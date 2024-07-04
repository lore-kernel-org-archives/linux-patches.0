Received: from gimli.kloenk.de (gimli.kloenk.de [49.12.72.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A9B1B1413
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 14:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.72.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720104682; cv=none; b=oPzJs6xnsP0w16x9KUCyEgoHzQ2Vt6ZKKKEj8VV/68uKx3sXUiYE+dBeKhulZa/PT7h2nMWBmN1whaDEI6noMztCM+qSfM6DNBrNBGTxNzHq3TleWiInaLyUmfnhnMx4gpe9/pzcCBQNSqvtH5tIF8055gqFA4Ys/jj0Csw3cd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720104682; c=relaxed/simple;
	bh=2WqPkYgcVOcJUdXrWzG9JEthQgFD3JbhnjuLk3fLfxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dJzO6cy3RyOQMXH69lq1k1xFU9nMkFt5o/Zs1kUjz+stkB83wtlMWp8T/NRe3bah9uzP1TnMUHJ1ELBgNa2FWXeVZLQwrQsF0wddhloi2qnuyNy1gWKwHjMh7d4lBZch3OTkB4s4DuchgSi/o34KHFUTc+q3R65uu5dBKN7t1Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev; spf=pass smtp.mailfrom=kloenk.dev; dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b=e4L7QNOl; arc=none smtp.client-ip=49.12.72.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b="e4L7QNOl"
From: Finn Behrens <me@kloenk.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.dev; s=mail;
	t=1720104678; bh=t4JaQy2kQjDTbqKgYKRhRdtwRxztZ6aV2QZFu9HiWgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4L7QNOlDf/MoEMzF61XrdYId+yPePTPGMsJdcs/xao5aluG+Hn/AcIYQLXNhSTWy
	 /473IiL4L0oA8bfdXQsQH3g7NNThQCLj5YdjhBZZgGQB30ALWXr2S6TwR0qLgZELIe
	 sjxWClV2odnwlyRi+oOuowL+d6xG+IcM59Z74634=
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH 08/13] rust: work around `bindgen` 0.69.0 issue
Date: Thu, 04 Jul 2024 16:51:17 +0200
Message-ID: <D672AA56-460F-44C5-A73C-E99D36F86078@kloenk.dev>
In-Reply-To: <20240701183625.665574-9-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
 <20240701183625.665574-9-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



On 1 Jul 2024, at 20:36, Miguel Ojeda wrote:

> `bindgen` 0.69.0 contains a bug: `--version` does not work without
> providing a header [1]:
>
>     error: the following required arguments were not provided:
>       <HEADER>
>
>     Usage: bindgen <FLAGS> <OPTIONS> <HEADER> -- <CLANG_ARGS>...
>
> Thus, in preparation for supporting several `bindgen` versions, work
> around the issue by passing a dummy argument.
>
> Include a comment so that we can remove the workaround in the future.
>
> Link: https://github.com/rust-lang/rust-bindgen/pull/2678 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Finn Behrens <me@kloenk.dev>

> ---
>  init/Kconfig                 | 5 ++++-
>  scripts/rust_is_available.sh | 6 +++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index febdea2afc3b..94e20d3b99d4 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1928,7 +1928,10 @@ config RUSTC_VERSION_TEXT
>  config BINDGEN_VERSION_TEXT
>  	string
>  	depends on RUST
> -	default $(shell,command -v $(BINDGEN) >/dev/null 2>&1 && $(BINDGEN) -=
-version || echo n)
> +	# The dummy parameter `workaround-for-0.69.0` is required to support =
0.69.0
> +	# (https://github.com/rust-lang/rust-bindgen/pull/2678). It can be re=
moved when
> +	# the minimum version is upgraded past that (0.69.1 already fixed the=
 issue).
> +	default $(shell,command -v $(BINDGEN) >/dev/null 2>&1 && $(BINDGEN) -=
-version workaround-for-0.69.0 || echo n)
>
>  #
>  # Place an empty function call at each tracepoint site. Can be
> diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.s=
h
> index 33bbd01ffe51..cfda8157dce9 100755
> --- a/scripts/rust_is_available.sh
> +++ b/scripts/rust_is_available.sh
> @@ -121,8 +121,12 @@ fi
>  # Check that the Rust bindings generator is suitable.
>  #
>  # Non-stable and distributions' versions may have a version suffix, e.=
g. `-dev`.
> +#
> +# The dummy parameter `workaround-for-0.69.0` is required to support 0=
=2E69.0
> +# (https://github.com/rust-lang/rust-bindgen/pull/2678). It can be rem=
oved when
> +# the minimum version is upgraded past that (0.69.1 already fixed the =
issue).
>  rust_bindings_generator_output=3D$( \
> -	LC_ALL=3DC "$BINDGEN" --version 2>/dev/null
> +	LC_ALL=3DC "$BINDGEN" --version workaround-for-0.69.0 2>/dev/null
>  ) || rust_bindings_generator_code=3D$?
>  if [ -n "$rust_bindings_generator_code" ]; then
>  	echo >&2 "***"
> -- =

> 2.45.2
