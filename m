Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE00F225A9
	for <patches@lists.linux.dev>; Sun,  4 Feb 2024 12:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707050981; cv=none; b=BbtdQVTojNC91U0Nz6Vevm+fs9Ak6JbPx0mBY1iJb/m/9TwisuvjWfh7wRqGpB4NAsqwKgl1aJFkH8b83bUqctzlTd2XRsAtOj1O3yJHhzM9KaooFWsmyb+a+ZIEYDsvxKaXQ9A7daUuRcsA7n178LQ7x6FQLnfvWAg02xw2r9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707050981; c=relaxed/simple;
	bh=7wTFTnO+F0NScoiCeS/b1XS3lcSN7OeKUBMFETX8PgE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eDij+brA/t/+gZc8eHZm92SEwRpYtzgguU7mVjaoCsmcrICqWi0U7SbRrbf8BcdLit8VVpS6KpNA60CDDJOmnH8RZduP51xivSSXO3wS4pzAVBhqe/pHqnzQIy38XF6HK1f6Mc+G/MJSai+V8EzACzDUVGaUOZmnbYiqEmEr4xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FrvWZzbU; arc=none smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FrvWZzbU"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-7d625a3ace6so1815504241.0
        for <patches@lists.linux.dev>; Sun, 04 Feb 2024 04:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707050976; x=1707655776; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TQFJiOCeyvW9AxAcex5su40KCd58YjeLn27g5qNpIqg=;
        b=FrvWZzbUaXnrXrEcb8h/XIitcUAmaN4A+1UUjd2fIwgnz8oSOIpTjalbn155w4WdHr
         696YCUq6DIqy9yQ/UrLbKg4fDX9x6vkeewlomDbLGZESIVpKq7jtdyYl2eSEallYT6QC
         KOK574rPHGDqzDrlI7yGK94wNrfmC3E3bejvQASdJxE7IUExCDj2yhnjeKLDI4kvlfr2
         mT9gohJZ+3N7BndpipCPFXsX0Bg8aYrQX88i+3p2FTsNrWbHQalOiJGaaHEPMFKg99RT
         cbJcJiGr34xNOhzgsGhY2jsfkOIEqWhEJQkdUX4Oq8L64oknDNpoArcHQze0rnEmB5ch
         JCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707050977; x=1707655777;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TQFJiOCeyvW9AxAcex5su40KCd58YjeLn27g5qNpIqg=;
        b=S512/YxlKhL4Rc+zfSX4i2ULdpgAixNNnKTd+ReaYD8x5kDGxz3F2SPkhqv35NZ5WT
         bzBW+PbIeZATnc5QohNYycyuWraz/DjrD+SiKyeg2A/hxh8EQV8oXkYiwhKTk3s6dpxd
         PRtFyTFm0IgaIJo/k1JBseR/FfHoT2t9tllMZKyMtG+UTxnUBHLN2pPFIeZ7SyV5/iiT
         6xQSEAcoMZj/NEZoasmx38V3Zdr+N0q9e4QSVVibLOzfnIGHBW4rocttH89D3n1edJXR
         7j2RG8VL6Ww4DuIL6hUBU7eOH03lGEiOZYDP2joE/pRH/MZk5mceOz1lOQyCfk9F+5yV
         UYeQ==
X-Gm-Message-State: AOJu0Ywc47maJAnIRdIo1jDgZStZaUeoW5AdPSXTSXy/XdHKsxIwvH37
	Vf/lj/5FQMAyIJwxJK6ZoSe0oleaSGe+xPw9ZgO0g59vultTmU/pS+nFPf2H03TLS+Fo+w/0ySa
	ooQo9N/Uu4ZUdj21LIk42LZfWGS3y/YywxnKPQQ==
X-Google-Smtp-Source: AGHT+IE7K1f5hGsHb9o85lZC4k0opLUhxhUSdn9gGK7i6T9mDmjIQVk2iYv/bqC4EKvLPtWBe8CbMBp1HdjDZIdRlB0=
X-Received: by 2002:a05:6102:1620:b0:46d:2b67:98a6 with SMTP id
 cu32-20020a056102162000b0046d2b6798a6mr203160vsb.7.1707050976486; Sun, 04 Feb
 2024 04:49:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240203174813.681845076@linuxfoundation.org>
In-Reply-To: <20240203174813.681845076@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 4 Feb 2024 18:19:25 +0530
Message-ID: <CA+G9fYuTn0xFwbK0+5pFNQND6wx3ezZWJjLuyktCXKEOK24EPA@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/355] 6.7.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 3 Feb 2024 at 23:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.7.4 release.
> There are 355 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 05 Feb 2024 17:47:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.7.4-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
----
Following Powerpc defconfig clang nightly build errors noticed linux-6.7.y,
linux-6.6.y, linux-6.1.y and Linux next-20240201 tag.

  error: option '-msoft-float' cannot be specified with '-maltivec'
  make[5]: *** [scripts/Makefile.build:243: arch/powerpc/lib/xor_vmx.o] Err=
or 1

We may have to wait for the following clang fix patch to get accepted
into mainline
 - https://lore.kernel.org/llvm/20240127-ppc-xor_vmx-drop-msoft-float-v1-1-=
f24140e81376@kernel.org/

## Build
* kernel: 6.7.4-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.7.y
* git commit: 10be46ba2b8a6653255c23ef52186db20723a01a
* git describe: v6.7.3-356-g10be46ba2b8a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.7.y/build/v6.7.3=
-356-g10be46ba2b8a

## Test Regressions (compared to v6.7.3)

## Metric Regressions (compared to v6.7.3)

## Test Fixes (compared to v6.7.3)

## Metric Fixes (compared to v6.7.3)

## Test result summary
total: 149088, pass: 128906, fail: 2231, skip: 17791, xfail: 160

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 143 passed, 2 failed
* arm64: 51 total, 50 passed, 1 failed
* i386: 41 total, 38 passed, 3 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 34 passed, 2 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 45 passed, 1 failed

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
* libhugetlbfs
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
