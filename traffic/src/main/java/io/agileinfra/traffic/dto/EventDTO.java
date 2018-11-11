package io.agileinfra.traffic.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Created by <a href="mailto:louis.gueye@domo-safety.com">Louis Gueye</a>.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = {"sensorBusinessId", "timestamp"})
@Builder
public class EventDTO {
    private String id;
    private Instant insertedAt;
    private Instant timestamp;
    private String sensorBusinessId;
    private SensorState state;
}
