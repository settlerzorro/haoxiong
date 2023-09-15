package com.money.service.impl;

import cn.hutool.core.collection.ListUtil;
import cn.hutool.core.date.DatePattern;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.money.common.util.BeanMapUtil;
import com.money.common.vo.PageVO;
import com.money.constant.OrderStatusEnum;
import com.money.dto.GmsBrand.GmsBrandVO;
import com.money.dto.OmsExpentiture.OmsExpenditureQueryDTO;
import com.money.dto.OmsExpentiture.OmsExpenditureVO;
import com.money.dto.OmsOrder.OmsOrderVO;
import com.money.dto.OmsOrderDetail.OmsOrderDetailDTO;
import com.money.dto.pos.PosGoodsVO;
import com.money.dto.pos.SettleAccountsDTO;
import com.money.entity.*;
import com.money.mapper.GmsBrandMapper;
import com.money.mapper.OmsBExpenditureMapper;
import com.money.service.*;
import com.money.util.PageUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ExpenditureServiceImpl extends ServiceImpl<OmsBExpenditureMapper, OmsExpenditure> implements ExpenditureService{
    private final GmsGoodsService gmsGoodsService;
    private final OmsOrderService omsOrderService;
    private final OmsOrderDetailService omsOrderDetailService;
    private final OmsOrderLogService omsOrderLogService;
    private final GmsBrandService gmsBrandService;

    @Override
    public PageVO<OmsExpenditureVO> listExpenditure(OmsExpenditureQueryDTO queryDTO) {
        Page<OmsExpenditure> page = this.lambdaQuery()
                .like(StrUtil.isNotBlank(queryDTO.getReason()), OmsExpenditure::getReason, queryDTO.getReason())
                .ge(queryDTO.getStartTime() != null, OmsExpenditure::getExpenditureTime, queryDTO.getStartTime())
                .le(queryDTO.getEndTime() != null, OmsExpenditure::getExpenditureTime, queryDTO.getEndTime())
                .page(PageUtil.toPage(queryDTO));
        return PageUtil.toPageVO(page, OmsExpenditureVO::new);
    }
}
