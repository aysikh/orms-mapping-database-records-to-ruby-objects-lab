class Student
  attr_accessor :id, :name, :grade
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student #returns
    #we are just reading data from SQlite
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
      SQL
      query = DB[:conn].execute(sql, name) 
      Student.new_from_db(query[0]) #we limited it to one so we will only ever get that student's info ONE time
    end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
      SQL
      DB[:conn].execute(sql).map do |student|
        self.new_from_db(student)
      end
  end


  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 9
    SQL
    query = DB[:conn].execute(sql).map do |student|
      Student.new_from_db(student) #we're creating a new instance
    end                   #we have to keep making instances of the classes in ruby
    return query          #every time we take from the database
  end

   def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
      SQL
      query = DB[:conn].execute(sql).map do |student|
        Student.new_from_db(student)
      end
      return query
    end


  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?
      SQL
    query = DB[:conn].execute(sql, x).map do |student|
      Student.new_from_db(student)
    end
  end

  def self.first_student_in_grade_10
    Student.first_X_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      SQL

      DB[:conn].execute(sql, x).map do |student|
        Student.new_from_db(student)
      end
    end
end
