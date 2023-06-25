package groovy

import io.github.ponderyao.decision.test.value.PromotionInfo

class PromotionPriceSpikeAction {

    def goodsInfo

    def memberLevelInfo

    def promotionInfo
    
    def invoke(Map<String, Object> params) {
        def promotionInfo = (PromotionInfo) this.getProperty("promotionInfo")
        def price = promotionInfo.getPriceSpike()
        return ['price': price]
    }
    
}
