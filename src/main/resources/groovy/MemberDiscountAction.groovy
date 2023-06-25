package groovy

import java.math.RoundingMode;

class MemberDiscountAction {

    def goodsInfo

    def memberLevelInfo

    def promotionInfo
    
    def invoke(Map<String, Object> params) {
        def memberLevelInfo = this.getProperty("memberLevelInfo")
        def discount = BigDecimal.valueOf((Integer)memberLevelInfo.getDiscount()).divide(BigDecimal.valueOf(100))
        def price = (BigDecimal) params.getOrDefault("price", 0)
        def finalPrice = (discount * price).setScale(2, RoundingMode.HALF_UP)
        return ['price': finalPrice]
    }
    
}
