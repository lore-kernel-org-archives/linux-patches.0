Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7C9111D;
	Wed,  8 Nov 2023 03:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mZ1EyD+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D253CC433C9;
	Wed,  8 Nov 2023 03:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699413129;
	bh=zWzQI9h3JCmUeFnDwkorPBWuwpKsgMwO9qtOrsDKJtk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mZ1EyD+rahmxc5oJmN6mow3uP8TFbBfuD+yfl8UJFpuivRX8C4WZR8+qvEDtOOObl
	 F/Y+kvHxpeKjmExv8txKviglCJKIC4/EJsiFMB07hjmFiI8PhiHaIvu0Rx8JvHtVJq
	 PKCOvcjs7xjSAyP/1ii/Y9JpFGKQt55ApuQL8GJVstKPH/T6ufFo2f1ikiYgVEjng1
	 Bdfs93ZzxvJdWNzowXDF60kNUGaZur3lwhEkv3nYefiJ8OdniUTlfJk/0zni0BaBsJ
	 mJr1/ORktAhHJLly+8LVqVxyTxq8PFbJJ1iMllD4kenjVFw1Igm94IwFGoDRtMzhu7
	 A6Cr7kkc8zrtA==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-53ed4688b9fso10682182a12.0;
        Tue, 07 Nov 2023 19:12:09 -0800 (PST)
X-Gm-Message-State: AOJu0YzKnLUgcGqhiw88yvB86Y35lcTz39ALJZE+l8jm/V+aB+M1v/ri
	+FgaTePTJzvD7GnapBwqwk/Su74fbor8ImyV3Bc=
X-Google-Smtp-Source: AGHT+IHxIANpMSTnCBsjUQot+qYbwXrOYHOuQcH/shPCBn66k9YGTd2uK6Co9Kr0z7LX9MwoBysbR3k/zHMEj32jttE=
X-Received: by 2002:a17:906:dc95:b0:9be:77cd:4c2c with SMTP id
 cs21-20020a170906dc9500b009be77cd4c2cmr321928ejc.28.1699413128274; Tue, 07
 Nov 2023 19:12:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231102-loongarch-always-inline-percpu-ops-v2-1-31c51959a5c0@kernel.org>
In-Reply-To: <20231102-loongarch-always-inline-percpu-ops-v2-1-31c51959a5c0@kernel.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 8 Nov 2023 11:11:57 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6CuABSAEn8MXssE8yDgSVEsONW7PmaDOiS+xJm=ZbcQA@mail.gmail.com>
Message-ID: <CAAhV-H6CuABSAEn8MXssE8yDgSVEsONW7PmaDOiS+xJm=ZbcQA@mail.gmail.com>
Subject: Re: [PATCH v2] LoongArch: Mark __percpu functions as always inline
To: Nathan Chancellor <nathan@kernel.org>
Cc: kernel@xen0n.name, ndesaulniers@google.com, trix@redhat.com, 
	jiaxun.yang@flygoat.com, loongarch@lists.linux.dev, llvm@lists.linux.dev, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied to loongarch-next, thanks.

Huacai

On Thu, Nov 2, 2023 at 11:43=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> A recent change to the optimization pipeline in LLVM reveals some
> fragility around the inlining of LoongArch's __percpu functions, which
> manifests as a BUILD_BUG() failure:
>
>   In file included from kernel/sched/build_policy.c:17:
>   In file included from include/linux/sched/cputime.h:5:
>   In file included from include/linux/sched/signal.h:5:
>   In file included from include/linux/rculist.h:11:
>   In file included from include/linux/rcupdate.h:26:
>   In file included from include/linux/irqflags.h:18:
>   arch/loongarch/include/asm/percpu.h:97:3: error: call to '__compiletime=
_assert_51' declared with 'error' attribute: BUILD_BUG failed
>      97 |                 BUILD_BUG();
>         |                 ^
>   include/linux/build_bug.h:59:21: note: expanded from macro 'BUILD_BUG'
>      59 | #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
>         |                     ^
>   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_O=
N_MSG'
>      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond),=
 msg)
>         |                                     ^
>   include/linux/compiler_types.h:425:2: note: expanded from macro 'compil=
etime_assert'
>     425 |         _compiletime_assert(condition, msg, __compiletime_asser=
t_, __COUNTER__)
>         |         ^
>   include/linux/compiler_types.h:413:2: note: expanded from macro '_compi=
letime_assert'
>     413 |         __compiletime_assert(condition, msg, prefix, suffix)
>         |         ^
>   include/linux/compiler_types.h:406:4: note: expanded from macro '__comp=
iletime_assert'
>     406 |                         prefix ## suffix();                    =
         \
>         |                         ^
>   <scratch space>:86:1: note: expanded from here
>      86 | __compiletime_assert_51
>         | ^
>   1 error generated.
>
> If these functions are not inlined (which the compiler is free to do
> even with functions marked with the standard 'inline' keyword), the
> BUILD_BUG() in the default case cannot be eliminated since the compiler
> cannot prove it is never used, resulting in a build failure due to the
> error attribute.
>
> Mark these functions as __always_inline to guarantee inlining so that
> the BUILD_BUG() only triggers when the default case genuinely cannot be
> eliminated due to an unexpected size.
>
> Cc:  <stable@vger.kernel.org>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1955
> Fixes: 46859ac8af52 ("LoongArch: Add multi-processor (SMP) support")
> Link: https://github.com/llvm/llvm-project/commit/1a2e77cf9e11dbf56b5720c=
607313a566eebb16e
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Changes in v2:
> - Change 'inline' to __always_inline for all functions that contain
>   BUILD_BUG() (Huacai)
> - Notate that 'inline' does not guarantee inlining in the commit message
>   to further clarify the change to __always_inline.
> - Link to v1: https://lore.kernel.org/r/20231101-loongarch-always-inline-=
percpu-ops-v1-1-b8f2e9a71729@kernel.org
> ---
>  arch/loongarch/include/asm/percpu.h | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/percpu.h b/arch/loongarch/include=
/asm/percpu.h
> index b9f567e66016..313852fba845 100644
> --- a/arch/loongarch/include/asm/percpu.h
> +++ b/arch/loongarch/include/asm/percpu.h
> @@ -32,7 +32,7 @@ static inline void set_my_cpu_offset(unsigned long off)
>  #define __my_cpu_offset __my_cpu_offset
>
>  #define PERCPU_OP(op, asm_op, c_op)                                    \
> -static inline unsigned long __percpu_##op(void *ptr,                   \
> +static __always_inline unsigned long __percpu_##op(void *ptr,          \
>                         unsigned long val, int size)                    \
>  {                                                                      \
>         unsigned long ret;                                              \
> @@ -63,7 +63,7 @@ PERCPU_OP(and, and, &)
>  PERCPU_OP(or, or, |)
>  #undef PERCPU_OP
>
> -static inline unsigned long __percpu_read(void *ptr, int size)
> +static __always_inline unsigned long __percpu_read(void *ptr, int size)
>  {
>         unsigned long ret;
>
> @@ -100,7 +100,8 @@ static inline unsigned long __percpu_read(void *ptr, =
int size)
>         return ret;
>  }
>
> -static inline void __percpu_write(void *ptr, unsigned long val, int size=
)
> +static __always_inline void __percpu_write(void *ptr, unsigned long val,
> +                                          int size)
>  {
>         switch (size) {
>         case 1:
> @@ -132,8 +133,8 @@ static inline void __percpu_write(void *ptr, unsigned=
 long val, int size)
>         }
>  }
>
> -static inline unsigned long __percpu_xchg(void *ptr, unsigned long val,
> -                                               int size)
> +static __always_inline unsigned long __percpu_xchg(void *ptr, unsigned l=
ong val,
> +                                                  int size)
>  {
>         switch (size) {
>         case 1:
>
> ---
> base-commit: 278be83601dd1725d4732241f066d528e160a39d
> change-id: 20231101-loongarch-always-inline-percpu-ops-cf77c161871f
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
