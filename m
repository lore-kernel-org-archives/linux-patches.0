Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CC61F5EA
	for <patches@lists.linux.dev>; Wed, 20 Aug 2025 10:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755686613; cv=none; b=hB6jGv7bP3BPQF4DMU4c50276CScc8ABAcr229ielKl2XbZEk0YsOlG5PjYdJNeYAYXF+1K28LqvNDjueCHgDxj6kR1o1TFi0mJq0N7zIKS01RvqTdQ69KdCHdDVL8gvqDtNz0nbLiVEzDx3yVwJhC1ocbbR0tVMbanIspt1D/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755686613; c=relaxed/simple;
	bh=uVpcSCB5mtAaK6aCWFyWWs7ICZDA2hsY1/QCUgHENGk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S957K/bu8w59OLZ8N8llGk7FdEfHcDLcMzNjRrsd7pxMcDG9zDG//2r6S1g0CsL15GsIAxJehib2B17O8beXQ1qYK3rT2MjNAnO9U+BZqnW7ULu01NyZVaJRstyWEuTNbN2XLPf76YtEtLoyOuBHr0E+sL/JE4trK0gfo4tEweA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MhPEfEr5; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MhPEfEr5"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-24456f3f669so9263065ad.1
        for <patches@lists.linux.dev>; Wed, 20 Aug 2025 03:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755686611; x=1756291411; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lk/vtWnmqYeXCudIPf+xoX46PWcEg0mYxFLpg6PHTfg=;
        b=MhPEfEr5cCej8tMk5CWsHKVrhQEkKDwXvq/SmuOJk1pKk7pcyktJreH9QoRuHMrutD
         iI4z9txvYaGp7E+auYtURAk4rSsVH+843brXkt58lrSOmB4kCmALinQm/L0UiisUL5gW
         lnCIfoV/cATu6sicYMcHeB/rb8P/1ZN7zFERDtlNgrGsPnYFrptfio3DrjZd1Ax4Cjh+
         EH/FFfiB9lz+B19MFGHH1RaTYqJuP6AKlmqooOMDBySd2ugBJ8IHScOo2zunHmc+2DON
         OlfQFKlMEoxbWAVqeSkqXL0aL1Jq+Cmqi9AZPPMkOtT1RFz+MaGw8gR877t/L8jcao5J
         M6cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755686611; x=1756291411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lk/vtWnmqYeXCudIPf+xoX46PWcEg0mYxFLpg6PHTfg=;
        b=VqxwWFN4eTuT7u15VcklxqkVi4QTZoaJM+uKjBzET23CgTV952ds5bbX6dPlUDWO0e
         EQ1oukHJZJvXsNH++uFdQ0BiiwjKHC+j5/i9lhNfU5QVF3Zn/XYB4gDyIogW5BKbXihf
         g//IIAqkyrrZJQjB1sgtxd/7jaT3xgpmFXOvLSNFY+wKQo0/AmFmeW/QASqFAUdNPNQl
         eJmdW0KTptZrtQf4jdeRtrrnpLYigKdhJdiVz5WOeTYyUjCZbQ6ZPhqBTu+8sOqgA+PC
         B3ZRr3qEO2cT5/q1YiJ7Hj3wY0giMTP6KsB8XxaugXz/NR5qEF5szfP3davjmJ08ln7X
         4xKg==
X-Forwarded-Encrypted: i=1; AJvYcCU1lXECjvjf+9XDDwBdIf+CKlf/8ni6Gz9IzPikWyJxoBDUgxWF092oIFtzdDV04HevQsMiQnBS@lists.linux.dev
X-Gm-Message-State: AOJu0YwKmA505bhLS1viGD9t5hH+1Ka/miYV2BZOE45nBBwVMMCAt/vY
	h/He8HfDpFiB7B0lpAyHQma/4acGQr1zaLX+vAxjNKwjlEJbUedXVvx2ajOYtCPz97tVKBQ9oWd
	20BskwgzVKlimbFbDo7u5hqnU09kIbDIQOpLpG3r/cg==
X-Gm-Gg: ASbGncscTgU75+WRdRUcPwdXE0mlaQ9mWiEAOcpjgz8cJdwW5diLj4GmrI0LM4prBH4
	eRJEgNMGQ3nom5uTSNdW9UdVqe1GHVtwbxdvb9+cF6UcEtoyWl8Ezw+j1r4zVi6wVB7QxQ0L2Lp
	75O4bmRS9Wz9IF1Cim80WA+YIbwNxGaiMyS+Mm0gdkh/16guGeUK01XOXIIFYvI05uv+eiJESS6
	APL9PTqTYxZzwHqhfzL68Ifc8Y0vYhvw5+TggKe5IO9ju2Hd6M=
X-Google-Smtp-Source: AGHT+IFwrsubzwYy6OCz71QSPoYRUwgOCZIF012RxCruCEQL3nCCwcumSkjdOdE86Hy8RNzNzoY+6hhO68xb0y33ijc=
X-Received: by 2002:a17:902:da85:b0:235:f091:11e5 with SMTP id
 d9443c01a7336-245ee010a57mr36015605ad.10.1755686611227; Wed, 20 Aug 2025
 03:43:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250819122844.483737955@linuxfoundation.org>
In-Reply-To: <20250819122844.483737955@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 20 Aug 2025 16:13:19 +0530
X-Gm-Features: Ac12FXyXjg44pYVkVc6KmflacKpBYZDwKjup2B-GNdc5o1-6kkVWh646JGrHJBE
Message-ID: <CA+G9fYuxaTeCD9ftGZ=MJVSoH-OY+pHx6XS8aXGhvySfT3V3TA@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/564] 6.16.2-rc2 review
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

On Tue, 19 Aug 2025 at 18:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.2 release.
> There are 564 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 21 Aug 2025 12:27:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.2-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.16.2-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: b81166f7d5904b51887cd414c27cc416fba3f215
* git describe: v6.16-1186-gb81166f7d590
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.16.y/build/v6.16=
-1186-gb81166f7d590

## Test Regressions (compared to v6.16-628-gcd8771110407)

## Metric Regressions (compared to v6.16-628-gcd8771110407)

## Test Fixes (compared to v6.16-628-gcd8771110407)

## Metric Fixes (compared to v6.16-628-gcd8771110407)

## Test result summary
total: 329363, pass: 304882, fail: 6396, skip: 18085, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 24 passed, 1 failed
* s390: 22 total, 22 passed, 0 failed
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
