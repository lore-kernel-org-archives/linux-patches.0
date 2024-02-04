Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B10E24211
	for <patches@lists.linux.dev>; Sun,  4 Feb 2024 17:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707066201; cv=none; b=aYb2AG2Hw1x9eyvhgH2y7/cDe3MkTUgrAXeeeS9uYM6iatXFTDDaWYF1NKherPwQxz5rmulYJweNuPUWNtkBlWBpcKpem54SN7SefAE0bYTlCA9BV3wMKUbx2GefPJpBeNHcIrxKqYl7kmok3Wz34ubdgMPyWsz+Ij070PNaZsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707066201; c=relaxed/simple;
	bh=24sCwJLJUAwGwA9wjlLnpsqLaUYZam9pqmP0t3d5K50=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oFh+e9xVDSZsbCcL8Pszh9pM2pHaeMmUZBHxl10Qgrf0RJUit0ALfl0px60L7Bu9VtgOKDKn6MCUFNw519ZAQbc9HaLDdqHFyTs9YZVIVo3Y2RpHFpsJ7wmQs8s+o7cRnlo8qW3oB7LSwm5nF26cY0k5ZAAwt4cd2boSSg4Oik0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Fwljn/0j; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Fwljn/0j"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-21433afcc53so2329385fac.3
        for <patches@lists.linux.dev>; Sun, 04 Feb 2024 09:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707066199; x=1707670999; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bDn4K/wW/c8fSGRp7Mb5kBC0d+BPRzZbIs44N4i9Z/A=;
        b=Fwljn/0jOA0NmYHWvb/OSe+2wJlzyoZVBmYYiP6696jI1mgBDtu89C7DmISyzaclK3
         irtOFfUxZmvEq8oYe721F233xIl7qErULn5Ezb4JpU30ODHfiRzbRGYbCZ2UJ8SeILGx
         vvUgU8QMaLt+yQ0oBj3pQSw4CZWanSD1ZRqDEkO6Rh2+rnnj/xT+L3Rlgd71YcCj0DF7
         b8/vnluwqg4sI5CJTMCXWDVGZ+zRWBoiwmuVxu1RHyUILRTeuJvNTmobDCXL4zDMEnjE
         gEOgMTaP0FRe/YeyS3VZuZXBenHE8rPFMZlrz8iwvTn3wVzqOmd9iC3Y4qLWWIMo1HMy
         IIjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707066199; x=1707670999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bDn4K/wW/c8fSGRp7Mb5kBC0d+BPRzZbIs44N4i9Z/A=;
        b=fr3I5tqdcanopdGXmrW/0JacyrMt8eCmEmKGwoxbFL1g0kk9zv3kkPpSbmJclAfcsj
         F40ek9E7ozNZ5ptTmLrzYIEFOseYdt7P6tI45xv9vjSGfz53Yak+u7RhTgr9UGrRAncG
         jIeis4K+gjF/536tn/MF95e0efx0Bc5gu6jjxFV9Rnt2LbxqnuWU7jmJSZOmkB0PokRj
         WAl6EAIB2Pm37MmZGH6+tlxaihPGfwhjtzjkWMmtScLKoTOFODdXfyRJAqbpsj6EELlt
         H9/x7miGiGR+6pXGoptq0+QUq1yfohU9iDdrp/vcGLuxhgLGIxxEP1hxFFRUBN52zatm
         ZDrQ==
X-Gm-Message-State: AOJu0YxtaFS//7FHMiE53xbvZL2cgiyTF27niaPF1fHx0I4T28JJNm44
	MBeBO8hazgcGMm+0Q8hKuMRjE4CKEcdaW7jKKJfBiLMh1BauXWK+6FpLq9T+/WMqhjhoPGM62fN
	m7w9APnmnTxH4mRMxkD7GXnL0qAXjkVkroF8ihQ==
X-Google-Smtp-Source: AGHT+IH5dfsWMya9IXb4QHHcqRcY5AtT4iAzFUMV7/nyEsn21i9BjqkWD0Tvm4CiLLjIlPqN3TV+fNogSdRJjIoY72s=
X-Received: by 2002:a05:6871:825:b0:219:2209:6448 with SMTP id
 q37-20020a056871082500b0021922096448mr6516612oap.25.1707066199107; Sun, 04
 Feb 2024 09:03:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240203174756.358721205@linuxfoundation.org>
In-Reply-To: <20240203174756.358721205@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 4 Feb 2024 22:33:08 +0530
Message-ID: <CA+G9fYuCTuXYtL7wXpdFsYWD9+-pjhio3ATCFb8hA8UTa8Ki+g@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/221] 6.1.77-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 3 Feb 2024 at 23:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.77 release.
> There are 221 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 05 Feb 2024 17:47:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.77-rc2.gz
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
* kernel: 6.1.77-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: eccceff25f8274da6f7e7eb3d97bb4d41ddc80ac
* git describe: v6.1.76-222-geccceff25f82
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.7=
6-222-geccceff25f82

## Test Regressions (compared to v6.1.76)

## Metric Regressions (compared to v6.1.76)

## Test Fixes (compared to v6.1.76)

## Metric Fixes (compared to v6.1.76)


## Test result summary
total: 136302, pass: 115762, fail: 2793, skip: 17592, xfail: 155

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 150 total, 150 passed, 0 failed
* arm64: 52 total, 52 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 34 passed, 2 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
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
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
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
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
