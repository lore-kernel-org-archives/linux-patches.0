Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF55678F51
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 08:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744188290; cv=none; b=jsNY241k3KDZPxv/S10SYY9NFMG0m2GQ1jPF3RhN2rjLas/sfnUTsxJmnYTKCcs5EbqFq3BMgNdYtzbBW1s/ewlA7sJ7VO2hE/wvYrh2VIqSaGORUtdAPcEhWTj16UUqqCdzZfvSCY/PMX/USQKuTGNGCT2G2D8QyFVW9mOjkos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744188290; c=relaxed/simple;
	bh=UcvtGqHftKcHDySqW5lny9qK57wRwrXMss3CirE7KYw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F3VBJcWdcqiV506zyIhSmA3/1I5A1c8XzS9rKrqdwjpp0pL9CBOVKc37BntFl8+oglJ3SGYh2/jpodd3vMg2xu+hLeaGk8EvTUpaKwFwtjfR66jE79GA2DeYCRaffj+jvrn7Bv37QZ/O+FSmtvsIQRNxtnUVbKl5Vz0FXmvHC2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=edgU0dgt; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="edgU0dgt"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-873a2ba6f7cso1791249241.3
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 01:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744188288; x=1744793088; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sATv1P8kIDaxvXmhiWDZnHa3AJJeCbV8agMtPDw+RK0=;
        b=edgU0dgtDE7teYUgYwAgnqxZJePS9DGvU098lNnw8QHGT2IyrBTaNH6UBnYLK0QidR
         hR/tRhqdfA6Sq23ww90p7OqeTHGkoyJHt63Sf02siGR3POkWi46TCNtNTcewekjcPYr4
         +hA6vMJ+cPfA58PD10JMOIJy6uyGsQ0FbvLwhildubHk9bIaq85u2QsUfgMK0ElL+2uC
         SIabAz45gXtQYEj5JN+N5dTrgzoWhmE97YXQYz39b6Pu78tRLwkKVVC+QkeY0JLSJZm3
         IR8L7plRNzU4UaRBv6TxBDcj6zd9mRDMg1weGEDbggSAsD3IK/tjWiAYBpdkoBIylWAz
         scmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744188288; x=1744793088;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sATv1P8kIDaxvXmhiWDZnHa3AJJeCbV8agMtPDw+RK0=;
        b=eAvj7awSnHHRvwT8z76HfhpYLfy64aR4XVUHLjS0yHTH0pw2qXyhNr7ip0WPsKfksN
         wsRx568FAK80EwzmUO0ED9Ih2DLE3lUzsbWOUOfFVZGFJIU2Xp1mKRUoU0rTtzx1l8ZQ
         fpWGYPJ55fjLE2AMVAUw9TvSVjvSJQEmYEt5EfnD5pcdmF5bNUWJ+LXGdbfsX88alTku
         MNPzu3i7o1RY7AKapjDnehsCPUJyZShSdlyFuMTa+E2fnS7NbNXF8TEbodnBdpWAvFIL
         m6zcaX3eYS4F+PKfN/tGeJgRI4sLQDew/B7D9yjze5FBbEpBdTluVCsAcp8aus+sK7ed
         /oUA==
X-Forwarded-Encrypted: i=1; AJvYcCX9euPrfy1+SKqnLPQLAgilnKjZD6vKnWJAhV5GXUFVUPJZTurUXDL2bU8BRuIjQpf2WnbNH7fG@lists.linux.dev
X-Gm-Message-State: AOJu0YwRHiDe/PJhgtLswx5H4lglI6k3SC8yhUlQlb0NT/pqenrJGrhs
	D4YMffGrA/I/Ego1gOU6+lmjD9emU2DXSL7/Y0lELl1VCEt16XDsQDnIQGe/El0I0yGN/Ywlo5S
	VJNqU1FYSZOc5P8fzRib9ju1fIZW+pxA48IZPFA==
X-Gm-Gg: ASbGncstObCuIHmJIje/MY9pcpghnebjiAIe1bVAB/v4sBBmhBTLiiTwTP27yyqFaVZ
	IgPGueAhdrguKliD00JWPJTn+aoQ7QoCPuC9xMuhSphtX9ltvdYS3xnMDVWD7p1MOdh8XAHRPOJ
	XU0tNM6LulqQq2M9UbsHJplD3uJ0zsucaFCO9wPTxL91oyBe5TpCIHgilcxDaa16G/Ag==
X-Google-Smtp-Source: AGHT+IF9PDjhz3U36sr0FPKCEjNWE0KhBMW5VnpWdv19NKllNss6oXXHmudrq06C4RiYlOViR38uV0s61R7zimmsuhU=
X-Received: by 2002:a05:6102:5687:b0:4c4:dead:59ab with SMTP id
 ada2fe7eead31-4c9c4139f4dmr1382352137.5.1744188287694; Wed, 09 Apr 2025
 01:44:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408104820.266892317@linuxfoundation.org>
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Apr 2025 14:14:35 +0530
X-Gm-Features: ATxdqUESOUek8Y77NxlUr1DELbiAjzQAVXUxD6eVLLLehUNSHSoPSk49XX2dSlc
Message-ID: <CA+G9fYvgLrfNKgP0h5fwOu54a+kNVA0652aGey+A7xVzyjwe9A@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/204] 6.1.134-rc1 review
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

On Tue, 8 Apr 2025 at 18:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.134 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.134-rc1.gz
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
* kernel: 6.1.134-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 41c273b7c6e5686866a063a29a03f95e3970fd7f
* git describe: v6.1.133-205-g41c273b7c6e5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
33-205-g41c273b7c6e5

## Test Regressions (compared to v6.1.131-221-g819efe388d47)

## Metric Regressions (compared to v6.1.131-221-g819efe388d47)

## Test Fixes (compared to v6.1.131-221-g819efe388d47)

## Metric Fixes (compared to v6.1.131-221-g819efe388d47)

## Test result summary
total: 79336, pass: 60518, fail: 4593, skip: 13917, xfail: 308

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 133 passed, 2 failed
* arm64: 43 total, 42 passed, 1 failed
* i386: 27 total, 23 passed, 4 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 29 passed, 3 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 14 total, 12 passed, 2 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 35 total, 34 passed, 1 failed

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
