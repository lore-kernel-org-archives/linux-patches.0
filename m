Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505A07B;
	Thu, 31 Mar 2022 07:11:49 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id x4so27587530iop.7;
        Thu, 31 Mar 2022 00:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=7x1fdU6pqjAZLbP5PtFUo2vUl+jZ2Pw0oZiQRelFaww=;
        b=jRJHzTJIP2ij7OoBi7EoxZn8Lv/F8ANuafSpdYYtHY2l0iu/EIhW6Axb/Eb4/ShbYj
         VvshYHke/Ek54uH1G11HOJy1G+0Rc3oIoKRZeclydKZDkl2AekzZsTswfJQ9QRleZWk5
         SY/3t+X+O2w2D4/xcBKR7FqhT5M0rE40lBf1Vxs5aRZxhUl5HwjPFilFZCa6b4+ahx4r
         CuzJ+Lu12dZOuSHnUKSwR5zOhNuyRtrLrca6ZTb7GPUwFm7nUUmts/9trsBecdsVzGf0
         SRKh08VlvGUX+JPPMwaAAdRYDaObjySTNuwrtI5YrORrfo2ADUHknLxWX2fNteipk+HI
         wRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=7x1fdU6pqjAZLbP5PtFUo2vUl+jZ2Pw0oZiQRelFaww=;
        b=YcXeDb8ENQIjNctl3U70k6Z6f2tYJqbGxQt60PMQ8BNEuzNoby9QQs4CkVt9GwVeS8
         B7mI+ErR6km0Hlzq8ey0DGFAYWz2Jim9n7bw5hx4CPv8p2XbYDPyITEItvlLMGhyw4rR
         wERddwO0jac2BvPu5aFiflYIb9XGukJ8K6NEKCGDfmzd8Mufj0rh0Hi1Poiq3IoZzavE
         SPMSybaj7VOVXpiau4Ewq/HMBH3+YhZdAB4ureQwsFVRiNkcv01T/Bc21pcWs8NVZ2HB
         eRYk6W1U4BgW3UQuQgWLRRbFJY5vzHsO54u+ZR2zfezsKtvPYzjA0IGyHl/UKbc71RsA
         WsvA==
X-Gm-Message-State: AOAM53243FlRFkbbiDXFhxqfOys1tgQhPfUBFsnwiWQaRBHgT+zxUSwr
	66Vpbi7Ed6deC0XbjjJXKceQL0onee5wOUexG38=
X-Google-Smtp-Source: ABdhPJwWy7Y4cOJDc9jZYpOHaZTQZy2emksvzTY5Pr5LwDRkTPWRmcVZAivt62hqNW+lswewqcf1Qrku/kUk4nI5bDQ=
X-Received: by 2002:a05:6638:a3a:b0:323:5c6d:ae20 with SMTP id
 26-20020a0566380a3a00b003235c6dae20mr2323427jao.80.1648710708247; Thu, 31 Mar
 2022 00:11:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220330234528.1426991-1-nathan@kernel.org> <20220330234528.1426991-2-nathan@kernel.org>
In-Reply-To: <20220330234528.1426991-2-nathan@kernel.org>
Reply-To: sedat.dilek@gmail.com
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Thu, 31 Mar 2022 09:11:12 +0200
Message-ID: <CA+icZUXrVgGyaujA1iQEw5P3nJHVwMtbFxpE2gKktaxW0Xg-wg@mail.gmail.com>
Subject: Re: [PATCH 1/2] kbuild: Remove '-mno-global-merge'
To: Nathan Chancellor <nathan@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Kees Cook <keescook@chromium.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-um@lists.infradead.org, llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, Mar 31, 2022 at 5:27 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> This flag is specific to clang, where it is only used by the 32-bit and
> 64-bit ARM backends. In certain situations, the presence of this flag
> will cause a warning, as shown by commit 6580c5c18fb3 ("um: clang: Strip
> out -mno-global-merge from USER_CFLAGS").
>
> Since commit 61163efae020 ("kbuild: LLVMLinux: Add Kbuild support for
> building kernel with Clang") that added this flag back in 2014, there
> have been quite a few changes to the GlobalMerge pass in LLVM. Building
> several different ARCH=arm and ARCH=arm64 configurations with LLVM 11
> (minimum) and 15 (current main version) with this flag removed (i.e.,
> with the default of '-mglobal-merge') reveals no modpost warnings, so it
> is likely that the issue noted in the comment is no longer relevant due
> to changes in LLVM or modpost, meaning this flag can be removed.
>
> If any new warnings show up that are a result of the removal of this
> flag, it can be added back under arch/arm{,64}/Makefile to avoid
> warnings on other architectures.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  Makefile | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index daeb5c88b50b..f2723d9bfca4 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -784,10 +784,6 @@ ifdef CONFIG_CC_IS_CLANG
>  KBUILD_CPPFLAGS += -Qunused-arguments
>  # The kernel builds with '-std=gnu89' so use of GNU extensions is acceptable.
>  KBUILD_CFLAGS += -Wno-gnu
> -# CLANG uses a _MergedGlobals as optimization, but this breaks modpost, as the
> -# source of a reference will be _MergedGlobals and not on of the whitelisted names.
> -# See modpost pattern 2
> -KBUILD_CFLAGS += -mno-global-merge
>  else
>
>  # gcc inanely warns about local variables called 'main'
> --
> 2.35.1
>

I have tested this several times and was able to boot into bar metal -
no problems with building and/or booting my kernel-modules.

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>

Just as a side-note:
As with Linux v5.18-rc1 and -std=gnu11 we change the above comment ...?

# The kernel builds with '-std=gnu89' so use of GNU extensions is acceptable.
KBUILD_CFLAGS += -Wno-gnu

- Sedat -
