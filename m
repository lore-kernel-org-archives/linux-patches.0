Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1651EEE0
	for <patches@lists.linux.dev>; Thu, 23 Jan 2025 08:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737620616; cv=none; b=dnOgJpWDOpz70XhgnbU5fKMsKRUu8HY7wI0YctxW+MXqa+IAV5AQeFYNV/fuzPTT6VHGGUj4ON0H7S9vQAHfrZoZzRoJCkJ04qVqnnaibob7Yoc5Hv64DitONt8iY0L113P81bhuXyc8SzCYJ+LGWopMq0hACkCf4gUefe1D8mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737620616; c=relaxed/simple;
	bh=k+F4Yh+Ql2d5/O3Hz9vVyBRTDvF+gjl0ohaq2x+51rU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QjZ59navwcmbRkL20Re2GDhAEr+eUGoszjqYzM8Phz6jV8A9tMneHdj4Wannmy030GtS6YFIn0nbYzLROlA9RZNo2AFSUbsEqE8r2ngBu6cLPWcinw4WupSXYVKEQSwMBOrpmH1h6I7Hx9OfXF0TdrfkTl2QKxuZpiY9toG8wC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eLJLecfb; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eLJLecfb"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-85c5adbca8eso164068241.0
        for <patches@lists.linux.dev>; Thu, 23 Jan 2025 00:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737620612; x=1738225412; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dn76UqJ76Uut5NswtzAbnqW0Jfd4Qqd1Omi81eFZ2/s=;
        b=eLJLecfbRFr+8PsT0ryz9gqSEI9hobDGPF5SsdRoaAijSp8oIsMLTfRlfygzW/NkCX
         NmhlSVNXZLAQo06Mb6jwhq6Pka4e7V7nqPFWzCxFeeV3oJnpZNXmoz/2Z+Qq37iTRqA/
         jPoV/ag8Cneku79+CMwsS+zHq3Z2A6y3zG3CutJ3CzJ/Vx4GQOq110h+kc7rBjCNE3KV
         z45+l3DXzDhdAS0YUZ7AadWj9HrvcBCS5kEzbPvoWUqP50wzzwmL4/B01eOvCW06VDBb
         hoTzGn33dTCESqXxlmyfhOm7pQbkExbAf407osMS/f6NwhpOhgaav3y/y8hkJQQJej85
         eSFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737620612; x=1738225412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dn76UqJ76Uut5NswtzAbnqW0Jfd4Qqd1Omi81eFZ2/s=;
        b=lRE0I5axqZjq5vMJceYubHjU6kObq8VhQ+Heat5V6wHiUvUmocD3xQng3p4MwpT6Ff
         ug+hRwJw4WnruEZy+/EYMi6H4sFuGqI0Jak3lrplet7KRxiUq4uO4ut3kvMECT7DDecK
         KP4o1DloFwCdZBq6AMqWoFgWk0QY6y60gq19ZJqc05UUtI5AdkQadwzudB2rEDDODvj4
         ApbAxp4+Fgyz7DXqrruxtchr/b2P2pWpHyxNf5D2HFhkkD7LSlDjeyYbHr01lVUULSoD
         Mpu8xJL2dbTHeHi32XXtHsxU2qJiYwzjEzt6BHR82xj2ILmzRfaKeTtDNFcmNaRK/sIA
         LO8w==
X-Forwarded-Encrypted: i=1; AJvYcCURgCNnXG2stfLlePQ3vgs82qO+93c2vCVedHRn6e6tzSaSxs8mI/oQWzJxWKr1s1hTMK1Uo8/V@lists.linux.dev
X-Gm-Message-State: AOJu0YwJHXZUXiAz3K/XQBmJNRTZT7zLbNRB5zy0mwJNknwcoM4WkYKG
	SEqmi1XClqN85/Z7u8+U6/Af7s4PBLYQiK4aItRzLv2yB2MGSxPM3QaymmhCKuRsggE5ERMjGa9
	q2u/lI5sIs81g3sweEKpjwuKiJZNoELQygfXuhA==
X-Gm-Gg: ASbGncsxiTyZeh6pUrm6ah2WU97RvfPF/7iD/9pLe9GStd+u0SQJwQmgaVUQJSkPgef
	OJX6viL5K1AWMvDOy1yxR4DK186qS2v5VatgMZZuYBDhKGBfgnvdFxVFV8NS7jjQ=
X-Google-Smtp-Source: AGHT+IGK8fI3fxpC85rMREdfJ/pQd3JZ1PoRr2/QFlFJtCWEM2QLjvwLRdwewRksGtG4+Bhk82RHb1zruVyybEG+37Y=
X-Received: by 2002:a05:6102:3ec8:b0:4af:e077:8a73 with SMTP id
 ada2fe7eead31-4b690bfc4c7mr20151892137.13.1737620611776; Thu, 23 Jan 2025
 00:23:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250122073827.056636718@linuxfoundation.org>
In-Reply-To: <20250122073827.056636718@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 23 Jan 2025 13:53:20 +0530
X-Gm-Features: AWEUYZn2E7j0_LQ9Ij4benW2eZMt62H7J96oDuzB8A3K93Bhuz0BdRo7UwvEI6A
Message-ID: <CA+G9fYvEVxCS6nb61E2ABxvAzvULuZTD7xvdut=g=5tfbg17VA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/64] 6.1.127-rc2 review
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

On Wed, 22 Jan 2025 at 13:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.127 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jan 2025 07:38:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.127-rc2.gz
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
* kernel: 6.1.127-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: c5148ca733b386401ef46ed4ec93a2f4a078e187
* git describe: v6.1.126-65-gc5148ca733b3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
26-65-gc5148ca733b3

## Test Regressions (compared to v6.1.124-93-gf121d22cf28e)

## Metric Regressions (compared to v6.1.124-93-gf121d22cf28e)

## Test Fixes (compared to v6.1.124-93-gf121d22cf28e)

## Metric Fixes (compared to v6.1.124-93-gf121d22cf28e)

## Test result summary
total: 101152, pass: 77945, fail: 4846, skip: 17897, xfail: 464

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 139 total, 139 passed, 0 failed
* arm64: 46 total, 44 passed, 2 failed
* i386: 31 total, 27 passed, 4 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 33 passed, 3 failed
* riscv: 14 total, 13 passed, 1 failed
* s390: 18 total, 17 passed, 1 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 38 total, 38 passed, 0 failed

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
* ltp-co[
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
