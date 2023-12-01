Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0955A4E605
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 20:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VRC2yF6x"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-40b422a274dso13175e9.0
        for <patches@lists.linux.dev>; Fri, 01 Dec 2023 12:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701461561; x=1702066361; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vwvbU3NbxVoLwq1aUgdhbPcKUW0YvfljLLe46XRPIWI=;
        b=VRC2yF6xJqbiDBM/Dd94wlGzb7SN7DgZrHEvJ2ACtqtNYFno0SziRkNNdjZWGm8Xet
         KdZaZiI3dlnI7AFZRD70opjggcHSR1KAWU5oSqjvIvpvq6c4YnZqfi8y6YEjTUGl+Et7
         WVSVEiP01lyH/R50qVy+5pMx8o7HGYB/Yyq9qiwiSQ+aNKcoiEsf/EvmMi3KbhnlAfoy
         +sm1owaXZg9qwBN/Ab6mT/MT3/D/YIAICyMlYk9jE4lh+likWFOfOC2VwToQ0Ehn0RsN
         2JGmc9I3T/goboZad1uWpC1t3yHucOfzix2ObtPeQQxUsVw9TDo2Bo2hNYiA74wh2WXE
         9nVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701461561; x=1702066361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vwvbU3NbxVoLwq1aUgdhbPcKUW0YvfljLLe46XRPIWI=;
        b=LSY2K37d38Puzu1hEEj6Wa0+OoAuFjYSFIDvbAcW9g9pw9FPFCwPFTJ/6u200/LKGx
         NDL2jjfcG2Sj18rwbAoqXY2ewivJCDiyI5zpFN9mdGTQru2j3+MTwgSBXTNTGvmoCxht
         x+9WmDD2pHzbjds07aM5uycafFa/RP4oJM1X86svl0a6rcGQ9Jw+CnjYQitUUMVOCdNx
         trOBJh0PgdI1qwT5d2WQ/cI4hLxXv3qH6Zj8/Xe24jdEN3Gx688v0oj4GCln0s6qfPWF
         4NTQGLIUEMAT4AOAXAppAcb1LwdhvIEOOj/gOg3r2U1MNLBG63fjjB8BEqjVejxyKjzY
         1N8A==
X-Gm-Message-State: AOJu0YwgAbwESkruu1CFZMFS72kWXDImoRgw76KWL+tPtxUEdGe1c3K+
	HVwmHvcP9nX2+WDoZ94qEEa1ny9sjIb/pG4nTK+/QA==
X-Google-Smtp-Source: AGHT+IFSO1J6OUWZ4PAIR7oz0XqCBsEtAD5/qv01GXRaVlpBcK2jtBS60oRspgP5OTu19AE7wozkkxsK7nkHo1Esl8k=
X-Received: by 2002:a05:600c:54e7:b0:3f7:3e85:36a with SMTP id
 jb7-20020a05600c54e700b003f73e85036amr199679wmb.7.1701461561009; Fri, 01 Dec
 2023 12:12:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org>
 <20231129-riscv-restrict-dwarf5-llvm-v1-2-ec0d368fb538@kernel.org>
 <CAFP8O3JscgacLPX-_pc2J0uhqk=ehtxSNStzo7PwewPSuXkxiw@mail.gmail.com> <20231201194858.GA290910@dev-arch.thelio-3990X>
In-Reply-To: <20231201194858.GA290910@dev-arch.thelio-3990X>
From: Fangrui Song <maskray@google.com>
Date: Fri, 1 Dec 2023 12:12:26 -0800
Message-ID: <CAFP8O3+uta+GQO7dpeNLe0OMFnX-tdEyvHREEu1ThjA3nFtTkQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] riscv: Restrict DWARF5 when building with LLVM to
 known working versions
To: Nathan Chancellor <nathan@kernel.org>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	conor@kernel.org, ndesaulniers@google.com, linux-riscv@lists.infradead.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 1, 2023 at 11:49=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> On Thu, Nov 30, 2023 at 08:16:41AM -0800, Fangrui Song wrote:
> > On Wed, Nov 29, 2023 at 3:30=E2=80=AFPM Nathan Chancellor <nathan@kerne=
l.org> wrote:
> > >
> > > LLVM prior to 18.0.0 would generate incorrect debug info for DWARF5 d=
ue
> > > to linker relaxation, which was worked around in clang by defaulting
> > > RISC-V to DWARF4 [1]. Unfortunately, this workaround does not work fo=
r
> > > the kernel because the DWARF version can be independently changed fro=
m
> > > the default in Kconfig.
> > >
> > > Do not allow DWARF5 to be selected for RISC-V when using linker
> > > relaxation (ld.lld >=3D 15.0.0) and a version of LLVM that does not h=
ave
> > > the fixes (the integrated assembler [2] and ld.lld [3] < 18.0.0)
> > > necessary to generate the correct debug info.
> > >
> > > Link: https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db16=
f649fc21dd18e5b0918f6 [1]
> > > Link: https://github.com/llvm/llvm-project/commit/1df5ea29b43690b6622=
db2cad7b745607ca4de6a [2]
> > > Link: https://github.com/llvm/llvm-project/commit/7ffabb61a5569444b5a=
c9322e22e5471cc5e4a77 [3]
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > >  arch/riscv/Kconfig | 9 +++++++++
> > >  lib/Kconfig.debug  | 1 +
> > >  2 files changed, 10 insertions(+)
> > >
> > > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > > index 72be1d8122a3..81b473cb47b0 100644
> > > --- a/arch/riscv/Kconfig
> > > +++ b/arch/riscv/Kconfig
> > > @@ -186,6 +186,15 @@ config RISCV_USE_LINKER_RELAXATION
> > >         # https://github.com/llvm/llvm-project/commit/6611d58f5bbcbec=
77262d392e2923e1d680f6985
> > >         depends on !LD_IS_LLD || LLD_VERSION >=3D 150000
> > >
> > > +# https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db16f64=
9fc21dd18e5b0918f6
> > > +config ARCH_HAS_BROKEN_DWARF5
> > > +       def_bool y
> > > +       depends on RISCV_USE_LINKER_RELAXATION
> > > +       # https://github.com/llvm/llvm-project/commit/1df5ea29b43690b=
6622db2cad7b745607ca4de6a
> > > +       depends on AS_IS_LLVM && AS_VERSION < 180000
> > > +       # https://github.com/llvm/llvm-project/commit/7ffabb61a556944=
4b5ac9322e22e5471cc5e4a77
> > > +       depends on LD_IS_LLD && LLD_VERSION < 180000
> > > +
> > >  config ARCH_MMAP_RND_BITS_MIN
> > >         default 18 if 64BIT
> > >         default 8
> > > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > > index cc7d53d9dc01..a0ebce05a368 100644
> > > --- a/lib/Kconfig.debug
> > > +++ b/lib/Kconfig.debug
> > > @@ -282,6 +282,7 @@ config DEBUG_INFO_DWARF4
> > >  config DEBUG_INFO_DWARF5
> > >         bool "Generate DWARF Version 5 debuginfo"
> > >         select DEBUG_INFO
> > > +       depends on !ARCH_HAS_BROKEN_DWARF5
> > >         depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VER=
SION >=3D 23502 && AS_HAS_NON_CONST_LEB128)
> > >         help
> > >           Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc=
 5.0+ (gcc
> > >
> > > --
> > > 2.43.0
> > >
> >
> > A comment and "depends on" condition introduced by commit
> > 0a6de78cff600cb991f2a1b7ed376935871796a0 "lib/Kconfig.debug: Add check
> > for non-constant .{s,u}leb128 support to DWARF5"
> > can now be refined.
> >
> > > ib/Kconfig.debug
> > > (AS_IS_GNU && AS_VERSION >=3D 23502 && AS_HAS_NON_CONST_LEB128)
> >
> > AS_VERSION can now be 24100.
>
> That will impact all architectures that use GNU as, even though the
> issue was really only seen on RISC-V. It probably doesn't matter since
> most architectures work with the integrated assembler and that is what
> we tell people to use but I think the current check will continue to
> work.

Agreed.

    depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION
>=3D 23502 && AS_HAS_NON_CONST_LEB128)

is enabled for GCC. The long condition chain is for Clang. Given
Clang's behavior, we can simplify this to

    depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU &&
AS_HAS_NON_CONST_LEB128)

This will still work even after R_LARCH_{ADD,SUB}_ULEB128 support is
added to llvm-project.
This condition matches HAVE_AS_LEB128 in GCC in spirit.

> Alternatively, I could do something like this but it is quite ugly and
> verbose :/
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index a0ebce05a368..aea0ef5a5d1f 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -231,11 +231,6 @@ config DEBUG_INFO
>           in the "Debug information" choice below, indicating that debug
>           information will be generated for build targets.
>
> -# Clang is known to generate .{s,u}leb128 with symbol deltas with DWARF5=
, which
> -# some targets may not support: https://sourceware.org/bugzilla/show_bug=
.cgi?id=3D27215
> -config AS_HAS_NON_CONST_LEB128
> -       def_bool $(as-instr,.uleb128 .Lexpr_end4 - .Lexpr_start3\n.Lexpr_=
start3:\n.Lexpr_end4:)
> -

Consider keeping this config, but just reword the comment.

>  choice
>         prompt "Debug information"
>         depends on DEBUG_KERNEL
> @@ -258,7 +253,7 @@ config DEBUG_INFO_NONE
>  config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
>         bool "Rely on the toolchain's implicit default DWARF version"
>         select DEBUG_INFO
> -       depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 |=
| (AS_IS_GNU && AS_VERSION >=3D 23502 && AS_HAS_NON_CONST_LEB128)
> +       depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 |=
| (AS_IS_GNU && ((!RISCV && AS_VERSION >=3D 23502) || (RISCV && AS_VERSION =
>=3D 24100)))

The RISCV condition would cause additional churn when LoongArch
ULEB128 support is added.

>         help
>           The implicit default version of DWARF debug info produced by a
>           toolchain changes over time.
> @@ -283,7 +278,7 @@ config DEBUG_INFO_DWARF5
>         bool "Generate DWARF Version 5 debuginfo"
>         select DEBUG_INFO
>         depends on !ARCH_HAS_BROKEN_DWARF5
> -       depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION=
 >=3D 23502 && AS_HAS_NON_CONST_LEB128)
> +       depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && ((!RISCV &=
& AS_VERSION >=3D 23502) || (RISCV && AS_VERSION >=3D 24100)))
>         help
>           Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0=
+ (gcc
>           5.0+ accepts the -gdwarf-5 flag but only had partial support fo=
r some



--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
