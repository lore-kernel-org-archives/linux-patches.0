Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3E62EC571
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 08:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756888131; cv=none; b=Apbj/BYqovSQOpgQmBiYIz3ONHxbSdBg/mVheYntiZBx12o4lkIGVYH0MqtlwUWV/nOcfpbouTYVot9loXRS2PGuBjtD3mg436hct5S4U32EIRO9D5NIXJLPfVUJ5WYWmioptBbMec5qTqRy6B9bv5DL1wXPBMvInZA6lcmSGS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756888131; c=relaxed/simple;
	bh=1Wym7Nu8boFhEFpKuUAnQJFtOt+aiYW99MGI9WjtyNI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A4S95/ViI04CQ5Yvz7kSQ3/9FNwcinD8M+me2XKWRx+gsiCOAGiLu9EuYUYCTFXRAsiGGRlGFIeHhEOz6CaCRyFMGexgUfgpSsgZ3uaDmkis0rIcyq3lG71jjOHNm5aKBmqgiyiHVUfvAu2RXSC5YLcnHoyufl/rB/CUzsN1jUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Cg4C1qMh; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Cg4C1qMh"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso5457392a12.3
        for <patches@lists.linux.dev>; Wed, 03 Sep 2025 01:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756888130; x=1757492930; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XLdFeYJfsJKqx9nSy+skvh05dFulDLtOnZYFfC/PFRM=;
        b=Cg4C1qMht5ElSKP9WDZL96q+3gCGXABA8qMFSfWKa8HY0YFbICNEXAMS3gBw/Hm0th
         esIoSCw5fPrNGr8/4YccJCkad6Er1vLNlkV8TcC0XpA1fUyQaaekrwxW7yX1vg40vGlP
         GXUdAugmpMlusMfAYy/oavxBSdam0Y02+nnYMju8xQyw6mToJGSLvxKgq2SwSggU1G3D
         wTxGhQKNw+Gaui+7X/+xeMnq/i8ECzGlbe4d7604JwfeOetiyEEvvMzkizM3VDJi22yu
         AlZynaCPyMoaGkbWv6qBA2IYjmGZ+/1u1nwn0KCXLwf1zR4UnEuLRr//GWPpCQhCzegO
         wEXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756888130; x=1757492930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XLdFeYJfsJKqx9nSy+skvh05dFulDLtOnZYFfC/PFRM=;
        b=jnKDxA74P6kZUTnWnxuAR+7HQ1j4GnW5shu4F3BKvUtTHE2UdXTF1L9GvN1AxMj8Cx
         VSwfWtV6nC+XolLCeaxCizk6iRFe7yCry5liBlegnN1EYGrTyhgmgpBTjUQYExbNP+ty
         huIGPeWhjVG5XpDBQGE5AfmaxC54L4PtwhjRZ2ndVVkKmZv2sEQcgn71T9sq5ZkH1A6c
         xFL+l4h1ARhqp5SCH7NvAu47uCBBG6UDg0jTnjPMvimmwbey2eWZ4NRTDCkH/TKOG9d4
         ET0Uf/misf++saOkhPuDLqL7UAVnGl3yagYmbMIH7MKUGpo1kMQjAf4X/C01DAwjAOJv
         GBAg==
X-Forwarded-Encrypted: i=1; AJvYcCW66gXSLcXKxZxZCwxW8eNEOSp090ks96Kk9IllyQ77XdozB24DSFeRtOwSjUjQbUKMZcpWYv85@lists.linux.dev
X-Gm-Message-State: AOJu0YzaBUTN83pQu41l/3tDekcO0yjvEt/vcTriL5bjV+mu8Pc29tFW
	OSZdxQSyNwkY9w8JxgcuJLqXp9pbOEMCc6TQ7lrxTWc7fKPj/oJSgoJQLIHV1XegRljWa/K7RBg
	Zko1/XoZFOTpeZxVTdbXI72mtTi3reSxglsU8sAtXSA==
X-Gm-Gg: ASbGnctqGbWBClKEVlbU7ZXMtBps7IAmkPcwCSNmJ6eA0n5G6PMX3cb+7Vk9CU5a8Ol
	UFWBNaRU563b6OcJdx92cypFrbzi7B6kM62b6jtF3BSypgHGKhh5pN+YK+I4GOL+/GjoX5FTmDO
	ltcV9HcznOQMCHibnw6p9Wt4QqZc3iSjDYO6W/px3HpEd0uJVU7ecoM6Ua4TSy39jRTtFCbsjJ5
	61yel273cGl36bRR7J+rippz8+pQczEZbRW8vbpNhM6KgBNsGg=
X-Google-Smtp-Source: AGHT+IFa+3oFduUGstIxVZlUPFivKo6G2a3ngt5XNcSYKiNIJHejXq4G+jm39VsJCLYhYa1GOPB0rsCi1WwOgIqzKgQ=
X-Received: by 2002:a17:903:987:b0:24c:180b:d103 with SMTP id
 d9443c01a7336-24c180bdb6emr52728045ad.15.1756888129560; Wed, 03 Sep 2025
 01:28:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250902131935.107897242@linuxfoundation.org>
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 3 Sep 2025 13:58:37 +0530
X-Gm-Features: Ac12FXx9HCXftwKC32N7kq9QfFr14TNGWUGwqxvrn45DLYReD-NSj3e0oV3dW2s
Message-ID: <CA+G9fYuKHWwz60jKchZ5cTZVt0p+kg_DLFqHchrrdkUbSCdC6w@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/75] 6.6.104-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Sept 2025 at 19:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.104 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.104-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.104-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 12cf6be144d1470c08fbb5844926e5b617dfde95
* git describe: v6.6.103-76-g12cf6be144d1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
03-76-g12cf6be144d1

## Test Regressions (compared to v6.6.102-588-gdd454ff512a6)

## Metric Regressions (compared to v6.6.102-588-gdd454ff512a6)

## Test Fixes (compared to v6.6.102-588-gdd454ff512a6)

## Metric Fixes (compared to v6.6.102-588-gdd454ff512a6)

## Test result summary
total: 276426, pass: 257769, fail: 6102, skip: 12184, xfail: 371

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 36 passed, 1 failed

## Test suites summary
* boot
* commands
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-efivarfs
* kselftest-exec
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-mincore
* kselftest-mm
* kselftest-mqueue
* kselftest-net
* kselftest-net-mptcp
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-x86
* kunit
* kvm-unit-tests
* lava
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-capability
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* modules
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
