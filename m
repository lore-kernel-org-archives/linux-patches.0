Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5ED1774C
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 08:18:32 +0000 (UTC)
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-79df12ff0f0so1773266241.3
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 01:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694506711; x=1695111511; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wWXNYBL9b31oc1SggDkz4tlCDlhgG4dwgemXcdjOh2U=;
        b=s7HeN+GlXIpgXysRjyRuQnlTX5jkOOrjLUjgkGhkJkLF+ucfoorFYlh3myEYXzq93H
         rc6zuKWQZ+fqUTeU9tIzhb687DAwe7j7kSNj/5s+/44pdT4tG4J/pO3ORDKmKJs2dlDQ
         EhEWzkLjHEpuWBfJUOfY3W+g3SoAWj3Hk9S9RTgwaCmCh5gGYvOigpPwjCOMt37XFRbq
         GJJWBu38oEt/hz1JNgKoogJQcrwqOzdl6dOTaMJMw32+Ghf7WraSmdnPMdeMg3r5aqjC
         jIw1F3aDQJBvvoAY8AqnbPGgoNPyuYwO945oqyrxVjly7ubAwN5YQpYied1zmBgs4G67
         kAng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694506711; x=1695111511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wWXNYBL9b31oc1SggDkz4tlCDlhgG4dwgemXcdjOh2U=;
        b=F2u/7HXnT1K4GorXg8DS6BQKVic5QsM+XXkarA2deaDXnMHbDHwk3sQpfOlh7fYP9D
         AWEwyWmbwg4seZ+3UEX3qAAIbAbo15vE1CVfn6zCtY9I1GzRJ06MFhAiwEAe7d1CzeGQ
         tpdmoqa/+79Bs7afrgrTCJ9kmWTLl6DcIoWqO64AOBOksxXc4zwq99ZVWq1bVc9i/nle
         Wb7v+6BDHsLYNKo7khml0fnrMtaoDTE1sAxsm5ODDYwUxFdXsOUPtRlmxCD2MMsZZ4M8
         I9RLy92ime5RZCk0BRGya4XTQLeRNl/USZzjPZq9t2+nENMxwSJ1dwfYPPu2pbpsT+co
         DZfw==
X-Gm-Message-State: AOJu0YwdZdY000xdrM5/R7hUF1PV9BZijkRRhtMUan9xESkD53tHK/G+
	KboPiZKiMtET+Ov+Keb155ycOciwbe/jgVfKkfLijA==
X-Google-Smtp-Source: AGHT+IEX6pcSZJvQvRgvyqsKyvnSAqViInvTbBSBqP12HNwDgj/I0laXg08nOh5hiOvEHo0S3ie9kKEYxcLpVH+QExQ=
X-Received: by 2002:a05:6102:3166:b0:44e:a2ee:8408 with SMTP id
 l6-20020a056102316600b0044ea2ee8408mr10634044vsm.23.1694506710926; Tue, 12
 Sep 2023 01:18:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911134650.286315610@linuxfoundation.org>
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 12 Sep 2023 13:48:19 +0530
Message-ID: <CA+G9fYvLsuHn2ckfwJRwFU5ZzYq4W_JgeC7LZvMYiQML5ygh+A@mail.gmail.com>
Subject: Re: [PATCH 6.4 000/737] 6.4.16-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Sept 2023 at 19:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.4.16 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.4.16-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.4.16-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.4.y
* git commit: c383978584827c8fe5480bc6c182183dba0e4b92
* git describe: v6.4.15-738-gc38397858482
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.4.y/build/v6.4.1=
5-738-gc38397858482

## Test Regressions (compared to v6.4.15)

## Metric Regressions (compared to v6.4.15)

## Test Fixes (compared to v6.4.15)

## Metric Fixes (compared to v6.4.15)

## Test result summary
total: 145516, pass: 125575, fail: 1989, skip: 17770, xfail: 182

## Build Summary
* arc: 4 total, 4 passed, 0 failed
* arm: 140 total, 138 passed, 2 failed
* arm64: 51 total, 48 passed, 3 failed
* i386: 42 total, 40 passed, 2 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 37 total, 35 passed, 2 failed
* riscv: 25 total, 22 passed, 3 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 46 total, 42 passed, 4 failed

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

--
Linaro LKFT
https://lkft.linaro.org
