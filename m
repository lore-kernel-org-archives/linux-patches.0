Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B3C1946E
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 09:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Itpv1ylp"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-7c449d30fa3so1272383241.0
        for <patches@lists.linux.dev>; Tue, 28 Nov 2023 01:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701163843; x=1701768643; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RysSL349wtX71+LB9aMToXkLSEollEFV5Ko+eyRvxOc=;
        b=Itpv1ylpmZpoP90yVCiosT0fnVFpjGLipCryLJswBih+JqHmBHtzwj+Ca72G2MliD2
         DjxvoeRkd4PGurqr4Z0I35q9PZHBRzqKoi1oKUsEOy3at7QQiPDKECW8NbDbCrW8Py5Q
         m5hpNbqKtn1NVRvq0rv2xikpNnV/qYOdV0VbtqqLY7DAWxaFOniuzqGxvTDpZ51yJMI3
         le/MbaHyU3m2DdixhO2AOEO5LqZiQ7UzmgIiZDlgxoSTErJRow93AmrktmUl2qmmXxPt
         FTr97dItG1kXfJFSl3Ugt933PYJtnK6Ld/YWP7ONWXIyqSPKSkCoNNfyOaGQZpWo9vKe
         +hPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701163843; x=1701768643;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RysSL349wtX71+LB9aMToXkLSEollEFV5Ko+eyRvxOc=;
        b=UCjeZRJJi+YwG3yCgcpAuzrJrwoFQqveK0n1olSVVKFsMG5FsRYTPAetWiHe+Gqnuo
         Tl2kCfZpQHSTq8fIPu35AM9U8Fsv0705CVU11+tpoY8b2r93TExwswkmigYRVlPyC0Zx
         CbvgoC/ED47N9T4+Nf49UWjk+pU9N6/+UOfpzDOlT8/c0oXDlZ9UZrXvUgjFLoohzOX5
         oGyibeBJEdtMWMOpY8xcwrS7ArNFPcIt40U/Jw+fj50YbnngniohFXkIM5FZNqMYio6B
         zBeFNfX6Ww1VOQQAfoAylmMUgYzwc3v0qBPjQYcS3KJe5pLuxmV1BckoGE0ZPf/LdFZL
         wM2A==
X-Gm-Message-State: AOJu0YwFxVJjcJ/gdliyAy/8WiwiJJvloT6TezJ+TH/xLcAw9b9KfTMH
	NGuDMA71Y1Iwx2kpFOURQWWIMtjt+UobbQdEWzTZNA==
X-Google-Smtp-Source: AGHT+IHkuIAtRcV8IkdzBUFavg/7wgDk43HoJLjLYNj3a9prWCPjkVLZE61la+uUUIFD1opUnJvdm9gXU5uNADwJ8ss=
X-Received: by 2002:a05:6102:54ac:b0:45f:3b30:9c9a with SMTP id
 bk44-20020a05610254ac00b0045f3b309c9amr15983484vsb.27.1701163842635; Tue, 28
 Nov 2023 01:30:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231126154335.643804657@linuxfoundation.org>
In-Reply-To: <20231126154335.643804657@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 28 Nov 2023 15:00:31 +0530
Message-ID: <CA+G9fYvmF=PVjePVE7m9-ZGW7EfKCv-9iwe-uwqdNqwVHGmNYA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/187] 5.10.202-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	Marc Zyngier <maz@kernel.org>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 26 Nov 2023 at 21:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.202 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.202-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
As others reported on gpio warning while booting arm and arm64 noticed.

[    0.466552] gpio gpiochip0: (1000000.pinctrl): not an immutable
chip, please consider fixing it!
[    4.741930] gpio gpiochip2: (200f000.spmi:pmic@0:gpios@c000): not
an immutable chip, please consider fixing it!

Links,
 - https://lkft.validation.linaro.org/scheduler/job/7060124#L2577

## Build
* kernel: 5.10.202-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 80dc4301c91e15c9c3cf12b393d70e0952bcd9ee
* git describe: v5.10.201-188-g80dc4301c91e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.201-188-g80dc4301c91e

## Test Regressions (compared to v5.10.201)

## Metric Regressions (compared to v5.10.201)

## Test Fixes (compared to v5.10.201)

## Metric Fixes (compared to v5.10.201)

## Test result summary
total: 88957, pass: 67831, fail: 3474, skip: 17604, xfail: 48

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 117 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 25 total, 25 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
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
* kselftest-sigaltstack
* kselftest-size
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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
