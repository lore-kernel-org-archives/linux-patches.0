Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABD8D2F1
	for <patches@lists.linux.dev>; Wed, 16 Aug 2023 22:41:27 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-407db3e9669so63011cf.1
        for <patches@lists.linux.dev>; Wed, 16 Aug 2023 15:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692225686; x=1692830486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e9Paa0v1ravHMTVpZPXZD6S/7y0k3tuVxrGRZui4T4g=;
        b=yuLIbWj0ndGCTBfEUMxmcy1U7qRYzAnlX/r6cAI7WSDFr7lJ44BoAPmVuafCxmBXGs
         Yl1kLoMVmA7fH1aP/ZTBsICyEGWKwk8EpcjIXyFqfNUbTCRqO38tM3b0JqAcgHFRnwwo
         scyChh4+23DL0RmOpkKY9VRAcecrBSauNl4oEShfb79Je7PNRNluHfm577nAcvCjamVD
         3QfOrl5015SDHhfKdR20bfWe0ZxNy1t24yfR+Q1dAedSbLKfIP01s8q7u7Vh1M3H8P6Y
         VwD2v5GTeNpsbomGnP1xwatyxwcdFXhjlZaT2gQxJZe7HBEXRtbBOgVgCLUTriT0RRAo
         8cFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692225686; x=1692830486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e9Paa0v1ravHMTVpZPXZD6S/7y0k3tuVxrGRZui4T4g=;
        b=ZHV4Fq8qDRwH/vUOE/eKUccdwagKDIh/e8hXMj5OqzsfnadSLQ5gbfZVBP4rNLf3aP
         dVohKc/7abGtZQUcedxtEvsi2TAyzlrXpU20sdrq56+cihSD2Yw3+/PkfXBusCRKfxdG
         1WuVAAuIMB0umFQLN8INz/RHpIR/UVlX/l5ifYPSvrzcqttTxzFPqAeigbY5zidDXOxt
         YEX8wAVSshEBWFkMjluqhyo7vm7sfS1LCfUH8n3ZpqsBmXQfVF+0FB6gOsCQ0bOjTVfQ
         xu1zIaAj2rAH6Y5ClXjTNImhW+rnFcjkFim/D6nfwGosFER054cGZWy6fq1J2yT7pdJF
         sKYw==
X-Gm-Message-State: AOJu0YwD9vmv3h5BEhLLO5+7OyLfOiBZTp7ut63njs6CZdySVDe1ODdn
	FEuvQL08xKSjx1ig/hOV2iMHj+rW6A7rEVW+jWl4yw==
X-Google-Smtp-Source: AGHT+IF6JWEDCSKLUVNR5Pubq/VVpxeJie1GCRuH7hfHz3D8W3HCTN8Rw035Pu4ZVTdsuvdT6cFcRsGo+kakuONFvqs=
X-Received: by 2002:a05:622a:1b89:b0:3f8:e0a:3e66 with SMTP id
 bp9-20020a05622a1b8900b003f80e0a3e66mr60587qtb.3.1692225686462; Wed, 16 Aug
 2023 15:41:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230816-riscv-debug_info_split-v1-1-d1019d6ccc11@kernel.org>
 <20230816220457.kqzlbiibeomvki4y@google.com> <CAKwvOdnRb1OmLWNWnj5f-r-rqL0=OsBXJV9d7OU3bjXtOLLtiA@mail.gmail.com>
In-Reply-To: <CAKwvOdnRb1OmLWNWnj5f-r-rqL0=OsBXJV9d7OU3bjXtOLLtiA@mail.gmail.com>
From: Fangrui Song <maskray@google.com>
Date: Wed, 16 Aug 2023 15:41:15 -0700
Message-ID: <CAFP8O3LzmUQNHMPKwW6cz05hdC576WbbUsrBSkWMTSMc=P1vaQ@mail.gmail.com>
Subject: Re: [PATCH] lib/Kconfig.debug: Restrict DEBUG_INFO_SPLIT for RISC-V
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, akpm@linux-foundation.org, conor@kernel.org, 
	trix@redhat.com, linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 16, 2023 at 3:35=E2=80=AFPM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Wed, Aug 16, 2023 at 3:05=E2=80=AFPM Fangrui Song <maskray@google.com>=
 wrote:
> >
> > On 2023-08-16, Nathan Chancellor wrote:
> > >When building for ARCH=3Driscv using LLVM < 14, there is an error with
> > >CONFIG_DEBUG_INFO_SPLIT=3Dy:
> > >
> > >  error: A dwo section may not contain relocations
> > >
> > >This was worked around in LLVM 15 by disallowing '-gsplit-dwarf' with
> > >'-mrelax' (the default), so CONFIG_DEBUG_INFO_SPLIT is not selectable
> > >with newer versions of LLVM:
> > >
> > >  $ clang --target=3Driscv64-linux-gnu -gsplit-dwarf -c -o /dev/null -=
x c /dev/null
> > >  clang: error: -gsplit-dwarf is unsupported with RISC-V linker relaxa=
tion (-mrelax)
> > >
> > >GCC silently had a similar issue that was resolved with GCC 12.x.
> > >Restrict CONFIG_DEBUG_INFO_SPLIT for RISC-V when using LLVM or GCC <
> > >12.x to avoid these known issues.
> > >
> > >Link: https://github.com/ClangBuiltLinux/linux/issues/1914
> > >Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D99090
> > >Reported-by: kernel test robot <lkp@intel.com>
> > >Closes: https://lore.kernel.org/all/202308090204.9yZffBWo-lkp@intel.co=
m/
> > >Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > >---
> > >Since this only impacts RISC-V, it seems reasonable that this would go
> > >in via their tree but I have added Andrew in case he wants to take it.
> > >---
> > > lib/Kconfig.debug | 5 +++++
> > > 1 file changed, 5 insertions(+)
> > >
> > >diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > >index d6798513a8c2..bd51274f4771 100644
> > >--- a/lib/Kconfig.debug
> > >+++ b/lib/Kconfig.debug
> > >@@ -355,6 +355,11 @@ endchoice # "Compressed Debug information"
> > > config DEBUG_INFO_SPLIT
> > >       bool "Produce split debuginfo in .dwo files"
> > >       depends on $(cc-option,-gsplit-dwarf)
> > >+      # RISC-V linker relaxation + -gsplit-dwarf has issues with LLVM=
 and GCC
> > >+      # prior to 12.x:
> > >+      # https://github.com/llvm/llvm-project/issues/56642
> > >+      # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D99090
> > >+      depends on !RISCV || GCC_VERSION >=3D 120000
>
> Thanks for the patch. I was initially surprised to see no explicit
> check for LLVM version.  Rereading the commit description a few times,
> I think it makes sense, but I'm guessing we may need to rework this
> condition again should we eventually get split debug info working for
> riscv for llvm.  I am looking to enable split debug info for kernels
> for Android's next release.
>
> Fangrui, any thoughts on feasibility for `-mrelax` and `-gsplit-dwarf`
> composability for llvm?

Yes, this should be feasible and is on my radar
(https://github.com/llvm/llvm-project/issues/56642#issuecomment-1548421026)=
.

It's the next thing I'll do in my spare time after DWARF v5 & linker
relaxation interop: https://reviews.llvm.org/D157657

> Link: https://github.com/llvm/llvm-project/issues/56642
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>
> > >       help
> > >         Generate debug info into separate .dwo files. This significan=
tly
> > >         reduces the build directory size for builds with DEBUG_INFO,
> > >
> > >---
> > >base-commit: 2ccdd1b13c591d306f0401d98dedc4bdcd02b421
> > >change-id: 20230816-riscv-debug_info_split-0713571a1ac2
> > >
> > >Best regards,
> > >--
> > >Nathan Chancellor <nathan@kernel.org>
> > >
> >
> > LGTM as the author of the Clang mitigation
> > (https://github.com/llvm/llvm-project/issues/56642) and several recent
> > LLVM assembler side linker relaxation improvement (I continue updating
> > https://maskray.me/blog/2021-03-14-the-dark-side-of-riscv-linker-relaxa=
tion
> > about the complication of linker relaxation).
> >
> > Reviewed-by: Fangrui Song <maskray@google.com>
>
>
>
> --
> Thanks,
> ~Nick Desaulniers



--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
