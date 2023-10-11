Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88C820E7
	for <patches@lists.linux.dev>; Wed, 11 Oct 2023 01:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sUCRTq4W"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-493542a25dfso2141799e0c.0
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 18:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696987853; x=1697592653; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1WCazXgjZG6/RbtNWBEaTlLjOlWoiY3DlSKlQpJqUVg=;
        b=sUCRTq4WyafMT907f5ZiJq6zJqLtWpxIZVTPV+4svmsSRH8nemthkzvSFD2KU0JAtq
         RtKIiqU9b3qmpAtDDWSeDgiGotNsFu3cKOydsg2zyranVCri2aGJYiO79I7Xy3hK+S1P
         NY9wxAuY0aKVogJIfPiRtRtDHfxoIVvS2ECf5iu+prhbHmDz/PdCWKHKMmN9MhLVqdi7
         My//NPuJDU2MFk1cYWhfufN6iE4lV3J3iCus9WZcsfMWDIb86PWtEG5/c28XFYOgF3/q
         qJrroz3D4Tmi9iMDus1qcdYpLPOl3/JkqP08RS1QgYdHXCFbZUbQFbpZAjNxnZBdvX4Y
         br5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696987853; x=1697592653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1WCazXgjZG6/RbtNWBEaTlLjOlWoiY3DlSKlQpJqUVg=;
        b=uFa/jMZa1e2ZmjAvzlizs7MdqrLsFAengmgLHhAhiMWcgGisbQGxxLn7YyzGllcYu3
         FnOrKbMYKiF9gbmMkH3kcxmQvjAzjJvk0mm9JgROcOGf/7jmreZGCHndd1yo6a0MWc4T
         aHt74sqDq3GZtgaNo8OXllTnGfbj8gGixCnT/uLFqG1ptVlrrMrmiqWSIUpZP758Rf8/
         6m10l/zDyLCIsMeTfOfAKgVEwvt7Vt/HxJqtZISGyn3BGfDvXvhJ09j9stYvKhV9/f3y
         X10OcaEXx3g8xTLhUNkj2XDf0GRCS44Asvu7RepwXDPyBERrZULfpnMGnxz2maSg89F4
         32eQ==
X-Gm-Message-State: AOJu0Yz7uYu34VgZ61JlmB0nh2A7bCQdYVz1+27txP453RI6x6vT7n/B
	UBT+U4Psos04kz05DuOPxfrfDsZqpzZ4IM8pJIm2Dg==
X-Google-Smtp-Source: AGHT+IH8MAtZKzz5d7zmiYzvXuyT1JqyT4ZqLCkvEdCZJQcXXb81/Jogy5TjCC0TNg7qu4hLdW1qzymIDi671Ka3t28=
X-Received: by 2002:a1f:e043:0:b0:49d:a52a:4421 with SMTP id
 x64-20020a1fe043000000b0049da52a4421mr17043739vkg.4.1696987852124; Tue, 10
 Oct 2023 18:30:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009130111.518916887@linuxfoundation.org>
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 11 Oct 2023 07:00:40 +0530
Message-ID: <CA+G9fYtm8JvOEOUXQj9=ukN4vyH_E3wwMOHsD0wsHQs-Y-e9DA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/91] 4.19.296-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Oct 2023 at 19:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.296 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.296-rc1.gz
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
* kernel: 4.19.296-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 1d560dafb2e3608cc252a10c4558f86edc39b34c
* git describe: v4.19.295-92-g1d560dafb2e3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.295-92-g1d560dafb2e3

## Test Regressions (compared to v4.19.295)

## Metric Regressions (compared to v4.19.295)

## Test Fixes (compared to v4.19.295)

## Metric Fixes (compared to v4.19.295)

## Test result summary
total: 52204, pass: 44074, fail: 1739, skip: 6358, xfail: 33

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 111 total, 105 passed, 6 failed
* arm64: 37 total, 32 passed, 5 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 30 total, 26 passed, 4 failed

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
