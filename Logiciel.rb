######################################################################################################################################################################################################
# Nom : Logiciel atelier                                                                                                                                                                             #
# Auteur : Spyrojojo (Jonathan Vanhoutte)                                                                                                                                                            #
# Version 0.0.0.6                                                                                                                                                                                    #
######################################################################################################################################################################################################
require 'gosu'
require 'roo'
Name = "Logiciel atelier"
Version = "0.0.0.6"
Hauteur = 600
Largeur = 800
Full = false
Font_base = "Bell MT"
Font_bar = "Arial"
File_interface = "Ressource/Interface.png"
######################################################################################################################################################################################################

#------------------------------------------------------#
# * Module Gosu couleur                              * #
#------------------------------------------------------#
module Color
  #Color interface
  Background = Gosu::Color.new(25, 25, 25)
  Info = Gosu::Color.new(45, 45, 45)
  Toolbar = Gosu::Color.new(75, 75, 75)
  Toolbar_name = Gosu::Color.new(55, 55, 55)
  Rendu_color = Gosu::Color.new(25, 50, 75)

  #Color text
  Text_info = Gosu::Color.new(85, 85, 85)
  Text_name = Gosu::Color.new(10, 10, 10)
  Text_window = Gosu::Color.new(0, 0, 0)
end

#------------------------------------------------------#
# * Module taille/position des fenetre d'interface   * #
#------------------------------------------------------#
module Coord
  #Window info
  Info_width = Largeur
  Info_height = 13
  Info_x = 0
  Info_y = Hauteur-Info_height

  #Window essence
  Essence_width =  240
  Essence_height = 120
  Essence_x = 20 
  Essence_y = 20

  #Window bordereau
  Bordereau_width = 240
  Bordereau_height =  160#Hauteur-Info_height-Essence_height-60
  Bordereau_x = 20
  Bordereau_y = 160

  #Window Rendu
  Rendu_width = 500
  Rendu_height = 540
  Rendu_x = Essence_width+40 
  Rendu_y = 20

  #Divers
  Espace = 15
end
########################################################
# * Classe de la database du bois                    * #
# ID : nil                                             #
########################################################
class Data_wood
  def initialize(ref)
    @data_wood_name = Roo::Excelx.new("Data/Bois.xlsx")
    $data_wood_choix = 2
  end
  def update
    $dt_wood_name = @data_wood_name.cell($data_wood_choix, "A")
    $dt_wood_mass = @data_wood_name.cell($data_wood_choix, "B").to_i
    $dt_wood_price = @data_wood_name.cell($data_wood_choix, "C").to_i
  end
end

########################################################
# * Classe de la souris                              * #
# ID : 9999                                            #
########################################################
class Mouse
  def initialize(ref); @mouse_picture = Gosu::Image.new(ref, "Ressource/Mouse.png", true); end
  def draw(x,y); @mouse_picture.draw(x, y, 9999); end
end

########################################################
# * Classe de la fenetre de rendu                    * #
# ID : 1 a 20                                          #
########################################################
class Window_rendu
  def initialize(ref)
    @picture_rendu = Gosu::Image.new(ref, File_interface, true)
  end
  def draw
    @picture_rendu.draw_rot(Coord::Rendu_x, Coord::Rendu_y, 1, 0, 0, 0, Coord::Rendu_width,  Coord::Rendu_height, Color::Rendu_color, :default)
  end
end

########################################################
# * Classe de la fenetre de bordereau                * #
# ID : 21 a 40                                         #
########################################################
class Window_bordereau
  def initialize(ref)
    @picture_bordereau = Gosu::Image.new(ref, File_interface, true)
    @picture_bordereau_bar = Gosu::Image.new(ref, File_interface, true)
    @bordereau_name = Gosu::Image.from_text(ref, "Information sur l'objet", Font_bar, 12)
    @bordereau_text_poid = Gosu::Font.new(ref, Font_base, 16)
    @bordereau_text_cout = Gosu::Font.new(ref, Font_base, 16)
    @bordereau_text_prix = Gosu::Font.new(ref, Font_base, 16)
    @bordereau_text_fdp = Gosu::Font.new(ref, Font_base, 16)
    @bordereau_text_height = Gosu::Font.new(ref, Font_base, 16)
    @bordereau_text_width = Gosu::Font.new(ref, Font_base, 16)
  end
  def draw
    @picture_bordereau.draw_rot(Coord::Bordereau_x, Coord::Bordereau_y, 21, 0, 0, 0, Coord::Bordereau_width,  Coord::Bordereau_height, Color::Toolbar, :default)
    @picture_bordereau_bar.draw_rot(Coord::Bordereau_x, Coord::Bordereau_y, 22, 0, 0, 0, Coord::Bordereau_width,  13, Color::Toolbar_name, :default)
    @bordereau_name.draw(Coord::Bordereau_x+5, Coord::Bordereau_y+1, 23, 1, 1, Color::Text_name)
    @bordereau_text_poid.draw("-Poid total : 0g", Coord::Bordereau_x+5, (Coord::Bordereau_y+5)+Coord::Espace, 24, 1, 1, Color::Text_window)
    @bordereau_text_cout.draw("-Cout de prodution : 0E", Coord::Bordereau_x+5, (Coord::Bordereau_y+5)+(Coord::Espace*2), 25, 1, 1, Color::Text_window)
    @bordereau_text_prix.draw("-Prix de vente (eventuel) : 0E", Coord::Bordereau_x+5, (Coord::Bordereau_y+5)+(Coord::Espace*3), 26, 1, 1, Color::Text_window)
    @bordereau_text_fdp.draw("-Frais de port (eventuel) : 0E", Coord::Bordereau_x+5, (Coord::Bordereau_y+5)+(Coord::Espace*4), 27, 1, 1, Color::Text_window)
    @bordereau_text_height.draw("-Hauteur de l'objet : 0cm", Coord::Bordereau_x+5, (Coord::Bordereau_y+5)+(Coord::Espace*5), 28, 1, 1, Color::Text_window)
    @bordereau_text_width.draw("-Largeur de l'objet : 0cm", Coord::Bordereau_x+5, (Coord::Bordereau_y+5)+(Coord::Espace*6), 29, 1, 1, Color::Text_window)
  end
end

########################################################
# * Classe de la fenetre des essences                * #
# ID : 41 a 60                                         #
########################################################
class Window_essence
  def initialize(ref)
    @picture_essence = Gosu::Image.new(ref, File_interface, true)
    @picture_essence_bar = Gosu::Image.new(ref, File_interface, true)
    @essence_name = Gosu::Image.from_text(ref, "Essence de bois", Font_bar, 12)
    @essence_picture_list = Gosu::Image.new(ref, "Ressource/Essence.png", true)
    @essence_text_name = Gosu::Font.new(ref, Font_base, 16)
    @essence_text_poid = Gosu::Font.new(ref, Font_base, 16)
    @essence_text_prix = Gosu::Font.new(ref, Font_base, 16)
  end
  def draw
    @picture_essence.draw_rot(Coord::Essence_x, Coord::Essence_y, 41, 0, 0, 0, Coord::Essence_width,  Coord::Essence_height, Color::Toolbar, :default)
    @picture_essence_bar.draw_rot(Coord::Essence_x, Coord::Essence_y, 42, 0, 0, 0, Coord::Essence_width,  13, Color::Toolbar_name, :default)
    @essence_name.draw(Coord::Essence_x+5, Coord::Essence_y+1, 43, 1, 1, Color::Text_name)
    @essence_picture_list.draw(Coord::Essence_x, Coord::Essence_y+13, 44)
    @essence_text_name.draw("-Nom : #{$dt_wood_name}", Coord::Essence_x+5, (Coord::Essence_y+40)+Coord::Espace, 45, 1, 1, Color::Text_window)
    @essence_text_poid.draw("-Poid : #{$dt_wood_mass}", Coord::Essence_x+5, (Coord::Essence_y+40)+(Coord::Espace*2), 46, 1, 1, Color::Text_window)
    @essence_text_prix.draw("-Prix (m3): #{$dt_wood_price}", Coord::Essence_x+5, (Coord::Essence_y+40)+(Coord::Espace*3), 47, 1, 1, Color::Text_window)
  end
end

########################################################
# * Classe de la fenetre d'info                      * #
# ID : 61 a 80                                         #
########################################################
class Window_info
  def initialize(ref)
    @picture_info = Gosu::Image.new(ref, File_interface, true)
    @text_info  = Gosu::Font.new(ref, Font_bar, 12)
  end 
  def draw(ref)
    @picture_info.draw_rot(Coord::Info_x, Coord::Info_y, 61, 0, 0, 0, Coord::Info_width,  Coord::Info_height, Color::Info, :default)
    @text_info.draw("Version : #{Version} <> Resolution : #{Hauteur}/#{Largeur} <> Database : nill <> Mouse x = #{ref.mouse_x.to_i}/ Mouse y = #{ref.mouse_y.to_i}",Coord::Info_x+5, Coord::Info_y+1, 62, 1, 1, Color::Text_info)
  end
end

########################################################
# * Classe de la fenetre de base                     * #
# ID : 81 a 100                                        #
########################################################
class Window_base < Gosu::Window
  def initialize
    super(Largeur, Hauteur, Full)
    self.caption = "#{Name} - #{Version} - Press escape to exit"
    @back = Gosu::Image.new(self, File_interface, true)
    @wait_go = true
    #Nouvelle class
    @window_info = Window_info.new(self)
    @window_essence = Window_essence.new(self)
    @window_bordereau = Window_bordereau.new(self)
    @window_rendu = Window_rendu.new(self)
    @mouse = Mouse.new(self)
    @data_wood = Data_wood.new(self)
  end
  def button_down(id)
    close if id == Gosu::KbEscape
  end
  def draw
    @back.draw_rot(0, 0, -100, 0, 0, 0, Largeur, Hauteur, Color::Background, :default)
    @window_info.draw(self)
    @window_essence.draw
    @window_bordereau.draw
    @window_rendu.draw
    @mouse.draw(self.mouse_x, self.mouse_y)
  end
  def choice_wood
    $data_wood_choix += 1 if button_down?(Gosu::MsLeft) && @wait_go == true
    $data_wood_choix -= 1 if button_down?(Gosu::MsRight) && @wait_go == true
    $data_wood_choix %= 9
    $data_wood_choix = 2 if $data_wood_choix == 0
    if button_down?(Gosu::MsRight) or button_down?(Gosu::MsLeft) 
      @wait_go = false
    else
      @wait_go = true
    end
  end
  def update
    @data_wood.update
    choice_wood
  end
end

Window_base.new.show
