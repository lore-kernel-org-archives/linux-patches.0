Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317FD171D6
	for <patches@lists.linux.dev>; Wed,  8 Nov 2023 12:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tDRujrMz"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-7bb4b7eb808so1027001241.3
        for <patches@lists.linux.dev>; Wed, 08 Nov 2023 04:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699445926; x=1700050726; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gtleK5+B+iSrGADJfvBkG6jHsi6KD2PrLC0HlWzUmbI=;
        b=tDRujrMzt9RlllDFWz4fwBNMn+ZpAl5qXobghcXPqj9Lvl90fB4zCoCe3ZEmUbDL2W
         2NlFNyXqsfzLKD62tF+0yoHS+FPrLXnryeGN1I7L18kP+vKd+SH+CC/txIyb4sW8QxEt
         w6x4fkc/7IxCBk38NZFgxEexH7W4bReE+anSYdep1UUDHImeuAQScni2NvujXeIOPfQN
         FlVZ5BxAtSNrlZ0PfobzorHu7ZzVaQUaA3OKfJ8oLetCeKHUFOzRYaf5F7lA0LTfj33U
         UkH25uqx6+pgpsg4x+LMhRw6n9sf5izpw4S9FBNcoI5XbTFufeHKkJ83SrE9K2WG57Qz
         bIyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699445926; x=1700050726;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gtleK5+B+iSrGADJfvBkG6jHsi6KD2PrLC0HlWzUmbI=;
        b=SLXXWE4EbqHu1TcAWiqPDjqIDyvkHqVGbYzQc6y/3Tziw/uTW0TVSSQ3ksmUwB7of8
         bFeRzVZ7FF7GRxmbvuBcI8tec3KSnJcTbAzq7rcXzFUIy77yn+Wsa8n8Dkt6WqPkGqVL
         ZNTpxzTt5m7mmfZMp4iG+NodNb6S5z6I/r/uXiNd0YObIC5aEmMiguTx5BB6CyqK4l8b
         DTCSvlHveeICuB1dy59mk+uoarg7t5K7l7H2dZVi+/qbEstpvce+l3EpJNTd25/NJ/dR
         boS2zFN+NXbuH4NPI8Nxxx1kVGfULSvoUbNdAd3FGbSCKSrLhLp8C4Y5MfqG63AA89Ue
         pVyQ==
X-Gm-Message-State: AOJu0YwvkeUhCpgZnPR85XG5k2Lkvm2lydxccIGE5OqWJfOxn1kDXlae
	QsC6B7G5fISypKkLQOzqnhtWvzwIVQd+51JAOHI1gA==
X-Google-Smtp-Source: AGHT+IHqU66uAC3lXdc4sKllRsYweIpdsltZ/i8A/zB8EvIJhiRjXgx+94NX2hrKqiHu8SVCcxUAv+Ep/J0zfypORRM=
X-Received: by 2002:a67:c182:0:b0:45d:92e7:76d9 with SMTP id
 h2-20020a67c182000000b0045d92e776d9mr1361581vsj.21.1699445925844; Wed, 08 Nov
 2023 04:18:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231107202324.434534294@linuxfoundation.org>
In-Reply-To: <20231107202324.434534294@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 8 Nov 2023 17:48:34 +0530
Message-ID: <CA+G9fYuOvAtZwtvyaUCA4P-pzdjop0=XqL13-f-ibSM_Eu3S+Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/125] 5.15.138-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Nov 2023 at 01:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.138 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Nov 2023 20:22:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.138-rc2.gz
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
* kernel: 5.15.138-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: f3efa02c9542a1de453a56c6ad9913f699a45737
* git describe: v5.15.137-126-gf3efa02c9542
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.137-126-gf3efa02c9542

## Test Regressions (compared to v5.15.137)

## Metric Regressions (compared to v5.15.137)

## Test Fixes (compared to v5.15.137)

## Metric Fixes (compared to v5.15.137)

## Test result summary
total: 93104, pass: 73581, fail: 2547, skip: 16923, xfail: 53

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 117 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 34 total, 34 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 26 total, 26 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 11 total, 11 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
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
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
