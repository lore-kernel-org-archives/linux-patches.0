Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C82257A
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 12:28:06 +0000 (UTC)
Received: by mail-vs1-f41.google.com with SMTP id g12so5971707vsf.12
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 04:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676982486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6s881pmuKwph24asBcE5u5JIORQ5AHE6gdovKQqgyMs=;
        b=TPOMTNt0WiYkI2y93B0i8TZbPyD1GxgQWEaxNLI/oi8xc6ywzhHKusXaxgiez+3awM
         Bl/u0wNJ6PtNG2ofV2jsAyaqRlCKAJ3KEKh3SID1aEizECMvXv8J58p2sdbhq5vsy4iM
         gsevlU7g/a2qo41pKK3rCRGvv4BZ82on+Z/8t353kwfpEWO46veyFtWNVjkPStNCsGVS
         rRDp3qMyAKuAnRXw6k9+qgHWNr5yaSBaJxKgtmMTTNuZPNKlMaJT/DIos2Vsvi4FWfoq
         Iym2Wvoq+yx45h/2XAX2BH1s2LJaWu8Ucvsn8JsCP5t7XP3E7Tox045R43wvQJ6ytfvn
         hwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676982486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6s881pmuKwph24asBcE5u5JIORQ5AHE6gdovKQqgyMs=;
        b=CWJGJRqP2ySH8LxJnZwahiVYKp80hcaWcU/8oPp8e0tBdlygT/2tw7YIXissdUtanD
         1TkH1Yo+HZlUqPczXw9O9AT/WSWXdlX9TIsJCdWW+paFOAFsqG8PIqlz8bSXBlnD4HqC
         4h54/G0zGu7+mLmbR00B/BaVK0ika6FidJ/lVjk+aWQKv1e2RXe7Tg3Mj2x9nD4bQR/P
         x0HBQu0xzrorbB38i86q4TU3EudqRqqW8mjItivForwGqmgneKUUEw3KX5sNzwGxF+6f
         GALutD7/Zfng6UCQzD3F7xSGXhHkDmv5QGEYVSJs0IV2IU9G8RIrpT/KzPt55lnahdMN
         fbVA==
X-Gm-Message-State: AO0yUKX/xTBd+OjZi7LXcSFNVViIZfbZjsKSwXzBUqqwsRqrX8QxCYtw
	hsrQnEsy0AfOOGcSYE+JUnD09pJu00o5luAN797MVA==
X-Google-Smtp-Source: AK7set9CgFAXa8X0dpmM5jq8DddbwBC8HpXgS0UKe/A1/EqRqLiIunwYtMqRjMGQ2584zHktQaX59LdgAs5TVJ0D6Jo=
X-Received: by 2002:a05:6102:a24:b0:41e:991d:8814 with SMTP id
 4-20020a0561020a2400b0041e991d8814mr223496vsb.71.1676982485594; Tue, 21 Feb
 2023 04:28:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230220133553.066768704@linuxfoundation.org>
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 21 Feb 2023 17:57:54 +0530
Message-ID: <CA+G9fYuXJVQK-a-EVR+Z=ihgEwQPsaF9kafW=JYWpY3JztsYRA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/89] 4.19.273-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Feb 2023 at 19:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.273 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.273-rc1.gz
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
* kernel: 4.19.273-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 717ab64d0adf6544c30105e64d851b388324c7ef
* git describe: v4.19.272-90-g717ab64d0adf
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.272-90-g717ab64d0adf

## Test Regressions (compared to v4.19.272)

## Metric Regressions (compared to v4.19.272)

## Test Fixes (compared to v4.19.272)

## Metric Fixes (compared to v4.19.272)

## Test result summary
total: 108520, pass: 84162, fail: 3369, skip: 20591, xfail: 398

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
