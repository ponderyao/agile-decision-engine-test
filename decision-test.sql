-- decision-domain
INSERT INTO decision_domain(domain_code, domain_name, domain_desc) VALUES ('price-calculation', '商品价格计算', '根据商品信息、会员等级、促销活动三个维度计算商品最终价格');

-- condition-stub
INSERT INTO condition_stub(domain_id, condition_code, condition_name, condition_type, condition_desc, condition_script, script_method, prev_condition)
VALUES(1, 'isNotLowGoodsPrice', '商品价格非超低价', 'Boolean', '判断商品总价是否超过低价上限', 'package groovy\n\nclass GoodsPriceCondition {\n    \n    def goodsInfo\n    \n    def memberLevelInfo\n    \n    def promotionInfo\n    \n    def invoke() {\n        def goodsInfo = this.getProperty(\"goodsInfo\")\n        def isNotLowGoodsPrice = (goodsInfo.getPrice() + goodsInfo.getShipPrice()) > 1\n        return [\'isNotLowGoodsPrice\': isNotLowGoodsPrice]\n    }\n    \n}\n', 'invoke', null);
INSERT INTO condition_stub(domain_id, condition_code, condition_name, condition_type, condition_desc, condition_script, script_method, prev_condition)
VALUES(1, 'memberLevel', '会员等级', 'String', '会员等级', 'package groovy\n\nclass MemberLevelCondition {\n    \n    def goodsInfo\n    \n    def memberLevelInfo\n    \n    def promotionInfo\n    \n    def invoke() {\n        def memberLevelInfo = this.getProperty(\"memberLevelInfo\")\n        def memberLevel = memberLevelInfo.getMemberLevel()\n        return [\'memberLevel\': memberLevel]\n    }\n    \n}\n', 'invoke', 1);
INSERT INTO condition_stub(domain_id, condition_code, condition_name, condition_type, condition_desc, condition_script, script_method, prev_condition)
VALUES(1, 'promotionType', '促销活动类型', 'String', '促销活动类型', 'package groovy\n\nclass PromotionLevelCondition {\n    \n    def goodsInfo\n    \n    def memberLevelInfo\n    \n    def promotionInfo\n    \n    def invoke() {\n        def promotionInfo = this.getProperty(\"promotionInfo\")\n        def promotionType = null\n        if (promotionInfo != null) {\n            promotionType = promotionInfo.getPromotionType()\n        }\n        return [\'promotionType\': promotionType]\n    }\n    \n}\n', 'invoke', 2);

-- action-stub
INSERT INTO action_stub(domain_id, action_code, action_name, action_desc, action_script, script_method)
VALUES (1, 'goodsPrice', '商品原价', '获取商品原价', 'package groovy\n\nclass GoodsPriceAction {\n    \n    def goodsInfo\n    \n    def memberLevelInfo\n    \n    def promotionInfo\n    \n    def invoke() {\n        def goodsInfo = this.getProperty(\"goodsInfo\")\n        def price = goodsInfo.getPrice()\n        return [\'price\': price]\n    }\n    \n}\n', 'invoke');
INSERT INTO action_stub(domain_id, action_code, action_name, action_desc, action_script, script_method)
VALUES (1, 'goodsShipPrice', '商品运费', '增加商品运费', 'package groovy\n\nclass GoodsShipPriceAction {\n    \n    def goodsInfo\n    \n    def memberLevelInfo\n    \n    def promotionInfo\n    \n    def invoke(Map<String, Object> params) {\n        def goodsInfo = this.getProperty(\"goodsInfo\")\n        def price = params.getOrDefault(\"price\", goodsInfo.getPrice())\n        price += goodsInfo.getShipPrice()\n        return [\'price\': price]\n    }\n    \n}\n', 'invoke');
INSERT INTO action_stub(domain_id, action_code, action_name, action_desc, action_script, script_method)
VALUES (1, 'memberDiscount', '会员折扣', '计算会员折扣后价格', 'package groovy\n\nimport java.math.RoundingMode;\n\nclass MemberDiscountAction {\n    \n    def goodsInfo\n    \n    def memberLevelInfo\n    \n    def promotionInfo\n    \n    def invoke(Map<String, Object> params) {\n        def memberLevelInfo = this.getProperty(\"memberLevelInfo\")\n        def discount = BigDecimal.valueOf((Integer)memberLevelInfo.getDiscount()).divide(BigDecimal.valueOf(100))\n        def price = (BigDecimal) params.getOrDefault(\"price\", 0)\n        def finalPrice = (discount * price).setScale(2, RoundingMode.HALF_UP)\n        return [\'price\': finalPrice]\n    }\n    \n}\n', 'invoke');
INSERT INTO action_stub(domain_id, action_code, action_name, action_desc, action_script, script_method)
VALUES (1, 'promotionDiscount', '促销折扣价', '计算促销折扣后价格', 'package groovy\n\nimport java.math.RoundingMode\n\nclass PromotionDiscountAction {\n    \n    def goodsInfo\n    \n    def memberLevelInfo\n    \n    def promotionInfo\n    \n    def invoke(Map<String, Object> params) {\n        def promotionInfo = this.getProperty(\"promotionInfo\")\n        def discount = BigDecimal.valueOf((Integer)promotionInfo.getDiscount()).divide(BigDecimal.valueOf(100))\n        def price = (BigDecimal) params.getOrDefault(\"price\", 0)\n        def finalPrice = (discount * price).setScale(2, RoundingMode.HALF_UP)\n        return [\'price\': finalPrice]\n    }\n    \n}\n', 'invoke');
INSERT INTO action_stub(domain_id, action_code, action_name, action_desc, action_script, script_method)
VALUES (1, 'promotionRebate', '促销满减价', '计算促销满减后价格', 'package groovy\n\nclass PromotionRebateAction {\n    \n    def goodsInfo\n    \n    def memberLevelInfo\n    \n    def promotionInfo\n    \n    def invoke(Map<String, Object> params) {\n        def promotionInfo = this.getProperty(\"promotionInfo\")\n        def price = (BigDecimal) params.getOrDefault(\"price\", 0)\n        if (price > (BigDecimal) promotionInfo.getRequiredPrice()) {\n            price -= promotionInfo.getRebate();\n        }\n        return [\'price\': price];\n    }\n    \n}\n', 'invoke');
INSERT INTO action_stub(domain_id, action_code, action_name, action_desc, action_script, script_method)
VALUES (1, 'promotionPriceSpike', '促销秒杀价', '计算促销秒杀价格', 'package groovy\n\nimport io.github.ponderyao.decision.test.value.PromotionInfo\n\nclass PromotionPriceSpikeAction {\n    \n    def goodsInfo\n    \n    def memberLevelInfo\n    \n    def promotionInfo\n    \n    def invoke(Map<String, Object> params) {\n        def promotionInfo = (PromotionInfo) this.getProperty(\"promotionInfo\")\n        def price = promotionInfo.getPriceSpike()\n        return [\'price\': price]\n    }\n    \n}\n', 'invoke');

-- decision-rule
INSERT INTO decision_rule(domain_id, rule_name, rule_desc) VALUES (1, '商品超低价不参与优惠活动', '商品超低价不参与优惠活动');
INSERT INTO decision_rule(domain_id, rule_name, rule_desc) VALUES (1, '普通会员购买无促销商品', '普通会员购买无促销商品');
INSERT INTO decision_rule(domain_id, rule_name, rule_desc) VALUES (1, '普通会员购买促销折扣商品', '普通会员购买促销折扣商品');
INSERT INTO decision_rule(domain_id, rule_name, rule_desc) VALUES (1, '普通会员购买促销满减商品', '普通会员购买促销满减商品');
INSERT INTO decision_rule(domain_id, rule_name, rule_desc) VALUES (1, '普通会员购买促销秒杀商品', '普通会员购买促销秒杀商品');
INSERT INTO decision_rule(domain_id, rule_name, rule_desc) VALUES (1, 'VIP会员购买无促销商品', 'VIP会员购买无促销商品');
INSERT INTO decision_rule(domain_id, rule_name, rule_desc) VALUES (1, 'VIP会员购买促销折扣商品', 'VIP会员购买促销折扣商品');
INSERT INTO decision_rule(domain_id, rule_name, rule_desc) VALUES (1, 'VIP会员购买促销满减商品', 'VIP会员购买促销满减商品');
INSERT INTO decision_rule(domain_id, rule_name, rule_desc) VALUES (1, 'VIP会员购买促销秒杀商品', 'VIP会员购买促销秒杀商品');
INSERT INTO decision_rule(domain_id, rule_name, rule_desc) VALUES (1, 'SVIP会员购买无促销商品', 'SVIP会员购买无促销商品');
INSERT INTO decision_rule(domain_id, rule_name, rule_desc) VALUES (1, 'SVIP会员购买促销折扣商品', 'SVIP会员购买促销折扣商品');
INSERT INTO decision_rule(domain_id, rule_name, rule_desc) VALUES (1, 'SVIP会员购买促销满减商品', 'SVIP会员购买促销满减商品');
INSERT INTO decision_rule(domain_id, rule_name, rule_desc) VALUES (1, 'SVIP会员购买促销秒杀商品', 'SVIP会员购买促销秒杀商品');

-- condition-entry
INSERT INTO condition_entry(domain_id, rule_id, condition_stub_id, condition_value) VALUES (1, 1, 1, 'false');
INSERT INTO condition_entry(domain_id, rule_id, condition_stub_id, condition_value) VALUES (1, 2, 1, 'true'),(1, 2, 2, 'ORDINARY'),(1, 2, 3, null);
INSERT INTO condition_entry(domain_id, rule_id, condition_stub_id, condition_value) VALUES (1, 3, 1, 'true'),(1, 3, 2, 'ORDINARY'),(1, 3, 3, 'DISCOUNT');
INSERT INTO condition_entry(domain_id, rule_id, condition_stub_id, condition_value) VALUES (1, 4, 1, 'true'),(1, 4, 2, 'ORDINARY'),(1, 4, 3, 'REBATE');
INSERT INTO condition_entry(domain_id, rule_id, condition_stub_id, condition_value) VALUES (1, 5, 1, 'true'),(1, 5, 2, 'ORDINARY'),(1, 5, 3, 'SPIKE');
INSERT INTO condition_entry(domain_id, rule_id, condition_stub_id, condition_value) VALUES (1, 6, 1, 'true'),(1, 6, 2, 'VIP'),(1, 6, 3, null);
INSERT INTO condition_entry(domain_id, rule_id, condition_stub_id, condition_value) VALUES (1, 7, 1, 'true'),(1, 7, 2, 'VIP'),(1, 7, 3, 'DISCOUNT');
INSERT INTO condition_entry(domain_id, rule_id, condition_stub_id, condition_value) VALUES (1, 8, 1, 'true'),(1, 8, 2, 'VIP'),(1, 8, 3, 'REBATE');
INSERT INTO condition_entry(domain_id, rule_id, condition_stub_id, condition_value) VALUES (1, 9, 1, 'true'),(1, 9, 2, 'VIP'),(1, 9, 3, 'SPIKE');
INSERT INTO condition_entry(domain_id, rule_id, condition_stub_id, condition_value) VALUES (1, 10, 1, 'true'),(1, 10, 2, 'SVIP'),(1, 10, 3, null);
INSERT INTO condition_entry(domain_id, rule_id, condition_stub_id, condition_value) VALUES (1, 11, 1, 'true'),(1, 11, 2, 'SVIP'),(1, 11, 3, 'DISCOUNT');
INSERT INTO condition_entry(domain_id, rule_id, condition_stub_id, condition_value) VALUES (1, 12, 1, 'true'),(1, 12, 2, 'SVIP'),(1, 12, 3, 'REBATE');
INSERT INTO condition_entry(domain_id, rule_id, condition_stub_id, condition_value) VALUES (1, 13, 1, 'true'),(1, 13, 2, 'SVIP'),(1, 13, 3, 'SPIKE');

-- action-entry
INSERT INTO action_entry(domain_id, rule_id, action_stub_id, next_action) VALUES (1, 1, 1, 2),(1, 1, 2, null);
INSERT INTO action_entry(domain_id, rule_id, action_stub_id, next_action) VALUES (1, 2, 1, 4),(1, 2, 2, null);
INSERT INTO action_entry(domain_id, rule_id, action_stub_id, next_action) VALUES (1, 3, 1, 6),(1, 3, 4, 7),(1, 3, 2, null);
INSERT INTO action_entry(domain_id, rule_id, action_stub_id, next_action) VALUES (1, 4, 1, 9),(1, 4, 5, 10),(1, 4, 2, null);
INSERT INTO action_entry(domain_id, rule_id, action_stub_id, next_action) VALUES (1, 5, 1, 12),(1, 5, 6, 13),(1, 5, 2, null);
INSERT INTO action_entry(domain_id, rule_id, action_stub_id, next_action) VALUES (1, 6, 1, 15),(1, 6, 3, 16),(1, 6, 2, null);
INSERT INTO action_entry(domain_id, rule_id, action_stub_id, next_action) VALUES (1, 7, 1, 18),(1, 7, 4, 19),(1, 7, 3, 20),(1, 7, 2, null);
INSERT INTO action_entry(domain_id, rule_id, action_stub_id, next_action) VALUES (1, 8, 1, 22),(1, 8, 5, 23),(1, 8, 3, 24),(1, 8, 2, null);
INSERT INTO action_entry(domain_id, rule_id, action_stub_id, next_action) VALUES (1, 9, 1, 26),(1, 9, 6, 27),(1, 9, 2, null);
INSERT INTO action_entry(domain_id, rule_id, action_stub_id, next_action) VALUES (1, 10, 1, 29),(1, 10, 3, null);
INSERT INTO action_entry(domain_id, rule_id, action_stub_id, next_action) VALUES (1, 11, 1, 31),(1, 11, 4, 32),(1, 11, 3, null);
INSERT INTO action_entry(domain_id, rule_id, action_stub_id, next_action) VALUES (1, 12, 1, 34),(1, 12, 5, 35),(1, 12, 3, null);
INSERT INTO action_entry(domain_id, rule_id, action_stub_id, next_action) VALUES (1, 13, 1, 37),(1, 13, 6, null);