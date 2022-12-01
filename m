Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CBD7473
	for <patches@lists.linux.dev>; Thu,  1 Dec 2022 16:48:09 +0000 (UTC)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-3b48b139b46so22878097b3.12
        for <patches@lists.linux.dev>; Thu, 01 Dec 2022 08:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v6lyHoHVTKEoHn2BpYu6Y3TDsg6KZVLToH9RQug1Qs8=;
        b=x8SxzLXmt9uvMRWQT8/EvDhuDixlBnrc7L5DPDE6wLUH+d7wu9pURE2pTe02CsCGWD
         BVUpftRcagE9a3Jn3WDf4fJTwt486Xu2MozcrEiEsyoyZMyPxBik3w3XWgoNvxi8m5/i
         ApGaxj8KCnyj7bjulKwoYALtscU5XvSrqFyT6OJbHguQf4ekfGnsU9/jQ7eOzhgNMtI8
         DpL5LXYheat+KqvqU2dnDw6a3IVuIY5DBRcb3YuamW4bmxVQNY6Q1cykQd9ZKaIwzunf
         OeMhTPIR6rDCI4i5JyYxbmjk7mbX442gSuidDjjpTsLhAgUZmp6MIYNCxrabhcM4E020
         ZTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v6lyHoHVTKEoHn2BpYu6Y3TDsg6KZVLToH9RQug1Qs8=;
        b=MH4gEyzjsIp3yGodrOb2Pr90bqPu2ExCXgez0RA3LqHYVNfU8DwOAe6wNa9st6CWoK
         QaMCTp4P3YLYsyd6ensfxRV0O2QD7iIk2dx723xRjwP12rKCug+or1Mku4gmp/cazKVj
         7u7wH8cR3nKJT5qjqagmdTWCVgQjYi0JUSbWWteCt3IxJQsMWxtA45VuZg/9S6QInoht
         YLhtM37Xata6Jdv0u2IAsXBIoDrSJoVDZZelmmkY3glwmAceYpvjP2CA3sj7+TTCOlhz
         koqQFE38/ewmhPoUQhyNeDCFfWhlWsOoWUpAGJDKzl+LxQmL7Ijsa+0xYj+UT4SRHLMR
         Lobg==
X-Gm-Message-State: ANoB5pkBmZOl56AV6VMQxM06JnB2tGIHsMpGpAwsTowMZkl7c63y+x67
	EAuYTCoNppQLpBOp5P+r66nln0NHLRXCsb562XGnHQ==
X-Google-Smtp-Source: AA0mqf6VOaY9LeyYUGBAcsPy0V4iTFjkZ/TmTRlKjH0ow1ItaaZKYmY++xCq82vuhhTIOQytH8f0yG5JTrwesUEG1dk=
X-Received: by 2002:a05:690c:444:b0:3d7:2ccc:12a3 with SMTP id
 bj4-20020a05690c044400b003d72ccc12a3mr7288868ywb.459.1669913285515; Thu, 01
 Dec 2022 08:48:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221130180528.466039523@linuxfoundation.org>
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 1 Dec 2022 22:17:54 +0530
Message-ID: <CA+G9fYtQN2SCStLEd+yJcROUYA6-EVZA2Mu+wpMkM1-BLooPxw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/162] 5.10.157-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Wed, 30 Nov 2022 at 23:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.157 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.157-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.157-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 97b8f00e4c810098e87b79964b78957b3dd7529c
* git describe: v5.10.155-312-g97b8f00e4c81
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.155-312-g97b8f00e4c81

## Test Regressions (compared to v5.10.155)

## Metric Regressions (compared to v5.10.155)

## Test Fixes (compared to v5.10.155)

## Metric Fixes (compared to v5.10.155)

## Test result summary
total: 141429, pass: 123082, fail: 2536, skip: 15574, xfail: 237

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 49 total, 46 passed, 3 failed
* i386: 39 total, 37 passed, 2 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 32 total, 25 passed, 7 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-openat2
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
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
