Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FA6CA40
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 10:38:20 +0000 (UTC)
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-486519e5da0so109494e0c.2
        for <patches@lists.linux.dev>; Wed, 26 Jul 2023 03:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690367899; x=1690972699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zIVeVwbWTTFXz8sKxYfdejU59DP28K7TUiG752OJ1bY=;
        b=Ed63tR4hX3NLwkv4cNeMoZ609032VNzIKqHsRpb1aIY63hcX//qcems87u1uD9L9fC
         zoxYSzdfSG59svXE8wZiEH+Qo/RN2GmagjbqnpHzDVgLK8OOIHiHybfWcux/SAWrVvB3
         8F1c6an9aogB6fy877FrG+xjhrPtot8JRYdi1T2Do3Z20F+ojdQSaT84CCXQnRU/gVr9
         4VRL4IqH8dx4Z0ej7lE4VV1CsAFtDzuDT0Om72VU4uJqTuy+Wsuz2e3but/TaUkrTjGC
         Nlr5ETAivNCWbGKEveVeLSLlr7C1BQBnWKGo0V8Jni+5NhCcQoUSDkfW4neyp5Av52LK
         lEbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690367899; x=1690972699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zIVeVwbWTTFXz8sKxYfdejU59DP28K7TUiG752OJ1bY=;
        b=PYjxIR1sX2gMHczdUn/2xwvw9DttVo7IHUVuf00m9aq9a340wxHCUvQjXYu+gVSs83
         iO1EBk8/9XfZ9ZfhH0aE3yCXVobOuDqNbCaZaO01HD5hP/ijIBm+0iOTmPboenE9Smwm
         udjZKvgNq9ilIx1UWPPGE0FgZW8GCOHtegNyno5m4VH5ehdS6x9varjNvVL1V36rHRTA
         TjzjRGhtKsyHa52BHqhXc02Bf8pJ2rHddmgRzpD+ychSMezFz/6o/zaLVq9Nm9qWw1Fm
         HGgnm01B8CErZC1f2whfIcSCrTCtph1UkhiutiwnLjB48MALoIMnMvtZa7ts2B8RqQsB
         zgUA==
X-Gm-Message-State: ABy/qLbAs/jaiL3b7aumfr9EPm3yBU0YOwZ6aDrxIjDpXfUfISUJrFdo
	agsXepyq3d1XRDpNiplPNJk6iwh/x+TtkGwrODcKDw==
X-Google-Smtp-Source: APBJJlH3BrgnoIR4LvzrfMDAoJXI9L+FHaF0gIVQa8oIDWDYLvD0mcPOHU29TnTlafzNfJuJmDSHpRKmA2JtI+sXY24=
X-Received: by 2002:a1f:c192:0:b0:486:4558:ed05 with SMTP id
 r140-20020a1fc192000000b004864558ed05mr558172vkf.4.1690367899581; Wed, 26 Jul
 2023 03:38:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230725104507.756981058@linuxfoundation.org>
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 26 Jul 2023 16:08:08 +0530
Message-ID: <CA+G9fYvF27q6PRJ=DQvOu6WGD4W7UzQ2_h+GwzzOvQdm6XcXTQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/183] 6.1.42-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Jul 2023 at 16:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.42 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.42-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.42-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: b3f8a9d2b13712777c36667183b782dd7efa5039
* git describe: v6.1.41-184-gb3f8a9d2b137
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.4=
1-184-gb3f8a9d2b137

## Test Regressions (compared to v6.1.40)

## Metric Regressions (compared to v6.1.40)

## Test Fixes (compared to v6.1.40)

## Metric Fixes (compared to v6.1.40)

## Test result summary
total: 129464, pass: 112241, fail: 1676, skip: 15398, xfail: 149

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 146 passed, 1 failed
* arm64: 50 total, 50 passed, 0 failed
* i386: 37 total, 36 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 42 total, 42 passed, 0 failed

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
* kselftest-lib
* kselftest-membarrier
* kselftest-memfd
* kselftest-mincore
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
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
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
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
