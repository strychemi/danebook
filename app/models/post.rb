class Post < ActiveRecord::Base
  belongs_to :user, inverse_of: :posts
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 2000 }
  validates :user, presence: true

  after_create :create_activity
  after_destroy :destroy_activity

  private

    def create_activity
      Activity.create(
        user_id: self.user_id,
        event: "Wrote a Post",
        activable_id: self.id,
        activable_type: "#{self.class}",
        created_at: self.created_at,
        updated_at: self.updated_at
      )
    end

    def destroy_activity
      activity = Activity.find_by_user_id_and_activable_id_and_activable_type( self.user_id, self.id, "#{self.class}")
      activity.destroy
    end

    # def create_activities
    #   if post.user.frienders
    #     post.user.frienders.each do |friender|
    #       Activity.create(
    #         user_id: friender.id,
    #         event: "Wrote a Post",
    #         activable_id: self.id,
    #         activable_type: "#{self.class}" )
    #     end
    #   end
    # end

end
