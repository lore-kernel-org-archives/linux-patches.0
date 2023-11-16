Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E230F328A2
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 14:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HqzqpQ1Y"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-4abf86c5ae1so347786e0c.3
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 06:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700144641; x=1700749441; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6KJkXeq1c0Mlv5gjaKW3vMtX+YJGSTJ76GSnkl3Srbw=;
        b=HqzqpQ1YiGdppUDSHbQKpL1fJUvZH3+1wql+4NjHu8u3vYxZliGjpgNCESd7l9wWrZ
         OWGZoUTjukAP5OqaINR+J9jK327cMYSoFGPDqzNbuJyE4uRAnNgbGv5antfo8ysN0z9t
         Png5Q5lEpq9cLeU3ioPkKNreLB4RUgGlT84nl/nHGtG3Zi3rQ6VUdtKqG5xf/8HThfzr
         DAE+59MQ5FxkrNQlnguLrTp3i4IzyS9G2xrG0mtxlhTg627hagqZvwgBUHU9UXqLRbO1
         TUOej1f8rgg2yEz8rKJQ7H3V1dTkbt6b7AbU6lAq99+oBMidyY2AkM8Rne22O4CRaWBs
         G9aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700144641; x=1700749441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6KJkXeq1c0Mlv5gjaKW3vMtX+YJGSTJ76GSnkl3Srbw=;
        b=GFaPFfjiUjIxBvB2bsKXQelcMtHbNSvt9V5oQfyl7xzpl95ag0weFh/9PdmSFnkUr4
         ZOa7g43wb2i0fggw0TmosoEVoWJABfLack+8jyl7rmBtSTKfSQ2FKdaVue3riu5/uKtG
         j89bVkMRtPUZkM1MhnSyeC68QFG7u4dTg2y4HH3S1SvNrAqg1k2/1ByS7OjG8bd6+AaX
         FwgmnWTz7mLni4ort6DNwl/7Eb7DFm/8tWpQ7OGek7xzjV5vQWivSkL6J0Bm1WXI5a/T
         4mBPDKgRXS2n93v5kf1ASJ64UwVLfzZPgt4zHRbVTQpeXA2A279XtK5RzJmyuX9UizZl
         q4gA==
X-Gm-Message-State: AOJu0Yyf/IvZmVoiDy+juTkS0/YAPv3u3N4joqAmcrobxccuqWq9hUdR
	8tVUVoM/g09cTnmcSMC4YcoD5xXegV0IAVzo4dUdDQ==
X-Google-Smtp-Source: AGHT+IFZ+gmH9ee3C9+IKGOdCpJK4UhHwKPQ41ZEfQJqJ3vOizJMchMwJ+8sAu4LvbhUcv+nzBns2e4KA8t1gGTjGJs=
X-Received: by 2002:a1f:a084:0:b0:49b:289a:cc3f with SMTP id
 j126-20020a1fa084000000b0049b289acc3fmr15034872vke.3.1700144641588; Thu, 16
 Nov 2023 06:24:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231115191613.097702445@linuxfoundation.org>
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 Nov 2023 19:53:49 +0530
Message-ID: <CA+G9fYsS3r+mM1qQo4WHe4hp-xZBGhFsXyYWg2dLo-up_vzP8A@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/603] 6.6.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Nov 2023 at 01:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.2 release.
> There are 603 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
Following kernel crash noticed while running selftests: ftrace on
arm64 Juno-r2 device running stable-rc linux-6.6.y.

Link:
 - https://lore.kernel.org/linux-trace-kernel/20231116123016.140576-1-nares=
h.kamboju@linaro.org/T/#u

## Build
* kernel: 6.6.2-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: df34d612fd4ef266814366c8101094b7f83b6a92
* git describe: v6.6.1-604-gdf34d612fd4e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
-604-gdf34d612fd4e

## Test Regressions (compared to v6.6.1)

## Metric Regressions (compared to v6.6.1)

## Test Fixes (compared to v6.6.1)

## Metric Fixes (compared to v6.6.1)

## Test result summary
total: 136854, pass: 118192, fail: 1765, skip: 16783, xfail: 114

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 142 total, 141 passed, 1 failed
* arm64: 50 total, 47 passed, 3 failed
* i386: 40 total, 35 passed, 5 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 32 passed, 4 failed
* riscv: 25 total, 24 passed, 1 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 43 passed, 1 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-exec
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
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
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
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
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
