Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22152066DE
	for <patches@lists.linux.dev>; Thu, 17 Jul 2025 06:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752732685; cv=none; b=EKUCdHjCRMSWDvKaq1gXIqjkxFL0zWuSxIUQxmMTc5Vl7FxHRc+pqe657FMJx59UCUr4eT42VU6b6dDwUjrQ/EaS2XTjZvNwp6wTH7v9h0abMHDheMX3XCOjWk1EQKHvcZMsrUA0L3Ao9i/h7Iw+V2I3gpOATW3nT4RBN75Q7uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752732685; c=relaxed/simple;
	bh=Zbe2q4+4Q8Fqm1aid0Xd8atXSKo30Ypwn/3kMQH3t4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AE5aFkEMcIGz4b0Rf3XK3tw5pCzrRzvsSMtMWBsQQFF1sQaVYOoDQ2hueb/UuUHp4P5VDQUjL2aVaLUxRNQbn+vnA1zTYZiQ2zMvaHjOnc5PtQtN97fLHrKbKBK+J4InkhMk8XvfNzNKvIBpJhnsGs6alHf66PAxfVhKy6jOYHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=w46UfNkt; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w46UfNkt"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-315f6b20cf9so669134a91.2
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 23:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752732683; x=1753337483; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RMtB2Iw9WAh5wEW52PdaXvpNvOwsz07gd2TiAfAFZrA=;
        b=w46UfNktJrS5X+AED+JuTwej8gWQZXQphLEoY04cR9S4dhPeCzJwkyPcL3xoP8jUXE
         nKOvMs1YxnmhxrYUvU7fUa7nGxjadgBcK60XIjVvbyCtBOkeaZvXKs05H737gE0md84c
         MlmGRmRLYFYFF87xVUx8GO0LcATiOefSP2SJy4vZHBx5JScmBQ+dxScurc/U3Tt3+ec7
         vXhMjeK1mo89ZKeOGZV9lpy32uHcrVbtroXRjpmbbZSf0y2XeK6t9HesiL0g1G3o1PfK
         rMAvAY4pttSCXPgbu9EykaHfKkGozrleOx8pnE/wn8j+NoyIVnpqehGKqCz806WXOAGu
         VR2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752732683; x=1753337483;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RMtB2Iw9WAh5wEW52PdaXvpNvOwsz07gd2TiAfAFZrA=;
        b=aoydZVGnERyCI1FkyJ/O1bJJaikZgQldDpNzzEt3ssU8+lYc+I74oE/CJO5aFKw/61
         mP/K9zbNXzN/WnLBvgHh90YzgAophHtH7D2HSqTa4mde6Kj9wcqnssx1KkvrfphE6o3m
         OJiszwd5lq14ILk3iM7yRdS3K4iIGKGyAOTClDTjsse1njRpsk6dQV5W9UgF9WtMZe2q
         EfFM5l9F6RvLp9hg6SGQxE+ORttqB0QluiuGUeuJL5ALFhfStc1RuuAEFthkj3yrVcit
         kwb3BxCFXxE/GR4jOEIAlNEgxWACsC9haBjiSWuy77HFl9c8Lr+nET9ISanYo6AePNp8
         iE1w==
X-Forwarded-Encrypted: i=1; AJvYcCVGjLdQCs0yuuIEBBP2+x/dL54hVomTSBQjur9xxujGFWKWqcJTB3iUsBJG7YZ32uGfx2n7Gpnc@lists.linux.dev
X-Gm-Message-State: AOJu0YwKPxsgoBOJQCYCEhL+KUjk16xaBjUYkMnaMzWzo4f4LgCnPWai
	x66qW4HQCtgFX2Th/uWqDFAK3WddGox+QnF1U+cHjKp818vyqLrZbbuNgkB4hSueYLfGods3/rv
	mT45fr0NGPDNNdn3JP96Wo/+Mtbb84/AtExPpTOxIoA==
X-Gm-Gg: ASbGncvUDXIWzrTDBM0ANGBHNxFrg8hGnn/gYCGc6X1kQ2npM2MlJBnBLQ3yA+RX09A
	fOrdoXLFYylLFUoYDFh7A9zPUHbd3MFAvGNhwObQHp3++6u58DOWv6nvEl+fAenWz2nCOZPZe0X
	CzRD2rKkahBT+YUNRxBait6hIOs/zbsp8F6TpLkPzSePjnO4caxS3WpQFka8tY0C5XVY2DbSVnM
	M6esIUq0+WVLuR1YW9SdDKx1t0753XSywLPVemF
X-Google-Smtp-Source: AGHT+IHkOgqSndFh2sn5u8Ze2RN4Z1jS3DnTq8InFCNXwPIB0SZm0lju8UDvvs9PhDnkwHDrfHsBKvuEZVHdN0jLg+Q=
X-Received: by 2002:a17:90a:ec90:b0:31c:9dc1:c700 with SMTP id
 98e67ed59e1d1-31c9f4376ddmr7637603a91.26.1752732682713; Wed, 16 Jul 2025
 23:11:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715163547.992191430@linuxfoundation.org>
In-Reply-To: <20250715163547.992191430@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 17 Jul 2025 11:41:11 +0530
X-Gm-Features: Ac12FXwQuuhnkVAKH0EW1O6mL8kt_EcvovLTSe1kalni_rKC64UEWjM9iv28KGQ
Message-ID: <CA+G9fYu88hqRGioGLQX+b02xLXSm6HjtRGYsVg1Oq+SOGykoBA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/78] 5.15.189-rc2 review
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

On Tue, 15 Jul 2025 at 22:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.189 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 16:35:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.189-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.189-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: d21affcc10e6929cdbd116012aff62709982dd1e
* git describe: v5.15.187-81-gd21affcc10e6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.187-81-gd21affcc10e6

## Test Regressions (compared to v5.15.186-150-g09eb951d49e5)

## Metric Regressions (compared to v5.15.186-150-g09eb951d49e5)

## Test Fixes (compared to v5.15.186-150-g09eb951d49e5)

## Metric Fixes (compared to v5.15.186-150-g09eb951d49e5)

## Test result summary
total: 54868, pass: 42016, fail: 1984, skip: 10589, xfail: 279

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 22 total, 22 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 24 passed, 0 failed

## Test suites summary
* boot
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-livepatch
* kselftest-membarrier
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

--
Linaro LKFT
https://lkft.linaro.org
