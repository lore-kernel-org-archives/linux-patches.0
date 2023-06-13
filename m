Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F631C2B
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 08:31:56 +0000 (UTC)
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-43b2fb0afa6so312648137.1
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 01:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686645115; x=1689237115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M4iXIQmlE7K/ZL7WODqTijarurUNDUtMrl1zC33XtUM=;
        b=W7tOwFeb7OKaxnCiWPufvGERu1UH+ZrF1DmyUa800pGdoqQl/VPPjOXX1qwejlfKor
         YeLpeMhOhLpm+EJmFC7BGEmPAU7W/b9pY505g6yYrzSINKGosNEnDQbDVBSOk9kPP1U7
         P/LJK0huLvgULwj46FxudgkbrwqoveABcSttSUwFagxY0ty7MGC07uI8BAC2MedDUUsZ
         YhGqhz1NzVAb/vX/TYb76hWGX+5fu9GKM8InGQOrPLdA75AmJD5C2mAAvgmol1fZB2Df
         jq9ihOt2MbZ8JbLyYTW6HDTxpN1xwsks98n2Z/8vJtnzNx1CXpmGhzqhHTTyTmbQ8z58
         gxrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686645115; x=1689237115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M4iXIQmlE7K/ZL7WODqTijarurUNDUtMrl1zC33XtUM=;
        b=aXFCmOIQsL+yr4Q9GhQ8t8Lj1/EsJ5swENUByC8JsGi7Cxjgm9DND6IxBDcmYX1fbH
         eAK81ngqqBb1yHNiUFDjYnai8Mn1Gb7okxBX8sG7pgKCmTJOD6C5yd+fSiaYdTtQuIJ0
         Fs2GNJA26H91RCXk9NNihdGHO6/WW4iiRL0jezQNXNZzbNFOZaD15WEXzfCVeoE3NbjX
         ZaAQLj5TATZND6mL9uir8G7kfTl1//ST9ftaLFWHxDHE2jiB6RcwdQMREXqrMhuFhVFj
         S+oz+oeeA9NgPtk2hUpidqpirc9BZCUkLUc2SD+FZ30185P1udCmqsOssSuAUL5vtY2p
         H+Ew==
X-Gm-Message-State: AC+VfDy9tIW13F+BnJMxatb1W+mIaNCXaLt+wGyR5czrGXntE7Vukv8H
	QDjsrnW77ooTm4gbTi3XznXeGM4TjLy39AsBjvc9dA==
X-Google-Smtp-Source: ACHHUZ7dAttEj0WX3njveCX71aXDMkbQmyqjLTKbyt12iCSdXtC5npmRe3YLMafc5OUtcg/WusOl5Ln1bid0f4entac=
X-Received: by 2002:a67:ff91:0:b0:43b:3ad8:6886 with SMTP id
 v17-20020a67ff91000000b0043b3ad86886mr5060793vsq.16.1686645114885; Tue, 13
 Jun 2023 01:31:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230612101702.085813286@linuxfoundation.org>
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 Jun 2023 14:01:43 +0530
Message-ID: <CA+G9fYuUF6pc44ETj7q7Mz5Lik93OqLkK_uzx1D_Yu2CGc_V2g@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/91] 5.15.117-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Jun 2023 at 16:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.117 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.117-rc1.gz
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
* kernel: 5.15.117-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 09ab3478acfde2bfd20e35fa2f6d3db44662db69
* git describe: v5.15.116-92-g09ab3478acfd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.116-92-g09ab3478acfd

## Test Regressions (compared to v5.15.116)

## Metric Regressions (compared to v5.15.116)

## Test Fixes (compared to v5.15.116)

## Metric Fixes (compared to v5.15.116)

## Test result summary
total: 131232, pass: 110630, fail: 3682, skip: 16729, xfail: 191

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 116 passed, 1 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 35 total, 32 passed, 3 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 36 passed, 2 failed

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
