Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4125A524DF
	for <patches@lists.linux.dev>; Wed,  1 May 2024 10:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714558443; cv=none; b=e0Ucr7Sif2/5lSsuensnG1HcjFTr+HfTaWZfrxSVt4YpIMxHciGIHBD27kpu+nDihCWXS/h5bvw6Y1jYtgmLs3d1kEQu2sidYoWe3cYoOiDxOrBJq3BesZVLr2VnlfZPQGRHiaEemzgIvd6lM9SuQ9U/9aVQsWlqIqwNJNS8DHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714558443; c=relaxed/simple;
	bh=R4fmjy+8hfGHxDfrhgKhaTl+RpHiDKixsqP18LZW7AE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UuWqY70rcy++Wc8SVxMiCgd4W8V/f+wCvbOCBQz3piIdGIer28g92kIp33EGQTuUdCVr2OMTY4es2gxa5UMnrYC1rioeCi+8ZfaVF1NtpuHpmZ+yUpWFGsqvnnG/cYd894T47WQbvVcH+4/WiZ39wolQKjsvdFeBdHsByRaSL/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Dmdpqb/V; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Dmdpqb/V"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-47d8b5bebb1so450010137.1
        for <patches@lists.linux.dev>; Wed, 01 May 2024 03:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714558439; x=1715163239; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EbIjCKOEuz58/k1pZWu5FN3AtpqH/WknsKLnXxTqtW8=;
        b=Dmdpqb/VqGZDowhOvXGYuVPEfHZ58GsQ83Wp87QyL5vAtVkTYuu3F6McCzq3v+UDhT
         S37KjNcKujsikLhYDBjMr8ToilEs1RyCW3U3uTtGD8NlAIH3+huMkr7b/beEqC0vcB3u
         ytZphMm/MxDit40IL2HaknrASBdN83fWpxcAqdzzpaMeIpdmCOURb3L9krqb655ciZD8
         0fae+XG8X+qAEaK0zVKXmBvZhuuoV/l8ZZVNHZCU+4jsFjZirKdHm8hNP55VTMomPHXv
         J+xwrmEpbTga+t8mhfeNLpMVcoczrElSWJcsIsYtQS63iNX2Q3QujxBcIC+9saFr1Kot
         o6zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714558439; x=1715163239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EbIjCKOEuz58/k1pZWu5FN3AtpqH/WknsKLnXxTqtW8=;
        b=Rg5DOyi8E7t1kVSfXYsIqftzzckpeCbP2bkBwvlAKI90LUW/5bhPlrqABD/Y/22a73
         TpN1uRAUn1K6KQ921Sn9Ti12tsvKf8MOcPohgGd64KBewPNB1EGFM+MZxcamQ+GPdzjU
         3pcZoQZBP0RysKW6t4IB1mk12Q3DYOeYnRrWGXReCqgqzhAHx+XQ7nNcjbmdh2lFw7UM
         PkOxWp/YUwouGKfiPhtV6zm9ctNl9aVFCetep3H8AENCmeOIAJ7KXxZ3PwvXRZwhE+Aw
         PVSj5pJ6pKXAkfga7HspIma0MLyrZm7htLRhs1YS3UTAWQR4XOB9GQThQGGUIi5Aamh0
         +M7w==
X-Forwarded-Encrypted: i=1; AJvYcCXkxbD9wDCaVovgUF5UyKuZLo/8Ezzry4HLDfJ+SFvkI3p35B+P2+AFhhvDXcHGBVnM7oMYGTd4ObHhDWysAq2GBdqaHiYbOA==
X-Gm-Message-State: AOJu0YyKJMIah6GBETEmuISlMMr6eOXhAkZ6dudD5aXzwcT6hT9pcDqe
	ddyALd780lHVLobH/VZdTgaGGqu6cHGGL07zMn0IrOFH8larTDLKVuFxwPy9IqRTv7VeSZ54Tk+
	aBE9ubNZA86Nb5g7ogmqnBzeDKGGoiM6KPFCT4Q==
X-Google-Smtp-Source: AGHT+IGPZVswxDsVKQ85QCYc6SsPa5oLux4hMYc+4nof+Quq002rktVnJ9FzL5fqHueqx254hm//pDt9M9EdnP1v8bg=
X-Received: by 2002:a05:6122:1695:b0:4da:a82e:95f5 with SMTP id
 21-20020a056122169500b004daa82e95f5mr2140942vkl.5.1714558439121; Wed, 01 May
 2024 03:13:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240430103047.561802595@linuxfoundation.org>
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 1 May 2024 15:43:47 +0530
Message-ID: <CA+G9fYu8cj_wEwWLeWwO5krCfnKbKbNZ=sgnZkAXSi-0XmbbXA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/110] 6.1.90-rc1 review
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

On Tue, 30 Apr 2024 at 16:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.90 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.90-rc1.gz
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
* kernel: 6.1.90-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: b3fba631803defe65cfb1653433902b510db9330
* git describe: v6.1.88-113-gb3fba631803d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.8=
8-113-gb3fba631803d

## Test Regressions (compared to v6.1.87)

## Metric Regressions (compared to v6.1.87)

## Test Fixes (compared to v6.1.87)

## Metric Fixes (compared to v6.1.87)

## Test result summary
total: 142192, pass: 121440, fail: 2635, skip: 17971, xfail: 146

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 28 total, 28 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 32 total, 32 passed, 0 failed

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
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mm
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
