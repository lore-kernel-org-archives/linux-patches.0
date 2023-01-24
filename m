Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653618839
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 15:57:48 +0000 (UTC)
Received: by mail-vk1-f170.google.com with SMTP id t2so7810715vkk.9
        for <patches@lists.linux.dev>; Tue, 24 Jan 2023 07:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rt1mrhGHV+ldz6z6aqQgrdha6p8O6lh39DequDEH0yE=;
        b=IjSHFd+Vn2/fkqTe5+VAtDGku8zfUzzP+8BcO4Ir/3IcZDAaLVJDmxAiuWr2TeDmu/
         ER8u67yjuXwboLQIohzs9q9q1U8SE5E7/7s+Pv3PzURjz8lKjKh1Eyw2sCA+nfffpozh
         oBLz26dFnnbIza3QIq1HQGbQJxHUclbHsX0HHmw+2UwCK4HgVmT7eBRt5kQXMl8aWJPU
         53X0p2ObmgjnPCvPVjyX82MDF3oQqeH/KGnjC+1w+O3TOzWdD/WVf6/Owmgsoetq0Wy3
         sIBOTe1z/WpXqq2CUItkNHyMPU+iKp8/asuaastuRVXBBfC7o/8fAKX0eCgvfau5MO7X
         FUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rt1mrhGHV+ldz6z6aqQgrdha6p8O6lh39DequDEH0yE=;
        b=rT+hoiQBPxvjEOYcRLTMp0wKMSEGQsJ+8oQth5+FruswePtQu+taqoHAQ4U/i82nQ2
         GZhTfbXYIj5A/7s5MHv3/xFCTbsDKKufXEM3+LaknTc2ohSx57/A4AXsya40riFoYknQ
         UwiMmYsuf2tIqyxrKMS6UXip4TfT9A4/20DyRi+P8DKahfKXlUv+KDmV1IrxUxM3k/Lc
         f+mDbdCw608CBRRRX5rIL9Up0Spkcg7J2i6WDnuXz+MnXucBE7/5bCQFtH4lyLzKHkje
         vceDhfmUi0q46vANKQtiz8MoSeDQoFGZiJ6+Q1XGDn3bKj/IqPDt7UxefKoKbfZdDXn+
         1GUQ==
X-Gm-Message-State: AFqh2krSpS7plLvMhe4XOWj21ii6hZI8tQsrUtUMCgLJJN5ARonSuvLl
	fpW5K2UnDJzrBVn6T4k5V7IHk2tV02bnmiaz1bX6Uw==
X-Google-Smtp-Source: AMrXdXtqs9pmeYKVlp5gkQOIDBOvbJ1s4bxzVrVQmF0oYHrigv63uukiEf1yx9kbm/7UGTA+8RQ5NOhfeA5Sc0vj+8s=
X-Received: by 2002:a1f:2e58:0:b0:3e1:5761:fdbb with SMTP id
 u85-20020a1f2e58000000b003e15761fdbbmr3626747vku.7.1674575867112; Tue, 24 Jan
 2023 07:57:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230122150246.321043584@linuxfoundation.org> <CA+G9fYsS1GLzMoeh-jz8eOMbomJ=XBg_3FjQ+4w_=Dw1Mwr3rQ@mail.gmail.com>
 <20230123191128.ewfyc5cdbbdx5gtl@oracle.com> <20230123194218.47ssfzhrpnv3xfez@oracle.com>
 <CA+G9fYvLh=epzy_KEZObfFn1kVCugKvuVWF08X9eEiPe4ehe3g@mail.gmail.com> <20230124125445.gqko2lyvp3vmecto@oracle.com>
In-Reply-To: <20230124125445.gqko2lyvp3vmecto@oracle.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 24 Jan 2023 21:27:35 +0530
Message-ID: <CA+G9fYvOdYfsvprxtFqdGdfBOK88CDRU4i=d6aH1WBUc+tZ5RQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
To: Tom Saeger <tom.saeger@oracle.com>
Cc: Rich Felker <dalias@libc.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	Masahiro Yamada <masahiroy@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Dennis Gilmore <dennis@ausil.us>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Arnd Bergmann <arnd@arndb.de>, linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Jan 2023 at 18:25, Tom Saeger <tom.saeger@oracle.com> wrote:
>
> On Tue, Jan 24, 2023 at 05:41:22PM +0530, Naresh Kamboju wrote:
> > Hi Tom,
> >
> > On Tue, 24 Jan 2023 at 01:12, Tom Saeger <tom.saeger@oracle.com> wrote:
> > >
> > > On Mon, Jan 23, 2023 at 01:11:32PM -0600, Tom Saeger wrote:
> > > > On Mon, Jan 23, 2023 at 01:39:11PM +0530, Naresh Kamboju wrote:
> > > > > On Sun, 22 Jan 2023 at 20:51, Greg Kroah-Hartman
> > > > >
> > > > > Results from Linaro=E2=80=99s test farm.
> > > > >
> > > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > > >
> > > > > * sh, build
> > > > >   - gcc-8-dreamcast_defconfig
> > > > >   - gcc-8-microdev_defconfig
> > > >
> > > > Naresh, any chance you could test again adding the following:
> > > >
> > > > diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.=
lds.S
> > > > index 3161b9ccd2a5..b6276a3521d7 100644
> > > > --- a/arch/sh/kernel/vmlinux.lds.S
> > > > +++ b/arch/sh/kernel/vmlinux.lds.S
> > > > @@ -4,6 +4,7 @@
> > > >   * Written by Niibe Yutaka and Paul Mundt
> > > >   */
> > > >  OUTPUT_ARCH(sh)
> > > > +#define RUNTIME_DISCARD_EXIT
> > > >  #include <asm/thread_info.h>
> > > >  #include <asm/cache.h>
> > > >  #include <asm/vmlinux.lds.h>
> > > >
> > > >
> > > > My guess is build environment is using ld < 2.36??
> > > > and this is probably similar to:
> > > > a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error =
with GNU ld < 2.36")
> > > > 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT")
> > > >
> > > >
> > > > Regards,
> > > >
> > > > --Tom
> > > >
> > > > >
> > > > >
> > > > > Build error logs:
> > > > > `.exit.text' referenced in section `__bug_table' of crypto/algbos=
s.o:
> > > > > defined in discarded section `.exit.text' of crypto/algboss.o
> > > > > `.exit.text' referenced in section `__bug_table' of
> > > > > drivers/char/hw_random/core.o: defined in discarded section
> > > > > `.exit.text' of drivers/char/hw_random/core.o
> > > > > make[2]: *** [/builds/linux/scripts/Makefile.vmlinux:34: vmlinux]=
 Error 1
> > >
> > >
> > > This is also occurring in latest upstream:
> >
> > Right !
> > build/gcc-8-dreamcast_defconfig
> > build/gcc-8-microdev_defconfig
> >
> > These build errors started from v6.2-rc2 on the mainline [1] & [2].
> >
> > >
> > > =E2=9D=AF git describe HEAD
> > > v6.2-rc5-13-g2475bf0250de
> > >
> > > =E2=9D=AF tuxmake --runtime podman --target-arch sh --toolchain gcc-8=
 --kconfig microdev_defconfig
> > >
> > > `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:=
 defined in discarded section `.exit.text' of crypto/algboss.o
> > > `.exit.text' referenced in section `__bug_table' of drivers/char/hw_r=
andom/core.o: defined in discarded section `.exit.text' of drivers/char/hw_=
random/core.o
> > > make[2]: *** [/home2/tsaeger/linux/linux-upstream/scripts/Makefile.vm=
linux:35: vmlinux] Error 1
> > > make[2]: Target '__default' not remade because of errors.
> > > make[1]: *** [/home2/tsaeger/linux/linux-upstream/Makefile:1264: vmli=
nux] Error 2
> > > make[1]: Target '__all' not remade because of errors.
> > > make: *** [Makefile:242: __sub-make] Error 2
> > > make: Target '__all' not remade because of errors.
> > >
> > >
> > > FWIW, the above patch resolves this.
> > Yes. Tested and confirmed it fixes the reported problem.
> >
> > > How many more architectures need something similar?
> > Now I see it on sh with gcc-8 only on the mainline.
> >
> > OTOH,
> > It was noticed on earlier stable-rc 5.4 for x86, i386, powerpc, sh and =
s390.
> >
> > git_describe : v5.4.228-679-g79cbaf4448f3
> > kernel_version: 5.4.230-rc1
> >
> > Regressions found on sh: [1] & [2] mainline and below
> >     - build/gcc-8-dreamcast_defconfig
> >     - build/gcc-8-microdev_defconfig
> >
> > Regressions found on i386: [3]
> >     - build/gcc-8-i386_defconfig
> >
> > Regressions found on powerpc:  [4]
> >     - build/gcc-8-mpc83xx_defconfig
> >     - build/gcc-8-ppc64e_defconfig
> >     - build/gcc-8-maple_defconfig
> >     - build/gcc-8-ppc6xx_defconfig
> >     - build/gcc-8-defconfig
> >     - build/gcc-8-tqm8xx_defconfig
> >     - build/gcc-8-cell_defconfig
> >
> > Regressions found on s390: [5]
> >     - build/gcc-8-defconfig-fe40093d
> >
> > Regressions found on x86_64: [6]
> >     - build/gcc-8-x86_64_defconfig
>
> v5.4 needs:
> 84d5f77fc2ee ("x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to generic DISC=
ARDS")
>
> which didn't hit Linus's tree until: v5.7-rc1~164^2~1
> This explains why v5.4 blew-up and v5.10 didn't.
>
> I'm testing the following for v5.4
>
> 84d5f77fc2ee ("x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to generic DISC=
ARDS")
> This needed a little massaging to apply.
>
> 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
> 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT")
> 07b050f9290e ("powerpc/vmlinux.lds: Don't discard .rela* for relocatable =
builds")
> a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error with G=
NU ld < 2.36")
> + the arch/sh patch https://lore.kernel.org/all/9166a8abdc0f979e50377e617=
80a4bba1dfa2f52.1674518464.git.tom.saeger@oracle.com/
>
>
> I'd be grateful if you could confirm - so I can send this full series to
> Greg.
>
> If you'd rather - I can send the patch-series now for testing?

Please send your repo and branch. I will pick up and run tests on it.

- Naresh
