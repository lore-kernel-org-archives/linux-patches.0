Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B705467D
	for <patches@lists.linux.dev>; Thu, 30 Nov 2023 16:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kvne9/E6"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-40b35199f94so83185e9.0
        for <patches@lists.linux.dev>; Thu, 30 Nov 2023 08:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701361016; x=1701965816; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1WTfd9Dke/wAtrjfd7TJ0XP8He7wb5roBd0D+Jv5G+8=;
        b=Kvne9/E6pJ3KtLuHeCklDlEu0vaIXzxwXtiXOZoY8kz3V7Hj1P874qg54M0hoT8JUi
         UqXfH7MYxYN9DBSWsJEM9If+pFDWylFK2dPXs4wKbA7bX7Upyb4HMvXaVMtyLVcjX4WD
         PqOP+dwRVdIYfV7VohmQ+WTZXGJS+zYvivmagFUy12fD+wXDVMt/hPBeARC4Ej2P/tBI
         ku43mtQJawUY2kVcR++3yiq49+I3CDDnyMtg8koZsQxxVxzvTj1QRYneyDOLJuBhmiE2
         6zMm5ks1z6mMnczg52wzAbbUO6B2CogHyHknCPDOMs7k+uxa5T+6qfGB6w/5D0ZighSO
         ee0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701361016; x=1701965816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1WTfd9Dke/wAtrjfd7TJ0XP8He7wb5roBd0D+Jv5G+8=;
        b=sFVPEx38vkd0u5PBo5Rx50iz/ekRNntu9+XTsAb6jrbXsepaEFINdBlV7Jpdl+GPwZ
         7PygZb/VZyI/HrTTNHKCYXivQbw35wz7pk1ujWZqKA+8LKOlNy3kN1NobXpSuOGnACNd
         PXLoE7kZt0l+O4cN/EDI9ruZbl9bi+pYr4V06G3CdSg/GzUlEjvAWuGL5JHZ+Y4lF3Sj
         NsHpXB5Fr+v6LrN9FoBJbJiawZ6yacb0OToroSYCNMfYCZ5iyFbsBpfyiPKRzWakDnYE
         Vy9RTM69yPVbxd5hRalKzqJJDb2EY2qI7Ocj3LsOyLpq1CrP4+NgUiELNCoZLNMAOWqI
         pa+A==
X-Gm-Message-State: AOJu0YzScrdVzhwM6YB3BE4pEQUKSoI9K9KzNQMk1Te9jr7ni2SlU3Ju
	wv/7q8bd83+VW9qpfh4kWZvJvkRh2uz1S7uzUsjLDw==
X-Google-Smtp-Source: AGHT+IGHXtr/E8NOLWNyZndhRTTrYhJyY0dcj6OSW4gPELV7MTjdbT3NJnNTWIYqXPZBfh1qufpPoy5lX9LAEeCBts0=
X-Received: by 2002:a05:600c:1e15:b0:40b:3483:8488 with SMTP id
 ay21-20020a05600c1e1500b0040b34838488mr135764wmb.3.1701361016285; Thu, 30 Nov
 2023 08:16:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org> <20231129-riscv-restrict-dwarf5-llvm-v1-2-ec0d368fb538@kernel.org>
In-Reply-To: <20231129-riscv-restrict-dwarf5-llvm-v1-2-ec0d368fb538@kernel.org>
From: Fangrui Song <maskray@google.com>
Date: Thu, 30 Nov 2023 08:16:41 -0800
Message-ID: <CAFP8O3JscgacLPX-_pc2J0uhqk=ehtxSNStzo7PwewPSuXkxiw@mail.gmail.com>
Subject: Re: [PATCH 2/2] riscv: Restrict DWARF5 when building with LLVM to
 known working versions
To: Nathan Chancellor <nathan@kernel.org>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	conor@kernel.org, ndesaulniers@google.com, linux-riscv@lists.infradead.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 29, 2023 at 3:30=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> LLVM prior to 18.0.0 would generate incorrect debug info for DWARF5 due
> to linker relaxation, which was worked around in clang by defaulting
> RISC-V to DWARF4 [1]. Unfortunately, this workaround does not work for
> the kernel because the DWARF version can be independently changed from
> the default in Kconfig.
>
> Do not allow DWARF5 to be selected for RISC-V when using linker
> relaxation (ld.lld >=3D 15.0.0) and a version of LLVM that does not have
> the fixes (the integrated assembler [2] and ld.lld [3] < 18.0.0)
> necessary to generate the correct debug info.
>
> Link: https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db16f649=
fc21dd18e5b0918f6 [1]
> Link: https://github.com/llvm/llvm-project/commit/1df5ea29b43690b6622db2c=
ad7b745607ca4de6a [2]
> Link: https://github.com/llvm/llvm-project/commit/7ffabb61a5569444b5ac932=
2e22e5471cc5e4a77 [3]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/riscv/Kconfig | 9 +++++++++
>  lib/Kconfig.debug  | 1 +
>  2 files changed, 10 insertions(+)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 72be1d8122a3..81b473cb47b0 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -186,6 +186,15 @@ config RISCV_USE_LINKER_RELAXATION
>         # https://github.com/llvm/llvm-project/commit/6611d58f5bbcbec7726=
2d392e2923e1d680f6985
>         depends on !LD_IS_LLD || LLD_VERSION >=3D 150000
>
> +# https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db16f649fc2=
1dd18e5b0918f6
> +config ARCH_HAS_BROKEN_DWARF5
> +       def_bool y
> +       depends on RISCV_USE_LINKER_RELAXATION
> +       # https://github.com/llvm/llvm-project/commit/1df5ea29b43690b6622=
db2cad7b745607ca4de6a
> +       depends on AS_IS_LLVM && AS_VERSION < 180000
> +       # https://github.com/llvm/llvm-project/commit/7ffabb61a5569444b5a=
c9322e22e5471cc5e4a77
> +       depends on LD_IS_LLD && LLD_VERSION < 180000
> +
>  config ARCH_MMAP_RND_BITS_MIN
>         default 18 if 64BIT
>         default 8
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index cc7d53d9dc01..a0ebce05a368 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -282,6 +282,7 @@ config DEBUG_INFO_DWARF4
>  config DEBUG_INFO_DWARF5
>         bool "Generate DWARF Version 5 debuginfo"
>         select DEBUG_INFO
> +       depends on !ARCH_HAS_BROKEN_DWARF5
>         depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION=
 >=3D 23502 && AS_HAS_NON_CONST_LEB128)
>         help
>           Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0=
+ (gcc
>
> --
> 2.43.0
>

A comment and "depends on" condition introduced by commit
0a6de78cff600cb991f2a1b7ed376935871796a0 "lib/Kconfig.debug: Add check
for non-constant .{s,u}leb128 support to DWARF5"
can now be refined.

> ib/Kconfig.debug
> (AS_IS_GNU && AS_VERSION >=3D 23502 && AS_HAS_NON_CONST_LEB128)

AS_VERSION can now be 24100.

Thanks for the comment. I just marked
https://sourceware.org/bugzilla/show_bug.cgi?id=3D27215 (" as: Error:
non-constant .uleb128 is not supported on riscv64") as resolved :)

> +# Clang is known to generate .{s,u}leb128 with symbol deltas with DWARF5=
, which
> +# some targets may not support: https://sourceware.org/bugzilla/show_bug=
.cgi?id=3D27215

This comment can be updated:)


--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
