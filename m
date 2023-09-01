Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EF5BE4D
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 13:10:41 +0000 (UTC)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-594ebdf7bceso20517457b3.2
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 06:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693573841; x=1694178641; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YI+f69Da0/ReHl5am5F0DBVWSgfDHFwlWTRWiRxoibc=;
        b=qbqBy1ztQj5JH2cTlfAIM1UCK5RNahoKRHBeaDhX4pjFkQK/k8awJRYU43RuApubR9
         2bjR55ryXhmC4k4Zw9KKlxyCo68c4CNNdHClLYjWPR+goeN1QkQhQEavqaEUBIECYUPr
         lk2/9lNgY60UtJW2KNBKtOwGbO4hJ9Nj/YiUVWD2BQuwdnBgzDuGH9vqL2dwIjOUMBhY
         4+RoTXphsfccA41okpj6a0m6Q/dV9Oa8SiBhBA6siLzahwXzMFmuLyXLxxxiiZhYYGet
         0YI30llVj1T5DMyCqlR0bzqpAw4XH4oqIVHrBW8+gu2BHOqcTLljKjbUkS9X2y6whvEz
         Mpyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693573841; x=1694178641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YI+f69Da0/ReHl5am5F0DBVWSgfDHFwlWTRWiRxoibc=;
        b=QkeJ3Ck/RJLL2z8flUnHhSAb2ldgqZRgpTX1Mr3smlZk1COwb2x5oL3ZQyTr5GORzs
         5hXBS68CZw/8UCL/sS7rtN53M6S0EKcK3FL8WLn8dRK1kys+WIDaqhb5UqyGx4a5EnSP
         46akLwOPVjPGWgg+K4XUp1PACba9z2sqZFiYGVEJEZ/H9Q2QsuP9cdla6Zwis1dHWv5P
         WdUnLHT1Ibgp+ttg4PQtPRaIpo5q1yD6PPjETPOl39b0M2L3SaWJRHwY8z7mno36rZcI
         OoeTyYw7kmTIAgnv2/wLPX45B8sMMeDWu2feNCr3CYqSFeMhmgpqUdXfu6/9H01DeEIU
         3IQw==
X-Gm-Message-State: AOJu0Yzef8zfMO1g4ks6XLDQhG4sYEnVhMGZ/b8wxbF1XBq+bZJK1+bR
	sZFC0O5aMVdYqvzQnzgwqxMYY+XlJE9TDSW4PC9F5Q==
X-Google-Smtp-Source: AGHT+IHnVRWDOWAqxI/WIpfjC6F74R6HnhkU4uKg3TUyMHBYq0LyhrGZeyaSJ37S9ZpOCnM7shhW8EZHJpyQFdiWnug=
X-Received: by 2002:a25:abc1:0:b0:d64:6cd9:29a4 with SMTP id
 v59-20020a25abc1000000b00d646cd929a4mr2592765ybi.61.1693573840777; Fri, 01
 Sep 2023 06:10:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230831110828.577111137@linuxfoundation.org>
In-Reply-To: <20230831110828.577111137@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 1 Sep 2023 18:40:29 +0530
Message-ID: <CA+G9fYv_3cXagvCTPdgeVx8KNzd=Q1wfM4UiXFfMN=16W8+xdg@mail.gmail.com>
Subject: Re: [PATCH 4.14 0/2] 4.14.325-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Aug 2023 at 16:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.325 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.325-rc1.gz
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
* kernel: 4.14.325-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 9467395c02c9be2630558247a1ac6c7da38f81d9
* git describe: v4.14.324-3-g9467395c02c9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.324-3-g9467395c02c9

## Test Regressions (compared to v4.14.324)

## Metric Regressions (compared to v4.14.324)

## Test Fixes (compared to v4.14.324)

## Metric Fixes (compared to v4.14.324)

## Test result summary
total: 51160, pass: 43042, fail: 1506, skip: 6573, xfail: 39

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 107 total, 100 passed, 7 failed
* arm64: 35 total, 31 passed, 4 failed
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
* kselftest-kvm
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
