Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463101CEAB3
	for <patches@lists.linux.dev>; Thu,  5 Dec 2024 23:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733442005; cv=none; b=oxFDzNBZZfkAfUSuJj6XEzUh/FSol22auQIsnDjE348ZwiuJJpAswEd+XutoxxI3yuwDBas00b3eU4xRvdKvE1sy9IDdTSOViqE3BzKFfdoW65bIRjljR7zm6Nwip0+YZbEWQ882yvFRIYV5d4vrmTdSvt1Ekhk/gpRzSk6bN3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733442005; c=relaxed/simple;
	bh=xsaP4U5pHbcH6lrCPxKA+1Tf417cCvTSpwmt6Uxm9hU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tulb4fLDpTOb29Rw391ZuJJ8iG/pg/NkxabDXfpd0oLYRzUsrPgpmozD3JspVqNz79YrOcvzkrpKY2y/N6aF/ObExZKr7tegNdvtdrB4inpS5MJpgQPvzaIViHKARbX0/DN/Rnbu1KRECDUmulYUxGMjbBd+m9qebAXEoKXqdLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xv8TpBLD; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xv8TpBLD"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5ceca0ec4e7so1722501a12.0
        for <patches@lists.linux.dev>; Thu, 05 Dec 2024 15:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733442002; x=1734046802; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+MB5DA5Lyb0OmXYuKKW+jJvk7Dw23YqpgDd8tDMcjU=;
        b=xv8TpBLDarG2APg2caeKy5kW8Der0OfnikWlcMKuCz7xzBlcIWiTjt+GQyV3ZOu9Bt
         pcHV/0JxaZK9N2xgfy0C8pgOGDmuwrkTYBx1Yh790Ua4WVEchkkJI0+JVfHhXDm3ifLB
         FE9rOvMupzLX0hgpPQ5TDBf+P/CmhCM8zUBMQ2EJ/9AocFPMAHHkvmO4bqnH/xvom0hP
         2HOTE3z5tEceTITEN+GviAjo1gtmicUD1Y7HDhKKWDFlDW5ctAXt1rYfFohCjXUTl5Pk
         U2T2fS9EymqY1CmQOMSfdvANKLxmzGlM4OYT5DmHGivDZy6aaNZNW4TfgoEo5ZB8ZKNy
         F6BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733442002; x=1734046802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L+MB5DA5Lyb0OmXYuKKW+jJvk7Dw23YqpgDd8tDMcjU=;
        b=jkncDYGVxkphfKyzGcn9NaQgLZmpFdzSh3OPMWQi2coTqyq1fz2Ubq3kKkXxtV5ogH
         MR8LcWyPuHAiLrHrvwIvIvPw8AlnopsC7HmAs5C5kF0dpNlvq1xP5eDAOVLsqeGx2U4r
         msrLLAIjJEF61kRs7MtR1t0M/meTxod1PnFDrSLoHgxmoRszuNAaYvnqQOULp6R3jqbI
         tdCXle19Pglnt+9b1Uy6Ym7ov6jQr1B95myKkWf3IZC0sD30dhKn4+2UxJdEdX5/aE1m
         Gl7M1DcG5+ei383c35HhLlhgOXWAVajlWbpSXyk0hJdGc+TVXstjj8je3N7XB0ufZ8SS
         p3+A==
X-Forwarded-Encrypted: i=1; AJvYcCXmwzEfREp773/BBybygoSqGrx38+ZKTaEom7Meqi/HUfxhu702gx7s2OBwYgMZpxLwQMEXGUQ7@lists.linux.dev
X-Gm-Message-State: AOJu0YziQtAuTq0MgD9iX7ryfWaKt33vF3paepY9W3BD9plp/rnHXP3B
	pjavml/DM3YYRh9tQLAC79oMoIFUQgBmyDEiWiwc4ASi2uBsvZKeWe7SdaM6xdD1OK6KLqsbvcr
	qEojzsC5dvx5q/xZtzUnMy9zdi8ZeX9zV0lH+jvs51FNClsyjwpA+
X-Gm-Gg: ASbGncsuzpVmUYkFoNYhs6m5p5TjcuqcPYLo94TtuhQFPFPhr3UEEAeWbnvHtZKT0L0
	sa9C8/N2hESzpLJ4qxjGuTNGzACTDpaz9+K3uvtuQLLNH6uo6+01Hbh2Kspy7eCI=
X-Google-Smtp-Source: AGHT+IG0eJwol/pjrqooOab5q8PwKWmOD6RpXYtIUF7nN9ABJjk70oRCP9el2KO875OhTIaI5aGYBKKVTIFg4+EW1Cg=
X-Received: by 2002:a05:6402:4497:b0:5d3:bc56:3b24 with SMTP id
 4fb4d7f45d1cf-5d3be65a58bmr639866a12.4.1733442001551; Thu, 05 Dec 2024
 15:40:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112184455.855133-1-ojeda@kernel.org>
In-Reply-To: <20241112184455.855133-1-ojeda@kernel.org>
From: "Hong, Yifan" <elsk@google.com>
Date: Thu, 5 Dec 2024 15:39:25 -0800
Message-ID: <CAABy=s1u75ywAECbkCmGfyt+Yp5khnF0UVcezA-_BEDWUVrHkw@mail.gmail.com>
Subject: Re: [PATCH v3] kbuild: rust: add PROCMACROLDFLAGS
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, 
	linux-kbuild@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2024 at 10:45=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> From: HONG Yifan <elsk@google.com>
>
> These are flags to be passed when linking proc macros for the Rust
> toolchain. If unset, it defaults to $(KBUILD_HOSTLDFLAGS).
>
> This is needed because the list of flags to link hostprogs is not
> necessarily the same as the list of flags used to link libmacros.so.
> When we build proc macros, we need the latter, not the former (e.g. when
> using a Rust compiler binary linked to a different C library than host
> programs).
>
> To distinguish between the two, introduce this new variable to stand
> out from KBUILD_HOSTLDFLAGS used to link other host progs.
>
> Signed-off-by: HONG Yifan <elsk@google.com>
> Link: https://lore.kernel.org/r/20241017210430.2401398-2-elsk@google.com
> [ v3:
>
>   - `export`ed the variable. Otherwise it would not be visible in
>     `rust/Makefile`.
>
>   - Removed "additional" from the documentation and commit message,
>     since this actually replaces the other flags, unlike other cases.
>
>   - Added example of use case to documentation and commit message.
>     Thanks Alice for the details on what Google needs!
>
>   - Instead of `HOSTLDFLAGS`, used `KBUILD_HOSTLDFLAGS` as the fallback
>     to preserve the previous behavior as much as possible, as discussed
>     with Alice/Yifan. Thus moved the variable down too (currently we
>     do not modify `KBUILD_HOSTLDFLAGS` elsewhere) and avoided
>     mentioning `HOSTLDFLAGS` directly in the documentation.
>
>   - Fixed documentation header formatting.
>
>   - Reworded slightly.
>
>          - Miguel ]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> Masahiro: if Kbuild wants to pick this up, that is great. Otherwise, I am=
 happy
> picking this up early next cycle, if you give an `Acked-by` since this is
> changing the interface for Kbuild users given we are introducing a new
> environment variable. Thanks!
>
> Note that the `or` means if the string is empty, we will use the default =
rather
> than nothing. I didn't change that from Yifan's version, but maybe we wan=
t to do
> otherwise. Users can still provide e.g. an empty space to avoid any flag.

I am not sure if I understand the implications here.
https://www.gnu.org/software/make/manual/html_node/Conditional-Functions.ht=
ml
says:

The or function provides a =E2=80=9Cshort-circuiting=E2=80=9D OR operation.=
 Each
argument is expanded, in order. If an argument expands to a non-empty
string the processing stops and the result of the expansion is that
string. If, after all arguments are expanded, all of them are false
(empty), then the result of the expansion is the empty string.

I am assuming that this means:
- If PROCMACROLDFLAGS is not empty, KBUILD_PROCMACROLDFLAGS evaluates
to PROCMACROLDFLAGS
- Otherwise if KBUILD_HOSTLDFLAGS is not empty,
KBUILD_PROCMACROLDFLAGS evaluates to KBUILD_HOSTLDFLAGS
- Otherwise KBUILD_PROCMACROLDFLAGS is set to empty.

What do you mean by "use the default"?


>
> Yifan/Alice: please double-check the changes. Thanks!
>
> v3: see changes above.
> v2: https://lore.kernel.org/rust-for-linux/20241017210430.2401398-2-elsk@=
google.com/
> v1: https://lore.kernel.org/rust-for-linux/20241017200138.2390077-2-elsk@=
google.com/
>
>  Documentation/kbuild/kbuild.rst | 11 +++++++++++
>  Makefile                        |  3 ++-
>  rust/Makefile                   |  2 +-
>  3 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/kbuild/kbuild.rst b/Documentation/kbuild/kbuil=
d.rst
> index 1796b3eba37b..9cb876ccc363 100644
> --- a/Documentation/kbuild/kbuild.rst
> +++ b/Documentation/kbuild/kbuild.rst
> @@ -91,6 +91,17 @@ HOSTRUSTFLAGS
>  -------------
>  Additional flags to be passed to $(HOSTRUSTC) when building host program=
s.
>
> +PROCMACROLDFLAGS
> +----------------
> +Flags to be passed when linking Rust proc macros. Since proc macros are =
loaded
> +by rustc at build time, they must be linked in a way that is compatible =
with
> +the rustc toolchain being used.
> +
> +For instance, it can be useful when rustc uses a different C library tha=
n
> +the one the user wants to use for host programs.
> +
> +If unset, it defaults to the flags passed when linking host programs.
> +
>  HOSTLDFLAGS
>  -----------
>  Additional flags to be passed when linking host programs.
> diff --git a/Makefile b/Makefile
> index a9e723cb0596..3efb001bada5 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -471,6 +471,7 @@ KBUILD_HOSTRUSTFLAGS :=3D $(rust_common_flags) -O -Cs=
trip=3Ddebuginfo \
>                         -Zallow-features=3D $(HOSTRUSTFLAGS)
>  KBUILD_HOSTLDFLAGS  :=3D $(HOST_LFS_LDFLAGS) $(HOSTLDFLAGS)
>  KBUILD_HOSTLDLIBS   :=3D $(HOST_LFS_LIBS) $(HOSTLDLIBS)
> +KBUILD_PROCMACROLDFLAGS :=3D $(or $(PROCMACROLDFLAGS),$(KBUILD_HOSTLDFLA=
GS))
>
>  # Make variables (CC, etc...)
>  CPP            =3D $(CC) -E
> @@ -595,7 +596,7 @@ export HOSTRUSTC KBUILD_HOSTRUSTFLAGS
>  export CPP AR NM STRIP OBJCOPY OBJDUMP READELF PAHOLE RESOLVE_BTFIDS LEX=
 YACC AWK INSTALLKERNEL
>  export PERL PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
>  export KGZIP KBZIP2 KLZOP LZMA LZ4 XZ ZSTD
> -export KBUILD_HOSTCXXFLAGS KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS LDFLAGS_=
MODULE
> +export KBUILD_HOSTCXXFLAGS KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS KBUILD_P=
ROCMACROLDFLAGS LDFLAGS_MODULE
>  export KBUILD_USERCFLAGS KBUILD_USERLDFLAGS
>
>  export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS KBUILD_L=
DFLAGS
> diff --git a/rust/Makefile b/rust/Makefile
> index f349e7b067ea..9f55c470aa2c 100644
> --- a/rust/Makefile
> +++ b/rust/Makefile
> @@ -344,7 +344,7 @@ quiet_cmd_rustc_procmacro =3D $(RUSTC_OR_CLIPPY_QUIET=
) P $@
>        cmd_rustc_procmacro =3D \
>         $(RUSTC_OR_CLIPPY) $(rust_common_flags) \
>                 -Clinker-flavor=3Dgcc -Clinker=3D$(HOSTCC) \
> -               -Clink-args=3D'$(call escsq,$(KBUILD_HOSTLDFLAGS))' \
> +               -Clink-args=3D'$(call escsq,$(KBUILD_PROCMACROLDFLAGS))' =
\
>                 --emit=3Ddep-info=3D$(depfile) --emit=3Dlink=3D$@ --exter=
n proc_macro \
>                 --crate-type proc-macro \
>                 --crate-name $(patsubst lib%.so,%,$(notdir $@)) $<
>
> base-commit: d072acda4862f095ec9056979b654cc06a22cc68
> --
> 2.47.0
