Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCD527BF7C
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 19:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744225923; cv=none; b=MeDxiHL88CRbAYRhd5ASU3DkE5/TLH7A4RRFqMqSwnrXmwZQ+QSem6rSqoPNPwU2mNprFNAZKJyL/gjVytlKeR0otX3Hf5+m0DsocePU0Ktc1DynuPXDddMZhEWGGYd4jQEXZUMMPFsinMVIaGgx3RY4HarGN0M44w+7RzJTK2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744225923; c=relaxed/simple;
	bh=rJVQDauQEjZj0g6jxReYpgMbOkc7rgwaKyOHe56V6g0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HcupPs2IuMfyLmkuezWKP/va+kOj/VniTOpUZnJkh2i+xDhFlCMAh7NYMzbycpXGV02zVlBMtrXWoxRt9hXYLdVxFIxfrhp82TG0vhQ7a2UqhhNilG3wVmnR5aNsoyJ0FEbwnLKhDA1KKoeZdd02r/lZA/UkKphj0M0cNAIqNgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TOjBW4nD; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TOjBW4nD"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-873ac8037ecso1793607241.3
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 12:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744225919; x=1744830719; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wi3/JxnteRx/5BMoOtb3JvQUUrvrHRfi+TmZ/LdTJGI=;
        b=TOjBW4nDaDUjD2YyaYSYafEI0wKJHlHxRYh3u/jDbH/ToJCRaZHwHKqPwmvyz+5NhA
         4xxnhpHIZnnrAcPcRjMwUn6zFuzLcn9Sn3BwOI+De7asgwW5nTGxLEpRHQ07I95vLoNe
         2JdCc/LW0rHoIf+1pBLgSSKp4fUuxGjYPi/Yag/R9hj9+4HY48tf2z7hQ+ak+mzQHnud
         R//WrtbaGMD9dRj07nXD6c0RQMSNk1gjZon2h3QMRhaZvEPimJdrBusNzc7f9k/6J5KL
         kqbCmNihPoI6rO6F3iKzxA7WiU224E/PZqN2QjXGlGM4c2GUPhRwmsaAvQUNqBhCon4g
         8eGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744225919; x=1744830719;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wi3/JxnteRx/5BMoOtb3JvQUUrvrHRfi+TmZ/LdTJGI=;
        b=IwF/6h20DeCeJY0iCCf56+YSZsQdAikpn7uQmOZ9Xlto0SzD2P5KoEUSkxoZW9NA6C
         miVGbcOcAv1veEh6VoswKoy2+QtzzOEAxs3xe02V7Iyr9UdiRBCb7q21mtjrrj2/4q8B
         BRAE7EwTHRkDnRxekxPYR2oNJtrtb8VBjvTmrVSdGv8p/xVgGc0C7vHQaTlVb4gpHWPu
         QZqwU9tFS9CcHw+UHQuqiD372fTzjVk9FNp+9eKiAHb8EEldAZ2SPXl+fne11ckbA/EU
         pVw8VsX/SOlFK1HxhP+oqL3LsGxBiLoDPEUd5UgMedeUVoVAhgknqo7Gc4PYvEz5FZk4
         5NRA==
X-Forwarded-Encrypted: i=1; AJvYcCW0O2xKEX3M9FrK4rUSOZgGh0TRo69Oit6i2BzkLbJE08+uCZNHlADrFjoTPxNEh4KubgoCkI7r@lists.linux.dev
X-Gm-Message-State: AOJu0YwqZeCPSkq0mVo7PZAmEuB0yQhbr0WA6rKxhdMmLnP2CR5JsejM
	qQ8qmGXLgMXK7q6X6xNSYA0hbpxB+M74rRy7K7AXlvNhfmp/woJ4oG2usj63h6p2mIfLZy8kpaZ
	RReWyL5vfEQMNduFNbCJftuIc7ylggOFO278YFg==
X-Gm-Gg: ASbGncthWxglqssThVxSzwxYeJLbJiOOK4jDJBgBDCe5UuvoZsfkGknINKvnXDJfZhH
	IoHWuWxbVuxufLLoiHxeJCNVNXefR61AfLlE0gCkj8WTueLvyadQKHRnsrj0w35dQP1YrVdespi
	PbgJo6PN+myM91s32eM51wF+ARb27+TBK4iLPkAuEdIiTbW8hJFQlnTJY=
X-Google-Smtp-Source: AGHT+IGquHRVV8Iwo0UImEXO1PZ149S8v0mbw+LbHunLj+Ma11Z53jzf53nmAhS3dfI8tSSV0Gz8MnVOHEj4TciTaV4=
X-Received: by 2002:a05:6102:5549:b0:4bb:c24b:b644 with SMTP id
 ada2fe7eead31-4c9d36ad092mr112527137.20.1744225919161; Wed, 09 Apr 2025
 12:11:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250409115934.968141886@linuxfoundation.org>
In-Reply-To: <20250409115934.968141886@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 10 Apr 2025 00:41:47 +0530
X-Gm-Features: ATxdqUFkjZ7UUrX4iO9RrF97-ijUSvahOPsHLqjGxDqg8TdQn2H2ls89xcSQVFc
Message-ID: <CA+G9fYtnTU1KAuXnzt29x2CW8bxGcC5MzjNEYXkdwt3Y-G89gw@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/726] 6.14.2-rc4 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Juri Lelli <juri.lelli@redhat.com>, 
	Ran Xiaokai <ran.xiaokai@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"

On Wed, 9 Apr 2025 at 17:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 726 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Apr 2025 11:58:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.2-rc4.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regression on Dragaonboard 845c and Dragonboard 410c the intermittent
failures noticed,

cpuhotplug03 1 TFAIL: No cpuhotplug_do_spin_loop processes found on CPU1

Regression Analysis:
- New regression? Yes
- Reproducibility? Intermittent

Test regression: cpuhotplug03 intermittent failures on Dragonboard
845c and 410c devices

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Links
 - https://lkft.validation.linaro.org/scheduler/job/8211196#L4101
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.1-727-g2cc38486a844/testrun/27996013/suite/ltp-cpuhotplug/test/cpuhotplug03/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.1-727-g2cc38486a844/testrun/27996013/suite/ltp-cpuhotplug/test/cpuhotplug03/history/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.1-727-g2cc38486a844/testrun/27996013/suite/ltp-cpuhotplug/test/cpuhotplug03/details/

## Build
* kernel: 6.14.2-rc4
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 2cc38486a8443cdeaab34c7ece4e5600fe5d7645
* git describe: v6.14.1-727-g2cc38486a844
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.1-727-g2cc38486a844

## Test Regressions (compared to v6.14-rc6-492-g8dba5209f1d8)
  * Dragaonboard 845c and Dragonboard 410c
    * ltp-cpuhotplug/cpuhotplug03

## Metric Regressions (compared to v6.14-rc6-492-g8dba5209f1d8)

## Test Fixes (compared to v6.14-rc6-492-g8dba5209f1d8)

## Metric Fixes (compared to v6.14-rc6-492-g8dba5209f1d8)

## Test result summary
total: 103967, pass: 79606, fail: 7152, skip: 16873, xfail: 336

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 136 passed, 3 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 35 passed, 5 failed
* riscv: 25 total, 22 passed, 3 failed
* s390: 22 total, 18 passed, 4 failed
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
