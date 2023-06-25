package groovy

class MemberLevelCondition {

    def goodsInfo

    def memberLevelInfo

    def promotionInfo
    
    def invoke() {
        def memberLevelInfo = this.getProperty("memberLevelInfo")
        def memberLevel = memberLevelInfo.getMemberLevel()
        return ['memberLevel': memberLevel]
    }
    
}
