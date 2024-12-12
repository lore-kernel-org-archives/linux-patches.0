Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8702253EE
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 15:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019116; cv=none; b=R2+pMYN898DJllV2mkmda2lP4CV/mHivQaV5nZiezNBRYq5QSGTsBl9fSQ0Rlj5gbnioToX74Gui0UkP5UeRgYqXMK2JQUocD4JUn+qFUsW/iO/TUiR0DMVhMz/gDw0HE3Oi7uMX8d+OdPd9tY50eKMq3uaV95cpfhrQ9ItyKD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019116; c=relaxed/simple;
	bh=KK0O8y9eNgjmb0qxL9/XgBHBD4XbecIwOdl/COhFqec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oOdaJ+4RgeXdlFH6Iiimk8tOfeGw+DBmtLBkgrAPoXtoizJApO7W2NOk3sSFPmeL0mekXQpvTdqfEKzcc41yxgIQ8seH/JcQaiFK9PljEYzLPasESeunwueQffngt1zR3VRr0/Y2gPf0k9J9W+BOtuPacUUQcqgjsNY3WyDoPMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LqyBykSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqyBykSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D3AC4CED4
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 15:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734019115;
	bh=KK0O8y9eNgjmb0qxL9/XgBHBD4XbecIwOdl/COhFqec=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LqyBykSqdR9SGA8/IaaZLXGYXD/W55Ad6f6RiQJHDrJjeo7Uv7gauk9A/rUL5PeHy
	 Ywf3d682F0kriYrUyuh/zILHAMoYDQoo2Rci1vG299OItSpkzTRPjDpelu2NzsyEJq
	 xDBlbll9VupOwl+SmEUJrpeKwmgN/h8FdW2GZSHvoqosn+A36wJtg0zuG8mtFL8e3n
	 iJ1G84Nes7mHkzypQold7Tlj1/kWTy7wWva2jNQDcuV4LIyi3eNhO/t14Vj6z4RQn/
	 mWOV5xXMFE71AAh0zj0VlMRqpnf/8Y/xtw7JjA9ilTBcJqhk9xJTHBPZLTPjPRew+B
	 nLsDMT+L3PZxA==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3023c51146cso7720461fa.1
        for <patches@lists.linux.dev>; Thu, 12 Dec 2024 07:58:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU54BWA7wG3oK+Ht39+kW4sQOvDmsv7XZihAme5xfjnI+suFymyADs9rsb0kCSqLJ7XAfC4fFot@lists.linux.dev
X-Gm-Message-State: AOJu0YxOhR6jh539Nv4MJSkUO6KcF/9acyeEKeoVQ+vsY8EN+qw7E6hm
	obPQg5wdSYW828pZ+fAmuPKqzmbw2N/Vivl9X/07F94RYp+lB5ZZdCSAAay+X+wGsI9hMapPHN/
	7CfMxbHH6Q1+EHA3sUQA2Auw0JOQ=
X-Google-Smtp-Source: AGHT+IEehlYgwfoiimpQ7GDIYs3PGo6YxsYOeWkxoKuF2tvZvSylROVt5BE4PwmwIfczjdeyhogB+QkthHYnalah5fc=
X-Received: by 2002:a2e:bea5:0:b0:302:49b6:dfaf with SMTP id
 38308e7fff4ca-30251f3b58cmr2928431fa.20.1734019114037; Thu, 12 Dec 2024
 07:58:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241212144349.797589255@linuxfoundation.org> <20241212144351.271628434@linuxfoundation.org>
In-Reply-To: <20241212144351.271628434@linuxfoundation.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 12 Dec 2024 16:58:22 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHtbZNrrehr2bhkA8A_Ab0mAcG_X1PerVEWqdFJv-aUUw@mail.gmail.com>
Message-ID: <CAMj1kXHtbZNrrehr2bhkA8A_Ab0mAcG_X1PerVEWqdFJv-aUUw@mail.gmail.com>
Subject: Re: [PATCH 6.1 032/772] x86/stackprotector: Work around strict Clang
 TLS symbol requirements
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Brian Gerst <brgerst@gmail.com>, "Borislav Petkov (AMD)" <bp@alien8.de>, Nathan Chancellor <nathan@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Dec 2024 at 16:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.1-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> [ Upstream commit 577c134d311b9b94598d7a0c86be1f431f823003 ]
>

There is a follow-up patch that addresses a build issue with this
patch and older GCC versions. Given that this fix is for 32-bit only,
whereas the build issue affects 64-bit too, let's hold off on this one
until we can apply them as a pair.



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
> index 3419ffa2a3507..a88eede6e7db4 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -113,7 +113,8 @@ ifeq ($(CONFIG_X86_32),y)
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
> index 7f922a359ccc5..b4e999048e9a4 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -2158,8 +2158,10 @@ EXPORT_PER_CPU_SYMBOL(cpu_current_top_of_stack);
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
> index 78ccb5ec3c0e7..c1e776ed71b06 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -486,6 +486,9 @@ SECTIONS
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
