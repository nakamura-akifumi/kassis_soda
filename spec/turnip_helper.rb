# spec/turnip_helper.rb
require 'rails_helper'

Dir.glob("spec/steps/**/*") { |f| load f, true }