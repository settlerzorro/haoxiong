<template>
  <div class="app-container">
    <!-- 搜索 -->
    <div v-if="crud.props.searchToggle" class="filter-container">
      <el-date-picker v-model="datePicker" class="filter-item" type="datetimerange" :picker-options="pickerOptions" value-format="yyyy-MM-dd HH:mm:ss" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" align="right" style="margin-right:10px" />
      <el-input v-model="query.reason" placeholder="原因" class="filter-item-200" @keyup.enter.native="crud.toQuery" />
      <rr-operation />
    </div>
    <!-- CRUD操作 -->
    <crud-operation :permission="permission" />
    <!-- 订单列表 -->
    <el-table ref="table" v-loading="crud.loading"  show-summary :data="crud.data" style="width: 100%" @selection-change="crud.selectionChangeHandler" @sort-change="crud.sortChangeHandler">
      <el-table-column type="selection" width="55" />
      <el-table-column align="center" width="200" prop="reason" label="原因" />
      <el-table-column align="center" prop="money" label="支出金额" />
      <el-table-column align="center" width="180" prop="createTime" label="创建时间" />
      <el-table-column align="center" prop="notes" label="备注" />
<!--      <el-table-column label="操作" width="200" align="center" fixed="right">-->
<!--        <template slot-scope="{ row }">-->
<!--          <router-link :to="'/oms/order/detail/'+ row.id"><el-button size="mini">查看</el-button></router-link>-->
<!--        </template>-->
<!--      </el-table-column>-->
    </el-table>
    <!-- 分页 -->
    <pagination />


    <el-dialog append-to-body :close-on-click-modal="false" :before-close="crud.cancelCU" :visible.sync="crud.status.cu > 0" :title="crud.status.title" width="380px">
      <el-form ref="form" :inline="true" :model="form" :rules="rules" size="small" label-width="80px">
        <el-form-item label="原因" prop="reason">
          <el-input v-model="form.reason" style="width: 220px" @keydown.native="keydown($event)" />
        </el-form-item>
        <el-form-item label="支出金额" prop="money">
          <el-input v-model="form.money" style="width: 220px" @keydown.native="keydown($event)" />
        </el-form-item>
        <el-form-item label="描述" prop="notes">
          <el-input v-model.trim="form.notes" style="width: 220px" rows="6" type="textarea" maxlength="250" show-word-limit />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="text" @click="crud.cancelCU">取消</el-button>
        <el-button :loading="crud.status.cu === 2" type="primary" @click="crud.submitCU">确认</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import dayjs from 'dayjs'
import rrOperation from '@/components/Crud/RR.operation.vue'
import crudOperation from '@/components/Crud/CRUD.operation.vue'
import udOperation from '@/components/Crud/UD.operation.vue'
import Pagination from '@/components/Crud/Pagination.vue'
import CRUD, { presenter, header, form, crud } from '@/components/Crud/crud'
import calculator from '@/utils/calculator'
import crudExpenditure from '@/api/oms/expenditure'

export default {
  name: 'Expenditure',
  components: { Pagination, rrOperation, udOperation, crudOperation },
  cruds() {
    return CRUD({ title: '支出', url: '/oms/expenditure', crudMethod: { ...crudExpenditure } })
  },
  mixins: [presenter(), header(), form({}), crud()],
  dicts: ['orderStatus'],
  data() {
    return {
      // 操作权限定义
      permission: {
        add: ['omsExpenditure:add'],
        edit: ['omsExpenditure:edit'],
        del: ['omsExpenditure:del']
      },
      // 表单验证规则
      rules: {
        reason: [
          { required: true, message: '请输入支出原因', trigger: 'blur' }
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
    // 禁止输入空格
    keydown(e) {
      if (e.keyCode === 32) {
        e.returnValue = false
      }
    }
  }
}
</script>
