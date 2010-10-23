namespace :mysql do
  namespace :backup do
    desc "Backup of a specific table; Usage: rake mysql:backup:table['table name', 'dump_name' << Optional! ] RAILS_ENV=<env>"
    task :table, :table_name, :dump_name do |task, args|
      raise "No table name defined: rake mysql:backup:table['table name']" if args[:table_name].blank?
      db_info = retrieve_db_info()
      puts "execute: mysqldump -u #{db_info[:username]} -p#{db_info[:password]} #{db_info[:database]} '#{args[:table_name]}' | bzip2 -c > tmp/#{args[:dump_name] || "dump" << Time.now.strftime("%y%m%d%H%M%S")}.sql.bz2"
      `mysqldump -u #{db_info[:username]} -p#{db_info[:password]} #{db_info[:database]} '#{args[:table_name]}' | bzip2 -c > tmp/#{args[:dump_name] || "dump" << Time.now.strftime("%y%m%d%H%M%S")}.sql.bz2`
    end

    desc "Backup of a database; Usage: rake mysql:backup:db RAILS_ENV=<env>"
    task :db do |task, args|
      db_info = retrieve_db_info()
      puts "execute: mysqldump -u #{db_info[:username]} -p#{db_info[:password]} #{db_info[:database]} | bzip2 -c > tmp/#{args[:dump_name] || "dump" << Time.now.strftime("%y%m%d%H%M%S")}.sql.bz2"
      `mysqldump -u #{db_info[:username]} -p#{db_info[:password]} #{db_info[:database]} | bzip2 -c > tmp/#{args[:dump_name] || "dump" << Time.now.strftime("%y%m%d%H%M%S")}.sql.bz2`
    end
  end

  private

  def retrieve_db_info
    if File.exists? "#{RAILS_ROOT}/config/database.yml"
      result = File.read "#{RAILS_ROOT}/config/database.yml"
    else
      puts "[Deploy Info] no database configuration given, use ENV variables DB UN PW"
    end
    result.strip!
    config_file = YAML::load(result)
    return {
            :database => ENV['DB'] || config_file[RAILS_ENV]['database'],
            :username => ENV['UN'] || config_file[RAILS_ENV]['username'],
            :password => ENV['PW'] || config_file[RAILS_ENV]['password']
    }
  end
end
