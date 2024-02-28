Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABA43FBAC
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709139446; cv=none; b=fdqlHM52lq4yfcWy+P0na38/Hhgt0n5qAEo8WLw8brHdVWDxDDp7xE4O0PDbBTXwj4pPScmMKCR6PUGrSp63VXBLwd4zgu6oxMDnJTE4YxmkmTxmLBd9y1ClWnuUryc1wTCkro6TLmDHBzfaQqUUWgqAdrOQ7DZylj3g2n/RmXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709139446; c=relaxed/simple;
	bh=oxbZNucaFzw+bKW6bDkMNkI0wPAd97IsaMqhkGuwG5Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qoZkuOHkcrPR4zYjiltn6wMhJPVUPPDT8SWEq9yc7jWTSXtuEGntk9M54t4kPMbFSLOMdb8nc1UjOOcedzCHM0RBCdj0p5L7hMs7R1h4rVfMmra8USWaKaIBhtiTglbsdTLJ7dXSEuIu3421VPUcZqZD+Vs0cmLaghPu/qh16Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=m0IlEr/0; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m0IlEr/0"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-4caabc3f941so586149e0c.1
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 08:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709139443; x=1709744243; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g8ZCXlkSEn9sHLTdA1hVAvLgAkoam9yf2+6BQoI+uFM=;
        b=m0IlEr/0vBQccFkQZVC926Lr+KNJrJl1QOCMelFwu+rlnwGEKNMWGzGpJWyDg+ykBR
         EypSJIAoqt5OElSUwgzmwZDoZXZz6UuMHXbgSqyYErexyjvQ7/8cqJe7oWs5UiaP5ypi
         IJphmyYpWNPL6gDWrGiI/3vLZNpl4NRP44KzOfrdB0n/aVo1TeuYbOgxizEr1kztx7Nw
         2aicpbCAmyjZa0gRSQquKULmt7it+eK83dHa+xgCNcjNORQbtAHrzyQHoiptujW7nuQ2
         0iN14su4x4QEot6yyzG9KDVjtYd7V0Ge2Ota4/hJIwU7v4AFF/EG6o/hchrojXzHAD23
         4hDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709139443; x=1709744243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g8ZCXlkSEn9sHLTdA1hVAvLgAkoam9yf2+6BQoI+uFM=;
        b=wmTEZl0XrnxWOBI7ofKlpzsRVlhntbSd7khtUjJDjvcD0m5+n5uTzVwuDpRy1dLN2W
         bnCUTE5Cdt0wSMYLnppS7dTvCKTwOarduqQvnfuAvYTu+I1z29ku6k1p+IBJTEzKX46y
         rG2GunJ0OfgLiitds5LkZO9WAAhbb9JBigPQBafWu+PRZeV8jrS6JCefsxFMZGaKAOZm
         qD7wlnnebrYIX1plOb4A44Qvae1fRIRuPbnxOs4WfAdbRhalJsaQeWX7QZo//TYBE/FE
         FgKPsvRtZi4b6A2agw/e+PS/sERAetmHr2pr+RE5W1gMCcmBU4WqdPF6QL22eWS37SQl
         mwHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfpFS22RWHGUVsgvRu9l+7zlP1ksBnEH567hbU/30fm/NfqOJAMrL6T/wZFMSJgp3Brm00lrCKZXuuvN+BVEGYqMxKMVbXpA==
X-Gm-Message-State: AOJu0YzEKRt8geFxdT3fQVBpv6Wyh0GT/xWstxsKO/zD3MXviqdzikZZ
	AE6m07JepOrpCOyeS8q7psuNgR4z+hUPH+SWyON8bFJU+srHjFC8JC6hjj0r6yGMM3Ubz+sARZv
	ZkdCm2PjpyJg/cJJLY+wrvFG9RoAGc7DPX4VC3Q==
X-Google-Smtp-Source: AGHT+IGXE+ieJuji5Gf3xi7ZEA3I2p8k6LgKwtJ/+ODluFfA8K0fvyI367HZNofy3S28Bs6hldwV/7TMkAA4RddfDHM=
X-Received: by 2002:a1f:ddc2:0:b0:4c8:2803:9468 with SMTP id
 u185-20020a1fddc2000000b004c828039468mr14872vkg.3.1709139442794; Wed, 28 Feb
 2024 08:57:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240227131625.847743063@linuxfoundation.org>
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 28 Feb 2024 22:27:11 +0530
Message-ID: <CA+G9fYssEMP-2-MS-YCDBB5DtJh+GS2MDaUtVTjojbQY8-nRxg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/299] 6.6.19-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Feb 2024 at 19:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.19 release.
> There are 299 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.19-rc1.gz
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
* kernel: 6.6.19-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: 3c05aa9775af6258ef849f6db3539689f244d3c8
* git describe: v6.6.18-300-g3c05aa9775af
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
8-300-g3c05aa9775af

## Test Regressions (compared to v6.6.18)

## Metric Regressions (compared to v6.6.18)

## Test Fixes (compared to v6.6.18)

## Metric Fixes (compared to v6.6.18)

## Test result summary
total: 193689, pass: 166903, fail: 2157, skip: 24386, xfail: 243

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 131 total, 131 passed, 0 failed
* arm64: 41 total, 39 passed, 2 failed
* i386: 31 total, 31 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 32 passed, 2 failed
* riscv: 16 total, 16 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 35 total, 35 passed, 0 failed

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
