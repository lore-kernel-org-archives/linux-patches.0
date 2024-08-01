Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E398157469
	for <patches@lists.linux.dev>; Thu,  1 Aug 2024 08:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722502459; cv=none; b=WxoxBToITWAQAYpl8E6sS8MmWwG3DSvfeb9NSc4gQ9maWmjwDbc/OBmnsaL2ZBFCG4mZBJcyDk95VehUPixqKeYDi6e4yhjkOmbbuhe2Ugcgp4lQae+yGHlxqHV574ULqIGwVNCMIUpuWJFbFlKKnXap0RCQ1+QVUNxabsbXe04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722502459; c=relaxed/simple;
	bh=Kj7c/438Wa9O64kPH+po+5hSx1lbASVplI7UxAzPUEI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sP2tAXJIurTGbng0gpgdgUViPpegxjPZ5brIaC4pXS79/CmH0FNzPP3rvZxLRhioAVdCPgEYgE5NGLwh7gOj/WwCFhq/z1ZsVwVw/JFaNQQ7ExQK9j4KSATE7/0EV2YAYWxAcY2fraIiGOD1IfnSgxYsptok4ZAt381HSe2x76U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qgs0xXDT; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qgs0xXDT"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-492a01bce97so1644651137.2
        for <patches@lists.linux.dev>; Thu, 01 Aug 2024 01:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722502455; x=1723107255; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TfY9uGRmgYgwlEYLKB30UoOS/7PZs7LGccJhnUl/vDI=;
        b=qgs0xXDT8U+8mlU7oEosDwOT3luEoQcUYHDlH6qGpDQZaqXvZtebQeViY4zmWwhVNp
         QzapVQwlO6yB+iNMYD/ebxPudUkPmV1UPIc0HJMwuQbc8GCymQZW9fXv3E8zEXOZwyR1
         30Ve/8Zh/2F0SvVoyVvl4OoD05rNHW7xEUGs2dBLvMtwXOV59lPJDTp24B/U+04vFIo/
         WWCQ++kqkpiXTzxoDpxoCxes9gv61F6VtIv77yZcdfkbCu3xpiV2eiCtj+rRnEWYsq8x
         NweUQJPYEr1waAc9v+3H1ySFQckZU6lsw45HIZ4bXKjc032LJQ1qiDJ8/VHNdOVB52Hx
         GKNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722502455; x=1723107255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TfY9uGRmgYgwlEYLKB30UoOS/7PZs7LGccJhnUl/vDI=;
        b=RuDFa2qwL0x96Vmr6rWsImWN3KHEyzPt7/+L0GMVsM1lD7oK87HH6ucCb1r1wr8Qkj
         Jd9Ej2afIXnVPm1wbePC+5slQc+Q9j29sTA8FZDMV0K2sq74aQFANd/pFwW2Gp1dhyLG
         0JklOk7xQqQmC5YjldgM0inTUFwUQV0Cglmon7K177ofC7etb7JA6/1kdmU4Gb94ZIMg
         jcVfClUjpWaLHHaTTpNYxeUa+ZYuShNxAgtMDRf7oQ6/kIDqDkVwRtHyixsDv9+A54MA
         3rCdlVWb8vkb1LGdqdMI3dLYUq1lM6DHX+MovRBDw+2ADOx+6mu+2qd+e8BSLO50PBXF
         2pvg==
X-Forwarded-Encrypted: i=1; AJvYcCXsgPl9uue9xPxCco4ils0hnnXNrF5JTaUslNmgD7m1gAvoYp9cBDNnndbGVDyXNwZ/JqrTBPXoF1vt7WZ1Xj3XYIhNL4ijgw==
X-Gm-Message-State: AOJu0YySIdtR25wJC3lEg2ymMlVaV5CaGxtvRJOjlJPbe7iht7ZtRoRK
	h+h7o04HVwnAq+G9KGYJWj5kWeVHn9/bLg+SnFXDuAjT3Q4o6kXVHeUQzynlsmN+EfQW76hbXhk
	naJyFAZytQ9gMm+HLE0N7czOlEFQBqFbanKNR7Q==
X-Google-Smtp-Source: AGHT+IH6JdzRzhUBNvL2xB5DHRVjVsFJqjvuKiRftt7np+NNTPuZnk8Z59nka/DWI3U/OK1VV95z5DjFAvqMAmId0sQ=
X-Received: by 2002:a05:6102:3a0b:b0:492:773e:a362 with SMTP id
 ada2fe7eead31-4945099babamr2044736137.25.1722502455326; Thu, 01 Aug 2024
 01:54:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240731100057.990016666@linuxfoundation.org>
In-Reply-To: <20240731100057.990016666@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 1 Aug 2024 14:24:03 +0530
Message-ID: <CA+G9fYv9fyCLmJirVSpgQm2kNb7vHdnstREKCisxHCT7XJww7A@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc3 review
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
> This is the start of the stable review cycle for the 6.1.103 release.
> There are 440 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Aug 2024 09:59:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.103-rc3.gz
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
* kernel: 6.1.103-rc3
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: dbbffaaee18872f4ae741cf2bcb726583b65c069
* git describe: v6.1.102-441-gdbbffaaee188
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
02-441-gdbbffaaee188

## Test Regressions (compared to v6.1.101-14-gdc0e6d516f8a)

## Metric Regressions (compared to v6.1.101-14-gdc0e6d516f8a)

## Test Fixes (compared to v6.1.101-14-gdc0e6d516f8a)

## Metric Fixes (compared to v6.1.101-14-gdc0e6d516f8a)

## Test result summary
total: 171958, pass: 147513, fail: 2121, skip: 22066, xfail: 258

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 36 total, 36 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
