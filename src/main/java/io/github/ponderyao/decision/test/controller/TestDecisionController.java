package io.github.ponderyao.decision.test.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.github.ponderyao.decision.test.service.TestDecisionService;
import io.github.ponderyao.decision.test.value.TestDTO;
import lombok.RequiredArgsConstructor;

/**
 * TestDecisionController
 *
 * @author PonderYao
 * @since 1.0.0
 */
@RestController
@RequestMapping("/decision/test")
@RequiredArgsConstructor
public class TestDecisionController {
    
    private final TestDecisionService testDecisionService;
    
    @PostMapping("/")
    public Map<String, Object> testDecision(@RequestBody TestDTO dto) {
        return testDecisionService.runDecision(dto);
    }
    
    @GetMapping("/script")
    public Map<String, Object> parseScript(String groovyClassName) {
        Map<String, Object> result = new HashMap<>();
        result.put("script", testDecisionService.parseScript(groovyClassName));
        return result;
    }
    
}
