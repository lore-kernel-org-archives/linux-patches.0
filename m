Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B19A4A28
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 05:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jcxl1P9r"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7b0e19acda7so230747241.0
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 22:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696484116; x=1697088916; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/LQ+X+x8kIqTkVd50ogLWp0VaSEkcS2ypomcdLaAgP0=;
        b=jcxl1P9rp3BNNjfx0OIINqYI3BDsQzaH7jRnCBrCHVDBPIrOV8BE6zeghj+FdNsvW8
         I7eNSwM4aUk8LFBp1yTMMsmQf0OU7VrN0s7egAbo6mz1rdyuN460dY7XcpPu6ExtXrR0
         iRg14/xrMx0f7sGuFyPuYXc/6opkEv6SqN/FhQiK+1+xSj/IIRtvY4QZ2yWMuiwhWS9M
         6MtxI3N7trszeHiZgIF6s1uRzVI/hih/oBua/SOkS7LFVs0aOBjVswDfxP5Ut/20Q9+X
         l/wioJhGx01QGt6nr3jsd9membiqyfKw1pEcPcXuSGmkyysSTrEUjPbsceW/ypzmXORk
         i5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696484116; x=1697088916;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/LQ+X+x8kIqTkVd50ogLWp0VaSEkcS2ypomcdLaAgP0=;
        b=SCCaL7CN0/5KMieJWvSwiL4oeNp8CDw91u5PNgNgzJe/JUHrZI+ytJOPvMrAfWxXr+
         cLWRkruoDsXFRlXf7wPU6cxvBfVOCcnlX2aZqvCLJPyouZ65dpf1i27odbdSyZ/YEFJU
         ohVGPG+0K6MvbIynfZmmT+BEHujxY7PHVbWxECFrT7gDyhUPbEvBEcTxY7yRhqy1jqoy
         IxHRLuNSQ17IMPipphMhudgWVIZ7byR3e2cp4xeWHGgS2bLNwhv9PAXE4yecFDrD+Wv3
         vpEjv6SuSrkrbfUmCngZCjsl+b+cTMJuwd2r7LkkID5mRWT8lMiYuCpCfG7J/eEARxS4
         APcw==
X-Gm-Message-State: AOJu0YxaRpq8TVuosdzbl/9E06zl88hNTeDaUonguoz1+caT7wyBtX+m
	fi+AfLVIfltC5tMy1NjnomKUQKSyJUGIAeO7yL4EuQ==
X-Google-Smtp-Source: AGHT+IFyUEy98cMidc1tr4QnSypHpNlXUtm1aI5nwEWjnjVyHJ6lFX/6zV9UcK6yLBCnVPD0b2cF/SGIK7DsUIDhFMI=
X-Received: by 2002:a05:6102:282a:b0:452:d5f6:cf5d with SMTP id
 ba10-20020a056102282a00b00452d5f6cf5dmr3993630vsb.32.1696484115747; Wed, 04
 Oct 2023 22:35:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231004175229.211487444@linuxfoundation.org>
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 5 Oct 2023 11:05:04 +0530
Message-ID: <CA+G9fYuE9Pu3QCVDywA8Ss-41jVfiy2e2kpxjhpTe3CRgmZkBw@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/321] 6.5.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Hou Tao <houtao1@huawei.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Oct 2023 at 23:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.5.6 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following kernel warning was noticed on qemu-armv7 while booting
with kselftest merge configs enabled build on stable-rc 6.5.6-rc1.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

> Hou Tao <houtao1@huawei.com>
>     bpf: Ensure unit_size is matched with slab cache object size


bpf: Ensure unit_size is matched with slab cache object size
[ Upstream commit c930472552022bd09aab3cd946ba3f243070d5c7 ]

[    2.525383] ------------[ cut here ]------------
[    2.525743] WARNING: CPU: 0 PID: 1 at kernel/bpf/memalloc.c:385
bpf_mem_alloc_init+0x3b0/0x3b4
[    2.527241] bpf_mem_cache[0]: unexpected object size 128, expect 96
[    2.527897] Modules linked in:
[    2.528721] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.5.6-rc1 #1
[    2.529525] Hardware name: Generic DT based system
[    2.531279]  unwind_backtrace from show_stack+0x10/0x14
[    2.531684]  show_stack from dump_stack_lvl+0x48/0x54
[    2.532220]  dump_stack_lvl from __warn+0xd4/0x200
[    2.532878]  __warn from warn_slowpath_fmt+0xb4/0x168
[    2.533516]  warn_slowpath_fmt from bpf_mem_alloc_init+0x3b0/0x3b4
[    2.534133]  bpf_mem_alloc_init from bpf_global_ma_init+0x18/0x30
[    2.534911]  bpf_global_ma_init from do_one_initcall+0x118/0x250
[    2.535594]  do_one_initcall from do_initcall_level+0xe8/0xf4
[    2.536016]  do_initcall_level from do_initcalls+0x50/0x80
[    2.536618]  do_initcalls from kernel_init_freeable+0x90/0xd8
[    2.537220]  kernel_init_freeable from kernel_init+0x14/0x1b4
[    2.537634]  kernel_init from ret_from_fork+0x14/0x28
[    2.538271] Exception stack(0xf0825fb0 to 0xf0825ff8)
[    2.539230] 5fa0:                                     00000000
00000000 00000000 00000000
[    2.539792] 5fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[    2.540497] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    2.541682] ---[ end trace 0000000000000000 ]---

Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.5-322-g9327d0db36be/testrun/20257234/suite/log-parser-boot/test/check-kernel-exception/log
 - https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2WJGm4kyWj47rr0KEArH4BwqPCs
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.5-322-g9327d0db36be/testrun/20257234/suite/log-parser-boot/tests/

--
Linaro LKFT
https://lkft.linaro.org
