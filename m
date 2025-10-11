Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11403595B
	for <patches@lists.linux.dev>; Sat, 11 Oct 2025 08:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760172003; cv=none; b=o4jrSqxReNKGUwSXNDuZHKE+I8t+whNSzdutHrRm0H5/pyKsCFkpmBifSs9llLU7sVplD/yl3utyhTI8DM+V1/4tXe9PTQR2Mq++E8XN7kyRkylEjJwku2K96YDq4n91K+1wMVgpRgxVxJa7Y+BFWlYqnNBnMwIuVotMjxwN+F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760172003; c=relaxed/simple;
	bh=swXtNkDF0FL3cU8HnGgzyI0EVBiiiSrQRFIrdvPgPTE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sJXDLjYSxYc/YWyWt3Sv+NTri4dNCxAC8HkG3RzwS73cj2XTLt9rY6xOkGiQIOjnNY1K/vT/lUEU3wMF0p7qIeDDuoCEmBc594YUHS93UIwg7ow6HfnQVcc2Yl8auLrbcB+Av3ZLiU+k96R27VydlnUZMy1+FtCx/u4drryBRCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eJJV5Hpt; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eJJV5Hpt"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-28e8c5d64d8so26544745ad.1
        for <patches@lists.linux.dev>; Sat, 11 Oct 2025 01:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760171996; x=1760776796; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sVXSsfvT0etGlmUWNsUkD8HWlAPhEcr1Pl7r8v1EiJ4=;
        b=eJJV5Hpt46hQWa9NFK5z2Dv8WCALYKXuR8iwV/wJJ5x1GUk2GwRvps5ARWrUYkz1CH
         lFHP3pEZJuDbETurHr0OsD7r33hWg4rE497QkFnL1hGnUl4EITTR+ukwIIzB9XbSNrTa
         cUmbFmbX6AM8VfW/chdBO//BqyWplGVQYL4tOBMMOVfZKRgCZU+pDgxuIkUJcqdIJlAx
         4Fog0ag03dRecJs+TuAVdy9oQBYk09+kSKu0vlGZYOXvYsC4lYjl/kMa5IohQzFZjX6i
         QutkYvLN2JqznS+gB0khGRfmeq9CepvKn5zgqxYLUq4sxXzqNxX/YKX/kYaAu1VI3PA7
         iY+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760171996; x=1760776796;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sVXSsfvT0etGlmUWNsUkD8HWlAPhEcr1Pl7r8v1EiJ4=;
        b=B0WOMsxvmzBLMXkzlsDwTnHuv4cJPwylP5iem0KSRt5hsA5o3Cax8SFeWzk+YONN9F
         +/XRr39w9fsLbQKMqrQhbRrS3ASPiH3bQVNWxrtD3W2Fv9Kffhg0bQoxyX8OJtWPqbtV
         sjEgauNSWr/lA4lKrRAiq63Yn2UNy1yC5fAT5JRrP/6X+Z3G752IsxKEo7rzYnu77HAQ
         3eJOJlu6M8wHM1AKAPYRvPV16s/9yoES7ECNxbibMV6KUTyiIexO0+WRrERrJeQeio5N
         fk6vk2+QlThBci9G/3ZhYOr1iALntxQznvBv+HXQF8ydkyVssihg+emUig2+uA4Ac1GA
         ZL4A==
X-Forwarded-Encrypted: i=1; AJvYcCUys4RlHndAITx6FpbfUBVGq8g651ouJ1NbUTHoCCQ4qcswcOfAgj3tw9yi7ZE5PEgUJ/d3QDqj@lists.linux.dev
X-Gm-Message-State: AOJu0YyHOHzArky0SjZQzEUqbBa3497zWAjjKc7hQulgwVzewGoYSwwk
	y5GT4/fvZA7jXiW8eGAHd/WkwYBOLRgcxoht4la3i/zj/DVbEUzNxTRcKu1lfiO2F2rh1eTDUry
	HenBdJrV2tZqqsgcPanM0JIn81Vp9ied4M7xGQtIwvQ==
X-Gm-Gg: ASbGncu1o27xOqHXYido84pP5oa7suaLYanhbIfpR1AX8x8krvVDlBXKfY8FsnQV3Pb
	0Axztj9AJxiRFDm2KRpkNDtByaPEGOJj8+bek1mwgZ4jnVqxghx4ti6YEp2D/PzkmmyNqXSDqWP
	WPxo7sCzs84sDX9AfrzX87Um5NrInhDHlHWxXGD/djhhWJmE7gWnqNW2urxXqsbF+X1aMSUQKQQ
	fQT35Ws/c8CZ0OYPfsceC3cUqVMpze7YWTMzGTIiFbfI2AulzCD4N2jJItRkMJM3XRaQ8PyegS+
	afInxcz+5Ob06PrhS7OdWJdYSvrf
X-Google-Smtp-Source: AGHT+IEWSSNNR67J2Tri1k5iIkSgRur7iBrdXo0jF5zYqoAUkAI0CEF7pto+xF3B6vHgeUJ+4fZofUvRANEko+90ns0=
X-Received: by 2002:a17:903:b4e:b0:28e:acf2:a782 with SMTP id
 d9443c01a7336-290273edf3amr155968555ad.37.1760171996152; Sat, 11 Oct 2025
 01:39:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251010131331.204964167@linuxfoundation.org>
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 11 Oct 2025 14:09:44 +0530
X-Gm-Features: AS18NWD-nh6ACoVYAo2FqFeMvXPVdFpklauhx_xomL920GlPKUaJYF10ev9HgC0
Message-ID: <CA+G9fYuMpQ1bskoCuteZYUTgMyDVo5EFRePDyQov77UEvURYUA@mail.gmail.com>
Subject: Re: [PATCH 6.17 00/26] 6.17.2-rc1 review
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

On Fri, 10 Oct 2025 at 18:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.2 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.17.2-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 8902adbbfd36cec55ff7b00116d287c06bda347c
* git describe: v6.17-43-g8902adbbfd36
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.17.y/build/v6.17=
-43-g8902adbbfd36

## Test Regressions (compared to v6.17-16-ge7da5b86b53d)

## Metric Regressions (compared to v6.17-16-ge7da5b86b53d)

## Test Fixes (compared to v6.17-16-ge7da5b86b53d)

## Metric Fixes (compared to v6.17-16-ge7da5b86b53d)

## Test result summary
total: 164414, pass: 138312, fail: 4644, skip: 21458, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 50 passed, 7 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 23 passed, 2 failed
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
