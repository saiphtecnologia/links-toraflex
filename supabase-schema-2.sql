-- Incremento (Fase 2): conteúdo do site, redes sociais e upload de imagens.
-- Já foi aplicado diretamente no projeto Supabase em uso; mantido aqui como referência.

-- ── site_content: linha única com os textos/imagens do cabeçalho e do cartão de destaque ──
create table public.site_content (
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
  'assets/logo-arte-mineira.jpg',
  'Logo da Arte Mineira Móveis',
  'assets/fundo-madeira.webp',
  'Desde 2011 · Itaúna, MG',
  'Móveis em madeira de demolição e acabamento artesanal',
  'Design, tradição e personalidade em peças feitas para transformar ambientes.',
  'Nossos canais',
  'Artesanalmente mineiro',
  'Madeira com história. Móveis com personalidade.',
  'Conheça peças que unem a beleza do rústico, o cuidado artesanal e a presença marcante da madeira.',
  'Conheça nossos móveis',
  'https://artemineira-moveis.stoqui.shop/',
  'Siga a Arte Mineira'
);

-- ── social_links: lista de ícones sociais do rodapé (adicionável/removível pelo painel) ──
create table public.social_links (
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
  ('instagram', 'Arte Mineira Móveis no Instagram', 'https://www.instagram.com/artemineiramoveis', 1),
  ('tiktok', 'Arte Mineira Móveis no TikTok', 'https://www.tiktok.com/@artemineira', 2),
  ('whatsapp', 'Falar com a Arte Mineira Móveis pelo WhatsApp', 'https://wa.me/5537999974543', 3);

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
