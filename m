Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62976A936
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 13:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hbO9elQS"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-4b2c0ba26f1so3207744e0c.0
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 05:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702387280; x=1702992080; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MaQdT2yLxO087BBqctciHEVHxUbwrhtqF6ffwVQnHig=;
        b=hbO9elQSHPjLtUPkGaJR361ak7sMZVSfKoGZqk8pGv4WxDM7451ACTasikNYF0wBvB
         zQjMlU2ugFsXWrDgilRUSMVm9Ktshttja0cSSrltm996rzC4HxpSp2QjGkIuz19nkBXu
         8X91X2EcsQS4750vttCFKM52o6waVK0GWFuLmMD1OUUnerWlPayz9BfTo/jb+6O/zN+P
         4RE0i6475vOJwjSztRkJVRX/f69Tku60ZZq5Ro4jJNo3hCAieInaVz0mpNwfOZ9G80F8
         VZYBXVjlwba9vd10OAssuO8U+9IPIj7iHuRoNGS5ZbTqv9AMeSZkdhM2OZGuHB8EbJPn
         dKYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702387280; x=1702992080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MaQdT2yLxO087BBqctciHEVHxUbwrhtqF6ffwVQnHig=;
        b=Ysn935QsHA8Y4J/ryP82FjHHJvYYqyO4LtbMq4XjuGmBfkXRLSKeTZv/9F59Kk3RfE
         Nyn2uxRGNgsY5dIOJ21Gtshx8TzYGYVqIE5MHOfNKF8WHTwW3XhkuHRjEKuO0mOgVtDo
         SQJMSHHwzrjpUZQ/qaENp6+0fDdEPu6rQkjcBx+kZZRLopbo8KGYJIfUI5ws1ztZ4YU2
         cG0c6+Pa3DHdSQRjbomMwVJc2h+UkSAtCaNOT5xKC9Vih7PORdFJiGV6aL6rA99vRMLG
         GWRvTyNV1dfSxfWPyulhJliAKM2k5yvApsf6t/AmSiMXMuH6+VyliLY/5myHTghp53vV
         7ZmQ==
X-Gm-Message-State: AOJu0YxA4sWm3GQkB6IRaQgRr2kLPKugB3qI8fANwr6BcM6pJ1F2madM
	2ZfBYo5VSVsCOSE1qbzjBNc7ztmaGiKxGfnEWYn6tA==
X-Google-Smtp-Source: AGHT+IEwA/cN9ZvhmumzcgBJXe7RBw5yeCOEZ/8RgMLaMWL2tk/2enFn97aBlzglNvfCpBBGmMLAKI9jX09lTYqWdxE=
X-Received: by 2002:a05:6122:360f:b0:4b2:c573:ed5d with SMTP id
 dt15-20020a056122360f00b004b2c573ed5dmr4659443vkb.15.1702387280095; Tue, 12
 Dec 2023 05:21:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231211182036.606660304@linuxfoundation.org>
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 12 Dec 2023 18:51:08 +0530
Message-ID: <CA+G9fYsa8=JLZUXFKSkCGNPqt+TwzTA-q7+5thugG_o0+s2nUA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/194] 6.1.68-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Dec 2023 at 00:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.68 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.68-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.68-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 807435a379b45e6eec975857b7daf5ac2b3fbf93
* git describe: v6.1.67-195-g807435a379b4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.6=
7-195-g807435a379b4

## Test Regressions (compared to v6.1.66)

## Metric Regressions (compared to v6.1.66)

## Test Fixes (compared to v6.1.66)

## Metric Fixes (compared to v6.1.66)

## Test result summary
total: 136008, pass: 114767, fail: 2850, skip: 18250, xfail: 141

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 150 passed, 1 failed
* arm64: 52 total, 52 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 35 total, 35 passed, 0 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 46 passed, 0 failed

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
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
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
* v4l2-complianciance

--
Linaro LKFT
https://lkft.linaro.org
