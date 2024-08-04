Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEF92FB6;
	Sun,  4 Aug 2024 18:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722794621; cv=none; b=JtdYWhg2LNo9o7iaeHWQcsebCGM5toL+NI3M0f4oH3Mf5BhcTSrH0h0MA9+4PXRJ6xuOUht6Xz7ELRIRfmg8f+79iDTr8KHiCU/T++e8pJxsgNumrjy6cYTJMQ+i3X96zLyiGGUJHS5lJ1ku+MeYqdBa/sJT5no9tT3HxHT4N/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722794621; c=relaxed/simple;
	bh=nijxQpzlXD+TZVfdf9WwxE+H/vBFAOp8EY+ZFY4eRe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DNDBP+kuE7FrDD7zFQrbrYmgb1tOv+KR4R9s5fEMpDrNyNzW+RilVSKDpOIqHJtk9Uq2xuuTG1On+Wy3qDzRhi17eeunFYwdVdaJVeH+iiifC5OlPWUg+LuKdNheu6Ubm5pXL25bCKyMUfFmgE4EWh94ubjFMy0qJaMrSWBibLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgGijlPY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgGijlPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7BFC32786;
	Sun,  4 Aug 2024 18:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722794620;
	bh=nijxQpzlXD+TZVfdf9WwxE+H/vBFAOp8EY+ZFY4eRe8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XgGijlPYGkQidVVpiHH4P8o7M80HPSvFREvx1CNiFkVqR2ka6TQ4xzn6JE0p9cOuY
	 qWG24H2ngE+N+LQZRZd7gr0RjTeGw+T6HHy6fgsSQhzayTb6BaeVdfzki3vAVz4FOo
	 HYr3cMbSj6biTAvDp9gIC234ZOuP3wBNME6SpJeekjkeB27e8IDrbkHqrQ7QHD41yj
	 58PL78ylFlno8KELs6ezfASJheSQ7IdS0cUp3SIk5rk8Vi+VvaVI0daMQt8epf10DZ
	 Nl0NZgtQIeK6dGDj8HfKamZWnG/zUbhWrTifgaMoVMQccrcDSK9tmcRJQWyR7guD1Q
	 pxX2IeEb0uR7Q==
Date: Sun, 4 Aug 2024 11:03:38 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 4/5] Compiler Attributes: fix formatting of GCC/Clang doc
 links
Message-ID: <20240804180338.GD2627063@thelio-3990X>
References: <20240803171933.483316-1-ojeda@kernel.org>
 <20240803171933.483316-4-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240803171933.483316-4-ojeda@kernel.org>

On Sat, Aug 03, 2024 at 07:19:32PM +0200, Miguel Ojeda wrote:
> Over time, some links have been added that did not follow the formatting
> of the rest. Fix it for consistency.
> 
> No non-whitespace changes intended.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

It might be worth calling out the expected format (aligned on the colon)
since I was initially confused until I looked a little harder :)

> ---
>  include/linux/compiler_attributes.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
> index 2d1ad2a74a4e..a6e8c9406f7a 100644
> --- a/include/linux/compiler_attributes.h
> +++ b/include/linux/compiler_attributes.h
> @@ -226,7 +226,7 @@
>   *   goto <label>;
>   *   return [expression];
>   *
> - *  gcc: https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html#Statement-Attributes
> + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html#Statement-Attributes
>   * clang: https://clang.llvm.org/docs/AttributeReference.html#fallthrough
>   */
>  #if __has_attribute(__fallthrough__)
> @@ -236,7 +236,7 @@
>  #endif
>  
>  /*
> - * gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#Common-Function-Attributes
> + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#Common-Function-Attributes
>   * clang: https://clang.llvm.org/docs/AttributeReference.html#flatten
>   */
>  # define __flatten			__attribute__((flatten))
> @@ -264,8 +264,8 @@
>  /*
>   * Optional: only supported since GCC >= 7.1
>   *
> - *      gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fprofile_005finstrument_005ffunction-function-attribute
> - *    clang: https://clang.llvm.org/docs/AttributeReference.html#no-profile-instrument-function
> + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fprofile_005finstrument_005ffunction-function-attribute
> + * clang: https://clang.llvm.org/docs/AttributeReference.html#no-profile-instrument-function
>   */
>  #if __has_attribute(__no_profile_instrument_function__)
>  # define __no_profile                  __attribute__((__no_profile_instrument_function__))
> @@ -283,7 +283,7 @@
>   * Optional: only supported since GCC >= 11.1
>   *
>   *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fstack_005fprotector-function-attribute
> - *   clang: https://clang.llvm.org/docs/AttributeReference.html#no-stack-protector-safebuffers
> + * clang: https://clang.llvm.org/docs/AttributeReference.html#no-stack-protector-safebuffers
>   */
>  #if __has_attribute(__no_stack_protector__)
>  # define __no_stack_protector		__attribute__((__no_stack_protector__))
> -- 
> 2.46.0
> 
