package com.money.dto.OmsOrder;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
* <p>
* 订单表
* </p>
*
* @author money
* @since 2023-02-27
*/
@Data
@Schema(description = "订单表")
public class OmsOrderVO {

    private Long id;

    @Schema(description="订单号")
    private String orderNo;

    @Schema(description="状态")
    private String status;

    @Schema(description="联系方式")
    private String contact;

    @Schema(description="总成本")
    private BigDecimal costAmount;

    @Schema(description="总价")
    private BigDecimal totalAmount;

    @Schema(description="实付款")
    private BigDecimal payAmount;

    @Schema(description="最终销售金额")
    private BigDecimal finalSalesAmount;

    @Schema(description="备注")
    private String remark;

    @Schema(description="支付时间")
    private LocalDateTime paymentTime;

    @Schema(description="完成时间")
    private LocalDateTime completionTime;

    private LocalDateTime createTime;

}
