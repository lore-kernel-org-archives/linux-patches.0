Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9956621C186
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 16:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752080010; cv=none; b=vC82AThu10a2LkK93MlKqjronDGnmfeVsDI32ZudlJ5817mJRg24xfqEs9NHt58t0ETPvYWOHqHHMgcfDfUs4fkgUPj4t5RMoJjI9n7jXQEakkqKED48J46yFs+F4/4zjsAXMCorjOds7sy9RRkhVYShc64et+yRRSonJDawk34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752080010; c=relaxed/simple;
	bh=ETmSGWb8s195ymgPNwflBPPZhtnQxXrVFwQL8Ep98yA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qwuTXxTOviwJqT//qUINqyZlk1uRiTXVzmVS6YCFzpWgzqbtx/W8EwouGhb9rqgVwBu4YdBTIbjXiaB1adsnEqA8ThK0aUbiShwVtB3CL6TWR1FQVXM1/WuPRbI4rC5epSHH7D3mVYUKibwIeLU+MMR8krimSkC3HLeYYkJu+oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=moTueF0x; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="moTueF0x"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b271f3ae786so180615a12.3
        for <patches@lists.linux.dev>; Wed, 09 Jul 2025 09:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752080008; x=1752684808; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Nzb8QBeVA+iiDAxXQK5Sqsw2Affc73UEi8O9xXgrmw=;
        b=moTueF0xYcd+KEUMmBYIgE91Z/8mm8hFqqiRJ5mt4MvZfRwE4kbsIl5nT9GSofZoPw
         hZGlDDrtmhe4QgnYsWZBy7QhHA0NdeDEld+eE9M4GIy+wDVzo0BwqbA3FwBFUw8Norsg
         4dNz+7UPHeo8kE9LrsBYBWhIYi5/SeovZg3FApqIansRZI7ZPZRWl//bpcsbeO/nz7kU
         9pQSkTu+cb+4RXrDBxujbSVw9ESnbU7w1UdLO1a/J6+gcvXj3ldpJrT6k52Ha5JVOYLE
         dqfww/RzE12G9tdDIB3iy4eGobIF0zy8DpFQREyksiho8LKIod81breCuJJ9fuy283y4
         Cltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752080008; x=1752684808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Nzb8QBeVA+iiDAxXQK5Sqsw2Affc73UEi8O9xXgrmw=;
        b=dVJ8ZlVeHzrlGHVISzIMGs4QOBX+wlB8D0ICcMOAoYz1U93F+xqtEW9RRF+tVlOIBE
         lriBqp+pgJV+f5br5dr6aHGz4hKoGIr1eYnIabpvk9urmK+3tNJiC9OrVkF/hyHt/6eA
         sCuNBe+PWUf9CJp11o0IzaD7ClvO5iEbg9wDMI79AAhZfCw8PYXRcsY5DLpQSggrIWqG
         24F3SPq0LLHYPSyz2SfOFbQNqK6V0mq+3saOY7qvHqxmstMCKcHGwqXUQDU6C1WSfVAx
         +xz3UiTrN+tyn3QvTaGFscHmLTKtNZu3U0/YtltzRs9cNaHAtM2knc2UYQNgMm6g0NpF
         8/5w==
X-Forwarded-Encrypted: i=1; AJvYcCWbQiD+p3cPUiTOMHjv7jTkEY3XvNQOz5vyG25Bwv8EhoJA7Q9gkMHEy3yEZgfZ8CRCYvR12jFL@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+6/VK5NyX1Tl9zamzz8HRlRgUfzjVacuVuacHQBKo0Nce2cOG
	zWnoh0svDizaebONwIUO6bk+SrL1ep/ho7MyVy8kjBCQrxJGKBYBs6iwGqjBi515Pa75yf36uDr
	JndZ0vD/lwHM9KZHn/tKazU80i2KALH4BuVYzZOa3AvDt88p4PeJnfqg=
X-Gm-Gg: ASbGncspU5kMKbfpMUIosbf81w0QJQg+v74V87XjzSqXMnKpuYcbQiCNtch6mtMAZSP
	PefOyJXI+HTBAkL+oMDjGVMEgZro0KGYdNE6Zdddl8vQ8w6W9I/aPYvf3nV6SYq1m7rUFkU1iye
	Z0IIVJhD/D6CkGWnLmGcxScWKEmDYN5gBmweFt7ynSqi82pRmTDAexR8xUYcmTG1WsSfcxsLBDP
	zNK
X-Google-Smtp-Source: AGHT+IFe5pMoIPZcou4Y8jFL5QVoIolrYs4GD43h1xsn5n1NDW2BR5XIUpU9iQTapT8p53r0thNXJxiwfvtfT+22B8U=
X-Received: by 2002:a17:90b:4d01:b0:311:d258:3473 with SMTP id
 98e67ed59e1d1-31c2fcffda2mr4788071a91.13.1752080007778; Wed, 09 Jul 2025
 09:53:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250708162241.426806072@linuxfoundation.org>
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Jul 2025 22:23:15 +0530
X-Gm-Features: Ac12FXwPd2uci1O7b_OMVYQ6v-yG4ihVV4AWxcyjiIC27vkrbJpvuFh-GYM2G3E
Message-ID: <CA+G9fYtn9f2w+pwFR9AmQCig4vp41XrC1OD6=WYg8T_SZpTBZA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/232] 6.12.37-rc1 review
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

On Tue, 8 Jul 2025 at 21:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.37 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.37-rc1.gz
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
* kernel: 6.12.37-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 3d503afbd029b665345130b4760e91f9d32d9f02
* git describe: v6.12.36-233-g3d503afbd029
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.36-233-g3d503afbd029

## Test Regressions (compared to v6.12.35-219-g08de5e874160)

## Metric Regressions (compared to v6.12.35-219-g08de5e874160)

## Test Fixes (compared to v6.12.35-219-g08de5e874160)

## Metric Fixes (compared to v6.12.35-219-g08de5e874160)

## Test result summary
total: 317029, pass: 291320, fail: 7015, skip: 18182, xfail: 512

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 55 passed, 0 failed, 2 skipped
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 0 failed, 1 skipped
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 21 passed, 1 failed
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
