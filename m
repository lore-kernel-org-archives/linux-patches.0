Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A351E4AF
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 12:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720614666; cv=none; b=bBBjriDVYXAVST2u0yB+MFjxT/HZxBOL4eoI3Svq82jhT3Nj/0O55MGXG378hQrlEtQLG6k2W9IgKFXxpcZf5EsgBFl0xNZlJN0nzKp1lVNUwYRJ62BtbUE3pQVnNeP3TCmGOw6Y2jLK8DG/Esq5wDwnWQW8voXsJA1gi5O0PHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720614666; c=relaxed/simple;
	bh=j2CB1IYugxTa0rXRRo+PzEw6wqFVB3MyPRvpWsJp/qk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ktvfd7QG6voQ7VIkrowcQVnXSfXI+hPj0EIsLDqoJRlTYkxxswzzp/mbCsQnwhKDY52z/5NW4O8xApkM4QLr99AVJAeveO2us8u1y90IlTcWQ1aLGbMvP4j85PoVHkZ3Fnb/RbTtRDR4Dd1xk5h94INY6TcnzC3cKtrX2qbPiuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DNJWciD/; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DNJWciD/"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-4f30d197e5cso443652e0c.0
        for <patches@lists.linux.dev>; Wed, 10 Jul 2024 05:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720614663; x=1721219463; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yx5K/74FS6SU2gZ9vr31wzdS+iWH8sI+s/sfE4t8SU0=;
        b=DNJWciD/7liiOYCOsCSyJlS+QOFnzLCupEzDBoJaxQs2oHGVTC08TTt1qT8m8aMx7R
         2vQiKfqrnNjE4OF71tuAkkobbG8yoHH7occbw0RaDydb0lSyaHnf55/n7Sct4NLkdA72
         ASfx7pCJKIzqtV6Pd1mZ2pS42QSFGV7OzhoQKlYJ3Z+7GW4ADbCyLJ3UK+W0TIn9b6r/
         W/x3Z9pJeJADlEtUwYYJ6616DI3jA7uz0GZTnzZsI5Ve/HAtXjjG1SH9igZ5dXFhvaRG
         pBaM+4D8Xw7JJsy8gPrwanNrZ2LLr2AXMzm0kO1LmgqGrOnWoF2xWIK2dAkgkogidXKP
         IGKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720614663; x=1721219463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yx5K/74FS6SU2gZ9vr31wzdS+iWH8sI+s/sfE4t8SU0=;
        b=bkxej7/JUQiEnnUv8KhigFpDp5qZ3Mho6N2aMhBudcY//dC+ZqP3g+CDz5muUAW7Bd
         /mlYsznPkaYNNgy7S+a4aaTLKqde5V07/5dRevjn4Ek7nMbERbfTVJe+Sa4fF0Y3HSoh
         Nrdxcj80T3LzveCSffY4KsCDzdL1flshmiOKv+Pp5uHQQH/Tbj+dPH6lpECSynGyDFet
         mQbCu4WaPmi7Tqauht5Mag4aUoxRegPD8Ax3iC8vhlXaUCFfswPAUFm683cugMLsmI0X
         db5a8lZHI662JZb7ugOuKu0otU7Z55kxsn/9lnOcBVY+pF6SrH8Mug8/of+Cipon0ZmW
         RNDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaMrOKOf9Ob/otP58om1CXmaG0D6HhxUaLeCw1sBdn5Dzb5Trx9/NYvNG5xkutPQlKdcSmWC4xNoxFuvZ987d3hUyQEwIZmw==
X-Gm-Message-State: AOJu0Ywupd1nW3Tr0q+V+bx7IkQkBSE9f0t9uGwIjXMbQIA5H7oljiel
	qVOfo2EVPaYZGSdx9Wz8dt1Ivxk3UGk+Q+n8W0rnhVyhOMlnQyDhDF0cCYMfNNlvx6EgVOv+ID4
	Rpp576fqOdAJJca+70YCxFoh8weB8uJvtNW9LQA==
X-Google-Smtp-Source: AGHT+IEnrOL1Ef9b4qJMG/aI4rTGiGMeiNh1rANHAMpP1crKDydeBnuAVTvcgZZsLkksfqrE4YlJ5vw2AyweNG7013I=
X-Received: by 2002:a05:6122:12bc:b0:4f2:ffa6:dbd5 with SMTP id
 71dfb90a1353d-4f3a35c890emr2508024e0c.6.1720614663476; Wed, 10 Jul 2024
 05:31:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240709110658.146853929@linuxfoundation.org>
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 10 Jul 2024 18:00:51 +0530
Message-ID: <CA+G9fYvs8EmAaxoxzHuEhr73+ppK7=o95yxUkJRE4U7RUjvyEg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/139] 6.6.39-rc1 review
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

On Tue, 9 Jul 2024 at 16:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.39 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.39-rc1.gz
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

NOTES:
1) The Powerpc build regressions reported and bisected [1]
Email thread link,
 [1] https://lore.kernel.org/stable/CA+G9fYvcbdKN8B9t-ukO2aZCOwkjNme8+XhLcL=
-=3Dwcd+XXRP6g@mail.gmail.com/

2) The new Build warnings noticed on arm64 [2]
arch/arm64/net/bpf_jit_comp.c: In function 'bpf_int_jit_compile':
arch/arm64/net/bpf_jit_comp.c:1651:17: warning: ignoring return value
of 'bpf_jit_binary_lock_ro' declared with attribute
'warn_unused_result' [-Wunused-result]
 1651 |                 bpf_jit_binary_lock_ro(header);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Build
* kernel: 6.6.37-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: ca32fab2f2f9ffc305606cc41fe02e41bce06dd6
* git describe: v6.6.36-164-gca32fab2f2f9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.3=
6-164-gca32fab2f2f9

## Test Regressions (compared to v6.6.38-140-g3be0ca2a17a0)

* powerpc, build
  - clang-18-defconfig
  - clang-nightly-defconfig
  - gcc-13-defconfig
  - gcc-8-defconfig


## Metric Regressions (compared to v6.6.38-140-g3be0ca2a17a0)

## Test Fixes (compared to v6.6.38-140-g3be0ca2a17a0)

## Metric Fixes (compared to v6.6.38-140-g3be0ca2a17a0)

## Test result summary
total: 256613, pass: 222330, fail: 3270, skip: 30550, xfail: 463

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 127 total, 127 passed, 0 failed
* arm64: 36 total, 36 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 30 passed, 4 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
