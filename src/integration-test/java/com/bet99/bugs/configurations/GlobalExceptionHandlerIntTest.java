package com.bet99.bugs.configurations;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.bet99.bugs.BugService;
import com.bet99.bugs.controllers.BugRestController;
import com.bet99.bugs.models.BugDto;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.Mockito.mock;

@WebMvcTest(controllers = BugRestController.class)
@Import(GlobalExceptionHandlerIntTest.TestConfig.class)
public class GlobalExceptionHandlerIntTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @TestConfiguration
    static class TestConfig {
        @Bean
        @Primary
        public BugService bugService() {
            return mock(BugService.class);
        }
    }

    @Test
    void testHandleValidationExceptions_givenInvalidBugDto_expectValidationErrorsInResponse() throws Exception {
        // Create a BugDto with missing required fields (e.g., no title, no description)
        BugDto invalidBug = BugDto.builder().build();

        mockMvc.perform(post("/api/bugs")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidBug)))
                .andExpect(status().isBadRequest())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.bugTitle").exists())
                .andExpect(jsonPath("$.description").exists());
    }
}
