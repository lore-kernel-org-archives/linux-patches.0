Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5A9BE66
	for <patches@lists.linux.dev>; Sat,  2 Dec 2023 04:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TrfwzsAF"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-40b367a0a12so16525e9.1
        for <patches@lists.linux.dev>; Fri, 01 Dec 2023 20:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701491486; x=1702096286; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xVvA+XfxaSXw1LOLOxF27ECPqWwPbIuTdt5pxpSTVtI=;
        b=TrfwzsAFF8gm5b6YhJJ2bGAuAyx/LFdn8yrauTprQp5q6czBeMkBPLsodG4GK6/Hzs
         Rzr3Gs39vz3kb6KxEIiv/sQAV1dBwdqFp3iv3SkFwyN1hlJdDcmlrtKZO/oPC2fFCjks
         dABYxShycQqFNPSECtMxgT39tGug+C8ar6qzEd1CWBLwSO7bicObW4rr37H5N9QgITAG
         jlTrmlXwVpsXO7yYFDL90M13OkPaG1pXW5Tq4MtQuGhtQZvGZE9g1fqt8ViUijbamGs8
         mJRaF3sdVy7DH5U18gjfvhe3u5UUshXPO2ZdApzHdlr/4ZrGPL8WidoIIvjoofOOzkdo
         K03w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701491486; x=1702096286;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xVvA+XfxaSXw1LOLOxF27ECPqWwPbIuTdt5pxpSTVtI=;
        b=uOjaCOAD3OQAF5911r422I6kEpk1OroNsnB+AudLE/cnegEQJHzjBdN4NAvG8xKG83
         uX75QYIDBQYB0zCIFh7Z+ZexuIfBxx/+ez1cqsRRQ87oI4MVqgbStsrSVGAynkGbpUvA
         WdEMPdoIW9w+kLdYjN1qv07CsZMsgVbhCoarag85THpo5EflgBiweN596C9b3O8n74Da
         c0P4E3cZXlGXNPI8eUh9qnEyawnzeXKXlGg5RG8xJ7npMAiZ6m7odjv1qOvpSp0aDO62
         2vf2h9Vt/0KBRnObzSuDvaannpDHbc37Ps4PRdg7srcIhzuWTC7dBUIs1caUiDcZzolx
         R6YA==
X-Gm-Message-State: AOJu0YxjgJxw3b5By4/bSfXXXvmVtd+ss+QrumqhCOQMNKe0kVAwidJC
	mhQ7ti2+b6C6gYLHNmnpqN3Kcc9l3VI4hCpNUilc0g==
X-Google-Smtp-Source: AGHT+IGZhXPrV5zZD7MMITUMl+i1J2MAf+VqQ3LbjimMEmYuYS/1QgCXy9TruE5THgAQQOMpOJkXklaVozBLg9DISgk=
X-Received: by 2002:a05:600c:35d2:b0:40a:4c7d:f300 with SMTP id
 r18-20020a05600c35d200b0040a4c7df300mr314571wmq.6.1701491486245; Fri, 01 Dec
 2023 20:31:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org>
 <20231129-riscv-restrict-dwarf5-llvm-v1-2-ec0d368fb538@kernel.org>
 <CAFP8O3JscgacLPX-_pc2J0uhqk=ehtxSNStzo7PwewPSuXkxiw@mail.gmail.com>
 <20231201194858.GA290910@dev-arch.thelio-3990X> <CAFP8O3+uta+GQO7dpeNLe0OMFnX-tdEyvHREEu1ThjA3nFtTkQ@mail.gmail.com>
 <20231201215021.GA2579712@dev-arch.thelio-3990X>
In-Reply-To: <20231201215021.GA2579712@dev-arch.thelio-3990X>
From: Fangrui Song <maskray@google.com>
Date: Fri, 1 Dec 2023 20:31:12 -0800
Message-ID: <CAFP8O3LJPqPVxcRzi_Qxvu_w8w76BXmfWv8YnsK+bMvqXb701Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] riscv: Restrict DWARF5 when building with LLVM to
 known working versions
To: Nathan Chancellor <nathan@kernel.org>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	conor@kernel.org, ndesaulniers@google.com, linux-riscv@lists.infradead.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 1, 2023 at 1:50=E2=80=AFPM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> On Fri, Dec 01, 2023 at 12:12:26PM -0800, Fangrui Song wrote:
> > On Fri, Dec 1, 2023 at 11:49=E2=80=AFAM Nathan Chancellor <nathan@kerne=
l.org> wrote:
> > >
> > > On Thu, Nov 30, 2023 at 08:16:41AM -0800, Fangrui Song wrote:
> > > > On Wed, Nov 29, 2023 at 3:30=E2=80=AFPM Nathan Chancellor <nathan@k=
ernel.org> wrote:
> > > > >
> > > > > LLVM prior to 18.0.0 would generate incorrect debug info for DWAR=
F5 due
> > > > > to linker relaxation, which was worked around in clang by default=
ing
> > > > > RISC-V to DWARF4 [1]. Unfortunately, this workaround does not wor=
k for
> > > > > the kernel because the DWARF version can be independently changed=
 from
> > > > > the default in Kconfig.
> > > > >
> > > > > Do not allow DWARF5 to be selected for RISC-V when using linker
> > > > > relaxation (ld.lld >=3D 15.0.0) and a version of LLVM that does n=
ot have
> > > > > the fixes (the integrated assembler [2] and ld.lld [3] < 18.0.0)
> > > > > necessary to generate the correct debug info.
> > > > >
> > > > > Link: https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1=
db16f649fc21dd18e5b0918f6 [1]
> > > > > Link: https://github.com/llvm/llvm-project/commit/1df5ea29b43690b=
6622db2cad7b745607ca4de6a [2]
> > > > > Link: https://github.com/llvm/llvm-project/commit/7ffabb61a556944=
4b5ac9322e22e5471cc5e4a77 [3]
> > > > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > > > ---
> > > > >  arch/riscv/Kconfig | 9 +++++++++
> > > > >  lib/Kconfig.debug  | 1 +
> > > > >  2 files changed, 10 insertions(+)
> > > > >
> > > > > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > > > > index 72be1d8122a3..81b473cb47b0 100644
> > > > > --- a/arch/riscv/Kconfig
> > > > > +++ b/arch/riscv/Kconfig
> > > > > @@ -186,6 +186,15 @@ config RISCV_USE_LINKER_RELAXATION
> > > > >         # https://github.com/llvm/llvm-project/commit/6611d58f5bb=
cbec77262d392e2923e1d680f6985
> > > > >         depends on !LD_IS_LLD || LLD_VERSION >=3D 150000
> > > > >
> > > > > +# https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db1=
6f649fc21dd18e5b0918f6
> > > > > +config ARCH_HAS_BROKEN_DWARF5
> > > > > +       def_bool y
> > > > > +       depends on RISCV_USE_LINKER_RELAXATION
> > > > > +       # https://github.com/llvm/llvm-project/commit/1df5ea29b43=
690b6622db2cad7b745607ca4de6a
> > > > > +       depends on AS_IS_LLVM && AS_VERSION < 180000
> > > > > +       # https://github.com/llvm/llvm-project/commit/7ffabb61a55=
69444b5ac9322e22e5471cc5e4a77
> > > > > +       depends on LD_IS_LLD && LLD_VERSION < 180000
> > > > > +
> > > > >  config ARCH_MMAP_RND_BITS_MIN
> > > > >         default 18 if 64BIT
> > > > >         default 8
> > > > > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > > > > index cc7d53d9dc01..a0ebce05a368 100644
> > > > > --- a/lib/Kconfig.debug
> > > > > +++ b/lib/Kconfig.debug
> > > > > @@ -282,6 +282,7 @@ config DEBUG_INFO_DWARF4
> > > > >  config DEBUG_INFO_DWARF5
> > > > >         bool "Generate DWARF Version 5 debuginfo"
> > > > >         select DEBUG_INFO
> > > > > +       depends on !ARCH_HAS_BROKEN_DWARF5
> > > > >         depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS=
_VERSION >=3D 23502 && AS_HAS_NON_CONST_LEB128)
> > > > >         help
> > > > >           Generate DWARF v5 debug info. Requires binutils 2.35.2,=
 gcc 5.0+ (gcc
> > > > >
> > > > > --
> > > > > 2.43.0
> > > > >
> > > >
> > > > A comment and "depends on" condition introduced by commit
> > > > 0a6de78cff600cb991f2a1b7ed376935871796a0 "lib/Kconfig.debug: Add ch=
eck
> > > > for non-constant .{s,u}leb128 support to DWARF5"
> > > > can now be refined.
> > > >
> > > > > ib/Kconfig.debug
> > > > > (AS_IS_GNU && AS_VERSION >=3D 23502 && AS_HAS_NON_CONST_LEB128)
> > > >
> > > > AS_VERSION can now be 24100.
> > >
> > > That will impact all architectures that use GNU as, even though the
> > > issue was really only seen on RISC-V. It probably doesn't matter sinc=
e
> > > most architectures work with the integrated assembler and that is wha=
t
> > > we tell people to use but I think the current check will continue to
> > > work.
> >
> > Agreed.
> >
> >     depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION
> > >=3D 23502 && AS_HAS_NON_CONST_LEB128)
> >
> > is enabled for GCC. The long condition chain is for Clang. Given
> > Clang's behavior, we can simplify this to
> >
> >     depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU &&
> > AS_HAS_NON_CONST_LEB128)
>
> I think we still need the version check due to
> https://sourceware.org/bugzilla/show_bug.cgi?id=3D25611, which was added
> in commit 98cd6f521f10 ("Kconfig: allow explicit opt in to DWARF v5").

I see...

> > This will still work even after R_LARCH_{ADD,SUB}_ULEB128 support is
> > added to llvm-project.
> > This condition matches HAVE_AS_LEB128 in GCC in spirit.
> >
> > > Alternatively, I could do something like this but it is quite ugly an=
d
> > > verbose :/
> > >
> > > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > > index a0ebce05a368..aea0ef5a5d1f 100644
> > > --- a/lib/Kconfig.debug
> > > +++ b/lib/Kconfig.debug
> > > @@ -231,11 +231,6 @@ config DEBUG_INFO
> > >           in the "Debug information" choice below, indicating that de=
bug
> > >           information will be generated for build targets.
> > >
> > > -# Clang is known to generate .{s,u}leb128 with symbol deltas with DW=
ARF5, which
> > > -# some targets may not support: https://sourceware.org/bugzilla/show=
_bug.cgi?id=3D27215
> > > -config AS_HAS_NON_CONST_LEB128
> > > -       def_bool $(as-instr,.uleb128 .Lexpr_end4 - .Lexpr_start3\n.Le=
xpr_start3:\n.Lexpr_end4:)
> > > -
> >
> > Consider keeping this config, but just reword the comment.
>
> Do you have a suggestion for how it should be reworded? I am struggling
> to come up with something that conveys additional information in a
> succinct manner.

Perhaps: Clang generates .uleb128 with label differences for DWARF v5,
a feature that older binutils ports, utilizing RISC-V style linker
relaxation, do not support.

(Signed LEB128 is used by DWARF as well, but it is encoded directly
into DW_OP_fbreg/DW_LNS_advance_line/etc, and explicit .sleb128
directives are not emitted)
(In assemblers, "label difference" is a more common term.)
(People working on DWARF tend to prefer DWARF v5 to DWARF5, when the
full "DWARF version 5" feels too verbose.)

> > >  choice
> > >         prompt "Debug information"
> > >         depends on DEBUG_KERNEL
> > > @@ -258,7 +253,7 @@ config DEBUG_INFO_NONE
> > >  config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
> > >         bool "Rely on the toolchain's implicit default DWARF version"
> > >         select DEBUG_INFO
> > > -       depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 1400=
00 || (AS_IS_GNU && AS_VERSION >=3D 23502 && AS_HAS_NON_CONST_LEB128)
> > > +       depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 1400=
00 || (AS_IS_GNU && ((!RISCV && AS_VERSION >=3D 23502) || (RISCV && AS_VERS=
ION >=3D 24100)))
> >
> > The RISCV condition would cause additional churn when LoongArch
> > ULEB128 support is added.
>
> Ah, I did not realize that LoongArch would have the same issue. This is
> definitely not the right way to go for that then.
>
> > >         help
> > >           The implicit default version of DWARF debug info produced b=
y a
> > >           toolchain changes over time.
> > > @@ -283,7 +278,7 @@ config DEBUG_INFO_DWARF5
> > >         bool "Generate DWARF Version 5 debuginfo"
> > >         select DEBUG_INFO
> > >         depends on !ARCH_HAS_BROKEN_DWARF5
> > > -       depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VER=
SION >=3D 23502 && AS_HAS_NON_CONST_LEB128)
> > > +       depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && ((!RIS=
CV && AS_VERSION >=3D 23502) || (RISCV && AS_VERSION >=3D 24100)))
> > >         help
> > >           Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc=
 5.0+ (gcc
> > >           5.0+ accepts the -gdwarf-5 flag but only had partial suppor=
t for some
>
> Cheers,
> Nathan
>


--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
