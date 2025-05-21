Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCC123D293
	for <patches@lists.linux.dev>; Wed, 21 May 2025 09:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747819499; cv=none; b=rYtcnyjRsyby86uC2biwXdY9oEH2TKxuSOID2BnBBguEsAcHxn7LzBGRL57Cq1lKGKPnGCPFBnKer27JqbqNPu9U+LIrkf8681apYODEBQj0GA/PQ1jnDZvmpzSo8HI3CYdz5QrbEPMHalU9IvIL6jxE4WwkFiSPYi6wm2gx2jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747819499; c=relaxed/simple;
	bh=SavTODshLkzYqwL86QGyu6EkUkeSNhbB+u+NcCVLQV4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HK4U5Kmyj5/ww3Ikxy6kwiy+Noyio+bx3ir4nXM8noy1oIuMYjeWFyi6fCvHlVawpbEVwGsFNMTyO/efihYqg6hKjWuxcvKupVRCJddYFNVqTfS9YSk59k+kISWcF8pxS6vsIF8H81sm57jPzgaHr+UUUj+uahlQELo01HZlmEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=flkbbiAp; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="flkbbiAp"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-4e1382f2b24so3673805137.1
        for <patches@lists.linux.dev>; Wed, 21 May 2025 02:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747819497; x=1748424297; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y3hWC1VK1BIw070IJJezvDB/VqZ9aNqLVgo32LJ2soE=;
        b=flkbbiAp1U6Vy/PYdRYcIu2sJ0vcIUcq4+0DGOBD3I632D6bSao2bkFpXSQ7LyWmjD
         B69+w+wgrMR1j6lTIuwFo4XRDrQ8Yjf4vdHeWuSGMn0pofhl8FLw1BZH5pebT4xM5Q1P
         ybGqxqDHABxDc5PiUooJkjoq+sGMUKVvEsXEWPpwO+6KQiOOw+xyiJtCOL852xjS/rJI
         Xx5xQq2MV8WHgGKlGVzRlrBpPQs41+ly3/1q4kfN9jWaQmoTqvkkwWNkQsG2iKECq69x
         u4CuNOaKM0Cc1vwR4L8pPL5tQssjKhTNHoOnLde/rsBq4EPcum2xnqPYlNE6iPpk1Sfd
         5R0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747819497; x=1748424297;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y3hWC1VK1BIw070IJJezvDB/VqZ9aNqLVgo32LJ2soE=;
        b=cCBedo0BoaZQjPu/MxQNpzuF0PX2Cl47YQp5ukzgc+K2vV7TAnymnuCzaXFb175vF+
         n47wxEv+YolF+FAhu/Uy5uWNCn7lx+HzvYHAo7LP3vTvrkP0dEueKXTzdw6OFjvTtTwC
         uOymffEDmZeorMmh1R+tiLSqjDhp8aBZMQc59jEjBf8Nuob32+d6qiX4anj+3+uvWYGG
         g3prbTWqPlNUPoroCyv9f9PPv+QJzb/tlnfFfdine8hwgvp4Sh2Ja5uhktLmb2u9eqYv
         1TPM3hVg3D4sr+i6E/ytizbDqurGqDBmOZOudhZ4OqpN8XboqJWoMYNnB6/MBx9IlzoT
         gPIw==
X-Forwarded-Encrypted: i=1; AJvYcCV3dJBjia8wdGIltQgz0Zp/nW/tWbNZk0Gau/VcZTRejCFo8XZhRkC0y9LBvKQQs8sM3RUkPAD5@lists.linux.dev
X-Gm-Message-State: AOJu0YwT5/JfDTWiGsFTZkyN86tTW0ilCNDpYvPpCXThi/Jzp7HB1n3E
	VjivQyDu/w13gvFkTFjgUjOnYXKnjA6HGnNJznTOk1pevGVBczdFQMG5vNHbRU8YU7hfjNikAUG
	T/FrcSaS7pPgEy/R62sPtXam9W4xTlSgBylJiCTtO+A==
X-Gm-Gg: ASbGnct5kM9jdMrud7XY0XvX8tuObeU/WDwWEqdwg07CgOOYfX9i8MeZLvLOrXjpJPG
	jCPJP1E5G6K0j0hzwbMPnDsR19swaXsVg7o46n4KfuFCuM3rXpuHArILTjzHcQDIaM61M1D3eoN
	OM4UeNuXnb8KuP8P/Wram/VPopIetC6PBC
X-Google-Smtp-Source: AGHT+IHybR48EbvrBa29y9puviflM6BTRI7N0qtLYKnfE4iwghlm6IPecE8XTgSi4fNgHyd9vdOk97NIcw1zz+FQxY4=
X-Received: by 2002:a05:6102:370a:b0:4db:154e:ad1d with SMTP id
 ada2fe7eead31-4dfa6aa8a8fmr19845230137.2.1747819496744; Wed, 21 May 2025
 02:24:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520125810.535475500@linuxfoundation.org>
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 21 May 2025 14:54:45 +0530
X-Gm-Features: AX0GCFskf24dlsDWbKHkhQN63sjnMSpcZ3dtlC-TQcODUS0EOjnNNGC3AAtyqw8
Message-ID: <CA+G9fYuQf1dvNFru8dtiJnvJZjfKuMwN1DhN0EKrCLCR6DNbnw@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/145] 6.14.8-rc1 review
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

On Tue, 20 May 2025 at 19:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.8 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.14.8-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 75456e272f58170ba9694debd95bb643fc199e6d
* git describe: v6.14.7-146-g75456e272f58
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14=
.7-146-g75456e272f58

## Test Regressions (compared to v6.14.6-198-g6f7a299729d3)

## Metric Regressions (compared to v6.14.6-198-g6f7a299729d3)

## Test Fixes (compared to v6.14.6-198-g6f7a299729d3)

## Metric Fixes (compared to v6.14.6-198-g6f7a299729d3)

## Test result summary
total: 238113, pass: 213864, fail: 4515, skip: 19096, xfail: 638

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 16 passed, 2 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 22 passed, 3 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 42 passed, 7 failed

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
* ltp-ipc
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
