
class App
  def call(env)
    headers = {}
    headers["x-frame-options"]  = "deny"
    headers["x-xss-protection"]  = "1; mode=block"
    headers["x-content-type-options"]  = "nosniff"
    headers["referrer-policy"]  = "strict-origin"
    headers["content-security-policy"]  = "default-src https:"

    # HSTS 6M
    headers["strict-transport-security"]  = "max-age=16000000"
    headers[""]  = ""
    [399, headers, []]
  end

end

App.new
