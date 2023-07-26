Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFFAE57F
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 16:11:34 +0000 (UTC)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5217ad95029so9201053a12.2
        for <patches@lists.linux.dev>; Wed, 26 Jul 2023 09:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690387892; x=1690992692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BIZpsuSzukMrHPU5mVuhvu2412Eqf+WFtCO0MhRK8wM=;
        b=woA8Osj4Rj0G5hvJp1zIfHphT+i/IrOYk6m8budbGssa+F3akwM2R/qlXnNMssFF+z
         5JvrgFtcSFHS+NE1iuZ3C5loEyOC17ryOi5GN/duNOGFs2jlsKv7Rk30NfjVqz3Pzp/N
         ZuMKZhjQpRpBDSl4Q8aMSR7lYgAO6mZK+0Pjd5xnpHYgNHcuMJBFgc93RtnNBATBTIZK
         7F2ZS6UQqe7nFrD+59SBtjLjGV3VMKRGw0hdVqjGRS+5KO5cmBNu9mTiA+8e+U8OvOm5
         Isrj6MV9WQC9FzhpRUOPsIRW3Boxyq9VY/QXFoL0vTIpgYYFCkJt+qDB6nmPjzt7ifR8
         xFdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690387892; x=1690992692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BIZpsuSzukMrHPU5mVuhvu2412Eqf+WFtCO0MhRK8wM=;
        b=TuYs57xnTg1hhWhjIesJxb75AjtezOtwva8HfUTuw1E2YSwwxXKvp8MBWhQwHzz8Pr
         rrjeZjTO6T+QOgGlBMfpHMV3VkHavFYV6m+eYKzxrPlKPvENJXo8TLiL3x6x7PtDqEOI
         +APsgn1aOQuJkFL6NC6xyZpUKII8WmGebb+lYeDBPLX1JJpmgR4WZM6zwyFgHH/oG0hW
         wutfoLyuOG3zYsJaLiE5o+U9F8yVzALCKaeM0NH5N4Az5U+dncmx+aIvhn+tuoCYGM4t
         99wY5kJ0oiV7vAptfL+IJozwrt9hRLrVucvhHmKAKCYKuMl9VeRNMkrg7nPf3JMnxqJt
         t6og==
X-Gm-Message-State: ABy/qLYHN5q0xCXPruTz/1ZecLCvIdvncxXF78Wm1TC3qCxsJaI5WhBv
	a7hXJt8FTmsct50xwq0XOtlQf9nTVUWt4S8auOLVWA==
X-Google-Smtp-Source: APBJJlHMpGM/zFDyqbbT8McAfUw0nFgiABRB3AE7Ic02+3FUH3QudH2VVZePLTOMLoAaZRX4VWtWwnRHuw3wudAVHMs=
X-Received: by 2002:a05:6402:744:b0:522:5873:d4aa with SMTP id
 p4-20020a056402074400b005225873d4aamr1994638edy.23.1690387892488; Wed, 26 Jul
 2023 09:11:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230726045328.327600022@linuxfoundation.org>
In-Reply-To: <20230726045328.327600022@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 26 Jul 2023 21:41:20 +0530
Message-ID: <CA+G9fYsqwsjZMwDmgPGg8kmKAPy6n-aidHA5MRh87F2mjg+Y8w@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/508] 5.10.188-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Jul 2023 at 10:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.188 release.
> There are 508 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 28 Jul 2023 04:52:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.188-rc2.gz
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
* kernel: 5.10.188-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 76be481217944567fbdcc92f135a187cc3de8158
* git describe: v5.10.187-509-g76be48121794
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.187-509-g76be48121794

## Test Regressions (compared to v5.10.186)

## Metric Regressions (compared to v5.10.186)

## Test Fixes (compared to v5.10.186)

## Metric Fixes (compared to v5.10.186)

## Test result summary
total: 94215, pass: 75452, fail: 1602, skip: 17096, xfail: 65

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 114 total, 113 passed, 1 failed
* arm64: 42 total, 40 passed, 2 failed
* i386: 32 total, 30 passed, 2 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 23 total, 23 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
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
* kselftest-lib
* kselftest-membarrier
* kselftest-memfd
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
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timens
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
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

--
Linaro LKFT
https://lkft.linaro.org
