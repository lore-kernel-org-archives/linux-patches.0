Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4B82ECD3B
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 17:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750959887; cv=none; b=isJ+5MTkdqF8SdQkzSkUqIQDSGb+Jx/NM1jjK6ekAdj42JIuZIJBxZWP04zPC7SswKxVR4fBdEVfIk7pUwTuxXpe3jsdWRIKt0iFU6tXk1uL8zmxXjrjDSn4dOjflX13pSseDGj6afa9+0n6y9Ks0O1c/nlHLmGBwI6STCdZ4rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750959887; c=relaxed/simple;
	bh=zqUO0sW+cNaKMWzNEDMI98mGQvarDe1iRGXhZ+Veqss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TND+CRfpzLDCv3Dg+7WcO6AOM0t7+UinXgflensaZ7j0qpIIxjCq6/kT2DYPuJv9v0XI/wE5v5Pd3JcY/JzrHNyLAPfr/ocQt/Eua2RHayIzr7Us+7gGebQbdGxxLhY0EadykDv50BZ1px9YYeVmnrifkBQKuTyyaUKHJnPjm5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ucZUQvkX; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ucZUQvkX"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b271f3ae786so1094705a12.3
        for <patches@lists.linux.dev>; Thu, 26 Jun 2025 10:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750959885; x=1751564685; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=awzZr2qt61hMaORaAhilI11J4L+Y4ATtUQ36+lUSj4E=;
        b=ucZUQvkXA9DLJHtwksHfHh6+NiaSDw07NzRkzeAZ/cPxSJT0lMBT9YO7leMHQ/zw6c
         U0tBTDdC/DOI8VuWKPoOqzHfsuKNIHJ25V9Ay26lINvTHO1jCdvr9ZP3Bsyin8N6PisN
         4cCJy3itruMgLLdaTht3umITmP8OY+z727BRyB0Q5MQNBqEfKJcNYjSIjqKR1d0k4LBy
         GXwUF17L6awsOj7MY7sHlafo00ITnX1E1jPllndLuqj7P1bA+aVUCIz3Ot2iQb5q0n64
         YiIcv+8iUtoCv9egPcUipc7qTIzX8xC0rwM1U1AyUAlMFzLnYezCsT+b7vCsTObwBm9L
         axMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750959885; x=1751564685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=awzZr2qt61hMaORaAhilI11J4L+Y4ATtUQ36+lUSj4E=;
        b=kuTyZg2Yx7zXC5FZBvjLEQV6oKw06XqPSzcYziyhf6QzxfhJw2kM8dHhjqUx1/fLd+
         cB3ToSiKKuihsHB8mVp10miFJOmVDNeQwi9v4LLJEAlvLbau1cdZSZjNygbI/GXEzm/Z
         mVrJC8e/H7bhxpgRqqY1hmUDlVhgZ8UTPCLwbuQlrtaeQb7K6dB4ifRQewdRXfdSw4vr
         TPaE78zC6NQ3/bdyy3Hubi3F/uapBIDQt7HTiKp6uD6tkVnTATPWfXVs5SW5t72Qkxz8
         4Hsp/vE0PZBDjJG+fEPjxGf6ZcwRkWG1B6Z1MUxRaeAV+wbk1lMo4KliMofQu+/DWEa5
         8WIg==
X-Forwarded-Encrypted: i=1; AJvYcCXjGTt1QaTwbUg5JNbVwl/zOPJQC7rqblrfDXi1acqYeaJQsiekUdYyaP/DThV4v9d2vbQUq5Uq@lists.linux.dev
X-Gm-Message-State: AOJu0YxEXZ9JoyCtBpzGroQhI4TbhC+CkR7FX4lmABrjpboUh+WJsFct
	lYZlLD4wJhVTqpkYBFEANP43Q33mWnnglYfvoseZH0rYWtxczC8NwTeXJxmvaSUcAvxxMlUT84U
	VgaORaAH4jQO5p1mxKgXcOpS3kn4ol1y8dpU5o34oBg==
X-Gm-Gg: ASbGncsFObbmnPkNYZ1bGTAxJdTd+/TukYYeMFZjboIzqLK1ld45OG49QKWUJBEYZd5
	1ohml0Sm/JeJBZLuvYmbUZvya2ToxBP+vrXFdrN/rVQI+yTqUNRPMeXeSicEHA1STieHj/Gdx+v
	yvhrzTkxno9DvAMQPhMnLbXNcKXqjckIE9dFK2liJGQcUM6f6ijLqKijrHAiGR5F6EEAbQfulOv
	98a
X-Google-Smtp-Source: AGHT+IEFPPEqV7DtiqEA1oE1/fKrctRNlSpnteTT9tcvCUfZIlkuK+VPMsW7r1iS1qPSXO31ZrE+Ng7a60BAXQEdGNk=
X-Received: by 2002:a17:90b:3cd0:b0:311:d258:3473 with SMTP id
 98e67ed59e1d1-316158cc4d5mr6717061a91.13.1750959885262; Thu, 26 Jun 2025
 10:44:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250626105243.160967269@linuxfoundation.org>
In-Reply-To: <20250626105243.160967269@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 26 Jun 2025 23:14:33 +0530
X-Gm-Features: Ac12FXycaF7oeRJLnS3XeYXVpdhngxsyXODthsn8k9cqqTJDz0BHwpoRhfHoX6U
Message-ID: <CA+G9fYunftA3YqTxm-2GMN1fpQ_PVviBpDOnGznUo4YSW9pmSA@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/589] 6.15.4-rc3 review
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

On Thu, 26 Jun 2025 at 16:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 28 Jun 2025 10:51:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.4-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
The reported regressions on 6.15.4-rc1 / rc2 LTP syscalls readahead01 has
been fixed on this 6.15.4-rc3.

## Build
* kernel: 6.15.4-rc3
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: d93bc5feded1181a1f0de02e38b4634a7a76b549
* git describe: v6.15.3-590-gd93bc5feded1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.15.y/build/v6.15=
.3-590-gd93bc5feded1

## Test Regressions (compared to v6.15.1-816-gd878a60be557)

## Metric Regressions (compared to v6.15.1-816-gd878a60be557)

## Test Fixes (compared to v6.15.1-816-gd878a60be557)

## Metric Fixes (compared to v6.15.1-816-gd878a60be557)

## Test result summary
total: 270887, pass: 246235, fail: 6441, skip: 18211, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 56 total, 56 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 33 total, 27 passed, 6 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 49 passed, 0 failed

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
