Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6444B28E7
	for <patches@lists.linux.dev>; Thu, 17 Jul 2025 06:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752732402; cv=none; b=R6vckbLsMs0WXsqGwcQ1Ok4xNL1CVGmtjoDOsBf6eLyU9shkAv6oAinjxbPLEKyEOButhLn+6VbB33ekcIt98fR0CQ0PHKn9rjXkvA1Mqsy6kI494cZBHhkf8v7pJXdag0gzAJRlXyxsXFRCIIo8N54d2JUxtn8k+kNSdrSazmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752732402; c=relaxed/simple;
	bh=w/XNXA0/1Ho+Fsc2IZ/94LPEGGsUlTvRDCA0izkaS2U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lWKPNJYQAPqSMWICmGUImFV/SEiXm4Q5D+DAkYMA9razU6rDaszbQTX4pDCQAMcR6nXiViTm2fsZRg+SBZHD1lY5Ik+XMY/Y9aokhM+n7NU0aZlSPb5fLmA1dEIXES3Dbu2oN13hBcKJie+1OOrPxOZcNfHSht95PQPcm7ozWY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JPiTnBvw; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JPiTnBvw"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b34a8f69862so433666a12.2
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 23:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752732399; x=1753337199; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8IV5c7k8FkRHMfVKUwEzdiWKabmC2jryJUoHOy4flaA=;
        b=JPiTnBvwDmIeRAjIYX3WyeVJTS/YwOUSa4dnp65ZaejQHzDVbtpXEYjpFNDZjVg6oW
         w2KvUd236imEIw71MtYZvPGfQDtPudFzHtoCKGc5jbv1Xp9GLT1nntt+bYT5s7MccE6H
         0m8S2bZJICR87yKH+eIRuqROHhy9T9k7k7vDJ9kGiZwr8yKqHQBf58c7JjYVya8U1gEI
         izRIiMFPW9c6zV1d6o1UyAePScDg4AlNce3Xuel0834hecCPMY1sif/QStHD/yvuw3v9
         RsmVWZvfXi24QbWvvd15Y7IrX9zq8913S+0OwzA9pG2ZGDT/oMtgyyYFkx1nFzu4EJK6
         ey9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752732399; x=1753337199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8IV5c7k8FkRHMfVKUwEzdiWKabmC2jryJUoHOy4flaA=;
        b=ec8RGC8lDUzvkzFLwA3MBf1cpsX5dN2l9qQFwBq1DiclNQ6UpcWXFlzRoAV7XWt63y
         p+QC25V/35wiSZs9750CcKEEgtjnBemAHwrjDXyT8CiaBZz6fiEvfxusBXlbqryt1PDs
         wH4xCHKCCUsxaZ1GDexeQiZI9HUi50uu3GqEV50WXE+pGGpDMsMYXJhHi6YD+aBa/q7C
         v/BO3GHevp0U/1spi4TUpEbjtH+PclqzJwkqG9fe+o0EcWjKqUsj1oK0IEc/wfPxBKPS
         Z1o3NUH2bPNfx2nWwCh/0WHXvTBXGOJgxnFMMINT2GkML1zxxLrQSGgBUXvjRlgTKzuV
         tcfA==
X-Forwarded-Encrypted: i=1; AJvYcCUllVqoF4PwvGeVJ/pgOzv8QyNWXrIegXUh2bNUbPlyn+wWKDsiT+uQXt61Ic0EJ60uYqq0AScT@lists.linux.dev
X-Gm-Message-State: AOJu0YwjCLArZX3PNrtQyN7wjYo21mPJF4ZL0rX+fjyg/H77OrAiRXj1
	rjITKakP23ZWajJ9O6nL/uZWVrnzD1FpyVyPRUVgwLv+9cH5o21KbcOiSfoQ+Y9fLvNPS8fN+np
	byCUPapUERa6C/JrfJ9fUQdX9ZcOvFw/MMzELF8Lqrw==
X-Gm-Gg: ASbGncu2gWG/OGCALxSM2jxWmUYCEEEsbjisNW7eM8sYX+zN0tA+gAVKgd4gvKg/hRN
	nmMd4xlEDIg29euvxzMVlKBB4Hd4NFoXEjhNiXpdfjhsaxxL2l+/8MyQE2akaKKDeJNWl2zIXoP
	Pj+8KrRWzsfhMVHDrymbu+thIs+zZM+T7TYP9Sra9/gfOH75zrg6AxMp/XEgxeoRjxzzdDk02VQ
	6M9NKwuYS2zOEP4I7IpwXVGPzexpG3reQTspZMko7o3XjH4e+Y=
X-Google-Smtp-Source: AGHT+IElD+hWffueY9O2l5MlqFuqIXzGyCKBnFzcuaWJr5IbzPpnXRMfFI73nz6+ivP3Lmv0Z3fyQZbpDdsSYxJ75Ro=
X-Received: by 2002:a17:90b:4985:b0:311:ea13:2e63 with SMTP id
 98e67ed59e1d1-31c9f47c919mr7014030a91.13.1752732398519; Wed, 16 Jul 2025
 23:06:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715163613.640534312@linuxfoundation.org>
In-Reply-To: <20250715163613.640534312@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 17 Jul 2025 11:36:26 +0530
X-Gm-Features: Ac12FXw75ij4GhIMb8FWW5TzSpjmuX_6qgN5xYsecfajFGkyv7O_tsvhp9A2AFw
Message-ID: <CA+G9fYvnLqHYteeXiucdCJzpcxJ=w7v+RFn1GE2pa_LjFSNV9g@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/209] 5.10.240-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Jul 2025 at 22:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.240 release.
> There are 209 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 16:35:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.240-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.240-rc3
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 2067ea3274d013cacad86f86222ade38d0f51a7b
* git describe: v5.10.239-210-g2067ea3274d0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.239-210-g2067ea3274d0

## Test Regressions (compared to v5.10.238-353-g9dc843c66f6f)

## Metric Regressions (compared to v5.10.238-353-g9dc843c66f6f)

## Test Fixes (compared to v5.10.238-353-g9dc843c66f6f)

## Metric Fixes (compared to v5.10.238-353-g9dc843c66f6f)

## Test result summary
total: 41250, pass: 31019, fail: 1800, skip: 8248, xfail: 183

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 100 total, 100 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 21 total, 21 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 24 passed, 0 failed

## Test suites summary
* boot
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-livepatch
* kselftest-membarrier
* kselftest-mincore
* kselftest-mqueue
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-x86
* kunit
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
