package com.money.service.impl;

import cn.hutool.core.collection.ListUtil;
import cn.hutool.core.date.DatePattern;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.core.util.StrUtil;
import com.money.common.util.BeanMapUtil;
import com.money.constant.OrderStatusEnum;
import com.money.dto.OmsOrder.OmsOrderVO;
import com.money.dto.OmsOrderDetail.OmsOrderArrearsVO;
import com.money.dto.OmsOrderDetail.OmsOrderDetailDTO;
import com.money.dto.pos.PosGoodsVO;
import com.money.dto.pos.SettleAccountsDTO;
import com.money.entity.*;
import com.money.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PosServiceImpl implements PosService {
//    private final UmsMemberService umsMemberService;
    private final GmsGoodsService gmsGoodsService;
    private final OmsOrderService omsOrderService;
    private final OmsOrderDetailService omsOrderDetailService;
    private final OmsOrderLogService omsOrderLogService;
    private final GmsBrandService gmsBrandService;

    @Override
    public List<PosGoodsVO> listGoods(String name) {
        List<GmsGoods> gmsGoodsList = gmsGoodsService.lambdaQuery().like(StrUtil.isNotBlank(name), GmsGoods::getName, name).gt(GmsGoods::getStock,0).list();
        List<PosGoodsVO> pgo = BeanMapUtil.to(gmsGoodsList, PosGoodsVO::new);
        for(PosGoodsVO goods : pgo){
            GmsBrand brand = gmsBrandService.getById(goods.getBrandId());
            if(brand != null){
                goods.setBrandName(brand.getName());
            }
        }
        return pgo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public OmsOrderVO settleAccounts(SettleAccountsDTO settleAccountsDTO) {
        String orderNo = getOrderNo();
        OmsOrder order = new OmsOrder();
        order.setOrderNo(orderNo);
        // 核算订单
        List<OmsOrderDetailDTO> orderDetailDTOS = settleAccountsDTO.getOrderDetail();
        OmsOrderArrearsVO arrearsVO = settleAccountsDTO.getArrearsVo();
        List<OmsOrderDetail> orderDetails = orderDetailDTOS.stream().map(dto -> {
            GmsGoods goods = gmsGoodsService.getById(dto.getGoodsId());
            OmsOrderDetail detail = new OmsOrderDetail();
            detail.setOrderNo(orderNo);
            detail.setStatus(OrderStatusEnum.PAID.name());
            detail.setGoodsId(goods.getId());
            detail.setGoodsName(goods.getName());
            detail.setSalePrice(goods.getSalePrice());
            detail.setPurchasePrice(goods.getPurchasePrice());
            detail.setGoodsPrice(dto.getGoodsPrice());
            detail.setQuantity(dto.getQuantity());
            return detail;
        }).collect(Collectors.toList());
        this.aggOrder(order, orderDetails);
        //欠账
        if(arrearsVO.getStatus().equals(OrderStatusEnum.ARREARS.name())){
            order.setArrearsAccount(arrearsVO.getArrearsAccount());
            order.setRemark(arrearsVO.getRemark());
            order.setStatus(OrderStatusEnum.ARREARS.name());
        }else{
            order.setStatus(OrderStatusEnum.PAID.name());
        }
        order.setPaymentTime(LocalDateTime.now());
        // 保存订单
        omsOrderService.save(order);
        omsOrderDetailService.saveBatch(orderDetails);
        // 扣库存
        orderDetails.forEach(omsOrderDetail -> gmsGoodsService.sell(omsOrderDetail.getGoodsId(), omsOrderDetail.getQuantity()));
        // 订单日志
        OmsOrderLog log = new OmsOrderLog();
        log.setOrderId(order.getId());
        if(order.getStatus().equals(OrderStatusEnum.ARREARS.name())){
            log.setDescription("完成订单,订单状态：" + "欠账." + "还款金额 " + order.getArrearsAccount());
        }else{
            log.setDescription("完成订单,订单状态：" + "结清.");
        }

        omsOrderLogService.saveBatch(ListUtil.of(log));
        return BeanMapUtil.to(order, OmsOrderVO::new);
    }

    /**
     * 核算订单
     *
     * @param order        订单
     * @param orderDetails 订单细节
     */
    private void aggOrder(OmsOrder order, List<OmsOrderDetail> orderDetails) {
        // 成本
        BigDecimal costAmount = BigDecimal.ZERO;
        // 总价
        BigDecimal totalAmount = BigDecimal.ZERO;
        // 实付款
        BigDecimal payAmount = BigDecimal.ZERO;
        // 用券
        BigDecimal couponAmount = BigDecimal.ZERO;
        for (OmsOrderDetail orderDetail : orderDetails) {
            BigDecimal quantity = new BigDecimal(orderDetail.getQuantity());
            BigDecimal purchasePrice = orderDetail.getPurchasePrice().multiply(quantity);
            BigDecimal salePrice = orderDetail.getSalePrice().multiply(quantity);
            //BigDecimal coupon = orderDetail.getCoupon().multiply(quantity);
            BigDecimal goodsPrice = orderDetail.getGoodsPrice().multiply(quantity);
            costAmount = costAmount.add(purchasePrice);
            totalAmount = totalAmount.add(salePrice);
            payAmount = payAmount.add(goodsPrice);
            //couponAmount = couponAmount.add(coupon);
        }
        order.setCostAmount(costAmount);
        order.setTotalAmount(totalAmount);
        order.setPayAmount(payAmount);
        //order.setCouponAmount(couponAmount);
        order.setFinalSalesAmount(payAmount);
    }

    /**
     * 得到订单
     *
     * @return {@link String}
     */
    private synchronized String getOrderNo() {
        // 15位
        String date = LocalDateTime.now().format(DatePattern.PURE_DATETIME_FORMATTER);
        // 1位
        String random = RandomUtil.randomNumbers(1);
        return date + random;
    }

}
