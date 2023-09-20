package com.money.dto.OmsOrderDetail;

import com.money.common.dto.ValidGroup;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

/**
* <p>
* 订单明细表
* </p>
*
* @author money
* @since 2023-02-27
*/
@Data
@Schema(description = "订单欠账信息")
public class OmsOrderArrearsVO {

    @Schema(description="状态：结清/欠账")
    private String status;

    @Schema(description="已还账金额")
    private BigDecimal arrearsAccount;

    @Schema(description="备注")
    private String remark;

}
