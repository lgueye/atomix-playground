package io.agileinfra.traffic;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import io.agileinfra.traffic.repository.SosRepository;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.web.client.RestTemplate;

@Configuration
public class TrafficApplicationConfiguration {

    @Bean
    public ObjectMapper objectMapper() {
        return Jackson2ObjectMapperBuilder.json().serializationInclusion(JsonInclude.Include.NON_NULL) // Don’t include null values
                .featuresToDisable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS) // use ISODate and not Timestamps
                .modules(new JavaTimeModule()).build();
    }

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    @Bean
    @Qualifier("primary")
    public SosRepository primaryRepository(final RestTemplate restTemplate) {
        return new SosRepository(restTemplate, "http://primary.sos.agileinfra.io");
    }


    @Bean
    @Qualifier("fallback")
    public SosRepository fallbackRepository(final RestTemplate restTemplate) {
        return new SosRepository(restTemplate, "http://fallback.sos.agileinfra.io");
    }

    @Bean
    public TrafficJob trafficJob(@Qualifier("primary") final SosRepository primary, @Qualifier("fallback") SosRepository fallback) {
        return new TrafficJob(primary, fallback);
    }
}
