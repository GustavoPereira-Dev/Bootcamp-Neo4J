// --- 1. Constraints ---
CREATE CONSTRAINT IF NOT EXISTS FOR (u:User) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (m:Movie) REQUIRE m.id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (s:Series) REQUIRE s.id IS UNIQUE;

// --- 2. Gêneros ---
CREATE (:Genre {name: 'Sci-Fi'}), (:Genre {name: 'Drama'}), (:Genre {name: 'Ação'}), 
       (:Genre {name: 'Comédia'}), (:Genre {name: 'Terror'}), (:Genre {name: 'Fantasia'}),
       (:Genre {name: 'Crime'}), (:Genre {name: 'Aventura'});

// --- 3. Diretores e Atores ---
CREATE (d1:Director {name: 'Christopher Nolan'}),
       (d2:Director {name: 'Quentin Tarantino'}),
       (d3:Director {name: 'Martin Scorsese'}),
       (d4:Director {name: 'Greta Gerwig'}),
       (d5:Director {name: 'Denis Villeneuve'}),
       (a1:Actor {name: 'Leonardo DiCaprio'}),
       (a2:Actor {name: 'Cillian Murphy'}),
       (a3:Actor {name: 'Margot Robbie'}),
       (a4:Actor {name: 'Timothée Chalamet'}),
       (a5:Actor {name: 'Samuel L. Jackson'}),
       (a6:Actor {name: 'Zendaya'}),
       (a7:Actor {name: 'Robert De Niro'}),
       (a8:Actor {name: 'Millie Bobby Brown'});

// --- 4. Filmes (20 itens) ---
CREATE (m1:Movie {id: 'M1', title: 'Inception', year: 2010}),
       (m2:Movie {id: 'M2', title: 'The Dark Knight', year: 2008}),
       (m3:Movie {id: 'M3', title: 'Interstellar', year: 2014}),
       (m4:Movie {id: 'M4', title: 'Pulp Fiction', year: 1994}),
       (m5:Movie {id: 'M5', title: 'The Matrix', year: 1999}),
       (m6:Movie {id: 'M6', title: 'Oppenheimer', year: 2023}),
       (m7:Movie {id: 'M7', title: 'Kill Bill: Vol. 1', year: 2003}),
       (m8:Movie {id: 'M8', title: 'The Wolf of Wall Street', year: 2013}),
       (m9:Movie {id: 'M9', title: 'Barbie', year: 2023}),
       (m10:Movie {id: 'M10', title: 'Dune', year: 2021}),
       (m11:Movie {id: 'M11', title: 'Goodfellas', year: 1990}),
       (m12:Movie {id: 'M12', title: 'Django Unchained', year: 2012}),
       (m13:Movie {id: 'M13', title: 'Tenet', year: 2020}),
       (m14:Movie {id: 'M14', title: 'Shutter Island', year: 2010}),
       (m15:Movie {id: 'M15', title: 'The Departed', year: 2006}),
       (m16:Movie {id: 'M16', title: 'Little Women', year: 2019}),
       (m17:Movie {id: 'M17', title: 'Once Upon a Time in Hollywood', year: 2019}),
       (m18:Movie {id: 'M18', title: 'The Prestige', year: 2006}),
       (m19:Movie {id: 'M19', title: 'Blade Runner 2049', year: 2017}),
       (m20:Movie {id: 'M20', title: 'The Hateful Eight', year: 2015});

// --- 5. Séries (10 itens) ---
CREATE (s1:Series {id: 'S1', title: 'Breaking Bad', seasons: 5}),
       (s2:Series {id: 'S2', title: 'Stranger Things', seasons: 4}),
       (s3:Series {id: 'S3', title: 'The Crown', seasons: 6}),
       (s4:Series {id: 'S4', title: 'The Boys', seasons: 3}),
       (s5:Series {id: 'S5', title: 'Black Mirror', seasons: 6}),
       (s6:Series {id: 'S6', title: 'Succession', seasons: 4}),
       (s7:Series {id: 'S7', title: 'The Bear', seasons: 2}),
       (s8:Series {id: 'S8', title: 'The Last of Us', seasons: 1}),
       (s9:Series {id: 'S9', title: 'Mindhunter', seasons: 2}),
       (s10:Series {id: 'S10', title: 'Euphoria', seasons: 2});

// --- 6. Usuários (30 usuários) ---
UNWIND range(1, 30) AS i
CREATE (:User {id: i, name: 'User_' + i});

// --- 7. Relacionamentos de Equipe (Diretores/Atores) ---
MATCH (d:Director {name: 'Christopher Nolan'}), (m:Movie) WHERE m.title IN ['Inception', 'Interstellar', 'The Dark Knight', 'Oppenheimer', 'Tenet', 'The Prestige'] CREATE (d)-[:DIRECTED]->(m);
MATCH (d:Director {name: 'Quentin Tarantino'}), (m:Movie) WHERE m.title IN ['Pulp Fiction', 'Kill Bill: Vol. 1', 'Django Unchained', 'Once Upon a Time in Hollywood', 'The Hateful Eight'] CREATE (d)-[:DIRECTED]->(m);
MATCH (d:Director {name: 'Martin Scorsese'}), (m:Movie) WHERE m.title IN ['The Wolf of Wall Street', 'Goodfellas', 'Shutter Island', 'The Departed'] CREATE (d)-[:DIRECTED]->(m);
MATCH (d:Director {name: 'Greta Gerwig'}), (m:Movie) WHERE m.title IN ['Barbie', 'Little Women'] CREATE (d)-[:DIRECTED]->(m);
MATCH (d:Director {name: 'Denis Villeneuve'}), (m:Movie) WHERE m.title IN ['Dune', 'Blade Runner 2049'] CREATE (d)-[:DIRECTED]->(m);

MATCH (a:Actor {name: 'Leonardo DiCaprio'}), (m:Movie) WHERE m.title IN ['Inception', 'The Wolf of Wall Street', 'Shutter Island', 'The Departed', 'Once Upon a Time in Hollywood'] CREATE (a)-[:ACTED_IN]->(m);
MATCH (a:Actor {name: 'Cillian Murphy'}), (m:Movie) WHERE m.title IN ['Inception', 'The Dark Knight', 'Oppenheimer'] CREATE (a)-[:ACTED_IN]->(m);
MATCH (a:Actor {name: 'Margot Robbie'}), (m:Movie) WHERE m.title IN ['The Wolf of Wall Street', 'Barbie', 'Once Upon a Time in Hollywood'] CREATE (a)-[:ACTED_IN]->(m);
MATCH (a:Actor {name: 'Timothée Chalamet'}), (m:Movie) WHERE m.title IN ['Interstellar', 'Dune', 'Little Women'] CREATE (a)-[:ACTED_IN]->(m);
MATCH (a:Actor {name: 'Zendaya'}), (m:Movie) WHERE m.title IN ['Dune'] CREATE (a)-[:ACTED_IN]->(m);
MATCH (a:Actor {name: 'Zendaya'}), (s:Series {title: 'Euphoria'}) CREATE (a)-[:ACTED_IN]->(s);

// --- 8. Relacionamentos de Gênero ---
MATCH (m:Movie), (g:Genre {name: 'Sci-Fi'}) WHERE m.title IN ['Inception', 'Interstellar', 'The Matrix', 'Oppenheimer', 'Tenet', 'Dune', 'Blade Runner 2049'] CREATE (m)-[:IN_GENRE]->(g);
MATCH (m:Movie), (g:Genre {name: 'Crime'}) WHERE m.title IN ['Pulp Fiction', 'The Dark Knight', 'The Wolf of Wall Street', 'Goodfellas', 'The Departed', 'Django Unchained'] CREATE (m)-[:IN_GENRE]->(g);
MATCH (s:Series), (g:Genre {name: 'Drama'}) WHERE s.title IN ['Breaking Bad', 'The Crown', 'Succession', 'The Bear', 'The Last of Us', 'Euphoria', 'Mindhunter'] CREATE (s)-[:IN_GENRE]->(g);

// --- 9. População de Avaliações Aleatórias (WATCHED) ---
// Simula 150 avaliações distribuídas aleatoriamente
MATCH (u:User), (v) WHERE v:Movie OR v:Series
WITH u, v, rand() AS r
WHERE r > 0.85
CREATE (u)-[:WATCHED {rating: duration({days: toInteger(rand()*5) + 1}).days}]->(v);