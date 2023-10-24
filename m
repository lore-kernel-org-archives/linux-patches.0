Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ECD125CA
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bHp4YE2s"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6ce2988d62eso2656289a34.1
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 01:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698136026; x=1698740826; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r6xFOWkzDc9VNNDhFj5k3kApmxSIikFRxzXsDT+7/Oc=;
        b=bHp4YE2sN7bpPp7GCXrehvIENfzlbg3KBlys1rG0XEqJe8C+qrGZEqgltEf+4kZ4Uj
         0nU5Q430BHY3Ioe2F5EBHF3/9mBjCQVwMpq9GpqI18/NfBASIEdgz2pNVQmy4ey9w8B4
         zSthmopG0OpX+U3Hae0RCqEJ4ND3z1a1o9PVnSmv1MKabFvNbY4+dR0Sio5kzNNL6wGC
         3cPyN1BUgor6h3iMc4ygxXRuppOHgjWTl5GkDulCbjINnsm82qcZtv3/a2xVi9EWTz1U
         LhqMt5p9Rlb+pntWnkVDe/rtx4MHUfa6qp+BORqZUpFNAAvFBJ97aV7LtWFe4z6GQvdu
         9F2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698136026; x=1698740826;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r6xFOWkzDc9VNNDhFj5k3kApmxSIikFRxzXsDT+7/Oc=;
        b=t/CBVuEDQCaCWMr5xDUvh7aPeocWjqTt8APYL6evcapYwaMSnl1hPCWQNojQO5R3ry
         H+0nVI9aaQJYE4XB+7WKpC2COGGdxHE6H36mSAP/Ob2tfQNH+7On7dxNW1EQgSCT7kNo
         yp7kv35BiK/ZQ2pr7ACh3QhrXnRhyhf4+tGfRcC3Vh+lDzHtfHqNWfWgyyf7pog6IOrd
         iMZ7wpVD9cCN2hJRia2H2CfE03odHFkR5UIlt0iU1IYV0uvSJcsqb/Bzag3OGENqs3wz
         3WFR/pakKHuqqOcREYHQ8CN8K9mdw7xzgjZwav76zzKOJVUSW9HiVMdY+EYtqYlcp1Nl
         IAmw==
X-Gm-Message-State: AOJu0YwzDWll29YTWYfA2EH2+z9/CR046oCGEP4imHorB4+bEPz19Y+B
	N8IPwCp2kUhfiNBy9lm5arJHUg==
X-Google-Smtp-Source: AGHT+IG/PZxz2wLDicsKHgvZOahUW87F+0RkArgSq4FocJWiU6Di3+djYJ8FiaqiO9l7L9TCeE8cCg==
X-Received: by 2002:a05:6830:1d6c:b0:6ce:25da:6e9a with SMTP id l12-20020a0568301d6c00b006ce25da6e9amr12570527oti.34.1698136025872;
        Tue, 24 Oct 2023 01:27:05 -0700 (PDT)
Received: from [192.168.17.16] ([138.84.45.126])
        by smtp.gmail.com with ESMTPSA id v25-20020a9d69d9000000b006c65f431799sm1790208oto.23.2023.10.24.01.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 01:27:05 -0700 (PDT)
Message-ID: <ea064789-9dd7-48e4-9415-2c6333229ec7@linaro.org>
Date: Tue, 24 Oct 2023 02:27:03 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.5 000/241] 6.5.9-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org
References: <20231023104833.832874523@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 23/10/23 4:53 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.9 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.5.9-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.5.y
* git commit: b83aad774cc81f19bac02dd06d3d3c907ea44893
* git describe: v6.5.7-432-gb83aad774cc8
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.7-432-gb83aad774cc8

## No test regressions (compared to v6.5.7-191-gbe4ec7370801)

## No metric regressions (compared to v6.5.7-191-gbe4ec7370801)

## No test fixes (compared to v6.5.7-191-gbe4ec7370801)

## No metric fixes (compared to v6.5.7-191-gbe4ec7370801)

## Test result summary
total: 142426, pass: 122802, fail: 2262, skip: 17248, xfail: 114

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 270 total, 270 passed, 0 failed
* arm64: 86 total, 86 passed, 0 failed
* i386: 64 total, 64 passed, 0 failed
* mips: 52 total, 52 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 67 total, 67 passed, 0 failed
* riscv: 43 total, 43 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
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


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
