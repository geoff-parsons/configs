def cmd_exists?(cmd)
  system("command -v #{cmd} &> /dev/null")
end

def run_cmd(cmd = nil, message: nil, halt_on_error: false, &block)
  return if cmd == nil && block == nil

  print "   #{message}" if message
  begin
    result = if cmd
      system(cmd)
    else
      yield
    end
  rescue Exception => e
    if message
      puts " ✗".bold.red
      puts "      #{'Error'.underline}: #{e.message}"
    else
      raise e
    end
    exit 1 if halt_on_error
  else
    if result == 1
      # typically the result of a call to `system` failing
      puts " ✗".bold.red if message
    else
      puts " ✔︎".bold.green if message
    end
  end
end

def set_xenv_global(command, version)
  if !cmd_exists?(command)
    return
  elsif `#{command} versions --bare`.split.include?(version)
    system("#{command} global #{version}")
  else
    raise RuntimeError, "Configs wants to set global #{command} version to #{version} but it is not installed."
  end
end
