require "rails_helper"

describe CreatesProject do
    it "" do
        creator = CreatesProject.new(name: "Project Runway")
        creator.build
        expect(creator.project.name).to eq("Project Runway")
    end
end

describe "task string parsing" do
    let(:creator) { CreatesProject.new(name: "Test", task_string: task_string) }
    let(:tasks) { creator.convert_string_to_tasks }
    
    describe "with an empty string" do
        let(:task_string) { "" }
        specify { expect(tasks.size).to eq(0) }
    end
    
    describe "" do
        let(:task_string) { "Start things:3\nEnd things:2" }
        it "" do
            creator.create
            expect(creator.project.tasks.size).to eq(2)
            expect(creator.project).not_to be_new_record
        end
    end
end