Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CA92066DC
	for <patches@lists.linux.dev>; Thu, 20 Mar 2025 11:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742469628; cv=none; b=EcmMy1OWlr2Yu3zqaOIlL/SoXnhlHWVqvI3bIn+I14T8TvjRJtSh5UPDwMIeWCVvBbGN3tWqUgGsXb5nCpvGkzhPs/Qyw2bps3a5BqzI5rWfFx1zxcjME9TUclj3YyL7AoH+a8PKmwg6XUEUIDoaFPEiTXQicrXd3Ni5NS+wbOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742469628; c=relaxed/simple;
	bh=qqDEyNubMPJ7zCt3oPa0x/EPWryhlCvZzsA7+X0AY6I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e3N4llF0aAAACc4q5Nzg7ZQ/i6UcIgYz41o+0zdOjYXc0LFqk/XBPV0SlP74xxbhtS0ttoWsmHsMZTfY3p8zTVZYu61W4todIlZI+4d7vQkd1+Rk5UHRpbPRx1zS7orJtf/67u449vqtn9Tnu+97I34xYGylUUSDEPpJhZNU6VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JF+Ui1Jo; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JF+Ui1Jo"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-523f670ca99so330998e0c.1
        for <patches@lists.linux.dev>; Thu, 20 Mar 2025 04:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742469625; x=1743074425; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zh/p/m1A+uLbYaQNcQdnHgNl8J7Dga3etgiuxry0OWI=;
        b=JF+Ui1JoHOSdVsxoIT5Vob1btRRxmN6TUDRI95gQdVnh9BH4zhuqqNhrmlSAwV0IBW
         ZEybx7n15uF6g88XLYzh22gutPORvdZJq55VY+/f53rfg8I/3PggV06UMd4qUOzJKyGR
         bCx7/BWIad0Dpfvas3c/544OZjBtUFXlug8uYtNL5Q0b67Key+y5qjvS8Nc3jI1k85hz
         S7Fp3hCK+brzTHGBLhLpVPGBHjorU3uOY0NG3yO+oLW7K4qdJq2EIA5aq/YVH/fUmsz6
         +3bQ6C5bUO7LKpB9m+wOBY3wwDLfyWLiPPRIjBlAh4SHfMmDued4cfvNHBt2YqXEd5Ca
         nXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742469625; x=1743074425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zh/p/m1A+uLbYaQNcQdnHgNl8J7Dga3etgiuxry0OWI=;
        b=ehJhfOHUrCe0p33maGWFubtu0DGbmYPVCdH8udU1JrjxD8e3Byq/cLHG0GCwGc586e
         8KAGQwE/fDh1eUB5Y3/UVP0HDKeEGtUoYmQUI46KVhjVrGuny0GnNqkr2DDtycVR+8Aq
         JT/nPn9YaFp4/61V2ftCdYlzRm2MdhG6y5bguh5+DYMhfdCse851ONcbArzXcgt+6i9P
         Pe1MUeBZZGr9Z/8w0IFKkd/4QQY8StFpld2gakD3jsVGRhhPYP4ZV7gyndxa+rg0Rbwq
         B/vlsdwpFr72+AjA3lYteYxS/aX1CixH7JR+136Tljkthv3HQMBK72YlfSxbio2nBI9e
         bsmA==
X-Forwarded-Encrypted: i=1; AJvYcCVAh2yIoKzTk5ZjW1Oqh8FSGXVsqfJ/GP2UDwrcSgCqWQr1v1luq1DQ1h/audfDpuoB92AIUcEC@lists.linux.dev
X-Gm-Message-State: AOJu0YwjinBjPKexkzh6aHBx/2F9f6pLh82Sql/cFpgoBYU6QvidITRj
	h4mFwoAUV6SdmjR9FLD10NriUKXs9VePaHsZvM7AMH1jo6FYpawfDPhiCv+JJvDaqzTM3GRtiPc
	LlPTz7GD9Yy043Oj+AHHa+phf7HKtCpSX4hMdyg==
X-Gm-Gg: ASbGncvJus/IEeUMkYvt9m6DlNzkXU1thRv1voFEDAc36DusJxX7LQRlv5dRlYbVUqE
	Cp49kqn4/YqoVIJgwPbXzZluT02YKC/0McRnZ5OD+3OFSu4eLF6tf1OBbduEVNrHsEwct9c3GOB
	eVTSGOqg51Z7+qLIfw5eObeZmtpCzO7MLqwI+D8XNKDiYKUJGkgPEd2OY=
X-Google-Smtp-Source: AGHT+IHhoWEXjjkxBLRTLTkbLyln8K0nbCDcpvsOmze6EcD+/4wUp5mfy3/ws4QE+x7mPoXIwZZfiNZmMAMtkvdtLUY=
X-Received: by 2002:a05:6102:e13:b0:4bd:3519:44be with SMTP id
 ada2fe7eead31-4c4ec681b3bmr4855483137.15.1742469624927; Thu, 20 Mar 2025
 04:20:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250319143026.865956961@linuxfoundation.org>
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 20 Mar 2025 16:50:13 +0530
X-Gm-Features: AQ5f1JpN-3B-OZ8yl_fYlt8BRtL9Aj0UDSUVoLXufJCRpVuMPh7D7U1AFDJvN1U
Message-ID: <CA+G9fYvsOJVK=7FD3JwuEVm0oVgLWNCWBc57X9RjwFBhj54U4g@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/231] 6.12.20-rc1 review
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

On Wed, 19 Mar 2025 at 20:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.20 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.20-rc1.gz
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
* kernel: 6.12.20-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 981e6790e1859469af2f2d82ae3c22581fec7ec2
* git describe: v6.12.19-232-g981e6790e185
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.19-232-g981e6790e185

## Test Regressions (compared to v6.12.18-270-g53db7cb59db6)

## Metric Regressions (compared to v6.12.18-270-g53db7cb59db6)

## Test Fixes (compared to v6.12.18-270-g53db7cb59db6)

## Metric Fixes (compared to v6.12.18-270-g53db7cb59db6)

## Test result summary
total: 127126, pass: 104122, fail: 4097, skip: 18842, xfail: 65

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 54 passed, 4 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 43 passed, 1 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 22 passed, 4 failed
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
