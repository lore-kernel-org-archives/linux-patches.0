Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6FD219EF
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UBOkiQvA"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-581ed744114so1610252eaf.0
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 01:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698136591; x=1698741391; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vFK5k+WyCRpKrbHhGAax9JXCvlUkc9VlqKKWcgFoIFk=;
        b=UBOkiQvApuYeR7vj7zFbfGlUi9uhRADAFaUy2zOkPOD0+kohkwgTGJmdgaY8D4UhVU
         ed46SX0bGzQfESaZiE6pmv0rHDkTr/7bHuQ4Y/wDwhyb0bDjUucpc2V967OauWGTOeNP
         hFjLu7rDpGVPpnJhEq/J3l/ZYbUascjpEYnhDKKJijzIUsMqJeeM6ATEhWTBNLlSHoN9
         aua7x/ZDq52Fw8OAm7LOSmnBUed+s1NxKpAUFG/7PWCjBZy9+gDY8p2nEAy0sx2du343
         WnYEvOrTaaT0Qzy1qOGNTF18Y0dbfftsrgL131CIGb5M3DuzGB+KlibvDTy6rMRd1D59
         JXVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698136591; x=1698741391;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vFK5k+WyCRpKrbHhGAax9JXCvlUkc9VlqKKWcgFoIFk=;
        b=c0My/Tp++aMdpkUrScsmSQ87UV1/G89OfllwhGxFbm0dXaGl6F89Dp9wiHnjznHs5h
         Pl/3uTR1CRzgCx5nqrzsLWb3ga7Y4ozn2DCfiEKPqG7AVSEyZkqxOUvv6uQ18dXorYte
         rzxblDRHtn8aoBlOO6MHc1Rna6/tJVxJnKLPUkSNOVeFxEYQ1gPs2n/B3HUrote/hDu9
         L9oJCiXpawQ2Kos2QXipMn8nt8Ignhs7EMlU6GBvdKV1HiDhlURpc0fWbe3ZnkDQlUPL
         XioardLInxGa7f61wtFk6df/6r1tgjXxui6MvB0dzWMOoBCC2Ct5kyigVPIgLqTxbEqV
         c0FA==
X-Gm-Message-State: AOJu0YwlgHokheX4q5UUACZ2NBV/6NG9GIl+YiEGg62xiB+pHPGs4T8k
	TmJ8BCBkN5E81Y1GI4zWdfekjA==
X-Google-Smtp-Source: AGHT+IGSMJ0piiAiwfyvmnGbpCfN1/lJbhUActtZOTV0+s3MxR9fImA4LNHpZ4m5Zvp0GxJrO/sNQA==
X-Received: by 2002:a4a:ca0b:0:b0:581:f2d8:3f9f with SMTP id w11-20020a4aca0b000000b00581f2d83f9fmr10227466ooq.7.1698136590993;
        Tue, 24 Oct 2023 01:36:30 -0700 (PDT)
Received: from [192.168.17.16] ([138.84.45.126])
        by smtp.gmail.com with ESMTPSA id v18-20020a4aa512000000b00581f11e81c7sm1829225ook.7.2023.10.24.01.36.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 01:36:30 -0700 (PDT)
Message-ID: <ad8d0dd9-d9dc-43f6-a112-8177bfb55b90@linaro.org>
Date: Tue, 24 Oct 2023 02:36:28 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.14 00/66] 4.14.328-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org
References: <20231023104810.781270702@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231023104810.781270702@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 23/10/23 4:55 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.328 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.328-rc1.gz
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
* kernel: 4.14.328-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 3ca3af8901320d3cbd71731933ed8a51bdbe55eb
* git describe: v4.14.327-67-g3ca3af890132
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.327-67-g3ca3af890132

## No test regressions (compared to v4.14.327)

## No metric regressions (compared to v4.14.327)

## No test fixes (compared to v4.14.327)

## No metric fixes (compared to v4.14.327)

## Test result summary
total: 55044, pass: 46798, fail: 1550, skip: 6658, xfail: 38

## Build Summary
* arc: 20 total, 20 passed, 0 failed
* arm: 210 total, 200 passed, 10 failed
* arm64: 62 total, 54 passed, 8 failed
* i386: 36 total, 30 passed, 6 failed
* mips: 42 total, 42 passed, 0 failed
* parisc: 6 total, 0 passed, 6 failed
* powerpc: 16 total, 14 passed, 2 failed
* s390: 11 total, 9 passed, 2 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 47 total, 39 passed, 8 failed

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

