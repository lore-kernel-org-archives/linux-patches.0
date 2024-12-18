Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C686F1A00FE
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 13:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734528772; cv=none; b=DhFbSOdrfbzbbwqSWZF/wdIB3yHd4NfSMo3nuT+gQxT8G3aYMtKeyBZod5KhRur6tm8WsPlINNr9uyQ/Ht5WuOWfU+UDFv+ckood4KEEXNxcncX7Ejn1HqTDMz2wGDHChroT3z7QpYrSSs+fKPHBUSnLdO69ppy1eHvTZIXHY6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734528772; c=relaxed/simple;
	bh=G5/soJifnSaX1ND1QtoXn3IjtMRSp9uGdN3QmqPu4No=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=evEfRvKlTSz31C0//HsEsboXTpMZkJ3fQQD+Ycc8GaV7IdvchfnQdzAsjPxnAYBC/Fuywr78sZKAKbvR3OIbzy0T82WcWPuyFDm4aNpFmMbsIlwnI3MvawVNuJIOjCjh2ZgyXY9auMy7VWx9z57yp0klSZxH3E32GCSkdEu/s5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f7FPjlFr; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f7FPjlFr"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-518808ef4a1so1906062e0c.3
        for <patches@lists.linux.dev>; Wed, 18 Dec 2024 05:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734528769; x=1735133569; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUnvniu6hhiToDi2KkXkauo96l6qkrj1MUqRCRa1hWg=;
        b=f7FPjlFrVPhWGIQVzNl70uANu1HtOPicN+o2NcJSSTFVPd5jnGIihpPdl8Jhxgb3oV
         yHAR1SvRS7idpDOjiXmzBCBgkHCYgKwzCvV+SeRetzlzKcOI5MRQEiCsblgN3qLH8ImD
         mYz0I+PyBxQkqCBWLEKaWsE/epWFC5YgkVoYf884nOP3M7HS059JeLIfCxoaEseT+i13
         lQRgPqD1GXtI668QRajru5Q3ckYBWKl3REZ3BYtxqyYPG4J5GlPRYOo1jPFjR3fYwc17
         EIzT5Q0e3+bBAH3vHkiPRNrq4RnkEN6E67qYtBkdkN+fwuLlklgk5rr5XWTUle4CTORw
         Dfxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734528769; x=1735133569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iUnvniu6hhiToDi2KkXkauo96l6qkrj1MUqRCRa1hWg=;
        b=PPIKikFiQDtFuHLZPB/npw7iFuD5cLgHUJiT8FFDstdPXkapVIiQ/DEePxUPVDEIcl
         DgAtZTu/tFwFq1PUL8zJNKzSZ7q6fXbHPiVK5WrSTx5TaeWK3jKti1Lr3l5R1zyU/ALf
         8rLtt61DvIHfailUY/UJ3ubBt44Hr+f2NyAcAnk9o2g28KvrUxAzMAWMt3VEEHwFA45d
         iol1S0jDftr9EGks4WKdLF9jJRwAwYw0NfCi9X9ENxJBdaarhtVOnlo7BY8swKUJ+edk
         c58pykMpFqrFtOrJDB4SCqjMPOaSJKMV/h8GhjkPkxVlEt9Erlgk1SEqXtCFr8uQAYCW
         Xnew==
X-Forwarded-Encrypted: i=1; AJvYcCW+JAY+cYHsrcBN7dV0IrvmghmDmWNc1vOjSCgHlYFjRwWqut/puQ9zKRaUpHxtFlqIlxei6oJc@lists.linux.dev
X-Gm-Message-State: AOJu0Yxx0ZAHTWRn0VnnnHWXYMHp+MdGwRqg0csWLyNInpvrgPzSkfeH
	yY5K/Sl1LqXNI+ISvM9Uuadw+kUX29Uy/h9w5uyYZGBX+eSSYqhFo1fc2w69wQI0iDI5/aVw/L5
	HVrt4en2mfZdadQzUI+DUx/0lKQirZm3uPCjeWw==
X-Gm-Gg: ASbGncuLoWDVl8kzY/3pDmJHbtXcI3ia5wm2DcdC/vPxdJhKoba0rjMAM5s1tCeE3MF
	i9A3zEhrLc8AP4LUnnsHQFV6HryqJjYj7rblliPI=
X-Google-Smtp-Source: AGHT+IFrn3WMYPlXHzUXLRGTfPnAsmK0F390EDdRR7M3D7ArWGAYU87aHLoNK3kNirhAdSej02oJOftv/JXTu7CbCWE=
X-Received: by 2002:a05:6122:d0c:b0:50f:f21c:4fd0 with SMTP id
 71dfb90a1353d-51a36d4c76cmr2707332e0c.8.1734528768665; Wed, 18 Dec 2024
 05:32:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241217170519.006786596@linuxfoundation.org>
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 18 Dec 2024 19:02:36 +0530
Message-ID: <CA+G9fYvTZPHivc_QD=Y4o=3o7OBCqa_f5BHUpT-FGjBJnifsLw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/24] 5.4.288-rc1 review
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

On Tue, 17 Dec 2024 at 22:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.288 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.288-rc1.gz
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
* kernel: 5.4.288-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: b66d75b25fae4e086d9f581b37104ef233989897
* git describe: v5.4.287-25-gb66d75b25fae
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
87-25-gb66d75b25fae

## Test Regressions (compared to v5.4.286-317-gce5516b3ce83)

## Metric Regressions (compared to v5.4.286-317-gce5516b3ce83)

## Test Fixes (compared to v5.4.286-317-gce5516b3ce83)

## Metric Fixes (compared to v5.4.286-317-gce5516b3ce83)

## Test result summary
total: 42127, pass: 27773, fail: 3201, skip: 11132, xfail: 21

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 132 total, 132 passed, 0 failed
* arm64: 32 total, 30 passed, 2 failed
* i386: 20 total, 14 passed, 6 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 26 total, 26 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 28 total, 28 passed, 0 failed

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
* kselftest-x86
* kunit
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
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
