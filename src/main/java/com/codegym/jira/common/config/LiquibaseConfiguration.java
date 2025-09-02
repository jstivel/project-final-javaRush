package com.codegym.jira.common.config;

import liquibase.integration.spring.SpringLiquibase;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.ImportAutoConfiguration;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;

import javax.sql.DataSource;

@Configuration
@EnableAutoConfiguration
@ImportAutoConfiguration({DataSourceAutoConfiguration.class})
public class LiquibaseConfiguration {

    @Bean
    @DependsOn("dataSource")
    public SpringLiquibase liquibase(DataSource dataSource) {
        SpringLiquibase liquibase = new SpringLiquibase();
        liquibase.setDataSource(dataSource);
        liquibase.setChangeLog("classpath:db/changelog.sql"); // Asegúrate de que esta ruta sea la correcta
        return liquibase;
    }
}
