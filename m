Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A599E2101AE
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 11:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730980261; cv=none; b=o+5eZLUuXG58l+6HOb6wDr8sziB3ICiU43uR5hPuCq6ZoxxK3RyZ2KQVwrnngZ/pPRFL2OmvMiFsssL5HZSiVEFcBGvMg4BsllRIBYhaBM4HgWntQP0H5uxnvHTxOghZbIaKyd+/JuqR91anFLXgYxbVKyxhuHPYRHsWkiHZtAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730980261; c=relaxed/simple;
	bh=Mvs2mAn+Drk32JlagAj6fXdJ/5G6gyP5H7MHIcqftUw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WmHJI0UDRL178eVFTql3F2Qq8Xyvri8DQBHXS/X301H+c4/TI2PK9Xq+WWMAG5KCFxOMIUpPLD6rnamMbEF8VqkysGMsw2S3JlHsnmbHJotTG4DDNIEaT9TKLOm5U43C65Ld9MxDn15Z6eevXpAVMEq2A19nmlOlkTv/k0f8t2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x3QSB0jX; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x3QSB0jX"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-50d3365c29cso1431115e0c.0
        for <patches@lists.linux.dev>; Thu, 07 Nov 2024 03:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730980258; x=1731585058; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tAOAzPzMyM9M2AFbfquPPJQN+4hXvXsj2wZKfn4Sf6M=;
        b=x3QSB0jX0o3noTQrP0oex23XMBItGhrmG+f16OfcoWGjl6QDampzSTAt8PbjsCRqlX
         MVwP3qf2zmptd7wmg5OQprgmcS7kKV8iVYIScl+j/CXGB8xLfD0QwTOzjJXEGr2+mWph
         hrLrYA5V/Q700mIA2ADxCmHlzb2HZAzD4aPdc825nACOexbPliJr1wkffwNhdU8JPsRD
         2LO5+tL3HUmC6/jiCJdGTdgjlzFTFmvpGvXf5Er2eZwDbav0URf9DYZ7afemwanjZM+Y
         PMc1/F4R1AeF0wnqdZyLex/TD0nApFWhCUr8uqnJZfSJRIc1DNmw6q039+fLIarutvbu
         srKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730980258; x=1731585058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tAOAzPzMyM9M2AFbfquPPJQN+4hXvXsj2wZKfn4Sf6M=;
        b=MEBgLbfFwKFgA2cSakdKCWi9qXYKsYe505cMip83JPY5QXFKbae/Da03aQ9PmQYd6z
         r0/h0ZZ/4pxE5IV/tZlFrxAnYHn8oxJ42SIeUSH0lzRpqc95Di6Wi7rDaJcIUIoNEbvb
         gmr6g7mbq0ce2mKCYlkT8wLVXXErdsjOXto7rgNnPU3tlJQ1xWbBuKaCgELHo3Bk0nGK
         UtCgzKntbYSSQktZDT8EJqSRbwx326kOW1XS5MSRpEvbAWtsooTcczNCFqDlhbxkCZVl
         jTenbysC7/2vUmoUM5u+LyjYNqp/u6M1nxfmB7y3q5d/WnXO4cWZvuDwfYC4567MwmA5
         YgMA==
X-Forwarded-Encrypted: i=1; AJvYcCXBGyYt7vIpCXMLbF7x4ifo3D234jZWWPxwsgMOu2AkPU0gXqoSCbXhf7MMIEvZOVe0NkNvsPgj@lists.linux.dev
X-Gm-Message-State: AOJu0YxoDvYKHbK2Oc9AF8tQdkGdnEiT/VQ5UzHxBOb3Wh4t8r3u8nqx
	CctpMgFPLzaQ2vtTUIM4eS+4/9x02pi+bfR/+SkCGxRAH5fQYGQXQuIObMURxuOHc4q3uHFf4gi
	br4yb+8M+8mVKM0q4zTPZ1MYKl9S1TjUR1/hkgA==
X-Google-Smtp-Source: AGHT+IHOorGanACLiDA0VqGusHLjdV99Wf3r3+lkatrz0pw0DdKsclrxXksCxolyu8HoLHYrbpx2b0DNBtEIBbR7Log=
X-Received: by 2002:a05:6102:200e:b0:4a4:71e5:eb76 with SMTP id
 ada2fe7eead31-4a9c24b1d4dmr1441105137.10.1730980258545; Thu, 07 Nov 2024
 03:50:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106120306.038154857@linuxfoundation.org>
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 7 Nov 2024 11:50:47 +0000
Message-ID: <CA+G9fYs3Jb0RsnX=uTwVi00HPZBCyOF0kZQ689_Q45e+R408iA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/126] 6.1.116-rc1 review
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

On Wed, 6 Nov 2024 at 12:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.116 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.116-rc1.gz
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
* kernel: 6.1.116-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 17b301e6e4bcfbf3583ab4432c71766837667b6c
* git describe: v6.1.113-359-g17b301e6e4bc
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
13-359-g17b301e6e4bc

## Test Regressions (compared to v6.1.113-232-geeea9e03a3d4)

## Metric Regressions (compared to v6.1.113-232-geeea9e03a3d4)

## Test Fixes (compared to v6.1.113-232-geeea9e03a3d4)

## Metric Fixes (compared to v6.1.113-232-geeea9e03a3d4)

## Test result summary
total: 113467, pass: 90642, fail: 1843, skip: 20882, xfail: 100

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 14 total, 14 passed, 0 failed
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
