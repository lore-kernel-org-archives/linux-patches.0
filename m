Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE93917727
	for <patches@lists.linux.dev>; Wed, 16 Aug 2023 22:35:18 +0000 (UTC)
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-48a50725641so633827e0c.1
        for <patches@lists.linux.dev>; Wed, 16 Aug 2023 15:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692225317; x=1692830117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7SX8jlMVqMi1+mLRoYyUfc72SUd+crYgBsYv56+9V6E=;
        b=EfLFo/b41aCL09FPShvIG4tmRfEM0AwoIXv4zJi49BVDrF9iPI0A8tbq7wR4GQ0e9p
         oivgK7oz9AKcXdl2AHm4mwT2RWJEekqG5ehDH0h1D2QkJmPpDLbEgyyHCyZLK1PmVn3e
         zovIeprLeYevzeyj5NnQkJKitard3wRxq1Pejhayb3ju9rtFqyqs28IVC0TJIMjgED+n
         5seVZQzsp70BDVbVQDuVR9Va4sPDH8z1COdrb2bVRzEbIxHnHvfdk724UhKH9YayP2np
         +JMvf40D3KN/T+WBRDVcd3vov+V6HWZTYVP8sbiRt4HJWrQb8+IndhjuTc1UXuyD23Tz
         PTxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692225317; x=1692830117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7SX8jlMVqMi1+mLRoYyUfc72SUd+crYgBsYv56+9V6E=;
        b=ZZwYCi+jOkGTPzPc47VHZRyAFtzBZ6L+oAYm1D7IPn/1DG5h7v/qh1/I/tac97WgUk
         CrrPI3v6fyo/Y3RrdGSKEKmhddYArYCsp+kuho76g4zUzuA0PI4RbLc7vda/SOy2/HWh
         oljsYZUZs/OXoyJgjY2r3vpLxLRaNtPjRDHwYz2GXXsN6JCENREa5l/K2XKpLo6ljlo7
         nzCpf0ACXU7eG+d02+jy9GGpJE7n3SahdtZxLe60Qdw2c+re3zwWszOg9kmm6woVnXiS
         WC5lSov+Fb8zJ0tUzQopYir4C9cni51TrDHFxvb/P8DzKmQFpyq4L6AMpgLBHeFySmli
         jjNQ==
X-Gm-Message-State: AOJu0Yxr1c44IsENAd8sW1KsuabQLXgSZVInufH+Nx3US1FvTpepvB2b
	E34lsRS3A8Ypp4BRE/OfrC2u8YX2Rj/0zzRkXht8WQ==
X-Google-Smtp-Source: AGHT+IGxyLfu+paRIoexaD6++oCBn/XHtUBIo0chldIV2SAMVOqAwfY5RYFRwl6Gb08X8o6pYt8fWuN4GCV6exZuHyU=
X-Received: by 2002:a67:f299:0:b0:446:a2f8:9fe4 with SMTP id
 m25-20020a67f299000000b00446a2f89fe4mr2962206vsk.16.1692225317332; Wed, 16
 Aug 2023 15:35:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230816-riscv-debug_info_split-v1-1-d1019d6ccc11@kernel.org> <20230816220457.kqzlbiibeomvki4y@google.com>
In-Reply-To: <20230816220457.kqzlbiibeomvki4y@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 16 Aug 2023 15:35:06 -0700
Message-ID: <CAKwvOdnRb1OmLWNWnj5f-r-rqL0=OsBXJV9d7OU3bjXtOLLtiA@mail.gmail.com>
Subject: Re: [PATCH] lib/Kconfig.debug: Restrict DEBUG_INFO_SPLIT for RISC-V
To: Fangrui Song <maskray@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, akpm@linux-foundation.org, conor@kernel.org, 
	trix@redhat.com, linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 16, 2023 at 3:05=E2=80=AFPM Fangrui Song <maskray@google.com> w=
rote:
>
> On 2023-08-16, Nathan Chancellor wrote:
> >When building for ARCH=3Driscv using LLVM < 14, there is an error with
> >CONFIG_DEBUG_INFO_SPLIT=3Dy:
> >
> >  error: A dwo section may not contain relocations
> >
> >This was worked around in LLVM 15 by disallowing '-gsplit-dwarf' with
> >'-mrelax' (the default), so CONFIG_DEBUG_INFO_SPLIT is not selectable
> >with newer versions of LLVM:
> >
> >  $ clang --target=3Driscv64-linux-gnu -gsplit-dwarf -c -o /dev/null -x =
c /dev/null
> >  clang: error: -gsplit-dwarf is unsupported with RISC-V linker relaxati=
on (-mrelax)
> >
> >GCC silently had a similar issue that was resolved with GCC 12.x.
> >Restrict CONFIG_DEBUG_INFO_SPLIT for RISC-V when using LLVM or GCC <
> >12.x to avoid these known issues.
> >
> >Link: https://github.com/ClangBuiltLinux/linux/issues/1914
> >Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D99090
> >Reported-by: kernel test robot <lkp@intel.com>
> >Closes: https://lore.kernel.org/all/202308090204.9yZffBWo-lkp@intel.com/
> >Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> >---
> >Since this only impacts RISC-V, it seems reasonable that this would go
> >in via their tree but I have added Andrew in case he wants to take it.
> >---
> > lib/Kconfig.debug | 5 +++++
> > 1 file changed, 5 insertions(+)
> >
> >diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> >index d6798513a8c2..bd51274f4771 100644
> >--- a/lib/Kconfig.debug
> >+++ b/lib/Kconfig.debug
> >@@ -355,6 +355,11 @@ endchoice # "Compressed Debug information"
> > config DEBUG_INFO_SPLIT
> >       bool "Produce split debuginfo in .dwo files"
> >       depends on $(cc-option,-gsplit-dwarf)
> >+      # RISC-V linker relaxation + -gsplit-dwarf has issues with LLVM a=
nd GCC
> >+      # prior to 12.x:
> >+      # https://github.com/llvm/llvm-project/issues/56642
> >+      # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D99090
> >+      depends on !RISCV || GCC_VERSION >=3D 120000

Thanks for the patch. I was initially surprised to see no explicit
check for LLVM version.  Rereading the commit description a few times,
I think it makes sense, but I'm guessing we may need to rework this
condition again should we eventually get split debug info working for
riscv for llvm.  I am looking to enable split debug info for kernels
for Android's next release.

Fangrui, any thoughts on feasibility for `-mrelax` and `-gsplit-dwarf`
composability for llvm?

Link: https://github.com/llvm/llvm-project/issues/56642
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> >       help
> >         Generate debug info into separate .dwo files. This significantl=
y
> >         reduces the build directory size for builds with DEBUG_INFO,
> >
> >---
> >base-commit: 2ccdd1b13c591d306f0401d98dedc4bdcd02b421
> >change-id: 20230816-riscv-debug_info_split-0713571a1ac2
> >
> >Best regards,
> >--
> >Nathan Chancellor <nathan@kernel.org>
> >
>
> LGTM as the author of the Clang mitigation
> (https://github.com/llvm/llvm-project/issues/56642) and several recent
> LLVM assembler side linker relaxation improvement (I continue updating
> https://maskray.me/blog/2021-03-14-the-dark-side-of-riscv-linker-relaxati=
on
> about the complication of linker relaxation).
>
> Reviewed-by: Fangrui Song <maskray@google.com>



--=20
Thanks,
~Nick Desaulniers
