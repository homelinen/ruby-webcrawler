
port = 9999

task :run_server do
  dir = './spec/website'
  sh "heel -d -r #{dir} -p #{port}"
end

task :kill_server do
    sh "heel -k -p #{port}"
end
