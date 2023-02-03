Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC4D8F60
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 17:19:36 +0000 (UTC)
Received: by mail-oi1-f169.google.com with SMTP id j21so4717106oie.4
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 09:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pu2wfn5AzYDI159ZTO1HeyKu7qZk0yfyx7W3jgIeOVE=;
        b=ifDarwp18RTVOspWsBnP5kAFI0WnULAQScqkMjBdAYUUqR8InNRZ69yKSLSWJjHPOv
         SUaXFBkDIMMwb+gEAAKJ/NQYtupXgX9m4iuNsnQLum1auumtZvTK44wqRupmw/7e7Yck
         mEufxBirD60NTMtPHKBTDfCM8MUdl3k0bPVCxqv4xoHX7Q+ZoPeHjn3tLkAoVyUSNjaU
         VJBMfMHGxWngyOJXTbU2d+bUHOzE4ptkBx0Xw81Tcq4TCAKqfuwYXhRHT1ptsGHED3Qy
         mxY8bQ3QCUV2TTdmdkC0drWXLeJUbFY0XU35YZt/fZxLtGpnOVMxlC1PIWYL1UdD4RUJ
         CSCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pu2wfn5AzYDI159ZTO1HeyKu7qZk0yfyx7W3jgIeOVE=;
        b=KmEeivHe4iVoGypKM4Oqhoq8dX0TQ7mhT/Je/pYV4injyV7Hx96bX4SgaI5ferlN8i
         e6vC8tcVB5F7elV+2hAvO+9mr58hJurnC25PrcGDObjNphfUE27oQaNWX127YAczPVXd
         ZDgrrdd7HqXi5kCUVSNp/enWDlmRDkbPP+GMtSczkiWKEHbfn12e0qa6MeUSjdWGJsht
         3LFmlirDLHUXi1mNgdBO/Fp5u6JKIV3HV0j8073n8LwuF6S7K3q11R+qUdBLKypDBOns
         Ifd/OZNxE7A5uVSGHWp8dKLgNcW98BwwF6+JnlaT3BvzEYsopDjn7pws68UXP8anQ2dz
         CWcg==
X-Gm-Message-State: AO0yUKV0kwTvikQjsXk5guBuY5Af0XAvqKyca7+JBH6vxTUJscF/H0jZ
	UCwgRu1VEUelDYS9L6Ruen0=
X-Google-Smtp-Source: AK7set+D5X0wa02/3cQ0ZCwH/NMpIDZvtogU0AmhrvIURoSxcPLDl5X+ZoTLCkV6+iz5Xr1ZFoliRQ==
X-Received: by 2002:aca:5a86:0:b0:364:e913:3a9 with SMTP id o128-20020aca5a86000000b00364e91303a9mr4598760oib.49.1675444775728;
        Fri, 03 Feb 2023 09:19:35 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b3-20020aca6743000000b0037854b52db4sm967724oiy.55.2023.02.03.09.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 09:19:35 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 3 Feb 2023 09:19:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
	Gaosheng Cui <cuigaosheng1@huawei.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH 4.19 00/80] 4.19.272-rc1 review
Message-ID: <20230203171934.GB1500930@roeck-us.net>
References: <20230203101015.263854890@linuxfoundation.org>
 <CA+G9fYvd8D3LfxPg2afZXKFC3WNHrhyE7c3fFLViaG4WhJeHVg@mail.gmail.com>
 <Y907af0mqs6RbgjI@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y907af0mqs6RbgjI@kroah.com>

On Fri, Feb 03, 2023 at 05:50:49PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Feb 03, 2023 at 04:34:40PM +0530, Naresh Kamboju wrote:
> > On Fri, 3 Feb 2023 at 15:48, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 4.19.272 release.
> > > There are 80 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.272-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > 
> > Following patch caused build error on arm,
> > 
> > > Gaosheng Cui <cuigaosheng1@huawei.com>
> > >     memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()
> > 
> > drivers/memory/mvebu-devbus.c: In function 'mvebu_devbus_probe':
> > drivers/memory/mvebu-devbus.c:297:8: error: implicit declaration of
> > function 'devm_clk_get_enabled'
> > [-Werror=implicit-function-declaration]
> >   297 |  clk = devm_clk_get_enabled(&pdev->dev, NULL);
> >       |        ^~~~~~~~~~~~~~~~~~~~
> > drivers/memory/mvebu-devbus.c:297:6: warning: assignment to 'struct
> > clk *' from 'int' makes pointer from integer without a cast
> > [-Wint-conversion]
> >   297 |  clk = devm_clk_get_enabled(&pdev->dev, NULL);
> >       |      ^
> > cc1: some warnings being treated as errors
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > Build link, https://storage.tuxsuite.com/public/linaro/lkft/builds/2LDxPVbsGpzKKtYLew33pC6wCSc/
> 
> Ick, sorry about that, I'll go drop the offending patch now and push out
> a -rc2.

Wait a minute, you have more issues to fix.

Guenter
