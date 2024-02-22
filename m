Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E5960B90
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 12:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708604650; cv=none; b=jgTPElzhzOcFtMOzvWSLMk6a3cCdTgwye6Y71yBGDQl1Qehc7QC5pGgay7Qhq2vmV3eJDYA55D+No/bNPZoi6xbzvS5F2KU39jSxMeOZNLNx60u1WbPi/H5wT2vUeJCjgkLJ4QfPr1sa2dMvcY+fdpvCq+EPFqE73HY/rBIscIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708604650; c=relaxed/simple;
	bh=eTJPvbYPNCJ1j99etIO+DAPNHeXEiTFSEoTP8+HZolg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=swoUcnsk7BlCp3HMVLxc/mxDX/M/aeVcr5gB3cLu1JZgGfcjtiB5s3YtH7kyc0pP8VbhH9N/+mqniMn8Wpe/eLJZtF8fKCUrZ4BplXFamvbWB7801Ab0I7QHvXXRibvTEUx7zwnc4/owhH55a2JgmWAiZCkQqC5G8CPl93bi8mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=j03Nc0Ic; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j03Nc0Ic"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-7d5bbbe57bbso3480630241.1
        for <patches@lists.linux.dev>; Thu, 22 Feb 2024 04:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708604647; x=1709209447; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HZ26GtWBMfOOBIvjFBZJGybRXjVBZXEvkGayYiWiTAQ=;
        b=j03Nc0IckAmhfChTWlULKGLoxH83zIZLKgERKJRt+H9DYTAuRaKJUxIyO5LTFSy3Cc
         WsigSTGziAjGPJWNLYwOyB6n1x8UNWWBGbln5P56eQbW6l7N9SBiKQk7p+qVEYsFI8jU
         AoCe2AplUNtM7nLCo1q3c37yUtxtfmRcWh+B6he7XVtbP36rqXzOrZfEaT6NFRzkKq3q
         D2z09FYNFKl0gaJPOQVg6zHuiWl/jYJdvPC77wSGTpI5aNx5rtQgScyHHjk1qGuEYkx2
         rnFmZwyTPRRp9dZiJopTwbF0bztpvAyfVeuwbzA3JyzNRPDatnGp7cy/nZknO+FGtFGp
         zF9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708604647; x=1709209447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HZ26GtWBMfOOBIvjFBZJGybRXjVBZXEvkGayYiWiTAQ=;
        b=Aj6u9MQ/k8LPuD1Wmrv+w5jmfNGbcpm/BJ+NerWaTYKO38cU0vy6FL7eTbuwrziW3l
         khtvy+GQykhBOCsZLnWCNS/c25gSQe0e2Tr4d0TLFRwQ4KIQ+mtfR/GlWvieGstzO7dh
         tKgkd00xN46KOH+PYD2eJkglKG4JOvwf6OxrtcpJtvU18Hcr/vCNz2lNMEnO+d6MOIiU
         ruUWinPEqrRrg9Nxpm97dVCV8rORkioam+OzHBF9OK8PX/KLIWyaB9BB938Ao/3rortG
         3rYMmO7XPhQ3enDOnH5zxqrCEeWHRBiNZ/x73um5mBgs5QX/82hbFWYoirXV0TGgmZRK
         1i4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVMKwlzwufY4gS/EkBS5vsfW42nUG77k9cSNkTcE6u4pBLlhMu2nLfV3TkIzKQU175tmuC28sw0E9PMqQPQ2wgfGfQuMnEO1g==
X-Gm-Message-State: AOJu0YzXX36BcLgH1ghzaSNLFYghM6BIdjNwGxGmD6oMG3c5W1bmMjoE
	pamuNMNutHWWSyRXOidEMSv1Z2TCzj82TQiW7buthWP2gfvknH65GRnMFpiuXuscXw6D/ohCcQo
	gTMpJmknH+B3XBYRpGJmVEGg01zR+PVtv7/laNg==
X-Google-Smtp-Source: AGHT+IGpKrpOvwOxLRAab+hHWX6jt4YmgvO9hwgLsO6jhE5ITDJ6DMLf1QOoMOIwPHreuGQeg4TtpVei3wFC1l1YL9s=
X-Received: by 2002:a67:e28d:0:b0:470:4be4:41ba with SMTP id
 g13-20020a67e28d000000b004704be441bamr9143357vsf.1.1708604646800; Thu, 22 Feb
 2024 04:24:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240221125953.770767246@linuxfoundation.org>
In-Reply-To: <20240221125953.770767246@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 22 Feb 2024 17:53:55 +0530
Message-ID: <CA+G9fYsBV=HULT6J=fRWZF_M66YuCaEE5HVu4n6edC_9pyGWjA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/338] 6.6.18-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Feb 2024 at 18:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.18 release.
> There are 338 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.18-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.18-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: 6f4f386cf24e138f1005832aca27572eac5d2099
* git describe: v6.6.16-465-g6f4f386cf24e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
6-465-g6f4f386cf24e

## Test Regressions (compared to v6.6.16)

## Metric Regressions (compared to v6.6.16)

## Test Fixes (compared to v6.6.16)

## Metric Fixes (compared to v6.6.16)

## Test result summary
total: 212665, pass: 184895, fail: 2487, skip: 25066, xfail: 217

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 146 passed, 1 failed
* arm64: 53 total, 51 passed, 2 failed
* i386: 43 total, 42 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 34 passed, 2 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 48 total, 46 passed, 2 failed

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
* ltp-ma[
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
