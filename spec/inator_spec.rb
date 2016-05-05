require 'inator'

describe Inator do
  before :each do
    @connector = Inator::Connector.new(YAML.load_file('./spec/configs/rally.yml'))
    @fetch = 'FormattedID,State'
    @endpoint = 'defect'
  end
  describe "#new" do
    it "returns a Connector object" do
        expect(@connector).to be_an_instance_of Inator::Connector
    end
  end
  describe "#make_request" do
    context "given query state=foobar" do
      it "total result count is 0 when state=foobar" do
        query = '(State = Foobar)'
        status, headers, body = @connector.make_request(:get, @endpoint, {fetch: @fetch, query: query})
        result = JSON.parse(body)
        total_result_count = result["QueryResult"]["TotalResultCount"]
        expect(total_result_count).to eql(0)
      end
    end
    context "given query state=fixed" do
      it "total result count is greater than 0 when state=fixed" do
        query = '(State = Fixed)'
        status, headers, body = @connector.make_request(:get, @endpoint, {fetch: @fetch, query: query})
        result = JSON.parse(body)
        total_result_count = result["QueryResult"]["TotalResultCount"]
        expect(total_result_count).to be > 0
      end
    end
  end
end