Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDD519DFA2
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746028260; cv=none; b=QlQTTWzQBQeMagi6NtXktipIggfjrR0LzoDRG+7GW58ujMbqNyjAzxtSh6tCJz5uxFMmG5cuDpJUd3regGvHvn5rxYAvqJVpHpOo6xABkEKzWu7QtYxuLzNT4Ik4yi9QkbvwEdyg46656OgTydFfZpKmTaMFD/MRnZ9AQ4Cknew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746028260; c=relaxed/simple;
	bh=1mCRoSl/WXj9EpqFdvrhBKzBNrOH0XyKXi5WpfLxlMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KcEAyaI5ZnRRqYiyStR4jEJPIsWMwx4ifTIptZGvx79CoBuDz3H7DRWLmTGKrYJxiH7nmT+eTvk0De9Zao28sjvUPydiEVsC+Qf1qrfDOkIk/xb9I1uQCPYfmKhahQCo1Ov/qXnhMHFFIX9DzIaPLVMMIJjGu2ShM2vD5pAMcQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rbBVIzqa; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rbBVIzqa"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-86d3ac0fec0so6669761241.1
        for <patches@lists.linux.dev>; Wed, 30 Apr 2025 08:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746028256; x=1746633056; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uJAx/WqHCy0T5aZ2CQVyjJWgqdYiF6JZTKOjqwwgqJM=;
        b=rbBVIzqaFKvfScP4XjxtVwkc+gwitvhHh5WZGkDS6xSn3s9jKwZ+YFc87/UipjQFrY
         C1PZh3o39xrjWPFQRmm+9ixxg9czpjLtDVhGj/ybKOOxkcSMMm3u/ixFCeyOJo8gqBy2
         QYwrv2XdDbCBwytzejFK2oAYJHhmfxnqcLWtCnVXb3kPCbxXHIV3Y35zmq3cYA4Lbs46
         +jJUC9YaUEwPUnIerSw3Xd49FHPLHGBl5LjuvgVf7qJCCpMyiVDtSsUqPWaPaV4RNexQ
         mGHJopk5NhkAVAzHj3flH6tXN40+4qm8oq2XK0Nlrz/1kjX4FY3RCENKtd7iQGWZrLQ+
         jbXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746028256; x=1746633056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uJAx/WqHCy0T5aZ2CQVyjJWgqdYiF6JZTKOjqwwgqJM=;
        b=nigDDpZWI7WPwHkEtwzmx1bhHq5NbO1ordxo+5sAjgs+ryJ5RMZ3pyBnD/3tZ7f/LN
         dlTvp8HZLYwfC7q5bbE696t3VYlJFYWuxvWOLWFbZzZ5AawtlamadN9e32wwHZnCS6UE
         10Zy2IYLArn8PGlwrc8AzGYLTUULnZA4NnxgkltLMPC7iVeihJ/scBlsJL1DunhPUhZS
         9N7N7gmELjIhcHNG9FcY5H8H+Px5a0HDXm+WBy94B2SWioXjvAtTSTlwqPNPI8ZJDBRP
         ZgIolXNg6v99CTBg7xPQV76ZW3B5cmPCx/zgqcUJCVPE6s2E46JrOTyE+nL2p5V07q4J
         12kQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNYuWcVLBc+EXvYyrYx0neKpuwVkgLHLSKEYVzg97PL1Kr99Xgh1lfNfrxyrXkNcjJIH1FDiyU@lists.linux.dev
X-Gm-Message-State: AOJu0YyfHQmlOibDf7E3X8saWnvjUTnwwLgVDU3rK/dqfcMilcku0tFu
	zbOYBX9f38QZNSLNMjo8gWLNmu6vmHj8QYieQQfaWqZyCfMd0pjlXh9I6YmdZRs6BnqQoKQnN3d
	0cuMHH3DrTO8cuauve4V2mgiKWuj+EUhgit0UDw==
X-Gm-Gg: ASbGncsf5qxtP5XLIV8KDU8R/E1vG4p5gC2iOxEK8nFWY64KHjacer5UuTwyCLfA/f7
	uxjwREs+t/ALVfozyduNyVW+I9FyhxdLFhIKTZ9lzgKxvjQ6QMtdLcsMU/gJTGCo3POsINbuwgV
	KBMN17kICeMejaIePFeHW1sZZ58zogyK7THxmK1v52+7o/DG3xEAr3Lck=
X-Google-Smtp-Source: AGHT+IGGsdPw3RT8avgBXabu5//S4MiovS5cVHy8pMESNsoOOlpTQkhJUXpjjxf/3yA7TyQdDfUlJPcOKqFKVhOhzFg=
X-Received: by 2002:a05:6102:2ac7:b0:4c1:71b6:6c with SMTP id
 ada2fe7eead31-4dad359944emr3077320137.7.1746028255694; Wed, 30 Apr 2025
 08:50:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250429161107.848008295@linuxfoundation.org>
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 30 Apr 2025 21:20:44 +0530
X-Gm-Features: ATxdqUFMXca-djiqqc25Inw-41HaeAOh1iaxf6BhFyDDx8VbrmE3g622gxZ0Igc
Message-ID: <CA+G9fYtGFVgM+RFNZnOWyvkCq3iZvOj4Npo6Pxnt=5f=EHhgvw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/286] 5.10.237-rc1 review
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

On Tue, 29 Apr 2025 at 22:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.237 release.
> There are 286 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.237-rc1.gz
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
* kernel: 5.10.237-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: ce0fd5a9f1a4e7c9d2c59cffe033ca7d1d7e1688
* git describe: v5.10.236-287-gce0fd5a9f1a4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.236-287-gce0fd5a9f1a4

## Test Regressions (compared to v5.10.235-229-g5b68aafded4a)

## Metric Regressions (compared to v5.10.235-229-g5b68aafded4a)

## Test Fixes (compared to v5.10.235-229-g5b68aafded4a)

## Metric Fixes (compared to v5.10.235-229-g5b68aafded4a)

## Test result summary
total: 45273, pass: 32910, fail: 3086, skip: 9042, xfail: 235

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 102 total, 102 passed, 0 failed
* arm64: 30 total, 30 passed, 0 failed
* i386: 22 total, 22 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 21 total, 21 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

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
* kselftest-x86
* kunit
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
