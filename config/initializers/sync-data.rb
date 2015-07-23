'''
FILE: tasks_initializer.rb
TASK: run the syncing script at the server
TIME OF SYNC: every midnight
'''

require 'rufus-scheduler'
require 'rake'

Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
StockWatcher::Application.load_tasks # providing your application name is 'sample'

puts "[LOG] Starting rufus scheduler..."
scheduler = Rufus::Scheduler.new
puts "[LOG] Rufus started"

#Run every day every midnight
scheduler.cron("00 00 * * *") do
	sync_routine
end 

scheduler.every("30s") do
	if Update.count == 0
		Update.create(:updated=>true)
	end

	if Update.first.updated
		status = Update.first
		status.updated = false
		status.save
		sync_routine
	end
end 

def sync_routine
	puts "Checking for updates..."
	Rake::Task['stock:crawl'].reenable # in case you're going to invoke the same task second time.
    Rake::Task['stock:crawl'].invoke
    puts "[LOG] Sync task OK"
end
