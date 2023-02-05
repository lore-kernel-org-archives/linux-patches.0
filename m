Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E14723B4
	for <patches@lists.linux.dev>; Sun,  5 Feb 2023 09:10:35 +0000 (UTC)
Received: by mail-vs1-f42.google.com with SMTP id h19so9722984vsv.13
        for <patches@lists.linux.dev>; Sun, 05 Feb 2023 01:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VLxzCfAuB3mMk0uOkOzfb8NTkZjPf17jvrqwzu/1ISY=;
        b=LVbfIkquomoFzGFHhWUONhQqxwqv+LS4MWZlVn49h+UdRpco4ZCzOuWcFAhmfaM49L
         Bqwt642qdOqVvesPhDSaVQwgPcEjrtuPS2t9K8MMtHmNBmLOaV08071az9XNvhPJ4Oen
         07aPiTNIxuwzYYPHa2TFcJV+IefwDL41QTKuzvhT7ypomYgweR3G6+m705eN6z+xRSct
         fpO5j87s3K+MwpWHApucWNFC1Mq4D5lVUmx2yZqD0Z6/kLg6a1oRRmlSa1Uc+Pq4Jsiw
         xPaU211SzB76fXOE7w9tszpGRW/SXdB7PuqnqgHxo/vN2wGj5Xz/7FQqo5gxfrG7EZ95
         t+yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VLxzCfAuB3mMk0uOkOzfb8NTkZjPf17jvrqwzu/1ISY=;
        b=Xqwf0WYeVnIi99D+5kyd9biLMx325NDOrQq205UiC4/BIFlEh1pXVO1vU9IEwmgbjm
         N3yldcc8rOY6RpU+9TRY0cLNEbz6zB42Hvh1o6b1PLSJl8CfRZ5+dGbf6cDJMS/mhWQE
         qipqAPtjiWEiZ95msHvk2A4MMcuzivq8J/w6dk1Fk+0e+druG5eaApriROh5ZRX352Vc
         c6Q5jXcbQleQe5T1O+EC8vTwKEH/iAKAS+oFYa58Rn3p2NSvJQCo6zBkQl23/YJYXfJX
         QziI3vwQ7NjfsycVFEZ/jrvOgkL6AO46g8T3zR+MYr1p2f1aE8TU6YFCvylM+rn9ez2v
         jS9Q==
X-Gm-Message-State: AO0yUKXT5O4FBDhS+3f3ff0ZmPBi8R5x/Qg3/kCF0bfPlOQ/X4+IMI74
	LrJi/NGkbf2pnTiAZr5MQPXUzcZm3PRGWsoAGwsvl6Wc3G3QLgjN
X-Google-Smtp-Source: AK7set/pVSJu6Y4up8NykcK+C2LBpNAQPMFNCR4rxU88lIwjPITS2blC1yvy263f14ZeaOSs2ayEXFo71brvGWZEUAE=
X-Received: by 2002:a05:6102:3fa5:b0:3f7:4e35:cdfa with SMTP id
 o37-20020a0561023fa500b003f74e35cdfamr2265041vsv.83.1675588234014; Sun, 05
 Feb 2023 01:10:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230204143556.057468358@linuxfoundation.org>
In-Reply-To: <20230204143556.057468358@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 5 Feb 2023 14:40:23 +0530
Message-ID: <CA+G9fYumzgMVJZjAjYaGq8vzs0eqBCppe=L=bWTougpu_W5k6A@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/62] 4.14.305-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 4 Feb 2023 at 20:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.305 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 06 Feb 2023 14:35:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.305-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.305-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 76cd9cefc3a262da4fc9d16dc3946124e0218cdc
* git describe: v4.14.304-63-g76cd9cefc3a2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.304-63-g76cd9cefc3a2

## Test Regressions (compared to v4.14.304-63-g001d96b34795)

## Metric Regressions (compared to v4.14.304-63-g001d96b34795)

## Test Fixes (compared to v4.14.304-63-g001d96b34795)

## Metric Fixes (compared to v4.14.304-63-g001d96b34795)

## Test result summary
total: 91909, pass: 79431, fail: 2980, skip: 9151, xfail: 347

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 311 total, 306 passed, 5 failed
* arm64: 53 total, 50 passed, 3 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 51 total, 50 passed, 1 failed

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
