<template>
  <div class="app-container">
    <!-- 搜索 -->
    <div v-if="crud.props.searchToggle" class="filter-container">
      <el-date-picker v-model="datePicker" class="filter-item" type="datetimerange" :picker-options="pickerOptions" value-format="yyyy-MM-dd HH:mm:ss" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" align="right" style="margin-right:10px" />
      <el-input v-model="query.reason" placeholder="原因" class="filter-item-200" @keyup.enter.native="crud.toQuery" />
      <rr-operation />
    </div>
    <!-- CRUD操作 -->
    <crud-operation :hidden-columns="['address', 'paymentTime', 'completionTime', 'remark']" />
    <!-- 订单列表 -->
    <el-table ref="table" v-loading="crud.loading"  show-summary :data="crud.data" style="width: 100%" @selection-change="crud.selectionChangeHandler" @sort-change="crud.sortChangeHandler">
      <el-table-column align="center" width="200" prop="reason" label="原因" />
      <el-table-column align="center" prop="money" label="支出金额" />
      <el-table-column align="center" width="180" prop="createTime" label="创建时间" />
      <el-table-column align="center" width="180" prop="expenditureTime" label="支出时间" />
      <el-table-column align="center" prop="notes" label="备注" />
      <el-table-column label="操作" width="200" align="center" fixed="right">
        <template slot-scope="{ row }">
          <router-link :to="'/oms/order/detail/'+ row.id"><el-button size="mini">查看</el-button></router-link>
        </template>
      </el-table-column>
    </el-table>
    <!-- 分页 -->
    <pagination />
  </div>
</template>

<script>
import dayjs from 'dayjs'
import orderApi from '@/api/oms/expenditure'
import rrOperation from '@/components/Crud/RR.operation.vue'
import crudOperation from '@/components/Crud/CRUD.operation.vue'
import Pagination from '@/components/Crud/Pagination.vue'
import CRUD, { presenter, header, form, crud } from '@/components/Crud/crud'
import calculator from '@/utils/calculator'

export default {
  name: 'Expenditure',
  components: { Pagination, rrOperation, crudOperation },
  cruds() {
    return CRUD({ title: '支出', url: '/oms/expenditure', optShow: { add: false, edit: false, del: false } })
  },
  mixins: [presenter(), header(), form({}), crud()],
  dicts: ['orderStatus'],
  data() {
    return {
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
    }
  }
}
</script>
