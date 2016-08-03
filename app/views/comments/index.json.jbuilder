json.array!(@comments) do |comment|
  json.extract! comment, :id, :body, :user_id, :blog_id, :pid
  json.url comment_url(comment, format: :json)
end
