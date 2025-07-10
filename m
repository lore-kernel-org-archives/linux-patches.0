Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C1D1DF75C
	for <patches@lists.linux.dev>; Thu, 10 Jul 2025 10:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752143385; cv=none; b=LtWK7JOdIBsAXnGST5qOugIaHFstcJtIhPCIOUMKzSoPfuAGd/e37ByNZRVGOJec4g6r7M8VuR75cIpeeV+eV7bjhgiy00jM4TD1qanmCuP24teknu2mWtoeBzHSqi/DCzVIHgfn9x6DBDM+nzxulU+ku9fU5+0HoxB/eKK2ZJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752143385; c=relaxed/simple;
	bh=X4dWfCuAvC2u2fIEaHCnRGK8nxZGyEJAfZE0s2Z8LYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KQ3m0Qak//8UhgbA1z4Ou6hFJKNIvQWblEuxYfWCryiJ/oHOy/z612eln/vublOUUIt4khI/puincZjNrc5Ao7TrMOjm70g5gKjzTLroZ9HlVVGQ9jLGkcsxSeroovROPn/KcUNhRWPxC50Iwnq/lqtkB0htNT+Uuu9GeKRtEJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=erzZtm2a; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="erzZtm2a"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b31f0ef5f7aso544467a12.3
        for <patches@lists.linux.dev>; Thu, 10 Jul 2025 03:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752143383; x=1752748183; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8H5h9tlKdQd4trkg6e5cY1N3SXg7n3+0oZV2U7x4PRc=;
        b=erzZtm2aLb630nRkxrsx3NOgfnRTUaw+rdk5TqC7IQ4nX1x91Rec1p6E83e1yZJJh3
         bvV/a/4O83dI1a67AljDrQYD7/3mj8D676msq1/sIKUMAEA0x+MMAiiT0OB0p5QRoK27
         SYucRclHj8J9n7Un3wkkle1VZRC8lXVVNzUnEfPRdUNCzWfUEAftHVblm0ImK/MxFYwa
         CJYZWffndPgOYsWqSHsu4ZONDA0EmRNXfI5qcAiPyWQGxGyjvcWEa/t95jjv0fwfhDIJ
         dBNnj1HvxU+FGyyEWvOg4zXKKCuJDb8EuB6zMBpowRQ/wuwmuZYsnhpb/UFw3JLhr2Wl
         CACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752143383; x=1752748183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8H5h9tlKdQd4trkg6e5cY1N3SXg7n3+0oZV2U7x4PRc=;
        b=dr77nshfLCgNaa2z7qsouxNVG+NgOR1qPughgtGQgoanC9pqRHCYizAO+UAKwLwLrF
         XXW7APFHtZT8QOKSAMCUHYBadhHjYM6NuwDxTnczMt/zjHpFujU2XKD3I5yIIez+hXVG
         dYD1tGFxY3oQwtm9qdfmb7bX4nkGZoyS+vBvysk2LRT/2lPSchk7D3BWyYDv024YxcYA
         lgE1bx8/uT9El5FXAnRQDmWWZ9/J1WEVl5INyrMRzbiDmoUnQxguNXjxCb6DPnTPtS32
         U/fG20azfryTm9PFw2l0ZHK4hwNFJvDWn/xO8E/LWZvzkXfwUX14edOlyFfioHxqSx7i
         vkpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHr8M/n8IqKzgNWd0GJA2+IpNk3KovME66D039IMNcQcXFBeOK81W40Pzicam/vlyFF9N5EGpu@lists.linux.dev
X-Gm-Message-State: AOJu0YxdRZQS7d24SLyRBq/zHz9wmHp/WLeW7c7ZCDvrj4SMSYiVEP/a
	DAUpteco8ssQ1xiTvh6X6J7Pb35CuA2WBoZ2S6BrqQMIq2o5LFP/gkCkSdjGurkZsufL4xaCrvd
	RIdgbO88Y/PAKkizkksrRMzQ3hxDhTUDZZgM+iffTjw==
X-Gm-Gg: ASbGncv32qK6g1SPjZcFV3kMDXWKnTte9a8YrbZla1gC8z5nHzoLaD5IhAFnu+jB3Fx
	95G6T1zCmEz+m3p75kY/S5UW4vZ89kNLxovLkfGQloLDtp05qTSCJDd+AYcsiqwpZc2YwIgIbH4
	UjYa4q87Bh0L0FnSIVQ4scPqI7TyQqx3VTXEFRGCgNHAjhq1yahpYYd4VU85IQcpeSJI1vp+5mz
	vRW
X-Google-Smtp-Source: AGHT+IGTPRflc71ehM/erqtBSBvrbFlDX7EuK4Oc4DS8WHD5He8D/ywhaBNzOZQtlE1/7Ffka7swie+za5d+pVFLbPg=
X-Received: by 2002:a17:90b:5344:b0:313:62ee:45a with SMTP id
 98e67ed59e1d1-31c3ef2308emr3235696a91.13.1752143383085; Thu, 10 Jul 2025
 03:29:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250708183250.808640526@linuxfoundation.org>
In-Reply-To: <20250708183250.808640526@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 10 Jul 2025 15:59:31 +0530
X-Gm-Features: Ac12FXzL-Kg4EgSJdYxYdn7rWZRJkNLFNrf7e6muOpwhA3-sOwMlQSSbxtPvCY8
Message-ID: <CA+G9fYv0z4NJxEyyB2mtv5f8GThcvgE1bbcvhQxGCkGAVDmt-A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/149] 5.15.187-rc3 review
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

On Wed, 9 Jul 2025 at 00:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.187 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jul 2025 18:32:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.187-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.187-rc3
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 09eb951d49e58b88552e5054a2c1dc20ea1f1504
* git describe: v5.15.186-150-g09eb951d49e5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.186-150-g09eb951d49e5

## Test Regressions (compared to v5.15.185-412-gcab978569923)

## Metric Regressions (compared to v5.15.185-412-gcab978569923)

## Test Fixes (compared to v5.15.185-412-gcab978569923)

## Metric Fixes (compared to v5.15.185-412-gcab978569923)

## Test result summary
total: 54782, pass: 41945, fail: 1996, skip: 10559, xfail: 282

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 22 total, 22 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 24 passed, 0 failed

## Test suites summary
* boot
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-livepatch
* kselftest-membarrier
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
