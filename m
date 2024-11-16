Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C85192B96
	for <patches@lists.linux.dev>; Sat, 16 Nov 2024 08:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731745411; cv=none; b=ZqlBJbhdYpsrzNytaCkfOjNO+9fBoZiTR9O2mCMKYqVlAFtzjGM6vq+YyIRLBeu8dbRXp//IF5FWrE9S8GZRJNvousg9dGO95wCev8fgmE4EMlO99i37pDEBc5Wo9xS/oYdB8/oMaVNoNZXWVHfi7ZPdtPHkeeJheiQCSX1gBbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731745411; c=relaxed/simple;
	bh=/vAXpvQJcUvvaJpB0creFK6Tfqr0lDfjuAa3ofKrd2g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gpv+pN9Z45FlCpR7VKWKU7+vW0G746WT2s21+F3j82xFnM9P4jzY+jEbVFubdYRCPnVEIi/7INAWSGQMWMv75dJU+0nxsn1TBPczhnroJowNXcx29raOUkez1WmgbtlIff0kBnclPkheigaDeIdQ7+86FNA8r0BIHUbT6lNjp5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FMalckay; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FMalckay"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-50da1fceeacso655558e0c.1
        for <patches@lists.linux.dev>; Sat, 16 Nov 2024 00:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731745408; x=1732350208; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jL+EGpzKO3rkWQkX1EtEQ2OUgQqQWIQ+psOwfG+IX20=;
        b=FMalckaygnfooUBNxxPYyDmZymEq8oyXAoICpSTHGq1WF/+Hk/2jEpWAG3s9rxmDvE
         RX0LmcCrWBrhm3H8b2BiGiryrHBSgZH+ZbJJQP9FuyAILNWRySr9fIkY0IDqOMKPOKEQ
         88ZPr7fs4TLwybyAszOdRrCxBaFeelCamSlzW64k4syGUHzGDd9Ff38hSZOlAnFcceff
         JGCX9n1y+FrUu8hFIadZY6wk+9noEspZjYO4gNe+AYKCjW0aXP8HClx9+gWvON5Dcrrp
         6V1e1a6KdfuabmIx7fkhKJnzgkgCmyHPCMfX9jb1nUMIUXlCSjzdiakawZBK/CCe8lG/
         mhQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731745408; x=1732350208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jL+EGpzKO3rkWQkX1EtEQ2OUgQqQWIQ+psOwfG+IX20=;
        b=a5nKSk2krE9fohyfGuG4IFqbRL3oVbFu0PEc7ABxWlE10tYl1QwNsYjtd339H1G2Tx
         lg0oOW4X5OStin7Dw9a7hQxD8zCUIBPZ1Qu3155vbxsVCOJdeHkUIWwg+ogn58t+7Xan
         3KWICwC8BUIspd86C2BmyVKf61GjGHPWY+rILOFQMooHT1eFpaGbJVmePIOsCKsRzyGT
         n4IvuNkmthJdKw9x5G0BHW+F/f6Kct5QijzwR7x5LcrumyqUV5ztCpfLam0Ieu2AP4AV
         Py2xiofyTOmOUmVmU9NBUwJ0BiHzeRG65dcXrWYkGXHM0HeYFqh45m0tTUwzQN8nD2Ww
         XASQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+65UqiGFPN1q/UGNe3VJswT8dQpx0NGNWkdUMj0C7HR3GxVF2tCP69WGZUjBFRi3BbGOo9oiC@lists.linux.dev
X-Gm-Message-State: AOJu0YympOXtUs6aLJiqD9te7f+6iqhCqOrssvViGBEQdk7C85nP8Ps5
	mjgAK5sAqL+IASOOPdm1SqASbriXfQLRRVYeavYFvpPOtwVjtzP01FLoqb3wPS+TlsCy8rOEB3c
	2f7DfJAFZpaCPN9v/4CdtZ2kbkUSByxnjDtMqxg==
X-Google-Smtp-Source: AGHT+IFfsrHAKWiUgxHG1qmyvjcG0JFl63uHkfBHMWAOjZI7ZUVNK9whEoSXc1qn9TgWJnXz4SICKB+CG8m7VOHh2aM=
X-Received: by 2002:a05:6122:1794:b0:50d:3ec1:1546 with SMTP id
 71dfb90a1353d-51477f148b9mr6219285e0c.4.1731745408187; Sat, 16 Nov 2024
 00:23:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241115063722.962047137@linuxfoundation.org>
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 16 Nov 2024 13:53:16 +0530
Message-ID: <CA+G9fYuZYe7_AfPgjPMqPL9xgAq90kA5T272B3irJ-hLiM0Acg@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/48] 6.6.62-rc1 review
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

On Fri, 15 Nov 2024 at 12:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.62 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.62-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.62-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 68a649492c1fa0ed80e347e707b68e57128fa3c7
* git describe: v6.6.60-169-g68a649492c1f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.6=
0-169-g68a649492c1f

## Test Regressions (compared to v6.6.60-120-gba4164ffa865)

## Metric Regressions (compared to v6.6.60-120-gba4164ffa865)

## Test Fixes (compared to v6.6.60-120-gba4164ffa865)

## Metric Fixes (compared to v6.6.60-120-gba4164ffa865)

## Test result summary
total: 149514, pass: 123228, fail: 1597, skip: 24596, xfail: 93

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 128 total, 128 passed, 0 failed
* arm64: 40 total, 40 passed, 0 failed
* i386: 27 total, 25 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 19 total, 19 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 32 total, 32 passed, 0 failed

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
* kselftest-tc-testing
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
