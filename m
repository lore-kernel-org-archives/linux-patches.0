Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8003F36E
	for <patches@lists.linux.dev>; Wed,  8 Feb 2023 04:46:52 +0000 (UTC)
Received: by mail-vs1-f49.google.com with SMTP id k4so18642393vsc.4
        for <patches@lists.linux.dev>; Tue, 07 Feb 2023 20:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9BGUCWxywmSqW/Kd3Ha2QF3DOwIWqbYIoTgVPrb7HQk=;
        b=zVEq7AVYWPMzLbKz781ZaD2w6e6xN0RFF87o3VIXSzEdWO9Li/ZKLmwvlm9PGlR6ys
         Ff9BQI9iJmsRcKTG3nEL1fkAc6cJLGSh9fRsfoC8vrrNFzeFlFUT//40j0WY14yNXfXJ
         KYZx5RHCdrZeIOmPv2gADCpVGX/ShMywFRyKx6bIfQpPvio1lh1jLjZ1RadSKGbWaBeK
         2ub8cGGc4RpBwXYlK/5PCttQLTEmrXkE0F4Geiwdp8gUkSIBg+hOC/uRE5QphahhO4OJ
         yDTc5dgcnGTcdscFiata+m8woyEtUCdCfmr3qK0is2dy6IRUBjukxiXnxP3n3YrpyrWk
         MtUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9BGUCWxywmSqW/Kd3Ha2QF3DOwIWqbYIoTgVPrb7HQk=;
        b=Z8YWVgdI6pMLke5vSGH4TBeEM/khTy5dxmFeXjaxj1Vuk5jMqHZ/yfyYaSvF0K/M92
         q+4lIdEdzYXWsp5rSDOef8nPgxVq9s+BdJMvXJsuKmgT7NdgXPDYsqziBZev3oPApatk
         7K0+1XQEr4509ihT/Zlu4o5bksL8rfR+MNF7Rr7jG7praLOGOnEeR0Pz2D5yuPwyzqH3
         7aduOug2oRGKoStMIg5tD2mOdFOck3VOIKh1psmItpROMvoqHcDtiBZJLChFKA5U+Tuj
         5aGBpZXQfADc9ueNBU2wLRYiAKHtt8n82KEw+fFf8qJQqvB6DZBmUZk0MWaQ1TETUGND
         b6ZA==
X-Gm-Message-State: AO0yUKXb9RNhuEsJNsRUuoOGm6rdrr04NJVQu0zgCL5iD+LA52ttJG5N
	GYwKPQiq+4Ai5qc5U9NoO4T0JOwXB92nyYP6t59hRA==
X-Google-Smtp-Source: AK7set8DuOCVLtSJUMAUdvgqN+SUpNwTjUDLGPm27qAHduZa07uDph12H6VTsAZVIKkN3aisMtzkSsA2ZcvUvfAFaqw=
X-Received: by 2002:a05:6102:3652:b0:3f7:4e35:cdfa with SMTP id
 s18-20020a056102365200b003f74e35cdfamr1260705vsu.83.1675831611087; Tue, 07
 Feb 2023 20:46:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230207125618.699726054@linuxfoundation.org>
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 8 Feb 2023 10:16:40 +0530
Message-ID: <CA+G9fYsB8ihp81kQ0nD+fKW1S10Kt1CeYMTSGWXU_mBzrrvA4w@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/120] 5.15.93-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Feb 2023 at 18:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.93 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.93-rc1.gz
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
* kernel: 5.15.93-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: a0b338ae148124eaaf13c5cde22eb4026a783229
* git describe: v5.15.91-142-ga0b338ae1481
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.91-142-ga0b338ae1481

## Test Regressions (compared to v5.15.90-205-g5605d15db022)

## Metric Regressions (compared to v5.15.90-205-g5605d15db022)

## Test Fixes (compared to v5.15.90-205-g5605d15db022)

## Metric Fixes (compared to v5.15.90-205-g5605d15db022)

## Test result summary
total: 167493, pass: 137421, fail: 4754, skip: 24977, xfail: 341

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
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
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
