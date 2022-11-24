Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876CB23AE
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 08:54:29 +0000 (UTC)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-3b56782b3f6so9002597b3.13
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 00:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kYkoA/GomV2J1R+NfO0IwXHjKjxsC0Vb0ETBF00zbXI=;
        b=ulH5JJlEBiyEJOyyzmDJEuovb470lZAyDOB5qNe/r+VBdnVulYNBQnNUSszcmHgA3r
         bkj8uWQEGyLTC9K961wA9Hd37J/TC5kQb7emkDeK9EoFNll5qYS4vk6heKtzV7LtZ5Ig
         yEM+B8eR3YKZQb7tMff3yRiIpfoqPEMZU1M0rBZ1BBG4FpNGBYtOtylj9MBmV5uQb/jY
         9OwNpq12jh2E0hIEl+Pn5X2NNRtgABUL0VAmJBQrPdTXaJaPvRJetpCOVks/qeuMyj4a
         G22/QjplaRtlbys6YMYSk5ljss+0SOoE6UMMY/RSLZfaElD1FEaXtS0xkEtbkRn18RxP
         IGDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kYkoA/GomV2J1R+NfO0IwXHjKjxsC0Vb0ETBF00zbXI=;
        b=7WZtZHmvWFDwhKxwDhcrBvkYkiTqII3AZtTMfaZCESKZoYNwlDIvhuPd2ChBmzKbtP
         BnSEIa4QBr2Q0dNrX780yDEcV8BEyjOiIiAI89P4vs4mA9AY67k7H7Bc2FAR79m9uDpI
         D/XiJcgehMYI0KcJSUoueu4xAJYAJeps23mvLldnmEPemBtqN79Rres+oLI4FX3Tml5b
         MzmrEIspCGRpLixs2s5dLu/Mlvm67cDsnYEdkX1OoWnaku/ADBWzYEEyP3BWZfQw1jBA
         MtxltmRER996nzIfHhHs6mt+TzQB6+Jx0bopoVu9p5XoWknfQytYSyzkXD8tnzfqqf8k
         3wfA==
X-Gm-Message-State: ANoB5pnumpeo1Aty4Owyvoxv0yhvrvI3uYO+f/BP14WHqNwUNDEGauW9
	zmKS9vQ7a8nw/lgO3h73GSHTthWWypV9jPmYzUKYsA==
X-Google-Smtp-Source: AA0mqf7PUjfLOTXJ/tlxRold+GNACKzGQPvC5qgYTBuKsbjof9rmRRzeEIro6Uscs431x2P0gTzIHHNWktmr0hWQxqU=
X-Received: by 2002:a81:5945:0:b0:369:5494:75c0 with SMTP id
 n66-20020a815945000000b00369549475c0mr30631265ywb.448.1669280068349; Thu, 24
 Nov 2022 00:54:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221123084602.707860461@linuxfoundation.org>
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 24 Nov 2022 14:24:16 +0530
Message-ID: <CA+G9fYtnHTdCS=RWNULkzENX=mtRrJzc6e++PfeprmFqrQBr9g@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/181] 5.15.80-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Nov 2022 at 14:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.80-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
As other reported arm: allmodconfig build failed due to

rtc: cmos: fix build on non-ACPI platforms
[ Upstream commit db4e955ae333567dea02822624106c0b96a2f84f ]

Build error:
drivers/rtc/rtc-cmos.c:1299:13: error: 'rtc_wake_setup' defined but
not used [-Werror=unused-function]
 1299 | static void rtc_wake_setup(struct device *dev)
      |             ^~~~~~~~~~~~~~
cc1: all warnings being treated as errors

## Build
* kernel: 5.15.80-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 1ac88d934860fc481995accb27454e4fe906d4f6
* git describe: v5.15.79-182-g1ac88d934860
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.79-182-g1ac88d934860

## Test Regressions (compared to v5.15.79)

## Metric Regressions (compared to v5.15.79)

## Test Fixes (compared to v5.15.79)

## Metric Fixes (compared to v5.15.79)

## Test result summary
total: 145866, pass: 126226, fail: 3335, skip: 15985, xfail: 320

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 146 passed, 1 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 35 total, 33 passed, 2 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 10 total, 10 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 38 total, 36 passed, 2 failed

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
* network-basic-tests
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
