Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4014C33ED
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 09:33:29 +0000 (UTC)
Received: by mail-ua1-f41.google.com with SMTP id d12so685536uak.10
        for <patches@lists.linux.dev>; Thu, 09 Mar 2023 01:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678354408;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a6NJ8jZlGXDKqz4F6ViXwHF/cy0kv/iFG5qHu8dcTVk=;
        b=OXyEusqXWGAEy8CnaYmZ30A720Fgy2SgZ3MHXomOY+4A+b34mJh94g8Nl0kYi5yvyS
         MZm4/MREQjXd4gwIGWb1lIsZ7KZ+p6FneXLTvsUvx4lO34DDSf6uX0P2g/i9Ymelo5PS
         J5PiRe7ZtQCUsXr+XN5/H9bXAd3w3R++hiJ1/zmvVG+EFVexFc0j/KXtOJS1N6+xst2y
         0/NriDdtOz/51FkzwqBQWzE5HAwjSg3t4q1SiRG9ptCrAOjJfet9b+XAsRLZn/VGV/P4
         89MBuwTz/fjmKlrLUXmIZxo67EFNK9TSum7JoyL24T8UcRf6DfWR+xt1qw6NlKt/TSL2
         lNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678354408;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a6NJ8jZlGXDKqz4F6ViXwHF/cy0kv/iFG5qHu8dcTVk=;
        b=oTx/L/wVbSZkqQCQVHWPqS5Im/nssLQQhDBI9tw5mSODtAovLjekkA8dq0rG/mAilK
         HCLYD7T/1Xq+RE0xTIDLa7gn+B0cUCYESLVSVTUVWRJax0r+pBSxWdz/gIEug4GjZSzU
         GqZLxODQwtct42K4h151csDtBJJdtqDEBHXf6q5a/gq9i3CYtsrKcn9Vavp+hAGSVW+E
         X5vks+ejGjASU8nsLCL5I9F6ZJBBim2/xv29Xi1wQLsSZjoy5X0CLBh2O8DUq7hDX+ef
         2Rn50w32yDHVz1NdTKOx/GsjLDBofCd3RPtszTuaROoXkhnm3bEcX7ej2SW8DtnmQjnx
         lKVQ==
X-Gm-Message-State: AO0yUKUoIuL1NTO/X0CcH/2Zug8SaB5s1XX86gM2fedaPYE8tfdECjTU
	viqnG+8bCQw+HzbCv6Ld6lL3Dk20ohODvf6nWWxWhw==
X-Google-Smtp-Source: AK7set8hOPKU1eR50fOB1UEnr0CrQBJzTH2q+0AWMw9HkBWVoerFlxX1Qd2y62wHSmDovrcyPhK/cga+kGDSuUdHpRA=
X-Received: by 2002:a9f:310b:0:b0:663:e17a:e5f6 with SMTP id
 m11-20020a9f310b000000b00663e17ae5f6mr15399979uab.2.1678354407846; Thu, 09
 Mar 2023 01:33:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230308091853.132772149@linuxfoundation.org>
In-Reply-To: <20230308091853.132772149@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 9 Mar 2023 15:03:16 +0530
Message-ID: <CA+G9fYt586nAUh7nOcpGre2ffxv8wXw7sQyUHztPTGh8ETyb6A@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/887] 6.1.16-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Mar 2023 at 14:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.16 release.
> There are 887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.16-rc2.gz
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
* kernel: 6.1.16-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: bb4e875c8c41e8f41325722722e6a9cf02850f50
* git describe: v6.1.15-889-gbb4e875c8c41
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
5-889-gbb4e875c8c41

## Test Regressions (compared to v6.1.15)

## Metric Regressions (compared to v6.1.15)

## Test Fixes (compared to v6.1.15)

## Metric Fixes (compared to v6.1.15)

## Test result summary
total: 163829, pass: 144385, fail: 4981, skip: 14421, xfail: 42

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 144 passed, 1 failed
* arm64: 47 total, 47 passed, 0 failed
* i386: 35 total, 34 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

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
* kselftest-vm
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
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
