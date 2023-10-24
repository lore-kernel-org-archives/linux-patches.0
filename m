Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA65241F3
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-59b5484fbe6so43826917b3.1
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 01:35:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698136518; x=1698741318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C6WGKCx/tnchPSjDNC0icQpihqJVUVz/LWjSt9rOyiY=;
        b=p37csJhotAHiMemwaK4JR3DzEeRfzLH75tsrwzLYr6Z9Sjqf3zgtfzFcGMGCqccJ5C
         PDlDIMLzGC9z2D9unO5lPgn2sp5bESNS7ulsoICKZRJiRLROEv2F88w/pxo597Br/DF5
         KcLazpsdyg0kDW8fm0RzQW3qq8kgoIK5mUZXcytLZOb5jtWXq5h6ayuGpKUX+pw3M6z5
         mbOjSXJmfom8NbKHNzgyWScZzCfvT21A1AgSs75l3lH8xkfubRwscI+S/F5AfBfVvyNB
         LlSWmR4yjJ8AoSmZBRFDEs9WdQYXFPTltEe69q9FIf+WIKsmhSWYyItg5gZRZusjgNPh
         buHA==
X-Gm-Message-State: AOJu0YypPlnVaqmUZUgOJKTA5tyojPECi4/fhQ4yozkW6I9LPp5wo235
	ppLWicYYPIV1tJN10aMM3cLyD9ptfv8SQA==
X-Google-Smtp-Source: AGHT+IF7niR967MydNWHouFfgz9TFuFFmEkMxlMi3dzxEjhUrmFfWKXsyx3Br+imS2NJ7oI60tzluw==
X-Received: by 2002:a81:6d09:0:b0:5a7:ab56:e081 with SMTP id i9-20020a816d09000000b005a7ab56e081mr13829155ywc.19.1698136518524;
        Tue, 24 Oct 2023 01:35:18 -0700 (PDT)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com. [209.85.128.180])
        by smtp.gmail.com with ESMTPSA id a23-20020a0dd817000000b005a8dbe385d1sm3881330ywe.12.2023.10.24.01.35.18
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 01:35:18 -0700 (PDT)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-5a8ee23f043so43696697b3.3
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 01:35:18 -0700 (PDT)
X-Received: by 2002:a81:52d3:0:b0:5a7:a838:3fa with SMTP id
 g202-20020a8152d3000000b005a7a83803famr11277453ywb.3.1698136517845; Tue, 24
 Oct 2023 01:35:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231023104820.849461819@linuxfoundation.org> <724521b8-9c63-4645-b3e0-30d9635573a7@linaro.org>
 <CAEUSe7-zbuRsgsr2EYq+OeW9iEJyZHmo8u9K3pDCAFRKnCEv0A@mail.gmail.com>
 <CAMuHMdXYB6QAE15RYs7eg9sVofesqNN1+vmPHkosqC_8A-JTSg@mail.gmail.com>
 <9737cd7b-f3c6-7e90-f92c-0ceeed788980@roeck-us.net> <2023102453-backspin-immunize-b110@gregkh>
In-Reply-To: <2023102453-backspin-immunize-b110@gregkh>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 24 Oct 2023 10:35:05 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVR9KFdu=t=8cowyY_-88Hutd-1OxKh6w+f+Cu+YXgtWQ@mail.gmail.com>
Message-ID: <CAMuHMdVR9KFdu=t=8cowyY_-88Hutd-1OxKh6w+f+Cu+YXgtWQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/137] 5.15.137-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, Oct 24, 2023 at 10:31=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Oct 23, 2023 at 12:56:48PM -0700, Guenter Roeck wrote:
> > On 10/23/23 11:50, Geert Uytterhoeven wrote:
> > > CC maz
> > >
> > > On Mon, Oct 23, 2023 at 7:17=E2=80=AFPM Daniel D=C3=ADaz <daniel.diaz=
@linaro.org> wrote:
> > > > On Mon, 23 Oct 2023 at 09:11, Daniel D=C3=ADaz <daniel.diaz@linaro.=
org> wrote:
> > > > > On 23/10/23 4:55 a. m., Greg Kroah-Hartman wrote:
> > > > > > This is the start of the stable review cycle for the 5.15.137 r=
elease.
> > > > > > There are 137 patches in this series, all will be posted as a r=
esponse
> > > > > > to this one.  If anyone has any issues with these being applied=
, please
> > > > > > let me know.
> > > > > >
> > > > > > Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> > > > > > Anything received after that time might be too late.
> > > > > >
> > > > > > The whole patch series can be found in one patch at:
> > > > > >        https://www.kernel.org/pub/linux/kernel/v5.x/stable-revi=
ew/patch-5.15.137-rc1.gz
> > > > > > or in the git tree and branch at:
> > > > > >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/lin=
ux-stable-rc.git linux-5.15.y
> > > > > > and the diffstat can be found below.
> > > > > >
> > > > > > thanks,
> > > > > >
> > > > > > greg k-h
> > > > >
> > > > > We see lots of errors on Arm 32-bits:
> > > > >
> > > > > -----8<-----
> > > > > /builds/linux/drivers/gpio/gpio-vf610.c:249:11: error: 'IRQCHIP_I=
MMUTABLE' undeclared here (not in a function); did you mean 'IS_IMMUTABLE'?
> > > > >     .flags =3D IRQCHIP_IMMUTABLE | IRQCHIP_MASK_ON_SUSPEND
> > > > >              ^~~~~~~~~~~~~~~~~
> > > > >              IS_IMMUTABLE
> > > > > /builds/linux/drivers/gpio/gpio-vf610.c:251:2: error: 'GPIOCHIP_I=
RQ_RESOURCE_HELPERS' undeclared here (not in a function)
> > > > >     GPIOCHIP_IRQ_RESOURCE_HELPERS,
> > > > >     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > > /builds/linux/drivers/gpio/gpio-vf610.c:251:2: warning: excess el=
ements in struct initializer
> > > > > /builds/linux/drivers/gpio/gpio-vf610.c:251:2: note: (near initia=
lization for 'vf610_irqchip')
> > > > > /builds/linux/drivers/gpio/gpio-vf610.c: In function 'vf610_gpio_=
probe':
> > > > > /builds/linux/drivers/gpio/gpio-vf610.c:340:2: error: implicit de=
claration of function 'gpio_irq_chip_set_chip'; did you mean 'gpiochip_get_=
data'? [-Werror=3Dimplicit-function-declaration]
> > > > >     gpio_irq_chip_set_chip(girq, &vf610_irqchip);
> > > > >     ^~~~~~~~~~~~~~~~~~~~~~
> > > > >     gpiochip_get_data
> > > > > cc1: some warnings being treated as errors
> > > > > ----->8-----
> > > >
> > > > Bisection points to "gpio: vf610: make irq_chip immutable" (upstrea=
m
> > > > commit e6ef4f8ede09f4af7cde000717b349b50bc62576).
> > >
> > > IRQCHIP_IMMUTABLE was introduced in commit 6c846d026d490b23 ("gpio:
> > > Don't fiddle with irqchips marked as immutable") in v5.19.
> > > Backporting (part of) that is probably not safe.
> > >
> >
> > In this context: What exactly does commit e6ef4f8ede09 fix that makes i=
t
> > a stable release candidate ?
>
> It is needed as a dependency for 430232619791 ("gpio: vf610: mask the
> gpio irq in system suspend and support wakeup") which says it:
>   Fixes: 7f2691a19627 ("gpio: vf610: add gpiolib/IRQ chip driver for Vybr=
id")
> which was in the 3.19 kernel release.
>
> That's why it was added.  And then none of my x86 builds caught this
> build failure before I pushed out the -rcs.

Ah, the difference between semantic and lexical changes ;-)

The proper backport would be to just add

       .flags =3D IRQCHIP_MASK_ON_SUSPEND | IRQCHIP_ENABLE_WAKEUP_ON_SUSPEN=
D,

Don't bother with the IRQCHIP_IMMUTABLE.

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
