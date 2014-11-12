use t::Helper;

{
  diag "minify=0";
  my $t = t::Helper->t({minify => 0});

  plan skip_all => 'Could not find preprocessors for jsx', 6 unless $t->app->asset->preprocessors->can_process('jsx');

  $t->app->asset('jsx.js' => '/js/c.jsx');
  $t->get_ok('/test1')->status_is(200)->content_like(qr{;[\n\s]+React})
    ->content_like(qr{var app\s*=\s*React\..*div.*{.*"appClass"},\s*"Hello, React!"\)});
}

{
  diag "minify=1";
  my $t = t::Helper->t({minify => 1});

  $t->app->asset('jsx.js' => '/js/c.jsx');
  $t->get_ok('/test1')->status_is(200)
    ->content_like(qr{var c=\(function\(\)\{var module=\{exports:\{\}\};module\.export=React\.createClass});
}

done_testing;

__DATA__
@@ test1.html.ep
%= asset 'jsx.js', { inline => 1 }
