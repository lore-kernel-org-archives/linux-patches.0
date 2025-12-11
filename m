Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D8C283121
	for <patches@lists.linux.dev>; Thu, 11 Dec 2025 06:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765434237; cv=none; b=rvX7Yunnr84yziM0r+iTf8IeX69TmtLHT6ui/Njnd/InfqITWgXCCxkH9g8eTm34aLlGGalpyHEKY3EVn7xB//QUonREcf3zSMqj0iTgac89aSqs+SvzjnNaSzLSRr9LZO5y+q/NXpeCFmgCoOyP+uEaxIh0F3y44dQQQj3LQoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765434237; c=relaxed/simple;
	bh=+Ea/t9Gzvkzqy7qyNNB2KfWfIh3PKgywyC9p5zSkt8Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qnp8xeWCIJ5cNbUGkFth2WQ5b0Yi2TwE/e7EC+nLqJq+TXW0b1exHIVVKw+jLzI+g8iq+a62WWSwPj3e1Xk1G5zcTwlrcP0jXfCxyaul+MultauOTqFWl4X1dRKmUaOWxyBu9Y5T6B3ITUZl3zOqGSEyYq4/fL8luillgFyxLbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=P1BnptzJ; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P1BnptzJ"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso404445a12.3
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 22:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765434235; x=1766039035; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yNkVbuY3usTKHCsWOGhWZWGyB86GCzXVbCkYK/l5WJc=;
        b=P1BnptzJ1IgMwd6v9wESn+vGx1DXBOEnokU4oXo3f0P+3CgHOzj1fPeEWYShm2zB2d
         ruDgUWj+5bMxu5CWMJ0KNi86y9Y2yEnkACUImHJfVhSjvGhvY6gu1EaHLBUf1L4hv+LF
         By1K+cvPwenkwGBSir+j1Ub/OdHSecQxlYKPASY0YCyDY7Hy4gO+jVSIRu/1pA3+KS4f
         MzLUghIX+BW/FifcYEesGBHB0MAvhjQ+1aVpwT75oGbwWtXmHpEM250FbpysgCc/ExzR
         tw3pzQQwFo6ewIQMMQ4sVMESvp3k/IIYNp1SPPA2naj28YDcVc4IVDCSy+8MGi/svgrF
         JyRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765434235; x=1766039035;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yNkVbuY3usTKHCsWOGhWZWGyB86GCzXVbCkYK/l5WJc=;
        b=Uad1gyI2CWZ6VgJof1OghkeEsx62ZK3xKJeHPR/jLoUm1p5/ZZgObwDeuTB77ATHjm
         neplNkU/de3rzIS8kn8UheHU5Ptpt4yyo/sB+jo5g7kN5EHMGy5wry+TBqwRn14Hwxv2
         7ZqgxGxo57qDFdlP/8GMWhS6vf7PzwJGdcmHgfhISQMzhjArNgtxjLpmaGGS7XmBptBb
         qPWSeq7Jovq5FLnvmIpr64EUaCaQ2pnYv6MHBKGTj+GXLWIGs1vGNHCoDXWmNk4vbUPh
         ZSF1HeLddILtkKUzRM+nKp2ExywB6MCbTwTKsvUp+Qud5WtsoS57yPiC62aFxFkU7D8E
         XlKA==
X-Forwarded-Encrypted: i=1; AJvYcCXBQG973n0wsZWZeJe7n8BPgBwVqr47KPXrh/AbgPQEyK/p0chJcoCLD/rGG+UwJRRyDOW5Top3@lists.linux.dev
X-Gm-Message-State: AOJu0YxXPILBl5wCkJGllfWtHdvxj4dbT6FflAhzfRVMN/barQS/aVmG
	7RUbUT83afCHBDYdmG9hqpN6wX/Y8v8zfzwmmXrN0ISV2cydzfD95RUTALAsvyAEwrfi5s7a2mt
	WeQ+ap//w+U3m0xExC7/kn7tMKgG5GGJBns+C85+quQ==
X-Gm-Gg: AY/fxX74j3GC0ol4JzBVle78GLYOkuBPtuXbeshB7GFmxje/s0EAcG50YoVRIlO1mMe
	JrHyvO+LmS4UJc+1LuPgBbSfQM7ib0hDP8bpauHKG3TXsKyxSXqps6w+t/tehHW7p8jRF0dbfWe
	NwP3dFeJ34p/W4eSPn0brW1UJ0D0nPzA8YJ6wv3ttIcpM3nW9ZR1m8s1Qbsv1M0bKhY/7OFt8uW
	7Y5UtkIGk0KZl//lwylDq7WYxwWoxJ9YDtdZ3aLyxsHyLJmMjjDZbif18iNp5ukbXlDaZIdAl+G
	1yAqoS2x2kJytAgAgqLdz2IwP1DsDQ==
X-Google-Smtp-Source: AGHT+IGVxhAUv3cl81I8lkaEMdy/a72TP9vctXDJDJTWxE5FmtXceYhvpxR3BE0Jmi5uzyOFWesP4W0n7csc6GC3IS8=
X-Received: by 2002:a05:7301:428e:b0:2ac:1c50:f900 with SMTP id
 5a478bee46e88-2ac1c5101e0mr692552eec.34.1765434235378; Wed, 10 Dec 2025
 22:23:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210072947.850479903@linuxfoundation.org>
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 11 Dec 2025 11:53:40 +0530
X-Gm-Features: AQt7F2p22RbIhZwEd5TrSspQvQY1KIbWLmV1jiNB8KMKbUqYqiz3PuuMvzz2x-4
Message-ID: <CA+G9fYtGdn8Gqy3kWWRF_SrauO6Ax+TXR3hAH_hirjxJCAYdSQ@mail.gmail.com>
Subject: Re: [PATCH 6.17 00/60] 6.17.12-rc1 review
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

On Wed, 10 Dec 2025 at 13:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.12 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Dec 2025 07:29:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.17.12-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: e7c0ca6d291c41a8a9648a5016ce9b73e492aa3d
* git describe: v6.17.10-208-ge7c0ca6d291c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.17.y/build/v6.17=
.10-208-ge7c0ca6d291c

## Test Regressions (compared to v6.17.10-147-gc434a9350a1d)

## Metric Regressions (compared to v6.17.10-147-gc434a9350a1d)

## Test Fixes (compared to v6.17.10-147-gc434a9350a1d)

## Metric Fixes (compared to v6.17.10-147-gc434a9350a1d)

## Test result summary
total: 116299, pass: 98676, fail: 3761, skip: 13862, xfail: 0

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
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
