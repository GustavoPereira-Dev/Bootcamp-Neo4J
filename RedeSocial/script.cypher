// =========================================================================
// 1. LIMPEZA E CONFIGURAÇÃO DE INTEGRIDADE
// =========================================================================
MATCH (n) DETACH DELETE n;

CREATE CONSTRAINT IF NOT EXISTS FOR (u:User) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (c:Company) REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (p:Post) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (e:Event) REQUIRE e.id IS UNIQUE;

// =========================================================================
// 2. CRIAÇÃO DE ENTIDADES (50 NÓS POR TIPO)
// =========================================================================

// --- 50 Empresas (Company) ---
UNWIND range(1, 50) AS i
CREATE (:Company {
    id: 'COMP_' + i,
    name: ['TechNova', 'DataStream', 'CreativeFlow', 'CyberLogic', 'CloudSystems'][toInteger(rand()*5)] + ' ' + i,
    industry: ['Software', 'Big Data', 'Design', 'Cibersegurança', 'Infraestrutura'][toInteger(rand()*5)],
    city: ['São Paulo', 'Curitiba', 'Rio de Janeiro', 'Belo Horizonte', 'Recife'][toInteger(rand()*5)]
});

// --- 50 Usuários (User) com Personas ---
UNWIND range(1, 50) AS i
CREATE (:User {
    id: i,
    name: ['Ana', 'Bruno', 'Carla', 'Diego', 'Elena', 'Fabio', 'Gabi', 'Hugo', 'Iara', 'João'][toInteger(rand()*10)] + ' ' + 
          ['Tech_Lead', 'DevOps', 'Data_Viz', 'Investor', 'Researcher', 'Manager', 'Designer'][toInteger(rand()*7)] + '_' + i,
    seniority: ['Junior', 'Pleno', 'Senior', 'Specialist', 'Director'][toInteger(rand()*5)],
    influence_score: rand() * 100
});

// --- 50 Eventos (Event) ---
UNWIND range(1, 50) AS i
CREATE (:Event {
    id: 'EV_' + i,
    title: ['Summit', 'Workshop', 'Meetup', 'Conference', 'Expo'][toInteger(rand()*5)] + ' de ' + 
           ['IA', 'Grafos', 'Cloud', 'Segurança', 'Agile'][toInteger(rand()*5)] + ' 2026',
    topic: ['Tecnologia', 'Negócios', 'Inovação'][toInteger(rand()*3)]
});

// --- 50 Hashtags ---
UNWIND range(1, 50) AS i
CREATE (:Hashtag {tag: 'Trend_' + i});

// =========================================================================
// 3. CRIAÇÃO DE CONTEÚDO E RELACIONAMENTOS (ESTRUTURA DE REDE)
// =========================================================================

// --- Criação de Posts e Autoria (1 por usuário) ---
UNWIND range(1, 50) AS i
MATCH (u:User {id: i})
CREATE (u)-[:AUTHORED]->(:Post {
    id: 1000 + i,
    content: 'Insight técnico sobre o mercado ' + i,
    date: date(),
    views: toInteger(rand()*1000)
});

// --- Relacionamentos Aleatórios de Rede ---

// Trabalha em (WORKS_AT)
MATCH (u:User), (c:Company) WHERE rand() < 0.1 CREATE (u)-[:WORKS_AT]->(c);

// Participação em Eventos (ATTENDED)
MATCH (u:User), (e:Event) WHERE rand() < 0.15 CREATE (u)-[:ATTENDED]->(e);

// Rede de Seguidores (FOLLOWS)
MATCH (u1:User), (u2:User) WHERE u1 <> u2 AND rand() < 0.08 CREATE (u1)-[:FOLLOWS]->(u2);

// Engajamento (LIKED)
MATCH (u:User), (p:Post) WHERE rand() < 0.2 CREATE (u)-[:LIKED]->(p);

// Categorização (TAGGED)
MATCH (p:Post), (h:Hashtag) WHERE rand() < 0.1 CREATE (p)-[:TAGGED]->(h);

// =========================================================================
// 4. QUERIES DE INTELIGÊNCIA DE NEGÓCIO (INSIGHTS)
// =========================================================================

// --- A. Top 3 Hashtags Mais Usadas por Empresa (Tendências) ---
MATCH (c:Company)<-[:WORKS_AT]-(u:User)-[:AUTHORED]->(p:Post)-[:TAGGED]->(h:Hashtag)
WITH c.name AS Empresa, h.tag AS Hashtag, count(p) AS Frequencia
ORDER BY Empresa, Frequencia DESC
WITH Empresa, collect({hashtag: Hashtag, total: Frequencia})[0..2] AS TopTendencias
RETURN Empresa, TopTendencias;

// --- B. Identificação de Influenciadores por Engajamento ---
MATCH (u:User)-[:AUTHORED]->(p:Post)<-[l:LIKED]-()
RETURN u.name AS Autor, count(l) AS Total_Likes
ORDER BY Total_Likes DESC LIMIT 10;

// --- C. Sugestão de Networking (Amigos de Amigos) ---
MATCH (me:User {id: 1})-[:FOLLOWS]->(amigo)-[:FOLLOWS]->(sugestao:User)
WHERE NOT (me)-[:FOLLOWS]->(sugestao) AND sugestao <> me
RETURN sugestao.name, count(*) AS Conexoes_em_Comum
ORDER BY Conexoes_em_Comum DESC LIMIT 5;