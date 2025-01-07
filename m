Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C0F259C
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 00:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736210168; cv=none; b=iS/HFmQBKOvBweEq/FixAFhoYHvuNG5WFPGv5LH+VNFQqRZ7qjhSP0r7bvoF0LDGN38+Jt0cg58F4hMLjVuPfe3GmxgVFsfZADVRLDu5oKIWs1FWT7VaceguG6iZ88IiSY4sitgCHXAbXGnEaooqliWMT4ZxEyOW488dx7T60QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736210168; c=relaxed/simple;
	bh=KQBS8V9zO/o//0Y8Xje+RRZe5uUi4BHvtEH8WcRP3s4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WNW8F/Y0iUuFoCTO9+x3b2ZJeX4NW0SG6YRKQDpLCjOq1nvqzZrvx10CzF0YxFND9jybwLN3pSwmhiYux5w3LKPb2j2zZTk7dZFurbL/grxvZjdnKCNQS40J6i6NRgB70RdkQgqxl19CNJIOL9+HiiwFi6jw0TfY85CQqC76cVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=FQRzidcb; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FQRzidcb"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5d3f65844deso25543810a12.0
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 16:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1736210165; x=1736814965; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tzoqP7VUFyC5xlqPKb8r6BlrzHDCAh4iXBERhXh5St4=;
        b=FQRzidcb7SmW3w0IBoALAgNnDF1Pr9qY8mCyzhAu/FYv/Ahrxx+fSiMSisPEqC6Amp
         cE+Vj5vkkC0U4xc3mX5kJO8ra2NR3IZ7iJGrJtd2V7yiZexL4FaSXdmVJB3X3PoSzGB/
         UWVqecydLsoK7f3BotAtVOKFpcIY0RSUwVj42mNsFagwDSva1JZSHzThXr+7QD8mlD3h
         Nec8+/5ZUM2iaa443/ZDNVmeEhquFu/NiNFLocq8SUMxxSMX7kdI3MdtS6hGlLT/0KCy
         r55dOoKXyqn5lgaHGlktIlnMp5sOhfYCB2WQbWGrne4UgQlHaeTcSsiQPSs/qpafjY1B
         kSVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736210165; x=1736814965;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tzoqP7VUFyC5xlqPKb8r6BlrzHDCAh4iXBERhXh5St4=;
        b=dqfK0DoUtD8iXzaI1EyDlOh/D57kxAvNPuERrC7pAadY3NXDpBnzfAuppGmW0X8wM+
         3/Re6qo+doXc3C1ZS1IOwqReRickVkUdOC+Gsy9Xsp0fxXQbFqDeH3+oOW3vH5gFWZ4O
         r7P+e4naEnMXfZQwX5a8G7wc86KYR3vpTp0jdqWSG+zjvl9vPlNna3+LhbU+SejFkMAS
         9A2CxZ17GKF1HDAhNBnu7Wf3sO8IYWJUO1rvp5j2+x68DQJJIaXLI63RBpSKhffLmjOc
         sXULQyb9LWBzMtyazDiKwfNc4laQUI/nzn3iGo+v9PV7HLypQ9PoRPIUXaDVHH8H6o3i
         uFfA==
X-Gm-Message-State: AOJu0Yy9pFDZWOPLpKQlUYHq2zoPxjKUPFrYNr5Yc/zdDX9/UM/34byA
	1f+VaLyoVIbMJf4LfcQdSRABbgeldSjgVknJ9NgR/Z4fTUJDmXQ=
X-Gm-Gg: ASbGncteRaJZk3pr8VKbJkAorzPjU+cpemCmaYVchTTE12rNfEo5R0Woubph2O6eIYL
	5x8lR3NoRxCCiH19dN3emEkYsTaZLDIt/MjhBpxqBqJC7p4QCrEltwQ0KTMVgDz9fF3FXW1fKXj
	3bRxtftTpe8BnM24yiu5uTV7dvx0TA9PoK0GR56OnllidLbbSNdT0S+0HcjaEK3CBH+9B8btJO6
	NSHpK7/Mk1RhOBjLZS+o66znoaTSXDu5t2nH8k+bcpfbLMI+oMAOkU0TO5ca0bmBN8VuNazTzyP
	WIetV7L+2mvSKNSQRJUcJqSq2Wi7mhqQ
X-Google-Smtp-Source: AGHT+IFj+Yor/734CYqFoAEpmejra+JRG8327Ef7/5uhWrQH0A0ClV/W8Iy20jbswFN/baFZtIZIRg==
X-Received: by 2002:a50:cc04:0:b0:5d8:a46f:110b with SMTP id 4fb4d7f45d1cf-5d8a46f1123mr29718731a12.17.1736210164684;
        Mon, 06 Jan 2025 16:36:04 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4110.dip0.t-ipconnect.de. [91.43.65.16])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80679eea6sm23555260a12.49.2025.01.06.16.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 16:36:02 -0800 (PST)
Message-ID: <896ab5a8-e86b-4176-812f-9111b44df90a@googlemail.com>
Date: Tue, 7 Jan 2025 01:36:00 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/222] 6.6.70-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250106151150.585603565@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.01.2025 um 16:13 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.70 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

6.6.70-rc1 builds, boots and seems to work on my 2-socket Ivy Bridge Xeon E5-2697 v2 
server, but I see a scary looking dmesg warning, right after booting. As it is currently 
running, I will try building 6.12.9-rc with it, and see how that goes. The dmesg warnings 
I see look similar to that already reported by Miguel Ojeda.


[    0.012910] ACPI: Reserving ERST table memory at [mem 0x7cca41c8-0x7cca43f7]
[    0.012911] ACPI: Reserving HEST table memory at [mem 0x7cca43f8-0x7cca449f]
[    0.012912] ACPI: Reserving BERT table memory at [mem 0x7cca44a0-0x7cca44cf]
[    0.012938] ------------[ cut here ]------------
[    0.012939] Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead
[    0.012948] WARNING: CPU: 0 PID: 0 at mm/memblock.c:1324 memblock_set_node+0x10c/0x120
[    0.012955] Modules linked in:
[    0.012956] CPU: 0 PID: 0 Comm: swapper Not tainted 6.6.70-rc1+ #1
[    0.012959] Hardware name: ASUSTeK COMPUTER INC. Z9PE-D16 Series/Z9PE-D16 Series, BIOS 
5601 06/11/2015
[    0.012960] RIP: 0010:memblock_set_node+0x10c/0x120
[    0.012962] Code: 0f 87 fe c0 ca 00 41 83 e4 01 74 0b 41 bc ff ff ff ff e9 50 ff ff ff 
48 c7 c7 d0 28 fa 98 c6 05 58 0a 13 02 01 e8 14 86 ce ff <0f> 0b eb de e8 fb e3 d0 00 66 
66 2e 0f 1f 84 00 00 00 00 00 90 90
[    0.012965] RSP: 0000:ffffffff99803df8 EFLAGS: 00010046 ORIG_RAX: 0000000000000000
[    0.012967] RAX: 0000000000000000 RBX: ffffffff999fc990 RCX: 0000000000000000
[    0.012969] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[    0.012970] RBP: ffffffff99803e28 R08: 0000000000000000 R09: 0000000000000000
[    0.012971] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[    0.012972] R13: 0000000000000000 R14: ffffffffffffffff R15: 000000000008a000
[    0.012973] FS:  0000000000000000(0000) GS:ffffffff99bb0000(0000) knlGS:0000000000000000
[    0.012975] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.012976] CR2: ffff9e62eac01000 CR3: 0000000ae9e36000 CR4: 00000000000200f0
[    0.012978] Call Trace:
[    0.012979]  <TASK>
[    0.012981]  ? show_regs+0x6d/0x80
[    0.012987]  ? __warn+0x89/0x160
[    0.012990]  ? memblock_set_node+0x10c/0x120
[    0.012993]  ? report_bug+0x17e/0x1b0
[    0.012996]  ? fixup_exception+0x27/0x370
[    0.013000]  ? early_fixup_exception+0x9b/0xf0
[    0.013004]  ? do_early_exception+0x25/0x80
[    0.013008]  ? early_idt_handler_common+0x2f/0x3a
[    0.013013]  ? memblock_set_node+0x10c/0x120
[    0.013015]  ? memblock_set_node+0x10c/0x120
[    0.013017]  ? __pfx_x86_acpi_numa_init+0x10/0x10
[    0.013021]  numa_init+0x82/0x570
[    0.013025]  x86_numa_init+0x1f/0x60
[    0.013028]  initmem_init+0xe/0x20
[    0.013030]  setup_arch+0x98b/0xea0
[    0.013034]  start_kernel+0x6c/0xb00
[    0.013039]  ? load_ucode_intel_bsp+0x3d/0x80
[    0.013044]  x86_64_start_reservations+0x18/0x30
[    0.013046]  x86_64_start_kernel+0xbf/0x110
[    0.013049]  secondary_startup_64_no_verify+0x18f/0x19b
[    0.013056]  </TASK>
[    0.013057] ---[ end trace 0000000000000000 ]---
[    0.013063] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.013065] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.013066] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.013066] SRAT: PXM 0 -> APIC 0x03 -> Node 0



Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
