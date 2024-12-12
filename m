Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42D6229145
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 16:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021870; cv=none; b=uICpPHu23fjNlTN1zrzmK8fneJjx8eeGQ+GOdJUemP99dHEyl8OeyQ2cm3wM+8XfjZ+dMr5EarsBK3B3t5gHWYi88KeV9+4QPJMkeR6A7pRucfA0ACgCJQkQiNEJK9Xs4Ow+YhukT6OCRdR73weJD73FXWO4h5EQZFvoJj3NAb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021870; c=relaxed/simple;
	bh=ld/cbcGIMh7wjL+EMp4uhFlDVLJ4/bUyclFK+sOJlrs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c0k+IgqmQ/jU6a0zN/vErT9oCFiBBV0+8gfubUMTEfh9bO6R9crqdjRKfa6r+rEEmFv1Pb2bKbyMnweQ6D5WMT79bHHV/QWdsqGUpqSxG9KgaoIYy9dVd15Gn6odUfSZmDEzVdIdWdY7dGluangVj2ZweBgZlhaNWfblmuk587Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=THjKnkAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="THjKnkAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75013C4CECE
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 16:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734021870;
	bh=ld/cbcGIMh7wjL+EMp4uhFlDVLJ4/bUyclFK+sOJlrs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=THjKnkAsuTJGeKTaOaj6XVrOrofHClMuL2nL55xRWVqNFPt1a4kaOWk9vrn1JM/8Z
	 Gl4AWxPf9lEKbtR0I8vb+o+OJzVb2JTgy4KAsaCwZC7tJ/FPL7A8eOchHuAXfYSPT2
	 ANLR0fRCHZEVU4MFCdWsPhSo7A8FfV4GK42YXcg6O26sQUeCWJvU7H1z52ipQ9BidU
	 3EehQfMleQf56fRvhbQ5InvvH0g+xIDS2o9RW/K4jcOwArLXFJmmAKEF63PBZ7lJM4
	 9zSnoCnmd6N/KXaH/JA/Rw0japJhAhiTnJBUswTfs+04IUTo0cchZ8Rc/ql+6dqw+I
	 /o6ZHP9SpECYQ==
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-30037784fceso7216891fa.2
        for <patches@lists.linux.dev>; Thu, 12 Dec 2024 08:44:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXESCUjJC5A1nvcireyN57WustK2+TvFEF/1r0uBIY8yN5gC04LJ0DRH775gaD7bd/UqSePA5SE@lists.linux.dev
X-Gm-Message-State: AOJu0YyjSwYUkRQ0z3nzfa5CtIKQYyxU4DicnyrcG3TXrkaqy+567bdO
	xnoENR5P80iXIRionUHFxkqp4tiwjyaWHBkIeTSQ0gHM+2TAL0ToaRKp2qjTaqH3J1ibk7urk18
	Y5NyZwOBo96ENF0uny3EeGU0TrCY=
X-Google-Smtp-Source: AGHT+IHXwTFB5nRftcTtAQA2d+D/Qi/magR8HrwnOV4HAbbK19AOAR7dmyuM43Kg+kBigONTIH3wczCNq7V6iRYoeW4=
X-Received: by 2002:a2e:b057:0:b0:302:1de7:ef3c with SMTP id
 38308e7fff4ca-30251e67775mr3232821fa.31.1734021868676; Thu, 12 Dec 2024
 08:44:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241212144311.432886635@linuxfoundation.org> <20241212144314.376068717@linuxfoundation.org>
In-Reply-To: <20241212144314.376068717@linuxfoundation.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 12 Dec 2024 17:44:17 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFaeqMe3RSP+CzH1KoCu-PJqmuO=vq8fVRQ9MH19F6WUg@mail.gmail.com>
Message-ID: <CAMj1kXFaeqMe3RSP+CzH1KoCu-PJqmuO=vq8fVRQ9MH19F6WUg@mail.gmail.com>
Subject: Re: [PATCH 5.15 073/565] x86/stackprotector: Work around strict Clang
 TLS symbol requirements
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Brian Gerst <brgerst@gmail.com>, "Borislav Petkov (AMD)" <bp@alien8.de>, Nathan Chancellor <nathan@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Dec 2024 at 17:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 5.15-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> [ Upstream commit 577c134d311b9b94598d7a0c86be1f431f823003 ]
>

Please drop this for now - see my reply to the v6.1 version.


> GCC and Clang both implement stack protector support based on Thread Local
> Storage (TLS) variables, and this is used in the kernel to implement per-task
> stack cookies, by copying a task's stack cookie into a per-CPU variable every
> time it is scheduled in.
>
> Both now also implement -mstack-protector-guard-symbol=, which permits the TLS
> variable to be specified directly. This is useful because it will allow to
> move away from using a fixed offset of 40 bytes into the per-CPU area on
> x86_64, which requires a lot of special handling in the per-CPU code and the
> runtime relocation code.
>
> However, while GCC is rather lax in its implementation of this command line
> option, Clang actually requires that the provided symbol name refers to a TLS
> variable (i.e., one declared with __thread), although it also permits the
> variable to be undeclared entirely, in which case it will use an implicit
> declaration of the right type.
>
> The upshot of this is that Clang will emit the correct references to the stack
> cookie variable in most cases, e.g.,
>
>   10d:       64 a1 00 00 00 00       mov    %fs:0x0,%eax
>                      10f: R_386_32   __stack_chk_guard
>
> However, if a non-TLS definition of the symbol in question is visible in the
> same compilation unit (which amounts to the whole of vmlinux if LTO is
> enabled), it will drop the per-CPU prefix and emit a load from a bogus
> address.
>
> Work around this by using a symbol name that never occurs in C code, and emit
> it as an alias in the linker script.
>
> Fixes: 3fb0fdb3bbe7 ("x86/stackprotector/32: Make the canary into a regular percpu variable")
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> Cc: stable@vger.kernel.org
> Link: https://github.com/ClangBuiltLinux/linux/issues/1854
> Link: https://lore.kernel.org/r/20241105155801.1779119-2-brgerst@gmail.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/x86/Makefile                     |  3 ++-
>  arch/x86/entry/entry.S                | 15 +++++++++++++++
>  arch/x86/include/asm/asm-prototypes.h |  3 +++
>  arch/x86/kernel/cpu/common.c          |  2 ++
>  arch/x86/kernel/vmlinux.lds.S         |  3 +++
>  5 files changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 9c09bbd390cec..f8a7d2a654347 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -81,7 +81,8 @@ ifeq ($(CONFIG_X86_32),y)
>
>         ifeq ($(CONFIG_STACKPROTECTOR),y)
>                 ifeq ($(CONFIG_SMP),y)
> -                       KBUILD_CFLAGS += -mstack-protector-guard-reg=fs -mstack-protector-guard-symbol=__stack_chk_guard
> +                       KBUILD_CFLAGS += -mstack-protector-guard-reg=fs \
> +                                        -mstack-protector-guard-symbol=__ref_stack_chk_guard
>                 else
>                         KBUILD_CFLAGS += -mstack-protector-guard=global
>                 endif
> diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
> index f4419afc7147d..23f9efbe9d705 100644
> --- a/arch/x86/entry/entry.S
> +++ b/arch/x86/entry/entry.S
> @@ -48,3 +48,18 @@ EXPORT_SYMBOL_GPL(mds_verw_sel);
>
>  .popsection
>
> +#ifndef CONFIG_X86_64
> +/*
> + * Clang's implementation of TLS stack cookies requires the variable in
> + * question to be a TLS variable. If the variable happens to be defined as an
> + * ordinary variable with external linkage in the same compilation unit (which
> + * amounts to the whole of vmlinux with LTO enabled), Clang will drop the
> + * segment register prefix from the references, resulting in broken code. Work
> + * around this by avoiding the symbol used in -mstack-protector-guard-symbol=
> + * entirely in the C code, and use an alias emitted by the linker script
> + * instead.
> + */
> +#ifdef CONFIG_STACKPROTECTOR
> +EXPORT_SYMBOL(__ref_stack_chk_guard);
> +#endif
> +#endif
> diff --git a/arch/x86/include/asm/asm-prototypes.h b/arch/x86/include/asm/asm-prototypes.h
> index 5cdccea455544..390b13db24b81 100644
> --- a/arch/x86/include/asm/asm-prototypes.h
> +++ b/arch/x86/include/asm/asm-prototypes.h
> @@ -18,3 +18,6 @@
>  extern void cmpxchg8b_emu(void);
>  #endif
>
> +#if defined(__GENKSYMS__) && defined(CONFIG_STACKPROTECTOR)
> +extern unsigned long __ref_stack_chk_guard;
> +#endif
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index f0cc4c616ceb3..5db433cfaaa78 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -2000,8 +2000,10 @@ EXPORT_PER_CPU_SYMBOL(cpu_current_top_of_stack);
>
>  #ifdef CONFIG_STACKPROTECTOR
>  DEFINE_PER_CPU(unsigned long, __stack_chk_guard);
> +#ifndef CONFIG_SMP
>  EXPORT_PER_CPU_SYMBOL(__stack_chk_guard);
>  #endif
> +#endif
>
>  #endif /* CONFIG_X86_64 */
>
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index 351c604de263a..ab36dacb4cc50 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -490,6 +490,9 @@ SECTIONS
>         ASSERT(SIZEOF(.rela.dyn) == 0, "Unexpected run-time relocations (.rela) detected!")
>  }
>
> +/* needed for Clang - see arch/x86/entry/entry.S */
> +PROVIDE(__ref_stack_chk_guard = __stack_chk_guard);
> +
>  /*
>   * The ASSERT() sink to . is intentional, for binutils 2.14 compatibility:
>   */
> --
> 2.43.0
>
>
>
