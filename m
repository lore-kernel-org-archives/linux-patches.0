Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D4D1FD5
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 06:44:20 +0000 (UTC)
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-791c27bb91dso495881241.0
        for <patches@lists.linux.dev>; Tue, 27 Jun 2023 23:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687934659; x=1690526659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dUQY/KQMUAHY8497x7ti5aFzbngQAIZSi9WNQAjVh48=;
        b=yyVmvHLpmr19dV52c3XRTdGU37pbBKWxRMH5bUBSDDN+CoLhSngsRDjg/VAA2l4/UQ
         u9XN7yZyqYivBD3bxj/y+enxIeD7m1r21+x4C7u+Hh019MU6FqVSCpbrZwnfl6p1hlyN
         pVwPXBeSOc+JCc/Nr0ZsSZqK6Dpu06Imhadtkf39VoaJ8EYdqto4U6eLG6dg+P5aHE70
         7lswUE4mUJHVt4RcS8tZyUh7L7TlT0QrdArtkAXes3afG9J3ZWwc72Gk4kMg5aOQQ8xq
         AuDaBZr4FLcfu9dY0w6FUycBoLvQNlsgqZngaXP74+cFbFpLBUfJnE1aLcMlXPzW2z/u
         QSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687934659; x=1690526659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dUQY/KQMUAHY8497x7ti5aFzbngQAIZSi9WNQAjVh48=;
        b=deUmFvw2+8RxdJ7ZNUZUUpiKIHla9RYUCMFu1I++cdvuZvOOAwI1B94DG+6zQgNEp6
         M896F3jizwHmaKSESgS8lxjSvMwZThzQXu2H09XOfa0ZPErfwPAZV93Z9GjQg/sI6gSm
         I+zYmO/wsH9pL0xgjsJFAyfxFSvxzcV6LPXp6yEhj7j5/afPGOooBP4uC2VZjOSSuESN
         LQF77rJmPHMviLUQ7RFQmd9pM/pee1OBwBqB28u0KJ/j0is3mX/KTLkBA4ZDaZe8GArh
         PVwx5yu8Gridc3Vh2jNspYXZoZ2nEvUrxvCqznE+sQJVA2icn6WpAxs/WPtJSdBXA+Iq
         miPA==
X-Gm-Message-State: AC+VfDzXFO3onE9Dw9lfCuWJuieEFeJ/q7oAMN1MTvj51beSjRA5CNPa
	BHjxk4ubIJg6azzeodEIGueoDU0ti+yzOBn3XZGP8Q==
X-Google-Smtp-Source: ACHHUZ7QdCQ8B2raBfrqmhG5hbwLg/21LM6OqtC13nev/uKtd/YHGsSa0Vrz5US+v+LkYfjUS5t0MFlOFiqgSIZt6VM=
X-Received: by 2002:a05:6102:ec8:b0:443:8053:f969 with SMTP id
 m8-20020a0561020ec800b004438053f969mr182680vst.17.1687934658947; Tue, 27 Jun
 2023 23:44:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230626180744.453069285@linuxfoundation.org>
In-Reply-To: <20230626180744.453069285@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 28 Jun 2023 12:14:00 +0530
Message-ID: <CA+G9fYttECVM514OrQLxYu0SVhUsiKp46TRu+fJWJ48fGdEA-w@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/81] 5.10.186-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Jun 2023 at 00:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.186 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.186-rc1.gz
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
* kernel: 5.10.186-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: f7aacfe10a2532408aa014a3b046aa1efc426cd6
* git describe: v5.10.185-82-gf7aacfe10a25
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.185-82-gf7aacfe10a25

## Test Regressions (compared to v5.10.185)

## Metric Regressions (compared to v5.10.185)

## Test Fixes (compared to v5.10.185)

## Metric Fixes (compared to v5.10.185)

## Test result summary
total: 108478, pass: 84486, fail: 2704, skip: 21222, xfail: 66

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
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
