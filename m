Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5348B2E3EE
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722014701; cv=none; b=XZ6NX/d1GBXcSi83Mj2mv/ewsRbgWHQu+lahCZ4rAnbkTLpgvUBYgJPjsCWVKtPbBYclz2LuYudZc0KgElp1or/2JYGIcdwOcFwPejggoVZJX4mfcvZNnEg5Y/DcBFJDmHvkvkbq9xXnto8lpEorpvUsta9AyJYle1DSOtCYHHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722014701; c=relaxed/simple;
	bh=d7hmh8N3pCoBMuGhW4AGc5lKX1lHGbyxUOtclkpgj3Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s3gzpn8wICEs0t42kUAa5pFpzju45XMXfJhzyWS9tcaYOesB5CWk+zgGECTP3ZxLRJ9B1QQ7Q8pxG2MaaSahk51y85Oy7HLdMHopfgK5q8QC92iAV+mxtlFQr4vT3/jCW38zhfadSuqH/7m+1EphrLp/TWDcc8Jw8UjDpS/oX2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=W+Ogmpbt; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="W+Ogmpbt"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-493d748ba72so738026137.3
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 10:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722014699; x=1722619499; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HdUkZWObe4rGQcZr0zoGLyHGASv5SV+Kk6yoIF1//6Y=;
        b=W+OgmpbtkfNmVCtzvNnhdmgwB0TBeCjUhRhR4PFj5auU4JSxHfUQWUX1T0RzX/fNI7
         UUortEnGl4/OySb/vI4Y8+tO4HCVuUel+GMs8J/fHsHAl942Ed+D9Q3oldOwhoWJ4Cme
         256wTzY9op7zv8vdL9k7kFUkrW2Z9ecUOUu9Z8LnmYQo5me5W6pE9LUCg+OTjvItTPFZ
         u+qkDO26p8+wYIJ7fMGnswXeK/hy3sV1T6WZOoCIWegkpUivFuYi55h1P8aKJOLv2Rxb
         g5aimGK8GtP/aMzlasn7T6SADeTvIapBqHNPqbrPNbLu2F5R6f135HifJcr9tRwHi2ys
         Jqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722014699; x=1722619499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HdUkZWObe4rGQcZr0zoGLyHGASv5SV+Kk6yoIF1//6Y=;
        b=hHZFgSKsPURwQjzt43Jx21aob051ywYEB9S97dAjaXjSUlMGpiqwkn/iekXx5Pu10Q
         1uGkEawH4RmUPfSEBT33KeseoNj/CHnc4lEGSYtgaLqosoVWVD05XFtTQh4mdn4Dnuwv
         c0NXw1gWecMesgE7CCBDKjkeH1YYnbsKEF/V/5NsTgP5PuzvPVcCg/yn82XvOfribcbp
         k4/zT6qP33Zu/AhjI4F7vO5F69z5O1C7pRUZt8Kbbu5XkMLzayh+0ApkAQy4nluWrRbY
         oEX4FPJ8E94NE1DaG+nqRKK4o+4g+GnzaL6xwOAy3YKLrnhOWTX8DC59Uk63UVu3U/j7
         xydQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDKyMiVmXIFcOK3/mmTjEP39kVQg65Rd+4n6CWTxfO1irWP6txvECZ0xLb7v5MY5it5lfNklRgLWgnvAZ889uvBdFIb+Zjiw==
X-Gm-Message-State: AOJu0YyMl8zMBna7TYZ1ZkiZsGQcQPU3pTKEWcZbiBWS5M/iQdE0xv7j
	PhgtNYgdV+VHCSR6BAxfaqE3PhBBpmODkknVbWKTkar3i/vrF4AO72yANaiOFnn+6jbxuPZsMCQ
	6wr919jOo0ONtHRnUCAhh+0QR3ZIxnndZU9ruFg==
X-Google-Smtp-Source: AGHT+IFzKTWdLke9VjtZ/BV1OfWRdeakqeYLX7uvkByln9g609wuH+wARm2BvbhZPXdMPfmEOJAlrQ7NDRhJQzV3tyc=
X-Received: by 2002:a05:6102:f11:b0:493:ddd1:d7fc with SMTP id
 ada2fe7eead31-493fa19c7fbmr461627137.11.1722014699180; Fri, 26 Jul 2024
 10:24:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240726070548.312552217@linuxfoundation.org>
In-Reply-To: <20240726070548.312552217@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 26 Jul 2024 22:54:48 +0530
Message-ID: <CA+G9fYvGWZH=u5=FB9TYbeg3QDEUDZJMC_AutFQ95H2vr82fSg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/44] 5.4.281-rc2 review
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

On Fri, 26 Jul 2024 at 12:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.281 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 28 Jul 2024 07:05:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.281-rc2.gz
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
* kernel: 5.4.281-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 6b3558150cc145a5ebe7f22d20a01e58d3d88a10
* git describe: v5.4.280-45-g6b3558150cc1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
80-45-g6b3558150cc1

## Test Regressions (compared to v5.4.279-80-g4fb5a81f1046)

## Metric Regressions (compared to v5.4.279-80-g4fb5a81f1046)

## Test Fixes (compared to v5.4.279-80-g4fb5a81f1046)

## Metric Fixes (compared to v5.4.279-80-g4fb5a81f1046)

## Test result summary
total: 95233, pass: 76674, fail: 1631, skip: 16868, xfail: 60

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 33 total, 31 passed, 2 failed
* i386: 21 total, 15 passed, 6 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 29 total, 29 passed, 0 failed

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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
