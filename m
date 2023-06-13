Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E296D2915
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 09:40:26 +0000 (UTC)
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-78cc78d79deso281264241.2
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 02:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686649225; x=1689241225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fWL+8F4wX9QAkgda6QyJxqZXMC6jN1JJ2qnzQJBp1LA=;
        b=FWNDnQrHaBxGSTCFKvGpSOnoHQIMoP+4atd30vuD3aEc3PZwxblz4336lsE9Oah2Jn
         Kl6KLUMpSxcu05FzHx3wQESkClCZxlQ4rF225tHHAB5XZz5BHl7X+MvmgA6W9VYo5xPN
         QTyh6tX3zGg6Hr1gQ1thoElaL47qUkO4ZO3BJ4Kv1ZLU9o5chPmwrSEYKCTWQFKlVCpQ
         024ASjyR8PeKOaNHGNOPnI61D/R+fxjjsHp1H5JG0N6uNAddKTuDroG9Z/6B6IeFgN+F
         VIUCZLOObbQDGA8WBnsIwicoA34oOeW7+MfaKn6eUsjTrEw6MDrZoq8Dp6HO4S1uYaR4
         5q3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686649225; x=1689241225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fWL+8F4wX9QAkgda6QyJxqZXMC6jN1JJ2qnzQJBp1LA=;
        b=OW2dBRjjhQ6e4MoGwwYUKGcsKmS7bPCCfbLva8mBB1ZrCQhheXk7sNqwbA7YASinjf
         uD/msGlkMqnDW3JYxVzJtFpi0Xy4VRhhuAFwLr0lA7+S/yN4E5hES6+DPvzwoM7rPUgq
         +89uSVDz3UeO1PZgQQLWw+4CpnRXIXb39kvkOI6e5Mj1I8yqO0/TQHAiWylrbr/J6xbE
         bSavl96vKkIIUr1WMjhM/4OGWFDwOQFU+9SXffZOnfvTBJTu9bDPxS7qR6YmAQKZXpL7
         o1cgSTjXIFEPiDHRIQf+3f/0+rfsME50BMXRrUy6ylwZljawLcSoBgTdn2nbvFJrYyS7
         PklQ==
X-Gm-Message-State: AC+VfDzm/pjzT0yXs/FAsK61WS8G86BEABN4n4i+iiJtBsMLOPw7UpG4
	qLmLGZyuuxh6b373zuvf6B5M8/3TrVC3rmnFOhdUlQ==
X-Google-Smtp-Source: ACHHUZ4EWfyHA5rw2XRBroD1azAfrmIXM3Fz6jopLa5yjoIdXhSqZPmSLZjjsADXUBn9iJmU85TtEMrvKH806787l5c=
X-Received: by 2002:a1f:6051:0:b0:464:c5aa:3338 with SMTP id
 u78-20020a1f6051000000b00464c5aa3338mr4506802vkb.15.1686649225448; Tue, 13
 Jun 2023 02:40:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230612101651.048240731@linuxfoundation.org>
In-Reply-To: <20230612101651.048240731@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 Jun 2023 15:10:14 +0530
Message-ID: <CA+G9fYvOtkh4H2CLn=ogogxz3S6TYcbS_YMGHpgaoeP6XQHeAw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/21] 4.14.318-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Jun 2023 at 15:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.318 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.318-rc1.gz
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
* kernel: 4.14.318-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 6958cbc0ef5cb58a12f24faede15c46ea71a1975
* git describe: v4.14.317-22-g6958cbc0ef5c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.317-22-g6958cbc0ef5c

## Test Regressions (compared to v4.14.316)

## Metric Regressions (compared to v4.14.316)

## Test Fixes (compared to v4.14.316)

## Metric Fixes (compared to v4.14.316)

## Test result summary
total: 66388, pass: 56634, fail: 3131, skip: 6520, xfail: 103

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 104 passed, 4 failed
* arm64: 35 total, 31 passed, 4 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 21 total, 21 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 8 total, 7 passed, 1 failed
* s390: 6 total, 5 passed, 1 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 23 passed, 4 failed

## Test suites summary
* boot
* igt-gpu-tools
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
* kselftest-net
* kselftest-net-forwarding
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
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
