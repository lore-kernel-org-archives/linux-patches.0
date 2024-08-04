Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDAB79C2;
	Sun,  4 Aug 2024 18:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722794689; cv=none; b=FZCtwPDFXG0zqMM9YOPgCj3IIb64Z7D1zN0Qd3tvzQVMEDG1kjVptlfdcnyJCBbgdFDtY2VsGBxZ8NKeyCRbyrQJktj+SCiCJeTCb3ZaYaFnus/oJx+b9RZj+2hTvbctNYaatjdnC4pb1Q++GF89k924HfqSPFlsoN+85E3pQ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722794689; c=relaxed/simple;
	bh=elODJ8vsHIYapmcSvAT74UzNVi3bbdW6jjOI53xPYzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NO4qZwCu725oM5sB9ztfgCvQlKQ9+PyBMyKx4H6phJByk61IgvsrH1TCuot4Ae9N43xNZ3dvdx7eg5fnPMgqMU+gFdbkuSs4SsYw1Z6R7Or56RFnsnjWP+cr9A2uwpTWZ/T7tJGLIyGDXVTvc33i1OvN+9pGqIU5SNeLvhg28jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uayii9cy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uayii9cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99DDC32786;
	Sun,  4 Aug 2024 18:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722794689;
	bh=elODJ8vsHIYapmcSvAT74UzNVi3bbdW6jjOI53xPYzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uayii9cyBM5g6VF/mW2LFN1qi96/mVdyjGbPb/iClXe7g4KJsRy4tS8BuMvi+xcM3
	 OKM/FOskw6UYwU8LEF2L0PJpP9GgiUlbZEM6KaFvoLFqr1q9rGPko5/1Fig4YYbP8U
	 /lFOYxu6CUSHV9Ee8Qr/nzzF7SqSuk2cPAAEi2vCnlnmTi3Sg2NjVEyU3+YSVO9zcC
	 5xzp2ttlLEWuYjJEbYi4cTACqTuTEJeQ9RHqiby4aMs2CGHOJLZim4wItv1Y5NaEFL
	 4R/wTBz5fLahj/N5Lq19n37F34i/tUaHiqmdzY26v6ZMzKVQbqvSRGYhVg5ef0hT2r
	 Aj2qF26YbhDjQ==
Date: Sun, 4 Aug 2024 11:04:47 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 5/5] Compiler Attributes: make version constraints more
 consistent
Message-ID: <20240804180447.GE2627063@thelio-3990X>
References: <20240803171933.483316-1-ojeda@kernel.org>
 <20240803171933.483316-5-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240803171933.483316-5-ojeda@kernel.org>

On Sat, Aug 03, 2024 at 07:19:33PM +0200, Miguel Ojeda wrote:
> Over time, some version constraints have been added that did not follow
> the formatting of the rest. Fix it for consistency.
> 
> Some of the version requirements can be simplified, too.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Yeah, I think just having the major version is reasonable, especially
since Clang has moved to GCC's version scheme of x.0 for main, x.1 for
release.

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  include/linux/compiler_attributes.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
> index a6e8c9406f7a..908e59e261c0 100644
> --- a/include/linux/compiler_attributes.h
> +++ b/include/linux/compiler_attributes.h
> @@ -112,7 +112,7 @@
>  
>  /*
>   * Optional: not supported by gcc
> - * Optional: only supported since clang >= 14.0
> + * Optional: only supported since clang >= 14
>   *
>   * clang: https://clang.llvm.org/docs/AttributeReference.html#diagnose_as_builtin
>   */
> @@ -146,7 +146,7 @@
>  #endif
>  
>  /*
> - * Optional: only supported since clang >= 14.0
> + * Optional: only supported since clang >= 14
>   *
>   *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-error-function-attribute
>   * clang: https://clang.llvm.org/docs/AttributeReference.html#error-warning
> @@ -262,7 +262,7 @@
>  #endif
>  
>  /*
> - * Optional: only supported since GCC >= 7.1
> + * Optional: only supported since gcc >= 7
>   *
>   *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fprofile_005finstrument_005ffunction-function-attribute
>   * clang: https://clang.llvm.org/docs/AttributeReference.html#no-profile-instrument-function
> @@ -280,7 +280,7 @@
>  #define __noreturn                      __attribute__((__noreturn__))
>  
>  /*
> - * Optional: only supported since GCC >= 11.1
> + * Optional: only supported since gcc >= 11
>   *
>   *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fstack_005fprotector-function-attribute
>   * clang: https://clang.llvm.org/docs/AttributeReference.html#no-stack-protector-safebuffers
> @@ -388,7 +388,7 @@
>  #define __must_check                    __attribute__((__warn_unused_result__))
>  
>  /*
> - * Optional: only supported since clang >= 14.0
> + * Optional: only supported since clang >= 14
>   *
>   *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-warning-function-attribute
>   * clang: https://clang.llvm.org/docs/AttributeReference.html#error-warning
> @@ -400,7 +400,7 @@
>  #endif
>  
>  /*
> - * Optional: only supported since clang >= 14.0
> + * Optional: only supported since clang >= 14
>   *
>   * clang: https://clang.llvm.org/docs/AttributeReference.html#disable-sanitizer-instrumentation
>   *
> -- 
> 2.46.0
> 
