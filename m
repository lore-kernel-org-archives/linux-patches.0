Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7A61581EE
	for <patches@lists.linux.dev>; Thu, 27 Mar 2025 22:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743113614; cv=none; b=elc5tRKFV0fRWURTlzLzZOCKmFroBoZHkOBIpLqabrca1SdyQJFDNziDW2NXbD0AZ/jQ66/Z1PwkGmYHvQO/NS8nnCZMqrJ+k5y+wpE1U67flL7twqXR515+242KPeJQoBY0FajQTLreBaXelEOj7MXjQX6KkBFxG8D31wx7R20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743113614; c=relaxed/simple;
	bh=TYGJ8FnfsKT1SKjoZWBosa8mBZ3KjzthRNE8P8nvecE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bIAah5K23301+d+d087IX0jf8Aiv8RZT41PyVh8I8os6E13zRcGTZ2TB4WwqZDp1AQEgn0ppAKnoxy1Fur2rDLDkdUCUBkAVveYVtHzlTNUM53J5Ocr57mL+jrTNyAveKDyo8GxCx09l6o4uG5zofcjgDDlRQx1cWpTnltb9hu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=RfneHWSi; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="RfneHWSi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=rq2gsk3pfvay7fg5nyq3ghjsg4.protonmail; t=1743113609; x=1743372809;
	bh=Vrk6CcpdVcblD8Yoi4uM8XudDIG9EgjbDWgg5W2/PO0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=RfneHWSiAyNxultd7Fssx0bbLRtJdVbBqsZJz5oD6qD2GsbQ4/36TWrpLy7lg+DmF
	 vnlER0HAcssPgET0HTb9yNDxki7tEztPSH0C8H67N0XPwy+gZ5WPbq2qCtQ1eENQPU
	 kOnGYplP6tb3H4rtk29pwmRMCS+7s+FUcGx5PhMAr0lDOuWfLKDneKOrlEvWAFlLOD
	 ZKXQkFuKl2U1Wg5B2xRsUOnmUFtHUGK38R/UbIZATR7RBxqKrAlbLOCJHbYXGQN5dv
	 GPE9uqewuMZymcnHSm0Xzu1EsICI8eYZMERYJRwmRIsRkK/LbcTptqGpefovzTB26o
	 BEe/cCRP+vMxA==
Date: Thu, 27 Mar 2025 22:13:22 +0000
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: clarify the language unstable features in use
Message-ID: <D8RE79BLHK7K.1ZM2N5RBYGUY8@proton.me>
In-Reply-To: <20250327211302.286313-1-ojeda@kernel.org>
References: <20250327211302.286313-1-ojeda@kernel.org>
Feedback-ID: 71780778:user:proton
X-Pm-Message-ID: 57039260adb80c49be970e0c87108b8ac94d43c1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu Mar 27, 2025 at 10:13 PM CET, Miguel Ojeda wrote:
> We track the details of which Rust features we use at our usual "live
> list" [1] (and its sub-lists), but in light of a discussion in the LWN
> article [2], it would help to clarify it in the source code.
>
> In particular, we are very close to rely only on stable Rust language-wis=
e
> -- essentially only two language features remain (including the `kernel`
> crate).
>
> Thus add some details in both the feature list of the `kernel` crate as
> well as the list of allowed features.
>
> This does not over every single feature, and there are quite a few
> non-language features that we use too. To have the full picture, please
> refer to [1].
>
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [1]
> Link: https://lwn.net/Articles/1015409/ [2]
> Suggested-by: Andreas Hindborg <a.hindborg@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

LGTM, so:

Reviewed-by: Benno Lossin <benno.lossin@proton.me>

And left two suggestions below.

> ---
>  rust/kernel/lib.rs     | 27 ++++++++++++++++++++-------
>  scripts/Makefile.build |  8 ++++++++
>  2 files changed, 28 insertions(+), 7 deletions(-)
>
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index ba0f3b0297b2..660a3ab6f9d4 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -12,21 +12,34 @@
>  //! do so first instead of bypassing this crate.
> =20
>  #![no_std]
> -#![feature(arbitrary_self_types)]
> -#![cfg_attr(CONFIG_RUSTC_HAS_COERCE_POINTEE, feature(derive_coerce_point=
ee))]
> -#![cfg_attr(not(CONFIG_RUSTC_HAS_COERCE_POINTEE), feature(coerce_unsized=
))]
> -#![cfg_attr(not(CONFIG_RUSTC_HAS_COERCE_POINTEE), feature(dispatch_from_=
dyn))]
> -#![cfg_attr(not(CONFIG_RUSTC_HAS_COERCE_POINTEE), feature(unsize))]
> +
> +// Please see https://github.com/Rust-for-Linux/linux/issues/2 for detai=
ls on
> +// the unstable features in use.
> +
> +// Stable since Rust 1.79.0.
>  #![feature(inline_const)]
> +
> +// Stable since Rust 1.81.0.
>  #![feature(lint_reasons)]
> -// Stable in Rust 1.82
> +
> +// Stable since Rust 1.82.0.
>  #![feature(raw_ref_op)]
> -// Stable in Rust 1.83
> +
> +// Stable since Rust 1.83.0.
>  #![feature(const_maybe_uninit_as_mut_ptr)]
>  #![feature(const_mut_refs)]
>  #![feature(const_ptr_write)]
>  #![feature(const_refs_to_cell)]
> =20
> +// Expected to become stable.
> +#![feature(arbitrary_self_types)]
> +
> +// `feature(derive_coerce_pointee)` is the one expected to become stable=
.
> +#![cfg_attr(CONFIG_RUSTC_HAS_COERCE_POINTEE, feature(derive_coerce_point=
ee))]
> +#![cfg_attr(not(CONFIG_RUSTC_HAS_COERCE_POINTEE), feature(coerce_unsized=
))]
> +#![cfg_attr(not(CONFIG_RUSTC_HAS_COERCE_POINTEE), feature(dispatch_from_=
dyn))]
> +#![cfg_attr(not(CONFIG_RUSTC_HAS_COERCE_POINTEE), feature(unsize))]

Does it make sense to add another comment in front of these three along
the lines of:

    // Before Rust 1.82.0 `feature(derive_coerce_pointee)` doesn't exist, s=
o enable the predecessor
    // features.

> +
>  // Ensure conditional compilation based on the kernel configuration work=
s;
>  // otherwise we may silently break things like initcall handling.
>  #[cfg(not(CONFIG_RUST))]
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 56be83024851..41a640990cfa 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -226,6 +226,14 @@ $(obj)/%.lst: $(obj)/%.c FORCE
>  # Compile Rust sources (.rs)
>  # ----------------------------------------------------------------------=
-----
> =20
> +# The features in this list are the ones allowed for non-`rust/` code.
> +#
> +#   - Stable since Rust 1.81.0: `feature(lint_reasons)`.
> +#   - Stable since Rust 1.82.0: `feature(asm_const)`, `feature(raw_ref_o=
p)`.
> +#   - Stable since Rust 1.87.0: `feature(asm_goto)`.

Probably a good idea to add:

    #   - Expected to become stable: `arbitrary_self_types`.

---
Cheers,
Benno

> +#
> +# Please see https://github.com/Rust-for-Linux/linux/issues/2 for detail=
s on
> +# the unstable features in use.
>  rust_allowed_features :=3D asm_const,asm_goto,arbitrary_self_types,lint_=
reasons,raw_ref_op
> =20
>  # `--out-dir` is required to avoid temporaries being created by `rustc` =
in the
>
> base-commit: e6ea10d5dbe082c54add289b44f08c9fcfe658af


