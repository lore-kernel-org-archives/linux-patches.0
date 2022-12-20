Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF5E1111
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 06:49:11 +0000 (UTC)
Received: by mail-vs1-f50.google.com with SMTP id a66so10942782vsa.6
        for <patches@lists.linux.dev>; Mon, 19 Dec 2022 22:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=js2ufOjBmmgGy8PvjmPtd+4QZZsXyUTcMnnsyn0kH4g=;
        b=JOVAogE1ejpgQTqA9TTAPdAyL5qjaC8H210ZmtKV1cEqz2y/OZKbnOyyRprvDQ3Ujb
         mhDUeac8ByG3HVa06zkrmFEBbp8txoab+7LFC8Du1ErLh8WdpOaYMvXUL3u2ndDEHAJa
         kYeX8orYGquhNt7AriPjlGSsMSH4v3tthsdvS+MMNXjfpqCIB9VB1HAx/RVpFLCis8Bv
         Qk+Fl51/5C79y/BBnk//8h13HfC8LTyPgDWu5csPOJlIyz2bcn674BXMtf+ySxoaYfxR
         Q3LDTJumwIYTxldipCE2/s98/bFKqo2tJTYlNLoNiygWR4G+oXRM4BhyjSgk6894wEyn
         5Hcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=js2ufOjBmmgGy8PvjmPtd+4QZZsXyUTcMnnsyn0kH4g=;
        b=CHy9OgjTtqoZ9KGjpvyeKWQLVZh+zZLn/Y5QvtClAcSL/vstYfOJhNGmLSNYFwvw1M
         f+ICbBzbieICG/zKThe+plSGmQneTnEyLnn4RN+OOifNVKpM1gTUWJpxayaQzN8kVTiN
         eFG+ZHeKS0bsei6lH1OsbA6npnfxiolNLwnnjKh1TzdjhhTNnwG5Q0lja4K6pTF/USa3
         fIpAggumtno3o5CC3zXeh8YgB92+EpHH1jhDowzKL/H01g4BpMJYrd3EWeqV9JqI2Gpo
         ffTZIIiQZjiCVz3msrNiD9w9lmgOPOtKdkqGSasFCNYeaHw84Vps1PKJN2MEm8fEmqBQ
         AtjQ==
X-Gm-Message-State: ANoB5plXRbspsayd/ROMO0y1ksN1Kp4AUB/1wTaxHYGu+r+5i/rEn9uh
	V1jBsXE7vCq+BRMsiaK2KhkO0tLu2zLDxqfc+9E2rA==
X-Google-Smtp-Source: AA0mqf7M+QFzXIepln2+4d+ZDhXcaia0gI29dkHFuRQuZpSXS9dxbWHuTRbE5lswl1IWHvWJA3AkHvaI3zwN2wrVsmY=
X-Received: by 2002:a05:6102:21b6:b0:3b5:21d5:5a0b with SMTP id
 i22-20020a05610221b600b003b521d55a0bmr2921509vsb.34.1671518950130; Mon, 19
 Dec 2022 22:49:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221219182940.739981110@linuxfoundation.org>
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 20 Dec 2022 12:18:59 +0530
Message-ID: <CA+G9fYtWgwmEZVY7pQHQ4kKadxtgM71v-3goRq0gikDMoFdKjQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Dec 2022 at 00:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.85 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.85-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.85-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: bef75c6188c78b9ddf305681393ec04bd7d2ad30
* git describe: v5.15.84-18-gbef75c6188c7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.84-18-gbef75c6188c7

## Test Regressions (compared to v5.15.84)

## Metric Regressions (compared to v5.15.84)

## Test Fixes (compared to v5.15.84)

## Metric Fixes (compared to v5.15.84)

## Test result summary
total: 139603, pass: 121329, fail: 2908, skip: 14952, xfail: 414

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 49 total, 47 passed, 2 failed
* i386: 39 total, 35 passed, 4 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 34 total, 32 passed, 2 failed
* riscv: 14 total, 14 passed, 0 failed
* s390: 16 total, 14 passed, 2 failed
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
