require 'spec_helper'

describe Moira::Domain::Table do
  context 'when new with name and comment' do
    before do
      @t = FactoryGirl.build(:table)
    end

    subject {@t}

    it {should_not be_nil}
    its(:name) {should eq :table.to_s}
    its(:comment) {should eq :table.to_s + "_comment"}
    its(:cols) {should_not be_empty}
  end
end
