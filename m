Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411EC13B58D
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 08:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736238806; cv=none; b=QbnE9Tx6Zo3pNMcpD5W4Z5acN7G05xJvjGnP+c1wXPvCykEZmEtGPNaHlxN+2Wz6B8+TRodugAyZvzNJeBDhwDZYHyIxXy9WysX9Uj1RnK4eGU7GVyvox5HdiXPT7VhIjnW5oct1lOOVJamDlEukZLSB5d88jub1Q5WNowWlPGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736238806; c=relaxed/simple;
	bh=o3c4xW01MlLt6AqvT50LxovUv1h70hmJ6kadq6rLOh8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=euyGNuOk+wX4NfOj2leGl2QQeDqNUACJ6iQ5oXlb7zpygwAMCANii+SOjOOfmAtx3okBean0NA3HnbzoVVP4thsIZr/40ivhc/P7k31blVEK/uf8BO+VyecmIr+25HGpBkWu7fcUh3kaAXTraDSwq95Axd7JGlokg2D8J6yFx+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V9whRDLu; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V9whRDLu"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-85b88a685e6so6327912241.2
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 00:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736238802; x=1736843602; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AOb3+hAddSIUzdjpQrT/NEZaORWBlzf1SKg8j80MHAc=;
        b=V9whRDLuxpDRs/y2/29twUdWzTRPvwN+NXzs8zYDU47kZQ6zdNe2gL3WOqb/scpNBc
         TclXRNZtDlBfKmSOVpv0zUfRk5NVtur1zFfA4RapQRxU7jUlzTf5xEYXB8zOs/ya3RmI
         7SWSTgPhgYMcOXJOfSvh1Q42R3kSqDA40XEUfb88y73F2Lp5qmelNwgRoRoPx7Db5Jct
         uT7PKokBXeIo62xmxD4NrEb9WUBcf8eV94SrizVEHe3zOVBXCOhg6YcBOkKapeiW/kD9
         impu6Q+DDDI7dpJ8c6m2hKjDMxDg0euZ0zKCBHQ62xl6fqw28zn4Kipq4vHSmz5TCESO
         ksMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736238802; x=1736843602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AOb3+hAddSIUzdjpQrT/NEZaORWBlzf1SKg8j80MHAc=;
        b=puodQy10xOW9w9Cl6afdNVOviCXjUGRi0mNRTjfgVWGmU6U7XlmN/yur7rkD825QqM
         phpIddYAKsvlbCSX0Eh5OyjJpa5GrEm+f6vMhEOhFLz1MKmw2tISPThBTYP9GBRVs2Bp
         4fgRq/7mG889mYzPY9oqIsxUBy9JZ6SXjdUhTglGFiihClVddCBxQ1QsuyIlHOd9LPSZ
         cWy9N3kPPvwZOMeoQpgT3dKPpfVkjA4DJWEWZIG0fx9YWJzbd6Hf+CNCXkKyFcKr511Q
         ug92cXqVdk/TcVHB6rRXITJWuLRjFZG7lwjSssPBh/NuKkAk2JiB77yeSosibUqWDlgF
         PYgg==
X-Forwarded-Encrypted: i=1; AJvYcCWDnAnLkMB2jurWzKlRKWBfqdFqk/xd3h5AhsfTBgEWX8+3WAW0gVAVH5XdVdI2S9+xAyXAWZYN@lists.linux.dev
X-Gm-Message-State: AOJu0YwfF71AyUGTBghatg+RJhofyzqk5piViLAuPuTS0cGGyClzQEOf
	TwGng2KTUGqMj6k0GW1XsJc57q6qUco8UUGstYFYb/rLMCKz/PR/94ZnHWFkv1EdMPJywI1HWe0
	3POk95Hg0dsUbnrjW+Yxv5G9U5XXs7hm9iWlJLg==
X-Gm-Gg: ASbGncsLAo5xcsZxz4ximbJojBZtp7aSVHGBChpd6Yr0lSc+kFVM+YYdWOP0cKxj/jC
	WGyitC8WDeF5k0NcrtAgh+97UVMg+rAtSEOm8GeU=
X-Google-Smtp-Source: AGHT+IG7ZVdbFjQkwvo9+d7q0UxDBknTtxsvnf8taB/cPAZ4LDxl7qsgCBaerGbta/UN4qnRz6M0BYXLL5SJpvG73mI=
X-Received: by 2002:a05:6102:548f:b0:4b2:ae3e:3ff with SMTP id
 ada2fe7eead31-4b2cc48a5eemr42731959137.27.1736238801229; Tue, 07 Jan 2025
 00:33:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106151141.738050441@linuxfoundation.org>
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 7 Jan 2025 14:03:09 +0530
X-Gm-Features: AbW1kvaG91wnd1vMUK0C0HwzbTQbv1w3Mgho9lRI6s0h_W8EwlnNb-mIG4skv3I
Message-ID: <CA+G9fYtyKfP2pqMc8hOM=wd3hjbR5ffEA=4Q7VWZECbNP-SBaQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
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

On Mon, 6 Jan 2025 at 21:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.9-rc1.gz
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
* kernel: 6.12.9-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: cab9a964396de70339b5d65f9666da355b6c164e
* git describe: v6.12.8-157-gcab9a964396d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.8-157-gcab9a964396d

## Test Regressions (compared to v6.12.7-115-ged0d55fbe89c)

## Metric Regressions (compared to v6.12.7-115-ged0d55fbe89c)

## Test Fixes (compared to v6.12.7-115-ged0d55fbe89c)

## Metric Fixes (compared to v6.12.7-115-ged0d55fbe89c)

## Test result summary
total: 113584, pass: 91189, fail: 4574, skip: 17818, xfail: 3

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 56 passed, 2 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 40 passed, 4 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 22 passed, 4 failed
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
