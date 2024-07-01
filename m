Received: from mail-40135.protonmail.ch (mail-40135.protonmail.ch [185.70.40.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFC816FF5F
	for <patches@lists.linux.dev>; Mon,  1 Jul 2024 19:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719863972; cv=none; b=Y97MtAu4/ExXYW8bt3e0IM7hHAiYy2fm1XIqRq8lNBDaqpihhbAfgm1WQKYmlvQ2W7YaM513FWT0pehLfbKb4oI+jDZ2yiX3J0LHfHOp7nPZ4xWdR+u2gB6jw3FUxNYRx1UuSF7Y1Dz30AzV+f04dXLcINm9mADoBIALOv9Noxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719863972; c=relaxed/simple;
	bh=AqA7XSoiga49RNa4in42qXiUyHcLPSufgPaTSG4cQCo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tKfbu4MFrCkmKbsnkUFzuPdPtmYBtQPtYi+8H2LR6WfAzkWScQPvUDjFFRDMFBvgJH8niX6tkIrPca32sz3AdpMUmp7JJzvYFgYSDVZux1gZn32Q5XlVpFcXINvrtmo2+lVjEQzj6xiioiKVdIEZ7MMRYEWeAgfCcNlMWTLcMxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=Ua6Q1SOJ; arc=none smtp.client-ip=185.70.40.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="Ua6Q1SOJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1719863962; x=1720123162;
	bh=LHHzOFrLVRHPhXM3cTpsKHZXSCksH5WLT0OBAgYAHgs=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Ua6Q1SOJgp+n6fD2oSLGxkwqVwx7+c9Xr4o0P452MFU7E0vLWW3tl5iLMekSfT0nB
	 aSbUbpWk+xqutaIuqVEYzkEbPj9hj1q/RG52uTPXGn+9wxqG4fI+Hlqmf8m9ZTiayi
	 UPSZ9YGZkHbIWyCmw10aS+tXoQIF7Ai+Fnvwdt4Kg+X7BInSMlwM5qwGk1blaEh+3y
	 8gMHL0FUk8Yf+K9lw79s+2cOZmkCosNb7chfP1pvvj2mUqFdBA+LAhRCmGg89zz0xk
	 e0+F2UQ0ypzhdgly82J83y5X7n7NuV3fogDnPMpsWdijbe1pFAH+de42c1IRfq0U/A
	 PaOPMT+O+v6qw==
Date: Mon, 01 Jul 2024 19:59:17 +0000
To: Miguel Ojeda <ojeda@kernel.org>
From: =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 01/13] rust: macros: indent list item in `paste!`'s docs
Message-ID: <9TYxnX2cuHc3686PNQnw2JWAXbte0llMojuko4xBdIpn1E5cQIus0_j8KGiYnTUUXzA92iglhe0EswEtgtDEKF_RKQ06s22pxzlVB9nnhxo=@protonmail.com>
In-Reply-To: <20240701183625.665574-2-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org> <20240701183625.665574-2-ojeda@kernel.org>
Feedback-ID: 27884398:user:proton
X-Pm-Message-ID: 5bdcc7dd4aadf6635da74163485a606716c87b10
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Monday, July 1st, 2024 at 20:36, Miguel Ojeda <ojeda@kernel.org> wrote:

> A new style lint, `doc_lazy_continuation` [1], has been introduced in the
> upcoming Rust 1.80 (currently in beta), which detects missing indentation
> in code documentation.
>=20
> We have one such case:
>=20
>     error: doc list item missing indentation
>     --> rust/macros/lib.rs:315:5
>         |
>     315 | /// default the span of the `[< >]` group is used.
>         |     ^
>         |
>         =3D help: if this is supposed to be its own paragraph, add a blan=
k line
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#doc_lazy_continuation
>         =3D note: `-D clippy::doc-lazy-continuation` implied by `-D clipp=
y::style`
>         =3D help: to override `-D clippy::style` add `#[allow(clippy::doc=
_lazy_continuation)]`
>     help: indent this line
>         |
>     315 | ///   default the span of the `[< >]` group is used.
>         |     ++
>=20
> While the rendering of the docs by `rustdoc` is not affected, we apply
> this kind of indentation elsewhere since it looks better.
>=20
> Thus clean it up.
>=20
> Link: https://rust-lang.github.io/rust-clippy/master/index.html#/doc_lazy=
_continuation [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Bj=C3=B6rn Roy Baron <bjorn3_gh@protonmail.com>

> ---
>  rust/macros/lib.rs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
> index 520eae5fd792..05d976b3c09a 100644
> --- a/rust/macros/lib.rs
> +++ b/rust/macros/lib.rs
> @@ -312,7 +312,7 @@ pub fn pinned_drop(args: TokenStream, input: TokenStr=
eam) -> TokenStream {
>  ///
>  /// Currently supported modifiers are:
>  /// * `span`: change the span of concatenated identifier to the span of =
the specified token. By
> -/// default the span of the `[< >]` group is used.
> +///   default the span of the `[< >]` group is used.
>  /// * `lower`: change the identifier to lower case.
>  /// * `upper`: change the identifier to upper case.
>  ///
> --
> 2.45.2
