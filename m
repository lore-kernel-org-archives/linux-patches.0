Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7B81CA84
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 06:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744267570; cv=none; b=dNLpVK2jNd4Q27hF9+n7Xdan+YzFDrB7BmJW3aciMcIlaJP+Q16RNTvL4Ikpamin1eYW4xHlri2G7FhutfwqraOqtLMFlnXN+HOSmMQVcZYDGg6AA1nhUSvgtfzBKPxca9Fof6xPwa5GOUIT7ck8iER25F/L7xYiwUp4qRW284s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744267570; c=relaxed/simple;
	bh=sSr05Z4MTo64Ypvx2bVPKbPWej/18+F2EyIz2qX/qEo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EpeArVz2V5RiuJXvJRhLF5sHzKptySsLtU4pyGJYEr+Y4nU6Hjzki1sWfGz8NqEvMDsGh1OdjJ3W7zUMNUOputgPXS/1dkEQy0VB5Gg1a7Q2LQ5M3T0oHuCTpbQKmDfgeOERRftfXR4R1mZrkbsqXwJrutBLTL7Q3K5MRFuUPOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=N+t2wuFT; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N+t2wuFT"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-523eb86b31aso266305e0c.0
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 23:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744267567; x=1744872367; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HPcT11jaYN5mShNHWtq3zBklcFvlC0Fzq1ASVJmlPp0=;
        b=N+t2wuFTLyanLCWM9fPmvc+dD2afMkdJq+XYF95YYOgIQcYaZ7gY2Sw4nsShy0KX7S
         MTj4ZB5N2lD/xWkWrf0l3CEse1LF5vHhEQJW4sDXRIFwcx+47C/doZCKiWwxWYzZqKpS
         9ZJapKjuKEWb7krG9h5BZ4wTaT8dWWnb6Pa7HFcDsiK5QhlfPFoIuSm83AzSIYx3CUID
         sfHHWgGdHh1HB2CUejUG2/nOedJz/YH9MDhbWEt7A70fdiLnqoz2zBnaTOZsfe60HKD9
         Igs1sBS01GOE6UCR63dq9PVz3BVaR+9TGb0ImF/Sxh52OAQN9mfBbvdX3zH2UgsolFG0
         daQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744267567; x=1744872367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HPcT11jaYN5mShNHWtq3zBklcFvlC0Fzq1ASVJmlPp0=;
        b=hTe643P42K0DWZPfbIHwuRkB7P23/nQwFu+44i1ANMVLWRo7Kgpl3HhyY6zK0JnKfg
         cQDxsUbI33Pf9zSxCrUkbK2pTAduuVSDSX1JW+gt2mK4yfBERiUMRoG3dnl0SOgxzB/G
         4Eapm5crCpcp4ekgzLVb6qA5eytU/IUx9UK9mhU+nAJ5TU+6qk/62AmC7PWYQNOvsuZC
         bO0g0zOuzojMPGJWhkImu4xq4F140s4fw51rUKcqCxRCjjoTmmA22NcINXFkTwc/rtna
         EQP8lhCCQoFu+iCuQsRjkWSVHECTpsrfs6gcLxkkngVPbg8pz968vXQPpYthcGCzbWn7
         qv6A==
X-Forwarded-Encrypted: i=1; AJvYcCWNFBINYuivIr8QuPCRuxXgVMoQTCLkKQUgmy5K+Z/dHrqv3Idr4YQKeAnqr1QsFTFzP8CggyW0@lists.linux.dev
X-Gm-Message-State: AOJu0YyMxHIlGEF4hxrir3xRax6NDun2YSFiSj/01TNC8Ql0kngcuTiX
	Ex0Dslr2+W+Q64r2la9iFP21M0jVpH25GMj2Cjnrhhz3Fb+Rea59LK7uYHj9NqUgPoZLUdvq84v
	BbKJx9wQQ+SSXTCjE8WUKcnzztNVxMqDWBcqjPgWGGxIpS9iKJiQ=
X-Gm-Gg: ASbGncvrzUPiECTECVW+ffQXvkToBJv5hq/9KwNr6GgTdjnRDuD9omxBGUNdkIwtDOF
	PhQRfrNbJ/kfUMebkU4RBujFhmEs2055fzJQ3lTlKnd6ozI1HMjKund9NG0rcm+cqzWcKXyQv18
	Un7Ls334Rvb01cRI5/6w0EQ/EBijJZfm/vtWlk90HbBnSAVZ2+6IROi4Q=
X-Google-Smtp-Source: AGHT+IFcF58ptX8rME8i60brMH2Rz0ZUwEDEhM4pTRJ84EhXi3e5CvCfc4pa2+GApvjuzqUGXpEjK1FA2FeBPF3M7dk=
X-Received: by 2002:a05:6122:c84:b0:520:997d:d0b4 with SMTP id
 71dfb90a1353d-527b4fc7f4cmr1132792e0c.4.1744267567324; Wed, 09 Apr 2025
 23:46:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250409115859.721906906@linuxfoundation.org>
In-Reply-To: <20250409115859.721906906@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 10 Apr 2025 12:15:56 +0530
X-Gm-Features: ATxdqUGvW4YOWgoXk4KI1NpcPGcMFtvH6xWIlP3CPREnWd0I0rRk9RpueS2FCe4
Message-ID: <CA+G9fYuB020QpRb2GHex2-0p-=zdhe60s+txw+UZhqSDLP5rHA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/426] 6.12.23-rc3 review
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

On Wed, 9 Apr 2025 at 17:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.23 release.
> There are 426 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Apr 2025 11:58:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.23-rc3.gz
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
* kernel: 6.12.23-rc3
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 27cbbf9f1b51b34889f65faffc14ab313869b880
* git describe: v6.12.22-427-g27cbbf9f1b51
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.22-427-g27cbbf9f1b51

## Test Regressions (compared to v6.12.19-371-g03f13769310a)

## Metric Regressions (compared to v6.12.19-371-g03f13769310a)

## Test Fixes (compared to v6.12.19-371-g03f13769310a)

## Metric Fixes (compared to v6.12.19-371-g03f13769310a)

## Test result summary
total: 121138, pass: 95392, fail: 7426, skip: 17964, xfail: 356

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 136 passed, 3 failed
* arm64: 57 total, 54 passed, 3 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 35 passed, 5 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 17 passed, 5 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 48 passed, 1 failed

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
