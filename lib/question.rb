class Question
  attr_reader :text, :variants, :answer, :points, :time_to_answer

  def initialize(text, variants, answer, points, time_to_answer)
    @text = text
    @variants = variants.shuffle
    @answer = answer
    @points = points.to_i
    @time_to_answer = time_to_answer.to_i
  end

  def answer_correct?(answer_index)
    variants[answer_index - 1] == answer
  end

  def to_s
    <<~QUESTION
      #{text} (#{points} pts., #{time_to_answer} seconds to answer)

      #{variants.map.with_index(1) { |var, i| "#{i}. #{var}"}.join("\n") }
    QUESTION
  end
end
