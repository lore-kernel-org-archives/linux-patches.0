Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EF379C2;
	Sun,  4 Aug 2024 17:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722794086; cv=none; b=t1QnXRxHUlALMF3Chg+UIz8J7qdlAsFA7FbfDF4CUgGUGN60IlP0EFptywXFcnGs67KgUQ/VCCr+BQNumA4/N2tgIRWMxO5M1MJx1HDP/UhRprQUWt52nS/yABxrnNOULXsXWgE+a7Ez0SnWf16Sjj6FkKShzktu+5qQTszww5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722794086; c=relaxed/simple;
	bh=CiZr9g0FV8fPACr6xthb7JjGo6m95xlIky84HIGH0NE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J/6E0HIFPAqGhN/6k2CjorRwajR6HQWZdJlThvIqXNOPeJP3KgmCOU41W3TBICDrXsyUKeio9Uj0tODgODxxNHcb8V5/k7nI5lFSV1OD+Ad8jjMsWmZcAokYV8dFqWTVW3ge6hbjBF/ts512Vm/yZX4w9m/GdvT7Iq9enmSq30k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rlRkwqE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rlRkwqE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4678AC32786;
	Sun,  4 Aug 2024 17:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722794085;
	bh=CiZr9g0FV8fPACr6xthb7JjGo6m95xlIky84HIGH0NE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rlRkwqE9XJor4TjmfM8E5NuhU5zMgaEKFsoFYuA52Y27VVChXATSX4jYYyx0p5Zdg
	 4glpsGU9A/W0pGGvRfhztSYi1M3jhBPptB+os8gDA5SByQs9n5YZNiFsHztHjYr1kT
	 udmDb9eujXaL88YzoQc2D8rxn+ldYRvUFjowMl0GxSFq/mq4/yjagzNrhYuFOtywZx
	 JrZ4OWGQvtfcqnSVv1wdJ4ZaIkX8mU8VhV3TMd33S22hS/ZHAud50DP7lh1C5V7385
	 xGiRQvbaXqCAlwOqKzWhSg7VcZIaaxzbx/zI6673egnziRTiFEcblUAAoNX5RtUUvC
	 N3x382hZeysLA==
Date: Sun, 4 Aug 2024 10:54:43 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 1/5] Compiler Attributes: update GCC and Clang's
 `counted_by` URLs
Message-ID: <20240804175443.GA2627063@thelio-3990X>
References: <20240803171933.483316-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240803171933.483316-1-ojeda@kernel.org>

On Sat, Aug 03, 2024 at 07:19:29PM +0200, Miguel Ojeda wrote:
> Clang 18 was released with support for `counted_by`, thus point to the
> documentation now instead of the implementation PR.
> 
> Similarly, GCC's bugzilla issue is now closed and GCC has a documentation
> page for it.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  include/linux/compiler_attributes.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
> index 32284cd26d52..b658136e6cda 100644
> --- a/include/linux/compiler_attributes.h
> +++ b/include/linux/compiler_attributes.h
> @@ -98,8 +98,8 @@
>   * Optional: only supported since gcc >= 15
>   * Optional: only supported since clang >= 18
>   *
> - *   gcc: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
> - * clang: https://github.com/llvm/llvm-project/pull/76348
> + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-counted_005fby-variable-attribute
> + * clang: https://clang.llvm.org/docs/AttributeReference.html#counted-by
>   */
>  #if __has_attribute(__counted_by__)
>  # define __counted_by(member)		__attribute__((__counted_by__(member)))
> 
> base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
> -- 
> 2.46.0
> 
