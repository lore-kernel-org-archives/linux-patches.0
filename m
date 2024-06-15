Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107D7208B6
	for <patches@lists.linux.dev>; Sat, 15 Jun 2024 08:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718439128; cv=none; b=PsFDfB9/yJrukE5pmFo47oz15GfL//2/GEh6OlV0EG1vu1D2qavqkDehhWl/i46Uo0HCTJwqcLcj27Wm0Mm3BuO8eapyHByCGEKlvGCNekEQgAmQRKLWBtftHHDBUHlMFJzjleIB78iXYrE+v7uz9BQ5EPMHwWE9/DiFwtdm0L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718439128; c=relaxed/simple;
	bh=T/MZPbZQgPKyZqFaOxXEYvsvn2SayXByQqpNuAM55us=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KT/r8qYqnfOkF2xieage58r6XBZIv4kTMQKXu3cpmWePyBFRhBBZ7+XLT7xoRdxsW9YE+0UR8lLWenyIyYjxHH15t8EkV3z5hOrSR+hmJv/4hk8MVu6SDn4YvZTT0rhVcbzT9/YNR4ZEDdi15osVzEX90PtQVvjSF0IouOfNmSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jedMDN2/; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jedMDN2/"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4ecfa40a778so761455e0c.2
        for <patches@lists.linux.dev>; Sat, 15 Jun 2024 01:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718439125; x=1719043925; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CX/O9XayHzYV7cWWCWO6mgKk856aZ6rbvTGPWtOjZk8=;
        b=jedMDN2/Qlh1As5+VIlUPsvTsaG7fj7KrnYCoFTRdnwROuz9imX+JmCUd3vWfCeWnz
         TOLm/G8Jm5q6re4MWLr5AHQtSpOWV1N159zSDGI/ve9gFqdhMsADZKfUcYRckgXh2JoL
         Bam2SwQm6rog+km6HpJXVnfwSpuG/Jd17TFs2fqNtQvF4fnPbqSpL82tiEZ8NonwDo1L
         OorHoiQAPhqvYBgYkU/n8ouSvU57FDmxRMtK9urPz/pjRBg6IbJTLSsWcN5HARiYCwgX
         at+CZji9kW9R33sFAKMTayYb4fHPSbte1BGZP/d3IR7jzYftBqpvlWTr/LZP4o70zmjt
         4CKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718439125; x=1719043925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CX/O9XayHzYV7cWWCWO6mgKk856aZ6rbvTGPWtOjZk8=;
        b=TpRdmbGdk+PDIajSPCbDTKDV0/wArWVcWPBrWzmVSNvUXcqhtm988cwUpRKOwL2qOU
         XNL2r/xyLa900gyi+godPCwls09GyKCN3FwjGWLN0rPDjObSKd6gpnGzrISrhRB2LTZK
         tkjU6smzoAk4qRPFVYc5NM25/OHug9itKI2iWDCm2S3gMbMY32dDDsOeffDyD7aHXK+B
         rKweuk04J/Ws6tkgAJ9v0jKhqTfBPGXpcvDsg8Kg5s/9F1D/UW2za7/GqUORbY/1ijL5
         P/R7Eh8PHe4zLM9WoGqOo+UUjQoIufPhTK5oFRsfDtHodkm6KV/bdpg9eEG/a9+HatTv
         SnhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLQOhd241DwhnmVswzqDS+4SKJuRgPgavGJkKWCo7E23IBUAXYxCE6TzBMbMpR25Euyq/xGP/F+JIs6okILyFxo/J5IMV4tw==
X-Gm-Message-State: AOJu0YwmhC9wxQlL8XoEtm5PDti2jsdQBm4Mcc9PRoW5PUFWsDubJQVS
	E8En4g1ttzGjGda/j9TCIUQirnmWfVQPwmRoMv+XoZ08Dz5NtfyRele+Ac8RADDkHlYHI4JsSpW
	+m6G04ssJtMfuU2/hpc2j+ihfmeDD5/k3nv2rdw==
X-Google-Smtp-Source: AGHT+IE+FSgOidj7gD4O5t933BVOdLfDJrzcamX8mcRHcOSsAFXlr1aFntiKrxA2O0EuNqDWwXit7SM0N4ZTpVrmfJo=
X-Received: by 2002:a05:6122:30a2:b0:4ec:f291:2a45 with SMTP id
 71dfb90a1353d-4ee3eb78b99mr5746899e0c.5.1718439124819; Sat, 15 Jun 2024
 01:12:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240613113227.759341286@linuxfoundation.org>
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 15 Jun 2024 13:41:53 +0530
Message-ID: <CA+G9fYuFsA_vw1z8d5cPiMw7GpW0Y6XQHGeJsNj=3_eda_00Qg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/202] 5.4.278-rc1 review
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

On Thu, 13 Jun 2024 at 17:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.278 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.278-rc1.gz
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
* kernel: 5.4.278-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: b5a457a9ff04a0bb90149f3bc8033a2a98d04caf
* git describe: v5.4.277-203-gb5a457a9ff04
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
77-203-gb5a457a9ff04

## Test Regressions (compared to v5.4.277)

## Metric Regressions (compared to v5.4.277)

## Test Fixes (compared to v5.4.277)

## Metric Fixes (compared to v5.4.277)

## Test result summary
total: 93744, pass: 75189, fail: 2023, skip: 16475, xfail: 57

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 35 total, 33 passed, 2 failed
* i386: 23 total, 17 passed, 6 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
* log-parser-boot
* log-parser-test
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
