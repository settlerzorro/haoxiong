<template>
  <div class="app-container">
    <el-row :gutter="10">
      <!-- 工具栏 -->
      <el-col :sm="4" :md="3" :lg="2" style="float: right; margin-bottom: 10px;">
        <el-card class="tool-card" shadow="always">
          <div class="tool-list">
            <el-button plain @click="reload">刷新</el-button>
            <el-button plain :type="tool.editPrice ? 'success' : ''" @click="editPrice">修改价格</el-button>
            <el-button plain @click="clearOrderList">清空商品</el-button>
            <el-button type="success" @click="showOrder">收款</el-button>
            <el-button v-if="isMobile" plain :type="tool.simple ? 'success' : ''" @click="tool.simple = !tool.simple">精简</el-button>
          </div>
        </el-card>
      </el-col>
      <!-- 收银台 -->
      <el-col class="cashier" :sm="20" :md="21" :lg="22">
        <!-- 输入 -->
        <div class="cashier-input">
          <el-card shadow="always">
            <el-row :gutter="40" type="flex" class="row-bg" justify="space-between" align="middle">
              <el-col :xs="24" :sm="17" :md="19" :lg="20">
                <el-row type="flex" class="row-bg">
                  <el-autocomplete v-model="name" class="cashier-input-item" popper-class="cashier-input-item" :fetch-suggestions="queryGoods" placeholder="名称" @select="item => name = item.name" @keydown.enter.native="enterName" >
                    <template slot-scope="{ item }">
                      <span class="label">{{ item.name }}</span>
                      <span class="desc">{{ item.brandName }} {{ item.name }} -库存- {{ item.stock }} {{ item.unit }}</span>
                    </template>
                  </el-autocomplete>
                </el-row>
              </el-col>
              <el-col :xs="0" :sm="7" :md="5" :lg="4">
                <el-button type="success" style="width:100%;height:100%" @click="showOrder">
                  <h1>收款</h1>
                </el-button>
              </el-col>
            </el-row>
          </el-card>
        </div>
        <!-- 商品列表 -->
        <div class="cashier-goods">
          <el-card shadow="always">
            <el-row type="flex" justify="between">
              <el-col>
                <h4>共 {{ total }} 件</h4>
              </el-col>
            </el-row>
            <el-table ref="table" border :data="orderList" style="width: 100%;" fit row-key="goodsName">
              <el-table-column key="2" :fixed="tool.simple" prop="goodsName" min-width="120" align="center" label="商品" />
              <el-table-column v-if="!tool.simple" key="1" prop="unit" min-width="120" align="center" label="单位" />
              <el-table-column key="3" prop="quantity" align="center" label="数量">
                <template slot-scope="scope">
                  <el-input-number v-if="!tool.simple" v-model="scope.row.quantity" size="small" :min="0" @change="changeQuantity(scope.row)" />
                  <el-input v-else v-model="scope.row.quantity" @change="changeQuantity(scope.row)" />
                </template>
              </el-table-column>
              <el-table-column v-if="!tool.simple" key="4" prop="salePrice" align="center" label="原价" />
              <el-table-column key="7" :min-width="tool.editPrice ? 120 : 0" prop="goodsPrice" align="center" label="应收">
                <template slot-scope="scope">
                  <template v-if="tool.editPrice">
                    <el-input v-model="scope.row.goodsPrice" placeholder="请输入内容" class="input-with-select">
                      <el-button slot="append" icon="el-icon-refresh" @click="cancelEdit(scope.row)" />
                    </el-input>
                  </template>
                  <span v-else style="font-size: 16px">{{ scope.row.goodsPrice }}</span>
                </template>
              </el-table-column>
            </el-table>
          </el-card>
        </div>
      </el-col>
    </el-row>

    <!-- 清单 -->
    <el-dialog v-loading.fullscreen.lock="fullscreenLoading" class="orderDialog" title="清单" :visible.sync="showOrderDialog">
      <el-row :gutter="10" style="text-align: center">
        <el-col :span="6">
          <h4>商品名称</h4>
        </el-col>
        <el-col :span="6">
          <h4>原价</h4>
        </el-col>
        <el-col :span="6">
          <h4>现价</h4>
        </el-col>
        <el-col :span="6">
          <h4>优惠</h4>
        </el-col>
      </el-row>
      <div v-for="item in orderList" :key="item.name">
        <el-row style="text-align: center;margin-bottom: 10px;">
          <el-col :span="6"><span>{{ item.goodsName }}</span></el-col>
          <el-col :span="6"><span>{{ item.salePrice }}</span></el-col>
          <el-col :span="6"><span>{{ item.goodsPrice }}</span></el-col>
        </el-row>
        <el-row type="flex" style="text-align: center;margin-bottom: 20px;">
          <el-col><span style="color: #909399">数量 X {{ item.quantity }}</span></el-col>
          <el-col><span style="color: #909399">小计{{ calculator.Mul(item.goodsPrice, item.quantity) }}元</span></el-col>
          </el-col>
        </el-row>
      </div>
      <el-row style="text-align: center;margin-bottom: 10px;font-size: 15px">
        <el-col :span="12">总计：{{ totalAmount }}</el-col>
        <el-col :span="12">优惠：{{ calculator.Sub(totalAmount, payAmount) }}</el-col>
        <el-col :span="12">应付：{{ payAmount }}</el-col>
      </el-row>
      <div slot="footer" class="dialog-footer">
        <el-button @click="showOrderDialog = false"> 取消 </el-button>
        <el-button type="primary" @click="arrearsPartDialog()"> 提交 </el-button>
      </div>
    </el-dialog>

    <div style="display:none">
      <print-order ref="child" :is-pos="true" />
    </div>
    <!--是否欠账弹窗-->
    <el-dialog append-to-body :close-on-click-modal="false" :visible.sync="dialogA" title="是否欠账" width="380px">
      <el-form ref="form" :inline="true" :model="form" size="small" label-width="80px">
        <el-radio-group v-model="form.status" @change="handleRadioChange">
          <el-radio v-model="form.radio" label="ARREARS">欠账</el-radio>
          <el-radio v-model="form.radio" label="PAID">结清</el-radio>
        </el-radio-group>

        <el-form-item label="已付金额" prop="arrearsAccount">
          <el-input v-model="form.arrearsAccount" style="width: 220px" :disabled="disableInputs"/>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input  v-model="form.remark" style="width: 220px" rows="6" :disabled="disableInputs" type="textarea" maxlength="250" show-word-limit />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="text" @click="dialogA = false">取消</el-button>
        <el-button @click="settleAccounts(form)">确认</el-button>
      </div>
    </el-dialog>

  </div>
</template>

<script>
import { isMobile } from '@/utils/index'
import posApi from '@/api/pos/pos'
import calculator from '@/utils/calculator'
import printOrder from '../oms/order/printOrder.vue'

export default {
  components: { printOrder },
  data() {
    return {
      form:{arrearsAccount:0,status:'PAID'},
      disableInputs: true,
      dialogA: false,
      isMobile: isMobile(),
      calculator: calculator,

      goodsList: [],
      memberList: [],

      name: null,
      member: null,
      orderList: [],

      currentMember: null,
      tool: {
        simple: false,
        editPrice: false
      },
      showOrderDialog: false,
      fullscreenLoading: false
    }
  },
  computed: {
    total: function () {
      return this.orderList.reduce((prev, next) => (prev.quantity | 0) + (next.quantity | 0), 0)
    },
    totalAmount: function () {
      let val = 0.0
      this.orderList.forEach((data) => {
        val += calculator.Mul(data.quantity, data.salePrice)
      })
      return val
    },
    payAmount: function () {
      let val = 0.0
      this.orderList.forEach((data) => {
        val += calculator.Mul(data.quantity, data.goodsPrice)
      })
      return val
    },
  },
  created() {
    this.tool.simple = this.isMobile
    // 初始化
    this.loadInit()
  },
  methods: {
    // 初始 or 刷新
    loadInit() {
      posApi.listGoods(this.name).then((res) => {
        this.goodsList = res.data
      })
    },
    //点击欠款和结清单选框切换
    handleRadioChange() {
      if (this.form.status === 'PAID') {
        this.form.arrearsAccount  = 0;
        this.form.remark  = '';
        this.disableInputs = true;
      } else {
        this.disableInputs = false;
      }
    },

    // 查询商品
    queryGoods(name, cb) {
      let result = this.goodsList
      if (name) {
        result = this.goodsList.filter((e) => e.name.includes(name) || e.name.includes(name))
      }
      cb(result.length > 10 ? [] : result)
    },
    // 回车商品
    enterName() {
      if (!this.name?.length > 0) return
      const goods = this.goodsList.find((e) => e.name === this.name)
      if (goods) {
        let orderDetail = this.orderList.find((e) => e.goodsId === goods.id)
        if (!orderDetail) {
          orderDetail = {
            goodsId: goods.id,
            goodsName: goods.name,
            quantity: 1,
            salePrice: goods.salePrice,
            goodsPrice: goods.salePrice,
            unit: goods.unit
          }
          this.orderList.push(orderDetail)
        } else {
          orderDetail.quantity += 1
        }
        this.name = ''
      } else {
        this.$notify({
          title: 'Warning',
          message: '未找到该商品',
          type: 'warning',
          duration: 2000
        })
      }
    },
    // 修改数量
    changeQuantity(goods) {
      if (goods.quantity == 0) {
        this.orderList = this.orderList.filter((e) => e.goodsId !== goods.goodsId)
      }
    },
    // 显示订单
    showOrder() {
      if (this.showOrderDialog === true) {
        if (this.fullscreenLoading === false) {
          this.settleAccounts()
        }
      } else {
        if (this.orderList.length === 0) {
          this.$notify({
            title: 'Warning',
            message: '没有商品',
            type: 'warning',
            duration: 2000
          })
        } else {
          this.showOrderDialog = true
        }
      }
    },
    //提交订单
    settleAccounts(form) {
      const data = {
        member: this.currentMember?.id,
        orderDetail: this.orderList,
        arrearsVo: form
      }
      posApi
        .settleAccounts(data)
        .then((res) => {
          this.$notify({
            title: 'Success',
            message: '订单结算成功',
            type: 'success',
            duration: 2000
          })
          this.dialogA = false;
          this.showOrderDialog = false
          const printOrderInfo = {
            info: res.data,
            detail: this.orderList.flatMap((o) => {
              return [Object.assign({ key: Math.random() }, o), Object.assign({ key: Math.random() }, o)]
            }),
            member: Object.assign({}, this.currentMember)
          }
          this.settleAccountsOk()
          this.fullscreenLoading = false
          // 移动端不打印
          if (!this.isMobile) {
            this.$refs.child.print(printOrderInfo)
          }
        })
        .catch(() => {
          this.fullscreenLoading = false
        })
    },
    // 展示欠款弹窗
    arrearsPartDialog() {
      this.dialogA = true;
    },
    // 结算成功，清理打印
    settleAccountsOk() {
      this.name = null
      this.member = null
      this.currentMember = null
      this.tool.editPrice = false
      this.clearOrderList()
      this.loadInit()
    },
    // ============================ 工具 ===============================
    // 刷新
    reload() {
      this.loadInit()
    },
    // 清空商品
    clearOrderList() {
      this.orderList = []
    },
    // 修改价格
    editPrice() {
      this.tool.editPrice = !this.tool.editPrice
      this.orderList.forEach((e) => {
        e.oldGoodsPrice = e.goodsPrice
      })
    },
    // 取消修改
    cancelEdit(goods) {
      goods.goodsPrice = goods.oldGoodsPrice
    }
  }
}
</script>

<style lang="scss">
.cashier {
  display: flex;
  flex-direction: column;
}

.orderDialog {
  .el-dialog {
    width: 100%;
    max-width: 450px;
  }
}

// 输入部分
.cashier-input {
  margin-bottom: 10px;
}

.cashier-input-item {
  width: 90%;
  padding: 7px;

  input {
    font-size: 14px;
    height: 42px !important;
    line-height: 42px !important;
  }

  li {
    display: flex;
    padding: 5px 20px;
    flex-direction: column;
    line-height: 20px;

    .label {
      font-size: 15px;
    }

    .desc {
      font-size: 13px;
      color: #999;
    }
  }
}

@media only screen and (max-width: 767px) {
  .cashier-input {
    .cashier-input-item {
      width: 100%;
    }
  }
}

// tool
.tool-card {
  .el-card__body {
    padding: 0.5rem !important;
  }
  .tool-list {
    display: flex;
    flex-direction: column;
    align-items: center;

    .el-button {
      width: 100px;
      height: 3rem;
      margin: 0.3rem;
    }
  }
}

@media only screen and (max-width: 767px) {
  .tool-card {
    .el-card__body {
      padding: 0.5rem !important;
    }
    .tool-list {
      display: flex;
      flex-direction: row;
      justify-content: space-around;
      flex-wrap: wrap;

      .el-button {
        width: 100px;
        height: 3rem;
        margin: 0.3rem;
      }
    }
  }
}

.el-autocomplete-suggestion li.highlighted,
.el-autocomplete-suggestion li:hover {
  background-color: lightgray;
}
</style>
