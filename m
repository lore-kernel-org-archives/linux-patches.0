Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29038C2CD
	for <patches@lists.linux.dev>; Tue, 17 Oct 2023 08:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Cznv5nHs"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-49dd647a477so1877711e0c.3
        for <patches@lists.linux.dev>; Tue, 17 Oct 2023 01:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697530292; x=1698135092; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZwhdmZoboZYxQUEHCjJkidFw0OTKD3D55xEAaroQmr0=;
        b=Cznv5nHsS7w4B6NiMRdRGN/90/bOzaz66TfaFWEehP5pItw5LRMS/EU71YRHMlu4hR
         cKId9lrLYoh2JRDRlmWc7AYOkjtg3pQ+CI0ZVkA7bAdxyQ83vDqnmO6hTE7sIEh0y1Zl
         qQcMQQXkG7jX+VXYIx25/n7aItIaeQkuodp88gTQGxWsrFGfGvOezRKAXFqGq97P8Cxx
         J0BydNvDDomFlaVUP/pDxiL6OMnC3NCnsvzmknJ23aPMq1ZZlSc26qdIdtukOBGFBDZT
         jckOPWQGCzgA/abKfySxXCpws7L5R91/0ZBcjczvusxwcdIbkhl0xLmqFvh6Aum8+3vE
         MTIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697530292; x=1698135092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZwhdmZoboZYxQUEHCjJkidFw0OTKD3D55xEAaroQmr0=;
        b=six3nZXCnU8OuMHw6vDnOw8SBdL3LJ5cUhayOIO1fUiUIRpxpT4nVMjWtJFok6aNFP
         e7hOR0kk8RzdeVjB7RZ3XFTa4tMivJagtfhPPq0RgRPza0mEXJ29qyeB0b4N9wQwje+O
         WNz42jWfzVbEqll9zQ/62vqRUHlCkQqJCcAiXUXBrBlTR/i/JewYDN5Rapxj4s/Sqjzw
         CAQy30EbMJJnUo9NXdymkwcGKk9I+H1UhIQ3wr0wJGIztXx9nJdpmoczk873tkwoGqBg
         yLRdb9mKeH8CwbaPkL2DpH3HrKdmZcSLPKGLCmMFvDqiAycXQREWJ5SAwYJJzxwGs69J
         IAnQ==
X-Gm-Message-State: AOJu0Yz56robeGgaEcA7Urn9Wp9NzmLPDjbnfSVYN/65L0rpZNonFijV
	ItFxy8t7p5QTxQpX0sP+sZ294aPqJVtgxiF5PsShRw==
X-Google-Smtp-Source: AGHT+IHlZI6sNT/XNOy/gozixslsRF2nf0psq0DGT67oLm3hUpt2MiGFiteCDAooonykWLkljGmHedBnKhRzYqUEkJ0=
X-Received: by 2002:a1f:2f16:0:b0:499:e671:1682 with SMTP id
 v22-20020a1f2f16000000b00499e6711682mr1594511vkv.3.1697530291961; Tue, 17 Oct
 2023 01:11:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231016185002.371937173@linuxfoundation.org>
In-Reply-To: <20231016185002.371937173@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 17 Oct 2023 13:41:20 +0530
Message-ID: <CA+G9fYuE6rLYQC6ngBVa7kBzAQbEZCG6mWh3s6Wu+Kbhycpzpw@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/190] 6.5.8-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Oct 2023 at 01:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.5.8 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Oct 2023 18:48:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.5.8-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.5.8-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.5.y
* git commit: be4ec73708011c2c14720bfd9c94504d997827f1
* git describe: v6.5.7-191-gbe4ec7370801
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.7=
-191-gbe4ec7370801

## Test Regressions (compared to v6.5.7)

## Metric Regressions (compared to v6.5.7)

## Test Fixes (compared to v6.5.7)

## Metric Fixes (compared to v6.5.7)

## Test result summary
total: 138434, pass: 118450, fail: 2031, skip: 17760, xfail: 193

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 144 total, 144 passed, 0 failed
* arm64: 52 total, 51 passed, 1 failed
* i386: 41 total, 41 passed, 0 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 26 total, 25 passed, 1 failed
* s390: 16 total, 13 passed, 3 failed
* sh: 14 total, 12 passed, 2 failed
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
