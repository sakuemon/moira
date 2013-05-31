require 'spec_helper'

describe Rdbdocumentor::Domain::Schema do
  context "when new with name and no tables" do
    before do
      @s = FactoryGirl.build(:schema)
    end

    subject {@s}

    its(:name) {should eq :schema.to_s}
    its(:tables) {should_not be_empty}
 end
end
