# frozen_string_literal: true

module Decorators
  # Decorator for an authorization code, providing an hash representation
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Authorization < Virtuatable::Enhancers::Base
    enhances Arkaan::OAuth::Authorization

    def to_h
      {
        code: code
      }
    end
  end
end
