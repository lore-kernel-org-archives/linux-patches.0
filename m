Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D52630C638
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 11:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760442286; cv=none; b=CRM089retC/z/Ejs8BeR/SONQy5Wnwmj3nsRejddZEfElyRQ5LPC9q22iEkTAa4kRDC0bcnJVeK16Z+mSiAs6UrlG+4JGxtpRdzw0yg1R501gmYLhVqmCtY7QqY2o9tcdHuGp9TxzDFauLJotCSc+zKC+SO1zHHRDhxdaGANJfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760442286; c=relaxed/simple;
	bh=hfahCY27limKIRliXlbrcCNzQkVZ+dtcWauUhXG8Mcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qO8+udoA/l3SPKhoFiw/PbfBRsHJAJAKqin86Bt6zO5BuBE2JIMJS8qWm4elf6OUySDAZf32RHJ/ADS2xkybIc8lQIz4vpZqx5ec8oEY7t0aEWXVVrCMvNCYuNoGtfaJwxzLEydDhKQJ7nz7wA2GcZ0E2JmIe4qS1nZ5NyWGwJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RoW6cNdQ; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RoW6cNdQ"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-27c369f898fso74104195ad.3
        for <patches@lists.linux.dev>; Tue, 14 Oct 2025 04:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760442284; x=1761047084; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oQ9uK3Kf8jfSaZ6zDVviWmBEyuzg21Wd4ByP3R0vGQ0=;
        b=RoW6cNdQoRQRLX+qi/d3o3bukRgPHCjcJcsBFmoBqoCPKwJwGUj6qAp/ZukEDpusGh
         ymgcioG4N6h63DGZb/9ZoOjHiG69jSzp7JaU/VO9oWgxQ1yTiPanhOw2ye3TPYNzA3wz
         m8z3aaveF4pIPi63z6bQ8GrUUZoEaguGrxvQYW/nXZSrZ96FScj3o41i+jn++gln4bcI
         Xg/ZlJlHPBgOqJpAGwi877sTbxb0Jfl93aRqKX/dOcG6U9qvvFELFlnIxHjKBu/bCNli
         wAAUfK2PRGXlid2DfS2wk8i3+3ZC0mjjW74erxsH15ST6bEgLkzhWWHh4SeroT2nONdr
         D3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760442284; x=1761047084;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oQ9uK3Kf8jfSaZ6zDVviWmBEyuzg21Wd4ByP3R0vGQ0=;
        b=vprh3EVizc+ALacgdNMB/fv8+xQ+m2sl9N77w+4vR7kSAzT9JljDPCMPaMKQ2gr3lE
         PYqI3+TmyrbfMr0Wb8kBf7Ek8OXNgWXiIrqzrU0J798BK9dzi9+iuwmKOuxbStW71Gay
         8x+mU19zZ7mgJeYATZuxUkpBE9f2QBpFkeJKmcH51bOKJS9dhfDYoQfv5Rtw+wwvasJt
         8M7BESvNCyqjtiaZZE6tCh69mjf70gi+0gQNHZuYlYDZoGPiD0fnh70M+nQLdJIjD4xV
         Hy3e5KQRdexPwYOtjuWNijBeM7B/xU2spXC0nhYC97LYwCj0qL4qmZGsszaCqssVacqL
         0nmA==
X-Forwarded-Encrypted: i=1; AJvYcCXyl6VVtMPzhElYadjXlahYVYUs9LoQofrXHyGHD1DK0c8ihUlkomv0H5ju9RlmQu6G9/+0AXox@lists.linux.dev
X-Gm-Message-State: AOJu0YziRoAfI+7geRKx83JrB0/GaVHWMe3T28MT4YZlelTSG+1VFBkt
	11Gf2w8sWDwXsh1Vxl5oIXtRBdF78jQhjMKHhO1f2nawIvlAOGMkHZfYoqW89gNiP4hZ8R7YAvg
	3ecmr2JfjYDzz9Cwyzw37opGe51ugs6oixzEHH2o1sA==
X-Gm-Gg: ASbGncuPfViHdi5XHefM4Ja2VlFiLB2MPKVqG9fuDjJi2h06AXzppBV3iThS+xIZnbG
	5uETSL7A6bRqepbkS3KihuESXnoXfNsmlVvdUna2GRxTxIgyAxUg0Eqg7Z5a+raT7xxMhUV4SZe
	xYMrqI3GBHyLapz7cvwYQT7KhXFI+hGAN+VojSDqAjjP2fr8WFthUIX1sxAm/m4Ab8MgcBRtuIf
	kCZgz2iySZrluVJ3xGyLuNXmmN47QuFjwF9tSjPTKifyyZOTntpybH3oNZ1d1d344S2CCVP1Iu3
	GIwliEsPVzAJz3FwPMk=
X-Google-Smtp-Source: AGHT+IFbZ/y6NT5ea9IDQYQSQTzRLXABcHqTVM3gxucF4K4llB2C5gXZ26odu6Mkc0GD85/tFvvstkrHCeTXD2iVOSs=
X-Received: by 2002:a17:903:298e:b0:27e:eea6:dffc with SMTP id
 d9443c01a7336-290272e3120mr301473205ad.41.1760442283616; Tue, 14 Oct 2025
 04:44:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251013144315.184275491@linuxfoundation.org>
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 14 Oct 2025 17:14:30 +0530
X-Gm-Features: AS18NWBlDyPq4hVEQ-J5018eNoHovic3dklSVWqWWI4TEgdRGPz-I4T3A5-jiaM
Message-ID: <CA+G9fYvRj41__1beAtYvsGcoeqZfu=chpk4sjHC96+wCrbdWiQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/196] 6.6.112-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, linux-s390@vger.kernel.org, bpf <bpf@vger.kernel.org>, 
	Netdev <netdev@vger.kernel.org>, Ilya Leoshkevich <iii@linux.ibm.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, Arnd Bergmann <arnd@arndb.de>, 
	Ben Copeland <benjamin.copeland@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 Oct 2025 at 20:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.112 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.112-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The S390 defconfig builds failed on the Linux stable-rc 6.6.112-rc1
and 6.12.53-rc1 tag build due to following build warnings / errors
with gcc and clang toolchains.

Also seen on 6.12.53-rc1

First seen on 6.6.112-rc1
Good: v6.6.111
Bad: 6.6.112-rc1 also seen on 6.12.53-rc1

Regression Analysis:
- New regression? Yes
- Reproducibility? Yes

Build regressions: arch/s390/net/bpf_jit_comp.c:1463:49: error:
'struct bpf_jit' has no member named 'frame_off'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

# Build error
arch/s390/net/bpf_jit_comp.c: In function 'bpf_jit_insn':
arch/s390/net/bpf_jit_comp.c:1463:49: error: 'struct bpf_jit' has no
member named 'frame_off'
 1463 |                         _EMIT6(0xd203f000 | (jit->frame_off +
      |                                                 ^~
arch/s390/net/bpf_jit_comp.c:208:55: note: in definition of macro '_EMIT6'
  208 |                 *(u32 *) (jit->prg_buf + jit->prg) = (op1);     \
      |                                                       ^~~
include/linux/stddef.h:16:33: error: invalid use of undefined type
'struct prog_frame'
   16 | #define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
      |                                 ^~~~~~~~~~~~~~~~~~
arch/s390/net/bpf_jit_comp.c:208:55: note: in definition of macro '_EMIT6'
  208 |                 *(u32 *) (jit->prg_buf + jit->prg) = (op1);     \
      |                                                       ^~~
arch/s390/net/bpf_jit_comp.c:1464:46: note: in expansion of macro 'offsetof'
 1464 |                                              offsetof(struct prog_frame,
      |                                              ^~~~~~~~
include/linux/stddef.h:16:33: error: invalid use of undefined type
'struct prog_frame'
   16 | #define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
      |                                 ^~~~~~~~~~~~~~~~~~
arch/s390/net/bpf_jit_comp.c:209:59: note: in definition of macro '_EMIT6'
  209 |                 *(u16 *) (jit->prg_buf + jit->prg + 4) = (op2); \
      |                                                           ^~~
arch/s390/net/bpf_jit_comp.c:1466:41: note: in expansion of macro 'offsetof'
 1466 |                                0xf000 | offsetof(struct prog_frame,
      |                                         ^~~~~~~~
arch/s390/net/bpf_jit_comp.c: In function '__arch_prepare_bpf_trampoline':
include/linux/stddef.h:16:33: error: invalid use of undefined type
'struct prog_frame'
   16 | #define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
      |                                 ^~~~~~~~~~~~~~~~~~
arch/s390/net/bpf_jit_comp.c:209:59: note: in definition of macro '_EMIT6'
  209 |                 *(u16 *) (jit->prg_buf + jit->prg + 4) = (op2); \
      |                                                           ^~~
arch/s390/net/bpf_jit_comp.c:2447:33: note: in expansion of macro 'offsetof'
 2447 |                        0xf000 | offsetof(struct prog_frame,
tail_call_cnt));
      |                                 ^~~~~~~~
make[5]: *** [scripts/Makefile.build:243: arch/s390/net/bpf_jit_comp.o] Error 1

The git blame is pointing to,
 $ git blame -L 1463 arch/s390/net/bpf_jit_comp.c
   987b48ef91346f Ilya Leoshkevich _EMIT6(0xd203f000 | (jit->frame_off +

Commit pointing to,
   s390/bpf: Write back tail call counter for BPF_PSEUDO_CALL
   [ Upstream commit c861a6b147137d10b5ff88a2c492ba376cd1b8b0 ]

## Build
* kernel: 6.6.112-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 07c1c4215e9202defca86827ce9e9c920c3596b9
* git describe: v6.6.111-197-g07c1c4215e92
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.111-197-g07c1c4215e92

## Test Regressions (compared to v6.6.109-37-g65af00078567)

* s390, build
  - clang-21-defconfig
  - clang-nightly-defconfig
  - gcc-14-allmodconfig
  - gcc-14-defconfig
  - gcc-8-defconfig-fe40093d

## Metric Regressions (compared to v6.6.109-37-g65af00078567)

## Test Fixes (compared to v6.6.109-37-g65af00078567)

## Metric Fixes (compared to v6.6.109-37-g65af00078567)

## Test result summary
total: 131194, pass: 109732, fail: 4948, skip: 16043, xfail: 471

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 128 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 14 passed, 1 failed
* s390: 14 total, 8 passed, 6 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 34 passed, 3 failed

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

--
Linaro LKFT
https://lkft.linaro.org
