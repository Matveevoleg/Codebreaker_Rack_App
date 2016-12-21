require_relative '../modules/io_module'
require_relative '../modules/mark_module'

module Codebreaker
  class Game
    include(IOModule)
    include(MarkModule)

    attr_reader :hints, :attempts, :secret_code

    HINTS = 2
    ATTEMPTS = 5
    CODEBREAKER_FILE = 'codebreaker.txt'

    def initialize
      @secret_code = generate_secret_code
      @attempts = ATTEMPTS
      @hints = HINTS
    end

    def save(user_name)
      str = user_name + '|' + hints.to_s + '|' + attempts.to_s
      save_result(str, CODEBREAKER_FILE)
    end

    def get_statistics
      load_results(CODEBREAKER_FILE)
    end

    def get_hint
      return 'You don`t have hints' if @hints == 0
      @hints -= 1
      hint
    end

    def get_answer(input)
      return 'won' if input == @secret_code
      return 'Invalid input' unless correct_input?(input)
      @attempts -= 1
      answer(input)
    end
    private

    def generate_secret_code
      Array.new(4) { rand(6) + 1 }.join
    end
  end
end
