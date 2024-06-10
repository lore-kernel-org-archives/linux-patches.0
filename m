Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959861422CA
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 16:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718036028; cv=none; b=GZEDdOAceWh0AM97jQ5nZdwe44WmlPkYpqWCNqfDfihnUOY6lP/ApGqDT/cUIJC8FuUgk7M7+3fVlQLJFiQWqYTrqUs5gxXQ+AadAlsdaPwqEPF4DQVDK1md4+RJ70nb/h/jrrStChwfOZY1MhouXag0MNE23G8X/uZMXDyKk4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718036028; c=relaxed/simple;
	bh=ANFTp/weWFW5AIvaKB0ZVMJypGvMDeYp+xero9WkTJY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=suubMnZ7CQ2VXDbe+g3uHpv+5LqULdHAqeg/05UMvoI85AafEF7WbSB8vxETyBw21xEWbSdTTMV5Cy8NEtjOus51sKVIGEN2tHIZOKhuw6Unf6sGU1/w/qhAvAdt7YCfmFTbCuAGLb/Apcuin58QaaGnCv5USzOYIq42uPupaHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G0ot5uc2; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G0ot5uc2"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-48c4a3d7930so528380137.0
        for <patches@lists.linux.dev>; Mon, 10 Jun 2024 09:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718036024; x=1718640824; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zy3UT0yyFkK2jWmjzHRfhvJ0XhcxX+WMOHBbMX7TWw=;
        b=G0ot5uc2j5FhzZF00rr1qlGi66GSMDuW1UTpSKCSFIdzd2ACcI0cL11W8E1dyZmv+u
         cSwFIHzJeCk3Prn9F2wqUN5j3rJISePMYoUmO1oxqF2mxnMAEq7F8BlSlvFa+yI4Qvv/
         AUhPy6L4y43mATuMGS2MFc8h0YCWIzUdNVlv7KiiNBxlKvt3mien9huq3fj29MQ7rL9j
         LCkgGVH/2SErTExLjqu5g7BCE+b+z8zH4rl6eMnzH/PrZRBYz/s0kBdhbtdnwudK6pYn
         ZCl9PI8JichTrJ8Y4/ZEDpzIXgpga2tIeF8fYk3R2EyNmmHVO+tB4tiJ/sLPlxuIKQm4
         sepg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718036024; x=1718640824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8zy3UT0yyFkK2jWmjzHRfhvJ0XhcxX+WMOHBbMX7TWw=;
        b=vQvoqZHzXddisnyc7YnMAsf2gyU18l50jRQBBrpyXqP1KzY4Gle+aFqVSQSLJ5Lttn
         PosGFIpTogZuUHAPZ9foEyP5fShQHVFoEXgGnteaL8QRl+nSTFcfSAEv3ydkBQZzXTkL
         HM0wIboeCHBZI3hUloiqg9Ppe9GOOJ9nedpNyzQFsMTWP0RrisaGnqCalyZAoMHuQ7VU
         cDZfE/K72byeSr80FMn54p9QgNRYm0XzSXIttBBG4bi3Urj35FZMk7fOeFBXbYS/v8Cm
         ZWuDChyzuu+E03/1ornwgs02dwTNJ9/FIv0qmvj9pkIE1sGVP2Qx14oQfAfI37wjQJLb
         KNoA==
X-Forwarded-Encrypted: i=1; AJvYcCWhj/B5SCIqqwA6Kf0qXH4JOwAe2jsBqG43plxvzfnSOUzvTGkZiLq1ioaMx7IuGc8cUhGdMkC12AibWYjZp6iE/TPo0lZbEQ==
X-Gm-Message-State: AOJu0YzEhEct/Nmhch/hDmbUNazobOkjgOOzvVi6AcxMbQ+suQDZpbHP
	k+psWqKOW0dTInAYy4YEgSZiaTe1ND4dYL4T31bOh7F8ZWahTDihSX01QJM+R1rQNogDbJTgAsS
	nbUdP+R055v1BQOCBeX44aKcAk4w7XpzgawlHXg==
X-Google-Smtp-Source: AGHT+IFq6tlHdLaJg531GvEs5Ls9kVx7hFFfOKyJyNs5KOTU6Hb1F914Fr2+LSfszlTrbFZPfiOV2GgueH98JuMbDak=
X-Received: by 2002:a1f:cd87:0:b0:4e9:7f87:4c2b with SMTP id
 71dfb90a1353d-4eb5621cd6cmr8361323e0c.3.1718036024400; Mon, 10 Jun 2024
 09:13:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240609113803.338372290@linuxfoundation.org>
In-Reply-To: <20240609113803.338372290@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 10 Jun 2024 21:43:32 +0530
Message-ID: <CA+G9fYuXrS3vphJ-2keKTN4Voc6gRAkUPJYD10uBrp6LjA3z8Q@mail.gmail.com>
Subject: Re: [PATCH 6.9 000/368] 6.9.4-rc2 review
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

On Sun, 9 Jun 2024 at 17:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.9.4 release.
> There are 368 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 11 Jun 2024 11:36:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.9.4-rc2.gz
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
* kernel: 6.9.4-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.9.y
* git commit: 4aee3af1daf2e1e4f2ff4e124cae1ef79b118e90
* git describe: v6.9.2-797-g4aee3af1daf2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.9.y/build/v6.9.2=
-797-g4aee3af1daf2

## Test Regressions (compared to v6.9.2)

## Metric Regressions (compared to v6.9.2)

## Test Fixes (compared to v6.9.2)

## Metric Fixes (compared to v6.9.2)

## Test result summary
total: 229325, pass: 170430, fail: 35789, skip: 23106, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mm
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
