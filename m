Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B125913342F
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 17:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713289310; cv=none; b=bValdnoNPTZoZuGJDxE9seivJNiXIyMsgVMNn+CkIGQ7CcTTLW+7OojcNJiqAGMSaDHoqbEkdSXYFkWOyxE6ZLKvKpkofCAp6VxutI8yPTluPajHw8IFgA33UWHH8/xNsYipt+5jZrrPv44vw3PVOFEBu3NPOVC9YV1vB9zKWJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713289310; c=relaxed/simple;
	bh=uKVZxVZlSo4tSfHTbZrt8QwnCT7MxtMg82Aru1PM+u8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AFoE1Zn9bPi91W7X77sLA809ENzJY0/+p9ylp5PkxYXV1SFgfRoJpLE/US9fD7E8oimhd40cfnDFkvLkztE4ESXkbwQvKnD/qfC1W1761KUNAjnvhae4X4PAgCpAKviwk+Y646yNsxM4VMi8vddxnQZYgdnYrWwodLbgcXHvSoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uKsKBczh; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uKsKBczh"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-7e3d5cfd81fso654468241.3
        for <patches@lists.linux.dev>; Tue, 16 Apr 2024 10:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713289307; x=1713894107; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WnPrPrshaoqEgDMfeskW4XuFf5a8CzPJbeeAH4eg1mE=;
        b=uKsKBczhyaZllaT17piVVK9AqttsBxZrydmJ4Rbu6/onNWmj7zSAYNNa0n19AJXoAU
         fQ0OG0bDux7eLIOPKCyOr8bRXsc9WY914no+D5WcfmfzuQUm9pnOf9MmhRhCWgIilapz
         E62OkbEeZbSRERYZqgwApZzckWyiybVUWnWx1+lvChh1z9sBF9AHZD7b+KCl/iuVn8kW
         fS6ckZv8G7/+YM6saBFuRzUR/4gEjULmPlYUMm5R2EpHewcSxSZoXiGpfIZMAhffPt19
         XlF5OMtKyu5PMKCbIErOaYPnY3UES+gBBcegydwOCUUXnLHGhrIe+pxvKISEoytcrF6P
         7nVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713289307; x=1713894107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WnPrPrshaoqEgDMfeskW4XuFf5a8CzPJbeeAH4eg1mE=;
        b=XkbMl6+/580a12FPjprvHIiqZHadguMESYYZm1lJLED/Wt2oUS2/1IA1WmFHx1eaQ2
         TOYYsTg8YWwJ68H4rzROSI7iCn36Tk1RkWuNcdD2sHHaMdGtC2S9PD63h/IrVPDQgd2G
         aY1il6kwFXWSFsW/A9lp5O4OJOBvV80Jk888jPN9rRIAoQNzdfSXN89mmXXEBg4vIWlL
         Y4JV/W5S+2CODhvmq5v1tWBZeMHqHwzaXzYSrT96wIzEnt2TZZJGqaQD+0JE8K3EkncC
         qQKP4RYXS4ZqySGjwv6BWTCCMdZM8xuvSZ2FZsVlasma8CezEXdbt5CykuK32r+1IoGT
         Nueg==
X-Forwarded-Encrypted: i=1; AJvYcCUr+RSM7xQWMyTLljZKEKLSy/2LzuqR1tW6fzE45gUTXWrXuPnzCrS2pGSPvMuWWgB9A43ci2n2NnMjW9akY/wO3N637EOdtQ==
X-Gm-Message-State: AOJu0YyFk3XErdjKCH1ORMoCOOcbGCeqSBxOpz8QMQcamDnG6C08q3Va
	/6DuT0IOxMSyYxmo99yCP02Lyy9GnUeTbd/zblXBv2SQ59YHE8CvWgGhsfnFs+w3gCOXA676+TS
	aqZcgJULixFBJsbBRyDOmatNJDvI2LoKaDab/vA==
X-Google-Smtp-Source: AGHT+IGQOiRJVB0i9nfTAHucMka5bk9jMtq3i/B9OdHXAz7Tlx+yTSFzDhb7vY49vXsiPkVKXzwjOnCxxwy7cZedC4E=
X-Received: by 2002:a05:6102:1629:b0:47b:a037:99ca with SMTP id
 cu41-20020a056102162900b0047ba03799camr1332168vsb.1.1713289306728; Tue, 16
 Apr 2024 10:41:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240415141959.976094777@linuxfoundation.org>
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 16 Apr 2024 23:11:35 +0530
Message-ID: <CA+G9fYscTZr0qJH5k8eycnD7Mj50XGgNbzcmk65=RKtme1tVpg@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/172] 6.8.7-rc1 review
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

On Mon, 15 Apr 2024 at 19:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.8.7 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Apr 2024 14:19:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.8.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.8.7-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.8.y
* git commit: 367141eaada2c7635234576914bcd1f480d62731
* git describe: v6.8.6-173-g367141eaada2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.8.y/build/v6.8.6=
-173-g367141eaada2

## Test Regressions (compared to v6.8.6)

## Metric Regressions (compared to v6.8.6)

## Test Fixes (compared to v6.8.6)

## Metric Fixes (compared to v6.8.6)

## Test result summary
total: 285130, pass: 247210, fail: 3619, skip: 33930, xfail: 371

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 131 passed, 2 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 32 total, 32 passed, 0 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 19 total, 19 passed, 0 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 6 passed, 2 failed
* x86_64: 37 total, 36 passed, 1 failed

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
* kselftest-livepatch
* kselftest-membarrier
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
* ltp-io[
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
