Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E24660885
	for <patches@lists.linux.dev>; Wed, 31 Jan 2024 09:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706692919; cv=none; b=Y7FagkqWpGcHDMesXGRVgs1nbEt/dsL1/CmdzsuIzcf00+XR7uNUnVhF2adUKrumtdCSOX0NIbebx0dAzR+/OxIu3rIwbg4liz5Z5WdE4F1qLBYQBKotYueYMpt0egBpOmg/p0Xg0N0/e8QxZBzHSvkGH+kx9WF3/8yWz3UJXr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706692919; c=relaxed/simple;
	bh=SAaMwNJn+2lVKcGemFp9iczayZE/LpTTrz8hdgTSFYA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hK7FDWun/10oZYK0YpYOjlNOCKP7g2SnSokceVuNv6Qt20fxhY1LxSdqcJCwtFH33VGHUR3tPegbOO0poMecwZin8EUWVARy/X/eaSeifozIW6g5sBA8FTkIUBKypVYg+262WAmFhlcshYHs4mXz0vFyyp3EpguEkqwGiLV1u2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D0im4EX1; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D0im4EX1"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-46b35fad293so1291864137.1
        for <patches@lists.linux.dev>; Wed, 31 Jan 2024 01:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706692916; x=1707297716; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ciKe48E5S5XvJWsuhR935wOI3y5DUHsuIixqs+fAckE=;
        b=D0im4EX1gX1XvKSqhVahvxgy8nrA0mf7b4mStGlj1geSieWIHVZO4j4E8uYxKRBR+u
         n0yOoySNtm95JZpNH/qOOVfs27c//IeDzQeYVbmkC6TTI1hzlbE4pQkeMqlxpExTVibU
         lA6qA+xSHasY3eBaFaX+msMmC7CA8id0BKFjjpEOdU3MVwZy9QY7KPdAmHMYyVlYW8AQ
         Mr1YlzHbXuEl7mLC1UU1vbdXq5KE2mvY9/oHhL9/B2kma8p45gG+7BEP3LMZk+9J7XVN
         DqOc+N+e3/Z1sh4OaRAWJT5h1fbyD7F6WyYulhlDooodfputwzFo2KbTv95e97Kl49j+
         Ad9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706692916; x=1707297716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ciKe48E5S5XvJWsuhR935wOI3y5DUHsuIixqs+fAckE=;
        b=dE/Svl64wcf/Pq/MuZpoiOs8IRi2ANHfptL+k42yVWPlg0ABCwb/DlXvJP2Au4wI/6
         /sMyZkffbUm+vvUo2C50J2VgGK3unjKDEmPGREfwm5JamcbTypboHPtfRHERrTh6pNN7
         YkELTv/7kO0/0N//UU+g658WUdkY35/4MgpMYUqiF+oicU14GrnfvTvoYCM+s4p0Illh
         WnoI9d/RkYvj/w6yIQETFcqvWQiAcQ+jW7jOSkvI6A1PxPUyfdkrmlKPYSbRl7SryY5g
         LwEi55sbIFvcgu+eLD13XzqeXpypq01/tSEolQUEhPruR2bzE66eNo3eJyYV1jGFjjfD
         M+Og==
X-Gm-Message-State: AOJu0YzPsMhFL67gKFYoIr9cR2TVAsFZOJQq3ciLMtK5hqlxo53E8sEx
	hKdHbAjXl92DGzPEibDa6/ZvMa9rkJZUnmDWjEgL3+XG0rsC/l68a4uwZ8kAmx31qme1ccj/YEU
	pWKoEtmqAi7teAke1WjBA/5HcTBLwyNfNi0eAVg==
X-Google-Smtp-Source: AGHT+IEqAesS+yRRrTLmaGaB64fxinZhk2LNLD0OFdCvbsBaqPRqVvs1qKTZJ7dkz5G8Eu19kOzl0Ytkjf9SXpRwaCk=
X-Received: by 2002:a67:f316:0:b0:46c:a3fc:e899 with SMTP id
 p22-20020a67f316000000b0046ca3fce899mr814472vsf.26.1706692916240; Wed, 31 Jan
 2024 01:21:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240130183318.454044155@linuxfoundation.org>
In-Reply-To: <20240130183318.454044155@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 31 Jan 2024 14:51:44 +0530
Message-ID: <CA+G9fYtbtLrqBVr5hCSLSeWU6sFdsF3i+iWXZQUd6E48S-AnXA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/186] 6.1.76-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 31 Jan 2024 at 00:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.76 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 Feb 2024 18:32:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.76-rc2.gz
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
* kernel: 6.1.76-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: ce3f6cd9e4cd1f20fb62a64cc5c53578699d952b
* git describe: v6.1.75-187-gce3f6cd9e4cd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.7=
5-187-gce3f6cd9e4cd

## Test Regressions (compared to v6.1.74-415-ga7fd791e5c51)

## Metric Regressions (compared to v6.1.74-415-ga7fd791e5c51)

## Test Fixes (compared to v6.1.74-415-ga7fd791e5c51)

## Metric Fixes (compared to v6.1.74-415-ga7fd791e5c51)


## Test result summary
total: 136691, pass: 115297, fail: 2721, skip: 18498, xfail: 175

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 151 passed, 0 failed
* arm64: 52 total, 52 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 46 passed, 0 failed

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
* kselftest-vm
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
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
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance
* v4l2-complianciance

--
Linaro LKFT
https://lkft.linaro.org
