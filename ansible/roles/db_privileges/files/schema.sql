DROP TABLE IF EXISTS events_timeline CASCADE;

CREATE TABLE events_timeline (
  event_id    VARCHAR(255) NOT NULL,
  state       VARCHAR(50)  NOT NULL,
  inserted_at BIGINT       NOT NULL,
  timestamp   BIGINT       NOT NULL,
  sensor_bid  VARCHAR(255) NOT NULL,
  PRIMARY KEY (event_id)
);

CREATE INDEX idx_events_timeline_sensor_bid
  ON events_timeline (sensor_bid);
CREATE INDEX idx_events_timeline_timestamp
  ON events_timeline (timestamp);
ALTER TABLE events_timeline
  ADD CONSTRAINT idx_events_timeline_uniq UNIQUE (sensor_bid, timestamp);
