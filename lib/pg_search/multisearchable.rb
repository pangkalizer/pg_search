require "active_support/concern"
require "active_support/core_ext/class/attribute"

module PgSearch
  module Multisearchable
    extend ActiveSupport::Concern

    included do
      has_one :pg_search_document,
        :as => :searchable,
        :class_name => "PgSearch::Document",
        :dependent => :delete

      after_create do
        if PgSearch.multisearch_enabled?
          create_pg_search_document :searchable => self
        end
      end

      after_update :update_pg_search_document,
        :if => lambda { PgSearch.multisearch_enabled? }
    end

    def update_pg_search_document
      create_pg_search_document(:searchable => self) unless self.pg_search_document
      self.pg_search_document.save
    end
  end
end
