Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4450F28CF5D
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 07:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764746114; cv=none; b=k1Gpkhjrh1HYpQymnSwME+pikBSmJHY3JRz04FlwmNkjDQqQZhl9DeZx9XsrklJHUJMSH6vrNu6Ki+uYM6k2RmZCyhltd7/9qEiJ9ZdeJF1fY81OymCXIIzcxg+dQGgf1GqorAh0OlLcEMPc7PyEeTlvBPdLec2Rf/KcOZ0r/iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764746114; c=relaxed/simple;
	bh=hhYimVu64Jhzi0NwwVUu2hKUQTleXM0vwg56OYBPvRo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XQ9GsLmwvlZzGCQWTN0yk0I4mJNjg6qKJ4tnsaN8hJEpdYafkmBI96ERGaAQWfh88Pbq9vpGlLqPTPDvdgD7icOsb02Z7VWl/j+Vc6smMr/gxYCcv0t4Seu2ExVR0oI3v4tzwTeeX4b6WKkkrkdFCz6c22yUoY5TvMoi4HwjwHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=b+Eypbr+; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="b+Eypbr+"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso4164612a12.3
        for <patches@lists.linux.dev>; Tue, 02 Dec 2025 23:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764746111; x=1765350911; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KuaqeRiXB2RSHvZmjA8H7YeoSS8/bN+aXc/eV8k0YL4=;
        b=b+Eypbr+oDtoh9PxlzYZ5XoMnZWa7W1kIf2KgS8I17+Sa86AXWrsmoGxFJloQIaRjB
         8RroypmrtNvuNjYd1BvMWhswWID/5lqj/668AhJOpTSuTGshVkaD7ei7pioTma5aM1DB
         IQ0qu97mYDAwh/4c8O7O2wZPrDbkVskt0FRUCOLcwr69aa0q9QICTYpdYZdXD2K0eoak
         kZhIWxoPanmf6g2O/h5VydG5/PFlFV18u0x75R7T0j6QK+ZbhnlYtJeVBWcQxjGOaOu/
         5qD1fFkeZSfbJ4wOvv6fkgq4hKRpTzUGpOj4mFoMSmt9LaMAIjCYCupzHU3KYhKEqW+Y
         dQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764746111; x=1765350911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KuaqeRiXB2RSHvZmjA8H7YeoSS8/bN+aXc/eV8k0YL4=;
        b=GpUtFeqmcwnYd6mKf3fVkn5lmYO8gaxFbFZMAQY2N8A5ArNIqAKFecPK8T6gXX/rG9
         3KDWpoUVcxXN//fSpyQvQ5hzhbFPyFDjJr6X8IOUeCVlYRBGtpfvJRwz/NgptptpfUF6
         dsz9NEQqtmMXFz6SGP4rUTmwCR5l+St6URlX1PCBlEVwCKtbEFrH+HUuOWIelOgTQ607
         J9HkzMf/4J8tnIe4ff+I8gXAvAupoxHvvDjgM2C3uwIsjvdF4m1DqbvZEOTGyB64vJAg
         wgbAdO0leWxIlL/iP8Ve/k/tR6/fOGr2tVSrgXYi4SqI6mH3Nyh1Hnx4b2cN3IgAdGFG
         y4oQ==
X-Forwarded-Encrypted: i=1; AJvYcCUS24zY674Z9Uabt5ctO597+LWc6ULlGbthLpCTi3K71QsxVY9Hfw6URUYsGzOIR6Zq0dczO362@lists.linux.dev
X-Gm-Message-State: AOJu0YyO6aWofvzionstTZASo/gaTB/huiiigCOgATz8lhLmP9YZzAip
	2GwfCLtvFhpBBPecpfukQKfM2ojvJK5ZDq2brO7OQ+akiipy92E/Drw5ETtwxKZmYGLKOfjYeZ+
	wBdEpVy+rBj6lOwr+NAo/MIDrUMBT5O2kSh4sgZGcCw==
X-Gm-Gg: ASbGncvvtt+Dy1AHERcjeyfWWK4YSj2eTDUPZONaCYRfL0JzkYmnI5u47J3Qwc48Sd8
	plNCSn+pwNycoXUWvPKPpH/u/o2mOUE7sKFOhYqf7tmW0BGhtQnKzLmWSKzALCCA3GSvKHKD7n2
	Ty35uPDQShRRz0P8r725b5hjVT0IoxH11cl/ZFFEQhkc5mfQ8jJKWKg5fXyoKIwd1hTbUWm0wuY
	4x+eufhoeaXDk1ACzALxlOyFhV/Aoe5ZikfsAT8pkefqCeSCrYVB/Qh1j/q1E+gbftYHox6gukg
	VQ09liQPgAVtuJ185CplPcob0Cse
X-Google-Smtp-Source: AGHT+IEETnb54HbdKeTiuWDb/Lm7b8afZhTKNTzzH0LI7UTbYLqKJsp23LG3WvoCfMvvkbfrzU+7EYOG3b5zJPTCWxc=
X-Received: by 2002:a05:693c:2c94:b0:2a4:3593:c7d4 with SMTP id
 5a478bee46e88-2ab92ea4736mr969734eec.20.1764746110958; Tue, 02 Dec 2025
 23:15:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251202152903.637577865@linuxfoundation.org>
In-Reply-To: <20251202152903.637577865@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 3 Dec 2025 12:44:59 +0530
X-Gm-Features: AWmQ_bnUN2qyQc96l7jqt-7SYMj2rnFyyw2W-5GaA3sZoN7Dn6CHN1uhUQkFwtE
Message-ID: <CA+G9fYsut9v7pNOEMV=xt1NeGoT_WhUcgvO5+vcJyTHqjAV45A@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/182] 5.4.302-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Dec 2025 at 21:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.302 release.
> There are 182 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Dec 2025 15:28:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.302-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.302-rc3
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 95d4a5c8c83fb774f7103574166d0190dc839cdc
* git describe: v5.4.301-183-g95d4a5c8c83f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.3=
01-183-g95d4a5c8c83f

## Test Regressions (compared to v5.4.300-225-g4e89a6191515)

## Metric Regressions (compared to v5.4.300-225-g4e89a6191515)

## Test Fixes (compared to v5.4.300-225-g4e89a6191515)

## Metric Fixes (compared to v5.4.300-225-g4e89a6191515)

## Test result summary
total: 27636, pass: 19070, fail: 3006, skip: 5408, xfail: 152

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 131 total, 131 passed, 0 failed
* arm64: 31 total, 29 passed, 2 failed
* i386: 18 total, 13 passed, 5 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 26 total, 26 passed, 0 failed
* riscv: 9 total, 3 passed, 6 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

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
* kselftest-membarrier
* kselftest-mincore
* kselftest-mqueue
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-x86
* kunit
* lava
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
