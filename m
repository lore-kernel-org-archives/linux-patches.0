Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67BA1ADC86
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 09:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740043006; cv=none; b=JENFZ2iqk5whlfFsjoo+5nPxCbrzSeLPAtJ0MzaupbP4ZuW4KcrbVY4mnSeZr2hdgVO3GfdGhLdceqwGtvugZ1QDd/EHRBf8mRBUytm9TqDSNtYWprlLxwq0Lt3Ti2uR/2DWG4n740wE3c/TbaF5asFH8Xf8GyXBfXONNZGgxrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740043006; c=relaxed/simple;
	bh=GiVby10/n5I0HseZQxln2jZFII0SHsV7bW6nsEeMO/k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K0SHf1JGOXVV9dUjCfOmukKa3SxsUWZuxITb0/lIxNr9iDhfMihFx5LoUeuWret93oRrRbEf20AP/PllQfuG3qhNnOG66EhLhN7wXdXf4ecsok9qhZ5da5bbw4fnoheh686ru9v3Lnq/EUyj0hAS1VURrnqbfm7ez2jDqk2QAe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X+GzkFuw; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X+GzkFuw"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-4be60963da5so529751137.2
        for <patches@lists.linux.dev>; Thu, 20 Feb 2025 01:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740043003; x=1740647803; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c1Hs1uVDCX7uer7df81v2kpXaM9YWnPM+ecXbZIv9js=;
        b=X+GzkFuw+f0SNQh5/D01ay8r2XM/+vb3vgnkMlETf56UhoUJ3jz/Y/jo5dGofCWtD8
         ifde+TJbjrFL5++dxY070qQlMse+jP053Ei1BAVE90UQ3sfHPyAU4jGgTRicWQzzYet0
         /Y3tAW6suxjHcDuIUgQoXABoyDQeaVS2ockI57tGjpG08ifnKZoxOzdCSeW9py6hWUj7
         lc4vrQrOTVnnN0G58KPfGEnS2XcuuKZZPWI2SuWYv/MtpBPX4e4qWtgJmlbC7/uOZ7mT
         rf0GliGddj6PyUesk1KUnuqm49ot6JlteXTrc4VS+mlP5c4tPYO+vLRvJjgFfzh8t6Tr
         mklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740043003; x=1740647803;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c1Hs1uVDCX7uer7df81v2kpXaM9YWnPM+ecXbZIv9js=;
        b=HAo7OrxEWtUCMWRhCICHsMPo47BsQu4dSo8vlqNMtrEi5aOy6zTFSkuMTA672u1FV0
         QwL3TRqeGjuJqsJ86f24m9/a28jA1dnF/8PAlUXFt+fgeJpDRO5T03+vK7zktJvJ3phx
         UCqufaNLtPddaTTGjGfXdB48Zy8Fm7jYRlVCxW+AR8pqkzId3AoBNunJcMTJL5vOSdnY
         J+DZTz4QgJeiJuWCaLiOs+FQHqzbvYkrIBHeJflYj2/36kPz/1R803CE9bFw8GXetpF/
         UCEdoP4lSaUHYcuWXG1vtG6jH75fT1cZcXbanIADT9hXdJsoUY3p50IBP+7oEw59Hd2o
         Dxjw==
X-Forwarded-Encrypted: i=1; AJvYcCXt/f9FnmhGY2AnEz3qR57lQ/lXAc2Xv/EuHenbeAfT8dMiX80tCGCoL+j2k6H6xkIkGCeDDjWa@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/03kVdMYlKQQv/FIQE34r1uHO1n/YlL2kDHFmB5WJDqFj8T8O
	LWrbFpKjhDXJW/HHdFaChQVsLvjc+GCzIBlF09CfbowiWisdXZbkpJSHZbdKcCgdh+qH5/HdncI
	NsP2Wy+Z/ybKxveu3+qwYFn7OXozoMkN9rmZm0g==
X-Gm-Gg: ASbGncuIaQAdL3Ga76vF1RC4onaKkioa57V8XwSxfmos2UG8Wt6GpbpnBxFjyNe8/LM
	argXXCqHGzQoKO0/7bihfGkOk5rg0/uahvE2+HDFM7I+R1l5v7AC0oppp5MpYuTdfW17qNsaCCo
	Y=
X-Google-Smtp-Source: AGHT+IHN51X9i9ID69Sau6EJlrF3CZlU38cZaUyFXTMyP5JUk5iZqcTT4IRs8ij0yVhX/uZt7PciZ4+Br0p/8WTkVEI=
X-Received: by 2002:a05:6102:d8e:b0:4bb:dfd8:4175 with SMTP id
 ada2fe7eead31-4bd3fe4661bmr12751371137.19.1740043003403; Thu, 20 Feb 2025
 01:16:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250219082652.891560343@linuxfoundation.org>
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 20 Feb 2025 14:46:32 +0530
X-Gm-Features: AWEUYZm0xgvwBNk_J2j7sQxJRc3ijLg_s_ZqF9tKim_dp149oEQ08mclS7LaPr0
Message-ID: <CA+G9fYtxS_kC06uE9koOUjJQYOeoMtBHkkGdVC6oHGgW4pzCKQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/578] 6.1.129-rc1 review
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

On Wed, 19 Feb 2025 at 14:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.129 release.
> There are 578 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.129-rc1.gz
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
* kernel: 6.1.129-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: a377a8af64e7b08203073eef8cb7633b9c1b9af0
* git describe: v6.1.128-579-ga377a8af64e7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
28-579-ga377a8af64e7

## Test Regressions (compared to v6.1.126-65-gc5148ca733b3)

## Metric Regressions (compared to v6.1.126-65-gc5148ca733b3)

## Test Fixes (compared to v6.1.126-65-gc5148ca733b3)

## Metric Fixes (compared to v6.1.126-65-gc5148ca733b3)

## Test result summary
total: 29597, pass: 22716, fail: 1253, skip: 5516, xfail: 112

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 20 total, 20 passed, 0 failed
* i386: 26 total, 22 passed, 4 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 31 total, 30 passed, 1 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 11 total, 11 passed, 0 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 32 total, 32 passed, 0 failed

## Test suites summary
* boot
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
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
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
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
