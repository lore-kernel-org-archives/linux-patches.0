Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8C03D7C
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 07:17:20 +0000 (UTC)
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-791c27bb91dso511013241.0
        for <patches@lists.linux.dev>; Wed, 28 Jun 2023 00:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687936639; x=1690528639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eFn/Do9jN3RPupZVUJruVQkAXpC2rvNpM+OVzSO4M6Y=;
        b=EmVb2jYocbol7lc9U2yvCz3rNWIJ7Y2nr9o7JlyPRdeGsUe7k1mW7+9qSXLVTnp0or
         jz9Hjlfsk2TlslvuvbitC6XR4JslIX8ToZ/GM7ST7eO3g5liKaEII1AGWIbyqkJLMiOp
         pzVTNBCV/dRuG+F21Y2/MOCyg0br+oj1bi0wwyvc6jHDNAt9eLsazXTu4BJxyrauJgth
         gXKZWrqz9x29OZ4y2w++XGpKUBSVLga0KANIuQ6tka9hc0H+1QJLuTnRhGnDvf1A4Q3T
         qlQUd9PAAZRt0HryBVj+bcKuOzvVv19yZqU4xJOZYQoyuzZ5I3C93O7cyLZhYlq+iWP7
         SGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687936639; x=1690528639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eFn/Do9jN3RPupZVUJruVQkAXpC2rvNpM+OVzSO4M6Y=;
        b=HU6k5Lgtt1CBULWV46KE+ZA/x1LTleSDVO6Biqy32/ZYaqnPZcjSQASEkyhuX3q872
         bTt85nl6GiwhpjuvwvbRBYxL1oGTPzVZ/s/0oRgVJPg5oc5yx4S3TMErNeDMdtwEVeCC
         GSXwrJevbV5ht8Wdt6sHZ4PUroSWKk2eWzeDGg9tuztqX9e9RuyZ8lRhLEWrY/jM70Uy
         QYItViKuu4dHtVMOEmIyDrPtJ5n/rycxyi9cssiGCZyuOGCCGF+B0LKkYhk1UYZL6Cn4
         /2yydiU5GqyN9x0iBCTshXPtS9pYcvOc+z5Vknb++FChKPYEUCGvTO6kO59J1557X0zt
         U54A==
X-Gm-Message-State: AC+VfDxVLCyn41VecXEu1K+dLpSA7YDcY7z+3XE4oLVjEVQYu1CH/VJ/
	8mT6qPvbgq+weacjEz+xnHN5Ejbg53+C04Zs+WfJag==
X-Google-Smtp-Source: ACHHUZ620+ut1eAZaT3bcrux1OZzch2BmXZiVR/JAa5o3q2SNMYljDhjnw86jyAORwrecq40xjDRJwSnfOiK5+6IE0I=
X-Received: by 2002:a67:f9c2:0:b0:443:681b:c8ca with SMTP id
 c2-20020a67f9c2000000b00443681bc8camr165293vsq.10.1687936638913; Wed, 28 Jun
 2023 00:17:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230626180733.699092073@linuxfoundation.org>
In-Reply-To: <20230626180733.699092073@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 28 Jun 2023 12:47:07 +0530
Message-ID: <CA+G9fYvkRm274Sdk-06dbQuKV-W-mx7K9KM9BER9i_+HH0x4ZA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/26] 4.14.320-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Jun 2023 at 23:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.320 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.320-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.320-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 11aa1c2697f51ec92ee0c9033b8bce9e13b71787
* git describe: v4.14.319-27-g11aa1c2697f5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.319-27-g11aa1c2697f5

## Test Regressions (compared to v4.14.314-117-g854d9237fbd3)

## Metric Regressions (compared to v4.14.314-117-g854d9237fbd3)

## Test Fixes (compared to v4.14.314-117-g854d9237fbd3)

## Metric Fixes (compared to v4.14.314-117-g854d9237fbd3)

## Test result summary
total: 61334, pass: 48370, fail: 2047, skip: 10872, xfail: 45

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 104 passed, 4 failed
* arm64: 35 total, 31 passed, 4 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 21 total, 21 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
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
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
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
* kselftest-x86
* kselftest-zram
* kunit
* libhugetlbfs
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
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
