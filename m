Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB6623A0
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 08:18:30 +0000 (UTC)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-36cbcda2157so8658647b3.11
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 00:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RJnk7b9Prwvkwj/6ULA/7qfo5vqHNlDVoa8M96eq0eQ=;
        b=n3PoVsyZhgRpnzeV7UQzEq0CdyoVE3lF5brAlfiK2qO8+DaqmThvItsJY2p8xVlxov
         1u7UO8e1RfW+3tqYxN8DnlmmNT73xua9Mr9IIWpyRbKTwfolqZ54uN3KXIf6CJTK7AYo
         yzLPpTSuPrIJgPId5WNP5PGhFWnykhTJU/Cy3CcuQr6tecOKCLhZ+/1wSEui9TzeumEF
         WrM0fH2UmIPGqsixU2TmXnQFPXXEi3EhnhMWnTgDm5bLpp+HAb+6SHU9tYKKaC0P/LpL
         jitptmKODttfclsu/SHc1qeNfY+duIE+Hl3AlCE16evlxADlFiQKJgQvDRQoFQKGfq1c
         XchQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RJnk7b9Prwvkwj/6ULA/7qfo5vqHNlDVoa8M96eq0eQ=;
        b=Qzig/nG3LwcCyHnks/q6dQQtFy7krDvQnEgGLSNRE/og+MZY78IW5lQOJUcIyddWby
         ZVGX/I8c8LzmmGzvZpLiUmfUanr31JITnSJnfI/Wpq8GwNIKNU5f2LsPhX5Przb9oVyK
         vzq3Ihmn/yS180bV0kdNPCO25+nByIMFuKuuSqX5GHF2iM4WeHIZlQeZ3e5gBCgvbYPx
         Fx5z88VvFdMKu74P45whWbDPteB8P+hjkOxp+ecTMaqj8n06aQEdBkarXDk41Xi9BJVz
         SLYnSkPk4dqZbiapEp3hohTZjRaKQZKi1DCiYLT/xzDeX6xTSkuHgj6XTjlZJzzfpdby
         G8PA==
X-Gm-Message-State: ANoB5pm9A9a0nWd7VItiahzpOdjVfugYp2CpX6T9rmoxaqgXXGnkjf7N
	A5K0THYeAwmJHxLcJra+AFH3xLzX7G+7K9LxYREQfw==
X-Google-Smtp-Source: AA0mqf7+S35yAAykhkjxvI00othj3Ijb20THmCFaveDKjg8fWbQOz6iX08zhG+h7ET2QD/QEqpuiXZXzWzajRXwz/7k=
X-Received: by 2002:a0d:df8b:0:b0:39b:b038:1edd with SMTP id
 i133-20020a0ddf8b000000b0039bb0381eddmr11999608ywe.311.1669277909670; Thu, 24
 Nov 2022 00:18:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221123084625.457073469@linuxfoundation.org>
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 24 Nov 2022 13:48:18 +0530
Message-ID: <CA+G9fYt1PhHTfGcN9Rf7883Gz9RvGOicbgoqHNLGym8Vdoet9g@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Nov 2022 at 15:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.10-rc1.gz
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

NOTE:
As others reported arm: allmodconfig build failed due to

rtc: cmos: fix build on non-ACPI platforms
[ Upstream commit db4e955ae333567dea02822624106c0b96a2f84f ]

Build error:
drivers/rtc/rtc-cmos.c:1347:13: error: 'rtc_wake_setup' defined but
not used [-Werror=unused-function]
 1347 | static void rtc_wake_setup(struct device *dev)
      |             ^~~~~~~~~~~~~~
cc1: all warnings being treated as errors


## Build
* kernel: 6.0.10-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: dcf677c9377c88653b9cbbfc7e59e70f7a2af096
* git describe: v6.0.9-315-gdcf677c9377c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.9-315-gdcf677c9377c

## Test Regressions (compared to v6.0.9)

## Metric Regressions (compared to v6.0.9)

## Test Fixes (compared to v6.0.9)

## Metric Fixes (compared to v6.0.9)

## Test result summary
total: 148325, pass: 129685, fail: 3631, skip: 14746, xfail: 263

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 144 passed, 3 failed
* arm64: 45 total, 45 passed, 0 failed
* i386: 35 total, 34 passed, 1 failed
* mips: 27 total, 26 passed, 1 failed
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
