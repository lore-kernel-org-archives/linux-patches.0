Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7249768ED
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 13:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706103775; cv=none; b=uU+ZKNcaxd9LSQYtL5Cq1TsQZCN/L8Acrau7i3zsfl5vufxEYlFaozi0LomnPNwNHGmpo/Gsw1h0/mezCvuTQoFaD+PoZaw9IMbSbvb0dQWaml3KYjjgjvXRXtkvsKBcLNaR9F4CIZf97OBmXwK1uA8exoigAQaZLz9kZmdE7g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706103775; c=relaxed/simple;
	bh=HP8nxaU5rS3Y7akBagTf6CBwQ71I4mYNtI9RF8Xh36g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TwW3gzPiSGsmgtvI2j4HoeVZ+gWaA6Z2UeydFzBRXp+g4trfXYITM3M4bScjDusqM+9pzdLvunJ6cnHUDOzoZyJOs8GHUgAvNCE1SPoiMzd5c0mgeEYasdssQfWEa3Yvos/HRZjhLOPrsfCiJ4xSDLslCFYpNHS8F+afS0LBDGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D6/l9Y0B; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D6/l9Y0B"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-7ce528fc53fso1757237241.0
        for <patches@lists.linux.dev>; Wed, 24 Jan 2024 05:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706103772; x=1706708572; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1TrFLj4+exaa3X9fzr2uX3yAlSBmc6Hz/Z8VhWjlP+E=;
        b=D6/l9Y0B8vjC51CUq/tyD13M5v7KxstdQbgcm1Og1mXOOHx/ZSiVA9rT89P7MO0JxG
         AB8aQqNlGtjDpJCqKRe/f9f/vR83YssZubJZhpgma9YfN6yjKXFwgfpXuqnsE6k7lTaL
         b5vDNfPLnd7dOs3mMEZvnoJwxSYCYGEPvhNbPHlhECYq7cOPWnYWuGngJ3tzfj13QEWP
         7D1fwEtzyba/ibI0B3vjFvPZJSKUriboI3auW31L5mFWnu/QKH95dJNWR/tMb5adDKQP
         JK2HT8v5TQPGHnuBb8XKfVUIkfUnuCKcLJJ/YfE0ClZyxmbwaLHox1Vy7/7z8DRSKvpy
         l58A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706103772; x=1706708572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1TrFLj4+exaa3X9fzr2uX3yAlSBmc6Hz/Z8VhWjlP+E=;
        b=sxzymywcINeY/sxfxw4AOxSkWnMmlTB4duq6D7LKGvl0B0QdRcxNp1zbfdRDiF8uew
         YJHSVqv0cvcyqmRvrvjTk762GGZDXFCxNQat9ehKyk3gaZj7SvZggHATsOm+5eUYZVRn
         zs7S34osDsja8rfbFDtNj0L+k3YoVjdBcfBjy0LkLqtNNErClM9nPpGBBvj1r3LeGRSF
         XxK2tSA4NIfiHSuDRpm6l2Ln4eqexzW6JScm/KbOgvlwlPoXKekXu3sUlgKws3m/s6BG
         ei9KEh3/4bTLS8Dz4/n3WTJqgMXCX8SlJ8TJ7jdrH7IAlRGIAqtIFJodV3lazSZ96mCH
         FT3g==
X-Gm-Message-State: AOJu0YxQvzMnxdAVaZlWKo/nwCnMwVRMvKy3KRZy92uPgcSqySi/lRgz
	2BvycPEF1zkt2vzyZiP4NFxa0af7VI7qE0BqB10Sb0AIKSu+BjLLx4pSvqaooOwj2n9Zfvpd6iD
	wiLwX091VuztjtgGM8ZMA7WLeOc9e1Z6wqA2vqA==
X-Google-Smtp-Source: AGHT+IHcwMyxWT78OAzMCLr2qdVhvMuRS6XWYrMXxWbbEvDbczGsjz048cKKxGZ192E9nQTpVyjJWQqzOAyKI5BZx7Q=
X-Received: by 2002:a67:ed84:0:b0:467:7d9f:afa3 with SMTP id
 d4-20020a67ed84000000b004677d9fafa3mr4068481vsp.2.1706103771587; Wed, 24 Jan
 2024 05:42:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240123174510.372863442@linuxfoundation.org>
In-Reply-To: <20240123174510.372863442@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 24 Jan 2024 19:12:40 +0530
Message-ID: <CA+G9fYuj_UnUoUPy0FAhZyrAkgSAf77AeYu+Ds3fnZuN8a4-GQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/414] 6.1.75-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Jan 2024 at 23:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.75 release.
> There are 414 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Jan 2024 17:44:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.75-rc2.gz
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
* kernel: 6.1.75-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: a7fd791e5c51cd002dca6309fcd6ab75ee5fa9dd
* git describe: v6.1.74-415-ga7fd791e5c51
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.7=
4-415-ga7fd791e5c51

## Test Regressions (compared to v6.1.74)

## Metric Regressions (compared to v6.1.74)

## Test Fixes (compared to v6.1.74)

## Metric Fixes (compared to v6.1.74)

## Test result summary
total: 135195, pass: 114143, fail: 2690, skip: 18196, xfail: 166

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 151 passed, 0 failed
* arm64: 52 total, 52 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 34 passed, 2 failed
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

--
Linaro LKFT
https://lkft.linaro.org
