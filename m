Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5685134C4
	for <patches@lists.linux.dev>; Thu, 25 Jan 2024 23:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706224227; cv=none; b=ojDAggk+GthjHleB76Yog9P8/a7Vsf94WcTDXnzQZzLM6GdoaPzQugitGiriQmE302Mm3ALKCipmmyOqQVpjbKftfD32iZ3DsfF+6/HJKuPeYJ/8qrLI+zyiZv+ZVghN2As/PRU65ZkgDNpArp76QybNFNsqkpax3fmliu/Uunk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706224227; c=relaxed/simple;
	bh=F0JsRt97ajucsfaFS27RF2bTkUl+vXZuPR7I3vO2DBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=swPkGtAZv23rkrbeytAEr1U0Gu3lqCdi09SV3oOiik6EeggpDdI+RZLGTMP7UgZvUl344/n00yf6TvWy/9WKliGDwT0FuF9d6Wmp+bPFf4jwuI2f0S9wv4IxYwPr1TKTR/FCfv4kB2iTC2mcxr/wNrQIC7fYwi+Modn2XJ52nV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=UW21vVSH; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UW21vVSH"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6dd85328325so3107583b3a.1
        for <patches@lists.linux.dev>; Thu, 25 Jan 2024 15:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1706224225; x=1706829025; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YSh2SMxpzeSY8suanJAp4xUOQNbTcnMt4h+uTiF67+U=;
        b=UW21vVSHGcAaGRkVQXe521II436epSVaAs1WxuBlqUqrHBvjXbkMqaRmQE0zmg0EZ6
         t+Nhlb/xledPhzmKMHgTtV3lehdHj5ZDmJ1Wn7Xg8ztp40NY+ztHjL8ks6jW9jzJSGT0
         XEq6Ins9PbJoRG1suf6Wu3Ae0Yo015kGQbNrc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706224225; x=1706829025;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YSh2SMxpzeSY8suanJAp4xUOQNbTcnMt4h+uTiF67+U=;
        b=YIRZRRmrcHzxkig6mk9ZDDYzn5Xt19r5O6cU2SObCEZR+paLL64ca3NbnNyFYNnX+e
         NUANxbaW4sgGSnczd07CTsTG3BPHTP86o3nC8S8gblkC3bd0FY4SUQ680VqPLulHzLy8
         eOC+l5nM4eUCJ/w0tY8NHCsbg3KM/rGU+iVABQGJeclK90oFXryUT80bscG23dfRc4U6
         tY1Q9sniuqqJBA3oZviEwYQHeo4WcIHP+hZQW7NTHzGMKKADIT99MnnqFk3nADg+zl5/
         PU0JDwzAiiQNwP0V5O/Eui5NjdS63S5fUKpo9c60IOt6aLAbqLPTUNUw6rfSLA4HQ7hj
         39+Q==
X-Gm-Message-State: AOJu0Yygcka3PaqygRAJlKi7KLL5dlNzhEMdZagCbFGYvx0Dmz59zbRB
	egmVL86ehb29bXmAWuL3JsqtbKGN0MjpPZ6xBPrPcqzsC29JIzabnsnpOGp0Dg==
X-Google-Smtp-Source: AGHT+IH31m5NlnF2FWv8Czpe2vRmKzes75Mmfn8IuhBbVPoTR04pbzWQk7GFedHzNU9HrXMbCT/lvQ==
X-Received: by 2002:a05:6a21:338d:b0:19a:e2aa:ff23 with SMTP id yy13-20020a056a21338d00b0019ae2aaff23mr509971pzb.9.1706224225137;
        Thu, 25 Jan 2024 15:10:25 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id s22-20020a635256000000b005ca0ae17983sm33642pgl.8.2024.01.25.15.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jan 2024 15:10:24 -0800 (PST)
Date: Thu, 25 Jan 2024 15:10:24 -0800
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: akpm@linux-foundation.org, masahiroy@kernel.org, nicolas@fjasle.eu,
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, linux@armlinux.org.uk,
	ardb@kernel.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, aneesh.kumar@kernel.org,
	naveen.n.rao@linux.ibm.com, linuxppc-dev@lists.ozlabs.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	conor@kernel.org, linux-riscv@lists.infradead.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 00/11] Bump the minimum supported version of LLVM to
 13.0.1
Message-ID: <202401251509.17795F434@keescook>
References: <20240125-bump-min-llvm-ver-to-13-0-1-v1-0-f5ff9bda41c5@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240125-bump-min-llvm-ver-to-13-0-1-v1-0-f5ff9bda41c5@kernel.org>

On Thu, Jan 25, 2024 at 03:55:06PM -0700, Nathan Chancellor wrote:
> Hi all,
> 
> This series bumps the minimum supported version of LLVM for building the
> kernel to 13.0.1. The first patch does the bump and all subsequent
> patches clean up all the various workarounds and checks for earlier
> versions.
> 
> Quoting the first patch's commit message for those that were only on CC
> for the clean ups:
> 
>   When __builtin_mul_overflow() has arguments that differ in terms of
>   signedness and width, LLVM may generate a libcall to __muloti4 because
>   it performs the checks in terms of 65-bit multiplication. This issue
>   becomes harder to hit (but still possible) after LLVM 12.0.0, which
>   includes a special case for matching widths but different signs.
> 
>   To gain access to this special case, which the kernel can take advantage
>   of when calls to __muloti4 appear, bump the minimum supported version of
>   LLVM for building the kernel to 13.0.1. 13.0.1 was chosen because there
>   is minimal impact to distribution support while allowing a few more
>   workarounds to be dropped in the kernel source than if 12.0.0 were
>   chosen. Looking at container images of up to date distribution versions:
> 
>     archlinux:latest              clang version 16.0.6
>     debian:oldoldstable-slim      clang version 7.0.1-8+deb10u2 (tags/RELEASE_701/final)
>     debian:oldstable-slim         Debian clang version 11.0.1-2
>     debian:stable-slim            Debian clang version 14.0.6
>     debian:testing-slim           Debian clang version 16.0.6 (19)
>     debian:unstable-slim          Debian clang version 16.0.6 (19)
>     fedora:38                     clang version 16.0.6 (Fedora 16.0.6-3.fc38)
>     fedora:latest                 clang version 17.0.6 (Fedora 17.0.6-1.fc39)
>     fedora:rawhide                clang version 17.0.6 (Fedora 17.0.6-1.fc40)
>     opensuse/leap:latest          clang version 15.0.7
>     opensuse/tumbleweed:latest    clang version 17.0.6
>     ubuntu:focal                  clang version 10.0.0-4ubuntu1
>     ubuntu:latest                 Ubuntu clang version 14.0.0-1ubuntu1.1
>     ubuntu:rolling                Ubuntu clang version 16.0.6 (15)
>     ubuntu:devel                  Ubuntu clang version 17.0.6 (3)
> 
>   The only distribution that gets left behind is Debian Bullseye, as the
>   default version is 11.0.1; other distributions either have a newer
>   version than 13.0.1 or one older than the current minimum of 11.0.0.
>   Debian has easy access to more recent LLVM versions through
>   apt.llvm.org, so this is not as much of a concern. There are also the
>   kernel.org LLVM toolchains, which should work with distributions with
>   glibc 2.28 and newer.
> 
>   Another benefit of slimming up the number of supported versions of LLVM
>   for building the kernel is reducing the build capacity needed to support
>   a matrix that builds with each supported version, which allows a matrix
>   to reallocate the freed up build capacity towards something else, such
>   as more configuration combinations.
> 
> This passes my build matrix with all supported versions.
> 
> This is based on Andrew's mm-nonmm-unstable to avoid trivial conflicts
> with my series to update the LLVM links across the repository [1] but I
> can easily rebase it to linux-kbuild if Masahiro would rather these
> patches go through there (and defer the conflict resolution to the merge
> window).
> 
> [1]: https://lore.kernel.org/20240109-update-llvm-links-v1-0-eb09b59db071@kernel.org/
> 
> ---
> Nathan Chancellor (11):
>       kbuild: Raise the minimum supported version of LLVM to 13.0.1
>       Makefile: Drop warn-stack-size plugin opt
>       x86: Drop stack-alignment plugin opt
>       ARM: Remove Thumb2 __builtin_thread_pointer workaround for Clang
>       arm64: Kconfig: Clean up tautological LLVM version checks
>       powerpc: Kconfig: Remove tautology in CONFIG_COMPAT
>       riscv: Remove MCOUNT_NAME workaround
>       riscv: Kconfig: Remove version dependency from CONFIG_CLANG_SUPPORTS_DYNAMIC_FTRACE
>       fortify: Drop Clang version check for 12.0.1 or newer
>       lib/Kconfig.debug: Update Clang version check in CONFIG_KCOV
>       compiler-clang.h: Update __diag_clang() macros for minimum version bump
> 
>  Documentation/process/changes.rst |  2 +-
>  Makefile                          |  8 --------
>  arch/arm/include/asm/current.h    |  8 +-------
>  arch/arm64/Kconfig                |  5 +----
>  arch/powerpc/Kconfig              |  1 -
>  arch/riscv/Kconfig                |  2 --
>  arch/riscv/include/asm/ftrace.h   | 14 ++------------
>  arch/riscv/kernel/mcount.S        | 10 +++++-----
>  arch/x86/Makefile                 |  6 ------
>  include/linux/compiler-clang.h    |  8 ++------
>  lib/Kconfig.debug                 |  2 +-
>  scripts/min-tool-version.sh       |  2 +-
>  scripts/recordmcount.pl           |  2 +-
>  security/Kconfig                  |  2 --
>  14 files changed, 15 insertions(+), 57 deletions(-)
> ---
> base-commit: 979741ebd48f75ed6d101c7290e3325340d361ff
> change-id: 20240124-bump-min-llvm-ver-to-13-0-1-39f84dd36b19
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 

Yes, please. :) This looks reasonable -- I appreciate the review of
default Clang versions across distros!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
