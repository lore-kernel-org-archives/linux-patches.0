Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBAA22EF7
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ko6NoPcN"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3b2f28caab9so2700131b6e.1
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 01:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698136280; x=1698741080; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OK8Gn6Rp36Zb2Io1jphw894wwfjV0cDFBU0eNPjRUcQ=;
        b=ko6NoPcNAgcOmm+q+3+Rta/L8oi3jzag3vgBTC/oIS7/r3q4PMb4f+Hac9RLhn5HcZ
         EYGREtL1aSXvtD7jfi0DSVd9suD3lCtnKZ1U1V6qZ3QTjiKsXETWIBqMnCSJ2rPzdzYk
         7pGd6XXE6fuA2e1bKWaiymi56QpBsd0DTr/DMuDXRwjhnu91FycJtX0lwXy4FWSm4JE/
         RCqPdqnGBJdgxKM5XCEVtgMG5+T3JEiNCe7SoS9cGMUfRbrXASXv/2jBJXNd1aXVhXul
         k98CIQKdmyEF3hyWoOtVl9YQ8srVsYdVN8hhrs6uzIXhZkIjaQKTmLo4pd3nLqOerkIY
         Wv+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698136280; x=1698741080;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OK8Gn6Rp36Zb2Io1jphw894wwfjV0cDFBU0eNPjRUcQ=;
        b=fM+QXyAV2V/DtRwKiUWZL3WgUHFsdv4yU5DaY6A+64X2iT/p2Vy7LqJkJXqjHzEcea
         i5zoklGdyic1sRprVbn5H2eRyb12ImBIDzb6CrgJZhkqJ3Y7t3IzdwnkXh8as9DWNtty
         XNLJG0hBLy7mDL0Koo1Z8JT02jVzvjsHoihMdDliEI56O+Z8UaIZ52CYhGtuscqqHcqR
         /Ncq/dEC63lvy6e6lA7LFSruAaNZDycKM7zbN/D0UQdIe5nHAnw4qr3bZ/o4cRHne2GY
         jj4bFvE83k6YdduwcggcDsQrCukSF0axxXUVL79SxbhrMafFMCKz8hFau68HeYXiE7ma
         HK0g==
X-Gm-Message-State: AOJu0YyEuO5QP//4hKa45TeIrvpi0iWMW/siilTuAf9+qQCLV6GTLdMB
	IukLiOo3qLL5qxBVRB4SNw039w==
X-Google-Smtp-Source: AGHT+IHAqrO3OmwwdLLODEm9PEja6ioShdlwwyEHXSmYi8fLAhn6FJiFRa+kTonvEtCIaJ2T2qnW4A==
X-Received: by 2002:a05:6808:20a1:b0:3ae:251b:5552 with SMTP id s33-20020a05680820a100b003ae251b5552mr14782121oiw.12.1698136279952;
        Tue, 24 Oct 2023 01:31:19 -0700 (PDT)
Received: from [192.168.17.16] ([138.84.45.126])
        by smtp.gmail.com with ESMTPSA id w13-20020a0568080d4d00b003ae165739bbsm1860215oik.7.2023.10.24.01.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 01:31:19 -0700 (PDT)
Message-ID: <2d0fe6f7-9994-4beb-8791-a8e2c2ab286c@linaro.org>
Date: Tue, 24 Oct 2023 02:31:16 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/196] 6.1.60-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org
References: <20231023104828.488041585@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 23/10/23 4:54 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.60 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.60-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.60-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: fa9447b759f65cb3a25b4092562576311f245dff
* git describe: v6.1.58-328-gfa9447b759f6
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.58-328-gfa9447b759f6

## No test regressions (compared to v6.1.58-132-g9b707223d2e9)

## No metric regressions (compared to v6.1.58-132-g9b707223d2e9)

## No test fixes (compared to v6.1.58-132-g9b707223d2e9)

## No metric fixes (compared to v6.1.58-132-g9b707223d2e9)

## Test result summary
total: 130174, pass: 111193, fail: 2397, skip: 16455, xfail: 129

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 279 total, 279 passed, 0 failed
* arm64: 83 total, 83 passed, 0 failed
* i386: 64 total, 64 passed, 0 failed
* mips: 52 total, 52 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 68 total, 68 passed, 0 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 23 total, 23 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 11 total, 11 passed, 0 failed
* x86_64: 73 total, 73 passed, 0 failed

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


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
