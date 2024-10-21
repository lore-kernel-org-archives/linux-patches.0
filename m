Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E461B1EEE0
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 19:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729538738; cv=none; b=ZkgSxrdImZVO3Cc1yNyx8vZVC9umW9EDzdlFMC+x/oxqHjkoVhhONCdHq7tZMIXDZvFUJchd6dAtOygvonA0fe4rUsgXrPA9aOSpsrVRDzb+ozWh02IrscFA5JKHm8Zd74LdzCLu+HVw+EDB0B4ubTI5f4rKVZKFHYQ1h913lrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729538738; c=relaxed/simple;
	bh=39yXzsbEVAnhGU9F9Q4jIZeDJdzY9UAjmvAgreporMk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nDxlS0nKly7SnXR2ciIXFgKMA75fEaxXgFl/B51nurZZmjt+axtm0ru3+Q0WJHZlpJEWwswqszFJnOc1mXZxRkThwtto4sQLHPiqkCWFJ6dzHk5JFVZChjyqfs10ANt5p3Qekj3mgY2DIYtDK5+k0L/flZzHwX+6aZQKOLZcnJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qGHB1hbI; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qGHB1hbI"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-84fc5aaccf8so1487769241.3
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 12:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729538735; x=1730143535; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddjIRK0h2N+TtLtOm19QTadObnytcTIMmkiX9ZGErp4=;
        b=qGHB1hbIupr2mQKEfjNSoe87Sqvc2wBC6DpuKtm1sGlnWi3h9SomtLxNWTekNQJevR
         5E+UUTkLNWaYkzeX4u9dAjsT4L9uFh4wOOEKBj0FXfKKMs6f68aeQodf2dPscpKSR1H3
         L1C+lC0v5Ma6M2ehQcmzYLbNEQidGjYNK01GN0jnwnk91j1Z7/uh1YTW8gdGHoNwGi7A
         FXNaNoLktq2Nxu6gZqQWKkYN01ENYCerd2jMh3qqsHcuFQm5qF4iSVxxTXgRxAEK1QaH
         Fi3bT8TM9Q126LINXlmBpDeNrgHfBpF88olh4pPOs63kjemRyLBGGWpdGXfVBUmBIfmB
         mOYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729538735; x=1730143535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ddjIRK0h2N+TtLtOm19QTadObnytcTIMmkiX9ZGErp4=;
        b=mJjriAxftqUftjEG8qS9xNB4u57slvxe87Q5+Vc+QQ7qepzcB9LKy0Dp9L8xxWnL22
         NS6zPriFtXXRAnSvG1vE5N9ZHGruERq4vIiJFcxesdeyp8PW23jPxrDvkF1djI/yW+mU
         WJzWfqsmRe8BJgJv8nAWSbqb5TpNy8bzds84n8F3eLbyDEAAkWgJL7XTB5E6pzlgkW/+
         TLEv09CXcRU6CyCR+7AAz7UMAaHSV/8B7E7q1qfvU9xFKesWS6Spj5ZJ8G8FpL6dNwwI
         AemdRMougH4GWmqW+zFoNJzB6RAvVQjiFQWZ5H75jZewp+i5544/vc/cjw081WKGVM/y
         VAAg==
X-Forwarded-Encrypted: i=1; AJvYcCV8QAycZp4KWhl51ChedmHZO9oGsNwm02FX+facjaMViEw4LS8xvNyfqKEVcf/kbKSiACwwizjk@lists.linux.dev
X-Gm-Message-State: AOJu0YyGt+Y2lEQXiYtkBRO5U5l/AIaT0sKwJdIsxaudioS3Pir78Ysf
	KTljfhhpHRplkQWB+kwwJGnmOaP/ocDqplbGZT/yFw7BGgdxijRRv9+DMFrDOJpw61GNu0gh+nG
	bi6Um+C5DFKDJX3H7+rwdLGpml1yWxEdR2uLlEw==
X-Google-Smtp-Source: AGHT+IHqjjHFZnJR7XHWSlS4Z0c2Ba7H3ulN6LRShf5mzStW412b1YId+gX/N/k5EJ+koqn0VKg+qW7lpGT9P4yN0Zc=
X-Received: by 2002:a05:6102:c8c:b0:4a3:dd83:c0bc with SMTP id
 ada2fe7eead31-4a5d6ac17e3mr9459635137.15.1729538734673; Mon, 21 Oct 2024
 12:25:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241021102247.209765070@linuxfoundation.org>
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 22 Oct 2024 00:55:23 +0530
Message-ID: <CA+G9fYsmcUHgwL44T8cWdOr=qs0NyNZjP2kotKVOi=cGXt=ZQQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/82] 5.15.169-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Oct 2024 at 16:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.169 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.169-rc1.gz
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

NOTE:
-----
The following build warnings have been noticed on 32-bit kernel builds.
fs/udf/namei.c:747:12: warning: stack frame size (1544) exceeds limit
(1024) in 'udf_rename' [-Wframe-larger-than]
  747 | static int udf_rename(struct user_namespace *mnt_userns,
struct inode *old_dir,
      |

Build log link,
------------
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2nkFEUWzJg4an4au6=
tEGcCBQ873/

## Build
* kernel: 5.15.169-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 4d74f086d8cf173c105457670e3c58190f13c06c
* git describe: v5.15.168-83-g4d74f086d8cf
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.168-83-g4d74f086d8cf

## Test Regressions (compared to v5.15.167-692-g63cec7aeaef7)

## Metric Regressions (compared to v5.15.167-692-g63cec7aeaef7)

## Test Fixes (compared to v5.15.167-692-g63cec7aeaef7)

## Metric Fixes (compared to v5.15.167-692-g63cec7aeaef7)

## Test result summary
total: 50075, pass: 36724, fail: 1689, skip: 11593, xfail: 69

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 102 total, 102 passed, 0 failed
* arm64: 29 total, 29 passed, 0 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 25 total, 25 passed, 0 failed

## Test suites summary
* boot
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
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
