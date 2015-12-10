require 'spec_helper'
require 'bib'

describe Bib do
  before :each do 
		@Lib1 = Bib::Book.new(["Dave Thomas", "Andy Hunt", "Chad Fowler"],
			"Programming Ruby 1.9 & 2.0: The Pragmatic Programmers' Guide",
			"The Facets of Ruby",
			"Pragmatic Bookshelf",4,"July 7,2013",
			["ISBN-13: 978-1937785499", "ISBN-10: 1937785491"])
		@Lib2 = Bib::Book.new("Scott Chacon", 
			"Pro Git 2009th Edition",
			"Pro",
			"Apress","2009 edition","August 27,2009",
            ["ISBN-13: 978-1430218333","ISBN-10: 1430218339"])
        @Lib3 = Bib::Book.new(["David Flanagan", "Yukihiro Matsumoto"],
        	"The Ruby Programming Language",
        	nil,
            "O'Reilly Media","1 edition","February 4,2008",
            ["ISBN-10: 0596516177", "ISBN-13: 978-0596516178"])
        @Lib4 = Bib::Book.new(["David Chelimsky", "Dave Astels", "Bryan Helmkamp", "Dan North", "Zach Dennis", "Aslak Hellesoy"],
            "The RSpec Book: Behaviour Driven Development with RSpec, Cucumber, and Friends (The Facets of Ruby)",
            nil,
            "Pragmatic Bookshelf","1 edition","December 25,2010",
            ["ISBN-10: 1934356379", "ISBN-13: 978-1934356371"])
        @Lib5 = Bib::Book.new("Richard E. Silverman",
        	"Git Pocket Guide",
        	nil,
        	"O'Reilly Media","1 edition","August 2,2013",
            ["ISBN-10: 1449325866","ISBN-13: 978-1449325862"])
            
        @List = Bib::List.new @Lib1
        @ListVoid = Bib::List.new nil
        
	end

	describe "Expectativas de los atributos" do 
	  
		it "Hay uno o mas autores" do
			expect(@Lib1.autores).not_to be_empty
		end
		it "Debe existir un titulo" do
			expect(@Lib1.titulo.length).not_to be 0
		end
		it "Debe existir o no una serie" do
			expect(@Lib1.serie.length).to be >=0
		end
		it "Debe existir una editorial" do
			expect(@Lib1.editorial.length).not_to be 0
		end
		it "Debe existir un numero de edicion" do
			expect(@Lib1.numEdicion.to_s.length).not_to be 0
		end
		it "Debe existir una fecha de publicacion" do
			expect(@Lib1.fecha.length).not_to be 0
		end
		it "Debe existir uno o mas numeros ISBN." do
			expect(@Lib1.numISBN).not_to be_empty
		end
	end
	
	describe "Expectativas de los metodos" do 

		it "Existe un metodo para obtener el listado de autores." do
			@Lib1.autores == ["Dave Thomas", "Andy Hunt", "Chad Fowler"]
		end
		it "Existe un metodo para obtener el titulo." do
			@Lib1.titulo =="Programming Ruby 1.9 & 2.0: The Pragmatic Programmers' Guide"
		end
		it "Existe un metodo para obtener la serie" do
			@Lib1.serie =="The Facets of Ruby"
		end
		it "Existe un metodo para obtener la editorial." do
			@Lib1.editorial =="Pragmatic Bookshelf"
		end
		it "Existe un metodo para obtener el numero de edicion" do
			@Lib1.numEdicion == 4
		end
		it "Existe un metodo para obtener la fecha de publicacion." do
			@Lib1.fecha =="July 7,2013"
		end
		it "Existe un metodo para obtener el listado de ISBN" do
			@Lib1.numISBN == ["ISBN-13: 978-1937785499", "ISBN-10: 1937785491"]
		end
		it "Existe un metodo para obtener la referencia formateada" do
		  expect(@Lib1.to_s).to eq("Dave Thomas, Andy Hunt, Chad Fowler.\nProgramming Ruby 1.9 & 2.0: The Pragmatic Programmers' Guide\n(The Facets of Ruby)\nPragmatic Bookshelf; 4 edicion July 7,2013\nISBN-13: 978-1937785499\nISBN-10: 1937785491")
	    end
	end
	
	describe "Clase List" do
		
		it "Se puede insertar un elemento" do
			@List.add(@Lib2)
			@List.head.next.should eq @List.tail
		end
		
		it "Se pueden insertar varios elementos" do
			@List.add([@Lib2,@Lib3,@Lib4,@Lib5])
			@List.head.value.should eq @Lib1
			@List.head.next.value.should eq @Lib2
			@List.tail.value.should eq @Lib5
		end
		
		it "Se extrae el primer elemento de la lista" do
			@List.add(@Lib2)
			@List.subtract.should eq @Lib1
			@List.head.value.should eq @Lib2
			@List.tail.should eq nil
			
		end
		it "Debe existir una Lista con su cabeza" do
			@List.head.should_not eq nil	
		end
		it "Los elementos de la lista contienen su siguiente y su predecesor" do
			@List.add([@Lib2,@Lib3])
			aux = @List.head.next
			aux.next.value.should eq @Lib3
			aux.prev.value.should eq @Lib1
			
		end
	end
	
	describe "Expectativas para Node" do
		
		it "Debe existir un Nodo de la lista con sus datos y su siguiente" do
			@List.add(@Lib2)
			@List.head.value.should eq @Lib1
			@List.head.next.value.should eq @Lib2
		end
		it "Debe existir un Nodo con su anterior" do
			@List.add(@Lib2)
			aux = @List.head.next
			aux.prev.value.should eq @Lib1
		end
	end
	
	describe "Jerarquias" do 
		it "Existe una jerarquia en las clases" do
			expect(@Lib1).to be_a Bib::Book	
		end
	end
	
	describe "Expectativas Comparable" do
		before :each do
			@Book1 = Bib::Book.new("Pepe",
			"Libro1",
			nil,
			"editorial",nil,1998,
			nil)
			@Book2 = Bib::Book.new("Pablo",
			"Libro2",
			nil,
			"editorial",nil,2000,
			nil)
			@Book3 = Bib::Book.new("Pepe",
			"Libro3",
			nil,
			"editorial",nil,2004,
			nil)
		end
		
		it "Comparacion entre dos referencias" do
			expect(@Lib1 == @Lib1).to eq(true)
			expect(@Lib1 == @Lib2).to eq(false)
		end
		it "Ref1 < Ref2" do
			expect(@Book1 < @Book3).to eq(true)
		end
		it "Ref1 >= Ref2" do
			expect(@Book1 >= @Book3).to eq(false)
		end
	end
	
	describe "Expectativas Enumerable" do
		it "Comprobrando el metodo all?" do
			expect(@List.all?).to eq(true)
			expect(@ListVoid.all?).to eq(false)
		end
		it "Comprobrando el metodo any?" do
    		expect(@List.any?).to eq(true)
      		expect(@ListVoid.any?).to eq(false)
		end 
		it "Comprobrando el metodo count" do
      		expect(@List.count).to eq(1)
      		@List.add @Lib2
      		expect(@List.count).to eq(2)
    	end
	end
end
