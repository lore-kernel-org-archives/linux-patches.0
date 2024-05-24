Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BCB8562E
	for <patches@lists.linux.dev>; Fri, 24 May 2024 09:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716543148; cv=none; b=CqTWOTmx1g/cuatpjD0UOMWpZH4D7JGfW/bPEWcqUx6psbu3TX3EFFV/1czfM02+GNTEEBmpntg+lvcZ5vUqbTEpw4mdjPvyD4E7JjCoKwX/Dk6d95SYDtw8klHCyipXoIhnZuZN7JsshKve0kWvdf9PODm4GyYzke7OaaRaPLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716543148; c=relaxed/simple;
	bh=+r+3JkdoTS2WhVcXvGMz1cSz9823Vhc8c1KI2ioY+Gk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pxPigw5UU9BNdm5X/THm7BPeMe0BdX7kihvsghytMLzLZWZWKJQYcBsywX5QPVN5Umpe+Fa9WVRazexQ96fvpyn8LYtdDblMtt4zCxN3WQkLYdEHMthltjaxiAs/Ny44368sxDIAqMkasbxvdakpQ59oviMeALlfcFa6oLnnK1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oqUcaGbH; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oqUcaGbH"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-43fb02d7eb5so2897131cf.0
        for <patches@lists.linux.dev>; Fri, 24 May 2024 02:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1716543145; x=1717147945; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QobU3V4M9zLBH4ceWs5naausHLldCyE6Lvje0EpDn/I=;
        b=oqUcaGbHjjN+nIWIwkJamHA9e311VnhmuC2yPoAcRY540MrlHBmmScG/FYjSWyQAim
         2ia/VIpdCyqzKW0ont+8Df+SNYrKbRIfKxpmrLrR2tc5f6DxJPOIhSqzSohzpxV6sxrU
         pUduzT/ovw3tTTv+Sl4Umly3eG3oM5J/zPeZbM9PZGVBd8GYKPVT6HGrpGdl9Ai2zEE3
         WYx9ARsLbvhL6AwfaDXJ503kUeQjG1hgGFO+4S9dyyYMZ6seXqhFuoGa4tuKS0u95Fu9
         nqf1xSBY6gstBvhD2LF8Vv0kUq5wuWy9YNbzxnWsUgeInehntzalMDaiMr+MM2M5IcDI
         JJuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716543145; x=1717147945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QobU3V4M9zLBH4ceWs5naausHLldCyE6Lvje0EpDn/I=;
        b=kraJy69Fiz/L94B92LLTkgGHfdNIJZJ2+KrAJwjeGFZR++y+5H6AP8KxhptmuhZNIV
         /mdALLNuXywjkPHae/sAP5Gv00vGM/1792N43dHHh7EFhwiZtKF0E00tdaSMa3Jl/5Ek
         7iX1W8WyVu2vKrwVZK79RIFyNO9oMN0RrStTZ3JltStPlC8R9QwZVyvj/0D9iG5T+TLd
         jOr+4QhIkgxcb9aYbubLt1asSx0Kef2RsK7XfVykq5qvJwDbZj2TY87kjy6qvkuJa5OK
         8kx8tthw8Ugx+IxnhjOGbsSeHUoyLsF+9TU4zovkInvrZfuJgy+udrfiIX5BeeahmfQO
         YarQ==
X-Forwarded-Encrypted: i=1; AJvYcCUENYmsHrSOJao1JeGbAiejAhAmREpRQLha1QY8SMtjfXosJ1Bc+u/F58Q8WpVwTXJetNOTuWF6sASN4MScCwiMDsW72iDaig==
X-Gm-Message-State: AOJu0YzqR0iF6kLUfELInSGTtPDs2hHQfd4VvYJH1zS1KXw9FlPuCbo5
	NmDvMt/fpDueo1GhCkf5bb8gw/JOMgVF2kHuQr44N2Xn/2kC2wkGwcKGNwh7MXROZX1UpAvfAHK
	yGod+oR0NbYSSlE6fzRt2/H8dE5p3OHBDOwhRKg==
X-Google-Smtp-Source: AGHT+IFjoTKXgMDlyDzfnWuX3M1jKwtPOvvc+KZ+MYplITOHlLZg+z2dEWqjtafHvad6W6+WbomyBD93D2MSib0JiRY=
X-Received: by 2002:a05:6214:4903:b0:6ab:8e5c:e17b with SMTP id
 6a1803df08f44-6abbbc194eamr17864306d6.9.1716543144576; Fri, 24 May 2024
 02:32:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240523130330.386580714@linuxfoundation.org>
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Fri, 24 May 2024 11:32:13 +0200
Message-ID: <CADYN=9+OCBJ0qkoB-t7ECCS=c4rHf0YKNZmmYkvu1F9dfkq1Zw@mail.gmail.com>
Subject: Re: [PATCH 6.9 00/25] 6.9.2-rc1 review
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

On Thu, 23 May 2024 at 15:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.9.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.9.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.9.y
> and the diffstat can be found below.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 126 total, 126 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 23 total, 23 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

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
