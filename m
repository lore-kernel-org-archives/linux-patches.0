Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439C71850A4
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 13:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724851051; cv=none; b=fmq3sjyeU+gX/BYSVCVQAgLJrRCOvU7gC7QbPpO7vbQuxgWPttCHHHU/jHfBy8FGwt/oGicipWuhPFT66nKpHOhlTuirehJGTmj0P+qWAvg1jXiVzw0jtKfaL3c0If+LaYUMCXMotCvyafqgc+/shGAnhKfvOmh7UD4+021dqaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724851051; c=relaxed/simple;
	bh=hPDWqLIHM/DnZGu4RmS69ayFXne41WlztcIZGcd8f8k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ii7IS5Zz+A8pxsMUKkPFvH065dBQJ7v8y4M32xLUpqtU8f/Fn5+swvsQLo2U/1Ll0EzSPhTyAxZN/DYRQdtQAJZnCAvxlfE3yySn5tIAhbP/tEphm6vM6Knw12DAU4tL5/HhOsydFLrEiVEYPmxbsnMw4ij7+TvzrptZLhqhPTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=de0f6ttI; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="de0f6ttI"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3dd16257b7bso829620b6e.1
        for <patches@lists.linux.dev>; Wed, 28 Aug 2024 06:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724851047; x=1725455847; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p85AmrzBy9ysQPfxftCN2WfEfLHzF0fIelXYs6ezfX8=;
        b=de0f6ttIX2GfmLckIyko2ZVcYVt17A/PBwKPnL+P2OSXURjDRx2M+51oGtLR4K4C4t
         YRrG05SY8ckYb4JztHFcedBm7XOeBfdxI4DXnlWwHjjr2X5iVtea5E+z01aLGTY2rCSs
         p07DWTmzmF7fdAMWZcRUu0eyoZdNqbjlXZX6SEG+PuH8pdsaGxPZoy9WgmciK7999B8T
         06Pp+JDAUlMJbwqBeyLa2T2JQptgqlfvj43vV3QO6rNGpXH/dC/qFcwvKsDxWqwVM8cz
         W/T03GUrkpC4pbSKqZ89hShp3bIlC1e0AxCYfhjFZ/YDBYKkVolEFNx25tNOEiZ9TQSb
         kjkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724851047; x=1725455847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p85AmrzBy9ysQPfxftCN2WfEfLHzF0fIelXYs6ezfX8=;
        b=Uf6AUF7O7wU0UYf0wAQvemdgRxZvZmxH8Jzxwxq89sPrcZUCxohXO+Mk8nK7zupNYH
         m0/I0VnsX66HMxFnb9BQlpU5+CT52W7VxWKPR+IFMaDd+rSNf7EUA48IO39PP+nEDQZj
         N+4ce4ohfESDmMguWkKFEU1/w/QVh4K7UJnW+jonW5aO+HekZuhexbTHhaQOOW6RiwKB
         6bftqLrzrpe8Jwo4AJW64iVScf0+NCxMgH88Lm8pA4q1UI5G9Ko98h/A89qbsfv1MALF
         w4ao3OWZ6XUViKEdqbuPepEP7fQwuqgRtsJdhdO/DpPG+B1jlTm1iWcD+6Drf5OkXFUT
         zynQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwZlmf2ZLBHhLDjFooi9pg7Gw/ZVwRwImFo54Pe/PYhhBk2bsap4S+YTTZ405u2/ECQW+C20je@lists.linux.dev
X-Gm-Message-State: AOJu0YwXZ86uVlNkflNJk0zIlMujeoePb10wKIacoWtjCJXTR/ovkk2s
	2/qBs75bMuzVo67hUyxg6HBBR4kXsQWbe39Y6DpvZavthXehqib5IWcOXo8H5Mo3NMJi9HV/pmY
	do8LMlhjsDo8fFY4Vc0elDykOcBP7nbHFV+n/jQ==
X-Google-Smtp-Source: AGHT+IG2ZNqmCpvxZnZqXDnDiNptOQpD9bze//Y71Nl6tPd+HcMtO0wrNlyQSgo+kAl6HiZywcc/ScZhP0dm+GM7DHw=
X-Received: by 2002:a05:6808:3026:b0:3da:b3b3:191 with SMTP id
 5614622812f47-3deffbae250mr1974969b6e.48.1724851047220; Wed, 28 Aug 2024
 06:17:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240827143833.371588371@linuxfoundation.org>
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 28 Aug 2024 18:47:15 +0530
Message-ID: <CA+G9fYvH=+SD+UxZ0koz4rtm4XxHfG--oZZCpD0svEcODZ9pjQ@mail.gmail.com>
Subject: Re: [PATCH 6.10 000/273] 6.10.7-rc1 review
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

On Tue, 27 Aug 2024 at 20:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.7 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.10.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.10.7-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: aa78b3c4e7eeb94e23ce019c419141739613862e
* git describe: v6.10.6-274-gaa78b3c4e7ee
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.10.y/build/v6.10=
.6-274-gaa78b3c4e7ee

## Test Regressions (compared to v6.10.5-26-ga522cad06418)

## Metric Regressions (compared to v6.10.5-26-ga522cad06418)

## Test Fixes (compared to v6.10.5-26-ga522cad06418)

## Metric Fixes (compared to v6.10.5-26-ga522cad06418)

## Test result summary
total: 171554, pass: 150636, fail: 1805, skip: 18905, xfail: 208

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 127 passed, 2 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 3 passed, 1 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 19 total, 19 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 6 passed, 1 failed
* x86_64: 33 total, 33 passed, 0 failed

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
