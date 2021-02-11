class Student

  # getter and setter
  attr_accessor :name, :grade

  # getter
  attr_reader :id

  # id is nil because if not nil it can cause problem with auto signing.
  def initialize(name, grade, id=nil)
    # initailize the argument
    @id = id
    @name = name
    @grade = grade
  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
  # self => Student.create_table
  def self.create_table # creates a table in ruby for connection
    # sql is the variable
      # Create the table if the student does not exists
    sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )  
    SQL
    # connects with the db and executes the code (sql)
    DB[:conn].execute(sql)
  end

  # self => Student.drop_table 
  def self.drop_table 
    # sql => variable
          #  is sql commands 
          # DROPs the table if the table exists
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end


  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].excute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  # constructor => class students

  def self.create(name:, grade:)
    # create
    student = Student(name, grade)
    student.save
    student
  end
end
