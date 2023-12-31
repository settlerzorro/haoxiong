package com.money.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.money.mb.base.BaseEntity;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

/**
 * <p>
 * 订单表
 * </p>
 *
 * @author money
 * @since 2023-02-27
 */
@Getter
@Setter
@TableName("oms_order")
@Schema(description = "订单表")
public class OmsOrder extends BaseEntity {

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

    @Schema(description="已还账金额")
    private BigDecimal arrearsAccount;

    @Schema(description="最终销售金额")
    private BigDecimal finalSalesAmount;

    @Schema(description="备注")
    private String remark;

    @Schema(description="清账备注")
    private String settleAccountRemark;

    @Schema(description="支付时间")
    private LocalDateTime paymentTime;

    @Schema(description="完成时间")
    private LocalDateTime completionTime;

}
