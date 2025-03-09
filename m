Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E065C158A13;
	Sun,  9 Mar 2025 21:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741554161; cv=none; b=DfRtyQ2wux2Xq5r0/jQLWbz8pPsnMe9JJf/CxAIcnRRqNPUZzW8IkAUMBE8MSqdx6ITtyuo7gG42tAUQ6uAh+o3Tkzkm8+Ifp6RW/n7E1PgJyqMU89KIy43bgiySlVwkNCIVAsdKlPvoswY/cMyY5GjFF/Uigcp1p4LEyczhHzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741554161; c=relaxed/simple;
	bh=Ic1WIKJ0UVZZzgfiMRYykl3vQLtQ/asCIjh48uwldc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ux9TA1cqS93nK408XP6CK0swxoYwjRT+C2IrOuyAG/SDAhVwmsxKJkx5pbBWtxvn3O96tc7+KRp/XWeFQU6hpi7adhZ0NSxzcXXT8cmDqSCnKh0SwTQRrPq0hNYH8gyhYjcehKqLatqC3Q8fBeHlnMjOnPJiLoIQIA0yvNLBaH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCPSi2WT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCPSi2WT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0C5C4CEE3;
	Sun,  9 Mar 2025 21:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741554160;
	bh=Ic1WIKJ0UVZZzgfiMRYykl3vQLtQ/asCIjh48uwldc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JCPSi2WTrCZwPcSspU5STrITzLjhP9j23DKZmljdG+lYUYgAsvN4C289QHU/2Ig/y
	 4/M9M/3hKCITjSj5P8EgTVVK+ECCByWNDcHlapAv2ccHMczp5aSS17HUsY9plQUp7z
	 Ma0uOj6auT98n4gJBSXlo3hDa9Dr0Xby6TQYENBw=
Date: Sun, 9 Mar 2025 22:02:37 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev
Subject: Re: [PATCH 6.12.y 0/2] The two missing ones
Message-ID: <2025030931-fantasize-bats-d2b5@gregkh>
References: <2025030955-kindness-designing-246c@gregkh>
 <20250309204217.1553389-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250309204217.1553389-1-ojeda@kernel.org>

On Sun, Mar 09, 2025 at 09:42:15PM +0100, Miguel Ojeda wrote:
> Two missing ones on top of the other 60 -- sorry again! I tested the end result
> of applying the 62 on top of v6.12.18 with all combinations of:
> 
>   - The minimum and maximum Rust compiler versions (i.e. 1.78.0 and 1.85.0).
> 
>   - x86_64, arm64, riscv64 and loongarch64 (this last one with the other
>     unrelated-to-Rust fix on top).
> 
>   - A defconfig with Rust users enabled (rust_minimal, rust_print, rnull,
>     drm_panic_qr, qt2025, ax88796b_rust) plus a similar with a couple debug
>     options on top (Rust debug assertions and KUnit Rust doctests).
> 
> All pass my usual tests, are `WERROR=y` and Clippy-clean etc.
> 
> Plus x86_64 out-of-tree build, a x86_64 subdir build and a x86_64 Rust disabled
> build. On x86_64, it should still build commit-by-commit.
> 
> Cheers,
> Miguel
> 
> Gary Guo (1):
>   rust: map `long` to `isize` and `char` to `u8`
> 
> Miguel Ojeda (1):
>   rust: finish using custom FFI integer types
> 
>  drivers/gpu/drm/drm_panic_qr.rs |  2 +-
>  rust/ffi.rs                     | 37 ++++++++++++++++++++++++++++++++-
>  rust/kernel/error.rs            |  5 +----
>  rust/kernel/firmware.rs         |  2 +-
>  rust/kernel/uaccess.rs          | 27 +++++++-----------------
>  5 files changed, 46 insertions(+), 27 deletions(-)
> 
> --
> 2.48.1
> 

Now queued up, thanks.

greg k-h
