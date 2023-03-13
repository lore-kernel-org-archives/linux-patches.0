Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B4A184F
	for <patches@lists.linux.dev>; Mon, 13 Mar 2023 06:13:53 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-176261d7f45so12648289fac.11
        for <patches@lists.linux.dev>; Sun, 12 Mar 2023 23:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678688032;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sFwFZRZYKw2DA2WpiOF9s0EPlDORWW1/wSadX5SWkOg=;
        b=EKIllb8+E7Qmsu5WbtRfmy52Ir7ImanQP6EIuBRXtQ1Xz7YguDZZeN2FH8tSdBcgHu
         xTQfw8bYHNayWn9ks+VONjGupukS+KULMygYf1MHH7yDtwJZdObcGO408cOIBqGuQTrq
         3VBhOtn415ebnqjykAs61ibbYOtMA2D2aJVlGbPL7zNMvlFSVTM5rqg1Lz1MVqMdkZ4T
         veCXODjEvDCWhNRrJLcyobco9ikGQadvIvAouC8gP5PRZaN6wp3XUp9trEhyo6zCPhYK
         ln7URbS6kHApxkNhoG7VS5mL9lfq+bIuEKS7sfNYLVLGXdvM5Gv/lUPtg/0/MVNNPmPn
         536A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678688032;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sFwFZRZYKw2DA2WpiOF9s0EPlDORWW1/wSadX5SWkOg=;
        b=mmqlRg99S/od0K5LIDixwN2f3XB0s77mcsP0nivrLa2DRE+OqVjvrrGfiDZQ3jyFN6
         4FpJrfWmBFaTgWkWSu60GksA2WROV1pTKeU7T+9bT0411bC5JlGlOamX9cMp8SkGvxao
         JMY7mHFuGcNpg8wKRCVCcRRRsw9JJYP3u654yaaySQPPZPuNE4k6I4vKoSjj/rEdM5O3
         wHnYgDWFu2HTHQ6EkbYXWxTkiAq/u2QdKTu16+zuwLIZ1YpVf+YBpI5lWyHKZaoAsima
         j+4+s30UlRfx06V/xe3fcA56N+DoAO26JtzDqypBr7MFur0LKiE4DZ4Z04d/6srwhguO
         YISA==
X-Gm-Message-State: AO0yUKXkcLvkfI+e3f/e8vYKsRFJQrUIVdEf8EIQkK70IAQ+ggktjAvs
	Jza08FfzcBCJAoNh4Hji7a8hJQ==
X-Google-Smtp-Source: AK7set9YRC56/G09PuwqH204/SkCS1mEmaSo3TAXT/AuwwL9QBrPNx/HiSxphwu3Ij66/FCiVtt0OQ==
X-Received: by 2002:a05:6870:f150:b0:176:2585:e6ac with SMTP id l16-20020a056870f15000b001762585e6acmr19830680oac.23.1678688032018;
        Sun, 12 Mar 2023 23:13:52 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.75.19])
        by smtp.gmail.com with ESMTPSA id et3-20020a056808280300b00383e0bec93bsm2768695oib.49.2023.03.12.23.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Mar 2023 23:13:51 -0700 (PDT)
Message-ID: <a552adfc-9c16-5c97-c566-806041cfa7a6@linaro.org>
Date: Mon, 13 Mar 2023 00:13:50 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10 000/528] 5.10.173-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230311091908.975813595@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20230311091908.975813595@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 11/03/23 03:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.173 release.
> There are 528 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Mar 2023 09:17:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.173-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

## Build
* kernel: 5.10.173-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 79ef18039d4902c95b2a84af18b5612d9e9f222a
* git describe: v5.10.172-529-g79ef18039d49
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.172-529-g79ef18039d49

## Test Regressions (compared to v5.10.172)
No test regressions found.

## Metric Regressions (compared to v5.10.172)
No metric regressions found.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Test Fixes (compared to v5.10.172)
No test fixes found.

## Metric Fixes (compared to v5.10.172)
No metric fixes found.

## Test result summary
total: 138158, pass: 113527, fail: 3907, skip: 20437, xfail: 287

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 114 passed, 1 failed
* arm64: 42 total, 39 passed, 3 failed
* i386: 33 total, 31 passed, 2 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 26 total, 20 passed, 6 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 36 total, 34 passed, 2 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
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
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
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
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
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
