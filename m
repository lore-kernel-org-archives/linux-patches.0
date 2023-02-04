Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17FC7F
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 09:00:36 +0000 (UTC)
Received: by mail-vk1-f172.google.com with SMTP id g28so3754597vkd.8
        for <patches@lists.linux.dev>; Sat, 04 Feb 2023 01:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bNI5Aq7Kn3/1EGHMDxgGbuJMnHtDUNYcpIoe53s+84Y=;
        b=vBaptIDRa87SJmUwMHD1erCpdY3ePMwK3QUxa9GN3IGwuGnfl8j7wH7ZOAC3GhucHK
         Shr6Z5dOnHB4BGwjgkUOnAxD0qtFfBe2L4GbZZxb4KqLDhpMFLAXWcSvA3E/rQ2CZboA
         nAymzBz13ztIvs7X43AWXEr2CMSCZcRrUb5z9NKmqCnWRDUH3LxZDKrC0eF8RxQPvIjZ
         8iLilEFx7vKEvE7oywF/GFD05QSa/ZetcVZGfQ9M48JBeq8vyyewK1velvfDwsFOKAa2
         /55HMRUL4aahYIZOi0LUD7jId01OZBZvgkcx+Lv3isJgnUjStAmuuStiDvrx81AohjBF
         nFtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bNI5Aq7Kn3/1EGHMDxgGbuJMnHtDUNYcpIoe53s+84Y=;
        b=4wrRsFqotBBK+7vIyYBpLuEYXbYzA0Y4xAcyr9eX+F9cn33AgIezwP4lIS+SOOnRWb
         WrFW75MaYxQ5KdGlEJTEZ3zlyB3ojvcnmT0IjQbGABIHUxC8ogGSBqoUcJcLC3mF44I3
         PM79lz3pmDdD1ywodZsn0eIgOqefUqwjuiXbqrhYaYToKIjxMwFtGmBRSvsCm/3priTR
         1bTZ6pjIk+bdbJxxr1SfCzMGn6feqrpB2TPiXwceTt15TfjZ5lNdmJYHVMSwrkjXy8st
         7imgutqMccXR1GXhbFlYJnLEJwkXM4N52EhUf/t4YhQtzsNZU8LQx14AnaPADfkrR2En
         L+GA==
X-Gm-Message-State: AO0yUKXjqAq3w9Rw5xJ0SwkEWgPpNhCmBNJ2lbYWSdYVOUigDpkjYBX+
	LLN63hOnv5TGwwaJ7VgePIoKHuOgj8om2Q4Leb5nDw==
X-Google-Smtp-Source: AK7set9MYY2Am8jfv6DGLWFxcOM8abacBkmXwq2yZw6Lr/9pdPrOuEQL0bD2B8IVL3tnpFc4kyVg/Fz7vBvoOYxIXSo=
X-Received: by 2002:ac5:c778:0:b0:3e6:8a8:3387 with SMTP id
 c24-20020ac5c778000000b003e608a83387mr1824314vkn.39.1675501235595; Sat, 04
 Feb 2023 01:00:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230203101023.832083974@linuxfoundation.org>
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 4 Feb 2023 14:30:24 +0530
Message-ID: <CA+G9fYv7qJkUf=hZgeu_j3hE59EUWTBiLUQQpHgB0DFWwjbMuA@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 3 Feb 2023 at 15:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.231 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.231-rc1.gz
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
* kernel: 5.4.231-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: f094cca7f934dd6b1c62254251d145087d40c30b
* git describe: v5.4.230-135-gf094cca7f934
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
30-135-gf094cca7f934

## Test Regressions (compared to v5.4.230)

## Metric Regressions (compared to v5.4.230)

## Test Fixes (compared to v5.4.230)

## Metric Fixes (compared to v5.4.230)

## Test result summary
total: 130133, pass: 103865, fail: 3011, skip: 22894, xfail: 363

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 144 total, 143 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 26 total, 20 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 37 total, 35 passed, 2 failed

## Test suites summary
* boot
* fwts
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
