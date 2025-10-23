Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A652A23D288
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 07:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761203476; cv=none; b=cgaFNVKaW1DzXUExHUbpwtcFnyZTL6wC9NPX79PTn0+pf1xTNu1dcB8a7JLLY5apucNYbHsWuJ/U8xCloTLz0EOb+7pBQ9JJi8TY0zn7dJDFmr0LOjBMyhHjhV3r5uirVANyvZzKkbchqx9qQYUUtmpiyxX/redCZOuco1D3siU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761203476; c=relaxed/simple;
	bh=83WfB3SqYO2Z9dZJO8Pzq5z46Mj56YTUJvCapIfPmAg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VvAJNqkRk7q9VQC5bc78Ho058Uq44GkHjGdt5OEGZtz1cmyOgkDjXS8v8kR8vsutgIgdOvIbuCrD3nOP0oCm4nZ4ogdeu4LnITVZ5FgOY6cFCCvrNnBOtjlUCJOtAInS+6rzYOcE1biYKZpSsAKQ8/2MUD/qx7jYGbL5R6/z9uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PFbRZgwJ; arc=none smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PFbRZgwJ"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-63e11347fd9so497008d50.1
        for <patches@lists.linux.dev>; Thu, 23 Oct 2025 00:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761203473; x=1761808273; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVFmcKppr8jIO/+cy4Rhc1x+4EvS+GSHFcZUJ4Pfb18=;
        b=PFbRZgwJp2DXD3ZmElB8RJ2U1fdXWG1O5beh3dGJhGtuiQIj7UWfNYxIF9Cujs9L2y
         skM8oH7aN6JqPEpr9qtWp7f6qB2eh6oBa4JXoaey4moSvT5MBtVISvN/xfqdZ4SDWI+Z
         pqJpMqFPUBLG/lm5DAMuRpcGqV2KAFaMa6AFfXIaCi6gNDb/kvBxxQmr5dY10CFcVjHJ
         2vzPReor4SJj0MWT3bE8FlTsUs1poeHghQEUXJarpQsqGjVD2GcIw2FqkljmVtyiHvXW
         X5EJhvad3yfb+puN1iFTypV4/YLGlAHnB7UgGjz8mM6oRAV8XXxswGe5YdjWlwKSt4lj
         UK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761203473; x=1761808273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BVFmcKppr8jIO/+cy4Rhc1x+4EvS+GSHFcZUJ4Pfb18=;
        b=W9Ef4xho/N9yq78UxzXAj9WUb0PHMjNEN283u5B8QAm1/FTpNJ5uN+IeBQSsdEjrZk
         XVOXn+R2dViqFX6MaCvmqnzIIe5KLBK9edyMttDpBe+DV+vbZewUFgiT/oDJoovjGHV2
         isVmqH5Iah5b22R8ecfUVFxiGkhP6pbGbsOqaaZVKBEfeSeKqf7tBuvNLrQqr8j2rOfp
         6XrOzEI6kNotsce71KsUIxQCBFAXbaL2nu8Ag1nEeihjlpgdWJHZw/SKFLn67O83GscZ
         jSnvZ/4YgAyzJPpOT9mnf7wwQKUbjZoNNC78t9WpjNleEI0SeKIYOMglIM5BtjF1J8rK
         LzOw==
X-Forwarded-Encrypted: i=1; AJvYcCUGpOKxE4t36EI0hDx2FEnisedwSHwaERWPBa8NmyYjJjNco81yaNJ+TRp2fRW0M3iPreNbCXkd@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2RVB9nINCrohCXFqaO/y4aVnrXDG6ASQVkzU17d6WsWiR+Obb
	vxo0TgW1QwrnEB4H63ClZZAg43ZQsYtf6TJ7TrNNDg7Ngd/jU6fb25GknMXYmPnVd1c5kcS5ejd
	h5zp1aTDYhtpx8TjU4RmIHlPWzsoi3QmSKOArHls0Pw==
X-Gm-Gg: ASbGncvWyV9BkbHz3jKDOMfuFX/L3CEkqbMmxZdIhw3eTbrzlBF9kVD21Zp7QYq8QMX
	earpwQXQy2vhrr50DxojMCL4iq9+Sc2RlHkbuW6hs1PldrJz1ECha7SKFCIH90GzAdD3DcE2Abh
	fZCP6NFwsWySyCotMJF/GDGVz8MFoFY+GaASJmLIaI1RkkRIwXC2vi8xh4lwsiIvI/nrHH7gm4J
	x0yXVsCgNLTdLH4dk9CnF8w7LYgGg2H3Lu+VcFazWUGOjP/bzDvnbJASD0mYsF2AKhfCZBx1o/Z
	WFw2OmNEm2asU3989mvm7BTv/0CScb0rnXXw50apK761TG6eRE0rU0L+oNi3P9/kBVEWics=
X-Google-Smtp-Source: AGHT+IH3VvCDO2eAFj9JJJRDEEDT2NNCXO5PyFPHxu8d0hi6hIJxQoOArUWORp1GvtDA6/0rOxpi/UwchI9zIngrtoA=
X-Received: by 2002:a05:690e:d85:b0:63f:309f:6354 with SMTP id
 956f58d0204a3-63f309f66efmr3332065d50.47.1761203473301; Thu, 23 Oct 2025
 00:11:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251022060141.370358070@linuxfoundation.org>
In-Reply-To: <20251022060141.370358070@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 23 Oct 2025 12:41:00 +0530
X-Gm-Features: AWmQ_bnJFFuVapEywiEjdKwHI9nFNuApBe7za4vRcqQ8LxS3q9W1qtdNuEfmywk
Message-ID: <CA+G9fYuEMMptWPgF5wmEPN4T2eyrDC8i+Ha_xLT_E35AXHeP-A@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/135] 6.12.55-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Oct 2025 at 13:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.55 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Oct 2025 06:01:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.55-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.55-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: bd9af5ba302635dcb1e470488c0fdf70be8d45cf
* git describe: v6.12.54-136-gbd9af5ba3026
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.54-136-gbd9af5ba3026

## Test Regressions (compared to v6.12.53-278-g6122296b30b6)

## Metric Regressions (compared to v6.12.53-278-g6122296b30b6)

## Test Fixes (compared to v6.12.53-278-g6122296b30b6)

## Metric Fixes (compared to v6.12.53-278-g6122296b30b6)

## Test result summary
total: 119783, pass: 101440, fail: 3822, skip: 14162, xfail: 359

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 51 passed, 6 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 24 passed, 1 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 46 passed, 3 failed

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
