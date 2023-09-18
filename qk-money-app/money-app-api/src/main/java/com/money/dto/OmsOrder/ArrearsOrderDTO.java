package com.money.dto.OmsOrder;

import lombok.Data;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

/**
 * @author : money
 * @version : 1.0.0
 * @description : 返回商品dto
 * @createTime : 2022-04-25 21:07:27
 */
@Data
public class ArrearsOrderDTO {


    /**
     * 清账金额
     */
    @NotNull
    private BigDecimal arrearsAccount;

    private String settleAccountRemark;
}
