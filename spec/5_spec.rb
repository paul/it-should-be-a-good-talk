# frozen_string_literal: true

require "spec_helper"
require "rspec/resembles_json_matchers"

RSpec.describe "fuzzy-matching JSON" do
  include RSpec::ResemblesJsonMatchers
  subject(:document) do
    {
      name: "Paul",
      id: 42,
      title: "Cool Dude",
    }
  end

  it do
    should resemble_json({
                           name: "whatever",
                           id: 1,
                           title: "anything"
                         })
  end

  describe "nesting" do
    subject(:document) do
      {
        users: [
          {
            name: "Paul",
            id: 42,
            title: "Cool Dude",
          }
        ]
      }
    end
    it do
      should resemble_json(
        { users: [{
          name: "whatever",
          id: 1,
          title: "anything"
        }] }
      )
    end
  end
end
