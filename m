Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E5C7B
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 08:38:09 +0000 (UTC)
Received: by mail-vs1-f53.google.com with SMTP id i185so34968475vsc.6
        for <patches@lists.linux.dev>; Wed, 18 Jan 2023 00:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xSpb9k1VQIhesAkOYuaD05lW2+xLG8Wkaag5mS/rNM=;
        b=bBoTlcpchQEAT8sYNjdVDmytBYHJotBKNLXZfjDqsEqKC/jTQNsOuGsBJNUg2cE+/M
         xK061uO/lGuoHIP5AOS0FzmmOFoSoi03wnzYL4RxWZ6At8vHJrVU6vb4AmZgO+IEICEJ
         f5ibDbvPnN5XVdiNxsaf++zPx5NdT0CLRGs+1tCW56D00nvt23R2sBwUuwdJ0B7S6IBC
         654w9R7KxamaOIMRE7FWa6lu3GSCL6XHJm7bTIeK1hc2UCBJaC7omCeM9yA3QNvrV7Gk
         T9OJ7yyfxmQtjJCNflsSjjfqJxLlDJNQkNhU1iVr1FX1wRmwUkk8D8zRZY5mAJYbublm
         eQUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4xSpb9k1VQIhesAkOYuaD05lW2+xLG8Wkaag5mS/rNM=;
        b=klPubsERANn3dKai4kQ1nxq0nbzHq+D/x+GVO6nmGB79WJrm6FTQ5DCHdoVn3HhfHN
         fudn4qamyONRbP5qy4+mZRJMJ8Ukiyhhqz12+SLUHRDtENVlh9KaOyWx8xaP56j1s/5H
         7uyOVEyuH9ZfmKZiGN3dfDd3sSQdTw7of3lzH1aThNJJH82fdffc5qzD6U2odKVbndTh
         PeW+ejfshiBc7tRKxKX+iQ27fq0meOsLZvE08jIA2HvO3+rQ+KvN2FE8U1w174FbeEU1
         +VNnJz4YTOGVXnLoJaMV9AgoIxgrljv3chgD6r3xr0Xx4E4C37cHMSQ4WuU46zkDYyas
         8Skw==
X-Gm-Message-State: AFqh2kowu0O1h72t7+yQoUvqiUo0Cxdc77dOynGiQCAjlGVB2Cvd8kk0
	xRE9EUJNZ+MP3qZ0/Kd2z+tG6NahNx4e0t6MG0rgKg==
X-Google-Smtp-Source: AMrXdXv3lM7bBzKfS09f3aOeVbB2umM972cC+13zP+aiQAy3z7Ci20mCWR4+fGIJRkSe2Mgv2EqRZt7FhE4IiH07Z78=
X-Received: by 2002:a67:f9d8:0:b0:3d0:8947:f6f6 with SMTP id
 c24-20020a67f9d8000000b003d08947f6f6mr845609vsq.3.1674031088396; Wed, 18 Jan
 2023 00:38:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230117124648.308618956@linuxfoundation.org>
In-Reply-To: <20230117124648.308618956@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 18 Jan 2023 14:07:57 +0530
Message-ID: <CA+G9fYus9p1Qu7HHxdphBcttDtGC8_J1w1Rn+vEPY4Be3epp=g@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/622] 5.4.229-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jan 2023 at 18:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.229 release.
> There are 622 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.229-rc2.gz
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
* kernel: 5.4.229-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 11f7238df0b49d924647889fa54e04c023811200
* git describe: v5.4.228-623-g11f7238df0b4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
28-623-g11f7238df0b4

## Test Regressions (compared to v5.4.228)

## Metric Regressions (compared to v5.4.228)

## Test Fixes (compared to v5.4.228)

## Metric Fixes (compared to v5.4.228)

## Test result summary
total: 127769, pass: 103864, fail: 3495, skip: 20045, xfail: 365

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 146 total, 145 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 26 total, 20 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 37 total, 30 passed, 7 failed

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
