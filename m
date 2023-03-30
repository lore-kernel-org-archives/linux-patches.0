Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CE41FAD
	for <patches@lists.linux.dev>; Thu, 30 Mar 2023 11:44:20 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id v20-20020a05600c471400b003ed8826253aso3288691wmo.0
        for <patches@lists.linux.dev>; Thu, 30 Mar 2023 04:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20210112.gappssmtp.com; s=20210112; t=1680176658;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=g0JdgbhClOFYZkBIrmVYKwypeprdaD8BQ3RAt+KP9Fs=;
        b=UGQs1w6ZJO+wmBd9qR0yAZA5IBTIe62IsjIs/jWOm2AoRAOmFSeGY973sd6WoW1ERC
         pg1FLyq0GqIlIl0lDQ5kX+yLMT8purlrGX3jHIqR9D2kGtmQMoBFNHy1rz9Pu6IWf+1B
         JvIvOWNJUKwf0AbZSsO0bj3BOcQ1H5FewikKJ7KAGFiuks+XOPuvICDrZdX4uTT0qjZb
         jzQKs4in03r0HM8NGlJg9VCu7QYn7gESWvNtrO2rokhnJASDOltY6KSqEvXJKsAkn/uc
         mhqdt0BSEbvp0jBdSGQZQb7re9ZsUjV0joOKZbWuOD5BLX1q0z7+UUIv3L63fV5QBYlI
         UBmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680176658;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g0JdgbhClOFYZkBIrmVYKwypeprdaD8BQ3RAt+KP9Fs=;
        b=KlPUyiCjULP74HqPXLK9MnbSFsXnMYuQES88GJuRl90zzbgvJZNsMLRXCocV8YGwS3
         orVOi8JZGIojEse2Z7Hfv4WLGf5780aWlxzbdq520tD96hQPieFmIycb0RFX3ebD0kd5
         /ZFpJ3EL9F5Gd4hBgl60kOvvV8LTEQXKbqlpJgSIMiG7ZVkkqYNAon8fgFpNxzWldt9h
         NmB2c9idDh7Hk6n57zi1XXU4MbaCA9G9EJQmTUHOaS6kWchu8AgzbIPwU4K8d2DhQabV
         uzc2V6oYHhAJYnOR0ifnqAZ2w7FM9PiOI+gEi9InQW1T0e8yAbW0nYg4nqvaz1ZvSzFI
         NWnA==
X-Gm-Message-State: AO0yUKXUmekXHWs/nCXCBRnn1qk4qhaTYcqWhyxK9rXsiPo8rfEUW3Y0
	j7s/g+S98rZNHmn0cxiKaHP7Ew==
X-Google-Smtp-Source: AK7set86Se45lU8RiKxEAJPVjl82rkHkBCzt88SKrtkidgTB0cn034DBzdmyHV1BF4ygXgTH+MThNg==
X-Received: by 2002:a7b:c38a:0:b0:3ee:1acd:b039 with SMTP id s10-20020a7bc38a000000b003ee1acdb039mr17418382wmj.34.1680176658316;
        Thu, 30 Mar 2023 04:44:18 -0700 (PDT)
Received: from localhost ([147.161.155.91])
        by smtp.gmail.com with ESMTPSA id o5-20020a05600c510500b003ef5bb63f13sm6025059wms.10.2023.03.30.04.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 04:44:17 -0700 (PDT)
References: <20230329223239.138757-1-y86-dev@protonmail.com>
 <20230329223239.138757-2-y86-dev@protonmail.com>
User-agent: mu4e 1.9.18; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: y86-dev@protonmail.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH v3 01/13] rust: macros: add `quote!` macro
Date: Thu, 30 Mar 2023 13:42:29 +0200
In-reply-to: <20230329223239.138757-2-y86-dev@protonmail.com>
Message-ID: <877cuy5ur2.fsf@metaspace.dk>
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
> ---
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
> index 000000000000..7efb009c25a9
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
> +        let mut tokens = Vec::new();
> +        let span = $span;
> +        quote_spanned!(@proc tokens span $($tt)*);
> +        proc_macro::TokenStream::from_iter(tokens)

Should this be `::alloc::vec::Vec` and
`::proc_macro::TokenStream::from_iter` ?

Best regards,
Andreas

> +    }};
> +    (@proc $v:ident $span:ident) => {};
> +    (@proc $v:ident $span:ident #$id:ident $($tt:tt)*) => {
> +        let mut ts = proc_macro::TokenStream::new();
> +        crate::quote::ToTokens::to_tokens(&$id, &mut ts);
> +        $v.extend(ts.into_iter());
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident #(#$id:ident)* $($tt:tt)*) => {
> +        for token in $id {
> +            let mut ts = proc_macro::TokenStream::new();
> +            crate::quote::ToTokens::to_tokens(&token, &mut ts);
> +            $v.extend(ts.into_iter());
> +        }
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident ( $($inner:tt)* ) $($tt:tt)*) => {
> +        let mut tokens = Vec::new();
> +        quote_spanned!(@proc tokens $span $($inner)*);
> +        $v.push(proc_macro::TokenTree::Group(proc_macro::Group::new(
> +            proc_macro::Delimiter::Parenthesis,
> +            proc_macro::TokenStream::from_iter(tokens)
> +        )));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident [ $($inner:tt)* ] $($tt:tt)*) => {
> +        let mut tokens = Vec::new();
> +        quote_spanned!(@proc tokens $span $($inner)*);
> +        $v.push(proc_macro::TokenTree::Group(proc_macro::Group::new(
> +            proc_macro::Delimiter::Bracket,
> +            proc_macro::TokenStream::from_iter(tokens)
> +        )));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident { $($inner:tt)* } $($tt:tt)*) => {
> +        let mut tokens = Vec::new();
> +        quote_spanned!(@proc tokens $span $($inner)*);
> +        $v.push(proc_macro::TokenTree::Group(proc_macro::Group::new(
> +            proc_macro::Delimiter::Brace,
> +            proc_macro::TokenStream::from_iter(tokens)
> +        )));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident :: $($tt:tt)*) => {
> +        $v.push(
> +            proc_macro::TokenTree::Punct(proc_macro::Punct::new(':', proc_macro::Spacing::Joint))
> +        );
> +        $v.push(
> +            proc_macro::TokenTree::Punct(proc_macro::Punct::new(':', proc_macro::Spacing::Alone))
> +        );
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident : $($tt:tt)*) => {
> +        $v.push(
> +            proc_macro::TokenTree::Punct(proc_macro::Punct::new(':', proc_macro::Spacing::Alone))
> +        );
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident , $($tt:tt)*) => {
> +        $v.push(
> +            proc_macro::TokenTree::Punct(proc_macro::Punct::new(',', proc_macro::Spacing::Alone))
> +        );
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident @ $($tt:tt)*) => {
> +        $v.push(
> +            proc_macro::TokenTree::Punct(proc_macro::Punct::new('@', proc_macro::Spacing::Alone))
> +        );
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident ! $($tt:tt)*) => {
> +        $v.push(
> +            proc_macro::TokenTree::Punct(proc_macro::Punct::new('!', proc_macro::Spacing::Alone))
> +        );
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident $id:ident $($tt:tt)*) => {
> +        $v.push(proc_macro::TokenTree::Ident(proc_macro::Ident::new(stringify!($id), $span)));
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
> +        quote_spanned!(proc_macro::Span::mixed_site() => $($tt)*)
> +    }
> +}

