Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EC479CC
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 20:46:41 +0000 (UTC)
Received: by mail-ed1-f45.google.com with SMTP id eh3so144209609edb.11
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 13:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20210112.gappssmtp.com; s=20210112; t=1680727600;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=PjVK3OcYLqF4e28UZO8WCt8ffeDwGmSl2Tba2xHUZTQ=;
        b=S+FdGx5OVDOWQ5NuClG6fFfByhM2/uoL0xdBSpNlIboO6AGKXYv1pvtR2kEIBF2v4w
         Uly2Hz01alFFO2T+djikpxMRSJnCd9IXU44uuX25AUrkgzYGL7zbRApowvRQzu8J5KNh
         kEzfSQHpHEZ5WJg25yd/d7auULoMB6ftWjkuWB9XgetRuRFLN1ej6aHCLAHSth0Uaf8p
         0ZmUWWUrsSMBHh8tTWLEIIZVC7S2W90Xpm4ad96OE9Td91v7frJfEV9QnzNXVBaBnc8G
         WY7ARbfUIYTwTJngzPviMkVSdp+c0w/j314svGS7lC3JIvE0PhsfyU37Qa33UvDD1d+g
         +7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727600;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PjVK3OcYLqF4e28UZO8WCt8ffeDwGmSl2Tba2xHUZTQ=;
        b=fH/oHS/h9iZQKkq3lfNK+jpbd5OlzXVFaBxZt9+mFxiD92h1wdDyMpmLKsBTWhWij9
         glOT+kN9e7OQwPNVg7qdzYdwL2/CFp4mhlWIGGqHB4QgEgZE6h22CeZu7T57qRHqffV2
         czj09rYIaApTEqAi456AgTwgDVPx09hwq+CxnbujWk+3gGQN1TUA+QAnKqS7up7EH46n
         EBHv7P5MqNlk43fuC0+ACAkUY0B+AW/ALZOcLRLKZHoGpLuhXpR6pQgwuHibGNBnNTz6
         QwEOYrxFGCsWuzeeFao3tTTiPu17IaI1PvGX5bBZQEEewLd5z/6NzPMfS5FpdWZq0IQ+
         nfvA==
X-Gm-Message-State: AAQBX9f9Fd8ExocOzC4V3HU2j2gWCst2MMNJJCnJ9JGoN9Ehpfl9xigq
	IdGgCD6amMcuRyxrHOzE5aRdhA==
X-Google-Smtp-Source: AKy350aGDXTiJvSHX/YUEcY6IQZp4Bdeq9EFS0GjiPQShb4Gy7iz8du0uRkNAB08ACzio3QUcIPdCA==
X-Received: by 2002:a17:906:16c8:b0:933:3a22:8513 with SMTP id t8-20020a17090616c800b009333a228513mr4053369ejd.53.1680727599845;
        Wed, 05 Apr 2023 13:46:39 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id xb7-20020a170907070700b00948c2f245a9sm3928942ejb.110.2023.04.05.13.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:46:39 -0700 (PDT)
References: <20230405193445.745024-1-y86-dev@protonmail.com>
 <20230405193445.745024-2-y86-dev@protonmail.com>
User-agent: mu4e 1.10.1; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: Benno Lossin <y86-dev@protonmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Alice Ryhl <aliceryhl@google.com>, Andreas
 Hindborg <a.hindborg@samsung.com>
Subject: Re: [PATCH v6 01/15] rust: enable the `pin_macro` feature
Date: Wed, 05 Apr 2023 22:45:57 +0200
In-reply-to: <20230405193445.745024-2-y86-dev@protonmail.com>
Message-ID: <87fs9et5u8.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Benno Lossin <y86-dev@protonmail.com> writes:

> This feature enables the use of the `pin!` macro for the `stack_pin_init!`
> macro. This feature is already stabilized in Rust version 1.68.
>
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
> Reviewed-by: Gary Guo <gary@garyguo.net>
> Acked-by: Boqun Feng <boqun.feng@gmail.com>
> Cc: Andreas Hindborg <a.hindborg@samsung.com>
> ---

Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>

>  rust/kernel/lib.rs     | 1 +
>  scripts/Makefile.build | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index 223564f9f0cc..4317b6d5f50b 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -17,6 +17,7 @@
>  #![feature(core_ffi_c)]
>  #![feature(dispatch_from_dyn)]
>  #![feature(generic_associated_types)]
> +#![feature(pin_macro)]
>  #![feature(receiver_trait)]
>  #![feature(unsize)]
>
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 76323201232a..ba4102b9d94d 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -277,7 +277,7 @@ $(obj)/%.lst: $(src)/%.c FORCE
>  # Compile Rust sources (.rs)
>  # ---------------------------------------------------------------------------
>
> -rust_allowed_features := core_ffi_c
> +rust_allowed_features := core_ffi_c,pin_macro
>
>  rust_common_cmd = \
>  	RUST_MODFILE=$(modfile) $(RUSTC_OR_CLIPPY) $(rust_flags) \

