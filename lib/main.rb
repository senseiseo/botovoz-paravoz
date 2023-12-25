# frozen_string_literal: true

require_relative "environment"
@app_config = AppConfig.new

TelegramWorkflow.configure do |config|
  config.start_action = Actions::Start
  config.client = Client
  config.session_store = TelegramWorkflow::Stores::InMemory.new
  config.api_token = @app_config.token
end

trap "SIGINT" do
  puts "Exiting..."
  TelegramWorkflow.stop_updates
end

TelegramWorkflow.updates(timeout: 5).each do |params|
  TelegramWorkflow.process(params)
end

# SMILES = %w(😀 😃 😄 😁 😆 😅 😂 🤣 😍 😌 😉 🙃 🙂 😇 😊 ☺ ️ 🥰 😘 😗 😙 😚 😋 😛 😝 😜 🤪 🤨 🧐
#             🤓 😎 🤩 🥳 ☹ ️ 🙁 😕 😟 😔 😞 😒 😏 😣 😖 😫 😩 🥺 😢 😭 😤 😱 🥶 🥵 😳 🤯 🤬 😡 😠
#             😨 😰 😥 😓 🤗 🤔 🤭 🤫 😦 😯 🙄 😬 😑 😐 😶 🤥 😧 😮 😲 🥱 😴 🤤 😪 😵 🤕 🤒 😷 🤧
#             🤮 🤢 🥴 🤐 🤑 🤠 😈).freeze

# Telegram::Bot::Client.run(config.token) do |bot|
#   bot.listen do |message|
#     case message.text
#     when '/start'
#       binding.pry
#       bot.api.send_message(
#         chat_id: message.chat.id,
#         text: "Привет",
#         reply_markup: Menu.start
#       )

#     when '/console'
#       Thread.new { binding.pry }

#     when '/kill!'
#       bot.api.send_message(
#         chat_id: message.chat.id,
#         text: "Бот был жестоко убит пользователем"
#       )

#       Thread.new do
#         sleep 2
#         exit
#       end

#     when 'Подключить общий чат'
#       player = Player.find_by(uid: message.from.id) || Player.create(uid: message.from.id, username: message.from.username)
#       player.update(count: 10, publick_chat_id: message.chat.id)

#       bot.api.send_message(
#         chat_id: message.chat.id,
#         text: "Я вас посчитал, #{message.from.username}. Подключите так же личный чат и я напишу в нем когда вы умрёте"
#       )

#     when 'Подключить личный чат'
#       player = Player.find_by(uid: message.from.id) || Player.create(uid: message.from.id, username: message.from.username)
#       player.update(personal_chat_id: message.chat.id)

#       bot.api.send_message(
#         chat_id: message.chat.id,
#         text: "Я вас посчитал, #{message.from.username}. Подключите так же общий чат, в нём я буду считать смайлики."
#       )

#     else
#       player = Player.find_by(uid: message.from.id)

#       next unless player
#       next if message.chat.id.to_i != player.publick_chat_id.to_i

#       SMILES.each do |smile|
#         if message&.text&.include?(smile)
#           player.update(count: player.count - 1)

#           if player.count <= 0
#             bot.api.send_message(
#               chat_id: player.personal_chat_id.to_i,
#               text: "Вас постигла медленная и мучительная смерть..."
#             )
#           end

#           break
#         end
#       end
#     end
#   end
# end
