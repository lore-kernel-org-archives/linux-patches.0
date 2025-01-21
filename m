Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30860188CAE
	for <patches@lists.linux.dev>; Tue, 21 Jan 2025 21:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737495969; cv=none; b=Z2GNNvjTr1J+bSoZClZ7LLj4ZI0cpG/lQybr8dWlWaLuu9dzLvQq+MHGmQFyzaACQ56GSiUoJVMvOMM9oDYYjzfjqW18aXruDZSaN0daNRET1CADQ9pdGVPfcmyU9votHvs7mRIQQkQV1rFhJT0ntn1QcRa5SnUyWUCNq2qlLds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737495969; c=relaxed/simple;
	bh=3LLeiStxYToysVZyPL2LSNz3jjzOoMVel3ZLJ3xROgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Brvig7E/9cGGG0bvA+Vrl/oKwkN2Yb6JzXJYaOGbpYBTb65ZOzy/kel6jQooC112vwr6vEX09/H/NA9XKY2LYG3ckJ0LvxE2NWucgoMcfnu5twwXl7bs0ZxRQQxwqaiVm/cn3OqLtlhjAzhUOsPcf3jLAZiEwwujzGwxE6qqy/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jn+2pvi+; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jn+2pvi+"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d3bbb0f09dso10663109a12.2
        for <patches@lists.linux.dev>; Tue, 21 Jan 2025 13:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737495965; x=1738100765; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HlApovyX2yhqXs8BBrOWcgKw+xYbJfOZcDpmZ0IuRIE=;
        b=Jn+2pvi+5UoBki1opmxup/2xzLI87eRY0Hox4ewRF5pZcmwymCu5zNuFtJNPwtaiK6
         iVJxcvKb1hchIFn3hxy+WUp5RfchYicAKTSyKRKfNEbz4z6qP0WrdMGsufWcAS6Aqvfn
         2gKbc+l3LojLXxw1SV7t0tO64CnS9YXlJb3PWooSybX37kaMyWuD/x5CuR9AARAEBBPi
         j+leM3ylwSH17zi8VDgu05UxfU8pX6uNHfIBPEv8/X2ouoPrft5jzsWWRKo/G7fa7F3D
         27klpMNsFU6uaKoVjpJZIjfpmznYVNvCM8RNaxB6BizeBDQd/5Ia+sccLt1ZoCF5kn/y
         HpKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737495965; x=1738100765;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HlApovyX2yhqXs8BBrOWcgKw+xYbJfOZcDpmZ0IuRIE=;
        b=JyFK04TGuZ47WcfX+gDDcOzk74eaXSL+VbfSBlXWhVPAbsAgNRebRUhBaR5PCDhcLr
         TW7iNjttZg10oHcf9AAguXnWz81zrY6pPNITp3vJsWUZqXnJkiAMkwwxEnST5ljdr++2
         1Le2nEKv3AkZzXWJdGMqxLbFLEt5vNFh9HsTHdG0Fj2vFHdXmTS764M7AeKi4LFTqMJR
         JteKDYnTzAdhYkXCn0z3ao0Lr9aZf3snR7EuZ3PSaNTg/TtSFRKEsNghjUG0GyJr26bd
         QgBTReshyIBo1P9uYW7HKz9MjsN2CEYa9s5waYTmOsiuSR665lZNl0ErC1ywwoP7fT/m
         Ftdw==
X-Forwarded-Encrypted: i=1; AJvYcCVHq+K4QVbuvE7ZpvbshkflnXXtJpw7Rs5mF+qm0yeG9G4wPYdvHeNoqBW+QOWQh5v6eFvL50vS@lists.linux.dev
X-Gm-Message-State: AOJu0YxHfp88k9SJTJmWIJlL2uPCUzdL3xn8tQlWeMtBthMphE7SpMx1
	LOCv9H8lXiTKDxH1NEchjUaL2kDpC9tnZe10FPxY2vOxEuSS71V6
X-Gm-Gg: ASbGncvAQo6J2Er4Sa9mMkhfWuM5R2oEhHFdDF3icQYLw2i0CsJFKlGnEzvSvZr6fkM
	5ZoP18N40gz8SRIiwMsXcj80Uf4c+bvjdiPNGp4s0NsQvX/XUNrzCIv8K7Ppxjqr0GvX5KrMB4J
	kwpLSG0V4MVKbjpzOVxoWCS7dV+jKx45RKT2SLkeVRzGFdTKhaaj59b+PM0dVQe8B123TDDOQZX
	IrLMD1ouBNdQ3JamHO+SqqnZD3oRCDGW7CvY6n1zrwVhdDoSetRK4uS/RASgmDDhw3X8qQRGKMy
	v0raZd716wsx/pujwApN5nA+9K0=
X-Google-Smtp-Source: AGHT+IH+P6+VRF0jdFQ/AldfEjibVvDH5rn5neRrkUAq3GzMXJXeBhIzcSVSMSwi5CBdmsm9oN/g5w==
X-Received: by 2002:a17:907:1c25:b0:aa6:7cf3:c6f0 with SMTP id a640c23a62f3a-ab38b10d025mr1717588766b.14.1737495965097;
        Tue, 21 Jan 2025 13:46:05 -0800 (PST)
Received: from eldamar.lan (c-82-192-244-13.customer.ggaweb.ch. [82.192.244.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384c60746sm802762266b.4.2025.01.21.13.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 13:46:03 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 0CDB4BE2EE7; Tue, 21 Jan 2025 22:46:03 +0100 (CET)
Date: Tue, 21 Jan 2025 22:46:03 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
Message-ID: <Z5AVm4cQDGjnDet2@eldamar.lan>
References: <20250121174532.991109301@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>

Hi Greg,

On Tue, Jan 21, 2025 at 06:50:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Built and lightly tested, when booting I'm noticing the following in
dmesg:

[  +0.007932] ------------[ cut here ]------------
[  +0.000003] WARNING: CPU: 1 PID: 0 at kernel/sched/fair.c:5250 place_entity+0x127/0x130
[  +0.000006] Modules linked in: ahci(E) libahci(E) crc32_pclmul(E) xhci_hcd(E) libata(E) psmouse(E) crc32c_intel(E) >
[  +0.000021] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Tainted: G            E      6.12.11-rc1+ #1
[  +0.000004] Tainted: [E]=UNSIGNED_MODULE
[  +0.000002] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[  +0.000002] RIP: 0010:place_entity+0x127/0x130
[  +0.000003] Code: 01 6b 28 c6 43 52 00 5b 5d 41 5c 41 5d 41 5e e9 2f 83 bc 00 b9 02 00 00 00 49 c1 ee 0a 49 39 ce 4>
[  +0.000002] RSP: 0018:ffffbe1f400f8d08 EFLAGS: 00010046
[  +0.000003] RAX: 0000000000000000 RBX: ffff9ed7c0c0f200 RCX: 00000000000000c2
[  +0.000002] RDX: 0000000000000000 RSI: 000000000000001d RDI: 000000000078cfd5
[  +0.000002] RBP: 0000000029d40d60 R08: 00000000a8e83f00 R09: 0000000000000002
[  +0.000002] R10: 00000000006e3ab2 R11: ffff9ed7d4056690 R12: ffff9ed83bd360c0
[  +0.000002] R13: 0000000000000000 R14: 00000000000000c2 R15: 000000000016e360
[  +0.000003] FS:  0000000000000000(0000) GS:ffff9ed83bd00000(0000) knlGS:0000000000000000
[  +0.000002] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0.000002] CR2: 00007f9f5a7245d8 CR3: 0000000100bfc000 CR4: 0000000000350ef0
[  +0.000003] Call Trace:
[  +0.000003]  <IRQ>
[  +0.000002]  ? place_entity+0x127/0x130
[  +0.000002]  ? __warn.cold+0x93/0xf6
[  +0.000004]  ? place_entity+0x127/0x130
[  +0.000003]  ? report_bug+0xff/0x140
[  +0.000005]  ? handle_bug+0x58/0x90
[  +0.000002]  ? exc_invalid_op+0x17/0x70
[  +0.000003]  ? asm_exc_invalid_op+0x1a/0x20
[  +0.000006]  ? place_entity+0x127/0x130
[  +0.000003]  ? place_entity+0x99/0x130
[  +0.000004]  reweight_entity+0x1af/0x1d0
[  +0.000003]  enqueue_task_fair+0x30c/0x5e0
[  +0.000005]  enqueue_task+0x35/0x150
[  +0.000004]  activate_task+0x3a/0x60
[  +0.000003]  sched_balance_rq+0x7c6/0xee0
[  +0.000008]  sched_balance_domains+0x25b/0x350
[  +0.000005]  handle_softirqs+0xcf/0x280
[  +0.000006]  __irq_exit_rcu+0x8d/0xb0
[  +0.000003]  sysvec_apic_timer_interrupt+0x71/0x90
[  +0.000003]  </IRQ>
[  +0.000002]  <TASK>
[  +0.000002]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[  +0.000002] RIP: 0010:pv_native_safe_halt+0xf/0x20
[  +0.000004] Code: 22 d7 e9 b4 01 01 00 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 0>
[  +0.000002] RSP: 0018:ffffbe1f400bbed8 EFLAGS: 00000202
[  +0.000003] RAX: 0000000000000001 RBX: ffff9ed7c033e600 RCX: ffff9ed7c0647830
[  +0.000001] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00000000000017b4
[  +0.000002] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
[  +0.000002] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[  +0.000001] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  +0.000006]  default_idle+0x9/0x20
[  +0.000003]  default_idle_call+0x29/0x100
[  +0.000002]  do_idle+0x1fe/0x240
[  +0.000005]  cpu_startup_entry+0x29/0x30
[  +0.000003]  start_secondary+0x11e/0x140
[  +0.000004]  common_startup_64+0x13e/0x141
[  +0.000007]  </TASK>
[  +0.000001] ---[ end trace 0000000000000000 ]---

Not yet bisected which change causes it.

Regards,
Salvatore
