Date::MONTHS = {
 'Janvier' => 1,
 'Fevrier' => 2,
 'Mars' => 3,
 'Avril' => 4,
 'Mai' => 5,
 'Juin' => 6,
 'Juillet' => 7,
 'Aout' => 8,
 'Septembre'=> 9,
 'Octobre' =>10,
 'Novembre' =>11,
 'Decembre' =>12 }
Date::DAYS = {
 'Lundi' => 0,
 'Mardi' => 1,
 'Mercredi' => 2,
 'Jeudi'=> 3,
 'Vendredi' => 4,
 'Samedi' => 5,
 'Dimanche' => 6 }
Date::ABBR_MONTHS = {
 'jan' => 1,
 'fev' => 2,
 'mar' => 3,
 'avr' => 4,
 'mai' => 5,
 'juin' => 6,
 'juil' => 7,
 'aou' => 8,
 'sep' => 9,
 'oct' =>10,
 'nov' =>11,
 'dec' =>12 }
Date::ABBR_DAYS = {
 'lun' => 0,
 'mar' => 1,
 'mer' => 2,
 'jeu' => 3,
 'ven' => 4,
 'sam' => 5,
 'dim' => 6 }
Date::MONTHNAMES = [nil] + %w(Janvier Fevrier Mars Avril Mai Juin Juillet Aout Septembre Octobre
 Novembre Decembre )
Date::DAYNAMES = %w(Lundi Mardi Mercredi Jeudi Vendredi Samedi Dimanche )
Date::ABBR_MONTHNAMES = [nil] + %w(jan fev mar avr mai juin juil aou sep oct nov dec)
Date::ABBR_DAYNAMES = %w(lun mar mer jeu ven sam dim)

class Time
 alias :strftime_nolocale :strftime
 
 def strftime(format)
  format = format.dup
  format.gsub!(/%a/, Date::ABBR_DAYNAMES[self.wday])
  format.gsub!(/%A/, Date::DAYNAMES[self.wday])
  format.gsub!(/%b/, Date::ABBR_MONTHNAMES[self.mon])
  format.gsub!(/%B/, Date::MONTHNAMES[self.mon])
  self.strftime_nolocale(format)
 end
end


