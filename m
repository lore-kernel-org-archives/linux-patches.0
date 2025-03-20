Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C6721CA00
	for <patches@lists.linux.dev>; Thu, 20 Mar 2025 11:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742469263; cv=none; b=q2YsH67PXprLNh5X87/jrbWfpPLvFOzmyGLf86gel2UPSIGJDJnGzjIGkuvBkXg3kyE6Lg0d5lWyyfdZhIyD0izfeUEKBllxPPN1w4RmHWCZckzuYTbupoN0Z49YHlDL5nLA8M/+PT8UiRYhl/0Vz9NQmjJFeKERGH4OpMDQ05Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742469263; c=relaxed/simple;
	bh=gs/RxkOw+9zHjxMDkCWJn6pZjQhNWaAMP47VKIpV66I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U50CkzZKzuVUtLyRMTiQIsFI7YIOJhkQANqnw7k0rLStdtmL4JM2TOJSr3pFWhIGfNO50gsNjuLwVYwtlgkzaipmjtl8E+iwHfO+lqHw7/sC+tCHKFAriKkH5lcU1nBE3QGVEopCEH/Bvt7YlIHagdV3lcewYwmnc9AgNDDHKsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Nee5dB9g; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Nee5dB9g"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5242f137a1eso311680e0c.1
        for <patches@lists.linux.dev>; Thu, 20 Mar 2025 04:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742469260; x=1743074060; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yZ/40pKF4KOpdCreVXcSikFdMt28zfpEjIGcB1cZCPY=;
        b=Nee5dB9gGeDw3VARI7OhvdUGafokMcMgEjRc4woGJw4ay+M1lzmpM7pSlSHeF8IpAX
         YeMZ0gw0R3nIS26pqRbp0L6TLCQPeJ8TsuLSLqWHuv6vVuHcWM3eI+BP+/MCZg/7mefm
         EOKoIgjUaqHEaxhEg+gZsO4gOZCeDSyK6+OTC6nKrPSXjx1D1LUWTeYro5QfdfYPV61R
         pFWm2kfpZUqsq6bJc0WlFn22NB5De5M5AojDE31vs/V/YLhuKXu7LhbpEmSlQW4fRnAN
         gVK4FktZB4KeMqXJkIRcQ5KMNUfhUL9YXSjVYrr2NAE9xwgxYFIZ4pyNjrahbJ9WfS4A
         JDlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742469260; x=1743074060;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yZ/40pKF4KOpdCreVXcSikFdMt28zfpEjIGcB1cZCPY=;
        b=Yfbz4d6TQBS1hcBQSlsG1jQ+mQYcBOPbC3T/ukjDXohl+nXnypNXgZuJRtvLhRGMww
         wyAjpENKCGw3REZwS4wQ8N5+DyvUQQIh0jO0iIFXbVX74LDU5mQNrVOgL165Itzavru4
         4rE/s2jRg8JDhgHfgX2kw9qNxcj1cckPESRQeuWUQ/OGacjHYsNjKqMnTIu4GFPMAohU
         ns0gv6QF0LMJlF1fi6vUcxvKYgU1lE0eudRc0l5csFuz0vbS9ZM2nrpYw3kBPZiFCFI5
         YkXG4nYTY5j3av2d6ZARBsXUq75MRZkgRwsJuMXwAa7Hn0eBa3EQ/H+XQDc6/Y8KrEWP
         QWmw==
X-Forwarded-Encrypted: i=1; AJvYcCUP9M3gRW9Tp23N3/73+b0r4EI4g8MHeEvG0jF88RYqz9CZ1XDwdUnFb3vN7rsXOkBvIMz9F4f/@lists.linux.dev
X-Gm-Message-State: AOJu0YwicIQCfbo/eaczPx6EHYHSaZukNc/Esq1GDP9TKXa8cTKPhwfU
	ZDM1aTAAF9dNNo66+uEapLrz+BkIsoocOsbqfIkq/zQ2LkvvRHTfcbgGQw5WMl24Mz/4amm4UHO
	OdB2Ik/xG2HWuu4VelvdxQasOM1a5/ZAcnFUCVA==
X-Gm-Gg: ASbGncuNVHLAjZl19wq+7IzMzIeKenb6HnLLuj8lmzHfTKsK4S7BWH92/PrQvL4tfm/
	bP581B/xRB814W+2jDePDJtKXIeNhL6IM1FeTQiL7/N01Omtg47DD6sY22hi/K5QYRvASuVCwfL
	++jb1S9RWXIWRe2kT2kCh4srW+jPKFY5fQAdzMG5RsbTYgmVSyo0hiOQXIWxPqzDN1sg==
X-Google-Smtp-Source: AGHT+IHUtzsWp+sZFeHQ/CjaUDM4MAxDpqfXXpGW84EHC4lm9dFq4u1+7xTW8CSUfTYmAkSCBCCAkGX5tv67AWVQENY=
X-Received: by 2002:a05:6102:2926:b0:4c3:6ba1:4129 with SMTP id
 ada2fe7eead31-4c4ec821abfmr4660184137.20.1742469259807; Thu, 20 Mar 2025
 04:14:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250319143027.685727358@linuxfoundation.org>
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 20 Mar 2025 16:44:08 +0530
X-Gm-Features: AQ5f1Jo2_ANbgZbsR4eNysulQg_-IHFoWEtVL_IyMNH6mkLz5qnNtwZaWi_i3TM
Message-ID: <CA+G9fYsFM=9F39+bM+PHpuHXaEvQRw8JzjhxhM7v8HJTb06CbA@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/241] 6.13.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 19 Mar 2025 at 20:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.8 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


There are two email reports sent out for boot failures on arm64
1) Dragonboard 845c kernel NULL pointer dereference - camss_find_sensor
   - https://lore.kernel.org/all/CA+G9fYuquxGrt81z4FBSEDuvAMpu2qYAoFXwYKpfSuw2YYNS0w@mail.gmail.com/
2) Fast model boot fail Internal error Oops BTI - kernfs_iop_permission
   - https://lore.kernel.org/all/CA+G9fYtucEt8Hp6RsV0o+OWSz1E=hXBvhHa-P9C-bPnb7cyGaQ@mail.gmail.com/T/#u

But, Not sure these two issues are specific to this stable rc round.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.13.8-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 14de9a7d510fcfb3bd35e275eda09724bda4d440
* git describe: v6.13.7-242-g14de9a7d510f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13.7-242-g14de9a7d510f

## Test Regressions (compared to v6.13.6-198-gfca1356f3f51)

## Metric Regressions (compared to v6.13.6-198-gfca1356f3f51)

## Test Fixes (compared to v6.13.6-198-gfca1356f3f51)

## Metric Fixes (compared to v6.13.6-198-gfca1356f3f51)

## Test result summary
total: 132609, pass: 109017, fail: 3817, skip: 19775, xfail: 0

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 56 passed, 2 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 43 passed, 1 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 25 passed, 1 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 5 total, 3 passed, 2 failed
* x86_64: 50 total, 49 passed, 1 failed

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
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-ipc
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
