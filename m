Received: from hop.stappers.nl (hop.stappers.nl [141.105.120.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B0C156250
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 05:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.105.120.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725513654; cv=none; b=VlzzDHDPYkkGBY6oDTJD78339LXHu6MmQszyhQzps596IS1M1zkNWkuGJcsAIT4lkBLBUnM8pGAqzTr17J5yzI7/IwhYdfU2ZT8ZaXooDwAnUSwa4BlsbX1I80xlMxObr0hgwwQMh3DMWohWY+IyuskJBDffVgOOINFdfcqJGCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725513654; c=relaxed/simple;
	bh=EQcwm/zllP/nW9uFHAheM3MtUpsUsgD5LooMLUJVB9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SvX2T59XgdbRRcJfK+B+ACctKX7YUXaIZKgXHQV1x11kmg+802ZlU0YRFrwiBRU8XOm0BsY4XGZ43du1EnehSwSxHCcuMFk9nYrx3z7aVpZcH+z/wujjubcJMOiEbIGMnZhhM6d3MgEzzsLDTNsK0VWZs97x4RqBa0mR+1Skr2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stappers.nl; spf=pass smtp.mailfrom=stappers.nl; arc=none smtp.client-ip=141.105.120.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stappers.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stappers.nl
Received: from gpm.stappers.nl (gpm.stappers.nl [82.168.249.201])
	by hop.stappers.nl (Postfix) with ESMTP id 4401B20203;
	Thu,  5 Sep 2024 05:20:48 +0000 (UTC)
Received: by gpm.stappers.nl (Postfix, from userid 1000)
	id 68C8C30417C; Thu,  5 Sep 2024 07:20:47 +0200 (CEST)
Date: Thu, 5 Sep 2024 07:20:46 +0200
From: Geert Stappers <stappers@stappers.nl>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 12/19] rust: replace `clippy::dbg_macro` with
 `disallowed_macros`
Message-ID: <Ztk/rn+wztXYVTtd@gpm.stappers.nl>
References: <20240904204347.168520-1-ojeda@kernel.org>
 <20240904204347.168520-13-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904204347.168520-13-ojeda@kernel.org>

On Wed, Sep 04, 2024 at 10:43:40PM +0200, Miguel Ojeda wrote:
> diff --git a/.clippy.toml b/.clippy.toml
> index f66554cd5c45..ad9f804fb677 100644
> --- a/.clippy.toml
> +++ b/.clippy.toml
> @@ -1 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
> +
> +disallowed-macros = [
> +    # The `clippy::dbg_macro` lint only works with `std::dbg!`, thus we simulate
> +    # it here, see: https://github.com/rust-lang/rust-clippy/issues/11303.
> +    { path = "kernel::dbg", reason = "the `dbg!` macro is intended as a debugging tool" },
> +]
> diff --git a/rust/kernel/std_vendor.rs b/rust/kernel/std_vendor.rs
> index 67bf9d37ddb5..085b23312c65 100644
> --- a/rust/kernel/std_vendor.rs
> +++ b/rust/kernel/std_vendor.rs
> @@ -14,7 +14,7 @@
> -/// # #[allow(clippy::dbg_macro)]
> +/// # #[allow(clippy::disallowed_macros)]
> @@ -52,7 +52,7 @@
> -/// # #[allow(clippy::dbg_macro)]
> +/// # #[allow(clippy::disallowed_macros)]
> @@ -71,7 +71,7 @@
> -/// # #[allow(clippy::dbg_macro)]
> +/// # #[allow(clippy::disallowed_macros)]
> @@ -118,7 +118,7 @@
>  /// a tuple (and return it, too):
>  ///
>  /// ```
> -/// # #[allow(clippy::dbg_macro)]
> +/// # #![allow(clippy::disallowed_macros)]
>  /// assert_eq!(dbg!(1usize, 2u32), (1, 2));
>  /// ```
>  ///

For what it is worth, the exclamation mark did surprise me.


> @@ -127,7 +127,7 @@
>  ///
>  /// ```
> -/// # #[allow(clippy::dbg_macro)]
> +/// # #[allow(clippy::disallowed_macros)]
>  /// # {
>  /// assert_eq!(1, dbg!(1u32,)); // trailing comma ignored
>  /// assert_eq!((1,), dbg!((1u32,))); // 1-tuple


Groeten
Geert Stappers
-- 
Silence is hard to parse
