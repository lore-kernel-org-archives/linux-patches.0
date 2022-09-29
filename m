Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ACF53B3
	for <patches@lists.linux.dev>; Thu, 29 Sep 2022 18:28:26 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id 78so2151498pgb.13
        for <patches@lists.linux.dev>; Thu, 29 Sep 2022 11:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=kmkU5eKx3bCGNBgsrw/HiECPrMWFtDQ93OEAZ05I5Zw=;
        b=OqOoGfkG5celZzk8DoeCB0Z415XFc+acvqmoX8nBDnRxJgZpg8tGcRuwUEs+9xxChk
         1Hu9orSfm438RdiaqE5SXGX+unJnOXQ8fweCClM5aky1wIdO63k+1n67zorgWReLZRRz
         XDDORlnnR5dIjX1/FUHYRduZZtQBcu2RjAxzT1PHhAJZ4xRuZQ0a+bNPlwbBGagY3V9E
         hsBFGmqWCZ0HoO+Lw7VoOJlgTQHjLePudthZrRONzfmUPWyzXj8DD62qR3aZEB/Q9hD0
         kSxdoiY5KvnClKNNNO+8uBUlqZ0RxOaJJasuZIG4SPX1mPDtIORUcCimKvhwMe8iSP/m
         OkGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=kmkU5eKx3bCGNBgsrw/HiECPrMWFtDQ93OEAZ05I5Zw=;
        b=UEY2CqID4Uuu/nJqgCo77fu+pdjvTIJUT45CYzLwN7zcYZvm13babe0xYNLzwfHaTq
         IvYQ07FBtuOJg0oKL82o04Vb/JU6FPCw+zmGpF47S4SAYnpXZCOIVkf0eQle/bAQqD2N
         BJ1hTrGDwL6Hm6NyqfYN/O+OgJRyKv/PcSN66+7HYHv8QSZ7q578laQLKK8Bl/z7Vg8L
         SFy+4iLvMZE9foH7tL9OVnDZzmai8KEZf5prnl4WkBYsVB8BuUy6rJOkQD/4kKkfEFJl
         q5EHQhuhQX7hKfl1inbPU9CBtfFPmmfvQAJLwrkHs/2vyYmbo7gmLVtX9g2JMS3MM17c
         UQmQ==
X-Gm-Message-State: ACrzQf2tkabdNowczyeYn+dhXfm346z/AUy8yEIa+I3vyaSM0FpuLKcQ
	5NWD6TrkdrAJBIPvnIWoKJ9MoYk7Co7v8Ri8bUyvmA==
X-Google-Smtp-Source: AMsMyM6aYy/t89e8ZoJ8vAq/RDFkJ3JUmYiYBj+AqR8RM1wpoJNPrAqLhiGUBk3HkWio80GxowYRw1EQeeWp6uRum/4=
X-Received: by 2002:a63:e709:0:b0:438:98e8:d1c with SMTP id
 b9-20020a63e709000000b0043898e80d1cmr4115018pgi.403.1664476105851; Thu, 29
 Sep 2022 11:28:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220929152010.835906-1-nathan@kernel.org>
In-Reply-To: <20220929152010.835906-1-nathan@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 29 Sep 2022 11:28:14 -0700
Message-ID: <CAKwvOdn61SYD81r5opTN1N8MAWe5YObPJ8wELei1qOySsoxJyA@mail.gmail.com>
Subject: Re: [PATCH] x86/Kconfig: Drop check for '-mabi=ms' for CONFIG_EFI_STUB
To: Nathan Chancellor <nathan@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 29, 2022 at 8:20 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> A recent change in LLVM made CONFIG_EFI_STUB unselectable because it no
> longer pretends to support '-mabi=ms', breaking the dependency in
> Kconfig. Lack of CONFIG_EFI_STUB can prevent kernels from booting via
> EFI in certain circumstances.
>
> This check was added by commit 8f24f8c2fc82 ("efi/libstub: Annotate
> firmware routines as __efiapi") to ensure that '__attribute__((ms_abi))'
> was available, as '-mabi=ms' is not actually used in any cflags.
> According to the GCC documentation, this attribute has been supported
> since GCC 4.4.7. The kernel currently requires GCC 5.1 so this check is
> not necessary; even when that change landed in 5.6, the kernel required
> GCC 4.9 so it was unnecessary then as well.  Clang supports
> '__attribute__((ms_abi))' for all versions that are supported for
> building the kernel so no additional check is needed. Remove the
> 'depends on' line altogether to allow CONFIG_EFI_STUB to be selected
> when CONFIG_EFI is enabled, regardless of compiler.
>
> Cc: stable@vger.kernel.org
> Fixes: 8f24f8c2fc82 ("efi/libstub: Annotate firmware routines as __efiapi")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1725
> Link: https://gcc.gnu.org/onlinedocs/gcc-4.4.7/gcc/Function-Attributes.html
> Link: https://github.com/llvm/llvm-project/commit/d1ad006a8f64bdc17f618deffa9e7c91d82c444d
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  arch/x86/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f9920f1341c8..81012154d9ed 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1956,7 +1956,6 @@ config EFI
>  config EFI_STUB
>         bool "EFI stub support"
>         depends on EFI
> -       depends on $(cc-option,-mabi=ms) || X86_32
>         select RELOCATABLE
>         help
>           This kernel feature allows a bzImage to be loaded directly
>
> base-commit: f76349cf41451c5c42a99f18a9163377e4b364ff
> --
> 2.37.3
>


-- 
Thanks,
~Nick Desaulniers
