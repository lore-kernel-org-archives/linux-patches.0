Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D559F10E6
	for <patches@lists.linux.dev>; Fri,  2 Dec 2022 06:37:31 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id l67so4959983ybl.1
        for <patches@lists.linux.dev>; Thu, 01 Dec 2022 22:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0wfEd2nWOXAO99iFpiBOMFcG5XXUey3320YsBWB09fg=;
        b=jFJ4DgR1mw8gmitD91EYQR8V2dTecvm+fCgN3hozlyfXTme06epJkMemsY3PXuijA7
         ulxTLXteH0Scra0uw3JVMjptiyPGSqlZmHmzXaiaKXpBjvJH/7V2rVWHEjezf620hjgg
         4ZIUZ5H2HiXD1S0Dck8Eyi25QRUa2qKzVHwqjCGGRef3WC4ADwUzvUnQOeYqJnTQqbsE
         ZsxFE7r39pgcKHhe3M5h1re2Ceg+AuogoE9nWu6pXnlAP5XRxdc3Axd/wNghCIL47JQ7
         vlaEUMYQ5FGb7+aUBhZ5/Bm45GmBX5116JUgYKrxiJlxtUyC4PMdERcvDPe/Tx/8L/4S
         lfqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0wfEd2nWOXAO99iFpiBOMFcG5XXUey3320YsBWB09fg=;
        b=6jxWdVKEwdziuikDRnExhLxwsE1TcSSDLQGh+68L+dquR8VoIG+tp4it0FlyJICLPM
         jwthjNqTn/hsqxxwig9S0ZpVGEzAPaK9bYNRfCvEBwjE2tP7Es9XnlICBGC4uGyJRIef
         2KFumPx78FCttP6vS8sG2HsimmvnNP3mfpqQsL/HmCM2O7js0nzD/3CWik5Vx2pnZhrM
         bVf46weGfZey0KXKcOppSwmd3cN9HfAuILZNPCMgVa7Yn2nAugd3ttnopuX3E65PwskL
         O+m5LDS8w55MoF6Ob24RL4Kub10n6XhPWNipXfEGNBamwrHsAfknYqnYQVIrIKHjWQaJ
         wSOQ==
X-Gm-Message-State: ANoB5pnZ5rTY9O0/8qkeWZCZ17H/qqS6zAMPHFHhRbVpK3E+X2CcJl1N
	2IzUlss2cBn5mULQl/vY5i0lZB3SGQFkEKdDOg2Ehg==
X-Google-Smtp-Source: AA0mqf5QVMYfhTVBjiGucrxQENphP17XxGjPMOmH9tIM/Dg4DQPed1xX3OPXqHQIOqNSQENnhEfG//n32gRE2RNYwcg=
X-Received: by 2002:a5b:f0f:0:b0:6d2:5835:301f with SMTP id
 x15-20020a5b0f0f000000b006d25835301fmr56739938ybr.336.1669963050439; Thu, 01
 Dec 2022 22:37:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221201131113.897261583@linuxfoundation.org>
In-Reply-To: <20221201131113.897261583@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 2 Dec 2022 12:07:18 +0530
Message-ID: <CA+G9fYtM6EQh+Qg=bWD5DZeCmWsFuNPVh5tTEq2VD4dEWtqH2Q@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/280] 6.0.11-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Thu, 1 Dec 2022 at 18:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 03 Dec 2022 13:10:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.11-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.0.11-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: 7a60d1d7c4cda7564a42dca46c0a1e358ae4b887
* git describe: v6.0.9-595-g7a60d1d7c4cd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.9-595-g7a60d1d7c4cd

## Test Regressions (compared to v6.0.9)

## Metric Regressions (compared to v6.0.9)

## Test Fixes (compared to v6.0.9)

## Metric Fixes (compared to v6.0.9)

## Test result summary
total: 151978, pass: 129230, fail: 7393, skip: 14991, xfail: 364

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 144 passed, 3 failed
* arm64: 45 total, 45 passed, 0 failed
* i386: 35 total, 34 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 34 total, 30 passed, 4 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

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
* ltp-cv
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simpl
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
* ltpa-5904873/0/tests/4_ltp-fsx
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
