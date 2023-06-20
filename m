Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D9C111B7
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 14:38:00 +0000 (UTC)
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-78caeb69125so1825281241.3
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 07:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687271879; x=1689863879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zeVKuOD8riirgkkw4F481jqivXNQqLKmO0QQxZbQzT0=;
        b=UNwKc4cUy0zIyrKqFdCHX8RQcFKgzZ13F4LQkmEqvKQwXBjl9goykAXQMbKwHW1qzH
         hqLE3NV5qjm2pGwjIN9xm2eo2gsbmkNQTZ9sB/iPxZERoeXBj2a8NQuBqFO3RsjEnRjO
         v4VeRuz+aJNrZuQXKvwd8d/IiGDFp3+0jg2gDqW9Qlc1m+OB2q0qHMTAfBslr3yp65pq
         SMHD7TPwXwWny+U0mzmzlgZ+x27Z3Z13rJJOCRLllslJh+stV+BfdLyA0VjLv+iWf31u
         LlQhP4HF8Zg1zMmYzCUjBmyg3aUK1o5Fb+TDM+LCWQwEZHzaVLoDJI1kQ8KXQB7RObNL
         6fNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687271879; x=1689863879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zeVKuOD8riirgkkw4F481jqivXNQqLKmO0QQxZbQzT0=;
        b=UfTXED6RZmusXomGYmO+HRBvypYQtefrsi7jTqGoyf8iKLo5M0QioBHbn9N+FWzoj9
         qAy2nWCeKY1oycFlctKXQ+Jleq74aR8KRXUK5s+nMc83ea4EfXjiqEue893YNaxM1ZN4
         q65dNCFpVMjXJQQHa90iLvKKgat4G0urg6V5oeDNLgFTwfvyzeSeJcMNF6Ah4+9SItiC
         6qu+Y3cFL8ho3bN9BF1DGnWGCk0ZAw8sWi4cf9xAcPNtHE3YQiw20sSz/M/vC8iR6WSW
         jAGLmVCjrHIS/354Fq0Fe6mOAorcQXQapq+qon2k6Sn9D21MzPmPLWt6yB0fyX8OelUo
         EvzA==
X-Gm-Message-State: AC+VfDwTkMKTD+jxGthZqJM62swY/zHMZBl22lJ0sfNHq9haVpd12igY
	1ndq1PwxtiKfo0UnQshHK6K8bGjcUeGS+quwR90QAg==
X-Google-Smtp-Source: ACHHUZ7RFXpTS5p1L+ST32R42JdXIY8hHN1iYjBi8VbdeptXjtm1CMreCHk0gWIqWQoHqVoaUQFgrMYlw3EbsXKjNP4=
X-Received: by 2002:a67:f657:0:b0:43d:c3d8:b09c with SMTP id
 u23-20020a67f657000000b0043dc3d8b09cmr4772862vso.13.1687271878839; Tue, 20
 Jun 2023 07:37:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230619102138.279161276@linuxfoundation.org>
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 20 Jun 2023 20:07:47 +0530
Message-ID: <CA+G9fYv8ix7V-veOQtwyhz=FhCiL2X5PzC86SHd=JsR18NML1g@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/89] 5.10.185-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Jun 2023 at 16:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.185 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.185-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.185-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 8ce687c6d277beb9d0c0c1109a3336ae63976ee2
* git describe: v5.10.184-90-g8ce687c6d277
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.184-90-g8ce687c6d277

## Test Regressions (compared to v5.10.183)

## Metric Regressions (compared to v5.10.183)

## Test Fixes (compared to v5.10.183)

## Metric Fixes (compared to v5.10.183)

## Test result summary
total: 134576, pass: 109283, fail: 3977, skip: 21211, xfail: 105

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 116 passed, 1 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 35 total, 33 passed, 2 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 26 total, 25 passed, 1 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 36 passed, 2 failed

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
