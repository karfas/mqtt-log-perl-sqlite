CREATE TABLE mqtt_log(
    mql_id      INTEGER         PRIMARY KEY
                                NOT NULL
                                AUTOINCREMENT
  , mql_time_utc DATETIME       NOT NULL
                                DEFAULT (datetime('now'))
  , mql_time    DATETIME        NOT NULL
                                DEFAULT (datetime('now', 'localtime'))
  , mql_topic   NVARCHAR(254)   NOT NULL
  , mql_value   NVARCHAR(254)   NOT NULL
  );
CREATE index idx_mqtt_log_topic ON mqtt_log(
    mql_topic, mql_time_utc);
