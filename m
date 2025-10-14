Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672622F5324
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 07:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760428731; cv=none; b=uXfubNI5VXcbreTRO0vUMl/KdVSu4UBBa1srVZINE66nKtrI1elWUyo9NV+kp1J992LtdszKIFAMb9EQfWt3+hTRpVNC+oEVI5Uv6oDY/rzLh2y0RxvzMUCmlup77VvyAm5oy3pqTU6+GQ53mEF3euAFcUZ9t2s5uLjnfVk7nZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760428731; c=relaxed/simple;
	bh=G2VtRn5hudNwHDgDn/7W78by4qirc2MsuWrSActYjD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rj5aUQpfQ1MtFH5pA5BFZ1sN+agjb3nUG+kD75yw7fqglqFMtj8C9HXIv43sPmqCG45wT5WdJrYiCw+9D/54+E1PeVKaJ6+KeR1Was0w4Sg5pnhdev+CIA+SzJgNBU0rA81/fvBhZq8ieWbj/YzMkzfEajzwPwNpwvjZ2vrhMB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hvaNQTnO; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hvaNQTnO"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b5579235200so3183351a12.3
        for <patches@lists.linux.dev>; Tue, 14 Oct 2025 00:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760428728; x=1761033528; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2gCfEtBQohhUWgvY+Jg30trTCgcmv7nRwq3VJ9R+wHY=;
        b=hvaNQTnOAai7exattaD1t+gzjZUtS0jwJQrdQnl0mp+SEo6tekOxeB6Grdp7R9x3TW
         Zbx3poSM7WlF6t9Br3os7YZXNJzd4FhrFmDnswCffulCxx+H780+f8QcDmXXGLCxuAMJ
         7jIFxJttels1lHeIjL+oNsPKp46p4t3ZBy6aEjJ3LRTNURmpzxyl5MFu5uMkwwXe+C5a
         FQ2G9I7BT/V44e+xMRQo3cbyLuefZVGAKbvpEcxIu8N1wzUzNUGkN2M/iLA4Q8d08KFc
         IC7u78YRfXVSHgPlOm95tofOh7yHWhinve3z2vwLjzRRo1QWidTvHe4RrFIUx0UBgDAR
         PVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760428728; x=1761033528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2gCfEtBQohhUWgvY+Jg30trTCgcmv7nRwq3VJ9R+wHY=;
        b=S2lWZgtTMC+Omh+B2v3AKg1YzyMCiqO9FBDglbNJB0l8vkzK2NHqPR15Y6X0tKkrn2
         wD1JmxvBfY4vUuEIbdPFbsVIQZdVDyk+sTyr09J6VUtK0BmXyHlTQGtC3DVeFvMtiEHQ
         nLShOE+2wHq7cM/65M8RMT64qibRVl5yOXcD1krbj0NjjxIxzKCSvQb2N461dK4KqxqF
         g1N7buS/pf/T1VjsYMYh5AcmAuYwjILpSHun2tk12l4KZG6REX5m8dt6We/vprd0/Nyq
         xa2YVaYRKWoSKIcUtDrom41gDQOT9YRCXTdZem/T2RYGOeIGoox3ZVwPmR+vX6fUdvla
         u70A==
X-Forwarded-Encrypted: i=1; AJvYcCVKvqFW+dCNUFq+IJTUbg1CebVcRc6nARLCFQbue1bN5jyDp45SUHj6u8p2bkzgsQ5jfwi4Zh39@lists.linux.dev
X-Gm-Message-State: AOJu0YwXpjJweriCoGeYBVLv5Vnvnfc+PROE76oz53D0KUYivJD2+/ZE
	6iKJ/ZiSEaMkKIdK12wZn2DvBCoLFkhqt+N1ift3Zli/F3GOC7IS3d8Tk4Bh3wAleiTSJPTEEZJ
	Wd427Ez5UPytx3AMUhOvUrHoLUoDHE8zNsW50aIweKg==
X-Gm-Gg: ASbGncu9eBpQ6brbWCtthlEmes15VG++vS66upbB5+RNAimBlvr786Gsl8rfVvNdORz
	fnZd5IzO5RbKm+mnNLuX7+VfNfQTAsPYtpAAk2+asE0W5/swAamYSQaDM3QDdi81j6xv/4fuCvy
	60boljsrY5Jyr+GMLGLV3xlLa27vV4MEAjWpVvznAy7zR66263WE0Uz3gVCpGh4uzSRhh90k99I
	Mj6NPUqyDsPOU065u8fG5XEWXBHBOE/ZHE8yvBmXbijMNc9cEUCbixdV8JzfXCRlKqruvxbF9Ua
	gT2p9NwXg6Dek1bUuqUPtUR9EG9miw==
X-Google-Smtp-Source: AGHT+IGyLtRwKF59vA/XgA89QVVWWrZXaLpJuoILoiZ0IPjJIP505nZ21laMBq6+MEb4Y6JHPF+ffXMGtMTqV8CQDmc=
X-Received: by 2002:a17:903:f8e:b0:27e:f16f:61a3 with SMTP id
 d9443c01a7336-29027238f07mr282622365ad.23.1760428727710; Tue, 14 Oct 2025
 00:58:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251013144411.274874080@linuxfoundation.org>
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 14 Oct 2025 13:28:34 +0530
X-Gm-Features: AS18NWBVmjY_ZUNYY0Fb-geHzDHpJmdEB3VK9gcbwGTLTufE_jsfJXboVi5C0ZI
Message-ID: <CA+G9fYv4wpxs1zOrnNBCK+oYL7-fsTy2Lxgd9NGMY7PcwPOTMQ@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/563] 6.17.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Oct 2025 at 20:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.3 release.
> There are 563 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.17.3-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 99cf54e7bd2fde42d75c71b54fb3652adea2e7a4
* git describe: v6.17.2-564-g99cf54e7bd2f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.17.y/build/v6.17=
.2-564-g99cf54e7bd2f

## Test Regressions (compared to v6.17-43-g8902adbbfd36)

## Metric Regressions (compared to v6.17-43-g8902adbbfd36)

## Test Fixes (compared to v6.17-43-g8902adbbfd36)

## Metric Fixes (compared to v6.17-43-g8902adbbfd36)

## Test result summary
total: 150604, pass: 129081, fail: 4610, skip: 16913, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 51 passed, 6 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 24 passed, 1 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 46 passed, 3 failed

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
