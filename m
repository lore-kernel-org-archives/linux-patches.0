Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EEE747A
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 17:38:47 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-99bf1f632b8so796503666b.1
        for <patches@lists.linux.dev>; Wed, 30 Aug 2023 10:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693417126; x=1694021926; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jbAT6tVSst61nEOg9/KrYv+5R56n09qvoB/CI4vs9QQ=;
        b=fDU/sVdbmKXVQCkGGtWt76U5J+GqEvz9azW4jxU6sja8UvyWxoPyF9c99ccftkMbLL
         0kqguQoRqyFhDbgZc1Se874NgtJ+XhN/aBqlkOaDajfnsbEDA8bfztEcghKPpvH6r8Ru
         9xmmdnMf2quqsRMLQyJLfIWOrs4+7bCRLkfiGnZpx87LNLAf0SEHPd0wXhOA0RwnzRTo
         QwoKM1gVZ+CyIl7YTUeRnJf//wh/y/f9SIPhZOgAjVUrR7Kun2hQRXu+hc5GY5a0uJiA
         VXlMc+HawAG5kChjtHWRlv+nUlIMgAQ70sOYCMNxz7ZXRN6/U8yr2rHb35/izhILcsd7
         vq1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693417126; x=1694021926;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jbAT6tVSst61nEOg9/KrYv+5R56n09qvoB/CI4vs9QQ=;
        b=R6OUEAlmOCZrEgxK0ygsHNZcAdhXtHWRxLKRPEqMzCAPf4bsuS5pqagzuUciCMtzI4
         zaMlEGkglolpjze10rWinIXwaYCBkhHVOTykIJ7/1IuByZ1rGaSLcIDVok7vTnab1PsJ
         KbpDNaDVN6bSWGLpi7DsO9XLocYMUdeoYAQ8BOPcKcI0PifcGr2YZL+V1wSJv7OquxIh
         AlfA9L/aHFEOgvl8bRQrmEyOATf6XPVmHBWvoquWmqCeZBBXTOltVM2pF3tOSWIOlXMd
         6pA4+iEu0APM7ecZ+85IrSsyOYmjMRmd7POaqAE1BmfNNIe0tlyEIM5TJEghPA1vbTAU
         8rlQ==
X-Gm-Message-State: AOJu0YyapcF2BYTLEkIYcnmf4CGQdDVe6Za3kZGcFnV02DRMcD+/bJv5
	QRERkAxFYs+1W9olEAQ9h/mw3qd3m52DzqyYztw=
X-Google-Smtp-Source: AGHT+IEDsNd7eXwxh1LNnWZAg+qaWrGjiIX7dw+Do6ISHYsemNHEnLpvwqGM9Tfm4J6v2gaWSRAzM890tlGOr2xWHTQ=
X-Received: by 2002:a17:907:1dd0:b0:9a2:1df2:8e08 with SMTP id
 og16-20020a1709071dd000b009a21df28e08mr2292155ejc.45.1693417125551; Wed, 30
 Aug 2023 10:38:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230828101149.146126827@linuxfoundation.org> <5b30ff73-46cb-1d1e-3823-f175dbfbd91b@roeck-us.net>
 <2023083014-barley-upscale-518e@gregkh> <64374066-4086-3e92-8650-ab1563350f0c@roeck-us.net>
 <95baa835-9940-a257-cf96-93c543aa389f@gmail.com>
In-Reply-To: <95baa835-9940-a257-cf96-93c543aa389f@gmail.com>
From: Manuel Lauss <manuel.lauss@gmail.com>
Date: Wed, 30 Aug 2023 19:38:09 +0200
Message-ID: <CAOLZvyEuj=93tpObwDgyAK01Jyz8NfXQzJfAX5=vVwG1wxo-cA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/84] 5.10.193-rc1 review
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable <stable@vger.kernel.org>, patches@lists.linux.dev, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	Pavel Machek <pavel@denx.de>, jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Content-Type: text/plain; charset="UTF-8"

Hello all,

Florian Fainelli <f.fainelli@gmail.com> schrieb am Mi., 30. Aug. 2023, 19:07:
>
> + Manuel,
>
> On 8/30/23 09:01, Guenter Roeck wrote:
> > On 8/30/23 03:52, Greg Kroah-Hartman wrote:
> >> On Mon, Aug 28, 2023 at 09:42:11AM -0700, Guenter Roeck wrote:
> >>> On 8/28/23 03:13, Greg Kroah-Hartman wrote:
> >>>> This is the start of the stable review cycle for the 5.10.193 release.
> >>>> There are 84 patches in this series, all will be posted as a response
> >>>> to this one.  If anyone has any issues with these being applied, please
> >>>> let me know.
> >>>>
> >>>> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> >>>> Anything received after that time might be too late.
> >>>>
> >>>
> >>> FWIW, commit 619672bf2d04 ("MIPS: Alchemy: fix dbdma2") should be
> >>> reverted
> >>> v5.10.y since it doesn't fix anything but breaks the build for
> >>> affected boards
> >>> completely.
> >>>
> >>> arch/mips/alchemy/common/dbdma.c: In function 'au1xxx_dbdma_put_source':
> >>> arch/mips/alchemy/common/dbdma.c:632:14: error:
> >>> 'dma_default_coherent' undeclared
> >>>
> >>> There is no 'dma_default_coherent' in v5.10.y.
> >>
> >> But that was added in 5.10.185, from back in June.  What changed to
> >> suddenly cause this to fail now?
> >>
> >
> > Nothing. I started to build this configuration and tracked down the
> > problem after the build failure was reported by others. Sorry, I didn't
> > initially realize that this is an old problem.
>
> We could back port 6d4e9a8efe3d59f31367d79e970c2f328da139a4 ("driver
> core: lift dma_default_coherent into common code") but that won't work
> too well on 4.14 or 4.19. I believe it would be simpler to adjust the
> branches with this patch, Manuel does that work?

Please drop this patch from all stable releases. I didn't CC stable
when I submitted it,
and have no idea why it ended up there anyway.
It was intended to fix a problem initially found in 5.18 (I think).

Thanks!
        Manuel
