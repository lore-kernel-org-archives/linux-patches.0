Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE7519E994
	for <patches@lists.linux.dev>; Sat, 15 Mar 2025 20:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742069570; cv=none; b=nWOAf5/uO8CJ4t082WVQl1nFoGVvmIvg0YZdxsvvxzM1Nxrv0IrRtyqNMbi96Hxml1RQt0zh+Ab+jTSVC1wG+DWOFgsVvpczjAhxhe6wDmALmCWRvUcxH1r9D9+54NHY0JX9io2ApY1rx6gtvhI4T1HvUyCvnyQ1Fe9E456v+Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742069570; c=relaxed/simple;
	bh=QDbqp1bEfuNRkAkeWgCe8le/REa+td5CGaS1SXutrYc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jaj84yPaGzjuVn4gZc4XKrcWnm39fdp9sEQqFxZJYBbIzK0agLkkUu8KkixhsxfvB/AlP1OVHmPmmgHvyIj1c8IEb2IY+XMqHfcGb05sza2YZaeu4hC225LjCMwW9GtvUKDSSJ1Y/RIQMswVqx8H33wOG+SfQsihovvjDAX3fhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rlv+C2H5; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rlv+C2H5"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-30bf251025aso27673821fa.1
        for <patches@lists.linux.dev>; Sat, 15 Mar 2025 13:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742069567; x=1742674367; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3phS/r1RDvxvQ2MTiit7eQFWn/59+JXZG3F6Hx5Hm8I=;
        b=Rlv+C2H5rVE4vaYq5FuOb/jJzOKZ5tf3kSPwwyq9vq4HxtBCDAD3uqyMC8/nB1uPrv
         WiMAN0JHMyEaeIgzl+TEnX5pUsGKoyQWRgfEl6TjWOuspLeSzxZBVs1DN5xBZmJiLISx
         9JLrFkGDSkGTwZtGCGFuT97pl9f9ZEzXfQVW49NbveJyX4xjsQ2FAgAbNhqfKiC9XGsD
         di+UNl/bX/AKQXxpgT++ErdaHGORpkvmY4m2DZujUg4fJtDA2L0kVmSiqt/38mJmWnBU
         Bo9IUbXmBryG2E+NJEj50fXFycEhl9c6SluAoMgBjW7/zRpEwETTX7MzTDfyFwhc+sdI
         KzCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742069567; x=1742674367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3phS/r1RDvxvQ2MTiit7eQFWn/59+JXZG3F6Hx5Hm8I=;
        b=m18i16MW2TXQTNVdtoynxtccrCQyXsWZ5Wt26PzM6TwZ+8aO39jOsAj9mDU187+HJJ
         xU7URhdy6mLp0yTsHb8D7OLMuIV4kbGD0kTYgBZLxaKXKwQVWqMoOs9TtKLH5LY5Pz3o
         baH/v3flRHI9ZuqQnxyBdho9aYGQR31cZvUZ3wa7hKqte12PyB2FQmJfmT/IbtHXMVBu
         2m8WEriy0ODQN9eOj1maNyt3Pf+vOnHwYJj5gOX2mm5WFn6fkcCqm8MAPKM4KZGWDc5N
         IgMBW/JKLKsmagLRZCU6RfphGQR3BH8Dd3riK9GHggJ8mIPDkZqJs4hyqNIx48FHpf9L
         3cEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKO8IPJ3EiQnOcsVfqc+3aDk6BKJ11qFarPQCtgLV6za0hU1OnG1vD+t2WcGMPn/Nj/MPMYefj@lists.linux.dev
X-Gm-Message-State: AOJu0YxUFXLKiNtnhrbER4Iepezcnmeici+m+Do77C45nMwZzONX0Dv8
	pWdTm1jSHF+s1faKU2hRI7UVbALN3MwDRZB1fykm5Sp2YvDe0BBNeyTZSogJrdr7MuHsWUeJYCM
	jRCwoZgkReXHvxDT6uFc0htxAJXU=
X-Gm-Gg: ASbGncsEzs+y3sSBbusFovrhiI1vVFke/B7UolJUmwEzXGPPOgGW7sW23zEULANMBm7
	1K/BcNtM1qg0zAUKkfMWe1xo4HYkW+v0LtMHOk+BpjEpQe4nFQmfKIq6dQXStGS8l1JJ4NPuVys
	AsLnjQ8znTM0CBlvE/oCRxVHjPzTpv2QkX3wruLPH2/Xf9dK5jUSubwUnupfVl
X-Google-Smtp-Source: AGHT+IFm7u/ca+fpxCQ+7+YMZzrKOStRLWcuvfvFBYSJTa+No/pqBu7Qqr1e6HCaZmCkLCgP+lX+Ttx/F2r2o7AdNoE=
X-Received: by 2002:a2e:b895:0:b0:30c:1af6:b41a with SMTP id
 38308e7fff4ca-30c4a8769fcmr32496991fa.18.1742069566448; Sat, 15 Mar 2025
 13:12:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250315194045.2353200-1-ojeda@kernel.org>
In-Reply-To: <20250315194045.2353200-1-ojeda@kernel.org>
From: Tamir Duberstein <tamird@gmail.com>
Date: Sat, 15 Mar 2025 16:12:10 -0400
X-Gm-Features: AQ5f1JoSHl9Pk5sGde8YLinE1OIhoyWuxkSyv0i4A4qoM-oYiV0cuN7rEeMjPpY
Message-ID: <CAJ-ks9kk-31CfavAHqgzmZMXcaq07ZwMyButDVqNG-g5RMSD6A@mail.gmail.com>
Subject: Re: [PATCH v2] rust: kbuild: skip `--remap-path-prefix` for `rustdoc`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 15, 2025 at 3:41=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> `rustdoc` only recognizes `--remap-path-prefix` starting with
> Rust 1.81.0, which is later than on minimum, so we cannot pass it
> unconditionally. Otherwise, we get:
>
>     error: Unrecognized option: 'remap-path-prefix'
>
> Note that `rustc` (the compiler) does recognize the flag since a long
> time ago (1.26.0).
>
> Moreover, `rustdoc` since Rust 1.82.0 ICEs in out-of-tree builds when
> using `--remap-path-prefix`. The issue has been reduced and reported
> upstream [1].
>
> Thus workaround both issues by simply skipping the flag when generating
> the docs -- it is not critical there anyway.
>
> The ICE does not reproduce under `--test`, but we still need to skip
> the flag as well for `RUSTDOC TK` since it is not recognized.
>
> Fixes: 6b5747d07138 ("kbuild, rust: use -fremap-path-prefix to make paths=
 relative")
> Link: https://github.com/rust-lang/rust/issues/138520 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> v2:
>   - Skip the flag also in `RUSTDOC TK`. The ICE does not apply there,
>     but we still need to skip the flag.
>
>  rust/Makefile | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/rust/Makefile b/rust/Makefile
> index ea3849eb78f6..089473a89d46 100644
> --- a/rust/Makefile
> +++ b/rust/Makefile
> @@ -57,10 +57,14 @@ endif
>  core-cfgs =3D \
>      --cfg no_fp_fmt_parse
>
> +# `rustc` recognizes `--remap-path-prefix` since 1.26.0, but `rustdoc` o=
nly
> +# since Rust 1.81.0. Moreover, `rustdoc` ICEs on out-of-tree builds sinc=
e Rust
> +# 1.82.0 (https://github.com/rust-lang/rust/issues/138520). Thus workaro=
und both
> +# issues skipping the flag. The former also applies to `RUSTDOC TK`.
>  quiet_cmd_rustdoc =3D RUSTDOC $(if $(rustdoc_host),H, ) $<
>        cmd_rustdoc =3D \
>         OBJTREE=3D$(abspath $(objtree)) \
> -       $(RUSTDOC) $(filter-out $(skip_flags),$(if $(rustdoc_host),$(rust=
_common_flags),$(rust_flags))) \
> +       $(RUSTDOC) $(filter-out $(skip_flags) --remap-path-prefix=3D%,$(i=
f $(rustdoc_host),$(rust_common_flags),$(rust_flags))) \
>                 $(rustc_target_flags) -L$(objtree)/$(obj) \
>                 -Zunstable-options --generate-link-to-definition \
>                 --output $(rustdoc_output) \
> @@ -171,7 +175,7 @@ quiet_cmd_rustdoc_test_kernel =3D RUSTDOC TK $<
>         rm -rf $(objtree)/$(obj)/test/doctests/kernel; \
>         mkdir -p $(objtree)/$(obj)/test/doctests/kernel; \
>         OBJTREE=3D$(abspath $(objtree)) \
> -       $(RUSTDOC) --test $(rust_flags) \
> +       $(RUSTDOC) --test $(filter-out --remap-path-prefix=3D%,$(rust_fla=
gs)) \
>                 -L$(objtree)/$(obj) --extern ffi --extern kernel \
>                 --extern build_error --extern macros \
>                 --extern bindings --extern uapi \
>
> base-commit: bc5431693696b3f928b0b7acf8d7a120127db7a4
> --
> 2.49.0
>

Reviewed-by: Tamir Duberstein <tamird@gmail.com>
