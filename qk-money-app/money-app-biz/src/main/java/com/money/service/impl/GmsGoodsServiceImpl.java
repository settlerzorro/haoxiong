package com.money.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.conditions.query.LambdaQueryChainWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.money.common.exception.BaseException;
import com.money.common.vo.PageVO;
import com.money.constant.GoodsStatus;
import com.money.dto.GmsGoods.GmsGoodsDTO;
import com.money.dto.GmsGoods.GmsGoodsQueryDTO;
import com.money.dto.GmsGoods.GmsGoodsVO;
import com.money.entity.GmsGoods;
import com.money.mapper.GmsGoodsMapper;
import com.money.oss.OSSDelegate;
import com.money.oss.core.FileNameStrategy;
import com.money.oss.core.FolderPath;
import com.money.oss.local.LocalOSS;
import com.money.service.GmsBrandService;
import com.money.service.GmsGoodsCategoryService;
import com.money.service.GmsGoodsService;
import com.money.util.PageUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * <p>
 * 商品表 服务实现类
 * </p>
 *
 * @author money
 * @since 2023-02-27
 */
@Service
@RequiredArgsConstructor
public class GmsGoodsServiceImpl extends ServiceImpl<GmsGoodsMapper, GmsGoods> implements GmsGoodsService {

    private final OSSDelegate<LocalOSS> localOSS;
    private final GmsBrandService gmsBrandService;
    private final GmsGoodsCategoryService gmsGoodsCategoryService;
    @Override
    public PageVO<GmsGoodsVO> list(GmsGoodsQueryDTO queryDTO) {
        LambdaQueryChainWrapper<GmsGoods> queryChainWrapper = this.lambdaQuery();
        if (queryDTO.getCategoryId() != null) {
            List<Long> categoryIds = gmsGoodsCategoryService.getAllSubId(queryDTO.getCategoryId());
            queryChainWrapper.in(GmsGoods::getCategoryId, categoryIds);
        }
        Page<GmsGoods> page = queryChainWrapper
                .eq(ObjectUtil.isNotNull(queryDTO.getBrandId()), GmsGoods::getBrandId, queryDTO.getBrandId())
                .eq(ObjectUtil.isNotNull(queryDTO.getStatus()), GmsGoods::getStatus, queryDTO.getStatus())
                //.like(StrUtil.isNotBlank(queryDTO.getBarcode()), GmsGoods::getBarcode, queryDTO.getBarcode())
                .like(StrUtil.isNotBlank(queryDTO.getName()), GmsGoods::getName, queryDTO.getName())
                .orderByDesc(StrUtil.isBlank(queryDTO.getOrderBy()), GmsGoods::getUpdateTime)
                .last(StrUtil.isNotBlank(queryDTO.getOrderBy()), queryDTO.getOrderBySql())
                .page(PageUtil.toPage(queryDTO));
        return PageUtil.toPageVO(page, GmsGoodsVO::new);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void add(GmsGoodsDTO addDTO) {
        boolean exists = this.lambdaQuery().eq(GmsGoods::getName, addDTO.getName()).eq(GmsGoods::getUnit, addDTO.getUnit()).exists();
        if (exists) {
            throw new BaseException("名称已存在");
        }
        GmsGoods gmsGoods = new GmsGoods();
        BeanUtil.copyProperties(addDTO, gmsGoods);
        // 更新商品数量
        gmsBrandService.updateGoodsCount(gmsGoods.getBrandId(), 1);
        gmsGoodsCategoryService.updateGoodsCount(gmsGoods.getCategoryId(), 1);
        this.save(gmsGoods);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void update(GmsGoodsDTO updateDTO) {
        boolean exists = this.lambdaQuery().ne(GmsGoods::getId, updateDTO.getId()).eq(GmsGoods::getName, updateDTO.getName()).eq(GmsGoods::getUnit, updateDTO.getUnit()).exists();
        if (exists) {
            throw new BaseException("名称已存在");
        }
        GmsGoods gmsGoods = this.getById(updateDTO.getId());
        // 更新商品数量
        if (!gmsGoods.getBrandId().equals(updateDTO.getBrandId())) {
            gmsBrandService.updateGoodsCount(updateDTO.getBrandId(), 1);
            gmsBrandService.updateGoodsCount(gmsGoods.getBrandId(), -1);
        }
        if (!gmsGoods.getCategoryId().equals(updateDTO.getCategoryId())) {
            gmsGoodsCategoryService.updateGoodsCount(updateDTO.getCategoryId(), 1);
            gmsGoodsCategoryService.updateGoodsCount(gmsGoods.getCategoryId(), -1);
        }
        BeanUtil.copyProperties(updateDTO, gmsGoods);
        // 调整状态
        if (GoodsStatus.SOLD_OUT.name().equals(gmsGoods.getStatus()) && updateDTO.getStock() > 0) {
            gmsGoods.setStatus(GoodsStatus.SALE.name());
        }
        if (GoodsStatus.SALE.name().equals(gmsGoods.getStatus()) && updateDTO.getStock() <= 0) {
            gmsGoods.setStatus(GoodsStatus.SOLD_OUT.name());
        }else{
            gmsGoods.setStatus(updateDTO.getStatus());
        }
        this.updateById(gmsGoods);
    }

    @Override
    public void delete(Set<Long> ids) {
        List<GmsGoods> gmsGoodsList = this.listByIds(ids);
        this.removeByIds(ids);
        gmsGoodsList.forEach(gmsGoods -> {
            if (StrUtil.isNotBlank(gmsGoods.getPic())) {
                localOSS.delete(gmsGoods.getPic());
            }
        });
    }

    @Override
    public void split(String id) {
        //拆分后库存减1
        GmsGoods gmsGoods = this.getById(id);
        gmsGoods.setStock(gmsGoods.getStock() - 1);
        // 调整状态
        if (GoodsStatus.SOLD_OUT.name().equals(gmsGoods.getStatus()) && gmsGoods.getStock() > 0) {
            gmsGoods.setStatus(GoodsStatus.SALE.name());
        }
        if (GoodsStatus.SALE.name().equals(gmsGoods.getStatus()) && gmsGoods.getStock() <= 0) {
            gmsGoods.setStatus(GoodsStatus.SOLD_OUT.name());
        }
        this.updateById(gmsGoods);

        boolean exists = false;
        QueryWrapper<GmsGoods> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("name",gmsGoods.getName());
        List<GmsGoods> list = this.list(queryWrapper);
        for(GmsGoods goods : list){
            //找到名称一样，但单位不一样的商品，例如条软玉对应的包软玉,然后增加其库存
            if(!goods.getUnit().equals(gmsGoods.getUnit())){
                goods.setStock(goods.getStock() + Integer.parseInt(gmsGoods.getSize()));
                this.updateById(goods);
                exists = true;
                break;
            }
        }
        //不存在散货则直接新增散货
        if(!exists){
            GmsGoods newGoods = new GmsGoods();
            BeanUtil.copyProperties(gmsGoods, newGoods);
            if(newGoods.getUnit().equals("条")){
                newGoods.setUnit("包");
            }
            if(newGoods.getUnit().equals("件")){
                newGoods.setUnit("瓶");
            }
            newGoods.setStock(Long.parseLong(newGoods.getSize()));
            newGoods.setPurchasePrice(newGoods.getPurchasePrice().divide(new BigDecimal(newGoods.getSize())));
            newGoods.setSales(0L);
            newGoods.setSalePrice(newGoods.getSalePrice().divide(new BigDecimal(newGoods.getSize())));
            newGoods.setId(null);
            newGoods.setSize(null);
            this.save(newGoods);
        }
    }

    @Override
    public void sell(Long goodsId, Integer qty) {
        if (qty > 0) {
            GmsGoods byId = this.getById(goodsId);
            byId.setStock(byId.getStock() - qty);
            byId.setSales(byId.getSales() + 1);
            byId.setStatus(byId.getStock() > 0 ? GoodsStatus.SALE.name() : GoodsStatus.SOLD_OUT.name());
            this.updateById(byId);
        }
    }

    @Override
    public void updateStock(Long goodsId, Integer qty) {
        if (qty != 0) {
            GmsGoods byId = this.getById(goodsId);
            byId.setStock(byId.getStock() + qty);
            byId.setSales(byId.getSales() + 1);
            byId.setStatus(byId.getStock() > 0 ? GoodsStatus.SALE.name() : GoodsStatus.SOLD_OUT.name());
            this.updateById(byId);
        }
    }

    @Override
    public BigDecimal getCurrentStockValue() {
        List<GmsGoods> gmsGoods = this.lambdaQuery().select(GmsGoods::getStock, GmsGoods::getPurchasePrice).gt(GmsGoods::getStock, 0).list();
        List<BigDecimal> sumList = gmsGoods.stream().map(gmsGood -> gmsGood.getPurchasePrice().multiply(new BigDecimal(gmsGood.getStock()))).collect(Collectors.toList());
        return sumList.stream().reduce(BigDecimal.ZERO, BigDecimal::add);
    }

}
