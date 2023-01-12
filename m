Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5491979CE
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:25:42 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id ss4so37882868ejb.11
        for <patches@lists.linux.dev>; Thu, 12 Jan 2023 06:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KYpqbjdLUiH8F5H1EJG0ptUSVdez6XT9MKBwFyuoI2o=;
        b=WdTaqzvFjo3/K9YUHrDGwic5e44c1ojtJE2M9bn/xjrQUOCGPy5uMKteHS5CesqTOx
         A8XSjVIvtzUUR1pymfl4C3JLi3ERHX3mq52bHs4UliQa2bjDgpykQcc+5PBwjHuDHatZ
         XkcnjKg/gSmihb+ZRknkc13ouU0z4s1Tcqqlq0JwJWtQMHlr2jVlmzYw0mx59/jTUyuN
         sgIjAoh9pUzgbxigArv2QhA14Y3wFc+xe3tJEekRLTtKzcB6tfx2hjVZjr9VXG87nCgi
         LMMGCEr7JhgPtzwbYc17UNYQybrhrb8ECSQKtZfMg15NRnP3g2sA1EUfovxxPJ0GSqJj
         /qTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KYpqbjdLUiH8F5H1EJG0ptUSVdez6XT9MKBwFyuoI2o=;
        b=dGL6ytaDQpS0VYUUJpkLYmi9jaJ0mHc8Zv4dlzpF2KlTfm2yQDqztGHWVLSODJ4DXh
         MnqMkNWVOMQIxB8G4PmmjQ6nkPZe9Gplp1GxAH49pbZK4lntTCdAb2KCr3SDntHVU5FE
         QL5aCRgUv0xP67JdUXSUCmGWEYJbQsX0ad5xt01JaLGvmiOht7e9FG9Bl20LfLWKAURY
         A15WnAZewET3kS3lVQZ2fSDCqZMNrrDys77MGQoTlXJmWqYKPEu8f8tgj9ZIpPDVngdu
         WNcuACd5Goq5KvkjRQYnofW+s0m1hee1ZD4Fv3lOMKIpT/vH/MH638JNiEmme06G1DCS
         QXnQ==
X-Gm-Message-State: AFqh2krl6kB6BwlakafsCwwILEDiihXjJHwjo4DxmgI3G4F6OLSwgrEq
	DR9YdumveMMPJTU9gq51CD4=
X-Google-Smtp-Source: AMrXdXtfDk1CKgSiYb0Pxnr+Jv456eavOCuqTkBLuld1MUlN3/b/LR7FCyoooB1eYE6Ta1ukM1kFYA==
X-Received: by 2002:a17:907:6e05:b0:7c1:235d:2a2b with SMTP id sd5-20020a1709076e0500b007c1235d2a2bmr85006546ejc.24.1673533540433;
        Thu, 12 Jan 2023 06:25:40 -0800 (PST)
Received: from localhost ([2001:b07:5d37:537d:3285:c486:87d3:b4eb])
        by smtp.gmail.com with ESMTPSA id sb25-20020a1709076d9900b007a4e02e32ffsm7532398ejc.60.2023.01.12.06.25.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 06:25:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 12 Jan 2023 15:25:38 +0100
Message-Id: <CPQA4LWQZOX1.31XJYNUR2O449@vincent>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Wedson Almeida Filho"
 <wedsonaf@gmail.com>, "Alex Gaynor" <alex.gaynor@gmail.com>, "Boqun Feng"
 <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc: <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>, "Domen Puncer Kugler"
 <domen.puncerkugler@nccgroup.com>
Subject: Re: [PATCH] rust: print: avoid evaluating arguments in `pr_*`
 macros in `unsafe` blocks
From: "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
X-Mailer: aerc 0.8.2
References: <20230109204912.539790-1-ojeda@kernel.org>
In-Reply-To: <20230109204912.539790-1-ojeda@kernel.org>

On Mon Jan 9, 2023 at 9:49 PM CET, Miguel Ojeda wrote:
> At the moment it is possible to perform unsafe operations in
> the arguments of `pr_*` macros since they are evaluated inside
> an `unsafe` block:
>
>     let x =3D &10u32 as *const u32;
>     pr_info!("{}", *x);
>
> In other words, this is a soundness issue.
>
> Fix it so that it requires an explicit `unsafe` block.
>
> Reported-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> Reported-by: Domen Puncer Kugler <domen.puncerkugler@nccgroup.com>
> Link: https://github.com/Rust-for-Linux/linux/issues/479
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
> ---
>  rust/kernel/print.rs | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
>
> diff --git a/rust/kernel/print.rs b/rust/kernel/print.rs
> index 29bf9c2e8aee..30103325696d 100644
> --- a/rust/kernel/print.rs
> +++ b/rust/kernel/print.rs
> @@ -142,17 +142,24 @@ pub fn call_printk_cont(args: fmt::Arguments<'_>) {
>  macro_rules! print_macro (
>      // The non-continuation cases (most of them, e.g. `INFO`).
>      ($format_string:path, false, $($arg:tt)+) =3D> (
> -        // SAFETY: This hidden macro should only be called by the docume=
nted
> -        // printing macros which ensure the format string is one of the =
fixed
> -        // ones. All `__LOG_PREFIX`s are null-terminated as they are gen=
erated
> -        // by the `module!` proc macro or fixed values defined in a kern=
el
> -        // crate.
> -        unsafe {
> -            $crate::print::call_printk(
> -                &$format_string,
> -                crate::__LOG_PREFIX,
> -                format_args!($($arg)+),
> -            );
> +        // To remain sound, `arg`s must be expanded outside the `unsafe`=
 block.
> +        // Typically one would use a `let` binding for that; however, `f=
ormat_args!`
> +        // takes borrows on the arguments, but does not extend the scope=
 of temporaries.
> +        // Therefore, a `match` expression is used to keep them around, =
since
> +        // the scrutinee is kept until the end of the `match`.
> +        match format_args!($($arg)+) {
> +            // SAFETY: This hidden macro should only be called by the do=
cumented
> +            // printing macros which ensure the format string is one of =
the fixed
> +            // ones. All `__LOG_PREFIX`s are null-terminated as they are=
 generated
> +            // by the `module!` proc macro or fixed values defined in a =
kernel
> +            // crate.
> +            args =3D> unsafe {
> +                $crate::print::call_printk(
> +                    &$format_string,
> +                    crate::__LOG_PREFIX,
> +                    args,
> +                );
> +            }
>          }
>      );
> =20
>
> base-commit: b7bfaa761d760e72a969d116517eaa12e404c262
> --=20
> 2.39.0

