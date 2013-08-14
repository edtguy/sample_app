require 'spec_helper'

describe "MicropostPages" do

  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  
  describe "micropost creation" do
    before { visit root_path }
    
    describe "with invalid information" do
    
      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end
      
      describe "error message" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end
    
    describe "with valid information" do
    
      describe "zero micropost state" do
        it { should have_content('0 microposts') }
      end
      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end
  
  describe "one micropost state" do
    it "should have one micropost" do
      expect { Micropost.count == 1 }
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }
    
    describe "as correct user" do
      before {visit root_path}
      
      describe "one micropost state" do
        it { should have_content('1 micropost') }
        it { should_not have_content('1 microposts') }
      end
      
      describe "two micropost state" do
        before { FactoryGirl.create(:micropost, user: user) }
        before { visit root_path }
        it { should have_content('2 microposts') }
      end
      
      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end
