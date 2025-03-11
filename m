Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9931C5D46
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 13:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741701402; cv=none; b=KIcXWL8VxhMy2K4M03CR7ut4wpNkAY7d/RQczd5Kg5CvtYaO2wwx7fEQYG1ioL+7sVAXONCrhHDuS1wO/6rnmXm8V2Hbt662gzfUeAE3RHc9lNPYXKDyatYEphduJ2xCFjFWPjImBheiCWdtReBmUYqMIQUNsWVZgNq1/72s9pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741701402; c=relaxed/simple;
	bh=8IiP310D7e4ansyuaQQM1xov8Mvy6oaQfxyIgMszHD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K7QeoEK3ujy4m1uR49rjZyiReUSKOxEaWKbI/0jvjUfbsOVf2x2qbuPy66WzuAmBplInoKFIiks4DHa3fFJQU46JhEZdqihojkJVLYNvuX4tIGS9AS/6Cf191JOFQZYcp/QkaOWvG6gnKlONENTjdwjzoDJ5/AtgRzPVUbXbsT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sAiLVZo4; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sAiLVZo4"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-524038ba657so2449486e0c.0
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 06:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741701398; x=1742306198; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U2N+Aak+CIPeIHj0r29UVuXvGehh5FWJExHuvJuMJuw=;
        b=sAiLVZo4IRrnbPCBOuHeculQTxmqDcMYpJLJ9TfcO5s+7wfW8LykQScfzzxbXF1Jak
         bggdyRclTzQXK8cWsHLtzDqerSDGPvD3Da/nSj31rSXp8EqONinCMZ5by8h2QtWNjy3R
         OAnk9GGH0Hd7kwxjf0MVJW9jNCNlw/eZQWamiC74jDpXRT8/5cXQaTEWUvjY+OtomHzy
         JLdiIvKmvBCPaM0QRXuqSzWpw0t7DGvnk9LIpTtwxP74W0gdNZmAaT1hdYCVvA6/gXlG
         tT0AURKIsGZD5Dy/tAaojtLQeseBnNjUjjCwcG1Q852JCE9+g9wxQwg5ORuO1Vzcr0Cq
         9/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741701398; x=1742306198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U2N+Aak+CIPeIHj0r29UVuXvGehh5FWJExHuvJuMJuw=;
        b=FTQCRJU+4plqbtfIUVlixLyDQCZI9lrRoALs1QF1Q/AA5KG7/v1Z7PlmyKWUfPNO+2
         MDLqn/k2XBbwuzKuo0ReLWyE9wG2Lo4mmeaz4kbhn6lgeysQUHGwAiKTZT8fbdvn88bU
         uhjm4DJJXvxKd0/7H2puD07osgvHM0tb7TFemNTrVJiQGJNlnembG1z3P8LixFY+vpu7
         6fxvze5XtUOnorym8obnm78SKpPD4HCw3Wosb+c0/pZaQ9mC2BZQkh7qKEJql20iZwNZ
         XYB51babA8HbNfS6YMFornyi7MP7QmFaO2l36iOnS8NFaiLAWhQ/8WhmwRRxqBGnLcuW
         5nUg==
X-Forwarded-Encrypted: i=1; AJvYcCUbCJ7hyAFk6Ar3k/hsYTOWjRrUlaHNVFo67nolKxHTxu4CI+klh/o5S2C2mgKnrZFnWJ1DUm/q@lists.linux.dev
X-Gm-Message-State: AOJu0YwWlj3YpL5bWkrwEMCi3uwUMON5x0zByHCFkObPOG1ppcwUo0pM
	mT6LgEOI2RnSCRZVU8xFCD/RNEUAzwAE7SD+MPkIxbUOXeQBFbcQKpJtX82Lu1uLTFXzSMU2eK4
	fWNJAfO0sQAuDCJr88ALESwuwu+heYNEMiu2n8Q==
X-Gm-Gg: ASbGncuU2KIQrWEDLvbJo5bXegLt+FWc+i8WRUzdsalyGvEuGWysoY8cHr6Z7yLE+xX
	mRiYTb17jtk4NVAeBgNzT25iuInHozoi6OWQiLCrxMUbKom3X5cM9R2vjZQzkBxra34eTh2lqte
	QalZruBkjMAIu1u43JtKSAY4dMpdH2C+EVECt2wwEcngYrDGXHaAG/vNgBilw=
X-Google-Smtp-Source: AGHT+IEFerF36HL1rGh4auPc7CBLh70p65CcQmhmyY6oaALXU6swyvZCI0BvNaOEVhtsxQeTQfLD2Hu11+otSm5zxMY=
X-Received: by 2002:a05:6122:3d47:b0:523:dbd5:4e7f with SMTP id
 71dfb90a1353d-52419754983mr2484522e0c.3.1741701398495; Tue, 11 Mar 2025
 06:56:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250310170447.729440535@linuxfoundation.org>
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 11 Mar 2025 19:26:26 +0530
X-Gm-Features: AQ5f1JpJScIVXTIFtt-TDzw-VZFe3PYeUikQXgKwV-72D77COTTUyRM5ws7x7v4
Message-ID: <CA+G9fYtzO4bv8ij+x7yV5YDbSr+wsHRQCzfzjXUA29oQmvTsvg@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/207] 6.13.7-rc1 review
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

On Mon, 10 Mar 2025 at 22:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.13.7-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 2fe515e18cbae9a204a7662d4b3b5760633f31fa
* git describe: v6.13.6-208-g2fe515e18cba
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13=
.6-208-g2fe515e18cba

## Test Regressions (compared to v6.13.3-552-g3244959bfa6b)

## Metric Regressions (compared to v6.13.3-552-g3244959bfa6b)

## Test Fixes (compared to v6.13.3-552-g3244959bfa6b)

## Metric Fixes (compared to v6.13.3-552-g3244959bfa6b)

## Test result summary
total: 74660, pass: 60565, fail: 2624, skip: 11471, xfail: 0

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 56 passed, 2 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 42 passed, 2 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 25 passed, 1 failed
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
