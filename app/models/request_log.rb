class RequestLog < ApplicationRecord
  attr_reader :days

  def days
    DateTime.now.to_i - self.created_at.to_i
  end
end
