Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E97ABE5C
	for <patches@lists.linux.dev>; Mon, 15 Jan 2024 08:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z5+YX8C/"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-4b73e952ef2so1408740e0c.2
        for <patches@lists.linux.dev>; Mon, 15 Jan 2024 00:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705308615; x=1705913415; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jnB0KQ9n30qRjDbWGaCy0bZrFlz+zGMbjPXvFhazWYk=;
        b=z5+YX8C/gXzOXZnBEanB2Ieq2BO+RQI1OR/QZnrWtPpyI+F5dYcVa2O30zxmyKRdgM
         nqAk4Hh26Q+jyWxU3QBZ97yg8CwA6vjMQ/rrnUOiwyi9Y2wMoss88voGFDeSuS9ZJUdE
         LQHh2owd+wEnWDGeQqkaiii+8jj4+WS+I7QlWszInJ9UdMvk9S6xrWRXXJfCza5jFbbZ
         TSKCP+w3wH9B1TIF3H+iRx3wEbjApfVGaSGB10coaZlURY8DIvxrgnjhyL9PGkdAoxnd
         KtV8Aqn5P6AFZljJAKqczPST0U3+4EDoxDU6CYPpPh4984uu7cFCoseDlW9VCFbaEeq9
         E9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705308615; x=1705913415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jnB0KQ9n30qRjDbWGaCy0bZrFlz+zGMbjPXvFhazWYk=;
        b=sPq+RiR1qLxelflMvNZVdtwSiLvqrxnDCUBrLQtBtDe1vN814W5KoNEhoQk8BXYBnc
         EWcCz5M8871SVTAgy6rsuQzLw7aRrUCtHecXX/jAVWxs5eUaye/HkerMGZCbCxL80IVH
         zsE1w01gJxrUjCBMP2WV6yYgF5D/ZC/uuYDPGa07Ln6zCzy6oWx1A9POogp0TRJ+QYvk
         DY0wLwx6LpA51l7uDQPOpO4rfo8lXuTYYxkjb+omX2pqp/0tItVPp8jCIlDYBhMTAHNY
         2p80ngivgephnZImFs5KB7VP5bm5+4Cj2PSfmyS1th9yh6uslKl3K5t55G7DioMmN9wv
         d0WQ==
X-Gm-Message-State: AOJu0YwgX8/+1k8dnxAkqsgydeICcxOFKos5DTwgqvSKoQfDWCnpI+em
	s2pcznN8naXWG1T96NdyRpjevBio0dDFC4XVmWtgqPpADWASog==
X-Google-Smtp-Source: AGHT+IER2LHdcYASLqpy/PfdO8Gpg40SfDQcuW1fxoPYHs8Q2bhDpNHi14VF6ecCs7jo2egVbIqPe1MtNxnKV+D9l+8=
X-Received: by 2002:a05:6122:448e:b0:4b6:ca2c:b420 with SMTP id
 cz14-20020a056122448e00b004b6ca2cb420mr1640394vkb.2.1705308615173; Mon, 15
 Jan 2024 00:50:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240113094204.017594027@linuxfoundation.org>
In-Reply-To: <20240113094204.017594027@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 15 Jan 2024 14:20:04 +0530
Message-ID: <CA+G9fYsg1tT9-HHRbPmiQAV+BZ3o7BJepQzskYmRU=JHLxucEw@mail.gmail.com>
Subject: Re: [PATCH 6.1 0/4] 6.1.73-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 13 Jan 2024 at 15:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.73 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 15 Jan 2024 09:41:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.73-rc1.gz
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
* kernel: 6.1.73-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: ccaabe94627897d3e2d2234aa6b2196c32a63325
* git describe: v6.1.72-5-gccaabe946278
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.7=
2-5-gccaabe946278/

## Test Regressions (compared to v6.1.71)

## Metric Regressions (compared to v6.1.71)

## Test Fixes (compared to v6.1.71)

## Metric Fixes (compared to v6.1.71)

## Test result summary
total: 253149, pass: 214510, fail: 4787, skip: 33543, xfail: 309

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 150 passed, 1 failed
* arm64: 52 total, 52 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 15 total, 14 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 46 passed, 0 failed

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

--
Linaro LKFT
https://lkft.linaro.org
