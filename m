Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E5F1E5B95
	for <patches@lists.linux.dev>; Sat, 26 Jul 2025 16:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753545929; cv=none; b=L0m7x7kDzlVMJ6DYjsKrAQAz+83Ii+cm3LdwmGFd5wbdVjre6crBzoaBXvHGIfGdx5l8EUmjhukbcovU8cwIXkJri20f5cZlWL5RSZpcpHfDJmtRZog/rHCGKP7HycotOJcbSKEMw5oc8ofFHzY/TnNgqpH1YZSAd4uMfPDgtdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753545929; c=relaxed/simple;
	bh=6MpzxbPX27NadrsGk0zw216Oyyfxgmiy2Y1q0a0nRAg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fNc4MSWjcjLZKx14+alle/hEB/fpdsS26S2Ug1NcPdKU28JH0PicelUlAKY3bZS5WYrwX+mceII8JOfqjyOvar77F9Sb6Ju//ow6Zq88nHWkXSTc2+u6xARV/h9yb+xQeGuUPUMdWbKFGnOkK4cT/mKdGCGdAb0YwaFK7WvMfmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nswe3jsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nswe3jsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CA5C4CEEF
	for <patches@lists.linux.dev>; Sat, 26 Jul 2025 16:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753545928;
	bh=6MpzxbPX27NadrsGk0zw216Oyyfxgmiy2Y1q0a0nRAg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Nswe3jsqp6uE7J1q7VAwlweFK/2EEUj7/yxpjrJQyvWTj4EeJEZBv0JpsuCBwmk9j
	 KQGbwwXZkDzP3Cv/CmuBqW5czzXH4Amoedtr7f+H5hLT3PHXN7KteirmjuUQiZOAQl
	 klNA3B27wfo4lQDjcAPDelN6tRNDHFIX5fF86m2sx5GTcFLgwLLiXX/d6P7PkMYoCj
	 8kmhXu/aREl7k1k6ju8PWjjtBJetXCVS6rBAYEiiFnlB0QmrzDwj6nZ6ZsREF+y7qo
	 u/Kn73NsPR4Njr7h9iAxCY18/TebJ9DGgoU2vR+YIAqUCF0naKkBNT6CMpQ2EJRehI
	 jsQfyRqmURChQ==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-32f1df58f21so31109791fa.3
        for <patches@lists.linux.dev>; Sat, 26 Jul 2025 09:05:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUf8KchCX+h5h15/D+Xwy8AuVMYfh0aKelTZ6/DD6LdNCTwdNu7Cco0pJ6fIEU5fWSiQneu9WyM@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4t+kxH59XTuG4OIzVclWTEiYLDLEtrpfCEK/ieIDGNa5X87gE
	mYA4E3GQDb7KlLAyTfU8pOmHk2++2WdfdDkJ+I7VrUdxSfDo6NIXmUL6p8wspFABoJx1VJB4ECQ
	2EV4KDs3Y46rbKW3ubMZUGzVaWr9KvWU=
X-Google-Smtp-Source: AGHT+IG3EDvduZsc53+xFnV4ZnOEuNccFoxXRBW2DEcupA+kF+Dd/tDVGJKqs9SWSByGCvtmwfD4iZl2Wi/hY9T3Dvo=
X-Received: by 2002:a05:651c:154b:b0:32a:8916:55af with SMTP id
 38308e7fff4ca-331ee622688mr19317841fa.2.1753545927125; Sat, 26 Jul 2025
 09:05:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250726133435.2460085-1-ojeda@kernel.org>
In-Reply-To: <20250726133435.2460085-1-ojeda@kernel.org>
From: Tamir Duberstein <tamird@kernel.org>
Date: Sat, 26 Jul 2025 12:04:50 -0400
X-Gmail-Original-Message-ID: <CAJ-ks9kneAWVxMNYcmQzks6NaprRPJZPyFkRBtLmtseemyJgbg@mail.gmail.com>
X-Gm-Features: Ac12FXxAFNw0PPG_mgb-afX1RFMqeDfPaH7GOci4UnEY3JifxOIfnYstVIjNq5A
Message-ID: <CAJ-ks9kneAWVxMNYcmQzks6NaprRPJZPyFkRBtLmtseemyJgbg@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: clean output before running `rustdoc`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Daniel Almeida <daniel.almeida@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 26, 2025 at 9:35=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> `rustdoc` can get confused when generating documentation into a folder
> that contains generated files from other `rustdoc` versions.
>
> For instance, running something like:
>
>     rustup default 1.78.0
>     make LLVM=3D1 rustdoc
>     rustup default 1.88.0
>     make LLVM=3D1 rustdoc
>
> may generate errors like:
>
>     error: couldn't generate documentation: invalid template: last line e=
xpected to start with a comment
>       |
>       =3D note: failed to create or modify "./Documentation/output/rust/r=
ustdoc/src-files.js"
>
> Thus just always clean the output folder before generating the
> documentation -- we are anyway regenerating it every time the `rustdoc`
> target gets called, at least for the time being.
>
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned i=
n older LTSs).
> Reported-by: Daniel Almeida <daniel.almeida@collabora.com>
> Closes: https://rust-for-linux.zulipchat.com/#narrow/channel/288089/topic=
/x/near/527201113
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

I've seen this as well.

Reviewed-by: Tamir Duberstein <tamird@kernel.org>


> ---
>  rust/Makefile | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/rust/Makefile b/rust/Makefile
> index 115b63b7d1e3..771246bc7ae6 100644
> --- a/rust/Makefile
> +++ b/rust/Makefile
> @@ -103,14 +103,14 @@ rustdoc: rustdoc-core rustdoc-macros rustdoc-compil=
er_builtins \
>  rustdoc-macros: private rustdoc_host =3D yes
>  rustdoc-macros: private rustc_target_flags =3D --crate-type proc-macro \
>      --extern proc_macro
> -rustdoc-macros: $(src)/macros/lib.rs FORCE
> +rustdoc-macros: $(src)/macros/lib.rs rustdoc-clean FORCE
>         +$(call if_changed,rustdoc)
>
>  # Starting with Rust 1.82.0, skipping `-Wrustdoc::unescaped_backticks` s=
hould
>  # not be needed -- see https://github.com/rust-lang/rust/pull/128307.
>  rustdoc-core: private skip_flags =3D --edition=3D2021 -Wrustdoc::unescap=
ed_backticks
>  rustdoc-core: private rustc_target_flags =3D --edition=3D$(core-edition)=
 $(core-cfgs)
> -rustdoc-core: $(RUST_LIB_SRC)/core/src/lib.rs FORCE
> +rustdoc-core: $(RUST_LIB_SRC)/core/src/lib.rs rustdoc-clean FORCE
>         +$(call if_changed,rustdoc)
>
>  rustdoc-compiler_builtins: $(src)/compiler_builtins.rs rustdoc-core FORC=
E
> @@ -122,7 +122,8 @@ rustdoc-ffi: $(src)/ffi.rs rustdoc-core FORCE
>  rustdoc-pin_init_internal: private rustdoc_host =3D yes
>  rustdoc-pin_init_internal: private rustc_target_flags =3D --cfg kernel \
>      --extern proc_macro --crate-type proc-macro
> -rustdoc-pin_init_internal: $(src)/pin-init/internal/src/lib.rs FORCE
> +rustdoc-pin_init_internal: $(src)/pin-init/internal/src/lib.rs \
> +    rustdoc-clean FORCE
>         +$(call if_changed,rustdoc)
>
>  rustdoc-pin_init: private rustdoc_host =3D yes
> @@ -140,6 +141,9 @@ rustdoc-kernel: $(src)/kernel/lib.rs rustdoc-core rus=
tdoc-ffi rustdoc-macros \
>      $(obj)/bindings.o FORCE
>         +$(call if_changed,rustdoc)
>
> +rustdoc-clean: FORCE
> +       $(Q)rm -rf $(rustdoc_output)
> +
>  quiet_cmd_rustc_test_library =3D $(RUSTC_OR_CLIPPY_QUIET) TL $<
>        cmd_rustc_test_library =3D \
>         OBJTREE=3D$(abspath $(objtree)) \
>
> base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
> --
> 2.50.1
>
>
