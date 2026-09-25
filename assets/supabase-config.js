// Credenciais do Supabase usadas pelo index.html e pelo admin.html.
// A chave "anon public" é feita para ser pública — a segurança de escrita
// vem das políticas de RLS configuradas nas tabelas (só usuários
// autenticados podem inserir/editar/excluir).
//
// >>> PROJETO TORAFLEX <<<
// Preencha os dois valores abaixo com os dados do NOVO projeto Supabase da
// Toraflex, encontrados em: Supabase → Project Settings → API.
// Enquanto contiverem "SEU-PROJETO", a página pública usa os dados de
// emergência embutidos e o painel admin mostra o aviso "Configuração pendente".
window.TF_SUPABASE_URL = "https://SEU-PROJETO.supabase.co";
window.TF_SUPABASE_ANON_KEY = "SUA-CHAVE-ANON-PUBLICA";
