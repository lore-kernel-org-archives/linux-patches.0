Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1368B79EC
	for <patches@lists.linux.dev>; Wed,  5 Jul 2023 16:41:31 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3a0642e4695so3702201b6e.2
        for <patches@lists.linux.dev>; Wed, 05 Jul 2023 09:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688575291; x=1691167291;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZItWwLEsX01dfWTwqqKlDnCkQDqzMNjfuZC64H7G12Y=;
        b=uU9A1U36lqNqVHHTIfrDfQ6g4gIxWcMxDXJL2SfUQP0SHzJy1VKBP6gMJyyC9hbdxp
         CvXn/+uvHqGhgqsFSS5q/6ipgGxGcmQj2HF2oaY+V71i3sZ/0zgEaFMt1ZkkiEr8V7Xh
         n7KMYe3oz9TVn5nZ6QxEvrzsKNUA0JfJoTYjK/zzgjnIvfxvGyGyvTdQISzIRHtp7RkF
         oI12w8f++6FMAcc201HW7vX3hEAW0ZaAIS6o1N7A1/uN4U1/IilVF4yK/pcby2a17pmn
         vTVBchAU2+y07nQ2fegl9kk/3mttN7zpplL352YpUhSVO0Mfl/CUMoXEh/lcfzhx5Qh0
         MVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688575291; x=1691167291;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZItWwLEsX01dfWTwqqKlDnCkQDqzMNjfuZC64H7G12Y=;
        b=VZiOGPrNFbm0yODUDjCoxuW0GaPaZpDgfr3jgcPaA0yiocxSDpKMk2fRNHHLgS7bvj
         nU26bx5ItghLI+MjfbuVIZLj80eFKnmFQ9CL2dvcIi6J8DX1xwuMqnwQWJnYUdzcA8Ou
         Zy3cOwJBiJRYAly6QSh/XFHvQCghgNanahlxq+EXl9tw4v8p7kYVoo/vRN0DV74r/NW2
         OozLqZCIoKdKGPPVJhPi5F+jGXbTvL6zQPXhRaR3k1QAirOEY/sWwcDLEez1F3V+JJRb
         H4LUwqkrSwF81NDfaaBJ/p0e9nDonZTOjiHGzAwMLINZu1kX8ParnqwbkpxBeD9AM9BJ
         CyqA==
X-Gm-Message-State: AC+VfDzAn0D9q4n+J1dRzbCWxkz3hD3jm8FODE4xuS884SJMrHjc4jYJ
	T7C/eRZsiRoTeKR1HAPpduZROA==
X-Google-Smtp-Source: ACHHUZ71xAk9m8ywiInTW6lzaBlBXIDNyFBGKnqraIY4h7JMPzBBtlq8M8vGhu+z8UFMPU0p8L5D1g==
X-Received: by 2002:a05:6808:2104:b0:3a3:33e9:9a34 with SMTP id r4-20020a056808210400b003a333e99a34mr14319555oiw.55.1688575291106;
        Wed, 05 Jul 2023 09:41:31 -0700 (PDT)
Received: from [192.168.17.16] ([149.19.169.25])
        by smtp.gmail.com with ESMTPSA id t12-20020a0568080b2c00b00396050dca14sm8998756oij.28.2023.07.05.09.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 09:41:30 -0700 (PDT)
Message-ID: <73d24185-35ba-d1ba-ee60-1562bcc99627@linaro.org>
Date: Wed, 5 Jul 2023 10:41:28 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
From: =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Subject: Re: [PATCH 5.15 00/17] 5.15.120-rc2 review
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

On Tue, 04 Jul 2023 09:48:47 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.120 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jul 2023 08:46:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.120-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

## Build
* kernel: 5.15.120-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 492521f41846c04df93ee45e8b780dc9478d90df
* git describe: v5.15.119-18-g492521f41846
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.119-18-g492521f41846

## Test Regressions (compared to v5.15.119)
No test regressions found.

## Metric Regressions (compared to v5.15.119)
No metric regressions found.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Test Fixes (compared to v5.15.119)
No test fixes found.

## Metric Fixes (compared to v5.15.119)
No metric fixes found.

## Test result summary
total: 113091, pass: 88007, fail: 2292, skip: 22703, xfail: 89

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 116 passed, 1 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 35 total, 32 passed, 3 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 36 passed, 2 failed

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

