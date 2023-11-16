Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A98B46536
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 18:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iCq43iKZ"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4ac71c558baso378100e0c.2
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 10:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700158849; x=1700763649; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UEl2OjV0pgRuHXnpuYWusoP5rNXpr413oL62t3BAqVU=;
        b=iCq43iKZF9/efT+fKIiIvnToApMNJi0nu7F2BeaZdGvo4EKx3wr1Mhm/6N2cKFz6BE
         8ZoQKzmKxGlhdvSKtjm4i/qiFRomNLouBTRnOFhYlXDI8TrGcPHVFT7U2+hbl7ZKF6cA
         lIA0nZFkBP2cjZsWwOGVPEciFcPENEBLtbNaHeCCtcGMwNizKoSGfnouA/47xQuXsRWP
         3VNJlIGCt3/6QHbjTcKqYQzp1c5i5IPVrH6RSFAppNIknAt1P1rnXa5CPBCUmd5nYYQE
         NjlBYVMqKdlDGmfxw9tMnzTXfZEnACowyVN+VaoBD5K6vbYoHgf5bn+fyaKrufyuKcoS
         qk7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700158849; x=1700763649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UEl2OjV0pgRuHXnpuYWusoP5rNXpr413oL62t3BAqVU=;
        b=ElP0znPS8/S7Fu89QIW6wrQH6xF0NWOUZ76OX0FVlNI4iHqkkPKfiOF3nrHUTNHNW8
         qYnhhU+yNjT0KJuax8inrZ8tNdr+75s/5iaW/m4fKwfzYedWj9N1nCH3EzeVdIN7QjAD
         wmD9auBdp8Thx+RGGkRS6Q9T9iEm+8R8n1J//WNFVj0qSRQvaRH8yZcJJVf0qhNMzEqu
         LtgjZ5NPZjthIorWF/jfyCEPuAFKOCaaX+AT5QHm1zBpTMfsdfRvs+4D46GVcvauqRbi
         DATPlvnvfJB1zILbsonTzqKPYoySoOj0by7CObmvs5yj33heWUoYeB4vRe4g3oDNX38V
         8Bpg==
X-Gm-Message-State: AOJu0Yx7Rx9gJELA9YhKPSPvd5fJ97ZpaYXCTf+qd5tywl6WxlTnjFrO
	i8PCWC3zYKeF93MyL/RM6YF902ZfYt065Z7JCy8lFg==
X-Google-Smtp-Source: AGHT+IGEyPY4IzC4f9/B04WjLL7alQQKnVu1MAPjV5f34N5SVhWjjVLKojtF/F1oGuZK6MIEY/VPS+UOk/LuJjn93tk=
X-Received: by 2002:a05:6122:c8b:b0:49a:1dcf:21a8 with SMTP id
 ba11-20020a0561220c8b00b0049a1dcf21a8mr12009240vkb.16.1700158849053; Thu, 16
 Nov 2023 10:20:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231115203548.387164783@linuxfoundation.org>
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 Nov 2023 23:50:35 +0530
Message-ID: <CA+G9fYsFM-+M9D-_9fvmFKNj6Nwr+WUPhtvHOzFu+NZEKEDRRQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/244] 5.15.139-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Nov 2023 at 02:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.139 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Nov 2023 20:34:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.139-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.139-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 0d55b31d7e1db6eee3c65c0e64d373dd4269578c
* git describe: v5.15.138-245-g0d55b31d7e1d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.138-245-g0d55b31d7e1d

## Test Regressions (compared to v5.15.138)

## Metric Regressions (compared to v5.15.138)

## Test Fixes (compared to v5.15.138)

## Metric Fixes (compared to v5.15.138)

## Test result summary
total: 85933, pass: 68466, fail: 2348, skip: 15070, xfail: 49

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 115 passed, 0 failed
* arm64: 43 total, 43 passed, 0 failed
* i386: 34 total, 33 passed, 1 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 26 total, 26 passed, 0 failed
* riscv: 10 total, 10 passed, 0 failed
* s390: 11 total, 11 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
