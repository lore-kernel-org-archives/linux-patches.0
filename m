Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AF11D545
	for <patches@lists.linux.dev>; Thu,  4 Apr 2024 16:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712246548; cv=none; b=mYXzCPNetmD45lS8QENzmdx4BM0XLWftf8/hEKKVOoQDK/k0x2jwjDeQJrGbhBWIqSVL46Ay2mHXs0DFe05FNVMIURF2YT6DL9923IFaNW02eAB8yDrvFBKKUa2hkyAUxfIjo6KcPCkPGl2hSwMGzKovmLvbp7JXcTqwiGKmgUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712246548; c=relaxed/simple;
	bh=IDmK4uUx+wlhYuF9PhOMx4SNKC94RvhgZPZnyTimVd4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AA0g8mq7Lu5JvyTDkRKZQ3FiabkUTdzHUiOndW5rcgPj9anZq5QhrGRhTmTw0tteiWu1tBitNWh+aHKAvlf2QOtKDj1tYdYVi9oVoK01+fxFpgJTvtpPDpdelzlhQMM+vYUZ7dgWt8CUB7jzUa5IkPklNmHaFB3Xi6Q4ttYdOBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S5S8Guhq; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S5S8Guhq"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3c4e99e7f78so191487b6e.2
        for <patches@lists.linux.dev>; Thu, 04 Apr 2024 09:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712246545; x=1712851345; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jyg0hXO6E2q0WJvGCJ4GruXSk8RIFkv8agNThby4pB8=;
        b=S5S8Guhqtg7m0TgN36XSSrtHo5uPDXKwfyiXi+p0tOfzBn7moVuwIuZyp0IJaDayuZ
         Cxl8KqjopTcoFLY44++Q+t0PebLTopps/tsmBZW3/SlMEnb2qOHbHl5gdQ08x6jv0hma
         kA8Td30ApCg5zDjm6aMq/vISYwFB+y30fqtiTem5goqd6jg2kjD9iJyhMoGHetN5OufI
         j+h9bZy5ir7gvJdMufMCgGbU1rc/S77qBC3QH4DiixghYwdbYvjnpAiHbrGWmHn2PRVW
         54bDWWaxgXVx/jXFatLJptux/OgFxNNN+5vJC1KqolWBfzQRnRcrcPyFnkqVXoSfYWHw
         XJng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712246545; x=1712851345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jyg0hXO6E2q0WJvGCJ4GruXSk8RIFkv8agNThby4pB8=;
        b=Jd/PwzYm5wiu3zXxC32FqjsmDaqPt67RwSNG1R7D79qXNT7uj8BvZmrA3o8qGLrAIc
         CYBuiOJMTtgB7n6JhGHSJTsEhQ8UbM5/1j+kpnvSvuuF2r0XBCwCtH3pPJoInzM2pyVO
         IAxjwqLllK/j7cHcwc+ALkuGSSJm49bRYRdoUGIq3g5I9Vxxzvwj4lQ4a5n6Yju+MApR
         TTdxPPl7WfiB6kFQsrQImwpLgfjJCzpyY6hTcq7eiISn4rohahngZ4srDul4+jyg3DGq
         5wp269WL0+DRHWNtHvTr6hnW/p/Krph/anQRLq79xY14RmCrl/3ZLRaIX8ErzgXqPv7x
         DC8A==
X-Forwarded-Encrypted: i=1; AJvYcCVDlSbx3zqfVXxPHdeV9EVqwwiR22XBJCDvH26+nhC2nZlDSQXLCKjzNvkkGdPwVI/wbsyQI8IbKZIt7MtISJKYfSvGTVfSJg==
X-Gm-Message-State: AOJu0YwkZwXd9Khx18cMrEOS32JgSdhVftI2doTu6dlXi/F6U3ZvwTS6
	WkjSU7ZDPZpDjI+BdjEgw2jx/ejHxX7j4sbsOzaqIJuf/o9z8rU3qtovdzE9xlS3yhzBGdeTNFx
	eYt7lsdcecEtsg1CGEwQq+jKYOMP+Vi16v4OAFQ==
X-Google-Smtp-Source: AGHT+IETeM01LKgtRA5QxmngBY+AiGddknDgFaH6sHiUkiZ3j6NX5/O4k6goqx+540Q0XQLpdJ4lUYtOQQqMdbI+NaI=
X-Received: by 2002:a05:6808:14ce:b0:3c5:b4a9:41d2 with SMTP id
 f14-20020a05680814ce00b003c5b4a941d2mr3398838oiw.3.1712246545200; Thu, 04 Apr
 2024 09:02:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240403175125.754099419@linuxfoundation.org>
In-Reply-To: <20240403175125.754099419@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 4 Apr 2024 21:32:13 +0530
Message-ID: <CA+G9fYvRA8N00SPa4nNMJybv7Z6WCVgS24AwKW7+2kOmqcm5Fg@mail.gmail.com>
Subject: Re: [PATCH 6.8 00/11] 6.8.4-rc1 review
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

On Wed, 3 Apr 2024 at 23:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.8.4 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Apr 2024 17:51:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.8.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.8.4-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.8.y
* git commit: c4c57420c666b4ef4b77e6600f062bd5e631403d
* git describe: v6.8.3-12-gc4c57420c666
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.8.y/build/v6.8.3=
-12-gc4c57420c666

## Test Regressions (compared to v6.8.2)

## Metric Regressions (compared to v6.8.2)

## Test Fixes (compared to v6.8.2)

## Metric Fixes (compared to v6.8.2)

## Test result summary
total: 148875, pass: 130376, fail: 1350, skip: 17015, xfail: 134

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 16 total, 16 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
* kselftest-livepatch
* kselftest-membarrier
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
