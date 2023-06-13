Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE35D3C00
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 08:10:17 +0000 (UTC)
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-46e4d4081beso91755e0c.0
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 01:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686643816; x=1689235816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJGoti4fG+0pknEggWZJXFELNKDoqGk9G5Z/l41RQlA=;
        b=hMlTihtRAuHJ78JmOxiGdKTyXO2S/91L2mxQUOCk6NlnVgqp2VFPHI2CphpRvbincy
         uVAmHyBoqXM0EWPyV9QukzhHtzlB8FGBY4SUY8zUBjwI++MD9Qvn85/3zvQ61glIXQHD
         /bRtSGTPjBtXDaMSq1hotNDSBd5xcDMbhTCs1ieM4WHXlAyb6QPPKkPdOeKS2rZg7kvQ
         MFdIA/ZxQ18xdnjz3sk8oEYGx2biBeeo9EfS4XAngmxXthh4zwi0GcmpGCYYCIdU0EKc
         d5ygTugefl7j8sPiKQtc0Hbiie5DuZIE583EuKBMtAsO3B1rvMuP9IMBCsxbx7ZAQNdJ
         q0Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686643816; x=1689235816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJGoti4fG+0pknEggWZJXFELNKDoqGk9G5Z/l41RQlA=;
        b=Vi0YH1HeJwFwa8DoUsU9qouiwHAejEvQdo5Kqt8kRDH5IkcZbsVlwdPPYswJam3/w6
         b/e5EULGf/2r3zrGmOGWJzHelpTZTCZX53xPdgP4iuy3Pd30WQXC1FUNcluA0DIPiTXD
         8gnbNhg7/GeAGJ+r5v8F0OD84WBqhlld7gR4AZvbqglGKokYdYSM56RRmHz45tuEC1RS
         d7SMppYEBk//7p0RYcU+rph5YXT/7V6fzuFk/gpvWvtPK4ykWkiF8Dl3gZQToIVPhQQt
         f8Ju56t5DQUgOSEAivrM+BfOBB9MQiU2wBJ0VLdaEoeg5NlHKsr1KzVeyNI1hfo9En6o
         nWRA==
X-Gm-Message-State: AC+VfDyXFWhHH0msIK/8cx3CXo16jGpg+W10Z027AtYj+bW+gzb2/rDx
	kkK+p30ZqnvJ85HQMS++1rpTbfgZN+pM0sxbegAv/w==
X-Google-Smtp-Source: ACHHUZ55hm3X1GohvSzQ92ugV0VO5+HkLZJhpRZUd2AiBnxKhL0ZabwNCDiom74vi0mGM389RV4QmeNsHhnJeZe0DRs=
X-Received: by 2002:a1f:4386:0:b0:45d:5914:80b with SMTP id
 q128-20020a1f4386000000b0045d5914080bmr6056714vka.6.1686643816204; Tue, 13
 Jun 2023 01:10:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230612101710.279705932@linuxfoundation.org>
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 Jun 2023 13:40:04 +0530
Message-ID: <CA+G9fYvWcZ0x_i3FEdhKb53+NzAs8O-B_dz6jvU1Afv5xwnPDg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/132] 6.1.34-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Jun 2023 at 16:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.34 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.34-rc1.gz
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
* kernel: 6.1.34-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-6.1.y
* git commit: 08f336c8c68dd7cec1d536063754c10805a7d5b4
* git describe: v6.1.33-133-g08f336c8c68d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.3=
3-133-g08f336c8c68d

## Test Regressions (compared to v6.1.33)

## Metric Regressions (compared to v6.1.33)

## Test Fixes (compared to v6.1.33)

## Metric Fixes (compared to v6.1.33)

## Test result summary
total: 169316, pass: 146224, fail: 3790, skip: 19022, xfail: 280

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 150 passed, 1 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 41 total, 38 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 38 total, 33 passed, 5 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 46 passed, 0 failed

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
* kselftest-watchdog
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
* ltp-n[
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
