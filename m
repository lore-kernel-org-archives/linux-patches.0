Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5904654670
	for <patches@lists.linux.dev>; Mon, 11 Dec 2023 21:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y61Avxwl"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6d9dc789f23so3212436a34.3
        for <patches@lists.linux.dev>; Mon, 11 Dec 2023 13:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702328644; x=1702933444; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ktj8wEOwOJtT93Qoj4w+8XeXXw7nxK8KClGQi33+6EU=;
        b=y61AvxwlEWrIJMtJBOd0xuUYTHatEeKhNn/XTvQ4DLp2p0BfdIQnEVOewZJh8S9WAw
         KVYtt5QfVrXcA1ibHsYiPUVWewzBAXzlh2nGn2XyHYKiP3W1YA5g0Q++5tDrfoVrTOyn
         petsQQGmXqUzzihBG+N1jOhhQIErYDZM1Y80JD9cnsOnJHOLfa/xiF67T6zv4nqrDwDi
         g6ftgon9e4K7dvQniQi9kzKPllLwUD2ste694sxu6dts04VU+7T0H6a4ZvN+9t0Nj2BC
         tA/cWERsacLsmZyKey4tiVzo3edQD1HQ2V5XTq0B3UaNhd+SxgtgA2JjoKSdgL7cbfXH
         tvuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702328644; x=1702933444;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ktj8wEOwOJtT93Qoj4w+8XeXXw7nxK8KClGQi33+6EU=;
        b=ZMsovy5YAT/aXu/MvDZWCbGfs3Fdv/eFJeT6HQBWapNaLhmMU9E6lrGjiFsQ3E2spd
         ixOOg833YMIrduOr0S/3MkNcgg3PYDQsVKC4+1OVgxZM/vQp/lZlAWhO5u7PQhtL4Dta
         qbkXJtR2KAXyLsAHc0gDzX9izstjF72VBFt7oJafaiZQyPafZr1Rh0/fOxG9K2vUTd1N
         QqRN7AeMB2RDAT/lsMtx1jBqf6O6WBRvN2Kt9wmOtJVq8yi2rK/pJsMq559B7oBD9wuN
         CgxT5tvvmo36+PHuozGaxUdxgs9fZVrj9jsXIsL/I4A/NXRSpNayjqUVonWEDqD/kGTR
         VOwg==
X-Gm-Message-State: AOJu0Yx2tMHBOWeLX2o05hsbuZ4urCIqXNoa37JARSW1/yIkB4lU1KqK
	wnyvWCFFvwsjYkzqBA2efywZnQ==
X-Google-Smtp-Source: AGHT+IEA9OP/kzB0+/sAZLOnwZ2cQXl9KeyBl3FnZnFIQVntp6ST40h5Ka1h/rFzYDa1Ou71de42hw==
X-Received: by 2002:a9d:6a82:0:b0:6d7:f97d:14c with SMTP id l2-20020a9d6a82000000b006d7f97d014cmr4316698otq.28.1702328644365;
        Mon, 11 Dec 2023 13:04:04 -0800 (PST)
Received: from [192.168.17.16] ([138.84.62.113])
        by smtp.gmail.com with ESMTPSA id n25-20020a0568301e9900b006d9a0bf775asm1850375otr.7.2023.12.11.13.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 13:04:04 -0800 (PST)
Message-ID: <ff65c696-1fde-4e4c-b964-356e81495cab@linaro.org>
Date: Mon, 11 Dec 2023 15:04:00 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/55] 4.19.302-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, arnd@arndb.de
References: <20231211182012.263036284@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231211182012.263036284@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 11/12/23 12:21 p. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.302 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.302-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same problem here as with 4.14. Here's a list of failures:

## Test Regressions (compared to v4.19.301)
* arm, build
   - clang-17-axm55xx_defconfig
   - clang-17-defconfig
   - clang-17-multi_v5_defconfig-aa80e505
   - clang-17-mxs_defconfig
   - clang-17-nhk8815_defconfig
   - clang-17-u8500_defconfig
   - gcc-12-axm55xx_defconfig
   - gcc-12-bcm2835_defconfig
   - gcc-12-defconfig
   - gcc-12-lkftconfig
   - gcc-12-lkftconfig-debug
   - gcc-12-lkftconfig-debug-kmemleak
   - gcc-12-lkftconfig-kasan
   - gcc-12-lkftconfig-kselftest-kernel
   - gcc-12-lkftconfig-kunit
   - gcc-12-lkftconfig-libgpiod
   - gcc-12-lkftconfig-rcutorture
   - gcc-12-multi_v5_defconfig-aa80e505
   - gcc-12-mxs_defconfig
   - gcc-12-nhk8815_defconfig
   - gcc-12-u8500_defconfig
   - gcc-8-axm55xx_defconfig
   - gcc-8-bcm2835_defconfig
   - gcc-8-defconfig
   - gcc-8-multi_v5_defconfig-aa80e505
   - gcc-8-mxs_defconfig
   - gcc-8-nhk8815_defconfig
   - gcc-8-u8500_defconfig

* arm64, build
   - clang-17-defconfig
   - clang-17-defconfig-40bc7ee5
   - clang-17-lkftconfig
   - clang-lkftconfig
   - gcc-12-defconfig
   - gcc-12-defconfig-40bc7ee5
   - gcc-12-lkftconfig
   - gcc-12-lkftconfig-64k_page_size
   - gcc-12-lkftconfig-armv8_features
   - gcc-12-lkftconfig-debug
   - gcc-12-lkftconfig-debug-kmemleak
   - gcc-12-lkftconfig-devicetree
   - gcc-12-lkftconfig-kasan
   - gcc-12-lkftconfig-kselftest-kernel
   - gcc-12-lkftconfig-kunit
   - gcc-12-lkftconfig-libgpiod
   - gcc-12-lkftconfig-rcutorture
   - gcc-8-defconfig
   - gcc-8-defconfig-40bc7ee5


Failure:

-----8<-----
   /builds/linux/drivers/tty/serial/amba-pl011.c: In function 'pl011_dma_tx_refill':
   /builds/linux/drivers/tty/serial/amba-pl011.c:644:20: error: 'DMA_MAPPING_ERROR' undeclared (first use in this function); did you mean 'DMA_TRANS_NOERROR'?
     if (dmatx->dma == DMA_MAPPING_ERROR) {
                       ^~~~~~~~~~~~~~~~~
                       DMA_TRANS_NOERROR
   /builds/linux/drivers/tty/serial/amba-pl011.c:644:20: note: each undeclared identifier is reported only once for each function it appears in
   make[4]: *** [/builds/linux/scripts/Makefile.build:303: drivers/tty/serial/amba-pl011.o] Error 1
   make[4]: Target '__build' not remade because of errors.
----->8-----

Bisection points to the same commit:

   commit 6afe0d46b25850f794626c70aac55cc7f9b774e2
   Author: Arnd Bergmann <arnd@arndb.de>
   Date:   Wed Nov 22 18:15:03 2023 +0100

       ARM: PL011: Fix DMA support
       
       commit 58ac1b3799799069d53f5bf95c093f2fe8dd3cc5 upstream.


A revert helps the build pass.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

