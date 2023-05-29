Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348708C1E
	for <patches@lists.linux.dev>; Mon, 29 May 2023 17:06:40 +0000 (UTC)
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-456e4f4ea83so997930e0c.3
        for <patches@lists.linux.dev>; Mon, 29 May 2023 10:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685379999; x=1687971999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txuuPp7T+tYOE6ycy+zbHEBbalw1NZT3uAM4suikcJ4=;
        b=yJNx9V9BdJvxXsJQYeQ/0/qNpBXxbAS6AM4gz0nEPRkT9CxEVjcnbMUTj1A3Sz9rIN
         voskS0NNFqJjNHHh3CvM3AURpOvKo0rxXMjwIJY08KS8d6DthuyFmHVTiBJkBf6UMLlM
         wP/jo1nZtYFDmqTleeAENi//qHO8bUVr6FGj/IGhJ9BIYgP0E2+IdGm8bbjPOFVy+7Q+
         1Xz8L/9U9pCTlqKpthnxYJ3k677j/KY/XXzQf5Fp0KRWp1sAsW8z4uuJrQ7Q2ymXe28S
         iNs/vjlaS2lOzarD5gJR6Z2J+91w4eFFRp6KvPcm29Cifs6+rqq5zd65wHQX0rqzm5Vp
         iX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685379999; x=1687971999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=txuuPp7T+tYOE6ycy+zbHEBbalw1NZT3uAM4suikcJ4=;
        b=JXhR+WmZYJ07K0ODot52A8uN2GeSKNv1u+peKjoBmkgu2tCfoJ+SR1OulUafRQns2d
         Ga8DGXq6UJsoazIdxBlnkjBvHjqO6bryishj/ERykv6YPvzu/rAe9G6MOf89Vh5JSc1c
         Lezn3j5Lb7MJ83vLReCPv2Ym6QUqYHzlQDMV5CxjNzVFR93uhpQ4SVmVIszg1S5hhvNb
         EP1H6mFPffbEY8afcyxcL4Lvjezs0z+sXrScYWfU98kkqkcRqDjoK80y5gWcCZo9YZ2o
         kX7NdnCmA5e7sobDb1WVyVvYh62/KM+yhxtGEKr4ScNANjdQWbz+iIGX4/1ZtMEgYfuV
         ZAIQ==
X-Gm-Message-State: AC+VfDzbmFLQTJDOW2v/QlGSmYULS8NLB4lolBdY1kaVcq3+SiveP2Qy
	zhNLAbQ5IpbUtrpjooJRqK1HB3ZXwBL7uIk4fdZBew==
X-Google-Smtp-Source: ACHHUZ5EcZy72/IxFWnOsJ+VWRh3z6qnVB4jOBl2N+iguJRpGMaEidoOehJwhFq4W8mfvJvcriN7LPE43vNpX/9TE6g=
X-Received: by 2002:a67:fd7b:0:b0:437:d6b8:8baf with SMTP id
 h27-20020a67fd7b000000b00437d6b88bafmr3140852vsa.15.1685379998767; Mon, 29
 May 2023 10:06:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230528190837.051205996@linuxfoundation.org>
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 29 May 2023 22:36:27 +0530
Message-ID: <CA+G9fYs+AR1jd7v0UtZKdz2hadf2m20ZXyDseNWXpxqnDuHY=Q@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/161] 5.4.244-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 29 May 2023 at 00:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.244 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.244-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.244-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 99ecfa2a4afcb3256e9102eb5cc0525d97aec466
* git describe: v5.4.243-162-g99ecfa2a4afc
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
43-162-g99ecfa2a4afc

## Test Regressions (compared to v5.4.243)

## Metric Regressions (compared to v5.4.243)

## Test Fixes (compared to v5.4.243)

## Metric Fixes (compared to v5.4.243)

## Test result summary
total: 134703, pass: 113495, fail: 3730, skip: 17279, xfail: 199

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 144 passed, 1 failed
* arm64: 45 total, 39 passed, 6 failed
* i386: 28 total, 20 passed, 8 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
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

--
Linaro LKFT
https://lkft.linaro.org
