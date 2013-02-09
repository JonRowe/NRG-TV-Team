require 'sinatra'
require 'haml'
require 'sass'

module Web
  class App < Sinatra::Base

    mime_type :otf, 'application/octet-stream'
    set :public, "./public"
    set :views,  "./views"

    get('/')      { find_page :home }
    get('/:page') { find_page params[:page] }

    get '/stylesheets/:style.css' do
      set_last_modified "./stylesheets/#{params[:style]}.sass"
      sass params[:style].to_sym, views: './stylesheets', charset: 'utf-8'
    end

    not_found { not_found }
    error { haml :error }

    private
      def find_page(page)
        ( page_exist(page) && display_page(page) ) || not_found
      end
      def set_last_modified(filename)
        File.open filename do |file|
          last_modified file.mtime unless file.nil?
        end
      end
      def page_exist(page)
        File.exist?("./views/#{page}.haml")
      end
      def display_page(page)
        set_last_modified "./views/#{page}.haml"
        haml page.to_sym
      end
      def not_found
        status 404
        haml :four_oh_four
      end
  end
end
