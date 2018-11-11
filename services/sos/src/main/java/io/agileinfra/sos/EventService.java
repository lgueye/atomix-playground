package io.agileinfra.sos;

import io.agileinfra.sos.domain.Event;
import io.agileinfra.sos.domain.EventDTOToEventConverter;
import io.agileinfra.sos.domain.EventToEventDTOConverter;
import io.agileinfra.sos.dto.EventDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Created by <a href="mailto:louis.gueye@domo-safety.com">Louis Gueye</a>.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class EventService {

    private final EventRepository repository;
    private final EventDTOToEventConverter dtoToDomainConverter;
    private final EventToEventDTOConverter domainToDtoConverter;

    void create(EventDTO event) {
        final Event domain = dtoToDomainConverter.convert(event);
        if (domain != null) {
            domain.setInsertedAt(Instant.now());
            repository.save(domain);
        }
    }

    List<EventDTO> finadAll() {
        return repository.findAll().stream().map(domainToDtoConverter::convert).collect(Collectors.toList());
    }
}
