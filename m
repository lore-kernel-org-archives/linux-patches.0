Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CDE204F9C
	for <patches@lists.linux.dev>; Wed, 28 May 2025 10:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748427743; cv=none; b=r7D21vvfEtxTFe5e/kO0OCwYOUL3+DXMitts2XzxxHC3g6GiuHULh+Ua5WkBxbr0dwRa/KqOwxzNaYS7bwxESmnDijHqcnmPV/dtanCZogQ94xu88T3QqZTtFEvg25EYQ5hD8W7FBvmkKY0gdzbCPH5044i565xcTFoxTM8mGwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748427743; c=relaxed/simple;
	bh=xIZDmtQ2bvvQrjrF0cMpsxOEeT+sh9IA+MNDwQ3A68s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O8LoQY2/VbBML5JLezTmGgtWtDcs2/5qpGZOp//fJAXEpaR3FzfD6U9jB7cigVo//kwZA2pn8/z78Eq0nPiJM9j7dM6Yk8U+9Cuq4G0Z3rgChH3kUTHP1xNEMahafYjPrgQ8H8Mp7fyucVgFVPprWSMWLgJg0cAL0HiKoV+bPws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZSN1lj7U; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZSN1lj7U"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5240b014f47so1296023e0c.1
        for <patches@lists.linux.dev>; Wed, 28 May 2025 03:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748427740; x=1749032540; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UAEI9dBBmQszHW+RKw/FSPz3iCXRW4F3HWgkJ+DnBwI=;
        b=ZSN1lj7UhhlVxLY5N2KQfEmaHm9W4oBzFf6l93iZ8lL4Mt2mCO7JHHPhyKrfDP9+La
         pIrn/Mt3a46FoVLWiogHnO9wlKK7P9uVf74x8Yn+9nWt1Qc6VwASLDItzQSbrPZ6HunT
         tj2Xi8R6Rte0OPTn+3vNW7xrK8l0UI+ENkjhnGXuo85Ty4CCjRhQicUxLaKN519mDM5b
         QlcNXZDQ3GqMyPvdfcSxWwp+KnlNhPU1EM067K1zq6kZ13SKvmZXltD84nytHPZgpZ14
         VKf/8Xak4II2Zo5VjrR34pKimU++Nk/tbkfCX8rjtgG0yTqlB6W/aBJzsU6MyeN2zQIy
         LplA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748427740; x=1749032540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UAEI9dBBmQszHW+RKw/FSPz3iCXRW4F3HWgkJ+DnBwI=;
        b=rsCfo1FXy9wGRoLuycF6AiB/OaD7zUaQPiI33sPyX9BvruHbw+vrpCj6yMehwvxXdg
         zIwLhP2J1A26LMLNB5A2REkLGl24TKMeh/ozgM6ZI93ZiOOjppcv/I/yg3SBj00vo744
         6ibbyJG+3MCST2NxwSAIHOAsYHJJbty2+KEls+OIeueg7NcJi9zpbnvCaQIiwTNAjkfm
         V18XaE4vw9EHsKYCQxDAV7zqiFsPWkruRfKGMK8sBfQu6mhtRZFiyX7KTkDshO4cRA2n
         PYbt+lUbRZB3NC6DedhSTIFI9GDBLKDVTizPllz4zTsjAyFNGODTt/9ccsvfD1RhW3BZ
         34eQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIbNUCuZ0CrbLwVwmKzTNbZMyksn9pYo70PtCh92fTPQQM5VVBYNK2U2X0jtvN/01sWm3xUdzQ@lists.linux.dev
X-Gm-Message-State: AOJu0Yyi3H1dDgEubDF6L8r7XISrvJKRvKNNRffHDyB+y3ibqDwIxU6h
	xEHxi5H/LqvjA43GyfQQPtHfyXxBppcXhNsP27kWhjYc3/PfDYcB1os3+BvnhdQ6W0CBQHjbWzk
	ijWFFSlypcJsF5hks7vcne6ss9ZaFYDLufBjUrt2Waw==
X-Gm-Gg: ASbGncv6cNCwrbf+/KRHR7BHCng0RCjkBem9FUSPo9XWiJbnHaFuPQmT8vwI94Sx8UI
	BJtj9UWZpzy/1RCB4L/vnpaOtRWmHTw8uzVCTUYDhPmxpk/bVML7rjP0qN2tb/9am4f+CHruQ10
	I8nfJz6gK/bDbT7zVG58cFTc1VmfKRoC8PModBhhr41wP49KQIMK0BfSax3sN1kJU=
X-Google-Smtp-Source: AGHT+IEO3OOrOKakDBXhBTdlrsfwTV2dD71uDOAnQpVHty/kUYLxbnKLo9QmXXM/u9gXgZxa0nnw9P5aUEWPNgid+No=
X-Received: by 2002:a05:6122:d9b:b0:526:1ddc:6354 with SMTP id
 71dfb90a1353d-52f2c310e57mr11013519e0c.0.1748427740331; Wed, 28 May 2025
 03:22:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250527162445.028718347@linuxfoundation.org>
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 28 May 2025 15:52:07 +0530
X-Gm-Features: AX0GCFsXzFBM0eq21JXza1j0vn6z6QdWuG8ZgACS1SYBRb2dXaTUVPRzdxziTBQ
Message-ID: <CA+G9fYsJ_=E0+eE0p32TZ993JSr57N9eS3f=B-conLWJwts3SQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/626] 6.12.31-rc1 review
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

On Tue, 27 May 2025 at 22:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.31 release.
> There are 626 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 May 2025 16:22:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.31-rc1.gz
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
* kernel: 6.12.31-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 3fc6e1848884b217db332a5f677a33ad485a128e
* git describe: v6.12.30-627-g3fc6e1848884
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.30-627-g3fc6e1848884

## Test Regressions (compared to v6.12.29-144-g28ceb2ca3164)

## Metric Regressions (compared to v6.12.29-144-g28ceb2ca3164)

## Test Fixes (compared to v6.12.29-144-g28ceb2ca3164)

## Metric Fixes (compared to v6.12.29-144-g28ceb2ca3164)

## Test result summary
total: 323787, pass: 297841, fail: 5458, skip: 19725, xfail: 763

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 21 passed, 1 failed
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
