Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC8017D4
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 03:54:46 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id d8so3054350plg.2
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 20:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681876486; x=1684468486;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cnPz/w8Z/3kQN93QDAUAkuy+lITIiM3M8QeoYgBe2v4=;
        b=EU3Gaa05CAhSxpRzC6wao5rhwfkvEBLX2yQ3jnCOtdFWBBOBK0PMn7QI4UqDZ76pNE
         pq8szVmS6CObGcaRSH3H4isnZB549ccvGk4MtR9YIA1UPRMYwQTnEwuR4gvmWl2sLftu
         83ZTWt4nwVmjGNCQtp3KJ1wXWlFpWmvYtBUBkThQNwAdYdvG1q9eUnlHK56WPtjtuyVo
         Y8SdSe3m4FAVsRdXv/US28jec4tK6uLal4cI0V999x5uw4B2LYT1hnsyuDsom5vJWkCF
         y740BegRnoDdTPAfRkTIhD4r9tnnuomdsjgFfUB5ydryOe8u7NpefmTIzRN3S7rajEmk
         9teA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681876486; x=1684468486;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cnPz/w8Z/3kQN93QDAUAkuy+lITIiM3M8QeoYgBe2v4=;
        b=SDATzRNYP101MJWQKoxx7znuUe4DCNoxVEssz1j7dBrpd03RlEchj28cY3aT+Dg/KA
         S62HcfARTkJLOl41GMpHp959OrYb96pqHGcFnNV647aXkla1lol2m08CiOOuBVeB1Jgr
         tU1GJwc2zEgftq/O+k41JI/fDiM3Tjib6kSsUpnfQyqdEQQzos7GcJEcKzznxQgtqle8
         tACMlegEJbXrk8YSbsV9SWuN/c+wj6rvE6LwrQR/hXDxvh0x11B1iwAKdyH6PlHVtPR5
         EFwLEzi16ArBoSAD+t/gsDhwKD2j/CWumO2Vx32Ud70WgkqdZfjb8erX31mfbEmH6x2T
         e8mA==
X-Gm-Message-State: AAQBX9dbbMd9RL77z1kYWJ7eq5//UKiGgWPBaw+1tzjUh58hM3rtaOuf
	tVKWdqdfBaCFfBvbfBCCFQdHYrZBiYw=
X-Google-Smtp-Source: AKy350Yww1bJ6b93Slr8tYit3eAVFYCJdzzs8BuJvBGhMthRbNTDZvJEp8hfxuFS34HpmjCcbNRmQA==
X-Received: by 2002:a05:6a20:6a28:b0:f0:86ce:d02c with SMTP id p40-20020a056a206a2800b000f086ced02cmr1002487pzk.16.1681876486052;
        Tue, 18 Apr 2023 20:54:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s12-20020a63524c000000b005142206430fsm185481pgl.36.2023.04.18.20.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 20:54:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 18 Apr 2023 20:54:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
Message-ID: <be1852dd-859a-4c62-84a1-54598dfd380d@roeck-us.net>
References: <20230418120305.520719816@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>

On Tue, Apr 18, 2023 at 02:21:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 146 fail: 14
Failed builds:
	alpha:allmodconfig
	arm:omap2plus_defconfig
	arm:vexpress_defconfig
	arm64:defconfig
	i386:defconfig
	ia64:defconfig
	mips:defconfig
	parisc:allmodconfig
	parisc64:generic-64bit_defconfig
	powerpc:defconfig
	powerpc:ppc64e_defconfig
	powerpc:cell_defconfig
	s390:defconfig
	x86_64:defconfig
Qemu test results:
	total: 499 pass: 452 fail: 47
Failed tests:
	mipsel64:64r6el_defconfig:notests:nonet:smp:ide:hd
	mipsel64:64r6el_defconfig:notests:nonet:smp:ide:hd
	mipsel64:64r6el_defconfig:notests:nonet:smp:ide:cd
	<all riscv32, riscv64, s390>

Build failures:

kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
kernel/cgroup/cpuset.c:2979:30: error: 'cgroup_mutex' undeclared

riscv32/riscv64 images crash.

[    0.000000] Linux version 5.15.108-rc1-00092-g0b6a5617247c (groeck@server.roeck-us.net) (riscv32-linux-gcc (GCC) 11.3.0, GNU ld (GNU Binutils) 2.39) #1 SMP Tue Apr 18 14:19:32 PDT 2023
[    0.000000] random: crng init done
[    0.000000] OF: fdt: Ignoring memory range 0x80000000 - 0x80400000
[    0.000000] Machine model: riscv-virtio,qemu
[    0.000000] earlycon: uart8250 at MMIO 0x10000000 (options '115200')
[    0.000000] printk: bootconsole [uart8250] enabled
[    0.000000] efi: UEFI not found.
[    0.000000] Unable to handle kernel paging request at virtual address 00600001
[    0.000000] Oops [#1]
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.15.108-rc1-00092-g0b6a5617247c #1
[    0.000000] Hardware name: riscv-virtio,qemu (DT)
[    0.000000] epc : fdt_check_header+0x6/0x1ac
[    0.000000]  ra : __unflatten_device_tree+0x32/0x106
[    0.000000] epc : c04cf1dc ra : c0859f08 sp : c1c01f30
[    0.000000]  gp : c1d6dca8 tp : c1c0a9c0 t0 : 00000000
[    0.000000]  t1 : c100f4fc t2 : 00000000 s0 : c1c01f40
[    0.000000]  s1 : c0c25000 a0 : 00600000 a1 : 00000000
[    0.000000]  a2 : c1d74044 a3 : c0c253ae a4 : 00000000
[    0.000000]  a5 : c173a000 a6 : c1c01f2c a7 : 00000001
[    0.000000]  s2 : 00600000 s3 : c1d74044 s4 : c0c253ae
[    0.000000]  s5 : 00000000 s6 : 00000000 s7 : 8001b020
[    0.000000]  s8 : 00002000 s9 : 800312e4 s10: 00000000
[    0.000000]  s11: 00000000 t3 : 00000000 t4 : 00000000
[    0.000000]  t5 : a0000000 t6 : 80400000
[    0.000000] status: 00000100 badaddr: 00600001 cause: 0000000d
[    0.000000] [<c04cf1dc>] fdt_check_header+0x6/0x1ac
[    0.000000] ---[ end trace 6977e3ccdb629cdf ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!

Bisect points to

08ace525df14 riscv: Do not set initial_boot_params to the linear address of the dtb

This is not surprising, because that commit says:

"early_init_dt_verify() is already called in parse_dtb() and since the dtb
 address does not change anymore (it is now in the fixmap region), no need
 to reset initial_boot_params by calling early_init_dt_verify() again.
"

However, the patch which actually moves the early dtb mapping into the
fixmap region was not backported (and looks quite invasive to me).
That makes me wonder ... why is this a stable release candidate in the
first place ?

Guenter
