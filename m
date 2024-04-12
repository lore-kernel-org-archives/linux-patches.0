Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0F414E2FE
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 18:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712946308; cv=none; b=Kb9ftOrQefXQV3KzQBgoMkeL4sCV+TlUPm9udTOdsv6BpG9qfMmwVRNg+wWG9dZ5FPmFjNsG/PvnRv9F2e4reJjFwhzjxCF1XbjBXxN45lkNFFS6CLr/OYqqAkepOCiJDV0bXmSU19qb0fVDSMTIxs3n/KYFBRw3TtXQtWlz0cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712946308; c=relaxed/simple;
	bh=ry66YQlyt3rAYniCDBOFkCGxY2ZiHVBUqgNRBCuc3PY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BNMFDrM1FfKNH3j858l/a6tNiseJkcBQMvMod0Ptd5US1GFkYjh2EahcazNzpU2Vz6Cij36PZLvZwMZAqh/0VOAR9TD/6hOjUPgLLe6eh35N/001V8q1U2UtOfXDh7/ZMUczV3NJVFDKcyt6KzfHQrPcfdLngm2LwiCJS/FqLeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kPKWqdZq; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kPKWqdZq"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-4dab344ace5so369919e0c.3
        for <patches@lists.linux.dev>; Fri, 12 Apr 2024 11:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712946305; x=1713551105; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jQVC4UrxcWEkIXkGeGXm7dBR+1G2Vzp/gIdMFXmEOQM=;
        b=kPKWqdZqtSosf8sRXj3Zk5GE+Ys89MGKOgqEusb65x9TOYHJc8+9bu3rqsYMvtO6BR
         Ta7DxpXv2AKcjz1qwTgcNsbU9NQo2nWdlbw3kjS1JjdBlTayQYyw7w8xGRLRP85o66Lj
         tL70uZbhOFwdI3SltYM6Z7mUWaBotDO4bi4EEM/4ez1VAA1WeXvJ3kh001MpsuEc1js5
         FMok9U+UmCED6E9fK7+nLjLToN2cK5fyygxS4hG8IKPC6Zw8gZSTiu85V9dEklRpgJhX
         fqcpxGToyu6pB0wsaIh+3GCuCgBjDu8j38CxS5BYp+4YEZxbZPNnP+nvqCGhVDWEwIZx
         R3YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712946305; x=1713551105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jQVC4UrxcWEkIXkGeGXm7dBR+1G2Vzp/gIdMFXmEOQM=;
        b=Kt9AKw28wOSTvp0rKFu7fmcU0thpe8C3N07l2Muo6oKBrEwmbZGy96gxxPOClGIEs/
         Cd5MhyqgPLgc2kBlsKtNXFmp2Az6KS+4yqccrEE0IcYpqDp6yYwsIZaYV/GjmSRvrtFy
         0ERIg74lf0BAxnRLL6jH0kKUT3i3DTu0pTlL6MgZ79Tu9QW018HdX3td1Yanei+zQR/j
         /Z/dIpbsoTMP7IBl9UcB5yycGnlW9xs25UqwyEZaAPYSvA1PQwZc4Y5eswBXE2UKG+m1
         4vEbPx3ry+DO3pTJvVGsQHnQVdwvagQRmb0/AHkF6U8Ng2nZcKhejWfkgY59VLNTW3nd
         rzMg==
X-Forwarded-Encrypted: i=1; AJvYcCXQHVUgVI5JoPBsjFCVrqHzh7EhpTvL9DecC7zGIQFsHE0c+RjXHd2nwqphQl3G9FQYgom4ickmZEhYnKEa4seBqKWhSjKz4A==
X-Gm-Message-State: AOJu0YwNipnuug49/czJBgyhvGWd8j5HbuIx34lB/MNp1+1mn6qCs1uD
	H9dXoNHjrBaxOtpDU5HSJKheSaj3IXsaqp2UKLSAbvxn9b5awo4vX+NVqbxZ9rMv5UX/VaD412Y
	+alUbDHMpKFjlt7yKd/wfO9/Rh7oRCz7bysAAPw==
X-Google-Smtp-Source: AGHT+IHMP9iSKz9Wkqt1WKRSp65sfJmSOV5flXRlhZ3cVhkWjFku5qz8AJVj/wKL3Vrf+35SNZ0bmN6Lzol/yZLlCLs=
X-Received: by 2002:a05:6122:3c56:b0:4da:9d3e:a7df with SMTP id
 fv22-20020a0561223c5600b004da9d3ea7dfmr3994403vkb.5.1712946305324; Fri, 12
 Apr 2024 11:25:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240411095407.982258070@linuxfoundation.org>
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 12 Apr 2024 23:54:54 +0530
Message-ID: <CA+G9fYvGhW9dNHWiDwe1nCOtEMqbVuK7zC9kWQjvYPTb4hrHHA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/57] 5.15.155-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Apr 2024 at 16:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.155 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.155-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
LKFT test setup using NFSv4 do not notice LTP syscalls fcntl17 test failure=
s.

## Build
* kernel: 5.15.155-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 857e7024b96feefc0c2ab59eb5e661df777e6a72
* git describe: v5.15.154-58-g857e7024b96f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.154-58-g857e7024b96f

## Test Regressions (compared to v5.15.154)

## Metric Regressions (compared to v5.15.154)

## Test Fixes (compared to v5.15.154)

## Metric Fixes (compared to v5.15.154)

## Test result summary
total: 93809, pass: 74866, fail: 2649, skip: 16230, xfail: 64

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 104 total, 104 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

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
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mm
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
