Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E728A29AB
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 16:30:34 +0000 (UTC)
Received: by mail-ua1-f51.google.com with SMTP id x33so10646298uaf.12
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 09:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679416234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0uIrtU+bZl2qj7TNQIp62bAxClByyOF0EeFBE6kbbC8=;
        b=iCVG7yjE0xAworp/brk/w4knlsCYqtzBxbuBcc6c+mezcYa5DY7mxvP/6+AdRC086+
         fNt7FAxAglgCkIemW+zeLVUcOJzeX+ulAWXuzbRS05ELM/QireO7UnHVhLHuN90TCh0a
         mpkgZTiHYX7RACwqEqJtQKxirKqWvUyhTBzbLzc9A8dTqHSufzmPIjgYUn8oO2uS8YqF
         b3GcMZ2WcKxnieUSGgpuEDJ6yNgMBEK2PRlKdsHpPC/zfKaQDtOIVwZiTx/FU/IkMRng
         yG5p+Rxb2+6RSi7cOdlIQJ5rLrXUMviVV1bcDKsEXMOprnRqfqorVG4hjN5bbXUnombL
         1zEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679416234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0uIrtU+bZl2qj7TNQIp62bAxClByyOF0EeFBE6kbbC8=;
        b=R/6sm1eoloXxHFnj9Tdtz5OFO9Jb67Qq7OKgpTuPh/Yncoh8orPJaUMGQGJAteVHst
         Eo7FschIiEniFfHP+X2NTn7dj59CDjV81KqEKer+vjOtzLmz8rUAMiM/bcVQg6INpNuS
         MTxOURGBMHXpUmXVPTMYa77g5Q8qvll6OFXEv5sw+8AX4SDjPPHT0gT45Cg05QF7q9UT
         7zefJaCxdp+wznL0xymQu+iEqnUN0cDQwJnw2F6k8NPG8Cieeo+jTW6i14oS6ctd/NQ4
         QhpzfoTW5Q7jtOCGOUkjx8N8PGWjeD8U3JWh3P+HkPaCIf+IvgW5R4z18nN9lrBjGtIp
         cwRw==
X-Gm-Message-State: AO0yUKXRtQB6ILxIsx7iyn6ETw8G4VfxmdRowDSrTZnUbME/FzvJ+/L2
	QAfJfCMk7NOiPBrTW9Q054M8ky4sxYvxTAGIpqZmpA==
X-Google-Smtp-Source: AK7set/puN1h8wFN7Y3HKojmaI6F7udH8vjy6e4sdVuQVRwNcoUn3zILxCmUAGIbBQs75FhQi49RgdrYg5P4zFmd3DU=
X-Received: by 2002:a05:6122:9a9:b0:401:7625:e9e3 with SMTP id
 g41-20020a05612209a900b004017625e9e3mr2421854vkd.1.1679416233548; Tue, 21 Mar
 2023 09:30:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230321080647.018123628@linuxfoundation.org>
In-Reply-To: <20230321080647.018123628@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 21 Mar 2023 22:00:22 +0530
Message-ID: <CA+G9fYufT4c0mAAKc9DgE1SYc_TYfUdviNfKo4s5djdt1wMi5A@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/57] 5.4.238-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Mar 2023 at 14:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 08:06:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.238-rc2.gz
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
* kernel: 5.4.238-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: dc3bb2fad2c079a9417e255cefcd5209477dbc13
* git describe: v5.4.237-58-gdc3bb2fad2c0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
37-58-gdc3bb2fad2c0

## Test Regressions (compared to v5.4.237)

## Metric Regressions (compared to v5.4.237)

## Test Fixes (compared to v5.4.237)

## Metric Fixes (compared to v5.4.237)

## Test result summary
total: 136375, pass: 111406, fail: 3211, skip: 21559, xfail: 199

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 146 total, 145 passed, 1 failed
* arm64: 46 total, 42 passed, 4 failed
* i386: 28 total, 22 passed, 6 failed
* mips: 30 total, 29 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 33 total, 32 passed, 1 failed
* riscv: 15 total, 12 passed, 3 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 39 total, 37 passed, 2 failed

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
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
