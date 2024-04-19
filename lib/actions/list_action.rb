class Actions::ListAction < Actions::BaseAction
  def initial
    on_redirect do
      available_actions = [
        [{ text: "Начать изучение", callback_data: "start" }]
      ]

      pp available_actions
      client.do_send_actions(text: "Выберите действие:", actions: available_actions)
    end

    on_message do
      next_action = if params.callback_data == "start"
        Actions::StartWordAction
      else
        client.do_send_message text: "❗️Incorrect action"
        :initial
      end

      redirect_to next_action
    end
  end
end
