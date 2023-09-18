package com.money.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.money.mb.base.BaseEntity;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * @Author: zhang shuai
 * @CreateTime：2023-09-15 14:45
 * @Description：
 */
@Getter
@Setter
@TableName("oms_expenditure")
@Schema(description = "支出表")
public class OmsExpenditure extends BaseEntity {

    @Schema(description="支出原因")
    private String reason;

    @Schema(description="支出金额")
    private String money;

    @Schema(description="备注")
    private String notes;

}
