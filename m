Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B8E35892
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 18:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fIA2ohqR"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-45e777af839so392161137.3
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 10:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700158727; x=1700763527; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2YAci+1wqiwB/kontdKmzRRGgE3fU/1zqtfW4K+RiiE=;
        b=fIA2ohqRTiL3J6XB3S6LPf5eADALJqa8Ernl9PxEQWj8jXaPxbVOTuUSjq2KBH9i17
         z/GMGVMy7ga/8W+flA7dYootQvNIiwIhSXz7EAoZefKqX5STSXL5j/LOBMazIOPOpXiT
         0aduBwBjtsHZlG8B7EocJf2bcFc0PtljIRzHEv2ipd7cKiCooX35LN/f8WatHj5klJNd
         jDk3d1dQfeWZPz8f48whY07EMbianl+ItA5PHHwCh8F1t2KJ4HMffz7mgke2bUHa1OgQ
         nnYCYiAyW4pCHt0tAAoQ99ABE58aiogL/tcRO74P1HILm1JcPvadP3MgRCc64lpbvaiR
         cB8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700158727; x=1700763527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2YAci+1wqiwB/kontdKmzRRGgE3fU/1zqtfW4K+RiiE=;
        b=GMJQddHPLdgREjRJMDS2MHLzvxLXLywgEvBHvRdf0XQiZvM43DuWvuVvK6pAxi4KXg
         x5/SEs1GAyafrQ8VKaTEXEWlSoRuv33JXT7n2uUcHvMQjqHWijpAgW3zVeNEoZ6+/M6i
         oQ1rwjG/guf6dKbs4VZkR8rbjlGlIXF2MVIQPBd8SiRpchXYcnaTOQmseSuySNqDq7dr
         CIxHHlRFY1jrQVRapJf6KQHiTFqiqJ+RGyB39azsZtv+vbFas0yFyMeEP7CefGmpmQ3f
         WzUXQ3ksN20SSmFy9fBONVSEGqNsUwITRlbRtv0RUN5Q2YMrs9vJOcv4EAe8Bz9pgpkY
         UqrQ==
X-Gm-Message-State: AOJu0Yy+dPN/MlIbAGD0dkuJoaxZzH7OO5UiAggeww4kfAaiZu9bK6v2
	7gMrQmPduUubQURKxkr4x0tJe/4WGE58NXLxMVSWjA==
X-Google-Smtp-Source: AGHT+IGQEZ5wLUtlYPdF70kdQrc120i9IsEXXMv5n2+gnrkPnGz0H2wC/EneYGbqiS19pHHY6y5+0MTWWdIm4KZoiY8=
X-Received: by 2002:a05:6102:4687:b0:44e:8626:71f2 with SMTP id
 dw7-20020a056102468700b0044e862671f2mr11397434vsb.13.1700158727243; Thu, 16
 Nov 2023 10:18:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231115204644.490636297@linuxfoundation.org>
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 Nov 2023 23:48:34 +0530
Message-ID: <CA+G9fYsuoZdsy_biRqB0a+3pwTLK7z_xL3sYrJMsckivmxKimA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/191] 5.10.201-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Nov 2023 at 02:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.201 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Nov 2023 20:46:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.201-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.201-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 550b7e1fee20e8840f9c1028c89dd3fc9c959fff
* git describe: v5.10.200-192-g550b7e1fee20
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.200-192-g550b7e1fee20

## Test Regressions (compared to v5.10.200)

## Metric Regressions (compared to v5.10.200)

## Test Fixes (compared to v5.10.200)

## Metric Fixes (compared to v5.10.200)

## Test result summary
total: 82357, pass: 64836, fail: 2567, skip: 14910, xfail: 44

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 113 total, 110 passed, 3 failed
* arm64: 43 total, 40 passed, 3 failed
* i386: 34 total, 33 passed, 1 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 25 total, 25 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
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
* kselftest-sigaltstack
* kselftest-size
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
