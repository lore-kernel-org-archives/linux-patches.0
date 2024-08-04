Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99B721350;
	Sun,  4 Aug 2024 17:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722794112; cv=none; b=a8mzMTtHiGKqkC1B7wcHTKjhcRPfY1krdhtKmGIcjy+cDUZMxu/dD14DRbGjRcRTUNYcUMjqvhpr+u5oshEYmAUOylyS+DFDoroeDT/c0hMGaH5sOa21cvtHAsGwhKoKWD10ZCwSt0P9PY8F+S8WhAG7lZvAx/JWSz8a2Cy8owk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722794112; c=relaxed/simple;
	bh=RL3DqmXaOjPc9EgbTdT9LfpsICVqt3KILOs2N4vf9Kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jlAcH4Ib5GC/j8MQcNCQE/el9DU7hT3wMIu7eDg/Qfe8k4xBd09WDRZ3m4kvkS0/VulZHb7oGsv9uLApu1T5aK2iZ96YFviVpKCqV1TH/PlOgVsoiKWFJ8lPxWozBeuwvkpYzkk35mNxoGRmN0H/b8oPm65vzykJPJIHdJ3rwqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jc0xMbMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jc0xMbMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0640C32786;
	Sun,  4 Aug 2024 17:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722794112;
	bh=RL3DqmXaOjPc9EgbTdT9LfpsICVqt3KILOs2N4vf9Kk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jc0xMbMOgwl1BOmFX7EEj/FiXNpCis720MJSm/hH5lIOw2qjygeTHgDM2dTpm/OVu
	 81mQDTwMR5s8+pcqjzbf5Ud/om9b5+MvVIbISriGWFAuzJKIrlZZ+XOYR4xEr+o/8J
	 F5mHJd4fKjwxZTuPweCiCYaJYBs43sTcNNwmE7wf4VwgyPflCJItrYYVVVNkFikQZ2
	 8RWOBNCqKZFUQ6G7RJp3HJILdRIV+2HasrdDhzTKihH6J/lFjSG+GdKHiLCoFMt6o+
	 iD2LgVjrJOCvBdQB5yC+d4dbGYTKPoSN3MDtf1tqJm5pV4z12rxXOwcb6nutcYgK0x
	 bxlX6Dlo+Q/ng==
Date: Sun, 4 Aug 2024 10:55:10 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 2/5] Compiler Attributes: remove unneeded version
 comments for older LLVMs
Message-ID: <20240804175510.GB2627063@thelio-3990X>
References: <20240803171933.483316-1-ojeda@kernel.org>
 <20240803171933.483316-2-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240803171933.483316-2-ojeda@kernel.org>

On Sat, Aug 03, 2024 at 07:19:30PM +0200, Miguel Ojeda wrote:
> The kernel upgraded to support only LLVM >= 13 in commit 9c1b86f8ce04
> ("kbuild: raise the minimum supported version of LLVM to 13.0.1"),
> thus remove version comments that are not needed anymore.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Whoops :)

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  include/linux/compiler_attributes.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
> index b658136e6cda..5d171a7f8cbd 100644
> --- a/include/linux/compiler_attributes.h
> +++ b/include/linux/compiler_attributes.h
> @@ -256,7 +256,7 @@
>  #endif
>  
>  /*
> - * Optional: only supported since GCC >= 7.1, clang >= 13.0.
> + * Optional: only supported since GCC >= 7.1
>   *
>   *      gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fprofile_005finstrument_005ffunction-function-attribute
>   *    clang: https://clang.llvm.org/docs/AttributeReference.html#no-profile-instrument-function
> @@ -275,7 +275,7 @@
>  #define __noreturn                      __attribute__((__noreturn__))
>  
>  /*
> - * Optional: only supported since GCC >= 11.1, clang >= 7.0.
> + * Optional: only supported since GCC >= 11.1
>   *
>   *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fstack_005fprotector-function-attribute
>   *   clang: https://clang.llvm.org/docs/AttributeReference.html#no-stack-protector-safebuffers
> -- 
> 2.46.0
> 
> 
