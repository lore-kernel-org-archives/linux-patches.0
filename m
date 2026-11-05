Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793838513;
	b=0lN2hidpmjjStppZ70EdXviahGL7hwghzABAmLH6shqWfVxjwhP1ukScVSjhGBjJrsta
	 LlY45/hGmzpRy42zo+SnR8KEtO/i82qFT48Edk8NNvAEHF2ficzbsJdv7tByqQoR0L395
	 0lGhRubV3GPBS80C5tdDNvsv/2P/ZbbeMz42E341dfzNNn2S462BKC+S57VGvC5v77PDP
	 74M5emgQjGyflx5LP7qSZ5f9VeLedhrCF0OP5N7pZ88nNDVFFUkgRa02ZvGjzS10ydN5Y
	 oEKqH3dWCFUJxhbAj7h0XkmAPiG8qGm1fDzR/i8Q7cTxhprfoVrYhA16U5VhUvF4Fog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793838513;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=+fcZSr/8DIicfjiJFn4Q5iadDvBffA+oE/j8iUxjfSg=;
	b=JM0tasPRiOWXi4PST/exN9WcQFRjs/+6UpXrvBWg6ueWZIF/62fOOS2kaFllhKJGKE3C
	 w3s2hso30CxztiPaogr34HgSd/wyWuV655SUwtbnb2WjwrgLiF1zPO/9L89vdKlaQpGdp
	 ljOjwBGon5YjGOZ45fSIqJuuREwgpRXHGZ56GsV8EatsCiecbv8yMl3G/vkjwEFLxuFK/
	 kjjsdyZ7cWj4zS8t+l4cnCAeoaVdvEHk3fVpXmWqZCh0g80D3fVwaqf5jS7QPZ5oSd2HQ
	 8VERuMl3/HCa+O6/ddSYxwb/sPmpsKU/Ugnh8w7wbFG7eViA6HUq8C4FbajT7gzhgcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.de;
	spf=pass smtp.mailfrom=gmx.de;
	dkim=pass header.d=gmx.de header.i=rwarsow@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=MjZDejx3;
	arc=none smtp.remote-ip=212.227.15.18
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E04606A32D
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 00:28:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5E04606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.de header.i=rwarsow@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=MjZDejx3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1793838473; x=1794443273; i=rwarsow@gmx.de;
	bh=+fcZSr/8DIicfjiJFn4Q5iadDvBffA+oE/j8iUxjfSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=MjZDejx3y57evfJnJ/JAzd7db24iDM52WjEMDqGHefeHRkaLL9s4HmkdQ0/I4Us1
	 J7HD8YYj98vfSfMeVypGcKBT2iidQDIUTFkPJWLSSMCaOf5OE4ZHNe9CL6FM/ANmJ
	 6Fe2S747hApQ95t6Xk0xdZ7/R9V0BRQhSJYxUdmonBgOGvz6dYt7s7xbM0GGj+uDY
	 xlo0H5YPYkJAh45b1lO93J1EgAfR38KSHNwQwKpbUBU47n+e9ifbeTO8gOuJWw7yI
	 +wtzOtYsbDcL1gfEo7Vm8r9sNGaWdgtKSAJFUFyccAIysPBJM0d2L+h+gEMZP2uAw
	 kYAaE7Mf0oN2qk6DGA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MgeoI-1wsjMz146W-00ifw4; Thu, 05
 Nov 2026 01:27:53 +0100
Message-ID: <3dfb9b8d-3bf7-4fa2-89ec-6561c1b7b70e@gmx.de>
Date: Thu, 5 Nov 2026 01:27:50 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261104211038.406938024@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:WhRlFt5N/0ILcCHR8OZIwNhPz0rCLzI4eb4Qu5n2tLkP/GNTJeW
 sTNlFuHN9DpfowWwfflJ3q+sNzRYjZNtivqNXE62rzxj9yHPlJyymAnJMLGByUGk/nkdPG5
 o40j2T7XEuVO10WyVdykKG6Cuh+LtwKBS4JtScEeMdmqmhGc2h8H+ImGJafetw+IXnaQZd/
 J1ImNPu93L+fO4c2YWzww==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:fpL7rYvL7Og=;+QPVLqQa+Ymxl6slPZF/C4dPuxk
 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

Hi

kernel build / boot test on x86_64 (11th Gen Intel Core i5-11400).


not bisected, just "visual grepped" on the linux-stable-rc.git log !

I need to revert:

"x86/mm/pat: Fix effective RW computation in lookup_address_in_pgd_attr()"

commit 7f85bfd44bcccf315eb30145e9c2a2fd9f6f8a87


otherwise I get:

[    0.105981] x86/fpu: Enabled xstate features 0x2ff, context size is=20
2568 bytes, using 'compacted' format.
[    0.108036] ------------[ cut here ]------------
[    0.108037] CPA detected W^X violation: 8000000000000123 ->=20
0000000000000123 range: 0xffffffffc0400000 - 0xffffffffc0400fff PFN 101000
[    0.108039] WARNING: arch/x86/mm/pat/set_memory.c:722 at=20
__change_page_attr_set_clr+0xc4c/0x11f0, CPU#0: swapper/0/0
[    0.108043] Modules linked in:
[    0.108045] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted=20
7.3.2-rc1_MY-g75eaee7a6465 #1 PREEMPT(lazy)
[    0.108047] Hardware name: ASUS System Product Name/ROG STRIX B560-G=20
GAMING WIFI, BIOS 2501 05/22/2026
[    0.108048] RIP: 0010:__change_page_attr_set_clr+0xc65/0x11f0
[    0.108050] Code: 7c 24 4c 00 0f 85 e9 03 00 00 48 8d 3d a4 78 01 03=20
48 8b 34 24 4d 89 e9 4d 8d 84 24 ff 0f 00 00 4c 89 e1 48 89 c2 48 89 04=20
24 <67> 48 0f b9 3a 48 8b 04 24 48 ba 00 f0 ff ff ff ff 0f 00 48 21 d3
[    0.108052] RSP: 0000:ffffffff85203c40 EFLAGS: 00010246
[    0.108053] RAX: 0000000000000123 RBX: 8000000101000123 RCX:=20
ffffffffc0400000
[    0.108054] RDX: 0000000000000123 RSI: 8000000000000123 RDI:=20
ffffffff857c8f70
[    0.108055] RBP: 8000000101000123 R08: ffffffffc0400fff R09:=20
0000000000101000
[    0.108056] R10: 0000000000000123 R11: 0000000000000000 R12:=20
ffffffffc0400000
[    0.108056] R13: 0000000000101000 R14: 000ffffffffff000 R15:=20
ffffffff85203d40
[    0.108057] FS:  0000000000000000(0000) GS:ffff97940910f000(0000)=20
knlGS:0000000000000000
[    0.108058] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.108059] CR2: ffff979067570000 CR3: 0000000126238001 CR4:=20
0000000000770ef0
[    0.108060] PKRU: 55555554
[    0.108061] Call Trace:
[    0.108062]  <TASK>
[    0.108064]  ? _vm_unmap_aliases+0x229/0x2a0
[    0.108067]  change_page_attr_set_clr+0x154/0x5a0
[    0.108070]  ? perf_get_hw_event_config+0x28/0x30
[    0.108072]  set_memory_x+0x39/0x50
[    0.108073]  apply_retpolines+0x695/0x710
[    0.108077]  ? perf_get_hw_event_config+0x28/0x30
[    0.108078]  ? __pfx_x86_pmu_filter+0x7/0x10
[    0.108080]  ? perf_get_hw_event_config+0x2d/0x30
[    0.108081]  alternative_instructions+0x37/0xc0
[    0.108086]  arch_cpu_finalize_init+0x11b/0x170
[    0.108087]  start_kernel+0x9ae/0xa50
[    0.108089]  x86_64_start_reservations+0x24/0x30
[    0.108091]  x86_64_start_kernel+0x121/0x130
[    0.108092]  common_startup_64+0x13e/0x158
[    0.108095]  </TASK>
[    0.108095] ---[ end trace 0000000000000000 ]---


Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
