# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020, by Samuel Williams.

module Latinum
	# Represents an error when trying to perform arithmetic on differently named resources.
	class DifferentResourceNameError < ArgumentError
		def initialize
			super "Cannot operate on different currencies!"
		end
	end
end
