Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3923B22CBF3
	for <patches@lists.linux.dev>; Thu,  8 May 2025 16:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746720147; cv=none; b=Nw6yxOGHyM3g75dhVM5xA83+XWUMqkBqhUsmZex6gDVPHpzYUa+3UdohsFnejfaN3TB6kl3Ek7/d+IGr5rHGuy2ws7mBGwn7UxbLJXSAnxKk26TfRtq4giU7Ci1ww7F8wJeHnq/2BTMJUaplrlIOVrhl7GbRPNOZ7XunOySfFf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746720147; c=relaxed/simple;
	bh=XaLX+EH+cjL4P9o15Zyjx1Vk2yuv/XqGmQvdiYIWb7Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JHhLp7oVR68AabdRtPk7NOTF1rfqgJhUNfuwZMhRBOe8pG2ngBKzD9BZUnZIZBjn/spmfrAbJz5+eSHYzoEweLvzM/zk+C8P6xZvoy9RG5LTLcChmhboGaNnI2YKoRHYa7zHxg6Zrief/7Eu9thSKURwPm3LOcEKjnYHN26Aon0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uKAosoqM; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uKAosoqM"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7302a769534so826719a34.1
        for <patches@lists.linux.dev>; Thu, 08 May 2025 09:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746720145; x=1747324945; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z38mnBmRkxkRddtM6glxuD7U8+je5cn7ew22HMMDKOk=;
        b=uKAosoqMJz5K3b/k7zCWZgTJelq5M3JmfGX4pwGHmJa+F8IPr4eYKRuITtkrF+SqDF
         omgUOLD+hlf554IyJlW5Fnb18F0BZpjxp84qKnUeLn1IyPStMO/yL5fl2/W5Pv9muDEq
         njWNUfwZHRpS1VgHHjC3VhNkcuM9gSF9C45zu27WkAKtnSMF5yOy9UZ9xCHgsrZcUXuV
         4fvKfP5SayWAJzoTOqqQD6LJAif0tbpK2Bhs91Tibpf6BAZAykks1jAo65sB7vWWujXf
         cCPFtokDfrwAGV4VSmsBK2JfxeLbwck0QpOSZSTS92q++1ZBIn0LfjuCXX8G9TqOSq5/
         id/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746720145; x=1747324945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z38mnBmRkxkRddtM6glxuD7U8+je5cn7ew22HMMDKOk=;
        b=scQuh1a2SbQwKZ2IPkz7i0cFhkl7I54XZJwWQWfVfvy9IRL90llZoI5QpduHeisce4
         R7Ky49N/Fm6QcXzx4nluQFl5zhNqD0+M8xeSAOncTwLIiGCHfBAPdwP/rWD0SdOSLl/L
         ygGAf8b1Vq1IZZXPB1MpG1q2k7KtuUns0VMjq3CDfZeKBCpTZJtmFPK1EgPzqKQQyM5N
         OqSA8fyDvhJn9oW46hFIPsEm2cJkvxakTUEct/Xi1LKCtReifvckx/YxW9FpWnpEGEUm
         Ih53UbHsfEpDYYciZAuOwUvVBf2IEQCjGscSq7c7sfGCYu/tD6t2+9QC5qgMrHxkHsLb
         ZH6g==
X-Forwarded-Encrypted: i=1; AJvYcCXomz92EDKYyKCWNQ3i6Jp/jmdz6Aap4/oVwN5Yf2zeeHvhFMAuKh6V5jHt2sL1egyycAWWgxKL@lists.linux.dev
X-Gm-Message-State: AOJu0YyEL4kPb7THSm/FX516E9L4cJr1cCk2PWiLP+AYT0eyucsTIQmL
	kZsg5q7uH2sacCWEc9cognffcOWrIaNYVBfofK+vlep/K1d2SRTYaj+EllJoCcsaNUYrxmNdlcT
	KlMmj8oQMr5y8rJRE3rjIv2hfwrU0KlTI2EpU/Q==
X-Gm-Gg: ASbGnctyWOA3k516YvAIqdUbl1XWqLrXivFQXR4Zefl1X/k/T8APC2sUWPcoM1I8M6A
	TbfyrSL7Gg2Z1dF8fp7RIiI7JRXJsdTPpgTArj398VchzDPELyekIznmLcaGNDNXqIy2zlX8X2k
	alopMon2NWmBVz6FoFIP8v7T//mJItkifU5LIxajtVCdEjrijz9mxoEc0=
X-Google-Smtp-Source: AGHT+IHQV7olZh1aiWWFaD+aGYoDJx58pftLhIvXe69fIrYjKdcP+ttiAXHsdv2ktPGpik2h9tPub6LGWsoRbPvdHDQ=
X-Received: by 2002:a05:6830:6186:b0:72b:a175:2f1d with SMTP id
 46e09a7af769-73226b3090amr144279a34.23.1746720145073; Thu, 08 May 2025
 09:02:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250508112559.173535641@linuxfoundation.org>
In-Reply-To: <20250508112559.173535641@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 8 May 2025 21:32:13 +0530
X-Gm-Features: AX0GCFslT05Q7sUXFhXMzpJL8JH0JP1bseRENR7DTeD19wSzrM2wd6ZSEU6mODM
Message-ID: <CA+G9fYsoE9P1HhAc-Yi3n3xDRV9bbpr0y_uujp7huf23dCfpSg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/55] 5.15.182-rc2 review
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

On Thu, 8 May 2025 at 17:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.182 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 10 May 2025 11:25:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.182-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.182-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 364c50bdd7d289a0ac440f198b3dd2af3fdbacee
* git describe: v5.15.181-56-g364c50bdd7d2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.181-56-g364c50bdd7d2

## Test Regressions (compared to v5.15.180-369-g85e697938eb0)

## Metric Regressions (compared to v5.15.180-369-g85e697938eb0)

## Test Fixes (compared to v5.15.180-369-g85e697938eb0)

## Metric Fixes (compared to v5.15.180-369-g85e697938eb0)

## Test result summary
total: 58495, pass: 44233, fail: 2661, skip: 11236, xfail: 365

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 102 total, 102 passed, 0 failed
* arm64: 30 total, 30 passed, 0 failed
* i386: 22 total, 20 passed, 2 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 22 total, 22 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

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
