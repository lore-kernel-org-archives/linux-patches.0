Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C263214A6C
	for <patches@lists.linux.dev>; Fri, 28 Mar 2025 10:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743156110; cv=none; b=qaZEKopftJHV7iWy2h9Ud/q+4FyRoz5UbqeyCNN+uQCzE7JL9+ya6rx3bxAmAOT6rvCJESYLSQ/J30Pv4+x00bsmxGBVm1yApeZACnPT1YbtlIAuBmNuL7mjldAiOsL6cbOY2aweN/cfwLGyhw5hzTu5w0CzapBxsSB/8KcIVjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743156110; c=relaxed/simple;
	bh=TAEdwrUyn9kPBfK7OOZcmsCuGPNnNLkqPPkNDGTKkj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bHQT0edBI8056gxaqw2zN9SsPKAXZZ6BdiYBqPAmVuN0WutV++uZRb/mrCgQ0R10F177cc3osDvBrgNy6IlpuNpwHhkroHvHUcL2Epx2H54iX9+otwdsb+oQHv2ArUIfollz02z2CHMBdXOnN0iUBwEQ3cPS0tC21Se8AFiI0iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pdtaWTbk; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pdtaWTbk"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-525b44ec88aso894077e0c.3
        for <patches@lists.linux.dev>; Fri, 28 Mar 2025 03:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743156108; x=1743760908; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hy0b3ef7tRBEX4cJpPaVoQh3iegxY1zj0tUH/YADkAI=;
        b=pdtaWTbkNJGqcwpVKja2mfqScDbcrQIr+/rzkj99zzqCatWPUTFrLdPvdVwsSy3h68
         grO8RyDFL7bjKyMhYQwfijhOhvGsfI0bSpkGr8A2u9Jv4lMhOPm+IfE576iM13ELvTqu
         NLp0XpVKl8Yhf0Fkow8QaTL5Lz+MIekj/IH6bKhStJGLqrEDfzcfmMdXZ+fg8pcBnTAo
         znpikuXYd/ZhpkrftOwEehBuQUASccRFhGs8R6qCQHo5Pxrb992kGjr+RcZMgmYOq1xq
         u0hoPrq5WxEwLX7joDDHOLrV/geiIiD6fXljoySWZDq++YXBq3gpl/cijpdPmMo5hAXi
         AH1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743156108; x=1743760908;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hy0b3ef7tRBEX4cJpPaVoQh3iegxY1zj0tUH/YADkAI=;
        b=eIwGNufOWfwIW+1fccYQCDvNKkwIz+RY+B8fNenQeaGt/Xq+awVpfPzT4eiAa+OX3X
         lNZvbR2ZZI22nNKhuwckZSxY/fKP8fhaqJ9nBB0KFxd9cEiphivrzZDc1NTla3p8KfIY
         nerMsg2kEaPA71A+Ugjq9ed+sAdFXJm47a05rwYPn/O+a85i1xA6Qzg8KQYAAClZcrtY
         ZEhP2Kg+8o7lXK+dY3WEwgzW9dhEjJWGZnm7BfzCdsFSOIJu5sFFw3O/IaNSBmJN+/P5
         P6M08X77gD/PWsIuSfnlPzNvBnT2Y8Gv7IUFSnn7Cc5JMKiWjUFOLeQCYy/rTMOTY/VD
         NeLw==
X-Forwarded-Encrypted: i=1; AJvYcCV0Cbsy9nt/ZlrXt8u0ioOmjuCjDx+VdcyCuyJ2jedLMBqV2uV7vY/uekYB4WwnLWe3FjxYlNkS@lists.linux.dev
X-Gm-Message-State: AOJu0YxSwMsjj8lOVW1VpsBFSNhY2Cid5QXWSm6pzXtBodudOp84YHh2
	7pqNmudh/xp6uDukm0fDlWa0q499+dGmCB8z4WfKU92MQMpIwquPyxjg5KN+8nPDvqZepPDI0FH
	YWdNboFwYQ7pTmsSnmHYVMSMBZ07/Xd/ysPGAEA==
X-Gm-Gg: ASbGncumS3qN0Zw9e8lB3QhgzvkeE8rEt9mbN6rHcU96Dk3SrlL06F+I4iguW/sbX2M
	a/P0rrCOuiFdotmN1vBwNHT9+wWVrRLnO7nZM8UX0v/KlfK9E49LWwr8Xjbhf1larUMc4cuVrXC
	MMqVs/hu1BG5hfdXqzXp4KtttIti2tSldCrRL08k0HOQsQAZHQ4cdTItHLVWs=
X-Google-Smtp-Source: AGHT+IFtROEWRg79IGDLc0rRT+rbEMKi8ZlgwalunWQkzYQSnh9mC3YGIgViI3XB5GGoj5M99BwEITd7NGTa0RHkaLA=
X-Received: by 2002:a05:6122:3d0e:b0:523:9ee7:7f8e with SMTP id
 71dfb90a1353d-526009144f9mr5547735e0c.4.1743156107633; Fri, 28 Mar 2025
 03:01:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250326154546.724728617@linuxfoundation.org>
In-Reply-To: <20250326154546.724728617@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 28 Mar 2025 15:31:35 +0530
X-Gm-Features: AQ5f1JpQB4dRotLGNTjOBzHAHFolf1GRaUeE_3Fa2NXTiSNL3tVJxULU2L8PMXA
Message-ID: <CA+G9fYvqdsfwnPNaP1rGoDV=KayU0ivo9=3ixPao01FSr-YGjQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/115] 6.12.21-rc2 review
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

On Wed, 26 Mar 2025 at 21:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.21 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 28 Mar 2025 15:45:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.21-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.21-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: f5ef0867777d85f346f9f134c67999eda52c7611
* git describe: v6.12.19-348-gf5ef0867777d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.19-348-gf5ef0867777d

## Test Regressions (compared to v6.12.19-232-g981e6790e185)

## Metric Regressions (compared to v6.12.19-232-g981e6790e185)

## Test Fixes (compared to v6.12.19-232-g981e6790e185)

## Metric Fixes (compared to v6.12.19-232-g981e6790e185)

## Test result summary
total: 130475, pass: 107490, fail: 4077, skip: 18846, xfail: 62

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 54 passed, 4 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 43 passed, 1 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 16 passed, 3 failed, 7 skipped
* sh: 6 total, 5 passed, 1 failed
* sparc: 5 total, 3 passed, 2 failed
* x86_64: 50 total, 49 passed, 1 failed

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
* kunit
* kvm-unit-tests
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
