require 'rails_helper'

RSpec.describe Project do
    describe "initialization" do
        let(:project) { Project.new }
        let(:task) { Task.new }

        it "contains a project with no tasks to be done" do
            
            expect(project.done?).to be_truthy
            
            
        end
        
        it "knows that a project with an incomplete task is not done" do
                
                project.tasks << task
                expect(project.done?).to be_falsy
            end
            
        it "can distinguish a completed task" do
            task = Task.new
            expect(task).not_to be_complete
            task.mark_completed
            expect(task).to be_complete
        end
        
        it "" do
            project.tasks << task
            task.mark_completed
            expect(project).to be_done
        end
        
        it "properly estimates a blank project" do
            expect(project.completed_velocity).to eq(0)
            expect(project.current_rate).to eq(0)
            expect(project.projected_days_remaining.nan?).to be_truthy
            expect(project).not_to be_on_schedule
        end
    end
    
    describe "estimates" do
        let(:project) { Project.new }
        let(:newly_done) { Task.new(size: 3, completed_at: 1.day.ago) }
        let(:old_done) { Task.new(size: 2, completed_at: 6.months.ago) }
        let(:small_not_done) { Task.new(size: 1) }
        let(:large_not_done) { Task.new(size: 4) }
        
        before(:example) do
            project.tasks = [newly_done, old_done, small_not_done, large_not_done]
        end
        
        it "can calculate total size" do
            expect(project.total_size).to eq(10)
        end
        
        it "can calculate remaining size" do
            expect(project.remaining_size).to eq(5)
        end
        
        it "knows its velocity" do
            expect(project.completed_velocity).to eq(3)
        end
        
        it "knows its rate" do
            expect(project.current_rate).to eq(1.0/7)
        end
        
        it "knows its projected time remaining" do
            expect(project.projected_days_remaining).to eq(35)
        end
        
        it "knows if it is on schedule" do
            project.due_date = 1.week.from_now
            expect(project).not_to be_on_schedule
            project.due_date = 6.months.from_now
            expect(project).to be_on_schedule
        end
        
        
    end
    
    describe "velocity" do
        let(:task) { Task.new(size: 3) }
        
        it "does not count an incomplete task toward velocity" do
            expect(task).not_to be_part_of_velocity
            expect(task.points_toward_velocity).to eq(0)
        end
        
        it "does not count a long-ago task toward velocity" do
            task.mark_completed(6.months.ago)
            expect(task).not_to be_part_of_velocity
            expect(task.points_toward_velocity).to eq(0)
        end
        
        it "counts a recently completed task toward velocity" do
            task.mark_completed(1.day.ago)
            expect(task).to be_part_of_velocity
            expect(task.points_toward_velocity).to eq(3)
        end
        
        
    end
end