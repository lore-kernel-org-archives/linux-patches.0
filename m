Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CF6539D
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 13:10:29 +0000 (UTC)
Received: by mail-vs1-f44.google.com with SMTP id d20so14038700vsf.11
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 05:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A4WVrBFRQq4QUsRczg7Y2MlyS+WU9bbe/QBWkOJ7jUg=;
        b=IkfC6GfwKNX1BqeewIAO0G8ciDmdPCdksUI/fzcokzIl9YSapNYNVt3t/kCOdpzxLi
         LqChzMrQGPhjEaoCqgqpYafwPFAu1UOYvN7wfIuthGxstoQcZ2SQGialy+OrIxx1MYXj
         ZxbYOMtjZ2ESHBJn3U8G0cAoFeJy6y/sSCqFgR2cl5fZ/6zjXwddZaMLjIyyArzbW1r1
         iwoWn8K7bLp/4AirMZYKaE31dK75Rjdi7IZXF/Kxy3GMue5bkzw5dz/tc0IomnrNSIPp
         rfCN0VZ8qryKcYyWNxiirC1beblnkOvIrTxAhGkoWHILG+oyjkE21/erVrvzUGi/MG3Y
         VAiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A4WVrBFRQq4QUsRczg7Y2MlyS+WU9bbe/QBWkOJ7jUg=;
        b=caN6ebJH9Be5edFhz5LJ5+tEnRt4NtqzQfLHEqIkL1SAAnZyz8KFZwDMolAlaHEI1n
         RXiNrkbfKSyaD7nSqu/I6mGkWXRMGmG9Qtk97G6AcePYoTntAdoejCvlLQm7Xoms1k8e
         DeXv6yq+S80KERZxzNWnzFt2CA6e4b84jEEAqJ0m4YP1HnrMyO+w4wAIPikkQlod5M2D
         5qIy7tsCoUB4CrTqPU4qm2KxLEYsgH2Xptvw3LkkTU+MYlFBvalRHcj5zymeqC+6CK0W
         ZViJtGB07qNuDoPb/O/FBRt7C88zbp63zOEAHCSNGya5ydLv3m7bxHegUYtNo/ax+WXv
         dTkw==
X-Gm-Message-State: AO0yUKX7t3zryAgVMSjZ//GYbe6u7Q9W9TYty9THY/Jok/aZGLX59DQ5
	PLKVkNvZZBDItmNiVtjh9oXzF1GNSgN7EGpCTCmB8A==
X-Google-Smtp-Source: AK7set/HjK6h3VTj4Dd5ARCtQPbgumo+BCPTwaNjqFo5aRBeoBqZmjwYXn7zixE2lXTiIbeYW5IvQshbzuw8xWA86Ko=
X-Received: by 2002:a05:6102:1264:b0:412:d18:c718 with SMTP id
 q4-20020a056102126400b004120d18c718mr2358797vsg.3.1677244228295; Fri, 24 Feb
 2023 05:10:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223141538.102388120@linuxfoundation.org>
In-Reply-To: <20230223141538.102388120@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 24 Feb 2023 18:40:17 +0530
Message-ID: <CA+G9fYsqVZGp7QPrbifLnS9fx=sAq4eH5O_UTEzxZEsUGap7SA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/12] 4.19.274-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Feb 2023 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.274 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.274-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.274-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: e3bb11000779b35aa67fa437fce19d0c0d6a1e0b
* git describe: v4.19.273-13-ge3bb11000779
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.273-13-ge3bb11000779

## Test Regressions (compared to v4.19.273)

## Metric Regressions (compared to v4.19.273)

## Test Fixes (compared to v4.19.273)

## Metric Fixes (compared to v4.19.273)

## Test result summary
total: 108314, pass: 83933, fail: 3453, skip: 20539, xfail: 389

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 232 total, 230 passed, 2 failed
* arm64: 48 total, 47 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 43 total, 43 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 57 total, 57 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 42 total, 41 passed, 1 failed

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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
