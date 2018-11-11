package io.agileinfra.sos.domain;

import io.agileinfra.sos.dto.EventDTO;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

/**
 * Created by <a href="mailto:louis.gueye@domo-safety.com">Louis Gueye</a>.
 */
@Component
public class EventToEventDTOConverter implements Converter<Event, EventDTO> {
    @Override
    public EventDTO convert(Event source) {
        if (source == null) return null;
        return EventDTO.builder().id(source.getId()).insertedAt(source.getInsertedAt()).sensorBusinessId(source.getSensorBusinessId()).state(source.getState()).timestamp(source.getTimestamp()).build();
    }
}
