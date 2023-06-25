package groovy

class GoodsPriceCondition {

    def goodsInfo

    def memberLevelInfo

    def promotionInfo
    
    def invoke() {
        def goodsInfo = this.getProperty("goodsInfo")
        def isNotLowGoodsPrice = (goodsInfo.getPrice() + goodsInfo.getShipPrice()) > 1
        return ['isNotLowGoodsPrice': isNotLowGoodsPrice]
    }
    
}
