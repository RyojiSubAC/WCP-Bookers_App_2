class BooksController < ApplicationController
  before_action :authenticate_user!

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
    @new_book = Book.new
    @user = current_user
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
    @user = @book.user
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
		if @book.user_id != current_user.id
	    	redirect_to books_path
	  end
    @new_book = Book.new
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        @books = Book.all
        @user = current_user
        @new_book = @book
        format.html { render :index }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    @book = Book.find(params[:id])
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_book
    #   @book = Book.find(params[:id])
    # end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :body, :user_id)
    end
end
