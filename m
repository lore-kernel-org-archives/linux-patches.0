Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EED51514F6
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 10:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750243118; cv=none; b=AV5vddJY1Rg+x4Nl3pbI9Sy1g6JxxyNAEbFDt7Cmry6U3IgT7G4OjqKl0+A7QkpLCXs6kOsjfpHq4ZQFjaVVve57KjieIY7+LZ7UKTT+jJoMo2k2nedCnPDc9df4cXM+ms6FprWCMKlZ0nOTXLMo4sTVaFkx8T43RGsI3UCZh/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750243118; c=relaxed/simple;
	bh=9a+VL3V5KHa28e7NmLre1sNjbdQBiWLNlPZSaD9/wgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yn7yW3L3owxobMe09ExUKiOfHceTUUJChbbS/g673iUBTI2hesJHDK7Io35fqqABZZV3fBbxXiSxprbtzRa/XvlSVJpEYC3mClhwiTUyu2jkSK0FSLz2x2sM4ToiymMkWofC2xuzlth7wmnzZ826YLf5dA3KNHjY/KESkF9JeoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=N39ObvUt; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N39ObvUt"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-4e80d19c7ebso2744969137.3
        for <patches@lists.linux.dev>; Wed, 18 Jun 2025 03:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750243115; x=1750847915; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fg5xtbe/WgT7FmBUSQgT2r9SiVEXizKaw2ohyTbpqFs=;
        b=N39ObvUtyEBOlQkzyCoedzq5+jww1DLs/mC8A2Q/gNdmEaTaBo1MEs8Rokr+t7/Xov
         1HSTxiHr6FA38xGblgKSzWg0Dc0i4AC00Han3wYJQg3VDkPwisbW2kUs2aF3wbF0NHD4
         1tHfKzAChMmYLNk0oLfKtGS5lLGi6eKSAyOPepiI77LVOkIKKtzV/SriF6WdYrMnA3KD
         sWhsmDUgbk3GL7e775iRPa36fJ3nuBEfjYXjhOQt433OIPx4r2IyLI0nrekb7WJ0MIfZ
         scNId9Um8JxTocHv5g6mpDTCRkP1x0Xp9/p4t7SFM+MXfhA928el0l+NhyLK7lBxwYCU
         +WVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750243115; x=1750847915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fg5xtbe/WgT7FmBUSQgT2r9SiVEXizKaw2ohyTbpqFs=;
        b=m4NGzbpzpiFE9dQzJzXfz9kwAdDmccaIHQiPkIo3ZUI14ih5/h5zFnoZ1V1R8RRdZA
         TRCnpjabOznaJk5YTY4WEyJtcErUH44BTnpfBPKm13+8KHwTtNTC+juyaIVaEQGsYQae
         CNy6cHj4aLOty4mZD4oTw5XtbfPTDilPmvmAiEfR2TcRQerAQCGygXWNAkPs8v5lEaLK
         sfqx7n4S9HfM29nBH44KtV+8wkgpvbyu6KQX9LUc2v6/Fov1Yua/6GTiWXOePrc7SJj7
         aK16QoCePqN6xldIJZ4UW1pqzy/4cyz1oouHGO8o3G6KkCc2TfUFFdTJ6DIesvy62xFl
         AuPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVx8W6nfDfHvFJCIH24E8EqVE8WfexB2NMHu8cDTmMZg3tXt6JSabhZvNxmdf0L8GzVrqo53scX@lists.linux.dev
X-Gm-Message-State: AOJu0YzSMQN3LY5dM4aqIECLpRB2LZQr3PwXBBmM91GGhwTO+r4QGuJM
	Rysdw6kDAKk8gYgcPn3fMr1+UzLhIq33eSYYNXZkIQOKkMZVA7jZb+stZoUC0L2sChrLQ+JyGEO
	SYGut9ImqhwwXKyrywX+p3x5crUc2rVeJ+2ShuEXgSg==
X-Gm-Gg: ASbGnctu6+SeV44uyxtSAdvpLxVjVPA69R9XH9HaaX2+X/6ejBtEtneAEn4XPbnl1ix
	nUnJGvg/pWe0mVRtF0pTJmXx+ngWfB+rr4w8GUZyyozjfctm4mN2DvNRvZuvEXyypqn90oQDKRX
	UvBvlmkUBXsg1tjzD98mAuWRVrmML/ovRhmce3RN4abCw=
X-Google-Smtp-Source: AGHT+IGlfaQhICcEzYKv2o3Stujza9qvdQkGO403DqHMwBxcjQFicmsVSifd2BvFEXZCY1N3yeldnIcDuwCKvObxQZ8=
X-Received: by 2002:a05:6102:5109:b0:4e7:be09:deef with SMTP id
 ada2fe7eead31-4e7f6117f97mr12455145137.7.1750243115354; Wed, 18 Jun 2025
 03:38:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250617152451.485330293@linuxfoundation.org>
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 18 Jun 2025 16:08:23 +0530
X-Gm-Features: Ac12FXyOvwAA90cx5WybGNFeuMmnrzQzZyMyRWHnfy4aD9kitOfgrNhzgM3cmZY
Message-ID: <CA+G9fYtiuoPfpv6wCtpBhD4h3iRf2n8LLBpqCi5FHP67i-rS1g@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
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

On Tue, 17 Jun 2025 at 20:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.3 release.
> There are 780 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jun 2025 15:22:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.15.3-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: d878a60be557cef27d9897a1c5269b76e3269603
* git describe: v6.15.1-816-gd878a60be557
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.15.y/build/v6.15=
.1-816-gd878a60be557

## Test Regressions (compared to v6.15.1-35-g04e133874a24)

## Metric Regressions (compared to v6.15.1-35-g04e133874a24)

## Test Fixes (compared to v6.15.1-35-g04e133874a24)

## Metric Fixes (compared to v6.15.1-35-g04e133874a24)

## Test result summary
total: 256017, pass: 234795, fail: 6773, skip: 14449, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 136 passed, 3 failed
* arm64: 57 total, 54 passed, 0 failed, 3 skipped
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 47 passed, 0 failed, 2 skipped

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
* modules
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
