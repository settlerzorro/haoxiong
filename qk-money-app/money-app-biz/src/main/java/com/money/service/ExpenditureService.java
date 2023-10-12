package com.money.service;

import com.money.common.vo.PageVO;
import com.money.dto.OmsExpentiture.OmsExpenditureQueryDTO;
import com.money.dto.OmsExpentiture.OmsExpenditureVO;
import com.money.dto.pos.PosGoodsVO;
import com.money.entity.OmsExpenditure;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

/**
 * @author : money
 * @version : 1.0.0
 * @description : pos服务
 * @createTime : 2022-04-14 22:08:07
 */
public interface ExpenditureService {

    /**
     * 支出列表
     *
     * @param queryDTO 支出过滤
     * @return {@link List}<{@link PosGoodsVO}>
     */
    PageVO<OmsExpenditureVO> listExpenditure(OmsExpenditureQueryDTO queryDTO);

    List<OmsExpenditure> get(LocalDateTime startTime, LocalDateTime endTime);

    void add(OmsExpenditureVO addDTO);

    void update(OmsExpenditureVO updateDTO);

    void delete(Set<Long> ids);

}
