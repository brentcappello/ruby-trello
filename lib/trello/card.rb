# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Card < BasicData
    attr_reader :id, :name, :description, :closed, :url, :board_id, :member_ids, :list_id

    class << self
      def find(id)
        super(:cards, id)
      end
    end

    def initialize(fields = {})
      @id          = fields['id']
      @name        = fields['name']
      @description = fields['desc']
      @closed      = fields['closed']
      @url         = fields['url']
      @board_id    = fields['idBoard']
      @member_ids  = fields['idMembers']
      @list_id     = fields['idList']
    end

    # Links to other data structures

    def actions
      return @actions if @actions
      @actions = Client.get("/cards/#{id}/actions").json_into(Action)
    end

    def board
      return @board if @board
      @board = Board.find(board_id)
    end

    def checklists
      return @checklists if @checklists
      @checklists = Client.get("/cards/#{id}/checklists").json_into(Checklist)
    end

    def list
      return @list if @list
      @list = List.find(list_id)
    end

    def members
      return @members if @members
      @members = member_ids.map do |member_id|
        Client.get("/members/#{member_id}").json_into(Member)
      end
    end

    # Add a comment
    def add_comment(text)
      Client.put("/cards/#{id}/actions/comments", :text => text)
    end
  end
end
