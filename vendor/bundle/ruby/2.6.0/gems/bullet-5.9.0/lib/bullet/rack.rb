# frozen_string_literal: true

module Bullet
  class Rack
    include Dependency

    def initialize(app)
      @app = app
    end

    def call(env)
      return @app.call(env) unless Bullet.enable?

      Bullet.start_request
      status, headers, response = @app.call(env)

      response_body = nil
      if Bullet.notification?
        if !file?(headers) && !sse?(headers) && !empty?(response) &&
           status == 200 && html_request?(headers, response)
          response_body = response_body(response)
          response_body = append_to_html_body(response_body, footer_note) if Bullet.add_footer
          response_body = append_to_html_body(response_body, Bullet.gather_inline_notifications)
          headers['Content-Length'] = response_body.bytesize.to_s
        end
        Bullet.perform_out_of_channel_notifications(env)
      end
      [status, headers, response_body ? [response_body] : response]
    ensure
      Bullet.end_request
    end

    # fix issue if response's body is a Proc
    def empty?(response)
      # response may be ["Not Found"], ["Move Permanently"], etc.
      if rails?
        (response.is_a?(Array) && response.size <= 1) ||
          !response.respond_to?(:body) ||
          !response_body(response).respond_to?(:empty?) ||
          response_body(response).empty?
      else
        body = response_body(response)
        body.nil? || body.empty?
      end
    end

    def append_to_html_body(response_body, content)
      body = response_body.dup
      if body.include?('</body>')
        position = body.rindex('</body>')
        body.insert(position, content)
      else
        body << content
      end
    end

    def footer_note
      "<div #{footer_div_attributes}>" + footer_close_button + Bullet.footer_info.uniq.join('<br>') + '</div>'
    end

    def file?(headers)
      headers['Content-Transfer-Encoding'] == 'binary' || headers['Content-Disposition']
    end

    def sse?(headers)
      headers['Content-Type'] == 'text/event-stream'
    end

    def html_request?(headers, response)
      headers['Content-Type']&.include?('text/html') && response_body(response).include?('<html')
    end

    def response_body(response)
      if response.respond_to?(:body)
        Array === response.body ? response.body.first : response.body
      else
        response.first
      end
    end

    private

    def footer_div_attributes
      <<~EOF
        data-is-bullet-footer ondblclick="this.parentNode.removeChild(this);" style="position: fixed; bottom: 0pt; left: 0pt; cursor: pointer; border-style: solid; border-color: rgb(153, 153, 153);
         -moz-border-top-colors: none; -moz-border-right-colors: none; -moz-border-bottom-colors: none;
         -moz-border-left-colors: none; -moz-border-image: none; border-width: 2pt 2pt 0px 0px;
         padding: 3px 5px; border-radius: 0pt 10pt 0pt 0px; background: none repeat scroll 0% 0% rgba(200, 200, 200, 0.8);
         color: rgb(119, 119, 119); font-size: 16px; font-family: 'Arial', sans-serif; z-index:9999;"
      EOF
    end

    def footer_close_button
      "<span onclick='this.parentNode.remove()' style='position:absolute; right: 10px; top: 0px; font-weight: bold; color: #333;'>&times;</span>"
    end
  end
end
