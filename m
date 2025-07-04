Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5302F94A2
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 13:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751635541; cv=none; b=HU/ncYU5N5oftgCySQjVz9XN/sshvi7IIty3ZhZ7/vZexIzFhQySOVyROJLvIbVrARpbouj3JConPXeXfwJrSeUskEGS3kXLjdkWmMJNoTWZCdwKq4f9/lKdMb8HnP6feAisXU8vNPfSYRFV2how365Ju0eXjDOhpWqK6MGeDqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751635541; c=relaxed/simple;
	bh=8lKJP1Z5Y7Dnii9C693REqDKfCL8ddZW23NtRFLW07g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E+QS3SWMELj5TpB27UF7M1TvPDZwrEhvMVKUCjV2wnvlaWWuszkzQkpk06xJSx80pbIZ26qxAG8EoQ3SwUGW4MNJ4oAz0Ofvia++5IB1y7I0f6aQc6qW8qag4mIffWfO2e9aqk3d/cBMIw3W7EH9Y4+8ztfizGwmHqz1gUAy2MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OMeZr4v/; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OMeZr4v/"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-23526264386so9608715ad.2
        for <patches@lists.linux.dev>; Fri, 04 Jul 2025 06:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751635539; x=1752240339; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mdrJVJb2DLNFcGIFOTNNoe56BFKKklEBsHxLiosK2WU=;
        b=OMeZr4v/8uCGq5mgBh7/TOm2Itq4KfkGWcI2JiVs4Tm4UaMDxUB2j9OdhmwENHgz99
         61g7Q0W5bQIQzw+77FzNoMr2YsFMOdAio1hQM0dRSaudSuePHcYAFkf/l2IPDcVnXlnt
         lzVpFmnqn0WzoCJvZdJIqYLD6KSG1ESqJffhu4QzlHGNUh9y0fxqG9vNIrs0g0FqqMFt
         8x5lfBSDFnvrTSgzVSVJEniqnu/gDgScQYIbGoOmLSxntkLsUiVZa+Yio/XcubRwt+F5
         qvFk6+G6FY1mQ3NY9U/D252y+13wgzfhtiVv/1a7uGgIs9jhaloVfMDNFzXcQz1E1Q0h
         S/ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751635539; x=1752240339;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mdrJVJb2DLNFcGIFOTNNoe56BFKKklEBsHxLiosK2WU=;
        b=JYsRUoyuR4qPk5L2cTo7tYyuy+m083O9N7YByDn2PpHIdeqK6ovbbzR9Yxk2ZsGgW1
         WYbRuxwlpo7gi8TzH+/1+Oj+7+V0i0xIM5rD/zyx7R7iuII4VZ8M4HVgg44jEIqomwg0
         W8cyV77O6k1QLB5FEUpkAP1HZZEwUXTPuyzun81V6U3y3+BO18DknumIvU1JJGrNmjJ0
         wmYmehn41RroKFfz0vT8wNc4bdoGDIFYHC0x+VfqQ2Ca/ve3/ZYiD/AXXCyySpz8awyI
         EBIpuTuVFfd1YzlY8Z6aOlFt2PC+QNwMcZymaPYwa5Cn4bwCWcpEZuZ9/eNFGfKg/pDK
         CZqA==
X-Forwarded-Encrypted: i=1; AJvYcCUyNr/QSCMSkSNRWqw7EHq8klkVdsPYadTyruGIZuDgdaBxWD17+8iZm7di9Sk5jKJNMOkbRyEL@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1fTKM5qxAMPzNjHHM/QGRXKNATtVX7NgpACyLKFqREu3wLFQX
	TR5MXWcl++9BYEhfv37ED2Kq867ClNeKNvAFjs3ez5SZyd7cM1FrMfd5kkgmLbY8RgLHsRZ2NRI
	SNvVIY1IsDdUO8kzLPQlj+hWfhSw8dx5O3aBdfFMQvg==
X-Gm-Gg: ASbGncstSQ1cBe+eWJsvym+ARxMOTKmwaZHroFJuxMepXyAZNyDHaRWAJcHPvgcEY2V
	5wh09hVFgTMg9iuVOPEEUpCN54TDOdjJXCP/RRwvKLfXFJNM/sUs5Tfz8MQ8vro3v2lEJ8n+vXY
	8kbn62eRkXWcpO+1OXw/pLapyiKknPfT0H13ifhgSNCQCgC+/4FUJnqyS87cCOWBMDGeFWornUH
	pGs
X-Google-Smtp-Source: AGHT+IEJ/sDn49EvivdcN4MphJg5GlX/nLZFnn+yYbIr+govC0++eMS6gpldFW4QKttk+Apc0UaImPReeCzAUISOslA=
X-Received: by 2002:a17:90b:37c8:b0:311:ab20:159d with SMTP id
 98e67ed59e1d1-31aadd9ce5bmr3234913a91.19.1751635539104; Fri, 04 Jul 2025
 06:25:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703143941.182414597@linuxfoundation.org>
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 4 Jul 2025 18:55:27 +0530
X-Gm-Features: Ac12FXx79trvmIhjSYqu8P5hDN1zeNOSmCT2hOXSGMNLXknUMkdBqfZVS5xK8Kw
Message-ID: <CA+G9fYu=JdHJdZo0aO+kK-TBNMv3dy-cLyO7KF4RMB20KyDuAg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/139] 6.6.96-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Anders Roxell <anders.roxell@linaro.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Thu, 3 Jul 2025 at 20:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.96 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.96-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following build errors were noticed on arm with gcc-13 and clang-20 on
the stable-rc 6.6.96-rc1.

Test environments:
- arm

Regression Analysis:
- New regression? Yes
- Reproducibility? Yes

Test regression: 6.6.96-rc1: coresight-core.c error implicit
declaration of function 'FIELD_GET'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Test log
drivers/hwtracing/coresight/coresight-core.c: In function
'coresight_read_claim_tags':
drivers/hwtracing/coresight/coresight-core.c:138:16: error: implicit
declaration of function 'FIELD_GET'
[-Werror=implicit-function-declaration]
  138 |         return FIELD_GET(CORESIGHT_CLAIM_MASK,
      |                ^~~~~~~~~
cc1: some warnings being treated as errors

## Build
* kernel: 6.6.96-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: e950145d456d01fa4e589d5e6183c2f8f0676743
* git describe: v6.6.95-140-ge950145d456d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.95-140-ge950145d456d

## Test Regressions (compared to v6.6.94-289-g33e06c71265b)
* arm, build
  - clang-20-lkftconfig
  - clang-20-u8500_defconfig
  - clang-nightly-lkftconfig
  - clang-nightly-u8500_defconfig
  - gcc-13-allmodconfig
  - gcc-13-lkftconfig
  - gcc-13-lkftconfig-debug
  - gcc-13-lkftconfig-kasan
  - gcc-13-lkftconfig-kunit
  - gcc-13-lkftconfig-libgpiod
  - gcc-13-lkftconfig-perf
  - gcc-13-lkftconfig-rcutorture
  - gcc-13-u8500_defconfig
  - gcc-8-u8500_defconfig


## Metric Regressions (compared to v6.6.94-289-g33e06c71265b)

## Test Fixes (compared to v6.6.94-289-g33e06c71265b)

## Metric Fixes (compared to v6.6.94-289-g33e06c71265b)

## Test result summary
total: 224212, pass: 204338, fail: 5194, skip: 14300, xfail: 380

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 113 passed, 15 failed, 1 skipped
* arm64: 44 total, 44 passed, 0 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 14 passed, 0 failed, 1 skipped
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 36 passed, 0 failed, 1 skipped

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

--
Linaro LKFT
https://lkft.linaro.org
