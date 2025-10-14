Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F9F204F99
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 14:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760451074; cv=none; b=l+Gcu8oy9O92aYC42dvAgRuj5JD23xaduZ6QffH+Wmx0bednGR9caDYc6Wv78DfucPDaIx5v/K1pXo22TkNM6Wdmp/gYEnN0/OYii+MmOYpKxtcCyU/zqwxrujW6gm5Eht/DZt6bXXPPRFRjflha1rL1OSpVOWPtnIQi3D4oe94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760451074; c=relaxed/simple;
	bh=kGoX263RqUSA0Us4TMFi2bOCy/tmZMWLysxu0CI0aVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yr9k4tcab72MWdANloJkQtF3cx70FrC5ucsYigRHYynBRyX0c6UE7iateY+jRnMz/eaEmKOZ6hTVWFof8bS+JCbKzp8OulPyXlE77sDbJzVabXvNg6LrXKazjiC2kN0g6wPuXX0EIhbE55dxtx8lwu4lNzgw1Xx/YRed4PRo4PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d0a1GVwp; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d0a1GVwp"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-27ee41e0798so86521285ad.1
        for <patches@lists.linux.dev>; Tue, 14 Oct 2025 07:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760451071; x=1761055871; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JMdkjQGuLT8DWGyEwUDOwwNR4ew8j/yyQFeLk39r5n8=;
        b=d0a1GVwpnWYNbkjHMcIxItNa9pGKtnghRJ9hvHMBmUDr41sHWnWtdeMaXsZwNc0ZN/
         1VlYNbugqnCyv6aVNJQaWDj0JZ9ZKoquB56nLE/1yPrajXl7kaWPCzOsxi70iicT7Jiq
         qJRFoQHLJuLr32RyGtJlwP1DZTwOZHiam9VO+nI5Nu+9x98SBZPzK0ua88BzkDnQnjwz
         rGOO8JDoZyUnG9G43PDAinyG00G7Ca1glOSa1q8m4lVEnRmL7bfiq2Oca+6LkgrC6PgQ
         /csXW9GZcpvMg+IKlSIpAfqcuFKUY3BE9DMD+/IwK9oxxt5w6kaVehzLlSmojVe+Ac97
         DhoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760451071; x=1761055871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JMdkjQGuLT8DWGyEwUDOwwNR4ew8j/yyQFeLk39r5n8=;
        b=sNAXl5tYBeipCSjgxdmgLoYGYRlJg5RXaa7CdMncHuOT+/0j0nNAdE0ZVjyv7W02Bu
         KsHbyykwyFbgDSG1PTov2G2B5bfMf1dmxqYCk9uSmNevt6J5yQalh+jh/ETjkQUcnw3r
         H3TZ4QYh1IbMPLvC67paccEQsgu1H29d4I8APhXTg79qpAFMX7Udoc+799vCi1NWkHM/
         HdYKese28q5v91A3HqGbyjPwVrwKeJPvT0sMqIX9QB6TbClCY5CKY2d7XpgVEUZXJrFZ
         O8E9cBXh2FWH49YGhjksRUfMLZMjyXIxIlNeww8ul/6u0zGK0fK03xW2ozbm0k1gEImd
         dvlA==
X-Forwarded-Encrypted: i=1; AJvYcCUAdopmHsZR5988ewX5BIWL7qelLNgWA6+R0HeGmptvymIVnOBqe6WbYgEjhtnSwaK6Wjoz5ufo@lists.linux.dev
X-Gm-Message-State: AOJu0YwwS4CHOXjbRoHzM2vZhg9+KOTCvol77T9x+oP1XWQSn7nXx1xg
	LdhnZyj1VXw9DYsqbOl8EPVgeTNXQ0Ds1rsBlGe0v29tlRrFa+W16d4IcREBMv1lru44HmH2VZu
	Hb3cR2TkFuPEFxseyd0b2dVp6PdI0XcoKOgp2baBcoA==
X-Gm-Gg: ASbGncsjGJE/IoGGsbRCXKHSMJ7+Y0IBFIfDQqSMc+JpLN5L3KtNvf6msBAPQNeTcIp
	Tk4gTAJpu1vjftqB/Jpp43xZpZt6s7T3G0NS7Qk9XXImc6PqquCxytLWfVgflJhLiFWuKAcHcgF
	Jjqo5FGbr+UBBN/i8+DyTB8VmBw+5MC7f0r1+P2tISFgjwF8KOkKE4yrD9K3P8mFMMYMXWGVkf+
	BOfIXOffaQKAH9NaqSDMABu61Niij3av0yN8LLsBOAVmQ6tFHq6Wmz5VuFFRg7KeiL55bIU4Y1a
	J1N/2vSs6v+cClt0Ha4=
X-Google-Smtp-Source: AGHT+IEmO3Gx7kyNMt4swJ3QuKQ7vC+f+1MMBbTXoKoGxWLCLzDt+Rdb17spwAO1lz6MtUau1lMK55g4bVsaq+j207Q=
X-Received: by 2002:a17:903:2a8d:b0:24e:e5c9:ecfd with SMTP id
 d9443c01a7336-290273ffc74mr302431295ad.42.1760451070963; Tue, 14 Oct 2025
 07:11:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251013144314.549284796@linuxfoundation.org>
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 14 Oct 2025 19:40:59 +0530
X-Gm-Features: AS18NWASLVoxLmB2xetvxplEfjkLd1CWbBO3gda86sgaGChckjxYHNLEtw-8DeA
Message-ID: <CA+G9fYvYE5+zY6CiBx1KWnf+W5-4cbZebSciAuh+TAc-6oV31w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/196] 6.1.156-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Oct 2025 at 20:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.156 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.156-rc1.gz
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
* kernel: 6.1.156-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: b9f52894e35f79b1ab1c988d4202ddf668e35032
* git describe: v6.1.155-197-gb9f52894e35f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
55-197-gb9f52894e35f

## Test Regressions (compared to v6.1.154-74-g8a8cf3637b17)

## Metric Regressions (compared to v6.1.154-74-g8a8cf3637b17)

## Test Fixes (compared to v6.1.154-74-g8a8cf3637b17)

## Metric Fixes (compared to v6.1.154-74-g8a8cf3637b17)

## Test result summary
total: 99093, pass: 82935, fail: 2925, skip: 12977, xfail: 256

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 132 passed, 1 failed
* arm64: 41 total, 38 passed, 3 failed
* i386: 21 total, 21 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 10 passed, 1 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 32 passed, 1 failed

## Test suites summary
* boot
* commands
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-mincore
* kselftest-mqueue
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-x86
* kunit
* kvm-unit-tests
* lava
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-capability
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
