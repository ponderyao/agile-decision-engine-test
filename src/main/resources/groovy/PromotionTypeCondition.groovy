package groovy

class PromotionLevelCondition {

    def goodsInfo

    def memberLevelInfo

    def promotionInfo
    
    def invoke() {
        def promotionInfo = this.getProperty("promotionInfo")
        def promotionType = null
        if (promotionInfo != null) {
            promotionType = promotionInfo.getPromotionType()
        }
        return ['promotionType': promotionType]
    }
    
}
