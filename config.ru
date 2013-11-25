Encoding.default_external = 'utf-8'

class NoRoot

  def call env
    [404, headers, ['']]
  end

private

  def headers
    { 'Content-Type'  => 'text/html', 'Cache-Control' => 'public, max-age=86400' }
  end

end

class FourOhFour

  def initialize app
    @app = app
  end

  def call env
    response = @app.call env
    if response[0] == 404
      [404, headers, four_oh_four]
    else
      response
    end
  end

private

  def headers
    { 'Content-Type'  => 'text/html', 'Cache-Control' => 'public, max-age=86400' }
  end

  def four_oh_four
    File.open('public/404.html', File::RDONLY)
  end

end

use Rack::Deflater
use FourOhFour
use Rack::Static, urls: ['/', '/stylesheets', '/javascripts'], root: 'public', index: 'index.html'
run NoRoot
