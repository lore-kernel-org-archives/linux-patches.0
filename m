Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05507522C
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 17:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-1dcfe9cd337so3181085fac.2
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 10:12:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698253924; x=1698858724;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6UkPVw/GSelcy6GD1xMl2P635kTGDpqZ7QzhPfb3ZQ=;
        b=XEOfvfxzpUXS7DtZ49XfpR3egusZPQOXUWb5BM08Z3nuP1ozzvrHqhLIErKviyUH9v
         tbhbOcYq9Nlke/UByHnD5qfAtab7UbG+MvaCZMBskwpCxGXbd+yMPYubFtjAeF5CuROh
         JFMb6ofqvqrjOV0qKzRQLDs3UrHG8nHQfvc8gOqDwX1gSMBZ7wLzoymt4RmETfsHkbKc
         vN0I9GZ1VE4Jdm3m5eGX0MZo4/mMuyRL5pRb//6oMlop5xIbJQ7z7qhYagwyA0gG3l8s
         bAsFjqvBLNvOEvtr3lS/6LcePDFEhU2zdLKhePGIt5R4IFg5yhtR/TcYihYDUlP7zRbK
         bDtA==
X-Gm-Message-State: AOJu0YyCLONYo+6f5hw6y9vHCOrpgD+OCMMd0RAAcbk/pk71VZw9mJDN
	Po4wWjlKAqmEhTg+gU6vs9U73zoPDK56JA==
X-Google-Smtp-Source: AGHT+IEoYOID5dlVe9JZ/UbBSOgTwYj7o01ITT9IH1jfv9qQoeuisxsZLtPETZUkXS7K/SFqVjhCFQ==
X-Received: by 2002:a05:6870:1309:b0:1ea:125f:cffa with SMTP id 9-20020a056870130900b001ea125fcffamr12255698oab.34.1698253923732;
        Wed, 25 Oct 2023 10:12:03 -0700 (PDT)
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com. [209.85.160.52])
        by smtp.gmail.com with ESMTPSA id cj19-20020a05687c041300b001c02f12abd0sm2673265oac.38.2023.10.25.10.12.03
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 10:12:03 -0700 (PDT)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-1e9c42fc0c9so3194825fac.1
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 10:12:03 -0700 (PDT)
X-Received: by 2002:a05:6902:1890:b0:d9a:d196:67c1 with SMTP id
 cj16-20020a056902189000b00d9ad19667c1mr18693936ybb.10.1698253566394; Wed, 25
 Oct 2023 10:06:06 -0700 (PDT)
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
 <CAMuHMdVrdmBgopnPnJK_ij52wz2WVBdYRHur2KfosFnT945ULw@mail.gmail.com> <CAMuHMdWZvTGrFgx_o3g3usOwkDvD2rw5QH9_ibo=OKdw17sAzg@mail.gmail.com>
In-Reply-To: <CAMuHMdWZvTGrFgx_o3g3usOwkDvD2rw5QH9_ibo=OKdw17sAzg@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 25 Oct 2023 19:05:53 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXvpiGQ7jqAG69Zo=10wV-E0bioC9AYUHwwhRGmLXygWA@mail.gmail.com>
Message-ID: <CAMuHMdXvpiGQ7jqAG69Zo=10wV-E0bioC9AYUHwwhRGmLXygWA@mail.gmail.com>
Subject: Re: renesas_sdhi problems in 5.10-stable was Re: [PATCH 5.10 000/226]
 5.10.198-rc1 review
To: Pavel Machek <pavel@denx.de>, Wolfram Sang <wsa+renesas@sang-engineering.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, niklas.soderlund+renesas@ragnatech.se, 
	yoshihiro.shimoda.uh@renesas.com, biju.das.jz@bp.renesas.com, 
	Chris.Paterson2@renesas.com, stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, conor@kernel.org, linux-reneas-soc@vger.kernel.org, 
	Linux MMC List <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 25, 2023 at 2:35=E2=80=AFPM Geert Uytterhoeven <geert@linux-m68=
k.org> wrote:
> On Wed, Oct 25, 2023 at 12:53=E2=80=AFPM Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > On Wed, Oct 25, 2023 at 12:47=E2=80=AFPM Geert Uytterhoeven
> > <geert@linux-m68k.org> wrote:
> > > On Tue, Oct 24, 2023 at 9:22=E2=80=AFPM Pavel Machek <pavel@denx.de> =
wrote:
> > > > But we still have failures on Renesas with 5.10.199-rc2:
> > > >
> > > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pip=
elines/1047368849
> > > >
> > > > And they still happed during MMC init:
> > > >
> > > >     2.638013] renesas_sdhi_internal_dmac ee100000.mmc: Got CD GPIO
> > > > [    2.638846] INFO: trying to register non-static key.
> > > > [    2.644192] ledtrig-cpu: registered to indicate activity on CPUs
> > > > [    2.649066] The code is fine but needs lockdep annotation, or ma=
ybe
> > > > [    2.649069] you didn't initialize this object before use?
> > > > [    2.649071] turning off the locking correctness validator.
> > > > [    2.649080] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.199-r=
c2-arm64-renesas-ge31b6513c43d #1
> > > > [    2.649082] Hardware name: HopeRun HiHope RZ/G2M with sub board =
(DT)
> > > > [    2.649086] Call trace:
> > > > [    2.655106] SMCCC: SOC_ID: ARCH_SOC_ID not implemented, skipping=
 ....
> > > > [    2.661354]  dump_backtrace+0x0/0x194
> > > > [    2.661361]  show_stack+0x14/0x20
> > > > [    2.667430] usbcore: registered new interface driver usbhid
> > > > [    2.672230]  dump_stack+0xe8/0x130
> > > > [    2.672238]  register_lock_class+0x480/0x514
> > > > [    2.672244]  __lock_acquire+0x74/0x20ec
> > > > [    2.681113] usbhid: USB HID core driver
> > > > [    2.687450]  lock_acquire+0x218/0x350
> > > > [    2.687456]  _raw_spin_lock+0x58/0x80
> > > > [    2.687464]  tmio_mmc_irq+0x410/0x9ac
> > > > [    2.688556] renesas_sdhi_internal_dmac ee160000.mmc: mmc0 base a=
t 0x00000000ee160000, max clock rate 200 MHz
> > > > [    2.744936]  __handle_irq_event_percpu+0xbc/0x340
> > > > [    2.749635]  handle_irq_event+0x60/0x100
> > > > [    2.753553]  handle_fasteoi_irq+0xa0/0x1ec
> > > > [    2.757644]  __handle_domain_irq+0x7c/0xdc
> > > > [    2.761736]  efi_header_end+0x4c/0xd0
> > > > [    2.765393]  el1_irq+0xcc/0x180
> > > > [    2.768530]  arch_cpu_idle+0x14/0x2c
> > > > [    2.772100]  default_idle_call+0x58/0xe4
> > > > [    2.776019]  do_idle+0x244/0x2c0
> > > > [    2.779242]  cpu_startup_entry+0x20/0x6c
> > > > [    2.783160]  rest_init+0x164/0x28c
> > > > [    2.786561]  arch_call_rest_init+0xc/0x14
> > > > [    2.790565]  start_kernel+0x4c4/0x4f8
> > > > [    2.794233] Unable to handle kernel NULL pointer dereference at =
virtual address 0000000000000014
> > > > [    2.803011] Mem abort info:
> > > >
> > > > from https://lava.ciplatform.org/scheduler/job/1025535
> > > > from
> > > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/job=
s/5360973735 .
> > > >
> > > > Is there something else missing?
> > >
> > > I don't have a HopeRun HiHope RZ/G2M, but both v5.10.198 and v5.10.19=
9
> > > seem to work fine on Salvator-XS with R-Car H3 ES2.0 and Salvator-X
> > > with R-Car M3-W ES1.0, using a config based on latest renesas_defconf=
ig.
> >
> > Sorry, I looked at the wrong log on R-Car M3-W.
> > I do see the issue with v5.10.198, but not with v5.10.199.
>
> It seems to be an intermittent issue. Investigating...

After spending too much time on bisecting, the bad guy turns out to
be commit 6d3745bbc3341d3b ("mmc: renesas_sdhi: register irqs before
registering controller") in v5.10.198.

Adding debug information shows the lock is mmc_host.lock.

It is definitely initialized:

    renesas_sdhi_probe()
    {
        ...
        tmio_mmc_host_alloc()
            mmc_alloc_host
                spin_lock_init(&host->lock);
        ...
        devm_request_irq()
        -> tmio_mmc_irq
            tmio_mmc_cmd_irq()
                spin_lock(&host->lock);
        ...
    }

That leaves us with a missing lockdep annotation?

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
