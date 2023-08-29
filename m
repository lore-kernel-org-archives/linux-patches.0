Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEAB63C0
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 09:05:51 +0000 (UTC)
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-7a4d05eaea8so723961241.2
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 02:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693299950; x=1693904750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UK33mQoDAtnqgnVp8fhJUScF7p7neaBjU5m5OZRwG84=;
        b=V+KdT24IHmaKsujT6kLT+VsEusOLH2azK18ASv7RQPGn+yQK0ut0w9cCAsW/h+KDIK
         BWP/K3REvkmn1COPzSVxUUae3wq8MLFlNmLS9HuhucccS164aO5U8cMr6LITLHFiMewf
         nu7vrm8v+sanKv397ABuDudEnyB3vC+z8heoumMXJliyLivb40l/ogjoSCPubWzW9Ees
         y+bWtqJtcURoER/v85dDKjmjgllM6jMpMSwhVA+M+cUBNgqVWhFbiOfrTirrCt8wf4Aj
         +lniP3NatObSJA/MbF84I90LupUuKSA3SyKUscmaDpp0pMH9w+exumos0R4+n9nL03SZ
         GyNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693299950; x=1693904750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UK33mQoDAtnqgnVp8fhJUScF7p7neaBjU5m5OZRwG84=;
        b=CER+LH8+hi5uWwMASN38sSDV6s/KlxsRTMpgH0Q+iWmxSps5yEQflGLY2CdbRc7ww2
         gyJnfvVWuYdnzpz7/UAir5c2DYRhu73eEJS104MAkGNOWFW5F4PhGYcV1nTLIORO/4bR
         MYDEvCMrZan4fAHyGPfIqa6pYGyTPrrKkGlwmCeHvtD2wWWsSzdrPjv5Uojp4pu+V1Vi
         4IPAfjybb0eZPinLWWPLWoUiU4oyG41jwAh/vjgY3liVvKZ/rwTNcL+OclVnizGR3zAj
         ERDC2xVTZNFeUo5t8aoKq5iN7gl+VbGcN3Y7ST1Rmd7BPMm9rwGTI2+AmWoqWtlUonwh
         Zoxw==
X-Gm-Message-State: AOJu0Yyi+it4mU5d3VqqE/lSinzp/zzpcsJ8Nt4mll7kf0gX7sMM2t+2
	Ou7r0Yz6UgcmP8M7n/Njp807EB8JWQTa85ECSSJKGQ==
X-Google-Smtp-Source: AGHT+IHdbcI75ldWVcT0Eq6O+Oi80x4A/VVxMtAbbXLIiOJlwL88pmGnIKiyXcWpIYFYCQUFy3Eo+ZIAYVtnY14LtDo=
X-Received: by 2002:a67:ec55:0:b0:447:4c30:cb68 with SMTP id
 z21-20020a67ec55000000b004474c30cb68mr22960717vso.32.1693299950080; Tue, 29
 Aug 2023 02:05:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230828101150.163430842@linuxfoundation.org>
In-Reply-To: <20230828101150.163430842@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 29 Aug 2023 14:35:39 +0530
Message-ID: <CA+G9fYsrSC2JjXstuiYfLK2Q2ouv3icM_tX0u28BC3Kq_PCwHA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/89] 5.15.129-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Aug 2023 at 16:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.129 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.129-rc1.gz
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
* kernel: 5.15.129-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 948d61e1588b9442fe7390e694431478159553bc
* git describe: v5.15.128-90-g948d61e1588b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.128-90-g948d61e1588b

## Test Regressions (compared to v5.15.128)

## Metric Regressions (compared to v5.15.128)

## Test Fixes (compared to v5.15.128)

## Metric Fixes (compared to v5.15.128)

## Test result summary
total: 85285, pass: 69850, fail: 1587, skip: 13790, xfail: 58

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 111 total, 110 passed, 1 failed
* arm64: 44 total, 43 passed, 1 failed
* i386: 34 total, 33 passed, 1 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 26 total, 25 passed, 1 failed
* riscv: 10 total, 9 passed, 1 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 37 total, 36 passed, 1 failed

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
* kvm-unit-tests
* libgpiod
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
