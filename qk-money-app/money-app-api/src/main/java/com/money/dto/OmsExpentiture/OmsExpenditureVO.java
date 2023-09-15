package com.money.dto.OmsExpentiture;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * @Author: zhang shuai
 * @CreateTime：2023-09-15 14:45
 * @Description：
 */
@Data
@Schema(description = "支出表")
public class OmsExpenditureVO {

    private Long id;

    private String reason;

    private BigDecimal money;

    private LocalDateTime expenditureTime;

    private String notes;

}
