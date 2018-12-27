# Conversations take place between an NPC and a Player, or an NPC and another NPC
# These can unlock more conversations, turn in quests, require certain skills, etc.
class Conversation
  attr_reader :id, :initiator, :target, :options, :current_option_index, :unlocked_options

  def initialize(convo)
    @initiator = convo[:initiator]
    @target = convo[:target]
    @options = convo[:options]
    @id = convo[:id]

    @current_option_index = -1

    next_option
  end

  def next_option
    @current_option_index += 1 if @current_option_index + 1 != @options.length
    option = @options[@current_option_index]

    option[:lines].each do |sentence|
      say_line(sentence)
    end
  end

  def say_line(sentence)
    sentence.each_char do |char|
      sleep(0.05)

      print(char)
    end

    puts ''
    sleep(0.5)
  end

  def handle_reply
    reply = gets.to_s

    puts reply if reply_exists

    unless reply_exists
      puts 'What..?'
      handle_reply
    end
  end

  def reply_exists(reply)
    option = @options[@current_option_index]

    return true if option[:replies].include?(reply)
  end
end

convo_hash = {
  :options => [
    {
      :id => 0,
      :lines => [
        {
          :quote => "Welcome! Would you like to get started?"
        }
      ],

      :replies => [
        {
          :quote => 'Sure!'
        },
        {
          :quote => 'No thanks.',
          :cancel => true
        }
      ]
    }
    {
      :id => 1,
      :requires_options => [0]
      :lines => [
        {
          :quote => 'What do you prefer?',
        }
      ],

      :replies => [
        {
          :quote => 'A',
          :unlocks_options => [2]
        },
        {
          :quote => 'B',
          :unlocks_options => [3]
        }
      ]
    }
  ]
}

convo = Conversation.new(convo_hash)
