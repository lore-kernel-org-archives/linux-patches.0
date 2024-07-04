Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA3B846F
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 13:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720099636; cv=none; b=t3wNNUIoTllDHuoExukRZkSWIhN5oJmKDZbAGbwOMQX72qERye/XO8IJ83GSLg91jLEOzuqPXmjnRsmyLt8jmBTAjcwQmY9HL9KTuDQAc2GA0tXI+8kxIVYiyCXb/sLP8vXljBruOKG9x6LRQkFc9DwnGMwWpiaucewxOZ4/3rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720099636; c=relaxed/simple;
	bh=nD4dlFykd0rag83nMKMbIxA95FBUzMYgo1O2Eewwq0s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g4fdeVCSr3SPmvAm7EsIbCws2D7EuNbNQUu1ai7YUvJTidoInSXxCCCcHYuRc53otmGzwnZv+o18pfaMOm7fw4Df+tnQ2sUn+mPcaJEKpWbb6jJFO3buwAyIkZ64qtUNUBUHLrv4u5lqMtQ7mgsYFX9drmOgXPxM0WUWrNUfYuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZfaHhWuD; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZfaHhWuD"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-4f2fd568899so13634e0c.1
        for <patches@lists.linux.dev>; Thu, 04 Jul 2024 06:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720099633; x=1720704433; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qcUcUtX7e7qX8Zg3ofi0CJpQeDuqdz1vevOFSzSU7OE=;
        b=ZfaHhWuDvZ8X9fcuNLEvKCh10YgSxE5Am4ixVn/0WNKkxYVqMfksCg2FjBy4JNN0Ob
         QWZRJ6W/EJxY8rwhsd/KGBtltuew+jqP4M1DurYXwUvtR5wbMTXfeWnUV9IsJMtnXTOR
         JIEfdJPqQJ7yEoJnV9e/5QyVh2VhDxUmWQaXti+1BduzWG2trKyIj+uphQaA3E8z1xIh
         dSvOAPjDAn45eetmewIQ55LyWQfXK/kXfIbZSLaTUWSwNKJnL7OUOnfM5CDqiiwrUN/5
         PPPmb0vq7NnC25BaqqOMmGU7xZ77HaGkGSVbjQfHnRWcwLOXP8aCIIo9KFOCmK2zGDYn
         NafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720099633; x=1720704433;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qcUcUtX7e7qX8Zg3ofi0CJpQeDuqdz1vevOFSzSU7OE=;
        b=FJ3gSonKpnEksz6MvHg7DF/5M0Znma0fUd36JBDEuml54NF60AZAjkubtgU8gVBOda
         SU6A5KoIANdfET9LcKnD+Bu4q/GSOV6Cck59gJ1Lg9JCmWBGPL1Xqy9fnJ2OYaKRMmkF
         fJBeKjRf3L+zgs+B7+nPwTgDmyii8oH4HPWjLz3Moe6p4AMnjaooppj3xjAf8gsqDy9x
         EsftWo0gsdLRHfnszxTtMLz2PntaQdkIiGz1X65/CHxHNR/WQARyxC9G5XEQ3fKitcPG
         YANkOw/uvLYvkwPrZCa+ogiqZWddSvhXBwslmRC9bHNU3GeKbFH3kssiF+DVQhwajWvS
         7hJA==
X-Forwarded-Encrypted: i=1; AJvYcCUpbTdICEb1jbFOjn0/aVrFJJ5PPR+cKHhG0oGTopJlvCpIDbllboZCSAwWGTiqMmqFYT6BNpDqxz5SrAbEvHVBu1sESIUfpA==
X-Gm-Message-State: AOJu0YzvMgktYlxTAd6Rgh/AKnmWGcVQEqLwUacLzT0sIw0ahJcsC3om
	LCEf2hVGRbcHxPdXktV1Aez5AJICVBb8av8Q57NfJGg0u9loTCmLCAY4+XINrM1eMY9THnGGJYm
	CJ2MGJtokh4Xw51r/eVfY3JngnAafS9VoNLQxbg==
X-Google-Smtp-Source: AGHT+IFXTAkShQutIlODaFkW/XCcuIVPd7eCwSuN5P4hK7O4yvbWqnC9eeky0EmDFKopq7ju/gRVhcTihk9V57g5D4I=
X-Received: by 2002:a05:6122:4491:b0:4d3:34f4:7e99 with SMTP id
 71dfb90a1353d-4f2f5e234admr889385e0c.0.1720099632987; Thu, 04 Jul 2024
 06:27:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240703102913.093882413@linuxfoundation.org>
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 4 Jul 2024 18:57:01 +0530
Message-ID: <CA+G9fYtbcy5eRrJSuqGPJxQi58V99GFtepxgOYj7qXHmoD0R0g@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/356] 5.15.162-rc1 review
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

On Wed, 3 Jul 2024 at 16:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.162 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Jul 2024 10:28:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.162-rc1.gz
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
* kernel: 5.15.162-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: ba1631e1a5ccf4fa69f692369f3f80f200b2678b
* git describe: v5.15.161-357-gba1631e1a5cc
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.161-357-gba1631e1a5cc

## Test Regressions (compared to v5.15.161)

## Metric Regressions (compared to v5.15.161)

## Test Fixes (compared to v5.15.161)

## Metric Fixes (compared to v5.15.161)

## Test result summary
total: 132177, pass: 108849, fail: 2842, skip: 20352, xfail: 134

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
