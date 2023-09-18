package com.money.controller;

import com.money.common.dto.ValidGroup;
import com.money.common.vo.PageVO;
import com.money.dto.GmsBrand.GmsBrandDTO;
import com.money.dto.OmsExpentiture.OmsExpenditureQueryDTO;
import com.money.dto.OmsExpentiture.OmsExpenditureVO;
import com.money.dto.OmsOrder.OmsOrderQueryDTO;
import com.money.dto.OmsOrder.OmsOrderVO;
import com.money.dto.OmsOrder.OrderCountVO;
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
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

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

    @PostMapping
    @PreAuthorize("@rbac.hasPermission('omsExpenditure:add')")
    public void add(@Validated(ValidGroup.Save.class) @RequestBody OmsExpenditureVO omsExpenditureVO) {
        expenditureService.add(omsExpenditureVO);
    }

    @PutMapping
    @PreAuthorize("@rbac.hasPermission('omsExpenditure:edit')")
    public void update(@Validated(ValidGroup.Update.class) @RequestBody OmsExpenditureVO omsExpenditureVO) {
        expenditureService.update(omsExpenditureVO);
    }

    @DeleteMapping
    @PreAuthorize("@rbac.hasPermission('omsExpenditure:del')")
    public void delete(@RequestBody Set<Long> ids) {
        expenditureService.delete(ids);
    }


}
