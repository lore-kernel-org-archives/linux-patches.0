Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEE88F47
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 18:17:09 +0000 (UTC)
Received: by mail-vs1-f52.google.com with SMTP id a66so32586432vsa.6
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 10:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tOBzKrHIZiNhQCC3SGZiV+P8BTy8Nspc63LhdG+gCbc=;
        b=TeKjETEb372iD79Ac+Wof6L+xeTA6p5FCrxhJMgxLzPAbJvdkDZuetOMB3DuqKh7hk
         hh0AtEkahdi1UCFFMwMeoGLzWjjYzsC1wKbC7SJUGPGdmjh2AdLeEujdeZlMXeU3IO00
         ozIKB4tPTrM45wn+tTq6IhfxOGzE6AnIAcWIM/Ap9h3MUECP7lAu1XmEJCqtuDhB8SHa
         cHYV0I9fuRRkiKGCZajESwrd41zB9T7sqoYm09kEr9nL4H5LHuJRyfenzIMZ542M4iyd
         NjQFbpI4V1Vra5PB6ncdTyxFfN8jsk058OtVEglgFSG7B+/6qADgpYizfhwom05M6BD4
         o9nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tOBzKrHIZiNhQCC3SGZiV+P8BTy8Nspc63LhdG+gCbc=;
        b=mSozc/PxNNjoKm0HXjT9Xxi7Ub0GOe3OjqsVDhZifAfFfrM0RWqLCfApa5LP72Pahb
         mGHYJywNwiW7RB296pvp9qWPoYzlqXRjMYfAadkn48wsMYsdyihjqu4HJ1/+d2v6whjk
         WsjidsUxoIBq7ORE+NgVHKgGxPVnEkZAQZyJHP8Y265rf9/ZBj1qVEmxQZ5HDNUPRgpn
         m3c12jVlXh2wuWAQT+ig8VU/Vd3v9xz6UjUk8fA+R154w+gP2JcYWyyFg02rmUUq1rGv
         b6OzETz98ntcY3bd6SPsuvPnAiDkN+NHfD9aIKT3Oh4SrIeLuOY0ofxYDnaDL+U5pCOb
         nYeA==
X-Gm-Message-State: AFqh2kqCzW41byGKPj2kT7cf4mXd1O9We8oKFwS4tn86QigdFb9CKYXp
	tHlHfQ7wV5/bOrEnKutdyr3PlrLe6LG0wPOqLxDbvaFE5IhCk9gO
X-Google-Smtp-Source: AMrXdXt0sTPrcVgkVIhWyI5jbkVfigkIYOKIynaMGTeeVh0TksKHIXC6nC1bY4tPkjJPqQjg9Veh8w2ZQ7guuIaNhz8=
X-Received: by 2002:a67:ec94:0:b0:3b5:32d0:edcc with SMTP id
 h20-20020a67ec94000000b003b532d0edccmr4938819vsp.24.1672769828471; Tue, 03
 Jan 2023 10:17:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230103081308.548338576@linuxfoundation.org>
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 3 Jan 2023 23:46:57 +0530
Message-ID: <CA+G9fYte94MoVjMBQ=37r9Wrg1C1VmTVZ7eWik3xKmu02_554w@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/63] 5.10.162-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Jan 2023 at 13:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.162 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 05 Jan 2023 08:12:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.162-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.162-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: c5bc645ae6f96d3949dcf1f0fb0a7c243fb525d1
* git describe: v5.10.161-64-gc5bc645ae6f9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.161-64-gc5bc645ae6f9

## Test Regressions (compared to v5.10.160-19-gbc32b2c55e20)

## Metric Regressions (compared to v5.10.160-19-gbc32b2c55e20)

## Test Fixes (compared to v5.10.160-19-gbc32b2c55e20)

## Metric Fixes (compared to v5.10.160-19-gbc32b2c55e20)

## Test result summary
total: 138327, pass: 116359, fail: 3491, skip: 18160, xfail: 317

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 49 total, 46 passed, 3 failed
* i386: 39 total, 37 passed, 2 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 32 total, 25 passed, 7 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 16 total, 16 passed, 0 failed
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
