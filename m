Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE431FBE9C
	for <patches@lists.linux.dev>; Thu, 13 Mar 2025 07:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741850905; cv=none; b=t0+G+USLfx66Ecip8UbXola4bf5GnopavqQ+y/3c4/lFW1ajyu66ZiIeigILBdCF1MOfi2xgd3oO6T7nDLvOQ7pC4IXZ57rczvJ7N3niyGHABxEyENRU3a49XM9NlfHNGVIQgE6I0OcBXUqS6uDfwCYZlmVpmEloApwT26LtK18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741850905; c=relaxed/simple;
	bh=JJokp/CKQZLqokfC1w2VhhlIWaQHtkolCqS6Urvxxko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dpf47Ibu8vu0F5s63BgL9KKPSMhECUVtoRWqeps6D8qWt1O25g8rggbf6jaCf3GRqEjl4ncskGL/SgDbmWhFRzvOoZvsvPzaapfXZRr7+mf/QTnRj+synnL1f/oihGNCcL/hxD5a/sXpYUAUbHLoy1hUI0x+1XCHR8+cYwx6OaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l2Vrzy8+; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l2Vrzy8+"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-523dc190f95so323619e0c.1
        for <patches@lists.linux.dev>; Thu, 13 Mar 2025 00:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741850901; x=1742455701; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b9GsaOplAxyko9C5PtdLfN/NTW4t3muSEZ94FIoQb5g=;
        b=l2Vrzy8+AVN7Leutdtk4JcgEKsU5jjr6R4W/p/kA072Xcz2Gw/OZHk+3OB8AMk11R5
         VqUZqMLCOJsImqQYdw50VxYilIHkN7kM1PVW7K23qNAw17hs8Xub9FiwrvEIKq65ZTGz
         IGNEpn+SBRLzUICx9m6x7GESJqERDuBn05LshvmeC03o0Aclq9eGql+YV+xNr/Ysmhaf
         tzXXe22jjVes69php4vaR0VGrtccydp+DyWufdRVevijVHMkGuLQwFq74id+zayYLVtB
         4InVPxQ6Jqdtd/cB8/QqghgeTK+2rBw+mfZvcamtM4/QCxbpotv2KZt0I0Bswfw/WxtY
         xh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741850901; x=1742455701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b9GsaOplAxyko9C5PtdLfN/NTW4t3muSEZ94FIoQb5g=;
        b=u6hdPj99wgdnHCasmj+c8Fhc/QgC2/OyBclhSsymcaa5gYDWantw3GxJ9RdKl7f9v7
         gFjipb9xkCHZKyn8Kdu0b6BofFHjryBqzXZfD59lLJMNaPOGHZYiCzQl3tQEKDnTm32z
         PLwZ2RN8B4s3HA6P9zh9Bx4lyxlMoXDYXVu167Ro+X/GI9vpXeU0wmvoG5pAmFh4eisC
         YZXKUrOjxqrFvFcR4FKJhBStThuj85VHK1HMPgKlg1JY38K1NwmnnFibmdyFZMQ20JcH
         rrEFA+/hRuv/m6vSDZdfwSL4LDos8K1OszKgR17I687L7Je/z8K7IL9iMFDlIu3hypzP
         395A==
X-Forwarded-Encrypted: i=1; AJvYcCUhhXzgMoCw0Pw0qbag5+kkD9SQZy/a0E0NmIcZ5SykS8+sm6FKEeWw6zGpF8f5JjSfbHeHDN2j@lists.linux.dev
X-Gm-Message-State: AOJu0YwRESadSoFUtMn8/ggJTZXNQ4SK65SKFBtlGUmo7yd3yL9+TgcS
	C4VLj4BV9wSct8PVL4bUqGYDkNelLcRHIeSwkT5YprmhATaldq57Op2/5abMgyQ+Z0Fmr8D6rC2
	9hsVOPnEHquyzZnIDqtWA2HsgGYETc0MHK2OMdw==
X-Gm-Gg: ASbGncuvRD664ZB9t/RiLXPqYMA24UtdKYQocXTogu1TexaShF60ZcBOmH2+GQLYYxH
	2MVCbCWai17ds1J4ed4HJeXUgrJa+YGxi2WEyGa1dByXPfe0b/PMemL64f/vhOHZhVTVeYnof6Q
	jTn3ePTdxr5o0a6/+fggkSf7Bb89/kfBqSmZ6+eoVRT759cEzSHNa+jrTF3tqH726JZYQ0nA==
X-Google-Smtp-Source: AGHT+IEArvJAZ5UguwGcppghBvPRVvfpId0PIyf+pFN+dOk18wNGtp+xcG06YxdIEMdaeCM8A6U4/JtgkmueEDLNCAI=
X-Received: by 2002:a05:6122:910:b0:523:e175:4af1 with SMTP id
 71dfb90a1353d-523e426529emr19254504e0c.6.1741850901634; Thu, 13 Mar 2025
 00:28:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250311145758.343076290@linuxfoundation.org>
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 13 Mar 2025 12:58:08 +0530
X-Gm-Features: AQ5f1JqaWd2v1fXzfup4wZKObpDD9kkTyqWwE96rDq4hwaFSmi5SULaiVlr9Qa0
Message-ID: <CA+G9fYuBvqPiiuXfd3yZaK489KCwoLt9Sk=tR0jMjSp70YxUJQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/462] 5.10.235-rc1 review
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

On Tue, 11 Mar 2025 at 20:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.235 release.
> There are 462 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Mar 2025 14:56:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.235-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
The following build errors noticed on arm, arm64 and x86 builds

net/ipv4/udp.c: In function 'udp_send_skb':
include/linux/minmax.h:20:35: warning: comparison of distinct pointer
types lacks a cast
   20 |         (!!(sizeof((typeof(x) *)1 =3D=3D (typeof(y) *)1)))
      |                                   ^~

Link:
 - https://storage.tuxsuite.com/public/linaro/anders/builds/2uDdzxpnkQaVOXP=
setXcyEGCkjq/

## Build
* kernel: 5.10.235-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 92c950d96187151bf683889647407b8869ea4641
* git describe: v5.10.234-463-g92c950d96187
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.234-463-g92c950d96187

## Test Regressions (compared to v5.10.233-137-g99689d3bdd98)

## Metric Regressions (compared to v5.10.233-137-g99689d3bdd98)

## Test Fixes (compared to v5.10.233-137-g99689d3bdd98)

## Metric Fixes (compared to v5.10.233-137-g99689d3bdd98)

## Test result summary
total: 49601, pass: 34341, fail: 3928, skip: 10994, xfail: 338

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 105 total, 105 passed, 0 failed
* arm64: 32 total, 32 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* mips: 25 total, 22 passed, 3 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 24 total, 23 passed, 1 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 11 total, 10 passed, 1 failed
* sparc: 8 total, 7 passed, 1 failed
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
