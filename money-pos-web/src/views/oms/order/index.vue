<template>
  <div class="app-container">
    <!-- 搜索 -->
    <div v-if="crud.props.searchToggle" class="filter-container">
      <el-date-picker v-model="datePicker" class="filter-item" type="datetimerange" :picker-options="pickerOptions" value-format="yyyy-MM-dd HH:mm:ss" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" align="right" style="margin-right:10px" />
      <el-input v-model="query.orderNo" placeholder="订单号" class="filter-item-200" @keyup.enter.native="crud.toQuery" />
      <el-select v-model="query.status" clearable placeholder="状态" class="filter-item-200" @change="crud.toQuery">
        <el-option v-for="item in dict.orderStatus" :key="item.value" :label="item.label" :value="item.value" />
      </el-select>
      <rr-operation />
    </div>
    <!-- CRUD操作 -->
    <crud-operation :hidden-columns="['settleAccountRemark','paymentTime', 'completionTime']" />
    <!-- 订单列表 -->
    <el-table ref="table" v-loading="crud.loading" :summary-method="getSummaries" show-summary :data="crud.data" style="width: 100%" @selection-change="crud.selectionChangeHandler" @sort-change="crud.sortChangeHandler">
      <el-table-column align="center" width="200" prop="orderNo" label="订单号" />
      <el-table-column align="center" prop="costAmount" label="成本" />
      <el-table-column align="center" prop="totalAmount" label="总价" />
      <el-table-column align="center" prop="payAmount" label="实付款" />
      <el-table-column align="center" label="利润" prop="profit">
        <template slot-scope="{ row }">
          <span>{{ calculator.Sub(row.payAmount, row.costAmount) }}</span>
        </template>
      </el-table-column>
      <el-table-column align="center" prop="status" label="状态" :formatter="formatStatus">
      </el-table-column>
      <el-table-column align="center" width="180" prop="createTime" label="创建时间" />
      <el-table-column align="center" width="180" prop="paymentTime" label="支付时间" />
      <el-table-column align="center" width="180" prop="completionTime" label="完成时间" />
      <el-table-column align="center" prop="remark" label="备注" />
      <el-table-column align="center" prop="arrearsAccount" label="还账" />
      <el-table-column align="center" prop="settleAccountRemark" label="清账备注" />
      <el-table-column label="操作" width="200" align="center" fixed="right">
        <template slot-scope="{ row }">
          <router-link :to="'/oms/order/detail/'+ row.id"><el-button size="mini">查看</el-button></router-link>
          <el-button v-if="row.status != 'RETURN'" size="mini" type="danger" @click="handleReturn(row, $index)">退单</el-button>
          <el-button v-if="row.status == 'ARREARS'" size="mini" type="warning" @click="showDialog(row.id)">清账</el-button>
        </template>
      </el-table-column>
    </el-table>
    <!-- 分页 -->
    <pagination />

    <el-dialog append-to-body :close-on-click-modal="false" :visible.sync="dialogA" title="清账" width="380px">
      <el-form ref="form" :inline="true" :model="form" :rules="rules" size="small" label-width="80px">
        <el-form-item label="清账金额" prop="arrearsAccount">
          <el-input v-model="form.arrearsAccount" style="width: 220px"/>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model.trim="form.settleAccountRemark" style="width: 220px" rows="6" type="textarea" maxlength="250" show-word-limit />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="text" @click="dialogA = false">取消</el-button>
        <el-button :loading="crud.status.cu === 2" type="primary" @click="arrearsPartDialog(form)">确认</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import dayjs from 'dayjs'
import orderApi from '@/api/oms/order'
import rrOperation from '@/components/Crud/RR.operation.vue'
import crudOperation from '@/components/Crud/CRUD.operation.vue'
import Pagination from '@/components/Crud/Pagination.vue'
import CRUD, { presenter, header, form, crud } from '@/components/Crud/crud'
import calculator from '@/utils/calculator'

export default {
  name: 'Order',
  components: { Pagination, rrOperation, crudOperation },
  cruds() {
    return CRUD({ title: '订单', url: '/oms/order', optShow: { add: false, edit: false, del: false } })
  },
  mixins: [presenter(), header(), form({}), crud()],
  dicts: ['orderStatus'],
  data() {
    return {
      selectedRowId: null,
      dialogA: false,
      // 表单验证规则
      rules: {
        arrearsAccount: [
          { required: true, message: '请输入清金额', trigger: 'blur' }
        ]
      },
      countInfo: null,
      calculator: calculator,
      datePicker: [dayjs().startOf('M').format('YYYY-MM-DD HH:mm:ss'), dayjs().endOf('M').format('YYYY-MM-DD HH:mm:ss')],
      pickerOptions: {
        shortcuts: [
          {
            text: '今天',
            onClick(picker) {
              picker.$emit('pick', [dayjs().startOf('d').toDate(), dayjs().endOf('d').toDate()])
            }
          },
          {
            text: '本月',
            onClick(picker) {
              picker.$emit('pick', [dayjs().startOf('M').toDate(), dayjs().endOf('M').toDate()])
            }
          },
          {
            text: '最近7天',
            onClick(picker) {
              picker.$emit('pick', [dayjs().subtract(6, 'd').startOf('d').toDate(), dayjs().endOf('d').toDate()])
            }
          },
          {
            text: '最近30天',
            onClick(picker) {
              picker.$emit('pick', [dayjs().subtract(29, 'd').startOf('d').toDate(), dayjs().endOf('d').toDate()])
            }
          }
        ]
      }
    }
  },
  methods: {
    showDialog(rowId){
      this.selectedRowId = rowId;
      this.dialogA = true;
    },
    arrearsPartDialog(row){
      orderApi.arrearsPart(row,this.selectedRowId).then(() => {
        this.crud.toQuery();
        this.$message({
          type: 'success',
          message: '操作已执行'
        });
        this.dialogA = false;
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '操作已取消'
        });
        this.dialogA = false;
      });
      this.selectedRowId = null;
    },
    formatStatus(cellValue){
        if (cellValue.status == 'PAID'){
            return '已支付';
        }else if (cellValue.status == 'RETURN'){
            return '退单';
        }else if (cellValue.status == 'ARREARS'){
            return '欠账';
        }else{
          return '未知';
        };
    },
    // 查询前操作
    [CRUD.HOOK.beforeRefresh]() {
      this.query.startTime = this.datePicker[0]
      this.query.endTime = this.datePicker[1]
    },
    // 查询后
    [CRUD.HOOK.afterRefresh]() {
      orderApi
        .count({
          startTime: this.query.startTime,
          endTime: this.query.endTime
        })
        .then((res) => {
          this.countInfo = res.data
        })
    },
    // 退货
    handleReturn(row) {
      this.$confirm('确认退单?', '提示', {
        cancelButtonText: '取消',
        confirmButtonText: '确定',
        type: 'warning'
      }).then(() => {
        orderApi.returnOrder([row.id]).then((response) => {
          this.$notify({
            title: 'Success',
            message: '退单成功',
            type: 'success',
            duration: 2000
          })
          this.crud.toQuery()
        })
      })
    },
    // 合计行
    getSummaries(param) {
      const { columns } = param
      const sums = []
      if (this.countInfo) {
        columns.forEach((column, index) => {
          if (index === 0) {
            sums[index] = '总计'
            return
          }
          if (column.property === 'costAmount') {
            sums[index] = this.countInfo.costCount
          }
          if (column.property === 'payAmount') {
            sums[index] = this.countInfo.saleCount
          }
          if (column.property === 'profit') {
            sums[index] = this.countInfo.profit
          }
        })
      }
      return sums
    },
    // 状态颜色
    statusTag(status) {
      if (status === 'RETURN') {
        return 'info'
      } else if (['PAID', 'DONE'].includes(status)) {
        return 'success'
      }
    }
  }
}
</script>
