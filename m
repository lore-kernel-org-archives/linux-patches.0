Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201D615491
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 10:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-d9a6399cf78so673589276.0
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 03:48:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698230891; x=1698835691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q7T7NGjmsCv32Izm0iMAgL/DHgoAs/s0TcgPa3jLVR8=;
        b=JHSYe0MF+h7tJB926yYMMQACNE9yAy8lmQXfgvSS60fKkpKOXyAyVE19YXoXATN5pf
         CzPF439/hC422+DJUrm6AEzhF0nj6Yq6Dg1eAr2fSPB7S4EAz5pQga7Sq0+F3AwPYG2N
         RneeHJwwR3W2mESRtq56zHoqxagFPfIzUJmEeaNc//JyNqmp5+w3PyvxjXzC4lMKzY+Q
         KtE2Ywc4saj4YjQEVvRbWkxN80hu/AypsK3hEEIeSI5kneNMJUAobp2mbxrBKFKarEsM
         i7ONpYGzAbkPK3sUq/q800XoZ+vHfJ7cOnpqdBlAcUTmcdUeogWEYTpnIsQ080CgAKTO
         RHrA==
X-Gm-Message-State: AOJu0YzyxgHOaMYP+cnctSaZMa+d6mgW+llh/d319Pm/SMwW2jrNpSQ7
	FF5cSxqJxDCe3PsVrsAcwK4OuNSiJRMiyQ==
X-Google-Smtp-Source: AGHT+IEvWXI25G1RFgH+iYsc1Kww3Y7EKltbPP2TIid8xhzlg/aX1Wgs8qT1/zJz/e/zq9ad/5Dpnw==
X-Received: by 2002:a25:d111:0:b0:d9a:be2c:ce3d with SMTP id i17-20020a25d111000000b00d9abe2cce3dmr19943191ybg.8.1698230890806;
        Wed, 25 Oct 2023 03:48:10 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id j191-20020a25d2c8000000b00d9ace05037csm4369236ybg.13.2023.10.25.03.48.09
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 03:48:09 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-d9a6399cf78so673571276.0
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 03:48:09 -0700 (PDT)
X-Received: by 2002:a25:b116:0:b0:da0:81da:e4df with SMTP id
 g22-20020a25b116000000b00da081dae4dfmr1644233ybj.13.1698230889565; Wed, 25
 Oct 2023 03:48:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009130126.697995596@linuxfoundation.org> <ZSRVgj5AqJbDXqZU@duo.ucw.cz>
 <ZSRe78MAQwbBdyFP@duo.ucw.cz> <ZSUy+zA0+Chm6dFb@duo.ucw.cz>
 <ZSU+GHl1q7T/TBp5@duo.ucw.cz> <ZSWg1fv3gOyV5t+h@shikoro> <2023101057-runny-pellet-8952@gregkh>
 <ZTgZa1ic1iFbdaTM@duo.ucw.cz>
In-Reply-To: <ZTgZa1ic1iFbdaTM@duo.ucw.cz>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 25 Oct 2023 12:47:57 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXQApuOPfU1zNKcHKN5=fCuLBSDiLtF06U7e4Tx0+noyA@mail.gmail.com>
Message-ID: <CAMuHMdXQApuOPfU1zNKcHKN5=fCuLBSDiLtF06U7e4Tx0+noyA@mail.gmail.com>
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

On Tue, Oct 24, 2023 at 9:22=E2=80=AFPM Pavel Machek <pavel@denx.de> wrote:
> > > > And testing failed. So
> > > >
> > > > commit f5799b4e142884c2e7aa99f813113af4a3395ffb
> > > > Author: Wolfram Sang <wsa+renesas@sang-engineering.com>
> > > > Date:   Tue Nov 10 15:20:57 2020 +0100
> > > >
> > > >     mmc: renesas_sdhi: populate SCC pointer at the proper place
> > > >
> > > >     [ Upstream commit d14ac691bb6f6ebaa7eeec21ca04dd47300ff5b6 ]
> > > >
> > > > seems to be the buggy commit that breaks renesas boards in 5.10.
> > >
> > > This patch was part of a series. Did the other two patches come with =
it?
> > >
> > > b161d87dfd3d ("mmc: renesas_sdhi: probe into TMIO after SCC parameter=
s have been setup")
> >
> > Yes.
> >
> > > 45bffc371fef ("mmc: renesas_sdhi: only reset SCC when its pointer is =
populated")
> >
> > No :(
> >
> > > If not, I could imagine that could lead to a crash. No idea why only
> > > with 5.10, though.
> >
> > The above commit is only in 5.11, so newer kernels should be fine.
> >
> > I'll go queue up the one missing patch now, thanks.
>
> Thank you. Patch indeed appears to be in 5.10.199.
>
> But we still have failures on Renesas with 5.10.199-rc2:
>
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines=
/1047368849
>
> And they still happed during MMC init:
>
>     2.638013] renesas_sdhi_internal_dmac ee100000.mmc: Got CD GPIO
> [    2.638846] INFO: trying to register non-static key.
> [    2.644192] ledtrig-cpu: registered to indicate activity on CPUs
> [    2.649066] The code is fine but needs lockdep annotation, or maybe
> [    2.649069] you didn't initialize this object before use?
> [    2.649071] turning off the locking correctness validator.
> [    2.649080] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.199-rc2-arm=
64-renesas-ge31b6513c43d #1
> [    2.649082] Hardware name: HopeRun HiHope RZ/G2M with sub board (DT)
> [    2.649086] Call trace:
> [    2.655106] SMCCC: SOC_ID: ARCH_SOC_ID not implemented, skipping ....
> [    2.661354]  dump_backtrace+0x0/0x194
> [    2.661361]  show_stack+0x14/0x20
> [    2.667430] usbcore: registered new interface driver usbhid
> [    2.672230]  dump_stack+0xe8/0x130
> [    2.672238]  register_lock_class+0x480/0x514
> [    2.672244]  __lock_acquire+0x74/0x20ec
> [    2.681113] usbhid: USB HID core driver
> [    2.687450]  lock_acquire+0x218/0x350
> [    2.687456]  _raw_spin_lock+0x58/0x80
> [    2.687464]  tmio_mmc_irq+0x410/0x9ac
> [    2.688556] renesas_sdhi_internal_dmac ee160000.mmc: mmc0 base at 0x00=
000000ee160000, max clock rate 200 MHz
> [    2.744936]  __handle_irq_event_percpu+0xbc/0x340
> [    2.749635]  handle_irq_event+0x60/0x100
> [    2.753553]  handle_fasteoi_irq+0xa0/0x1ec
> [    2.757644]  __handle_domain_irq+0x7c/0xdc
> [    2.761736]  efi_header_end+0x4c/0xd0
> [    2.765393]  el1_irq+0xcc/0x180
> [    2.768530]  arch_cpu_idle+0x14/0x2c
> [    2.772100]  default_idle_call+0x58/0xe4
> [    2.776019]  do_idle+0x244/0x2c0
> [    2.779242]  cpu_startup_entry+0x20/0x6c
> [    2.783160]  rest_init+0x164/0x28c
> [    2.786561]  arch_call_rest_init+0xc/0x14
> [    2.790565]  start_kernel+0x4c4/0x4f8
> [    2.794233] Unable to handle kernel NULL pointer dereference at virtua=
l address 0000000000000014
> [    2.803011] Mem abort info:
>
> from https://lava.ciplatform.org/scheduler/job/1025535
> from
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/5360=
973735 .
>
> Is there something else missing?

I don't have a HopeRun HiHope RZ/G2M, but both v5.10.198 and v5.10.199
seem to work fine on Salvator-XS with R-Car H3 ES2.0 and Salvator-X
with R-Car M3-W ES1.0, using a config based on latest renesas_defconfig.

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
