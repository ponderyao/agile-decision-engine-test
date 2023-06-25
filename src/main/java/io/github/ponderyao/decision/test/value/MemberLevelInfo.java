package io.github.ponderyao.decision.test.value;

import lombok.Data;

/**
 * MemberLevelInfo
 *
 * @author PonderYao
 * @since 1.0.0
 */
@Data
public class MemberLevelInfo {
    
    private Long memberId;
    
    // 会员类型：ORDINARY，VIP，SVIP
    private String memberLevel;
    
    // 会员折扣
    private Integer discount;
    
}
