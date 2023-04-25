Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0913763D9
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 15:14:55 +0000 (UTC)
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-771d9ec5aa5so24896858241.0
        for <patches@lists.linux.dev>; Tue, 25 Apr 2023 08:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682435695; x=1685027695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NxnjgBH3r01yRypB6bVr6mXGG/d22cFoPAOaP3+DkyQ=;
        b=sX9fstc651c4dzxNrdtuuYCdxtWWzyn1oTILxQYSwYl/Bm686GtL73Fz6Z05TiHA3b
         T/7KS5t6bvMTlbHREPPlkGr/noKFqn1hggyBNrZS5l6sRPNwCUSrAFladtdP+gG74G9G
         qTolbyUwN9pXt6nGfXhUEcjBJo54WlP8Wc6gQOJo5ca2GEK1vy6IPyOiKBoKiDX58VDh
         TlkCYvYhOY24uEc1t0XW7YbSaYYYd+W01jFZCMmX2Cz/odEdfLXZGoHKA84h0e+bRhi1
         7J90RTdp1NJjqcbfHFiOJpngBp1AM82CNock6JGkLq33JcdIKh3Vlg1VZYRRgCGzGJqJ
         o64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682435695; x=1685027695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NxnjgBH3r01yRypB6bVr6mXGG/d22cFoPAOaP3+DkyQ=;
        b=lge700s9PidSEg9yAuPA5ZTnTDw5cdC2yCqa7/EFRhUXtnpUI9u3Ux07+qE+9iGPTn
         TsSX62++7Ti7dx0PSAz+5MZwRcwPaXjmhzMhCERd5YYEhop+YacJ5W5nROGhw8qrc06T
         HRtDB0lmfcN14lIkLVf2igQHqpbKvllk3kq9oh8oCmgLlYWzSLjelFmaQ4H4B3fl62MF
         LAzP+yx29kNERthgy16EbF5ewifCmrjtTF2kzo/oKWL+kiqoigXUQ81D8wzP3oZX6EvJ
         aHHMos4S/uTMY5dzjgWRxrJfPoa9sOPCpWOE/JvatIjKjN+A+b4zeMlS17CXa5S/edVx
         ltEA==
X-Gm-Message-State: AAQBX9f8xTKGa8pHqmrcksrbo9bbfE0JQe+IxUjRFAG0N5mSlG/8Yl+U
	HiuOeZHwmzMVOAwwfxWjjv/0U2S5EYwQPf5UPsBrCQ==
X-Google-Smtp-Source: AKy350bg7Ue4P+RG/HLejbUlXUJm67HzzN+QK6+EbTXGlSkS48R8MujxUMfMRYv9mKpWJoXo8gIE3C413ABXvEkZOUI=
X-Received: by 2002:a1f:bf8d:0:b0:43f:e623:952 with SMTP id
 p135-20020a1fbf8d000000b0043fe6230952mr6045262vkf.2.1682435694610; Tue, 25
 Apr 2023 08:14:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230424131136.142490414@linuxfoundation.org>
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 25 Apr 2023 16:14:43 +0100
Message-ID: <CA+G9fYs38=gG5tttigg_tngigDEqgXeA+QwqP2k25iUJnNrQgA@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/110] 6.2.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Apr 2023 at 14:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.13 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.13-rc1.gz
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
* kernel: 6.2.13-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: 9e5d20c139403093b3899c2aeac481792aed6826
* git describe: v6.2.9-608-g9e5d20c13940
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.2.y/build/v6.2.9=
-608-g9e5d20c13940

## Test Regressions (compared to v6.2.9-497-g7507bdf58f79)

## Metric Regressions (compared to v6.2.9-497-g7507bdf58f79)

## Test Fixes (compared to v6.2.9-497-g7507bdf58f79)

## Metric Fixes (compared to v6.2.9-497-g7507bdf58f79)

## Test result summary
total: 194288, pass: 162649, fail: 3944, skip: 27389, xfail: 306

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
