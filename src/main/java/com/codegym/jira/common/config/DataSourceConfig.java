package com.codegym.jira.common.config;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import javax.sql.DataSource;

@Configuration
public class DataSourceConfig {
    private final Dotenv dotenv = Dotenv.load();

    @Bean
    @Profile("prod")
    public DataSource postgresDataSource() {
        return DataSourceBuilder.create()
            .url(dotenv.get("DB_URL"))
            .username(dotenv.get("DB_USER"))
            .password(dotenv.get("DB_PASSWORD"))
            .driverClassName("org.postgresql.Driver")
            .build();
    }

    @Bean
    @Profile("test")
    public DataSource h2DataSource() {
        return DataSourceBuilder.create()
            .url("jdbc:h2:mem:testdb;DB_CLOSE_DELAY=0;MODE=PostgreSQL;DATABASE_TO_UPPER=false")
            .username("sa")
            .password("")
            .driverClassName("org.h2.Driver")
            .build();
    }
}
