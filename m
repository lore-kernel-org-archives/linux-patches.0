Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F12199BF
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 14:31:29 +0000 (UTC)
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2c007d6159aso17236501fa.3
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 07:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695306687; x=1695911487; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LlxydF8le7it9YpHGNLNEPIlTudRJihNNIHVUyHtnc0=;
        b=JDWRitbIreUqOfqCwiX2loXgM6pe7Kha36gibf6qplEe7dz0JQtO17cnZudXlsSE8q
         1YppmNiOnylnFSsC7g9S2ZsyECaPVf9jlKyr9lQRDXGEGpvWBZg8+RCMJsywiw6XkyxW
         Pax6SbJRqJ9EWd579nAERv6cSStuldSPtmC0yjkQ6BEY84FQvonOdO6aP43cmxnUoKbA
         7lhgGlumgHMLO/hXbUzX/nvs6zcZB7E4ZDNabubyIwyallz/m2f9IcUKei0hGIjUeNUI
         29KOGYb1/MxP/Th0USKD0PfK5fxpS8RqUKfpzfsPfrommaSGqohR10P7ndkjV/JWtyMi
         r4PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695306687; x=1695911487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LlxydF8le7it9YpHGNLNEPIlTudRJihNNIHVUyHtnc0=;
        b=WUvYJO0JBD9+Guc7kegySK2+H+6x1g6lX115SC1ZF8KzrHQgVh2epKOFCnFC2iknGP
         TELA9A1qFeQWItx1bk8fP7eiTBf2aT5qtOsWUveHeeHVKSFIf24f1A2GFk+ABrQZAi78
         AVN6BCqk0rasPWNHaXylUAHoDwm7LVe1mucKTsqN2bRy3vZ1zRGoxGsfmJgV1f2hT2kP
         TAXki+n5Xhg88zndIoDapYXLcyYTwJ7eV2xIvT+AweZeu8ghsTaVKM9zSsOXu5kUj83d
         I7Coaosn+KD46II3eE2Unk1MGKZwfC/5qRN7yjg+LEIx51ChOdFFSqYP+ulaVabKjQhC
         GI+w==
X-Gm-Message-State: AOJu0YzRbNAjEXfQABaH5YJgl8Z9EIlS2z/TnC0yhW+Dk95PPS4oVNEw
	R2uaYETHyX16k+IKLjDTUB8f8TLcySki3Pnr0j+UAA==
X-Google-Smtp-Source: AGHT+IGF2cvtTba86WdIfDIU3gmonfJVLY6SefqVJdddvwLJLTBmjRH9SaGtP+HeAhkkuKuCQYMl5QElQJBjGmSTwRw=
X-Received: by 2002:ac2:5e28:0:b0:503:b65:5d95 with SMTP id
 o8-20020ac25e28000000b005030b655d95mr4651461lfg.6.1695306687047; Thu, 21 Sep
 2023 07:31:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230920112845.859868994@linuxfoundation.org>
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 21 Sep 2023 16:31:14 +0200
Message-ID: <CA+G9fYsSUZF3YZKkKQqSRJKmoVHoNgCkdB4WhwiwVz+a8uYh8A@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/211] 6.5.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Sept 2023 at 13:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.5.5 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.5.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.5.5-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.5.y
* git commit: 9e47a110b1b588900a2455918785c47d03dc01f0
* git describe: v6.5.4-212-g9e47a110b1b5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.4=
-212-g9e47a110b1b5

## Test Regressions (compared to v6.5.4)

## Metric Regressions (compared to v6.5.4)

## Test Fixes (compared to v6.5.4)

## Metric Fixes (compared to v6.5.4)

## Test result summary
total: 127706, pass: 110002, fail: 1740, skip: 15783, xfail: 181

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 144 passed, 1 failed
* arm64: 53 total, 51 passed, 2 failed
* i386: 41 total, 41 passed, 0 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 26 total, 24 passed, 2 failed
* s390: 16 total, 13 passed, 3 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 43 passed, 3 failed

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
* kselftest-vm
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

--
Linaro LKFT
https://lkft.linaro.org
