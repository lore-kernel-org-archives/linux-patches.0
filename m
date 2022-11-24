Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814472589
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 13:01:45 +0000 (UTC)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-3704852322fso15023917b3.8
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 05:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6rAZ7pWAiorVAjOuH7ZY0Tu0xEScvSbIVQK0TciWFFs=;
        b=pgvqkb7EZQWfC9mtKZMK4aVe9tfAGBM2X8cHjSrTT3D9J8Scl4pthlH304AYfceoGL
         dTC5I7wLld+p2MpLJGYxtVYWuKNxiPAu58WyBewbU+ewSlp6GHvhzMI9597TqdvcLd2W
         p5ic5MibJv88CCbBwSW0lJ/L3OYYck8jyY4MWkXWz3YBMdx8feZuCwESI2T7lIzbN2OG
         euuinNHIGEixdhwchQ4YGPQ1S+8wmbTBO1re2FWiaCyXnXlQZc2Zt8Vyd0p+S0HZkkNy
         OtUThgCaRWvwpQPkv2Mlx9rf6YtuPlIh0FqafWbNz0ekAta6QjJf8U/8i2VrRVhFH3YW
         u8UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6rAZ7pWAiorVAjOuH7ZY0Tu0xEScvSbIVQK0TciWFFs=;
        b=tN+QRh5/h0Q+2HbIwB5UelrD/gDOqmqHuiA+9uRl/LxtH+LdPAC+RfMzWSqFJQ0oa9
         Wkehyb5/GO/ogsqfFtpUkJCOZGoZwmmJxI0QGwAoiAVUPfwCbD6Cnh1I08nsjeuxPtWX
         HACdaEuKTqyxqEjWyzNM7CfUdRTXSqg27f7qk2ppreBaVtE6K+dOWDpjFohVfDxWY/JY
         OohSwpO07bThnJ5M+Xh5WkgbsvZhmCKJ1wBEvDavhF4f36gUHZOuu4Eo5BzOzYKHEsye
         y5locFrCtusCQTYA7/WDqY8tFRKCVMKqhmv2SS3kkYESI8ww5DJYRVNzMrQU3YYl+h5S
         9JWQ==
X-Gm-Message-State: ANoB5pk2tH04l/cpOCmF8Oo5OY0G7m5Yad0h3FRiLV8ysn6b3LmNIc+0
	jLqn0/+jp4EUuxpFfSBR07xMsM8l2a28Ti3SpGXvnA==
X-Google-Smtp-Source: AA0mqf7caecl2IUUdCRyeAjjuLENTXoRLc3A1wYQ4qxXDAI6X3TupoCj5j2/c9DSBco/6CuVEzeW1A+IhTWbqJX/Hvs=
X-Received: by 2002:a81:553:0:b0:370:4438:38e6 with SMTP id
 80-20020a810553000000b00370443838e6mr15034528ywf.232.1669294904030; Thu, 24
 Nov 2022 05:01:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221123084546.742331901@linuxfoundation.org>
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 24 Nov 2022 18:31:32 +0530
Message-ID: <CA+G9fYvUXyA-Mn1kYzLUGaKm5kq7XB2mNCWUrbvHUfgQxi0qPQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/76] 4.9.334-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Nov 2022 at 14:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.334 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.334-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.334-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 48639dd0eaccd88a77f3a3ca4c609915a94fcf79
* git describe: v4.9.333-77-g48639dd0eacc
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.333-77-g48639dd0eacc

## Test Regressions (compared to v4.9.333-65-ga31fc950024b)

## Metric Regressions (compared to v4.9.333-65-ga31fc950024b)

## Test Fixes (compared to v4.9.333-65-ga31fc950024b)

## Metric Fixes (compared to v4.9.333-65-ga31fc950024b)

## Test result summary
total: 66462, pass: 57530, fail: 829, skip: 7490, xfail: 613

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 280 total, 277 passed, 3 failed
* arm64: 51 total, 46 passed, 5 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 40 passed, 1 failed
* parisc: 12 total, 0 passed, 12 failed
* powerpc: 45 total, 19 passed, 26 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 48 total, 47 passed, 1 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
* kselftest-breakpoints
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-lib
* kselftest-net-forwarding
* kselftest-netfilter
* kselftest-openat2
* kselftest-seccomp
* kselftest-timens
* kunit
* kvm-unit-tests
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* rcutorture
* timesync-off
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
