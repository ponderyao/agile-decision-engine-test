package io.github.ponderyao.decision.test.service;

import java.util.Map;

import io.github.ponderyao.decision.test.value.TestDTO;

/**
 * TestDecisionService
 * 
 * @author PonderYao
 * @since 1.0.0
 */
public interface TestDecisionService {
    
    Map<String, Object> runDecision(TestDTO dto);
    
    String parseScript(String groovyClassName);
    
}
