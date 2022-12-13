Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB8828EF
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 10:05:57 +0000 (UTC)
Received: by mail-vs1-f48.google.com with SMTP id 3so14110323vsq.7
        for <patches@lists.linux.dev>; Tue, 13 Dec 2022 02:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XMzzFTvuqaMziGtwkJpPvbzIY0Mb8qOTWg1NfkHEVhE=;
        b=JIrF0JrjEbC22Xe6s6IPvHqn0qMEb89jhAc1+irAGXJYCtQqITTSxVN8qDSZsBoAeA
         Aaqr31a2yqCR0CihwMb8QpsIsVzFpGH9JjnQeEwM9vmHQ5iktcAwRTLotk6sR/SUPCop
         lU42FjqrvgCiNST4BOzA05muKUsiQZey/riVqY1EyplKc6C9WA5IQpeBY3WdhQCTrXEK
         fgp/TcuKmt8/8a+Nm59w6TjpWHQjx7UXgbLp0kRcuV20NpDhjJU1lL+DdUniWlWJb7wF
         VfoA3PlKY+HefsP+6mjk6Khg7uHcn9jkBOR9oKGiqR4JuqJ23T7ukicXjB9FvwDfgAJa
         +khQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XMzzFTvuqaMziGtwkJpPvbzIY0Mb8qOTWg1NfkHEVhE=;
        b=iH2y85PJsEFLxErRp6IWJla8ffaHsyd/KROD40t0F4zAy7RV6QcszEKtQdy4U/v6+q
         9R7R0PL0J+Fyy4Fbxhek/pOQfgTz9B+mr7/I7KQvLPoM0v8ehIim4vuT5phShsdlt1z7
         Yjtu5qG9sKy2HSk514R9qSwxyO+dkPkSI/MIOrg0X0sPdjllZ7/rs9jN5IULxk7V+6vC
         mh2b7x4L51Y7q9g45gS5BXGjCFIV5Yw8Q60mbbHPV+GoeTKpWyUBoe9RzYvMoz06ytFJ
         wYgzc/KC6pNunitKYdlUjoxCSMZd7/L+yzDf69ZSDfscp0MYt9Iik26zMrPs1sZA1yl7
         LrgA==
X-Gm-Message-State: ANoB5pmswKJMzFxO8z8b302V/e/S5p0k/9zQ3kzajyN/Mr1yVt2UK/ud
	mlcW64kzueFpIzgdZ32Sea1OGGMN9EX3ICexfxLH7g==
X-Google-Smtp-Source: AA0mqf7vpSlMQ7Ef8ekL/1O2JwgvLvwzON3XuqsxRGCJcCtaYNlJG/cxmKIIJCa9o9rRzJFCC+FwwmxHhtbLGjWE/NQ=
X-Received: by 2002:a05:6102:3590:b0:3aa:eee:5bc9 with SMTP id
 h16-20020a056102359000b003aa0eee5bc9mr44049108vsu.24.1670925955828; Tue, 13
 Dec 2022 02:05:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221212130924.863767275@linuxfoundation.org> <CA+G9fYv7tm9zQwVWnPMQMjFXtNDoRpdGkxZ4ehMjY9qAFF0QLQ@mail.gmail.com>
 <86c7e7a5-6457-49c5-a9e3-b28b8b8c1134@app.fastmail.com>
In-Reply-To: <86c7e7a5-6457-49c5-a9e3-b28b8b8c1134@app.fastmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 Dec 2022 15:35:44 +0530
Message-ID: <CA+G9fYtNvr-82FG23mkKj2LAMtS87hGEEpjZsGNUhr8oPU6O2A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, YueHaibing <yuehaibing@huawei.com>, 
	Netdev <netdev@vger.kernel.org>, stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Guenter Roeck <linux@roeck-us.net>, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, 
	Pavel Machek <pavel@denx.de>, Jon Hunter <jonathanh@nvidia.com>, 
	Florian Fainelli <f.fainelli@gmail.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net, 
	rwarsow@gmx.de, Jakub Kicinski <kuba@kernel.org>, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 13 Dec 2022 at 14:50, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, Dec 13, 2022, at 08:48, Naresh Kamboju wrote:
> > On Mon, 12 Dec 2022 at 18:43, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >
> > Regression detected on arm64 Raspberry Pi 4 Model B the NFS mount failed.
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > Following changes have been noticed in the Kconfig file between good and bad.
> > The config files attached to this email.
> >
> > -CONFIG_BCMGENET=y
> > -CONFIG_BROADCOM_PHY=y
> > +# CONFIG_BROADCOM_PHY is not set
> > -CONFIG_BCM7XXX_PHY=y
> > +# CONFIG_BCM7XXX_PHY is not set
> > -CONFIG_BCM_NET_PHYLIB=y
>
> > Full test log details,
> >  - https://lkft.validation.linaro.org/scheduler/job/5946533#L392
> >  -
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.158-107-gd2432186ff47/testrun/13594402/suite/log-parser-test/tests/
> >  -
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.158-107-gd2432186ff47/testrun/13594402/suite/log-parser-test/test/check-kernel-panic/history/
>
> Where does the kernel configuration come from? Is this
> a plain defconfig that used to work, or do you have
> a board specific config file?
>
> This is most likely caused by the added dependency on
> CONFIG_PTP_1588_CLOCK that would lead to the BCMGENET
> driver not being built-in if PTP support is in a module.

Here is the build command which is the same for working and not working
kernels.

# tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
--kconfig defconfig
 --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/lkft.config
 --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/lkft-crypto.config
 --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/distro-overrides.config
 --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/systemd.config
 --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/virtio.config
 --kconfig-add CONFIG_ARM64_MODULE_PLTS=y
 --kconfig-add CONFIG_SYN_COOKIES=y
 --kconfig-add CONFIG_SCHEDSTATS=y CROSS_COMPILE_COMPAT=arm-linux-gnueabihf-

- Naresh

>
>      Arnd
