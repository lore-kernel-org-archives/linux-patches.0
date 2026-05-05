Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968E05733E;
	Tue,  5 May 2026 17:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778001395; cv=none; b=gGqqcrTxDZJPTrLJXbZocmS8Ix8BvGNCW3Fbv7MCPPKBFLQoGBmRCwWTQ0K9QTfd4yWnwkl0TPOeJw+wW0DSFBMqHBAOCNi1wfEh2cmmTjx4RuqDahM6NGgTqrHyJBn9sdoBf+2aV+jK/WbFPte3wEa9gOs3xWTBOiVwi3gznH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778001395; c=relaxed/simple;
	bh=uDEaCPz6eRDyCusvuMTn/d5rZpDj+9Tu0dLtyO7Gi2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h12EmFtVQgsgvgbV9i7YQ1/58vXNHH3NVzr4QpBTSzrDbAMi5meXPwiwwWNOlzNHgqngxs6wwHWCQodomEOWpqAsSNhLpgHUCgFgGIL/uuaE1DJgSXQKOrBL86QdIkzVc3L93JcVs1WfcKqyVD1gPAUvHQTSJPaep1Jhl1skbxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N4GKiogh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N4GKiogh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B190EC2BCB4;
	Tue,  5 May 2026 17:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778001395;
	bh=uDEaCPz6eRDyCusvuMTn/d5rZpDj+9Tu0dLtyO7Gi2E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=N4GKioghbOn1XW/0NwawORTFRkcVb2sMKDa87STLxQB558RACrhkVRp8PrFNlAiZ8
	 rKAfZu9v6kOHwNwTV2kPVkQkTTFNX5IWizlVGPUiUvPaxUnYIFZ8vqeRzI7P5xoFaq
	 e5Lq+pkH6BUdawIpM+2z0J6XldYI79mVm+xwtf5mKuRWUVvC9wpR8g62lJUimtU8s8
	 SY/tGmapz23KFJiJsmhRFoJLUqP3CnppGSNwA8DX8S54B84EmM6TTQ16CIayug9iHN
	 ufTq2/cTSsx2r2Vo6kUdKPsDBJqixAfrDsi8DFvEobTKPov1yfr4T0+4r+MUY1SNzZ
	 HmNUhPRTaf71Q==
Message-ID: <1bbeee9b-b69b-4be9-84ee-ddadda4793ef@kernel.org>
Date: Tue, 5 May 2026 19:16:31 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 6.18 214/275] mptcp: sync the msk->sndbuf at accept() time
Content-Language: fr
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Gang Yan <yangang@kylinos.cn>
Cc: patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
 stable@vger.kernel.org, MPTCP Linux <mptcp@lists.linux.dev>
References: <20260504135142.929052779@linuxfoundation.org>
 <20260504135151.022829547@linuxfoundation.org>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20260504135151.022829547@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Greg, Gang,

On 04/05/2026 15:52, Greg Kroah-Hartman wrote:
> 6.18-stable review patch.  If anyone has any objections, please let me know.

Please drop this patch, it looks like it is introducing regressions on
v6.18:


$ ./diag.sh
  TAP version 13
  1..1
  # 01 no msk on netns creation                          [ OK ]
  # 02 listen match for dport 10000                      [ OK ]
  # 03 listen match for sport 10000                      [ OK ]
  # 04 listen match for saddr and sport                  [ OK ]
  # 05 all listen sockets                                [ OK ]
  [    3.976840] Oops: general protection fault, probably for non-canonical address 0x656e6769736e75f8: 0000 [#1] SMP NOPTI
  [    3.977019] CPU: 0 UID: 0 PID: 221 Comm: mptcp_connect Tainted: G                 N  6.18.26 #1 PREEMPT(voluntary) 
  [    3.977251] Tainted: [N]=TEST
  [    3.977690] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  [    3.978293] RIP: 0010:mptcp_stream_accept (net/mptcp/protocol.h:966 (discriminator 2))
  [    3.978761] Code: f7 e8 d8 32 06 00 48 8b 1b 4c 39 fb 75 98 4c 89 ef e8 f8 99 ff ff 48 8b 93 d8 00 00 00 8b 8a 38 02 00 00 48 8b 92 c8 04 00 00 <3b> 8a d0 00 00 00 74 08 4c 89 ef e8 94 a4 ff ff 49 8b 95 a8 06 00
  All code
  ========
     0:	f7 e8                	imul   %eax
     2:	d8 32                	fdivs  (%rdx)
     4:	06                   	(bad)
     5:	00 48 8b             	add    %cl,-0x75(%rax)
     8:	1b 4c 39 fb          	sbb    -0x5(%rcx,%rdi,1),%ecx
     c:	75 98                	jne    0xffffffffffffffa6
     e:	4c 89 ef             	mov    %r13,%rdi
    11:	e8 f8 99 ff ff       	call   0xffffffffffff9a0e
    16:	48 8b 93 d8 00 00 00 	mov    0xd8(%rbx),%rdx
    1d:	8b 8a 38 02 00 00    	mov    0x238(%rdx),%ecx
    23:	48 8b 92 c8 04 00 00 	mov    0x4c8(%rdx),%rdx
    2a:*	3b 8a d0 00 00 00    	cmp    0xd0(%rdx),%ecx		<-- trapping instruction
    30:	74 08                	je     0x3a
    32:	4c 89 ef             	mov    %r13,%rdi
    35:	e8 94 a4 ff ff       	call   0xffffffffffffa4ce
    3a:	49                   	rex.WB
    3b:	8b                   	.byte 0x8b
    3c:	95                   	xchg   %eax,%ebp
    3d:	a8 06                	test   $0x6,%al
  	...
  
  Code starting with the faulting instruction
  ===========================================
     0:	3b 8a d0 00 00 00    	cmp    0xd0(%rdx),%ecx
     6:	74 08                	je     0x10
     8:	4c 89 ef             	mov    %r13,%rdi
     b:	e8 94 a4 ff ff       	call   0xffffffffffffa4a4
    10:	49                   	rex.WB
    11:	8b                   	.byte 0x8b
    12:	95                   	xchg   %eax,%ebp
    13:	a8 06                	test   $0x6,%al
  	...
  [    3.979083] RSP: 0018:ffffc9000048fda0 EFLAGS: 00010246
  [    3.979167] RAX: 0000000080000000 RBX: ffff888108c48e30 RCX: 0000000081da17f0
  [    3.979262] RDX: 656e6769736e7528 RSI: 00000000fffffe00 RDI: ffff888108c487c0
  [    3.979357] RBP: ffff888108c50940 R08: 0000000000000001 R09: ffffffff81c36d02
  [    3.979451] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88810481f740
  [    3.980273] R13: ffff888108c487c0 R14: ffff888108c50b90 R15: ffff888108c48e30
  [    3.980830] FS:  00007fdb510f6bc0(0000) GS:ffff8881b8f1c000(0000) knlGS:0000000000000000
  [    3.981059] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [    3.981241] CR2: 00007fdb5125dce0 CR3: 0000000103e1a006 CR4: 0000000000370ef0
  [    3.981428] Call Trace:
  [    3.981544]  <TASK>
  [    3.981637]  do_accept (net/socket.c:1989)
  [    3.981745]  __sys_accept4 (net/socket.c:2030 (discriminator 1))
  [    3.981861]  __x64_sys_accept (net/socket.c:2070 (discriminator 1))
  [    3.981977]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 (discriminator 1))
  [    3.982091]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)


@Gang: could you eventually have a look, please?

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

