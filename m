Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608961F3D56
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 15:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734536803; cv=none; b=c6G2Yvvsy8WuhBSJ2vatq6foBiLmYew1H5NQpveV5DOQdB1FfrZ+kpDa3409IX34bk2Dnnv5NyvejuDVBpXAn2M65oQEAkDk7fb0x4zjTAxZikizu+Zhagxs1SnD5c6EICkhnCpO3jWn0iOmwRUy92+bGyPNfwrDKKKGKDibnZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734536803; c=relaxed/simple;
	bh=fl10JA3keK+Mu3YbcjUMlWLHDFGW7MaZLwDVZB+DUE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fICJojgAl52zQKOfS+i99uQt0i5b/mg4HNkeA/ayZKHUCPGwk45l5syJ8gY8E7u3h4pnz0deu4HHNp02HaGkgNJ7jr0oDJbKf88LzySEygZISN0ugOT4QoiwAUlBJ8xbnmSkSbBE0+Hsd7lqHQPN5eF+rjOwo3JMSuKINpWgaJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EcFb8hkY; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EcFb8hkY"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6dccccd429eso39154736d6.3
        for <patches@lists.linux.dev>; Wed, 18 Dec 2024 07:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734536800; x=1735141600; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QaQov78Br/93bdXvfIihcrtJ5nJl689OakmMk4I7gu4=;
        b=EcFb8hkYp1JHHKAm7dJVexH9DOQt5uU1ejNJ9dEkF5l7WQoUkWgjmZ9q6vJDsCfiwD
         mDhI/OxlijofzkKlCOq1RtQacbmObJyqlmXUgUEFkJQoCBKDxszjbrnjpQFrbMukC43G
         ZxMcxjsEhlgN7XFnGhn6oFXN2tl3JKlFL72rJyJeEVnx6k2AEJn9+TG50kRJ494NKdSX
         xWFyFSJUFFuRUOWxVXTcaM9xMymTutYCHWnRuH4Q9+q9XscyciwOc92qEAZ2qtEP4M9m
         H5cafiSsnDRKHPNz22XbXzWVZtJfe7KUAH3rM+akhXO07b6dsrQMzwKGNh/oBgmYUESQ
         vAjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734536800; x=1735141600;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QaQov78Br/93bdXvfIihcrtJ5nJl689OakmMk4I7gu4=;
        b=dtol1Jw3oh4NJnVtrY0+tMC3WztvZ9sm+zHBQxxr6CvudHeysuS9VoYpXKmaaRD+lY
         xs8z70ZYXBDIlZ7Q5bk3biZJUpRIDNKbfg8UGmBE66K6WGdGiuW4iKwF4MSf65AU6HkO
         WsKtJGPPC7uWP6uis1AuQGmjIclSaPeWQCtsd2hP+2MPMzB7qQlzLc6EGY3omOIFbYfd
         bNGnn0YUmN/XRVPMydc/bjkj6ZpVnJIsExOaMBDnNAVrVNU68dKIvVYG7qjjjdmU6ahM
         IeCPbpCevbTwZojjnJzv2PwS9SH5Eb8ahfpj+Cz5nVlRV/gTiNhzA/X2ub6ba2DEOoSc
         V94Q==
X-Forwarded-Encrypted: i=1; AJvYcCV6pllfq4Ra4QhXbK42MQ14i6ItOpL0JZIp+WfpDNRx1w/kiY3wR5rWsqHid2DQjYpuUSdmBOk/@lists.linux.dev
X-Gm-Message-State: AOJu0YwdgtqG8NXusGe/zatJ0BJ5WdGCspqVdqxWn3glnbgfx7QutFL9
	ngUF0cYTVeAc8Z6I+r9GgkBdI97V6/tbWjnj2DNh6nNWxKZ/cKSaEPLg2bCCyOi3t4Q4pcENI1Z
	41HpOWdz9XRWnuy6bptR2zpb9LvuLledQaY4D3Q==
X-Gm-Gg: ASbGncvvGzpRQH1HN8j8P8cj+qwSQClceozAG3LgG3kGsJVZYbdWIAV+yspHfERzZaa
	0ruwvD1npvvStHIujXCO5or/O/pDf8iNgfKun3UM=
X-Google-Smtp-Source: AGHT+IE1Pp2xLJTcdKTmRqNCBhElQ10uwnZna/kAAuuyP8gm2xp1+puetNKVCE6BAcbDmo2izyj7vPbmIY4ZIFogv0I=
X-Received: by 2002:a05:6214:2b0d:b0:6d8:a1fe:72a4 with SMTP id
 6a1803df08f44-6dd0925ca16mr52727056d6.46.1734536800344; Wed, 18 Dec 2024
 07:46:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241217170526.232803729@linuxfoundation.org>
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 18 Dec 2024 21:16:27 +0530
Message-ID: <CA+G9fYuqP-XiWQAvj=prtSGVoSipjCzYeaEET=gZSpvjb0LiMg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/76] 6.1.121-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 17 Dec 2024 at 22:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.121 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.121-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The all i386 builds failed with the gcc-13 and clang-19
toolchain builds on following branches,
 - linux-6.12.y
 - linux-6.6.y
 - linux-6.1.y
 - linux-5.15.y
 - linux-5.10.y

* i386, build
  - clang-19-defconfig
  - gcc-13-defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
-------------
i686-linux-gnu-ld: arch/x86/kernel/static_call.o: in function
`__static_call_update_early':
static_call.c:(.noinstr.text+0x15): undefined reference to
`static_call_initialized'

The recent commit on this file is,
  x86/static-call: provide a way to do very early static-call updates
  commit 0ef8047b737d7480a5d4c46d956e97c190f13050 upstream.

js wrote:
Yes, the fix is at (via one hop):
- https://lore.kernel.org/all/aec47f97-c59b-403a-bf2a-d8551e2ec6f9@suse.com/

 ## Build
* kernel: 6.1.121-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 1855e5062cabff8aaf8ff42a0df6998fb40be9ee
* git describe: v6.1.120-77-g1855e5062cab
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.120-77-g1855e5062cab

## Test Regressions (compared to v6.1.119-773-gcb4fbe91b7b2)

* i386, build
  - clang-19-allnoconfig
  - clang-19-defconfig
  - clang-19-lkftconfig
  - clang-19-lkftconfig-no-kselftest-frag
  - clang-19-tinyconfig
  - clang-nightly-defconfig
  - clang-nightly-lkftconfig
  - clang-nightly-lkftconfig-kselftest
  - gcc-13-allmodconfig
  - gcc-13-allnoconfig
  - gcc-13-defconfig
  - gcc-13-lkftconfig
  - gcc-13-lkftconfig-debug
  - gcc-13-lkftconfig-kselftest
  - gcc-13-lkftconfig-kunit
  - gcc-13-lkftconfig-libgpiod
  - gcc-13-lkftconfig-no-kselftest-frag
  - gcc-13-lkftconfig-perf
  - gcc-13-lkftconfig-rcutorture
  - gcc-13-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-i386_defconfig
  - gcc-8-tinyconfig

## Metric Regressions (compared to v6.1.119-773-gcb4fbe91b7b2)

## Test Fixes (compared to v6.1.119-773-gcb4fbe91b7b2)

## Metric Fixes (compared to v6.1.119-773-gcb4fbe91b7b2)

## Test result summary
total: 105316, pass: 82169, fail: 4298, skip: 18795, xfail: 54

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 134 total, 134 passed, 0 failed
* arm64: 40 total, 40 passed, 0 failed
* i386: 27 total, 0 passed, 27 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 14 total, 14 passed, 0 failed
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
* kselftest-x86
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
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
