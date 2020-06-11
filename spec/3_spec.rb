# frozen_string_literal: true

require "spec_helper"
require "ostruct"

RSpec.describe "matcher DSL" do
  # If you want to make a fluid, natual-to-read spec, you can generate your own
  # matchers using RSpec's DSL:

  RSpec::Matchers.define :be_a_good_talk do |_expected|
    # 1
    match do |actual|
      actual.author == "Paul"
    end

    # 2
    description do
      "be the best talk ever"
    end

    # 3
    failure_message do |actual|
      "the author should be Paul, but it is #{actual.author}"
    end

    # 4
    failure_message_when_negated do |actual|
      "not a good talk, but the author was #{actual.author}, so it has to be"
    end
  end

  subject(:talk) { OpenStruct.new(author: "Paul") }

  it { should be_a_good_talk }
  it { should_not be_a_good_talk }

  context "when the author isn't Paul" do
    subject(:talk) { OpenStruct.new(author: "Not Paul") }

    it { should be_a_good_talk }
    it { should_not be_a_good_talk }
  end

  RSpec::Matchers.define :be_authored_by do |expected|
    match do |actual|
      @actual = actual.author
      @actual == expected
    end

    diffable
  end

  fit { should be_authored_by("Paul") }
  fit { should be_authored_by("Brian") }
end
