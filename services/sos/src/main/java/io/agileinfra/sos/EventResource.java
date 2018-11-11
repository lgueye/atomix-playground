package io.agileinfra.sos;

import io.agileinfra.sos.dto.EventDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Created by <a href="mailto:louis.gueye@domo-safety.com">Louis Gueye</a>.
 */
@RestController(value = "/api/events")
@RequiredArgsConstructor
@Slf4j
public class EventResource {
    private final EventService service;

    @PostMapping
    public void post(@RequestBody final EventDTO event) {
        service.create(event);
    }

    @GetMapping
    public List<EventDTO> read() {
        return service.finadAll();
    }
}
