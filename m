Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B15A20B35
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 16:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718901673; cv=none; b=PrYiXkw4yyNT5BqZ7bI3lwiQphsvBoX9Pi/oZifTqGu9Jf5ZBS5SEGibnurSQp7d2N3BsfSHNxqZcNYHxbBxEcUgsSLCMZV5YnrVWyBYN9CuElVE7RJ/iH8qvT9CmMhaV4uwAIP854Dv/IVOqpG3G799AfRlCJzaWqn8fNkEnII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718901673; c=relaxed/simple;
	bh=ledX+Evj/xF3pBn7sbfyeIbSq+67i7LKlZzPlN9m8mQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BxGBkNsGzpIJ/ll7dvNkZg4oYsHagIb7C+oSJS9oAngWGRf9g2ChTdJSfyMbsJwzJhPoYWKdoJZjoZTMXEzWgR/nizPFe7JDVZMaXIfj9tfIcrVyLJnj7BNSIz0y7pDxMJsGV9XdLoTPiNBUguubMhq1Q+8lqjfzVCL0XMzCyK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v3BS5UtO; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v3BS5UtO"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-57d26a4ee65so734094a12.2
        for <patches@lists.linux.dev>; Thu, 20 Jun 2024 09:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718901670; x=1719506470; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RyDn9eW//5EapF5PlqflhBRpLT8Lnv9D1EdTqTgpHRw=;
        b=v3BS5UtOtAQIy5fHBhR3fpMeVTwYryP51+JE69fQzv0qIq6J8ZhVQoGL+NVsSlXrrM
         iTcIE/W4zD5o67KFy6dQ+rF5eQNDgV2jabqQfPq/HIpc6y2SO8bS7J5nu4TkiRpFRHrY
         SDOhFAFTP2DN17R9BjRxnHrqDjdJCZhcaZhZXey7iCjeE7kgVMYWCJEQNIT3dkT8YGZ5
         Xwox/IN145OZ02ErhT0c/z44+53szGLutzg+n8P0bwpprR+hUF85oJUhKxybomJQM/6o
         N81h05zgWR1q1U62MFdInGYtx0XCjy/mW3+jm2RHKS+AAqbh/AdNjnEgHblyRdZJzcRV
         bl7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718901670; x=1719506470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RyDn9eW//5EapF5PlqflhBRpLT8Lnv9D1EdTqTgpHRw=;
        b=ObopXsE/NMX/KvcCkdXpL9W1eBm+16zQo6pVpgBONjTd1FSspEFHSIeFcB7mtl2L4c
         rThsTU4619btUp8M1gt1If3T+SthMkhRIA2HsX3JyqMYUBW8G5YHykthcACTDMRmY4Xk
         9B9BGaoQbHO+fOz3e1It43hS18hkzMtFVSD/idh+UY6xO8RiQRDhG+6RUXiiaT92DvaV
         6L7bjsUWgzHGaXP+7c9Ne09puRZDLNhD12kCsizLR1CgRpWpHXwEGrbUICjutAZdRsR5
         wvgjHvWeeh6HlJyrXIHiMypjZExd1dRFbFve/SNgU+QaiZH75kNifrT0OqUw22xp0MWN
         Lf7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUYa/9g5TDTAvKKmTyb3M/5zOVJgXc+0ABN8grKmMCMKQE1BjftxK1lBdn3v3IV6vRmJVm6YUTjAiIhltaDGuuPsLv9IOTS1Q==
X-Gm-Message-State: AOJu0Yy3fgX9H+eRDwOcQCSjkA2j8JjICjJESJ8bJ4+uPW4+mxT+JnwP
	X8eLoT/bypqaujix1Up4vqaRVqkekhNWhlNj4/CGQT2g4n6ft+pwx17R7CRE0EzG97lyE5oGORd
	dAwlYDeAL9u68yb/PBzthE2Cac7fVBj62muMTmw==
X-Google-Smtp-Source: AGHT+IFl6ngpWJx0DPdjF2Ef+KV4yVfuMhOWaSlMpqYuE0wg6ck/d9HSJv2HtpaDd2IMYZ/iHKwb4pqg9xmri2HqBj4=
X-Received: by 2002:a50:a69d:0:b0:57c:c6f0:e229 with SMTP id
 4fb4d7f45d1cf-57d07c5bd8cmr3034648a12.0.1718901669678; Thu, 20 Jun 2024
 09:41:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240619125606.345939659@linuxfoundation.org>
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 20 Jun 2024 22:10:56 +0530
Message-ID: <CA+G9fYtjcAUnH1LAGVR_H7q9-TbPk2QhZVXJOARUO4hRDhcDcw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/267] 6.6.35-rc1 review
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

On Wed, 19 Jun 2024 at 18:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.35 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.35-rc1.gz
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
* kernel: 6.6.35-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: 0db1e58b51e37c5cbaa81a40104bd54aad052427
* git describe: v6.6.34-268-g0db1e58b51e3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.3=
4-268-g0db1e58b51e3

## Test Regressions (compared to v6.6.34)

## Metric Regressions (compared to v6.6.34)

## Test Fixes (compared to v6.6.34)

## Metric Fixes (compared to v6.6.34)

## Test result summary
total: 256850, pass: 222555, fail: 3269, skip: 30682, xfail: 344

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

## Test suites summary
* boot
* kselft[
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
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
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mm
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
