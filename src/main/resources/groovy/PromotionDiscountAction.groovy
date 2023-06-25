package groovy

import java.math.RoundingMode

class PromotionDiscountAction {

    def goodsInfo

    def memberLevelInfo

    def promotionInfo
    
    def invoke(Map<String, Object> params) {
        def promotionInfo = this.getProperty("promotionInfo")
        def discount = BigDecimal.valueOf((Integer)promotionInfo.getDiscount()).divide(BigDecimal.valueOf(100))
        def price = (BigDecimal) params.getOrDefault("price", 0)
        def finalPrice = (discount * price).setScale(2, RoundingMode.HALF_UP)
        return ['price': finalPrice]
    }
    
}
