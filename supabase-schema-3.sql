-- Incremento (Fase 3): nomes personalizáveis para as opções de "Destaque" no formulário de link.
-- Já foi aplicado diretamente no projeto Supabase em uso; mantido aqui como referência.

alter table public.site_content
  add column if not exists highlight_primary_label text not null default 'Verde em destaque (largura total)',
  add column if not exists highlight_glow_label text not null default 'Brilho dourado';
