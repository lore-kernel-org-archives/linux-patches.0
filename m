Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB4B3B2A8
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 19:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bx6GcTDP"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6c7b3adbeb6so3188877a34.0
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 12:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698176371; x=1698781171; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d2dLiGFY0XUH1LVfZBMAVst/xxi3OmnWIKepMGPG7BU=;
        b=bx6GcTDPyB9F/BbBze0vLuaiIQFxBduJGPqI88uXItPyw6pjvHO8HrICqFOsfLdHT3
         DUbNDFor5aP6PDhnargkm7s7XU0zDmgGSJ5yLyMoyuO+xEAXSO8sOnhgZ9Bmd69dgSt0
         XwnTyJSyyHkag++R6ttT/E5908wi7F22dCI5/zi3j98e9NMvSdkuoGny9CnswAkCf1ex
         DX88j82di8wPURlUex4nmzb0VMVB6LYk4wv8xGhvkS4x+4zx2lADfgYU+WkVEN2XuWDo
         8jfZW0RU52kcqpyPar8SEjRBdKDz3kJ3U/5vyplKDyyR5BldFJr0H+Rs7ikGTZi6jJeU
         pdZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698176371; x=1698781171;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d2dLiGFY0XUH1LVfZBMAVst/xxi3OmnWIKepMGPG7BU=;
        b=i2t3AQf7KHlthYJDrrjDP1CCIYP8ApIOHHfiwIXE5lWQAoYkPCmF5ie8mJ4FnNwzdl
         aYYZPFQCTb8nrCqyQP9DmMt2YzG3AYPs8vlJu2NjZrKWxs9L6WyVJibLJR3y+7KK1jOy
         ntS0lbBTw3BVmb9kFIf9oN8KLc9fpw5MFBbWfsENN61MlWmt9IPUCT12qQgNj3GV5tXR
         zgtijFi84YL8u8Deskk5epOpsW2dgI4SRPaaPqHKNejyTtLQZz4eDFKVs4nCCDaQ2IQF
         RCwFJ8xgbqc8Gkni0yOcVy38qsJckzvvhF+yoKGMK/jJxtxsCIu36R6GMXoPj2h6yp0f
         bi7w==
X-Gm-Message-State: AOJu0Yw6vpSZiiCWU043Zq6qT2k97KA9w25ma6tj1cGcah2PpsrmWtVs
	eaYyfzsuigxDF3YTGBOLOn3XOQ==
X-Google-Smtp-Source: AGHT+IGQK+YxZVZ/iX4VUIAiQMKIh7vv3fz+xyPByreMo0J5rOv+HRnKOAca5ElFLuCHG1lTgOD0PA==
X-Received: by 2002:a05:6830:2b1e:b0:6c4:ae52:9599 with SMTP id l30-20020a0568302b1e00b006c4ae529599mr20869754otv.7.1698176371041;
        Tue, 24 Oct 2023 12:39:31 -0700 (PDT)
Received: from [192.168.17.16] ([138.84.45.126])
        by smtp.gmail.com with ESMTPSA id d9-20020a0568301b6900b006ce2c31dd9bsm1993535ote.20.2023.10.24.12.39.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 12:39:30 -0700 (PDT)
Message-ID: <7466fc86-8d32-469f-a94b-8e6a276589c7@linaro.org>
Date: Tue, 24 Oct 2023 13:39:28 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/120] 5.4.259-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org
References: <20231024083306.700855687@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231024083306.700855687@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 24/10/23 2:36 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.259 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Oct 2023 08:32:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.259-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.259-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 18f5a3e6c35c0a03c6667581701af2288329ca82
* git describe: v5.4.258-121-g18f5a3e6c35c
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.258-121-g18f5a3e6c35c

## No test regressions (compared to v5.4.258)

## No metric regressions (compared to v5.4.258)

## No test fixes (compared to v5.4.258)

## No metric fixes (compared to v5.4.258)

## Test result summary
total: 86702, pass: 68626, fail: 2248, skip: 15779, xfail: 49

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 146 total, 146 passed, 0 failed
* arm64: 47 total, 45 passed, 2 failed
* i386: 30 total, 24 passed, 6 failed
* mips: 29 total, 29 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 32 total, 32 passed, 0 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
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


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org

