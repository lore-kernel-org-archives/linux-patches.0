Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F3C3F4BA
	for <patches@lists.linux.dev>; Tue, 17 Oct 2023 09:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GzTFHZmh"
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-4580a2ec248so622915137.1
        for <patches@lists.linux.dev>; Tue, 17 Oct 2023 02:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697535484; x=1698140284; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bKqVh8btfAJWGYdTAKR1R2f9vNamhWmyPKOFxzrvwzU=;
        b=GzTFHZmhlYx7+tGd9dh7wAuaI3JEGh5PXFJbwkkq5rHu6caOG2+xyq7mkWbFrdWn8n
         VlaI4sU0qbXbC8y78IGNvIzwpE45RMWXVYpkd7B9isOygywbLkfGAM2uO4glW54GH1bA
         qBvta1NIQbHB+0rYvrWypCleufD36Nga2VC3BdXhkEbjjhGhNJKkpqO3ZRaK8CosEck8
         Ftv0LHlUdSRVC8PGn8OyWh7qjcxsLEe/XKaQ3A7zp/pKC9/9oPiSvBigBAMmo5DHfXAW
         4YPS3uFU3DDRv1JNWlp5cR5Tsc7CvFHFn1MJkbHxU2DrrXwtsstBcx1uDSIqs/jOgA0W
         5UnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697535484; x=1698140284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bKqVh8btfAJWGYdTAKR1R2f9vNamhWmyPKOFxzrvwzU=;
        b=rfOCOd4l70bxKKlVg+zCwwYYMlsiUERM7bYBrRsPSLGVeoDVmfx/aZvkXfpKKeHiP6
         sYDIw1PBNN7e19QyUDYxXjI3wqMyIXsqVLZh08fCn1Dyxn5i/kMV6YKgKA3IWV2qp7Ke
         ssMV0SI22QjMfc34HcSAo6ijYc5lHRNwM5wh+jMWTiH127a0kBkFfeImDgI7u2kAYh+S
         DJS2Jm543XPIDzK90lxn4yftKE7xmevO5uZT493qdlt+TE1P8a0APumt9NojN+7YSb4k
         SGefdKmPJbDwQjLt3XnvatSPU6fy33Rv3K7YYEtshKLmLwAfNcIUPJbqBacHxIIwo5J7
         izAw==
X-Gm-Message-State: AOJu0YyzBCA3Lxo7sWpny2mjfB5HBoTE/zQSBeodMrLksiodYaB+bWMz
	VO8s42gKFGnS+ZHBifjd/b+j18mIp8cgHyGTGhE0yg==
X-Google-Smtp-Source: AGHT+IFggEgn7Ks15xd+SYbFSRsXVnpK+EIouMs2/JqWFgjLW3Lrmv/FFmLO/NCZ3wAnATND43RyJd/PGM1/dusRVbM=
X-Received: by 2002:a67:e115:0:b0:452:b574:3ca3 with SMTP id
 d21-20020a67e115000000b00452b5743ca3mr1770346vsl.14.1697535484308; Tue, 17
 Oct 2023 02:38:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231016083953.689300946@linuxfoundation.org>
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 17 Oct 2023 15:07:53 +0530
Message-ID: <CA+G9fYsCiwLjPENYOAqCQm_AEY-4XV8Ko84JNJhtTGYsCPmENw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/102] 5.15.136-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Oct 2023 at 14:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.136 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Oct 2023 08:39:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.136-rc1.gz
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
* kernel: 5.15.136-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: f11fc66f963fdd01d969cd3dbb90f0f775de525e
* git describe: v5.15.135-103-gf11fc66f963f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.135-103-gf11fc66f963f

## Test Regressions (compared to v5.15.135)

## Metric Regressions (compared to v5.15.135)

## Test Fixes (compared to v5.15.135)

## Metric Fixes (compared to v5.15.135)

## Test result summary
total: 147886, pass: 122990, fail: 2836, skip: 21902, xfail: 158

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 227 total, 227 passed, 0 failed
* arm64: 85 total, 85 passed, 0 failed
* i386: 67 total, 66 passed, 1 failed
* mips: 51 total, 50 passed, 1 failed
* parisc: 7 total, 7 passed, 0 failed
* powerpc: 50 total, 49 passed, 1 failed
* riscv: 19 total, 19 passed, 0 failed
* s390: 21 total, 20 passed, 1 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 72 total, 72 passed, 0 failed

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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
