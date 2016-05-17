require 'inator'

describe Inator do
  describe "#make_request" do
    context "rally connection" do
      before :each do
        @rally_connector = Inator::Connector.new(YAML.load_file('./spec/configs/rally.yml'))
        @fetch = 'FormattedID,State'
        @endpoint = 'defect'
      end
      it "total result count is 0 when state=foobar" do
        query = '(State = Foobar)'
        status, headers, body = @rally_connector.make_request(:get, @endpoint, {fetch: @fetch, query: query})
        result = JSON.parse(body)
        total_result_count = result["QueryResult"]["TotalResultCount"]
        expect(total_result_count).to eql(0)
      end
      it "total result count is greater than 0 when state=fixed" do
        query = '(State = Fixed)'
        status, headers, body = @rally_connector.make_request(:get, @endpoint, {fetch: @fetch, query: query})
        result = JSON.parse(body)
        total_result_count = result["QueryResult"]["TotalResultCount"]
        expect(total_result_count).to be > 0
      end
    end
  end
end