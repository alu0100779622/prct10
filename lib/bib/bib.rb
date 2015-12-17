module Bib
	
  	class Ref
		include Comparable
		attr_reader :autores, :titulo, :fecha
		
		def initialize(aut,title,date)
			str=""
			aut.each do |x|
				separado = x.split(/\W+/)
				str+=separado[1]
				str+=", "
				unless separado[2].nil?
					str+=separado[2][0]
					str+=". "
				end
				str+=separado[0][0]
				str+="."
				str+=" & " unless x == aut.last
			end
			@autores = str
			@titulo = title
			@fecha = date
		end
		
		def <=>(other)
			if(@autores == other.autores)
				if(@fecha == other.fecha)
					if(@titulo == other.titulo)
						return 0 
					else
						v = [@titulo, other.titulo]
						v.sort_by!{|t| t.downcase}
						if(v.first == @titulo)
							return 1
						end
						return -1
					end
				elsif fecha > other.fecha
					return 1
				else
					return -1
				end
			else
				v = [@autores, other.autores]
				v.sort_by!{|t| t.downcase}
				if(v.first == @autores)
					return 1
				end
				return -1
			end
		end
		
	end
	
	class Journal < Ref
		def initialize(aut,title,date)
			super(aut,title,date)
		end
	end
	
	class Book < Ref
		attr_reader :volumen, :site, :editorial, :edicion
		def initialize(aut,title,date,editorial,edicion,vol,site)
			super(aut,title,date)
			@volumen = vol
			if site != nil
				site+=": "
			end
			@site = site
			@editorial = editorial
			@edicion = edicion
				
		end
		
		def to_s
			"#{autores} (#{fecha}). #{titulo} (#{edicion})(#{volumen}). #{site}#{editorial} "
		end
	end
	
	class Magazine < Journal
		attr_reader :editorial, :edicion, :vol, :site, :capitulo, :editores, :numPag
		def initialize(aut,title,date,editorial,edicion,vol,site,capitulo,editores,numPag)
			super(aut,title,date)
			str=""
			editores.each do |x|
				space = x.split(' ')
				str+=space[1]
				str+=", "
				unless space[2].nil?
					str+=space[2][0]
					str+=". "
				end
				str+=space[0][0]
				str+="."
				str+=" & " unless x == editores.last
			end
			@editores = str
			@editorial = editorial
			@edicion = edicion
			@vol = vol
			@site = site
			@capitulo = capitulo
			@numPag = numPag
		end
		
		def to_s
			"#{autores} (#{fecha}). #{capitulo}. #{editores}, #{titulo} (#{numPag}) (#{edicion}) (#{vol}). #{site}: #{editorial}"
		end
	end
	
	class Newspaper < Journal
		attr_reader :paper, :pag
		def initialize(aut,title,date,paper,pag)
			super(aut,title,date)
			@paper = paper
			@pag = pag
		end
		
		def to_s
			"#{autores} (#{fecha}). #{titulo}. #{paper}, pp. #{pag}"	
		end
	end
	
	class Digital < Journal
		attr_reader :formato, :site, :edicion, :url, :editor, :fechaAcc
		def initialize(aut,title,date,formato,site,edicion,url,editor,fechaAcc)
			super(aut,title,date)
			@formato = formato
			@site = site
			@edicion = edicion
			@url = url
			@editor = editor
			@fechaAcc = fechaAcc
		end
		
		def to_s
			"#{autores} (#{fecha}). #{titulo} (#{edicion}), #{formato}. #{site}: #{editor}. Disponible en: #{url} (#{fechaAcc})"
		end
	end
	
	class List
		include Enumerable
    	Node = Struct.new(:value, :prev, :next)
		attr_accessor :head, :tail
		
		def initialize()
			@head = nil
			@tail = nil
		end
		
		def add (ref)
			if ref.is_a? Ref
				if @head == nil
					@head = Node.new(ref, nil, nil)
					@tail = nil
				else
					if @tail == nil
						@tail = Node.new(ref, @head, nil)
						@head.next = @tail
					else
						aux = @tail
						@tail = Node.new(ref, aux, nil)
						aux.next = @tail
					end
				end
			elsif ref.instance_of? Array
				ref.each do |i|
					self.add(i)
				end
			else 
				raise "Error en el parametro de add"
			end
		end
		
		def subtract
			x = self.head
			@head = x.next
			if @head.next == nil
				@tail = nil
			end
			return x.value
		end
		
		def each
			if(@head == nil)
				yield nil
			elsif(@tail == nil)
				yield @head.value
			elsif
				aux=@head
				while(aux!=nil)
					yield aux.value
					aux = aux.next
				end
			end
		end
		
		def sort
			if @tail != nil
				change = true
				while change
					change = false
					item = @head
					next_item = @head[:next]
					while next_item != nil
						if(item.value > next_item.value)
							item[:value], next_item[:value] = next_item[:value], item[:value]
							change = true
						end
						item = next_item
						next_item = next_item[:next]
					end
				end
			else
				return
			end
		end
	end
	
	class RefList
		
		include Enumerable
		
		def initialize()
			@RefList = Bib::List.new
		end
		
		def insert(ref)
			@RefList.add(ref)
			@RefList.sort
		end
		
		def each
			@RefList.each{ |x| yield x}
		end
		def to_s
			str=""
			@RefList.each do |x|
				str << x.to_s
				str << "\n"
			end
			return str
		end
	end
end

	
