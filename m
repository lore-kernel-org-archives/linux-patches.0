Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198FC8C08
	for <patches@lists.linux.dev>; Thu, 17 Nov 2022 19:15:22 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id y10so1334076plp.3
        for <patches@lists.linux.dev>; Thu, 17 Nov 2022 11:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oqReIcW9s0Rx+ZZxRkzmtucR2377ZRmpngvb88GnLsg=;
        b=GOP378AKH/hv8Ar+sxOQ+MTbMDvMqgysny+XsfnA1NeD7BCG7kFsVW86EaxkoT3Rmo
         crJ093HED/R3LtbkrmLrYynfePGhZJBR1f642uzkd7gF9ttW+TcC4nZ6B/pQz/AuBN/p
         uxCcnKW/3Rzd1tusg7w+cUxuAytjrFkV0vzegfMQzGNbmHNxCBXT79csyRyoV+MyfRHi
         E+ZKGxPTAiLl45/3OfuLwCEUrrlWzahwy9srX5RWORrjfewK9d0tObXqwOEig8Jn/3dk
         zHeIZFgrbxrqjxCvOztd37+KYIJqwbZsNSSeTllD8fwVh+LNZ604Df8gMhpS4pLXcKdM
         n+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oqReIcW9s0Rx+ZZxRkzmtucR2377ZRmpngvb88GnLsg=;
        b=6LPM1HaMReJ/Ny10bBoaA5pSs+ljRk+xmoxLLZtJQQHVG8zkufNzHNlTuVwm8jNnVG
         KonJpPT2KueOJWnjxaSjqRkCiCvuLzNLDhsTSqcNmlWDv6qyL+GQYmIvUOZCuaDTvaPA
         WBwn7dneaOAePexIeoqUuvVyEhcqq1Te4SgAWYMyhtNvJYa/7pfTZy5gdcbx1b9wUSY1
         rfEDo890Pik89KfQgFA+OcrU2/IiC2Q8Gcj1LgvCtsFLLnVsHNQ4TUjhmt9YDjkL6XrS
         4TBpx6lkLEuH3px91G63Nez8SB/TqshEDRvINZIFIQXsJs4Y/yuJI3qgIJ0z9lF2qxQO
         2RKA==
X-Gm-Message-State: ANoB5pkjPSkLOaFgYIYn4eTkkRAEy1Gi1ASGpjNRzk+95vsyb6z3kpSe
	dSaJMAQkKJJDzNgQCAqw9RYqJ2hXgeiN0xzn7W/ddg==
X-Google-Smtp-Source: AA0mqf6uyYTOrbrUoUgvOqU2dy8oTvk0QDhsnTGXbpoRtxusgfBO0VUArzQuIC363xnourJQ4v+pQOZpiQFTPzv3rSk=
X-Received: by 2002:a17:902:8307:b0:186:8558:ded2 with SMTP id
 bd7-20020a170902830700b001868558ded2mr4098074plb.95.1668712521318; Thu, 17
 Nov 2022 11:15:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221114225719.1657174-1-nathan@kernel.org>
In-Reply-To: <20221114225719.1657174-1-nathan@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 17 Nov 2022 11:15:09 -0800
Message-ID: <CAKwvOdn67r3ZYb5XZkae3i5797GGV3=8=nLC7kT2d4On3OEm5A@mail.gmail.com>
Subject: Re: [PATCH] ARM: Drop '-mthumb' from AFLAGS_ISA
To: Nathan Chancellor <nathan@kernel.org>, Sylvestre Ledru <sylvestre@debian.org>, 
	Serge Guelton <sguelton@mozilla.com>
Cc: Russell King <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>, 
	Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
	"kernelci.org bot" <bot@kernelci.org>, Sylvestre Ledru <sylvestre@mozilla.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 14, 2022 at 2:58 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> When building with CONFIG_THUMB2_KERNEL=y + a version of clang from
> Debian, the following warning occurs frequently:

I also needed to explicitly set
CROSS_COMPILE=arm-linux-gnueabihf-
to reproduce.  Please add that detail to the commit message.  Thanks
for helping spot that difference on IRC.

It sounds like tuxmake (which our CI is built on) and perhaps kernelCI
are both setting that variable, which is no longer necessary when
using LLVM=1 for ARCH=arm.

Not CROSS_COMPILE=arm-linux-gnueabi- like the triple we use by default
for ARCH=arm in scripts/Makefile.clang.  So this issue arises from:
1. using debian's clang, which is carrying an out of tree patch affecting this.
2. using `CROSS_COMPILE=arm-linux-gnueabihf-`.

The use of both of those in conjunction I'd like to think would be
relatively unlikely, but it seems that we have both CI systems doing
this (and the patch LGTM regardless of changing the CI).

>
>   <built-in>:383:9: warning: '__thumb2__' macro redefined [-Wmacro-redefined]
>   #define __thumb2__ 2
>           ^
>   <built-in>:353:9: note: previous definition is here
>   #define __thumb2__ 1
>           ^
>   1 warning generated.
>
> Debian carries a downstream patch that changes the default CPU of the
> arm-linux-gnueabihf target from 'arm1176jzf-s' (v6) to 'cortex-a7' (v7).
> As a result, '-mthumb' defines both '__thumb__' and '__thumb2__'. The
> define of '__thumb2__' via the command line was purposefully added to
> catch a situation like this.

And we caught something!  It's almost like Ard has sight-beyond-sight
or something when he made that suggestion. Coincidence? I think not...
:P

>
> In a similar vein as commit 26b12e084bce ("ARM: 9264/1: only use
> -mtp=cp15 for the compiler"), do not add '-mthumb' to AFLAGS_ISA, as it
> is already passed to the assembler via '-Wa,-mthumb' and '__thumb2__' is
> already defined for preprocessing.
>
> Fixes: 1d2e9b67b001 ("ARM: 9265/1: pass -march= only to compiler")
> Link: htps://salsa.debian.org/pkg-llvm-team/llvm-toolchain/-/blob/17354b030ac4252ff6c5e9d01f4eba28bd406b2d/debian/patches/930008-arm.diff

Would you mind using
https://salsa.debian.org/pkg-llvm-team/llvm-toolchain/-/blob/snapshot/debian/patches/930008-arm.diff
as the link instead? The link on this commit message is a diff against
llvm-14, not ToT which is currently llvm-16; the context is quite
different as the logic moved source files completely.  Though it does
look like Sylvestre has not yet cut a 16 branch for debian's patches.

If not, at least re-add the missing `t` from the protocol in the URL
(s/htps/https/).

> Reported-by: "kernelci.org bot" <bot@kernelci.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

I verified this locally with LLVM built from source, comparing no out
of tree patches vs just debian's 930008-arm.diff applied.

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>

---

If memory serves, this is perhaps the third time downstream debian
patches to llvm have caused us initially-difficult-to-reproduce bugs.
Sylvestre, going forward, would you mind please giving your diff's
more descriptive file names, or making them actual commits with some
context in the commit message?  Time and resource permitting,
submitting them upstream, even if they're not accepted, but pointing
to the upstream discussion (if any) from commit messages would provide
us more context for these kind of things.  Maybe Serge could help you
burn down those out of tree patches? ;)

> ---
>  arch/arm/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index 357f0d9b8607..d1ebb746ff40 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -131,8 +131,9 @@ endif
>  AFLAGS_NOWARN  :=$(call as-option,-Wa$(comma)-mno-warn-deprecated,-Wa$(comma)-W)
>
>  ifeq ($(CONFIG_THUMB2_KERNEL),y)
> -CFLAGS_ISA     :=-mthumb -Wa,-mimplicit-it=always $(AFLAGS_NOWARN)
> +CFLAGS_ISA     :=-Wa,-mimplicit-it=always $(AFLAGS_NOWARN)
>  AFLAGS_ISA     :=$(CFLAGS_ISA) -Wa$(comma)-mthumb -D__thumb2__=2
> +CFLAGS_ISA     +=-mthumb
>  else
>  CFLAGS_ISA     :=$(call cc-option,-marm,) $(AFLAGS_NOWARN)
>  AFLAGS_ISA     :=$(CFLAGS_ISA)
>
> base-commit: 0c52591d22e99759da3793f19249bbf45ad742bd
> --
> 2.38.1
>


-- 
Thanks,
~Nick Desaulniers
