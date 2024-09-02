Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4E91CB51D
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 15:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725291517; cv=none; b=en1KIWWfMPzuhdDvHX8bb5bxHtz04sbJw6GieXWs6JILpBgNvTVd0WMLU2xy1DWfD7O2LDT2g1JZGlSt5WlCMdpl/xs2q3CyRoPMkFd2Zln6WBgS/6MiOJtLthibofc4+o89rpsBGcgKltuekbEQSrfyub6QJMvKJfBi925XaQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725291517; c=relaxed/simple;
	bh=+nfLd6UxJsEWwMxHZZj/0lyToCpTA44CP5Z+n9QIWTo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K0vrbq4civ7SzWGdDH0oryoJ4Xm2rGrkDadzbu1HX1o4DIu0cZTVB+u12fMfybMBSikF80Img282bRQUT+z1/Jc6hNjABL5ddZMAqCz13TZugqKvElUVYGf99jyDQsT3sTy4KsCT4yYOXGPwai+DgLhY7RfsrhxiCO5pe81rt9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EoHnxxRT; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EoHnxxRT"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-4fce6fd54ebso1924586e0c.1
        for <patches@lists.linux.dev>; Mon, 02 Sep 2024 08:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725291515; x=1725896315; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SkFbpUnzf3sssS4aIyE4C8Gye+7dq6aX/LwYe/LHKK4=;
        b=EoHnxxRTv+waMwH2pyzXqDZv4tuEvDnO1EwvERXC/9fGjaj+zL40sZbGs3W0PJJ106
         CAJFZHbNT1GmiFXftGfO2IDxvzI1h0IjpuQ82axAViFvOYUe7vJu7xN97DYdBOyGLt4h
         3y6uUh8IAaaxyJJVc+KRqaFIGxZfPBqgApGqCQtzPdlFloWMzUS2IKL8j2DrUwJiP4vw
         r2iPxrn8myZm6aSeFqFGUVrPFBHST+Kc/WkdHfNNLzjxiSadmQRzIKxYyRO7zDG5QUYt
         Uv/IvoQZbXM9KURxyX3b66qmKBvwjUY6W497MrLAKPnGLjuXiuagLgsZPumvRGS7tI/c
         cHRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725291515; x=1725896315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SkFbpUnzf3sssS4aIyE4C8Gye+7dq6aX/LwYe/LHKK4=;
        b=jmhZ3LaV681qfWiD/s/SS09vapWr14+Pl3Z3Vu+vXTrC3h6aXgc9A353ARjeeh37k9
         GykLFwgUjt6+fNwZvAPFGlSc7GgZV6RbILRXjcbLvw8Nn8AYEtbl00e1jDOWfk0RH5r8
         ReG9LeqxQVTWP3BXYXx8krAvQ7U/RJzKsoLDAtxjvjULLs3XzaXBaj3o9b1kCDFfT0NW
         /A5xF7unoiz0fCeBMUywYvZfTCcdzYPSf+Dsa13SLHCPlsUF/n6gZJixHWVRbMDwO2+f
         yUxh8hBYOm45QNmPuA3AXzCWFn7pvEa0u7QmG7lVm3uuNDek49OFW5olCBP5p0f2aL2u
         58ow==
X-Forwarded-Encrypted: i=1; AJvYcCVoLGMEqCm31Ba0cvKKpDU8dyqE6nNCg2r6ohA97axqUQTdWdK7w2Em2MlpYhLI7/AYL10ZiJ2Q@lists.linux.dev
X-Gm-Message-State: AOJu0YyXfQt6wD+u25cbPiEQzbK/vcGaLZDwicz+KvF4t0HD5JYq1uuF
	XjlEvo1CpOgjDUU+RQ2hlYitcPCeskaiW4DuxLEnY+quvc0yIePMFE/hg1E81R14V/YccmXME+f
	F/HYSVN4JKGeJ9YbQvTmPMXcBVdMRbAEeK6sbkw==
X-Google-Smtp-Source: AGHT+IEFiqCPj5ClWa+oAUuBhCOBhK8IXXtwLicW2kMJMvr8eV33HNEKEAufefXW9vtva1PNWsyrq8a7E/8QsHSq1Z0=
X-Received: by 2002:a05:6122:182a:b0:4df:1d06:eeb7 with SMTP id
 71dfb90a1353d-5009ac02acfmr8471169e0c.1.1725291514630; Mon, 02 Sep 2024
 08:38:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240901160807.346406833@linuxfoundation.org>
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 2 Sep 2024 21:08:23 +0530
Message-ID: <CA+G9fYufnSwnzUdu9wNfSXAw=u6CPnvhYWcNpX8V41h_XatjDw@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/93] 6.6.49-rc1 review
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

On Sun, 1 Sept 2024 at 21:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.49 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.49-rc1.gz
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
* kernel: 6.6.49-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 8723d70ba720be0b854d252a378ac45c0a6db8a7
* git describe: v6.6.48-94-g8723d70ba720
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.4=
8-94-g8723d70ba720

## Test Regressions (compared to v6.6.47-342-g0ec2cf1e20ad)

## Metric Regressions (compared to v6.6.47-342-g0ec2cf1e20ad)

## Test Fixes (compared to v6.6.47-342-g0ec2cf1e20ad)

## Metric Fixes (compared to v6.6.47-342-g0ec2cf1e20ad)

## Test result summary
total: 198423, pass: 174521, fail: 1723, skip: 21956, xfail: 223

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 19 total, 19 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* kselftest-x86
* kselftesu
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
