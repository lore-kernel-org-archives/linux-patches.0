Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD45412B71
	for <patches@lists.linux.dev>; Tue, 19 Dec 2023 09:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r2bnzwJt"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-7c5cb5eeab1so1246473241.3
        for <patches@lists.linux.dev>; Tue, 19 Dec 2023 01:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702976929; x=1703581729; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w0DJ+lmLJruEBqjMY41BOoK6VhsWNmE0oRWPKlfV7Nk=;
        b=r2bnzwJtedNi76ZNICOemytxKGnweajDmEDHmZaZCKZ29pNbU9XOSXZZyHsJzKtYYe
         imIxBR3XD4T+nHhBgZaHi1e3tAKEbUdZD8Ghd8uh963hgU3UCr6jVo5N0vhpMBoFga61
         3sVAsf/e9UpRYiAZ2JwUWs4JzdH8CXClqqe3KAJQ0bMybWAEeMTU3pveRn7HJ/OLlu2D
         eOf1p3OxzVB51hMdb9e4sdplHeGvooLfsn8lMVUe241+nQbV/mj5aOUhlaHDNb7ikCzt
         qTZI/toP04iiQVCDc3xREWwoabWLMR9qhQ/t4+cbRxrHDHnoZIDSpL0rFvl4nIC4kW6S
         BvIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702976929; x=1703581729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w0DJ+lmLJruEBqjMY41BOoK6VhsWNmE0oRWPKlfV7Nk=;
        b=jsl9BNKUk6igfrszJeE2Eg4gJnTczbVqsKb3EtcGdy/NgW8MJuAG/VtMWlqpLJbXCj
         f6i6OGFgJjntkjVZNUzD/KhlWM0w2Xk+yXYTeha/Hh+a5jH3bF9p9SwDF1h/4Zc07DOH
         wmTMCp92p7E049BOGNy6Mf3isXQ01TqLMZlk3FidZAf6gXWD0rxAW0/or9jVykc3JTJ4
         MCFfHODb3zkcoEDCI0OQIZcIale7GHSigrv9T1gOzw6mEepiXLSHVRkfDqBOwSv+fT0z
         qzNacaZZ6brHdGpIDzr0UV8R7079U66j97mkaaSCO+oSoAc2e+CdszubGDmY/7DpcUrS
         xYHQ==
X-Gm-Message-State: AOJu0YycVCM6nZ0t+oSZ3+NjL5TLv/HKsX3broWa52jcczJrYeqAxi8m
	yesVw18snnEPOWM1T+ToKreFbYlg6kMKtYzZsluzKA==
X-Google-Smtp-Source: AGHT+IFwxEB7g6rZPx9nMm+0XL1kHjozA2phuq94ZsK+h9tICVNDiE+KiLKE77eEKaMHAg1Es076GJzmssT0fbcePoo=
X-Received: by 2002:a05:6102:fa4:b0:466:9ac5:d014 with SMTP id
 e36-20020a0561020fa400b004669ac5d014mr2301780vsv.2.1702976929597; Tue, 19 Dec
 2023 01:08:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231218135042.748715259@linuxfoundation.org>
In-Reply-To: <20231218135042.748715259@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 19 Dec 2023 14:38:38 +0530
Message-ID: <CA+G9fYv9DAjegnefQ7PQ_M_-isfz+rCftRfkxjU8MDwqwVT0LA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/40] 5.4.265-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Dec 2023 at 19:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.265 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.265-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.265-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 2be881e1152507e5593dc93294d1b0c3127350e2
* git describe: v5.4.264-41-g2be881e11525
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
64-41-g2be881e11525

## Test Regressions (compared to v5.4.264)

## Metric Regressions (compared to v5.4.264)

## Test Fixes (compared to v5.4.264)

## Metric Fixes (compared to v5.4.264)

## Test result summary
total: 93105, pass: 72959, fail: 2338, skip: 17758, xfail: 50

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 148 total, 148 passed, 0 failed
* arm64: 47 total, 45 passed, 2 failed
* i386: 30 total, 24 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 32 total, 32 passed, 0 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
* kselftest-sigaltstack
* kselftest-size
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
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
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
