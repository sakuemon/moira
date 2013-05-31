require 'spec_helper'

describe Moira::Domain::Column do
  context "when new with name" do
    before do
      @c = FactoryGirl.build(:column_1)
    end
    subject {@c}

    its(:name) {should eq :column_1.to_s}
    its(:comment) {should eq :column_1.to_s + '_comment'}
    its(:type) {should eq 'int(11)'}
    its(:nullable) {should be_false}

  end

  context "when new with name and comment" do
    before do
      @c = FactoryGirl.build(:column_2)
    end
    subject {@c}

    its(:name) {should eq :column_2.to_s}
    its(:type) {should eq 'varchar2(256)'}
    its(:comment) {should eq 'comment'}
    its(:nullable) {should be_true}
  end
end
