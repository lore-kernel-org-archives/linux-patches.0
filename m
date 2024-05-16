Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31101311AE
	for <patches@lists.linux.dev>; Thu, 16 May 2024 08:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715848848; cv=none; b=ZGBDmXAgaftGRDswUeWHkus5G1/LwUSBbwbHMDbeGljcSwtaEhD8K0Bu3wf1iKQJ37GlTXkwExfHWx9Mkx4aOOscnsqN8KvBY7+RobyJeyCvzGAgx0UEii6bHHZl9Jw1SUQaQXarW+35J6fhUEpD8/YbiDuJ3jiVN7gvtR2Uzdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715848848; c=relaxed/simple;
	bh=roLqMz8FqyfVf6527S5XMqLSRWOu42nvwfArTsB08Dc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YeQuC+M9DWbM+UUfEZrBOAVIkokPqi/60UPT3ysu5C+erzRnkbkChdike3MKsg2O/aDWF+/VivBzIB0YoaP2/v8mzpwUnd3iJ17GttQrH6yJW+egpxM8GNRtWhQVnKCo/WHeRYrxc5cG+3zKMYrrJRk+15ZmTtgyBD35AojHA9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dM1ItHaH; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dM1ItHaH"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-4df6e7414fdso2441074e0c.0
        for <patches@lists.linux.dev>; Thu, 16 May 2024 01:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1715848845; x=1716453645; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KNAVmwKwoWfzHs+l6xT+mMxjt2LA2ipTuVGLXkM2+bk=;
        b=dM1ItHaHtGcoLM7mLh75BVAMWt7BuD04ZsuKupc8mpfHtP5ZwWS22Bq8tBnuuG56jW
         RpTNpihfPqqv+dkr3jBxfL8f/ZNIRrlq5FMtCoWrZACoqyW4VSrm0S4/Ohn23Sut9c9l
         T1tmlxWuJyAcFJlYcJVDeKq594Xqy0eJe5mh4Aciokwgh6cHFOc03PjRveUlZbAWVpHP
         r3IBBkNH0o4gi/Wb5m3vkFAK/BF/hWdVGC1TT5rbXDhHsTWbkcen51ksdBhqiea7oFDn
         AusU1rq6BcScWsFGtOi5+tU7umpgiLGMDcGyECFLhzMM0ynCjPPBEheCFwGdQAJMIgdv
         RBvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715848845; x=1716453645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KNAVmwKwoWfzHs+l6xT+mMxjt2LA2ipTuVGLXkM2+bk=;
        b=nZeJpjhuaKO1w7AIswfqygI5wRAPzEUtC0o6DSvOqLRxfRbviiB7X2wswckYCZuQ45
         RvuAmgkIeGqcmo8qHyEPWviiX8sD1+lI9gpR6WRqFVbaZeegfA39NyTer6qAl5Za2Efu
         HmyjW4AGfr/q/9a3RrG4+1diU63cmmkyd1Y/mTx+1J8G2Nr7j1PACCNrrMMDplYxqoaT
         Xzj8CsogK8Wequ6pJppOrdsX/sO5GMtVPfPHsAkraXGOWofN2PPcl885r6+3vcRjDmpb
         c3lkpJrfQgcnvrb3QDYrfLmMnILWTDtT7lhmB63H7X+epb594pQqyTr6KZwMsRcJGYnR
         4deg==
X-Forwarded-Encrypted: i=1; AJvYcCXZoxDKFt1Y7itV5lvfGOVED5Q4ADIu+YoZ3dxlinowPoehkxzIsWRqaLhALD13BeZBBwPJJ/Vg75jlnNedtXNuLWY5mKM40w==
X-Gm-Message-State: AOJu0Yy5Lzy7iXLyfFSbUaTQMZCIR4UKEaxfH/RQuzqtLBAdw6QHEmyj
	uVh6ONYmMYlguGxU1H5arPEjiD+NNxWU66FW0/CXpbRkhTqXLYN3LZDC6yTLZrNDz1eBJsOYhd1
	t6zGJyImJJqyMxTpnBSAI9JPG517l7mf40U0qng==
X-Google-Smtp-Source: AGHT+IGAczQ2X1s0QEP9pFvhWZ9B/pTAeRQwN6LW+rOGXflwh1HJZbZKRNSwz4WMtA43g7n/wWbl+4inojdNkhyvrSw=
X-Received: by 2002:a05:6122:2215:b0:4d4:1cb7:f57a with SMTP id
 71dfb90a1353d-4df882d2696mr15840836e0c.9.1715848843208; Thu, 16 May 2024
 01:40:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240515082345.213796290@linuxfoundation.org>
In-Reply-To: <20240515082345.213796290@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 May 2024 10:40:31 +0200
Message-ID: <CA+G9fYvtMyHwnPVjtp5vET9JWxXArPWdY_U4zrfA_ixNAPnmbw@mail.gmail.com>
Subject: Re: [PATCH 6.9 0/5] 6.9.1-rc1 review
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

On Wed, 15 May 2024 at 10:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.9.1 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.9.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.9.1-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.9.y
* git commit: 17f066a7f99c86ac634c661e8e013b124c4726b0
* git describe: v6.9-6-g17f066a7f99c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.9.y/build/v6.9-6=
-g17f066a7f99c

## Test Regressions (compared to v6.9)

## Metric Regressions (compared to v6.9)

## Test Fixes (compared to v6.9)

## Metric Fixes (compared to v6.9)

## Test result summary
total: 180327, pass: 155672, fail: 2287, skip: 22368, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 127 total, 127 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 16 total, 16 passed, 0 failed
* s390: 11 total, 11 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 32 total, 32 passed, 0 failed

## Test suites summary
* boot
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
