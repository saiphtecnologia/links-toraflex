# Prompts para o Lovable — Página de Links (Bio) da Toraflex + gestão no admin

Migração da página de links (bio) da Toraflex para dentro do site no Lovable, **reutilizando o Lovable Cloud (Supabase) e a autenticação/admin que o projeto já tem**.

**Como usar:** cole **uma etapa por vez** no chat do Lovable, na ordem. Espere cada uma terminar (e aprovar mudanças de banco quando ele pedir) antes de ir para a próxima. Isso deixa o resultado mais fiel do que mandar tudo de uma vez.

---

## ETAPA 1 — Banco de dados (Lovable Cloud / Supabase)

> Objetivo: criar as tabelas, o bucket de imagens, as políticas de segurança e os dados iniciais. Use o Lovable Cloud (Supabase) que o projeto **já** usa — não crie outro backend.

```
No Lovable Cloud (Supabase) deste projeto, crie a estrutura para uma página de "link na bio". Não crie um backend novo — use o que já existe.

Crie 3 tabelas com RLS (leitura pública para anon; escrita apenas para usuários authenticated) e 1 bucket de Storage:

1) links: id (uuid pk default gen_random_uuid), title (text not null), description (text null), url (text not null), icon_key (text default 'globe'), highlight (text default 'none', check em 'none'|'primary'|'glow'), badge_text (text null), position (int default 0), created_at (timestamptz default now()).

2) social_links: id (uuid pk), icon_key (text default 'instagram'), label (text not null), url (text not null), position (int default 0), created_at.

3) site_content: linha única — id (smallint pk default 1, check id=1), logo_url, logo_alt, background_url, eyebrow_text, brand_subtitle, brand_copy, links_section_label, feature_kicker, feature_title, feature_text, feature_cta_label, feature_cta_url, social_label, highlight_primary_label (text not null default 'Vermelho em destaque (largura total)'), highlight_glow_label (text not null default 'Brilho vermelho'), updated_at (timestamptz default now()).

4) bucket de Storage 'site-media' (público) para upload de logo e imagem de fundo: leitura pública, escrita/atualização/exclusão só para authenticated.

Popule com este seed:

site_content (id=1):
- logo_alt: "Logo da Toraflex Colchões"
- eyebrow_text: "Há mais de 40 anos · Betim, MG"
- brand_subtitle: "Colchões que combinam qualidade, conforto e conformidade"
- brand_copy: "A escolha certa para todos os estilos de sono — fábrica nº 1 de colchões de Minas Gerais."
- links_section_label: "Nossos canais"
- feature_kicker: "Qualidade & Conformidade"
- feature_title: "Noites de sono com qualidade e conformidade."
- feature_text: "Conheça a linha completa de colchões de espuma, mola e ortopédicos, feita para transformar o seu descanso."
- feature_cta_label: "Conheça nossos colchões"
- feature_cta_url: "https://toraflex.com.br/"
- social_label: "Siga a Toraflex"

links (nesta ordem de position 1..7):
1. "Fale pelo WhatsApp" / "Atendimento direto com a nossa equipe." / https://wa.me/553138781402 / icon_key whatsapp / highlight primary
2. "Visite nosso site" / "Conheça a linha completa de colchões." / https://toraflex.com.br/ / icon_key globe / none
3. "Portal do Revendedor" / "Seja um parceiro Toraflex." / https://revenda.toraflex.com.br/ / icon_key cart / none
4. "Instagram" / "Novidades, bastidores e lançamentos." / https://www.instagram.com/toraflexcolchoes/ / icon_key instagram / none
5. "LinkedIn" / "Acompanhe a Toraflex no mundo corporativo." / https://www.linkedin.com/company/toraflex-colchoes / icon_key linkedin / none
6. "Ligue para a fábrica" / "(31) 3878-1400 · Betim, MG." / tel:+553138781400 / icon_key phone / none
7. "Como chegar?" / "BR-381 Fernão Dias, KM 500 · Betim, MG." / https://www.google.com/maps/search/?api=1&query=Toraflex+Colch%C3%B5es+Betim+MG / icon_key pin / none

social_links (position 1..3):
1. instagram / "Toraflex Colchões no Instagram" / https://www.instagram.com/toraflexcolchoes/
2. linkedin / "Toraflex Colchões no LinkedIn" / https://www.linkedin.com/company/toraflex-colchoes
3. whatsapp / "Falar com a Toraflex pelo WhatsApp" / https://wa.me/553138781402
```

---

## ETAPA 2 — Página pública `/links` (visual idêntico)

> Objetivo: criar a rota pública que renderiza a bio a partir do banco. Só rode depois da Etapa 1.

```
Crie a rota pública /links: uma página de "link na bio" que busca links, social_links e site_content do banco (ordenando por position) e renderiza dinamicamente. Se a busca falhar, use os dados do seed da Etapa 1 como fallback embutido, para nunca quebrar.

Design (reproduza fielmente — não use estilo genérico):

- Fonte: Manrope (Google Fonts).
- Cores como tokens Tailwind/variáveis CSS: azul principal #2a3082, vermelho acento #dc2626, branco #ffffff, texto suave #5b6182.
- Fundo cobrindo a viewport: gradiente linear-gradient(155deg, #2a3082 0%, #232a6e 55%, #1a1f52 100%). Se site_content.background_url estiver preenchido, usar essa imagem no lugar do gradiente.
- Painel central "glass": largura min(100%, 700px), fundo rgba(255,255,255,0.84), backdrop-filter blur(18px) saturate(1.08), borda 1px solid rgba(255,255,255,0.52), border-radius 28px, sombra 0 24px 70px rgba(42,48,130,0.22), com animação sutil de entrada (fade + slide up).
- Cabeçalho centralizado: logo (largura ~180–240px, sem moldura), eyebrow (texto pequeno em maiúsculas com um ponto azul antes), h1 grande peso 700, subtítulo peso 600, parágrafo de apresentação em texto suave.
- Grade de links: 1 coluna no mobile, 2 colunas a partir de 560px. Cada card = branco translúcido rgba(255,255,255,0.78), borda sutil, border-radius 18px, min-height ~92px, layout [ícone 48px] [título + descrição] [seta →]. Hover: leve elevação + borda azul.
  - highlight=primary: ocupa a largura total (2 colunas), fundo vermelho #dc2626, texto e ícone brancos.
  - highlight=glow: borda vermelha com animação de pulso e um selo no canto superior direito (texto = badge_text ou "Destaque").
- Cartão de destaque (feature) abaixo dos links: fundo gradiente linear-gradient(120deg, #2a3082 0%, #303aa0 55%, #444dc4 100%), texto branco, com kicker (com ponto), título, parágrafo e um botão branco arredondado (CTA) que abre feature_cta_url.
- Rodapé: seção "Siga a Toraflex" com ícones circulares das redes sociais (hover azul), nome da marca, "© Toraflex Colchões · Fabricado com qualidade em Betim, Minas Gerais" e o crédito "Desenvolvido por: SAIPH Digital" (link https://saiph.digital).
- Ícones: crie um mapa iconKey -> componente. Use lucide-react para globe (Globe), cart (ShoppingCart), phone (Phone), pin (MapPin), instagram (Instagram), linkedin (Linkedin), ruler (Ruler), tag (Tag), star (Star), heart (Heart), calendar (Calendar), email (Mail), message (MessageSquare); e react-icons para os logos ausentes no lucide: whatsapp (FaWhatsapp), tiktok (SiTiktok), facebook, youtube, x, telegram, pinterest, threads.
```

---

## ETAPA 3 — Gestão dentro do admin existente

> Objetivo: adicionar a edição desse conteúdo ao painel admin que o projeto já tem, usando a mesma autenticação. Só rode depois da Etapa 2.

```
Adicione ao painel administrativo que já existe neste projeto uma nova seção chamada "Links da Bio", protegida pela MESMA autenticação atual (não crie login novo). Siga o padrão de código, rotas e layout do admin existente — é uma seção nova dentro dele, não um app separado. Use componentes shadcn/ui (Tabs, Dialog, Input, Select, Button).

IMPORTANTE — navegação: adicione um NOVO ITEM DE MENU chamado "Links da Bio" (com um ícone, ex.: Link ou LayoutGrid do lucide) na navegação/menu lateral do admin que já existe, no mesmo estilo dos itens atuais, apontando para a rota dessa nova seção (ex.: /admin/links-bio). O item só aparece para o usuário autenticado. Garanta que dá para chegar na seção clicando por esse menu — não deixe a página acessível apenas por URL direta.

A seção "Links da Bio" tem 3 sub-abas:

1) Links: listar (ordenados por position), criar, editar, excluir e reordenar com setas ↑/↓ (trocando position). Formulário: seletor visual de ícone (grade com os ícones do mapa da Etapa 2), nome, descrição (opcional), URL, e campo "Destaque" (Nenhum / Vermelho em destaque (largura total) / Brilho vermelho). Quando Destaque = Brilho vermelho, mostrar campo opcional "Texto do selo" (badge_text).

2) Redes sociais: mesmo fluxo (criar/editar/excluir/reordenar) com ícone, nome (label) e URL.

3) Conteúdo do site: formulário que edita a linha única site_content — upload de logo e de imagem de fundo (enviando para o bucket site-media e salvando a URL pública), texto acima do título (eyebrow), subtítulo, texto de apresentação, título da seção de links, textos do cartão de destaque (kicker, título, texto, rótulo e URL do botão), título da seção de redes sociais e os rótulos das opções de destaque.

Toda escrita deve passar pela sessão autenticada (a RLS já bloqueia anônimos). Ao salvar, a página /links deve refletir as mudanças ao recarregar.
```

---

## ETAPA 4 (opcional) — Ajuste fino visual

Se algo sair diferente, use follow-ups pontuais, por exemplo:

```
Ajuste a página /links para bater exatamente com a especificação: use a fonte Manrope, o gradiente de fundo linear-gradient(155deg, #2a3082, #232a6e 55%, #1a1f52), o painel central "glass" com blur(18px) e fundo rgba(255,255,255,0.84), o card highlight=primary em largura total com fundo #dc2626 e texto branco, e o selo pulsante nos cards highlight=glow.
```

### Notas
- Como o Lovable Cloud é Supabase por baixo, o schema aqui é o mesmo do arquivo `supabase-schema.sql` deste repositório — pode usá-lo como referência se preferir criar as tabelas via SQL Editor.
- A rota `/links` pode depois ser apontada por um subdomínio (ex.: bio.toraflex.com.br) via configuração de domínio, se quiser.
- Logo/favicon oficiais da Toraflex estão em `assets/` deste repositório, caso precise subir no projeto do Lovable.
