Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B1BB67D
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 14:23:38 +0000 (UTC)
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-50300cb4776so1879695e87.3
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 07:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695306217; x=1695911017; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gWoVfeJNWpYOw2AR5qsdHKnZ57Lj4md4yFa3lu+nPyw=;
        b=eqHQW5SmhGm6FJTj5mcmeiD7jfwn5J9qmZ+BsWiz3MtAdyQqny85QsBviroCNVx604
         8+wX3HupzZZLKu/SvHgul599QPF5hQkxXNCN96F/VakzK+XbW87q1I8eOsRRuVJFgx2p
         4bIo2uZPj9DvAF3UVon+RP/nmaEXO8Bp7Gau6LrKGshX6+euFgp/AwdIQ/9kevLCxdqM
         hcuIlUZuBPvqRkwHpIisVwOFp52GEAMeMlHGWXcYqhbC1q1P60QksYny3dti/LBuXJiD
         W3yBoacUcpgznAdQ/GGTzEoM1v3b7e2c+3msE9t1w/hK1Cg0tSn9KoIIJtxlIMvDvOaf
         Gp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695306217; x=1695911017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gWoVfeJNWpYOw2AR5qsdHKnZ57Lj4md4yFa3lu+nPyw=;
        b=vqFYmfxuSnkHYG1mmfFNlh95HrFe6hE4mh9KfqdTclFDoFO58V1oK0iCUzwo6ai7ct
         IZaYhClruNuHchub1Hb7DITH4f6KCTccsFHnjgHKl4jeEYqFvwVlHduAS7O+k3O6KMiP
         BS0OpRCAyAb8cZRhDm/GFwcI/lJ55ZeQudafEZX4yAQ2URDNQDUlm2/JIPastGRMNdQJ
         tD3aGpNF13s7ORINin88zDMLFQ7PaBXz522gzPp+JzavQ8ctGMdzAo174HjSkN5wuvnX
         w1CE08zi6XBwHJncyxF/j3zuCW1+gSqJ6pAGqHBU7YzHc+V/r8xfqDIewOmQ4xNui+ex
         JYRA==
X-Gm-Message-State: AOJu0Yz0BNE4ajB53LUhNVNrmxLpjKY1rvvDi/00ms9Trc+35+Y64Teg
	qbSnniXwoOca0yCqxLDiAkCiCA2V6hul2IZRBs7zwA==
X-Google-Smtp-Source: AGHT+IGrMj0r3Fxh+1t0WRpllLzabcIz3dq7zkG6Iib/mVE6tHfrUn9CTqOH6oPsZenAPfuengSGbduErGKPoCw2+vU=
X-Received: by 2002:a05:6512:3e17:b0:500:bff5:54ec with SMTP id
 i23-20020a0565123e1700b00500bff554ecmr6164308lfv.3.1695306216685; Thu, 21 Sep
 2023 07:23:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230920112835.549467415@linuxfoundation.org>
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 21 Sep 2023 16:23:24 +0200
Message-ID: <CA+G9fYtOEYip64iu00BPgx+cKbdhEAhzd36kO1GzQYCWKNbxoA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/139] 6.1.55-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Sept 2023 at 13:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.55 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.55-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.55-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: d5ace918366ee2fcf06842d77abec8a170c759aa
* git describe: v6.1.54-140-gd5ace918366e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.5=
4-140-gd5ace918366e

## Test Regressions (compared to v6.1.54)

## Metric Regressions (compared to v6.1.54)

## Test Fixes (compared to v6.1.54)

## Metric Fixes (compared to v6.1.54)

## Test result summary
total: 125579, pass: 106421, fail: 2477, skip: 16508, xfail: 173

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 150 passed, 1 failed
* arm64: 53 total, 51 passed, 2 failed
* i386: 41 total, 39 passed, 2 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 16 total, 15 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 43 passed, 3 failed

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
* kselftest-exec
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
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

--
Linaro LKFT
https://lkft.linaro.org
