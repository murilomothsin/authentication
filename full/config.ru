require 'bcrypt'
require 'sequel'

class Application
  def call(env)
    [ 200, {}, [] ]
  end
end

class User
  def self.register(params)
    DB[:users].inser(username: params['username'],
                     encrypted_password: BCrypt::Password.create(params['password']))
  end
end

class SignUp
  def call(env)
    req = Rack::Request.new(env)

    if req.post?
      User.register(req.params)
      [ 301, { 'Location' => '/login' }, [] ]
    else
      [ 200, { 'Content-Type' => 'text/html' }, [File.read('signup.html')] ]
    end
  end
end

map '/signup' do
  run SignUp.new
end

run Application.new