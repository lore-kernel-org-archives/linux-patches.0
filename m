Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD1C20F2
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 08:37:30 +0000 (UTC)
Received: by mail-ed1-f44.google.com with SMTP id w9so114095707edc.3
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 01:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20210112.gappssmtp.com; s=20210112; t=1680511048;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=XAnO4e/bcc7gFY55GITFumi1/bqavpz2t4PFPeByUwI=;
        b=zeORuAUJ11qVJ2im5Yau0sE35zafGmS/o2rOco4dxMHQuDZ9pmtCE6HiuByKPazEJG
         qKYhM30S+KjsUBZ7FoLmgiJJYcxz/j3I3eUWyLAvj2qjtFmaHr+Ab1VBdZL6bT+z8/gr
         kt7i+Np6m/MpEGrygX0zlC2nV0+Ir6DI8sogxQ9zFWgiYMRKU1lGPght81jeN9j/1pT5
         NqaUrccIOEOwABsGP22cIuK5s6Mpxt3FMrqedf14n58H0FN+vxxoU6QZzy2NqrsVr1sF
         NS2iINT5UT0CLZLMXE3Z39uWBn+ZQ9qTsU5Ox27dsF9MYSMLrwTOv7agFbl5N0Ijwz3A
         FxDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680511048;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAnO4e/bcc7gFY55GITFumi1/bqavpz2t4PFPeByUwI=;
        b=u8eKSkAtz6Udan7cIOc+hzNCkE2xM4T72Roem+FgfCo6ARBmfv6QJfg9fTYgceTP4d
         IsHnHNxOHabNYEE/5CAxjhJHkuGi28lyByZDWmgQkeUT4ERiTh46jROChxexzMMSZWMc
         w9WA3A+rBAFr1Fv5EIrrYj/8fBt+lR+pf/hWWZoDHav/OixAOXQIXR78MyA6hOFL/Oqf
         bF5kihh1kPTarJSmufBf7ZPqAeOpcd0RzkIUlOTWTyRj6fXQlMLuofWiSllnUqtODYvh
         leHl+bYfoubG+jY6sJKAWCaWTOZlneYhGUJcwuoHJZq5ax6F9umgQTq52UnbWZmqD3wG
         vxjw==
X-Gm-Message-State: AAQBX9d1k/tTSGr7FQpwio7/l3bX/HBVC602qRkEhvi36beIblhahkOy
	WbLdD9r+sRZeSyQPSNwwSKfXCA==
X-Google-Smtp-Source: AKy350a/yrbnuHPT4zj9O9NRIAGWjgB/O4T1sr3gEs/lWFxjQVfzvbe1NPii3ZfQpagkEZNP11D6qw==
X-Received: by 2002:a17:906:2009:b0:933:4184:f0d7 with SMTP id 9-20020a170906200900b009334184f0d7mr35551512ejo.69.1680511048475;
        Mon, 03 Apr 2023 01:37:28 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id s18-20020a17090699d200b0092be625d981sm4237867ejn.91.2023.04.03.01.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 01:37:28 -0700 (PDT)
References: <20230331215053.585759-1-y86-dev@protonmail.com>
 <20230331215053.585759-3-y86-dev@protonmail.com>
User-agent: mu4e 1.9.18; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: y86-dev@protonmail.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Alice Ryhl <aliceryhl@google.com>, Andreas
 Hindborg <a.hindborg@samsung.com>
Subject: Re: [PATCH v4 02/15] rust: macros: add `quote!` macro
Date: Mon, 03 Apr 2023 10:36:38 +0200
In-reply-to: <20230331215053.585759-3-y86-dev@protonmail.com>
Message-ID: <87355hl5tk.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


y86-dev@protonmail.com writes:

> From: Gary Guo <gary@garyguo.net>
>
> Add the `quote!` macro for creating `TokenStream`s directly via the
> given Rust tokens. It also supports repetitions using iterators.
>
> It will be used by the pin-init API proc-macros to generate code.
>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: Andreas Hindborg <a.hindborg@samsung.com>
> ---

Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>

>  rust/macros/lib.rs   |   2 +
>  rust/macros/quote.rs | 145 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 147 insertions(+)
>  create mode 100644 rust/macros/quote.rs
>
> diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
> index c1d385e345b9..82b520f024dd 100644
> --- a/rust/macros/lib.rs
> +++ b/rust/macros/lib.rs
> @@ -2,6 +2,8 @@
>
>  //! Crate for all kernel procedural macros.
>
> +#[macro_use]
> +mod quote;
>  mod concat_idents;
>  mod helpers;
>  mod module;
> diff --git a/rust/macros/quote.rs b/rust/macros/quote.rs
> new file mode 100644
> index 000000000000..94a6277182ee
> --- /dev/null
> +++ b/rust/macros/quote.rs
> @@ -0,0 +1,145 @@
> +// SPDX-License-Identifier: Apache-2.0 OR MIT
> +
> +use proc_macro::{TokenStream, TokenTree};
> +
> +pub(crate) trait ToTokens {
> +    fn to_tokens(&self, tokens: &mut TokenStream);
> +}
> +
> +impl<T: ToTokens> ToTokens for Option<T> {
> +    fn to_tokens(&self, tokens: &mut TokenStream) {
> +        if let Some(v) = self {
> +            v.to_tokens(tokens);
> +        }
> +    }
> +}
> +
> +impl ToTokens for proc_macro::Group {
> +    fn to_tokens(&self, tokens: &mut TokenStream) {
> +        tokens.extend([TokenTree::from(self.clone())]);
> +    }
> +}
> +
> +impl ToTokens for TokenTree {
> +    fn to_tokens(&self, tokens: &mut TokenStream) {
> +        tokens.extend([self.clone()]);
> +    }
> +}
> +
> +impl ToTokens for TokenStream {
> +    fn to_tokens(&self, tokens: &mut TokenStream) {
> +        tokens.extend(self.clone());
> +    }
> +}
> +
> +/// Converts tokens into [`proc_macro::TokenStream`] and performs variable interpolations with
> +/// the given span.
> +///
> +/// This is a similar to the
> +/// [`quote_spanned!`](https://docs.rs/quote/latest/quote/macro.quote_spanned.html) macro from the
> +/// `quote` crate but provides only just enough functionality needed by the current `macros` crate.
> +#[allow(unused_macros)]
> +macro_rules! quote_spanned {
> +    ($span:expr => $($tt:tt)*) => {
> +    #[allow(clippy::vec_init_then_push)]
> +    {
> +        let mut tokens = ::std::vec::Vec::new();
> +        let span = $span;
> +        quote_spanned!(@proc tokens span $($tt)*);
> +        ::proc_macro::TokenStream::from_iter(tokens)
> +    }};
> +    (@proc $v:ident $span:ident) => {};
> +    (@proc $v:ident $span:ident #$id:ident $($tt:tt)*) => {
> +        let mut ts = ::proc_macro::TokenStream::new();
> +        $crate::quote::ToTokens::to_tokens(&$id, &mut ts);
> +        $v.extend(ts);
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident #(#$id:ident)* $($tt:tt)*) => {
> +        for token in $id {
> +            let mut ts = ::proc_macro::TokenStream::new();
> +            $crate::quote::ToTokens::to_tokens(&token, &mut ts);
> +            $v.extend(ts);
> +        }
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident ( $($inner:tt)* ) $($tt:tt)*) => {
> +        let mut tokens = ::std::vec::Vec::new();
> +        quote_spanned!(@proc tokens $span $($inner)*);
> +        $v.push(::proc_macro::TokenTree::Group(::proc_macro::Group::new(
> +            ::proc_macro::Delimiter::Parenthesis,
> +            ::proc_macro::TokenStream::from_iter(tokens)
> +        )));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident [ $($inner:tt)* ] $($tt:tt)*) => {
> +        let mut tokens = ::std::vec::Vec::new();
> +        quote_spanned!(@proc tokens $span $($inner)*);
> +        $v.push(::proc_macro::TokenTree::Group(::proc_macro::Group::new(
> +            ::proc_macro::Delimiter::Bracket,
> +            ::proc_macro::TokenStream::from_iter(tokens)
> +        )));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident { $($inner:tt)* } $($tt:tt)*) => {
> +        let mut tokens = ::std::vec::Vec::new();
> +        quote_spanned!(@proc tokens $span $($inner)*);
> +        $v.push(::proc_macro::TokenTree::Group(::proc_macro::Group::new(
> +            ::proc_macro::Delimiter::Brace,
> +            ::proc_macro::TokenStream::from_iter(tokens)
> +        )));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident :: $($tt:tt)*) => {
> +        $v.push(::proc_macro::TokenTree::Punct(
> +                ::proc_macro::Punct::new(':', ::proc_macro::Spacing::Joint)
> +        ));
> +        $v.push(::proc_macro::TokenTree::Punct(
> +                ::proc_macro::Punct::new(':', ::proc_macro::Spacing::Alone)
> +        ));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident : $($tt:tt)*) => {
> +        $v.push(::proc_macro::TokenTree::Punct(
> +                ::proc_macro::Punct::new(':', ::proc_macro::Spacing::Alone)
> +        ));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident , $($tt:tt)*) => {
> +        $v.push(::proc_macro::TokenTree::Punct(
> +                ::proc_macro::Punct::new(',', ::proc_macro::Spacing::Alone)
> +        ));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident @ $($tt:tt)*) => {
> +        $v.push(::proc_macro::TokenTree::Punct(
> +                ::proc_macro::Punct::new('@', ::proc_macro::Spacing::Alone)
> +        ));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident ! $($tt:tt)*) => {
> +        $v.push(::proc_macro::TokenTree::Punct(
> +                ::proc_macro::Punct::new('!', ::proc_macro::Spacing::Alone)
> +        ));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident $id:ident $($tt:tt)*) => {
> +        $v.push(::proc_macro::TokenTree::Ident(::proc_macro::Ident::new(stringify!($id), $span)));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +}
> +
> +/// Converts tokens into [`proc_macro::TokenStream`] and performs variable interpolations with
> +/// mixed site span ([`Span::mixed_site()`]).
> +///
> +/// This is a similar to the [`quote!`](https://docs.rs/quote/latest/quote/macro.quote.html) macro
> +/// from the `quote` crate but provides only just enough functionality needed by the current
> +/// `macros` crate.
> +///
> +/// [`Span::mixed_site()`]: https://doc.rust-lang.org/proc_macro/struct.Span.html#method.mixed_site
> +#[allow(unused_macros)]
> +macro_rules! quote {
> +    ($($tt:tt)*) => {
> +        quote_spanned!(::proc_macro::Span::mixed_site() => $($tt)*)
> +    }
> +}

