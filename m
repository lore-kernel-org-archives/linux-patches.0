Received: from gimli.kloenk.de (gimli.kloenk.de [49.12.72.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76391B0123
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 15:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.72.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720105658; cv=none; b=P011AkDmXzVe588+ikfQNuI/v++s/gBmaFFgIAZzmuASrxsQl90df2gQM/FzoDayji1iN8INuojEwre2eoa5C7fmI1fHewB0RWn4+JEnL5OopDke0EnYN05n57EBxSRXbdF74GnBNxyHJr3r0QgBTmEavnvOtd/Y6DA37S5hw6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720105658; c=relaxed/simple;
	bh=5ndPS3SHNb5L8Qb8xjAjVQc0GvUaAbLiGMjz5p71ihk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AHzbyzBNEreIWK3zDzSzTKy/4K98IAtc+4HW1iKbOANpsJDm6GtKXCiZoMHs4JZF+Ktk5cjIbHCKy0nlYzV3ycu00hJJBLg+V+8gvXQgl2oCGgRZ6aCgP2Jo2nyEx0C8dGMd6e7lh8sPDBQdfzXuFv2dpnkenHTFHlsYiCnAPA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev; spf=pass smtp.mailfrom=kloenk.dev; dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b=KgfREaH7; arc=none smtp.client-ip=49.12.72.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b="KgfREaH7"
From: Finn Behrens <me@kloenk.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.dev; s=mail;
	t=1720105654; bh=/Myly9OePrHpY+RzBI1gBpBxXqgyChS6DazoIA98PLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KgfREaH7oOGttaLrHl4jHeS10G6vluS9d9dFXJeHtx1qAad0M3VVPfmkuXDjvf7Yb
	 hU2V+111IilwbmQ8xZUOCbfZH2rEtLYx81jlhTtz/YL3KcC538n9QByN5C2oqF8YdH
	 iIQ2llJKg0PpZWwUIoDrXbV39oVxv3giJ3uURk/U=
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 12/13] rust: support the new `-Zub-checks` flag
Date: Thu, 04 Jul 2024 17:07:33 +0200
Message-ID: <CF7780EE-D42B-4D79-BA8E-666D6E0E2A9D@kloenk.dev>
In-Reply-To: <20240701183625.665574-13-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
 <20240701183625.665574-13-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



On 1 Jul 2024, at 20:36, Miguel Ojeda wrote:

> Rust 1.79.0 has introduced a new codegen flag, `-Zub-checks` [1], to
> allow to independently configure (from `-Cdebug-assertions`) whether th=
e
> extra runtime checks for UB are emitted, in a similar fashion to
> `-Coverflow-checks`.
>
> This allows to configure the kernel with only the UB checks enabled,
> but not the `debug_assert!`s; or vice versa, e.g. [2].
>
> It also showcases how `RUSTC_VERSION` and the Kbuild macros, introduced=

> in the previous commit, can be used.
>
> Link: https://github.com/rust-lang/compiler-team/issues/725 [1]
> Link: https://godbolt.org/z/jY69ezx5K [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Finn Behrens <me@kloenk.dev>

> ---
>  Makefile          |  9 +++++++--
>  lib/Kconfig.debug | 18 ++++++++++++++++++
>  2 files changed, 25 insertions(+), 2 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 3f43f03f855e..c0cb5c237c26 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -820,10 +820,15 @@ KBUILD_CFLAGS +=3D -Os
>  KBUILD_RUSTFLAGS +=3D -Copt-level=3Ds
>  endif
>
> -# Always set `debug-assertions` and `overflow-checks` because their de=
fault
> -# depends on `opt-level` and `debug-assertions`, respectively.
> +# Always set `debug-assertions` because its default depends on `opt-le=
vel`.
>  KBUILD_RUSTFLAGS +=3D -Cdebug-assertions=3D$(if $(CONFIG_RUST_DEBUG_AS=
SERTIONS),y,n)
> +
> +# Always set `overflow-checks` and `ub-checks` because their default d=
epends on
> +# `debug-assertions`.
>  KBUILD_RUSTFLAGS +=3D -Coverflow-checks=3D$(if $(CONFIG_RUST_OVERFLOW_=
CHECKS),y,n)
> +ifeq ($(call rustc-min-version, 107900),y)
> +KBUILD_RUSTFLAGS +=3D -Zub-checks=3D$(if $(CONFIG_RUST_UNDEFINED_BEHAV=
IOR_CHECKS),y,n)
> +endif
>
>  # Tell gcc to never replace conditional load with a non-conditional on=
e
>  ifdef CONFIG_CC_IS_GCC
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 59b6765d86b8..6b4f512f9e13 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -3020,6 +3020,24 @@ config RUST_OVERFLOW_CHECKS
>
>  	  If unsure, say Y.
>
> +config RUST_UNDEFINED_BEHAVIOR_CHECKS
> +	bool "Undefined Behavior checks"
> +	depends on RUST && RUSTC_VERSION >=3D 107900
> +	help
> +	  Enables rustc's `-Zub-checks` codegen option.
> +
> +	  This flag allows you to control whether additional runtime checks t=
hat
> +	  detect some causes of Undefined Behavior at runtime will be emitted=
=2E
> +	  When enabled, a Rust panic will occur if UB is detected.
> +
> +	  All checks are generated on a best-effort basis; even if there is a=
 check
> +	  implemented for some cause of Undefined Behavior, it may be possibl=
e for
> +	  the check to not fire.
> +
> +	  Note that this will apply to all Rust code, including `core`.
> +
> +	  If unsure, say N.
> +
>  config RUST_BUILD_ASSERT_ALLOW
>  	bool "Allow unoptimized build-time assertions"
>  	depends on RUST
> -- =

> 2.45.2
