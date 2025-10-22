Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B17336EF3
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 12:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761134748; cv=none; b=uGrNhf365CvPzbNUM281NuxdsxJ4HHNKAZB5W9OHxUhj8nMnVw20HMzyOxKe2FMQRxPZnWulqzqPpKsSjpkx44nZYfUF/+xVuT+wCey/1VnEHof0nZ8Cab/ThC4ySfm0ZK8jsRYSVnYldDNZbxD0FzfBFi/6us22g+kwxi6uNQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761134748; c=relaxed/simple;
	bh=RNj2koT6/Jg9iN8a8+Er+ObY3cVJy0QTKD4UCscfYnc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VmKwS8A+jVjbp5NxhmR4vhJOh7pEsmQ8L+JTj0wgmpsMzn2CUZ6YIeA9d39tfG8Mhp9VoX8Y6X3EVdHHu9TB7a75NdTiD8HlBJ0x6E+ClMrp8lgoeev43i9bnKAFY3SkSM3XnLdxpQ1MTRsXQveDDLGAwhIE7dlqSQYRtvmHmwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=N9N26n4d; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N9N26n4d"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-78378cb66d6so47870677b3.2
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 05:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761134745; x=1761739545; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jsbxYdewfvfh2UHA2Tl3D1IaYpjBuKyP2US1/dOI7NQ=;
        b=N9N26n4dPx+vWJQGMi4RWjvUPsnoZN3OPMjBfQZ+HkD5qBIo3zLiGgtB86duLb7l4q
         kqku3yD7yhxae4xPdfECuARq6X07BtspJYqOijZDjbIhkV1WH5H6LqgwIL/1bFLWfiAJ
         WwL6hoADIprcdBKOU7oiBqZQ0dk485z2k9n9LeqQiLSgKiymBNjoDgGl7RWHN4Ra1kQo
         VcYTeFo38nmMLuUKcpDFka6OrE1Z4+nayxgO9/1H3rG82RvWzBCwwozkuOMhjd9fZkek
         L3OvDeoLiFzR3IhWDr9P/ldsUfozDpwIBdLhFrK1/X/S/b7Dl4kjdalPkgBdZFqNJ7o4
         lkqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761134745; x=1761739545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jsbxYdewfvfh2UHA2Tl3D1IaYpjBuKyP2US1/dOI7NQ=;
        b=KOWrcphUlr6XEi1PoB92jt25j7o4AXpgIR4WyiKE4kbj+xeBaTjlIKez3bA56gCvUx
         k5on79Lzdowt/HH020GJZJ3kl7h5SZE0H2mkvSVvcaT2xKxp6teE8VSs9Prq3sV/DsaV
         Ph6gHsln0KcAY7W+ybdGCktbRf6wc1b0+nGrFj0aNnBuT5//7yNxdoVzlB3CZL4OVtdw
         X5gb6fXgor9w+XFxPGVY4eDyUhC27SID28eYvGhxEn0zkspuL1fok/IOOn7q00VLpFWi
         BqS9TyZXn/PyVIGWvscWzx8MGvI1PSurYxVQoWIDigBqAmetjM3v0rhJ7P2nNvR0ApYm
         QbeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSx4bB+iOCP6xnBgkud2Z+7Cur79hbbCdIzBNsByJuDHhVopDTP2YGDZ7iXDxV79sJQIqsza74@lists.linux.dev
X-Gm-Message-State: AOJu0Yzjl29bmZudSBLFo1iIqJQmCz0AHtqYvRM9Ue++Ol3OS9bhjPb9
	rml7y27BVzXgqx4+1FvidJWcUfRmvXGU48CH9/9oHa/ztuFpN42UydyTmbpiiTNmoadx1Td2WdU
	EK6vzonkcx+9mVsvNqvQaqTuV+83cMoOLyy75EGeb/w==
X-Gm-Gg: ASbGnctFAilnQ+uZJq8ty1hRvg0d0yeDsUpsuGEBe7MR6DKzlb33Zpa9FWX1VxmIphG
	1hIfkIBzwIff+boO/esvKhUBzNdHO2B12bOnQAhG76h5GxdfGCtgpKWg6IjMnmrAyHxxPoGcagd
	NKu8V7YAInQYR0ULgEhxcxrsqOP6YhfO38FYuM5WaZ/U0WYcN3q2/U6MrWFHkMZk8ARYKw6G88B
	vnz5jfiR0MBjUZ7mbJ+bDibt1a0b/B5zdZBPUX7pr563FJ6lRC4SLQ8ql6hPipTKdg/1JJRU82o
	2GcYXbjA+s1MWrtz4nmo/YdItxOeKU7kET7GUJr346QSIBU=
X-Google-Smtp-Source: AGHT+IEVIK7tQKmoArMHFnvXs66lZp2ZJesGI2vCEWC8RihiAm1lX4iHvyouvLFSKyiioGMo2OeoztXCogIKnK/gcyI=
X-Received: by 2002:a05:690e:d59:b0:63f:2b0c:2d6e with SMTP id
 956f58d0204a3-63f2b0c2e74mr1569504d50.3.1761134745547; Wed, 22 Oct 2025
 05:05:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251021195021.492915002@linuxfoundation.org>
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 22 Oct 2025 17:35:32 +0530
X-Gm-Features: AS18NWBSyT6dQcKb1MqntEcC897UCpgSrWukoniGLQKQve0iUkiFAwPQt8eraPU
Message-ID: <CA+G9fYvfjjqBqxEoWudw6PUCz07_r=OxiA26e=cJ7bWBGNGCTQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/105] 6.6.114-rc1 review
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

On Wed, 22 Oct 2025 at 01:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.114 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Oct 2025 19:49:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.114-rc1.gz
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
* kernel: 6.6.114-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 8ed83e981d68359d06ea8e83da61f55c4a5fc71c
* git describe: v6.6.113-106-g8ed83e981d68
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
13-106-g8ed83e981d68

## Test Regressions (compared to v6.6.112-202-gef9fd03595ef)

## Metric Regressions (compared to v6.6.112-202-gef9fd03595ef)

## Test Fixes (compared to v6.6.112-202-gef9fd03595ef)

## Metric Fixes (compared to v6.6.112-202-gef9fd03595ef)

## Test result summary
total: 91363, pass: 76815, fail: 2923, skip: 11410, xfail: 215

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 128 total, 127 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 21 total, 21 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 31 total, 30 passed, 1 failed
* riscv: 15 total, 14 passed, 1 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 9 total, 9 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 33 passed, 3 failed, 1 skipped

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

--
Linaro LKFT
https://lkft.linaro.org
