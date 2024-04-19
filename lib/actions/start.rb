class Actions::Start < Actions::BaseAction
  def initial
    on_message do
      redirect_to Actions::ListAction
    end
  end
end
