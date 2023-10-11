Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118612106
	for <patches@lists.linux.dev>; Wed, 11 Oct 2023 01:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mA+8OGKO"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-4577c1ae94fso1200397137.1
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 18:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696988627; x=1697593427; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YSiDNY1At9S23ErLXYjIIHPvj55pOXoepaXSEOsk/yk=;
        b=mA+8OGKO13lKjpmXJQlyRdMJ7KSsd+iyNGE562+UA1HWkB9IXvgPKc/1vcAxdFy562
         FGUqf1tjqboertrxywNdLpcmqWz2jVnVsFMPYGVOFqm2Ycj2fZqrkUvFA+BNzRim+Mdc
         6M2erVg3q14A14h+lAq0UnEGAKl4toWhEbTBth+zmKpCJC7WihmsVFQe51NeuUOmrr8S
         l6FYALzo+o/YobtkW4MPMDYEU5vwohgaIgKVa77P1rfmlI7EiTzQECpaJNVPfVkigh+t
         vVkQMgC8DOrXe3kHgDfMr2erg7DAFZehwKFO1pUvsWD+cC3qttIideFvHcTa8tFH3jha
         pcqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696988627; x=1697593427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YSiDNY1At9S23ErLXYjIIHPvj55pOXoepaXSEOsk/yk=;
        b=n1o6mka2aM1PoF4gPjJHHTFQs1hRW3PeneZv7u+NFP2XU8mdfNsSntEZ7FthREMXSB
         vD7W+rJW7cvO23Zx23ijHl8U9TzFvL4c9N/uu4zSpkjLfG9B9ou0Xf2WoZx0dHGvdrPV
         cEX2aZshzrK4y74txSnSO7CSQquWATRj3ZNe8ZEHVdxgU6BfiyUo6vX7PzCHi18fawOH
         +DyqbeFyP0qhKR3MQC1NF/7WpIGAWfbYxgvnVwCNZPfZLASeC2pya7b9o+MdeES3WG0O
         FU8DxurcV0nR0UA7pnxnpArlvSv4npOzmmSOGYe1a0Nvf+TFSHMXuCCURVAvLyEbnczy
         vLAQ==
X-Gm-Message-State: AOJu0YwMZD3Ac0pJZmpbyydG+2TvRryFLXVY0FEZ17UIwtsyUPQTuyY9
	la2ThOFYqsy8vCnRm5JNn13X2z5lHrgbjxgnWoatsqWtOlC5c/Cmkdj12Q==
X-Google-Smtp-Source: AGHT+IGQuqX/VPx/KsIYHsiqXWsHllqMS9gkv4RcG0kqs5xw80WAtRklZow5+p7P/W71aIWwcCnXC7ibfgqfTnGCNNw=
X-Received: by 2002:a05:6102:534:b0:452:b96c:313b with SMTP id
 m20-20020a056102053400b00452b96c313bmr17791514vsa.13.1696988626704; Tue, 10
 Oct 2023 18:43:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009130116.329529591@linuxfoundation.org>
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 11 Oct 2023 07:13:35 +0530
Message-ID: <CA+G9fYu-h0kUGyQG4XTc6J7NZMvUeMSUuiY8KU0giNcPfzuU7A@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/131] 5.4.258-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Oct 2023 at 18:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.258 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.258-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.258-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 9209af362e00e07217be717fc07b25118037adc6
* git describe: v5.4.257-132-g9209af362e00
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
57-132-g9209af362e00

## Test Regressions (compared to v5.4.257)

## Metric Regressions (compared to v5.4.257)

## Test Fixes (compared to v5.4.257)

## Metric Fixes (compared to v5.4.257)

## Test result summary
total: 88941, pass: 70613, fail: 2365, skip: 15914, xfail: 49

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 148 total, 148 passed, 0 failed
* arm64: 47 total, 45 passed, 2 failed
* i386: 30 total, 24 passed, 6 failed
* mips: 30 total, 29 passed, 1 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

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
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
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
