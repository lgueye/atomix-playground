package io.agileinfra.sos.domain;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.engine.spi.SharedSessionContractImplementor;
import org.hibernate.id.IdentifierGenerator;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * @author louis.gueye@gmail.com
 */
public class CockroachUUIDGenerationStrategy implements IdentifierGenerator {
    @Override
    public Serializable generate(SharedSessionContractImplementor session, Object object) throws HibernateException {
        return ((Session) session).doReturningWork(connection -> {
            try (
                    Statement statement = connection.createStatement();
                    ResultSet resultSet = statement.executeQuery(
                            "select gen_random_uuid()"
                    )
            ) {
                if (!resultSet.next())
                    throw new IllegalArgumentException("Can't fetch a new UUID");
                return resultSet.getString(1);
            }
        });
    }
}
