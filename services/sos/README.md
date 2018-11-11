Build and run in test mode (h2):  
- `mvn clean install && java -jar target/sos-0.0.1-SNAPSHOT.jar --spring.jpa.generate-ddl=true`

Test stack with (H2):  
- http http://fallback.sos.agileinfra.io/actuator/health
- http http://primary.sos.agileinfra.io/actuator/health
- http http://fallback.sos.agileinfra.io/api/events
- http http://primary.sos.agileinfra.io/api/events
- http http://primary.consul.agileinfra.io
- http -a 'sos:hademo' --follow http://primary.consul.agileinfra.io
- http -a 'sos:hademo' --follow http://fallback.consul.agileinfra.io
- http POST http://fallback.sos.agileinfra.io/api/events timestamp=`date -u +"%Y-%m-%dT%H:%M:%SZ"` sensorBusinessId='sbid-1' state='off'
- http POST http://fallback.sos.agileinfra.io/api/events timestamp=`date -u +"%Y-%m-%dT%H:%M:%SZ"` sensorBusinessId='sbid-1' state='on'
- http http://primary.sos.agileinfra.io/api/events
