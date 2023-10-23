Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42B51848
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 15:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g25Jw8IG"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6ce2cf67be2so2344314a34.2
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 08:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698074984; x=1698679784; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Df/ckkvis1oPgnFdWOtaqrVu8o7llaO/MzOzfRXPKFU=;
        b=g25Jw8IGbqcLnvaHtWkLAENIEArRon8MDbXbTuDNs2FsfUT0HN8hJNDrX9nBghmU79
         U0NVWgecmJP76yLq+BFiWTVkiYBR5qIg+v2Noyc3/IreT/P0m18gDsjvNTa3ltsj39b5
         7hwoIy2mSA67j04NW3JyJBZ7vXD2xNaeq//HT6fzxwknlE73+27feNDKIL+zbVn0JgW6
         c+MtiiQZ9L8OP5nIUrTCCNxEntkG3z3kibZNlTikH0jd1+0tx6VK+HBmY0w35bYmWnYa
         kkqMBtm+7ufFG/GBBxo/EXttb8nQrrHasWQPyAZWJDjp9blI2iCy8rAXsCLNpYV10fFv
         O6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698074984; x=1698679784;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Df/ckkvis1oPgnFdWOtaqrVu8o7llaO/MzOzfRXPKFU=;
        b=wD3K8sqQFynccMd/g6/w+FVqp5WOhbU13D0eEnNfH/YpTBWoSYi2ROewDNKrJwkPm0
         xgoXWxl1Ad7lqe+VnklIGEfOo/rpxdZSQJPWi+0ads3ICXS6xlc+wRjLQY/q4m0k3NUg
         EWWzw5EIMfBKX0GdXGF+FDqx5SLOOfjlOEDoxZdagojJgFHRK4ZwoQ9Ceivp7dz3svAx
         +y8UqzN6LXA2lizmw8jq4EoAhXS2TBxCxYYIFIg4vnTPVd4SiqrLRHXYJF/fWsaaVjs1
         lA7HntAk4/kLXj/k9V92Z1bZz108gGeLcZWelCh5TIDwVVHpKqKW0nmH4eUG2kDbv0vi
         vxNg==
X-Gm-Message-State: AOJu0YyGx+Jcn7zsLKMIfZdKg+dXgzOS2mqnxfYB4ZBnC4Llg6LP/scP
	2noqsFvqDSoxd/6UnrungmE52Q==
X-Google-Smtp-Source: AGHT+IEk4HpqvNSfG2HdlBYVLxnNeHubY0avFEbC0GSyv12pCkrQrwoxI20w2FoA/tz5QOi2vOWS+w==
X-Received: by 2002:a05:6830:4d3:b0:6ce:2733:f71b with SMTP id s19-20020a05683004d300b006ce2733f71bmr9783746otd.26.1698074984668;
        Mon, 23 Oct 2023 08:29:44 -0700 (PDT)
Received: from [192.168.17.16] ([138.84.45.126])
        by smtp.gmail.com with ESMTPSA id l11-20020a9d6a8b000000b006cd2c236b8csm1449655otq.3.2023.10.23.08.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 08:29:44 -0700 (PDT)
Message-ID: <f403e53d-69f9-4254-b9db-bdb1912e4cfa@linaro.org>
Date: Mon, 23 Oct 2023 09:29:42 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/202] 5.10.199-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org
References: <20231023104826.569169691@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 23/10/23 4:55 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.199 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.199-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same problem as 5.15 with GPIO and Arm 32-bits:

-----8<-----
/builds/linux/drivers/gpio/gpio-vf610.c:249:18: error: 'IRQCHIP_IMMUTABLE' undeclared here (not in a function); did you mean 'IS_IMMUTABLE'?
   249 |         .flags = IRQCHIP_IMMUTABLE | IRQCHIP_MASK_ON_SUSPEND
       |                  ^~~~~~~~~~~~~~~~~
       |                  IS_IMMUTABLE
/builds/linux/drivers/gpio/gpio-vf610.c:251:9: error: 'GPIOCHIP_IRQ_RESOURCE_HELPERS' undeclared here (not in a function)
   251 |         GPIOCHIP_IRQ_RESOURCE_HELPERS,
       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/builds/linux/drivers/gpio/gpio-vf610.c:251:9: warning: excess elements in struct initializer
/builds/linux/drivers/gpio/gpio-vf610.c:251:9: note: (near initialization for 'vf610_irqchip')
/builds/linux/drivers/gpio/gpio-vf610.c: In function 'vf610_gpio_probe':
/builds/linux/drivers/gpio/gpio-vf610.c:340:9: error: implicit declaration of function 'gpio_irq_chip_set_chip' [-Werror=implicit-function-declaration]
   340 |         gpio_irq_chip_set_chip(girq, &vf610_irqchip);
       |         ^~~~~~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors
make[3]: *** [/builds/linux/scripts/Makefile.build:286: drivers/gpio/gpio-vf610.o] Error 1
make[3]: Target '__build' not remade because of errors.
make[2]: *** [/builds/linux/scripts/Makefile.build:503: drivers/gpio] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/builds/linux/Makefile:1832: drivers] Error 2
make[1]: Target '__all' not remade because of errors.
make: *** [Makefile:192: __sub-make] Error 2
----->8-----

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Affected builds:
* clang-17-defconfig                  arm
* clang-17-lkftconfig                 arm
* clang-17-lkftconfig-no-kselftest-frag arm
* clang-nightly-lkftconfig-kselftest  arm
* gcc-8-defconfig                     arm
* gcc-8-imx_v6_v7_defconfig           arm
* gcc-12-defconfig                    arm
* gcc-12-imx_v6_v7_defconfig          arm
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

