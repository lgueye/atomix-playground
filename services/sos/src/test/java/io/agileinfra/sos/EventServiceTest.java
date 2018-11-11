package io.agileinfra.sos;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JSR310Module;
import io.agileinfra.sos.dto.EventDTO;
import io.agileinfra.sos.dto.SensorState;
import org.junit.Test;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;

import java.time.Duration;
import java.time.Instant;

/**
 * Created by <a href="mailto:louis.gueye@domo-safety.com">Louis Gueye</a>.
 */
public class EventServiceTest {

    @Test
    public void test() throws JsonProcessingException {
        final String id = "1";
        final String json = Jackson2ObjectMapperBuilder.json().serializationInclusion(JsonInclude.Include.NON_NULL) // Don’t include null
                // values
                .featuresToDisable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS) // ISODate
                .modules(new JSR310Module()).build().writeValueAsString(EventDTO.builder().id(id).insertedAt(Instant.now()).timestamp(Instant.now().minus(Duration.ofSeconds(1))).sensorBusinessId("sbid-" + id).state(SensorState.on).build());
        System.out.println("json = " + json);
    }
}
