Received: from gimli.kloenk.de (gimli.kloenk.de [49.12.72.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F43212B2C
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 13:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.72.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737551795; cv=none; b=RPk6V7kHqh4mGDxmcQqzT2cUbpzyv8qSgva/ypNonqmwvdyJZIZmfPG8aVbz7G/EU3+tVBQi2cUn7qXuAYufgZizDpTWxMt92YDXS/Q0uYUoGB6P2/86etuxQcG6NnAqg1O87S09f+ine5ep2smriHGMtGigdXdk67+4wWdPtS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737551795; c=relaxed/simple;
	bh=JbahiaYhyjDQQ6SJtM8xFQdt3S5Maf3AaeaUXSZCRjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uwp3BKgYMgpGRrhi4pW6PBBYp4fKzuOUnc3cRqENaJkm6pFDcZZHDzh2GebaEUcG7e3NdnWqnRSewItx1O2CVTnQIIiQD5i7C/eSiOlfssqDB6FZ2tID7/42EQgyuXgyrhpb89+K63hP3lp1k6OfHCYV2qDmVr+vfa7d6Xq03C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev; spf=pass smtp.mailfrom=kloenk.dev; dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b=d7iEzrOQ; arc=none smtp.client-ip=49.12.72.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b="d7iEzrOQ"
From: Fiona Behrens <me@kloenk.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.dev; s=mail;
	t=1737551789; bh=DUZUvW9JunMerFCzRdTj1ODqPJnTnSdCAg2yVMAOD1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d7iEzrOQ0Qd2+4lPSraNPiw5fxRPaxK/DtHzm8dQzmjPSzObSzxdC2troaknQqdPx
	 CkVnx+PIqB69sSnUhDdixUOFo+onyuwuapagnI16KmZL5EmIr/MROaOru970m6OvI+
	 ZxYgU1pA99zCLVZxFM0GaDYtebkY4z9d9mFNc5no=
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: init: use explicit ABI to clean warning in future
 compilers
Date: Wed, 22 Jan 2025 14:16:28 +0100
Message-ID: <0B29578D-2A15-4466-BC7B-B21484DD8DF4@kloenk.dev>
In-Reply-To: <20250121200934.222075-1-ojeda@kernel.org>
References: <20250121200934.222075-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain



On 21 Jan 2025, at 21:09, Miguel Ojeda wrote:

> Starting with Rust 1.86.0 (currently in nightly, to be released on
> 2025-04-03), the `missing_abi` lint is warn-by-default [1]:
>
>     error: extern declarations without an explicit ABI are deprecated
>         --> rust/doctests_kernel_generated.rs:3158:1
>          |
>     3158 | extern {
>          | ^^^^^^ help: explicitly specify the C ABI: `extern "C"`
>          |
>          = note: `-D missing-abi` implied by `-D warnings`
>          = help: to override `-D warnings` add `#[allow(missing_abi)]`
>
> Thus clean it up.
>
> Link: https://github.com/rust-lang/rust/pull/132397 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Fiona Behrens <me@kloenk.dev>

> ---
>  rust/kernel/init.rs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
> index 347049df556b..c962029f96e1 100644
> --- a/rust/kernel/init.rs
> +++ b/rust/kernel/init.rs
> @@ -854,7 +854,7 @@ pub unsafe trait PinInit<T: ?Sized, E = Infallible>: Sized {
>      /// use kernel::{types::Opaque, init::pin_init_from_closure};
>      /// #[repr(C)]
>      /// struct RawFoo([u8; 16]);
> -    /// extern {
> +    /// extern "C" {
>      ///     fn init_foo(_: *mut RawFoo);
>      /// }
>      ///
>
> base-commit: 100ceb4817a2ac650e29f107cf97161ce3e2289a
> -- 
> 2.48.1
