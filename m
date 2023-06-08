Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02438F4E
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 14:05:40 +0000 (UTC)
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6b29f53137cso437121a34.0
        for <patches@lists.linux.dev>; Thu, 08 Jun 2023 07:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686233140; x=1688825140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=safYf9mtP/TqCKpDii2aud/ldnVoerr/RL86C5Y3JdA=;
        b=yeoSvKknohEapCfJtL5b/uPDo3O36xSSP2UiE2gr6fJmVfRaHgAh09q9GaP3Gt9i9O
         8l8Y6DRFuvkUi7j+dD3r5qVSIbc2q0/C2DEKzM810+BSkueV+RQ656VTwjBTN3yLABcN
         uMIMjTLU63yF1wON1fhy3ZzAI1kjnrSEAqMoYZ7Z71sB7sbQ3rY+uN9mu3C+uVzzgxT+
         suwNL53FZUCT4F5k8zLyU0NosM3HeMkkj/CBtgoe63biDtDJ1m1MZbLOndgp9c1FAOds
         aUDCIvLS7NAPtwy1VOorPTy0hDImZk3+IGtHRJqsaM3JEu1IC590xC1Fi/lh36NB66Jq
         RXIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686233140; x=1688825140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=safYf9mtP/TqCKpDii2aud/ldnVoerr/RL86C5Y3JdA=;
        b=Z7kpdjnD1BzEiukLECQp2uwxYdvMCh0S1DCxMLrqUAD6nMsZXEe5n6EOWlUfEVv8Bn
         pLanloeLOJrc+9hsMLTQpKIPnSyjaZgD2tSXz6oWJhxTGRI54rFnyH7k70OeWMbmts2L
         mRXy87g1jYlyCXHMK4p8OkzcWRBVN/ibIJ9sMRd9JdVE3rDOa6EE0SeHXqjuyDAxtgWp
         4Pztxiaq9jgAYff7G9TpVjMixfXurlRIg4AHjT9V0aiGRGZaX1utog/rAw15goV3ZImX
         nHbPQvH5HtL2/pNSaYEwWyXkxu/+3JgiEmv+eaGDp7vllnZM9vWI76lYrmS/V/Ob+4LG
         FUVA==
X-Gm-Message-State: AC+VfDxgFSp10u6tl9DcHr4wHnaFbpu6TOX2/E0JhgB+kaxrtKYbButm
	Yymg/3KzlkHpUTOkOOEByJo0sMNg9ZIdXc9m7VwapQ==
X-Google-Smtp-Source: ACHHUZ7KqxK0en144Hhhsj8yZ0vGveaeyuTpvLD0jU/cAdPLf+priNbDb4qTL52S86AU3Rt7dkR58oNUP0V5p14gzIY=
X-Received: by 2002:a05:6830:1e6d:b0:68d:6a1e:46b9 with SMTP id
 m13-20020a0568301e6d00b0068d6a1e46b9mr6119381otr.26.1686233139634; Thu, 08
 Jun 2023 07:05:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230607200903.652580797@linuxfoundation.org>
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 8 Jun 2023 19:35:28 +0530
Message-ID: <CA+G9fYtqtXhZ2CM56xP3C8iDz6CjvcsdP8SvJhtD=hkAt7VoBQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/159] 5.15.116-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Jun 2023 at 02:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.116 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.116-rc1.gz
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
* kernel: 5.15.116-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 00621f2608ac31643168c86e902c21a017ffe3b1
* git describe: v5.15.114-196-g00621f2608ac
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.114-196-g00621f2608ac

## Test Regressions (compared to v5.15.114)

## Metric Regressions (compared to v5.15.114)

## Test Fixes (compared to v5.15.114)

## Metric Fixes (compared to v5.15.114)

## Test result summary
total: 108256, pass: 91348, fail: 3032, skip: 13715, xfail: 161

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
