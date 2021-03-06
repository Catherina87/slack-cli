require_relative 'test_helper'

describe "Workspace" do
  describe "#initialize" do
    it "Creates an instance of workspace" do
      VCR.use_cassette("list_users") do
        workspace = Workspace.new
        expect(workspace).wont_be_nil
        expect(workspace).must_be_kind_of Workspace
      end
    end

    it "Responds to users" do
      VCR.use_cassette("list_users") do
        workspace = Workspace.new
        expect(workspace).must_respond_to :users
        expect(workspace.users).must_be_kind_of Array
        workspace.users.each do |user|
          expect(user).must_be_kind_of User
        end
      end
    end

    it "Responds to channels" do
      VCR.use_cassette("list_channels") do
        workspace = Workspace.new
        expect(workspace).must_respond_to :channels
        expect(workspace.channels).must_be_kind_of Array
        workspace.channels.each do |channel|
          expect(channel).must_be_kind_of Channel 
        end
      end
    end
  end

  describe "#select_user" do
    it "selects existing user by assigning it to 'selected' variable" do
      VCR.use_cassette("list users") do
        workspace = Workspace.new
        workspace.select_user("USLACKBOT")
        expect(workspace.selected.slack_id).must_equal "USLACKBOT"
        expect(workspace.selected.name).must_equal "Slackbot"
      end
    end

    it "leaves 'selected' variable set to nil if user is not found" do
      VCR.use_cassette("list_users") do
        workspace = Workspace.new
        workspace.select_user("7ESHPU")
        expect(workspace.selected).must_be_nil 
      end
    end
  end

  describe "#select_channel" do
    it "selects existing channel by assigning it to 'selected' variable" do
      VCR.use_cassette("list_channels") do
        workspace = Workspace.new
        workspace.select_channel("random")
        expect(workspace.selected.name).must_equal "random"
      end
    end

    it "leaves 'selected' variable set to nil if channel is not found" do
      VCR.use_cassette("list_channels") do
        workspace = Workspace.new
        workspace.select_channel("nono")
        expect(workspace.selected).must_be_nil
      end
    end
  end

  describe "#show_details method" do
    it "shows details of the selected user" do
      VCR.use_cassette("list_users") do
        workspace = Workspace.new 
        user = workspace.select_user("USLACKBOT")
        expect(workspace.show_details.include? user.slack_id).must_equal true

      end
    end

    it "shows details of the selected channel" do 
      VCR.use_cassette("list_channels") do
        workspace = Workspace.new
        channel = workspace.select_channel("random")
        expect(workspace.show_details.include? channel.name).must_equal true
      end
    end

    it "returns 'No recipient is selected' if no recipient is selected" do
      VCR.use_cassette("list_users") do
        workspace = Workspace.new
        expect(workspace.show_details).must_equal "No recipient is selected"
      end
    end
  end

  describe "#send_message" do
    it "sends a message if recipient is selected" do
      VCR.use_cassette("post_message") do
        workspace = Workspace.new
        workspace.select_user("USLACKBOT")
        response = workspace.selected.send_message("Hello, Slackbot")
        
        expect(response["ok"]).must_equal true 
        expect(response["message"]["text"]).must_equal "Hello, Slackbot"

      end
    end

    it "does not send a message if recipient is not selected" do
      VCR.use_cassette("post_message") do 
        workspace = Workspace.new 
        expect(workspace.send_message).must_equal "No recipient is selected"
      end
    end
  end
end
