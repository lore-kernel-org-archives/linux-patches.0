Received: from mail-43167.protonmail.ch (mail-43167.protonmail.ch [185.70.43.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C751716F908
	for <patches@lists.linux.dev>; Mon,  1 Jul 2024 20:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719864406; cv=none; b=g2o8otbYtCQ/QfxNUNdjET2JWPWQRT8jC7MjmXE08Vwd/wNt5P7Lm5YD91VZ0QH8SMIPSDsevrzYuTbL5mKxbDbArLG/7yY3BzZinvh37bvMAVEI0tlZUEvCV7f7fg3WU8g+m6eJjKKNR4Sdslnre7TXA2nEnAeOkpTrO52PkG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719864406; c=relaxed/simple;
	bh=XbPG5OYWR1cgiAkSWQfBtuSPvtxJkMeXLqpn4CoNSDs=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ol+cTXyqEAu/+1GjZoASHaLURgMca4FL5BS1LU9yISFwZA1sQTrM2+JUMn8Iym09KRQRbj7TSxWdoBfEh76ttVhQNAUN9mL3h2gisZF+p1EwsRnTsl0SUlBkm41l1Una3uVWuCIifKUwn4Rf12jc0/+l2MawBPO3QCLcsErUgt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=pfYul48e; arc=none smtp.client-ip=185.70.43.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="pfYul48e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1719864402; x=1720123602;
	bh=qBeERxLETEgybhXOkjxuhEzlSp6YK4Z+bBuIZXY0xnQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=pfYul48eOqn2o9ulBnP2mv7+RzdhnSn73xHin6gUZ1tJulbz9p7wZGXUqyJ9vfiXQ
	 EGUrUYeGmfIgc//SDC8v57JZgmBJ7ITyQnNK6zh5MULj/H2Ywy9gS7+DfTnDjromMS
	 yU/ol4DNWtAltdLIQzsn55C0rZO5MhB0w8rlOfYyBazcvYGj5YjXT829j9CysZ+zlF
	 Bd9GLsmf+as/SbcA6GfegSNZzFYJxQ9cFFJa9KuZPX/AS/KiUYQglNYjNa/wbUOYEF
	 hmpKxKbWNqsBKc/Bkv/cMson2IU5i0c6NhPe//1DahJ+HBRrVGSA3CT5dpUtFzFbtz
	 NbjpC5AP1okEA==
Date: Mon, 01 Jul 2024 20:06:38 +0000
To: Miguel Ojeda <ojeda@kernel.org>
From: =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 03/13] rust: allow `dead_code` for never constructed bindings
Message-ID: <dhqYZwDV26lEyH45RqwDnXjOODD6xEYXM_sG7vYK2VM2xhWILyi6voa0cS3PyKAseW29ZiIWEGOEwdQdhPxidg7eQgV74LmSgFm0N1yHRg8=@protonmail.com>
In-Reply-To: <20240701183625.665574-4-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org> <20240701183625.665574-4-ojeda@kernel.org>
Feedback-ID: 27884398:user:proton
X-Pm-Message-ID: 2c21c386f20e574f3d165c0dad0783ca192b2fc7
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Monday, July 1st, 2024 at 20:36, Miguel Ojeda <ojeda@kernel.org> wrote:

> Starting with the upcoming Rust 1.80.0 (since upstream commit 35130d7233e=
9
> ("Detect pub structs never constructed and unused associated constants
> in traits")), the `dead_code` pass detects more cases, which triggers
> in the `bindings` crate:
>=20
>     warning: struct `boot_params` is never constructed
>         --> rust/bindings/bindings_generated.rs:10684:12
>         |
>     10684 | pub struct boot_params {
>         |            ^^^^^^^^^^^
>         |
>         =3D note: `#[warn(dead_code)]` on by default
>=20
> As well as in the `uapi` one:
>=20
>     warning: struct `boot_params` is never constructed
>         --> rust/uapi/uapi_generated.rs:10392:12
>         |
>     10392 | pub struct boot_params {
>         |            ^^^^^^^^^^^
>         |
>         =3D note: `#[warn(dead_code)]` on by default
>=20
> These are all expected, since we do not use all the structs in the
> bindings that `bindgen` generates from the C headers.
>=20
> Therefore, allow them.
>=20
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Bj=C3=B6rn Roy Baron <bjorn3_gh@protonmail.com>

> ---
>  rust/bindings/lib.rs | 1 +
>  rust/uapi/lib.rs     | 1 +
>  2 files changed, 2 insertions(+)
>=20
> diff --git a/rust/bindings/lib.rs b/rust/bindings/lib.rs
> index 40ddaee50d8b..93a1a3fc97bc 100644
> --- a/rust/bindings/lib.rs
> +++ b/rust/bindings/lib.rs
> @@ -24,6 +24,7 @@
>      unsafe_op_in_unsafe_fn
>  )]
> =20
> +#[allow(dead_code)]
>  mod bindings_raw {
>      // Use glob import here to expose all helpers.
>      // Symbols defined within the module will take precedence to the glo=
b import.
> diff --git a/rust/uapi/lib.rs b/rust/uapi/lib.rs
> index 0caad902ba40..80a00260e3e7 100644
> --- a/rust/uapi/lib.rs
> +++ b/rust/uapi/lib.rs
> @@ -14,6 +14,7 @@
>  #![cfg_attr(test, allow(unsafe_op_in_unsafe_fn))]
>  #![allow(
>      clippy::all,
> +    dead_code,
>      missing_docs,
>      non_camel_case_types,
>      non_upper_case_globals,
> --=20
> 2.45.2
