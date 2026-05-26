Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8927E409132
	for <patches@lists.linux.dev>; Tue, 26 May 2026 18:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779818762; cv=none; b=mE7q4kP7myqdgEEbmpshHwvZR0nor2q8MpztWxESYkFnK1D7rwXNCoOs99BZPzFS2qRP02zuNKRVww0xK1FnbJMhnaGmwCuVJlkQ47mrrizEqenJgSHEg3eezAyjHx1lGAThgmdFAMSu7Wo2pAkNlt/8X9tkx+3fbSjGXM5djtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779818762; c=relaxed/simple;
	bh=kIP2+evibNPf3LsLn2/w+GsVX1bv56Y0F/lDGcHB188=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEgc0XiGkjtgfupOlb/0pX4ANHZzAx9Dov+KtzjbEdIz6qi4N4EMgpxQH5X4n+sqXJOAa93WJqcvDJrMHwpXoPAUNfJZre1TBlOx8r9WRcRuK8kWXraWmjOodxE4r1d1AfdJXTsq7jWYCRUsjSMbfZToyLe7BOn6sBR3HnfCZe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kOHV4zmj; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kOHV4zmj"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-835c98b659eso8826034b3a.0
        for <patches@lists.linux.dev>; Tue, 26 May 2026 11:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779818760; x=1780423560; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MWi74t3bYV7mM8mv2QAR7wV+HKAWFpjIBovoKvmCAWo=;
        b=kOHV4zmjwygBZGKXoMy6gvmDGHIvd1DgtWOvV2cdgphNoVacjSctB3+PgU9nNjf15+
         5fQ0+9EODSx9MR43tBj0C7Cnn4SrMEQDL8kM07WHXDVE8VywyPbue0eMnzvzqOl+7Ne0
         TVcCuRHSRU6Dpy0Jf9LV4C7RsTlo2BbCC2cYH0FC9ju6xgDHVS7mvyCRt02mHccJ+nEz
         ZpodV1b30yjWcUHGcE7tCj8rQO+bfJfOvmAhPN5UtevZjdS7zeVlYJZ9z5OzXYqrDOPh
         RZe5wVUCM/jyiZk4u1Y7TM/CakDgfcgW1wLaLkbMaxlK1F2Lx/MkDo2akT36cLXNW0I5
         7n1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818760; x=1780423560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MWi74t3bYV7mM8mv2QAR7wV+HKAWFpjIBovoKvmCAWo=;
        b=dnsQ8BIrL4y92ceDrBDbGaOU2CXUlvpL4F7NavtWmBdq9tfQ/7QicxojmU2XiqIy6r
         1UCUonYsNoQ+Qt14BaCCxvV5x5FWzCMdJHSFm+g+NrQq8GcwV4sb574O2o/tKK6dWqm1
         oD6fGk00hg/ZIlYzdePvZVrC7G9ymN/7M+ct6ojkZWAblIFVnbWBgp2dxJkIbo5fFUv2
         8j/4SozXh98ijw0jYuDy+7eJ2XTqoBoPhhlpmOG1NZCOpskFbhvg697czzGE2xcLUmu/
         1qxh1VfymBidmH39G0RQpNK6GA/otaZCWojq/HASoeF+3dmUaX/FSYWerBePP/CaVfag
         nZ+g==
X-Forwarded-Encrypted: i=1; AFNElJ/fOXUz5NG1gIHV3WhVqKI5PutBds68XB8zZn1v280nv/ZI4o91LkCjnE8rKLp7zc87jM3lEoLV@lists.linux.dev
X-Gm-Message-State: AOJu0Ywt2esX2vNgxH0fOYLuMmNrbnFBMbzVdKxNIe2huyANtfnwEoVE
	Szd1dfSkFlAauDBjUDVe4FzwLLNoio0db4oIZM2FtHC6UtfOOWLDxkbf
X-Gm-Gg: Acq92OEEwE2dfJ0BW3hioPm8fVcNetP1flT9AO6lhkufsSLORGC84iFYrMzQuGDEhgV
	S0Zs/0YbPU1103QcGYowFZLesUYlmxVwJOD+8JW8xnEnM6KkhAkM4dEc75Pg2qWWZRK/EjJ9Qxv
	jaGp8j2xGuweQrBSWvroB4d0/QR9O7hoz5z2cP8eyYMLgRuDeGRvxnRGH3kOTY0PNsjDsPF0vJp
	59szNX7pLtcA3ZIHkp8bdS4UXL+6tAN3ZwlGe4k8OnnGYjcqyewNoIrcBYJFmg8P0ZYk2fuvmOh
	wQogdaXdhSPolyHPMBcW1hmPxvthrbGnvCBHywuu9+FslH58dXgZpmdmYQCO5a2XX+m41UDNP2u
	LW8Tr+gnF8kadhLvbg/AQyA0MGufJyNVd/nykdpWdK8nk0FRpy8imKt0zCUKxX/HJ61qnH4otjN
	Sg8PW9MOWFuV2X1MXOgarEPoovGTpu9wijNfjzq/KeLaMJLYOKh+ZaPxlU/g3UF+Pyn1+k1RUOK
	YzOap3ewnDf6WFXui3sUdDxmUidQBqoA2cflMjvIfYPrfyxzIQ=
X-Received: by 2002:a05:6a00:1f11:b0:83b:905:c9fd with SMTP id d2e1a72fcca58-8415f32e8b0mr17791524b3a.24.1779818759878;
        Tue, 26 May 2026 11:05:59 -0700 (PDT)
Received: from leonardoc-nb (201-68-197-52.dsl.telesp.net.br. [201.68.197.52])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164e9e7cdsm13841950b3a.34.2026.05.26.11.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 11:05:59 -0700 (PDT)
From: Leonardo Costa <leoreis.costa@gmail.com>
To: ryanmatthews@fastmail.com,
	hongxing.zhu@nxp.com,
	bhelgaas@google.com,
	linux-pci@vger.kernel.org,
	linux-imx@nxp.com
Cc: francesco@dolcini.it,
	achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	gregkh@linuxfoundation.org,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.6 000/508] 6.6.141-rc1 review
Date: Tue, 26 May 2026 15:05:37 -0300
Message-ID: <20260526180537.21223-1-leoreis.costa@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260521052241.GA8766@francesco-nb>
References: <20260521052241.GA8766@francesco-nb>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello all,

> kern  :info  : [    0.593597] pci 0000:01:00.0: BAR 4 [io  0x1000-0x101f]: assigned
> kern  :info  : [    0.593629] pci 0000:01:00.0: BAR 0 [io  0x1020-0x1027]: assigned
> kern  :info  : [    0.593660] pci 0000:01:00.0: BAR 2 [io  0x1028-0x102f]: assigned
> kern  :info  : [    0.593692] pci 0000:01:00.0: BAR 1 [io  0x1030-0x1033]: assigned
> kern  :info  : [    0.593722] pci 0000:01:00.0: BAR 3 [io  0x1034-0x1037]: assigned
> kern  :info  : [    0.593753] pci 0000:00:00.0: PCI bridge to [bus 01-ff]
> kern  :info  : [    0.593767] pci 0000:00:00.0:   bridge window [io  0x1000-0x1fff]
> kern  :info  : [    0.593781] pci 0000:00:00.0:   bridge window [mem 0x01100000-0x011fffff]
> kern  :info  : [    0.593795] pci 0000:00:00.0:   bridge window [mem 0x01200000-0x012fffff pref]
> kern  :warn  : [    0.593856] sysfs: cannot create duplicate filename '/devices/platform/soc/1ffc000.pcie/pci0000:00/0000:00:00.0/resource0'
> kern  :warn  : [    0.593875] CPU: 1 PID: 28 Comm: kworker/u5:1 Not tainted 6.6.141-rc1-7.7.0-devel #1
> kern  :warn  : [    0.593891] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> kern  :warn  : [    0.593904] Workqueue: events_unbound async_run_entry_fn
> kern  :warn  : [    0.593959]  unwind_backtrace from show_stack+0x10/0x14
> kern  :warn  : [    0.594004]  show_stack from dump_stack_lvl+0x40/0x4c
> kern  :warn  : [    0.594040]  dump_stack_lvl from sysfs_warn_dup+0x58/0x64
> kern  :warn  : [    0.594080]  sysfs_warn_dup from sysfs_add_bin_file_mode_ns+0xbc/0xcc
> kern  :warn  : [    0.594112]  sysfs_add_bin_file_mode_ns from sysfs_create_bin_file+0xac/0xb4
> kern  :warn  : [    0.594144]  sysfs_create_bin_file from pci_create_resource_files+0x84/0x13c
> kern  :warn  : [    0.594181]  pci_create_resource_files from pci_bus_add_device+0x24/0x94
> kern  :warn  : [    0.594220]  pci_bus_add_device from pci_bus_add_devices+0x2c/0x70
> kern  :warn  : [    0.594250]  pci_bus_add_devices from pci_host_probe+0x40/0x90
> kern  :warn  : [    0.594276]  pci_host_probe from dw_pcie_host_init+0x3e4/0x614
> kern  :warn  : [    0.594309]  dw_pcie_host_init from imx6_pcie_probe+0x414/0x6ec
> kern  :warn  : [    0.594340]  imx6_pcie_probe from platform_probe+0x5c/0xb0
> kern  :warn  : [    0.594375]  platform_probe from really_probe+0xd0/0x3c8
> kern  :warn  : [    0.594415]  really_probe from __driver_probe_device+0x98/0x20c
> kern  :warn  : [    0.594448]  __driver_probe_device from driver_probe_device+0x30/0xc0
> kern  :warn  : [    0.594482]  driver_probe_device from __driver_attach_async_helper+0x50/0xd8
> kern  :warn  : [    0.594515]  __driver_attach_async_helper from async_run_entry_fn+0x30/0x144
> kern  :warn  : [    0.594548]  async_run_entry_fn from process_one_work+0x144/0x2cc
> kern  :warn  : [    0.594584]  process_one_work from worker_thread+0x18c/0x3b8
> kern  :warn  : [    0.594611]  worker_thread from kthread+0x110/0x12c
> kern  :warn  : [    0.594647]  kthread from ret_from_fork+0x14/0x28
> kern  :warn  : [    0.594670] Exception stack(0xf08edfb0 to 0xf08edff8)
> kern  :warn  : [    0.594683] dfa0:                                     00000000 00000000 00000000 00000000
> kern  :warn  : [    0.594697] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> kern  :warn  : [    0.594709] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> kern  :info  : [    0.594873] mmc0: SDHCI controller on 2198000.mmc [2198000.mmc] using ADMA
> kern  :info  : [    0.594997] mmc1: SDHCI controller on 2190000.mmc [2190000.mmc] using ADMA
> kern  :info  : [    0.595838] pcieport 0000:00:00.0: PME: Signaling with IRQ 291
> kern  :info  : [    0.596396] pcieport 0000:00:00.0: AER: enabled with IRQ 291
> kern  :warn  : [    0.596583] sysfs: cannot create duplicate filename '/devices/platform/soc/1ffc000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0/resource0'
> kern  :warn  : [    0.596598] CPU: 1 PID: 28 Comm: kworker/u5:1 Not tainted 6.6.141-rc1-7.7.0-devel #1
> kern  :warn  : [    0.596614] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> kern  :warn  : [    0.596626] Workqueue: events_unbound async_run_entry_fn
> kern  :warn  : [    0.596659]  unwind_backtrace from show_stack+0x10/0x14
> kern  :warn  : [    0.596702]  show_stack from dump_stack_lvl+0x40/0x4c
> kern  :warn  : [    0.596738]  dump_stack_lvl from sysfs_warn_dup+0x58/0x64
> kern  :warn  : [    0.596772]  sysfs_warn_dup from sysfs_add_bin_file_mode_ns+0xbc/0xcc
> kern  :warn  : [    0.596804]  sysfs_add_bin_file_mode_ns from sysfs_create_bin_file+0xac/0xb4
> kern  :warn  : [    0.596836]  sysfs_create_bin_file from pci_create_resource_files+0x84/0x13c
> kern  :warn  : [    0.596872]  pci_create_resource_files from pci_bus_add_device+0x24/0x94
> kern  :warn  : [    0.596907]  pci_bus_add_device from pci_bus_add_devices+0x2c/0x70
> kern  :warn  : [    0.596938]  pci_bus_add_devices from pci_bus_add_devices+0x60/0x70
> kern  :warn  : [    0.596968]  pci_bus_add_devices from pci_host_probe+0x40/0x90
> kern  :warn  : [    0.596994]  pci_host_probe from dw_pcie_host_init+0x3e4/0x614
> kern  :warn  : [    0.597022]  dw_pcie_host_init from imx6_pcie_probe+0x414/0x6ec
> kern  :warn  : [    0.597048]  imx6_pcie_probe from platform_probe+0x5c/0xb0
> kern  :warn  : [    0.597074]  platform_probe from really_probe+0xd0/0x3c8
> kern  :warn  : [    0.597105]  really_probe from __driver_probe_device+0x98/0x20c
> kern  :warn  : [    0.597138]  __driver_probe_device from driver_probe_device+0x30/0xc0
> kern  :warn  : [    0.597170]  driver_probe_device from __driver_attach_async_helper+0x50/0xd8
> kern  :warn  : [    0.597202]  __driver_attach_async_helper from async_run_entry_fn+0x30/0x144
> kern  :warn  : [    0.597232]  async_run_entry_fn from process_one_work+0x144/0x2cc
> kern  :warn  : [    0.597261]  process_one_work from worker_thread+0x18c/0x3b8
> kern  :warn  : [    0.597288]  worker_thread from kthread+0x110/0x12c
> kern  :warn  : [    0.597315]  kthread from ret_from_fork+0x14/0x28
> kern  :warn  : [    0.597335] Exception stack(0xf08edfb0 to 0xf08edff8)
> kern  :warn  : [    0.597350] dfa0:                                     00000000 00000000 00000000 00000000
> kern  :warn  : [    0.597364] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> kern  :warn  : [    0.597376] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> kern  :info  : [    0.631336] mmc1: new high speed SDXC card at address 0001
> kern  :info  : [    0.632908] mmcblk1: mmc1:0001 SD64G 58.2 GiB
> kern  :info  : [    0.642235] fec 2188000.ethernet eth0: registered PHC device 0
> kern  :info  : [    0.643162] imx_thermal 20c8000.anatop:tempmon: Industrial CPU temperature grade - max:105C critical:105C passive:95C

This warning happens on our tests for Apalis iMX6, and seems to come from the
imx6_pcie_probe function in the pci-imx6.c driver. We found some instances of
this happening on as early as 6.6.129. This went unnoticed until now, we're 
not sure when this started to happen.

Do you know what could be causing the duplicate file here?
