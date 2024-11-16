Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F208FA47
	for <patches@lists.linux.dev>; Sat, 16 Nov 2024 12:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731761503; cv=none; b=rOnStb1P+be8tQU6gPa/NjwkItjlKBI7+bLU2jnilEi3Jc7B2uiKt2lnAv7kI1tBA9wflpeAAnNnzts1vW73WjNC++iNuPHS476KEtbC5MvVUIEzVrmsB7i65iAu073/JSG4u+PCcnHlO1tig3za372x0n+9hKOaocn1d9Px8sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731761503; c=relaxed/simple;
	bh=yZ9spXyy1JHGFxTbJ+E/XSPQJIJou0UXNJ58XA/89fE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VIzte0yGfBTIM5Z+vH+PvwS95t1S6RSZe6kpMXFSVUBdvEz4g97beTWGO15Nl6rPPxWY0X2styAVwCkHF351ArZ72vM+s1I9EhJ4WD749XEKYeymOyOjy/y3lP7RIC0rUVj1F0lioNqDV7ofKYxuatZJL6SaSVHXnJsLzlMhABk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pHT1zqUu; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pHT1zqUu"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-856e849af48so537346241.2
        for <patches@lists.linux.dev>; Sat, 16 Nov 2024 04:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731761501; x=1732366301; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1gHVrsBBGX1xiJdji2Ax4tKFi+Wtxl7VnBxvhnAp2Rw=;
        b=pHT1zqUu5KvFkGswrKPubUbiQM5amc8bxmqc2oNYyN1D4HgjyjDkODjw1cns+qAse6
         R1uKIrBdoIfpSm2wznM7KM1ApSiZIY7LT5ec50VeKzUTSWMj1TqntRIDE4xYWAKQ8XyA
         hP95F/geWfvOlrm0E/fUPNoPAZ+IFK3GdGU4+hZOlpK6zdzhiozRUlTOhmlxjyglvks5
         SiAb3HZ3WMFaYar1CQaP7A1vl9RK8HvkFNhGWH89y/la/vTFgCDtaJEubT1op1rvvR+p
         w7hsx9l4gQ28TjMgd41lI0W42zAlqe9Tyih5fv2wMWBb0vw77d4ZtzlgyFYEITnNzyrW
         EMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731761501; x=1732366301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1gHVrsBBGX1xiJdji2Ax4tKFi+Wtxl7VnBxvhnAp2Rw=;
        b=OTO7ulbAmSALn3pm0LodoJJAruvE8kD5VHHjqZ6v2uWmYbH7rGehNIZhXx50TUKFAy
         TAAkOwuHRlXgIQih7JFVyCTUuR/jwoD4weEmwQMIIKGyOtGp/s7Zvg6Tl40hPhWGEpIs
         y7T2T+yP4gHrOmfGm/xmqobdoW8ppHT2Ct/zCuPbubNhaHNTXANJx9AF/+jeL40B/UeU
         nf+8S+x2gLf4yySKFz2mObfLlKAredKHURd2DYbLqn/H6Xo500t7yHXQpvt37/3j7nnL
         +8lbBdDkTzfL04h6v7UAy2udt1iozwutt5+IFwWJmAUUrhELYaLKEanxwcbEMs4D1b+Q
         Ok5w==
X-Forwarded-Encrypted: i=1; AJvYcCVnQe1DU4yRdu1HfTeN1Dt9sTbVjQ3UKvhDbwtD89V7Z+jsWfNz4I9CVKSp41SO4p4F7jGwvMRs@lists.linux.dev
X-Gm-Message-State: AOJu0Yz760o2cxR3IpJdhAqGsIVHQbuYR8ggBuvHfrC2RFlPd91tmyij
	/l9VdZP4sBRcMJEy0NQ6s+YycOSAp1KNoRezRlapFchOk+B8fne8EqekwOFfLOxyyET5iOBQyZt
	+B8zXWIM+q2JkD5/ennpndqdpbL3EjVxNbDVcxg==
X-Google-Smtp-Source: AGHT+IGKHfsegjA71cHf5q+QphFydcypRPh+ZCbZqZcBzqCCohTQJ3bMMjes+Oi1iKLmwyariK60DCyrq6WLrqc74lU=
X-Received: by 2002:a05:6102:54a1:b0:4ad:5686:21e0 with SMTP id
 ada2fe7eead31-4ad62c40328mr6417722137.21.1731761500832; Sat, 16 Nov 2024
 04:51:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241115063725.561151311@linuxfoundation.org>
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 16 Nov 2024 18:21:29 +0530
Message-ID: <CA+G9fYtsjLQOQFJsK8BBvEe03B+PJp0dSjpobbT+65Qhgaeoxw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/82] 5.10.230-rc1 review
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

On Fri, 15 Nov 2024 at 12:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.230 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.230-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.230-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: d7359abfa20de2d21fb8189353e5c82b34ecc0e8
* git describe: v5.10.229-83-gd7359abfa20d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.229-83-gd7359abfa20d

## Test Regressions (compared to v5.10.227-164-g5d5f7338c1ba)

## Metric Regressions (compared to v5.10.227-164-g5d5f7338c1ba)

## Test Fixes (compared to v5.10.227-164-g5d5f7338c1ba)

## Metric Fixes (compared to v5.10.227-164-g5d5f7338c1ba)

## Test result summary
total: 63187, pass: 46635, fail: 2066, skip: 14420, xfail: 66

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 22 total, 22 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 21 total, 21 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 24 passed, 0 failed

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

--
Linaro LKFT
https://lkft.linaro.org
