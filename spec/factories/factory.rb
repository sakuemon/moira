require 'moira/domain/column'

FactoryGirl.define do

  factory :column_1, aliases: [:pk], class: Moira::Domain::Column do
    name :column_1.to_s
    comment :column_1.to_s + '_comment'
    type 'int(11)'
    nullable false
  end

  factory :column_2, aliases: [:varchar2], class: Moira::Domain::Column do
    name :column_2.to_s
    comment 'comment'
    type 'varchar2(256)'
    nullable true
  end

  factory :table, class: Moira::Domain::Table do
    name :table.to_s
    comment :table.to_s + "_comment"
    cols [FactoryGirl.build(:column_1)]
  end


  factory :schema, class: Moira::Domain::Schema do
    name :schema.to_s
    tables [FactoryGirl.build(:table)]
  end
end
