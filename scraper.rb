require "json"
require "open-uri"
require "scraperwiki"

url = "https://raw.githubusercontent.com/g0v/summit.g0v.tw/2016/app/javascripts/components/SpeakerList/speakers.json"
speakers = JSON.parse(open(url).read)["en-US"]
avatar_base_url = "https://raw.githubusercontent.com/g0v/summit.g0v.tw/2016/app/javascripts/components/SpeakerList/"

speakers.map! do |s|
  # Use full YouTube URL
  s["interview"] = "https://youtu.be/" + s["interview"] if s["interview"]
  # Make avatar URL complete if it's relative
  s["avatar"] = avatar_base_url + s["avatar"][2..-1] if s["avatar"] && s["avatar"][0..1] == "./"
  # Change boolean so it can be saved in SQLite
  s["featured"] = 1 if s["featured"]

  s
end

ScraperWiki.save_sqlite(["name"], speakers)
