Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E56A17C220;
	Wed, 22 Jan 2025 09:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737538167; cv=none; b=tBhwQq7Hh3A23HsJoUMpYFvn4kxwIFvY9GHIxVOjOkE+MXtbjEOxNVRGDmR+Uu6F/r36eJMfEvC1VmgXa8QjBF5Y6HXGimFQocT5VZYSNQuPaphNxZPRwo4FGzxDpTa/BA7REP0NpIEH08v3XmULrbPrm/wQJzYZuHxI/r1GGb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737538167; c=relaxed/simple;
	bh=BUWmivnOW41tAfcqCmJ4dFK+yRjq4XacnpPS4JqkpQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S4zlhm0c5LJvpoFr+Gh8K2O6tEW6gdqELur/wuORrbXKr4Tk3tZpFbuu6GnvonV1GMcw5PnxkGKc+Q9E6FgdIhQ5sMyYsJgKjxt9OOxOiSw5o0Vqc2GXYzdp6g9kc6Pm7rKtyRSD0SvP2E3RtidRc9yE6/jbBdDCPfHIYhzRA+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+EKNke4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+EKNke4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B2CC4CED6;
	Wed, 22 Jan 2025 09:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737538166;
	bh=BUWmivnOW41tAfcqCmJ4dFK+yRjq4XacnpPS4JqkpQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S+EKNke4H2GroxlU0GFMGoc6sBsDG4UFQUfx0QCPC6xhfpfdFcUoFX4n6LtSIB4H6
	 qYIZcqkIxVyyeNbgVtpNrApulQOrGL+lR460TT99z7OkCgvPxltXmJF2xP+TLawIgV
	 X0xw60EHoGrYOja4oUU4xCrt+lV79BPMtFepsNgQ=
Date: Wed, 22 Jan 2025 10:29:22 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: Jon Hunter <jonathanh@nvidia.com>,
	Salvatore Bonaccorso <carnil@debian.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
Message-ID: <2025012204-defense-squeak-9aa6@gregkh>
References: <20250121174532.991109301@linuxfoundation.org>
 <Z5AVm4cQDGjnDet2@eldamar.lan>
 <449456d8-4e9a-4ee3-a3e8-8675cbde4a5c@nvidia.com>
 <a0fee4a8-2406-45ba-8d66-ab02ca8a6928@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a0fee4a8-2406-45ba-8d66-ab02ca8a6928@w6rz.net>

On Wed, Jan 22, 2025 at 01:01:42AM -0800, Ron Economos wrote:
> On 1/21/25 23:04, Jon Hunter wrote:
> > Hi Greg,
> > 
> > On 21/01/2025 21:46, Salvatore Bonaccorso wrote:
> > > Hi Greg,
> > > 
> > > On Tue, Jan 21, 2025 at 06:50:48PM +0100, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.12.11 release.
> > > > There are 122 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > >     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.11-rc1.gz
> > > > 
> > > > or in the git tree and branch at:
> > > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > > linux-6.12.y
> > > > and the diffstat can be found below.
> > > 
> > > Built and lightly tested, when booting I'm noticing the following in
> > > dmesg:
> > > 
> > > [  +0.007932] ------------[ cut here ]------------
> > > [  +0.000003] WARNING: CPU: 1 PID: 0 at kernel/sched/fair.c:5250
> > > place_entity+0x127/0x130
> > > [  +0.000006] Modules linked in: ahci(E) libahci(E) crc32_pclmul(E)
> > > xhci_hcd(E) libata(E) psmouse(E) crc32c_intel(E) >
> > > [  +0.000021] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Tainted:
> > > G            E      6.12.11-rc1+ #1
> > > [  +0.000004] Tainted: [E]=UNSIGNED_MODULE
> > > [  +0.000002] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> > > BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> > > [  +0.000002] RIP: 0010:place_entity+0x127/0x130
> > > [  +0.000003] Code: 01 6b 28 c6 43 52 00 5b 5d 41 5c 41 5d 41 5e e9
> > > 2f 83 bc 00 b9 02 00 00 00 49 c1 ee 0a 49 39 ce 4>
> > > [  +0.000002] RSP: 0018:ffffbe1f400f8d08 EFLAGS: 00010046
> > > [  +0.000003] RAX: 0000000000000000 RBX: ffff9ed7c0c0f200 RCX:
> > > 00000000000000c2
> > > [  +0.000002] RDX: 0000000000000000 RSI: 000000000000001d RDI:
> > > 000000000078cfd5
> > > [  +0.000002] RBP: 0000000029d40d60 R08: 00000000a8e83f00 R09:
> > > 0000000000000002
> > > [  +0.000002] R10: 00000000006e3ab2 R11: ffff9ed7d4056690 R12:
> > > ffff9ed83bd360c0
> > > [  +0.000002] R13: 0000000000000000 R14: 00000000000000c2 R15:
> > > 000000000016e360
> > > [  +0.000003] FS:  0000000000000000(0000) GS:ffff9ed83bd00000(0000)
> > > knlGS:0000000000000000
> > > [  +0.000002] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [  +0.000002] CR2: 00007f9f5a7245d8 CR3: 0000000100bfc000 CR4:
> > > 0000000000350ef0
> > > [  +0.000003] Call Trace:
> > > [  +0.000003]  <IRQ>
> > > [  +0.000002]  ? place_entity+0x127/0x130
> > > [  +0.000002]  ? __warn.cold+0x93/0xf6
> > > [  +0.000004]  ? place_entity+0x127/0x130
> > > [  +0.000003]  ? report_bug+0xff/0x140
> > > [  +0.000005]  ? handle_bug+0x58/0x90
> > > [  +0.000002]  ? exc_invalid_op+0x17/0x70
> > > [  +0.000003]  ? asm_exc_invalid_op+0x1a/0x20
> > > [  +0.000006]  ? place_entity+0x127/0x130
> > > [  +0.000003]  ? place_entity+0x99/0x130
> > > [  +0.000004]  reweight_entity+0x1af/0x1d0
> > > [  +0.000003]  enqueue_task_fair+0x30c/0x5e0
> > > [  +0.000005]  enqueue_task+0x35/0x150
> > > [  +0.000004]  activate_task+0x3a/0x60
> > > [  +0.000003]  sched_balance_rq+0x7c6/0xee0
> > > [  +0.000008]  sched_balance_domains+0x25b/0x350
> > > [  +0.000005]  handle_softirqs+0xcf/0x280
> > > [  +0.000006]  __irq_exit_rcu+0x8d/0xb0
> > > [  +0.000003]  sysvec_apic_timer_interrupt+0x71/0x90
> > > [  +0.000003]  </IRQ>
> > > [  +0.000002]  <TASK>
> > > [  +0.000002]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> > > [  +0.000002] RIP: 0010:pv_native_safe_halt+0xf/0x20
> > > [  +0.000004] Code: 22 d7 e9 b4 01 01 00 0f 1f 40 00 90 90 90 90 90
> > > 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 0>
> > > [  +0.000002] RSP: 0018:ffffbe1f400bbed8 EFLAGS: 00000202
> > > [  +0.000003] RAX: 0000000000000001 RBX: ffff9ed7c033e600 RCX:
> > > ffff9ed7c0647830
> > > [  +0.000001] RDX: 0000000000000000 RSI: 0000000000000001 RDI:
> > > 00000000000017b4
> > > [  +0.000002] RBP: 0000000000000001 R08: 0000000000000001 R09:
> > > 0000000000000000
> > > [  +0.000002] R10: 0000000000000001 R11: 0000000000000000 R12:
> > > 0000000000000000
> > > [  +0.000001] R13: 0000000000000000 R14: 0000000000000000 R15:
> > > 0000000000000000
> > > [  +0.000006]  default_idle+0x9/0x20
> > > [  +0.000003]  default_idle_call+0x29/0x100
> > > [  +0.000002]  do_idle+0x1fe/0x240
> > > [  +0.000005]  cpu_startup_entry+0x29/0x30
> > > [  +0.000003]  start_secondary+0x11e/0x140
> > > [  +0.000004]  common_startup_64+0x13e/0x141
> > > [  +0.000007]  </TASK>
> > > [  +0.000001] ---[ end trace 0000000000000000 ]---
> > > 
> > > Not yet bisected which change causes it.
> > 
> > 
> > I am seeing the same on Tegra. I have not looked to see which change
> > this is yet either.
> > 
> > Jon
> > 
> Seeing this on RISC-V also.
> 
> Jan 21 23:51:10 riscv64 kernel: WARNING: CPU: 3 PID: 16 at
> kernel/sched/fair.c:5250 place_entity+0x108/0x110
> Jan 21 23:51:10 riscv64 kernel: Modules linked in:
> Jan 21 23:51:10 riscv64 kernel: CPU: 3 UID: 0 PID: 16 Comm: rcu_preempt Not
> tainted 6.12.11-rc1 #2
> Jan 21 23:51:10 riscv64 kernel: Hardware name: SiFive HiFive Unmatched A00
> (DT)
> Jan 21 23:51:10 riscv64 kernel: epc : place_entity+0x108/0x110
> Jan 21 23:51:10 riscv64 kernel:  ra : place_entity+0x9c/0x110
> Jan 21 23:51:10 riscv64 kernel: epc : ffffffff8006ed68 ra : ffffffff8006ecfc
> sp : ffffffc60009bac0
> Jan 21 23:51:10 riscv64 kernel:  gp : ffffffff81fa6318 tp : ffffffd680323b00
> t0 : 0000000000000000
> Jan 21 23:51:10 riscv64 kernel:  t1 : 0000000000000000 t2 : 0000000000000000
> s0 : ffffffc60009bb00
> Jan 21 23:51:10 riscv64 kernel:  s1 : ffffffd6809f5000 a0 : 000000000053b491
> a1 : 0000000000000000
> Jan 21 23:51:10 riscv64 kernel:  a2 : 0000000000000002 a3 : 0000000000000000
> a4 : 0000000000000000
> Jan 21 23:51:10 riscv64 kernel:  a5 : 0000000000000000 a6 : 0000000000000000
> a7 : 0000000000000000
> Jan 21 23:51:10 riscv64 kernel:  s2 : 0000000031acb37b s3 : 0000000000000000
> s4 : 000000000006920d
> Jan 21 23:51:10 riscv64 kernel:  s5 : ffffffd9fedb2a00 s6 : ffffffd9fedb2900
> s7 : ffffffd6829cbb00
> Jan 21 23:51:10 riscv64 kernel:  s8 : 0000000000000000 s9 : 0000000000000001
> s10: 0000000000000201
> Jan 21 23:51:10 riscv64 kernel:  s11: 0000000000000000 t3 : 0000000000000000
> t4 : 0000000000000000
> Jan 21 23:51:10 riscv64 kernel:  t5 : 0000000000000000 t6 : 0000000000000000
> Jan 21 23:51:10 riscv64 kernel: status: 0000000200000100 badaddr:
> 0000000000000002 cause: 0000000000000003
> Jan 21 23:51:10 riscv64 kernel: [<ffffffff8006ed68>]
> place_entity+0x108/0x110
> Jan 21 23:51:10 riscv64 kernel: [<ffffffff8006efe2>]
> reweight_entity+0x182/0x1b0
> Jan 21 23:51:10 riscv64 kernel: [<ffffffff8006f0c8>]
> update_cfs_group+0x78/0xa8
> Jan 21 23:51:10 riscv64 kernel: [<ffffffff8006fc4c>]
> dequeue_entities+0x114/0x3d8
> Jan 21 23:51:10 riscv64 kernel: [<ffffffff80070084>]
> pick_task_fair+0xb4/0x110
> Jan 21 23:51:10 riscv64 kernel: [<ffffffff80077a3c>]
> pick_next_task_fair+0x1c/0x2f0
> Jan 21 23:51:10 riscv64 kernel: [<ffffffff80dc5556>] __schedule+0x176/0xc20
> Jan 21 23:51:10 riscv64 kernel: [<ffffffff80dc6022>] schedule+0x22/0x148
> Jan 21 23:51:10 riscv64 kernel: [<ffffffff80dcc072>]
> schedule_timeout+0x82/0x178
> Jan 21 23:51:10 riscv64 kernel: [<ffffffff800cb996>]
> rcu_gp_fqs_loop+0x346/0x4e8
> Jan 21 23:51:10 riscv64 kernel: [<ffffffff800cea62>]
> rcu_gp_kthread+0x12a/0x150
> Jan 21 23:51:10 riscv64 kernel: [<ffffffff8004db58>] kthread+0xc8/0xe8
> Jan 21 23:51:10 riscv64 kernel: [<ffffffff80dceefe>] ret_from_fork+0xe/0x18
> Jan 21 23:51:10 riscv64 kernel: ---[ end trace 0000000000000000 ]---
> 
> Reverting commit 11d21f2ae4a254aeef84fcf7b6314f5dd045151f "sched/fair: Fix
> EEVDF entity placement bug causing scheduling lag" removes the warning.

Ah, thanks!  I'll go revert that now and push out a -rc2.

greg k-h
