<template>
  <div class="app-container">
    <el-row :gutter="10">
      <el-col :xs="0" :sm="6" :md="4">
        <GoodsCategoryTree @node-click="selectCategory" @node-update="loadCategories" />
      </el-col>
      <el-col :xs="24" :sm="18" :md="20">
        <!-- 搜索 -->
        <div v-if="crud.props.searchToggle" class="filter-container">
          <el-input v-model="query.name" placeholder="名称" class="filter-item-200" @keyup.enter.native="crud.toQuery" />
          <el-select v-model="query.brandId" clearable class="filter-item-200" placeholder="品牌" @change="crud.toQuery">
            <el-option v-for="item in brands.data" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
          <el-select v-model="query.status" clearable placeholder="状态" class="filter-item-200" @change="crud.toQuery">
            <el-option v-for="item in dict.goodsStatus" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
          <rr-operation />
        </div>
        <!-- CRUD操作 -->
        <crud-operation :permission="permission" :hidden-columns="['brand', 'pic', 'description', 'createTime', 'updateTime']" />
        <!-- 商品列表 -->
        <el-table ref="table" v-loading="crud.loading" :data="crud.data" style="width: 100%;" @selection-change="crud.selectionChangeHandler" @sort-change="crud.sortChangeHandler">
          <el-table-column align="center" type="selection" width="55" />
          <el-table-column align="center" :show-overflow-tooltip="true" prop="brand" label="品牌">
            <template slot-scope="scope">
              {{ brands.label[scope.row.brandId] }}
            </template>
          </el-table-column>
          <el-table-column align="center" :show-overflow-tooltip="true" prop="name" label="名称" />
          <el-table-column align="center" prop="status" label="状态" :formatter="formatStatus"/>
          <el-table-column align="center" :show-overflow-tooltip="true" prop="salePrice" label="售价" />
          <el-table-column align="center" :show-overflow-tooltip="true" prop="purchasePrice" label="进价" />
          <el-table-column align="center" :show-overflow-tooltip="true" prop="stock" label="库存" />
          <el-table-column align="center" :show-overflow-tooltip="true" sortable prop="sales" label="销量" />
          <el-table-column align="center" :show-overflow-tooltip="true" prop="unit" label="单位" />
          <el-table-column align="center" :show-overflow-tooltip="true" prop="size" label="散装规格" />
          <el-table-column align="center" :show-overflow-tooltip="true" prop="createTime" label="创建时间" />
          <el-table-column align="center" :show-overflow-tooltip="true" prop="updateTime" label="更新时间" />
          <el-table-column align="center" :show-overflow-tooltip="true" prop="description" label="描述" />
          <el-table-column label="操作" width="115" align="center" fixed="right">
            <template slot-scope="scope">
              <ud-operation :data="scope.row" :permission="permission" />
            </template>
          </el-table-column>
          <el-table-column align="center" :show-overflow-tooltip="true"  label="拆分" fixed="right">
            <template slot-scope="scope">
              <el-button size="mini" :disabled="scope.row.stock <= 0 || (scope.row.unit != '条' && scope.row.unit != '件')" @click="showConfirmDialog(scope.row.id)">拆分</el-button>
            </template>
          </el-table-column>
        </el-table>
        <!-- 分页 -->
        <pagination />
      </el-col>
    </el-row>
    <!--表单渲染-->
    <el-dialog append-to-body :close-on-click-modal="false" :before-close="crud.cancelCU" :visible.sync="crud.status.cu > 0" :title="crud.status.title" width="620px">
      <el-form ref="form" :inline="true" :model="form" :rules="rules" size="small" label-width="80px">
        <el-form-item label="名称" prop="name">
          <el-input v-model="form.name" style="width: 450px;" @keydown.native="keydown($event)" />
        </el-form-item>
        <el-form-item label="进价" prop="purchasePrice">
          <el-input v-model="form.purchasePrice" style="width: 178px;" @keydown.native="keydown($event)" />
        </el-form-item>
        <el-form-item label="售价" prop="salePrice">
          <el-input v-model="form.salePrice" style="width: 178px;" @keydown.native="keydown($event)" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="form.status" style="width: 178px;" placeholder="请选择">
            <el-option v-for="item in dict.goodsStatus" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="库存" prop="stock">
          <Compute-Input v-model="form.stock" style="width: 178px;" />
        </el-form-item>
        <el-form-item label="品牌" prop="brandId">
          <el-select v-model="form.brandId" style="width: 178px;" placeholder="请选择">
            <el-option v-for="item in brands.data" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="分类" prop="categoryId">
          <el-select v-model="form.categoryId" style="width: 178px;" placeholder="请选择">
            <el-option v-for="item in categories.data" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="单位" prop="unit">
          <el-select v-model="form.unit" style="width: 178px;" placeholder="请选择">
            <el-option key="个"  value="个" />
            <el-option key="瓶"  value="瓶" />
            <el-option key="件"  value="件" />
            <el-option key="包"  value="包" />
            <el-option key="条"  value="条" />
          </el-select>
        </el-form-item>
        <el-form-item label="散装规格" prop="size">
          <Compute-Input v-model="form.size" style="width: 178px;" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model.trim="form.description" style="width: 450px;" type="textarea" maxlength="250" show-word-limit />
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
import ComputeInput from '@/components/ComputeInput'
import rrOperation from '@/components/Crud/RR.operation.vue'
import udOperation from '@/components/Crud/UD.operation.vue'
import crudOperation from '@/components/Crud/CRUD.operation.vue'
import Pagination from '@/components/Crud/Pagination.vue'
import CRUD, { presenter, header, form, crud } from '@/components/Crud/crud'

import crudGoods from '@/api/gms/goods'
import { selectBrand } from '@/api/gms/brand'
import { selectCategory } from '@/api/gms/goodsCategory'
import GoodsCategoryTree from './goodsCategoryTree.vue'
import oss from '@/utils/oss'
import { validNonnegative } from '@/utils/validate'
import calculator from '@/utils/calculator'

export default {
  name: 'Goods',
  components: { Pagination, rrOperation, udOperation, crudOperation, ComputeInput, GoodsCategoryTree },
  cruds() {
    return CRUD({ title: '商品2', url: '/gms/goods', crudMethod: { ...crudGoods } })
  },
  mixins: [presenter(), header(), form({
    // 表单初始值
    id: null,
    status: 'SALE',
    brandId: 0,
    categoryId: 0,
    name: null,
    purchasePrice: null,
    salePrice: null,
    stock: 0,
    unit: null,
    size: null,
    description: null
  }), crud()],
  dicts: ['goodsStatus'],
  data() {
    return {
      // 操作权限定义
      permission: {
        add: ['gmsGoods:add'],
        edit: ['gmsGoods:edit'],
        del: ['gmsGoods:del'],
        split: ['gmsGoods:edit']
      },
      dialogVisible: false,
      brands: {
        label: { 0: '无' },
        data: [{ label: '无', value: 0 }]
      },
      categories: {
        label: { 0: '全部分类' },
        data: [{ label: '全部分类', value: 0 }]
      },
      // 表单验证规则
      rules: {
        name: [
          { required: true, message: '请输入名称', trigger: 'blur' }
        ],
        purchasePrice: [
          { required: true, message: '请输入进价', trigger: 'blur' },
          { trigger: 'blur', validator: validNonnegative }
        ],
        salePrice: [
          { required: true, message: '请输入售价', trigger: 'blur' },
          { trigger: 'blur', validator: validNonnegative }
        ],
        stock: [
          { required: true, message: '请输入库存', trigger: 'blur' },
          { trigger: 'blur', validator: validNonnegative }
        ],
        status: [
          { required: true, message: '请选择状态', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.loadBrands()
    this.loadCategories()
  },
  methods: {
    showConfirmDialog(data) {
      this.$confirm('此操作将拆分整体为 散件/散包', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        crudGoods
          .split({
            data
          })
          .then((res) => {
            this.crud.toQuery()
          })

        this.$message({
          type: 'success',
          message: '操作已执行'
        });
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '操作已取消'
        });
      });
    },
    handleClose() {
      this.loadCategories();
      this.dialogVisible = false;
    },
    // 获取品牌下拉框
    loadBrands() {
      selectBrand().then(res => {
        this.brands.data.push(...res.data)
        res.data.forEach(e => {
          this.brands.label[e.value] = e.label
        })
      })
    },
    // 获取分类下拉框
    loadCategories() {
      selectCategory().then(res => {
        this.categories.data.push(...res.data)
        res.data.forEach(e => {
          this.categories.label[e.value] = e.label
        })
      })
    },
    // 选中分类
    selectCategory(val) {
      this.query.categoryId = val
      this.crud.toQuery()
    },

    formatStatus(cellValue){
        for(var i = 0;i<this.dict.goodsStatus.length;i++){
          if(this.dict.goodsStatus[i].value == cellValue.status){
            return this.dict.goodsStatus[i].label;
          }
        }
    },
    // 禁止输入空格
    keydown(e) {
      if (e.keyCode === 32) {
        e.returnValue = false
      }
    }
  }
}
</script>
