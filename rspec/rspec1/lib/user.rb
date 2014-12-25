require 'date'

class User
  attr_accessor :name, :birthday, :nationality, :likes

  def initialize(name: , birthday:, nationality: )
    @name = name
    @birthday = birthday
    @nationality = nationality
    @likes ||= []
  end

  def age
    @age ||= begin
                format = "%Y%m%d"
                (Date.today.strftime(format).to_i - @birthday.strftime(format).to_i) / 10000
              end
  end

  def greet
    case @nationality
    when :ja
      'こんにちは'
    when :en
      'Hello!'
    else
      '...'
    end
  end

  def describe
    "私の名前は #{self.name} です。年齢は #{self.age} 歳で、趣味は #{self.likes.join(', ')} です。"
  end
end
