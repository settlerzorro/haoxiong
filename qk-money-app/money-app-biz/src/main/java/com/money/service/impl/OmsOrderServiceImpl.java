package com.money.service.impl;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.money.common.exception.BaseException;
import com.money.common.util.BeanMapUtil;
import com.money.common.vo.PageVO;
import com.money.constant.OrderStatusEnum;
import com.money.dto.OmsOrder.*;
import com.money.dto.OmsOrderDetail.OmsOrderDetailVO;
import com.money.dto.OmsOrderLog.OmsOrderLogVO;
import com.money.entity.OmsExpenditure;
import com.money.entity.OmsOrder;
import com.money.entity.OmsOrderDetail;
import com.money.entity.OmsOrderLog;
import com.money.mapper.OmsOrderMapper;
import com.money.service.*;
import com.money.util.PageUtil;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.atomic.AtomicReference;

/**
 * <p>
 * 订单表 服务实现类
 * </p>
 *
 * @author money
 * @since 2023-02-27
 */
@Service
@RequiredArgsConstructor
public class OmsOrderServiceImpl extends ServiceImpl<OmsOrderMapper, OmsOrder> implements OmsOrderService {

    private final GmsGoodsService gmsGoodsService;
    private final OmsOrderDetailService omsOrderDetailService;
    private final OmsOrderLogService omsOrderLogService;
    private final ExpenditureService expenditureService;

    @Override
    public PageVO<OmsOrderVO> list(OmsOrderQueryDTO queryDTO) {
        Page<OmsOrder> page = this.lambdaQuery().eq(StrUtil.isNotBlank(queryDTO.getStatus()), OmsOrder::getStatus, queryDTO.getStatus())
                .like(StrUtil.isNotBlank(queryDTO.getOrderNo()), OmsOrder::getOrderNo, queryDTO.getOrderNo())
                //.like(StrUtil.isNotBlank(queryDTO.getMember()), OmsOrder::getMember, queryDTO.getMember())
                .ge(queryDTO.getStartTime() != null, OmsOrder::getCreateTime, queryDTO.getStartTime())
                .le(queryDTO.getEndTime() != null, OmsOrder::getCreateTime, queryDTO.getEndTime())
                .orderByDesc(StrUtil.isBlank(queryDTO.getOrderBy()), OmsOrder::getCreateTime)
                .last(StrUtil.isNotBlank(queryDTO.getOrderBy()), queryDTO.getOrderBySql())
                .page(PageUtil.toPage(queryDTO));
        return PageUtil.toPageVO(page, OmsOrderVO::new);
    }

    @Override
    public OrderCountVO countOrderAndSales(LocalDateTime startTime, LocalDateTime endTime) {
        // 1.查询时间段内的所有订单详情
        List<OmsOrderDetail> omsOrderDetails = omsOrderDetailService.lambdaQuery()
                // 仅查询需要用到的字段
                .select(OmsOrderDetail::getOrderNo, OmsOrderDetail::getQuantity, OmsOrderDetail::getReturnQuantity,
                        OmsOrderDetail::getGoodsPrice, OmsOrderDetail::getPurchasePrice)
                // 只统计已支付的订单
                .eq(OmsOrderDetail::getStatus, OrderStatusEnum.PAID)
                .ge(startTime != null, OmsOrderDetail::getCreateTime, startTime)
                .le(endTime != null, OmsOrderDetail::getCreateTime, endTime)
                .list();
        // 2.通过去重订单详情的单号获取到订单数
        long count = omsOrderDetails.stream().map(OmsOrderDetail::getOrderNo).distinct().count();
        // 3.计算销售额和成本
        BigDecimal saleCount = BigDecimal.ZERO;
        BigDecimal costCount = BigDecimal.ZERO;
        for (OmsOrderDetail omsOrderDetail : omsOrderDetails) {
            // 商品数量需要减去退货的数量
            int quantity = omsOrderDetail.getQuantity() - omsOrderDetail.getReturnQuantity();
            saleCount = saleCount.add(omsOrderDetail.getGoodsPrice().multiply(new BigDecimal(quantity)));
            costCount = costCount.add(omsOrderDetail.getPurchasePrice().multiply(new BigDecimal(quantity)));
        }
        // 4.计算支出
        BigDecimal expenditureCount = BigDecimal.ZERO;
        List<OmsExpenditure> omsExpenditures = getOmsExpenditures(startTime,endTime);
        long expenditureTotal = omsExpenditures.stream().filter(x -> StringUtils.isNotEmpty(x.getMoney())).mapToLong(k -> Long.parseLong(k.getMoney())).sum();
        expenditureCount = new BigDecimal(expenditureTotal);
        // 4.返回 VO
        OrderCountVO vo = new OrderCountVO();
        vo.setOrderCount(count);
        vo.setSaleCount(saleCount);
        vo.setCostCount(costCount);
        vo.setExpenditureCount(expenditureCount);
        // 销售额 - 成本 = 利润
        vo.setProfit(saleCount.subtract(costCount));
        //计算包含支出的利润
        vo.setProfitWithExpenditure(saleCount.subtract(costCount).subtract(expenditureCount));
        return vo;
    }

    @Override
    public OrderDetailVO getOrderDetail(Long id) {
        OrderDetailVO vo = new OrderDetailVO();
        OmsOrder order = this.getById(id);
        if (order == null) {
            throw new BaseException("订单不存在");
        }
        // 订单信息
        vo.setOrder(BeanMapUtil.to(order, OmsOrderVO::new));
        // 会员信息
        //vo.setMember(BeanMapUtil.to(umsMemberService.getById(order.getMemberId()), UmsMemberVO::new));
        // 订单详情
        vo.setOrderDetail(BeanMapUtil.to(omsOrderDetailService.listByOrderNo(order.getOrderNo()), OmsOrderDetailVO::new));
        // 订单日志
        vo.setOrderLog(BeanMapUtil.to(omsOrderLogService.listByOrderId(id), OmsOrderLogVO::new));
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void returnOrder(Set<Long> ids) {
        ids.stream().map(this::getById).forEach(order -> {
            List<OmsOrderDetail> orderDetails = omsOrderDetailService.listByOrderNo(order.getOrderNo());
            AtomicReference<BigDecimal> returnPrice = new AtomicReference<>(BigDecimal.ZERO);
            AtomicReference<BigDecimal> returnCoupon = new AtomicReference<>(BigDecimal.ZERO);
            orderDetails.forEach(orderDetail -> {
                int returnQty = orderDetail.getQuantity() - orderDetail.getReturnQuantity();
                returnPrice.set(returnPrice.get().add(orderDetail.getGoodsPrice().multiply(new BigDecimal(returnQty))));
                //returnCoupon.set(returnCoupon.get().add(orderDetail.getCoupon().multiply(new BigDecimal(returnQty))));
                // 更新库存
                gmsGoodsService.updateStock(orderDetail.getGoodsId(), returnQty);
                orderDetail.setReturnQuantity(orderDetail.getQuantity());
                orderDetail.setStatus(OrderStatusEnum.RETURN.name());
            });
            // 退款和抵用券
           // umsMemberService.rebate(order.getMemberId(), returnPrice.get(), returnCoupon.get(), true);
            // 修改订单最终销售额
            order.setFinalSalesAmount(BigDecimal.ZERO);
            order.setStatus(OrderStatusEnum.RETURN.name());
            this.updateById(order);
            omsOrderDetailService.updateBatchById(orderDetails);
            // 订单日志
            OmsOrderLog log = new OmsOrderLog();
            log.setOrderId(order.getId());
            log.setDescription("<span style=\"color:red\">退单</span>");
            omsOrderLogService.save(log);
        });
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void returnGoods(ReturnGoodsDTO returnGoodsDTO) {
        // 修改明细
        Integer returnQty = returnGoodsDTO.getQuantity();
        OmsOrderDetail orderDetail = omsOrderDetailService.getById(returnGoodsDTO.getId());
        orderDetail.setReturnQuantity(orderDetail.getReturnQuantity() + returnQty);
        if (orderDetail.getReturnQuantity().compareTo(orderDetail.getQuantity()) == 0) {
            orderDetail.setStatus(OrderStatusEnum.RETURN.name());
        } else if (orderDetail.getReturnQuantity().compareTo(orderDetail.getQuantity()) > 0) {
            throw new BaseException("退货数量不能超过商品数量");
        }
        omsOrderDetailService.updateById(orderDetail);
        // 修改订单
        OmsOrder order = this.lambdaQuery().eq(OmsOrder::getOrderNo, orderDetail.getOrderNo()).one();
        BigDecimal returnPrice = orderDetail.getGoodsPrice().multiply(new BigDecimal(returnQty));
        BigDecimal finalSalesAmount = order.getFinalSalesAmount().subtract(returnPrice);
        order.setFinalSalesAmount(finalSalesAmount);
        this.updateById(order);
        // 退款和抵用券
        //BigDecimal returnCoupon = orderDetail.getCoupon().multiply(new BigDecimal(returnQty));
        //umsMemberService.rebate(order.getMemberId(), returnPrice, returnCoupon, false);
        // 更新库存
        gmsGoodsService.updateStock(orderDetail.getGoodsId(), returnQty);
        // 订单日志
        OmsOrderLog log = new OmsOrderLog();
        log.setOrderId(order.getId());
        log.setDescription("<span style=\"color:red\">退货</span>" + orderDetail.getGoodsName() + " X " + returnQty);
        omsOrderLogService.save(log);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void arrearsAccount(Long id,ArrearsOrderDTO arrearsOrderDTO) {
        // 修改订单
        OmsOrder order = this.lambdaQuery().eq(OmsOrder::getId,id).one();
        if(order.getArrearsAccount() != null){
            order.setArrearsAccount(order.getArrearsAccount().add(arrearsOrderDTO.getArrearsAccount()));
        }else{
            order.setArrearsAccount(arrearsOrderDTO.getArrearsAccount());
        }
        if(Objects.equals(order.getArrearsAccount(), order.getPayAmount())){
            order.setStatus(OrderStatusEnum.PAID.name());
        }
        this.updateById(order);
        // 订单日志
        OmsOrderLog log = new OmsOrderLog();
        log.setOrderId(order.getId());
        if(order.getStatus().equals(OrderStatusEnum.ARREARS.name())){
            log.setDescription("<span style=\"color:red\">还款：</span>" + arrearsOrderDTO.getArrearsAccount() + ".共还款：" + order.getArrearsAccount());
        }else{
            log.setDescription("<span style=\"color:red\">已清账.还款：</span>" + arrearsOrderDTO.getArrearsAccount() + ".共还款：" + order.getArrearsAccount());
        }

        omsOrderLogService.save(log);
    }

    private List<OmsExpenditure> getOmsExpenditures(LocalDateTime startTime, LocalDateTime endTime){
        return expenditureService.get(startTime,endTime);
    }

}
