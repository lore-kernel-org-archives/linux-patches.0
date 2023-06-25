Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF59814263
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 20:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAF8C433C0
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 20:00:29 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hOxDoPce"
Resent-From: Ard Biesheuvel <ardb@kernel.org>
Resent-Date: Mon, 26 Jun 2023 22:00:26 +0200
Resent-Message-ID: <ZJnuWlMdatO3A+ZA@gambale.home>
Resent-To: patches@lists.linux.dev
Received: by 2002:a05:6504:1595:b0:22f:342c:2b60 with SMTP id b21csp6867680ltq;
        Sun, 25 Jun 2023 08:57:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7rjAmP1XPurFY4PyZiAmqqRUCHxyEayn+IlIaEbnYFpaZcsvmfHdCTUSew7ksFZLGAZ2Tj
X-Received: by 2002:a05:6870:44c1:b0:1b0:3b4b:8fb2 with SMTP id t1-20020a05687044c100b001b03b4b8fb2mr345882oai.10.1687708639441;
        Sun, 25 Jun 2023 08:57:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1687708639; cv=none;
        d=google.com; s=arc-20160816;
        b=TKnihQZV1C4h5eRX6wWsMz/sBpNC2epQX2XRRGbPDmud1lxHHttNvNnPZ1FEOdZkYQ
         xn0MTrO+X/7FAEyVa0lJm87A3zJGly64gXOT2mF2f3hiPHMAyzeLDIOQKyXvVFNOLqvn
         4780E+JTF/f/O9W9IAoUs7ir6DYsUsBZnVSy3alI1vnUhm1d9tjFVQ5yHltrmnid2CvX
         0vudFrU5xBp8xC1IlnLcHc4NHlyNtY62YOAK8blXgzP8KP1csUJhJ33wqSMteAIeRyRh
         0qUjESbSVwfqRlF+HPrV9cieIpQSbKCLAsBkY1cygSlW7Yt2fK7x0XpoYqVKclJ791bT
         B7AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:dmarc-filter:delivered-to;
        bh=3djWlnhgTMbhkowbCnm3Axo9ahe5xnhqxOrhebgzMeQ=;
        fh=jR/UThCfMP/RTzkk6YzprRaTed6SvvItvyhekvlRY0s=;
        b=EozYXyRu7P/ddI1UmUF49y4bgz53+JVqZ9KEN7C95jObbMDS+hmc1UjOFQg9mNbHZh
         /+77x9MeZQ/nlsylATX7HYyUN8rUMT6VbeBFQpBkB7lvq8kUAHItgwEQW29DaUC9/L3j
         M/0TirGGfSX9vRfRL/J3kRZYFpw1+qc5UV1Fdp5qUVzvN0XTe71Zn/u+EX//Iv09E/1a
         yL/dEPBae1mVYUbsQR83adMCjeC1Bzt0MxHoJJQQ5dZsz2jyfx8YZOlGk8V96r3IyDPF
         tmmbktrudRHEFwdniEDb3L8ZOuXei3AyyCcmE5C2sd+Dy9TZ03oXNglfUlKSmzkN0RkU
         HMfA==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@gmail.com header.s=20221208 header.b=hOxDoPce;
       spf=pass (google.com: domain of srs0=bkyn=cn=gmail.com=rminnich@kernel.org designates 2604:1380:4641:c500::1 as permitted sender) smtp.mailfrom="SRS0=BkyN=CN=gmail.com=rminnich@kernel.org";
       dmarc=pass (p=NONE sp=QUARANTINE dis=NONE) header.from=gmail.com
Received: from dfw.source.kernel.org (dfw.source.kernel.org. [2604:1380:4641:c500::1])
        by mx.google.com with ESMTPS id q12-20020a056870828c00b00194b5c14d70si1661362oae.221.2023.06.25.08.57.19
        for <workofard@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 08:57:19 -0700 (PDT)
Received-SPF: pass (google.com: domain of srs0=bkyn=cn=gmail.com=rminnich@kernel.org designates 2604:1380:4641:c500::1 as permitted sender) client-ip=2604:1380:4641:c500::1;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@gmail.com header.s=20221208 header.b=hOxDoPce;
       spf=pass (google.com: domain of srs0=bkyn=cn=gmail.com=rminnich@kernel.org designates 2604:1380:4641:c500::1 as permitted sender) smtp.mailfrom="SRS0=BkyN=CN=gmail.com=rminnich@kernel.org";
       dmarc=pass (p=NONE sp=QUARANTINE dis=NONE) header.from=gmail.com
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 13A5060BBD
	for <workofard@gmail.com>; Sun, 25 Jun 2023 15:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 894BFC433C9; Sun, 25 Jun 2023 15:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78FBFC433C0;
	Sun, 25 Jun 2023 15:57:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 78FBFC433C0
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-634ddd17647so12098736d6.2;
        Sun, 25 Jun 2023 08:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687708636; x=1690300636;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3djWlnhgTMbhkowbCnm3Axo9ahe5xnhqxOrhebgzMeQ=;
        b=hOxDoPcegO0BMQENdcpMdB0qwPcz4NjnigkbcqjKGx59LZJKCeqKQfw/qwsbO53aq8
         BO0mNlZH+bB8CbNFuUC6NOKo9czzE9SIE2suoEmKZvQLCwwftAnjlkx7cfQsb2QKusxG
         aR/kKuRMcsP8qrWDoIynxLRecojHFi/XgjmaMApwys8rbGyWiJGuiyWILdTDatFDkITq
         udZyyFE31kSzYI1YdEiJn5zmti30X2+59N/hXalMj3555zmXolPZ8JJyTLxX3X7E7ycr
         UkcP1qO73Yy08TzcS9yVNz2QCVuX3AKMffLctc++t9lZliSvx/pYwd1JlAcl4azXl0GI
         MUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687708636; x=1690300636;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3djWlnhgTMbhkowbCnm3Axo9ahe5xnhqxOrhebgzMeQ=;
        b=AWkmRCG9t+EZ5AhsExFYOMQzzi4p5u/U/n6l+ClkcTs4agCCCIrxCwaAF1Rs2VmmuK
         iTw93N+IJqo6rEvEgtzLhMARb5yMSY6JEJHkE9pM8C7iCm0Fh5/wUTNH/3gYrt42HF2X
         4zuU7KT/9oDbBF5rJ8zB1nz1GAJXy7URT65RPpNPmKXj1dpJNoteWEbL5klE4DJAA9o1
         kSHNNCazOD7gQl11pTDHi84rWWHHwTiMMl9g/b2l9feDW8V7g1ya6Yt3ANKKNZJvUB8e
         INDkoZ+52R8wyEnORW9RhCuEUZnXLwZOFeFnurusr862N9yx+XPIBl3OKGca3Yn5PQHQ
         wlzw==
X-Gm-Message-State: AC+VfDyMeohTTIGW5H01p59IYjH+8/No1xIT4tJBUNtUyY7jds8H3V8i
	/fvQN9eIiXnu4k9Q1/yfSiXO/5/5yLqipc7K1Y1x6cphD+GrRg==
X-Received: by 2002:ad4:5d66:0:b0:632:25c5:6fb8 with SMTP id
 fn6-20020ad45d66000000b0063225c56fb8mr12682617qvb.31.1687708636095; Sun, 25
 Jun 2023 08:57:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230426034001.16-1-cuiyunhui@bytedance.com> <CAMj1kXEKh9O-ndk3QFibJMYfMbG7vm-cLN2vVQM5eDsYK84NzQ@mail.gmail.com>
 <CAEEQ3wkJB5CKm33mHXUOPX5makYOHF8By6FYGnNzRkM-Mo72OQ@mail.gmail.com>
 <ZEj33QLZqEeL+/y4@FVFF77S0Q05N> <CAEEQ3wmDBJkfOeKCQfcnuE+1=1K0D2pzu+Sn+zPEWk+RHs0NFQ@mail.gmail.com>
 <CAP6exY+ydbzh1EkWTFejzwaW+PA-ySVO2Qj+CVJ1XbSMce2S9Q@mail.gmail.com>
 <CAP6exY+tqAU0j1TVEMTzTb18M6_mPH5bWWiAS=94gyDGTY3hyQ@mail.gmail.com>
 <CAEEQ3w=wBdpZWnUd2WWVBC3BtFiUp-PQtNAtdXE4cO4n0XT-fg@mail.gmail.com>
 <CAMj1kXFGpXEPtYpy1+bs13F2P_LLZf9rTMfYMU=6jzgd3=SEcw@mail.gmail.com>
 <CAEEQ3wnbXE0vJnQRLo5MhfDc-Q4PbNWBoWS-oMn71CcJU51JdA@mail.gmail.com>
 <CAMj1kXHfqkU2QxvjTkGBSkEcTf_HirbdOReOJwdpgz3hM8fBHw@mail.gmail.com>
 <CAEEQ3wn2n48TpNQ3MuvrRH4zzg28SaiOswunPeZ01jFm-TbJ5w@mail.gmail.com> <CAMj1kXHgaLD43jx0f6hn_j209LGT_4G+w5XEGaYB9znV5p9tdA@mail.gmail.com>
In-Reply-To: <CAMj1kXHgaLD43jx0f6hn_j209LGT_4G+w5XEGaYB9znV5p9tdA@mail.gmail.com>
From: ron minnich <rminnich@gmail.com>
Date: Sun, 25 Jun 2023 08:57:06 -0700
Message-ID: <CAP6exYJRE8iM63SX3hQP9_5aKYcnN5x0KOAtZOgeEWU5bwLEBA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] firmware: added a firmware information
 passing method FFI
To: Ard Biesheuvel <ardb@kernel.org>
Cc: =?UTF-8?B?6L+Q6L6J5bSU?= <cuiyunhui@bytedance.com>, 
	Mark Rutland <mark.rutland@arm.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, rafael@kernel.org, 
	lenb@kernel.org, jdelvare@suse.com, yc.hung@mediatek.com, 
	angelogioacchino.delregno@collabora.com, allen-kh.cheng@mediatek.com, 
	pierre-louis.bossart@linux.intel.com, tinghan.shen@mediatek.com, 
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org, 
	=?UTF-8?B?6JGb5aOr5bu6?= <geshijian@bytedance.com>, 
	=?UTF-8?B?6Z+m5Lic?= <weidong.wd@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey Ard, thanks for the discussion, sounds like we are able to move forward
now!



On Sun, Jun 25, 2023, 6:13 AM Ard Biesheuvel <ardb@kernel.org> wrote:

> On Sun, 25 Jun 2023 at 13:54, =E8=BF=90=E8=BE=89=E5=B4=94 <cuiyunhui@byte=
dance.com> wrote:
> >
> > Hi Ard,
> >
> > On Sun, Jun 25, 2023 at 3:43=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org=
> wrote:
> > >
> > > acpi_os_ioremap() is used by all ACPI core code that needs to map MMI=
O
> > > regions or DRAM from AML code. AML does not pass memory type
> > > attributes, so we have to consult the EFI memory map for these.
> > >
> > > As I have explained to you multiple times, ACPI on arm64 is *broken*
> > > without the EFI memory map.
> > >
> >
> > As Ron's suggested:
> > "...
> > It would be nice to separate those pieces on RISC-V; certainly they
> > were separate for a very long time in the x86 world (we had ACPI+SMM
> > on coreboot laptops without UEFI for example)
> > ...
> > "
> >
> > If it cannot be solved temporarily on arm64, then we cannot let it
> > continue to be bound in RISC-V.
> > And on the linux-next branch, RISC-V arch is not bound to EFI.
> > void *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
> > {
> >         return memremap(phys, size, MEMREMAP_WB);
> > }
> >
> >
> >
> > >
> > > Incorrect. We are talking about any physical region here, not just
> > > DRAM. And some DRAM regions may not be covered by memblock.
> > >
> > It is very strange that so many devices can complete the hardware
> > description through DTS without the problem you mentioned.
> > Even if there is, then it shouldn't be the problem that this patch
> > should solve, should it?
> >
> > > No, sorry. Please try to understand the objections that I am raising
> > > first. I am not saying this to annoy you, I am saying this because
> > > your approach is flawed.
> >
> > The implementation is right in front of us, we need to support ACPI on
> > RISC-V based on coreboot.
> >
>
> If this is only used on RISC-V, and implemented under arch/riscv, I
> have no objections.
>

