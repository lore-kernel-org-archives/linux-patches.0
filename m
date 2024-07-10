Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9B42B9C6
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 03:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720581096; cv=none; b=NlOxtup6tmUTWoamUqNXnLoXe3bcinsT/kdPVndwG3D5s4nV29omZazna3kLjSNvzUU9QamW8RJ7BwWYaYeAr5sgA5/8ENspzjMQB6TAovESt1qlur3rnCKazm/l2RvY0hAiN9amgm5FmxpsxqBbe4JXOeBgrHeoanX6GMPA2Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720581096; c=relaxed/simple;
	bh=9iAjbDUsI/zhA0vvsjprTEYjwvHRrCaeF74Z8TO9kE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LFfEzjpLHuFI5289ejrg664NTH9s37b8MvJ4BVbFtXKxzvXkW1+38Pljt4d7xaQloUtQuzkyGYlRZP3joVzar21F9JSH2RcWK4mq3wmfD5WS9TEbHJ4LwV+huMs/auwa176wcG7H86BhYwjbC+s+HRu8ScOABZN819OUAl3QhSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YwrnjaIA; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YwrnjaIA"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-48ffb39a752so1642679137.0
        for <patches@lists.linux.dev>; Tue, 09 Jul 2024 20:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720581092; x=1721185892; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6XIMdkfppqyP8G+FM/MdMhJ0bX3EL1i/c4IN0WSrWSw=;
        b=YwrnjaIA10hpOFUll3a3uCnpQzHUK6yh7x/TTlXRb759altdkk0468e+PqTPVmo7gB
         PoWXEQRFBXS/WlvWgPmDH6OCxzFbsZg1XzfzYQAtItFUmXBFGhOdbIBDzWwiCHvfbsQw
         QQ5WhmhCvLqllvp8xn8IihiVBYwXAsqIkLFu9jZf0SjEczdnSYH+kxBwr6TMXF/VjI71
         k3zD42S1pX51hTHzOEHBSF6W5iZQeArezB315M+/QTPMpp2ZjA7k6JQIg95BMPtrTg8F
         WLPN4cJoAeCPT1w+4bilU0xmrX36Y7tzxyusCaJRS7pTwBicxNas25Ow8JaehExrLZes
         FI8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720581092; x=1721185892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6XIMdkfppqyP8G+FM/MdMhJ0bX3EL1i/c4IN0WSrWSw=;
        b=GsnjuWa012kLIvgrY8H/80hnDmLfjMPxSJXZQ5bPtDWhk+9IR6k6gqjhoeysoh2VaE
         p3Nh65sBkza79fXWS8a7izDcO/a0sN5TrXhpvEILMrEVgTuH72QMNbLNnnsAXHGy8p2v
         rZvy7HH6QNjEeT2IJaOznXRsZgwkhDWgjw/Sl4MknHbQyUbpz3zid+wjtwaxJpW02hkM
         HsgtgbwLtBE2n1H6mfRZYj2nw+H7aJbBatJADEnrjiMvMMwZBMLtXXQNs1GY8USnhRl1
         bTPgKzHqIuBO7dWYnAStBVG+Lb2n0bEpDD9Rc+HKtwV8jme7YJWf9VYr7aqGX9DiMj1K
         pSaA==
X-Forwarded-Encrypted: i=1; AJvYcCUSMa1j41zmQW3K947UbcwJzGn0Yz2JwDmVExQcA7j9BAb5tWbF6p9H+JDJtA9cKHIxCarbIoYhZIBPRTqz+xgAGXqInlGC0Q==
X-Gm-Message-State: AOJu0YwY8KyIZIGNDUklR4Pf/Z03W+A//TB6SRBx0ktkbRcR4HpVqCX0
	kp0rQeTTejaB1a9t9CVfk/xLYz7r18CHGcNx0k+V0rfEZqdUPGfx9xhQrPuVdz/fpp1RPRHioqV
	JILNWxV2ZkfpkABMamGtjTckt1yMjKzHG2kaStA==
X-Google-Smtp-Source: AGHT+IEMEZ1PvfeDqTx8SuS+zx9EDRB6rW1s9H1rbATcOiobIk2cxUBMvcJeODpR6jQKmwdMkxhLWeAXs9BOMVS9U+E=
X-Received: by 2002:a05:6102:3906:b0:48f:143a:d8e9 with SMTP id
 ada2fe7eead31-490321597afmr4549583137.20.1720581092076; Tue, 09 Jul 2024
 20:11:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240709110708.903245467@linuxfoundation.org>
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 10 Jul 2024 08:41:20 +0530
Message-ID: <CA+G9fYsqkB4=pVZyELyj3YqUc9jXFfgNULsPk9t8q-+P1w_G6A@mail.gmail.com>
Subject: Re: [PATCH 6.9 000/197] 6.9.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Anders Roxell <anders.roxell@linaro.org>, 
	Mike Christie <michael.christie@oracle.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	rcu <rcu@vger.kernel.org>, gnstark@salutedevices.com, 
	linux-mm <linux-mm@kvack.org>, Jinliang Zheng <alexjlzheng@tencent.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Jul 2024 at 16:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.9.9 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.9.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
The following kernel panic was noticed while running kunit tests.

First seen on
git commit id: 2471237b27c681c22e5f2b7175584aa7d5c89bfc
date: on July 9th 2024.

  GOOD: v6.9.7-223-g03247eed042d
  BAD: v6.9.8-198-g2471237b27c6

Always reproduce: yes.

* qemu-arm64, Juno-r2, rk3399-rock-pi-4b and qemu-x86_64 the kunit-boot fai=
led.
  - gcc-13-defconfig-kunit
  - clang-18-defconfig-kunit
  - clang-nightly-defconfig-kunit
  - gcc-8-defconfig-kunit

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Crash log [1]:
---------
<4>[ 63.601683] kernel_init_freeable (init/main.c:1559)
<4>[ 63.602335] kernel_init (init/main.c:1446)
<4>[ 63.602980] ret_from_fork (arch/arm64/kernel/entry.S:861)
<3>[   63.603703]
<3>[   63.604057] The buggy address belongs to the object at fff00000c07582=
e8
<3>[   63.604057]  which belongs to the cache inode_cache of size 616
<3>[   63.605281] The buggy address is located 80 bytes to the right of
<3>[   63.605281]  allocated 616-byte region [fff00000c07582e8,
fff00000c0758550)
<3>[   63.606592]
<3>[   63.607294] The buggy address belongs to the physical page:
<4>[   63.607948] page: refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x100758
<4>[   63.608830] head: order:2 entire_mapcount:0 nr_pages_mapped:0 pincoun=
t:0
<4>[   63.609593] flags:
0xbfffe0000000840(slab|head|node=3D0|zone=3D2|lastcpupid=3D0x1ffff)
<4>[   63.610449] page_type: 0xffffffff()
<4>[   63.611934] raw: 0bfffe0000000840 fff00000c08d2dc0
dead000000000122 0000000000000000
<4>[   63.612810] raw: 0000000000000000 0000000080160016
00000001ffffffff 0000000000000000
<4>[   63.613668] head: 0bfffe0000000840 fff00000c08d2dc0
dead000000000122 0000000000000000
<4>[   63.614525] head: 0000000000000000 0000000080160016
00000001ffffffff 0000000000000000
<4>[   63.615694] head: 0bfffe0000000002 ffffc1ffc301d601
ffffc1ffc301d648 00000000ffffffff
<4>[   63.616583] head: 0000000400000000 0000000000000000
00000000ffffffff 0000000000000000
<4>[   63.617391] page dumped because: kasan: bad access detected
<3>[   63.618034]
<3>[   63.618354] Memory state around the buggy address:
<3>[   63.619281]  fff00000c0758480: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
<3>[   63.620086]  fff00000c0758500: 00 00 00 00 00 00 00 00 00 00 fc
fc fc fc fc fc
<3>[   63.620886] >fff00000c0758580: fc fc fc fc fc fc fc fc fc fc 00
00 00 00 00 00
<3>[   63.621664]                                ^
<3>[   63.622235]  fff00000c0758600: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
<3>[   63.623362]  fff00000c0758680: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00
<3>[   63.624138]
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
<6>[   63.645148]         not ok 1 block_bits=3D10 cluster_bits=3D3
blocks_per_group=3D8192 group_count=3D4 desc_size=3D64
<6>[   63.658504]         ok 2 block_bits=3D12 cluster_bits=3D3
blocks_per_group=3D8192 group_count=3D4 desc_size=3D64
<1>[   63.674531] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000008
<1>[   63.675691] Mem abort info:
<1>[   63.676527]   ESR =3D 0x000000009600006b
<1>[   63.677658]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
<1>[   63.678274]   SET =3D 0, FnV =3D 0
<1>[   63.678906]   EA =3D 0, S1PTW =3D 0
<1>[   63.679880]   FSC =3D 0x2b: level -1 translation fault
<1>[   63.680879] Data abort info:
<1>[   63.681606]   ISV =3D 0, ISS =3D 0x0000006b, ISS2 =3D 0x00000000
<1>[   63.682544]   CM =3D 0, WnR =3D 1, TnD =3D 0, TagAccess =3D 0
<1>[   63.683493]   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
<1>[   63.684732] [0000000000000008] user address but active_mm is swapper
<0>[   63.686080] Internal error: Oops: 000000009600006b [#1] PREEMPT SMP
<4>[   63.688843] Modules linked in:
<4>[   63.689662] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G    B
    N 6.9.9-rc1 #1
<4>[   63.690522] Hardware name: linux,dummy-virt (DT)
<4>[   63.691532] pstate: 224000c9 (nzCv daIF +PAN -UAO +TCO -DIT
-SSBS BTYPE=3D--)
<4>[ 63.692423] pc : _raw_spin_lock_irq
(arch/arm64/include/asm/atomic_lse.h:271
arch/arm64/include/asm/cmpxchg.h:120
arch/arm64/include/asm/cmpxchg.h:169
include/linux/atomic/atomic-arch-fallback.h:2055
include/linux/atomic/atomic-arch-fallback.h:2173
include/linux/atomic/atomic-instrumented.h:1302
include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187
include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170)
<4>[ 63.693097] lr : _raw_spin_lock_irq
(include/linux/atomic/atomic-arch-fallback.h:2172 (discriminator 1)
include/linux/atomic/atomic-instrumented.h:1302 (discriminator 1)
include/asm-generic/qspinlock.h:111 (discriminator 1)
include/linux/spinlock.h:187 (discriminator 1)
include/linux/spinlock_api_smp.h:120 (discriminator 1)
kernel/locking/spinlock.c:170 (discriminator 1))
<4>[   63.693714] sp : ffff800080087620
<4>[   63.694519] x29: ffff800080087680 x28: 1ffff00010010f45 x27:
ffff800080087a20
<4>[   63.696315] x26: 1ffff00010010f47 x25: ffff800080087a00 x24:
fff00000c99f0028
<4>[   63.697334] x23: 0000000000000000 x22: dfff800000000000 x21:
ffff800080087640
<4>[   63.698333] x20: 1ffff00010010ec4 x19: 0000000000000008 x18:
000000004b9fd0a9
<4>[   63.699711] x17: 0000000000000000 x16: fff00000da13e180 x15:
ffffaa8e3330c4c4
<4>[   63.700732] x14: ffffaa8e33312508 x13: ffffaa8e3583b0ec x12:
ffff700010010ec9
<4>[   63.701734] x11: 1ffff00010010ec8 x10: ffff700010010ec8 x9 :
dfff800000000000
<4>[   63.702792] x8 : 0000000000000003 x7 : 0000000000000001 x6 :
ffff700010010ec8
<4>[   63.704539] x5 : ffff800080087640 x4 : ffff700010010ec8 x3 :
ffffaa8e3585c520
<4>[   63.705529] x2 : 0000000000000001 x1 : 0000000000000000 x0 :
0000000000000000
<4>[   63.706625] Call trace:
<4>[ 63.707408] _raw_spin_lock_irq
(arch/arm64/include/asm/atomic_lse.h:271
arch/arm64/include/asm/cmpxchg.h:120
arch/arm64/include/asm/cmpxchg.h:169
include/linux/atomic/atomic-arch-fallback.h:2055
include/linux/atomic/atomic-arch-fallback.h:2173
include/linux/atomic/atomic-instrumented.h:1302
include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187
include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170)
<4>[ 63.708130] wait_for_completion_timeout
(kernel/sched/completion.c:84 kernel/sched/completion.c:116
kernel/sched/completion.c:127 kernel/sched/completion.c:167)
<4>[ 63.708902] kunit_try_catch_run (lib/kunit/try-catch.c:85)
<4>[ 63.709710] kunit_run_case_catch_errors (lib/kunit/test.c:544)
<4>[ 63.710558] kunit_run_tests (lib/kunit/test.c:649)
<4>[ 63.711555] __kunit_test_suites_init (lib/kunit/test.c:732
(discriminator 1))
<4>[ 63.712489] kunit_run_all_tests (lib/kunit/executor.c:276
lib/kunit/executor.c:392)
<4>[ 63.713317] kernel_init_freeable (init/main.c:1559)
<4>[ 63.713971] kernel_init (init/main.c:1446)
<4>[ 63.714503] ret_from_fork (arch/arm64/kernel/entry.S:861)
<0>[ 63.716154] Code: 93407c02 d503201f 2a0003e1 52800022 (88e17e62)
All code
=3D=3D=3D=3D=3D=3D=3D=3D
   0: 93407c02 sxtw x2, w0
   4: d503201f nop
   8: 2a0003e1 mov w1, w0
   c: 52800022 mov w2, #0x1                    // #1
  10:* 88e17e62 casa w1, w2, [x19] <-- trapping instruction

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0: 88e17e62 casa w1, w2, [x19]
<4>[   63.717705] ---[ end trace 0000000000000000 ]---
<6>[   63.718649] note: swapper/0[1] exited with irqs disabled
<6>[   63.720758] note: swapper/0[1] exited with preempt_count 1
<0>[   63.722091] Kernel panic - not syncing: Attempted to kill init!
exitcode=3D0x0000000b
<2>[   63.724608] SMP: stopping secondary CPUs
<0>[   63.725877] Kernel Offset: 0x2a8db2200000 from 0xffff800080000000
<0>[   63.726534] PHYS_OFFSET: 0x40000000
<0>[   63.727664] CPU features: 0x0,00000006,8f17bd7c,6766773f
<0>[   63.729291] Memory Limit: none
<0>[   63.731074] ---[ end Kernel panic - not syncing: Attempted to
kill init! exitcode=3D0x0000000b ]---

Steps to reproduce on qemu-arm64 link provided [2].
Build artifacts arm64 link provided [3].
The Kconfig is built with defconfig+Kunit and the config link provided [4].
This occurred on following Toolchain builds gcc-13, clang-18,
clang-nightly and gcc-8.

Reproducible always on following devices and emulators,
 * rk3399-rock-pi-4b
 * qemu-arm64
 * qemu-x86_64

I am bisecting this reported issue.
Please let me know if you need more information.

Links:
[1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.9.y/build/v6=
.9.8-198-g2471237b27c6/testrun/24552495/suite/boot/test/gcc-13-lkftconfig-k=
unit/log
[2] https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2j0YCw=
foW0D9nrPUAeDspHG0iFE/reproducer
[3] https://storage.tuxsuite.com/public/linaro/lkft/builds/2j0Y8lX6zRNGTiGT=
ZmteMwzwHj2/
[4] https://storage.tuxsuite.com/public/linaro/lkft/builds/2j0Y8lX6zRNGTiGT=
ZmteMwzwHj2/config

--
Linaro LKFT
https://lkft.linaro.org
