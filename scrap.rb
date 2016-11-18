require 'mechanize'
require 'date'

=begin
séparer dans d'autre fichiers
=> faire un scraping des diverses sources comme ResearchGate / ORCID etc ...

Dates_de_soutenance (liées au document) + auteur et rôle
Etablissements (adresse géographique & académie) => faire un scraping pour les établissements à partir de la barre latérale /!\ caractère accentués
Disciplines (voir section CNRS) => faire un scraping pour les disciplines à partir de la barre latérale /!\ caractère accentués
Ecoles_Doctorales (coopération entre établissements - rattachée à une académie ? - une adresse géographique ? && concerne 1 à n Disciplines) => faire un scraping pour les ecoleDoctorales à partir de la barre latérale /!\ caractère accentués
Langues (liées au document => potentiel d'anayse par rapport aux Disciplines / Ecoles_Doctorales && Etablissements) => => faire un scraping pour les langues à partir de la barre latérale /!\ caractère accentués && croisé avec listes des langues et dialectes + les "codes" standardisés à partir de Wikipédia
Directeurs de thèse (liés au document => possibilité d'analyse la mobilité entre école | la Disciplines de rattachement et son évolution | par extension, les "coopérateurs" & co-auteurs etc ...)
Domaines (différence avec Disciplines ?) => faire un scraping pour les domaines à partir de la barre latérale /!\ caractère accentués /!\ croisé avec disciplines et identifier le référentiel

Zone 1, 2, 3
Documents "La Thèse":
titreRAs
motCleRAs
abstracts
disciplines
textes "Texte intégral"


Les organismes :
etabSoutenances
coTutelles
ecoleDoctorales
partenaireLabos
partenaireEquipeDeRecherches
partenaireEntreprises
partenaireFondations
partenaireAutres


Les personnes :
auteurs
directeurTheses
presidentJurys
rapporteurs
membreJurys
personneRAs "Tous rôles"


Zone 4
<select name="zone4" id="zone4">

                        <option value="dateSoutenance"

                            selected="selected"

                                                >Date de soutenance</option>

                        <option value="sujDatePremiereInscription"

                                                >Date d'inscription en doctorat</option>

                        <option value="sujDateSoutenancePrevue"

                                                >Date de soutenance prévue</option>

</select>
=end

startDate = "1965-01-01"
today = Date.today
starpage = 1

agent = Mechanize.new

#Initialize current_page from starpage
current_page  = starpage - 1
#Set url
url   = "http://theses.fr/?q=&fq=dateSoutenance:[#{startDate}T23:59:59Z%2BTO%2B#{Date.today.year}-12-31T23:59:59Z]&checkedfacets=&start=#{starpage}&sort=none&status=&access=&prevision=&filtrepersonne=&zone1=titreRAs&val1=&op1=AND&zone2=auteurs&val2=&op2=AND&zone3=etabSoutenances&val3=&op3=AND&zone4=dateSoutenance&val4a=&val4b=&type="
#Run Get content from url
page  = agent.get(url)
#Set last_page from page
last_page = 3 #(( page.at('#sNbRes').text.to_i ) / 10)*10

while current_page < last_page
  #Set url
  url   = "http://theses.fr/?q=&fq=dateSoutenance:[#{startDate}T23:59:59Z%2BTO%2B#{Date.today.year}-12-31T23:59:59Z]&checkedfacets=&start=#{current_page}&sort=none&status=&access=&prevision=&filtrepersonne=&zone1=titreRAs&val1=&op1=AND&zone2=auteurs&val2=&op2=AND&zone3=etabSoutenances&val3=&op3=AND&zone4=dateSoutenance&val4a=&val4b=&type="
  #Run Get content from url
  page  = agent.get(url)

  current_page += 1

  # show "resultat" block
  #links = page.search("#resultat")
  # get content from "encart"
  content_resultat = page.search("div#resultat")

  content_resultat.each do |block|

      #block informations
      link_document_id = block.search(".informations h2 a")[0]["href"]
      link_information_title = block.search(".informations h2 a")[0].text
      team_alpha = block.search(".informations p")[0].text

      #for member in team do
      #  TODO: #retraiter les membres, le lien vers les profil SI il existe et le " - Labo" avec son lien d'entité
      # => link_team_entity_id = block.search(".informations p a")["href"]
      # => entity_name = block.search(".informations p a").text
      #end

      #block domaine
      domaine = block.search(".domaine h5")[0].text
      # TODO : identify domaine & subdomaine
      statut_these_alpha = block.search(".domaine h5")[1].text
      # TODO : get separate information according to these_Statut & Date en REGEX => Rubular

      #block snippet
      #snipet avec lien vers doc accessible SI existant
      # TODO : retraiter
      document_availability = block.search(".snippet h5 a").text
      # TODO : retraiter
      dateSoutenance_prevision = block.search(".snippet h6").text

      puts link_document_id
      puts document_availability
      puts link_information_title
      puts dateSoutenance_prevision
      puts "------"
      #puts team_alpha
      #puts link_team_entity_id
      #puts entity_name
      #puts domaine
      #puts statut_these_alpha
#exit
  end
=begin
    agent_url   = "http://theses.fr/#{link["href"]}"
    agent_page  = agent2.get(agent_url)

    rows = agent_page.search("table.rnr-c.rnr-vrecord").css("tr")

    str = String.new

    rows.each do |row|

      if row.content.include?("[email")
        content = cf_decode(row.to_s.split.join(' ').scan(/data-cfemail="([0-9a-zA-Z]*)"/).first.first)
      else
        content = row.content.split.join(' ').gsub("\302\240", ' ').strip
      end

      str << content + ";"

    end

    File.open(filename + '.txt', 'a') { |file|
      file << str + "\n"
    }

    total_agents += 1

  end

  puts "Finished to scrap page #{current_page}/#{last_page} - Total agents scrapped : #{total_agents}"
=end
end
