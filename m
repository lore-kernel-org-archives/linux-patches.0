Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E61E748A;
	Wed,  4 Oct 2023 07:33:23 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-68fb85afef4so1490504b3a.1;
        Wed, 04 Oct 2023 00:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696404803; x=1697009603; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VkowXdKDAV9ozSJhzTKuFpAPuWb2aX6v74W5qb0n/iQ=;
        b=bl96DO99PLYE6tb/PydkYjhSUYCHm8wIW4x+PTTlOqWujUwWIiz3piwl/tOfr77PFc
         y7ex21dRKlCdtiObKE5sQte3iakrmcrmY9C62aLn/dBVJl0qsVnn7HwbMvOIm1U6HcHf
         MNfzdSBM501PxZnt5fnmbxU5YPV5EhGhe82O9DlPXa6nkk+9uknsKaUdOByYFdEVBzRV
         YuWgi0SbbXEw9xx0azZ1sTF/q4578VKiQlnOz3JI3aF9+R7HZsJ8Aif6k169+bbi+zrN
         NG1b9fXd4VE60s/Zt/233KFrRrK6b86hKdTySbXM07dcnz740kdKsLm3MpmVuKErC5dd
         fOLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696404803; x=1697009603;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VkowXdKDAV9ozSJhzTKuFpAPuWb2aX6v74W5qb0n/iQ=;
        b=MOhZEs3wosiGG/Rv26Bzh7smzaGqff9yA+vb8JYXfco/18fpA6urlFGYOCFjJb2BNb
         ZudJpF/dYF8LKu8kFyqQQKNpsMqZWYJEoq4h1rZXjoItVqHojwpBVYfXRCPYzKx7UKlg
         sZ2i3y5wbMNr8J1QkP+YbAE5+GVY/A9UHVKK4wkpcVAqXnKMXB8Bju3OuaUiZ+MmHIjP
         8wJSLMpGLhyV8EMEnQfxsfWM6oX/hMcAmREy123sc9xGK7gkLRFz9OPXzuMZoPEcLuHe
         OT1IWBcxP7cmNp62oZp2EswHWBCRV5cj9tczgMHMfXJiDpGqC1ayoW7h/pCC5FKvc1SJ
         lq1w==
X-Gm-Message-State: AOJu0YyuOF/IGmVuMvMKdwng1EfTzQcECR9/47dKGW6ASyno0zbn7e/C
	7cNt4VkuoA6IhWb9OcbRT/qBCzzQxC+0uiSJ
X-Google-Smtp-Source: AGHT+IGFzGzCltUfrIGUGcXUyq5vEJqw+HItJlIOKOpSPzrlh/tt33vv6HuiosGbPT75UF1nyaQUkQ==
X-Received: by 2002:a05:6a00:1911:b0:68f:f650:3035 with SMTP id y17-20020a056a00191100b0068ff6503035mr1823127pfi.12.1696404802783;
        Wed, 04 Oct 2023 00:33:22 -0700 (PDT)
Received: from [0.0.0.0] (jp.bgp.twd2.net. [2a0c:b641:571::1])
        by smtp.gmail.com with ESMTPSA id z17-20020aa785d1000000b00690c7552098sm2546024pfn.44.2023.10.04.00.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Oct 2023 00:33:22 -0700 (PDT)
Message-ID: <a337bd2b-34f1-4316-a0d5-18ba295badb3@gmail.com>
Date: Wed, 4 Oct 2023 15:33:15 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] RISC-V: build: Allow LTO to be selected
To: Nathan Chancellor <nathan@kernel.org>, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, conor@kernel.org
Cc: ndesaulniers@google.com, trix@redhat.com, samitolvanen@google.com,
 linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
 patches@lists.linux.dev, =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?=
 <maskray@google.com>
References: <20231003-riscv-lto-v3-1-8aca61a4ecb4@kernel.org>
From: twd2 <twd2.me@gmail.com>
In-Reply-To: <20231003-riscv-lto-v3-1-8aca61a4ecb4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

+CC MaskRay

Thanks!
Wende

On 2023/10/4 3:16, Nathan Chancellor wrote:
> From: Wende Tan <twd2.me@gmail.com>
>
> Allow LTO to be selected for RISC-V, only when LLD >= 14, since there is an
> issue [1] in prior LLD versions that prevents LLD to generate proper
> machine code for RISC-V when writing `nop`s.
>
> I have tested enabling LTO for `defconfig`. The LLD took ~2m21s and ~3GiB
> on our Intel Xeon Gold 6140 server and produced an 18MiB Image. The image
> can boot to shell using an archriscv rootfs on QEMU.
>
> I have also tested it for `allyesconfig` without COMPILE_TEST, FTRACE,
> KASAN, and GCOV. The LLD took ~7h03m and ~335GiB on the server,
> successfully producing a 1.7GiB Image. Unfortunately, we cannot boot this
> image because the `create_kernel_page_table()` -> `alloc_pmd_early()` ->
> `BUG_ON()` logic limits the image to be < 1GiB. Maybe we can fix it in a
> separate patch further.
>
> Disable LTO for arch/riscv/kernel/pi, as llvm-objcopy expects an ELF
> object file when manipulating the files in that subfolder, rather than
> LLVM bitcode.
>
> [1] https://github.com/llvm/llvm-project/issues/50505, resolved by LLVM
>     commit e63455d5e0e5 ("[MC] Use local MCSubtargetInfo in writeNops")
>
> Tested-by: Wende Tan <twd2.me@gmail.com>
> Signed-off-by: Wende Tan <twd2.me@gmail.com>
> Co-developed-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> NOTE: I tested LLVM 14 through 18 with defconfig + full/thin LTO and
> allmodconfig + thin LTO. allmodconfig + thin LTO with LLVM 15 and 16
> shows
>
>   ld.lld: error: section size decrease is too large
>
> when linking vmlinux. This appears to be resolved in LLVM 17 with
> https://github.com/llvm/llvm-project/commit/9d37ea95df1b84cca9b5e954d8964c976a5e303e
> (I did not bisect but the commit message lines up with the issue). I
> kept the existing version check because defconfig worked fine but we may
> want to bump it to 17.0.0 if randconfigs trip over this.
>
> Changes in v3:
> - Disable LTO in arch/riscv/kernel/pi/Makefile, which was added to the
>   kernel after the submission of v2. This change matches arm64.
> - Link to v2: https://lore.kernel.org/r/20220512205545.992288-1-twd2.me@gmail.com/
>
> Changes in v2:
> - Some textual changes suggested by Nick.
> - Drop the changes to `arch/riscv/Makefile`, since the LLVM issue is
>   filed and resolved.
> - Drop the unnecessary changes to `arch/riscv/kernel/vdso/Makefile`.
> - Link to v1: https://lore.kernel.org/r/20210719205208.1023221-1-twd2.me@gmail.com/
> ---
>  arch/riscv/Kconfig            | 3 +++
>  arch/riscv/kernel/pi/Makefile | 3 +++
>  2 files changed, 6 insertions(+)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index d607ab0f7c6d..523640f7441e 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -46,6 +46,9 @@ config RISCV
>  	select ARCH_SUPPORTS_CFI_CLANG
>  	select ARCH_SUPPORTS_DEBUG_PAGEALLOC if MMU
>  	select ARCH_SUPPORTS_HUGETLBFS if MMU
> +	# LLD >= 14: https://github.com/llvm/llvm-project/issues/50505
> +	select ARCH_SUPPORTS_LTO_CLANG if LLD_VERSION >= 140000
> +	select ARCH_SUPPORTS_LTO_CLANG_THIN if LLD_VERSION >= 140000
>  	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
>  	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
>  	select ARCH_USE_MEMTEST
> diff --git a/arch/riscv/kernel/pi/Makefile b/arch/riscv/kernel/pi/Makefile
> index 07915dc9279e..b75f150b923d 100644
> --- a/arch/riscv/kernel/pi/Makefile
> +++ b/arch/riscv/kernel/pi/Makefile
> @@ -9,6 +9,9 @@ KBUILD_CFLAGS	:= $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) -fpie \
>  		   -fno-asynchronous-unwind-tables -fno-unwind-tables \
>  		   $(call cc-option,-fno-addrsig)
>  
> +# Disable LTO
> +KBUILD_CFLAGS	:= $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
> +
>  KBUILD_CFLAGS	+= -mcmodel=medany
>  
>  CFLAGS_cmdline_early.o += -D__NO_FORTIFY
>
> ---
> base-commit: 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
> change-id: 20231003-riscv-lto-f013beed8587
>
> Best regards,

-- 
Best wishes!
Sincerely,
twd2
https://twd2.me

