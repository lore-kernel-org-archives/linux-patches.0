Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ED81DFE1
	for <patches@lists.linux.dev>; Thu, 25 Apr 2024 09:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714036026; cv=none; b=iaTirN/JCBUZx10+ns5zLyaVOaWgulgTUJUr8VWpKKSLcXnmxnW12tQPShO5uXKOdQZyudZvqrZqlkx08485Y1QFx8F6JIPhfcq/0ClkU+YJZJwCHhxcyprShTtnXhA7gsPV+dK6iFjutQShpeBdVpoPAg+CYWuIrjebiLHlaGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714036026; c=relaxed/simple;
	bh=zH5gixlXx7k18tZ3ntglm1Ydk46XJiFzU956q0oQf7Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BNJTIXUuMGj9ECITv88EOFv6nkYWdCQ2lHViYfEe3yqL1j++H5W+iNh6lw7n5EazsqlHppp0VBIORmhDm/P2h0dJwbgs1KAD36eDpOftcOQAENjXJGOIWAwmcZCh5cokecvDcrQJupRzztS9V7RkRzjz4MQJZpE3d3yOe9rjhg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q0FY+F4I; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q0FY+F4I"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-7e7af556187so267857241.1
        for <patches@lists.linux.dev>; Thu, 25 Apr 2024 02:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714036023; x=1714640823; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=seJQmzkxBRJ1xARhjWl+1rguRqRv9yi0CbMnLf1JAns=;
        b=q0FY+F4IMd/QgDSsXXvegYHHBG/x5JtleVwPFNgp6/BVLA3ileYCkZiPyJoXp+WMNp
         a5KBCaxjGFm0TaEnydqU4rRCfvKCXfD1RUMI9X1MtNOxT/Wfyk0HgtMpwN5O6QB1QRj0
         NzSlnbsRdnvK+Il/dFfu851rW31WpOe+p3X7giTmkhgvpVN0jsqVRQhZIxD+eHNvjuB3
         L1cT04sSEmuoCQiHpJ1vKONdyUmZ7aNlq0+W/A/LH2T1cct0BtpPswSFyDkbwPvLrCAd
         yEU5POYIys9zmvd8F+jJydNKd86K4yG0dcDtnB3mcFsQKHEXk8+JXaSDGMnlJQvR07mv
         tHxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714036023; x=1714640823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=seJQmzkxBRJ1xARhjWl+1rguRqRv9yi0CbMnLf1JAns=;
        b=MtprLBeEMQIUA+OtAl38LRtKv5CsnPVP9AQpGgKWhe7xif0eF4PFJGCU9ik5Yg6zPt
         4XfLGDvnvq8OSuYoaq//nNZhat9cCGVnH2QJdauq1ysqrmgSqb5ivh/ar19U1R8SqoBE
         mPBBzd6ale5ZHSrk9rDStuBv0Ew6HyOzRrPE4P+46rKUr6BdlgsTwVkAdtP6Bf3vNSRm
         bb7Xb0jNRbN3JYCCMtfwvY9kQ8oGJ+8fzBBNij8tVusJR+Otw+vhjd3GnoXnXonMk5Yh
         YtMMEvUNYJuSW1xrPLe9FiyYyuhM3U1rQot8jJ3zaqWfHctDlOMC7snIRouuhLD7lHm3
         ENzw==
X-Forwarded-Encrypted: i=1; AJvYcCW3u7LdLe/0k4TAGhw1PpRkoA8Rvscn9Xa/qvQq3VbOl/EFl+/o3QqFtbM9tys3ZPitakPqZ3Hw5DKqsCCFEuI3dCUJqCYriA==
X-Gm-Message-State: AOJu0YwljvCFekvIZthzD7kZjk4vGleQVGqaZ5SKpD1j7nHvObvC5H6I
	QhwW8Re+dWry8gNe+i/8ADPAk464dRUXcy+Jlbh5yA/2biR7Xstzhdnw9RowGYpQDaOWNJ5ByKE
	KGF5fDqBlXUWmeCRJ4oq+VY9VnV3JOVE9wTAk4Q==
X-Google-Smtp-Source: AGHT+IEDf9TqQn6hQ8HPg3898JAvQBiPLOb7KrZ2mcy6634xnDFeMYqJiRsdiAhRN0bTU0Q8+B+hEIjpoxxx/WqiYvk=
X-Received: by 2002:a67:f644:0:b0:47c:f12:d410 with SMTP id
 u4-20020a67f644000000b0047c0f12d410mr4428944vso.1.1714036023512; Thu, 25 Apr
 2024 02:07:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240423213855.824778126@linuxfoundation.org> <CA+G9fYvB61RTie=PKQau1m2WWQNUQ++ZY+W_of4kXVh5P26B0w@mail.gmail.com>
In-Reply-To: <CA+G9fYvB61RTie=PKQau1m2WWQNUQ++ZY+W_of4kXVh5P26B0w@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 25 Apr 2024 14:36:52 +0530
Message-ID: <CA+G9fYvFamPhLn-EVQjiaXibC7hmDYoOeMzTEUWer1xmYLw38g@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/158] 6.8.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Apr 2024 at 12:10, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
>
> On Wed, 24 Apr 2024 at 03:11, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.8.8 release.
> > There are 158 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 25 Apr 2024 21:38:28 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patc=
h-6.8.8-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-6.8.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> Results from Linaro=E2=80=99s test farm.
> No regressions on arm64, x86_64, and i386.
>
> One regression on arm,
> the TI BeagleBoard-X15 device kunit test boot failed and
> it is always reproducible.
>
> Not a problem on qemu-armv7.
>
> However, I am bisecting this problem and let you know shortly.

After investigation it is found that it is an intermittent issue where
log-in prompt was not successful intermittently and results showed
a boot failed but it is not.

However, This is not regression.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.8.8-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.8.y
* git commit: 9919cd9ab98868581abf895dc0913cb6760c176f
* git describe: v6.8.7-159-g9919cd9ab988
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.8.y/build/v6.8.7=
-159-g9919cd9ab988

## Test Regressions (compared to v6.8.7)

## Metric Regressions (compared to v6.8.7)

## Test Fixes (compared to v6.8.7)

## Metric Fixes (compared to v6.8.7)

## Test result summary
total: 183677, pass: 159323, fail: 2769, skip: 21350, xfail: 235

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 128 total, 128 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 23 total, 23 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

## Test suites summary
* boot
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
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
