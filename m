Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AC73D39B
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 19:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BVqJdOKc"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6ce532451c7so1443935a34.2
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 12:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698176422; x=1698781222; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bcWM7D8z9+N/77Wmulmo8mnYRJT4imdJt9aViCXwiOM=;
        b=BVqJdOKcjD14o8aI1+S26weoHSNSEl4y6r3yjAR+8RkVLH+1pxsjL9IwNFNl6WHzn4
         8RaxRkboJwhNDo5xUtMV5o8NV35werUhFIy9HDrOSJCEgz0kyVktaqZdlgA4FoJ6CKeN
         RP756bS0velNEAxCq4x3VSnDJRbcILH91adaSf/O5FUHNDlKG0guMtqrsGK5uXtxToba
         3CCbwziN7rbTTytNLbzJG2ZmpGNqVgvUpfWtCtwcPRG21UAWPFPHTwZffLPuWOEAjrMW
         ej2eE8cOryF2D4Tsca9DPVWUME83UGTJJTF+ZKfYTXeLjAh8wDRAtRI3ZZUOQE5GKhRf
         IyiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698176422; x=1698781222;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bcWM7D8z9+N/77Wmulmo8mnYRJT4imdJt9aViCXwiOM=;
        b=MMxE9vUbZ2QnlwX8R22iSPcPsZJIli8CjasfvPv0EYioFJmpyAYhfkOQ582tz8IU64
         WVa8i1hIYuEx7wbl+2cD9H6VLegMZssrpEYdPfoEGLhB82bbt+WV7rVenV//sPHv4Sk/
         /uxfY3WSjn1+VwmGNJ9vV2nds6pzV30vI/LPVYj5aNoLG2+cDhHUN8NIdLS/11WDgIPm
         xWAd5vTqkONk8S9ackMMyiQN0XUuG80AWTAF/2atgSAgCIbgpTrFvSXrWtQu5wy6ftUE
         kMoFhQ8/TkhjVXaakRrS/K9FzoUcg3r02akuUPzLgjSspOCxQcHjQJa9F13NF1UoZJ90
         2xkw==
X-Gm-Message-State: AOJu0YwC18anuaF4BStsTpLlKZLSGgbZQ80o0zaoRusZMCV+nvIX2EL3
	QIc5LOfF5xHP//o31Z9maKAgsA==
X-Google-Smtp-Source: AGHT+IFIM6P6WEAmTPtH86jyNO9uaaVfNyp5lzemtIXZPEsSe5/5zyFLpzzYkCtHVLdHdIzl4g57fQ==
X-Received: by 2002:a05:6808:311:b0:3af:b6ea:2e2 with SMTP id i17-20020a056808031100b003afb6ea02e2mr9660195oie.59.1698176421872;
        Tue, 24 Oct 2023 12:40:21 -0700 (PDT)
Received: from [192.168.17.16] ([138.84.45.126])
        by smtp.gmail.com with ESMTPSA id d9-20020a0568301b6900b006ce2c31dd9bsm1993535ote.20.2023.10.24.12.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 12:40:21 -0700 (PDT)
Message-ID: <731ccc1e-2491-4b4c-92ed-d32b611fbbf8@linaro.org>
Date: Tue, 24 Oct 2023 13:40:19 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.14 00/65] 4.14.328-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org
References: <20231024083251.452724764@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231024083251.452724764@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 24/10/23 2:36 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.328 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Oct 2023 08:32:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.328-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.328-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 403b3799ab3ff03ad5d7d7b7bbe40dd35e8bfec3
* git describe: v4.14.327-66-g403b3799ab3f
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.327-66-g403b3799ab3f

## No test regressions (compared to v4.14.327)

## No metric regressions (compared to v4.14.327)

## No test fixes (compared to v4.14.327)

## No metric fixes (compared to v4.14.327)

## Test result summary
total: 52637, pass: 44228, fail: 1533, skip: 6837, xfail: 39

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 103 passed, 5 failed
* arm64: 35 total, 31 passed, 4 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 21 total, 21 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 8 total, 7 passed, 1 failed
* s390: 6 total, 5 passed, 1 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 23 passed, 4 failed

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
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
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
* kselftest-zram
* kunit
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
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
* rcutorture


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org

