class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @id = id 
    @name = name
    @grade = grade
  end

  def self.create_table
    sql =  <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        grade TEXT
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

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    sql2 = <<-SQL
      SELECT last_insert_rowid() FROM students
    SQL
 
    DB[:conn].execute(sql, self.name, self.grade)
    
    @id = DB[:conn].execute(sql2)[0][0] #assigning value to instance id
    #last_insert_rowid returns rowid of last row insert within 2 arrays
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
end
