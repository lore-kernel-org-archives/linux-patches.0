Received: from condef-04.nifty.com (condef-04.nifty.com [202.248.20.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785463C2A;
	Sun,  2 Oct 2022 18:04:34 +0000 (UTC)
Received: from conssluserg-03.nifty.com ([10.126.8.82])by condef-04.nifty.com with ESMTP id 292I0IcH025853;
	Mon, 3 Oct 2022 03:00:18 +0900
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179]) (authenticated)
	by conssluserg-03.nifty.com with ESMTP id 292HxoNp005179;
	Mon, 3 Oct 2022 02:59:51 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 292HxoNp005179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1664733591;
	bh=R7PtaZgk8+x+PYWDXdf99v3/AVCGe2a94wV004hUH6k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=xO0A9g6RUJDnwA9CSB2weCoEo3scGkQp28Ccfl360YU0NCEKRWy8ePTKXF+LpHcCR
	 Qj+uhXnzOk6WVPdOivwCgrAz7CzjtAT2/dm4OAICaja5guzw8Ros+o2qneakR8IlcE
	 eOSnFVXdQxApRAhSyA02do3kR+7Zdc9roadR+3ITb5vb0BgjeSJGf+iL34U8xQ6NH1
	 4M1Vwgd6UeNDob+6avKBE8LCKNKyladdUYnQOT6hdEiL039kktvXWBi2VsTzY6bDYN
	 U8k9p7ishUwJp9e7S4E8ujIUIHoxuF2je2jy5/laGeRgdNtZSoIt28LQeskpSxA1ai
	 7iIt7ux3HRO6w==
X-Nifty-SrcIP: [209.85.167.179]
Received: by mail-oi1-f179.google.com with SMTP id v130so9556859oie.2;
        Sun, 02 Oct 2022 10:59:51 -0700 (PDT)
X-Gm-Message-State: ACrzQf2wztyHq4XxZsgXccYCdXT1cgtAfQ840s46PbdlS9p2c3viNBKG
	isWq90WMo/xWrz2Yf1irnjCvFpRx0BJeK9rOQkc=
X-Google-Smtp-Source: AMsMyM71XYvBGKDOzldQA/iz6nCeMmIE5deiPHcMCnEuC+39NL3vd7LcIFvceQocZO4CUjwu53RMLDmfQcWmNz4h5P4=
X-Received: by 2002:a54:400c:0:b0:34f:9913:262 with SMTP id
 x12-20020a54400c000000b0034f99130262mr2676040oie.287.1664733590046; Sun, 02
 Oct 2022 10:59:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220928182523.3105953-1-nathan@kernel.org> <CAKwvOdmPLqX=oCwg43TYHj=tdoaU5OYc=bO906u=LeqcSrx+Dw@mail.gmail.com>
 <YzS+bQT1zJAUpp/6@dev-arch.thelio-3990X> <CAKwvOdk87wRWoiVjswZPwoLbSm+sYsMW6FHZv+r6MHxLHn0Trw@mail.gmail.com>
In-Reply-To: <CAKwvOdk87wRWoiVjswZPwoLbSm+sYsMW6FHZv+r6MHxLHn0Trw@mail.gmail.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Mon, 3 Oct 2022 02:59:13 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQtS_cVVjsV32S8hQJNER3jN9frnRosz4rfQ6+TkXKUtg@mail.gmail.com>
Message-ID: <CAK7LNAQtS_cVVjsV32S8hQJNER3jN9frnRosz4rfQ6+TkXKUtg@mail.gmail.com>
Subject: Re: [PATCH] lib/Kconfig.debug: Add check for non-constant
 .{s,u}leb128 support to DWARF5
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tom Rix <trix@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, linux-kbuild@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, llvm@lists.linux.dev,
        Conor Dooley <conor.dooley@microchip.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 29, 2022 at 6:53 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Wed, Sep 28, 2022 at 2:36 PM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > On Wed, Sep 28, 2022 at 02:13:47PM -0700, Nick Desaulniers wrote:
> > > Reraising my concern from
> > > https://github.com/ClangBuiltLinux/linux/issues/1719#issuecomment-1258678969
> >
> > Sorry, I thought I addressed your concern with my comment right below it
> > but I probably should have worded it better.
>
> No, I just missed your point about other architectures.
>
> > > We've put a fair amount of work into getting CC=clang LLVM_IAS=0 to
> > > work for DWARF v5 (both on the GNU binutils side, and Kbuild), I'd
> > > hate to see that effectively knee-capped because of an issue in GNU
> > > binutils that is only relevant for one architecture.
> >
> > Sure, that is a completely reasonable concern. However...
> >
> > > I'd concede support for ARCH=riscv, but not for all other
> > > architectures, which this effectively does.
> >
> > No, it does not, CONFIG_AS_HAS_NON_CONST_LEB128 can still be enabled
> > when GNU as supports this construct for a particular architecture; as
> > far as I can tell, RISC-V is the only one that doesn't. See the tests
> > with ARCH=arm64 and ARCH=x86_64 compared with ARCH=riscv below.
>
> Ah, sorry for the noise then. Thanks for the patch.
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>
> --
> Thanks,
> ~Nick Desaulniers




This patch is incomplete.

It looks like Clang 14 switched to DWARF v5 by default.

I see the same errors for
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y





masahiro@zoe:~/ref/linux$ clang --version | head -n1
Ubuntu clang version 14.0.0-1ubuntu1
masahiro@zoe:~/ref/linux$ grep DEBUG_INFO_DWARF .config
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_DEBUG_INFO_DWARF5 is not set
masahiro@zoe:~/ref/linux$ make ARCH=riscv LLVM=1 LLVM_IAS=0
CROSS_COMPILE=riscv64-linux-gnu- -j24
  CALL    scripts/atomic/check-atomics.sh
  CALL    scripts/checksyscalls.sh
  CC      arch/riscv/kernel/vdso/vgettimeofday.o
/tmp/vgettimeofday-5997b4.s: Assembler messages:
/tmp/vgettimeofday-5997b4.s:2698: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2699: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2705: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2706: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2712: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2713: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2719: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2720: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2726: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2727: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2731: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2732: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2736: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2737: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2743: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2744: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2748: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2749: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2755: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2756: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2760: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2761: Error: non-constant .uleb128 is not supported
/tmp/vgettimeofday-5997b4.s:2765: Error: non-constant .uleb128 is not supported
   ...


-- 
Best Regards
Masahiro Yamada
