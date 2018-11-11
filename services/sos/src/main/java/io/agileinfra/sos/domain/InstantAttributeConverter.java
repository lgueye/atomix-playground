package io.agileinfra.sos.domain;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;
import java.time.Instant;

@Converter(autoApply = true)
public class InstantAttributeConverter implements AttributeConverter<Instant, Long> {
	@Override
	public Long convertToDatabaseColumn(Instant entityValue) {
		if (entityValue == null) {
			return null;
		}

		return entityValue.toEpochMilli();
	}

	@Override
	public Instant convertToEntityAttribute(Long databaseValue) {
		if (databaseValue == null) {
			return null;
		}

		return Instant.ofEpochMilli(databaseValue);
	}
}
