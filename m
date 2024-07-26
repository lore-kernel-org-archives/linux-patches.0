Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483DB1B970
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722015022; cv=none; b=TxSES1d/oWVVe7S+/Dpj++C1oc8suiPrA48ts9r0uuhIag5+y69BWaVb92i8ueC4qahgeDr01Qo6kySVdSFUH94qyx7KxTwM5RDSvTrQxZ1Qxs2pnAcGhhRSzdQ5mXh5rqmN7baN3XqX8ZKS0jSWQOFv1yGqUZP6mWaXYgkdggw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722015022; c=relaxed/simple;
	bh=S8BJyi6Uwi4pGudUQFqxr0+CrXIJCvw64+A1fnLG/HQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nW9YaJ3/O1LXTgdFEU09DdQ8hyXKE55A0B22IMEYPiRT+HLZ0+icBw3czIdHSBdy3p7lD2UPC23Oex+j1IEUMiKKTOauohOWzZ6vtZ14Yhr4twtK/YLj4ajHsZcGRPLbLNVd7XGTODYG/kPsP3IFMK7hIGN2xYxr5C4Qng84If4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xgELopVZ; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xgELopVZ"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-4928d2f45e2so787398137.0
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 10:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722015020; x=1722619820; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ja9xurVw5McgAlny9cR/h9JB3vJIBFk+wQhogSUS8hY=;
        b=xgELopVZNAEhCH9NRzUxKgPn5ni7CFlphmn1N8oUn9L31QclbL/o/Pd01zeOs7Uh3S
         dv66dPv++emtoNakWUtUQs23i6EPdwFdwDpDNAGiwmZ/0kK/53KsOcuNv3ntRjciVGyV
         oOlE0dZ9hE5dfzjT9UearaZJwb91kCrP0DmD7uAaj2EBrb7w+3/e24+fMW842jr4E+gW
         vR0JaoUlfm8xywKf1/XksV3ALFJUQ5qpkBg5w/Wkd5ddmtHpc6vLRvbetVXW5xL/+VMS
         W6Vc/aa0OTifUijw3c7zQ3+1g9Vlc6j0QT6sFMt6mQfJ6eBXl1iUX5I/YaxyajUbDzMk
         v/wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722015020; x=1722619820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ja9xurVw5McgAlny9cR/h9JB3vJIBFk+wQhogSUS8hY=;
        b=r0wGuv7sDY8E+YOKzOPMqxMVknutCq2ZVQIRH+0DjubRp9RLVbAP51IQ+y83/V7V2K
         olVn1COeCOYDaD70kh7J2WGP1EYFsAFqjrsDY/02T9JbTTFYS8yInXHCPl3KnfFWx8M5
         R5eb6+R/cCeWRhDSjRfegKeQZMkMR6oxahTXPTK5jkU4q/tzdkiCBkXTsTXfH0EOdqUz
         ySUqM4orrQoOV2Nbxi/De2VsSEUmoLJk1pFoeZuea5EhHOoblL4m862jN3VTMjfa2WSk
         HNxMSe4hgHd4VHj7I1+2uU85YNWVsMmcKy5C3wmhdNPvdVIF1765JyZ/Dt8aBAi7JLhH
         oLWw==
X-Forwarded-Encrypted: i=1; AJvYcCX+Ib3vmTltGRxoAzHF+VJ5UGvrh3sOUX9Q4dRv3r55ilQIb2f2SOTJZuiXIauxJNvFmSvB8vdqkYqlPdlXW9gRcfYQbbKPyw==
X-Gm-Message-State: AOJu0YzsNaZuw2WqyckiPiGwRptuaMWGwJX8o77eoIK43Fjkwu4Cx+Po
	J9rVM5+NPqqnmPyS3OnQ+aJ5iCNwDNPlsdc72ays7zN9pd5CUd9f+MojEQDaRD7HKubEzi5tvur
	TR9UUKU+VaArcl7y6MBAbaedSqDXpbNoYQXuzQw==
X-Google-Smtp-Source: AGHT+IGRVWcS8NMtCwQCvQ+goUflnuWVyNyUIXLuSij5vzVj6Yor+/yWv4PqUqmRvTY8MIBihZ3/WFJh2pSxeJQJjmI=
X-Received: by 2002:a05:6102:d8c:b0:493:bf74:42f2 with SMTP id
 ada2fe7eead31-493fa1ef1fdmr467338137.17.1722015020145; Fri, 26 Jul 2024
 10:30:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240726070557.506802053@linuxfoundation.org>
In-Reply-To: <20240726070557.506802053@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 26 Jul 2024 23:00:09 +0530
Message-ID: <CA+G9fYv8meGAQm6LacVfUHci3mm9bsueZuCfXFy2C9COpgXXCA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/90] 5.15.164-rc2 review
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

On Fri, 26 Jul 2024 at 12:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.164 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 28 Jul 2024 07:05:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.164-rc2.gz
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
* kernel: 5.15.164-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 8730ae13275d35ced3e5b8bd7320d4e510f782ee
* git describe: v5.15.163-91-g8730ae13275d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.163-91-g8730ae13275d

## Test Regressions (compared to v5.15.163-88-g1d0703aa8114)

## Metric Regressions (compared to v5.15.163-88-g1d0703aa8114)

## Test Fixes (compared to v5.15.163-88-g1d0703aa8114)

## Metric Fixes (compared to v5.15.163-88-g1d0703aa8114)

## Test result summary
total: 91890, pass: 74826, fail: 1744, skip: 15221, xfail: 99

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 102 total, 102 passed, 0 failed
* arm64: 29 total, 29 passed, 0 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 25 total, 25 passed, 0 failed

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
