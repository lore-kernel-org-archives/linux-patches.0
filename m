Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEA93D8C
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 05:32:41 +0000 (UTC)
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-56d6dfa1f3cso2765434eaf.0
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 22:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692077561; x=1692682361;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SE/SjVC9Or6j28NQ+eceq6tJuZj7b9Khh+AYXK4kKVk=;
        b=UckFZEtgmE1HA+A4bxlt0PSPnPiUbfrMYn+vctLNsv4dljJZIP/7SZCZpq4vCyi4Zl
         WPWKNiKA6fUxlfhqh6YtFbRJp/9QhrNoW/V26TuxkjpeIwy/0p5zDveEqsqufz2nLAP+
         OFFor166xl6sQIof7UjgNnR0sSVt0jP4pJBH9FldzMkdcl2/iN4977AZd1g5xkgWVuZ9
         WnTQpRyHdQgNbz6JSID9IGgXsgeJyDemZZJ2RDNvVI9SHNdRrqeoCykEzbqIPGP+M5Zm
         kOJUf3WDykAAn5whJxBp7J+6E0x/N7nM0xKgBQdlaEG2VNQji4rsVMbnChwxVaVtNR8p
         4zVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692077561; x=1692682361;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SE/SjVC9Or6j28NQ+eceq6tJuZj7b9Khh+AYXK4kKVk=;
        b=FHgeSEesWaAe10JOFiwfSxzagBW8JjdON5V3nsubnObkFt7Z8uppDTNxN96uNYSpcA
         ajdkspVLUMTbO8y9k7kKO48jf9NF4Te0yr/+gv3kzsD9rQGvhRG2UOfrJhIVeLcvMTJS
         qeitmMF3XLofugUQxhYCcfPH9Uiv2pYsT5Exy1rSdjrK5r2PQlimKAtUeYp9OqqbnKPy
         zZPm702SQnXUz+4ADKWP7ithoFCS8YPSpAYovpMj7qI3nzvI8m8GM7lnxNAoz00JkZbN
         WKXYj/jyi+8tOjf+m6yKsML+CsgMdOsciQGskJZuhrWDE5TodATx2aQaOm4bHVrLsC9a
         Z/pA==
X-Gm-Message-State: AOJu0YyvZ1DZczaXQs+8hh6G/6d6VuK320oDitEnkOlh9aoJhe09yiE6
	5et92/Uio58JX/gO4DPN9qk9ZA==
X-Google-Smtp-Source: AGHT+IEIQsZm3+jbcPbR36nZqdFr2bCYzDCrzySFnoWLeCoWyMoAZV0tLq0r7AZ5t11XJ2F37DUw3Q==
X-Received: by 2002:a05:6870:7387:b0:1b4:7411:5c0c with SMTP id z7-20020a056870738700b001b474115c0cmr10380632oam.13.1692077561068;
        Mon, 14 Aug 2023 22:32:41 -0700 (PDT)
Received: from [192.168.17.16] ([149.19.169.25])
        by smtp.gmail.com with ESMTPSA id dy29-20020a056870c79d00b001c52b2bdb51sm207784oab.37.2023.08.14.22.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 22:32:40 -0700 (PDT)
Message-ID: <04946479-9fce-d803-5734-ed8ce4bf2672@linaro.org>
Date: Mon, 14 Aug 2023 23:32:37 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH 5.10 00/68] 5.10.191-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230813211708.149630011@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 13/08/23 15:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.191 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.191-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

This branch exhibits the same problem with regards to x86 and Clang as reported on 6.4 [1], 6.1 [2] and 5.15 [3].

Other than that, rest looks good:

## Build
* kernel: 5.10.191-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 5b1776cc14bf85186ed45a8d68d33206f73c727e
* git describe: v5.10.190-69-g5b1776cc14bf
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.190-69-g5b1776cc14bf

## Test regressions (compared to v5.10.190)
* x86, log-parser-boot
   - check-kernel-warning
   
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## No metric regressions (compared to v5.10.190)

## No test fixes (compared to v5.10.190)

## No metric fixes (compared to v5.10.190)

## Test result summary
total: 124569, pass: 99567, fail: 3522, skip: 21366, xfail: 114

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 116 passed, 1 failed
* arm64: 45 total, 45 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 26 total, 25 passed, 1 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

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
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
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

[1] https://lore.kernel.org/stable/b2145971-5417-e1b1-40b4-f971e247e1ea@linaro.org/
[2] https://lore.kernel.org/stable/239281dd-3cb8-23de-9ea1-27e9c224cfbd@linaro.org/
[3] https://lore.kernel.org/stable/5a3f5686-b303-8c30-a637-787be94f6623@linaro.org/

-- 
Linaro LKFT
https://lkft.linaro.org

