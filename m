Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA17A31A8C
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 19:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6ce2cf67be2so75029a34.2
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 12:53:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698263632; x=1698868432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xa8+C/PTH21PNEpO4wV0awBQL0qs+5FqYNr/HCsqJnA=;
        b=tSMy+SETkboh1HZm1lmWYRhzIc14diNbiCamvd0Rh38XteLH5jwuUV8FQw69wJr+wv
         560r9lYqWnRf2WZlULPkawDbofbdnaD3ppxJfZR+wrPipxz9kyd70+t+xBGGl3NWIIRD
         GMFIUGuDzyAGMZ2B2cLBTNXvF8Zar5E2yIdCTYzWw88bgIIFx0fGGUcfiHHZLF3umiJ0
         dXZmieJMO4DLYvK+UM4s764H0u/V/trW7sy/W/1LWPM+VBStd4tRHvvh8yeViAfsmAwg
         DeMUSsu73B+D2WF+UKBiHaIedSejxRkkzZSqMh59G+tuwGvISXLw2ElXtfSr+CxjYpK0
         z+wA==
X-Gm-Message-State: AOJu0Yzv965b3sMeck0E+eP+rzeNo7lh5SHOGkxqltnYjWW4J+Lc6Sy+
	UR31HkOCZmH30YZFDh6ehqUdw12/qIqklw==
X-Google-Smtp-Source: AGHT+IF9gV1sepo5qrha+sRA/9nXiwarWi9mtb0qWYTbNQtkyllU/3w5kNnMmLKVApVc59FUkVQUhQ==
X-Received: by 2002:a05:6830:719c:b0:6c6:3926:8055 with SMTP id el28-20020a056830719c00b006c639268055mr20155064otb.6.1698263631611;
        Wed, 25 Oct 2023 12:53:51 -0700 (PDT)
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com. [209.85.128.173])
        by smtp.gmail.com with ESMTPSA id y21-20020a0dd615000000b005a50575b1c8sm5302608ywd.26.2023.10.25.12.53.50
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 12:53:50 -0700 (PDT)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-5a7dd65052aso998067b3.0
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 12:53:50 -0700 (PDT)
X-Received: by 2002:a5b:c42:0:b0:da0:48df:cafa with SMTP id
 d2-20020a5b0c42000000b00da048dfcafamr5279836ybr.16.1698263629623; Wed, 25 Oct
 2023 12:53:49 -0700 (PDT)
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
 <CAMuHMdWZvTGrFgx_o3g3usOwkDvD2rw5QH9_ibo=OKdw17sAzg@mail.gmail.com>
 <CAMuHMdXvpiGQ7jqAG69Zo=10wV-E0bioC9AYUHwwhRGmLXygWA@mail.gmail.com> <7d7a5a15-3349-adce-02cd-82b6cb4bebde@roeck-us.net>
In-Reply-To: <7d7a5a15-3349-adce-02cd-82b6cb4bebde@roeck-us.net>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 25 Oct 2023 21:53:37 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXbPZ0uz0NnE1xhUD=QtaAq+TinSW-PrWPMpGe4h=7Spg@mail.gmail.com>
Message-ID: <CAMuHMdXbPZ0uz0NnE1xhUD=QtaAq+TinSW-PrWPMpGe4h=7Spg@mail.gmail.com>
Subject: Re: renesas_sdhi problems in 5.10-stable was Re: [PATCH 5.10 000/226]
 5.10.198-rc1 review
To: Guenter Roeck <linux@roeck-us.net>
Cc: Pavel Machek <pavel@denx.de>, Wolfram Sang <wsa+renesas@sang-engineering.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	niklas.soderlund+renesas@ragnatech.se, yoshihiro.shimoda.uh@renesas.com, 
	biju.das.jz@bp.renesas.com, Chris.Paterson2@renesas.com, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, conor@kernel.org, linux-reneas-soc@vger.kernel.org, 
	Linux MMC List <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi G=C3=BCnter,

On Wed, Oct 25, 2023 at 8:39=E2=80=AFPM Guenter Roeck <linux@roeck-us.net> =
wrote:
> On 10/25/23 10:05, Geert Uytterhoeven wrote:
> > On Wed, Oct 25, 2023 at 2:35=E2=80=AFPM Geert Uytterhoeven <geert@linux=
-m68k.org> wrote:
> >> On Wed, Oct 25, 2023 at 12:53=E2=80=AFPM Geert Uytterhoeven
> >> <geert@linux-m68k.org> wrote:
> >>> On Wed, Oct 25, 2023 at 12:47=E2=80=AFPM Geert Uytterhoeven
> >>> <geert@linux-m68k.org> wrote:
> >>>> On Tue, Oct 24, 2023 at 9:22=E2=80=AFPM Pavel Machek <pavel@denx.de>=
 wrote:
> >>>>> But we still have failures on Renesas with 5.10.199-rc2:
> >>>>>
> >>>>> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pip=
elines/1047368849
> >>>>>
> >>>>> And they still happed during MMC init:
> >>>>>
> >>>>>      2.638013] renesas_sdhi_internal_dmac ee100000.mmc: Got CD GPIO
> >>>>> [    2.638846] INFO: trying to register non-static key.
> >>>>> [    2.644192] ledtrig-cpu: registered to indicate activity on CPUs
> >>>>> [    2.649066] The code is fine but needs lockdep annotation, or ma=
ybe
> >>>>> [    2.649069] you didn't initialize this object before use?
> >>>>> [    2.649071] turning off the locking correctness validator.
> >>>>> [    2.649080] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.199-r=
c2-arm64-renesas-ge31b6513c43d #1
> >>>>> [    2.649082] Hardware name: HopeRun HiHope RZ/G2M with sub board =
(DT)
> >>>>> [    2.649086] Call trace:
> >>>>> [    2.655106] SMCCC: SOC_ID: ARCH_SOC_ID not implemented, skipping=
 ....
> >>>>> [    2.661354]  dump_backtrace+0x0/0x194
> >>>>> [    2.661361]  show_stack+0x14/0x20
> >>>>> [    2.667430] usbcore: registered new interface driver usbhid
> >>>>> [    2.672230]  dump_stack+0xe8/0x130
> >>>>> [    2.672238]  register_lock_class+0x480/0x514
> >>>>> [    2.672244]  __lock_acquire+0x74/0x20ec
> >>>>> [    2.681113] usbhid: USB HID core driver
> >>>>> [    2.687450]  lock_acquire+0x218/0x350
> >>>>> [    2.687456]  _raw_spin_lock+0x58/0x80
> >>>>> [    2.687464]  tmio_mmc_irq+0x410/0x9ac
> >>>>> [    2.688556] renesas_sdhi_internal_dmac ee160000.mmc: mmc0 base a=
t 0x00000000ee160000, max clock rate 200 MHz
> >>>>> [    2.744936]  __handle_irq_event_percpu+0xbc/0x340
> >>>>> [    2.749635]  handle_irq_event+0x60/0x100
> >>>>> [    2.753553]  handle_fasteoi_irq+0xa0/0x1ec
> >>>>> [    2.757644]  __handle_domain_irq+0x7c/0xdc
> >>>>> [    2.761736]  efi_header_end+0x4c/0xd0
> >>>>> [    2.765393]  el1_irq+0xcc/0x180
> >>>>> [    2.768530]  arch_cpu_idle+0x14/0x2c
> >>>>> [    2.772100]  default_idle_call+0x58/0xe4
> >>>>> [    2.776019]  do_idle+0x244/0x2c0
> >>>>> [    2.779242]  cpu_startup_entry+0x20/0x6c
> >>>>> [    2.783160]  rest_init+0x164/0x28c
> >>>>> [    2.786561]  arch_call_rest_init+0xc/0x14
> >>>>> [    2.790565]  start_kernel+0x4c4/0x4f8
> >>>>> [    2.794233] Unable to handle kernel NULL pointer dereference at =
virtual address 0000000000000014
> >>>>> [    2.803011] Mem abort info:
> >>>>>
> >>>>> from https://lava.ciplatform.org/scheduler/job/1025535
> >>>>> from
> >>>>> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/job=
s/5360973735 .
> >>>>>
> >>>>> Is there something else missing?
> >>>>
> >>>> I don't have a HopeRun HiHope RZ/G2M, but both v5.10.198 and v5.10.1=
99
> >>>> seem to work fine on Salvator-XS with R-Car H3 ES2.0 and Salvator-X
> >>>> with R-Car M3-W ES1.0, using a config based on latest renesas_defcon=
fig.
> >>>
> >>> Sorry, I looked at the wrong log on R-Car M3-W.
> >>> I do see the issue with v5.10.198, but not with v5.10.199.
> >>
> >> It seems to be an intermittent issue. Investigating...
> >
> > After spending too much time on bisecting, the bad guy turns out to
> > be commit 6d3745bbc3341d3b ("mmc: renesas_sdhi: register irqs before
> > registering controller") in v5.10.198.
> >
> > Adding debug information shows the lock is mmc_host.lock.
> >
> > It is definitely initialized:
> >
> >      renesas_sdhi_probe()
> >      {
> >          ...
> >          tmio_mmc_host_alloc()
> >              mmc_alloc_host
> >                  spin_lock_init(&host->lock);
> >          ...
> >          devm_request_irq()
> >          -> tmio_mmc_irq
> >              tmio_mmc_cmd_irq()
> >                  spin_lock(&host->lock);
> >          ...
> >      }
> >
> > That leaves us with a missing lockdep annotation?
>
> Is it possible that the lock initialization is overwritten ?
> I seem to recall a recent case where this happens.
>
> Also, there is
>         spin_lock_init(&_host->lock);
> in tmio_mmc_host_probe(), and tmio_mmc_host_probe() is called after
> devm_request_irq().

Unless I am missing something, that is initializing tmio_mmc_host.lock,
which is a different lock than mmc_host.lock?

> Also, how would lockdep annotation help with "Unable to handle
> kernel NULL pointer dereference at virtual address 0000000000000014"
> in the log above ?

For the log from v5.10.198-rc1-g18c65c1b4996, that happened because
it lacked commit 1e3d016a95067ab3 ("mmc: renesas_sdhi: only reset
SCC when its pointer is populated"), according to earlier messages in
this thread.

For the NULL pointer dereference in 5.10.199-rc2, I'm not sure.
I didn't see that on R-Car M3-W...

According to my logs, I never saw this lockdep issue in MMC on mainline
before, so it's a bit hard to guess what's missing...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
