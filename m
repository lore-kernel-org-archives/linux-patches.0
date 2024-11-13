Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F409B1FB897
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 11:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731496209; cv=none; b=SJFOXmKenrPne2UAWL9IXd8/Yrn0zev9/g4dO72PGZFBzh20IYHFTrubLvmhSfhysaam/uF9seD0f1pMYu8epudPE/GAyQR3pflUhbgfiUB9sEvnaE2j2nNmEtRLTJLD84GLE7ByQ4zP4YIfYPCNuxBUhiwChJkuqozKhQPq3z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731496209; c=relaxed/simple;
	bh=o7ZakQlIa2lYgRR3nNgwkZEcN6aiF+WrAxBCWIkUVWM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WbhkxGnIVjxoYT2gEz1wugFRUw5WxSx87BDhx4TKPIwV2ui/Hmmd5sWu9YeWWWHtDKdGWwm5arwhvXEKSCv8gZhdlSwgh/LKoi4txnzVOn95aWJvmzYQ+nbGPesi36GRzUFp+QAGXSibTfqugQ5YU2iyyqmD34UHUnj8AejMJyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KJmWMGSK; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KJmWMGSK"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5139cd002b7so2696742e0c.0
        for <patches@lists.linux.dev>; Wed, 13 Nov 2024 03:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731496207; x=1732101007; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aLRHbq0yedycOi7moHqeorbuEFrpPo0av/ZRKrfN6MQ=;
        b=KJmWMGSKzH+jCPG54KNGnIqJutm6aE8iNnAYIbHZwE8bAhbp35HJF9qYW40vgr7OwC
         i1wB4Tgv7BZFjOByvcu5PLJEFImi+3XfPb5vXH2lwps+mde0H4aUtOxp3/vBHN/2XMJ+
         iTBkeZZsylmH0xCUDW22uNyYH6pVqj2Axj9pyXBNnS0xdoyimPcDIZ3Db8r8TMOoPqYc
         eenM5oofRcdyaMv7RcLxWG0CRyKqfNotg6YKXglT+9SdGTq1HQGLt/phaYpSVvZxGzok
         wwtZP/U4c3L/yytgafyT7KOwSCczi6Z6N/dbRg1yisYiIGXN58nKpMkGV4zAPILKiRb/
         RtZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731496207; x=1732101007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aLRHbq0yedycOi7moHqeorbuEFrpPo0av/ZRKrfN6MQ=;
        b=idTSBp8OgKhYg108LhHkI5AmKOlFbWzP1qXDM/p77JuS9VqoOpQFKNKEfvx/SThpkd
         3FHOAtjpsWbAUBvCRTN5UVATdGYO89yEgYuQde9ZjeMqsbz+I9dI/6vLFO7FABvQQ1mL
         t6IMOHWMV8JETV18HcVAYpoYh3dkxmDUnQ0/Vl3H09lxEK+P/0G+UHzxeyp26fL4odPT
         agI1cEaNpj3z57rnhwHSFWQsxYHVnLcXq7Io6sVhCNygN29WapMh/m86no/+0xQgkpBK
         KZLiTAB6jVZdp7TVc8vS41NVg0lGh3kx+mOO2Ys0JL11Bvi1pLjyDVYhKNEu/JRbRSDp
         2yEw==
X-Forwarded-Encrypted: i=1; AJvYcCWdVCXpNjth3ula8VJ/9BpUuDBsVwQ14dkEtD+ojNMqDW5wAFhZohz6gkNs3GuuijW6Ry8ZchOW@lists.linux.dev
X-Gm-Message-State: AOJu0YwAoTKTnTkxwCAAEe1cc9BaOyLi95Z2VdW/Qdq6FHlZZPjk70f7
	PJoIOvDs2q+jjpDh2b2yHp3Yu/T5NYvnbkYJlwyYoqm1Va/HX0rp6tIk0vktpo3aPHkmssFyON/
	q7GlpgkKlaNl7KOcq3XbXF4HCUZ3BbtORaElGQGMm4yZF9oZdk6M=
X-Google-Smtp-Source: AGHT+IFYtql4PZnERxqsx1iVt7t5SNiqWamwYFmQtWq0EQx64r3jMppMGLMQpLIRJQlVFtUDuYAk+p5YKLimNZuqqvg=
X-Received: by 2002:a05:6122:181c:b0:4f6:b094:80aa with SMTP id
 71dfb90a1353d-51401e8d209mr20290230e0c.9.1731496206871; Wed, 13 Nov 2024
 03:10:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112101848.708153352@linuxfoundation.org>
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 13 Nov 2024 16:39:55 +0530
Message-ID: <CA+G9fYuvsU3hfJd_3tDsv1HpB_hBPTpzcyGqJ1bRhUcwmhKMjw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/119] 6.6.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Nov 2024 at 16:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.61 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Nov 2024 10:18:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.61-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.61-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: ba4164ffa865e6dc8d86c0605cdf762aae20e49b
* git describe: v6.6.60-120-gba4164ffa865
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.6=
0-120-gba4164ffa865

## Test Regressions (compared to v6.6.57-484-g2daffc45f637)

## Metric Regressions (compared to v6.6.57-484-g2daffc45f637)

## Test Fixes (compared to v6.6.57-484-g2daffc45f637)

## Metric Fixes (compared to v6.6.57-484-g2daffc45f637)

## Test result summary
total: 207451, pass: 172242, fail: 2343, skip: 32689, xfail: 177

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 257 total, 257 passed, 0 failed
* arm64: 81 total, 81 passed, 0 failed
* i386: 55 total, 51 passed, 4 failed
* mips: 52 total, 50 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 64 total, 62 passed, 2 failed
* riscv: 38 total, 38 passed, 0 failed
* s390: 28 total, 26 passed, 2 failed
* sh: 20 total, 20 passed, 0 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 65 total, 65 passed, 0 failed

## Test suites summary
* boot
* commands
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
* kselftest-kvm
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
* kselftest-seccomp
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
* kvm-unit-tests
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
