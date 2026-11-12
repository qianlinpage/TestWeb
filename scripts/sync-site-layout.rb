#!/usr/bin/env ruby
# frozen_string_literal: true

# The two homepages are the sources for shared, language-specific site elements.
# Run after rendering publications. Page bodies and metadata remain independent.
ROOT = File.expand_path('..', __dir__)
PAGES = %w[index projects teaching publications].freeze
BLOCKS = {
  header: /^  <header class="site-header">.*?^  <\/header>/m,
  profile: /^    <aside class="profile".*?^    <\/aside>/m,
  footer: /^      <footer>.*?<\/footer>/m,
  icon: /^  <link rel="icon"[^>]*>$/
}.freeze

def extract_once(html, pattern, label)
  matches = html.scan(pattern)
  abort "Expected one #{label}, found #{matches.length}" unless matches.length == 1
  matches.first
end

changes = {}
['', '.zh'].each do |suffix|
  home_path = File.join(ROOT, "index#{suffix}.html")
  home = File.read(home_path)
  shared = BLOCKS.to_h { |key, pattern| [key, extract_once(home, pattern, "#{key} in #{home_path}")] }

  PAGES.each do |page|
    filename = "#{page}#{suffix}.html"
    path = File.join(ROOT, filename)
    html = File.read(path)
    header = shared[:header].sub(/<nav\b.*?<\/nav>/m) do |nav|
      nav = nav.gsub(' aria-current="page"', '')
      target = "href=\"#{filename}\""
      abort "Missing navigation link to #{filename}" unless nav.include?(target)
      nav.sub(target, "#{target} aria-current=\"page\"")
    end
    header = header.sub(/<div class="language-switch".*?<\/div>/m) do |links|
      links.gsub('href="index', "href=\"#{page}")
    end

    BLOCKS.each do |key, pattern|
      extract_once(html, pattern, "#{key} in #{filename}")
      html = html.sub(pattern) { key == :header ? header : shared.fetch(key) }
    end
    changes[path] = html if html != File.read(path)
  end
end

# Validate all pages before writing any changes.
changes.each { |path, html| File.write(path, html) }
puts "Synchronized shared layout across #{PAGES.length * 2} pages (#{changes.length} updated)."
