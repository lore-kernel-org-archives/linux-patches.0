Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB275698
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 02:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R3d0rGbK"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-54c77d011acso3269a12.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 18:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701828711; x=1702433511; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TSzJ/eDmpu5qKlh7l7ZmUhxzU0D7hwAbG/bWD2UzWAg=;
        b=R3d0rGbKXsoCBIMxCCu/LgTLsy/L/v3bB+3U10ARG0vpM650AnxQhBJSLLBJmxA0Wc
         iN1FLQ1W2VpDBW/llm8mOFoajbxTsEFhC54v6j0EsS+ikX6YLA56inrx4nckZXeqK9B1
         blL3mOZehka+SM/+P40FYqRhMfY+r25qWUL68GbPYKr8gtfj1zX4V6JQTJNBr3MQ4y/X
         U5KlQCQfPMzTyFUhNL2dzgOqh1hl3chJSDkzfu8it2k9+7y3n9VOFgfO56hznzsPUFrz
         GDXqhvsMweHQORDgbYapesIbTigQM+XlvvQlkvxr7cwwvxzDg/mu4sAILn3e3ps8zSOh
         MOdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701828711; x=1702433511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TSzJ/eDmpu5qKlh7l7ZmUhxzU0D7hwAbG/bWD2UzWAg=;
        b=nzwgrz56Xh5JbC3+yw/iP5xV9X+SLF86jjbgw1aqenPV/OsE3TrbeJDvcBWosD1HOD
         zL3fqQBRe/TK5XhyYrfqUBUznNTVCGQXqWu6IEIcomyHTBm2acxxJju6StpY0PEFWFVd
         +xU2nZZh3QgKteExh0P5W14ZugTGPSLLBNzhSTyR0UlteoX+7VBks78XljunL0Vvr13X
         WGIqym9eh0aUb0jUxpXMh3YSxQ0+8PI4HfPyLUShBHYEwi1rTOp+grDEGrVwFpmj63ro
         w7qB2NlZljvsPX6h4YEl68r+WCmVQ0YRcrMx8BV21qxUpxJJGmnJWr5IwQe7l31111Y5
         GQTg==
X-Gm-Message-State: AOJu0YynWBzujDMc7TbX01BV/jUg+4URITgwqwZxJ+UrPeBCQIC+Ypc1
	9KJFox4koIQtLUHiPa4Qx2mt3iHMkQbKfwgmwHxeYg==
X-Google-Smtp-Source: AGHT+IFzA8RIjLbgincX9lQ/PvllzQCK/mYcCDN7t80oDb+wk/rQpCEl5GkjPt8Q+5aU6plyxvR27GnuD2AjYgQfTS8=
X-Received: by 2002:a50:9f69:0:b0:54b:6b3f:4a86 with SMTP id
 b96-20020a509f69000000b0054b6b3f4a86mr43698edf.4.1701828710837; Tue, 05 Dec
 2023 18:11:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205-riscv-restrict-dwarf5-llvm-v2-0-aedf00a382ac@kernel.org> <20231205-riscv-restrict-dwarf5-llvm-v2-2-aedf00a382ac@kernel.org>
In-Reply-To: <20231205-riscv-restrict-dwarf5-llvm-v2-2-aedf00a382ac@kernel.org>
From: Fangrui Song <maskray@google.com>
Date: Tue, 5 Dec 2023 18:11:38 -0800
Message-ID: <CAFP8O3+-YZaS01NSYt9d2cOVLS-wHk-tMjB8URA0g2GPddy4HQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] riscv: Restrict DWARF5 when building with LLVM to
 known working versions
To: Nathan Chancellor <nathan@kernel.org>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	conor@kernel.org, ndesaulniers@google.com, linux-riscv@lists.infradead.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 3:54=E2=80=AFPM Nathan Chancellor <nathan@kernel.org=
> wrote:
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

LGTM.  loongarch folks can add arch/loongarch/Kconfig after they
finish their R_LARCH_ADD_ULEB128/R_LARCH_SUB_ULEB128 toolchain work.

Reviewed-by: Fangrui Song <maskray@google.com>

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
>


--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
