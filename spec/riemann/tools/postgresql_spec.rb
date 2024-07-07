# frozen_string_literal: true

require 'riemann/tools/postgresql'

RSpec.describe Riemann::Tools::Postgresql do
  describe('#tick') do
    let(:general_fields) { %w[datid datname numbackends xact_commit xact_rollback blks_read blks_hit tup_returned tup_fetched tup_inserted tup_updated tup_deleted conflicts temp_files temp_bytes deadlocks checksum_failures checksum_last_failure blk_read_time blk_write_time stats_reset size] }
    let(:general_values) do
      [
        %w[32768 pakotoa_development 0 5190 1 156 218306 3480939 37885 0 0 0 0 0 0 0 nil nil 0 0 2022-11-12 13:50:09.308897-10 8704559],
        %w[32927 pakotoa_test 0 1146 14 871 56655 170965 27329 794 669 4 0 0 0 0 nil nil 0 0 2022-11-18 07:31:43.057234-10 8614447],
      ]
    end
    let(:connection_fields) { %w[datname count] }
    let(:connection_values) do
      [
        %w[template1 4],
        %w[postgres 1],
        [nil, '0'],
      ]
    end

    before do
      general_result = double
      allow(general_result).to receive_messages(fields: general_fields, values: general_values)

      connection_result = double
      allow(connection_result).to receive_messages(fields: connection_fields, values: connection_values)

      conn = double
      allow(conn).to receive(:transaction).and_yield
      allow(conn).to receive(:exec).with(/\ADECLARE [a-z]+ CURSOR FOR/)
      allow(conn).to receive(:exec).with(/\AFETCH ALL IN general/).and_return(general_result)
      allow(conn).to receive(:exec).with(/\AFETCH ALL IN connection/).and_return(connection_result)

      allow(PG).to receive(:connect).and_return(conn)
      allow(subject).to receive(:report) # RSpec/SubjectStub
      subject.tick
    end

    it { is_expected.to have_received(:report).with(hash_including(service: 'DB pakotoa_development tup_returned', metric: 3_480_939, state: 'ok', description: 'PostgreSQL DB tup returned')) }
    it { is_expected.to have_received(:report).with(hash_including(service: 'DB template1 connections', metric: 4, state: 'ok', description: 'PostgreSQL DB Connections')) }
  end
end
