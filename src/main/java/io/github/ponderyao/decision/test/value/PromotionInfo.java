package io.github.ponderyao.decision.test.value;

import java.math.BigDecimal;

import lombok.Data;

/**
 * PromotionInfo
 *
 * @author PonderYao
 * @since 1.0.0
 */
@Data
public class PromotionInfo {
    
    private Long promotionId;
    
    private String promotionName;
    
    // 活动类型：折扣（DISCOUNT），满减（REBATE），秒杀（PRICE_SPIKE）
    private String promotionType;
    
    // 折扣
    private Integer discount;
    
    // 满减金额
    private BigDecimal rebate;
    
    // 满减要求额度
    private BigDecimal requiredPrice;
    
    // 秒杀价
    private BigDecimal priceSpike;
    
}
