#!/usr/bin/env ruby
# frozen_string_literal: true

# Render both research-project sections; funding records remain outside this block.
require 'json'
require 'cgi'

root = File.expand_path('..', __dir__)
data = JSON.parse(File.read(File.join(root, 'research-projects-data.json')))
papers = JSON.parse(File.read(File.join(root, 'publications-data.json'))).fetch('papers').to_h { |p| [p.fetch('id'), p] }
projects = data.fetch('projects')
ids = projects.map { |p| p.fetch('id') }
abort 'Research project IDs must be unique' unless ids.uniq == ids

projects.each do |project|
  abort "Invalid project ID: #{project['id']}" unless project['id'].match?(/\Aproject-[a-z0-9-]+\z/)
  %w[title summary questions].each do |field|
    %w[en zh].each { |lang| project.fetch(field).fetch(lang) }
  end
  abort "Bilingual question counts differ in #{project['id']}" unless project['questions']['en'].length == project['questions']['zh'].length
  project.fetch('highlights').each do |highlight|
    %w[en zh].each { |lang| highlight.fetch('summary').fetch(lang) }
  end
  paper_ids = project.fetch('highlights').map { |h| h.fetch('paper_id') } + project.fetch('selected_paper_ids')
  abort "Repeated paper in #{project['id']}" unless paper_ids.uniq == paper_ids
  paper_ids.each do |id|
    paper = papers.fetch(id) { abort "Unknown paper #{id} in #{project['id']}" }
    abort "Unverified paper #{id} cannot be a research highlight" if paper.fetch('status') == 'unverified'
  end
end

escape = ->(value) { CGI.escapeHTML(value.to_s) }
updates = {}
%w[en zh].each do |lang|
  zh = lang == 'zh'
  suffix = zh ? '.zh' : ''
  labels = zh ? {
    'title' => '研究项目', 'intro' => '围绕三个相互关联的主题，持续研究统计学习的基础问题。每个主题汇集研究问题、已有进展与代表论文。',
    'questions' => '研究问题', 'progress' => '研究进展', 'papers' => '代表论文',
    'published' => '已发表', 'online' => '已在线发表', 'preprint' => '预印本', 'accepted' => '已接收，待正式出版',
    'funding' => '基金与合作记录', 'all' => '完整论文列表', 'first_preprint' => '首次预印本年份'
  } : {
    'title' => 'Research projects', 'intro' => 'Three connected themes guide my work on the foundations of statistical learning. Each brings together research questions, progress and selected papers.',
    'questions' => 'Research questions', 'progress' => 'Research progress', 'papers' => 'Selected papers',
    'published' => 'Published', 'online' => 'Published online', 'preprint' => 'Preprint', 'accepted' => 'Accepted, awaiting publication',
    'funding' => 'Funding and collaborations', 'all' => 'All publications', 'first_preprint' => 'First preprint'
  }
  paper_link = lambda do |id|
    paper = papers.fetch(id)
    status = labels.fetch(paper.fetch('status'))
    year = paper.fetch('year')
    meta = paper['status'] == 'accepted' ? "#{status} · #{labels['first_preprint']}: #{year}" : "#{year} · #{status}"
    "<a href=\"publications#{suffix}.html#paper-#{id}\">#{escape.call(paper.fetch('title'))}</a><span class=\"project-paper-meta\">#{escape.call(meta)}</span>"
  end

  html = []
  html << '      <!-- research-projects:start -->'
  html << '      <section id="projects">'
  html << "        <h2>#{labels['title']}</h2>"
  html << "        <p>#{labels['intro']}</p>"
  html << "        <nav class=\"research-project-nav\" id=\"related-research\" aria-label=\"#{zh ? '研究主题' : 'Research themes'}\">"
  projects.each { |project| html << "          <a href=\"##{project['id']}\">#{escape.call(project['title'][lang])}</a>" }
  html << '        </nav>'
  projects.each do |project|
    html << "        <article class=\"research-project\" id=\"#{project['id']}\">"
    html << "          <h3>#{escape.call(project['title'][lang])}</h3>"
    html << "          <p>#{escape.call(project['summary'][lang])}</p>"
    if project['website']
      website = project.fetch('website')
      html << "          <p><a href=\"#{escape.call(website.fetch('url'))}\">#{escape.call(website.fetch('label').fetch(lang))}</a></p>"
    end
    html << "          <h4>#{labels['questions']}</h4>"
    html << '          <ul class="plain-list">'
    project['questions'][lang].each { |question| html << "            <li>#{escape.call(question)}</li>" }
    html << '          </ul>'
    html << "          <h4>#{labels['progress']}</h4>"
    html << '          <ul class="project-highlights">'
    project['highlights'].each do |highlight|
      html << "            <li><p>#{escape.call(highlight['summary'][lang])}</p>#{paper_link.call(highlight['paper_id'])}</li>"
    end
    html << '          </ul>'
    html << "          <h4>#{labels['papers']}</h4>"
    html << '          <ul class="project-papers">'
    project['selected_paper_ids'].each { |id| html << "            <li>#{paper_link.call(id)}</li>" }
    html << '          </ul>'
    html << '        </article>'
  end
  html << "        <p class=\"section-intro\"><a href=\"publications#{suffix}.html\">#{labels['all']}</a> · <a href=\"#funding\">#{labels['funding']}</a></p>"
  html << '      </section>'
  html << '      <!-- research-projects:end -->'

  path = File.join(root, "projects#{suffix}.html")
  old = File.read(path)
  block = /^      <!-- research-projects:start -->.*?^      <!-- research-projects:end -->/m
  abort "Expected one research block in #{path}" unless old.scan(block).length == 1
  updates[path] = old.sub(block) { html.join("\n") }
end

updates.each do |path, html|
  File.write(path, html) if File.read(path) != html
  puts "#{File.basename(path)}: #{projects.length} research themes"
end
