-- Rode este script inteiro em: Supabase → SQL Editor → New query → Run.
-- Cria a tabela "links" (os botões da página), protege a escrita por login
-- e já popula com os 7 links que estavam fixos no index.html.

create table public.links (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  url text not null,
  icon_key text not null default 'globe',
  highlight text not null default 'none' check (highlight in ('none', 'primary', 'glow')),
  position integer not null default 0,
  created_at timestamptz not null default now()
);

alter table public.links enable row level security;

-- Qualquer visitante (chave anon) pode ler os links, para a página pública funcionar.
create policy "Public can read links"
  on public.links
  for select
  to anon
  using (true);

-- Só quem estiver logado (o admin) pode inserir, editar ou excluir.
create policy "Authenticated can manage links"
  on public.links
  for all
  to authenticated
  using (true)
  with check (true);

-- Seed com os links atuais do site, na mesma ordem e destaque de hoje.
insert into public.links (title, description, url, icon_key, highlight, position) values
  ('Fale pelo WhatsApp', 'Atendimento direto com a nossa equipe.', 'https://wa.me/5537999974543?text=Ol%C3%A1%2C%20vim%20pela%20p%C3%A1gina%20de%20links%20da%20Arte%20Mineira%20e%20gostaria%20de%20mais%20informa%C3%A7%C3%B5es.', 'whatsapp', 'primary', 1),
  ('Visite nosso site', 'Veja nossas linhas e novidades.', 'https://artemineira-moveis.stoqui.shop/', 'globe', 'none', 2),
  ('Solicite um orçamento', 'Conte sobre o seu projeto.', 'https://wa.me/5537999974543?text=Ol%C3%A1%2C%20gostaria%20de%20solicitar%20um%20or%C3%A7amento%20para%20meu%20projeto.', 'ruler', 'none', 3),
  ('Grupo de Ofertas', 'Condições especiais em primeira mão.', 'https://chat.whatsapp.com/IwEYWei6MtmLkGCMYT4izq', 'tag', 'none', 4),
  ('Grupo de Artesanato', 'Inspiração e novidades artesanais.', 'https://chat.whatsapp.com/HwllI7klf8jFzQtxb9bO1J', 'sparkles', 'none', 5),
  ('Instagram', 'Projetos, móveis e bastidores.', 'https://www.instagram.com/artemineiramoveis', 'instagram', 'none', 6),
  ('Como chegar?', 'Rua Silva Jardim, 758 · Itaúna, MG.', 'https://www.google.com/maps?q=-20.066544,-44.579758', 'pin', 'none', 7);
