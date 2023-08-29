Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A4314AB7
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 09:15:19 +0000 (UTC)
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-79a2216a2d1so1486949241.2
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 02:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693300518; x=1693905318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9oVldj815Ut7ngJIahEw8Dy/CL62RBMwOww69T9Fog=;
        b=LwQO1rVW6mSY5LKRX0WTQo8qH+2AuPzk4AJuScgQipObCKJ2mzd9POvZdZ/6NjKhhK
         C3nuVd0PID6hIbmzLfo7eIBIvEC3k1hRu5g0rEO4ahDp7TczymNvEWp5B8XRZoQE9AvR
         E6cJmAtlSvVUtTM3+FttB2wGJNbIhEQGZJS8O7iBQGHP1AxFJnhLyXiaW+w/C25EW+KE
         MYRwCzeN0Kwmfib/Dw4SNX1bucasCNHpsKXfBMLwFvzupx/cmWDIqSKPPiEFg3DaHgyj
         RWS5cT6yNsS3vaoHZ5w8a1As1XCzWMNntr7d78Qg0seGAhvMHaygqVxLXe+7G6JsD35E
         H6nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693300518; x=1693905318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9oVldj815Ut7ngJIahEw8Dy/CL62RBMwOww69T9Fog=;
        b=Nr9xjjwmptElT4ja0KALQPyu3/vtRnqIiqnLkNVa7LC73CVrHSY9jeZkw/3J+d9rpV
         f7YT84gZud6uL0grqinJzDP2g3XBwtZKrYxFVeidnyxW0ZeA+FeQpbtK+zJMJN+w09N6
         NLR/mGfN69Gekf5GyJYe8CTKa6AfhSaw46X9S+dhX/9VMC8K1I1eGnmk/KbBqhPsyKeZ
         SN9XUztQQEtZVNLCbbBM7U7E6PgrQaD0vneLQ0TAiOXuvKX4kROi1/eiMJXXxGdR+Cxi
         FKaaq4MpQNLdXyED+Q8CT11xA7xqLzIgkkmP0/gFcBM9mZXaKw/kqkfqs8CASWk9VhE3
         nHcA==
X-Gm-Message-State: AOJu0YzcFZqYUgGxCF4DukdtVO7gnOqXjzC3ul+51osr2iBcWbDlNbHC
	tWFyWLy8BrU6/HIR/nwBY+rvqxJfm/s87e7MPAkmBg==
X-Google-Smtp-Source: AGHT+IHjKhA99GhlJtmfy5ugI3Ii410+aMG4lV1T5+EgQIxL+yuMRDp2Q8kcSjUqaJIp3bAI1Y9RBlOQWZESTC6kWWo=
X-Received: by 2002:a05:6102:300f:b0:44d:5105:b146 with SMTP id
 s15-20020a056102300f00b0044d5105b146mr19752812vsa.23.1693300518145; Tue, 29
 Aug 2023 02:15:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230828101149.146126827@linuxfoundation.org>
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 29 Aug 2023 14:45:06 +0530
Message-ID: <CA+G9fYv0QKSFgY3zi3fLOaPBf+z9+1_LpMWYZUYLH3qkbeSV2g@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/84] 5.10.193-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Aug 2023 at 16:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.193 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.193-rc1.gz
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
* kernel: 5.10.193-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: c40f751018f92a4de17117a9018b24e538e55b50
* git describe: v5.10.192-85-gc40f751018f9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.192-85-gc40f751018f9

## Test Regressions (compared to v5.10.192)

## Metric Regressions (compared to v5.10.192)

## Test Fixes (compared to v5.10.192)

## Metric Fixes (compared to v5.10.192)

## Test result summary
total: 83926, pass: 69511, fail: 1254, skip: 13112, xfail: 49

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 116 total, 116 passed, 0 failed
* arm64: 43 total, 43 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 26 total, 25 passed, 1 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

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
* kselftest-vm
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
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
