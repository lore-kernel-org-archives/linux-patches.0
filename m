Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9901B1F153C
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 13:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743775124; cv=none; b=c4Td/jTbpDRQzr++mk++Mx6fNluapxOzadetCLcQ1J+ZF7TrWmYeOZWi/YcVZ4CoNeAObpmeCrtucI1qjedXzzwKll6DQxRQIlkCx1sG8Q+SPi110dcZseEtLJkhed4h3kYAEU95bueHI9fWyZoxiws8H6EYTlAJQ02KN4D5mQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743775124; c=relaxed/simple;
	bh=Pfj890P5IwbfTQahPjXr1drdBQeTDyPSELB4bM0oU9Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RjOMU4GNcNc992/D5V/BKGnYh7LccUQQc4WQa6WWXiJWVO02R/x2kuk1Azl1+HM3rreKyGQe1vfxsTm7/+WEfp64wJfV6Alci6l0nCM+r2UvEfyULtrYcrpoagEFELqRArSVlo7XThJk3snc+KbEE077B1GKZlmz5Nmsjke2Ao8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TCK2I/By; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TCK2I/By"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-86b9d9b02cbso921690241.1
        for <patches@lists.linux.dev>; Fri, 04 Apr 2025 06:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743775120; x=1744379920; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aB9/4tnJAtBLw0ZsGKRcy+CITdDU2AAS4m+EOvznbRo=;
        b=TCK2I/ByQPdFvxpkffsQW7eaG19C4TECMiXmRi9kVJn6L4qsBjVBCmb9zJS1Yl9c79
         f/al/0dVuMezRVX20ar2V+iMDdlBMo5kXxb8tMqT+q/+H4NUOgWTUk9sno4N/Tc+MW9x
         kNuCZWarCMPd98OP/XPSBREusnvsP07uS/bUjf0+ZOqmNzixXH3Xm3//5nSWG6lkREmQ
         zkt5MHyEXEgFuUmSCrTXbLbvlVVLTKUrrTdFlx6ZCHVFsoKpGZDNhCp2PSyDX77Qn8it
         3T7Dq19kU+TqlJkfsOMKztjivQ5VfnIWQUB7XxklB70I72wkjLNuf8rkY2gs8trMy7xx
         padA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743775120; x=1744379920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aB9/4tnJAtBLw0ZsGKRcy+CITdDU2AAS4m+EOvznbRo=;
        b=P4bPpaGngKEoDWObJUmLmGZFGc2ytguabPm0IZNDzhIK4bKJpGsapJUrCDKavk3ayK
         fVhiZaYMrjSpQal4nLvgxHjfOG9NjOxYxx6ahQHy2SMwaSRU6tm+DNW1WSrFgFACZJPs
         oxdxSnC3c9DlbAjKmtQ9vwBoXRa8UXmSZjqpNza9bu40u5ZH+m/loXJUjDLSDePOteXF
         X782nVhOQHD8jfiMn2hpkQ7FAmYo6Wu7vv2kgMFasy9lvGmU50ROJCkbCil2jaIMDAmQ
         ORvPpG7wb05WYFj73AZQBuXILEYq4Zij4SdxBVU3cf/yxu5sQ1INpge/XEu1CE3SR5aT
         hTxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGzDO6SJKe1EJ5zF9L7o4kTONPKx9ada0RNFylRnSNfDL7MnbLyyAA6S3q5Ten5nICUQ9MRWgq@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+Pzyt3nuXRprugPAGMBZHDtgkrwXRkJlUMxxla9SoXrAVlst7
	igR7FpiRzh7pVnzSE5JCk4fjO+KG/prakNYsaW6CCksKXSg5g8BvRea5PeTAiFLILSpC3UP7rim
	E2f98Zli34UdO6vktFdhsHmUhW6QuRaV/JMDGJg==
X-Gm-Gg: ASbGnct3JF7OJHHovLf2u423k7lQBS7kZCXDt36R0RNUcSt4QLZ+NCf4cvntK0bVEgf
	Jb6LwDnlilEMOTHuGr+TwokMiDq4d9uSiVSPS8Y7Jr2zDhUkocYZRrGTP/t8M4wmR87bPPbDJQa
	l1S+VC1Cp7fuw79EBAqeuSqGtaZLDqJewUGb6ANMnT10aNInRj3nwmOI0ke5c=
X-Google-Smtp-Source: AGHT+IGDDltg5ObO138k6zzOYL+wykiXZsnKn8Vh0cMA65TQ3tUMpH1ACOqRfxeVBXNWngIamyIeX+2FXG2uPojaJuY=
X-Received: by 2002:a05:6102:3f42:b0:4bb:c8e5:aa8b with SMTP id
 ada2fe7eead31-4c8554a106dmr2484511137.22.1743775120437; Fri, 04 Apr 2025
 06:58:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250403151621.130541515@linuxfoundation.org>
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 4 Apr 2025 19:28:28 +0530
X-Gm-Features: ATxdqUHv-en8o0wookVpU3iUOk9afvCFPma7LGlR77epx5goUvKncGk2Siry8JI
Message-ID: <CA+G9fYs22cxdKD24MzsBZnjVtHx1DpauDyKvLzecBaFjTy3G=w@mail.gmail.com>
Subject: Re: [PATCH 6.14 00/21] 6.14.1-rc1 review
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

On Thu, 3 Apr 2025 at 20:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

## Build
* kernel: 6.14.1-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 8dba5209f1d8c122539b8f9f164a6ed44c025bcf
* git describe: v6.14-rc6-492-g8dba5209f1d8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14=
-rc6-492-g8dba5209f1d8/

## Test Regressions (compared to v6.14.0)

## Metric Regressions (compared to v6.14.0)

## Test Fixes (compared to v6.14.0)

## Metric Fixes (compared to v6.14.0)

## Test result summary
total: 114030, pass: 88585, fail: 7464, skip: 17981, xfail: 0

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 57 passed, 1 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 43 passed, 1 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 25 passed, 1 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 5 total, 3 passed, 2 failed
* x86_64: 50 total, 49 passed, 1 failed

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
* ltp-filecaps
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
