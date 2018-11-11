package io.agileinfra.sos.domain;

import io.agileinfra.sos.dto.SensorState;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.time.Instant;

/**
 * Created by <a href="mailto:louis.gueye@domo-safety.com">Louis Gueye</a>.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = {"sensorBusinessId", "timestamp"})
@Builder
@Entity
@Table(name = "events_timeline", indexes = {@Index(name = "idx_events_timeline_uniq", columnList = "sensor_bid,timestamp"),
        @Index(name = "idx_events_timeline_sensor_bid", columnList = "sensor_bid"),
        @Index(name = "idx_events_timeline_timestamp", columnList = "timestamp")})
public class Event {
    @Id
    @GeneratedValue(generator = "cockroach_uuid")
    @GenericGenerator(name = "cockroach_uuid", strategy = "io.agileinfra.sos.domain.CockroachUUIDGenerationStrategy")
    @Column(name = "event_id")
    private String id;

    @Column(name = "inserted_at", columnDefinition = "BIGINT", nullable = false)
    @NotNull
    private Instant insertedAt;

    @Column(name = "timestamp", columnDefinition = "BIGINT", nullable = false)
    @NotNull
    private Instant timestamp;

    @Column(name = "sensor_bid", nullable = false)
    @NotNull
    @Size(max = 255)
    private String sensorBusinessId;

    @Column(length = 50, nullable = false)
    @Enumerated(EnumType.STRING)
    @NotNull
    private SensorState state;

}
