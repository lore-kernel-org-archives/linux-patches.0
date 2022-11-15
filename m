Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB4F1FA0
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 12:02:49 +0000 (UTC)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-381662c78a9so54017237b3.7
        for <patches@lists.linux.dev>; Tue, 15 Nov 2022 04:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ux8QFcJWIOHy95msi/DPXBwY/PKWFOBKNLrmFRGoLJE=;
        b=wJ2e0xBMeihOIaC8JieBaPJG/TuJHqXQEU2+yn713eLHOW7P0jmjUAJc0FzT3BXupM
         HAU/iMV1zGrbfC3heH90e44HKBildUEblpYMRHhu9KYqBdsxxjjnnYKuS3LHLTFsAfr9
         ypRlKjjvaeNGdeX/CYjv99vaNWXU+ZvBP58n8vMspZn8hQmU6ufW269O60upfrH9Izuc
         YThLq5YDiBnk9WT9nU2U0bcxZSCzRxKa9ddNGdGstZZS3OAi43mhBkJIAch+vNcKNtgY
         E6sTKZzyHbeU5xXilalnhbbJFwQpPedzrcNmAM363TMM+/jou/Wqp1Rlo/lWHvLl4xsD
         Zu6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ux8QFcJWIOHy95msi/DPXBwY/PKWFOBKNLrmFRGoLJE=;
        b=DS1AhzaC3AqEQ9ArJsu+WX3VwGtB3NSzTZOc2DgUE3Oysb/TgZ21UTiz57b77XQ7aO
         9qQ596zVIiuZ92Y/L9EOTF0f6OHaWoo58wBbMJCoLAwB85DbZ8PxezivIcBe1iRm2G0l
         e+P/Ifp8pFaf+K2gsBN5He6InvjqlPHwcQY32dmXHt8pvtZxWahbho/De0f/toO2rZbo
         wZ0jKNV3M2op1P2P7xrVL81u6MhLWoqRb61g3rQEP9ClXFAcWLV4nyqVZbqXVrIhXLml
         lpwa2ttJOrPGMQy+oiDy8U/MYyZyfGnCMdNwmmv2ZgBMUbhZKxoJ4PCJbUtPdbmpb+Gq
         Ucrw==
X-Gm-Message-State: ANoB5pmdFHfJ10J+tPmwprHW4UJyZhRsZBWqI2UWlfy6CuJ8HRhCpFaN
	zOAcqS4QZGWv6i2c8H1I4z9EH6t5hg7wOQGRhDRi6Q==
X-Google-Smtp-Source: AA0mqf4peP/pfzhfBwyPbXRi9SZmzgVzjr7Zhw8DsKipwrDO00grFNS7ArT8NL7616EwncYxAW6L0fn/wTkz8o7aafs=
X-Received: by 2002:a81:4f42:0:b0:37c:a694:25b9 with SMTP id
 d63-20020a814f42000000b0037ca69425b9mr14221008ywb.259.1668513768782; Tue, 15
 Nov 2022 04:02:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221114124448.729235104@linuxfoundation.org>
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 15 Nov 2022 17:32:37 +0530
Message-ID: <CA+G9fYs7z7hbf0rcKhhyAkROTnQHnbmOzZ+oTMbW=Es6pu159A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Nov 2022 at 18:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
A part from allmodconfig build failures on arm and arm64
other test reports are looking ok.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.79-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: b6ea7e152210f358e39d05a567697a098aa16e7a
* git describe: v5.15.78-132-gb6ea7e152210
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.78-132-gb6ea7e152210

## Test Regressions (compared to v5.15.78)

## Metric Regressions (compared to v5.15.78)

## Test Fixes (compared to v5.15.78)

## Metric Fixes (compared to v5.15.78)

## Test result summary
total: 63728, pass: 54817, fail: 1467, skip: 7178, xfail: 266

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 287 passed, 2 failed
* arm64: 80 total, 77 passed, 3 failed
* i386: 68 total, 64 passed, 4 failed
* mips: 54 total, 54 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 60 passed, 0 failed
* riscv: 20 total, 20 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 76 total, 72 passed, 4 failed

## Test suites summary
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
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-openat2
* kselftest-seccomp
* kselftest-timens
* kunit
* kvm-unit-tests
* libgpiod
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
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
