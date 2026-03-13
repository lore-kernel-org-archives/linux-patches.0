Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74C736C0BE
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 07:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773386854; cv=none; b=YQtuUTOW/TJHhZiK/+WqpdiJlCfty2aXswUxQu+RbPeUUXrnRHtMBxs0hojgN8BBzUI1KrZG9TdTKzgDRpz4vZjM+oqzWVe1ks4GY/H2M5W6IHzHjSOU40XbFEosh14OhNFRF7NAVB2YpljiyJ5B5xCvWoQP36dP73ddRp6leNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773386854; c=relaxed/simple;
	bh=duVhzSMaRrVyzFD9eIEANZk3lfy9PWVIpeTl+rUW6tg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pCc7gb8YOh40BzDlljdmEq5T1b87qlJzigA58psa5O7ZCS8K6IBLhJdydDSk92Tkxxd3afSIzq9HDOrIIB/T3tU4mdqmAZuGA2HvHTC/Cc426c/f0ezwCcP90nx4u5JrL/HNfSWT2DkpbHvlwUTt91MKfSTbcLk/N1FCBggh+9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=amZLPkPL; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="amZLPkPL"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 7EDA821429;
	Fri, 13 Mar 2026 08:27:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1773386848;
	bh=EXVot46du26sihN/Ow1Ufjr5/7L0XwLrBb40xXv1AIc=; h=From:To:Subject;
	b=amZLPkPLg1RsZRYnTeU9BWgGl1cQDXUY4W8BQkKmN9UU3fQz6r3FPkzD+YyOLfZZV
	 FzfwH0Tnu/D2GCHpe4vufudrTEkc47P8E/ykFNqrRrxZv1m1637TVmH0fjP8f8rIMX
	 RMmwNtfmhGSobEM6X75RpFCsXuQmOLfVQ2nIsXVteOrsW8EWoLDGWdF5+cgF+4sVVJ
	 uuI5VcC+hrpf+NaRrt9PO8py0oYE+hidUTSxGZKaDCA6wvuRG238s51dkF/yAk349v
	 4Vdqs2ocPagNYOKv/qQQhLEj7WxUAEtqbYECO981lUbvqJqK8j7KuRCQJuAC/1oPVE
	 zJLsFazrLoxKw==
Date: Fri, 13 Mar 2026 08:27:23 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Ron Economos <re@w6rz.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Barry K. Nathan" <barryn@pobox.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: freeze during boot regression Re: [PATCH 6.12 000/265]
 6.12.77-rc1 review
Message-ID: <20260313072723.GA6236@francesco-nb>
References: <20260312201018.128816016@linuxfoundation.org>
 <b4f58774-18d4-4a32-9c85-603f9e2c98fc@pobox.com>
 <ee851013-fec8-47f8-9863-392f17e54474@pobox.com>
 <2a313336-ccfc-42b7-a14d-c116733ef64a@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <2a313336-ccfc-42b7-a14d-c116733ef64a@w6rz.net>

On Thu, Mar 12, 2026 at 11:10:24PM -0700, Ron Economos wrote:
> I'm seeing this WARN on RISC-V in the same place.
>=20
> Starting systemd-udevd version 255.4-1ubuntu8.12
> [=A0 =A0 5.417957] usb 1-2: new high-speed USB device number 2 using xhci=
_hcd
> [=A0 =A0 5.765956] ------------[ cut here ]------------
> [=A0 =A0 5.765976] WARNING: CPU: 0 PID: 17 at kernel/sched/fair.c:5266 pl=
ace_entity+0x130/0x138
> [=A0 =A0 5.766013] Modules linked in:
> [=A0 =A0 5.766028] CPU: 0 UID: 0 PID: 17 Comm: rcu_preempt Not tainted 6.=
12.77-rc1 #2
> [=A0 =A0 5.766038] Hardware name: SiFive HiFive Unmatched A00 (DT)
> [=A0 =A0 5.766043] epc : place_entity+0x130/0x138
> [=A0 =A0 5.766052]=A0 ra : place_entity+0x9c/0x138
> [=A0 =A0 5.766061] epc : ffffffff800721c8 ra : ffffffff80072134 sp : ffff=
ffc6000a3af0
> [=A0 =A0 5.766067]=A0 gp : ffffffff823a8a70 tp : ffffffd6808c1d80 t0 : 00=
00000000000000
> [=A0 =A0 5.766072]=A0 t1 : 0000000000000000 t2 : 0000000000000000 s0 : ff=
ffffc6000a3b30
> [=A0 =A0 5.766078]=A0 s1 : ffffffd9fed138c0 a0 : 0000000000577fff a1 : ff=
ffffd681175400
> [=A0 =A0 5.766084]=A0 a2 : 0000000000000000 a3 : 0000000000000177 a4 : 00=
00000000000000
> [=A0 =A0 5.766089]=A0 a5 : 0000000026fdb4a5 a6 : 0000000000000000 a7 : 00=
00000000000002
> [=A0 =A0 5.766095]=A0 s2 : 0000000000000000 s3 : ffffffd9fed137c0 s4 : ff=
ffffd682b1d880
> [=A0 =A0 5.766100]=A0 s5 : 0000000000000200 s6 : 0000000000000003 s7 : 00=
00000000000001
> [=A0 =A0 5.766106]=A0 s8 : ffffffd9fed138c0 s9 : 0000000000200b20 s10: ff=
ffffd681175400
> [=A0 =A0 5.766112]=A0 s11: 0000000000000000 t3 : 0000000000000000 t4 : 00=
00000000000000
> [=A0 =A0 5.766117]=A0 t5 : 0000000000000000 t6 : 0000000000000000
> [=A0 =A0 5.766121] status: 0000000200000100 badaddr: 0000000000000177 cau=
se: 0000000000000003
> [=A0 =A0 5.766130] [<ffffffff800721c8>] place_entity+0x130/0x138
> [=A0 =A0 5.766141] [<ffffffff80072780>] reweight_entity+0x178/0x1a0
> [=A0 =A0 5.766151] [<ffffffff8007285e>] update_cfs_group+0x76/0xa8
> [=A0 =A0 5.766161] [<ffffffff80073340>] dequeue_entities+0x120/0x550
> [=A0 =A0 5.766171] [<ffffffff800738c4>] pick_task_fair+0x84/0x108
> [=A0 =A0 5.766179] [<ffffffff8007b954>] pick_next_task_fair+0x1c/0x1b0
> [=A0 =A0 5.766192] [<ffffffff80e2fe72>] __schedule+0x172/0xc10
> [=A0 =A0 5.766204] [<ffffffff80e30932>] schedule+0x22/0x140
> [=A0 =A0 5.766212] [<ffffffff80e36df0>] schedule_timeout+0x80/0x180
> [=A0 =A0 5.766226] [<ffffffff800d3586>] rcu_gp_fqs_loop+0xfe/0x4d0
> [=A0 =A0 5.766243] [<ffffffff800d6a12>] rcu_gp_kthread+0x122/0x158
> [=A0 =A0 5.766255] [<ffffffff80050280>] kthread+0xc8/0xe8
> [=A0 =A0 5.766268] [<ffffffff80e39cce>] ret_from_fork+0xe/0x18
> [=A0 =A0 5.766282] ---[ end trace 0000000000000000 ]---
> [=A0 =A0 5.992429] usb 1-2: New USB device found, idVendor=3D174c, idProd=
uct=3D2074, bcdDevice=3D 0.01
> [=A0 =A0 5.999916] usb 1-2: New USB device strings: Mfr=3D2, Product=3D3,=
 SerialNumber=3D1
> [=A0 =A0 6.007028] usb 1-2: Product: AS2107

Similar warning on i.MX8MP

[    6.426039] ------------[ cut here ]------------
[    6.426058] WARNING: CPU: 0 PID: 1 at /kernel/sched/fair.c:5266 place_en=
tity+0x114/0x120
[    6.426082] Modules linked in: rfcomm uas ahci libahci libata nls_iso885=
9_1 bnep onboard_usb_dev nls_cp437 dwc3 snd_soc_hdmi_codec dw_hdmi_cec dw_h=
dmi_gp_audio imx8mp_interconnect spidev caam_jr caamhash_desc caamalg_desc =
crypto_engine rng_core authenc libdes crypto_null evdev aes_ce_blk aes_ce_c=
ipher ghash_ce gf128mul imx8mp_hdmi_tx snd_soc_imx_hdmi sha2_ce sha256_arm6=
4 sha1_ce hantro_vpu sha1_generic snd_soc_simple_card fsl_imx8_ddr_perf dw_=
hdmi snd_soc_simple_card_utils cec v4l2_vp9 mwifiex_sdio v4l2_h264 drm_disp=
lay_helper hci_uart phy_fsl_imx8mq_usb mwifiex phy_fsl_samsung_hdmi phy_fsl=
_imx8m_pcie imx8mp_hdmi_pvi snd_soc_fsl_sai snd_soc_fsl_utils bluetooth etn=
aviv governor_userspace imx_pcm_dma ecdh_generic gpu_sched dwc3_imx8mp cfg8=
0211 samsung_dsim snd_soc_fsl_aud2htx imx_bus ecc rfkill ti_ads1015 libaes =
industrialio_triggered_buffer kfifo_buf snd_soc_wm8904 ina2xx lm75 lontium_=
lt8912b imx_sdma spi_nxp_fspi caam error snvs_pwrkey nvmem_snvs_lpgpr flexc=
an usb_conn_gpio can_dev imx8mm_thermal spi_imx pwm_imx27
[    6.426327]  roles display_connector gpio_keys fuse ipv6 autofs4
[    6.426353] CPU: 0 UID: 0 PID: 1 Comm: systemd Not tainted 6.12.77-rc1-7=
=2E6.0-devel #1
[    6.426363] Hardware name: Toradex Verdin iMX8M Plus WB on Dahlia Board =
(DT)
[    6.426368] pstate: 200000c5 (nzCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[    6.426376] pc : place_entity+0x114/0x120
[    6.426387] lr : place_entity+0xf4/0x120
[    6.426395] sp : ffff80008003b9c0
[    6.426399] x29: ffff80008003b9c0 x28: 0000000000000001 x27: 00000000000=
00000
[    6.426412] x26: ffff67c13fb80180 x25: ffff67c0ce69e600 x24: 00000000000=
00001
[    6.426424] x23: 0000000000000000 x22: 0000000000000000 x21: 00000000000=
003ce
[    6.426436] x20: ffff67c13fb80180 x19: ffff67c0ce69e600 x18: 00000000000=
00001
[    6.426448] x17: 0000000000000000 x16: 0000000000000000 x15: 036d98d7916=
7f52c
[    6.426460] x14: 000000000000000c x13: 0000000000000001 x12: 00000000002=
00b20
[    6.426472] x11: 0000000000200b20 x10: fffffffffff0251c x9 : 00000000000=
00000
[    6.426484] x8 : 00000000000003ce x7 : ffff67c13fb80180 x6 : ffff67c0ce6=
9e600
[    6.426496] x5 : 00000000672c7516 x4 : 00000000ffffffe0 x3 : 00000000000=
00000
[    6.426508] x2 : 00000000000003ce x1 : 0000000000000000 x0 : 00000000002=
1b03a
[    6.426520] Call trace:
[    6.426525]  place_entity+0x114/0x120
[    6.426533]  reweight_entity+0x1d0/0x1f8
[    6.426542]  update_cfs_group+0x8c/0xac
[    6.426550]  enqueue_task_fair+0x27c/0x5d0
[    6.426559]  sched_move_task+0x130/0x1ec
[    6.426567]  cpu_cgroup_attach+0x40/0x80
[    6.426574]  cgroup_migrate_execute+0x368/0x428
[    6.426584]  cgroup_update_dfl_csses+0x230/0x26c
[    6.426594]  cgroup_subtree_control_write+0x3f4/0x454
[    6.426603]  cgroup_file_write+0xa4/0x1b0
[    6.426610]  kernfs_fop_write_iter+0x130/0x1dc
[    6.426621]  vfs_write+0x208/0x374
[    6.426629]  ksys_write+0x74/0x10c
[    6.426636]  __arm64_sys_write+0x1c/0x28
[    6.426643]  invoke_syscall.constprop.0+0x50/0xe4
[    6.426653]  do_el0_svc+0x40/0xc4
[    6.426661]  el0_svc+0x38/0x158
[    6.426669]  el0t_64_sync_handler+0x120/0x12c
[    6.426676]  el0t_64_sync+0x190/0x194
[    6.426684] ---[ end trace 0000000000000000 ]---

