require 'rexml/document'
require_relative 'question'

class Quiz
  def self.from_xml(xml_file_path)
    doc = REXML::Document.new(File.read(xml_file_path))

    questions =
      doc.get_elements('questions/question').map do |question_node|
        points = question_node['points'].to_i
        time_to_answer = question_node['seconds'].to_i
        text = question_node.get_elements('text').first.text
        variant_nodes = question_node.get_elements('variants/variant')
        variants = variant_nodes.map(&:text)
        answer = variant_nodes.find { |variant| variant['right'] == 'true' }.text

        Question.new(text, variants, answer, points, time_to_answer)
      end

    new(questions)
  end

  def initialize(questions)
    @questions = questions
    @right_answers = 0
    @score = 0
    @current_question_index = 0
  end

  def finished?
    current_question.nil?
  end

  def current_question
    @questions[@current_question_index]
  end

  def time_to_answer
    current_question.time_to_answer
  end

  def answer
    current_question.answer
  end

  def answer_correct?(answer_index)
    current_question.answer_correct?(answer_index)
  end

  def result
    "Your result is #{@right_answers} out of #{@questions.size} with #{@score} points"
  end

  def score_up!
    @score += current_question.points
    @right_answers += 1
  end

  def next_question!
    @current_question_index += 1
  end
end
