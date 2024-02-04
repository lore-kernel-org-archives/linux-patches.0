Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE6B23770
	for <patches@lists.linux.dev>; Sun,  4 Feb 2024 17:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707066263; cv=none; b=mvSrtjH13vanX3ERo0kjrnkvWlLGgZulvrqO2TLemkYApHjEM69ZpFCOZBCjL8J1nGWNI7mhlapTR+BZdbtk0ailExHrq7SzDtSe6cCQoPmnQ7pL5RRufZIR3B1PYAcvWg+fYRbtqEazdfYJ8hWWKs5PJ0Aw4ec0F0qfiX5z1pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707066263; c=relaxed/simple;
	bh=yX+h8IvK+A/IWb9Fj7CnGrWJGC/nKsEUvKUrijLKEUw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YJrvT0Hh6KqZRDQPbAtyLkpOEt3ieokgtn/I7f6dy8LzgNGDyrU1yU+JY2SfRu/KwA6sPrHFtm1Vz6/Gk4P7PQE4MRCYjoVSetwtx5eDjAwCDNoEGeJHlv/XcIElVVA0eZgPhbtKWhJCEsNFvY+Bvf6XQ3CPlFqw8zgTmrLVZRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f4WN1p6P; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f4WN1p6P"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6e114e247a2so1918368a34.0
        for <patches@lists.linux.dev>; Sun, 04 Feb 2024 09:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707066261; x=1707671061; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UZ87Ikp1Acr0lR8nPCsHqhfw5EfhYftxf6b1PHlKALQ=;
        b=f4WN1p6Pudj0r3k5+XxCNmYjqMPs1bxw073F79c3J2ieoH5i6jVw3ONFOlBgv08Cuh
         BHQGz2/GUDykHzTxnAZsrIeIBEOWNVSfNblkiIHkJaYpHfo+BTvQqAt76swdedHic4KO
         eKQSo0P0SpXz2fmC3oIoLdkR9vXwGuOxP/ZVHwEeGnBwt1+ZnlxvJYSAEc6LJpByNCAu
         3mti3OmdPb/nm8PKkCbJCJ9M6dtG/4ijp6nhc3qHB2qvH4ZHhj6DR8BIQAzMsmAKqdhP
         /CEpXOxHeU2fYhfGuBt+9UHj0wEvPipeJgm3z9jqkJg2TxBdX5WxzJML1DZEK7e5itTb
         ACSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707066261; x=1707671061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UZ87Ikp1Acr0lR8nPCsHqhfw5EfhYftxf6b1PHlKALQ=;
        b=Kb5xB33GPzSeV3njJHSQOdD5toOvCD69qoFO6NyamqqJ4vQt24j/O1qdiKk82eupQd
         QJgMtIMJWQWblL3LW4g8xy7GctxjHu46r1XSfyK0YMW2PwlB6SnEwEXsID/I+OonODPt
         6QosfKNCQDt04ZlHhYn8X7hu4tZb18PmNi1/Xr6d2Xx+wC4Cz0EjfePWbwY3+fVd54pk
         /La9t5eZM+2+N0RjLFZOWjxfeUmxWyGoGEOVN7LjI/o48Y6vaH6yRLpZveSz7ecMkL3D
         cqI2oz3Q8P104B/Lbw1Ov9QNHhxkohBncRveocCRXvgS7jig/arJBujL0YTRfee4yXtB
         XkmQ==
X-Gm-Message-State: AOJu0YyvoKWokaOjK0hLVKbH9zh48N4OBGdsSO+OCdvXkdZKqdAIa0nM
	uE1LeyRJSeqo5YY1G0hr4Uy+qts8YGtc+UKWlsZVXqURCbSj6obM6Yf3aLzc1V2l3+V6J/lksY0
	OQDYlSXAj38ZnMXpWlKYJraLtm5IiY7eD4tZ0jA==
X-Google-Smtp-Source: AGHT+IFyki3C2fHB5tLh21Mi14JEHuS5/4QIiLwhXFkotGmhY7RN+9cmNc/XKl960Uwp8wmTxGzsZFEJhWTLUUDFFkc=
X-Received: by 2002:a05:6870:c6a4:b0:218:ea20:4a7e with SMTP id
 cv36-20020a056870c6a400b00218ea204a7emr6467887oab.42.1707066260676; Sun, 04
 Feb 2024 09:04:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240203174810.768708706@linuxfoundation.org>
In-Reply-To: <20240203174810.768708706@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 4 Feb 2024 22:34:09 +0530
Message-ID: <CA+G9fYunza75sqMnFW8TOr9UsNfwuBFRDm=+BnMQ5kXJmMSFmw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/326] 6.6.16-rc2 review
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
> This is the start of the stable review cycle for the 6.6.16 release.
> There are 326 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 05 Feb 2024 17:47:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.16-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
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
* kernel: 6.6.16-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: 8e1719211b07ef9172b231100722f54ffc23ed27
* git describe: v6.6.15-327-g8e1719211b07
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
5-327-g8e1719211b07

## Test Regressions (compared to v6.6.15)

## Metric Regressions (compared to v6.6.15)

## Test Fixes (compared to v6.6.15)

## Metric Fixes (compared to v6.6.15)

## Test result summary
total: 155032, pass: 133733, fail: 2219, skip: 18908, xfail: 172

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 146 passed, 1 failed
* arm64: 53 total, 52 passed, 1 failed
* i386: 43 total, 42 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 34 passed, 2 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 48 total, 46 passed, 2 failed

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
