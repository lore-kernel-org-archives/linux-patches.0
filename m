Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15758D2E4
	for <patches@lists.linux.dev>; Thu, 23 Mar 2023 20:49:58 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id w4so39530plg.9
        for <patches@lists.linux.dev>; Thu, 23 Mar 2023 13:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112; t=1679604598;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XI8tywudTbf+/Du8HSnowFxjBhkGxjNqSmV9psYjjfg=;
        b=0J9j+v8Q7QxfshuE7u8uNsFuM6xG2q2Vfj4RxLMy6STRD7dMafx3EqjOcWLH2MyKAq
         lzrvXs6lmQI15QfK1pSs+3QSpYTD69Y42Rd9jZ4xlI+UhSTjejvtyazSKoHQH4IJbErH
         cKCjyBiyk26dT2ft1o1zY45Ha0SJ0YATY85KEUMlJ8XTkpdjbNp4WyvOiRjzck/hJnnB
         inriE/h9QKHg1t6W01oVKIY2iSi5ScwSZEUxNdqwuNykbgeJUQ6gWxpI9ihQSXYXUyBU
         HnznaWLPSFmpJ8QmKCCUxfJiERjw16Wifk7Ydt2nT3nVWXfL8VXqirsvWEfCFNQysnsl
         Clug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679604598;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XI8tywudTbf+/Du8HSnowFxjBhkGxjNqSmV9psYjjfg=;
        b=6FOZgMzPH4S2xGlL+mtOT58uWPRhKgqbt8UDRqcGi98sICG28Fyy8+t38HyJPJHPB4
         HSYiEBoz2UVVWvIASYp6WDFIijv8UUVdVSZg86RP6SI9rKxnY+oIOOR42dAawjZiKf5l
         WFQAgCCSQTk+V2Jrwv3ge5gFnawEEIWKEud5w5zd+r9gWmTbH0Yt+GDd7F0ofpkRBzib
         6ncauUpXDVbEo6QhiH5bGwFvpFIp2lay/8YrbkdtbnE1A3daHpzAWyQVBiRH3vF6yld7
         6dZ0Bx7Z4J/0npJGfUgSPoexEIJ2ogRsB0SI0T46z2Wm3crdQpiIWP8RVjdt2j1MQNCT
         MxVA==
X-Gm-Message-State: AAQBX9dA24hu0dmKgEm8Tvg+S4WYsqSSIbDXP+02Ro4VQkTh4eywOnQ0
	9/WihYnzMruiMzA0qSv8Utlo3jHMwddj1VlvDmU=
X-Google-Smtp-Source: AKy350ZNYHhfrLLaYFvP3o9Mif++m9/2ilSJf2xDmClVwpq8bgLMRYiek68HZURMjClC6lhGDT/gGQ==
X-Received: by 2002:a17:903:245:b0:19e:839e:49d8 with SMTP id j5-20020a170903024500b0019e839e49d8mr188258plh.59.1679604598230;
        Thu, 23 Mar 2023 13:49:58 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902ee4c00b0019ca68ef7c3sm12792539plo.74.2023.03.23.13.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 13:49:57 -0700 (PDT)
Date: Thu, 23 Mar 2023 13:49:57 -0700 (PDT)
X-Google-Original-Date: Thu, 23 Mar 2023 13:48:47 PDT (-0700)
Subject:     Re: [PATCH] riscv: Handle zicsr/zifencei issues between clang and binutils
In-Reply-To: <20230313-riscv-zicsr-zifencei-fiasco-v1-1-dd1b7840a551@kernel.org>
CC: Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
  Conor Dooley <conor.dooley@microchip.com>, nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
  linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev,
  stable@vger.kernel.org
From: Palmer Dabbelt <palmer@dabbelt.com>
To: nathan@kernel.org
Message-ID: <mhng-8af569d4-c3a7-4f33-8900-e458f75abf18@palmer-ri-x1c9a>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Mon, 13 Mar 2023 16:00:23 PDT (-0700), nathan@kernel.org wrote:
> There are two related issues that appear in certain combinations with
> clang and GNU binutils.
>
> The first occurs when a version of clang that supports zicsr or zifencei
> via '-march=' [1] (i.e, >= 17.x) is used in combination with a version
> of GNU binutils that do not recognize zicsr and zifencei in the
> '-march=' value (i.e., < 2.36):
>
>   riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_c2p0_zicsr2p0_zifencei2p0: Invalid or unknown z ISA extension: 'zifencei'
>   riscv64-linux-gnu-ld: failed to merge target specific data of file fs/efivarfs/file.o
>   riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_c2p0_zicsr2p0_zifencei2p0: Invalid or unknown z ISA extension: 'zifencei'
>   riscv64-linux-gnu-ld: failed to merge target specific data of file fs/efivarfs/super.o
>
> The second occurs when a version of clang that does not support zicsr or
> zifencei via '-march=' (i.e., <= 16.x) is used in combination with a
> version of GNU as that defaults to a newer ISA base spec, which requires
> specifying zicsr and zifencei in the '-march=' value explicitly (i.e, >=
> 2.38):
>
>   ../arch/riscv/kernel/kexec_relocate.S: Assembler messages:
>   ../arch/riscv/kernel/kexec_relocate.S:147: Error: unrecognized opcode `fence.i', extension `zifencei' required
>   clang-12: error: assembler command failed with exit code 1 (use -v to see invocation)
>
> This is the same issue addressed by commit 6df2a016c0c8 ("riscv: fix
> build with binutils 2.38") (see [2] for additional information) but
> older versions of clang miss out on it because the cc-option check
> fails:
>
>   clang-12: error: invalid arch name 'rv64imac_zicsr_zifencei', unsupported standard user-level extension 'zicsr'
>   clang-12: error: invalid arch name 'rv64imac_zicsr_zifencei', unsupported standard user-level extension 'zicsr'
>
> To resolve the first issue, only attempt to add zicsr and zifencei to
> the march string when using the GNU assembler 2.38 or newer, which is
> when the default ISA spec was updated, requiring these extensions to be
> specified explicitly. LLVM implements an older version of the base
> specification for all currently released versions, so these instructions
> are available as part of the 'i' extension. If LLVM's implementation is
> updated in the future, a CONFIG_AS_IS_LLVM condition can be added to
> CONFIG_TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI.
>
> To resolve the second issue, use version 2.2 of the base ISA spec when
> using an older version of clang that does not support zicsr or zifencei
> via '-march=', as that is the spec version most compatible with the one
> clang/LLVM implements and avoids the need to specify zicsr and zifencei
> explicitly due to still being a part of 'i'.
>
> [1]: https://github.com/llvm/llvm-project/commit/22e199e6afb1263c943c0c0d4498694e15bf8a16
> [2]: https://lore.kernel.org/ZAxT7T9Xy1Fo3d5W@aurel32.net/
>
> Cc: stable@vger.kernel.org
> Link: https://github.com/ClangBuiltLinux/linux/issues/1808
> Co-developed-by: Conor Dooley <conor.dooley@microchip.com>
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> This is essentially a v3 of Conor's v1 and v2 but since I am sending the
> patch after finding a separate but related issue, I left it at v1:
>
> - v1: https://lore.kernel.org/20230223220546.52879-1-conor@kernel.org/
> - v2: https://lore.kernel.org/20230308220842.1231003-1-conor@kernel.org/
>
> I have built allmodconfig with the following toolchain combinations to
> confirm this problem is resolved:
>
> - clang 12/17 + GNU as and ld 2.35/2.39
> - clang 12/17 with the integrated assembler + GNU ld 2.35/2.39
> - clang 12/17 with the integrated assembler + ld.lld
>
> There are a couple of other incompatibilities between clang-17 and GNU
> binutils that I had to patch to get allmodconfig to build successfully
> but those are less likely to be hit in practice because the full LLVM
> stack can be used with LLVM versions 13.x and newer. I will follow up
> with separate issues and patches.
> ---
>  arch/riscv/Kconfig  | 22 ++++++++++++++++++++++
>  arch/riscv/Makefile | 10 ++++++----
>  2 files changed, 28 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index c5e42cc37604..5b182d1c196c 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -464,6 +464,28 @@ config TOOLCHAIN_HAS_ZIHINTPAUSE
>  	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zihintpause)
>  	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23600
>
> +config TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
> +	def_bool y
> +	# https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=aed44286efa8ae8717a77d94b51ac3614e2ca6dc
> +	depends on AS_IS_GNU && AS_VERSION >= 23800
> +	help
> +	  Newer binutils versions default to ISA spec version 20191213 which
> +	  moves some instructions from the I extension to the Zicsr and Zifencei
> +	  extensions.
> +
> +config TOOLCHAIN_NEEDS_OLD_ISA_SPEC
> +	def_bool y
> +	depends on TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
> +	# https://github.com/llvm/llvm-project/commit/22e199e6afb1263c943c0c0d4498694e15bf8a16
> +	depends on CC_IS_CLANG && CLANG_VERSION < 170000
> +	help
> +	  Certain versions of clang do not support zicsr and zifencei via -march
> +	  but newer versions of binutils require it for the reasons noted in the
> +	  help text of CONFIG_TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI. This
> +	  option causes an older ISA spec compatible with these older versions
> +	  of clang to be passed to GAS, which has the same result as passing zicsr
> +	  and zifencei to -march.
> +
>  config FPU
>  	bool "FPU support"
>  	default y
> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> index 4de83b9b1772..b05e833a022d 100644
> --- a/arch/riscv/Makefile
> +++ b/arch/riscv/Makefile
> @@ -57,10 +57,12 @@ riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
>  riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
>  riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
>
> -# Newer binutils versions default to ISA spec version 20191213 which moves some
> -# instructions from the I extension to the Zicsr and Zifencei extensions.
> -toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
> -riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
> +ifdef CONFIG_TOOLCHAIN_NEEDS_OLD_ISA_SPEC
> +KBUILD_CFLAGS += -Wa,-misa-spec=2.2
> +KBUILD_AFLAGS += -Wa,-misa-spec=2.2
> +else
> +riscv-march-$(CONFIG_TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI) := $(riscv-march-y)_zicsr_zifencei
> +endif
>
>  # Check if the toolchain supports Zihintpause extension
>  riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE) := $(riscv-march-y)_zihintpause
>
> ---
> base-commit: eeac8ede17557680855031c6f305ece2378af326
> change-id: 20230313-riscv-zicsr-zifencei-fiasco-2941caebe7dc

Is that a b4 thing?  Having change IDs with names is nice, it's way 
easier to remember what's what when sorting through backports.

Also, this is on fixes.

Thanks!

> Best regards,
