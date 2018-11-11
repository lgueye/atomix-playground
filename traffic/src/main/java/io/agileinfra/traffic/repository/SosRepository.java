package io.agileinfra.traffic.repository;

import io.agileinfra.traffic.dto.EventDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.List;

/**
 * Created by <a href="mailto:louis.gueye@domo-safety.com">Louis Gueye</a>.
 */
@RequiredArgsConstructor
@Slf4j
public class SosRepository {
    private final RestTemplate restTemplate;
    private final String domain;
    public boolean available() {
        try {
            final HttpEntity<String> entity = new HttpEntity<>(new HttpHeaders());
            final URI uri = UriComponentsBuilder.fromHttpUrl(domain).path("actuator").path("health").build().encode().toUri();
            restTemplate.exchange(uri, HttpMethod.HEAD, entity, Void.class);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public void create(EventDTO event) {
        try {
            final HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            final HttpEntity<EventDTO> entity = new HttpEntity<>(event, headers);
            final URI uri = UriComponentsBuilder.fromHttpUrl(domain).path("api").path("events").build().encode().toUri();
            restTemplate.exchange(uri, HttpMethod.POST, entity, Void.class);
            log.info(">> {} successfully processed event {}", domain, event);
        } catch (Exception e) {
          log.error("/!\\ {} failed to process event {}", domain, event);
        }
    }

    public List<EventDTO> findAll() {
        try {
            final URI uri = UriComponentsBuilder.fromHttpUrl(domain).path("api").path("events").build().encode().toUri();
            final HttpEntity<Void> entity = new HttpEntity<>(new HttpHeaders());
            return restTemplate.exchange(uri, HttpMethod.GET, entity, new ParameterizedTypeReference<List<EventDTO>>() {
            }).getBody();
        } catch (Exception e) {
            log.debug("/!\\ {} failed to fetch events", domain);
            throw new IllegalStateException("/!\\ "+domain+" failed to fetch events");
        }
    }
}
