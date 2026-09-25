-- ============================================================================
-- Toraflex Colchões — Página de Links (Link Hub)
-- Script único do banco Supabase. Rode inteiro em:
--   Supabase → SQL Editor → New query → Run
-- Cria as tabelas (links, site_content, social_links), o bucket de imagens,
-- as políticas de RLS (leitura pública, escrita só autenticada) e já popula
-- tudo com os dados da Toraflex.
-- ============================================================================

-- ── links: os botões da grade principal ──
create table if not exists public.links (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  url text not null,
  icon_key text not null default 'globe',
  highlight text not null default 'none' check (highlight in ('none', 'primary', 'glow')),
  badge_text text,
  position integer not null default 0,
  created_at timestamptz not null default now()
);

alter table public.links enable row level security;

create policy "Public can read links"
  on public.links for select to anon using (true);

create policy "Authenticated can manage links"
  on public.links for all to authenticated using (true) with check (true);

insert into public.links (title, description, url, icon_key, highlight, position) values
  ('Fale pelo WhatsApp', 'Atendimento direto com a nossa equipe.', 'https://wa.me/553138781402?text=Ol%C3%A1%2C%20vim%20pela%20p%C3%A1gina%20de%20links%20da%20Toraflex%20e%20gostaria%20de%20mais%20informa%C3%A7%C3%B5es.', 'whatsapp', 'primary', 1),
  ('Visite nosso site', 'Conheça a linha completa de colchões.', 'https://toraflex.com.br/', 'globe', 'none', 2),
  ('Portal do Revendedor', 'Seja um parceiro Toraflex.', 'https://revenda.toraflex.com.br/', 'cart', 'none', 3),
  ('Instagram', 'Novidades, bastidores e lançamentos.', 'https://www.instagram.com/toraflexcolchoes/', 'instagram', 'none', 4),
  ('LinkedIn', 'Acompanhe a Toraflex no mundo corporativo.', 'https://www.linkedin.com/company/toraflex-colchoes', 'linkedin', 'none', 5),
  ('Ligue para a fábrica', '(31) 3878-1400 · Betim, MG.', 'tel:+553138781400', 'phone', 'none', 6),
  ('Como chegar?', 'BR-381 Fernão Dias, KM 500 · Betim, MG.', 'https://www.google.com/maps/search/?api=1&query=Toraflex+Colch%C3%B5es+Betim+MG', 'pin', 'none', 7);

-- ── site_content: linha única com os textos/imagens do cabeçalho e do cartão ──
create table if not exists public.site_content (
  id smallint primary key default 1,
  logo_url text,
  logo_alt text,
  background_url text,
  eyebrow_text text,
  brand_subtitle text,
  brand_copy text,
  links_section_label text,
  feature_kicker text,
  feature_title text,
  feature_text text,
  feature_cta_label text,
  feature_cta_url text,
  social_label text,
  highlight_primary_label text not null default 'Vermelho em destaque (largura total)',
  highlight_glow_label text not null default 'Brilho vermelho',
  updated_at timestamptz not null default now(),
  constraint site_content_singleton check (id = 1)
);

alter table public.site_content enable row level security;

create policy "Public can read site content"
  on public.site_content for select to anon using (true);

create policy "Authenticated can read site content"
  on public.site_content for select to authenticated using (true);

create policy "Authenticated can update site content"
  on public.site_content for update to authenticated using (true) with check (true);

insert into public.site_content (
  id, logo_url, logo_alt, background_url, eyebrow_text, brand_subtitle, brand_copy,
  links_section_label, feature_kicker, feature_title, feature_text,
  feature_cta_label, feature_cta_url, social_label
) values (
  1,
  'assets/logo-toraflex.png',
  'Logo da Toraflex Colchões',
  '',
  'Há mais de 40 anos · Betim, MG',
  'Colchões que combinam qualidade, conforto e conformidade',
  'A escolha certa para todos os estilos de sono — fábrica nº 1 de colchões de Minas Gerais.',
  'Nossos canais',
  'Qualidade & Conformidade',
  'Noites de sono com qualidade e conformidade.',
  'Conheça a linha completa de colchões de espuma, mola e ortopédicos, feita para transformar o seu descanso.',
  'Conheça nossos colchões',
  'https://toraflex.com.br/',
  'Siga a Toraflex'
);

-- ── social_links: ícones sociais do rodapé ──
create table if not exists public.social_links (
  id uuid primary key default gen_random_uuid(),
  icon_key text not null default 'instagram',
  label text not null,
  url text not null,
  position integer not null default 0,
  created_at timestamptz not null default now()
);

alter table public.social_links enable row level security;

create policy "Public can read social links"
  on public.social_links for select to anon using (true);

create policy "Authenticated can manage social links"
  on public.social_links for all to authenticated using (true) with check (true);

insert into public.social_links (icon_key, label, url, position) values
  ('instagram', 'Toraflex Colchões no Instagram', 'https://www.instagram.com/toraflexcolchoes/', 1),
  ('linkedin', 'Toraflex Colchões no LinkedIn', 'https://www.linkedin.com/company/toraflex-colchoes', 2),
  ('whatsapp', 'Falar com a Toraflex pelo WhatsApp', 'https://wa.me/553138781402', 3);

-- ── Storage: bucket público para upload de logo e imagem de fundo ──
insert into storage.buckets (id, name, public)
values ('site-media', 'site-media', true)
on conflict (id) do nothing;

create policy "Public can read site-media"
  on storage.objects for select to public using (bucket_id = 'site-media');

create policy "Authenticated can upload site-media"
  on storage.objects for insert to authenticated with check (bucket_id = 'site-media');

create policy "Authenticated can update site-media"
  on storage.objects for update to authenticated using (bucket_id = 'site-media');

create policy "Authenticated can delete site-media"
  on storage.objects for delete to authenticated using (bucket_id = 'site-media');
