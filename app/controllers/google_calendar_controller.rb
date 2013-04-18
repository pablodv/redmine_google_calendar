require 'tzinfo'

class GoogleCalendarController < ApplicationController
  layout 'base'
  before_filter :find_project, :authorize

  def show
    @iframe_text = IframeText.get_iframe_text(@project)

    unless User.current.time_zone.nil?
      time_zone = tzinfo_from_offset(User.current.time_zone.utc_offset)

      #If "pvttk" string is not in the iframe, this is a public calendar
      if @iframe_text[/pvttk/].nil?
        #Substitute in the current timezone for public calendar
        @iframe_text.sub!(/ctz=\S*"/, "ctz=#{time_zone.name}\"")
      else
        #Substitute in the current timezone for private calendar
        @iframe_text.sub!(/ctz=\S*&/, "ctz=#{time_zone.name}&")
      end
    end
  end

private
  def tzinfo_from_offset(offset_in_seconds)
    #Search For US Timezones First
    us = TZInfo::Country.get('US')

    us.zone_info.each do |tz|
      return tz.timezone if tz.timezone.current_period.utc_offset.to_i == offset_in_seconds
    end

    TZInfo::Timezone.all.each do |tz2|
      return tz2 if tz2.current_period.utc_offset.to_i == offset_in_seconds
    end

    return nil
  end
end
