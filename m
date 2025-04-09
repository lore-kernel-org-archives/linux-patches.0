Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6416C25C6FA
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 09:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744192265; cv=none; b=Jw/kIqVCRB0o5PwH0c6vrNSJWzwjWINQOPIazx9lpNrFV9RzjVwgyKWE0G5d+hhtWzhAGOPh5Il1MF5PM+KSXgfRUE6bmQXq4XVTZ5yfk9+twJkDBfYXU2LoRiZH1LdjsshwUhQMNgwSQHslexk5iN0crcCLzQH6v/dFuOyTM+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744192265; c=relaxed/simple;
	bh=DpUkIKGDpIBV3cYAXbEup5OjKbfXtLEX/LwSCYEclE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=thcQ18uOVIkmiRmdeA17XIhGWsDleNbeNvNYADLMMr3q6EHfMOQbol0vcNqcjbL82vo118NZm7kqyf8QHJwUdF6g2RFNcWSlGkn5FbRJcbgXoKjGlEUoVWNgByMFKjApvAE7viLmiX+kjzza6v017BRy6U5WLo4XLk7Fv9x4gZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f65uHJHK; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f65uHJHK"
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-86b9b1def28so6035653241.3
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 02:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744192260; x=1744797060; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1njNObE6GIJqOAUn6DtRc5r3V4Q5XV6eVkgK12erEv4=;
        b=f65uHJHKhmNkH150WrIwEwV5qqgqf/JG7HKep87vCr0YbenK7MKwG51QGHpB/4A6F+
         WBzu+VKapyebS9ojDnit8fCg7USLQl1GtbBoltwTHqtMrJ4a8UBS/czBssS0Ftl74b0R
         ni3m2B/BIxUTfKog/df3wDDijavG8FlP/H3dLQY3usol9ulDWl98GTIkDIKqf+zxUcCp
         opEznQey0tM4I0rvmQqJFTQCiOfudakVxZZD1+OyvjF+Jdhi4lz/0N+4XJVG2dqKPSyu
         cOWmPlL6Xu5cA/5GRbuT3e9Kn/Okx4iuLfBmzFYI8qM19hLwPj1l0THbhJXV7n9x8Ooj
         EXsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744192260; x=1744797060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1njNObE6GIJqOAUn6DtRc5r3V4Q5XV6eVkgK12erEv4=;
        b=o+RY6Pv0z6gCrOvZ7lCjML7dm5kBT571FyXyuiyJh9unEP/OFwLhJJ6d1oVjbvZEo+
         YHRzGl5aajgROpvsNpgHgJgNdUpP88H4RyhnM89yRSgMiof85AyU+Oi8VJ/HcA0vCDgp
         5vijaCngJWwlcJzN7LqAWgriU3qBznh+bWWjwbkulYkx3brW3nOS/K0/g5yfuo9o9JCz
         XNmMeBbwV0sJhWL6dTZ/gsjK05JXqlWeeW5L2mZITXWkjc6ShIIh4+ChrwBbKZEEDwKC
         VrQ6GkXMY3/GbeTkNeIQxbWt2DFO0BgWgQIDqfS+AFZMn7INbWopY2lBhrHvhGRtxjw8
         b/Tw==
X-Forwarded-Encrypted: i=1; AJvYcCW55d1BqAhK/pgqnLlQt28iTWf5tbYsGenJDY4XKvLeKHgDHyPWYGRIyj794jS31YgMre4ulWBM@lists.linux.dev
X-Gm-Message-State: AOJu0YzXClzj4BmRZR4EbSCumFXZsxU5TZlNEV2YFEdFBDlzQWwlodT2
	wq/Rkb4ORWCXw0ZG9M2gWc8M2++tqqL5IoTIlk2i0WKET/KuOCw1wrM4C2C7hLPpB1OHjjdQjD6
	dEjv9W5rlf8jDfc8E+5jmN1BjXkafxnmMmt4aWOw5lyJKXu9OsUE=
X-Gm-Gg: ASbGncvFrbqDiCMDMgX1KHac0KI1Mf82n0i32ZjmulvRHWRzC6XcvLsn0fFZLBaQ/O9
	jjjrXAmjSEK/CfUxlYfQvI1vjiM2kIZlaNId/UxUrZJ0BPqQnJVgH7J9a4EmTeAlPWpIkQZlYx3
	X5PCA0JUy873Y0zdo/i1zzaZ1g4vE2TJTfTXUP83ms4VFrh4QLLH5v6ck=
X-Google-Smtp-Source: AGHT+IHsG0WKPLT9y5IYgBaUgVr1z4LIH9R6xpKkJTuJ5byGHhHn7WE9slVfaWZ/SR14YCSc7WcOvPakH+olVCjROHA=
X-Received: by 2002:a05:6102:570f:b0:4bb:e80b:473d with SMTP id
 ada2fe7eead31-4c9c41848f6mr1465104137.6.1744192260230; Wed, 09 Apr 2025
 02:51:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408104820.353768086@linuxfoundation.org>
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Apr 2025 15:20:48 +0530
X-Gm-Features: ATxdqUHXBcjtcqSTk0bz5Hn75TBoEbSUnr0VzKiWJ8WGDtcsvBL0fc7wW3KoqtA
Message-ID: <CA+G9fYty2+wHZUUVBWposQB1uDV+Z-b3+5HgsJP-a=z3pjEseQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/227] 5.10.236-rc1 review
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

On Tue, 8 Apr 2025 at 16:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.236 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.236-rc1.gz
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
* kernel: 5.10.236-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 327fc1af5609fca2b091894de2ee904fa6391306
* git describe: v5.10.235-228-g327fc1af5609
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.235-228-g327fc1af5609

## Test Regressions (compared to v5.10.234-463-g92c950d96187)

## Metric Regressions (compared to v5.10.234-463-g92c950d96187)

## Test Fixes (compared to v5.10.234-463-g92c950d96187)

## Metric Fixes (compared to v5.10.234-463-g92c950d96187)

## Test result summary
total: 39096, pass: 26647, fail: 2806, skip: 9346, xfail: 297

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 30 total, 30 passed, 0 failed
* i386: 22 total, 22 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 21 total, 21 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* boot
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
