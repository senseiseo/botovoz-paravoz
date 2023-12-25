class Actions::ListActions < Actions::BaseActions
  def initial
    on_redirect do
      available_actions = [
        [{ text: "Начать изучение", callback_data: "start" }]
      ]
      pp available_actions
      client.send_actions "Выберите действие:", available_actions
    end

    on_message do
      next_action = if params.callback_data == "start"
        Actions::StartWordActions
      else
        client.send_message text: "❗️Incorrect action"
        :initial
      end

      redirect_to next_action
    end
  end
end
