action :add do
    if @new_resource.jobinfo
        jobinfo = @new_resource.jobinfo
        jobinfo.each_pair do |key, value|
            @new_resource.instance_variable_set("@#{key}", value)
        end
    end

    name = @new_resource.name
    minute = @new_resource.minute
    hour = @new_resource.hour
    day = @new_resource.day
    month = @new_resource.month
    weekday = @new_resource.weekday
    user = @new_resource.user
    command = @new_resource.command
    description = @new_resource.description

    unless command
        raise Chef::Exceptions::ValidationFailed, "Required argument 'command' is missing!"
    end
    unless user
        raise Chef::Exceptions::ValidationFailed, "Required argument 'user' is missing!"
    end

    template "/etc/cron.d/#{name}" do
        source 'etc/cron.d/single-job-template.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
            :name => name,
            :minute => minute,
            :hour => hour,
            :day => day,
            :month => month,
            :weekday => weekday,
            :user => user,
            :command => command,
            :description => description
        )
        cookbook 'cron'
    end
end

action :remove do
    name = @new_resource.name

    file "/etc/cron.d/#{name}" do
        action :delete
    end
end

