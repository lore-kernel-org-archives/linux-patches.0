Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C90F9F7
	for <patches@lists.linux.dev>; Wed, 13 Dec 2023 06:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j2cbf7BS"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-7cac4a9c5b5so1635723241.1
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 22:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702448802; x=1703053602; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryCEu48eUmxPP9GQqL9AHFaoE514bwONp0zHyCua5pk=;
        b=j2cbf7BSE4pm3XPeIhaTndceGV4FcccuatGCKg/HA8AgDs33hwp9yH/++TlAPNOhwe
         E2n0VtLNIBWsu0DSpeUIltO0ztQnaVa8xVf3T5Snsa65bplg4EPV0xyRNbXeFez4qTWE
         /0GJUWawlasyJbWpkpf1JR0SVf0GoZari1y/WfV1agPrNE1UMqoTVxUm4vZP9XGp+pwb
         Gg54EJ8/lZkaRYcAFVHEssfDpRnPfsrxb+g2xarbm/4MbepLQJSz3vWyideM2ZmnD8DR
         h5wf4TBVOhaw38hleEIIL9KUIn8Aj2kTL2gK0pKekoe9nzxvYJm75GXPwFtF5r4+o0Ux
         L6Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702448802; x=1703053602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ryCEu48eUmxPP9GQqL9AHFaoE514bwONp0zHyCua5pk=;
        b=mqzrJwhtd/B5+92Yhd1j4euQCh432Jp5+iSjU78IkhyWkunqrAi//6lmQMzhPESTCl
         1yttWNvfu+NM8BDusJQm1L20A2LuM8FBpCZP6Fl+1wlzjsY3Vz9Tj9y+iCFByLBBGGhd
         JqhCagkWT1B/2RBtvPppVoLuVC0NQE4KXCM/PdcfjU6ZPYEYyu3CJ2/hMclBBmlvS2SM
         5faFuE1Y7yH/+ZJzBYX8QHdZcWAPJ2L59f8nAhBWTaXwHk/UeKOLdCUwH+Eb6psw9jyW
         oWcnQeK/HwDT6Uc0k8Zkb14bhtfwFBhnemLpa+Z3SNNq9lvrS1ePINMYqA34/41trVWV
         7eOQ==
X-Gm-Message-State: AOJu0YwdB7Yr/VWW6GxF6hjF0anNAalpNGWFrwvtADmP2ztHqH4KNAaL
	KQDXM+TPztgYxsv4Fho2Th3jbqnulOm+wA3+nvzVzpgZDAvYTr7UN2c=
X-Google-Smtp-Source: AGHT+IE3A8Ed8eaDWU5zKh/jzWxbUFJO8WH0pwo+X34lGkKWDhF8k9z1qeRJ5iKHhBajzWLC1POJ7NRiZRinHLbkW0E=
X-Received: by 2002:a05:6102:510a:b0:462:8ca2:1bb0 with SMTP id
 bm10-20020a056102510a00b004628ca21bb0mr5336003vsb.20.1702448801091; Tue, 12
 Dec 2023 22:26:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231212120154.063773918@linuxfoundation.org>
In-Reply-To: <20231212120154.063773918@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 13 Dec 2023 11:56:30 +0530
Message-ID: <CA+G9fYsprWr-ZcSE_bAvuXA-sXbQwgjLJUcP0i-6QB5FGbKDVA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/53] 4.19.302-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Dec 2023 at 17:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.302 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Dec 2023 12:01:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.302-rc2.gz
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
* kernel: 4.19.302-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: a7780f896379de16bc4e805ecf216959b5b876a4
* git describe: v4.19.301-54-ga7780f896379
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.301-54-ga7780f896379

## Test Regressions (compared to v4.19.301)

## Metric Regressions (compared to v4.19.301)

## Test Fixes (compared to v4.19.301)

## Metric Fixes (compared to v4.19.301)

## Test result summary
total: 55035, pass: 46309, fail: 1569, skip: 7122, xfail: 35

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 111 total, 105 passed, 6 failed
* arm64: 37 total, 32 passed, 5 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 20 total, 20 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
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
