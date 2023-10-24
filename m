Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3A17461
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hdnshr6g"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40907b82ab9so7859065e9.1
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 01:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698137699; x=1698742499; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K1736lalVb+Wj8lvqQcjrdbk9CZDipYLCDP3xDqokVo=;
        b=Hdnshr6glh7tO5AJHR6fk7GSGfTaLQQy+e2yoQmeVYDErY8feFqxVpMgZZSTHlNpmI
         m/Je3DBRTJa+L/Kk/zm4bTc5DyZlX0j3CPfvFM1Bz8KNk4lCz65iFSYsxL/Oi3Uc345r
         enQCR/uj7yTbtdbbyxhBuqroc/UQo4lhLWpXmA9XaQ4X7Kkknknp/vN6O0pZ3AC0XpSA
         jD7EWrnDSRLpi5OW3JUHenHGNlODKw5sL+FHmOH7GJZDe0fiFhhOAB1FMuSr6dgGTkZc
         kfIqV+M0xVIUXMsQSiPWuSb8JdP9+11NkfaZEbZU9DQLcWxus7YdNiqXb/LV/mmtke5F
         PCFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698137699; x=1698742499;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K1736lalVb+Wj8lvqQcjrdbk9CZDipYLCDP3xDqokVo=;
        b=EMIce+WmIO83pGjf6emObM+3pAGsFbwtlM3r0onF6rCbwHgUD+x6QL60QeV+JjYP3S
         nYuFDKlRrvQs0N7O2NoId1GUZqrw/611ChgGsogPHLQJdlnv3s336WtaXGXms2raxUft
         3feQAG8Z/UxO7v0nlhAwcHX2gCKH6xNksdRaLhn2ixo/00Lip9YftV2qT0QghzsMXRFY
         agBodf3yD3OWoVB0U/3dOthNFTmUT+MFcJ+KVvDuEEcdL83g8VJ0iFnKEQePrIcgoTZ3
         Ch7j+w36G74awfC8K6cwT1EaMUVNWAs5IBBYJS400uWtT7vFBcrtWN6FjN82oBIxAZKh
         yB+A==
X-Gm-Message-State: AOJu0YzrcQT1UU0RgalGiw+zsjXiNtarpJmdPKxaO8om+9u1LfJzhbCe
	10lEyB+GHQTE7IB17+UwG6g=
X-Google-Smtp-Source: AGHT+IF1ZEUhjIgBV17M+3sRkKelTrhlCGO1k5suPfx36p65ojRME0h8aK2m+4F5BWyzTgyj0urmIg==
X-Received: by 2002:a05:600c:2b10:b0:407:73fc:6818 with SMTP id y16-20020a05600c2b1000b0040773fc6818mr14477492wme.2.1698137698854;
        Tue, 24 Oct 2023 01:54:58 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id u25-20020a05600c00d900b004068495910csm16006675wmm.23.2023.10.24.01.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 01:54:58 -0700 (PDT)
Date: Tue, 24 Oct 2023 09:54:56 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/137] 5.15.137-rc1 review
Message-ID: <ZTeGYAH1WezbIKWK@debian>
References: <20231023104820.849461819@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>

Hi Greg,

On Mon, Oct 23, 2023 at 12:55:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.137 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230511):
mips: 62 configs -> no failure
arm: 99 configs -> failed
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
arm builds are failing with the error:
drivers/gpio/gpio-vf610.c:251:9: error: 'GPIOCHIP_IRQ_RESOURCE_HELPERS' undeclared here (not in a function)
  251 |         GPIOCHIP_IRQ_RESOURCE_HELPERS,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpio/gpio-vf610.c:251:9: warning: excess elements in struct initializer
drivers/gpio/gpio-vf610.c:251:9: note: (near initialization for 'vf610_irqchip')
drivers/gpio/gpio-vf610.c: In function 'vf610_gpio_probe':
drivers/gpio/gpio-vf610.c:340:9: error: implicit declaration of function 'gpio_irq_chip_set_chip' [-Werror=implicit-function-declaration]
  340 |         gpio_irq_chip_set_chip(girq, &vf610_irqchip);


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/5359
[2]. https://openqa.qa.codethink.co.uk/tests/5360
[3]. https://openqa.qa.codethink.co.uk/tests/5373

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
