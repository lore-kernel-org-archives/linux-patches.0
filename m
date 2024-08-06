Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF99E2AF15;
	Tue,  6 Aug 2024 15:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722958759; cv=none; b=VFqsPhm8U7ir27OGdgMhPOECkExTF0iNuFAMMxkSEu88QGVB6PQGgHc/5QmCY3v4VAUqeGHQrD9mRiBxKZ6JNApINfHa9rWxiLB5/RolaRwGWkHP7CI6KlzxlNt4qHEVucWQtfMnfiFn/Wl07TDwuApcwFW6S0vhRm4zNa1X1RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722958759; c=relaxed/simple;
	bh=5nd5DARlqYi9S8WFs/uH2XgF+To9Gz9QRZw6fGL/v4Q=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZvFcEV6/SVuN2WQ9demYZvUQ2C1SVq/uLUZhtbfUfy8wYLlkzE42GoDsfZ16VpGAYLOfEp8rxfQY9uWdVYXy2HEHz5hN8BKYcDMMDF9iptcITBm+2MWg5nZYfUHrNkW61eVpNcWlhqgDrq8egAAYr6E9KJC7XdzpgkeK4fHk2+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=XpnSrAof; arc=none smtp.client-ip=185.70.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="XpnSrAof"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=vdqqsxdusrdernhqgiiuiln6r4.protonmail; t=1722958755; x=1723217955;
	bh=pEaB718Z2amEohXeI3H5khlenOy/VSpHtc6ghjrri88=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=XpnSrAof+zmTqGDJzz6CZvJwVD5UrNCLfj8iLEul/mzFAEK1jMctXgJivKQ8Ffvlc
	 jbzEFsuaqQSesl1G0ad6xhZNgPnBc/7mfP5tlRVv5OARnGgAiKNFg2N77zU1Bro0RD
	 aijXjYHXQtw6zQY44p361NZYYVzDTVUyQ9Tx5nrb7MDnQ5c5zoT/vMhx5Dq9QKaBmK
	 t/ihQqvxUXKwqKh+mlpFfB+MXpUB7EI0sg4cG5iPeWsVg2Ph4Con/LFd+gut/Fmcch
	 TGWjvCDXRmlJnjyEHsTEpfih573blEGf0I4Y3DsimXBNMEC9+KqGSE6G7rr4AB3hxT
	 BIcTg9mMcz7wg==
Date: Tue, 06 Aug 2024 15:00:14 +0000
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Nathan Chancellor <nathan@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
From: Benno Lossin <benno.lossin@proton.me>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Nikita Popov <github@npopov.com>
Subject: Re: [PATCH] rust: x86: remove `-3dnow{,a}` from target features
Message-ID: <b7fc013a-297c-4df7-b7bb-e0a8d520d822@proton.me>
In-Reply-To: <20240806144558.114461-1-ojeda@kernel.org>
References: <20240806144558.114461-1-ojeda@kernel.org>
Feedback-ID: 71780778:user:proton
X-Pm-Message-ID: ec7f728f60548262dda571f95f6e3fdd0e8b00cb
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 06.08.24 16:45, Miguel Ojeda wrote:
> LLVM 19 is dropping support for 3DNow! in commit f0eb5587ceeb ("Remove
> support for 3DNow!, both intrinsics and builtins. (#96246)"):
>=20
>     Remove support for 3DNow!, both intrinsics and builtins. (#96246)
>=20
>     This set of instructions was only supported by AMD chips starting in
>     the K6-2 (introduced 1998), and before the "Bulldozer" family
>     (2011). They were never much used, as they were effectively supersede=
d
>     by the more-widely-implemented SSE (first implemented on the AMD side
>     in Athlon XP in 2001).
>=20
>     This is being done as a predecessor towards general removal of MMX
>     register usage. Since there is almost no usage of the 3DNow!
>     intrinsics, and no modern hardware even implements them, simple
>     removal seems like the best option.
>=20
> Thus we should avoid passing these to the backend, since otherwise we
> get a diagnostic about it:
>=20
>     '-3dnow' is not a recognized feature for this target (ignoring featur=
e)
>     '-3dnowa' is not a recognized feature for this target (ignoring featu=
re)
>=20
> We could try to disable them only up to LLVM 19 (not the C side one,
> but the one used by `rustc`, which may be built with a range of
> LLVMs). However, to avoid more complexity, we can likely just remove
> them altogether. According to Nikita [2]:
>=20
>> I don't think it's needed because LLVM should not generate 3dnow
> instructions unless specifically asked to, using intrinsics that Rust
> does not provide in the first place.
>=20
> Thus do so, like Rust did for one of their builtin targets [3].
>=20
> For those curious: Clang will warn only about trying to enable them
> (`-m3dnow{,a}`), but not about disabling them (`-mno-3dnow{,a}`), so
> there is no change needed there.
>=20
> Cc: Nikita Popov <github@npopov.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: x86@kernel.org
> Link: https://github.com/llvm/llvm-project/commit/f0eb5587ceeb641445b64cb=
264c822b4751de04a [1]
> Link: https://github.com/rust-lang/rust/pull/127864#issuecomment-22358987=
60 [2]
> Link: https://github.com/rust-lang/rust/pull/127864 [3]
> Closes: https://github.com/Rust-for-Linux/linux/issues/1094
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  scripts/generate_rust_target.rs | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Works on my machine:

Tested-by: Benno Lossin <benno.lossin@proton.me>

---
Cheers,
Benno

> diff --git a/scripts/generate_rust_target.rs b/scripts/generate_rust_targ=
et.rs
> index 87f34925eb7b..404edf7587e0 100644
> --- a/scripts/generate_rust_target.rs
> +++ b/scripts/generate_rust_target.rs
> @@ -162,7 +162,7 @@ fn main() {
>              "data-layout",
>              "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:=
128-n8:16:32:64-S128",
>          );
> -        let mut features =3D "-3dnow,-3dnowa,-mmx,+soft-float".to_string=
();
> +        let mut features =3D "-mmx,+soft-float".to_string();
>          if cfg.has("MITIGATION_RETPOLINE") {
>              features +=3D ",+retpoline-external-thunk";
>          }
> @@ -179,7 +179,7 @@ fn main() {
>              "data-layout",
>              "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64=
:32:64-f80:32-n8:16:32-S128",
>          );
> -        let mut features =3D "-3dnow,-3dnowa,-mmx,+soft-float".to_string=
();
> +        let mut features =3D "-mmx,+soft-float".to_string();
>          if cfg.has("MITIGATION_RETPOLINE") {
>              features +=3D ",+retpoline-external-thunk";
>          }
>=20
> base-commit: de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed
> --
> 2.46.0
>=20

