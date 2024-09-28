Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499B4186E56
	for <patches@lists.linux.dev>; Sat, 28 Sep 2024 13:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727530982; cv=none; b=shaCuLdtDwrEUJKtYBigQqSM3rfx6F4YpNfOoB1HS9yRQtkF6ipipDvP8t4SPL9H2JqweZro8yv/hIR3ZO3vdQe7ho4AZHMA3ixICPBnLWtXyvhVZoTBfOOzXmB+5l4HkgSv2DKHyR6l6U3oZfZqx+c33Cc2691IQ2mSpsUPwqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727530982; c=relaxed/simple;
	bh=j8+uLbNk15LUD/swoLKPjamTGdWDzEdyurpg9CKJ4HA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sx3yefP3XC222VsBo8Nd1aWF6Plz77HWeMCKF0r34mPt6syb6ibSL6x2eL8Chu5fimT8j8YKGxJzyUfkCMxT+HdJGGaGRffXYp7zSLtgWzE4Gur06ekJylssVGPEZ41t+4qNNlZibmyogRj4VwNoVIbaz1OBmE2P85hbzKAxyXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d0mXXyyr; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d0mXXyyr"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-50923780607so117772e0c.1
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 06:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727530979; x=1728135779; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c53yyAs7E6NtQLNrLLtPZdGoIfca6+dE3YJrHfT4exo=;
        b=d0mXXyyrlEVa4FJjnw3nx5GrGHrGp6FQnYbMWTXwWCBVCGLyJkpqVUqmCHhJZT2R3q
         7krulUF27liCDhk4Ww/tpoRAdNp7li8twFq35nwMKE1l0i3+gdnhm9IhnF/GSBJg91Jp
         l6PfC5xotA7MKqIjq+2qFwFhA9qd1ZQgfji3epc3yCY81wP2z2kPjot4Ne8c5ZrYBt96
         uySwC2264Naea4zUHL7pJbDl9P7VWdThUpr8H8CVyDzkhn3YSkPlRJlVn69bVPQSIxZc
         yKKUAq/pl1ooP3zfU/z8nNWP46R8FGbwIs7b5wQQSaLsVkFxYIVzovsKj2Iljr7RoOng
         ktnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727530979; x=1728135779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c53yyAs7E6NtQLNrLLtPZdGoIfca6+dE3YJrHfT4exo=;
        b=rYYtUsyYe4/RMEypeyYihi3UTgQVHMyV7VHiKM7QmEqDmunH11+tT4SqgNtT5shIeX
         jvaIj5yScs8unKzllbjTB++JRQkI1XRtgASPXoXgY7zmYIhZJapIoELWFKzvyZz1IBL1
         5KJEL6rpGuMGbVDhDqCDzna5SJetqalAVeu48yxzxTm1we2Es4mFXX3bpar/+cN4cdvq
         NvscGFoK3vVmOckYeLCvgUVxrmMaYxS/QDe2usjL/Kx8dO1rDItDEpWOeXugNu2wop5B
         pKN/X4aC/4jOB8FcB04HyAJk5O5xzkBP6xIM/c0unfPfGVh67NQtooW7YxgQuTe2CoIL
         4B9g==
X-Forwarded-Encrypted: i=1; AJvYcCVD10FB31YyMBqWyQ9lB0qNSXiCEhKqHSX3kfoyOJXB5x33m5ObO6tnxYb+KQuWo483MuU2E9Rx@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd49JNZ2OPZ037wQzOId+B75BmJyK+8CE1ZoEexInrONe+FH/q
	Buur5FJASvl3ecrWZQynGptFGEJ8mV7iPHpb2BAwwJDHyoRrL1otd74WJxF9DpKF2u3HC3c1OZV
	jaDyefQeppatvcWzOiHzwf8eHaBBPfnv5w3XXRw==
X-Google-Smtp-Source: AGHT+IFXav694ULLBUcIHDeEBtyNOQd2icWi28G4aTHq/JtEB90SqMDUHu4yQWX4LIEEwmaG089P2mrQbxxAZaJ7Bdg=
X-Received: by 2002:a05:6122:921:b0:4f6:b094:80b1 with SMTP id
 71dfb90a1353d-507818ca8f7mr4297460e0c.11.1727530979073; Sat, 28 Sep 2024
 06:42:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240927121715.213013166@linuxfoundation.org>
In-Reply-To: <20240927121715.213013166@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 28 Sep 2024 19:12:47 +0530
Message-ID: <CA+G9fYskpf=rGsmQ2QCZ2GVvBEuO5Fc5ROWuu4a6udSB9c22GA@mail.gmail.com>
Subject: Re: [PATCH 6.11 00/12] 6.11.1-rc1 review
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

On Fri, 27 Sept 2024 at 18:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.11.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.11.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.11.1-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: cecd751a2d94beedbaab82f5eb42ed19b0bbff41
* git describe: v6.11-13-gcecd751a2d94
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.11.y/build/v6.11=
-13-gcecd751a2d94/

## Test Regressions (compared to v6.11)

## Metric Regressions (compared to v6.11)

## Test Fixes (compared to v6.11)

## Metric Fixes (compared to v6.11)

## Test result summary
total: 225868, pass: 197174, fail: 2806, skip: 25888

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 131 total, 129 passed, 2 failed
* arm64: 43 total, 43 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 3 passed, 1 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 6 passed, 1 failed
* x86_64: 35 total, 34 passed, 1 failed

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
* ltp-ma[
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
