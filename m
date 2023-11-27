Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EA731739
	for <patches@lists.linux.dev>; Mon, 27 Nov 2023 14:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HrD8O0NG"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6cd0963c61cso2345272a34.0
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 06:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701095621; x=1701700421; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9Mkf9QcG9pXv0Qdie0/NQ3M3Nqa2uonDOOeKyBty/vA=;
        b=HrD8O0NGj8DSdPCqHEuz2SdylVtaQCnbiKKb6U2dSj50xewx7u2X4lvvv5TcC1Z9f1
         Vi8sg/ldkN7dO4VTAapanV/2i/l+A7aTh4uCiNr23IL0pQV+HkqvBeTb6AhSj1gvrS/y
         tZ1I5aC91+Rz4CrK0OfCLbV+1mF35TuxTkDrXn6DRIJ9J38MVw1do7JwqK8MF7maIJ+t
         B65uSfzLLVNe2DUVcGuX6g6hsjqGnI9duVtOyLz65mh8rJCWdZAl26QLxOkLnRd87s8A
         8HVbec+HMoZ9yCeNHfdfGJHYU9ZdkD3YGhrpv47IkOFrP9NtsgEXUNQ44wpvhmHHM+wF
         FfWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701095621; x=1701700421;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Mkf9QcG9pXv0Qdie0/NQ3M3Nqa2uonDOOeKyBty/vA=;
        b=KonlrBdhBs2A5rfZkPRI970OQMwfjZx2jUk4mDv2LDysoSrYN1q5Sc8u2G1D74z+jn
         3YBnvFOZtoC/sVjHUjpoSa1HYGMW4zOPCGXflLnESE8K6vYuW6wpx1BpdGR/yBb6U5tM
         q10iXzdSzEKC2MhJ3/nrzATwPC3EAudW2h5xgHxqgVCICPTLu1dxZ2/KIRFcongYLNv0
         rHWGUUXSVke06S0bxqIkJCgjKDX7Yea3YKFMorWDGi1PK+g1jwR32t0KmsMjzYt/uY1G
         yOw7IVcm5pb2hxdIxCZzbEDjst3Lc06iN6kLNHJsH+MBJFYCUF84pJVfdBl0Q7SJugGF
         3E3A==
X-Gm-Message-State: AOJu0Yyk8qtYVwYlB0PLNLFoGlaue44pqlaX2CM75Ruqpx3J2vMsTFzM
	StB8y5BfAquiiSmDjz63VtXKysefvxYsrAD3d7esIg==
X-Google-Smtp-Source: AGHT+IFL0Daxg/eseyWSM5ZIm84vrvKN7f+QFiyVVolXNZQwTeRn7X5tk1ApVycvVSZVAYVR2565sXctWyEw7Dbd7Mc=
X-Received: by 2002:a05:6358:2249:b0:16b:f69d:c8e7 with SMTP id
 i9-20020a056358224900b0016bf69dc8e7mr6752393rwc.0.1701095620791; Mon, 27 Nov
 2023 06:33:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231125163059.878143365@linuxfoundation.org>
In-Reply-To: <20231125163059.878143365@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 27 Nov 2023 20:03:29 +0530
Message-ID: <CA+G9fYt5W8CX_2B-6piLu5YytSx+ZoSKcOOo-ppO+u9jGzeWmQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/53] 4.14.331-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Sat, 25 Nov 2023 at 22:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.331 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 27 Nov 2023 16:30:48 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.331-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.331-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 39ca2c4cec46e5ef545815f62be91cba998b8927
* git describe: v4.14.330-54-g39ca2c4cec46
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.330-54-g39ca2c4cec46

## Test Regressions (compared to v4.14.330)

## Metric Regressions (compared to v4.14.330)

## Test Fixes (compared to v4.14.330)

## Metric Fixes (compared to v4.14.330)

## Test result summary
total: 54577, pass: 45662, fail: 1547, skip: 7326, xfail: 42

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 103 passed, 5 failed
* arm64: 35 total, 31 passed, 4 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 19 total, 19 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 8 total, 7 passed, 1 failed
* s390: 6 total, 5 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
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

--
Linaro LKFT
https://lkft.linaro.org
