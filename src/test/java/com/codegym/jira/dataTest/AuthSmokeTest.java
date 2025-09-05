package com.codegym.jira.dataTest;

import com.codegym.jira.AbstractControllerTest;
import com.codegym.jira.login.internal.web.UserTestData;
import org.junit.jupiter.api.Test;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithUserDetails;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

class AuthSmokeTest extends AbstractControllerTest {

    private static final String REST_URL_MNGR_PROJECT = "/api/mngr/projects";

    @Test
    @WithUserDetails(value = UserTestData.MANAGER_MAIL)
    void createProjectAsManager() throws Exception {
        String jsonBody = """
        {
          "title": "Smoke Project",
          "description": "Proyecto de prueba",
          "enabled": true,
          "typeCode": "SW",
          "code": "SMK1"
        }
        """;

        mockMvc.perform(MockMvcRequestBuilders.post(REST_URL_MNGR_PROJECT)
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonBody))
            .andDo(print())
            .andExpect(status().isCreated());
    }
}
