Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069D52CA7
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 09:22:52 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id 63so20314182ybq.4
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 01:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=93B0Dre8ygD5ww3IlnDi2YwovEkfvCwl584UBcJdaHM=;
        b=WEa66nggGx4X7ErwmoENSe/+ustQR3NlcgqWZuHAG++JnTfDKK+1f1FUSWtF+l4WS3
         72IYS7xLerm4khmL0rqEtP+pS53pC6h6jlnuEtJPl2sbH6BGEAHpb1I11OaRl2k/5a3z
         dvJBdS9IssbRxAl7/cRRHrhE88gQ4r4O+dZKhsr7GoFe8ZDI3W+jjXBTMmZDkZ4vTzfR
         8kxu6kcrjw8DUIsdfC99TopvbgMys/A+ME6muzGbDxsNZJToO7TAJw5cKqLQr/ydZ9NV
         KgfEd/Q4Y7TQ4f6GhsOuJ2e+grcb7me7XDjnQroCKOCuGgZC3TktFgWP62khvTUg6pha
         YEhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=93B0Dre8ygD5ww3IlnDi2YwovEkfvCwl584UBcJdaHM=;
        b=RYkvapuRfRkNCN1Lo8xHaoL5Q0+sCqt2z3pCc9fDihBMvUpPja7pEjM/LRtBWUGFpX
         SoiKJftLB9jlJ/4jNPuTknpC3FWITgnglruN4cdae8uHDg92DjWoNq3BhVnK0vg1+psj
         AuVEStj94g5Yj/ZOh4go/QHhidn5v0rt4VK1dKNb9P8j+dMcfXMflMS5dMf1ELVcxbMw
         zrWR1vulZeUa3dvm7gzV/XVz+G+pjqcaJNp6U41K7DxZAOeHZYs5NCawCHi+TnSW33gO
         KUkn1n5eW+LQaWSSx//KW74Yi7swLQlMaWgX/1tBph7qG0dRkCRuTR0GT/7wI+iv47sJ
         Uu5g==
X-Gm-Message-State: ACrzQf0W2ss0Wsa4MkKRH4P+co9mviLNGmCAcPYSMKRjcYLHSwjHPHuM
	WvmY0SLJ2GB63EGZ0u8X33nNO634mG2/jy/KCUZg2g==
X-Google-Smtp-Source: AMsMyM5clQFr4lq/QG2LqFK1i5w9cNmtKnwalzUuIYd7Enwwzjyvy3KrgBgY7+86TdDkwA3PT3Ua+5+uM1Pwlx9kzEY=
X-Received: by 2002:a05:6902:154d:b0:6d0:c289:7b9 with SMTP id
 r13-20020a056902154d00b006d0c28907b9mr34509636ybu.534.1667985771811; Wed, 09
 Nov 2022 01:22:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221108133354.787209461@linuxfoundation.org>
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Nov 2022 14:52:40 +0530
Message-ID: <CA+G9fYuGaGMYYjZDM0X8Wu0Q68=KAYpzOFeDypMF64tpVWcaFQ@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, horatiu.vultur@microchip.com, 
	william.xuanziyang@huawei.com, Dan Carpenter <dan.carpenter@oracle.com>, 
	Netdev <netdev@vger.kernel.org>, Peter Oskolkov <posk@google.com>, 
	"David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Nov 2022 at 19:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.8 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.

kselftest: net: ip_defrag.sh fails on x86_64 and i386.
Our bisect scripts are running.

This failure is also noticed on recent mainline master branch.

Test log did not have details of failure.
# selftests: net: ip_defrag.sh
not ok 19 selftests: net: ip_defrag.sh # exit=1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Stable-rc Linux-6.0:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.7-198-g87175bf36da5/testrun/12904204/suite/kselftest-net/test/net.ip_defrag.sh/history/

Mainline master:
https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v6.1-rc4/testrun/12848742/suite/kselftest-net/test/net.ip_defrag.sh/history/

## Build
* kernel: 6.0.8-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: 87175bf36da5ab43b42de327d6fdc5987b604269
* git describe: v6.0.7-198-g87175bf36da5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.7-198-g87175bf36da5

## Test Regressions (compared to v6.0.6-241-g436175d0f780)

* qemu_i386, kselftest-net
  - net.ip_defrag.sh

* x86, kselftest-net
  - net.ip_defrag.sh

## Metric Regressions (compared to v6.0.6-241-g436175d0f780)

## Test Fixes (compared to v6.0.6-241-g436175d0f780)

## Metric Fixes (compared to v6.0.6-241-g436175d0f780)

## Test result summary
total: 158003, pass: 133527, fail: 6163, skip: 17932, xfail: 381

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 146 passed, 3 failed
* arm64: 46 total, 46 passed, 0 failed
* i386: 37 total, 36 passed, 1 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 34 total, 30 passed, 4 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kself[
* kselft[
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
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
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
* ltp-math++
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
