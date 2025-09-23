Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F9F28726E
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 05:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758604512; cv=none; b=Mh09qG8tenFzbuBiv5leLFvVxPruCTiqJQtrkP+R1tX6vEVuPNF4BWVkLTScg+mIDLtDACY8SO7lx3aEJQ5x7D5PZkAq1tGJ0MgsXp/xcjJoXjpACYIG3JU4rEj7xssNQ8HJCBAfNrTnra+Y/Sgp1wQhu9iiPsqneN5cAMWSB7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758604512; c=relaxed/simple;
	bh=7xO/w8Ux8Q94lDae1VbNusDmpntZTLs83b9gcG70/VM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gdNJZMIFKvlwquoqte9TIlvm1AjvZQevOyQpup0M/f5f5RkFRURTfasOiveiIaQRAAEMiGTvP2ojeIlEZiG+b1e45mLstff/Y3WVnDzuezeejR+3Hq/Q1GzjNCS+BRrxdNYH8rbqZSi3vC2fpA/1Nr8l+RKgLb6V7vwrKs0wkxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Hm2cjNP4; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Hm2cjNP4"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3324523dfb2so1996006a91.0
        for <patches@lists.linux.dev>; Mon, 22 Sep 2025 22:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758604510; x=1759209310; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f7i9pmTrdIrbqnHasCnEr2Ik3GCVKcKjWftLq0bTHq4=;
        b=Hm2cjNP42YunEm8qJJht8TbFeJ91pC3bVTshl1m9gjgsY2ONjYTu6+gA0gj7eWhGnT
         lYmmrnqIi9jT8R6ptPQkKdDh6/1m+5XscAJKnBwMY692vEJF7RKX/C+E/bElB+s7f9dy
         Tx7ghGeQrp3BQJJoWvmy7eZgALp1SB8yO2gPdyUUVQ/x8NdTNawzwLJyy38YkG0VioyG
         ajZp6i4VPD5S4Yp3q9YM70n0X/2kOmCEeb1FUTewmu/6+i4kmIjwYqTd1aKHfJ+Ou80R
         7mQX4kT5xAIY+yik7JpdkasYW+UBHtilmBf6Eb0yiQWN24fNULjEBiaLDJD4O59JqddP
         pMww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758604510; x=1759209310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f7i9pmTrdIrbqnHasCnEr2Ik3GCVKcKjWftLq0bTHq4=;
        b=hOh8IukOPcll9RIX6Zmcgkrm0WtuzA8XB/vXLBk/cTsmP65pV1H2QpeFdrsk+a1A7g
         slGL8BhXHw8YBT4fcmY+1wi9cl9XlGhTRiMOcnKOjJP+K6QIKV/i9CE0ruKxBDew2axz
         7CgN+C4CjzOiT7eRS+PuFWMxVQ7l/UzAsEFf6Dy8zfNV2AYqUkvlEPmPR3jEjh/6plJc
         6VH6Swl4F9lg5YrgpaoE4/XdjZjeNgC46V3vwpv6zVFSz3EjAL9JaEzWfJGvFC+vy6Bt
         bsBDutSvdHVMWb3OuEhK00POHmJOZ7suNufAoDFf341hSehvToThux1Un1SEdR+uoSWP
         hXFw==
X-Forwarded-Encrypted: i=1; AJvYcCW4CPzZll+yQshsCBETphsLWhgiZjBN/XBtEpBVigvnyEAl4lpldgoUVKSMTT5ht6wypeR6rPTh@lists.linux.dev
X-Gm-Message-State: AOJu0YzJT0Tf9GLHRcbz9FR1Ywq6Rzgh20wmtda+TTsJdRZ0CNz6S22V
	y9Ct1HKe5g0U0v6fqV6vWGFvgJep5uYTToAlMHK0G/Qz7wmjpgW61N49rkWFdX+x4BHkL1/1E4n
	2fMxEO7wdPA8O2oYbbtnoLjZRt2okk0vHWNvWIX2qUg==
X-Gm-Gg: ASbGnctOSskfsshC/MHdTJ1s89V6IPzhXtezJKa0evIjo9XRjk+kiknonIFZzUmiR/6
	YQ5QnyJ/QXjPttovjnVqZZExRSkAW0oWiFUb1pr0t3PJEv+O+ZDY+qL9sJbiFdTRQsx+FSx8Ch0
	9nG1cA+vkI4DLBNS9xXjfTsQuRQAWjlbT5HDuVUengNxXP31F7ng+KdrIzJokgPq9nBEDzt1Vt2
	pns8Ssc7Ohpkk/nqK7Rjyx7xIR2T2yFLwPaldSi
X-Google-Smtp-Source: AGHT+IHkyyCZ4aLQZ1Y0xjlVL+qqA0NCcCbmE4WuYZchPsfa/VVDefDXqBjV83WLM8h+6HezJQO1BpZc/a10Bjf4AW0=
X-Received: by 2002:a17:90b:4cc5:b0:32b:6820:6509 with SMTP id
 98e67ed59e1d1-332a92da3bamr1474811a91.9.1758604509894; Mon, 22 Sep 2025
 22:15:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250922192412.885919229@linuxfoundation.org>
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 23 Sep 2025 10:44:58 +0530
X-Gm-Features: AS18NWB826YLcDy8jjmwFSMKmbn-OofuLGovoRwJaNxOpvEac_vZ-fqEi4wyT2Y
Message-ID: <CA+G9fYtNrr62bYOxqG8cXkE1Qv6neuq3CoB6v61SWxzUm6MxLA@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/149] 6.16.9-rc1 review
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

On Tue, 23 Sept 2025 at 01:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.9 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.16.9-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: fef8d1e3eca6557cae4f0149eb2071123c473c26
* git describe: v6.16.8-150-gfef8d1e3eca6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.16.y/build/v6.16=
.8-150-gfef8d1e3eca6

## Test Regressions (compared to v6.16.6-198-gfb25a6be32b3)

## Metric Regressions (compared to v6.16.6-198-gfb25a6be32b3)

## Test Fixes (compared to v6.16.6-198-gfb25a6be32b3)

## Metric Fixes (compared to v6.16.6-198-gfb25a6be32b3)

## Test result summary
total: 349618, pass: 322571, fail: 6726, skip: 20321, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 47 passed, 2 failed

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
* kselftest-rust
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
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
