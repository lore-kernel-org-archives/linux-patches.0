Received: from mail-io1-f66.google.com (mail-io1-f66.google.com [209.85.166.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2765338DF9
	for <patches@lists.linux.dev>; Fri,  7 Nov 2025 22:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762554911; cv=none; b=h0/2yLMUrOxaw+3XRyLEv8yVuMA1Uy998ZNQj07B1rIlkmolyMNxBUAUK5FdCZZ2xJa8VJ8zGr7WhmBbktmpM81PkXs6tfwd6o9t0igXyarBIP+PO+hKjIz984JztgRJnH8vav/flSdRSOxfYGBPovP5JbKamBE4o1YsfwLOg20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762554911; c=relaxed/simple;
	bh=jKIG+hl3ckKtlPWTwmBHwV9+UHs+t9nPAs35IGkcdVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d9CvdWZD8bOWHSpFWGTHGSqn4H8pajiqR4PiKiOEZeSuIOt1DqVg6v+M4Erm1S/Sf3or7U+AsqwofkgyBjXr2qhbJ6E5383D27mvymwzh7CoPSty5Ots87Spli96zvcYJzbmUiFwXe1lYlrlsQbdy2D2clHDNqRZe2/Fb+9vb/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Ir1wXhl/; arc=none smtp.client-ip=209.85.166.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Ir1wXhl/"
Received: by mail-io1-f66.google.com with SMTP id ca18e2360f4ac-94863b3620cso100974239f.3
        for <patches@lists.linux.dev>; Fri, 07 Nov 2025 14:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1762554909; x=1763159709; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vg08ldRAkLf5MLDRRjwTlFUbZI12uD+f/89Jv5J/3K8=;
        b=Ir1wXhl/y67ZeGRma5VwXAWnrq6nLWerkDYhwgeNSY41sFHLWMteRwp6QQNmWFObnD
         Fo/Vh7o0dNeUMceTbK8QxhTF81Mbq4hjxlUq60Ojx5YBaxsFzXij2d1Uzfku/yEC56EL
         pdp9AxgbYHESncAy7PJwYWh1ERGLqS9SKT0zSsFKMrd5jaBGSGE0Cf1SjDHCfPC0GPau
         D7MDEiElsHIaVY6vYowybeV7OCHCG8WT+oMTAw6etuQ0eS2xnJDJkyh0sXyiwYVBE1+N
         8hldg5Ks7FDgO46N1eKyLkOkispyUHlfqlHxTw1xVCXi4Lw3VuoB4SNKCvYggfLgCUTY
         waQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762554909; x=1763159709;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vg08ldRAkLf5MLDRRjwTlFUbZI12uD+f/89Jv5J/3K8=;
        b=MLX1tQZ0OJnBdO70CQa6np8BWMqf/e/bBwK1aZ9IiItmz73SBMTVoiu8auTVcvXANw
         8NUs1WO1XvLxgqBjeqIojLaxaXfeEVmls2Vvm60+UGStq1U4O9qaSI8aEZKgvkhZNq3E
         XwZbdnovI4p0nlYowKD/cPRM8sYIgTDLDqM7laUVGEj4AK+Te7ECEWs+XKAiXgH0fkQt
         O+7qsoWGCrpkWF2frETUKT6kyM1Kv1KeVzQ8rv1hESnQw2oeDOaeGU0x7KLmV32skaUw
         cmLmkFj4awARJ8lhC5hkKpb08scIK2eXK9sZpRaEF9VXF9uhbT0xhqJO3aZagUd10OUX
         CLgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxt44QKJgurutP+LY5aB7458n6GnCmc4O7CcNjF38mjp8lEMn+u5gKpp36hY/sYJVbYHmhy90N@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/UrPT+hA3may+l+qiOSAwFrnrlwTyrVhsqmu5ydogWD/PVDUr
	KWSfBPkgTV+EQJ5f28fi9OZmeSyLSlLJYfJbBaomxc2xePmfFzfQTDT0K0YeZeX9Q7A=
X-Gm-Gg: ASbGncswHn2MttGee6YCwcxBJs60dQYqcqAHhTgYHlUVE28tpjFmcd6QUu4cFKlawZf
	c27k8nPeS7jw7NxktE5KEInjRl1hzHYXRZJPtfcdtyUlEO53/m8uvSGyEzRWEEqLkTy0/s2Mlqr
	HVmvPrGphoL2hbqyJTESFKsFYr3T7HvePKqFTYdSApC1w3XcDWCDDn78dqjjW1und01pLSidMOZ
	2dkVZgd8gt6hznTrpBRac6yzMp8yomA03R/tdaSuHe8D09RG8+JsASgxVhXSXetAzJ4GTOpGFvt
	4n8i13+/BYeCM8XlYhEAO+LixgHF8GKgD75Rva3uSwIDd/qr13Xa9z1Wmt8cmZC0O0Ilozmi9em
	ol5boGQzYNPwm/If45qd5oRAH3FA86KCW3bXuZpgxDvwITr8EvnXe3CZ4ACsdsMKSTRAWo2aMwG
	p/XA==
X-Google-Smtp-Source: AGHT+IHZR6USA9yWR5ZWBMvXBHz10PgFyz+z8/DiHeuXwHyQGKeRtUt1d+sutlUlF7qY5zNBqoYc1A==
X-Received: by 2002:a05:6602:60c3:b0:948:28cf:3f9c with SMTP id ca18e2360f4ac-94896011efemr132046639f.14.1762554909205;
        Fri, 07 Nov 2025 14:35:09 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b746806d2bsm2465313173.18.2025.11.07.14.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:35:08 -0800 (PST)
Date: Fri, 7 Nov 2025 16:35:07 -0600
From: Andrew Jones <ajones@ventanamicro.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Ben Dooks <ben.dooks@codethink.co.uk>, linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Subject: Re: [PATCH fixes] riscv: Fix CONFIG_AS_HAS_INSN for new .insn usage
Message-ID: <20251107-e4e324e725ddf47b9aafa0b4@orel>
References: <20251107-riscv-fix-new-insn-usage-v1-1-9a186c5928a0@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251107-riscv-fix-new-insn-usage-v1-1-9a186c5928a0@kernel.org>

On Fri, Nov 07, 2025 at 02:56:59PM -0700, Nathan Chancellor wrote:
> After commit 44aa25c000b4 ("riscv: asm: use .insn for making custom
> instructions"), builds using LLVM older that 19 or binutils older than
> 2.38 fail with:
> 
>   arch/riscv/include/asm/vdso/processor.h: Assembler messages:
>   arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
>   arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
>   arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
>   arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
>   make[4]: *** [scripts/Makefile.build:287: arch/riscv/kernel/vdso/vgettimeofday.o] Error 1
> 
>   In file included from <built-in>:4:
>   In file included from lib/vdso/gettimeofday.c:6:
>   In file included from include/vdso/datapage.h:21:
>   In file included from include/vdso/processor.h:10:
>   arch/riscv/include/asm/vdso/processor.h:23:2: error: expected instruction format
>      23 |         ALT_RISCV_PAUSE();
>         |         ^
>   arch/riscv/include/asm/errata_list.h:47:3: note: expanded from macro 'ALT_RISCV_PAUSE'
>      47 |                 RISCV_PAUSE, /* Original RISC‑V pause insn */ \
>         |                 ^
>   arch/riscv/include/asm/insn-def.h:259:21: note: expanded from macro 'RISCV_PAUSE'
>     259 | #define RISCV_PAUSE     ASM_INSN_I("0x100000f")
>         |                         ^
>   arch/riscv/include/asm/asm.h:16:26: note: expanded from macro 'ASM_INSN_I'
>      16 | #define ASM_INSN_I(__x) ".insn " __x
>         |                          ^
>   <inline asm>:5:7: note: instantiated into assembly here
>       5 | .insn 0x100000f
>         |       ^
> 
> binutils gained support for '.insn <value>' in 2.38 [1] and LLVM gained
> support in 19 [2]. Adjust the test for CONFIG_AS_HAS_INSN to ensure that
> all versions of .insn are supported before being used.
> 
> Fixes: 44aa25c000b4 ("riscv: asm: use .insn for making custom instructions")
> Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=a262b82fdbf4cda3b0648b1adc32245ca3f78b7a [1]
> Link: https://github.com/llvm/llvm-project/commit/2a086dce691e3cc34a2fc27f4fb255bb2cbbfac9 [2]
> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/riscv/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 22cda9c452d2..fadec20b87a8 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -367,7 +367,7 @@ config RISCV_NONSTANDARD_CACHE_OPS
>  	  systems to handle cache management.
>  
>  config AS_HAS_INSN
> -	def_bool $(as-instr,.insn r 51$(comma) 0$(comma) 0$(comma) t0$(comma) t0$(comma) zero)
> +	def_bool $(as-instr,.insn 0x100000f)
>  
>  config AS_HAS_OPTION_ARCH
>  	# https://github.com/llvm/llvm-project/commit/9e8ed3403c191ab9c4903e8eeb8f732ff8a43cb4
> 
> ---
> base-commit: a882126c42fc53275ac91969d460d939191db7b0
> change-id: 20251107-riscv-fix-new-insn-usage-2261377c2d38
> 
> Best regards,
> --  
> Nathan Chancellor <nathan@kernel.org>
>

Thanks for posting this Nathan.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
