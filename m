Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F041CF7AA
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 07:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729065576; cv=none; b=N7LKFhnLUu0WJ8yrIzAw7UEaS8IvPIVdgEPTnBXQGseP0z5AvQ9aoOtAN8aU8KJpfBgKgeGJoPjYfUXFhaOEYyhBxwo+D0XyUGkO9aeEjk+nWwXfkn249U9Ve0bLxAE9yMdTYLwaPumKCuJ7P+gFbiAdFs7nP/lTRSD4WqFWyvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729065576; c=relaxed/simple;
	bh=/BiKXgb/ifi8dpicYpJPPROj1PZWiwo5txuUrOXm8tY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lRIc3qm8pZAr2kT1UlvU85jrp2phWia3nDece6gFvHWhObgEzC1mhHqbeqKeauoQdkvXtOAzNXTsInp9Pc42WN5dGhmzXbBqQk+Sww9gWckmATankYL6B95ssyKZYnYS+6V0P4z6oc8XBWSiLQHGuxU+EwTYje7o10LyCWsb8yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eP5nx9sh; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eP5nx9sh"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-50d57c109d5so773619e0c.2
        for <patches@lists.linux.dev>; Wed, 16 Oct 2024 00:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729065573; x=1729670373; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GvCnBTztCAnhD2mHou1d1ZIRw6cIuOdYGceF0zdZt5Q=;
        b=eP5nx9sh0WOJuK8Umfl1R3y1bwCQ7o/OgOTVIkicZKqK83sn7gJLLl5OQE72g+9+Y3
         9jbOhGEVdRKBqk5OR+5Bg8FFEcEt/DK7VNfvg6O16LSDDkODXdbV2SwRyDhegUY/QT03
         Fy2/jMw6KTMYqkpH/feBScfhvhvmKts9cXbDeFTkNcfeck60/rA1UkOLdLHsQD8ObZcP
         /OyVkU9+LxxlS5G9ss/A5jM3JRx1dApIfAPxdVDXr+bZTXdA2+T/33Eb1GQn9GGVWuaJ
         r0yKtyK/JKZZRe+sNQiA3kM+//W3KI5XmgM5vS0eH/IaQhoaHpgpbPqIohCLDFYOvhuJ
         PJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729065573; x=1729670373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GvCnBTztCAnhD2mHou1d1ZIRw6cIuOdYGceF0zdZt5Q=;
        b=pJOkqt+nJLUNzhqVEzc0+74HyJE4L5X8xr/T4Wy40XXdr01CkcN0r5xMNWrvn1/jKr
         D2G9/4lM2YALzm6SXC8QXlw/lKdSXfwq9gE/HIovtvz8b/Qd3gtVIhuYEJOxHyKBScvK
         znxj8j9I9OnVaEwkXBiD67Jp/XFstW1RhOsJnYcX78ml/49m3RTab4aZ7auer8wIVAF8
         l4mn8gqaR9lm5tS591dLvhUkRZx5qoDyxiJCQap761CT3bxpbzQst0yOCWzAMDYLHiVl
         lYrGiUDsmR8vvcx82bILy0rPXRXCHuvnbb4IXKTYhwLxRVAQmHJI/mXsR1SCwKimXzaT
         +Iyw==
X-Forwarded-Encrypted: i=1; AJvYcCX+Z8WEeZ/Ug3tNiOQ65ZsqzssPBhRp+Zt1DCkEAK+28i3Ifg3Loin2ktUU2iFqtuFoZhlKn7xs@lists.linux.dev
X-Gm-Message-State: AOJu0YxWFPBAvPOGuKQ4wItbazv1a1ZISOD4pBDSnZd91ktkyZ6Cg9XW
	0ZKV6QobE9rZo9ULrgdymlsHoLt+eIEDZj0U9w42oUOguyEYpybFqoIavA3Hlh1/SCGsaIJk+Ia
	EWEVkF3FJf3niUXZUaNAiExQ1aFex3VlaRvPjsw==
X-Google-Smtp-Source: AGHT+IG4hpwFBZCh4eDUtnLHfS4is5WIEfhKJ8QttRME4agWUgCKIL3gqQiAFbfsookdZ7aXIpHbJF73RL1Vb4bfH5Q=
X-Received: by 2002:a05:6122:1acc:b0:4f5:22cc:71b9 with SMTP id
 71dfb90a1353d-50d374b96e2mr8280137e0c.5.1729065573128; Wed, 16 Oct 2024
 00:59:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241015112327.341300635@linuxfoundation.org>
In-Reply-To: <20241015112327.341300635@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 16 Oct 2024 13:29:22 +0530
Message-ID: <CA+G9fYtmRGt9pXfRk=Bfnac7gbotdw8PcEsSOmD0nUefYHuBpQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/211] 6.6.57-rc2 review
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

On Tue, 15 Oct 2024 at 16:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.57 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.57-rc2.gz
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
* kernel: 6.6.57-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: a3810192966c3144d8cf988e8a13fc18a2dde677
* git describe: v6.6.56-212-ga3810192966c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.5=
6-212-ga3810192966c

## Test Regressions (compared to v6.6.54-387-g75430d7252ba)

## Metric Regressions (compared to v6.6.54-387-g75430d7252ba)

## Test Fixes (compared to v6.6.54-387-g75430d7252ba)

## Metric Fixes (compared to v6.6.54-387-g75430d7252ba)

## Test result summary
total: 161514, pass: 133557, fail: 1868, skip: 25978, xfail: 111

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 19 total, 19 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
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
