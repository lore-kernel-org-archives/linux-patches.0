Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF24307ADA
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 11:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757417623; cv=none; b=ee2ka9gCXCD/5TBnNomaS+Ksbal2ChI3yHmnOO1Xuxpq824PKSXnp1CZbYCOaZ7nhPX9v7vDVziUawtv/C2RXUzzupXhiaVyrazdubY4mLqv9sJvNSlm2++8TW5mn5mv6gOrGTkqodQTQw9qbL3S4uYoxg/1Mr5hxNRHmp/I2MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757417623; c=relaxed/simple;
	bh=9ZJyGW+bKC49GMc9FTX6kKd4h6DpRua6megBj5FtP04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mYOAxqr9KrBGCNlP+bvYyt2vWJJJ1mAEyHXS+84m0S72OgskDde0PJbJqoqGzmPzaSnCh2FkJjGbMCeB2WpQRiROkJbejChASfNu6eVY3GZZnC8PgsTMky27KewcK0ZNRD91wJdU6Zf/lj9YWl1pG24yNeY1KjWoT2BTv0VDbGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aqNLhIlV; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aqNLhIlV"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-32b6108f2d5so3942814a91.3
        for <patches@lists.linux.dev>; Tue, 09 Sep 2025 04:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757417619; x=1758022419; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wSFBZiOEQknXVMGBu4TMhR48FYYjHkmMkzk1O8AklF0=;
        b=aqNLhIlVQ0AX7XTl4hTZWFcWY7XJHYh4Oj8YfuReJGNXvGRWlhaOm+q+lC6HTm3Sje
         3Tygm6rFjC4Xf7Vh+OjiDsfNY9x/jP3/xNh07UkYS7h7B8qblmzNobBkQCwWs5CXvGas
         0YfzKO9Al9eyg1zFpsmskX6fGsq7fYhScQLyV4nd0W+U9h5dbZmKSmXGeMTcAsiUXBml
         eUIpwe0pbB7L6VAIGnw2YBIism+s0dy4OgjjxDr4AHH98IIea7Kb9xnNBEONtiIh/pm2
         3GbZ1EyRMQN4kjsWnY9VMavB1T5v4Qdv5eBZFgyaCXyUpXn3Kgwh9rwlKkil4vbA3xWz
         E/hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757417619; x=1758022419;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wSFBZiOEQknXVMGBu4TMhR48FYYjHkmMkzk1O8AklF0=;
        b=n+vEF8/LUHQFCl1ynAHv/GF4cxwwuoEpZ/W2mmEos7kafbJmgYIMIX7fa9lj9n6Yol
         ae4I8hmKCChuMMW6stYIkXkhC/+FnkfkLVzYYjttq8szLX8PDhS3l/N7OYMo7ZmlZhKW
         L8BdECeGdlvZ6YdO3aA5l9WPxfArQYW0GAuF29TqBKTAMltp/abIMXJJyykWF4feTkwM
         x48vr4MH411671IPrYU1d6GZ0bKCfpikuG0R+m/KTL2SFFXMkbyk8SmrLm9XmOGaG/oT
         U/eKnICarHehosvSi9mRyJ7qUQsPkcCXyFfieZSmDjH/NpOpvcxixwFB4cApHsKjlGEV
         t8SA==
X-Forwarded-Encrypted: i=1; AJvYcCU5b/KDJjV6qmEV3aT8FKEIVCJExlT5SQZXFjDYsPpTwOwSY4ceKYFyTrbmTNssVrx+nnhBcapb@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4QhPhj9fQOAQPAxsKyjiEXKja6orBaBR3Kj5rLJ2l6xxI+Yk7
	BoSzwSF4tOA2GGirU4TS6LCIhoYuy4XDjakDIHHhHf7rk/TmxZcFVCUxhp1YjE33oCaEzEgLXra
	vSOMxWi5kCmoKkRlmiwJ14ZuxKKXktE6MxpmlkhmVlQ==
X-Gm-Gg: ASbGncsQqe71EQQucJi4zhizKRnYliNmlOYKuDgWhraqcYYRf9un8UUEsVO7YkiphBR
	uYeDfW4ToD1JfBukpdHvUroV5FPhO/+V11dsKZU6Dx1HvkTWMPL9JJkfPihwkoRLQbZJ8FwIZRR
	P7nN2yrzABuT5WpYBH2HhhA4mCffz7ksFpiFbX3k9BrLu9yKGpsUaTkTE0bkSNTb+S0JZAk1TGs
	SZq2+KFKNKKdV+hT8g1s0lcTmXVYulS1IWKAkTanqqy9GpjdpwKdcPLwo5ghVqYq752MZmL3H5G
	1VdMknw=
X-Google-Smtp-Source: AGHT+IGGzAvVlQufG8KDouT3ADlykkEvkBvNGNZ0I5t8cAtFbJmawZEfYX0IP2i5/0oE+b08v9jB58colTYmLhLGcjU=
X-Received: by 2002:a17:90b:1fc4:b0:32b:ca6f:122d with SMTP id
 98e67ed59e1d1-32d43f825camr13296443a91.25.1757417619366; Tue, 09 Sep 2025
 04:33:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250907195614.892725141@linuxfoundation.org>
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 9 Sep 2025 17:03:27 +0530
X-Gm-Features: AS18NWA8U4mOQRqghtsMgzHRkSzb0GhoojrF8eMm9b0-1tUEHAsdjmOFmCsN3XM
Message-ID: <CA+G9fYtDP_haVwEOz56WHLZm2svRXA9cs7DPHsZ9SQF-sViYow@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/175] 6.12.46-rc1 review
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

On Mon, 8 Sept 2025 at 01:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.46 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.46-rc1.gz
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
* kernel: 6.12.46-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: c208f589048822e3898fbeda8f5d25df2d3aa413
* git describe: v6.12.44-272-gc208f5890488
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.44-272-gc208f5890488

## Test Regressions (compared to v6.12.44-96-g4459b7afd68d)

## Metric Regressions (compared to v6.12.44-96-g4459b7afd68d)

## Test Fixes (compared to v6.12.44-96-g4459b7afd68d)

## Metric Fixes (compared to v6.12.44-96-g4459b7afd68d)

## Test result summary
total: 332773, pass: 307187, fail: 6893, skip: 18162, xfail: 531

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 22 passed, 3 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 48 passed, 1 failed

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
