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
    context "github connection" do
      before :each do
        @github_connector = Inator::Connector.new(YAML.load_file('./spec/configs/github.yml'))
        @github_endpoint = "repos/RallyCommunity/open-closed-defects-chart/commits"
      end
      it "returns all commits" do
        status, headers, body = @github_connector.make_request(:get, @github_endpoint)
        result = JSON.parse(body)
        expect(result.length).to eql(6)
      end
      it "limit results by date" do
        since = {since: '2015-03-01'}
        status, headers, body = @github_connector.make_request(:get, @github_endpoint, since)
        date_limited_result = JSON.parse(body)
        expect(date_limited_result.length).to eql(2)
      end
    end
  end
end