Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E07CA6B
	for <patches@lists.linux.dev>; Thu, 11 Dec 2025 06:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765435464; cv=none; b=diaSbUd1lkPIs6R0BDtYY87dQjd6b5oisnObOug2N1+jayZ98n7J3dgyTW1pGKcsild7nO8rtC5RGfNVbMqMWP3uoxvtusfzmz3tvhv/HiFCFC8EvHUPsJU+3LTw4WyOYrWtiRTB6rAR1MLqcYg0WUteOpFM9VgWfIHiR8bfWrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765435464; c=relaxed/simple;
	bh=I3DoY5IXK00Eqyo5v/88aFKiir4lFJwaytRbk6+jHic=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KZn10Wbf+5+OtrtfE9ppysm010hxpN3SPXbbXRXBOIo2YGVG8sN0yMHtphLlIbPRUAbOn9o830eEAfmgKSLPlRdipsbeZNeIzVnNcSMIP2OzbHNxokJGgbicGQUzbOghsx+QJzIQ0ibb6qXO1dZSdd/s9xrTDSZ1FPMJ24HzU1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ix1Aigbs; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ix1Aigbs"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c06cb8004e8so579670a12.0
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 22:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765435461; x=1766040261; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W2Wz+FF8tXlSaQpLPb/9FXC05Bpx7SchjoEE86Alp3w=;
        b=ix1Aigbs5c8Vr+iDOOyD6YKssD//z9FxpQn1zrEMG48NQzke7WsUlu3qX3oC/P1gAY
         3XY4Bq85LvsQD1AZAlKYUO78G2T35BL16pCRAN8b1eyBCtUUS9lBj8QfmkljqQg+T5d3
         C/PeJCZIEX6PlbwGKDoTWZHvVntGev5dawhd8W7x/30IYSggHFPkTc07PHQj/9gVr4NJ
         0gdFa0WrbHCkLt3h/mzKna35WZ+nMn2nqWYcUJcDevOBns4wDkXLvhuUy+v2z7SBt6w9
         OUwhqHN1Aa3Wz1Q/z9y33nSnQKswsg5y/r6rjZ/isA4MTbp/Zvy6ByL2CQceBpRtL/SN
         QpnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765435461; x=1766040261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W2Wz+FF8tXlSaQpLPb/9FXC05Bpx7SchjoEE86Alp3w=;
        b=KLusWzrmYbHeRuebzw6dENtxOsrvsoD3gdLgmydB2vCViLrBwekgrTLHYJzjJzRqE9
         dMfvthdhrSA+1nbwMX0mif0wtO09xDdBR7Clevt9Mg4h09QzXBL4HIBTmrk/FxQoxa2o
         QDZUNnP45P4amzFNHfHlqjc4fc4mI5tHmHpC4AvIV1lG8UmSRihUX8BrZWf8V/YDcMPW
         Dl2UPD/DYexAiVPh464gfDqcSe7XJ9oFzo+vPo2rbGSuL5mqIxla/yAAGbRLmIjgByh2
         f+2+p1d1QVbsRUfvyqMHnlDvPWqCvg4riuu4c5fmmnMfpERZZJXQZEb/YlNqlIXPH/kO
         bEwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNVspgM7FANURHzZ8UfadLEHeHqjA2XYU2Vb5aEbIUqjF3/M03TXLhNAzVCbGEe4jIRYS3ZECI@lists.linux.dev
X-Gm-Message-State: AOJu0YzgOZp4crFV9pFsgM5NDKxdqsBQDrkr125f0E8INlp7dB8Y5cJv
	VNMJjadBTBDSzp/WjzcOGwOX/7iA+LKJsP9HXGRapELtXx/anLvN9SPFa8Y8bV/1wnP2q0BJZLL
	m/8F8eeAXbLep+mJ5iFhgbRGNGVSCnhQfAbKeF6Aw1Q==
X-Gm-Gg: AY/fxX4SOR+2QAslnhIKy5kF6HuSwunj8kone4Tz+42XPFr2JTWr5vimrSxV6Jzn1XL
	3i9XQcOOVL225NSQXtMi3qV3JBRenRVvBnozz2SKgBRzVznyfRPuTL48aS4/obTOiaiPjZCuIiU
	DJBeBicfD+N6eiEXPRqi5tFG/rMXwgSdLQT9VTMWAwso1aXOGbtxHIGaYfpb5ddS2sM2bjQy699
	EKWgdpKe/wlVYI58OMu5tJKP8m1wWUb0wS8oR81FmduqDwTNeB8XHKhKRbVv1+xsuA+Z6pfRD+B
	H3o2aT6VXBo9cp7wjYJlySf3tFgbYg==
X-Google-Smtp-Source: AGHT+IEBhF3ZD6pqQhHGKW/yGrs2jr4pOZgjV+jVfxmy+c2X9mLL4tZcKDT/0kMUOHG6StQEDh7Mz2q0dKKYOT3AqRU=
X-Received: by 2002:a05:7300:220f:b0:2a4:3593:6452 with SMTP id
 5a478bee46e88-2ac0544be0amr4883763eec.2.1765435460961; Wed, 10 Dec 2025
 22:44:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210072944.363788552@linuxfoundation.org>
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 11 Dec 2025 12:14:05 +0530
X-Gm-Features: AQt7F2pOtyl3D7vhCfaaVLgMxtqAUIm9hKtsocFubsUvatP3bH5AEP804uA_ELo
Message-ID: <CA+G9fYvtuO3sr4cmAmd2Vt020jLvr3dfxfm1KbQbJX6fiKw2dQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 00/29] 6.18.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Dec 2025 at 13:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.1 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Dec 2025 07:29:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.18.1-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 7d4c06f4000feb509a90ba5eeb00be9839decb91
* git describe: v6.18-30-g7d4c06f4000f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.18.y/build/v6.18=
-30-g7d4c06f4000f

## Test Regressions (compared to v6.18-30-g7d4c06f4000f)

## Metric Regressions (compared to v6.18-30-g7d4c06f4000f)

## Test Fixes (compared to v6.18-30-g7d4c06f4000f)

## Metric Fixes (compared to v6.18-30-g7d4c06f4000f)

## Test result summary
total: 105808, pass: 88879, fail: 3320, skip: 13609, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 139 passed, 0 failed
* arm64: 57 total, 54 passed, 3 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 48 passed, 1 failed

## Test suites summary
* boot
* commands
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
* kselftest-kvm
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
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
