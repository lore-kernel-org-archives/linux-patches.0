Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4543637C0FD;
	Tue, 24 Mar 2026 10:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774346460; cv=none; b=PU+Pb/AvoNbZkuxL9UU0FmQfbIqhc/NzNYOJEyd2nElPJpf5vei+Z1yPx1ZYvm6PVJVA7L5kGVOKU1zLuPOVZPLhgYFZoIzQOA1NJI4hBXMC2hdtRq+pefZgJT0rNkOkFPR9ncrxbID17QEBMMOEZorbc1limIrSe3pUdO/U3Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774346460; c=relaxed/simple;
	bh=uqI/fe+VQ0ECJLNh7ED9MIIYVDOciSY4Pq2+0eFQATg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S46zDtd48Pmcklk3qM0+vyNuVbK4XcJV1LTTNW56yB7fV5DctmIckBwG+DEEcdJ+8KB79mPKfXmzVwSPZuL9n47YxYUyx58okWnpVu0GEfiSA3VENSuErIdhomV5ADBQ8ehSXf6GoflW/VfyBPvvE8MBE33VP7PXHCOEffQebBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qP9TSKSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qP9TSKSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DA4C19424;
	Tue, 24 Mar 2026 10:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774346459;
	bh=uqI/fe+VQ0ECJLNh7ED9MIIYVDOciSY4Pq2+0eFQATg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qP9TSKSAVL2kuWeyBl+1YC35rectpuSZL1ULd/wsrNUoBtpOtuEZWr3VPt9vssWTS
	 0IY547sWw3A/mB3r1xeESYK97KCmnmXxJW0a0i0TJEjnZXQi+Eqw1hNIPFnFYTNiip
	 yRAvThSPyJtiU3R+tRr9CiRVV2hB+zqE2gcwE8QYUGSGSRf5m0/17+VX9VOcrRYDcX
	 R60u46u4id6CPdSfTpl38Rx84iqPzNQsu+DRoUozAo8kpVEJnlcEWAp1SMoUWYkz+8
	 VCv6eagZjpBQD0hDlRAquBaH7UgNB7TLMBOMuhRVhjqd9hBU42Ye0RjuFnvdz8jM2G
	 G4jvrfAPOTgMA==
Message-ID: <be03a2f9-f5ef-4431-818c-f0424366556d@kernel.org>
Date: Tue, 24 Mar 2026 11:00:54 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 6.6 438/567] net: use dst_dev_rcu() in sk_setup_caps()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, edumazet@google.com, kuniyu@google.com,
 kuba@kernel.org, dsahern@kernel.org, netdev@vger.kernel.org,
 Ruohan Lan <ruohanlan@aliyun.com>, Eric Dumazet <edumazet@google.com>,
 David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>
References: <20260323134533.749096647@linuxfoundation.org>
 <20260323134544.788448840@linuxfoundation.org>
From: Matthieu Baerts <matttbe@kernel.org>
Content-Language: fr
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20260323134544.788448840@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Greg, Ruohan,

On 23/03/2026 14:45, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.

I do!

> ------------------
> 
> From: Eric Dumazet <edumazet@google.com>
> 
> [ Upstream commit 99a2ace61b211b0be861b07fbaa062fca4b58879 ]
> 
> Use RCU to protect accesses to dst->dev from sk_setup_caps()
> and sk_dst_gso_max_size().
> 
> Also use dst_dev_rcu() in ip6_dst_mtu_maybe_forward(),
> and ip_dst_mtu_maybe_forward().
> 
> ip4_dst_hoplimit() can use dst_dev_net_rcu().
> 
> Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Link: https://patch.msgid.link/20250828195823.3958522-6-edumazet@google.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [ Adjust context ]

It looks like more adjustments are required: with this patch, running
the MPTCP 'diag.sh' selftest using kernel/configs/debug.config causes
this warning:


  =============================
  WARNING: suspicious RCU usage
  6.6.129 #1 Tainted: G                 N
  -----------------------------
  include/net/dst.h:577 suspicious rcu_dereference_check() usage!
  
  other info that might help us debug this:
  
  
  rcu_scheduler_active = 2, debug_locks = 1
  2 locks held by mptcp_connect/213:
  #0: ffff88810f9b0130 (sk_lock-AF_INET){+.+.}-{0:0}, at: inet_stream_connect (net/ipv4/af_inet.c:747) 
  #1: ffff88810fe28130 (k-sk_lock-AF_INET#2){+.+.}-{0:0}, at: mptcp_connect (net/mptcp/protocol.c:3883) 
  
  stack backtrace:
  CPU: 3 PID: 213 Comm: mptcp_connect Tainted: G                 N 6.6.129 #1
  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  Call Trace:
   <TASK>
  dump_stack_lvl (lib/dump_stack.c:107) 
  lockdep_rcu_suspicious (include/linux/context_tracking.h:153) 
  ip_dst_mtu_maybe_forward.constprop.0 (include/net/dst.h:577 (discriminator 13)) 
  ? __build_flow_key.constprop.0 (include/net/ip.h:457) 
  ? __lock_acquire (kernel/locking/lockdep.c:5719) 
  ? tcp_mtup_init (net/ipv4/tcp_output.c:1779 (discriminator 4)) 
  tcp_connect_init (net/ipv4/tcp_output.c:3804 (discriminator 1)) 
  ? tcp_sync_mss (net/ipv4/tcp_output.c:3786) 
  ? ipv4_dst_check (net/ipv4/route.c:1232) 
  ? __sk_dst_check (net/core/sock.c:601 (discriminator 2)) 
  ? inet_sk_rebuild_header (net/ipv4/af_inet.c:1316) 
  ? reacquire_held_locks (kernel/locking/lockdep.c:5405) 
  ? __lock_acquire (kernel/locking/lockdep.c:5719) 
  tcp_connect (net/ipv4/tcp_output.c:3986) 
  ? mark_held_locks (kernel/locking/lockdep.c:4274 (discriminator 1)) 
  ? tcp_send_syn_data (net/ipv4/tcp_output.c:3974) 
  ? trace_hardirqs_on (kernel/trace/trace_preemptirq.c:62 (discriminator 1)) 
  tcp_v4_connect (net/ipv4/tcp_ipv4.c:335 (discriminator 1)) 
  ? trace_tcp_bad_csum (net/ipv4/tcp_ipv4.c:214) 
  mptcp_connect (net/mptcp/protocol.c:3892) 
  __inet_stream_connect (net/ipv4/af_inet.c:676) 
  ? lockdep_hardirqs_on_prepare.part.0 (kernel/locking/lockdep.c:4300) 
  inet_stream_connect (net/ipv4/af_inet.c:748) 
  __sys_connect (net/socket.c:2056 (discriminator 2)) 
  ? __sys_connect_file (net/socket.c:2063) 
  ? update_socket_protocol+0x10/0x10
   
  __x64_sys_connect (net/socket.c:2083 (discriminator 1)) 
  ? syscall_enter_from_user_mode (arch/x86/include/asm/irqflags.h:42) 
  do_syscall_64 (arch/x86/entry/common.c:46 (discriminator 1)) 
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121) 
  RIP: 0033:0x7f2b23041186
  Code: 47 ba 04 00 00 00 48 8b 05 87 3c 19 00 64 89 10 48 c7 c2 ff ff ff ff c9 48 89 d0 c3 0f 1f 84 00 00 00 00 00 48 8b 45 10 0f 05 <48> 89 c2 48 3d 00 f0 ff ff 77 0f c9 48 89 d0 c3 66 2e 0f 1f 84 00
  All code
  ========
     0:	47 ba 04 00 00 00    	rex.RXB mov $0x4,%r10d
     6:	48 8b 05 87 3c 19 00 	mov    0x193c87(%rip),%rax        # 0x193c94
     d:	64 89 10             	mov    %edx,%fs:(%rax)
    10:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
    17:	c9                   	leave
    18:	48 89 d0             	mov    %rdx,%rax
    1b:	c3                   	ret
    1c:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    23:	00 
    24:	48 8b 45 10          	mov    0x10(%rbp),%rax
    28:	0f 05                	syscall
    2a:*	48 89 c2             	mov    %rax,%rdx		<-- trapping instruction
    2d:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
    33:	77 0f                	ja     0x44
    35:	c9                   	leave
    36:	48 89 d0             	mov    %rdx,%rax
    39:	c3                   	ret
    3a:	66                   	data16
    3b:	2e                   	cs
    3c:	0f                   	.byte 0xf
    3d:	1f                   	(bad)
    3e:	84 00                	test   %al,(%rax)
  
  Code starting with the faulting instruction
  ===========================================
     0:	48 89 c2             	mov    %rax,%rdx
     3:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
     9:	77 0f                	ja     0x1a
     b:	c9                   	leave
     c:	48 89 d0             	mov    %rdx,%rax
     f:	c3                   	ret
    10:	66                   	data16
    11:	2e                   	cs
    12:	0f                   	.byte 0xf
    13:	1f                   	(bad)
    14:	84 00                	test   %al,(%rax)
  RSP: 002b:00007fff4638afa0 EFLAGS: 00000202 ORIG_RAX: 000000000000002a
  RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f2b23041186
  RDX: 0000000000000010 RSI: 0000557a15fd7360 RDI: 0000000000000003
  RBP: 00007fff4638afb0 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000106
  R13: 000000000000000a R14: 00007f2b2328a000 R15: 0000557a15fd7330
   </TASK>
  
  =============================
  WARNING: suspicious RCU usage
  6.6.129 #1 Tainted: G                 N
  -----------------------------
  include/net/net_namespace.h:411 suspicious rcu_dereference_check() usage!
  
  other info that might help us debug this:
  
  
  rcu_scheduler_active = 2, debug_locks = 1
  2 locks held by mptcp_connect/213:
  #0: ffff88810f9b0130 (sk_lock-AF_INET){+.+.}-{0:0}, at: inet_stream_connect (net/ipv4/af_inet.c:747) 
  #1: ffff88810fe28130 (k-sk_lock-AF_INET#2){+.+.}-{0:0}, at: mptcp_connect (net/mptcp/protocol.c:3883) 
  
  stack backtrace:
  CPU: 3 PID: 213 Comm: mptcp_connect Tainted: G                 N 6.6.129 #1
  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  Call Trace:
   <TASK>
  dump_stack_lvl (lib/dump_stack.c:107) 
  lockdep_rcu_suspicious (include/linux/context_tracking.h:153) 
  ip_dst_mtu_maybe_forward.constprop.0 (include/net/net_namespace.h:411 (discriminator 13)) 
  ? __build_flow_key.constprop.0 (include/net/ip.h:457) 
  ? __lock_acquire (kernel/locking/lockdep.c:5719) 
  ? tcp_mtup_init (net/ipv4/tcp_output.c:1779 (discriminator 4)) 
  tcp_connect_init (net/ipv4/tcp_output.c:3804 (discriminator 1)) 
  ? tcp_sync_mss (net/ipv4/tcp_output.c:3786) 
  ? ipv4_dst_check (net/ipv4/route.c:1232) 
  ? __sk_dst_check (net/core/sock.c:601 (discriminator 2)) 
  ? inet_sk_rebuild_header (net/ipv4/af_inet.c:1316) 
  ? reacquire_held_locks (kernel/locking/lockdep.c:5405) 
  ? __lock_acquire (kernel/locking/lockdep.c:5719) 
  tcp_connect (net/ipv4/tcp_output.c:3986) 
  ? mark_held_locks (kernel/locking/lockdep.c:4274 (discriminator 1)) 
  ? tcp_send_syn_data (net/ipv4/tcp_output.c:3974) 
  ? trace_hardirqs_on (kernel/trace/trace_preemptirq.c:62 (discriminator 1)) 
  tcp_v4_connect (net/ipv4/tcp_ipv4.c:335 (discriminator 1)) 
  ? trace_tcp_bad_csum (net/ipv4/tcp_ipv4.c:214) 
  mptcp_connect (net/mptcp/protocol.c:3892) 
  __inet_stream_connect (net/ipv4/af_inet.c:676) 
  ? lockdep_hardirqs_on_prepare.part.0 (kernel/locking/lockdep.c:4300) 
  inet_stream_connect (net/ipv4/af_inet.c:748) 
  __sys_connect (net/socket.c:2056 (discriminator 2)) 
  ? __sys_connect_file (net/socket.c:2063) 
  ? update_socket_protocol+0x10/0x10
   
  __x64_sys_connect (net/socket.c:2083 (discriminator 1)) 
  ? syscall_enter_from_user_mode (arch/x86/include/asm/irqflags.h:42) 
  do_syscall_64 (arch/x86/entry/common.c:46 (discriminator 1)) 
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121) 
  RIP: 0033:0x7f2b23041186
  Code: 47 ba 04 00 00 00 48 8b 05 87 3c 19 00 64 89 10 48 c7 c2 ff ff ff ff c9 48 89 d0 c3 0f 1f 84 00 00 00 00 00 48 8b 45 10 0f 05 <48> 89 c2 48 3d 00 f0 ff ff 77 0f c9 48 89 d0 c3 66 2e 0f 1f 84 00
  All code
  ========
     0:	47 ba 04 00 00 00    	rex.RXB mov $0x4,%r10d
     6:	48 8b 05 87 3c 19 00 	mov    0x193c87(%rip),%rax        # 0x193c94
     d:	64 89 10             	mov    %edx,%fs:(%rax)
    10:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
    17:	c9                   	leave
    18:	48 89 d0             	mov    %rdx,%rax
    1b:	c3                   	ret
    1c:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    23:	00 
    24:	48 8b 45 10          	mov    0x10(%rbp),%rax
    28:	0f 05                	syscall
    2a:*	48 89 c2             	mov    %rax,%rdx		<-- trapping instruction
    2d:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
    33:	77 0f                	ja     0x44
    35:	c9                   	leave
    36:	48 89 d0             	mov    %rdx,%rax
    39:	c3                   	ret
    3a:	66                   	data16
    3b:	2e                   	cs
    3c:	0f                   	.byte 0xf
    3d:	1f                   	(bad)
    3e:	84 00                	test   %al,(%rax)
  
  Code starting with the faulting instruction
  ===========================================
     0:	48 89 c2             	mov    %rax,%rdx
     3:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
     9:	77 0f                	ja     0x1a
     b:	c9                   	leave
     c:	48 89 d0             	mov    %rdx,%rax
     f:	c3                   	ret
    10:	66                   	data16
    11:	2e                   	cs
    12:	0f                   	.byte 0xf
    13:	1f                   	(bad)
    14:	84 00                	test   %al,(%rax)
  RSP: 002b:00007fff4638afa0 EFLAGS: 00000202 ORIG_RAX: 000000000000002a
  RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f2b23041186
  RDX: 0000000000000010 RSI: 0000557a15fd7360 RDI: 0000000000000003
  RBP: 00007fff4638afb0 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000106
  R13: 000000000000000a R14: 00007f2b2328a000 R15: 0000557a15fd7330
   </TASK>


@Greg: Is it possible to drop this patch for the moment?
(This patch was probably coming with dependences.)

@Ruohan: do you mind looking at this please?
I didn't execute TCP specific tests, only MPTCP ones.

See: https://github.com/multipath-tcp/mptcp_net-next/actions/runs/23479015653/job/68317986391

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

