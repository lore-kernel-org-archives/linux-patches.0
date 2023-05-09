Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F08B12B9F
	for <patches@lists.linux.dev>; Tue,  9 May 2023 19:24:50 +0000 (UTC)
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-44fa9d3cdf3so2264782e0c.3
        for <patches@lists.linux.dev>; Tue, 09 May 2023 12:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683660289; x=1686252289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8IiXlzVjPWNjMDVf9eo1m4vSOqBrngb4nz7OkCPHkxY=;
        b=zUDlyq4tUf/VjpTweHN21KAob+U1M5Sq3Po9Z3SxX8EeRXergY7FH4n2xo5DsIcCri
         QyN48OUNi+XXeY1P+LY9xonupHliOAHEJNYyASrdIpSIQ+lIX7aD5vozZ+4OdG+t9AKT
         bLGMD1+fTpQzekUASMBhEP2iT1xvk+BwN3tr1fmrXbMCu5tbvK3q2plK+hb45+sGLC2r
         6ouyuHewJjQIerewNZsPBmbwr5P8ieG4gWtpyvfcHuOPsNgF8g6X7JSiRsia3TubWDD0
         I0o9BMpWGl4TdoDIsQvSA6cQJgdCg1YGuQrc6XzW7SfNEikuK88j/uKoMUgmR1TPDQHe
         4zOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683660289; x=1686252289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8IiXlzVjPWNjMDVf9eo1m4vSOqBrngb4nz7OkCPHkxY=;
        b=j4vYVF+vXaxX20UBrgXP+iJXKKbT1h9AlJF18MUzlww5Ii4OeF978B4iHbFyFwEc78
         iQRTKwxpeyJAYWbbyqasa7R5pR0FfaWGhAH59etZFUECNUlUg2py7+SRl4taRy9pf2+8
         HWKOOez1HqV0HjtHLOU+m1jAulJ/rdhddztbfDCDe0xEMPi1lfVe5cNc8Bcxf9uk1E7b
         bRlpp9ezJAXgtZCWHb+7Xc6joR9mUfAHE+mshJ3s+LAb0blrmbqsBkUpiYmKAZ6weq4Z
         LWdZyFqDhG8OMNL82MWGYL/O1kNZlsnni0UPwU/B9dISLmQ6QCh2x/YeywOPQJWejPz/
         CcnQ==
X-Gm-Message-State: AC+VfDwV1QSjz8XEMRNBb3bP8qKWrXcN+NcHTVPBYTjS1TpJyeCm9CJz
	kgTjiWy9NPoHai92Y2Chy4tJd/j5zAzOUeriwZ6dUw==
X-Google-Smtp-Source: ACHHUZ7bdODG2ROfWT3zLbHHFz58vz+kU8t4yb5IbLWLxD+Hy8KsqzjNxV6hF4GR2NfPI1f8ABRpoTbK4Ta7rUEcAF0=
X-Received: by 2002:a1f:ca03:0:b0:440:8a24:e71d with SMTP id
 a3-20020a1fca03000000b004408a24e71dmr3930486vkg.3.1683660289246; Tue, 09 May
 2023 12:24:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230509030705.399628514@linuxfoundation.org>
In-Reply-To: <20230509030705.399628514@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 10 May 2023 00:54:37 +0530
Message-ID: <CA+G9fYuQZDSpqt2JHiyXwbJtnTfdZv2XA811sPJq+6vvwdouVw@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 9 May 2023 at 08:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.3.2 release.
> There are 694 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.3.2-rc2.gz
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
* kernel: 6.3.2-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-6.3.y
* git commit: f1bb4e945e5219450ada73892d323d09f590efca
* git describe: v6.3-rc4-1630-gf1bb4e945e52
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.3.y/build/v6.3-r=
c4-1630-gf1bb4e945e52

## Test Regressions (compared to v6.3-rc4-935-gf45bb34ed520)

## Metric Regressions (compared to v6.3-rc4-935-gf45bb34ed520)

## Test Fixes (compared to v6.3-rc4-935-gf45bb34ed520)

## Metric Fixes (compared to v6.3-rc4-935-gf45bb34ed520)

## Test result summary
total: 278269, pass: 244914, fail: 4454, skip: 28654, xfail: 247

## Build Summary
* arc: 15 total, 15 passed, 0 failed
* arm: 395 total, 392 passed, 3 failed
* arm64: 105 total, 105 passed, 0 failed
* i386: 74 total, 72 passed, 2 failed
* mips: 52 total, 52 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 68 total, 68 passed, 0 failed
* riscv: 44 total, 44 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 84 total, 84 passed, 0 failed

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
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
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
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
