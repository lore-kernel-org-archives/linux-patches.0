Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CF91624D2
	for <patches@lists.linux.dev>; Mon, 14 Apr 2025 19:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744657339; cv=none; b=EbwZlra52eoQtvaMYQrIDAm9fS+vgWDfBBoAwyenIi5gJN+c4NNn7R0+Hp/j64wt6mKDa3eIAcrhM9wDH7cpQBlaZO539io6VBbHL4ePL04V4b4q54PRAaAj8/s3KlZwr/Ox2gdoxx40tLSZOA5qdU8jmirdHjW6E6W8YxtKr7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744657339; c=relaxed/simple;
	bh=lmVL5iXx8UtM9yGScibg2MyfyJuub7bM6yPpWGeTZS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6PBkcOifVmHi9eHSm7tFZLJMoSXDNumqbCRLmeOvEgVn1IAGY64BX4xsoWbjd4nNeb5WqhrxvCbkAAfnH4qfGa8CMUi4dXGRwBjBmHrGbqxJPXCSiclbSgbb4SPCmCYvWgLLNDdadWQzPbwTRTu0bJSDODa/RhZXdcBYpjhlos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l3gynlWL; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l3gynlWL"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac25520a289so806000366b.3
        for <patches@lists.linux.dev>; Mon, 14 Apr 2025 12:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744657336; x=1745262136; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6LY3Z65IQjRhzzZTzIq8s4BIA0G+Zu9nAcODU8uzb1U=;
        b=l3gynlWLLcjJhRv9G9CEz19hPgOU/nezrE3XBVzTD4no5LjZyQp0KTd3jM6n2vJYWw
         kyW7DdXPHIfgbv0VoqttfGE/kpYb/bmCA7AwsNol9sxN9OOLMLtji2BL+Jn9JYghWJlF
         OJJXA784JR/E6D5sZHOtuhYBCk24dpt4Yu1FchJnM66k9tU9+TK1uhgO+ZahrpDxGwW2
         7NO1kAxOCq4/ukIFcdLITaR4l4YqccDewFevqfWKKCbQtwG5cYhJDHhBRfEZzFZ7+uU6
         0MmLsUtmuLGl1jdBfgbLXs7XQjXggCwbdW5SQP+BpadYR+tWfdrJ3XqzVcTVCwnhfEVn
         9Y2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744657336; x=1745262136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6LY3Z65IQjRhzzZTzIq8s4BIA0G+Zu9nAcODU8uzb1U=;
        b=dc/nEJRje80Ag0N90E+1hRAceBElgWCnIZX08lp/85ZKmB80wS/b2E9fN3g0gQHSLY
         mI1vu4Msg18tYoKB/Tgm8GH64xWLvJ/AgEnV0vpHen5BkPFbb724I95M4KDaPfEw6qiF
         WGariS4+KU5MWAwXTs4ZEICO44TuXqhXtiK31OYoJRJESPvAyWE5drxxyOKj/3+mp/bP
         znr6RcJoGSlwEAQB4BtoxF3I1Xwmr+6ISWe1K/3WU9C6afaEqgM948dqP6PcIUfEiFFO
         HO7ZDRi9iZzVGYKaeYDkl0H3WQnoFPxafbqWDL7tj/ly7vRlwnv48A63CoQmuWEh2Zk8
         ROpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWd7vlRHus2omQy9Ss+dnFy5xfuPKp2dIfPCskZQp45CLtPmDnTbXbE/DECavl91jRMx8Ead5O@lists.linux.dev
X-Gm-Message-State: AOJu0Yz94MlGoN7T4PRuLbSmUoJSrRimfiUPUmU1ndMebzmtHtlDvAh1
	NgMRsK4EqqZYD6SLhDK+iYGDuEwNNIx25q1iTPdJo1hxT8l/JDu5
X-Gm-Gg: ASbGncvCHwkNYbyN6p2rifA2QXr6fgEQQilhVqzWNcyNGBxD5GTY4yMBWdBDXD5S6ZR
	6S2cGYIMCtP6rVaBDv+gtEx2+AKJk/4mR3roM3kFGqJdDO4EHLCzJCdeeMHzGsqq173ivJBHpVR
	RF0VKc3uZiC5lcYCFryeO8RbJ20y0OmpB1NAUF5AA08V/OCRH8hqV9CtEwt4qFR8I5+yXUmWaYr
	mn8Gh+BKvedJBe2BIxdckMUHl9m31b8GVlaedWYpufZZGidOC/xtKXr4eCS2IY0EBc5OxheuG/R
	cDufMhQnDoQ5YgKj4AfxTHl5s1I9H/zZWKwAjgAiL/ov+xNrTx/IP8T2MnQ6pV5nqHO0rKkB5yb
	op3PKlcV9
X-Google-Smtp-Source: AGHT+IFWkE1Glhu6cGY2ezqU0g1m+eeErpXkykD7wcWilXB3BpQqNt8TFncACH+ooaDNRap/v9EI9A==
X-Received: by 2002:a17:907:7f14:b0:ac7:edfb:5210 with SMTP id a640c23a62f3a-acad3496114mr1183905866b.20.1744657335667;
        Mon, 14 Apr 2025 12:02:15 -0700 (PDT)
Received: from eldamar.lan (c-82-192-244-13.customer.ggaweb.ch. [82.192.244.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acaa1ce7fdcsm969991366b.176.2025.04.14.12.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 12:02:15 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 2D6C5BE2DE0; Mon, 14 Apr 2025 21:02:14 +0200 (CEST)
Date: Mon, 14 Apr 2025 21:02:14 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jan Beulich <jbeulich@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 051/198] Xen/swiotlb: mark xen_swiotlb_fixup() __init
Message-ID: <Z_1btrSDlzd-ac20@eldamar.lan>
References: <20250325122156.633329074@linuxfoundation.org>
 <20250325122157.975417185@linuxfoundation.org>
 <20250407181218.GA737271@ax162>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250407181218.GA737271@ax162>

Hi,

On Mon, Apr 07, 2025 at 11:12:18AM -0700, Nathan Chancellor wrote:
> Hi Greg,
> 
> On Tue, Mar 25, 2025 at 08:20:13AM -0400, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jan Beulich <jbeulich@suse.com>
> > 
> > [ Upstream commit 75ad02318af2e4ae669e26a79f001bd5e1f97472 ]
> > 
> > It's sole user (pci_xen_swiotlb_init()) is __init, too.
> 
> This is not true in 6.1 though... which results in:
> 
>   WARNING: modpost: vmlinux.o: section mismatch in reference: pci_xen_swiotlb_init_late (section: .text) -> xen_swiotlb_fixup (section: .init.text)
> 
> Perhaps commit f9a38ea5172a ("x86: always initialize xen-swiotlb when
> xen-pcifront is enabling") and its dependency 358cd9afd069 ("xen/pci:
> add flag for PCI passthrough being possible") should be added (I did not
> test if they applied cleanly though) but it seems like a revert would be
> more appropriate. I don't see this change as a dependency of another one
> and the reason it exists upstream does not apply in this tree so why
> should it be here?

Might be following bugreport we got in Debian be related?
https://bugs.debian.org/1103153

The kernel log contains:

[    1.370662] pcifront pci-0: Installing PCI frontend
[    1.370674] software IO TLB: area num 4.
[    1.370853] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[    1.370861] BUG: unable to handle page fault for address: ffffffff830c7c05
[    1.370865] #PF: supervisor instruction fetch in kernel mode
[    1.370869] #PF: error_code(0x0011) - permissions violation
[    1.370873] PGD 2a15067 P4D 2a15067 PUD 2a16067 PMD 4a1e067 PTE 80100000030c7067
[    1.370879] Oops: 0011 [#1] PREEMPT SMP NOPTI
[    1.370884] CPU: 3 PID: 42 Comm: xenwatch Not tainted 6.1.0-33-amd64 #1  Debian 6.1.133-1
[    1.370889] RIP: e030:xen_swiotlb_fixup+0x0/0xb7
[    1.370895] Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
[    1.370904] RSP: e02b:ffffc90040177dd8 EFLAGS: 00010286
[    1.370907] RAX: ffffffff830c7c05 RBX: ffff88810a800000 RCX: 0000000000000001
[    1.370912] RDX: 000000000000000a RSI: 0000000000000800 RDI: ffff88810a800000
[    1.370916] RBP: 0000000000000800 R08: 000000000000002a R09: 0000000000000000
[    1.370920] R10: 000000000000000a R11: 0000000000000000 R12: 0000000000000001
[    1.370923] R13: 0000000000002cc0 R14: 0000000000000002 R15: 000000000000000a
[    1.370931] FS:  0000000000000000(0000) GS:ffff888277780000(0000) knlGS:0000000000000000
[    1.370936] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.370940] CR2: ffffffff830c7c05 CR3: 0000000101e88000 CR4: 0000000000050660
[    1.370946] Call Trace:
[    1.370950]  <TASK>
[    1.370952]  ? __die_body.cold+0x1a/0x1f
[    1.370958]  ? platform_driver_init+0x1a/0x1a
[    1.370963]  ? page_fault_oops+0xd2/0x2b0
[    1.370967]  ? search_module_extables+0x15/0x60
[    1.370973]  ? platform_driver_init+0x1a/0x1a
[    1.370976]  ? exc_page_fault+0xca/0x170
[    1.370982]  ? asm_exc_page_fault+0x22/0x30
[    1.370986]  ? platform_driver_init+0x1a/0x1a
[    1.370989]  ? platform_driver_init+0x1a/0x1a
[    1.370993]  ? __get_free_pages+0xd/0x40
[    1.370997]  swiotlb_init_late+0xd5/0x2b0
[    1.371001]  ? platform_driver_init+0x1a/0x1a
[    1.371004]  ? xenbus_dev_request_and_reply+0x80/0x80
[    1.371009]  pci_xen_swiotlb_init_late+0x4c/0x60
[    1.371015]  pcifront_connect_and_init_dma.cold+0x42/0x66 [xen_pcifront]
[    1.371021]  pcifront_backend_changed+0x274/0x397 [xen_pcifront]
[    1.371028]  ? xenbus_dev_request_and_reply+0x80/0x80
[    1.371031]  ? xenbus_read_driver_state+0x41/0x70
[    1.371035]  ? xenbus_otherend_changed+0x5b/0x110
[    1.371039]  xenwatch_thread+0x8f/0x1b0
[    1.371042]  ? cpuusage_read+0x10/0x10
[    1.371046]  kthread+0xd7/0x100
[    1.371051]  ? kthread_complete_and_exit+0x20/0x20
[    1.371055]  ret_from_fork+0x1f/0x30
[    1.371060]  </TASK>
[    1.371062] Modules linked in: crct10dif_pclmul crct10dif_common crc32_pclmul crc32c_intel xen_pcifront(+)
[    1.371070] CR2: ffffffff830c7c05
[    1.371072] ---[ end trace 0000000000000000 ]---
[    1.371076] RIP: e030:xen_swiotlb_fixup+0x0/0xb7
[    1.371080] Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
[    1.371088] RSP: e02b:ffffc90040177dd8 EFLAGS: 00010286
[    1.371092] RAX: ffffffff830c7c05 RBX: ffff88810a800000 RCX: 0000000000000001
[    1.371096] RDX: 000000000000000a RSI: 0000000000000800 RDI: ffff88810a800000
[    1.371100] RBP: 0000000000000800 R08: 000000000000002a R09: 0000000000000000
[    1.371104] R10: 000000000000000a R11: 0000000000000000 R12: 0000000000000001
[    1.371107] R13: 0000000000002cc0 R14: 0000000000000002 R15: 000000000000000a
[    1.371114] FS:  0000000000000000(0000) GS:ffff888277780000(0000) knlGS:0000000000000000
[    1.371118] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.371122] CR2: ffffffff830c7c05 CR3: 0000000101e88000 CR4: 0000000000050660
[    1.371127] note: xenwatch[42] exited with irqs disabled
[    1.377029] xen_netfront: Initialising Xen virtual ethernet driver
[    6.464888] xenbus_probe_frontend: Waiting for devices to initialise: 25s...
[    6.472956] xenbus_probe_frontend: Waiting for devices to initialise:
[    6.472992] xenbus_probe_frontend: Waiting for devices to initialise:

And we have other reports of (KVM) VMs with pci-passthrough devices
not booting up.

Regards,
Salvatore
