require 'spec_helper'

describe Rdbdocumentor::DB::MysqlInfo do
  context 'when inspect wordpress tables to db' do
    db = Rdbdocumentor::DB::MysqlInfo.new('127.0.0.1', 'root', 'AriochGG99', 'wordpress_test')

    subject {db}
    it {should_not be_nil}

    context 'tables' do
      tables = db.tables()

      it 'tables has 15 results' do
        tables.count.should eq 15
      end
    end

    context 'columns' do
      columns = db.columns('wp_posts')
      it 'columns has 23 results' do
        columns.count.should eq 23
      end
    end
  end
end