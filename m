Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA3B84DF5
	for <patches@lists.linux.dev>; Thu, 23 May 2024 21:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716499962; cv=none; b=bKz8Mtf5uOdVRHgpJ3KkSJ8Xk6nd0wNBSp2eaLDUhvKvM7uxX7JGouDmmlH4XBMOvR2ynp/uOh/QEr/JsR/Tjrj3Pht3WjZ0RdjAGVZpECepTEzNXaixys2XVa733CN8BtHn/U+4qZiBufRQAeaJq/yrWhwfM62bZL3jofrZXTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716499962; c=relaxed/simple;
	bh=zkITAr7CmBWLO2M3b7jQcZH99hzVRibXay5tFUhl/E8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YazPzBtzDFhnloKWEYLtk5LwUbldLxk98uyDNOQfwJaLUpJ8guvHu5a5Kb7dwy89yZqOJBjFdH2ZHYbXyVEee5cWIGEcCRKRPV72Clf43XMJq+e9ETltT/YL5b+y4xWI83VcbyT0p+sDWl9TbIqg/gYJosTPUHglECWaKKZoX5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cgE6wCJM; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cgE6wCJM"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6ab9e0a4135so1205276d6.1
        for <patches@lists.linux.dev>; Thu, 23 May 2024 14:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1716499959; x=1717104759; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pUt0t/lv5Qq1PHFIIh6EL2Y/XsjWxY/5yhdxX3CRxY0=;
        b=cgE6wCJMbrHedBdqRfEr5QD8LgmXxgrmTQXNN/71RT3jbgXDBgXntJvA/xeqAO0vqK
         3QS1L7+tTB6o0Cp3/Y2ewli+pJj+pvcLe2fvO8YW+r0OkAZ+sjRzxgGm9//NyqWjkzdM
         1IEfhVR38X9WHRanC+BsYLDg/5upSqQi4hje5OcbyIZIYPqosRKPtVgwvO8oucjds+T7
         IobTtXhL4PHKAinJO15Rt7oAZDCX8lgI6/groipqJwAWtSRwnjQnYoB0MaiDhgIsZNDZ
         vMNhnxvBYkarUi+tKlVETfrlcKLABPuka311M1H6+szE2t6qs2eUy7u0lpGCs3nK89rn
         j/+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716499959; x=1717104759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pUt0t/lv5Qq1PHFIIh6EL2Y/XsjWxY/5yhdxX3CRxY0=;
        b=JG/XrHHr+VkWljhlD5pzeOLvv+glddnux7cLH986s3LLWwf3lvvI/u8gLwb3ISRBNI
         45gVk7b1Us50ZYQIagVOHVc5k6cHzcGnMjZ8O0FWJwJ6LlqUBE0dsABdvDoLt/g0sQWy
         iQ5F/TtRzbv6mJni6myt4kcq7l8q1cc8T05nWtpX88YjW+nzrpyl/wlSFVV1OUi9oLeB
         kkFvYF4Ow1c1ijZ2MwYRbhG70/petvnmrfb31tgyMweunhsteKepO70zu+MXvGpKw98C
         E9rxpv0azKDzOnkW/Jj318cxI6hGcA1QjNzaPHscslM4mDfkXv6Bx65TsA3UmPpSbIYP
         I6jQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeymESKpxEHoi19l6pPr55zlEBA5ZJr2iQbmsQbQsaxILyH/gv0nWeKW68F0evM3QtPxaP82IcBKSvILLqP0YMqe6NJ+mx6w==
X-Gm-Message-State: AOJu0YyrqLQJg0tEgot0Vd6Ac3y0CL+4fhyI24lcxMTtvM8Hjp6S+Y5z
	CJxy5lPCQ7ljwPyk0+f20HcQOBHxGSBKdi3mvxZClISfaB8bLbXMTRqkkHwhZTAj5EZGaijuB+A
	gGfOBp6R+KBr8KddHwn9L2Uv9vLe6pxl87rWiFQ==
X-Google-Smtp-Source: AGHT+IEuBNQdLSthf/iTYVwBTUTOk5SUNT6V9pX+RZqJC3Zt89SpmPn2fjjJFos5V7lmOzNq6/+DLzlZhfudIcKNmrs=
X-Received: by 2002:a05:6214:b68:b0:6a8:ed2f:384a with SMTP id
 6a1803df08f44-6ab8f5f4fd9mr72035616d6.30.1716499959388; Thu, 23 May 2024
 14:32:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240523130329.745905823@linuxfoundation.org>
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Thu, 23 May 2024 23:32:28 +0200
Message-ID: <CADYN=9LRNB_T1wv2VW8Kqr6raHQKJ5FaiH_ahPYhy0cfvw+RCw@mail.gmail.com>
Subject: Re: [PATCH 6.8 00/23] 6.8.11-rc1 review
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

On Thu, 23 May 2024 at 15:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.8.11 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.8.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.8.y
> and the diffstat can be found below.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 128 total, 128 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 32 total, 32 passed, 0 failed

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
* kselftest-membarrier
* kselftest-memory-hotplug
* kselftest-mincore
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
