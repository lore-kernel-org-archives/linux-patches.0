Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B6927EE2
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 12:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6ce2bcb131fso3649535a34.1
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 05:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698237316; x=1698842116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3EHsQZuTAFlWrpT/TkHiVwF2+NYzk80BIkUmSEmXuGE=;
        b=hKdWUM04WKe9hK5cuKQEq7tavN6NZt0etr/XST2nH3Ip2DtURBD1+/kuvybzI1MYAd
         MRh5QmpLujYGIKJTcx+a5vVFEBiraJH8Zb3HpvY4GV2fpvpvW83Uf8Et+H1txJMr9xO9
         69UZVK/bKDLLesFWm2iTvpDg2gPGod63vInA16OHwIPnCVr0PjjQC4w05tV996vGO1cj
         sYDdcead1fieHV+fz0ag2xNdrcFMP+l2Ncyw0ydLggMR2fl4HmJAsknNiT8LX9Vszy7G
         Trvg1fTlFoTh8qo1pMdgZPqQJIlYd6bVqUdspMLZU61/DwGLCSSQkdbiMFh+c3MIf/J8
         v4RA==
X-Gm-Message-State: AOJu0YwDCyclxpoSb4gKgwCWYGRCqMYBrIXsG18l6eJw5N5DqSt+532Q
	mxFEAB1+oAVI6FmtEKjWSQ4BoDDXV2N96Q==
X-Google-Smtp-Source: AGHT+IEi61TJcbTJ6hDhzzWGKps4jnGPwv/io6TPweR4h0HAEk/HWcr+xwlszd0jfjNs4301QZeVSg==
X-Received: by 2002:a05:6830:919:b0:6aa:ecb5:f186 with SMTP id v25-20020a056830091900b006aaecb5f186mr16167516ott.7.1698237316552;
        Wed, 25 Oct 2023 05:35:16 -0700 (PDT)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com. [209.85.210.47])
        by smtp.gmail.com with ESMTPSA id h8-20020a056830164800b006ce32816a35sm2258699otr.81.2023.10.25.05.35.16
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 05:35:16 -0700 (PDT)
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6ce2bcb131fso3649523a34.1
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 05:35:16 -0700 (PDT)
X-Received: by 2002:a05:6830:10c2:b0:6cd:a989:c7ea with SMTP id
 z2-20020a05683010c200b006cda989c7eamr16906112oto.16.1698237315941; Wed, 25
 Oct 2023 05:35:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009130126.697995596@linuxfoundation.org> <ZSRVgj5AqJbDXqZU@duo.ucw.cz>
 <ZSRe78MAQwbBdyFP@duo.ucw.cz> <ZSUy+zA0+Chm6dFb@duo.ucw.cz>
 <ZSU+GHl1q7T/TBp5@duo.ucw.cz> <ZSWg1fv3gOyV5t+h@shikoro> <2023101057-runny-pellet-8952@gregkh>
 <ZTgZa1ic1iFbdaTM@duo.ucw.cz> <CAMuHMdXQApuOPfU1zNKcHKN5=fCuLBSDiLtF06U7e4Tx0+noyA@mail.gmail.com>
 <CAMuHMdVrdmBgopnPnJK_ij52wz2WVBdYRHur2KfosFnT945ULw@mail.gmail.com>
In-Reply-To: <CAMuHMdVrdmBgopnPnJK_ij52wz2WVBdYRHur2KfosFnT945ULw@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 25 Oct 2023 14:35:04 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWZvTGrFgx_o3g3usOwkDvD2rw5QH9_ibo=OKdw17sAzg@mail.gmail.com>
Message-ID: <CAMuHMdWZvTGrFgx_o3g3usOwkDvD2rw5QH9_ibo=OKdw17sAzg@mail.gmail.com>
Subject: Re: renesas_sdhi problems in 5.10-stable was Re: [PATCH 5.10 000/226]
 5.10.198-rc1 review
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Wolfram Sang <wsa+renesas@sang-engineering.com>, niklas.soderlund+renesas@ragnatech.se, 
	yoshihiro.shimoda.uh@renesas.com, geert+renesas@glider.be, 
	biju.das.jz@bp.renesas.com, Chris.Paterson2@renesas.com, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

On Wed, Oct 25, 2023 at 12:53=E2=80=AFPM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Wed, Oct 25, 2023 at 12:47=E2=80=AFPM Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > On Tue, Oct 24, 2023 at 9:22=E2=80=AFPM Pavel Machek <pavel@denx.de> wr=
ote:
> > > But we still have failures on Renesas with 5.10.199-rc2:
> > >
> > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipel=
ines/1047368849
> > >
> > > And they still happed during MMC init:
> > >
> > >     2.638013] renesas_sdhi_internal_dmac ee100000.mmc: Got CD GPIO
> > > [    2.638846] INFO: trying to register non-static key.
> > > [    2.644192] ledtrig-cpu: registered to indicate activity on CPUs
> > > [    2.649066] The code is fine but needs lockdep annotation, or mayb=
e
> > > [    2.649069] you didn't initialize this object before use?
> > > [    2.649071] turning off the locking correctness validator.
> > > [    2.649080] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.199-rc2=
-arm64-renesas-ge31b6513c43d #1
> > > [    2.649082] Hardware name: HopeRun HiHope RZ/G2M with sub board (D=
T)
> > > [    2.649086] Call trace:
> > > [    2.655106] SMCCC: SOC_ID: ARCH_SOC_ID not implemented, skipping .=
...
> > > [    2.661354]  dump_backtrace+0x0/0x194
> > > [    2.661361]  show_stack+0x14/0x20
> > > [    2.667430] usbcore: registered new interface driver usbhid
> > > [    2.672230]  dump_stack+0xe8/0x130
> > > [    2.672238]  register_lock_class+0x480/0x514
> > > [    2.672244]  __lock_acquire+0x74/0x20ec
> > > [    2.681113] usbhid: USB HID core driver
> > > [    2.687450]  lock_acquire+0x218/0x350
> > > [    2.687456]  _raw_spin_lock+0x58/0x80
> > > [    2.687464]  tmio_mmc_irq+0x410/0x9ac
> > > [    2.688556] renesas_sdhi_internal_dmac ee160000.mmc: mmc0 base at =
0x00000000ee160000, max clock rate 200 MHz
> > > [    2.744936]  __handle_irq_event_percpu+0xbc/0x340
> > > [    2.749635]  handle_irq_event+0x60/0x100
> > > [    2.753553]  handle_fasteoi_irq+0xa0/0x1ec
> > > [    2.757644]  __handle_domain_irq+0x7c/0xdc
> > > [    2.761736]  efi_header_end+0x4c/0xd0
> > > [    2.765393]  el1_irq+0xcc/0x180
> > > [    2.768530]  arch_cpu_idle+0x14/0x2c
> > > [    2.772100]  default_idle_call+0x58/0xe4
> > > [    2.776019]  do_idle+0x244/0x2c0
> > > [    2.779242]  cpu_startup_entry+0x20/0x6c
> > > [    2.783160]  rest_init+0x164/0x28c
> > > [    2.786561]  arch_call_rest_init+0xc/0x14
> > > [    2.790565]  start_kernel+0x4c4/0x4f8
> > > [    2.794233] Unable to handle kernel NULL pointer dereference at vi=
rtual address 0000000000000014
> > > [    2.803011] Mem abort info:
> > >
> > > from https://lava.ciplatform.org/scheduler/job/1025535
> > > from
> > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/=
5360973735 .
> > >
> > > Is there something else missing?
> >
> > I don't have a HopeRun HiHope RZ/G2M, but both v5.10.198 and v5.10.199
> > seem to work fine on Salvator-XS with R-Car H3 ES2.0 and Salvator-X
> > with R-Car M3-W ES1.0, using a config based on latest renesas_defconfig=
.
>
> Sorry, I looked at the wrong log on R-Car M3-W.
> I do see the issue with v5.10.198, but not with v5.10.199.

It seems to be an intermittent issue. Investigating...

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
