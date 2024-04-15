Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1AA83BBF0
	for <patches@lists.linux.dev>; Mon, 15 Apr 2024 10:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.175.24.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713176085; cv=none; b=sZ/JY1IbqGDjuW2tBVuv/ZbLN2kYYJQMG0CT1i43Fjb9z6xwEt6pJ7vaU9BKGYnuRWrXyHIqoIQ63RALGw3w5Dydax+yD6IbLtFjgYihnFsueVg4yJbOG5aAM7zzu62pwLFtk6nGJmt6kzkSG86iBBPIdICz8AApr+9ovHQajgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713176085; c=relaxed/simple;
	bh=cx+lsjyh/sdp7kr55rSduoD8MMgundgTDIANjAYz+yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pL/g3naGzUYQyBY65NzKCySaJCHlG3gBftakDaxsZGe6X1Rl63OOS88zxqa/BNvJcmYZmmA7FuW0SimZDFlchXx1Vyr+TJ+UdPLTwYP33zsi0HIFBGyOo3xQPNPkLrmrfUAdvqMItTq5hCFSN2BDUtk9msTO7whmjKr77rMkJX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de; spf=pass smtp.mailfrom=alpha.franken.de; arc=none smtp.client-ip=193.175.24.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alpha.franken.de
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
	id 1rwHob-0004hu-00; Mon, 15 Apr 2024 10:35:49 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
	id B764FC061A; Mon, 15 Apr 2024 10:35:35 +0200 (CEST)
Date: Mon, 15 Apr 2024 10:35:35 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: arnd@arndb.de, linux-mips@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] MIPS: Add prototypes for plat_post_relocation() and
 relocate_kernel()
Message-ID: <Zhzm19RhWVElRPpL@alpha.franken.de>
References: <20240403-mips-kaslr-missing-prototypes-v1-1-26b2390c1b7a@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240403-mips-kaslr-missing-prototypes-v1-1-26b2390c1b7a@kernel.org>

On Wed, Apr 03, 2024 at 02:26:33PM -0700, Nathan Chancellor wrote:
> When building malta_defconfig with CONFIG_RELOCATABLE=y, there are two
> warnings due to missing prototypes for functions only used when that
> configuration is enabled:
> 
>   arch/mips/kernel/relocate.c:42:12: warning: no previous prototype for 'plat_post_relocation' [-Wmissing-prototypes]
>      42 | int __weak plat_post_relocation(long offset)
>         |            ^~~~~~~~~~~~~~~~~~~~
>   arch/mips/kernel/relocate.c:324:14: warning: no previous prototype for 'relocate_kernel' [-Wmissing-prototypes]
>     324 | void *__init relocate_kernel(void)
>         |              ^~~~~~~~~~~~~~~
> 
> While relocate_kernel() is only called from assembly, it makes sense to
> keep the prototypes together in C to fix the warnings. Add them to
> silence the warnings.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/mips/include/asm/setup.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/mips/include/asm/setup.h b/arch/mips/include/asm/setup.h
> index 4dce41138bad..d8077136372c 100644
> --- a/arch/mips/include/asm/setup.h
> +++ b/arch/mips/include/asm/setup.h
> @@ -2,6 +2,7 @@
>  #ifndef _MIPS_SETUP_H
>  #define _MIPS_SETUP_H
>  
> +#include <linux/init.h>
>  #include <linux/types.h>
>  #include <uapi/asm/setup.h>
>  
> @@ -29,4 +30,9 @@ extern void per_cpu_trap_init(bool);
>  extern void cpu_cache_init(void);
>  extern void tlb_init(void);
>  
> +#ifdef CONFIG_RELOCATABLE
> +extern void * __init relocate_kernel(void);
> +extern int plat_post_relocation(long);
> +#endif
> +
>  #endif /* __SETUP_H */
> 
> ---
> base-commit: 39cd87c4eb2b893354f3b850f916353f2658ae6f
> change-id: 20240403-mips-kaslr-missing-prototypes-b15cbf88513f
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
