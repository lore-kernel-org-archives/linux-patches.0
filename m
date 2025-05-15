Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBD1298CAB
	for <patches@lists.linux.dev>; Thu, 15 May 2025 12:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747310503; cv=none; b=e0J3mBVwMb7BcScwUcFr3YiUlSeN4n7EVEhv9EgBGcd8x+AWfGfgIWO5tr553y6HG38gm7og8SR76i1cH78nrl5RDGr7DZpmOK/fqtLDEoEMflJws3nHwn/uO1COY8Rd60mBLVOFhn4OIMSH4lMa1LwvgjCQhpE6bBLI6/QZaMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747310503; c=relaxed/simple;
	bh=YDFUAr5da8o162aqbI1K22R9rw4a228pKAZsAnPOScs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QVMii7JiFQg2N1bP71mmQ1NDgZ/mO8qZ8C9o+fXjrwUvGeVdItnZhfVjLs8WwZ1AdWwkeNggurIB1Qbr84eE72sv1L+bgMgGWYYUAF0yDottwKVDIM9npxFvBEfKRiSHEyEb8OlbOjAxiXDLc4eQRpAJzlKWW599OfBuJNco0g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MLBVy0AG; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MLBVy0AG"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-40356cb3352so740828b6e.1
        for <patches@lists.linux.dev>; Thu, 15 May 2025 05:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747310500; x=1747915300; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=boeRSL7ymM1MdGqgj1pPiyPcUbQz9mLlHUY3utY5hEU=;
        b=MLBVy0AGFf1mnD42/lqLsMVyJXi0j7qq4nwBbAIQBnzcW54k0xbXDdEliL+3ZLPBJ/
         fY8dLFpPwEM+HTG2k75k1PNZjfzFH0NBnymmWj5EHve1HlNRgwYdev5lF6seHomkL3XM
         A5TJJTwi0B11GD4qZg27wflocE/bpOFUEHPU1TDRfnTKxXJ2aOKI6WuWMZjPE/NiI9/C
         afsMFJ7NBNkCkGKAJxJffJGdEoIYk8qP0VECt1QP+s2UzzBsz7vnC1CgP5u+XaPk96RZ
         al++By4aaGPCrwl7/Z8kGn5WaomvoeOLz2xM6E+iBcTE4dRJ1ioNflgZlnH6Bth1oCYO
         oKWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747310500; x=1747915300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=boeRSL7ymM1MdGqgj1pPiyPcUbQz9mLlHUY3utY5hEU=;
        b=rUErUujIHyLx0xbTjBLEA7cAl7xU3DfitVAnR5rLPzJ9CWjKTAMtqxHtL+vgCjcrVi
         VREdCDqgQRhEY2mBTzT6sTZwRv+u8ZvrO085Bcbnq6zNmt9DnvuD/Mijbb7vRkUF+eP3
         EQ77gUgzuMhjWDFBV1M2MIc2eBSl9iO2bV/apHBtKtoeUm8GIG4sXi0Uyi1lHFpNza57
         hmAFivCe8X5t/6micLExosUSL/lq4KoRl+lTAD7nNpzRozN0PwN6MJEVU+uQFvGT9RIa
         zl+fylK8geevcRglUIpxSTeDfesXoGn/M5c1ONluBwaL+foYwN2zPKBQDIuszJO5mru2
         bl5g==
X-Forwarded-Encrypted: i=1; AJvYcCXlubw6u+HeAbiju0IiSKYMq8kQSuC4+njMqHFRDFlmPD8/ziwY/E6z1N0q5A0A6HkpfnjQmxey@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2desU1F+zWZWwDIBO+Z/Ge+kX3T+8JDZnSyHc9Ga4xSPmLYLv
	pujB7ogjJOaYT3Xvsjy88j2UWyMPbfd12Bm/3iS0Ejb1T5wS7kFpKvKyT/bA+UDDRYcySUtLh9J
	53o5zBV5hMB0cQxAI8/plGRTfx+eBfmF8TSWSHJ9u7Q==
X-Gm-Gg: ASbGncuQoHChPL49pheoEMy/WPbVXIpROB//22Vt5W5FLgJ8O5iByJ1YBHUL9PbqB5c
	pOwAcPLO55ukk8SARJMp6bikGCnHIRenIQAmwDrVLVP7E+TCfzicqCDoKkkfJqckX/UvXUXoEpd
	etIHomrJ++CZC88p5ynARJmB1W30y5eF4=
X-Google-Smtp-Source: AGHT+IETIm65Gi5hUcwxtimmfoRGo6nkKMju25zlIOBCd5ID+1gOQSmy0JIluClS2ct7U0vOo+cZjdB0S4KBMfqMcnw=
X-Received: by 2002:a05:6808:ec6:b0:3f8:bbf3:3a18 with SMTP id
 5614622812f47-404cd76d68dmr1460990b6e.16.1747310500195; Thu, 15 May 2025
 05:01:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250514125617.240903002@linuxfoundation.org>
In-Reply-To: <20250514125617.240903002@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 15 May 2025 13:01:28 +0100
X-Gm-Features: AX0GCFs0FjaKtpOVN9UBOrrKADANFFyaTrwzsOpaTJ31mj22VjLsndjuWf_epr8
Message-ID: <CA+G9fYuFATLbTkum_UhZt6u6O=E58ZfkYnPPJUn2f503WgPWAA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc2 review
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

On Wed, 14 May 2025 at 14:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.91-rc2.gz
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
* kernel: 6.6.91-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 477cfead3566d334186ce439760204bf288d2769
* git describe: v6.6.90-114-g477cfead3566
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.9=
0-114-g477cfead3566

## Test Regressions (compared to v6.6.89-130-ga7b3b5860e08)

## Metric Regressions (compared to v6.6.89-130-ga7b3b5860e08)

## Test Fixes (compared to v6.6.89-130-ga7b3b5860e08)

## Metric Fixes (compared to v6.6.89-130-ga7b3b5860e08)

## Test result summary
total: 134900, pass: 111038, fail: 5345, skip: 17956, xfail: 561

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 27 total, 20 passed, 7 failed
* mips: 26 total, 22 passed, 4 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 20 total, 20 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 33 passed, 4 failed

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
