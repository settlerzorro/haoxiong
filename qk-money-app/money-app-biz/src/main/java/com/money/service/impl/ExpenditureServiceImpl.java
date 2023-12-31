package com.money.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.money.common.vo.PageVO;
import com.money.dto.OmsExpentiture.OmsExpenditureQueryDTO;
import com.money.dto.OmsExpentiture.OmsExpenditureVO;
import com.money.entity.*;
import com.money.mapper.OmsBExpenditureMapper;
import com.money.service.*;
import com.money.util.PageUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class ExpenditureServiceImpl extends ServiceImpl<OmsBExpenditureMapper, OmsExpenditure> implements ExpenditureService{

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
    public List<OmsExpenditure> get(LocalDateTime startTime, LocalDateTime endTime) {
        List<OmsExpenditure> list = this.lambdaQuery().ge(startTime != null, OmsExpenditure::getCreateTime, startTime)
                .le(endTime != null, OmsExpenditure::getCreateTime, endTime).list();
        return list;
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
