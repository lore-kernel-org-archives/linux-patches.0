Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3C37D405
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 19:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722454198; cv=none; b=VYwQQZstX4yFO7bALa5U0Q13YF76MaLv3Q0cO/wSsjxW6phLYz1EyLjVlq2uGE1tCwWmwQcVNfoNYOgC53UdrSa1/71Ohj0bKS1bCMaM1EsWZaJ8diIA4+QRFrkV6MKWuPo5XprzLkfu3pD2+vSAMgnWM0vck8ZZKfCr+yOsgiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722454198; c=relaxed/simple;
	bh=8VEBFafnSr9VpBkGUOOfJzMmeWvifxk7DLlZrSgU4b0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ACeco+f1wOyqYykiSTR0um+qwfwGrTEbP3W3vaqYXJy3OCjnuo1sc9ycSh1LvLkpr8XFB6su2WPVEDotfM8r8vkQbUphVQ025kuIJG3/KhI6EZ0PdUdDuSFlmRbzDpLGGP6ah/lkZrU6eV5wjuHb8E9vMM8fOSpXkrk9MZOwVeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O6y7Sr1r; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O6y7Sr1r"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-4f6ac477ff4so3316930e0c.3
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 12:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722454196; x=1723058996; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ajHV6NX4xbC0/X/XUlTpJgiJmCRqspyluOYbTikblWw=;
        b=O6y7Sr1rfmHUKbiPAH50rn7QcoLl3wOvTTe0S1OAukQbwobkuc35pPE8Z/cuLyu3WP
         PIiAO+FFaJ4m4RffonxHMB/cOD5o93uO2GbmjJUvPOWL7/Cg6HMmbqJU9j6PEe+CIUdy
         hBCjchoSROdZH4XMKFIInoRkzsxFVNT+2dI6fJ+wSC04ChE56zM/q5g5lNyxfydzTz7o
         SEYtDKmDJUBMfag3tGOgEtD9Cd1zf4E8FJSJD8s61SLYJqFhj+JEtDFLz9fV+E+qSUbW
         wSHeorvMc3dzOw2BlCaZreMjKok2cYsf8QUjxdlWProKO/t01vmKbYyEP9VPX+ZclKc0
         8iCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722454196; x=1723058996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ajHV6NX4xbC0/X/XUlTpJgiJmCRqspyluOYbTikblWw=;
        b=waKE8cUOVg3vk3DIGoLQvV7Qp6idGsMtAwik8fPNvxEvVX5Hgzd5Yv8sA7c8zDW0kK
         7UH6umonyytzk5xBd5/wvmx3zzsoEoGpYozJ526ixESIWR++8G6/zb5arag9t4o8pCYE
         eQKiWZ86PWO3Rm0qKowqzH4PebvhHGhfPh6nyJ2PqT/1OoVQBzjAH5PYsikmowY8ZmqX
         o5XiBYWDWEPMl8U3u+CyuJ/vifqIEURYCtVbPVGfDE8V0JGsXkweLcGXgT2uyqn0UzZS
         AX9udSlnW7lu24dSQlWu8BU92CampAF8ESfbTEBode+rB/ErBsqfR69VzG3dquFBkLGt
         +B2w==
X-Forwarded-Encrypted: i=1; AJvYcCWbDLy4wXn7bjSbm58P3yFwrDYa2GpCgKbJULfxy2O/XbQMHx8/bXmT8s3gA5qTXq8+Fo8KPR6M6E3++Uu+hW4VuKPeXitv7Q==
X-Gm-Message-State: AOJu0Yz8VcXcUeyZPnbg2U6PKRbszusuI2cztZ7e3a31J+/GAJSwHen7
	DdfI2mPz6jMWudusENNCDNiumn5lZkU2xou93NGQ1SF+MfieG9WWmfW9U577T+EvdfKr9Ju8E5+
	xDTD6pVPNuQJiiqUkcqzO0z8urfNsJaxhYL6kzQ==
X-Google-Smtp-Source: AGHT+IFGOh29LmDbgQeNaPW8BywZKqEMuxk4LG7u9wPcpkJp43UNZWjn4ROEnmMSCiHxRRMDEiuIuZJG/HI/Hu5JbdQ=
X-Received: by 2002:a05:6122:3c52:b0:4f5:21fb:5e49 with SMTP id
 71dfb90a1353d-4f896714753mr489423e0c.14.1722454195700; Wed, 31 Jul 2024
 12:29:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240731095022.970699670@linuxfoundation.org>
In-Reply-To: <20240731095022.970699670@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 1 Aug 2024 00:59:43 +0530
Message-ID: <CA+G9fYsf0tqqUqLsMAZuLhhPVJaJvX7gw7nhdsbScntYVBLMXw@mail.gmail.com>
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc3 review
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

On Wed, 31 Jul 2024 at 15:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Aug 2024 09:47:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.10.3-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.10.3-rc3
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: df6b86a465e839f8a9912c0de79b3c5681d0f1d9
* git describe: v6.10.2-810-gdf6b86a465e8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.10.y/build/v6.10=
.2-810-gdf6b86a465e8

## Test Regressions (compared to v6.10.1-30-gbdc32598d900)

## Metric Regressions (compared to v6.10.1-30-gbdc32598d900)

## Test Fixes (compared to v6.10.1-30-gbdc32598d900)

## Metric Fixes (compared to v6.10.1-30-gbdc32598d900)

## Test result summary
total: 418796, pass: 365615, fail: 6357, skip: 46059, xfail: 765

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 254 total, 254 passed, 0 failed
* arm64: 72 total, 72 passed, 0 failed
* i386: 54 total, 54 passed, 0 failed
* mips: 48 total, 48 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 68 total, 68 passed, 0 failed
* riscv: 34 total, 34 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 20 total, 20 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 62 total, 62 passed, 0 failed

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
