Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26FAF9EF
	for <patches@lists.linux.dev>; Wed, 13 Dec 2023 06:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TDbxXvD8"
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-462c6f436e4so1738852137.2
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 22:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702448911; x=1703053711; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Akz1Puzltw2De0oW27Kz6mV3Wu/LD2csUZa1D/sOJBk=;
        b=TDbxXvD8ojiaWoLqNPn50jNoTUMOa6AlxYY8lsQI3eYYrRkbvHcpiiKgV0G+O4D/+w
         nT/0y7tUsrnRbpeJvWtBAGj5bIwPpdm7Q12Td3Yo9NQt/GuKrGYWTLx0p0Z6hYgLRxr6
         vnlrll8aV8XsdcNX2HLL10LnoMDPSbFe5yTRK3NxjUVNjoLSMoThMdaMZrgMRKfgNtoI
         QCR2S0zSnB0trpGGgVxH6t4MwquSPyKjSU74wmRIfUUBR5rBu72lyZvsvumjKVvGy04q
         sVdmDMKuOzyTC3mZLaoirNebPofvwgJvij0MhvcWp8Ua05BTzGjQiZX4SX1xTNyU2mSU
         guFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702448911; x=1703053711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Akz1Puzltw2De0oW27Kz6mV3Wu/LD2csUZa1D/sOJBk=;
        b=s/PlyNEw8jPJ59KI/mCBkDPnafloOJQ/LI9xhgLHG3dyb7IL2j5JkTb5L2sek60Fyq
         KWOT8GelHLFl6DRxFTfKkJaBHAgqfsOTGxRTxMMkUKU5ojidEqFT+ogjlorbwPv3fuKK
         RUcXuPlZSyusRdDsxqqCCbWw8fCDqmdKvRjLkzxsvh91hm4MzVsyvvwRDWoBbYBHzM9J
         Gk5RLiNs17GTKHbrF5jzBCX7JMACQllDjefHQSnQMIgGTxHnYt8jhdSt26KiTW8A4lOv
         Yv6WwqSmnhSS+JE0PShxGTKKhGWZbzk1HI43JTtuaTBGn0cyBY9m9C53T9eYbxcBqOw/
         sH1Q==
X-Gm-Message-State: AOJu0YzdzyxOARosBGoT3zV6VMGZF4n1i6gr8vJQbPJEfABCCm8BgrIe
	XK9SXCOQoZKpEvr2VZo7rD9Mfw7lRzeySCMSsjVcVA==
X-Google-Smtp-Source: AGHT+IGQhg5JrLKCGBiXPF+aLsnGoxhgTZaQSJZ3CN3n6MyG75kVqb46vu3aGD3k4nEopq8fpUlLvD65tSfKaR4RA0I=
X-Received: by 2002:a05:6102:6ca:b0:464:8a32:d4d7 with SMTP id
 m10-20020a05610206ca00b004648a32d4d7mr5647631vsg.6.1702448911530; Tue, 12 Dec
 2023 22:28:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231212120146.831816822@linuxfoundation.org>
In-Reply-To: <20231212120146.831816822@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 13 Dec 2023 11:58:20 +0530
Message-ID: <CA+G9fYugjz90_tSMj3qBRC1R0vygybc-mV3tvcQ1TmcaNxkqsQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/24] 4.14.333-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Dec 2023 at 17:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.333 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Dec 2023 12:01:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.333-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.333-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 68f9b81cad708b197a2f7aa4e293c2669590d2ad
* git describe: v4.14.332-25-g68f9b81cad70
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.332-25-g68f9b81cad70

## Test Regressions (compared to v4.14.332)

## Metric Regressions (compared to v4.14.332)

## Test Fixes (compared to v4.14.332)

## Metric Fixes (compared to v4.14.332)

## Test result summary
total: 54698, pass: 45675, fail: 1625, skip: 7353, xfail: 45

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 103 passed, 5 failed
* arm64: 35 total, 31 passed, 4 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 19 total, 19 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 8 total, 7 passed, 1 failed
* s390: 6 total, 5 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 23 passed, 4 failed

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
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
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
* kselftest-zram
* kunit
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
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
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
