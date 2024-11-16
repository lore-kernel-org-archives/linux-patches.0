Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB2616631C
	for <patches@lists.linux.dev>; Sat, 16 Nov 2024 12:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731761600; cv=none; b=sxTfShIPJ/Fp501FYZS7zt8vQt3woy9qvDGOJ5Vwic4oVaiaTY727KjYw6Xe4w2huFP6/9LhYsCRQGxLV1K1FT7y0r0KBhu6NHirau11XAvlEAlLlsxhHSMn28jM2o3UjU0gH4bg94cualjfTtDKuBw3ymTfGURLHid+EKcZo/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731761600; c=relaxed/simple;
	bh=59otJXTX3TPHZSbpcdpyniMM4ZfEufZ2SuyYmnUp6pk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mH0vGCv6IPpIeDaZX1oRyu8hZmUOWFSKzkUvk/XgtemLM+ZClcbeXK9eq47Y/dihIMfku3oNjhavIfFf4BErxMRXIW/urK/0U2Mx1MCrSIYP850CY08CjgV9EYsd0eIfu5Pcr4ro6dkFDlavko6XZUJ04CLPqAwLJGwAJrWEzyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=azzsIrvW; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="azzsIrvW"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-856f2b3e1b7so184101241.0
        for <patches@lists.linux.dev>; Sat, 16 Nov 2024 04:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731761596; x=1732366396; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AlNnVnxiQ0/Us6Qy9l4AWDK9nCRlBxYrSIXgIu4HdPo=;
        b=azzsIrvWrHltkFV7x5UJP2MKt4GiJxvkyMU4D5WhyfeQKCiXd4OFx6VaypCJPOuNUm
         zmFerCr+BUot/utth2FKykeTOGuctuyJhDYEtkuabbPa3xsFm1Eaq2u3G59iRm4DFlix
         VLVtXF0yYTKf6dzP1TtysBM5LkoLbBY+j6fys08DlpbxxvDBdQ4ou4z2VAe9ENDfr2Aw
         1OtNHQvxHQr2Ph3j2b808oWHBb8kD++LQ0ZG31YbSDbn+Bi4uOn296GBsutYbJZz0/KF
         9NhGhqXpbzLqHvnwLa8NpnsKEI6n0GD0S+f4TvVudn2KH95S6X2U7h2861F9OUfQH6Kz
         4ZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731761596; x=1732366396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AlNnVnxiQ0/Us6Qy9l4AWDK9nCRlBxYrSIXgIu4HdPo=;
        b=xJsKRC+KptLWmXDdK8sBvmRbIc/oyko5JyHeC/3/SoxHCdelHdJnl1mIr9hAV6dsia
         H1jPvrFOMY62PmAeeu4R3elt6ES8T8u9rn1fkdLZtr9t3PtAj/k+/oE1kRttOzKHJ/GG
         5B8hxlrj8MEhNBzQ6kF64smvyp6NMSzKC5lPQlAVbW6gSvF3CflQeSW9JU/jluB79jUg
         uz8FheUsCYLwgotzJOBotfNem6IgBDz7lByhTeRBEnL+Qm6kA47XtyKjGNtqLqNv6CQE
         SxqRyujkNl1BwE8hRzHhtOEOXL7f/La24/U6D1FDIEwBxFwK5wCal34NRsrFw9g80a0y
         Po6g==
X-Forwarded-Encrypted: i=1; AJvYcCUK5Yr0MiOLFMybCCHnKW6bEy+bciqtdWdgnynIqyu+uySmFWsZfyIXvsfWnvMAnrP9B+n2JzFn@lists.linux.dev
X-Gm-Message-State: AOJu0YwyU+DbOvdgTqg+umWuL3yRU+DjvybXAavA1SOIQvktyPtKQWfO
	Due9Q/16TKLMOZktdTotPMZkidwifP7bbJc6UqrkkT0ynKEli6S63i5WthMqxHgmaci+Z7w3oxZ
	nWZ4tkv9HFXz7+4BJ+9XD0WaQ+kKmVZSAGDl+LQ==
X-Google-Smtp-Source: AGHT+IEhl/7zaJfBDAMgE7jr6T974RNihwhmyM3AqcuHj/rQo9P5BcBwkz6m6hlI0/17nFhK+cCIFmhp6AhxtaXefmo=
X-Received: by 2002:a05:6102:dc6:b0:4a4:9363:b84c with SMTP id
 ada2fe7eead31-4ad62ab15bcmr6164221137.6.1731761596528; Sat, 16 Nov 2024
 04:53:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241115120451.517948500@linuxfoundation.org>
In-Reply-To: <20241115120451.517948500@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 16 Nov 2024 18:23:05 +0530
Message-ID: <CA+G9fYtdzDCDP_RxjPKS5wvQH=NsjT+bDRbukFqoX6cN+EHa7Q@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/67] 5.4.286-rc2 review
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

On Fri, 15 Nov 2024 at 17:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.286 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Nov 2024 12:04:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.286-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.286-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: c655052e5fd83d7cfc19a650eb6c4cab30cc22cd
* git describe: v5.4.285-68-gc655052e5fd8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
85-68-gc655052e5fd8

## Test Regressions (compared to v5.4.284-462-g5dfaabbf946a)

## Metric Regressions (compared to v5.4.284-462-g5dfaabbf946a)

## Test Fixes (compared to v5.4.284-462-g5dfaabbf946a)

## Metric Fixes (compared to v5.4.284-462-g5dfaabbf946a)

## Test result summary
total: 57128, pass: 39927, fail: 1369, skip: 15755, xfail: 77

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 132 total, 132 passed, 0 failed
* arm64: 32 total, 30 passed, 2 failed
* i386: 20 total, 14 passed, 6 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 26 total, 26 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 28 total, 26 passed, 2 failed

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
* kselftest-watchdog
* kselftest-x86
* kunit
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
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
