Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D8C1E536
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 18:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-5a7afd45199so38092417b3.0
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:50:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698087028; x=1698691828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aYFfnW1lq/N35y1JdU1JiP7JMVnAqfYQ6cbBfI8EdMk=;
        b=fEG8+FcuD/YKcefE41mx3wSY65qDxCeZzJJcHmtPqgidJ+uakdToB5Xnpo/iYxUHvx
         t2bDLi4ndQJfsxlQTkTRH31qNxqXdPITCQm9bqk9pcaeTBFywUR7BneJpocSsycW6Mo7
         c/jV1ofePyk/DxvifgZCR6lLVA9/6FMKj1MHLak/B/Lvu+tyH9k0kjtKYz+qgY1wFh7D
         D7KFqds6tb/vUJQR+tyXjMFMVSgeMNnzSFCbtqRtBAemA1XGiCpReElT0JmYldhhLy3Q
         FxMqf6WlHXaIsqCwsi7GBMblFmRRiaoygrLefpefs16LoDgU5ZLYnGjRkmCxGOzcTpS5
         VVyw==
X-Gm-Message-State: AOJu0YxCejDycKjBkDzKvEUukFNOwVygXaOBZ21MSUUooZ9dcQjMlLR2
	lOjMsKXxfgVZSVmNLnbKwfMTntDaszVPuw==
X-Google-Smtp-Source: AGHT+IHDzAq0HE7rRQzX34Pa7ISn1PuAeSiR1NO63OW7VaUYo4Bjq+cjhH3m2jV4PeYNOlVmrEyX+Q==
X-Received: by 2002:a0d:d187:0:b0:59b:14ca:4316 with SMTP id t129-20020a0dd187000000b0059b14ca4316mr10224542ywd.43.1698087028300;
        Mon, 23 Oct 2023 11:50:28 -0700 (PDT)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com. [209.85.128.177])
        by smtp.gmail.com with ESMTPSA id h14-20020a81b64e000000b005a927c75068sm2120718ywk.122.2023.10.23.11.50.28
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 11:50:28 -0700 (PDT)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-5a7afd45199so38092347b3.0
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:50:28 -0700 (PDT)
X-Received: by 2002:a81:a090:0:b0:5a7:baac:7b34 with SMTP id
 x138-20020a81a090000000b005a7baac7b34mr10436542ywg.28.1698087027858; Mon, 23
 Oct 2023 11:50:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231023104820.849461819@linuxfoundation.org> <724521b8-9c63-4645-b3e0-30d9635573a7@linaro.org>
 <CAEUSe7-zbuRsgsr2EYq+OeW9iEJyZHmo8u9K3pDCAFRKnCEv0A@mail.gmail.com>
In-Reply-To: <CAEUSe7-zbuRsgsr2EYq+OeW9iEJyZHmo8u9K3pDCAFRKnCEv0A@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 23 Oct 2023 20:50:15 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXYB6QAE15RYs7eg9sVofesqNN1+vmPHkosqC_8A-JTSg@mail.gmail.com>
Message-ID: <CAMuHMdXYB6QAE15RYs7eg9sVofesqNN1+vmPHkosqC_8A-JTSg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/137] 5.15.137-rc1 review
To: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

CC maz

On Mon, Oct 23, 2023 at 7:17=E2=80=AFPM Daniel D=C3=ADaz <daniel.diaz@linar=
o.org> wrote:
> On Mon, 23 Oct 2023 at 09:11, Daniel D=C3=ADaz <daniel.diaz@linaro.org> w=
rote:
> > On 23/10/23 4:55 a. m., Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.137 release=
.
> > > There are 137 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.15.137-rc1.gz
> > > or in the git tree and branch at:
> > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > We see lots of errors on Arm 32-bits:
> >
> > -----8<-----
> > /builds/linux/drivers/gpio/gpio-vf610.c:249:11: error: 'IRQCHIP_IMMUTAB=
LE' undeclared here (not in a function); did you mean 'IS_IMMUTABLE'?
> >    .flags =3D IRQCHIP_IMMUTABLE | IRQCHIP_MASK_ON_SUSPEND
> >             ^~~~~~~~~~~~~~~~~
> >             IS_IMMUTABLE
> > /builds/linux/drivers/gpio/gpio-vf610.c:251:2: error: 'GPIOCHIP_IRQ_RES=
OURCE_HELPERS' undeclared here (not in a function)
> >    GPIOCHIP_IRQ_RESOURCE_HELPERS,
> >    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > /builds/linux/drivers/gpio/gpio-vf610.c:251:2: warning: excess elements=
 in struct initializer
> > /builds/linux/drivers/gpio/gpio-vf610.c:251:2: note: (near initializati=
on for 'vf610_irqchip')
> > /builds/linux/drivers/gpio/gpio-vf610.c: In function 'vf610_gpio_probe'=
:
> > /builds/linux/drivers/gpio/gpio-vf610.c:340:2: error: implicit declarat=
ion of function 'gpio_irq_chip_set_chip'; did you mean 'gpiochip_get_data'?=
 [-Werror=3Dimplicit-function-declaration]
> >    gpio_irq_chip_set_chip(girq, &vf610_irqchip);
> >    ^~~~~~~~~~~~~~~~~~~~~~
> >    gpiochip_get_data
> > cc1: some warnings being treated as errors
> > ----->8-----
>
> Bisection points to "gpio: vf610: make irq_chip immutable" (upstream
> commit e6ef4f8ede09f4af7cde000717b349b50bc62576).

IRQCHIP_IMMUTABLE was introduced in commit 6c846d026d490b23 ("gpio:
Don't fiddle with irqchips marked as immutable") in v5.19.
Backporting (part of) that is probably not safe.

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
