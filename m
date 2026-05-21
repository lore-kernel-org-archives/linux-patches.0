Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B01322522
	for <patches@lists.linux.dev>; Thu, 21 May 2026 05:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779340973; cv=none; b=g1idyC/hz45qNj4kRErYn+uLKaGczwwRLzCKiwyh0YGbGT6B6df4yQDQtyFF1mKq31wZorGp0Sc5HDRnV4sCQPnXiyXQwV/XQQsfCHz/++zBPeZMNrXbsK1PheEc/HBwXHcT+mlSPDjs98LKm8zxaZrQ5Taetlm2mvIsNTzcmq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779340973; c=relaxed/simple;
	bh=JzjhQdJ2WgnOTIYI7H88AKQ7aD2wbhUZ3OX+v23TmnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XgHJboAhsYpnaPkJ3rHLChRjVW2mEEO5GcyXVsTrCgL4uWq3vjfPtCJ1tjeH+081rLwMB0szxZdFPm53qmodCdJn69krkNp3SDDRvSb2E7xsB4k7KU82iKbw19aB/zuOx9mVDnjy5wq+Qf85g1FR7BgrP/ZnFoEc2vNVa1TnQ2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=jVg8gNRf; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="jVg8gNRf"
Received: from francesco-nb (93-38-208-55.ip72.fastwebnet.it [93.38.208.55])
	by mail11.truemail.it (Postfix) with ESMTPA id 2CB2C1F8CB;
	Thu, 21 May 2026 07:22:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1779340969;
	bh=o15KSxT+zAGeSPqW9VYkK8ANSMHwXJq4h0W9cEQevFU=; h=From:To:Subject;
	b=jVg8gNRf5T4Lp4uNflr4KPo2IycmYls0Y63zFxmAbQC11juTp0R62Z8Xbw/wgNFIj
	 xf3bSV0iWS7p5cADA7Ikluk2jqAxn5mHXFvQwOBfNYeHo2k/9Qp2GNyUv+x+neAxV8
	 GFi76tRWQS/lADP7X7nj+0i2+qValEkWPKzMhj7hlDApOKmYQIbWrXW+vgMs87KvXu
	 0BmiSKqaWwmzPKpzaLROaPYqU7N7jERVitaydc176WpSP29a/zNLzhrpMXSLlho14H
	 jN6UEWkoWvfg1v523HvtUZCS0ZU4gpnN5dct5j2UmbXWKBdFDOqz7O6C3tXE9FR77N
	 65zUEfg5wafnA==
Date: Thu, 21 May 2026 07:22:41 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Francesco Dolcini <francesco@dolcini.it>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/508] 6.6.141-rc1 review
Message-ID: <20260521052241.GA8766@francesco-nb>
References: <20260520162058.573354582@linuxfoundation.org>
 <20260521051542.GA6866@francesco-nb>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521051542.GA6866@francesco-nb>

Hello Greg,

On Thu, May 21, 2026 at 07:15:42AM +0200, Francesco Dolcini wrote:
> On Wed, May 20, 2026 at 06:17:03PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.141 release.
> > There are 508 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

I had another look, and despite my test passing there are warnings


kern  :info  : [    0.593597] pci 0000:01:00.0: BAR 4 [io  0x1000-0x101f]: assigned
kern  :info  : [    0.593629] pci 0000:01:00.0: BAR 0 [io  0x1020-0x1027]: assigned
kern  :info  : [    0.593660] pci 0000:01:00.0: BAR 2 [io  0x1028-0x102f]: assigned
kern  :info  : [    0.593692] pci 0000:01:00.0: BAR 1 [io  0x1030-0x1033]: assigned
kern  :info  : [    0.593722] pci 0000:01:00.0: BAR 3 [io  0x1034-0x1037]: assigned
kern  :info  : [    0.593753] pci 0000:00:00.0: PCI bridge to [bus 01-ff]
kern  :info  : [    0.593767] pci 0000:00:00.0:   bridge window [io  0x1000-0x1fff]
kern  :info  : [    0.593781] pci 0000:00:00.0:   bridge window [mem 0x01100000-0x011fffff]
kern  :info  : [    0.593795] pci 0000:00:00.0:   bridge window [mem 0x01200000-0x012fffff pref]
kern  :warn  : [    0.593856] sysfs: cannot create duplicate filename '/devices/platform/soc/1ffc000.pcie/pci0000:00/0000:00:00.0/resource0'
kern  :warn  : [    0.593875] CPU: 1 PID: 28 Comm: kworker/u5:1 Not tainted 6.6.141-rc1-7.7.0-devel #1
kern  :warn  : [    0.593891] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
kern  :warn  : [    0.593904] Workqueue: events_unbound async_run_entry_fn
kern  :warn  : [    0.593959]  unwind_backtrace from show_stack+0x10/0x14
kern  :warn  : [    0.594004]  show_stack from dump_stack_lvl+0x40/0x4c
kern  :warn  : [    0.594040]  dump_stack_lvl from sysfs_warn_dup+0x58/0x64
kern  :warn  : [    0.594080]  sysfs_warn_dup from sysfs_add_bin_file_mode_ns+0xbc/0xcc
kern  :warn  : [    0.594112]  sysfs_add_bin_file_mode_ns from sysfs_create_bin_file+0xac/0xb4
kern  :warn  : [    0.594144]  sysfs_create_bin_file from pci_create_resource_files+0x84/0x13c
kern  :warn  : [    0.594181]  pci_create_resource_files from pci_bus_add_device+0x24/0x94
kern  :warn  : [    0.594220]  pci_bus_add_device from pci_bus_add_devices+0x2c/0x70
kern  :warn  : [    0.594250]  pci_bus_add_devices from pci_host_probe+0x40/0x90
kern  :warn  : [    0.594276]  pci_host_probe from dw_pcie_host_init+0x3e4/0x614
kern  :warn  : [    0.594309]  dw_pcie_host_init from imx6_pcie_probe+0x414/0x6ec
kern  :warn  : [    0.594340]  imx6_pcie_probe from platform_probe+0x5c/0xb0
kern  :warn  : [    0.594375]  platform_probe from really_probe+0xd0/0x3c8
kern  :warn  : [    0.594415]  really_probe from __driver_probe_device+0x98/0x20c
kern  :warn  : [    0.594448]  __driver_probe_device from driver_probe_device+0x30/0xc0
kern  :warn  : [    0.594482]  driver_probe_device from __driver_attach_async_helper+0x50/0xd8
kern  :warn  : [    0.594515]  __driver_attach_async_helper from async_run_entry_fn+0x30/0x144
kern  :warn  : [    0.594548]  async_run_entry_fn from process_one_work+0x144/0x2cc
kern  :warn  : [    0.594584]  process_one_work from worker_thread+0x18c/0x3b8
kern  :warn  : [    0.594611]  worker_thread from kthread+0x110/0x12c
kern  :warn  : [    0.594647]  kthread from ret_from_fork+0x14/0x28
kern  :warn  : [    0.594670] Exception stack(0xf08edfb0 to 0xf08edff8)
kern  :warn  : [    0.594683] dfa0:                                     00000000 00000000 00000000 00000000
kern  :warn  : [    0.594697] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
kern  :warn  : [    0.594709] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
kern  :info  : [    0.594873] mmc0: SDHCI controller on 2198000.mmc [2198000.mmc] using ADMA
kern  :info  : [    0.594997] mmc1: SDHCI controller on 2190000.mmc [2190000.mmc] using ADMA
kern  :info  : [    0.595838] pcieport 0000:00:00.0: PME: Signaling with IRQ 291
kern  :info  : [    0.596396] pcieport 0000:00:00.0: AER: enabled with IRQ 291
kern  :warn  : [    0.596583] sysfs: cannot create duplicate filename '/devices/platform/soc/1ffc000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0/resource0'
kern  :warn  : [    0.596598] CPU: 1 PID: 28 Comm: kworker/u5:1 Not tainted 6.6.141-rc1-7.7.0-devel #1
kern  :warn  : [    0.596614] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
kern  :warn  : [    0.596626] Workqueue: events_unbound async_run_entry_fn
kern  :warn  : [    0.596659]  unwind_backtrace from show_stack+0x10/0x14
kern  :warn  : [    0.596702]  show_stack from dump_stack_lvl+0x40/0x4c
kern  :warn  : [    0.596738]  dump_stack_lvl from sysfs_warn_dup+0x58/0x64
kern  :warn  : [    0.596772]  sysfs_warn_dup from sysfs_add_bin_file_mode_ns+0xbc/0xcc
kern  :warn  : [    0.596804]  sysfs_add_bin_file_mode_ns from sysfs_create_bin_file+0xac/0xb4
kern  :warn  : [    0.596836]  sysfs_create_bin_file from pci_create_resource_files+0x84/0x13c
kern  :warn  : [    0.596872]  pci_create_resource_files from pci_bus_add_device+0x24/0x94
kern  :warn  : [    0.596907]  pci_bus_add_device from pci_bus_add_devices+0x2c/0x70
kern  :warn  : [    0.596938]  pci_bus_add_devices from pci_bus_add_devices+0x60/0x70
kern  :warn  : [    0.596968]  pci_bus_add_devices from pci_host_probe+0x40/0x90
kern  :warn  : [    0.596994]  pci_host_probe from dw_pcie_host_init+0x3e4/0x614
kern  :warn  : [    0.597022]  dw_pcie_host_init from imx6_pcie_probe+0x414/0x6ec
kern  :warn  : [    0.597048]  imx6_pcie_probe from platform_probe+0x5c/0xb0
kern  :warn  : [    0.597074]  platform_probe from really_probe+0xd0/0x3c8
kern  :warn  : [    0.597105]  really_probe from __driver_probe_device+0x98/0x20c
kern  :warn  : [    0.597138]  __driver_probe_device from driver_probe_device+0x30/0xc0
kern  :warn  : [    0.597170]  driver_probe_device from __driver_attach_async_helper+0x50/0xd8
kern  :warn  : [    0.597202]  __driver_attach_async_helper from async_run_entry_fn+0x30/0x144
kern  :warn  : [    0.597232]  async_run_entry_fn from process_one_work+0x144/0x2cc
kern  :warn  : [    0.597261]  process_one_work from worker_thread+0x18c/0x3b8
kern  :warn  : [    0.597288]  worker_thread from kthread+0x110/0x12c
kern  :warn  : [    0.597315]  kthread from ret_from_fork+0x14/0x28
kern  :warn  : [    0.597335] Exception stack(0xf08edfb0 to 0xf08edff8)
kern  :warn  : [    0.597350] dfa0:                                     00000000 00000000 00000000 00000000
kern  :warn  : [    0.597364] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
kern  :warn  : [    0.597376] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
kern  :info  : [    0.631336] mmc1: new high speed SDXC card at address 0001
kern  :info  : [    0.632908] mmcblk1: mmc1:0001 SD64G 58.2 GiB
kern  :info  : [    0.642235] fec 2188000.ethernet eth0: registered PHC device 0
kern  :info  : [    0.643162] imx_thermal 20c8000.anatop:tempmon: Industrial CPU temperature grade - max:105C critical:105C passive:95C


