require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { FactoryBot.create(:project) }

  it "provides methods for statuses" do
    project.pending!
    expect(project.pending?).to be(true)
    expect(project.wip?).to be(false)

    project.wip!
    expect(project.pending?).to be(false)
    expect(project.wip?).to be(true)
  end

  it "name cannot be empty" do
    project.name = ""
    expect(project.save).to be(false)
  end

  it "name cannot be nil" do
    project.name = nil
    expect(project.save).to be(false)
  end
end
