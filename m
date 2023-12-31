Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23851185D
	for <patches@lists.linux.dev>; Sun, 31 Dec 2023 09:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fFo7ZuDm"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-466de67f0d6so3919516137.1
        for <patches@lists.linux.dev>; Sun, 31 Dec 2023 01:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704016157; x=1704620957; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dpJkWjQtcLPrrAUeSPsMgmPP9dcEbzNL6qUsGWeWy48=;
        b=fFo7ZuDmajzZyHAZQiTKZu1Bu8gD6Tr3tnZAxjbtzFIedlaNw6feQqV+iBnEYXcmIe
         00YhkkwxUCwWlG0rVKOUBLuU2UM8YYHvsFrQVwuxMOI8XUEovA22lZD5kXvmjH3gME6R
         B7PcyVtjBR2WrzhDXt8JXphFlKOvEAw7IUY9mPx89j7+E3nSdwCTu4QcCcagcNUHN8hV
         eql6q4LLmDNEBzVTN3N88sQw4rbK1dOcM+CXCr2RKJNeQssl5F8E5DiHMtOOzeo0iYM5
         hse6eTviNJY1MLbZ1W5P4H9xRaJg8yaa5AsaD4VUZXSvpbg6Sg/JIdGHi1oAVBqBbrsY
         vNuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704016157; x=1704620957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dpJkWjQtcLPrrAUeSPsMgmPP9dcEbzNL6qUsGWeWy48=;
        b=BvGzcaHNnNe6Y12MW2dOtdimgHvhe07mtnSnmgpOj9TO1xQlkpf1oM688Yle3LlDbo
         Lzf4r5VQWd2U6V7BBqzkON4RNWKOWH+TNVEgrwMYxGfYuKsUEl5MKgSZnT+z7stxKQuZ
         ZomSyS0BYGCb8QFsEmlt5063BXA2xQiC97mNYbTCih45BXDgsYSxufp6nhesL0VcL9mk
         sJ7gD+pD807gVSjC51kq46fT1tXcHz09DRdbb4bQY+cVk0RfATpwcay5Qwt+mB2VQm7x
         Sn9ZuOVLoaf7YPAJR8PhfrqLJhu8YzSFbGmTOKBBkOH4bc0O+BMyADoOu30/Qa/knE02
         oehA==
X-Gm-Message-State: AOJu0YxImgHVIPnjxaoLXIMDTVUYQ74gpgBrJpumC0+wNP9z7cCbbsk1
	iarj7FO2wjMgly+23TreZE1NPgKrXT+5ESXSVwKPPcElKFNhGg==
X-Google-Smtp-Source: AGHT+IHVkBnxKxoccj1aut9b24Yn4p0IaxJO51yYWmBK2spGAvo8qRlCRuQI1J1h9JWKrfLjtru10Jik4grazyftqOA=
X-Received: by 2002:a05:6102:159e:b0:466:255a:69fe with SMTP id
 g30-20020a056102159e00b00466255a69femr8633577vsv.35.1704016156956; Sun, 31
 Dec 2023 01:49:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231230115806.714618407@linuxfoundation.org>
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 31 Dec 2023 15:19:05 +0530
Message-ID: <CA+G9fYtoMtSRzA8Wx4TCe=noeAamPXE04-gHUR+W1R5gpVy4gA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/112] 6.1.70-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 30 Dec 2023 at 17:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.70 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 01 Jan 2024 11:57:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.70-rc1.gz
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
* kernel: 6.1.68
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: ba6f5fb465114fcd48ddb2c7a7740915b2289d6b
* git describe: v6.1.68
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.6=
8

## Test Regressions (compared to v6.1.67)

## Metric Regressions (compared to v6.1.67)

## Test Fixes (compared to v6.1.67)

## Metric Fixes (compared to v6.1.67)

## Test result summary
total: 135673, pass: 114774, fail: 2742, skip: 18024, xfail: 133

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 150 passed, 1 failed
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
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kunit
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
