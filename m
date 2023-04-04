Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744C7648
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 12:30:25 +0000 (UTC)
Received: by mail-ua1-f46.google.com with SMTP id 89so23171807uao.0
        for <patches@lists.linux.dev>; Tue, 04 Apr 2023 05:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680611424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xbgh9TKrIPAPQmUd9OtixARVlr01XDWJkFcD5ndOpIU=;
        b=h7Jc/fRqwzSbE72HEHrF6Qm+puChRq66jIPwDc7KVBgVnnhwJpl8ZjcMdJw8VSMoBH
         NzTuKlCDm4w6WXo/xD5nFJYLz7MOKr5fqaRKkmtqLN1j0hP6SsP26/CKhApL0SBk0iO1
         wCWGB2CQ884DMAJd81ZrPW1+BzFqFXJUtub2syEpMwm0Zh8YEZ4Sig1pgjbYQFNo2Kps
         +nRQ4/ntbWiKzk55U4GIeKFkpwXaiox2Mz0z70IrCcdhwSThvhzwneF9S7wk18wa/FXe
         hO/5KvH8xQvkH62VEKNTtVUNQ0UdPitJE6DhLNzUPgHPgSfkpkFJHsqHCoqvrgBb4saS
         XVDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680611424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xbgh9TKrIPAPQmUd9OtixARVlr01XDWJkFcD5ndOpIU=;
        b=mB9KUL7SpQyQ36oqDImbeKJBioVttnQffU6aU1H3Mlw5LTZ9NBxeu8Wl6HaLf0aze4
         kkrLdHYpx7Qa3inHhgSAP+e78qy69//v2KXDDKGmuiyvHHlTieyRcQh7sX2qp5BtclpI
         cvOEFMLh6OHfTzlvv/kTGUQjHUUmuAMZ5oMtBlSN+oiephGoMxrJHo0VsOzdTSHXMdWV
         3CkBEZlr0wtQDoZXk1ME5aoTIYkPJDlBXLGMoIW3e9R3yCjExIquVeT7uLQqW4p0F8+n
         /fqBdpaqgwQIl8KKvRgl5AuSo9k4qYgso1qFZAyLNMjl7Gy8+6zHRHQxZNYsp2JUxb/L
         JeKg==
X-Gm-Message-State: AAQBX9eU1z3jU2ml/VAx1sPAMBNBbBkxI9Emf8E3B8mxMZBQbdJIcFrV
	1aDjtZB5Z+tby4t2v+7mu6WYxXkToynZeqCZBJKXzA==
X-Google-Smtp-Source: AKy350amVqZkX8vNf1TgCd1BJv+a0EVLtADE0arsDlDJrGykVE3ERVPi8dhCGfevy90drJlqjc+BCW7ziT/6To4bslM=
X-Received: by 2002:ab0:53db:0:b0:688:d612:2024 with SMTP id
 l27-20020ab053db000000b00688d6122024mr1530288uaa.2.1680611424161; Tue, 04 Apr
 2023 05:30:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230403140416.015323160@linuxfoundation.org>
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 4 Apr 2023 18:00:12 +0530
Message-ID: <CA+G9fYt=i-zXOnA7vGVOiuNRsEiv0KmFxbqYt-L4VTHGEth_kQ@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/187] 6.2.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Apr 2023 at 20:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.2.10-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: 6e4466c69e20058ca543fa4ced70f8d745dce1ec
* git describe: v6.2.9-188-g6e4466c69e20
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.2.y/build/v6.2.9=
-188-g6e4466c69e20

## Test Regressions (compared to v6.2.9)

## Metric Regressions (compared to v6.2.9)

## Test Fixes (compared to v6.2.9)

## Metric Fixes (compared to v6.2.9)

## Test result summary
total: 195294, pass: 167379, fail: 4270, skip: 23297, xfail: 348

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 142 passed, 3 failed
* arm64: 54 total, 53 passed, 1 failed
* i386: 41 total, 38 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 26 total, 25 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 7 passed, 1 failed
* x86_64: 46 total, 46 passed, 0 failed

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
* kselftest-exec
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
* ltp-nptl++
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* ltpa-6328543/0/tests/1_ltp-dio
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
