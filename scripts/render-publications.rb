#!/usr/bin/env ruby
# Regenerate only the publications section of the existing bilingual static pages.
require 'json'
require 'cgi'

root = File.expand_path('..', __dir__)
data = JSON.parse(File.read(File.join(root, 'publications-data.json')))
rank = { 'published' => 0, 'online' => 1, 'preprint' => 2, 'unverified' => 3 }
papers = data.fetch('papers').sort_by { |p| [-p.fetch('year'), rank.fetch(p.fetch('status')), p.fetch('id')] }
escape = ->(value) { CGI.escapeHTML(value.to_s) }

%w[zh en].each do |lang|
  zh = lang == 'zh'
  labels = zh ? {
    'published' => '已发表', 'online' => '已在线发表', 'preprint' => '预印本', 'unverified' => '待核实',
    'journal' => '期刊论文', 'conference' => '会议论文', 'chapter' => '书籍章节', 'manuscript' => '投稿稿件'
  } : {
    'published' => 'Published', 'online' => 'Published online', 'preprint' => 'Preprint', 'unverified' => 'Unverified',
    'journal' => 'Journal article', 'conference' => 'Conference paper', 'chapter' => 'Book chapter', 'manuscript' => 'Submission'
  }
  render_paper = lambda do |p, i|
    status = labels.fetch(p.fetch('status'))
    status += " · #{labels.fetch(p.fetch('type'))}" unless p['type'] == 'preprint'
    authors = p.fetch('authors').map { |name| name == 'Qian Lin' ? '<strong>Qian Lin</strong>' : escape.call(name) }.join(', ')
    authors = zh ? '作者信息待核实' : 'Authorship not yet verified' if authors.empty?
    venue = p.fetch('venue')
    if zh
      venue = venue.gsub('; revised ', '；修订于 ').gsub('ICLR 2025 submission', 'ICLR 2025 投稿稿件')
    end
    link_label = if p['status'] == 'preprint'
      'arXiv'
    elsif p['status'] == 'unverified'
      'OpenReview'
    else
      zh ? '正式出版页面' : 'Publication'
    end
    links = ["<a href=\"#{escape.call(p.fetch('url'))}\">#{link_label}</a>"]
    if p['doi']
      links << "<a href=\"https://doi.org/#{escape.call(p['doi'])}\">DOI</a>" unless p['url'] == "https://doi.org/#{p['doi']}"
    end
    if p['arxiv'] && p['status'] != 'preprint'
      links << "<a href=\"https://arxiv.org/abs/#{escape.call(p['arxiv'])}\">arXiv</a>"
    end
    note = p["note_#{lang}"]
    note_html = note ? "\n    <p class=\"paper-summary\">#{escape.call(note)}</p>" : ''
    <<~HTML.chomp
        <article class="publication" data-publication-id="#{p.fetch('id')}" data-year="#{p.fetch('year')}" data-status="#{p.fetch('status')}">
          <div class="paper-mark" aria-hidden="true"><span>#{format('%02d', i + 1)}</span>#{p.fetch('year')}</div>
          <div class="paper-content">
            <h4>#{escape.call(p.fetch('title'))}</h4>
            <p class="authors">#{authors}</p>
            <p class="venue">#{escape.call(venue)}</p>
            <p class="paper-summary">#{escape.call(status)}</p>#{note_html}
            <div class="paper-links">#{links.join(' ')}</div>
          </div>
        </article>
    HTML
  end

  counts = papers.group_by { |p| p.fetch('status') }.transform_values(&:length)
  published = papers.select { |p| %w[published online].include?(p.fetch('status')) }
  preprints = papers.select { |p| %w[preprint unverified].include?(p.fetch('status')) }
  groups = [
    {
      id: 'published-papers', title: zh ? '已发表' : 'Published', papers: published,
      count: zh ? "#{published.length} 篇" : "#{published.length} publications",
      description: zh ? "包括 #{counts.fetch('published', 0)} 篇正式发表和 #{counts.fetch('online', 0)} 篇已在线发表的论文；在线发表情况在条目中注明。" : "Includes #{counts.fetch('published', 0)} publications with final bibliographic details and #{counts.fetch('online', 0)} online-first articles, noted individually."
    },
    {
      id: 'preprints', title: zh ? '预印本' : 'Preprints', papers: preprints,
      count: zh ? "#{counts.fetch('preprint', 0)} 篇 · 待核实 #{counts.fetch('unverified', 0)} 条" : "#{counts.fetch('preprint', 0)} preprints · #{counts.fetch('unverified', 0)} unverified",
      description: zh ? '以下预印本尚未检索到正式发表记录。另附一条作者与发表状态待核实的投稿稿件，并保留明确说明。' : 'No formal publication was found for these preprints. One additional submission is listed with an explicit note because its authorship and publication status remain unverified.'
    }
  ]
  group_html = groups.map do |group|
    rows = group.fetch(:papers).each_with_index.map { |p, i| render_paper.call(p, i) }
      .map { |row| row.lines.map { |line| '          ' + line }.join }.join("\n")
    <<~HTML.chomp
          <div class="publication-group" id="#{group.fetch(:id)}" role="region" aria-labelledby="#{group.fetch(:id)}-heading">
            <div class="publication-group-heading"><h3 id="#{group.fetch(:id)}-heading">#{group.fetch(:title)}</h3><span>#{group.fetch(:count)}</span></div>
            <p class="section-intro">#{group.fetch(:description)}</p>
    #{rows}
          </div>
    HTML
  end.join("\n")
  intro = zh ? '分为已发表与预印本两类，各类按期刊卷期、会议或预印本首次公开年份倒序排列。' : 'Grouped into published work and preprints, each ordered by journal issue, conference or first preprint year, newest first.'
  jump_links = groups.map { |group| "<a href=\"##{group.fetch(:id)}\">#{group.fetch(:title)} <span>#{group.fetch(:count)}</span></a>" }.join("\n          ")
  section = <<~HTML.chomp
      <section id="publications">
        <div class="section-heading"><h2>#{zh ? '学术论文' : 'Publications'}</h2></div>
        <p class="section-intro">#{intro}</p>
        <p class="section-intro">#{zh ? '核查日期：' : 'Checked: '}#{escape.call(data.fetch('checked_on'))}</p>
        <nav class="publication-nav" aria-label="#{zh ? '论文分类' : 'Publication categories'}">
          #{jump_links}
        </nav>
  #{group_html}
      </section>
  HTML
  path = File.join(root, zh ? 'publications.zh.html' : 'publications.html')
  html = File.read(path)
  raise "Missing publications section in #{path}" unless html.match?(/<section id="publications">.*?<\/section>/m)
  html = html.sub(/<section id="publications">.*?<\/section>/m, section)
  html = html.sub(/<main id="main">\s*/, "<main id=\"main\">\n      ")
  html = html.sub('</section><footer>', "</section>\n      <footer>")
  File.write(path, html)
  puts "#{File.basename(path)}: #{papers.length} entries"
end
