Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A318B322C61
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 10:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755599777; cv=none; b=TMIpRMAhQrD55qJyes8oW44ftpaGpvBYx0Os6BQDl8rxMPDJIS6Q+8Kc51pAxQUFHBdU/nUs1kv64IbbI9leSBHh7+eQ5JaAtW9WYXWjx9mFbGn/PSg0aTj3OdNLHS47lxAQw3Rsbq0oGge+6cG6NMVq3lSOEcAkkYYubSPi7Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755599777; c=relaxed/simple;
	bh=f0QsgYzieVeY78Rm9/QS4ztp2XaR7DWI6fggUzgPROg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WPBpTaCLRUZ1a/fC/Qt4FctT4a7Ulz3C8geoqLf8VG2UBA+4hI7FRZGZ2urODsviqsEnz/Tdyx98U4UxCCSnFyeTgwe+Zl8RRbO7RQfSQspFKt6zOgMcJwBUsCZKYl24AXXoOREKrEJb0kqDxv01R6C3SR1KtBxjYGgu9WPXcS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DGP6RWu6; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DGP6RWu6"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-71d603a269cso41441087b3.1
        for <patches@lists.linux.dev>; Tue, 19 Aug 2025 03:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755599774; x=1756204574; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2fN+Cw2GD8q7ciDJSfP7W+cnq2F/R7FubEkGbK5iPps=;
        b=DGP6RWu69R8NMV+6omMmNUMvdTQ5yHnWqZslmZxTtLRs5I5VWR1uU46nMp6NRX0KI+
         ZeZL2Ny8wQ/iUdUhH3ZfB6ZU/yntw/+31mIqzWA88JPzbtideJkPZm10LQwDKb8kj9cM
         TJS5BqWLpWmj3RvBF94aDAkvSCsm2ZGqGHECPQjJS/sZS8yTLN3g7blcSNmYiHbjhwON
         C3VLP7k7P8S2hs+ixblBSoUbzZ8rXGBOxAXS9bYUfIc2u9/V+Qdj/wUM7qA3kNCV7dlZ
         i8/WghG+5k03ROZ8/pAWNx7jsBUf9YNKsSc2kJEemaYKZRcIsnipwL7hA1hPTO5ImfKw
         L1DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755599774; x=1756204574;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2fN+Cw2GD8q7ciDJSfP7W+cnq2F/R7FubEkGbK5iPps=;
        b=ksPzEoH8N/0k7jOa23l/Ibt97GYSqwJQ3qt/9uaEjNP8tnGXmYjXyb8i9ucMqK+t1B
         1W5HdayzuwwCiuhh7exQ30LGeHC19hob/VM87rpswHoFwaBQA0mMhbdNj6HTmyWiCs+9
         xyTYZ/hN5MOcNehyFzDWbS1OgURDJyJn/P8+p6iAVQauCvt8y2SNNTnvkrdCYgfMfNry
         o0V61foKhGpxGbhmpr5LxxGM98z7WrtuCAHPRS3J8Py+07T5MZQS2YimU+tmUIFd/Zd9
         XcAgbKRoSFcXyOtszpMwLJMS/JNFyoyiG5kjxGNKFOzyJFS+sMpzbbyxeqzvWUS9gmaL
         inFA==
X-Forwarded-Encrypted: i=1; AJvYcCUiPoI01Ist6lgh1w53NSjLyVIelr/AA6Dw5zVYZiCrHn/mx0uImS/aDDreFqGeXhvEDa7AJzjF@lists.linux.dev
X-Gm-Message-State: AOJu0YzQV3PyOFBhi+FrM78urs+qoGNoBjrncUg4u0fpBXI/1dRzKg/0
	Zq+A0N0g1Z8msxsNAJi7lXrG7G8ZCkk+oKWiIA4maYT6kEwI9bMt14kOHwn14ywXpy3Bz0E2LoW
	gf3JnrXSVHsPDj2B+tfKrSkf8GiyRA9ZeiY4YwA/3
X-Gm-Gg: ASbGncvnfpzkzW9Lum6M6bOtW03HDtUaLvxuMDfT2515nu4OyXWlFFAK8hPNjwhhWE4
	XYxOOtzb/nfIbtDopejTOfaDN7UACgDhGvOIzvNISWmMAhDs1T5JqAaAftnkSTlY2x4CEqiXKyX
	UJGiJOJvYNBg86AV64Ji6OffxosJEg1rU4JXk+6nGZa4ZctB8p33qGJov/NsrYtOqwJooLyb5k9
	iE0/BbylPZGkMEQM4rPTBiYHX6Upl2p6OR8YqS2WLSYghpjshZwXYj2
X-Google-Smtp-Source: AGHT+IEyQkk7FbmcgWE6e5Fltqxk8e2OmEel306FAGI6BUzZSbzI9juKCgBNuurFH75DIL/XFm7wd0hLUiRSVtYPoVQ=
X-Received: by 2002:a05:690c:6c02:b0:71e:325e:5468 with SMTP id
 00721157ae682-71f9d494f58mr24000397b3.5.1755599774272; Tue, 19 Aug 2025
 03:36:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org> <20250818-bump-min-llvm-ver-15-v1-9-c8b1d0f955e0@kernel.org>
In-Reply-To: <20250818-bump-min-llvm-ver-15-v1-9-c8b1d0f955e0@kernel.org>
From: Marco Elver <elver@google.com>
Date: Tue, 19 Aug 2025 12:35:37 +0200
X-Gm-Features: Ac12FXy_pMfFpBqlyslz5YoDfRSNwKDNUf2Ii-KoSTGsRrmWmRwz_9vxZQpt2K4
Message-ID: <CANpmjNN243_NoHOEdHvs0zDTzX5w4hjWoeo9TnQbwgfPzOWJAA@mail.gmail.com>
Subject: Re: [PATCH 09/10] objtool: Drop noinstr hack for KCSAN_WEAK_MEMORY
To: Nathan Chancellor <nathan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Kees Cook <kees@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 18 Aug 2025 at 20:58, Nathan Chancellor <nathan@kernel.org> wrote:
>
> Now that the minimum supported version of LLVM for building the kernel
> has been bumped to 15.0.0, __no_kcsan will always ensure that the thread
> sanitizer functions are not generated, so remove the check for tsan
> functions in is_profiling_func() and the always true depends and
> unnecessary select lines in KCSAN_WEAK_MEMORY.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Marco Elver <elver@google.com>

Good riddance.

> ---
> Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Marco Elver <elver@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: kasan-dev@googlegroups.com
> ---
>  lib/Kconfig.kcsan     |  6 ------
>  tools/objtool/check.c | 10 ----------
>  2 files changed, 16 deletions(-)
>
> diff --git a/lib/Kconfig.kcsan b/lib/Kconfig.kcsan
> index 609ddfc73de5..4ce4b0c0109c 100644
> --- a/lib/Kconfig.kcsan
> +++ b/lib/Kconfig.kcsan
> @@ -185,12 +185,6 @@ config KCSAN_WEAK_MEMORY
>         bool "Enable weak memory modeling to detect missing memory barriers"
>         default y
>         depends on KCSAN_STRICT
> -       # We can either let objtool nop __tsan_func_{entry,exit}() and builtin
> -       # atomics instrumentation in .noinstr.text, or use a compiler that can
> -       # implement __no_kcsan to really remove all instrumentation.
> -       depends on !ARCH_WANTS_NO_INSTR || HAVE_NOINSTR_HACK || \
> -                  CC_IS_GCC || CLANG_VERSION >= 140000
> -       select OBJTOOL if HAVE_NOINSTR_HACK
>         help
>           Enable support for modeling a subset of weak memory, which allows
>           detecting a subset of data races due to missing memory barriers.
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index d14f20ef1db1..efa4c060ff4e 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -2453,16 +2453,6 @@ static bool is_profiling_func(const char *name)
>         if (!strncmp(name, "__sanitizer_cov_", 16))
>                 return true;
>
> -       /*
> -        * Some compilers currently do not remove __tsan_func_entry/exit nor
> -        * __tsan_atomic_signal_fence (used for barrier instrumentation) with
> -        * the __no_sanitize_thread attribute, remove them. Once the kernel's
> -        * minimum Clang version is 14.0, this can be removed.
> -        */
> -       if (!strncmp(name, "__tsan_func_", 12) ||
> -           !strcmp(name, "__tsan_atomic_signal_fence"))
> -               return true;
> -
>         return false;
>  }
>
>
> --
> 2.50.1
>
