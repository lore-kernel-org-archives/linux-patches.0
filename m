Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AE118F
	for <patches@lists.linux.dev>; Thu, 14 Dec 2023 00:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="xypUG/ew"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6ce6d926f76so63458b3a.1
        for <patches@lists.linux.dev>; Wed, 13 Dec 2023 16:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702512744; x=1703117544; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=viMe9kglal5ScjZ1n6jPL3FjIe+JldVfUhvBnQIbEiw=;
        b=xypUG/eweQMH92qWDqkgRH4eOEvSjeO9d37Z9Rws/YwxdueksJUN/XaqqAikM0M56Z
         78Pb8SG8f+ErMgXTLceap3v4pTKx+FxYVNN9jd0+bMWr+ROlE0zp/iryu9t3wTmU1IK7
         idnrleGgbMa8vWv4X7NIwWp+uFDTk3pvPRjq3yhpEPsyTeIurFB/IWyLf8xhIeDEqB7U
         IfIk8W+KFLgdimgzmz3LR37pL4BvQYRCNjJ3NnNmTUAHIlKxFToz9tR8NGvc+IaFWNcK
         iEIZjRB8mUrPkpV9JQl2mRCzbusQlrqqK4Nm39oNCUV3DY50hVCA1knTgQXvpIyPe2Jy
         5FPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702512744; x=1703117544;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=viMe9kglal5ScjZ1n6jPL3FjIe+JldVfUhvBnQIbEiw=;
        b=D8CZio+MRGYwXdt1yzC+EXu0TIvp+1mZH+pKRzGG5fBVjfrktIioE9vBoNuaMSB0GR
         EfZQInyte2Q6xHlgrHiUoZSz4pnk699fy8jS/q3NPf7q4ZGM5HWc7BGcvgMPYTWWJbKT
         6C4PZhhnov3bD3neiCELeMrlcFtQnsw/LtLE8vmfaqAd/T6QLIeN3Gv2XWGYBgDokXL7
         QXUTvLfn+uGc0DRSzDYeqiFQHZ07xphLAwJUXdwp1Z7job5kju3z+F1tLqF6G6u5VEIw
         csYLCB0ZiKnQH9XtlYeSBComPfloi4YK2lsdzWdbmGKh1rQXAcNzp4JI3WZQszNgBf40
         Q+ug==
X-Gm-Message-State: AOJu0Yy5RXZXtom2yTRWufBoJSDd2JyHoASgMTJlJsv8CHLqGibpbNdO
	cEVf9+KhfZMay/SQxYq58XFKYw==
X-Google-Smtp-Source: AGHT+IEeZevrL+CP3o0k1tCx3qTiITpwRbjE02mFHTMHU0lILBn9xW4aeM0+zn8YH8RqAwIzSvOtZw==
X-Received: by 2002:a05:6a00:2da1:b0:6ce:2731:47b7 with SMTP id fb33-20020a056a002da100b006ce273147b7mr10780615pfb.23.1702512743782;
        Wed, 13 Dec 2023 16:12:23 -0800 (PST)
Received: from ghost ([12.44.203.122])
        by smtp.gmail.com with ESMTPSA id y4-20020a62f244000000b006ce809948adsm10397431pfl.30.2023.12.13.16.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 16:12:23 -0800 (PST)
Date: Wed, 13 Dec 2023 16:12:20 -0800
From: Charlie Jenkins <charlie@rivosinc.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	conor@kernel.org, maskray@google.com, ndesaulniers@google.com,
	linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 3/3] lib/Kconfig.debug: Update AS_HAS_NON_CONST_LEB128
 comment and name
Message-ID: <ZXpIZGE9e6F2d5Hk@ghost>
References: <20231205-riscv-restrict-dwarf5-llvm-v2-0-aedf00a382ac@kernel.org>
 <20231205-riscv-restrict-dwarf5-llvm-v2-3-aedf00a382ac@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205-riscv-restrict-dwarf5-llvm-v2-3-aedf00a382ac@kernel.org>

On Tue, Dec 05, 2023 at 04:53:52PM -0700, Nathan Chancellor wrote:
> Fangrui noted that the comment around CONFIG_AS_HAS_NON_CONST_LEB128
> could be made more accurate because explicit .sleb128 directives are not
> emitted, only .uleb128 directives are. Rename the symbol to
> CONFIG_AS_HAS_NON_CONST_ULEB128 as a result.
> 
> Further clarifications include replacing "symbol deltas" with the more
> accurate "label differences", noting that this issue has been resolved
> in newer binutils (2.41+), and it only occurs when a port uses RISC-V
> style linker relaxation.
> 
> Suggested-by: Fangrui Song <maskray@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  lib/Kconfig.debug | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index a0ebce05a368..76c2cc697573 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -231,9 +231,10 @@ config DEBUG_INFO
>  	  in the "Debug information" choice below, indicating that debug
>  	  information will be generated for build targets.
>  
> -# Clang is known to generate .{s,u}leb128 with symbol deltas with DWARF5, which
> -# some targets may not support: https://sourceware.org/bugzilla/show_bug.cgi?id=27215
> -config AS_HAS_NON_CONST_LEB128
> +# Clang generates .uleb128 with label differences for DWARF v5, a feature that
> +# older binutils ports do not support when utilizing RISC-V style linker
> +# relaxation: https://sourceware.org/bugzilla/show_bug.cgi?id=27215
> +config AS_HAS_NON_CONST_ULEB128
>  	def_bool $(as-instr,.uleb128 .Lexpr_end4 - .Lexpr_start3\n.Lexpr_start3:\n.Lexpr_end4:)

This seems like a good change. However the wording in your commit
message seems misleading. This config only ever checked for .uleb128
with a label difference and would assume that sleb128 with label
differences were supported. This seems more like a "bug" in the config
name that this is fixing. My interpretation is that your commit
describes why this issue was never caught (because sleb128 is not
emitted), but not the root of why this change is necessary (because
non-const sleb128 is not necessarily supported if non-const uleb128 is).
Anyways, it's just a commit message so not something that is important
to change.

Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>

>  
>  choice
> @@ -258,7 +259,7 @@ config DEBUG_INFO_NONE
>  config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
>  	bool "Rely on the toolchain's implicit default DWARF version"
>  	select DEBUG_INFO
> -	depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_LEB128)
> +	depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_ULEB128)
>  	help
>  	  The implicit default version of DWARF debug info produced by a
>  	  toolchain changes over time.
> @@ -283,7 +284,7 @@ config DEBUG_INFO_DWARF5
>  	bool "Generate DWARF Version 5 debuginfo"
>  	select DEBUG_INFO
>  	depends on !ARCH_HAS_BROKEN_DWARF5
> -	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_LEB128)
> +	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_ULEB128)
>  	help
>  	  Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc
>  	  5.0+ accepts the -gdwarf-5 flag but only had partial support for some
> 
> -- 
> 2.43.0
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
