Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DBD2BE658
	for <patches@lists.linux.dev>; Sat,  1 Nov 2025 09:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761988216; cv=none; b=XEVTXuyWPsGq34nRRsuqir1aelr5tXMQyZFUjNAAuYyKPf59WmH/XW31j/eRcNZvhoeg6IJVs1g3wZKqlNf7CwO0u64xjkuBHJzOpv33h/bv8rpHh1VbBy7C44QX5AvbrszLuPMnomBJl7MO741r6F7mf5z6X0Fd4IUmcyFH6H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761988216; c=relaxed/simple;
	bh=Dp2+LlrmkGSTKwtwAHJEz8oBvjgRnxxMPvMMXnTMpGc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GqM9ksojX+qseV9MwFTI2vH6eKEou7xhVxjGZzf7kqElp7fi80XZhQMZk+fgk0jnHEYn1by/050X3bgaGCgBR7ew+y/tE+5TzqhJk2be4asmXDGjpNWTK7bcRiAO4DfTIdiwcvLcEUVDLG/+YK0x98D1allqzyvkCykeRNsNmcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AFP2op3S; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AFP2op3S"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2953b321f99so10065215ad.1
        for <patches@lists.linux.dev>; Sat, 01 Nov 2025 02:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761988214; x=1762593014; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cjy8DpaTk4xM2lcsRurqJM+HB6H2irc/jMu1lfXkZyU=;
        b=AFP2op3S58LYcT9aGKOOj3AwNZxW1Uru65G4mFZuw4CJE9VzJnqcBLX//gnTNphKxT
         eRwidfvYxFZ7hZF/Nk7tHrwn9pWvWOXg4R8k0UDgZa3LzUddjT3lg5hWt6f/scqLIGqD
         rPpt0MBN5G0gBcDHZxOiYZx9xasntK4zkbutMEvXtbWzuzgGFL4ti6Tj/o/HGbAF3qpY
         uXzLW3kYKeZn6TRpaZWyGjTsSPNhkb8qhJUOho4G5ayYmDe5/vtLfz88RbvG/NXOEiuZ
         g4cmP9wOQe5Nd6GdWn9IOGzlw/fkKLOqIT9hkECBLRmAaAI5ZQ2CuQA6I7UOaXqUdoDJ
         kgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761988214; x=1762593014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cjy8DpaTk4xM2lcsRurqJM+HB6H2irc/jMu1lfXkZyU=;
        b=NsKF7MfGs9HvYJmKGFwv36eWSZo7THIZxdm1d/G00OqQnyPchBZlqi0wb/XE+v7ezB
         sdgsvlayNo8+fjW2jsrr8Cagfc9u37w7fl6VwETFr3c2hbxqWKrW18mFp+LStMCU+pVu
         Ks2u9K3t5xZDGx7E5x0mqqJnaBORZhQGVt8RL24Lo51A4GIg2VplSOEbwIZj03N54Cg3
         9jOHLByjobfAX2aaQ2c0LcV1b/glUNKArE/fLrpKVqZlOJMXvucd6F2nIEB9a8WVJUWO
         Av6L03JGEUNklVKORFEmgmjlJLmVpHhiokjpV1cHB3DNAgQpHowQ52wUa4y53uZx3XfT
         LOvA==
X-Forwarded-Encrypted: i=1; AJvYcCV/CMMNQPTJpb8NGshIX8thFUY+Zgms2jZiKGli8XtX3OjEoqkTkxzjSgn4hmsKPUQN1rZMPhEV@lists.linux.dev
X-Gm-Message-State: AOJu0YxHD8zmBR94Q6I1fC5PJppdznhriba849yfqO6zMV0jXKUzuCbL
	oeMYzY+mnkT+6+qc+1GRYcBczwcY9heVHr9rwBS0AkvDIO7cZPVvdkrhZ4fKVA8n2IOgMAuY1Y2
	gnbCLbtKJQxvnEXr5f9ARwY78c1RxUGcyb5QCExZXhw==
X-Gm-Gg: ASbGncv5XVWykOUnAE2nlGQEdR5lc/w0oFo2RGS7P278LgFjDyoauZ5qcQOt4y1zOvd
	FbauTTf0BwH6AuwEnpDsH9DMbHNqEC/0NdBw6d5tj8UNrJmJ5vpDei5IAk5cL0wXqDQHPUYVk+e
	Ds4y12dyMZq08kDMSs2kKhbtsxMxvHRoa+Ho7+SdWaMKoSED/hvlWFnC7FR2NqzUp8sq9be6WDH
	XNxL10PxJVbCK4ftgRytjdB4S98qkcdejG4xCCVGmo9cN72YMaUdY/ly8WGS40qK2ljro2kHAMU
	6tWaImbiSpyZKMrpx47XKnNei5C7LR448Q/2f9IVD75JFsrl0VQPYgLq1HI+
X-Google-Smtp-Source: AGHT+IE/83P0PCPiiJybb9+6zHNoa/A2vjnRPupEud97zgL56fm2RzORpcZVk52SpVD1UIWKuQlELJKAnLSFFv96QWo=
X-Received: by 2002:a17:903:1207:b0:294:a827:851 with SMTP id
 d9443c01a7336-2951a37a48dmr87237605ad.17.1761988213917; Sat, 01 Nov 2025
 02:10:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251031140043.564670400@linuxfoundation.org>
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 1 Nov 2025 14:40:02 +0530
X-Gm-Features: AWmQ_bnMvHfcDTj3Sf0J1WFQ_EMmx_jBUTSCbGachXza86m83JFdBgDkQLmkckE
Message-ID: <CA+G9fYuCoXiue1eS6XV+cyB+pDH2Bdhkdo6cc9OCt-8F9nXkng@mail.gmail.com>
Subject: Re: [PATCH 6.17 00/35] 6.17.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 31 Oct 2025 at 19:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.7 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.17.7-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 7914a8bbc909547c8cb9b1af5fbc4f1741e9e680
* git describe: v6.17.6-36-g7914a8bbc909
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.17.y/build/v6.17=
.6-36-g7914a8bbc909

## Test Regressions (compared to v6.17.4-346-g10e3f8e671f7)

## Metric Regressions (compared to v6.17.4-346-g10e3f8e671f7)

## Test Fixes (compared to v6.17.4-346-g10e3f8e671f7)

## Metric Fixes (compared to v6.17.4-346-g10e3f8e671f7)

## Test result summary
total: 126960, pass: 107190, fail: 4404, skip: 15366, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 139 passed, 0 failed
* arm64: 57 total, 53 passed, 3 failed, 1 skipped
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 48 passed, 1 failed

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
* kselftest-mm
* kselftest-mqueue
* kselftest-net
* kselftest-net-mptcp
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-rust
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
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
