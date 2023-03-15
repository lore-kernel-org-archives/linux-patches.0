Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174F75665
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 16:28:21 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id r36so809534oiw.7
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 09:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678897700;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WVYvcAy8dSxQ/ifYmimSGD1exSiUZr0vNmHxHR4sW1M=;
        b=E5X7b3yylb2zGuLdsnu2FaZg2SVX9HTQSbjTHTH8RL6IR8BdRmyW6dD4stDpUNMDoI
         Nlb0Y0yzg4PBPbcuDx2lKOl34qBbrl1JVeQLWLIw4HuP/3aOGXq8ymZCP7j/zZRzdKiX
         vjWL74Cc7TtcTCHb8OvNdnOyGjl6s7zTy9F1Pxi9Kf0DY/sce9GrYs4oYtH85RmwanBs
         Yw0Nn9FmBZs2A075Q2MYHDgT99Ep841hlSo5XfTNKZDzaJxiHELwI0XzpXkdi4D5JZsN
         QFpZrHbfcVmF84SSM68VXWlGHaCPivT+cevPiDz6MxkzFdNfkRUAOEcJCAz5eDpjyabp
         JlsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678897700;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WVYvcAy8dSxQ/ifYmimSGD1exSiUZr0vNmHxHR4sW1M=;
        b=1+XWAPkYIT46nT5+wDECn+oFjrDwC1i7oP0r1i/8zpea6F/ckmwXJ3GClIuq/XLnQM
         8Z4+vGbAobEIrAs/6RUdTkG1d2FLgijqe/KgaVNGqu7lmvK1zuxtAtt0DDQDmg4j/qPp
         TE/9QE8DOUjrBnCGu3Zr7OTDGhAchmXeXq7Ob4IbKkPswRmIZUNnUuhmR6DlQQT3ySpW
         5g2XlTyHVeWE7b0XKxZSaxMTzPvPSyU6s2VIgBxgiFPiKlW6L4HD8JRGXYY6/gVLlzON
         vQuvifqOEgr7++6g1EuyyZ4VHoKIlsVksoP1q9payHhOjD6kB1GfA0xbdBRVBj0bF8YT
         LEWg==
X-Gm-Message-State: AO0yUKU57kpws9xqrrxgG1ZITH+/LE2r2aa0GxymTySOb2CFt3wi2BAP
	VIGqJZzuzEP37hxj/R7+57/xsw==
X-Google-Smtp-Source: AK7set/s/eT7NOgMztjcEqii0UvOGk2DggthUhbrys8Q7BX9HUjtVGNAJmRl0c/ObnPkQxrHFm2I5g==
X-Received: by 2002:a05:6808:1189:b0:386:9eff:2d62 with SMTP id j9-20020a056808118900b003869eff2d62mr1264417oil.24.1678897698657;
        Wed, 15 Mar 2023 09:28:18 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.75.19])
        by smtp.gmail.com with ESMTPSA id s128-20020acac286000000b00369a721732asm2290756oif.41.2023.03.15.09.28.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 09:28:18 -0700 (PDT)
Message-ID: <c3b1918b-be90-0a85-6f91-83b2c2805f67@linaro.org>
Date: Wed, 15 Mar 2023 10:28:15 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 4.19 00/39] 4.19.278-rc1 review
Content-Language: en-US
From: =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230315115721.234756306@linuxfoundation.org>
 <7e46d536-cc68-4b7c-e56e-cf1b94a925cb@linaro.org>
In-Reply-To: <7e46d536-cc68-4b7c-e56e-cf1b94a925cb@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 15/03/23 09:44, Daniel Díaz wrote:
> Hello!
> 
> On 15/03/23 06:12, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.19.278 release.
>> There are 39 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.278-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Lots and lots of failures, mostly Arm.
> 
> For Arm, Arm64, MIPS, with GCC-8, GCC-9, GCC-10, GCC-11, GCC-12, Clang-16, for some combinations with:
> * axm55xx_defconfig
> * davinci_all_defconfig
> * defconfig
> * defconfig-40bc7ee5
> * lkftconfig-kasan
> * multi_v5_defconfig
> * s5pv210_defconfig
> * sama5_defconfig
> 
> -----8<-----
> /builds/linux/kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function 'get_online_cpus' [-Werror,-Wimplicit-function-declaration]
>          get_online_cpus();
>          ^
> /builds/linux/kernel/cgroup/cgroup.c:2237:2: note: did you mean 'get_online_mems'?
> /builds/linux/include/linux/memory_hotplug.h:258:20: note: 'get_online_mems' declared here
> static inline void get_online_mems(void) {}
>                     ^
> /builds/linux/kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function 'put_online_cpus' [-Werror,-Wimplicit-function-declaration]
>          put_online_cpus();
>          ^
> /builds/linux/kernel/cgroup/cgroup.c:2248:2: note: did you mean 'put_online_mems'?
> /builds/linux/include/linux/memory_hotplug.h:259:20: note: 'put_online_mems' declared here
> static inline void put_online_mems(void) {}
>                     ^
> 2 errors generated.
> make[3]: *** [/builds/linux/scripts/Makefile.build:303: kernel/cgroup/cgroup.o] Error 1
> ----->8-----
> 
> 
> For Arm64, i386 x86, with GCC-11, Perf has a new error:
> 
> -----8<-----
> In function 'ready',
>      inlined from 'sender' at bench/sched-messaging.c:90:2:
> bench/sched-messaging.c:76:13: error: 'dummy' is used uninitialized [-Werror=uninitialized]
>     76 |         if (write(ready_out, &dummy, 1) != 1)
>        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from bench/../perf-sys.h:5,
>                   from bench/../perf.h:18,
>                   from bench/sched-messaging.c:13:
> ----->8-----

Additionally, there's this on Arm with GCC-10, GCC-12, Clang-16 for:
* defconfig
* exynos_defconfig
* lkftconfig
* lkftconfig-debug
* lkftconfig-debug-kmemleak
* lkftconfig-kasan
* lkftconfig-kselftest-kernel
* lkftconfig-kunit
* lkftconfig-libgpiod
* lkftconfig-perf
* lkftconfig-rcutorture

-----8<-----
arch/arm/boot/dts/exynos5422-odroidhc1.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map0: Reference to non-existent node or label "gpu"

arch/arm/boot/dts/exynos5422-odroidhc1.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map1: Reference to non-existent node or label "gpu"

ERROR: Input tree has errors, aborting (use -f to force output)
make[2]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-odroidhc1.dtb] Error 2
arch/arm/boot/dts/exynos5422-odroidxu3.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent node or label "gpu"

arch/arm/boot/dts/exynos5422-odroidxu3.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference to non-existent node or label "gpu"

ERROR: Input tree has errors, aborting (use -f to force output)
make[2]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-odroidxu3.dtb] Error 2
arch/arm/boot/dts/exynos5422-odroidxu3-lite.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent node or label "gpu"

arch/arm/boot/dts/exynos5422-odroidxu3-lite.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference to non-existent node or label "gpu"

ERROR: Input tree has errors, aborting (use -f to force output)
make[2]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-odroidxu3-lite.dtb] Error 2
arch/arm/boot/dts/exynos5422-odroidxu4.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent node or label "gpu"

arch/arm/boot/dts/exynos5422-odroidxu4.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference to non-existent node or label "gpu"

ERROR: Input tree has errors, aborting (use -f to force output)
make[2]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-odroidxu4.dtb] Error 2
----->8-----


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

