require 'spec_helper'
require 'rspec-html-matchers'

describe Rdbdocumentor::HtmlTransformer do
  context 'when transform' do
    before do
      @s = FactoryGirl.build(:schema)
      @table = FactoryGirl.build(:table)
      @tables = [@table]
      @t = Rdbdocumentor::HtmlTransformer.new()
    end

    subject {@t.transform_table(@s, @table)}

    it {should have_tag('title', :text => 'schema|table')}
    it {should have_tag('header h1', :text => 'schema')}
    it {should have_tag('aside.list nav ul li:first', :text => 'table')}
    it {should have_tag('section.detail article h2', :text => 'table')}
    it {should have_tag('section.detail article p', :text => 'table_comment')}

	end
end
