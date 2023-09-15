package com.money.dto.OmsExpentiture;

import com.money.common.dto.QueryRequest;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

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
@EqualsAndHashCode(callSuper = true)
@Schema(description = "支出表过滤")
public class OmsExpenditureQueryDTO extends QueryRequest {


    @Schema(description="开始时间")
    private LocalDateTime startTime;

    @Schema(description="结束时间")
    private LocalDateTime endTime;

    @Schema(description="支出原因")
    private String reason;
}
