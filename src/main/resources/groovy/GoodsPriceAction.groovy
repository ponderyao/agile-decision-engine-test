package groovy

class GoodsPriceAction {
    
    def goodsInfo
    
    def memberLevelInfo
    
    def promotionInfo
    
    def invoke() {
        def goodsInfo = this.getProperty("goodsInfo")
        def price = goodsInfo.getPrice()
        return ['price': price]
    }
    
}
