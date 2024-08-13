Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A231CA9F
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 16:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723566637; cv=none; b=FavDjdPnt11ZlvVwekQkHrB3KW3wrxK5y6DUtyW/I3f1KBI/Hcejv9lq3HjEtENKD1G0GDzNELJdV9Sq4/vuDIgPkVL+heY2isyS3Q0ApIH6pr07AM4LL9wxGUZRg3aVHqrA3KVBKnMOYrrY30FMazSIjTJmbyma0y/l2+VeO9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723566637; c=relaxed/simple;
	bh=+kXd5lQBlmgt4ODhbDWegMf9ii18tWOxfLuvIC/UtU0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dGyRjHisbIXb5sBSO6JacUz+i9pZqv3kJEjpEG1nAGhqo0hV1srxIw5aIy1Wnvs0RQQvcd+0UO31yulJySWbaUmL5sZSbEyWnQ8vr7Jeu700C2nT6CA78wihJouvNUCeoNmmtUUDv7lNUaVgjZAYrAxBNjJJPFP3pZUnF7py9Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ch9Qjnmk; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ch9Qjnmk"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-4f524fa193aso20134e0c.0
        for <patches@lists.linux.dev>; Tue, 13 Aug 2024 09:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723566634; x=1724171434; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IcOkVGVomQgpIlgkRw2uEX+wAov9nzcGjYicRdhvNpA=;
        b=ch9QjnmkrGzz5gQlLs/baKVqDBl3zUuEnqYh9DGMS3uodZpbaRFtyOMK5iI5bXe8m0
         7cZ+SNmg+eBydrQbwQSUR25eukODZfxDLSfwjtkBucT++DKWeQuNOvOYrGomLCGFKRVN
         Q0nFQJKO4hfMyqrEKGFEpuh0Uf1CxuGQpEd26s2aMlVmawA4OPvlgD3gmwfa97peCytT
         ukgvJhL8CURL/Pl6MKK2ka3LZ9gRnknxMbSDm7CKsmEfkxCs62UiRR4ENmjAQME1xBal
         nhKPSFTmhdKGPrSAQK6Mkhy2GayIlv6RlEIubMQXUOBR5yPeCTPomf4T13sbGUa5DUQd
         fFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723566634; x=1724171434;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IcOkVGVomQgpIlgkRw2uEX+wAov9nzcGjYicRdhvNpA=;
        b=I5Z39ZP7l5nFJXne9P0D03g5uwJyEVzeH5LIa/fxYaEzOeS4z/2HrINAsQtsgyOmGr
         50lQyetihW9uHgCX5EuV1bkBdDt6JdtxWv3UsZ0WdEikJtLbY3j1JnzlmyFRZYVvHwJq
         bS5btUZTR/D5vf5txosFDLA6ml2iFUhozDYgXpevQVwpYX63gkF2aUA24HJsVTZkQlAi
         /RrthJ+S1jw0DHNVboC6anSax6JqUFo3DpG6y9ReEfAtf2XEbLCt9N7upD3oSrDnisqC
         JDPLkhVcfCZfoc8E63WFT9y7fuaA+5nn98k9ffC6GgCQ7Ad4hDieZ/qcvWEjZKzt9OM8
         besw==
X-Forwarded-Encrypted: i=1; AJvYcCUqrBv/08bNTYalg2aAW0/Kn8Fe8XECSUJdxvThQ/rlCJ5QYoej2QdhrPkzr5xzQ5Rt9gUHqu4HKl/Kt/+hJWwuu+KFmlIuSg==
X-Gm-Message-State: AOJu0Yxq0PaaG4Sj5K6jDqRg84EwwtlwEJXHGpsgQ79D4Y1h/3DXYp3H
	3AVyvsgxbBGU4+jkmZXDV2qZOcTU5yXNV2mZ0lwbhgcb4Jw8l4f+adE0zj841/XcgkzAaBn/aXw
	h8USZ2pkrih8jrbe2tlfOAz1qRUwDB+RbdO3TkQ==
X-Google-Smtp-Source: AGHT+IFU2kpn0vuuQICPaDAMggyIuddBpewr8z4/Dc9irwuRYKKCgZ66IiMoSL/+f+SHq/Zuf1+9i3z0clFf39M+P+I=
X-Received: by 2002:a05:6122:2002:b0:4f5:19b2:5435 with SMTP id
 71dfb90a1353d-4fac17fb19emr2537940e0c.2.1723566634139; Tue, 13 Aug 2024
 09:30:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240813061957.925312455@linuxfoundation.org>
In-Reply-To: <20240813061957.925312455@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 Aug 2024 22:00:22 +0530
Message-ID: <CA+G9fYtev5H05e9-BpRPaifWekO_xBNXVz0Ev9ps-hFXcVN8ZQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/149] 6.1.105-rc2 review
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

On Tue, 13 Aug 2024 at 11:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.105 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Aug 2024 06:19:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.105-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.105-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 9bd7537a3dd0286970c1962438e04c42993f76a9
* git describe: v6.1.104-150-g9bd7537a3dd0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
04-150-g9bd7537a3dd0

## Test Regressions (compared to v6.1.103-87-g54b8e3a13b43)

## Metric Regressions (compared to v6.1.103-87-g54b8e3a13b43)

## Test Fixes (compared to v6.1.103-87-g54b8e3a13b43)

## Metric Fixes (compared to v6.1.103-87-g54b8e3a13b43)

## Test result summary
total: 315861, pass: 270713, fail: 3868, skip: 40792, xfail: 488

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 270 total, 270 passed, 0 failed
* arm64: 82 total, 82 passed, 0 failed
* i386: 56 total, 56 passed, 0 failed
* mips: 52 total, 50 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 72 total, 70 passed, 2 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 28 total, 28 passed, 0 failed
* sh: 20 total, 20 passed, 0 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 65 total, 65 passed, 0 failed

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
