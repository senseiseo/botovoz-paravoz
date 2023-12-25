class Actions::Start < Actions::BaseActions
  def initial
    on_message do
      redirect_to Actions::ListActions
    end
  end
end
