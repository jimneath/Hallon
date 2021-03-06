# coding: utf-8
require 'singleton'

module Hallon
  class Session
    # The options Hallon used at {Session#initialize}.
    # 
    # @see Session#merge_defaults
    # @return [Hash]
    attr_reader :options
    
    # Application key used at {Session#initialize}
    #
    # @return [String]
    attr_reader :appkey
    
    include Singleton
    
    # Allows you to create a Spotify session. Subsequent calls to this method
    # will return the previous instance, ignoring any passed arguments.
    #
    # @param (see Session#initialize)
    # @see Session#initialize
    # @see http://ruby-doc.org/core/classes/Singleton.html
    # @return [Session]
    def Session.instance(*args, &block)
      @__instance__ ||= new(*args, &block)
    end
    
    # True if currently logged in.
    # @see #state
    def logged_in?
      status == :logged_in
    end
    
    # True if logged out.
    # @see #state
    def logged_out?
      status == :logged_out
    end
    
    # True if session has been disconnected.
    # @see #state
    def disconnected?
      status == :disconnected
    end
    
    private
      # Merge the given hash with default options for Session#initialize
      #
      # @private
      # @note This is called automatically by Session#initialize.
      # @param [Hash, nil] options
      # @option options [String] :user_agent ("Hallon") User-Agent to use (length < 256)
      # @option options [String] :settings_path ("tmp") where to save settings
      # @option options [String] :cache_path ("") where to save cache files (set to "" to disable)
      # @return [Hash]
      def merge_defaults(options)
        options ||= {}
        {
          :user_agent => "Hallon",
          :settings_path => "tmp",
          :cache_path => ""
        }.merge(options)
      end
  
      # Spawns a new thread that constantly reads from the `queue` and dispatches
      # events to the {Session}.
      #
      # To exit the thread using events, throw a `:shuriken` in a handler. You
      # can fire your own events using {Session#fire!}.
      #
      # @private
      # @note This is called automatically by Session#initialize.
      # @param [Queue] queue
      # @param [Class] handler
      # @return [Thread]
      def spawn_consumer(queue)
        @event_consumer = Thread.new do
          loop do
            handler, *args = queue.shift
            handler.public_send(*args)
          end
        end
      end
  end
end