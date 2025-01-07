Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F3953F9FB
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 04:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736224136; cv=none; b=hVHaTgPDkGJZQoNb4NP11/T39F7n0AmOg8P2iQaJ6+ZV6VRkMIWopWr6L18gGuw1XZgFVayIxb7gs/jDDT0SMDq66ep8sf1XSrTniNs68WczqUclTVgNLb6QzhGO/epeQpbpSc9rKVSlVIAelqWpqigKtlPjNaGrbaXSoSu7y+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736224136; c=relaxed/simple;
	bh=RjVyohkVhiny/GUZSgnTvR9eoIbbwiqgn3dGDkv03Qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWEYh/vJVvQlWEYXiw/6Q5EtCBNwLXldegp6xykVSqoTWPCGn0GAgC8D8drBd5B4O/IPzveHNfVG6S5yZ3SE3/vCeV7222C+K+aKkFlCKlMMEvGEAsDnCSgbjX8yRCmahi2WcVOYAdGh5gkBgAUs4cKU4V4Olhf4plc0ZwT3MtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=lmATPYBP; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="lmATPYBP"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id CA8BB14C1E1;
	Tue,  7 Jan 2025 05:28:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1736224131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X3WMOTo+IoF3n0gzjkw/T1s85IGr+PB+4o6Rd5v9X70=;
	b=lmATPYBPRF0SKrmo3VDFgy/0L28B/2TMEgQo0Gjw5abZaCGrTPVcfuji9W3wyh+YKNhPoW
	wbr2dkRis9h2U4bN4Axmi4aNe1VQMNH0B8zBLi4uML+Pci4OQZt0x2X2hli/8BCYXeMuOY
	KYBs37c/Dq7qvYGheQaQWQQ9O8rHBOvM1cz/MfFQd1Ngf6YxIFn+qr62pMrxip5uWGFTZ3
	rlTLxL1yRqCiIczltRZacXwqxiJrkVD8bNu0cR9TarC4v1RiiD0AM2L2e9BwkxuQdn15ZK
	1BbRpEWURCgH1TdpGIditke4Oa5Zc64aQVJZroaqPVzTJJQ9pOME0ALwlpxgNQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 11f130a8;
	Tue, 7 Jan 2025 04:28:47 +0000 (UTC)
Date: Tue, 7 Jan 2025 13:28:32 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 098/138] zram: fix uninitialized ZRAM not releasing
 backing device
Message-ID: <Z3ytcILx4S1v_ueJ@codewreck.org>
References: <20250106151133.209718681@linuxfoundation.org>
 <20250106151136.941319893@linuxfoundation.org>
 <Z3yUHnBIiz9q_jgf@codewreck.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z3yUHnBIiz9q_jgf@codewreck.org>

Dominique Martinet wrote on Tue, Jan 07, 2025 at 11:40:30AM +0900:
> I'll look a bit more into it today and reply to this mail with anything
> I've found.
> (didn't test on master or anything else either)

So:
- master has no problem
- 5.10.233-rc1, 5.15.176-rc1, 6.1.124-rc1 have the same issue
- 6.6.70-rc1 is also fine
- My previous mail lacked stacktrace decoding, here's a new backtrace
with proper decoding on 6.1.124-rc1, produced by virtme-ng +
decode_stacktrace.sh (end of the mail)
vng -e 'dmesg -C; echo 1 | sudo tee /sys/class/block/zram0/reset || dmesg'
- looking at said backtrace, a likely difference would be the
multi-stream rework, in particular commit 7ac07a26dea7 ("zram:
preparation for multi-zcomp support") that changed how freeing works.
... and cherry-picking it on 6.1 does fix the issue.
Unfortunately it doesn't cherry-pick cleanly to 5.15 and 5.10, so for
these two I'm not sure if it's better to just drop this "zram: fix
uninitialized ZRAM not releasing backing device" commit, or if we should
try harder to backport prerequisites (e55e1b483156 ("block: move from
strlcpy with unused retval to strscpy") is an obvious one that is not
too hard to pick even if not clean, but that wasn't enough and I didn't
try further).

I've at least checked that dropping this patch is enough, and will not
do anything else on this for now.




(nothing aside of the symbolized backtrace below)
-----------------

[    2.184091] BUG: kernel NULL pointer dereference, address: 0000000000000000
[    2.184094] #PF: supervisor read access in kernel mode
[    2.184096] #PF: error_code(0x0000) - not-present page
[    2.184098] PGD 0 P4D 0
[    2.184101] Oops: 0000 [#1] PREEMPT SMP NOPTI
[    2.184104] CPU: 2 PID: 650 Comm: tee Not tainted 6.1.124-rc1+ #5
[    2.184107] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[    2.184109] RIP: 0010:zcomp_cpu_dead (drivers/block/zram/zcomp.c:171) 
[ 2.184115] Code: ff 31 c0 48 c7 c7 c8 4c 9b a1 48 89 43 08 48 89 03 e8 ac d1 2c 00 ba f4 ff ff ff eb bb 0f 1f 44 00 00 0f 1f 44 00 00 89 ff 53 <48> 8b 5e f0 48 03 1c fd 20 ea 9e a1 48 8b 7b 08 48 85 ff 74 11 48
All code
========
   0:	ff 31                	push   (%rcx)
   2:	c0 48 c7 c7          	rorb   $0xc7,-0x39(%rax)
   6:	c8 4c 9b a1          	enter  $0x9b4c,$0xa1
   a:	48 89 43 08          	mov    %rax,0x8(%rbx)
   e:	48 89 03             	mov    %rax,(%rbx)
  11:	e8 ac d1 2c 00       	call   0x2cd1c2
  16:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  1b:	eb bb                	jmp    0xffffffffffffffd8
  1d:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  22:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  27:	89 ff                	mov    %edi,%edi
  29:	53                   	push   %rbx
  2a:*	48 8b 5e f0          	mov    -0x10(%rsi),%rbx		<-- trapping instruction
  2e:	48 03 1c fd 20 ea 9e 	add    -0x5e6115e0(,%rdi,8),%rbx
  35:	a1 
  36:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
  3a:	48 85 ff             	test   %rdi,%rdi
  3d:	74 11                	je     0x50
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 8b 5e f0          	mov    -0x10(%rsi),%rbx
   4:	48 03 1c fd 20 ea 9e 	add    -0x5e6115e0(,%rdi,8),%rbx
   b:	a1 
   c:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
  10:	48 85 ff             	test   %rdi,%rdi
  13:	74 11                	je     0x26
  15:	48                   	rex.W
[    2.184117] RSP: 0018:ffffb556409ffd20 EFLAGS: 00010246
[    2.184120] RAX: ffffffffa0e09620 RBX: 0000000000000000 RCX: ffffffffa1c604c0
[    2.184122] RDX: 0000000000000000 RSI: 0000000000000010 RDI: 0000000000000000
[    2.184124] RBP: 0000000000000044 R08: 0000000000000000 R09: 000000000000000a
[    2.184125] R10: ffff9e20fe61b360 R11: 0fffffffffffffff R12: 0000000000000010
[    2.184127] R13: ffff9e20fe61b360 R14: ffffffffa0e09620 R15: 0000000000000000
[    2.184130] FS:  00007f4ffda3c740(0000) GS:ffff9e20fe680000(0000) knlGS:0000000000000000
[    2.184134] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.184136] CR2: 0000000000000000 CR3: 0000000005362000 CR4: 0000000000750ee0
[    2.184138] PKRU: 55555554
[    2.184139] Call Trace:
[    2.184141]  <TASK>
[    2.184144] ? __die_body.cold (arch/x86/kernel/dumpstack.c:478 arch/x86/kernel/dumpstack.c:465 arch/x86/kernel/dumpstack.c:420) 
[    2.184149] ? page_fault_oops (arch/x86/mm/fault.c:727) 
[    2.184153] ? srso_alias_return_thunk (arch/x86/lib/retpoline.S:131) 
[    2.184158] ? kernfs_iop_setattr (fs/kernfs/inode.c:137) 
[    2.184163] ? exc_page_fault (arch/x86/include/asm/irqflags.h:40 arch/x86/include/asm/irqflags.h:75 arch/x86/mm/fault.c:1439 arch/x86/mm/fault.c:1487) 
[    2.184168] ? asm_exc_page_fault (arch/x86/include/asm/idtentry.h:608) 
[    2.184172] ? zcomp_cpu_up_prepare (drivers/block/zram/zcomp.c:167) 
[    2.184176] ? zcomp_cpu_up_prepare (drivers/block/zram/zcomp.c:167) 
[    2.184179] ? zcomp_cpu_dead (drivers/block/zram/zcomp.c:171) 
[    2.184182] cpuhp_invoke_callback (kernel/cpu.c:202) 
[    2.184187] cpuhp_issue_call (kernel/cpu.c:2016) 
[    2.184190] __cpuhp_state_remove_instance (kernel/cpu.c:2224) 
[    2.184193] zcomp_destroy (drivers/block/zram/zcomp.c:197) 
[    2.184196] zram_reset_device (drivers/block/zram/zram_drv.c:1737) 
[    2.184199] reset_store (drivers/pci/pci-sysfs.c:1387) 
[    2.184204] kernfs_fop_write_iter (fs/kernfs/file.c:338) 
[    2.184208] vfs_write (include/linux/fs.h:2265 fs/read_write.c:491 fs/read_write.c:584) 
[    2.184214] ksys_write (fs/read_write.c:637) 
[    2.184217] do_syscall_64 (arch/x86/entry/common.c:51 arch/x86/entry/common.c:81) 
[    2.184220] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121) 
[    2.184224] RIP: 0033:0x7f4ffdb372c0
[ 2.184227] Code: 40 00 48 8b 15 41 9b 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 80 3d 21 23 0e 00 00 74 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 48 89
All code
========
   0:	40 00 48 8b          	rex add %cl,-0x75(%rax)
   4:	15 41 9b 0d 00       	adc    $0xd9b41,%eax
   9:	f7 d8                	neg    %eax
   b:	64 89 02             	mov    %eax,%fs:(%rdx)
   e:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  15:	eb b7                	jmp    0xffffffffffffffce
  17:	0f 1f 00             	nopl   (%rax)
  1a:	80 3d 21 23 0e 00 00 	cmpb   $0x0,0xe2321(%rip)        # 0xe2342
  21:	74 17                	je     0x3a
  23:	b8 01 00 00 00       	mov    $0x1,%eax
  28:	0f 05                	syscall
  2a:*	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax		<-- trapping instruction
  30:	77 58                	ja     0x8a
  32:	c3                   	ret
  33:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  3a:	48 83 ec 28          	sub    $0x28,%rsp
  3e:	48                   	rex.W
  3f:	89                   	.byte 0x89

Code starting with the faulting instruction
===========================================
   0:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
   6:	77 58                	ja     0x60
   8:	c3                   	ret
   9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  10:	48 83 ec 28          	sub    $0x28,%rsp
  14:	48                   	rex.W
  15:	89                   	.byte 0x89
[    2.184229] RSP: 002b:00007ffd10d35a78 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[    2.184232] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f4ffdb372c0
[    2.184233] RDX: 0000000000000002 RSI: 00007ffd10d35b90 RDI: 0000000000000003
[    2.184235] RBP: 00007ffd10d35b90 R08: 0000000000000004 R09: 0000000000000001
[    2.184236] R10: 00007f4ffda53f18 R11: 0000000000000202 R12: 0000000000000002
[    2.184238] R13: 0000559c792ae310 R14: 0000000000000002 R15: 00007f4ffdc0d9e0
[    2.184243]  </TASK>
[    2.184244] Modules linked in:
[    2.184247] CR2: 0000000000000000
[    2.184248] ---[ end trace 0000000000000000 ]---
[    2.184250] RIP: 0010:zcomp_cpu_dead (drivers/block/zram/zcomp.c:171) 
[ 2.184253] Code: ff 31 c0 48 c7 c7 c8 4c 9b a1 48 89 43 08 48 89 03 e8 ac d1 2c 00 ba f4 ff ff ff eb bb 0f 1f 44 00 00 0f 1f 44 00 00 89 ff 53 <48> 8b 5e f0 48 03 1c fd 20 ea 9e a1 48 8b 7b 08 48 85 ff 74 11 48
All code
========
   0:	ff 31                	push   (%rcx)
   2:	c0 48 c7 c7          	rorb   $0xc7,-0x39(%rax)
   6:	c8 4c 9b a1          	enter  $0x9b4c,$0xa1
   a:	48 89 43 08          	mov    %rax,0x8(%rbx)
   e:	48 89 03             	mov    %rax,(%rbx)
  11:	e8 ac d1 2c 00       	call   0x2cd1c2
  16:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  1b:	eb bb                	jmp    0xffffffffffffffd8
  1d:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  22:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  27:	89 ff                	mov    %edi,%edi
  29:	53                   	push   %rbx
  2a:*	48 8b 5e f0          	mov    -0x10(%rsi),%rbx		<-- trapping instruction
  2e:	48 03 1c fd 20 ea 9e 	add    -0x5e6115e0(,%rdi,8),%rbx
  35:	a1 
  36:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
  3a:	48 85 ff             	test   %rdi,%rdi
  3d:	74 11                	je     0x50
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 8b 5e f0          	mov    -0x10(%rsi),%rbx
   4:	48 03 1c fd 20 ea 9e 	add    -0x5e6115e0(,%rdi,8),%rbx
   b:	a1 
   c:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
  10:	48 85 ff             	test   %rdi,%rdi
  13:	74 11                	je     0x26
  15:	48                   	rex.W
[    2.184254] RSP: 0018:ffffb556409ffd20 EFLAGS: 00010246
[    2.184256] RAX: ffffffffa0e09620 RBX: 0000000000000000 RCX: ffffffffa1c604c0
[    2.184258] RDX: 0000000000000000 RSI: 0000000000000010 RDI: 0000000000000000
[    2.184259] RBP: 0000000000000044 R08: 0000000000000000 R09: 000000000000000a
[    2.184261] R10: ffff9e20fe61b360 R11: 0fffffffffffffff R12: 0000000000000010
[    2.184262] R13: ffff9e20fe61b360 R14: ffffffffa0e09620 R15: 0000000000000000
[    2.184266] FS:  00007f4ffda3c740(0000) GS:ffff9e20fe680000(0000) knlGS:0000000000000000
[    2.184269] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.184271] CR2: 0000000000000000 CR3: 0000000005362000 CR4: 0000000000750ee0
[    2.184273] PKRU: 55555554
[    2.184274] note: tee[650] exited with irqs disabled


Thanks,
-- 
Dominique
