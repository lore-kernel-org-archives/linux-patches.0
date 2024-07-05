Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0C827452
	for <patches@lists.linux.dev>; Fri,  5 Jul 2024 05:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720156783; cv=none; b=s15RFukErrPFI3o98NCP2GeWktlxPQ8QLJRaDR+YCWOMXA6JHAghzKCClY0HPjYxdi3tOanQCBuZet3qOaR1mtvLggPP00B7wQXg5iTECCaSfs+5aPsPS9deE33aF9OpLUPJtPQbbhBQzsU2oj+dT4tQ+8i8CeB81hiL5MI8fO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720156783; c=relaxed/simple;
	bh=W5j6a/WBCFe+fGsj0N2OEWSozhjt42IaZwKXVEvzDIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZfPIM+uNvgpzWj5yre9X9+vQnLEbXQrw/aY3PcZDxrd4XYkHxbfT6AkOfea3wuSdVhQLUUn89QHImYr4baQaj49dvLLIuIQjrOI0fQd1u7wxtuYcEVeO6DjALu6mWhL7W6lI+CjnRVtZ7foVMr3d3ZnP5XJdOHKfXijH3ns9QfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RH19/VSs; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RH19/VSs"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-4f2fd568899so347672e0c.1
        for <patches@lists.linux.dev>; Thu, 04 Jul 2024 22:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720156780; x=1720761580; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Rbwslc1YUoORxX9xF6DoNOsXrVeWvYykz6W0DdakVY=;
        b=RH19/VSs7U9t7IteBVn4P4/EdBdIZyQeuocGgP+T124atcfFDnpO7sBoHXamvwk8Tj
         233UbS4Qsnf6Pb8158pYW5HsH9d5PMzOT0AQ4gQB2ENxot34bKgvwBCE7xO9LAQfsr6F
         s8jFTm2bQDZwLmYZyh27V74XEFjsE8fkgGF5GPnLCoZXTPOHJZdwxMIt+W8T2Dk6n/hu
         DUW0FezpRKxWF9gF+iXILtLTn9mFP5H/reEGT761BFzyQChJv3iVFDysCtGBChO2qpTb
         QB7XSrRQZoqa9J8D1ohBfxMOJcMFjcZLaTf97oiQwG3OpwERVrFHn5zXvDFHo+AhzmLp
         9EvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720156780; x=1720761580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Rbwslc1YUoORxX9xF6DoNOsXrVeWvYykz6W0DdakVY=;
        b=fH5pVdKdeMrsq/45UUMUcNF9xje23N+2rBk88yuDi8aU2ggwtgpMcNtaX8yu80Bbzp
         z9jovVuJdSjveMhhzWk9/GvEvNLggqWxVEYS/YsJmA0oG2NJlNnnOsCZrwAkQa1obsFh
         kUeXVJT+Tu6t45zgbzRXtd4ZTVYhl9w2lLHvRnSAnViEGAtFCmwKrfSZDMmAfZWh1DbX
         eLRjPjpmGcw4lXztnudXFT0H3+Qi7qUF3sK8SbYk0hDm+9ehhurruP7Wua6b7ajDYJNv
         irJoOROZ3XeyT12HvYr8hD+G5hxepItIRIED5XWhlrosgAcSrK3qFXPG5We4zWXqu5/y
         FV4A==
X-Forwarded-Encrypted: i=1; AJvYcCU0y5JRYwtvdz9D3vJTf4nO8gil/DhAg8jl0z5jf3IBLkED0uVnj/3uBplS6t9MFIY7hAyD4wP8pL4ydJNUrFQODa3F3cdr3Q==
X-Gm-Message-State: AOJu0Yw4iIih7Euu3/518lnmNycYRB5dO0NfzULqfnK3DA4vGfGGoTaP
	9zTnX17wr4LfF0P6cXS6oprTRH4Nht3KBzI27NWRFmRev94+OJ+RZxcH0UU2vlVcwRKRFoRkvRJ
	WyWE8aM9aiolPIEl+RrCS81yPZtZk39+mMLco8A==
X-Google-Smtp-Source: AGHT+IHMRf4CngznlnyynL/FplZL4zyIqzXKH4k86LNrfkWCGbFINlqeWFxDl3dSH5R2X9FxGJlmheib+X0zUJf5GlU=
X-Received: by 2002:a05:6122:4a14:b0:4eb:554f:20a9 with SMTP id
 71dfb90a1353d-4f2f60f95cbmr2318873e0c.5.1720156780551; Thu, 04 Jul 2024
 22:19:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240704094447.657619578@linuxfoundation.org>
In-Reply-To: <20240704094447.657619578@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 5 Jul 2024 10:49:29 +0530
Message-ID: <CA+G9fYtpctyKVKQUjNawKNSbsu_TrsNuoXKVvWtinBN4KHu+fw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/183] 5.4.279-rc2 review
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

On Thu, 4 Jul 2024 at 15:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.279 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 06 Jul 2024 09:44:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.279-rc2.gz
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
* kernel: 5.4.279-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: eee0f6627f7476f90ba9520fce5a25563c0c4d9a
* git describe: v5.4.278-184-geee0f6627f74
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
78-184-geee0f6627f74

## Test Regressions (compared to v5.4.278)

## Metric Regressions (compared to v5.4.278)

## Test Fixes (compared to v5.4.278)

## Metric Fixes (compared to v5.4.278)

## Test result summary
total: 135814, pass: 109531, fail: 2397, skip: 23766, xfail: 120

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 33 total, 31 passed, 2 failed
* i386: 21 total, 15 passed, 6 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 29 total, 29 passed, 0 failed

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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
