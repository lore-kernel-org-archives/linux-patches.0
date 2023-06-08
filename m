Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DEF10973
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 17:13:12 +0000 (UTC)
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-43b2e00d1dcso196591137.1
        for <patches@lists.linux.dev>; Thu, 08 Jun 2023 10:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686244391; x=1688836391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gGDzTNo47gL3l34z709RXOSmNh530aPfyDAa2PpnDE4=;
        b=b3Dv8fvrjKQEy+TMIi7ctsJVB48K5tnlAfFEFCMzdK/JltrMYm5IZ9HEQpnOOfP57E
         241FaucH4p348Nt2Qommj/0ANcLehDQJzvUHX4e5uyTeQcZ5/pFY598O96AequVC+jNe
         xodXql3z1Pms23QdpB7GwaAIEGExFUU4B+Vk91y45tkxqrDQDWdG7rvqe56WDcX6v9j5
         SPJnAO91xMputfP5mi2oOFvVCpXAExgdW3HPVIxDkuN4O+l51r7egtJpT+RaSpliDHIl
         znRaSuUdg0wcRZQ/54ChrByDk23/VXph5CjKH+pg6LmOaC4mMRYe0vGBRt22GSJuB9Ld
         0dXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686244391; x=1688836391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gGDzTNo47gL3l34z709RXOSmNh530aPfyDAa2PpnDE4=;
        b=Dq81Bpq77/pM69dmpRAzNEgV1oRUBlybdQezjEHzCnTy7nVHUcuXjLbONIgk0z0C84
         9Td+4RbeLJ3yWo23UXsPJLAtEhexYozoIK9a5NycRZ0XBz5VIPMr4t2umGzodzJodBVB
         AstxhFgEd16j9XUlsmjGKGmS77HXLPSxxenc0wFlcKd7ym1S7mVnGCnERrJ/ANoy/af3
         THxsencrA3cUjLyN5Qe1WKRmISxc4tryb66z8IFuaPH8cOrz4qfdilR93b2d0g9teKT7
         f0ZR/sQW/f+Hfq3teiHUKBa4gcVaaP2BpFTBO0CXuWFJQSone7RgmAK3ZtPapvcp0sfo
         jwTg==
X-Gm-Message-State: AC+VfDzbqyM4YXVNfG1GlmK8fQhmkZ4kS/tXdIAaBYgUW5QZEKLmvhzI
	Pplfxh5G75ciHUhiNn+aLuinv8688aqLgj0bdLXU0g==
X-Google-Smtp-Source: ACHHUZ5p2sYpthMeyynQsL3fnn0x9KnmeKSzKyjkx8xCpQq8siwDUDJjP5ULhYIcwh6Vc5jA8+sVMIE50cd2kGb/WWc=
X-Received: by 2002:a67:fe50:0:b0:43b:32a7:a0b6 with SMTP id
 m16-20020a67fe50000000b0043b32a7a0b6mr1996561vsr.16.1686244391354; Thu, 08
 Jun 2023 10:13:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230607200854.030202132@linuxfoundation.org>
In-Reply-To: <20230607200854.030202132@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 8 Jun 2023 22:42:59 +0530
Message-ID: <CA+G9fYuEwrL90BCDhd=EqE3UVwTGC2yZ2ApU9vTZAvTL+RSH2w@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/88] 4.19.285-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Jun 2023 at 02:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.285 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.285-rc1.gz
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
* kernel: 4.19.285-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: a1cebe658474418a36d59fa529955125794d12d8
* git describe: v4.19.284-89-ga1cebe658474
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.284-89-ga1cebe658474

## Test Regressions (compared to v4.19.284)

## Metric Regressions (compared to v4.19.284)

## Test Fixes (compared to v4.19.284)

## Metric Fixes (compared to v4.19.284)

## Test result summary
total: 58580, pass: 51345, fail: 1808, skip: 5353, xfail: 74

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 111 total, 106 passed, 5 failed
* arm64: 37 total, 32 passed, 5 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 26 passed, 5 failed

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
* kselftest-x86
* kselftest-zram
* kunit
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
