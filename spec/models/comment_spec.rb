require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:project) { FactoryBot.create(:project) }
  let(:comment) { FactoryBot.create(:comment, project: project) }

  it "content cannot be empty" do
    comment.content = ""
    expect(comment.save).to be(false)
  end

  it "content cannot be nil" do
    comment.content = nil
    expect(comment.save).to be(false)
  end
end
