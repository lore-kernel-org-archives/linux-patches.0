Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C2C15EA3
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 15:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r/53Gvsx"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3b2ec5ee2e4so2382863b6e.3
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 08:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698073900; x=1698678700; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U3pUWaYV0MHOvPseFbWxT/RBFgiDxlKuLFygzevJvjk=;
        b=r/53Gvsxvi1kLiqNX02S7Y4lmuTOTleyPb0UBxz7IrFnLpKI92XT1asc7JvxcsN+W4
         s+5rKJwefmhp9LfAQIXb0XKjZi++ydWXdl8SvIQfrsfZwNl1YhMWmJMuhsLlc8YSYls6
         nysbEP4AKLD/mEecF/Hr0JXxHBDUygJ/Jvo7BCdScVqVYHEKUVJc8rkoQM3HK8R13apA
         Cs0yqakG+9HN6rANwdOO8v/5njrE3XRmUcE1I6YRwIseZjBtOPtCfFX8Wryfz+z9N2dq
         xHh/r/YySw12mOxUh1HQ0bx9QPpDbc/Dsiqil/vso3JqJp/HzcLtzwjnLCJ24Nxfijbq
         eaAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698073900; x=1698678700;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U3pUWaYV0MHOvPseFbWxT/RBFgiDxlKuLFygzevJvjk=;
        b=FvbWCiYx++RZBYsmD98Re1U2YpwjBfUYmYkMlpv+g4aIhJnDvc7R5JOb+1oDWfGXOQ
         SsCG52jWstKoiLNQTyGIITOQ6T3g9atOhQL93lJx6NewDrEI8wH0uucdqaqSPhnP+e92
         DKG+MWsJc5EGnv8Nb+0GBG9hlB7+jyICknvsou00/iGvbCnjgPAeWJk1B2RNis/5Vjah
         Arqghg+JrZ0P+nJNV8D8AkAXeZ5IEw13g4sDB9yct06RJBhIol46/vtbWHeTdBnxzPgc
         bc8iaoacVw1eq0do2GegppBME+u1qVneyiSezJemeP3NfGS8XjIR85b2zSUHs5J2so3y
         d1WA==
X-Gm-Message-State: AOJu0YyhF9ejW8hmMxrl4DIqWxHjpitq7Eb+fUNBeMI22hb3wdC67eho
	xZlUZoEIU3+X8spedf4bYFg+oQ==
X-Google-Smtp-Source: AGHT+IGcKp4/eFPOWrpY5TtmEIBGpd+oYq18I+HIjdd/mGHJ37Djqu2HS8GusX9DKnUfaoEQWTwTrw==
X-Received: by 2002:a05:6808:188:b0:3a7:4876:6044 with SMTP id w8-20020a056808018800b003a748766044mr10467355oic.52.1698073900151;
        Mon, 23 Oct 2023 08:11:40 -0700 (PDT)
Received: from [192.168.17.16] ([138.84.45.126])
        by smtp.gmail.com with ESMTPSA id 4-20020aca1004000000b003af642cf646sm1513574oiq.37.2023.10.23.08.11.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 08:11:39 -0700 (PDT)
Message-ID: <724521b8-9c63-4645-b3e0-30d9635573a7@linaro.org>
Date: Mon, 23 Oct 2023 09:11:36 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/137] 5.15.137-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231023104820.849461819@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 23/10/23 4:55 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.137 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.137-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We see lots of errors on Arm 32-bits:

-----8<-----
/builds/linux/drivers/gpio/gpio-vf610.c:249:11: error: 'IRQCHIP_IMMUTABLE' undeclared here (not in a function); did you mean 'IS_IMMUTABLE'?
   .flags = IRQCHIP_IMMUTABLE | IRQCHIP_MASK_ON_SUSPEND
            ^~~~~~~~~~~~~~~~~
            IS_IMMUTABLE
/builds/linux/drivers/gpio/gpio-vf610.c:251:2: error: 'GPIOCHIP_IRQ_RESOURCE_HELPERS' undeclared here (not in a function)
   GPIOCHIP_IRQ_RESOURCE_HELPERS,
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/builds/linux/drivers/gpio/gpio-vf610.c:251:2: warning: excess elements in struct initializer
/builds/linux/drivers/gpio/gpio-vf610.c:251:2: note: (near initialization for 'vf610_irqchip')
/builds/linux/drivers/gpio/gpio-vf610.c: In function 'vf610_gpio_probe':
/builds/linux/drivers/gpio/gpio-vf610.c:340:2: error: implicit declaration of function 'gpio_irq_chip_set_chip'; did you mean 'gpiochip_get_data'? [-Werror=implicit-function-declaration]
   gpio_irq_chip_set_chip(girq, &vf610_irqchip);
   ^~~~~~~~~~~~~~~~~~~~~~
   gpiochip_get_data
cc1: some warnings being treated as errors
----->8-----

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Affected builds:
* clang-17-defconfig                  arm
* clang-17-imx_v6_v7_defconfig        arm
* clang-17-lkftconfig                 arm
* clang-17-lkftconfig-no-kselftest-frag arm
* clang-nightly-lkftconfig-kselftest  arm
* gcc-8-defconfig                     arm
* gcc-8-imx_v6_v7_defconfig           arm
* gcc-12-defconfig                    arm
* gcc-12-lkftconfig                   arm
* gcc-12-lkftconfig-debug             arm
* gcc-12-lkftconfig-debug-kmemleak    arm
* gcc-12-lkftconfig-kasan             arm
* gcc-12-lkftconfig-kselftest         arm
* gcc-12-lkftconfig-kselftest-kernel  arm
* gcc-12-lkftconfig-kunit             arm
* gcc-12-lkftconfig-libgpiod          arm
* gcc-12-lkftconfig-no-kselftest-frag arm
* gcc-12-lkftconfig-perf              arm
* gcc-12-lkftconfig-perf-kernel       arm
* gcc-12-lkftconfig-rcutorture        arm

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

