# frozen_string_literal: true

require "spec_helper"

RSpec.describe "negated matcher" do
  # You can take an existing matcher, and create a "negated" version.

  subject(:list) { 1.upto(10).to_a }

  before { list.delete(5) }

  # specify { expect(list).to_not include(5) }
  it { should_not include(5) }

  RSpec::Matchers.define_negated_matcher :exclude, :include
  specify do
    expect { list.delete(4) }
      .to change { list }.to(exclude(4) )
  end

  specify do
    expect { list.delete(4) }
      .to change { list }.to exclude(4)
      .and exclude(5)
  end
end
