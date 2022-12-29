Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603CE4A3C
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 15:43:55 +0000 (UTC)
Received: by mail-vs1-f48.google.com with SMTP id k4so14722872vsc.4
        for <patches@lists.linux.dev>; Thu, 29 Dec 2022 07:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nmYmfqjtvbfBZK8/2ZwhaSTeo2hBhd+oyVOwXnos3I0=;
        b=LKfCWv8QFNtfVhCvZxXROYgAus787paACdWe41EGKYMBn56ZTWlpXOwd46m+Pyw+8d
         UJ1zBXSxYYJd6XYZ18BqrQjw16ct2qilMGQWcabRyQ8JAhQkhmmEQqKN+vGYq0+/qsDE
         rM8zG2cODseTt9KPGhP5XkeP+V4oRrtchUUQR/kJrI5MUX+SEyfVKXbADPPymcy2MPj9
         wwE4Iu7fVV4K/hHeKfEt0LUZO7mvW1Mg82tHs17cu0GrIkWFIxPZJjVw6RLF426jEm/P
         GsjMRY6YLH8L7IE1eM9JNa1t8YTcBltmoLdJxzmkAXUqz2ZPwf/iLX2pzeKTV2qUBD25
         +vyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nmYmfqjtvbfBZK8/2ZwhaSTeo2hBhd+oyVOwXnos3I0=;
        b=x4CAB1RqJkReDAwjQS5A4upopT5EQi7K6QN9QZmfulLByPLRo5Ki0tAODSbPmkHE6j
         88w7DwzVezU7CyBb0oaXKm5VhrfN599EbekLYtF3YSCv+Tq3tGnizT6jl70PcuAtyS34
         QM+22oUYUaE9deC9qZ0ngiRKOCgXA5VeOhDiDQ7r1oMm42bu1jE33yIXAkBq0s8UYINO
         kHZF9lSu8gEHBH9pR46hZue+IMnsiHSR4q1KEuU6N98Du2QyCLgmrhItR/8qprBYiS/o
         iyoHHcI67m8ulz8wDBCCmJ/7mXTQDAqLn6UVheFf2LRI/RAaiPHnMbXzvLj3/KGEKI14
         +iHQ==
X-Gm-Message-State: AFqh2koc8QAd2qrJn/Wwo2WiL6Cn4zkm972oAdYqbCya9U2jN0rc+oED
	/tlbe3IskYMVxD8m0steyaeQ+6Rei8qjHJp8NtOnrg==
X-Google-Smtp-Source: AMrXdXstz5XMGPX5idIZD6wR33EZQEtbkH71xvI1/DfJZjRzGPNffUb02qm52fHjfqL/+yXTZCgMhuQHDs0NdFmc8g0=
X-Received: by 2002:a05:6102:c4e:b0:3c8:c513:197 with SMTP id
 y14-20020a0561020c4e00b003c8c5130197mr1368830vss.9.1672328634050; Thu, 29 Dec
 2022 07:43:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221228144328.162723588@linuxfoundation.org>
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 29 Dec 2022 21:13:42 +0530
Message-ID: <CA+G9fYtf=vBE4e91Xwd2FbkCsbKCZXe_G0E7AfhC9+RBboXHfQ@mail.gmail.com>
Subject: Re: [PATCH 6.0 0000/1073] 6.0.16-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Dec 2022 at 20:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1073 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Dec 2022 14:41:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.0.16-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
Daniel D=C3=ADaz reported allmodconfig failures [1].
https://lore.kernel.org/stable/c3c2ef47-b46d-b446-5475-366867954528@linaro.=
org/

## Build
* kernel: 6.0.16-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: 4c258f770fed290e92e6c284822fc4b4544b9ba0
* git describe: v6.0.15-1074-g4c258f770fed
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.1=
5-1074-g4c258f770fed

## Test Regressions (compared to v6.0.14-29-g65f3ab07fb24)

## Metric Regressions (compared to v6.0.14-29-g65f3ab07fb24)

## Test Fixes (compared to v6.0.14-29-g65f3ab07fb24)

## Metric Fixes (compared to v6.0.14-29-g65f3ab07fb24)

## Test result summary
total: 144840, pass: 128905, fail: 2636, skip: 13000, xfail: 299

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 144 passed, 7 failed
* arm64: 49 total, 45 passed, 4 failed
* i386: 39 total, 35 passed, 4 failed
* mips: 30 total, 27 passed, 3 failed
* parisc: 8 total, 7 passed, 1 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 16 total, 13 passed, 3 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 39 passed, 3 failed

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
