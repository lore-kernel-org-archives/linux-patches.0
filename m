Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26A6277C8D
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 12:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751633491; cv=none; b=SEoEwy7p8EdnUACsIWMwzjZkzydeQEJbOuUzLMkij3fmeryipdIQMuWlKW6wQ2vvj/OpbyC4Ipjs+blhFBbCPDd+O8/ejxnJX6dSJFMdKx1t1xZEJW/3iOWRZuvlRgeqkUkNsi/V6O8niXXFi2LA9yfYrMV+jQl2limoyXiL3qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751633491; c=relaxed/simple;
	bh=y/kbYTbXwrVINRik7S+tkYYYL4C0iQ3Fnbn38ah7j78=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ogo7wwJ+LHe/1LTussBZ+06hYVS7F26Dd2fIGhHJOJILG9c3KQUjvBamF9HLP5d/pFNOU4gvOtTcnkOiaem3XGWfVGtQU292/laxRHR4hwsvyzDumHgUpKVDLt0wYsUzO3+UP16owda/Oa+Os+4w1IzR44bmAU6zdV/Whc8Ruqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ep4q04zc; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ep4q04zc"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b31e076f714so1700220a12.0
        for <patches@lists.linux.dev>; Fri, 04 Jul 2025 05:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751633489; x=1752238289; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WzewkNlMN96GiZVrIk9GUqEzXm0VfOX3d4MoVRPtoWg=;
        b=ep4q04zcvGpUy6QuV0fTeb+4O/yV/uTxuMy5YB1gGauUYwOs4SwaP38qza6Wt7oQtT
         OOCfzLI1HtwiEeqUctFXCS60zFmnamvwsNDTWwqt9Ea6wu96Rn6Rq4m7xkV+bbXpOnJL
         lv9NEfvC0ascg3fZgV61BgYDtZd776uOPIqfS+m8YStGmqXLQvMYByQf0i/ZoXmwj+K/
         b5BcGjt5R5Q8RaC/Z46zR8J9JkUVq8sv+ugYIvIZe7mVXLIeoY5Mzrk4epcQSdbco3CG
         rZVKwOmqDPyFnIMxrZojNRYCMjMzSWSisTEjZNJl0ad+ek/8ku4BYuRmFAyPmNLlJ5KC
         7fqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751633489; x=1752238289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WzewkNlMN96GiZVrIk9GUqEzXm0VfOX3d4MoVRPtoWg=;
        b=V665v+u7WrLTVQu7+VCUwztqHivVqNhIhePbk2S12ARuKNkGsERcK7bztdMb3nDQAl
         dYRLpvY/N3qOPwLHH6KLOViaoALy+Q1b/7Y/6CRBu4Mtignfu2CsSlLidnrSg8GOvwx7
         vAR1tEQr1J7tzyoqb1j+avFuVGk7K/8TVsysoe1e5ho8/LnJ0UPg4opp2YqRzgOVQyoB
         IJcCWCLTp0vA/c36BAFEdSqa2t/gXxFKoacQJ84k9YPBa+xuP9VcRXRHBzrIGjRtUpcc
         kELdPDJVeHw3oZvwjAm8CwDZ/paJ+JWghscvZof4qpJhXJFtNn9JpuERzZAZ6tNjSi1K
         LQOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWErrGgIOvLYZFF4YuPcP3N5/xbDz0IpFVgfWK/KZCPghs4tH25e7nZafTypVVEkruy7BaKs2nD@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3P4xFsB25RR0AVea+JD5D4NpxXTm7r64B0Pf+RULGpe2vum3S
	ltuCjUWrOGEwt3dVUoM+zfjDVSvliBX91Lfd502T0vxkftvXdV+8ReJwZT5prCrz8V/fkXfpuGY
	CASkvIPygFEFCvctP2vd4rFaKR/h3NAH3Dlncc9cz7g==
X-Gm-Gg: ASbGncsA3YfIyaBKcz1t5nr/JG8L+T7OuaxWvPAqFKT9u9HqNci8qtcgzp5Vzz71WH5
	woFcga0iw2sqc4evedrohAhMZNx4Edw39qR1Ijlz9NyX7cJx5Sqq3uxRg/iojt1XyH6SRR4tlMA
	kH+9IbgcdvWk1DAbO3YAlJ42B+lwuJkM6gWauwJJFA3rM3fbUNXVddyRuNCx84gsuXgMCFSq4Ef
	ZE7
X-Google-Smtp-Source: AGHT+IE+dot2yMfM7G74tn6pBGrGMaT/wjPZVf/oo+P5hOer7D8qLs0cW1oLs4J2BeGO40uaVcVvqD1O9Z/H7hvNNJA=
X-Received: by 2002:a17:90b:3a05:b0:311:b5ac:6f7d with SMTP id
 98e67ed59e1d1-31aab854e04mr3898911a91.6.1751633489174; Fri, 04 Jul 2025
 05:51:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703143955.956569535@linuxfoundation.org>
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 4 Jul 2025 18:21:16 +0530
X-Gm-Features: Ac12FXxkoI9c359mtmkiGWYxMRrw6eIFnOiBA7xCFWZuNBOvGtFp14r2FRTFehc
Message-ID: <CA+G9fYv2CYDZGm_MC0F3pr8ia2E93epOoLOAoLn724YL6R8YCw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/218] 6.12.36-rc1 review
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

On Thu, 3 Jul 2025 at 20:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.36 release.
> There are 218 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.36-rc1.gz
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
* kernel: 6.12.36-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 08de5e8741606608ca5489679ec1604bb7f3d777
* git describe: v6.12.35-219-g08de5e874160
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.35-219-g08de5e874160

## Test Regressions (compared to v6.12.34-414-g7ea56ae300ce)

## Metric Regressions (compared to v6.12.34-414-g7ea56ae300ce)

## Test Fixes (compared to v6.12.34-414-g7ea56ae300ce)

## Metric Fixes (compared to v6.12.34-414-g7ea56ae300ce)

## Test result summary
total: 254325, pass: 232385, fail: 5932, skip: 15566, xfail: 442

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 55 passed, 0 failed, 2 skipped
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 48 passed, 0 failed, 1 skipped

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
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
