Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080221A28D
	for <patches@lists.linux.dev>; Thu, 12 Sep 2024 09:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726132189; cv=none; b=Shkrj4+PsUIrq7nyzK3R31ebEYS++8wDMG0dxX+BNL6CnOoLvLyMkugIYTy+YNjKgY41OoCOoE0Mpx8KfRe690ToKKipf0E1QzMUMRf+3P4x/uHvvviDwVL56YWJNWaKhjFX1YkNiUmye12riRmAvqlSeJo9RmJ3OfNZ7pBCe0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726132189; c=relaxed/simple;
	bh=CtjNbXIYcgh5YBZ+QQZwKS91eTGf5pyfKKmAeEYnfWo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sG0KLaDH/y/rYgXKQOtje2dVQrt3F1kkjhb6Gl24PlPDuIijfvNdaMqARpuNlhtl2Jtere9d4lTE/uicdKhWNOYSwCQgIzyjepEbq58AqRN+hCe8I9Zyyh/wuGLErA3VsL19uhSdNm5CgBJgk0aG6TQNtFBB7pOcvrkgZ6EA7dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QLO2J535; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QLO2J535"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-49bc7387371so314109137.2
        for <patches@lists.linux.dev>; Thu, 12 Sep 2024 02:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726132185; x=1726736985; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UatKUvp1pYDZvjY6oNaEb1ql1MN49sf3jLFsiNrWAGw=;
        b=QLO2J535SGnMj8gTchnXupiXRNZGIUERgcun1vqw1xi/dig0Uy0/s1PCbgRxt1TI05
         W9o5ClMZqR5Y3XXoB7869Xw09PnkiGQaDut0SSvTLKpzeOZbZeMwF/PZ5lGmkIytCHW6
         5AvaUsBSDXRlrc2ljznmXcb+CtGqnguSzWN4Ktd+QNg793JFuB+JRkMgKYNz5hqx0kCF
         hVw769XInm/SfqQfpaYFciz2fISbj5getJVJrtvVes2650UTdYboo5dpIiMLmQ4YvzgF
         k0LofWgORKqqAtckeYp5LNRf7vdnMClnJqbR2BQ2N1bGk2OWXTMaY1haODskOT+PIQ7U
         22kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726132185; x=1726736985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UatKUvp1pYDZvjY6oNaEb1ql1MN49sf3jLFsiNrWAGw=;
        b=tMiNChFLySbXQcnfU3u+Q3dIlgLD+MaSXYOihhhU53ne3+ZiwcS8Hg60xxgzX56kjo
         XZLiA6ST3OjHDcqwS4A7DIwVPkHM2OXDELjss8f1Gj+kwKLEy1QuQZznsb8XrRpPc+7l
         ia7RvZM0GOuhmY3E2b5sIRY07rhQMPiNLCuU9pA4kMvAvH/UhX/kGKuSJ19uXcyLtXCS
         djjplC8dR+qJ6nBMDX9+8+c58NxrGdA9q6Qp7/KSrwvFn1F358duxDsFMaxZy5/R9u96
         L5bttm85h9fMbUpfIijdT0rZb0bAKPZJSLKdDXXaa0rnKVUA5O8imCgq9DpG+pu9JbVI
         HXNg==
X-Forwarded-Encrypted: i=1; AJvYcCV1/atqIeKEdPkPBQUSXhTxlZGWguLvfUptI1jW4+bPee629CfQ1BXV83ZkEtKLfw20dSQDj9tT@lists.linux.dev
X-Gm-Message-State: AOJu0YwV2RCdUjSp7pUCowN13Zyot+WO/y2Y0yKHfvSRSLVPPsHhTtUb
	VthascV6+rBCh1sLyOsan/iWCTZrlrn13yNEy6y/AgRqpJZjBxxpBjIuf7KnEbtRFj+NEDxsuwc
	YRze/uR1hkHdldh1dLc5OYlmnPaEMisCVb3kpRA==
X-Google-Smtp-Source: AGHT+IGz0PbkoIwHKO0L6/298IeFlNf+Zwku+KeXskvK1GrqkgQeXRL1qLXEbBOqObscNX0b2JOvIPDn+Vxpg4ujjps=
X-Received: by 2002:a05:6102:ccd:b0:494:4fdd:4b7a with SMTP id
 ada2fe7eead31-49d414f314dmr2517039137.17.1726132184946; Thu, 12 Sep 2024
 02:09:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240911130518.626277627@linuxfoundation.org>
In-Reply-To: <20240911130518.626277627@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 12 Sep 2024 14:39:33 +0530
Message-ID: <CA+G9fYufxhcw_+22TEMu4Ae9V7JbGbK38UZSE39+vB1Bf9vwaQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/121] 5.4.284-rc2 review
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

On Wed, 11 Sept 2024 at 18:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.284 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 13 Sep 2024 13:05:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.284-rc2.gz
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

## Build
* kernel: 5.4.284-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 10d97a96b444c199de9b2a768ff73dcffee34c46
* git describe: v5.4.283-122-g10d97a96b444
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
83-122-g10d97a96b444

## Test Regressions (compared to v5.4.282-135-g6561e7052c34)

## Metric Regressions (compared to v5.4.282-135-g6561e7052c34)

## Test Fixes (compared to v5.4.282-135-g6561e7052c34)

## Metric Fixes (compared to v5.4.282-135-g6561e7052c34)

## Test result summary
total: 99812, pass: 82217, fail: 1355, skip: 16161, xfail: 79

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 33 total, 31 passed, 2 failed
* i386: 21 total, 15 passed, 6 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 6 total, 6 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
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
* kselftest-watchdog
* kselftest-x86
* kunit
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
