Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CB926E0F
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 10:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-5a7af45084eso52101397b3.0
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 03:53:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698231200; x=1698836000;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lp/P/2ckLQAwz9y7c2Caj6foLZ4doNpN7qmvBqweg0I=;
        b=MaY7ymI5vhgN7Jmk5HtaZIQWgriZDKz5RQ32Adn30L0BXSujnCmFkDXHGA/wM0M5v1
         CtK7ACmuT0dWIwZ1jq8S8+74AxF83RVxrRem40wxe1lwX7f5R3BojqNa37FEE26QKwPa
         TmM0+Jzkl0lH5lULzqGKv838RaB56a6y/Z+NU1F8jTmpxGGSYzg6cNIuivnpaPTPsArA
         uRrvBc2M8Kc9EHUtBGoisERcVpr/W3n2d/cNO7ALAJzcJLNd+EYR1d+14ZmWu4gDxe52
         FUNpNl6/nyzE1g/Z6NUtkxsGlR1YIZwRgRaM+900E5j3i7oYg5mA+C43HqBZzS8GciJ0
         mHTQ==
X-Gm-Message-State: AOJu0Yxos0W9CKbo8aalqk7MO+nq7FqpmO4aP97TmvUkBi9z2xCvjH+N
	xoy3TrNO3qfeh/QmCT5CuAiOowb3NIBeww==
X-Google-Smtp-Source: AGHT+IHqDuRFM6X6vm3VjigA2X7isJe2PpGUJP2fetifhEdje2Y6kwqang/MYMnnlBlXIM4Mj9VZpQ==
X-Received: by 2002:a0d:d605:0:b0:592:1bab:52bd with SMTP id y5-20020a0dd605000000b005921bab52bdmr14365178ywd.39.1698231200120;
        Wed, 25 Oct 2023 03:53:20 -0700 (PDT)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com. [209.85.128.181])
        by smtp.gmail.com with ESMTPSA id n8-20020a817208000000b005925c896bc3sm4994332ywc.53.2023.10.25.03.53.18
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 03:53:18 -0700 (PDT)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-5a7c95b8d14so51752307b3.3
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 03:53:18 -0700 (PDT)
X-Received: by 2002:a0d:d752:0:b0:5a7:c01d:268 with SMTP id
 z79-20020a0dd752000000b005a7c01d0268mr15876069ywd.18.1698231198298; Wed, 25
 Oct 2023 03:53:18 -0700 (PDT)
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
In-Reply-To: <CAMuHMdXQApuOPfU1zNKcHKN5=fCuLBSDiLtF06U7e4Tx0+noyA@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 25 Oct 2023 12:53:06 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVrdmBgopnPnJK_ij52wz2WVBdYRHur2KfosFnT945ULw@mail.gmail.com>
Message-ID: <CAMuHMdVrdmBgopnPnJK_ij52wz2WVBdYRHur2KfosFnT945ULw@mail.gmail.com>
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

On Wed, Oct 25, 2023 at 12:47=E2=80=AFPM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, Oct 24, 2023 at 9:22=E2=80=AFPM Pavel Machek <pavel@denx.de> wrot=
e:
> > > > > And testing failed. So
> > > > >
> > > > > commit f5799b4e142884c2e7aa99f813113af4a3395ffb
> > > > > Author: Wolfram Sang <wsa+renesas@sang-engineering.com>
> > > > > Date:   Tue Nov 10 15:20:57 2020 +0100
> > > > >
> > > > >     mmc: renesas_sdhi: populate SCC pointer at the proper place
> > > > >
> > > > >     [ Upstream commit d14ac691bb6f6ebaa7eeec21ca04dd47300ff5b6 ]
> > > > >
> > > > > seems to be the buggy commit that breaks renesas boards in 5.10.
> > > >
> > > > This patch was part of a series. Did the other two patches come wit=
h it?
> > > >
> > > > b161d87dfd3d ("mmc: renesas_sdhi: probe into TMIO after SCC paramet=
ers have been setup")
> > >
> > > Yes.
> > >
> > > > 45bffc371fef ("mmc: renesas_sdhi: only reset SCC when its pointer i=
s populated")
> > >
> > > No :(
> > >
> > > > If not, I could imagine that could lead to a crash. No idea why onl=
y
> > > > with 5.10, though.
> > >
> > > The above commit is only in 5.11, so newer kernels should be fine.
> > >
> > > I'll go queue up the one missing patch now, thanks.
> >
> > Thank you. Patch indeed appears to be in 5.10.199.
> >
> > But we still have failures on Renesas with 5.10.199-rc2:
> >
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelin=
es/1047368849
> >
> > And they still happed during MMC init:
> >
> >     2.638013] renesas_sdhi_internal_dmac ee100000.mmc: Got CD GPIO
> > [    2.638846] INFO: trying to register non-static key.
> > [    2.644192] ledtrig-cpu: registered to indicate activity on CPUs
> > [    2.649066] The code is fine but needs lockdep annotation, or maybe
> > [    2.649069] you didn't initialize this object before use?
> > [    2.649071] turning off the locking correctness validator.
> > [    2.649080] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.199-rc2-a=
rm64-renesas-ge31b6513c43d #1
> > [    2.649082] Hardware name: HopeRun HiHope RZ/G2M with sub board (DT)
> > [    2.649086] Call trace:
> > [    2.655106] SMCCC: SOC_ID: ARCH_SOC_ID not implemented, skipping ...=
.
> > [    2.661354]  dump_backtrace+0x0/0x194
> > [    2.661361]  show_stack+0x14/0x20
> > [    2.667430] usbcore: registered new interface driver usbhid
> > [    2.672230]  dump_stack+0xe8/0x130
> > [    2.672238]  register_lock_class+0x480/0x514
> > [    2.672244]  __lock_acquire+0x74/0x20ec
> > [    2.681113] usbhid: USB HID core driver
> > [    2.687450]  lock_acquire+0x218/0x350
> > [    2.687456]  _raw_spin_lock+0x58/0x80
> > [    2.687464]  tmio_mmc_irq+0x410/0x9ac
> > [    2.688556] renesas_sdhi_internal_dmac ee160000.mmc: mmc0 base at 0x=
00000000ee160000, max clock rate 200 MHz
> > [    2.744936]  __handle_irq_event_percpu+0xbc/0x340
> > [    2.749635]  handle_irq_event+0x60/0x100
> > [    2.753553]  handle_fasteoi_irq+0xa0/0x1ec
> > [    2.757644]  __handle_domain_irq+0x7c/0xdc
> > [    2.761736]  efi_header_end+0x4c/0xd0
> > [    2.765393]  el1_irq+0xcc/0x180
> > [    2.768530]  arch_cpu_idle+0x14/0x2c
> > [    2.772100]  default_idle_call+0x58/0xe4
> > [    2.776019]  do_idle+0x244/0x2c0
> > [    2.779242]  cpu_startup_entry+0x20/0x6c
> > [    2.783160]  rest_init+0x164/0x28c
> > [    2.786561]  arch_call_rest_init+0xc/0x14
> > [    2.790565]  start_kernel+0x4c4/0x4f8
> > [    2.794233] Unable to handle kernel NULL pointer dereference at virt=
ual address 0000000000000014
> > [    2.803011] Mem abort info:
> >
> > from https://lava.ciplatform.org/scheduler/job/1025535
> > from
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/53=
60973735 .
> >
> > Is there something else missing?
>
> I don't have a HopeRun HiHope RZ/G2M, but both v5.10.198 and v5.10.199
> seem to work fine on Salvator-XS with R-Car H3 ES2.0 and Salvator-X
> with R-Car M3-W ES1.0, using a config based on latest renesas_defconfig.

Sorry, I looked at the wrong log on R-Car M3-W.
I do see the issue with v5.10.198, but not with v5.10.199.

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
