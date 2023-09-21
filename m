Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84963B641
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 12:47:13 +0000 (UTC)
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-4528bd2c3b2so463730137.3
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 05:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695300432; x=1695905232; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Hj2ZbHk7wD50zNluyjwn885x6blD4upSIobGwpX/8c=;
        b=akSHlIA63CXRXKpxOmUQ3OJLjoi8Rk8wnEqV5NxAWUkgzCrmu06MOzW15O1Gotpsw8
         P4SCMwsuwdNydpB7IyLAySEWX+2REoD/fKZdikxEDqFLMKnYdqiwfbDo/In2Tppe0i7p
         2aLLvNMpu9HSXVthqngJLuiFnASZvLpWEhC2HuR3BeNTX559i6dIw6Z8WBonlmjtLJ0f
         CwnaTTC4QLcnl6Q1+mAuz2/6w1q2EL7Hh3ZbyUXfIuo0pseL7Ny1nIdjhMh1MaNuy9rk
         axWCdUmYwlJcJe2ZeVZfd5kdvGPlD5i3BCmyCscT+Na1NTc9/q/UMqzhfoT7XKOVnnq0
         lxng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695300432; x=1695905232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Hj2ZbHk7wD50zNluyjwn885x6blD4upSIobGwpX/8c=;
        b=OQ+2w3yX6DjtW1tAICHXgWJvNjFYnMYEXOkVIpnkFSzdNVEIT5L+ibG+Co2VdwjyW1
         DhRRzmESQZI8L2rlls2lUVzfvwUBi5GyT6ZzDqAgYHw7sA3zLkYPQ2a2e3pLONZK9lm6
         4UMPQU3dzjy0BMyjwNLzWowoUuYCRaKRYOMSn+RkB8BzV/gK44flbDM2lcwLV2nDMG3j
         CAUlw52ssWFw/2WH/K426Fca8mnoeFYS5FW6Al+LrJ7xV+2xaCc6VLCPiL5yyX0znpQu
         NYEm5RpFezux0H3VRHA8MjJwG+XpaReqGgVI31Qz1NtbwxQoEJj3IVsDd17JoZ60b/gE
         0QlQ==
X-Gm-Message-State: AOJu0YxwpUOVm7hcFTse+hQKpGo5XUOxU6AS67BxyayWGvqUerf3zIaB
	UEXmy/qm7nfqRTtcmBuZqIlxOqTp87AzmMrOkMeIXA==
X-Google-Smtp-Source: AGHT+IEsnQ4F2rramLNiHmi2v+BX80aZfHjTbk4kweC9NP3w5GMjoWSjNXzGB0kbkdULrF6gpsuuRZ6/t6J+Wg7NkpU=
X-Received: by 2002:a67:e205:0:b0:452:86e7:5b3d with SMTP id
 g5-20020a67e205000000b0045286e75b3dmr5918515vsa.26.1695300432292; Thu, 21 Sep
 2023 05:47:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230920112836.799946261@linuxfoundation.org>
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 21 Sep 2023 14:47:00 +0200
Message-ID: <CA+G9fYvOHuu+7Ozt0eLFy1A50j5KHoacp69HGvbHezTVeDNSCw@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/186] 4.14.326-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Sept 2023 at 14:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.326 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.326-rc1.gz
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

NOTE:
The latest version of selftests ftrace test fails here on 4.14.326-rc1.
This is not a kernel regression.

## Build
* kernel: 4.14.326-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: db587d473a47d83c9329f769e7df2c07df6b77a5
* git describe: v4.14.325-187-gdb587d473a47
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.325-187-gdb587d473a47

## Test Regressions (compared to v4.14.325)

## Metric Regressions (compared to v4.14.325)

## Test Fixes (compared to v4.14.325)

## Metric Fixes (compared to v4.14.325)

## Test result summary
total: 51393, pass: 43787, fail: 1208, skip: 6354, xfail: 44

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 107 total, 102 passed, 5 failed
* arm64: 33 total, 29 passed, 4 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 21 total, 21 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 8 total, 7 passed, 1 failed
* s390: 6 total, 5 passed, 1 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 23 passed, 4 failed

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
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-lib
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
* kselftest-zram
* kunit
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
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
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
