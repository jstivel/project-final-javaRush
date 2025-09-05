package com.codegym.jira.profile.internal.web;

import com.codegym.jira.AbstractControllerTest;
import com.codegym.jira.common.util.JsonUtil;
import com.codegym.jira.login.internal.web.UserTestData;
import com.codegym.jira.profile.ProfileTo;
import com.codegym.jira.profile.internal.ProfileRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithUserDetails;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static com.codegym.jira.profile.internal.web.ProfileTestData.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

class ProfileRestControllerTest extends AbstractControllerTest {
    private static final String REST_URL = ProfileRestController.REST_URL;

    @Autowired
    private ProfileRepository profileRepository;

    @Test
    @WithUserDetails(value = UserTestData.USER_MAIL)
    void getProfile() throws Exception {
        perform(MockMvcRequestBuilders.get(REST_URL))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
            .andExpect(content().json(JsonUtil.writeValue(USER_PROFILE_TO)));
    }

    @Test
    void getProfileUnAuth() throws Exception {
        perform(MockMvcRequestBuilders.get(REST_URL))
            .andDo(print())
            .andExpect(status().isUnauthorized());
    }

    @Test
    @WithUserDetails(value = UserTestData.USER_MAIL)
    void updateProfile() throws Exception {
        ProfileTo updated = getUpdatedTo();

        perform(MockMvcRequestBuilders.put(REST_URL)
            .contentType(MediaType.APPLICATION_JSON)
            .content(JsonUtil.writeValue(updated)))
            .andDo(print())
            .andExpect(status().isNoContent());

        PROFILE_MATCHER.assertMatch(
            profileRepository.getExisted(UserTestData.USER_ID),
            getUpdated(UserTestData.USER_ID)
        );
    }

    @Test
    void updateProfileUnAuth() throws Exception {
        perform(MockMvcRequestBuilders.put(REST_URL)
            .contentType(MediaType.APPLICATION_JSON)
            .content(JsonUtil.writeValue(getUpdatedTo())))
            .andDo(print())
            .andExpect(status().isUnauthorized());
    }

    @Test
    @WithUserDetails(value = UserTestData.USER_MAIL)
    void updateProfileInvalid() throws Exception {
        perform(MockMvcRequestBuilders.put(REST_URL)
            .contentType(MediaType.APPLICATION_JSON)
            .content(JsonUtil.writeValue(getInvalidTo())))
            .andDo(print())
            .andExpect(status().isUnprocessableEntity());
    }

    @Test
    @WithUserDetails(value = UserTestData.USER_MAIL)
    void updateProfileWithUnknownNotification() throws Exception {
        perform(MockMvcRequestBuilders.put(REST_URL)
            .contentType(MediaType.APPLICATION_JSON)
            .content(JsonUtil.writeValue(getWithUnknownNotificationTo())))
            .andDo(print())
            .andExpect(status().isUnprocessableEntity());
    }

    @Test
    @WithUserDetails(value = UserTestData.USER_MAIL)
    void updateProfileWithUnknownContact() throws Exception {
        perform(MockMvcRequestBuilders.put(REST_URL)
            .contentType(MediaType.APPLICATION_JSON)
            .content(JsonUtil.writeValue(getWithUnknownContactTo())))
            .andDo(print())
            .andExpect(status().isUnprocessableEntity());
    }

    @Test
    @WithUserDetails(value = UserTestData.USER_MAIL)
    void updateProfileWithHtmlUnsafeContact() throws Exception {
        perform(MockMvcRequestBuilders.put(REST_URL)
            .contentType(MediaType.APPLICATION_JSON)
            .content(JsonUtil.writeValue(getWithContactHtmlUnsafeTo())))
            .andDo(print())
            .andExpect(status().isUnprocessableEntity());
    }
}
