Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89244188733
	for <patches@lists.linux.dev>; Sat, 14 Dec 2024 11:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734174986; cv=none; b=UtOE7g+MlZFr9jzDIni9xitttjLybT/xf6BWxFDa5QMggQghp6RivDw/tsbANmFbgNSaTYjkBb25QVyeG7e/KNd9wYMUzVOMecnAEPxVhs4n8hB4TYn2PeYt42HXqv+chaD+r2su6fu0iIm1vbVhnhNpiH/Rzlstt7m/8eDleLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734174986; c=relaxed/simple;
	bh=Bq7EyBCrewGf7WfUYPsT/2jbdKTtf6N3GhCPqzaRkWY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=myW1bAIX3GqxdiLLuhJ20SvJQqUHozWYByBluHgEBJupVXrQV4Qm5WYHk4ik7SsBjEpW51NpyIve1d7czZoOYT48xzOGdm6W/pLZ129lZVrFcxvnh0d67nKUW66UraeSipLbX7lZZXbdLtGQ2AB5/M7zDO2ss7kTB5qul6wfy40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jMBqDKcT; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jMBqDKcT"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-4afecb2731dso703886137.3
        for <patches@lists.linux.dev>; Sat, 14 Dec 2024 03:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734174983; x=1734779783; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZTzKYRBN7u7k96cZPNQrKsCkmmERoC0Jn8Dsq8skyqo=;
        b=jMBqDKcTmJ/HIMdVqidVzRw3iPttsJDaVi7Axz9oCdd3rbV3g/PlRT8gsqiK3rblhp
         vGCynDCQoprVKXTlRqas7loWJoQlRg8SNoOdeL83MRbiA9SrQ0iiaU2XUymEZtc7cc//
         7Sezh9uLyPf+97j4LiRxR4AXV5+K9ia59VagEEhsObO3uEd5xKTZzm/f3mIkkXIruVP0
         KtyBZOFsKTAZeYLxkzSBOnv0QBQMVN5pEMjI/qbBJRiWMsgyXEOhRN7im+heW65frfNh
         e2nj1QXLJF9dHMh2P6AIUtjQrkr7fhWGQ/O5TvzdLlJm7W0rEKhZW4Eq81GDpZqVnFlg
         A4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734174983; x=1734779783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZTzKYRBN7u7k96cZPNQrKsCkmmERoC0Jn8Dsq8skyqo=;
        b=b2dBLhxh63HaN4v4VMyXR6R8Zy+hnhE/jGnjZJoxdaO1VkdOXEuapasQmtkSuoY2FK
         yu3UjCcEUzhiSVDUNIpbN31mALqpCC2yW5jO3VUdYTyNCr4Iy9hSngDaiGeplEN3I6E2
         WciJJ5qkkLHqjK07znAHjVdS1Xj6GPulYLJB9qwke1cakk7ZP8NKRk/Qy4H9z50fC3O6
         yx3z4yT7vIi5ME5/9LEh8NS8jXr6Y3FvTPg5E0E/WFyI45JpUgyLrHoNyBWDvLRFwNTm
         IrGJjLky+2Q58hUBQpkXWl5hxIX+5pRxIdTbcyChXLD+NxckaHHT5mRddMkp/647Q+kn
         VFBw==
X-Forwarded-Encrypted: i=1; AJvYcCUXjI8tPb6GI6OwAf15QwubTIOCtPZ7AlmffHj31FtRfuAA0ULqX/SkAxZD1dWVnA9nn9MzCZIU@lists.linux.dev
X-Gm-Message-State: AOJu0YxGTlcl0MJTQpQIXKuN/Q38IkhK0lsTVn4u4mF633RsS2kswidX
	Dv7EMwnnM8kIDSr7nY4+57wjMfpujF0GmJVfug2lESIzex2zieePp5Nli77JnW2c+6dpejJd16p
	2Y2GLeHinyvYqiy113/7G8SPZQK7sb3mbzYmpiQ==
X-Gm-Gg: ASbGnct/KS7LiRCzde0KKCDxvTbHLA3lXnJNcGRSIG66B8Vu1YdwwzDZoWZOmvAEhZb
	bTSm5hgtrf67F1ehi01UTfrC5st5iI4lskzbmXoP5RLddcIzQoFfwYjO5UtMrntSAjk+f91Y=
X-Google-Smtp-Source: AGHT+IF0zY/G5VOaxPikTt0DPkKqZJjwV1QHu77sXbzO1ssmJoEODDm+y9fgDuh1dY05j8VxHlt9+0OKE5ho/wRkdQw=
X-Received: by 2002:a05:6102:3587:b0:4b2:49dc:44cf with SMTP id
 ada2fe7eead31-4b25dc619c0mr6694176137.2.1734174983455; Sat, 14 Dec 2024
 03:16:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241212144253.511169641@linuxfoundation.org>
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 14 Dec 2024 16:46:12 +0530
Message-ID: <CA+G9fYsERkXC7u13A97Yhc_iHup-5uNsFDz_d41=NVpX+QdOBQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/459] 5.10.231-rc1 review
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

On Thu, 12 Dec 2024 at 22:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.231 release.
> There are 459 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.231-rc1.gz
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
-----
The following build warning seen with gcc-12 and clang-19 and
clang-nightly builds.

Build warnings:
--------
linux/kernel/sched/fair.c:8653:13: warning: 'update_nohz_stats'
defined but not used [-Wunused-function]
 8653 | static bool update_nohz_stats(struct rq *rq)
      |             ^~~~~~~~~~~~~~~~~

Link:
----
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2q7sxmkFm8o6GI3rp=
D4gmlFmbVj/

## Build
* kernel: 5.10.231-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 2146a7485c27f6f8373bb5570dee22631a7183a4
* git describe: v5.10.230-460-g2146a7485c27
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.230-460-g2146a7485c27

## Test Regressions (compared to v5.10.229-83-gd7359abfa20d)

## Metric Regressions (compared to v5.10.229-83-gd7359abfa20d)

## Test Fixes (compared to v5.10.229-83-gd7359abfa20d)

## Metric Fixes (compared to v5.10.229-83-gd7359abfa20d)

## Test result summary
total: 49631, pass: 35698, fail: 2910, skip: 10999, xfail: 24

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 22 total, 22 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 21 total, 21 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 24 passed, 0 failed

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
* kselftest-x86
* kunit
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-commands
* ltp-containers
* ltp-controllers
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
