package io.github.ponderyao.decision.test.value;

import java.math.BigDecimal;

import lombok.Data;

/**
 * GoodsInfo
 *
 * @author PonderYao
 * @since 1.0.0
 */
@Data
public class GoodsInfo {
    
    private Long goodsId;
    
    private String goodsName;
    
    // 商品原价
    private BigDecimal price;
    
    // 货运费
    private BigDecimal shipPrice;
    
}
