Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B51217C9FA
	for <patches@lists.linux.dev>; Sat, 28 Sep 2024 12:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727527188; cv=none; b=pextvpgpuqRfNDcbcZLSyBGFxuhiNuq4uAHgVujLdRYfRNL1Z+/U0xOPhA8wI39/ZGa67FvgQQZXmF0QwvWgBpuMktJuOdjer4H7rVZ/bnmlxbMJVSNIvJ+R5Xr+1wYn28DecmO6Yjg6a998gp4mVb/gdeRPhF9m2jySOZg+cjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727527188; c=relaxed/simple;
	bh=Jd2f0dlDcPMOFbdqGDhafd2lnXj21geAWRFPp1RpJ3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CuNsuAh/gh5AnpX0rIEiSQhjFuyrQSVJza0DYYUE5mTYG+6go2eMkkX9vubgxsoaR5FKBE0vq7AM9axXjm8ByeveuaewCe+CLQLRhdhIVzd++wSdQgFUT9ue7GfkhrqDp8iZdNajOBizzutGLwETJ6sbrblxZ2senRAeRhVN5Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hJpKEwoq; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hJpKEwoq"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-84e9893c457so971575241.2
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 05:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727527185; x=1728131985; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1l4GbE6hWpgjJgZXEVqIt2NtnbNkJOGS31/1kVeUq8=;
        b=hJpKEwoqmerF1x2118eP9IFi0wpSSLJcQozvkfQY9CoI/KxtXu9OQ32we4/NKHhMyW
         AInMtmA4Q+bpdvnR/O/G9/2PuIPuiJTtWlzo0CA4eJG32yOohBhc8DEdU9yEXHz7HjDR
         TS/UaNW6xHhYmEbSmP7r2V6YKgqjYI561OA2Y0NAC0I6Li/ZxE6acomRQZgsyxLq2jh4
         t7MKkyLPCAOhtNktfC75PqZzIs9WTVdo7sKeQ9jLY1i3gqn84KSrnQNr1rRDqOaDnoHb
         Wgr0e3icEAHGW3VtTblEAoelv5qvpM2MiNE3o+vg8z5Ysn9U9D4YSXcSVrJa8JCuw/6D
         FvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727527185; x=1728131985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1l4GbE6hWpgjJgZXEVqIt2NtnbNkJOGS31/1kVeUq8=;
        b=rqEEc+8eV+G1tjsVXnczDY5gt/Njq598sD6awcKJNx2t6wzpFIcMTNtpv8KxKYRCOG
         5nFmhNdRZ5ZgJygI6vUXB4IO70Z+LUJiqIcLnRoaYkPoyVW3CzSf4ZGt8V9GDsQ0azcr
         0q/Jwu3J3wF2g7m3k35mRw7VZUB++LDmJEV1UBwqsaX21hgfMw7ZAd783YB8xo9cEsdM
         xqBT1PUj34rHbgDONcgXz65BQUNilnD5jZoMNoKyRdbcH/WeeziRCa2dcCcebcUFsuQ5
         KvbU2CsoJvf+PG8IJ6g4QLcS32sazzcyIJfgdzIT0xKtcbvmiiXjeEUOVSdzxgtbo1yr
         27vw==
X-Forwarded-Encrypted: i=1; AJvYcCXR+8nyp+2KFS6jPteL1L1HZL4S0zI+wt9yrIPiTCb7maJ5xoIPF5Z9s+eLaZf24Ywek0KooU6r@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9P4pHlzJiy+/Wg3xjFPR2wh0CUwGQKz+jLUr96X/OI/SwYw0C
	jFdKtwQ5Q5Q4RZgQsTXK6wXOTAhDC5HBxCb8brc5inHW38CJeEk5s89qPRaS7WBQ0wKrdXMQc7S
	tbbKzxADL4ZIyOI5/AZe0iHMHW91RK4WU7lymrQ==
X-Google-Smtp-Source: AGHT+IHrJ/aX5w3TTLreZp6GtZMKWertuN3NS+/aHPuhBEZcF46fPwpckAVPGWcEarhi0ktZEoS0MirMF2O/RFaYqgQ=
X-Received: by 2002:a05:6102:cc9:b0:48f:447d:7915 with SMTP id
 ada2fe7eead31-4a2d7f48a84mr4704207137.15.1727527185128; Sat, 28 Sep 2024
 05:39:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240927121719.897851549@linuxfoundation.org>
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 28 Sep 2024 18:09:33 +0530
Message-ID: <CA+G9fYs9Z-yukxgVCVwgOKM0Q0N0hZecqYhWb9BNsrzeU8NxHQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/73] 6.1.112-rc1 review
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

On Fri, 27 Sept 2024 at 18:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.112 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.112-rc1.gz
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
* kernel: 6.1.112-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 4f910bc2b928f935a8a8203ccfa7be8456ac8f29
* git describe: v6.1.110-137-g4f910bc2b928
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
10-137-g4f910bc2b928

## Test Regressions (compared to v6.1.110-64-gdc7da8d6f263)

## Metric Regressions (compared to v6.1.110-64-gdc7da8d6f263)

## Test Fixes (compared to v6.1.110-64-gdc7da8d6f263)

## Metric Fixes (compared to v6.1.110-64-gdc7da8d6f263)

## Test result summary
total: 146051, pass: 125727, fail: 2019, skip: 18116, xfail: 189

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 7 total, 7 passed, 0 failed
* s390: 14 total, 14 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* kselftest-kcmp
* kselftest-kvm
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
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
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
