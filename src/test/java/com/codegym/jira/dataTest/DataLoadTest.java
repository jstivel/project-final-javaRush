package com.codegym.jira.dataTest;

import com.codegym.jira.AbstractControllerTest;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

class DataLoadTest extends AbstractControllerTest {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Test
    void testDataLoadedAndPrint() {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList("SELECT * FROM users");

        System.out.println("=== Datos cargados en la tabla USERS ===");
        rows.forEach(row -> System.out.println(row));

        // Validación
        org.assertj.core.api.Assertions.assertThat(rows).isNotEmpty();
    }
}
