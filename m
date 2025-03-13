Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442AC1FBEB7
	for <patches@lists.linux.dev>; Thu, 13 Mar 2025 07:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741850379; cv=none; b=ft28tJ8szv9bujzbU0ZERC2fb2jPZEfSWRWOFMsc3UwH9bMyZDgtwYfxUc9dTcYR30uMc38poVggJtkU51BgS3NUMuv/JnSDqWZfG6HiSPgjGHyUb/+UmthKKqRh4edBKmcfmF3WvJGxTsjiyttu53HwID+gfNH6tOF3xvL57Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741850379; c=relaxed/simple;
	bh=tvrIWAJJ2tNps0LjZcZloUQVbHDHX3SZ9LzINjvttfI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SRZ2dMZfD9zzyVeJsswzOZ5O5woV0tNliqiBOKh4PKxuCiZfZYxV87wF+MnHHtJKLEr3WnK5TjD/Qj/eqBD6pWcXrbu0U0OG5UML2HezkKYRwToN6zVeIBMVVAZJ/j27N4jCcXaRyH8763IO5Tjx4uRtNLeayUZxI4dM1Twf61o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Wp2e4XMf; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Wp2e4XMf"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-86c29c0acdfso328067241.3
        for <patches@lists.linux.dev>; Thu, 13 Mar 2025 00:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741850375; x=1742455175; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aAZsZ1wRYrAZzl/Zgd8kqSQ9r3vpzwVRs5a6xcEHCI0=;
        b=Wp2e4XMf7OuKswawFMyoQ6HY07lm92zrtkmn2vzAO89Hr8saEV1iAv0ImuamvovlkP
         K4yWCIBC4wRB+V/Zim5rvtOXysyr/Bkoumm2Pa96pcXB+adVVYuZW0Uaymb/3TaWV6g6
         Y7T9nxBUCi4o4/5epaHOx7k78UgQmBMWZZAS47Y27625rv8Ax27iYFDKpV8jF46op3A9
         BfYyTTdE6LRCyzjJiZ44hFZ7Zlvrt2vr32sQxp5C2vxNwnh5limIY9bxCEbYLwESPGJo
         n36FldoEoIIWmd2ahI6DgCqXpWyX0Yhf+10G0AA7764YmA2l/V57PeV1u1k0KwX0hG7t
         XHrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741850375; x=1742455175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aAZsZ1wRYrAZzl/Zgd8kqSQ9r3vpzwVRs5a6xcEHCI0=;
        b=PahNzeanh95o35TPo55C2Sq7N/PJS4XbWpXcHeZynThel6xYwh1TL+tuw522v5lQ6M
         CfGWYkbgCAp+c3KA+6bZiY7IDdWnpXG/4jhvSH1KF2R2sNwT5xCUMGD6JqG3XpDF6IeI
         yK1kT/GkqUudKGtszu5fUrj6A+H+AlJWbCgkr6pQQ35/Ck5ABLbImWGxG702BoQ7GWhx
         SOgeRhZ6PDww5F065XLE3kUx7jvIekopzSQZWH+lMf/ibygpMuAkCKd+ZbN8XtbYaoTm
         aFENld/xAuSw0KJGRD7qWczStHDy0loFONq/zidycnrBVdN45h880u5tCZ4/w0iFtRnW
         qmfw==
X-Forwarded-Encrypted: i=1; AJvYcCXjxO5Wb3gI7D0QvMtCqnCtVUXE6jcHrQhPg0ORzc3E1v6sKBTUX1UavfpKUGSbbpno8hvwjG5D@lists.linux.dev
X-Gm-Message-State: AOJu0YwA5auYO7NZa+SF28+izXK8AGVVakxEjrN+FJUUwRp0ozrTmDD0
	8OOV4+bTAfsExwadZBAcV36KYDCVgXCeG51wf2ASEt/mfZ1PLOrkq9AGsJ76Ah18fh+fcS7C8TY
	sr37WEFVAORT6l5iV7W/Xjqc3FOpgfoIxVeSFjA==
X-Gm-Gg: ASbGncteWUIya2mME1uTXNor8ztrTONOttRb2aL6UDxbVeQs8KN0WwdW48Fyjg2nwDy
	wZxM2O6QEqZ5LzWf285Cpe0eocvmRdlGTDobXLeXf6yjfIz2M/jPt/gbGM+jxBCKxujaP7tdxfn
	0Vasmx1PO2ASwRlJFNwOlOGsLmuotXIh4aRH3yARVw3jA/Nc++dHcsdOUuFG8=
X-Google-Smtp-Source: AGHT+IEV/rGOaoEuK3zniqwPgl/moqYdxmVdVff00QTaFe19FzRCQOIbMxDf+H94F4ZKWQ/VkTHqVRxX6Wom9nlJVLw=
X-Received: by 2002:a05:6102:508e:b0:4c1:9695:c7c with SMTP id
 ada2fe7eead31-4c34d37b464mr11680214137.24.1741850375129; Thu, 13 Mar 2025
 00:19:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250311145714.865727435@linuxfoundation.org>
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 13 Mar 2025 12:49:23 +0530
X-Gm-Features: AQ5f1JpCEAGT2FPlxBRj2m9Ee0zjW6ymNv1xOATnxXBPZ3MffwHeWFUXuP9Bz9U
Message-ID: <CA+G9fYtG9K8ywO4w2ys=UEuD_r1LgOuZhG4cg62YKAX0qK35cg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/328] 5.4.291-rc1 review
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

On Tue, 11 Mar 2025 at 20:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.291 release.
> There are 328 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Mar 2025 14:56:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.291-rc1.gz
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

NOTE:
The following build errors noticed on arm, arm64 and x86 builds
net/ipv4/udp.c: In function 'udp_send_skb':
include/linux/kernel.h:843:43: warning: comparison of distinct pointer
types lacks a cast
  843 |                 (!!(sizeof((typeof(x) *)1 =3D=3D (typeof(y) *)1)))
      |                                           ^~
 Link:
  - ttps://storage.tuxsuite.com/public/linaro/anders/builds/2uDcpdUQnEV7etY=
kHnVyp963joS/

## Build
* kernel: 5.4.291-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: fb482243c16ebfe8776fcd52223351b4061c1729
* git describe: v5.4.290-329-gfb482243c16e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
90-329-gfb482243c16e

## Test Regressions (compared to v5.4.289-95-gb4cc7cb40189)

## Metric Regressions (compared to v5.4.289-95-gb4cc7cb40189)

## Test Fixes (compared to v5.4.289-95-gb4cc7cb40189)

## Metric Fixes (compared to v5.4.289-95-gb4cc7cb40189)

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 137 total, 137 passed, 0 failed
* arm64: 37 total, 35 passed, 2 failed
* i386: 22 total, 16 passed, 6 failed
* mips: 29 total, 27 passed, 2 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 30 total, 28 passed, 2 failed
* riscv: 12 total, 4 passed, 8 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 8 total, 7 passed, 1 failed
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
