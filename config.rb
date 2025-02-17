# Markdown
class Redcarpet::Markdown
  # This override prefixes every rendered Markdown with the contents of source/_linkrefs.md!
  alias_method :orig_render, :render
  def render(markdown)
    prefix = File.open("source/_linkrefs.md").read
    orig_render("#{prefix}#{markdown}")
  end
end

set :markdown_engine, :redcarpet
set :markdown,
    fenced_code_blocks: true,
    smartypants: true,
    disable_indented_code_blocks: false,
    prettify: true,
    tables: true,
    with_toc_data: true,
    no_intra_emphasis: true

# Assets
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :fonts_dir, 'fonts'

# Activate the syntax highlighter
activate :syntax

activate :autoprefixer do |config|
  config.browsers = ['last 2 version', 'Firefox ESR']
  config.cascade  = false
  config.inline   = true
end

# Github pages require relative links
activate :relative_assets
set :relative_links, true

# Build Configuration
configure :build do
  # activate :minify_css
  # activate :minify_javascript
  # activate :relative_assets
  # activate :asset_hash
  # activate :gzip
end
