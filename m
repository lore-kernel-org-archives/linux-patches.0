Received: from gimli.kloenk.de (gimli.kloenk.de [49.12.72.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A20C1AEFE7
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 14:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.72.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720103172; cv=none; b=Ivra6ZQwl5LVFADNNWDZ0ydS+tO3SLaR9hPpkgz16zvPwaFqkSMQhNxtqsBIys9F3x5TAlemxX0Iyyo4PlogHfCgtc7WRoNH+JgEBKcdwCKLULpitaOn/BClIqWR02mDrNVhu6yOAqncLOxAhE3vX00+7VBWZVuLjXGjV+YN8U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720103172; c=relaxed/simple;
	bh=uWs+KI/NnNRYahU8cZs7MxLdZZhTS8AEn/oPUiUEj8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LFCNLKiaBDK2ZseokGf/Wv+8i68aSg6K6lQ7ayvo8y2HAkKQVzwcuCoNsegKCcoAswQdmOtdSNeGZSKv2XtanynZqlvVnQx2zU8qfkV5DPxIQMP2FWcE5cVnYjJ4SxC3L4Z2hCzcz9fay6yjeV2TDWE2kdWzzys6qx0gDNgEBos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev; spf=pass smtp.mailfrom=kloenk.dev; dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b=Wvpig7nN; arc=none smtp.client-ip=49.12.72.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b="Wvpig7nN"
From: Finn Behrens <me@kloenk.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.dev; s=mail;
	t=1720103160; bh=klEyNORmTUCopsPqwvQ4SusCT6WUx2UKJes8fXdkRVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wvpig7nN4lrs7VsYh/M3O45Lg3AnmUcPuxZQYexSIJck67xx6x0BQcdxk8qs6WGav
	 1s6gBDc5m3Go3ZRPEMuQ7zT5gVdMu16xsruZyW5X9ndKUxnn0BVE4gZcLYZxK7XFLY
	 5/Gh4axfm8Wnm3dfBkZY2zORWBqxFN6ifcOhbDRQ=
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH 01/13] rust: macros: indent list item in `paste!`'s docs
Date: Thu, 04 Jul 2024 16:25:58 +0200
Message-ID: <E3504594-6CD3-4D12-B0DA-92B032CD73AA@kloenk.dev>
In-Reply-To: <20240701183625.665574-2-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
 <20240701183625.665574-2-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



On 1 Jul 2024, at 20:36, Miguel Ojeda wrote:

> A new style lint, `doc_lazy_continuation` [1], has been introduced in t=
he
> upcoming Rust 1.80 (currently in beta), which detects missing indentati=
on
> in code documentation.
>
> We have one such case:
>
>     error: doc list item missing indentation
>     --> rust/macros/lib.rs:315:5
>         |
>     315 | /// default the span of the `[< >]` group is used.
>         |     ^
>         |
>         =3D help: if this is supposed to be its own paragraph, add a bl=
ank line
>         =3D help: for further information visit https://rust-lang.githu=
b.io/rust-clippy/master/index.html#doc_lazy_continuation
>         =3D note: `-D clippy::doc-lazy-continuation` implied by `-D cli=
ppy::style`
>         =3D help: to override `-D clippy::style` add `#[allow(clippy::d=
oc_lazy_continuation)]`
>     help: indent this line
>         |
>     315 | ///   default the span of the `[< >]` group is used.
>         |     ++
>
> While the rendering of the docs by `rustdoc` is not affected, we apply
> this kind of indentation elsewhere since it looks better.
>
> Thus clean it up.
>
> Link: https://rust-lang.github.io/rust-clippy/master/index.html#/doc_la=
zy_continuation [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Finn Behrens <me@kloenk.dev>

> ---
>  rust/macros/lib.rs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
> index 520eae5fd792..05d976b3c09a 100644
> --- a/rust/macros/lib.rs
> +++ b/rust/macros/lib.rs
> @@ -312,7 +312,7 @@ pub fn pinned_drop(args: TokenStream, input: TokenS=
tream) -> TokenStream {
>  ///
>  /// Currently supported modifiers are:
>  /// * `span`: change the span of concatenated identifier to the span o=
f the specified token. By
> -/// default the span of the `[< >]` group is used.
> +///   default the span of the `[< >]` group is used.
>  /// * `lower`: change the identifier to lower case.
>  /// * `upper`: change the identifier to upper case.
>  ///
> -- =

> 2.45.2
