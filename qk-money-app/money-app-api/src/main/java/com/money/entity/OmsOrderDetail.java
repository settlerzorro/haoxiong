package com.money.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.money.mb.base.BaseEntity;
import java.math.BigDecimal;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

/**
 * <p>
 * 订单明细表
 * </p>
 *
 * @author money
 * @since 2023-02-27
 */
@Getter
@Setter
@TableName("oms_order_detail")
@Schema(description = "订单明细表")
public class OmsOrderDetail extends BaseEntity {

    @Schema(description="订单号")
    private String orderNo;

    @Schema(description="状态")
    private String status;

    @Schema(description="商品id")
    private Long goodsId;

//    @Schema(description="商品条码")
//    private String goodsBarcode;

    @Schema(description="商品名称")
    private String goodsName;

    @Schema(description="实际单价")
    private BigDecimal goodsPrice;

    @Schema(description="数量")
    private Integer quantity;

    @Schema(description="售价")
    private BigDecimal salePrice;

    @Schema(description="进价")
    private BigDecimal purchasePrice;

//    @Schema(description="会员价")
//    private BigDecimal vipPrice;
//
//    @Schema(description="抵用券")
//    private BigDecimal coupon;

    @Schema(description="退货数量")
    private Integer returnQuantity;

//    @Schema(description="租户id")
//    private Long tenantId;

}
