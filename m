Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A828A28E15
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 13:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Tn9wrS5u"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-49618e09f16so2079370e0c.2
        for <patches@lists.linux.dev>; Wed, 06 Dec 2023 05:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701868534; x=1702473334; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=39DggU9sTHpsnUoWZEmvwMwfR1yAMVP7JXWAH0X6msw=;
        b=Tn9wrS5u2gQU07t1TzhCjU0Vb9/GJez+HyCi0l0advIPq/uoymiU1cNf3vGkHdnGzS
         l+tQmmPM7hVzOm53kcE4j1jkleS1qEJ6DKHyzvfNZtFfUjJGhl2DUOKWZE+nkd2GEqJ0
         kprBvFqUQQOS4tfYQsJdQC4KuCLOwM0dYGAd4cyU0AiTFwXnxl5WsKPbgLuzVuYAi/XI
         4jlcQflJvzPZ4Z8xNOwr4q6aHVgs/B1WbJfJME1am6j9eIwVcdkbAUcn7P987Usdd/ju
         Py8/soOK+mzmMFmqgpJaU9eBbSbosHC8M2nlgPl4y/ZSPHqqXG1qB9kU8kd2PVdt3rAx
         4wFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701868534; x=1702473334;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=39DggU9sTHpsnUoWZEmvwMwfR1yAMVP7JXWAH0X6msw=;
        b=ufqg//RD0+7tri+R6XdiA1XNbQv7DIm1bg3kk6Qih3oeFwObPayOJABca9i6ChIi3C
         qMYNjNiJ0BW1eG+KE9aEfy6er+eacmO+5gRV4M9Y/Ki/xTvaiwg2vHIFkzthCcLPwJeG
         ZnpqBihAYsLD28j7iQdn3H42oIwHfLMcyC6urW2SjbJxTZFPua8yzYl0Z0RGjG432nSU
         i0o/cSozzgQ4OUWdC0PIA1jd/Gl5XXxyTIuDcQxU0+iMRZWn27l7cZPqR7jhdgHRqeX7
         oSMRt41BSSiulsnzYpLLYGTeWCBw+xQthe/Ij6Uhfr5eS9CxkpVN2y9PwaDQ/ffv01hW
         elhg==
X-Gm-Message-State: AOJu0YzCw2EQGJM23QxVByleM9rv/2rAhNIaTM7TakTZJ/I1L2gFGYh9
	IoaSgbkrkqdR8qP9oa6DvH0sRZcpoFYdxzm5ZZOWvQ==
X-Google-Smtp-Source: AGHT+IGx7fu4jijoKMqQ8y3ZfqwsaN43tRyxC36L7eMmwuNg36EnQrysFEpN8/HA5UKrzboEFzI7wVyWWNPTVvryF6w=
X-Received: by 2002:a05:6122:1782:b0:4b2:c554:fbb3 with SMTP id
 o2-20020a056122178200b004b2c554fbb3mr807554vkf.21.1701868534305; Wed, 06 Dec
 2023 05:15:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205183241.636315882@linuxfoundation.org>
In-Reply-To: <20231205183241.636315882@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 6 Dec 2023 18:45:23 +0530
Message-ID: <CA+G9fYsKJfHPS2NgRkg4o0acA82eGreFLRtm2ZuGZbi0A4TeUg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/90] 5.4.263-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 6 Dec 2023 at 00:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.263 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.263-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.263-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 97430ed51c915b4a8037655ac6656a644fd42e9e
* git describe: v5.4.262-91-g97430ed51c91
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.262-91-g97430ed51c91

## Test Regressions (compared to v5.4.262)

## Metric Regressions (compared to v5.4.262)

## Test Fixes (compared to v5.4.262)

## Metric Fixes (compared to v5.4.262)

## Test result summary
total: 90072, pass: 70700, fail: 2384, skip: 16945, xfail: 43

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 148 total, 129 passed, 19 failed
* arm64: 47 total, 45 passed, 2 failed
* i386: 30 total, 24 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 32 total, 32 passed, 0 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
