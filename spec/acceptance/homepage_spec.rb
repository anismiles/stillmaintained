require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Homepage', %q{
  In order to feel welcome
  As a guest
  I want to have a nice homepage
} do

  describe 'the homepage' do

    background do
      [User, Project].each { |model| model.delete_all }

      Project.make(
        :name => "project1",
        :state => 'maintained',
        :user => 'alice',
        :visible => true,
        :description => 'project1 description'
      )
    end

    scenario "Visit the homepage" do
      visit '/'
      page.should.has_content? 'Still Maintained?'
    end

    scenario 'show every project in a list' do
      Project.make(:name => "project2", :user => 'bob')

      visit '/'

      page.should.has_content? "alice/project1"
      page.should.has_content? "bob/project2"
    end

    scenario 'do not show any invisible projects' do
      Project.make(:name => "project2", :user => 'bob', :visible => false)

      visit '/'

      page.should.has_content? "alice/project1"
      page.should.has_no_content? "bob/project2"
    end

    scenario 'do not show any forks' do
      Project.make(:name => "project2", :user => 'bob', :fork => true)

      visit '/'

      page.should.has_content? "alice/project1"
      page.should.has_no_content? "bob/project2"
    end

    scenario 'show the project descriptions' do
      visit '/'

      page.should.has_content? 'project1 description'
    end

    scenario 'click on a project name' do
      visit '/'

      click_link 'project1'

      page.should.has_content? 'project1 is still being maintained'
    end

    scenario 'click the "show all projects" link' do
      visit '/'
      click_link 'show all projects'

      page.should.has_content? '1 projects'
    end

    scenario 'search a project' do
      visit '/'

      fill_in 'q', :with => 'project1'
      click_button 'Search'
      page.should.has_content? '1 projects'
    end

  end

end
