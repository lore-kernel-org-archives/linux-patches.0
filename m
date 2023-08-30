Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2FB538A
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 13:22:48 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-68c0cb00fb3so4313017b3a.2
        for <patches@lists.linux.dev>; Wed, 30 Aug 2023 06:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1693401768; x=1694006568; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O4GvqqXYslqNFsd5EWHg4Ea3OLy5rZ2/lST17BJAYmg=;
        b=lUm0OFv5z8nm1MeREwbwq5POXsKIpjV5aQuopFeEdH2fkPzY4Rn2AaSqdnXF5+x0EM
         y0RwdwJgY/uF7cnzUIvuQL8t7lheHJEfrSM3ulcJkag0DItlCPUQNvq5ATSX3j1mvV4F
         D68YsMEHC29USdRcljqd6dCzlZssfIp1qdtkbSnnnv2wPpr0grjsJOujDT3PpQ633rFo
         Al0YSiVMEdY4/TIrr5bPO3nAnm7+M8xlKETNCU9U7iV4L/CMn/rxjl1MMJvNrV+Q2aOq
         0Em9rcFvdIo1hRUOe4bpm5lArCkKDR9aqKac1zzBnu7rBHw/vnvS7dH/DvtYrBiI965h
         HZZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693401768; x=1694006568;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O4GvqqXYslqNFsd5EWHg4Ea3OLy5rZ2/lST17BJAYmg=;
        b=iCCLqhvfERAzwKtHwWfanNLEwiHv8BH3LnrAeWCerEebtpzeY/quVhVPJWaHjNAfjs
         kRjQcVsG551eJ4X1YKoJ2+Q51aQLEd0g+Q+PaFne/x0r65s4+7DyMPxPY72RN8SloS9I
         gXV5yqkaSYA1N+CetIx06hYfbPma/H2nTKk3pc8jNPdmlZgepKjfkcev/uCI6M20XhFn
         Ve/vNQO1FfCwdOeRNJ90cu4cB4Q4ua6I/f/DMQ4SrR9q0hPPTcCAX38WbBe06coaxwiv
         MUoJ1s9EBtVVonMVU5S/M18B1riXlgAiadVeLBVqX9SZWQzZmdH+Dpn4F740CYbO6n4O
         Hhng==
X-Gm-Message-State: AOJu0Ywu1zRINhNsiYMdaaUbA3RBs3YB/DjwrOtn/R4S9nTrAWAHMX5r
	BKqIYtWS3m2EZuTg5jV0oBo+WQ==
X-Google-Smtp-Source: AGHT+IGTDa/l85FPKn1KhDFFtCyRdxWCBsUqIzaTeH5C54h6kus9MG641S9d7bLWS9D1W4VHOQfhMA==
X-Received: by 2002:a05:6a00:1ac8:b0:68a:457f:d418 with SMTP id f8-20020a056a001ac800b0068a457fd418mr2423568pfv.3.1693401767603;
        Wed, 30 Aug 2023 06:22:47 -0700 (PDT)
Received: from localhost ([135.180.227.0])
        by smtp.gmail.com with ESMTPSA id k8-20020aa792c8000000b006871fdde2c7sm9982010pfa.110.2023.08.30.06.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 06:22:45 -0700 (PDT)
Date: Wed, 30 Aug 2023 06:22:45 -0700 (PDT)
X-Google-Original-Date: Wed, 30 Aug 2023 06:22:40 PDT (-0700)
Subject:     Re: [PATCH] lib/Kconfig.debug: Restrict DEBUG_INFO_SPLIT for RISC-V
In-Reply-To: <20230816-riscv-debug_info_split-v1-1-d1019d6ccc11@kernel.org>
CC: Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
  akpm@linux-foundation.org, Conor Dooley <conor@kernel.org>, ndesaulniers@google.com, trix@redhat.com,
  linux-riscv@lists.infradead.org, llvm@lists.linux.dev, patches@lists.linux.dev, lkp@intel.com,
  nathan@kernel.org
From: Palmer Dabbelt <palmer@dabbelt.com>
To: nathan@kernel.org, keescook@chromium.org, akpm@linux-foundation.org
Message-ID: <mhng-747958b0-514c-4fc8-ac37-0769562ba385@palmer-ri-x1c9>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Wed, 16 Aug 2023 10:35:43 PDT (-0700), nathan@kernel.org wrote:
> When building for ARCH=riscv using LLVM < 14, there is an error with
> CONFIG_DEBUG_INFO_SPLIT=y:
>
>   error: A dwo section may not contain relocations
>
> This was worked around in LLVM 15 by disallowing '-gsplit-dwarf' with
> '-mrelax' (the default), so CONFIG_DEBUG_INFO_SPLIT is not selectable
> with newer versions of LLVM:
>
>   $ clang --target=riscv64-linux-gnu -gsplit-dwarf -c -o /dev/null -x c /dev/null
>   clang: error: -gsplit-dwarf is unsupported with RISC-V linker relaxation (-mrelax)
>
> GCC silently had a similar issue that was resolved with GCC 12.x.
> Restrict CONFIG_DEBUG_INFO_SPLIT for RISC-V when using LLVM or GCC <
> 12.x to avoid these known issues.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1914
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99090
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/all/202308090204.9yZffBWo-lkp@intel.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Since this only impacts RISC-V, it seems reasonable that this would go
> in via their tree but I have added Andrew in case he wants to take it.
> ---
>  lib/Kconfig.debug | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index d6798513a8c2..bd51274f4771 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -355,6 +355,11 @@ endchoice # "Compressed Debug information"
>  config DEBUG_INFO_SPLIT
>  	bool "Produce split debuginfo in .dwo files"
>  	depends on $(cc-option,-gsplit-dwarf)
> +	# RISC-V linker relaxation + -gsplit-dwarf has issues with LLVM and GCC
> +	# prior to 12.x:
> +	# https://github.com/llvm/llvm-project/issues/56642
> +	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99090
> +	depends on !RISCV || GCC_VERSION >= 120000
>  	help
>  	  Generate debug info into separate .dwo files. This significantly
>  	  reduces the build directory size for builds with DEBUG_INFO,

Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>

Not sure who's taking stuff for lib/Kconfig.debug, I can take it via the 
RISC-V tree if folks are OK with it.  Kees and Andrew were the last to 
touch it.

>
> ---
> base-commit: 2ccdd1b13c591d306f0401d98dedc4bdcd02b421
> change-id: 20230816-riscv-debug_info_split-0713571a1ac2
>
> Best regards,
