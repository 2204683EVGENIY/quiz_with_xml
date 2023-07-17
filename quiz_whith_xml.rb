require 'timeout'
require_relative 'lib/quiz'

file_path = File.join(__dir__, 'data', 'quiz_q_and_a.xml')

quiz = Quiz.from_xml(file_path)

until quiz.finished?
  puts quiz.current_question

  user_answer =
    begin
      Timeout.timeout(quiz.time_to_answer) do
        $stdin.gets.to_i
      end
    rescue Timeout::Error
      puts 'Your time is over!'
      break
    end

  if quiz.answer_correct?(user_answer)
    quiz.score_up!
    puts 'OK'
  else
    puts "No! Right answer is #{quiz.answer}"
  end

  quiz.next_question!
end

puts quiz.result
