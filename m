Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41106168CA
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 15:02:04 +0000 (UTC)
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-440ade974b8so899152137.1
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 08:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687273324; x=1689865324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ex9LH41sBtxSu4nGJTMmDXReVKlwhUxbkE+orFPF3pU=;
        b=pEGrgLluw3fEB0PMi/FzPPl+r1kOgefq6EBZyOoe0OuEHrYu03EfAv35dGeq+ACO8M
         Of1fL6arzMkS8jARtmqMBo0vEmKgdCdFOAbIpx6WCCH/e69vQG3aYK/zDQcu0l9gOEH3
         HQhu5X1suHp/3kOQd82etkSn8Pv5AHBtTOIw00NJ2Bg0l0qRLN43AHqrkBSteWkS03GY
         c8GY9UPpemcKNaGs7oxYq8bxpCpAYv3cbSduw8tT1n2017U+VpBKQELyIgAi1kOhPhEq
         JAqegnjEu/LAAYki1uAzuFvk5Ack3cOK3aSfvHgHddaMYhT2rAeciuCEwhnrExGKvaaL
         rZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687273324; x=1689865324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ex9LH41sBtxSu4nGJTMmDXReVKlwhUxbkE+orFPF3pU=;
        b=Mto85f8GpAyu63LIISM4iUuvJ0aAOXwibwAu1mTIQSFidFhhEkEtrB7K58sm/RcJx1
         +mXkpUtkqenVgOlFjTeKj3aebwDyGwcX8QNeF/R0b+OvzCvj/aRqIe6LamSih0Bacr9z
         SrgrqE1yjq3JhaEWxbIje6ygsGU+uTU5n/ZNKV4Cv+qKZwjHPamfo1ltzKS2yF5F/N8c
         ANsW/oua9VNFUFCxLFdM3MIaf9uJGf2+kAvclQlKiv0hntSJb46cdBIzSNcVS6GdeojC
         tCbCbSikb9b+5iNfnJKhzYbwKdLuEGCFziMmxvOnhtOm+bfMqBWl4uQLafxL3muBqcvd
         RD8A==
X-Gm-Message-State: AC+VfDzadUVnhXF5SPxP41PIABnUPzxHgWfJGDiFAjsXeWB8oGfHckur
	sb5Q9+oEtCNc3NKo0xegfidGfIO3ZzcT2VQEpjyAWA==
X-Google-Smtp-Source: ACHHUZ61l8hktY/IAC0pNcJtikH+zgj6xoAJwkJSzEsBNwtd6tNhRDNAQy0SnFlAQuG3RwlFEXR2znduvlY1D+ZT/90=
X-Received: by 2002:a67:f99a:0:b0:43f:567b:c61a with SMTP id
 b26-20020a67f99a000000b0043f567bc61amr5038917vsq.33.1687273323749; Tue, 20
 Jun 2023 08:02:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230619102132.808972458@linuxfoundation.org>
In-Reply-To: <20230619102132.808972458@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 20 Jun 2023 20:31:52 +0530
Message-ID: <CA+G9fYt_1vxhnHywwbLmLqWNytxu8VcU4mzmCcdH88gt+CpjTw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/64] 5.4.248-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Jun 2023 at 16:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.248 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.248-rc1.gz
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
* kernel: 5.4.248-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: d4a1c8c10fcdfa1193f2b8a5a632ee5918e74a55
* git describe: v5.4.247-65-gd4a1c8c10fcd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
47-65-gd4a1c8c10fcd

## Test Regressions (compared to v5.4.246)

## Metric Regressions (compared to v5.4.246)

## Test Fixes (compared to v5.4.246)

## Metric Fixes (compared to v5.4.246)

## Test result summary
total: 135818, pass: 111037, fail: 3470, skip: 21217, xfail: 94

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 148 total, 129 passed, 19 failed
* arm64: 48 total, 44 passed, 4 failed
* i386: 30 total, 22 passed, 8 failed
* mips: 30 total, 29 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 33 total, 32 passed, 1 failed
* riscv: 15 total, 14 passed, 1 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 41 total, 39 passed, 2 failed

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
* kselftest-sigaltstack
* kselftest-size
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
