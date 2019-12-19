class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end 

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
        )
        SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
      SQL
    DB[:conn].execute(sql)
  end
  
  # you do need to grab the ID of the last inserted row, i.e. the row you just inserted into the 
  # database, and assign it to the be the value of the @id attribute of the given instance.
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
      SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

    # 1) instantiate a new Student object with Student.new(name, grade)  
    # 2) save that new student object via student.save. 
    # this method should return the student object that it creates.
  def self.create(name:, grade:)
    student = Student.new(name, grade) 
    student.save
    student 
  end
  
end
