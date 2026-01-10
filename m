Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5882D7DDF
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 08:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768034513; cv=none; b=duOUDiH4/Z3ATEqD4XxsdtnHGkg76/+zzjeTxGywveGyCaOHLhDGZUvfuUYUctGr1GF0BIueeFOhgefIP9kshuToQW7NbT2/tBqlBrxnPNjQkPF+rxRHRjdgwT7xgv2NWpVibymXc6aYRdDXfm5QhXVZ6IsbxawHnc5hfSCVX5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768034513; c=relaxed/simple;
	bh=BCRNlgzCQQc1Jlrbfncr5/Zhoc8nxLGoDKgyHIkSqc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p49g5KlvBNynzdgi3q10Vmb6CJ2K1sFzTyugN85JmQCLH+jqANxlKHhwiax1Kwmhu6nvNJNwRKHCKVBs1vGIxUPd2CMdnlfo5P36yoQGgxUsepBTGylvJg1f5QiflnFmUSYrmjY4QcBWXsKYwfn+aZcibuXUbBUtZvDwGOE5Hss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=EZCi0C4e; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="EZCi0C4e"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id D539B1FD2D;
	Sat, 10 Jan 2026 09:41:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1768034510;
	bh=gMgq88MR9l/4UHEPUX3l+HmX7mUmb38yAKXrvdDyDD0=; h=From:To:Subject;
	b=EZCi0C4ey7LIzQtch+wkafTtEb7AbAh0DksWt2wKPtABo0BFW2BPrNPimX/DK2VDP
	 ojhoQ0/aQTDmO9VJakduBR7veCtNIwKfbBe3k4GOkLimhfSqvsFxuSD9sC6TXZKDrS
	 MkpmfxcaXNl81NixDjE74gnrVsfkgjf6LDOJEWDofyCJl6JgJ1GHkZh7SZ9qmAqJ9z
	 4V6qUwcabNTHYS2izYWFZ854DhCdEYbM64DXrKERk04bOYBGX60GFXtiq15Cub7uDa
	 S2C6dwpLJEamKXrLbaGquGFIiiDn+jPdrQT6oYJMAfAKTz/3lRCDPg6c4p2PvrgqQo
	 xNVlI+ghPJF6w==
Date: Sat, 10 Jan 2026 09:41:42 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/634] 6.1.160-rc1 review
Message-ID: <20260110084142.GA6242@francesco-nb>
References: <20260109112117.407257400@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>

On Fri, Jan 09, 2026 at 12:34:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.160 release.
> There are 634 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

It seems this introduces a regression on Verdin i.MX8MP compared to 6.1.159.

[   10.209496] Unable to handle kernel paging request at virtual address ffff8001f537c000
[   10.217443] Mem abort info:
[   10.220242]   ESR = 0x0000000096000005
[   10.223997]   EC = 0x25: DABT (current EL), IL = 32 bits
[   10.229317]   SET = 0, FnV = 0
[   10.232376]   EA = 0, S1PTW = 0
[   10.235522]   FSC = 0x05: level 1 translation fault
[   10.240404] Data abort info:
[   10.243288]   ISV = 0, ISS = 0x00000005
[   10.247127]   CM = 0, WnR = 0
[   10.250099] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000049c42000
[   10.256806] [ffff8001f537c000] pgd=100000023ffff003, p4d=100000023ffff003, pud=0000000000000000
[   10.265525] Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
[   10.271801] Modules linked in: 8021q garp mrp stp llc spidev caam_jr caamhash_desc caamalg_desc bluetooth crypto_engine rng_core authenc libdes ecdh_generic ecc mwifiex_sdio dwmac_imx stmmac_platform stmmac mwifiex cfg80211 imx_sdma pcs_xpcs crct10dif_ce fsl_imx8_ddr_perf etnaviv rfkill gpu_sched governor_userspace imx_bus ina2xx ti_ads1015 snvs_pwrkey industrialio_triggered_buffer lm75 rtc_ds1307 kfifo_buf rtc_snvs flexcan can_dev caam error spi_imx imx8mm_thermal pwm_imx27 imx_cpufreq_dt libcomposite fuse drm ipv6
[   10.317785] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W          6.1.160-rc1-6.8.5-devel+git.b40085af0da5 #1
[   10.328155] Hardware name: Toradex Verdin iMX8M Plus WB on Dahlia Board (DT)
[   10.335215] pstate: 200000c5 (nzCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   10.342195] pc : dwmac4_dma_interrupt+0x120/0x270 [stmmac]
[   10.347750] lr : stmmac_napi_check+0x50/0x1e0 [stmmac]
[   10.352941] sp : ffff800008003e40
[   10.356262] x29: ffff800008003e40 x28: ffff80000a253f80 x27: 00000000fff0e80c
[   10.363419] x26: ffff80000a253f80 x25: ffff8000097d3c50 x24: ffff80000a5cc07d
[   10.370575] x23: 0000000000000005 x22: 0000000000000005 x21: ffff800008003ea8
[   10.377729] x20: 0000000000000000 x19: ffff0000c6cc0900 x18: 0000000000000000
[   10.384885] x17: ffff8001f537c000 x16: ffff800008000000 x15: 0000aaaaf065c7c0
[   10.392036] x14: 0000001a92b60e94 x13: 0000000000000128 x12: 0000000000000001
[   10.399190] x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
[   10.406345] x8 : 0000000000000000 x7 : ffff8001f537c000 x6 : 000000000000d041
[   10.413498] x5 : 0000000000008040 x4 : ffff8001f537c000 x3 : 0000000000000000
[   10.420653] x2 : ffff0000c6cc4540 x1 : ffff80000b330000 x0 : 0000000000000000
[   10.427811] Call trace:
[   10.430266]  dwmac4_dma_interrupt+0x120/0x270 [stmmac]
[   10.435460]  stmmac_interrupt+0xb0/0x150 [stmmac]
[   10.440218]  __handle_irq_event_percpu+0x5c/0x170
[   10.444942]  handle_irq_event+0x4c/0xc0
[   10.448791]  handle_fasteoi_irq+0xa4/0x1a0
[   10.452901]  handle_irq_desc+0x40/0x60
[   10.456663]  generic_handle_domain_irq+0x1c/0x30
[   10.461295]  gic_handle_irq+0x50/0x130
[   10.465059]  call_on_irq_stack+0x30/0x48
[   10.468990]  do_interrupt_handler+0x80/0x90
[   10.473185]  el1_interrupt+0x34/0x70
[   10.476780]  el1h_64_irq_handler+0x18/0x30
[   10.480895]  el1h_64_irq+0x64/0x68
[   10.484310]  arch_cpu_idle+0x18/0x30
[   10.487899]  default_idle_call+0x30/0x6c
[   10.491831]  do_idle+0x248/0x2c0
[   10.495071]  cpu_startup_entry+0x34/0x40
[   10.499004]  rest_init+0xe4/0xf0
[   10.502246]  arch_post_acpi_subsys_init+0x0/0x18
[   10.506873]  start_kernel+0x688/0x6cc
[   10.510551]  __primary_switched+0xbc/0xc4
[   10.514576] Code: 35ffffab 321d0000 17ffffec f9800091 (c85f7c8c)
[   10.520687] ---[ end trace 0000000000000000 ]---
[   10.525316] Kernel panic - not syncing: Oops: Fatal exception in interrupt
[   10.532199] SMP: stopping secondary CPUs
[   10.536132] Kernel Offset: disabled
[   10.539628] CPU features: 0x000000,00800084,0000421b
[   10.544602] Memory Limit: none
[   10.547664] ---[ end Kernel panic - not syncing: Oops: Fatal exception in interrupt ]---


Thanks,
Francesco

