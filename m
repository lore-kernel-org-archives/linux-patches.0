Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAD6648
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 05:11:52 +0000 (UTC)
Received: by mail-vs1-f48.google.com with SMTP id cu36so27363404vsb.7
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 22:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680585111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SCiMJmUi8GaQ+x1OyTgFrNc5tQQqEFd+PygZeMOOGjI=;
        b=YGyuMqUTM5D9CeLhG6088aMd/+HgcJ+QoHsGZlmMCscGNlPTDjJfOdxKaXEdKG86Tc
         RJeiV03HoDKlpeCd+enyYmHAvE1uLgrT19GcPrGCrM2e3YF8xE49bgm01bM+or15PGE3
         eg0yrLkn5f6KkSKruqEqTxHQsiU76iJrPsDHJGXVOuB598RLhT6aoaTWS2bXzs7WVs9m
         iAV5nmL3WZs9M0sLSP1FvgDNAKsGsea/6tlhadFKLq8VmPdi8ipS40AMe5IELCqJ/7Sr
         T6+uDSCBtsr80NpKcFfgjTcB49i9FJ8dhy1cJk+RHzGA/HAKvPOdXHEzYnBLjYVewrVT
         ZoyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680585111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SCiMJmUi8GaQ+x1OyTgFrNc5tQQqEFd+PygZeMOOGjI=;
        b=5TsZyAI/pqSNEiCmVCq9LdQnS5gNoslJPHZXnDvJeU0zN7Ax0pPDsP5y+/7vaCBKTy
         TfwnY28NL31cofcQAeBzZMFfrgT/v49UWwHLKh+DuMk+M2SZfy1QDLkraSDmK3yGVDyp
         p+CNm/b9/aJzCkzd/k0cB1fBC+6dz18TLJ47YR4Z0p3pNrewFvxXsZ2CnBEyk6AS2FU0
         2jCo7pyHa67tn1FcbKnhv/3ofySLobbw40MXp8/+xdV5/XT3432gSvOOv3k7RQk6/mvV
         1IKoJ5tacGHyXkKWKz2qHeDhzIL3EQrx+DTf1G+5tv+aq0xjwh2+TZVsTfdWynKa0Re3
         chGw==
X-Gm-Message-State: AAQBX9cLoEZNiaVx7SZYsiPSkyAQYVvsPT8OqwvJOh4wxgs/PP8xHmAz
	8vXXvFCmm8J2+JpNOqSEmbTJtHGSZ6rm08i1COUjEw==
X-Google-Smtp-Source: AKy350YHEjnie5+lRjtxBz/zJSLcE4i2hqRV2u+5OLxYyK4AT/Gz1r8izWK4qKq8pbmTVSQjCPJE4C3u7sKBmh52BGI=
X-Received: by 2002:a67:ca8d:0:b0:425:d255:dd38 with SMTP id
 a13-20020a67ca8d000000b00425d255dd38mr1343193vsl.1.1680585111012; Mon, 03 Apr
 2023 22:11:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230403140351.636471867@linuxfoundation.org>
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 4 Apr 2023 10:41:39 +0530
Message-ID: <CA+G9fYu2dBjTD=X5josQwf0om2C1_A-Lerfnb7A9BWD=_drQ4w@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/66] 4.14.312-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Apr 2023 at 19:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.312 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.312-rc1.gz
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
* kernel: 4.14.312-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: f4c3927dd933c23aed0848ae3b5214808b7e6e88
* git describe: v4.14.311-67-gf4c3927dd933
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.311-67-gf4c3927dd933

## Test Regressions (compared to v4.14.311)

## Metric Regressions (compared to v4.14.311)

## Test Fixes (compared to v4.14.311)

## Metric Fixes (compared to v4.14.311)

## Test result summary
total: 63126, pass: 54139, fail: 1959, skip: 6939, xfail: 89

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 106 total, 104 passed, 2 failed
* arm64: 33 total, 31 passed, 2 failed
* i386: 20 total, 19 passed, 1 failed
* mips: 21 total, 21 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 8 total, 7 passed, 1 failed
* s390: 6 total, 5 passed, 1 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 25 total, 24 passed, 1 failed

## Test suites summary
* boot
* fwts
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
