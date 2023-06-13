Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBBE3C2A
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 07:31:29 +0000 (UTC)
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-46e0a9aaa01so129539e0c.1
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 00:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686641489; x=1689233489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3g+b2vltC3F+OFQWYwq7F1tumRpstZvjgQWTEP7Txb4=;
        b=ajyvwQKYILkUw0jsBoxuZklSkcPmhVdieM59wZGhCLrovjnVQbflmGFeHtZZ9w8e7h
         egRfhOFuSKcRGKAU69EqjyK4dWlb8KpZvfMiXVVswYS9+ZyrNdcghoMBmtPHZRqRovv+
         NVRUnPaCnjAuXEW7GRunpT5+eStUUDqOph7lYTFw+n40DlA4KpogJd3FugAmVyKvCWub
         1cS6zlzwIotULK69or2kLFH95oDJYdtHsI3/TVB/frzKCOS4PxeH9UAAKbFgjTK/iRpY
         5e1UDkpJsEpihkD1USxeZZbxHIzGm5l25aqFW0cAtCtFd7HvhbIY7hlMFz12SLL9EZRi
         YJrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686641489; x=1689233489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3g+b2vltC3F+OFQWYwq7F1tumRpstZvjgQWTEP7Txb4=;
        b=Ib9b9hB6MZeOzgK9hLQi/fA0GhAvXaD2eEPDiMSn07N/6byinRgxlYXp6o8SRhUkfU
         /9lP917UzZPI77ydwUoFA23MR+WO6L9wXk/UZ7uGl3wRt8MB+5LFtqULF2bhEemAlm1L
         zU1lIlKD05zhiXaO6O/9jVTIshlbo2SktpbnBITc8yLgCyP2R4nONgrxqCuqmQosekTo
         FEDyHlpcwtOUhPCkRG2g5ihAYVOcdCQUD67P4FB7SVVO1bH2KYNN/wliU3vmD9tFb4fs
         8ami4hE7J4JxoQVmoz2cTeBh1DIJTTrNosjvsmoo8Mf6v/bWxvBB1ABes5J063WA+1eG
         vGmg==
X-Gm-Message-State: AC+VfDyi+vm9TFCyu7kxruJS4AxD1nOSWO6PrH8IFdD/vbuwUcITpPRM
	4UdwhhDkYyL1mKnRpeWNw8a0y3A17A+/9YVtBU08VQ==
X-Google-Smtp-Source: ACHHUZ5m4CsWNuBusUZbEv/CFI9N53zLRqqE56Gsn9iIA1ffpdic8WDqyzU3a+fj0pjBa98jYGw992kamWSdldSVVXk=
X-Received: by 2002:a1f:5c43:0:b0:45f:ed55:4cca with SMTP id
 q64-20020a1f5c43000000b0045fed554ccamr5861243vkb.6.1686641488729; Tue, 13 Jun
 2023 00:31:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230612101715.129581706@linuxfoundation.org>
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 Jun 2023 13:01:17 +0530
Message-ID: <CA+G9fYtbQ2uO7_vnDWuxfwoQ1dNRdJZqXQBE7H4iqesDZsMz1Q@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/160] 6.3.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Jun 2023 at 16:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.3.8 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.3.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.3.8-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-6.3.y
* git commit: 718be3905b8f1b4c3ef58c6b82bba0bb167f5da8
* git describe: v6.3.7-161-g718be3905b8f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.3.y/build/v6.3.7=
-161-g718be3905b8f

## Test Regressions (compared to v6.3.7)

## Metric Regressions (compared to v6.3.7)

## Test Fixes (compared to v6.3.7)

## Metric Fixes (compared to v6.3.7)

## Test result summary
total: 173472, pass: 151655, fail: 3242, skip: 18318, xfail: 257

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 141 total, 140 passed, 1 failed
* arm64: 50 total, 50 passed, 0 failed
* i386: 37 total, 36 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 42 total, 42 passed, 0 failed

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
* kselftest-mincore
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
