package io.github.ponderyao.decision.test;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

/**
 * AgileDecisionEngineTestApplication
 * 
 * @author PonderYao
 * @since 1.0.0
 */
@SpringBootApplication
@ComponentScan(basePackages = {"io.github.ponderyao.decision.*"})
public class AgileDecisionEngineTestApplication {

    public static void main(String[] args) {
        SpringApplication.run(AgileDecisionEngineTestApplication.class, args);
    }
    
}
