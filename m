Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2B018B473
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 08:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729066534; cv=none; b=jmpVW1g9NCMK4BvgzBwfa/XRFUjGLIaJEWYbyllj5jlBEAy2v83R7dlvz95EJpXgp2/rg3TMWJ5IGwmFkTAbob6o50MhKebbPh7ReTwdA1bxzAcwmmb/TWiIjpDs0BOYnfDOnewhJsje9qH5A5pNMu6xYN8TosPfaJMpd5cNfnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729066534; c=relaxed/simple;
	bh=1IuA3bPqqaF9ChAHU+88Fb58RTiFz8iAP0BqIuxg7OI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q81AwjlnBVtbkCsGVVStCODutet5MU0HvOZ0IlgE6KrP9qH5u6uDA9XgNBxENrhc2zFkY5NGZ2elRYQH/QeWIw0e6bstkvnjs45hu5Qb1KB4YzPbzgHBnlmRW0teih+Cz6YXEzZeDNKWbq5AQ3iEPidqrQGAIR4TTCky/dTKMe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wQADwbF5; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wQADwbF5"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-50d73699e13so420215e0c.1
        for <patches@lists.linux.dev>; Wed, 16 Oct 2024 01:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729066531; x=1729671331; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WcI16q3sDOqKZecGXpjAdaHkVmug7qW5nF3fWN5j7Sg=;
        b=wQADwbF5IWBN1cCO2979Ajrd1uJiR9PAib3KXSLyO7TsqOwb+iY0jdOxwrEebUQRiL
         svYhBhMkKBbSYK/woZsC6z7JX6ppQLTlh7uaA1voT7e4wz2Rc8gUR53S6TdJz068KrZb
         u2p3v+JsTZFXQBgzE/alwlRV5ch6mQI9WnyhFT34uo4RF3W7rhcZfnp51URr83N5AGcb
         LcuY4jMyD2S62003lqHgzZ+LXcrdL3MRns4qZf3pnjAtWAjDFQbGJ9gp0U1Ok0Lqjlml
         fP2W8/FEMROioMFZNmiiFzXfcqrLW4as4fNiVTPfjz/1FUCz8VtYN/mF0AANOZbo55xs
         WNAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729066531; x=1729671331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WcI16q3sDOqKZecGXpjAdaHkVmug7qW5nF3fWN5j7Sg=;
        b=R5abFn4B13T5W/Mepb+PsYHFpnSMkrDuj1OU20QkQgAzfQibCuc9rZSA3iQBP68lKy
         kyhyAlnHXC+3uHRHUDS+cZfkUTjAfQ5dw56pxqb/9pHUpJ2bDiSEoS0s75T/dcd7a/i4
         Yf4/jt0oo79tLy/P1bk/yFiDmIFIu/LE293xbDW/Kmx3MDTcdKCUTkkJ+FbnGRdt6S5n
         dzxfxeEP+Vohxqj+0GDNjdV3JveFOAx7mNGxhPzEaldWCvi3U7an5oQTkf9PJ0ljcTXX
         rgjo+lO9KMAM1PN3XU66VIwg8pU/a2SupbVEKHsmx2dlWd/Ag0oKlGvMSTcOb7p6cQbl
         hmzA==
X-Forwarded-Encrypted: i=1; AJvYcCV8yzh9xXnCTsA0XzJr86X5bF+fAVMR4YZpFh4/fLy3BDKKdhHwn5ddWwgI1F5vhb3wuSbGT/1j@lists.linux.dev
X-Gm-Message-State: AOJu0Yxn6TrEacJSwdkZet+zmouXVoaFxwCaQ7av4a2IsNKLzf9TvhCi
	Rj07Wx2EteaTvErB1wMule8uhjH5Y0BdLCTUCUrHGbWm4fK3jQvT2+4M2pydGFl4bgMIxvrkP87
	q/Z0RqjO+LiQQ35Kderrvw7hnJguQVjurfQEZng==
X-Google-Smtp-Source: AGHT+IHxOwITgnRBE6TVGRHtx87wi7sbYnfJoxuv+8L8wixdpSdQXnE1+VUBsdANoINyaftmyTfT0tGd6kA6S8OH86w=
X-Received: by 2002:a05:6122:10f9:b0:50d:4bd2:bc9b with SMTP id
 71dfb90a1353d-50d8cbc570dmr2383374e0c.0.1729066531501; Wed, 16 Oct 2024
 01:15:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241015112501.498328041@linuxfoundation.org>
In-Reply-To: <20241015112501.498328041@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 16 Oct 2024 13:45:20 +0530
Message-ID: <CA+G9fYtqUBXiXPm1kzEabqSzQy41Bh-OieCgnvNi5jVnHh4dpQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/791] 6.1.113-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Oct 2024 at 16:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.113 release.
> There are 791 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.113-rc2.gz
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
* kernel: 6.1.113-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 7e3aa874350e5222a88aac9d02d8bc5a8ff44f80
* git describe: v6.1.112-792-g7e3aa874350e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
12-792-g7e3aa874350e

## Test Regressions (compared to v6.1.110-137-g4f910bc2b928)

## Metric Regressions (compared to v6.1.110-137-g4f910bc2b928)

## Test Fixes (compared to v6.1.110-137-g4f910bc2b928)

## Metric Fixes (compared to v6.1.110-137-g4f910bc2b928)

## Test result summary
total: 205815, pass: 164289, fail: 3758, skip: 37525, xfail: 243

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 270 total, 270 passed, 0 failed
* arm64: 82 total, 82 passed, 0 failed
* i386: 56 total, 52 passed, 4 failed
* mips: 52 total, 50 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 72 total, 68 passed, 4 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 28 total, 28 passed, 0 failed
* sh: 20 total, 20 passed, 0 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 66 total, 66 passed, 0 failed

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
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
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
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
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
