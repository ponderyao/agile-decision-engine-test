package groovy

class GoodsShipPriceAction {

    def goodsInfo

    def memberLevelInfo

    def promotionInfo
    
    def invoke(Map<String, Object> params) {
        def goodsInfo = this.getProperty("goodsInfo")
        def price = params.getOrDefault("price", goodsInfo.getPrice())
        price += goodsInfo.getShipPrice()
        return ['price': price]
    }
    
}
