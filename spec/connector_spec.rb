require 'connector'

describe Connector do
  before :each do
    @connector = Inator::Connector.new(YAML.load_file('./spec/configs/rally.yml'))
  end
  describe "#new" do
    it "returns a Connector object" do
        expect(@connector).to be_an_instance_of Inator::Connector
    end
  end
end