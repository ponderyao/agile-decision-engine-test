package io.github.ponderyao.decision.test.service.impl;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.stereotype.Service;

import io.github.ponderyao.decision.engine.DecisionEngine;
import io.github.ponderyao.decision.test.common.DecisionDomainConstant;
import io.github.ponderyao.decision.test.service.TestDecisionService;
import io.github.ponderyao.decision.test.value.TestDTO;
import io.github.ponderyao.decision.value.DecisionCondition;
import io.github.ponderyao.decision.value.DecisionResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * TestDecisionServiceImpl
 *
 * @author PonderYao
 * @since 1.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class TestDecisionServiceImpl implements TestDecisionService {
    
    private final DecisionEngine decisionEngine;

    /**
     * 场景：根据商品信息、会员等级、促销活动三个维度计算商品最终价格
     * - 商品信息：原价，运费
     * - 会员等级：等级，折扣，是否免运费（隐藏信息）
     * - 促销活动：活动类型，折扣/满减/秒杀
     * 分析：
     * - 条件桩：商品总价>1，会员等级，促销活动类型
     * - 动作桩：商品原价，商品运费，会员折扣，促销折扣价，促销满减价，促销秒杀价
     * - 规则：
     *   1. 商品超低价不参与优惠活动：（商品非超低价=false）->（商品原价，商品运费）
     *   2. 普通会员购买无促销商品：（商品非超低价=true，会员等级=ORDINARY，促销活动类型=null）->（商品原价，商品运费）
     *   3. 普通会员购买促销折扣商品：（商品非超低价=true，会员等级=ORDINARY，促销活动类型=DISCOUNT）->（商品原价，促销折扣价，商品运费）
     *   4. 普通会员购买促销满减商品：（商品非超低价=true，会员等级=ORDINARY，促销活动类型=REBATE）->（商品原价，促销满减价，商品运费）
     *   5. 普通会员购买促销秒杀商品：（商品非超低价=true，会员等级=ORDINARY，促销活动类型=SPIKE）->（商品原价，促销秒杀价，商品运费）
     *   6. VIP会员购买无促销商品：（商品非超低价=true，会员等级=VIP，促销活动类型=null）->（商品原价，会员折扣，商品运费）
     *   7. VIP会员购买促销折扣商品：（商品非超低价=true，会员等级=VIP，促销活动类型=DISCOUNT）->（商品原价，促销折扣价，会员折扣，商品运费）
     *   8. VIP会员购买促销满减商品：（商品非超低价=true，会员等级=VIP，促销活动类型=REBATE）->（商品原价，促销满减价，会员折扣，商品运费）
     *   9. VIP会员购买促销秒杀商品：（商品非超低价=true，会员等级=VIP，促销活动类型=SPIKE）->（商品原价，促销秒杀价，商品运费） ---- 秒杀不支持会员折扣
     *   10. SVIP会员购买无促销商品：（商品非超低价=true，会员等级=SVIP，促销活动类型=null）->（商品原价，会员折扣）
     *   11. SVIP会员购买促销折扣商品：（商品非超低价=true，会员等级=SVIP，促销活动类型=DISCOUNT）->（商品原价，促销折扣价，会员折扣）
     *   12. SVIP会员购买促销满减商品：（商品非超低价=true，会员等级=SVIP，促销活动类型=REBATE）->（商品原价，促销满减价，会员折扣）
     *   13. SVIP会员购买促销秒杀商品：（商品非超低价=true，会员等级=SVIP，促销活动类型=SPIKE）->（商品原价，促销秒杀价）
     */
    @Override
    public Map<String, Object> runDecision(TestDTO dto) {
        // 设定决策所需的前置业务对象
        Map<String, Object> previousObjects = new HashMap<>();
        previousObjects.put("goodsInfo", dto.getGoodsInfo());
        previousObjects.put("memberLevelInfo", dto.getMemberLevelInfo());
        previousObjects.put("promotionInfo", dto.getPromotionInfo());
        // 根据决策领域执行决策，得到决策结果
        DecisionCondition condition = new DecisionCondition(DecisionDomainConstant.PRICE_CALCULATION, previousObjects);
        DecisionResult result = decisionEngine.execute(condition);
        log.info("本次决策采取的决策规则：" + result.getDecisionRuleName());
        return result.getResponseData();
    }

    @Override
    public String parseScript(String groovyClassName) {
        AnnotationConfigApplicationContext applicationContext =
            new AnnotationConfigApplicationContext();
        applicationContext.scan("groovy");
        applicationContext.refresh();
        try {
            InputStream is = applicationContext.getResource("classpath:groovy/" + groovyClassName + ".groovy").getInputStream();
            String result = IOUtils.toString(is, StandardCharsets.UTF_8);
            System.out.println(result);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}
