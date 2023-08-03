Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0D58BE5
	for <patches@lists.linux.dev>; Thu,  3 Aug 2023 07:32:51 +0000 (UTC)
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-4478ea3ac05so269560137.2
        for <patches@lists.linux.dev>; Thu, 03 Aug 2023 00:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691047970; x=1691652770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Snirl9fPtOln6kCaE4DKmHG/K4Dw3/dYS9eCAPAXGkw=;
        b=dK9/veM6MSy2P+8zGBwGAjKy4pEwLiwMXv3x6kdWrVSe0lbWmJV7j6qxXeywF6+uTV
         gIiYAtXD1t8DP0pAT7QZRC96SPF3IPPCfMngauQtwyP5Nfy4r6kXJSl5dHc5nR5dCuqm
         60EFAjXAPOolS8PXvqKymMd8uJxWSzQZIzTio6YFg0VTa6JRdmYJTGrWAXGg8TUDdYo7
         rmZIOOGYa1VFz/hJ4IZ8Tq5M5KFSn21NUjstUErI9zVk1pAlaID1CptbdxI35QoK39P4
         iJKZj1/UwinptQ3z8xjuhDkf1mH4bfXTvn0oGsUxOEE4T+gQA7pvBIQo+3sw1YhTUYOf
         xAhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691047970; x=1691652770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Snirl9fPtOln6kCaE4DKmHG/K4Dw3/dYS9eCAPAXGkw=;
        b=Vl63AzJDH1tQ0qLdJNbLUYtztupcmBxVQ3nlJUn69kwiKFha85yCWF160TYiv4C40j
         4S+/RdGUwfXq+xmCauq5uNKx+JUMGNOEE0UJh/PiXZC54z0ihk0qhKKkyZOMXYd1s++T
         ITLPyaIrLokCRgJwV7xDW15dmaYknr+JMVEmMjnIodGrXVkW3umgjSbgqHm/G5SgJZSv
         /NN6Id4MiPK0hNQITuCwzPODHrYRgz/c2hI3NwiXHudXO9FrjHQgXmrWoMOkGmTFOabn
         O0oGpXTQDoGwPufIQiUJQ0uaDl0fAckbiIYIJsj9KnWe2Hv+pdXaot/0VDNNjAynbN32
         a1aQ==
X-Gm-Message-State: ABy/qLa+y21sHgbPT6YCnwf/I90hiMMkphhUSp9dRtSZcBdIAHdCjCWT
	X+lGpT+SJcNFTafXau16UqP8tvIOahCRZQIDjnl0bg==
X-Google-Smtp-Source: APBJJlEcMuRbk7FVc8mPw9tXNWLVN3U3+vK00tlZEoPuYSdI94FWJlqUF4WLUAPi6DLOYl36BxSctmJTP9f5s1l1jk8=
X-Received: by 2002:a05:6102:3022:b0:447:7dc0:e15 with SMTP id
 v2-20020a056102302200b004477dc00e15mr6460166vsa.28.1691047970090; Thu, 03 Aug
 2023 00:32:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230802065452.161574662@linuxfoundation.org>
In-Reply-To: <20230802065452.161574662@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 3 Aug 2023 13:02:38 +0530
Message-ID: <CA+G9fYs0c_mac8LL1Va_RoGY8MfkipJoiTiWN2UVTthgFxXusw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/153] 5.15.124-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Aug 2023 at 13:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.124 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Aug 2023 06:54:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.124-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.124-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: b261bd72eeda8af76b98809780cd6f182ec444bc
* git describe: v5.15.123-154-gb261bd72eeda
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.123-154-gb261bd72eeda

## Test Regressions (compared to v5.15.123)

## Metric Regressions (compared to v5.15.123)

## Test Fixes (compared to v5.15.123)

## Metric Fixes (compared to v5.15.123)

## Test result summary
total: 121249, pass: 98277, fail: 3017, skip: 19841, xfail: 114

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 114 total, 113 passed, 1 failed
* arm64: 42 total, 40 passed, 2 failed
* i386: 32 total, 30 passed, 2 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 35 total, 33 passed, 2 failed

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
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
