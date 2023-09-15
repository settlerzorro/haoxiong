package com.money.controller;

import com.money.common.vo.PageVO;
import com.money.dto.OmsExpentiture.OmsExpenditureQueryDTO;
import com.money.dto.OmsExpentiture.OmsExpenditureVO;
import com.money.dto.OmsOrder.OmsOrderQueryDTO;
import com.money.dto.OmsOrder.OmsOrderVO;
import com.money.dto.pos.PosGoodsVO;
import com.money.dto.pos.SettleAccountsDTO;
import com.money.service.ExpenditureService;
import com.money.service.PosService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "expenditure", description = "支出")
@RestController
@RequestMapping("/oms/expenditure")
@RequiredArgsConstructor
public class ExpenditureController {

    private final ExpenditureService expenditureService;

    @Operation(summary = "分页查询")
    @GetMapping
    @PreAuthorize("@rbac.hasPermission('omsExpenditure:list')")
    public PageVO<OmsExpenditureVO> list(@Validated OmsExpenditureQueryDTO queryDTO) {
        return expenditureService.listExpenditure(queryDTO);
    }

}
