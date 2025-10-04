Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4581E221299
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 12:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759579557; cv=none; b=nZIivqUGnoizgS7ny9v65OqlbMipmNZPVVT9J5ndjKYwJLt8SLEZg2cO98G8JavkU/RizkNM8PnH2Mu93khvHXNdQbmTkPKsG8rq78Uw9HHyvHp0GjWH7WqjUtIHNSOs2+bz9WEM/WgSRtrPEvVpVYiC5Oa0dN2S3SAORI89XtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759579557; c=relaxed/simple;
	bh=R1q7kEUIMV+6cN8A+xsA3CeTFAvUlbpVDYZvc0xGTlM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ye/nhiqs8hlyN6KxoIUZYqP8MeAEZjZ4tdUMObhWDk379DKxqOGMxGsykVm69cXMNq5El7mFsMnjZJfgFuX/Xm8g+wRZvG4ix0qnnqd19j2BB1r8qpz/y+abYSatN1pOZ0FmoZ7YrDeBYeeVTacB/ehkfp4m9jt+7GEZYMfAd8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ShZPZRl3; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ShZPZRl3"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3306d3ab2e4so3824288a91.3
        for <patches@lists.linux.dev>; Sat, 04 Oct 2025 05:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759579555; x=1760184355; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RvMiexLJvP6E79APrj0rLj11cSNtbanirw2a0dqWnQY=;
        b=ShZPZRl39+WJSrATrMh8Fgr6eIwcXhYBjG0ewScm4ut8eVFmgmlXkQiaYlpXTOHo1r
         qDUCitxx7KPNgUBdUmFOY0Aw6tsiWcRgneV/zHcwwV964j4eOwLGX1KXbJn8weejz9Nw
         +Ech1cVpw94heEhAXFoZODGG7uwHZtSBhlMXPyL9lyQA/hopjS3e645R21gPPbHmmnEC
         dwwzemwWSQ1EsuyF9Q6EsThphIoqkaeeHe4qXxwmSa3kcP+qKrKO0sySjPtCE26JLmtb
         jxizXGVvy5cN3H5P6Ih8KvP+jO3v70ForKA4Afnh2F13EtQIarnc6Hyc4MW+cTk/BBSo
         AJlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759579555; x=1760184355;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RvMiexLJvP6E79APrj0rLj11cSNtbanirw2a0dqWnQY=;
        b=P4+kXtyn84ShXEiqLEw6RJMtbERdkOMjjTJqdlTbXKqDWwy24HFFe0NclcYtVVtjTz
         xCweQeQ/N/ohE3AxEC/QzwkFKsZO+H3hobdHqq/QO2jRqqPDk1QyMVwy1yUVcqcG6d5k
         93CG60gtSrwHjbVoiHN0f9H9+tCYrhnbD5hG5CVvgtU83rLC0H5IfrU3LL9wuOhd0Yn8
         Sz/P78PKhncs3Ahq4k5+u4B1vv262g9BFi7vLeyauKvd7mIElh4M0KCmEQuOVqmj4zRU
         nrc5S7jyyRUVI1Os+X/bGU2Y03mx3E02wP43n6ogvHZ5difRAXZSMK0xFgaIWNkPrRhH
         1nOg==
X-Forwarded-Encrypted: i=1; AJvYcCX6YJvrSnAkb0d2diN7G5ErT7gn0KOcFrRK/0bC9KPJTrjKs4OGCu1D7VtIKF2y9rTUMOqQafKO@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4+YfI74BdDcgItax87nylyEMcv7sHx4NJU89OS6Q5Oj/hw1Ac
	9n4nXfd79OfHEGLmI4Vo4i1s6EQxJpuOsSwC7XE1aPLm0QD15r5sB2kRnV5Nt5xJflIXDOsxzvO
	qfNrJVKpRtLokdFLpMsMard8ZCH4g6e5be2mwNM+jXw==
X-Gm-Gg: ASbGncvU43WHURu226R++bbRjFmYJIdXhT31WfPWziG3x44LQZ2KKkmUc+N9w7C3A7x
	RoyC+aX2p20er4EfyOYqwqXgjWYrQXFgbHdGdwfRTObFqqBgLq5K8AJwdDznGFfqwv5yTWdbNl9
	hvDA9REitvpyZwlH36Ez1X8Cm7AlsI4+FyGm28CzKA/ZzzWNxluI7w0d0A8dBeV6B2dScwzIiP2
	qesOwXujiCCikW7f94GgiCDD0jXFf+hOTOrTclvmJ8BxVX5h5Ie+mje/GUscG3ltVF5+T0DshmX
	0ABZFMvJ3iDIrkTHqiNoS+oz
X-Google-Smtp-Source: AGHT+IHUcUiJvywAA3BHIQxICROug7QzGkP3JuEDSXUGBs+FalO/ecqWea7HGT/2uJb78TWgsqTWeIQtZungiwh66Xk=
X-Received: by 2002:a17:902:e78b:b0:26d:353c:75cd with SMTP id
 d9443c01a7336-28e9a567016mr83165785ad.21.1759579555517; Sat, 04 Oct 2025
 05:05:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251003160359.831046052@linuxfoundation.org>
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 4 Oct 2025 17:35:44 +0530
X-Gm-Features: AS18NWAObnZ1L7fWSoS2-NJL7inBt0GzGopLp_3E_Hq02ONyESgBFKR13d7cVUw
Message-ID: <CA+G9fYuW6+KiuVd+ONpyo-vWCvF=dSNJzc0cdarBXjNY_XGaAg@mail.gmail.com>
Subject: Re: [PATCH 6.17 00/15] 6.17.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, Kalesh Singh <kaleshsingh@google.com>, 
	Juan Yescas <jyescas@google.com>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Anders Roxell <anders.roxell@linaro.org>, 
	Ben Copeland <benjamin.copeland@linaro.org>, Joanne Koong <joannelkoong@gmail.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, LTP List <ltp@lists.linux.it>
Content-Type: text/plain; charset="UTF-8"

On Fri, 3 Oct 2025 at 21:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.1 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


LTP syscalls swapon01, swapon02, swapon03, swapoff01 and swapoff02 test failing
on 16K and 64K page arm64 devices and passed with default 4K page size.

These failures are noticed on Linux next and mainline master (v6.17).

This test failed on 16K page size builds and 64K page size builds.
 * CONFIG_ARM64_64K_PAGES=y
 * CONFIG_ARM64_16K_PAGES=y

Test regression: LTP swapon/off 16K and 64K page size LTP
libswap.c:230: TFAIL: swapon() on fuse failed: EINVAL (22)

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Anders, bisected this on the Linux next and found the,
# first bad commit:
  [bd24d2108e9c8459d2c9f3d6d910b0053887df57]
  fuse: fix fuseblk i_blkbits for iomap partial writes

## Test logs
### swapon01

libswap.c:230: TFAIL: swapon() on fuse failed: EINVAL (22)
swapon01.c:39: TINFO: create a swapfile size of 128 megabytes (MB)
swapon01.c:25: TFAIL: tst_syscall(__NR_swapon, SWAP_FILE, 0) failed: EINVAL (22)

Lore link,
- https://lore.kernel.org/all/CA+G9fYtnXeG6oVrq+5v70sE2W7Wws_zcc63VaXZjy1b1O1S-FQ@mail.gmail.com/

## Build
* kernel: 6.17.1-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: e7da5b86b53db5f0fb8e2a4e0936eab2e6491ec7
* git describe: v6.17-16-ge7da5b86b53d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.17.y/build/v6.17-16-ge7da5b86b53d

## Test Regressions (compared to v6.17-16-ge7da5b86b53d)
* qemu-arm64, ltp-syscalls
  - swapoff01
  - swapoff02
  - swapon01
  - swapon02
  - swapon03

## Metric Regressions (compared to v6.17-16-ge7da5b86b53d)

## Test Fixes (compared to v6.17-16-ge7da5b86b53d)

## Metric Fixes (compared to v6.17-16-ge7da5b86b53d)

## Test result summary
total: 162823, pass: 136895, fail: 4815, skip: 21113, xfail: 0

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
