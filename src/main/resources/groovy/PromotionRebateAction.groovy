package groovy

class PromotionRebateAction {

    def goodsInfo

    def memberLevelInfo

    def promotionInfo
    
    def invoke(Map<String, Object> params) {
        def promotionInfo = this.getProperty("promotionInfo")
        def price = (BigDecimal) params.getOrDefault("price", 0)
        if (price > (BigDecimal) promotionInfo.getRequiredPrice()) {
            price -= promotionInfo.getRebate();
        }
        return ['price': price];
    }
    
}
