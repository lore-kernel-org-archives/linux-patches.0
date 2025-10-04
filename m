Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BACF26E143
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 12:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759580039; cv=none; b=Vh8RMq64Xu3kpdUzsOq14o6JkDDEQfvepbFZ+rJ/xTIFCyroV3JXrsefMDLyLzXj2BezvNhcLWf3EsoyzjmiqUWhUg3BLOrJf/TvnuaX61TSU7RJe9wK35PRcemm/Skx/4k/31QrH9EQMA6WaIiYboCFucIPu2R36xGM4iLjABU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759580039; c=relaxed/simple;
	bh=XQxVEshz28IKhO0p+ZQMpTW7xOSwxxB1o6rEgJHFH6w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ti8L9W4EN07XfUiqjKuKcu9LuiZQ8hxx2BLIDeDlxqVxYqJhSCCHF0oBu4ea+h2KXgCxmmsjpFqlE4mgj7wOi/EY2i/h/2ByWQIGHVkd8lQziPtQDeBayt59wtd9rTPr4rsVcVomzj/BgMI1CpgXua1xPaKH0CeQPTK6fhhsVq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fIXfo4Be; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fIXfo4Be"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-27c369f8986so31770335ad.3
        for <patches@lists.linux.dev>; Sat, 04 Oct 2025 05:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759580037; x=1760184837; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dhEvWiXk60BQY92FOylfO8eNaNBD8kDsdejX07MfHU4=;
        b=fIXfo4BeBu8gCV7uU97vnOXk6cpMb4J82rm7W/aW3JVNh2mAbL32Jau2+J/1TOAoza
         hH3M/vzI9vyvIy7JDAgO3gQI7BiGFHZbwO/bOBrpageTCtQJlKgUwZSOdL5BV32Mp9H/
         9CCzXthQfupxXZ0vL2oeTgObnScfx0Cr30ufCSv/QE6xH5FI+ZB0OCc/xIXGNQrIQqLa
         kiF0JKBXIEU7J5oe/Fa0Sc9AKdDPzquUCdmHB/PWc/+zvuDNve0ggWMW7dxDBnYb1G9P
         k6pJGg31x+7XvOOhLog+u0jqr5t6qqB85ZrSlqHKaYJ60LlMzAtoB7vgnw3gRejITyWA
         1Ufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759580037; x=1760184837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dhEvWiXk60BQY92FOylfO8eNaNBD8kDsdejX07MfHU4=;
        b=UwbOA8mv8JB5uXGbQK0Fd8DMSA/2SKFhnQqkmgukeGzZoR4vR7y9CEd2LlLgSQcKl6
         Ngp+JqvBpJnHZSQsm9vHcAXxJ0C1JYEEJIokuRo8wp09H6j8l/spIaFUYpvvO+vBO32h
         Kh17G6+pfDasb8LWnx7aVWfuvm2wtR2buxrcsx99IcvNcUS2kQPY2kiexAIlZu+nmDMC
         5MBInGTMrfLSr4ndB7Z0r7nKPxckRoiAGhlZAN1ypm67tAjr86mFJ3AtWeheZa2pvlM7
         4PY2GVr2OHUStU1rKlkYcLX75hYY6ue8lkCA/da5fUS4/Kqpr3YcoTRwC0TQ+8NN7ot9
         bItA==
X-Forwarded-Encrypted: i=1; AJvYcCVjl+5LKv1ObD/xNrGorL2Ashyd88uT/oBqyw1XTTzAGyxsWDKyZerRTmImyKpIV9kDLROUjmMQ@lists.linux.dev
X-Gm-Message-State: AOJu0YxyTB8kXz55abFyfHtjzTv7mvHj0GJ/vKfIDUInzXE4a6FXwDtv
	oexfnb4Hv44Ej4/qC46xUdtwe15c6xjGShUqxn2Wtkk24pLKRcvW+iVO6uNhdk1EUsP83gu4czy
	UyDe/IsA+31SD9hXSqO+AnHdxN5C4TN2vRV4gv6UFGg==
X-Gm-Gg: ASbGnctT0vmT4XvqLM/gJf/QtIxI63Ma6lLARtswztpxlIzl2Wi37PHuwpwHhoRDEts
	BrK4WRMBUbKpPtk8D7Rq7uTXn2YQOch0/RAr2LfYYRWqVWtM84YFqUsYc3u1YB4/DWAqK22G++d
	PXpypcxxsHeVL13o5B2iyRm70nHv7r2Ueth1x/CyPxHx9RygPCYJPvd7XtRzSbVGDbNy/pRpsex
	HQXZ6TC8mMgvVzfbODmR7I9bV8S9Q0tFQhRM7n+I+Q++8uoFk3uDbW+9eXipWd4W73DzmZHtH/o
	R9jyVgt4vDlsVAXLLZLzHvjPWvqMic+jjFc=
X-Google-Smtp-Source: AGHT+IE9EcSqKs9pW7HpnTAx+2XrLnXQii3siZ9Bu3lX8wr5mdTW4z/DbBU7rWeDupsrW/IY1PfSanz3+PPWrpWVzrM=
X-Received: by 2002:a17:903:234b:b0:275:1833:96e5 with SMTP id
 d9443c01a7336-28e9a5beed8mr79039585ad.24.1759580036770; Sat, 04 Oct 2025
 05:13:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251003160338.463688162@linuxfoundation.org>
In-Reply-To: <20251003160338.463688162@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 4 Oct 2025 17:43:45 +0530
X-Gm-Features: AS18NWDKQHmwVr2XeBE_n915Zz4jcEjLc8nkYxw_IvMT8WzsEY2RMYkVEVebbNo
Message-ID: <CA+G9fYsjU1tMnt3E055cBCzA_wk3H7LHa=Qy5Kat05xAJFgD2w@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/10] 6.12.51-rc1 review
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

On Fri, 3 Oct 2025 at 21:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.51 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.51-rc1.gz
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
* kernel: 6.12.51-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 791ab27b9c005e9996ed4ff5785a84890ea86f8b
* git describe: v6.12.50-11-g791ab27b9c00
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.50-11-g791ab27b9c00

## Test Regressions (compared to v6.12.49-90-g8e6ad214c7b3)

## Metric Regressions (compared to v6.12.49-90-g8e6ad214c7b3)

## Test Fixes (compared to v6.12.49-90-g8e6ad214c7b3)

## Metric Fixes (compared to v6.12.49-90-g8e6ad214c7b3)

## Test result summary
total: 156220, pass: 132956, fail: 4989, skip: 17711, xfail: 564

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
