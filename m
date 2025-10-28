Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED47231A32
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 13:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761659653; cv=none; b=XQlVT+Uf65tsCGcndO0U6Y39ztoxFQ/3WeR8C2VmfYyJRnjnaZTa2G9hIrG6/Qj8F7Jm+nQhy56LDLuWBO82bAceUIWFJBXuRxqeLITqrvVj0qHgBn8qkZO2rT9Zf09nA5R5u6J9IFaXOjUBxaKmC3Y80oAhaxjprs8oaivZ75s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761659653; c=relaxed/simple;
	bh=wwK0weIbn/RJkabxgJwj6k1KFxg35yr2QUV0Eztl+2s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D5g9CnKPAE8F0EjobvLc0AM9URUQ8EVZ78T42AVqoQ5T615B4I0tPn0823tDrqXhpvZKf4+qFm8pNVfrDlSSEQLwOcWvgSVOFL3wpHjRajCfuiZYi3msZshxPrheabX0dhP/jr+iPhh8MizLNI6nW9rJxG2cz7WalLhxQwJWH2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vZWi8PIt; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vZWi8PIt"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b6cea7c527bso5847625a12.3
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 06:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761659651; x=1762264451; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QykRljktm0mc3MCvnNCRxcTfgz7VgLQw/V4DiDkpL8Y=;
        b=vZWi8PItseegsKBXdiL0TghovbhIAsieclcoF/4w1KqWeLJuzjPwMywfGt0wBmvuIK
         Mv7Bl9Kl3jMHj0jvkEctHc3EYHW71nP6+X4QibreyE0oHE2EdYNeSNx8Bi4N3xbfEG1P
         25VT0AFViMBXZg0Eb1lq7WVfVZu2ZMEkb/sZNgC3/Nz+jO9osVNgDl2eLWLk6lELYRNE
         LoxauIEajy4EGqeJjhMSenbBFkyak3qmxN7qxybBNHyXtnszWf46DEgxi3osK8noHsVr
         eYAtvmgFRZJd28kPyhY2SK6b46D4tz64Sk6gJ8aBFqW0AQN+ca8cTdzkvPGinlc6KQvs
         spJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761659651; x=1762264451;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QykRljktm0mc3MCvnNCRxcTfgz7VgLQw/V4DiDkpL8Y=;
        b=TeDEvLnw9u5o4Y4xDjVXLuX2wgeVt5URncCWCRaHg8LVRI9uQF9YZQCsIAU1CjJ9JL
         tGtP3/FTlY8Vt7pWm23v6WULkVbcy1sJwi+/f5oL8+I+8PWyO7mdV3b0TQ+W7n7vIWEF
         MhL0sCp9AgdGzbw/kH58pktE7E5XhRRNzdV3b9jJbajifSA055zYBL5VJO4t9Z6kdR8Z
         Q+WzKeAHNrC984rsiLR0EtMrSJcUM2AUF3rPhU2IxuF+gMawze8so/lUiCnUiosq0eWQ
         J0xizCuX0fXfzQQ2PrI8Ve3eD5Dzbtw39VSlW4Byqjq3VRqVClUeek6kP3eblV6D1jt1
         SKGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUaBynoLLa4YYWl0Uhmv5OEaTmHRawJXSF1OvWLCAzcGFpoBTR7LvKcvJDQs+9dYrIu9CABSKn@lists.linux.dev
X-Gm-Message-State: AOJu0Yxt289LMPONNnzVSoOMAxhodFWrC749K5qvONNPGjUPc0fnA7jh
	5CnzXT2H20Cdiz0QrBUSeB+35fecSUe6Giu5Q40qdSj4X64NbRYAUh+ZJOjr5ZNdqSIRb5u6JN5
	VgzRY33u0Lkh4WCCkcmZV+7JYIhKT54e+yYCGuCu2BA==
X-Gm-Gg: ASbGncsvK1eKM4Q7zgANbKGScaDWi1b2tkLvSFUU/h/+I3Lg1R7Cd9uha+HWbVVeMVF
	b3khvIeG/K3AJOKuF/CEFQZ6BsFSCx8JkaWBl7DOJAFsWIkl7mFPB2vfDpKCO/+0TvDe79nF1Oi
	vAJoMi3Swwm+ZUVm0Tj7rXBFb0yksmM78PDCVFxN4c1GrYt3icohskZcCvzZleXa99ekYTQtd50
	F0rUYfBuSskA2nTtZfmu6i9d2EkyGrWICjTJR950ksEfdHCAnWv48Q9CgQMPT+FogtS3Dqtwew/
	KbAk5Pl/ZvDq7m1zfyzKuHEExqh6RldFN2h15ZEvYR70fdYOpA==
X-Google-Smtp-Source: AGHT+IGUT0qkV3Bdj2hJRPpHT/PCadIoTCU4Ou75DCNinRSDeuk4gg21sOh4WYOhP7ha7zpx4+qR6h80MoL4LWyV2Pg=
X-Received: by 2002:a17:902:fc47:b0:294:db65:4de7 with SMTP id
 d9443c01a7336-294db6559c3mr4322955ad.27.1761659651151; Tue, 28 Oct 2025
 06:54:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251027183453.919157109@linuxfoundation.org>
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 28 Oct 2025 19:23:59 +0530
X-Gm-Features: AWmQ_bkje0OMMwzc6vZt00O0sguix3wBBNGcE3kvzFhV4YtpJR5AvdRehnqWb9A
Message-ID: <CA+G9fYtXU8UjgypJo7oXEXNysMQjohpy5pam3b7gHUYDhyQ9Tw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/117] 6.12.56-rc1 review
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

On Tue, 28 Oct 2025 at 00:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.56 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.56-rc1.gz
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
* kernel: 6.12.56-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 426f7f601ca06d40c899834021f62b7cf90894ca
* git describe: v6.12.54-253-g426f7f601ca0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.54-253-g426f7f601ca0

## Test Regressions (compared to v6.12.54-136-gbd9af5ba3026)

## Metric Regressions (compared to v6.12.54-136-gbd9af5ba3026)

## Test Fixes (compared to v6.12.54-136-gbd9af5ba3026)

## Metric Fixes (compared to v6.12.54-136-gbd9af5ba3026)

## Test result summary
total: 122101, pass: 103425, fail: 3993, skip: 14304, xfail: 379

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 51 passed, 6 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 24 passed, 1 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 46 passed, 3 failed

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
