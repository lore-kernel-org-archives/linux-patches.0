Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A27A23BD
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 07:04:12 +0000 (UTC)
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-78f6a9800c9so1896307241.3
        for <patches@lists.linux.dev>; Wed, 28 Jun 2023 00:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687935851; x=1690527851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sKt46WH3haNdn68oDulwJLfg6Dbw6icGdyGT3p+VLw0=;
        b=OFKJBQq9qQkqv28oN1Z49AJ4eKU+JMlStfQojCSUtYD9B9VSWJBt3KGLqw2r4WuYlX
         tpFbHquTLRbdEuvXoHsD2eo9wcJ7HBSPFto1E8lPj03rSbJeyBIH+Dka0FO6duAySqVV
         pwuAC65fLvXLCOmrExem+KHvjf0viBYHI8WenLkywpn72Ar2WuqC+By7mMgm0lGEZjzI
         NRQevpFOWP/RPuMADhG0xk4YC/vCHFHmtV0LFtcchIECaRmGr3WVI3GxyQ5pznxUiWnR
         i/ovgClUs6cruZTsdTY5Rh+o4YJirnekDeNzgr7+oSNudmnzagqwzEs3lKrJnMhoXFDM
         KRmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687935851; x=1690527851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sKt46WH3haNdn68oDulwJLfg6Dbw6icGdyGT3p+VLw0=;
        b=L2og0KPONn0sEFRVN3zzgG2VE+pNNeWCF0eyKYWAE4RvnirLdp5FGlRCV/fakbKH9v
         q637tJ/bVu03qfbvqrIAWfXcayG90Uw98r1agfSTtG/cmMKIMszALtEisiYO/+5ROUjy
         55VuWa+ewxW7PbasgzpIFCDRYqEeR7uLr93Og/mM8TZojjRNG8BDOtVBlY7Me2LKgaO8
         SGWHWzMxrhwLG6pfgbiEv+bmQIYzam7n3gwG/59VVx5/w8EjHGdj7PLAzlMLTeoVlBff
         wtXRjAuMW+4YEuCzjDoA1pbEW2HAlZVV4i0LzAXKvC7/uPN4Do+EPFjSzZA14VS+/de+
         pp9A==
X-Gm-Message-State: AC+VfDzA6TGEcxbkZa2+M+m08LU6yjuv7/DYGfc0yBJquXRjJMq7+Ko+
	r1gKv7cNDdPTbYvKLpzex6CRhujvwZC7KLq0tMh5gA==
X-Google-Smtp-Source: ACHHUZ4UnxeddFx5DIcm9mVNTPRPajWiHva1L+q9Tk7Ikj+GOB9OfZEnDxVa3jmGUyFeD1tDajfgyDTVAO8JaJDmf9Y=
X-Received: by 2002:a67:f615:0:b0:443:66b9:b8e9 with SMTP id
 k21-20020a67f615000000b0044366b9b8e9mr4364431vso.20.1687935850952; Wed, 28
 Jun 2023 00:04:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230626180739.558575012@linuxfoundation.org>
In-Reply-To: <20230626180739.558575012@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 28 Jun 2023 12:33:36 +0530
Message-ID: <CA+G9fYu6KHvkpd86q2aVjWF4gXbpBw2mgc-Tmu=4hG4eQ11z1w@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/60] 5.4.249-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Jun 2023 at 00:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.249 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.249-rc1.gz
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
* kernel: 5.4.249-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 824b023c3cda00fe610c1f79d14a6223d68f425f
* git describe: v5.4.248-61-g824b023c3cda
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
48-61-g824b023c3cda

## Test Regressions (compared to v5.4.248)

## Metric Regressions (compared to v5.4.248)

## Test Fixes (compared to v5.4.248)

## Metric Fixes (compared to v5.4.248)

## Test result summary
total: 115217, pass: 90332, fail: 2137, skip: 22692, xfail: 56

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 148 total, 129 passed, 19 failed
* arm64: 48 total, 44 passed, 4 failed
* i386: 30 total, 22 passed, 8 failed
* mips: 30 total, 29 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 33 total, 32 passed, 1 failed
* riscv: 15 total, 14 passed, 1 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 41 total, 39 passed, 2 failed

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
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
