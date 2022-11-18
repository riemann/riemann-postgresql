# frozen_string_literal: true

require 'riemann/tools'

# Reports PostgreSQL statistics to Riemann.
# http://www.postgresql.org/docs/9.2/static/monitoring-stats.html

module Riemann
  module Tools
    class Postgresql
      include Riemann::Tools
      require 'pg'

      opt :postgresql_host, 'PostgreSQL Server Hostname', type: String, default: 'localhost'
      opt :postgresql_port, 'PostgreSQL Server Port', default: 5432
      opt :postgresql_username, 'Authenticated username', type: String, default: 'postgres'
      opt :postgresql_password, "User's password", type: String, default: 'postgres'
      opt :postgresql_database, 'Database to connect', type: String, default: 'postgres'

      def initialize
        @conn = PG.connect(host: opts[:postgresql_host],
                           port: opts[:postgresql_port],
                           user: opts[:postgresql_username],
                           password: opts[:postgresql_password],
                           dbname: opts[:postgresql_database],)
      rescue PG::Error
        puts 'Error: Unable to connect with PostgreSQL server.'
        exit 1
      end

      def tick
        @conn.transaction do
          # General DB statistics.
          @conn.exec("DECLARE general CURSOR FOR SELECT pg_stat_database.*, pg_database_size \
                  (pg_database.datname) AS size FROM pg_database JOIN pg_stat_database ON \
                  pg_database.datname = pg_stat_database.datname WHERE pg_stat_database.datname \
                  NOT IN ('template0', 'template1', 'postgres')")

          result = @conn.exec('FETCH ALL IN general')

          keys = result.fields.collect.to_a
          result.values.collect do |row|
            vals = row.collect.to_a
            vals.each_with_index do |_val, index|
              next unless index > 1

              report(
                host: opts[:postgresql_host].dup,
                service: "DB #{vals[1]} #{keys[index]}",
                metric: vals[index].to_f,
                state: 'ok',
                description: "PostgreSQL DB #{keys[index]}".gsub('_', ' '),
                tags: ['postgresql'],
              )
            end
          end

          # Each DB specific connection counts.
          @conn.exec("DECLARE connection CURSOR FOR SELECT datname, count(datname) FROM pg_stat_activity \
                  GROUP BY pg_stat_activity.datname")

          result = @conn.exec('FETCH ALL IN connection')
          result.values.collect do |row|
            vals = row.collect.to_a
            report(
              host: opts[:postgresql_host].dup,
              service: "DB #{vals[0]} connections",
              metric: vals[1].to_f,
              state: 'ok',
              description: 'PostgreSQL DB Connections',
              tags: ['postgresql'],
            )
          end
        end
      end
    end
  end
end
