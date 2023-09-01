Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC10FAD3F
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 12:56:00 +0000 (UTC)
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-48d0dbf4ec5so732219e0c.2
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 05:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693572959; x=1694177759; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QvH35cfo8hbq7kkNMUx0gNbEXq2JOSFfFOtm9Y71cKU=;
        b=WvlPnwxTT13EZlAr6Z8vP0LGVhDG9wlrSiFpZVUv90BJIFDAVPWs7E420PhygkrpE1
         3BA/UmU8ruMAibtI4FN877v4Or/Xfp5iUfXh3Hc+gGMNDU/ikibQ4ZvqQLpK/EOGUMbD
         iJPG8FLKp/SdmfhAMbpr/QwFoZcYcDhTW/5YCtFZYURdh1FXvVv3b4cu42dnLDvYh/qC
         Bdl3SIpEoj4WMvagmTcfXLPVUPBfqxqIUZR16t/KNb7jUwsp4p5hsSLoqVsE2ab5Sgf0
         dboMGXBiQvPigLJwvoJb3EvEIX+hTqiW8X28dgbe3RzfML4sZ3qDbb5XbMGVp+aVUscI
         051g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693572959; x=1694177759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QvH35cfo8hbq7kkNMUx0gNbEXq2JOSFfFOtm9Y71cKU=;
        b=Vu6BSuGj+d5Hmut4mubLrSQtgxlNU4ZQDs3vLhkloaczpCu1FIEdKwZTdkNytdwMSu
         jlszoW81XYM36jmRQsbCBxeYpmH5Q61wUa58QtRwGMLV87evUKhTI0kfEGd7/vSDL7O9
         +MlIbnEeLoxq9uciRwTc3MTEQKUJbGicRgY4A/2JC0Iv6Pvo8qlsVIXT4zQcGEcmWCHY
         kxnWhgrccqOpJK0lZ7PbzFTy7s3ygfFqhlkyV3u37z9VbBrP+f7+ood6Wkq6baxr85M2
         dTslc7Gwkb2G5tgAY3Zs5VgdjkwecTLcbVFDLwZufPdtb125VjLiIGh4UQJdbIqqK3kh
         wM4A==
X-Gm-Message-State: AOJu0YwPJy1m6O7b6gUzeXbtv4LDYoP7panLyF3NLZBBt4WQmFgldcLe
	RqfDLbhRkFlOPafsPH+ZIotqMFyt5dEKnLSU5uXN7g==
X-Google-Smtp-Source: AGHT+IH6Cm2+42kWJhzcgE2fegmE9O6UDhVOlB3LtIZEaoHsDvBDJxBuyk88NAyOP2o56XB3/nKT50+OImD4rl6JMII=
X-Received: by 2002:a67:ce0c:0:b0:44d:476b:3bbf with SMTP id
 s12-20020a67ce0c000000b0044d476b3bbfmr2326282vsl.33.1693572959425; Fri, 01
 Sep 2023 05:55:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230831172214.759342877@linuxfoundation.org>
In-Reply-To: <20230831172214.759342877@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 1 Sep 2023 18:25:48 +0530
Message-ID: <CA+G9fYuKxuDKrWfjNya+12TUHrCMXqWx0o0RkuaYW4-ybSm7wA@mail.gmail.com>
Subject: Re: [PATCH 4.19 0/2] 4.19.294-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Aug 2023 at 23:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.294 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Sep 2023 17:22:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.294-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.294-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: cb2cdf2272086683c41f5bb61390600f01227b6e
* git describe: v4.19.293-3-gcb2cdf227208
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.293-3-gcb2cdf227208

## Test Regressions (compared to v4.19.293)

## Metric Regressions (compared to v4.19.293)

## Test Fixes (compared to v4.19.293)

## Metric Fixes (compared to v4.19.293)

## Test result summary
total: 48932, pass: 41532, fail: 1475, skip: 5891, xfail: 34

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 100 passed, 8 failed
* arm64: 37 total, 32 passed, 5 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 11 total, 11 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 26 passed, 5 failed

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
* kselftest-user
* kselftest-vm
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
