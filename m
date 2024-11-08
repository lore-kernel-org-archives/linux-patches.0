Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2F31E00AC
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 09:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731056993; cv=none; b=Fuvix6sj+aJqFPJQ4Xcj+qbDS6ks5HihX6ReRThQaXfgbrhyAXqBflNVxqmyvPRTq2ydj1qfu/NajONmMFgXTqD16HONxidY7r3lJ3d9Vv+/kjCPFBJWjO++YcDpj9vRl6SxFTI75r+pKLOutdbwLS3ZhMmqirgT6cwtX0pOseQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731056993; c=relaxed/simple;
	bh=6KyTu3O9fQfXvsz503x3Dgpd5/g0spE0Tog+jn1Fri4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GGj2Bupu6XrFE4fYIiL4jcXweiEoSvmv/p4MHFTUJJ0fBI3Rg1Iq+MTea9IBv1Z57yjUSGQyL4BygE1MZhQE4iclPH2py0Ld2SunvceWVYx73dJKEkznOB2hkC/5ul/R8zh2VvuOpilFkkQFE2bbD9sLlCogNEQ0zMoRxyCV3xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=faQEfmOQ; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="faQEfmOQ"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-84fe06fbdc6so836087241.0
        for <patches@lists.linux.dev>; Fri, 08 Nov 2024 01:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731056991; x=1731661791; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3rCuCRkF0AD6qgQEhq9OgaioP0iDJV1z0RS47lWOzG0=;
        b=faQEfmOQj3QuZnpS9GJICS5AP0QLfw5WN6Z1AaONrZD2QXYVzKmqK5KP7Qwre0lSRK
         ddoaxKCKvo5gvlLR7LoaaHd1AZ8PLUMGPTDH5ZjWlhc1vNvGioJ40AtyOF+FW35E22WD
         gs4QrAPQebgcuxpzeqlbWG5iv48hfmiSM5s5oQQPDNoqKrKhG+JJ72rIugrDBDEXJL5E
         mJED3Hz05pstGM2tCLhtqIXeYvp3bMIvyTmAEZ46xVsk49pUKLngD81mM3JLe8IHI1l+
         iTArGrpteXUzR0YPDJjNFHOWSHkm4r4eXpFuXYcgn/QTx3X7vbD+VnoaUEuC5zblcgOx
         hCIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731056991; x=1731661791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3rCuCRkF0AD6qgQEhq9OgaioP0iDJV1z0RS47lWOzG0=;
        b=B+9U6u8bjvCJ+sC7Zkb81eaDJ08BOpA4DjrB7Hhzo3NDx86N2ia5mSEh/x28RCH0Q8
         6k8jMPzahXoVAqM4ESoxHDL4tM+D9Go+p1PdAp6tEz2KWWcuDxPgCEXxnA6MdvFut2bW
         gbS6L/CJMV74viyEn47/Zbb9/Vh/W3aOvrerF8VGhlqPPCvFBcxDCURqwkQ5FNYQ+ybW
         roODsYnjyrc6L0ijQM4tEziZ8I5+Msf38T2/Olrh3+77zchKbJE28HcJLbazTeO1KlJa
         1dS2+OEMVp0GLzboPLzGvgtpOIvwKKO3Ed0q+2ojz71F0IXsuEowdyaasKwZoMrP+azZ
         csqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrmyFjblDR7MR3fDJoPuKSUUq53Eq2Stb/DdxVVWJCFCdtgCS7mP5tC+ztU/j+SCdiT793adPM@lists.linux.dev
X-Gm-Message-State: AOJu0YxZUn1KRdvbLBIVHatANrPSOxv+Liqs9TRUF4nFiPKSmOx1UdAq
	YitoBPMBCHhJmvpratewkKK6AMMLafHnnqSqI2CvcAWUpz1rMl9k9b7xLqZix8FvTU216J+UZn9
	pwUiuvJNT88uVdjnJEIwT5ar8qKYJRiCarFOoaA==
X-Google-Smtp-Source: AGHT+IFQ2rzdsFULikcsy1DcIOj/oaXCux6Um5MzvHa4kWe+1hKya+Pibd3ha8YnWK2f1twBBu+uljiRcC195WGdV0g=
X-Received: by 2002:a05:6102:3f09:b0:4a4:8651:3c2c with SMTP id
 ada2fe7eead31-4aae1686ad9mr2324623137.20.1731056990954; Fri, 08 Nov 2024
 01:09:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106120303.135636370@linuxfoundation.org>
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 8 Nov 2024 09:09:38 +0000
Message-ID: <CA+G9fYvi8fy2muefm9GbpO806oTSBQjmoEQriWD0OyKU4s_K+Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/110] 5.10.229-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Nov 2024 at 12:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.229 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.229-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.229-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 5d5f7338c1ba5235530d3a6b68406996feb2f021
* git describe: v5.10.227-164-g5d5f7338c1ba
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.227-164-g5d5f7338c1ba

## Test Regressions (compared to v5.10.227-53-g11656f6fe2df)

## Metric Regressions (compared to v5.10.227-53-g11656f6fe2df)

## Test Fixes (compared to v5.10.227-53-g11656f6fe2df)

## Metric Fixes (compared to v5.10.227-53-g11656f6fe2df)

## Test result summary
total: 59570, pass: 43633, fail: 1918, skip: 13945, xfail: 74

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 102 total, 102 passed, 0 failed
* arm64: 29 total, 29 passed, 0 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 23 total, 23 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 25 total, 25 passed, 0 failed

## Test suites summary
* boot
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
* kselftest-kcmp
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-mincore
* kselftest-mqueue
* kselftest-net
* kselftest-net-mptcp
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kunit
* libgpiod
* libhugetlbfs
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
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
