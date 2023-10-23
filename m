Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A40E1427E
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 15:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="b2d904ev"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5842a94feb2so1881186eaf.0
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 08:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698076391; x=1698681191; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3pESWV7UJ55d7qINlkbCLhWv7/gJJfRWuDRI1OH0PCg=;
        b=b2d904evq+krPf/CTNVY7s02EfopzMf5sG7kWAl7sEq5JJz2ieGcPIrCmloZO9Yk9Y
         Vg/iifrvgGQEtlZxl10m/2PRSe/pyhcRC7GZHX3Hm3ZAkJgTmNVvKeGEn6Kyvpt+TYhW
         cJmxqrH6VlXG3YJlD6CsQsJUUGNkA1Wrnw/0C8uZzKms6pYM9zPiAn2cOSHmU5GwYuOQ
         Q2ScxoHZ7Euc4WQwo6/YOrqpPYW3S48KXzkGZF+cbrU3k14YQ+Z9YRO1/p6HTNG8OMld
         5wH8QgoyHnsipFXc9BjTtoYCLz+ejgHij495V3mBpUEpPi9gEYs+ID1lrHONwacl4gV9
         uSAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698076391; x=1698681191;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3pESWV7UJ55d7qINlkbCLhWv7/gJJfRWuDRI1OH0PCg=;
        b=ArkEHUVo0oTQWGUxpIul79PeoLC4nsvmNiemSkkspITe9HXMt/wwBeDeb91vDzV9DV
         BM6K18R3CSP9+yRKePEkXksZGZxGwaKkQgf/APjgwMjVpKXRuVX1SSuNmNng/HPdjnpn
         KMTo2F/lO/U7HHByKOXuOAHhMtx8rScSJkbDkG+bSNHJzuDez49w2Mx9gVREwZZ0xIld
         mMIiS8myaPFNMCYaiDfUuGX+dkFu2Pf2HiW9D8pjB+wOb7jYpe5ZjCWPFZ1OnV1Tdk30
         2ydLo5xyxpvX2IwqKCjUdb9a1fe7QWRC1hmmenX5kAUyrehQAUU9tNytqloes2jHThSX
         /rHA==
X-Gm-Message-State: AOJu0YwHVtfKfAsXomdUpIy7jcvTedmzSRZJeJ/LuvwRo32gh0OtYpv8
	qgv8e53E7cwuxXK8kCczzeR38g==
X-Google-Smtp-Source: AGHT+IErwb2zGwqwo8mngOGoEHja3MbBSskOnAf8uFSdGqj3xWXSUxOxdB5X5QXTg1fIKty78pKpUw==
X-Received: by 2002:a4a:e64f:0:b0:581:e86d:3e87 with SMTP id q15-20020a4ae64f000000b00581e86d3e87mr8864366oot.4.1698076391243;
        Mon, 23 Oct 2023 08:53:11 -0700 (PDT)
Received: from [192.168.17.16] ([138.84.45.126])
        by smtp.gmail.com with ESMTPSA id r134-20020a4a378c000000b00582014b0138sm1627506oor.39.2023.10.23.08.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 08:53:10 -0700 (PDT)
Message-ID: <eb759f41-db11-4f2e-b3a0-e9e92dea3196@linaro.org>
Date: Mon, 23 Oct 2023 09:53:08 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/123] 5.4.259-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org
References: <20231023104817.691299567@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 23/10/23 4:55 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.259 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.259-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same problems on Arm 32-bits as with 5.10 and 5.15:

-----8<-----
/builds/linux/drivers/gpio/gpio-vf610.c:249:11: error: use of undeclared identifier 'IRQCHIP_IMMUTABLE'
   249 |         .flags = IRQCHIP_IMMUTABLE | IRQCHIP_MASK_ON_SUSPEND
       |                  ^
/builds/linux/drivers/gpio/gpio-vf610.c:250:6: error: use of undeclared identifier 'IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND'
   250 |                         | IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND,
       |                           ^
/builds/linux/drivers/gpio/gpio-vf610.c:251:2: error: use of undeclared identifier 'GPIOCHIP_IRQ_RESOURCE_HELPERS'
   251 |         GPIOCHIP_IRQ_RESOURCE_HELPERS,
       |         ^
/builds/linux/drivers/gpio/gpio-vf610.c:340:2: error: implicit declaration of function 'gpio_irq_chip_set_chip' [-Werror,-Wimplicit-function-declaration]
   340 |         gpio_irq_chip_set_chip(girq, &vf610_irqchip);
       |         ^
4 errors generated.
make[3]: *** [/builds/linux/scripts/Makefile.build:262: drivers/gpio/gpio-vf610.o] Error 1
make[3]: Target '__build' not remade because of errors.
make[2]: *** [/builds/linux/scripts/Makefile.build:497: drivers/gpio] Error 2
/builds/linux/drivers/gpu/drm/drm_lock.c:363:6: warning: misleading indentation; statement is not part of the previous 'if' [-Wmisleading-indentation]
   363 |          */     mutex_lock(&dev->struct_mutex);
       |                 ^
/builds/linux/drivers/gpu/drm/drm_lock.c:357:2: note: previous statement is here
   357 |         if (!drm_core_check_feature(dev, DRIVER_LEGACY))
       |         ^
1 warning generated.
----->8-----

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Affected builds:
* clang-17-defconfig                  arm
* clang-17-imx_v6_v7_defconfig        arm
* clang-17-lkftconfig                 arm
* clang-17-lkftconfig-no-kselftest-frag arm
* clang-nightly-defconfig             arm
* clang-nightly-imx_v6_v7_defconfig   arm
* clang-nightly-lkftconfig            arm
* clang-nightly-lkftconfig-kselftest  arm
* gcc-8-defconfig                     arm
* gcc-8-imx_v6_v7_defconfig           arm
* gcc-10-lkftconfig                   arm
* gcc-10-lkftconfig-debug             arm
* gcc-10-lkftconfig-debug-kmemleak    arm
* gcc-10-lkftconfig-kselftest-kernel  arm
* gcc-10-lkftconfig-libgpiod          arm
* gcc-10-lkftconfig-perf-kernel       arm
* gcc-10-lkftconfig-rcutorture        arm
* gcc-12-defconfig                    arm
* gcc-12-imx_v6_v7_defconfig          arm
* gcc-12-lkftconfig                   arm
* gcc-12-lkftconfig-debug             arm
* gcc-12-lkftconfig-debug-kmemleak    arm
* gcc-12-lkftconfig-kasan             arm
* gcc-12-lkftconfig-kselftest         arm
* gcc-12-lkftconfig-kunit             arm
* gcc-12-lkftconfig-libgpiod          arm
* gcc-12-lkftconfig-no-kselftest-frag arm
* gcc-12-lkftconfig-perf              arm
* gcc-12-lkftconfig-rcutorture        arm

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

