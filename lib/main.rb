require_relative "environment"
# require_relative "action_list"

AppConfig.instance

TelegramWorkflow.configure do |config|
  config.start_action = Actions::Start
  config.session_store = TelegramWorkflow::Stores::InMemory.new
  config.client = Client
  config.api_token = AppConfig.instance.config.telegram.token
end

trap "SIGINT" do
  puts "Exiting..."
  TelegramWorkflow.stop_updates
end

pool_options = {
  max_threads: AppConfig.instance.config.concurrent_ruby.max_threads.to_i, # Максимальное количество потоков в пуле
  min_threads: AppConfig.instance.config.concurrent_ruby.min_threads.to_i, # Минимальное количество потоков
  auto_terminate: AppConfig.instance.config.concurrent_ruby.auto_terminate, # Автоматическое завершение пула при отсутствии задач
  idletime: AppConfig.instance.config.concurrent_ruby.idletime.to_i, # Время простоя потока перед завершением (если auto_terminate: true)
  max_queue: AppConfig.instance.config.concurrent_ruby.max_queue.to_i # Максимальный размер очереди задач (0 - неограниченный)
}

pool = Concurrent::ThreadPoolExecutor.new(pool_options)

TelegramWorkflow.updates(timeout: AppConfig.instance.config.timeout.to_i).each do |params|
  pool.post do
    begin
      TelegramWorkflow.process(params)
    rescue StandardError => error
      TelegramWorkflow.config.logger.info(error.message)
    end
  end
end

pool.shutdown
pool.wait_for_termination
