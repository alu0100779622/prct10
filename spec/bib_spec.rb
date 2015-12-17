require 'spec_helper'
require 'bib'

describe Bib do
  before :each do 
		@Lib1 = Bib::Book.new(["Dave Thomas", "Andy Hunt", "Chad Fowler"],
			"Programming Ruby 1.9 & 2.0: The Pragmatic Programmers' Guide",
			"July 7,2013","Pragmatic Bookshelf",
			4,1,"EEUU")
		@Lib2 = Bib::Book.new(["Scott Chacon"], 
			"Pro Git 2009th Edition",
			"August 27,2009","Apress","2009 edition",1,
			nil)
        @Lib3 = Bib::Book.new(["David Flanagan", "Yukihiro Matsumoto"],
        	"February 4,2008","The Ruby Programming Language",
            "O'Reilly Media","1 edition",1,nil)
        @Lib4 = Bib::Book.new(["David Chelimsky", "Dave Astels", "Bryan Helmkamp", "Dan North", "Zach Dennis", "Aslak Hellesoy"],
            "The RSpec Book: Behaviour Driven Development with RSpec, Cucumber, and Friends (The Facets of Ruby)",
            "December 25,2010","Pragmatic Bookshelf","1 edition",1,
            nil)
        @Lib5 = Bib::Book.new(["Richard E. Silverman"],
        	"Git Pocket Guide",
        	"August 2,2013","O'Reilly Media","1 edition",1,
            nil)
            
        @List = Bib::List.new
        @List.add @Lib1
        @ListVoid = Bib::List.new
	end

	describe "Expectativas de los atributos" do 
	  
		it "Hay uno o mas autores" do
			expect(@Lib1.autores).not_to be_empty
		end
		it "Debe existir un titulo" do
			expect(@Lib1.titulo.length).not_to be 0
		end
		it "Debe existir una fecha de publicacion" do
			expect(@Lib1.fecha.length).not_to be 0
		end
	end
	
	describe "Expectativas de los metodos" do 

		it "Existe un metodo para obtener el listado de autores." do
			@Lib1.autores == ["Dave Thomas", "Andy Hunt", "Chad Fowler"]
		end
		it "Existe un metodo para obtener el titulo." do
			@Lib1.titulo =="Programming Ruby 1.9 & 2.0: The Pragmatic Programmers' Guide"
		end
		
		it "Existe un metodo para obtener la fecha de publicacion." do
			@Lib1.fecha =="July 7,2013"
		end
		it "Existe un metodo para obtener la referencia formateada" do
		  expect(@Lib1.to_s).to eq("Thomas, D. & Hunt, A. & Fowler, C. (July 7,2013). Programming Ruby 1.9 & 2.0: The Pragmatic Programmers' Guide (4)(1). EEUU: Pragmatic Bookshelf ")
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
			@Book1 = Bib::Book.new(["Pepe Ter"],
			"ABC",
			1998,"editorial",nil,nil,
			nil)
			@Book2 = Bib::Book.new(["Pepe Ter"],
			"BCD",
			2000,"editorial",nil,nil,
			nil)
			@Book3 = Bib::Book.new(["Pepe Ter"],
			"CDE",
			1998,"editorial",nil,nil,
			nil)
		end
		
		it "Ref1 < Ref2" do
			expect(@Book1 > @Book3).to eq(true)
		end
		it "Ref1 >= Ref2" do
			expect(@Book1 <= @Book3).to eq(false)
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
	describe "(APA)" do
		before :all do
			@Bibliografia = Bib::RefList.new
			@Libro = Bib::Book.new(["Dave Thomas", "Andy Hunt", "Chad Fowler"],
			"Programming Ruby 1.9 & 2.0: The Pragmatic Programmers' Guide",
			"July 7,2013","Pragmatic Bookshelf",
			4,1,"EEUU")
			@Articulo = Bib::Magazine.new(["Carlos Area","Pedro Gimenez"],"El universo: Agujeros negros",2010,"Trompeta",7,2,"Argentina","Astrofísica",["Eduardo Morales","Jorge Castilla"],12)
			@Periodico = Bib::Newspaper.new(["Maria Gonzales","Omaira Alvarez"],"Politica del siglo XXI","Agosto 2012","Publico",2)
			@Web = Bib::Digital.new(["Alberto Cejas"],"Cambio climatico","2 Diciembre 1999","Blog","España",2,"www.blogdealberto.com","ONU","3 Enero 2004")
		end
		it "Insertar elementos, y ordenar automaticamnete" do
			@Bibliografia.insert(@Libro)
			@Bibliografia.insert(@Articulo)
			@Bibliografia.insert(@Periodico)
			@Bibliografia.insert(@Web)
			expect(@Bibliografia.to_s).to eq("Thomas, D. & Hunt, A. & Fowler, C. (July 7,2013). Programming Ruby 1.9 & 2.0: The Pragmatic Programmers' Guide (4)(1). EEUU: Pragmatic Bookshelf \nGonzales, M. & Alvarez, O. (Agosto 2012). Politica del siglo XXI. Publico, pp. 2\nCejas, A. (2 Diciembre 1999). Cambio climatico (2), Blog. España: ONU. Disponible en: www.blogdealberto.com (3 Enero 2004)\nArea, C. & Gimenez, P. (2010). Astrofísica. Morales, E. & Castilla, J., El universo: Agujeros negros (12) (7) (2). Argentina: Trompeta\n")
		end
	end
end




