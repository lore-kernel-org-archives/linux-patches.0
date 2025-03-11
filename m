Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25334259C83
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 12:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741695552; cv=none; b=CVcP0QVrKuIy6UdGmS4YJw3ej6Y6onTCY/xmUbmXXB2QMJdn7qOVZGVt55WO7wgYo7SJ94bpezwhsiDJl/vjf5hRNHlOTRhZuWrmOp4tt1o+hjfVvEFIhnY3kiaQvmCXbwBNCEBhgg8nA1XF/iJJDtwMepdjF0QWEH3z5OaK2LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741695552; c=relaxed/simple;
	bh=1OR2ddn1OIKSZBuhlTLk9r24MJQoupMsoAjoOy/4a4Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PPtQyAaQeq4daRoMRfdz4xw6dIVk7pmB6pUOVjnziWkAaiaH5FkFrMmuIc6lSfsI+dY4EAbQ3qDtgUyj96ADtHQq9mLU96WUIzYLUjzxFL7N4HsY7f5NYuohP+Pc+wVQFeNoYbjKBKsWA6T6Xo8JrAst69HDCBwbxJRQldF97pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ntO205KZ; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ntO205KZ"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-520847ad493so4771824e0c.1
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 05:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741695549; x=1742300349; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y+pu4SKQgTYhhnwI1KV/Zn+Ls8AA/0w/uChTjZPaWZ4=;
        b=ntO205KZvrAh0MpoefzIgRgRlJmoaRJPCZYRKaC/xNYMa3q5DqqUQ0e2P05CIEsxZw
         Ro//ZPtnBwZ80QnGiSOB7GS4pYZYbNKszfHQE9IP+yZuT75JTDhXIOxHsItxgY0UaeM+
         4AwJaJ92Wno/AlW6QBtapTEo1l3JqNWESUa7D/xLShDRAgFjzQ/gg9N/fKsWA5CXDgi2
         qVywpEIfK+vrCk6pegUq6RypmV838BvE97Grem5BRw8uWbUMQZfOxKEv+udvhPYZ/lbo
         Pynz8k6eUtUUBMunN9XKv0rfgEIddxPr7lomtbAtpw21fBFoWRsrBwJFkYI3MjlWklgj
         Zh3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741695549; x=1742300349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y+pu4SKQgTYhhnwI1KV/Zn+Ls8AA/0w/uChTjZPaWZ4=;
        b=uiS9hjCKg5JGD42mL4PTo0xtISL6ag0KNMxlNCenG9hXaDKTT/2s9m1rz8txTlyDay
         pM4dGglHKIQ47aHzDiIP7zXgATjFjYz3GUibLcq62XW4fpmNLpjlaymydmPd2D4kpl2i
         LsDGC8ErhBcWaWosRz4jTlv11f/tQoY1Z6fTJ9mFYrTKka6VaO4lq0TIAjfk6va4JJ0x
         nDuym1i2mwJ3twtHTp9r0gvL2lnqCYJIp/Gj72JNS/2zDHcjRJZHFUh9E6F1zuEbiiIC
         oyOz/y6q5slXSXqaMumRzdBNjdS1JJkdl1pYPVi1AZbGegwyswGrJd4WSc/I50yseKhK
         l85g==
X-Forwarded-Encrypted: i=1; AJvYcCVIvtBw7zMgxsgLhQku/QELPAJ72mbz0PeQkgh0WU3AFSuqy7AUiDIm1zlNaeli1aEf8zTmfHrL@lists.linux.dev
X-Gm-Message-State: AOJu0YzmCyobU/G5+k5lJ1Ew5T56ASPa+fV8oJRc54PRQFnLP9u8OL6h
	asT4nciKhwrAOejpOdeI2mV0yffYh7R1nFkm7Q4qF02Jm9cPyYLEG2t/7OkLuEFWaCxich7pU4J
	7YpwVg5X09VITtLa7acQI3+QRV0CcFRIaFHC5TA==
X-Gm-Gg: ASbGncvyAYqWFaBDKH3aeO5y4ZNJYzqGhDRE1OH/HX77OHGP/Kmw8b6yGYJXi8oH62l
	eY5HycetI2l10OLh62F0nYf9PcEI58rcoNJ5hz6pfRptuyM3P+ZaGhvBemm2UNjehVz303DkXsS
	BHiY+nwyO5tVYWBc4cvGi8g+ao1u3l0KgJtSqZtMljHw7w5gdmqM0gefTgFC4=
X-Google-Smtp-Source: AGHT+IH45qk9E8UldXiFsm8nAVB3hcZwGPmx3+QCspv+0WyVSGg/7iMHvqU5qLYxficHb8Ss/KzF6a/WHqkSJz6+F8o=
X-Received: by 2002:a05:6122:468e:b0:520:5a87:66ff with SMTP id
 71dfb90a1353d-524195bb061mr1862180e0c.0.1741695548982; Tue, 11 Mar 2025
 05:19:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250310170457.700086763@linuxfoundation.org>
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 11 Mar 2025 17:48:57 +0530
X-Gm-Features: AQ5f1JqTHciVwmwj3kmllmiGi1ojMeOEj69Bqu4RztEVFb6rtzOUgOeaY70MDqg
Message-ID: <CA+G9fYsKDYoKUWp2BPOLmRL-cpcao=y-vJSU479E+cn_vFAK2Q@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/269] 6.12.19-rc1 review
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

On Mon, 10 Mar 2025 at 22:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.19 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.19-rc1.gz
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
* kernel: 6.12.19-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 53db7cb59db64055714b1a7fd1cadd8d5ef6e2be
* git describe: v6.12.18-270-g53db7cb59db6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.18-270-g53db7cb59db6

## Test Regressions (compared to v6.12.15-529-g7d0ba26d4036)

## Metric Regressions (compared to v6.12.15-529-g7d0ba26d4036)

## Test Fixes (compared to v6.12.15-529-g7d0ba26d4036)

## Metric Fixes (compared to v6.12.15-529-g7d0ba26d4036)

## Test result summary
total: 77388, pass: 61961, fail: 2961, skip: 12426, xfail: 40

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 54 passed, 4 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 43 passed, 1 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 22 passed, 4 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 5 total, 3 passed, 2 failed
* x86_64: 50 total, 49 passed, 1 failed

## Test suites summary
* boot
* commands
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
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
* ltp-crypto
* ltp-cve
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
