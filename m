Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F562C80
	for <patches@lists.linux.dev>; Wed,  5 Jul 2023 16:39:49 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-39ed11d6a50so4920530b6e.2
        for <patches@lists.linux.dev>; Wed, 05 Jul 2023 09:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688575189; x=1691167189;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EI9CLsm2oW8kfbs1hBH+e/0ERX071RcI8E72ekQXPDA=;
        b=gmFBtYFhwJ+7phVUY43QG+hVEi6c/vJc/q4QqqB04Fz/eh2KF7q49kSkFQq/ZYWvEb
         XLzUf/gY61oKMM35EUkP1NjDlAuTD55LKptgOxTECNm+9hoLWOB2GpbWvR4AJU7/emwm
         z1NWJQoY53o/DLZf0gQUXvTtAyo/dLEwJcuSA3Tos1SOtXRWm97IpA4pCgtkcYFoYO/g
         lgjn3OtVq8CWqcjX3KbeLNqj96Dl2uMALNZPFkmU3zuWEwjjOLn7DU73gfLH5LNRGqjM
         orS+u388qp9m712ulamDgCJZJyEqLvITp7nM7dPLUy/Ic0SZSphAQQalmZCFUBE0imqf
         ApSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688575189; x=1691167189;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EI9CLsm2oW8kfbs1hBH+e/0ERX071RcI8E72ekQXPDA=;
        b=iCPg1/1W6pSIR83DWWkWRhehAHGVBlo/Q47rVT9/W97iS7w94Oi584QExp0agVMa2f
         WkkF159jd7B5m7SM4jSawLT+Trmf8582UqUjilwW1XIKINXvSLMnwWo7PhxAihmx8sfR
         YQeXWdk4G/AetbOj7FAcRJBdVuwGRO0StpWymw0tyhsRvaM7+VtEr1auSF+BAfJ/aK3u
         sZwdoRgqQHceorkNtPR+cBxAZOg00NMvMRLqOZCQkwG8ok2OSKCql8TXJeXNktMXbICh
         im1Tcgn9DnxUMO+0zJX4h0+vqCIUCbkna+VBG3vhj9wG2Yq/T5+IOsgbzPkoSUJH+SXj
         QilA==
X-Gm-Message-State: AC+VfDwzfK4GrrPwuUX9d/Zb8h95iGZPGMz6FYnH3HNeX3i1gouBdDzV
	jQa/lBDcpSShOcDu/paWrPrk5A==
X-Google-Smtp-Source: ACHHUZ502PDYk+ukxq96sLxd2mbe+JQAKHgFVAKWl7eiRTAGponNHfG3cMQKfip2QB/8PrjRtZ9sHA==
X-Received: by 2002:a05:6808:158a:b0:3a1:dc0d:f32b with SMTP id t10-20020a056808158a00b003a1dc0df32bmr17523946oiw.40.1688575189011;
        Wed, 05 Jul 2023 09:39:49 -0700 (PDT)
Received: from [192.168.17.16] ([149.19.169.25])
        by smtp.gmail.com with ESMTPSA id n7-20020a0568080a0700b003a3d273aef8sm636728oij.6.2023.07.05.09.39.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 09:39:48 -0700 (PDT)
Message-ID: <073df643-2985-0b46-7ffb-381cbabb969e@linaro.org>
Date: Wed, 5 Jul 2023 10:39:45 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
From: =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Subject: Re: [PATCH 6.3 00/14] 6.3.12-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On Tue, 04 Jul 2023 09:48:39 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 6.3.12 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jul 2023 08:46:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.12-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

## Build
* kernel: 6.3.12-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.3.y
* git commit: c5daff36a0ce3df91adefd505cd78605a51ad1ed
* git describe: v6.3.11-15-gc5daff36a0ce
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.3.y/build/v6.3.11-15-gc5daff36a0ce

## Test Regressions (compared to v6.3.11)
No test regressions found.

## Metric Regressions (compared to v6.3.11)
No metric regressions found.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Test Fixes (compared to v6.3.11)
No test fixes found.

## Metric Fixes (compared to v6.3.11)
No metric fixes found.

## Test result summary
total: 170331, pass: 140734, fail: 1887, skip: 27550, xfail: 160

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 144 passed, 1 failed
* arm64: 54 total, 53 passed, 1 failed
* i386: 41 total, 40 passed, 1 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 26 total, 25 passed, 1 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 46 passed, 0 failed

## Test suites summary
* boot
* fwts
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
* kselftest-livepatch
* kselftest-membarrier
* kselftest-mincore
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
* vdso


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
