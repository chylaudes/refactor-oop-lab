class Squad
  attr_reader :id
  attr_accessor :name, :mascot

  def initialize params, existing=false
    @id = params["id"]
    @name = params["name"]
    @mascot = params["mascot"]
    @existing = existing
  end

  def existing?
    @existing
  end

  # should maintain a db connection
  def self.conn= connection
    @conn = connection
  end

  def self.conn
    @conn
  end

  # should return a list of squads
  def self.all
    @conn.exec("SELECT * FROM squads")
  end

  # should return a squad by id
  # or nil if not found
  def self.find id
    new @conn.exec('SELECT * FROM squads WHERE id = ($1)', [ id ] )[0], true
  end

  def students
    Squad.conn.exec("SELECT * FROM students WHERE squad_id = ($1)", [id])
  end

  def save
    if existing?
      Squad.conn.exec('UPDATE squads SET name=$1, mascot=$2 WHERE id = $3', [ name, mascot, id ] )
    else
      Squad.conn.exec('INSERT INTO squads (name, mascot) values ($1, $2)', [ name, mascot ] )
    end
  end

  def self.create params
    new(params).save
  end

  def destroy
    Squad.conn.exec('DELETE FROM students WHERE squad_id = $1', [ id ] )
    Squad.conn.exec('DELETE FROM squads WHERE id = $1', [ id ] )
  end

end
