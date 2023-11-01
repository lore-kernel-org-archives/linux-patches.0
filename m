Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E03411CBF
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 13:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zm5AvxRa"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-4a18f724d47so2235268e0c.3
        for <patches@lists.linux.dev>; Wed, 01 Nov 2023 06:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698847192; x=1699451992; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XgR3nF6EZLqp/H8kxFE33E+SA9d5i66IyhQCWYiF368=;
        b=zm5AvxRaja/gd3nS8Q0LYEXgO3nhZRJtnQo9u5Wz30CTL0VYwx0SUUptudAaxGXO7f
         8mlG0RWVZ3p7sT8OLXiriOLfSVOHoObi12HxLJNI7npJQ3dca/YO0tWpiYi+cGNkmR5l
         wCFkrUVMnMWp1uPRr7M+7n+b/k10ULB39NKEHfL2KX4Ae9Zw5+4lK0TC4fHnBOuS9X7b
         JnwhmWxfbehQvVdMoJFDe0vEFLtFpld3WScVzgKgDQHyWb4f7bGWSqQ05qgwNNUKiEWO
         3RWqa+5CSWdkWgniJ4PyVMZB78MoK0ssXYBNQautlBveOSuyWJ9jsSEbKtJRMjGAIFNE
         S8nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698847192; x=1699451992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XgR3nF6EZLqp/H8kxFE33E+SA9d5i66IyhQCWYiF368=;
        b=gcrG7Ki10u0s9i9rgoYcVYlJSYcrwnqLbOcMNgE3K7iDlc3wvTh3ZsZS6oaUoQsvws
         bvrlZtwPiEO5zs/OR9Irk0ISDutaRTR1Tx7d68Orv7nHO32FSOm5Ms8SoTv9LEuVeJUA
         uoHNx5bjzaF3gHeJiTlfKRZD/jMvoAfrzdXYp3XOG0xCihx2n0j3QKHchnM3RrTKKByE
         8IzuWDy1jE/fqOZyLSfXuEb1X3ztPWdQdgak8p6U19TL8r+KpVK5BYU/6CMcH1Tk+Byc
         3R8e/rLZllVHawyEEDxNGpjZwCYSgeYCsQa1oGMqwlVRFn/3tgSZzlQfiq2usSuR+eYo
         LGOw==
X-Gm-Message-State: AOJu0Yx0PlwjaM5W2m5nilp5JIpyDH3HObH8A2jBPZhF8+TvCWv489J0
	6uMs41K1bhNIz7izBlyUzWCoZ9eOpgULh6L/VGpgzPdacAXS86KCzCq3ig==
X-Google-Smtp-Source: AGHT+IHW8V1lpNIY3CAfyhi0XQek+S8lZMVyeE6Df+lCTa+Lo5LiXqssWb20eDJxfDl2hfODwffDXgN+IOHOhSHe2FM=
X-Received: by 2002:a67:c083:0:b0:457:c17a:d34 with SMTP id
 x3-20020a67c083000000b00457c17a0d34mr10681087vsi.2.1698847191929; Wed, 01 Nov
 2023 06:59:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231031165918.608547597@linuxfoundation.org>
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 1 Nov 2023 19:29:40 +0530
Message-ID: <CA+G9fYs7JCie4Vb2=A2oAVVDHyo6KMv1szqqPzSrE7NS4k3XQg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/86] 6.1.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Oct 2023 at 22:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.61 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Nov 2023 16:59:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.61-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.61-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: d87fdfa71a8c82a481a41421b387544c7012b21e
* git describe: v6.1.60-87-gd87fdfa71a8c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.6=
0-87-gd87fdfa71a8c

## Test Regressions (compared to v6.1.60)

## Metric Regressions (compared to v6.1.60)

## Test Fixes (compared to v6.1.60)

## Metric Fixes (compared to v6.1.60)

## Test result summary
total: 123155, pass: 104208, fail: 2398, skip: 16422, xfail: 127

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 147 passed, 0 failed
* arm64: 49 total, 49 passed, 0 failed
* i386: 37 total, 37 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 42 total, 42 passed, 0 failed

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
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
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
* v4l2-complianciance

--
Linaro LKFT
https://lkft.linaro.org
