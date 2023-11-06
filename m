Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB46D156E1
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 18:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PxN7ct/e"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5b999980689so3642299a12.1
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 10:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699294473; x=1699899273; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9eApiH5er5Q+LmkTrIbz1RtOUAFBAp0J1EDavJZLMnI=;
        b=PxN7ct/eJIPfN9ZnZ7PDCdvJ5tYHoMT5oCpRE00GYPC4AO27xrYDq+MOAXGzMlqOYA
         Tbi+CZ+jt/c8o+nZwp0EQBpLI0sK7HS/NfL8gxe4UuP/wvIpWATLqiXf+QgCykTKxGYL
         41ivMLmX+7ctnbLfs5N2V70S1nmp8cyjbtqHsYkQHMHr7obioXobZP+9YYY5EEAphUJc
         0oEr9yWQ+9Eeut1BNstXwkGd2iHmvt8wGtwI4CsYYfMSL3dl1d09XkaMpCP1X+7oAzK6
         VNia0Eg5zXxKITyh30vMnQPnfAj595OgvnLq5oSkT/1ZZycveKquJrB2ou7xQVsGL5Ic
         uJkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699294473; x=1699899273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9eApiH5er5Q+LmkTrIbz1RtOUAFBAp0J1EDavJZLMnI=;
        b=Ly0d7K/G94AU4FztvmQMMRA2+nEXPaQUHu2hqb7depVrsl8C1/Z34Ly70/J/HNOIP4
         vOuXa8wOa3lfCPYq2uKU0CGEgyYdJTi3fo1ZT5oO04aPrgjkhrsiKE8KlF4NznfAcxTT
         Ow1RbEdYtHFE2uW/hQqCHijnDgTHFIucOhXGpaPSc2xVe3o9EYfPTtnqGo23Od/RI8je
         i2fTCniPBDPLvBctjDfSaogJokgaw42/vZj7J1xaGm+2Nkp5uK5q+YUqyPSchMFR1SoS
         esvqOKhkKa/1PA92mikCcdd5kHFhVhwYnIuADayTEmT6YDDYBdg1m9oIgmkBRBwKrt8m
         PM2A==
X-Gm-Message-State: AOJu0YzavbWfqD3lNqzClUtePsCgGD1TgBiOZ5MWYxgQt+z73TVeVCuc
	3cKkJKHw9KAwnUwg4SG+mwTBBlGefyU9pO7xKjaqmQ==
X-Google-Smtp-Source: AGHT+IFxo6QPh+LlR1UORVHDkuRmzt/uzetk8veCXwUog6IYZKml7Dzr0uG/OJNPi7jnuYHy2QaQxVRk5w1zTym/o8o=
X-Received: by 2002:a05:6a20:9188:b0:15e:a8:6bb4 with SMTP id
 v8-20020a056a20918800b0015e00a86bb4mr27161506pzd.8.1699294472848; Mon, 06 Nov
 2023 10:14:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231106130304.678610325@linuxfoundation.org> <8aec1bd5-befc-486c-9e47-7571b937b8c7@linaro.org>
In-Reply-To: <8aec1bd5-befc-486c-9e47-7571b937b8c7@linaro.org>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Mon, 6 Nov 2023 12:14:21 -0600
Message-ID: <CAEUSe7_g2LbOkb6BqqdPha4SX4669O33H0a04sJ7AfbR1wfA_w@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/95] 5.10.200-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, apatel@ventanamicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Mon, 6 Nov 2023 at 11:53, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wrot=
e:
> On 06/11/23 7:03 a. m., Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.200 release.
> > There are 95 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.200-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> There seems to be a problem building for RISC-V with GCC 8, 12, and Clang=
 17. This is with defconfig, allnoconfig, tinyconfig:
>
> -----8<-----
> /builds/linux/drivers/irqchip/irq-riscv-intc.c: In function 'riscv_intc_i=
nit':
> /builds/linux/drivers/irqchip/irq-riscv-intc.c:119:17: error: implicit de=
claration of function 'fwnode_dev_initialized'; did you mean 'zone_is_initi=
alized'? [-Werror=3Dimplicit-function-declaration]
>    119 |                 fwnode_dev_initialized(of_fwnode_handle(node), t=
rue);
>        |                 ^~~~~~~~~~~~~~~~~~~~~~
>        |                 zone_is_initialized
> cc1: some warnings being treated as errors
> make[3]: *** [/builds/linux/scripts/Makefile.build:286: drivers/irqchip/i=
rq-riscv-intc.o] Error 1
> make[3]: Target '__build' not remade because of errors.
> make[2]: *** [/builds/linux/scripts/Makefile.build:503: drivers/irqchip] =
Error 2
> make[2]: Target '__build' not remade because of errors.
> make[1]: *** [/builds/linux/Makefile:1832: drivers] Error 2
> make[1]: Target '__all' not remade because of errors.
> make: *** [Makefile:192: __sub-make] Error 2
> make: Target '__all' not remade because of errors.
> ----->8-----
>
> Currently bisecting.

-----8<-----
Bisection done!
First commit presenting NEW behaviour: 6751b1fbf98ba2c40bbdda22e2e6714a9c27=
b91b

commit 6751b1fbf98ba2c40bbdda22e2e6714a9c27b91b
Author: Anup Patel <apatel@ventanamicro.com>
Date:   Tue Oct 3 10:13:51 2023 +0530

    irqchip/riscv-intc: Mark all INTC nodes as initialized

    [ Upstream commit e13cd66bd821be417c498a34928652db4ac6b436 ]
----->8-----

Reverting that commit makes the build happy again.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
