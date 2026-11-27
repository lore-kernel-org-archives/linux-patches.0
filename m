Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795796831;
	b=GUGJWWxGzDyEGRh84LE+0ZGFveX/Zqo1HaDCyockvtZFa71Vk6F25lh2MBKCN2jnM/LZ
	 AX0X3sd1TOzvIcgZcs2miYqe0Vwpj2e/bxGZJCL/GHwCsqC+Qp3V32Sb9Fyxg6wjjp3sn
	 Glshxqminoy+sJEy6fDp/G+CCIV4VtFouZFE80dvEVhwf0NGI5ilCb9PXTlntDxj6r+zM
	 Qhs9yE8UTexGXnlZm3QUj7ljgVP8hh4GrkkqWpmcGcTpPpK0S7OHRwgEKZWO1y8EDunzy
	 uUM69L/Ef/KxDPCsm74yzQikGR7livFIpA2MYnpRzcFctZhuFPq45yDQs5EzoTBnr6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795796831;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:Autocrypt:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=AqNIVKbwo2V2tWT49BvLRGDtzMkAEYOoeWHW8Z2m+l8=;
	b=eapq02h8NJjGAvFpPUBLwYMeeIizxJ+hUxmByFZCuS5+xsJEDw/49bIqP5o5RxomhlGi
	 JliyLrgpogAoPcyxiEsA2bF2i1OmeGAQbCUjEc0CAZUJd1T0o12t3Q3LxkHv0GDkoaq9E
	 O7yt0anpoeGwVCwKILU64rLukRo8fFpFl3u0Z+jiIeQxlt1gT2/gt9QfS8UdixNXvACq/
	 RN3xOpDqC//wNdT8jr+Z05SOtctLyqbu7kTxT4kGt39OKq+4vIFYTyZW/r1EJOE3ZnxsQ
	 YlKrEvUl93swHA8bJe/3fNxfp1VGo2IqHH8dsXjuGSwjYlB5M/i8m4cit+kRjjetFDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MblodTDw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADF0606A321;
	Fri, 27 Nov 2026 16:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MblodTDw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A3C1F00898;
	Fri, 27 Nov 2026 16:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795796831;
	bh=AqNIVKbwo2V2tWT49BvLRGDtzMkAEYOoeWHW8Z2m+l8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MblodTDwZ/BDl8VaFcJf0gHg6mH3B7XCCYblpy9ZIKVB7a9cEIEWYD6Ym0hCWGmiS
	 A2EtjHA608dR+sxheU6GaDtIqiL2A8UL1s5KXRxZeYn1i2m9M9Z/7FSR5MXbpvXcke
	 eDoxV82jaWCYusRwiGLWXABFSiuAkUJFAf8kTh3A+w/dg8Q1eRtPfLzbhrT3DwOAN6
	 bedfx4aQcrR18+jicoVrEKMV7WzcR+UCBybpt7eUlAIvzo1xE9fBo6xJhY+2BC4aDf
	 o9mVoiGuiRamQ3rw0f/dtAdSONAdKyLP4UM2n/Bbq4t5dwvSY68JNbc+/vHjOXFCiF
	 mAoP+jhTTVpAw==
Message-ID: <100e9459-ac70-4a3f-aed3-eefa395ebd78@kernel.org>
Date: Fri, 27 Nov 2026 17:27:02 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc2 review
Content-Language: fr
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com, "Michael S. Tsirkin"
 <mst@redhat.com>, sungbyeongchan <tjdqudcks0424@naver.com>
References: <20261126105725.767748294@linuxfoundation.org>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20261126105725.767748294@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Greg,

(+ cc: Michael)

Thank you for the new version!

On 26/11/2026 11:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.66 release.
> There are 990 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Our CI is applying patches from the stable-queue repo, and since the
24th of November, the VM on v6.18 fail to boot:


================================== 8< ==================================
[    0.770445] NET: Registered PF_VSOCK protocol family
[   21.748843] rcu: INFO: rcu_preempt self-detected stall on CPU
[   21.748843] rcu: 	2-....: (21000 ticks this GP) idle=d25c/1/0x4000000000000000 softirq=17/17 fqs=4766
[   21.748843] rcu: 	(t=21004 jiffies g=-1131 q=18 ncpus=4)
[   21.748843] CPU: 2 UID: 0 PID: 30 Comm: kworker/2:0 Not tainted 6.18.65 #1 PREEMPT(voluntary) 
[   21.748843] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   21.748843] Workqueue: events control_work_handler
[   21.748843] RIP: 0010:detach_buf_split (drivers/virtio/virtio_ring.c:795)
[   21.748843] Code: 01 48 85 c0 0f 84 83 00 00 00 48 8b 40 08 45 31 c0 2e 2e 2e ff d0 0f b7 5b 0e 41 83 46 2c 01 48 c1 e3 04 4c 01 fb 0f b7 43 0c <a8> 01 74 18 41 0f b6 56 41 a8 04 75 a4 84 d2 74 db 48 8b 33 48 83
All code
========
   0:	01 48 85             	add    %ecx,-0x7b(%rax)
   3:	c0 0f 84             	rorb   $0x84,(%rdi)
   6:	83 00 00             	addl   $0x0,(%rax)
   9:	00 48 8b             	add    %cl,-0x75(%rax)
   c:	40 08 45 31          	rex or %al,0x31(%rbp)
  10:	c0 2e 2e             	shrb   $0x2e,(%rsi)
  13:	2e ff d0             	cs call *%rax
  16:	0f b7 5b 0e          	movzwl 0xe(%rbx),%ebx
  1a:	41 83 46 2c 01       	addl   $0x1,0x2c(%r14)
  1f:	48 c1 e3 04          	shl    $0x4,%rbx
  23:	4c 01 fb             	add    %r15,%rbx
  26:	0f b7 43 0c          	movzwl 0xc(%rbx),%eax
  2a:*	a8 01                	test   $0x1,%al		<-- trapping instruction
  2c:	74 18                	je     0x46
  2e:	41 0f b6 56 41       	movzbl 0x41(%r14),%edx
  33:	a8 04                	test   $0x4,%al
  35:	75 a4                	jne    0xffffffffffffffdb
  37:	84 d2                	test   %dl,%dl
  39:	74 db                	je     0x16
  3b:	48 8b 33             	mov    (%rbx),%rsi
  3e:	48                   	rex.W
  3f:	83                   	.byte 0x83

Code starting with the faulting instruction
===========================================
   0:	a8 01                	test   $0x1,%al
   2:	74 18                	je     0x1c
   4:	41 0f b6 56 41       	movzbl 0x41(%r14),%edx
   9:	a8 04                	test   $0x4,%al
   b:	75 a4                	jne    0xffffffffffffffb1
   d:	84 d2                	test   %dl,%dl
   f:	74 db                	je     0xffffffffffffffec
  11:	48 8b 33             	mov    (%rbx),%rsi
  14:	48                   	rex.W
  15:	83                   	.byte 0x83
[   21.748843] RSP: 0018:ffffc90000113d98 EFLAGS: 00000282
[   21.748843] RAX: 0000000000000003 RBX: ffff8881013b9420 RCX: 0000000000000000
[   21.748843] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888101541700
[   21.748843] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff888100357a40
[   21.748843] R10: ffff888100056ac0 R11: fefefefefefefeff R12: 0000000000000000
[   21.748843] R13: 0000000000000000 R14: ffff888101541700 R15: ffff8881013b8000
[   21.748843] FS:  0000000000000000(0000) GS:ffff8881b8e0f000(0000) knlGS:0000000000000000
[   21.748843] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   21.748843] CR2: 0000000000000000 CR3: 0000000002648001 CR4: 0000000000370ef0
[   21.748843] Call Trace:
[   21.748843]  <TASK>
[   21.748843]  virtqueue_get_buf_ctx_split (drivers/virtio/virtio_ring.c:862)
[   21.748843]  control_work_handler (include/linux/spinlock.h:391)
[   21.748843]  process_one_work (arch/x86/include/asm/jump_label.h:36)
[   21.748843]  worker_thread (kernel/workqueue.c:3384 (discriminator 2))
[   21.748843]  ? __pfx_worker_thread (kernel/workqueue.c:3417)
[   21.748843]  kthread (kernel/kthread.c:432)
[   21.748843]  ? __pfx_kthread (kernel/kthread.c:381)
[   21.748843]  ? __pfx_kthread (kernel/kthread.c:381)
[   21.748843]  ret_from_fork (arch/x86/kernel/process.c:164)
[   21.748843]  ? __pfx_kthread (kernel/kthread.c:381)
[   21.748843]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
[   21.748843]  </TASK>
[   48.525527] watchdog: BUG: soft lockup - CPU#2 stuck for 45s! [kworker/2:0:30]
[   48.525532] Modules linked in:
[   48.525537] CPU: 2 UID: 0 PID: 30 Comm: kworker/2:0 Not tainted 6.18.65 #1 PREEMPT(voluntary) 
[   48.525539] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   48.525541] Workqueue: events control_work_handler
[   48.525549] RIP: 0010:detach_buf_split (drivers/virtio/virtio_ring.c:795)
[   48.525552] Code: 80 18 03 00 00 83 c1 01 48 85 c0 0f 84 83 00 00 00 48 8b 40 08 45 31 c0 2e 2e 2e ff d0 0f b7 5b 0e 41 83 46 2c 01 48 c1 e3 04 <4c> 01 fb 0f b7 43 0c a8 01 74 18 41 0f b6 56 41 a8 04 75 a4 84 d2
All code
========
   0:	80 18 03             	sbbb   $0x3,(%rax)
   3:	00 00                	add    %al,(%rax)
   5:	83 c1 01             	add    $0x1,%ecx
   8:	48 85 c0             	test   %rax,%rax
   b:	0f 84 83 00 00 00    	je     0x94
  11:	48 8b 40 08          	mov    0x8(%rax),%rax
  15:	45 31 c0             	xor    %r8d,%r8d
  18:	2e 2e 2e ff d0       	cs cs cs call *%rax
  1d:	0f b7 5b 0e          	movzwl 0xe(%rbx),%ebx
  21:	41 83 46 2c 01       	addl   $0x1,0x2c(%r14)
  26:	48 c1 e3 04          	shl    $0x4,%rbx
  2a:*	4c 01 fb             	add    %r15,%rbx		<-- trapping instruction
  2d:	0f b7 43 0c          	movzwl 0xc(%rbx),%eax
  31:	a8 01                	test   $0x1,%al
  33:	74 18                	je     0x4d
  35:	41 0f b6 56 41       	movzbl 0x41(%r14),%edx
  3a:	a8 04                	test   $0x4,%al
  3c:	75 a4                	jne    0xffffffffffffffe2
  3e:	84 d2                	test   %dl,%dl

Code starting with the faulting instruction
===========================================
   0:	4c 01 fb             	add    %r15,%rbx
   3:	0f b7 43 0c          	movzwl 0xc(%rbx),%eax
   7:	a8 01                	test   $0x1,%al
   9:	74 18                	je     0x23
   b:	41 0f b6 56 41       	movzbl 0x41(%r14),%edx
  10:	a8 04                	test   $0x4,%al
  12:	75 a4                	jne    0xffffffffffffffb8
  14:	84 d2                	test   %dl,%dl
[   48.525553] RSP: 0018:ffffc90000113d98 EFLAGS: 00000216
[   48.525554] RAX: 0000000000000003 RBX: 00000000000011c0 RCX: 0000000000000000
[   48.525555] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888101541700
[   48.525556] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff888100357a40
[   48.525556] R10: ffff888100056ac0 R11: fefefefefefefeff R12: 0000000000000000
[   48.525556] R13: 0000000000000000 R14: ffff888101541700 R15: ffff8881013b8000
[   48.525568] FS:  0000000000000000(0000) GS:ffff8881b8e0f000(0000) knlGS:0000000000000000
[   48.525569] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   48.525569] CR2: 0000000000000000 CR3: 0000000002648001 CR4: 0000000000370ef0
[   48.525570] Call Trace:
[   48.525572]  <TASK>
[   48.525575]  virtqueue_get_buf_ctx_split (drivers/virtio/virtio_ring.c:862)
[   48.525577]  control_work_handler (include/linux/spinlock.h:391)
[   48.525579]  process_one_work (arch/x86/include/asm/jump_label.h:36)
[   48.525584]  worker_thread (kernel/workqueue.c:3384 (discriminator 2))
[   48.525585]  ? __pfx_worker_thread (kernel/workqueue.c:3417)
[   48.525587]  kthread (kernel/kthread.c:432)
[   48.525590]  ? __pfx_kthread (kernel/kthread.c:381)
[   48.525591]  ? __pfx_kthread (kernel/kthread.c:381)
[   48.525593]  ret_from_fork (arch/x86/kernel/process.c:164)
[   48.525596]  ? __pfx_kthread (kernel/kthread.c:381)
[   48.525598]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
[   48.525602]  </TASK>
[   48.525603] Kernel panic - not syncing: softlockup: hung tasks
[   48.525842] CPU: 2 UID: 0 PID: 30 Comm: kworker/2:0 Tainted: G             L      6.18.65 #1 PREEMPT(voluntary) 
[   48.525842] Tainted: [L]=SOFTLOCKUP
[   48.525842] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   48.525842] Workqueue: events control_work_handler
[   48.525842] Call Trace:
[   48.525842]  <IRQ>
[   48.525842]  dump_stack_lvl (lib/dump_stack.c:122)
[   48.525842]  vpanic (kernel/panic.c:495)
[   48.525842]  ? __pfx_watchdog_timer_fn (kernel/watchdog.c:745)
[   48.525842]  panic (kernel/panic.c:760)
[   48.525842]  watchdog_timer_fn.cold (kernel/watchdog.c:839)
[   48.525842]  __hrtimer_run_queues (kernel/time/hrtimer.c:1782)
[   48.525842]  hrtimer_interrupt (kernel/time/hrtimer.c:1911)
[   48.525842]  __sysvec_apic_timer_interrupt (arch/x86/include/asm/jump_label.h:36)
[   48.525842]  sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1052 (discriminator 47))
[   48.525842]  </IRQ>
[   48.525842]  <TASK>
[   48.525842]  asm_sysvec_apic_timer_interrupt (arch/x86/include/asm/idtentry.h:697)
[   48.525842] RIP: 0010:detach_buf_split (drivers/virtio/virtio_ring.c:795)
[   48.525842] Code: 80 18 03 00 00 83 c1 01 48 85 c0 0f 84 83 00 00 00 48 8b 40 08 45 31 c0 2e 2e 2e ff d0 0f b7 5b 0e 41 83 46 2c 01 48 c1 e3 04 <4c> 01 fb 0f b7 43 0c a8 01 74 18 41 0f b6 56 41 a8 04 75 a4 84 d2
All code
========
   0:	80 18 03             	sbbb   $0x3,(%rax)
   3:	00 00                	add    %al,(%rax)
   5:	83 c1 01             	add    $0x1,%ecx
   8:	48 85 c0             	test   %rax,%rax
   b:	0f 84 83 00 00 00    	je     0x94
  11:	48 8b 40 08          	mov    0x8(%rax),%rax
  15:	45 31 c0             	xor    %r8d,%r8d
  18:	2e 2e 2e ff d0       	cs cs cs call *%rax
  1d:	0f b7 5b 0e          	movzwl 0xe(%rbx),%ebx
  21:	41 83 46 2c 01       	addl   $0x1,0x2c(%r14)
  26:	48 c1 e3 04          	shl    $0x4,%rbx
  2a:*	4c 01 fb             	add    %r15,%rbx		<-- trapping instruction
  2d:	0f b7 43 0c          	movzwl 0xc(%rbx),%eax
  31:	a8 01                	test   $0x1,%al
  33:	74 18                	je     0x4d
  35:	41 0f b6 56 41       	movzbl 0x41(%r14),%edx
  3a:	a8 04                	test   $0x4,%al
  3c:	75 a4                	jne    0xffffffffffffffe2
  3e:	84 d2                	test   %dl,%dl

Code starting with the faulting instruction
===========================================
   0:	4c 01 fb             	add    %r15,%rbx
   3:	0f b7 43 0c          	movzwl 0xc(%rbx),%eax
   7:	a8 01                	test   $0x1,%al
   9:	74 18                	je     0x23
   b:	41 0f b6 56 41       	movzbl 0x41(%r14),%edx
  10:	a8 04                	test   $0x4,%al
  12:	75 a4                	jne    0xffffffffffffffb8
  14:	84 d2                	test   %dl,%dl
[   48.525842] RSP: 0018:ffffc90000113d98 EFLAGS: 00000216
[   48.525842] RAX: 0000000000000003 RBX: 00000000000011c0 RCX: 0000000000000000
[   48.525842] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888101541700
[   48.525842] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff888100357a40
[   48.525842] R10: ffff888100056ac0 R11: fefefefefefefeff R12: 0000000000000000
[   48.525842] R13: 0000000000000000 R14: ffff888101541700 R15: ffff8881013b8000
[   48.525842]  virtqueue_get_buf_ctx_split (drivers/virtio/virtio_ring.c:862)
[   48.594867]  control_work_handler (include/linux/spinlock.h:391)
[   48.594867]  process_one_work (arch/x86/include/asm/jump_label.h:36)
[   48.594867]  worker_thread (kernel/workqueue.c:3384 (discriminator 2))
[   48.594867]  ? __pfx_worker_thread (kernel/workqueue.c:3417)
[   48.594867]  kthread (kernel/kthread.c:432)
[   48.594867]  ? __pfx_kthread (kernel/kthread.c:381)
[   48.594867]  ? __pfx_kthread (kernel/kthread.c:381)
[   48.594867]  ret_from_fork (arch/x86/kernel/process.c:164)
[   48.594867]  ? __pfx_kthread (kernel/kthread.c:381)
[   48.594867]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
[   48.594867]  </TASK>
[   48.594867] Dumping ftrace buffer:
[   48.594867]    (ftrace buffer empty)
[   48.594867] Kernel Offset: disabled
================================== 8< ==================================

https://github.com/multipath-tcp/mptcp_net-next/actions/runs/45869531463/job/140081085299

(I'm just surprised nobody else hit that :) )


I guess this is linked to one of these three patches (which are linked)

  virtio_ring: code cleanup in detach_buf_split
  virtio_ring: factor out split indirect detaching logic
  virtio_ring: use shadow flags when detaching split descriptors

They are the only ones modifying drivers/virtio/virtio_ring.c I think.

Do you want me to investigate more?

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

