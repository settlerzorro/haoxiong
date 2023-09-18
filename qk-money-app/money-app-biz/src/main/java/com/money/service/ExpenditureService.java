package com.money.service;

import com.money.common.vo.PageVO;
import com.money.dto.GmsBrand.GmsBrandDTO;
import com.money.dto.OmsExpentiture.OmsExpenditureQueryDTO;
import com.money.dto.OmsExpentiture.OmsExpenditureVO;
import com.money.dto.OmsOrder.OmsOrderQueryDTO;
import com.money.dto.OmsOrder.OmsOrderVO;
import com.money.dto.OmsOrder.OrderCountVO;
import com.money.dto.pos.PosGoodsVO;
import com.money.dto.pos.SettleAccountsDTO;
import org.springframework.web.multipart.MultipartFile;

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

    void add(OmsExpenditureVO addDTO);

    void update(OmsExpenditureVO updateDTO);

    void delete(Set<Long> ids);

}
