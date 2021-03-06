#!/usr/bin/env ruby
require "awesome_print"
require 'table_print'
require 'dotenv'
require_relative "workspace"

Dotenv.load

def ask_for_action
  puts "* Select from the options below:"
  puts "* list users"
  puts "* list channels"
  puts "* select user"
  puts "* select channel"
  puts "* details"
  puts "* send message"
  puts "* quit" 
  puts
end

def prompt_to_select_user(workspace)
  puts "Enter a name or Slack ID:"
  identifier = gets.chomp
  user = workspace.select_user(identifier)
  if user
    return "user #{identifier} selected"
  else
    return "user #{identifier} was not found"
  end
end

def prompt_to_select_channel(workspace)
  puts "Enter a channel name or Slack ID:"
  identifier = gets.chomp
  channel = workspace.select_channel(identifier)
  if channel
    return "channel #{identifier} selected"
  else
    return "channel #{identifier} was not found"
  end
end

def perform_action(action, workspace)
  case action
  when "list users"
    tp workspace.users, "slack_id", "name", "username"
  when "list channels"
    tp workspace.channels, "slack_id", "name", "topic", "member_count"
  when "select user"
    puts prompt_to_select_user(workspace)
  when "select channel"
    puts prompt_to_select_channel(workspace)
  when "details"
    puts workspace.show_details
  when "send message"
    puts workspace.send_message
  end
  puts
end

def main
  puts "Welcome to the Ada Slack CLI!"
  workspace = Workspace.new

  puts "Number of users loaded = #{workspace.users.length}" 
  puts "Number of channels loaded = #{workspace.channels.length}"
  puts
  ask_for_action
  action = gets.chomp.downcase
  until action == "quit"
    perform_action(action, workspace)
    ask_for_action
    action = gets.chomp.downcase
  end
  
  puts "Thank you for using the Ada Slack CLI"
end

main if __FILE__ == $PROGRAM_NAME