Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48A61D53E
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 17:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DKWJwkGD"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6b20577ef7bso2696922b3a.3
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 10:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698081405; x=1698686205; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8UmNA3JhvAwp9p6qqygcIMsmnra1xRqmMhLwxS7P5RI=;
        b=DKWJwkGDUJcZRTaQgjwJ558ILmyeQxYk3cIE1JhxuRneorJPfM1cVL9bIXO8pRFu0c
         /N0XjmbxpdmGVprH8zGYna4pZ/+doI2tbr1x04dnfY5JhN9kWFqdEoQKJN1bO10nQ/nA
         9NroyVMO8rMDEbRAeDWdmt+/xl62D62Mo3YMFqTM9NAK5vPM89rsxlxzGr4H9VirrOhs
         8t28mXbapPvGzALLpJaxwbwevzNhvn/onjQeRaGuRw3ExCXsAWtkNe1PHxphlvs6ztdC
         0Osllw8XAIF206cQlAWYpcqpaPdjlrW+7iY+x1ra/j8dKFqHnjN6gdUaRFfOpI/6xucw
         6oEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698081405; x=1698686205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8UmNA3JhvAwp9p6qqygcIMsmnra1xRqmMhLwxS7P5RI=;
        b=L7hj9LBy+xgg/4TxRTi37hx736dGqnw35cYxh29iQw6i/FLvgkXJRYfE1onBLpvUUO
         vvQmzVrlws0HAR3KJcM0LhOp6UbUKNnWN4VL9JkFMPBx24XTYXZd5b+msLtPcTzyAHgx
         sENm4Y6d0+ed8M6TXkteTmYiYeG8gO78atVmvTPQ0rXWpyA+n7PNf/maQ8HJpjLyK+SK
         +UBZfM1UeSMTeSesshCdaPNBHPKLsN6i7MLcS6J2woWfa09vKvgbU9D1yQRpLgWyjtXL
         Up89xDuateUjJvypp7wOwd8wllLbGsq5go4KNBJQteoE/cVRoWGg00HtJdjjBUbuTT7e
         x78Q==
X-Gm-Message-State: AOJu0Yx9ng+yK/wGpw8+/D9A1gG8vWAuukkBqLBuqgG/6w7OUb6l8vqk
	n47JLAByskrfenJ9SM2wkWmtYFpnI1R4I595BJNW3Q==
X-Google-Smtp-Source: AGHT+IGjInKpQgIG1aOOsF/TPL8qt6E39iqr99A3ZlMym6netNqwXxSEhKKw32twN44OhP4SWSJB0+MDVHKQffPtg9k=
X-Received: by 2002:a05:6a20:4299:b0:15e:bcd:57f5 with SMTP id
 o25-20020a056a20429900b0015e0bcd57f5mr285107pzj.3.1698081404981; Mon, 23 Oct
 2023 10:16:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231023104820.849461819@linuxfoundation.org> <724521b8-9c63-4645-b3e0-30d9635573a7@linaro.org>
In-Reply-To: <724521b8-9c63-4645-b3e0-30d9635573a7@linaro.org>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Mon, 23 Oct 2023 11:16:33 -0600
Message-ID: <CAEUSe7-zbuRsgsr2EYq+OeW9iEJyZHmo8u9K3pDCAFRKnCEv0A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/137] 5.15.137-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Mon, 23 Oct 2023 at 09:11, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wro=
te:
> On 23/10/23 4:55 a. m., Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.137 release.
> > There are 137 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.137-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> We see lots of errors on Arm 32-bits:
>
> -----8<-----
> /builds/linux/drivers/gpio/gpio-vf610.c:249:11: error: 'IRQCHIP_IMMUTABLE=
' undeclared here (not in a function); did you mean 'IS_IMMUTABLE'?
>    .flags =3D IRQCHIP_IMMUTABLE | IRQCHIP_MASK_ON_SUSPEND
>             ^~~~~~~~~~~~~~~~~
>             IS_IMMUTABLE
> /builds/linux/drivers/gpio/gpio-vf610.c:251:2: error: 'GPIOCHIP_IRQ_RESOU=
RCE_HELPERS' undeclared here (not in a function)
>    GPIOCHIP_IRQ_RESOURCE_HELPERS,
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> /builds/linux/drivers/gpio/gpio-vf610.c:251:2: warning: excess elements i=
n struct initializer
> /builds/linux/drivers/gpio/gpio-vf610.c:251:2: note: (near initialization=
 for 'vf610_irqchip')
> /builds/linux/drivers/gpio/gpio-vf610.c: In function 'vf610_gpio_probe':
> /builds/linux/drivers/gpio/gpio-vf610.c:340:2: error: implicit declaratio=
n of function 'gpio_irq_chip_set_chip'; did you mean 'gpiochip_get_data'? [=
-Werror=3Dimplicit-function-declaration]
>    gpio_irq_chip_set_chip(girq, &vf610_irqchip);
>    ^~~~~~~~~~~~~~~~~~~~~~
>    gpiochip_get_data
> cc1: some warnings being treated as errors
> ----->8-----

Bisection points to "gpio: vf610: make irq_chip immutable" (upstream
commit e6ef4f8ede09f4af7cde000717b349b50bc62576).

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
