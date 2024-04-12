Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EDD1482FA
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 15:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712934873; cv=none; b=LBXros1nw/cRBJE+lekO6YJogM/cWucT/8dr+ZPjSEK7KbM7KWA9qSlBAb8ufPdvx4Ho7pSDWfeFxpHhU8HQomFLIf7n2Atp7GfiQH/P71WYRvWqa0JWruGsDQCAzRx1FJiwRIHmzGjeZU4n+BGWZDcGBdNImI/z2qgaqC03KFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712934873; c=relaxed/simple;
	bh=brEje0cHPh78nWmZ49OAC1Q54MURkbmR/oXropLUQlI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lRACKhtTzAfFu3IEAQgV+laW487D/tIlAL7o/hWhap0TfqUx85TwLHenLYkHRYWr/hUYF9e7H4ehS+VrJiW/scxs0KzqnqgO71C0T2IY24XyasjZd2fzRvHRLde9Z44FlKso0kG28G/sNgrtw9Zfle8oIbYkr9/a/3ngayeZK6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JjEDauXt; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JjEDauXt"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-617ddc988f5so11484467b3.2
        for <patches@lists.linux.dev>; Fri, 12 Apr 2024 08:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712934871; x=1713539671; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VLvO4O9yjxcuvv/qAn2Shyb8mUKKY44bwVC7r1AMAcM=;
        b=JjEDauXtjX4Drw2+r2PkvG+ZXTcQAmE5O0myhJ5by9hagvEz2tz/zqlNdwXjXQrc92
         gYZmgUVnRMFrBz4IZ5vNF16MaAhh8N9k3YBvGYoBPF3el+pBXiIMF8tQl09HWfwEqw/7
         QaAtbXZ/PxKcpFTb4T+sobGVGaFvZh+xwAopQq1TIR2NyY+ppqbxGGrbBtvWi4eZEXs5
         bBXm4JXIMZrzKfGePeDq80Lw2AQ9Ep1YCxBRnGDK1q4DZI33E9O+h317ZPHAqbpdpR80
         9QNiHAvkWRRkvEwl8RMBbsDqPPINN3YvU3o4vhvc2h3zrL+/gCl+jBasShm4Ylae36/3
         tezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712934871; x=1713539671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VLvO4O9yjxcuvv/qAn2Shyb8mUKKY44bwVC7r1AMAcM=;
        b=Jz276vi4EQIMBMUBXrtagI2HRbFfQthAEuO6BNirC+47siT3FoloVoZcCssc2xwPYP
         2Wrqb28qDetCrMiMLQgrVq5SgsU/N+bHDQA5SDKGJ+8RM6N8jyiU0R2+S/Pvv/Plnur/
         OiSC+qeLTHLGaiBcEoE/hFFHdwRHtGaTVqzVF9G3v18penmrm6LADxuttkbd87hoiKRj
         fdtTY+fTNlZf37eEymv9HumIlSw7fENL0/3w9Q1Yba7N977gx8Zevb8qw5tzCCYW7IJv
         jX+y5/8L1vRjn3VEaZCd5Bt/i0S37D/79r8Pa2iUeStcodnPsfPCHs8RnrejAgffV6U1
         Nn2A==
X-Forwarded-Encrypted: i=1; AJvYcCVLZ+jet+63x9qzHUA4OP4X3gFRVNYKgDxypAUfEvnLLtUxwltVduqlKS8Wjk/5d4m8Oj39BJKTSBMwW87XWxwXH+TRgngxyQ==
X-Gm-Message-State: AOJu0Yz+h6VBr0RCUJ5WTfD3giK/U95bjjl0B8ZmKotgO/r9g8xWOJIq
	4ThpOqAy/uCsYaTWOy/GNX6yVCGcBF6j+A4V2II1VXsGHcerb2EnQ05bW1hrBmo04mCLUGsIbNh
	vO/nfgTPa7VTf42thDNeZoIWHC+95oeFsYT1cCg==
X-Google-Smtp-Source: AGHT+IFLuEDQPZPdafjpLdhnG+r9Ye8iEmmGE6muHcR1tOSBTmu8a6ZSPp1/UImrPk4NjhvsWI0E09D8nDEHmcvlq2E=
X-Received: by 2002:a81:ac67:0:b0:618:66f3:818d with SMTP id
 z39-20020a81ac67000000b0061866f3818dmr2705737ywj.16.1712934870543; Fri, 12
 Apr 2024 08:14:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240411095412.671665933@linuxfoundation.org>
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 12 Apr 2024 20:44:18 +0530
Message-ID: <CA+G9fYswXLb=gN9SUxqpctWKyDz52rsrXqynPWy=uUAPkKCUFw@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/83] 6.1.86-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Apr 2024 at 16:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.86 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.86-rc1.gz
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
* kernel: 6.1.86-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 2cacd493e299f82c489b78ba1de45da451d02bb0
* git describe: v6.1.85-84-g2cacd493e299
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.8=
5-84-g2cacd493e299

## Test Regressions (compared to v6.1.85)

## Metric Regressions (compared to v6.1.85)

## Test Fixes (compared to v6.1.85)

## Metric Fixes (compared to v6.1.85)

## Test result summary
total: 161977, pass: 138152, fail: 2686, skip: 20976, xfail: 163

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 139 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 31 total, 31 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 37 total, 36 passed, 1 failed

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
* kselftest-mm
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
