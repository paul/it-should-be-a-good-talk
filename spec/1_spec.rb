# frozen_string_literal: true

require "spec_helper"

RSpec.describe "predicate matchers" do
  # The simplest custom matcher is the "predicate matcher". If the subject has
  # a "question mark" method, then the `be_` matcher will call that method.

  specify { expect([]).to be_empty }

  specify { expect([]).to_not be_foo }

  class Result
    def success?
      true
    end

    def failure?
      false
    end
  end

  specify { expect(Result.new).to be_success }

  # You can also do `be_a_X`:
  specify { expect(Result.new).to be_a_success }
  specify { expect(Result.new).to_not be_a_failure }
end
