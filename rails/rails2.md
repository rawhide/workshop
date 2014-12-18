Ruby on Rails 入門
------------------------------------

# コントローラー

以下自動生成されたコントローラーです。(json用のレスポンス等一部削っています。)

```ruby
# すべてのコントローラーは ActionController::Base を継承するようにします。すべてのコントローラーで共通の処理は ApplicationController に定義してください。
# アクション内で設定したインスタンス変数はコントローラー、ビュー間で共有されます。インスタンス変数が3個以上になると危険です。
# コントローラー名の Controller を除いたものは複数形になるようにしましょう。
# 基本の7つのアクション(index, show, new, edit, create, update, destroy)。それ以外のアクションを追加することもできますが、本当に必要かもう一度考えてみましょう。

class MessageBoardsController < ApplicationController
  # show, edit, update, destroy アクションの処理を実行する前に set_message_board が呼ばれます。
  # あまり使わないですが after_action や around_action などもあります。
  # only の代わりに except を使うと指定されたアクション以外でメソッドが呼ばれます。
  before_action :set_message_board, only: [:show, :edit, :update, :destroy]

  # GET /message_boards
  def index
    # ビューで @message_boards を使用することができます。
    @message_boards = MessageBoard.all

    # CoCのおかげで以下のレンダリング処理をを書かなくても app/views/message_boards/index.html.erb をレンダリングしてくれます。
    # render :index
  end

  # GET /message_boards/:id
  def show
    # before_action で set_message_board が呼ばれているので @message_board が設定されています。
  end

  # GET /message_boards/new
  def new
    # ビューで掲示板の新規登録フォームを生成するため、MessageBaord モデルのインスタンスをビューに渡します。
    @message_board = MessageBoard.new
  end

  # GET /message_boards/:id/edit
  def edit
  end

  # POST /message_boards
  def create
    # MessageBoard.new には Strong Parameters を通したパラメーターを渡します。
    @message_board = MessageBoard.new(message_board_params)

    # save は保存に失敗した場合 false を返します。
    # save! は保存に失敗した場合例外が発生します。
    if @message_board.save
      # redirect_to message_board_url(@message_board), notice: 'Message board was successfully created.' と定義したのと同じになります。
      redirect_to @message_board, notice: 'Message board was successfully created.'
    else
      # app/views/message_boards/new.html.erb をレンダリングします。
      render :new
    end
  end

  # PATCH /message_boards/:id
  # PUT /message_boards/:id
  # PUT：冪等であるべき処理に使う。POSTっぽい処理？
  # PATCH；冪等でない処理に使われる。一般的な更新処理はPATCHの方が適当。
  def update
    if @message_board.update(message_board_params)
      redirect_to @message_board, notice: 'Message board was successfully updated.'
    else
      # app/views/message_boards/edit.html.erb をレンダリングします。
      render :edit
    end
  end

  # DELETE /message_boards/:id
  def destroy
    @message_board.destroy
    redirect_to message_boards_url, notice: 'Message board was successfully destroyed.'
  end

  private
    def set_message_board
      @message_board = MessageBoard.find(params[:id])
    end

    # Mass Assignment 脆弱性対策のため Strong Parameters という Rails の機能を使います。
    # Strong Parameters はコントローラーが受け取るパラメータをホワイトリスト形式で指定することができます。
    # 今回のコードではパラメータに :message_board というキーがあり、message_boardキー は :title と :body というキーを持つハッシュのみ受け付けます。
    # { "message_board" => {"title"=>"message_baord1", "body"=>"memo memo", "test"=>"test"} }
    # 分解すると以下のようになります。
    # params.require(:message_board) # => {"title"=>"message_baord1", "body"=>"memo memo", "test"=>"test" }
    # params.require(:message_board).permit(:title, :body) # => {"title"=>"message_baord1", "body"=>"memo memo"}
    # 結果 Strong Parameters で指定した {"title"=>"message_baord1", "body"=>"memo memo"} のみモデルに渡すことができます。
    def message_board_params
      params.require(:message_board).permit(:title, :body)
    end
end
```
