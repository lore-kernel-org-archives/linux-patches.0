Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D115423D0
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 11:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ew37I4tG"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-45d94e7759eso255412137.1
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 03:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700133211; x=1700738011; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PPbTsNVbTJpvM9xFj6LjzFWal6KJ/8xDtc70facoOGk=;
        b=Ew37I4tG0Pf4BTDpHQtobsO03b3hULcsAemWuW7GPzFv0uzf82FKVK28JtIQ2AWZCK
         sO74Ymyceh30U+A4NJj9rgvcdbLk99mJTJ5Laejhug3Xv74jm6x5OJYXM0TIKKQTpR7X
         eHcd4OYJqohKM6uugH/JSAyHs04A8NkYCe6Z6gbYjkrBBcnvZSkKHAnvhfbGpgFZoNDF
         nCneSrvWe6T7fQmVo4Mr3t2BjoMMVN77Fqd1x5To+qN1UMy89r7nZ6vxjdNRM81/N1RK
         mF+kJwyVA9BDmzPCIfH7wPZTdm3WsQhM+yd+Crobt84+AGNTjm9R4QT/kUS2NZop0I8v
         P83g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700133211; x=1700738011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PPbTsNVbTJpvM9xFj6LjzFWal6KJ/8xDtc70facoOGk=;
        b=Y944dT0iyrVaDANNbLsSzDE9t2KMafbWqFKlpJXFFR2DHEZcmwN+2qIg1vx07sQvGI
         q/v1KGruaTnWrR4eMovmdTbXBpi24zsBP1oj+65/xKMDXWYITqa+lJF/L+I5GYPmaWAD
         4XWR7XHhr6pFYgBVLAQng7reZccm5Ls5sXa/QvjUsOJwUV+e9HmEtDyp16N3XCe+kFlo
         elmF0v8R1cKHDWOE3UQijiOtda5zyzWzcIvrZLp7PHFzYisd1RBnliFPXosY8vnilg9n
         IBz96rbjl7ZMtTA6tuvPDIGv79D0P4GQ6YvsqffB5F+tLc0e69ySxvq69F36elUFWXMp
         zqDg==
X-Gm-Message-State: AOJu0YxTxCFhW9pVcAT6BE8RApqRK3ChgnloYbuS43z+VJ+nk77KNkJO
	Yn0KX7nHk/PlDozZMch8YoILZeGfiZWIR7ztfaIiQg==
X-Google-Smtp-Source: AGHT+IEA2x1WPWP9jfSdwsLXwYb+NbDsT7pP3FL/Ha+9jHQmjvVEub6KCNATZoBtK104xn94ETxAamo97B3WhzCTPco=
X-Received: by 2002:a67:e885:0:b0:45f:1790:5b55 with SMTP id
 x5-20020a67e885000000b0045f17905b55mr13106640vsn.28.1700133211627; Thu, 16
 Nov 2023 03:13:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231115191426.221330369@linuxfoundation.org>
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 Nov 2023 16:43:20 +0530
Message-ID: <CA+G9fYsq8SV8vpmcZexRWsPoBxYDKNfFBxJKPmev8cXvCJw+uw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/88] 4.19.299-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Nov 2023 at 02:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.299 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.299-rc1.gz
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
* kernel: 4.19.298-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: cf4a4e22ca8be35b01101e3d8d6d1dc62d7d2412
* git describe: v4.19.297-62-gcf4a4e22ca8b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.297-62-gcf4a4e22ca8b

## Test Regressions (compared to v4.19.297)

## Metric Regressions (compared to v4.19.297)

## Test Fixes (compared to v4.19.297)

## Metric Fixes (compared to v4.19.297)

## Test result summary
total: 53428, pass: 45034, fail: 1563, skip: 6798, xfail: 33

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 110 total, 104 passed, 6 failed
* arm64: 35 total, 31 passed, 4 failed
* i386: 19 total, 16 passed, 3 failed
* mips: 19 total, 19 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 4 total, 4 passed, 0 failed
* x86_64: 30 total, 25 passed, 5 failed

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
