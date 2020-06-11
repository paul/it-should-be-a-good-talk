# frozen_string_literal: true

require "spec_helper"

# Provides a nicer matcher and failure output when testing if a particular
# ActiveRecord model is included in a relation
RSpec::Matchers.define :include_record do |expected|
  diffable

  match do |collection|
    @actual = pp_rel(collection)
    ids = collection.map(&:id)
    ids.include? expected.id
  end

  description do
    %{include record #{pp_record(expected)}}
  end

  failure_message do |_actual|
    %{Expected collection to include record %<expected>, but it was missing from %<actual>} % {
      expected: pp_record(expected),
      actual: @actual
    }
  end

  failure_message_when_negated do |_actual|
    %{Expected collection to not include record %<expected>, but it was present in %<actual>} % {
      expected: pp_record(expected),
      actual: @actual
    }
  end

  def pp_record(record)
    attr, val = %i[name title slug to_param]
                .lazy
                .detect { |attr| record.respond_to?(attr) }
                .then { |attr| [attr, record.send(attr)] }
    %{#<%s:%d %s: %s>} % [record.class, record.id, attr.to_s, val.inspect]
  end

  def pp_rel(rel)
    %{[#{rel.map { |rec| pp_record(rec) }.join(', ')}]}
  end
end

Person = Struct.new(:id, :name, :biography, keyword_init: true)

RSpec.describe "include vs include_record" do
  let(:list) { [Person.new(id: 1, name: "Paul", biography: "A lot of really long text we don't care about at all")] }
  let(:paul) { Person.new(id: 1, name: "Paul") }
  let(:brooke) { Person.new(id: 2, name: "Brooke") }

  specify { expect(list).to include(paul) }
  specify { expect(list).to include_record(paul) }
  specify { expect(list).to include_record(brooke) }
end

RSpec.xdescribe "searching users" do
  subject(:results) { described_class.search(query) }

  let!(:chuck) { create :user, name: "Chuck Norris",  tags: ["walker",            "texas ranger"]   }
  let!(:bob)   { create :user, name: "Robert Norris", tags: ["used car salesman", "texas"]          }
  let!(:berry) { create :user, name: "Chuck Berry",   tags: ["musician",          "johnny b goode"] }

  context "by tag" do
    let(:query) { "texas" }

    it "should include contacts with tags that match partially" do
      expect(results).to     include_record(chuck)
      expect(results).to     include_record(bob)
      expect(results).to_not include_record(berry)
    end
  end
end
