package com.money.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.collection.ListUtil;
import cn.hutool.core.date.DatePattern;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.money.common.exception.BaseException;
import com.money.common.util.BeanMapUtil;
import com.money.common.vo.PageVO;
import com.money.constant.OrderStatusEnum;
import com.money.dto.GmsBrand.GmsBrandDTO;
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
import com.money.oss.core.FileNameStrategy;
import com.money.oss.core.FolderPath;
import com.money.service.*;
import com.money.util.PageUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
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
                .ge(queryDTO.getStartTime() != null, OmsExpenditure::getCreateTime, queryDTO.getStartTime())
                .le(queryDTO.getEndTime() != null, OmsExpenditure::getCreateTime, queryDTO.getEndTime())
                .page(PageUtil.toPage(queryDTO));
        return PageUtil.toPageVO(page, OmsExpenditureVO::new);
    }

    @Override
    public void add(OmsExpenditureVO addDTO) {
        OmsExpenditure omsExpenditure = new OmsExpenditure();
        BeanUtil.copyProperties(addDTO, omsExpenditure);
        this.save(omsExpenditure);
    }

    @Override
    public void update(OmsExpenditureVO updateDTO) {
        OmsExpenditure omsExpenditure = this.getById(updateDTO.getId());
        BeanUtil.copyProperties(updateDTO, omsExpenditure);
        this.updateById(omsExpenditure);
    }

    @Override
    public void delete(Set<Long> ids) {
        List<OmsExpenditure> omsExpenditureList = this.listByIds(ids);
        this.removeByIds(ids);
    }
}
