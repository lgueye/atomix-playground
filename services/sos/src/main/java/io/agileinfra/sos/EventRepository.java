package io.agileinfra.sos;

import io.agileinfra.sos.domain.Event;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Created by <a href="mailto:louis.gueye@domo-safety.com">Louis Gueye</a>.
 */
public interface EventRepository extends JpaRepository<Event, Long> {
}
