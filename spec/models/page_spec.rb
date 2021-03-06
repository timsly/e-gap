require 'spec_helper'

describe Page do
  it { should validate_presence_of :title }
  it { should validate_uniqueness_of :title }
  it { should validate_presence_of :content }
  
  context "published/unpublished" do
    let(:published_page) { create :published_page }
    let(:unpublished_page) { create :unpublished_page }
    let(:published_1_day_ago) { create :page, published_on: 1.day.ago }
    let(:published_tomorrow) { create :page, published_on: DateTime.tomorrow }
    
    describe '#published?' do
      it "should detect publshed page" do
        expect(published_page).to be_published
        expect(unpublished_page).not_to be_published
      end
      
      it "should be published if published_on is is set to sometime in the past" do
        expect(published_1_day_ago).to be_published
      end
    end

    describe '#unpublished?' do
      it "should detect unpublshed page if published_on is nil" do
        expect(unpublished_page).to be_unpublished
        expect(published_page).not_to be_unpublished
      end
      
      it "should be unpublished if published_on is is set to sometime in the future" do
        expect(published_tomorrow).to be_unpublished
      end
    end
    
    describe "#publish" do
      it "should publish page" do
        expect(unpublished_page.publish).to be_published
      end
    end
    
    describe "#unpublish" do
      it "should unpublish page" do
        expect(published_page.unpublish).to be_unpublished
      end
    end
        
    context "scopes and class methods" do
      describe "#published" do
        subject { Page.published }
        
        it { should include published_page }
        it { should include published_1_day_ago }
        it { should_not include unpublished_page }
        it { should_not include published_tomorrow }
      end
      
      describe "#unpublished" do
        subject { Page.unpublished }
        
        it { should include unpublished_page }
        it { should include published_tomorrow }
        it { should_not include published_page }
        it { should_not include published_1_day_ago }
      end
    end
  end
  
  describe "#total_words" do
    let(:page) { create :page, title: 'Word1', content: 'Word2 Word3' }
    
    it "returns the total number of words (title and content)" do
      expect(page.total_words).to be 3
    end
  end
end
