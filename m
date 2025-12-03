Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9247393DC8
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 16:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780681; cv=none; b=WbqcDBCmUg4gdZhTe4rK66JqxkXVW4HJ8WgSZgdITj7p1OvlmgOkwoj4+woMC3B9xaBVNfhZnBS/iQPsiqOZ1kbF64TYz9NG+nIpXYbWr9/edXF1EBiFWaTzsoe0ZUgwUv6/sizLzrL29Hnmyc3cGxGLjs6U2zSgtAwN5QGx7qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780681; c=relaxed/simple;
	bh=a9mTbBU8fFQF69+2iVV6K2zAt9GDsUbdqAfEiQDyGaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oDYUGaTngfD/fYE8dQLiGrC2FQ+Dt1NEByFLKI5Dn7dICx4Y+0HDa/8DelQNJfM/iyvm2wZAQGKo1yfsQJSnQYq3PTmQTmUea+6CuSAiU1u/LluUqQQhqUxCORDXyTTYQbe5fZgt0V01H9MhTuS1a0jEn/gqi+77D2FFOVCN8Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=F5DIY7Ue; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="F5DIY7Ue"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 23F57101CB307;
	Wed,  3 Dec 2025 17:51:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1764780673; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=BhNfuxoVZYDFNbGm3BYuYMGVRm429SiaQWrCqokB8IM=;
	b=F5DIY7UeHWBkW9I4kaEguNZHe4+PiKZaTGJNGdhhGy55uiYagubk5gt6DkYBqUUk1si6Yn
	IK7cYB/E2ddpB9CqoeGdNPINKAEw4Fz78wHF7jvNQsFCiWcTr4sQ2MHsijdwmKCGM9VaNi
	KsHGm4LRALN/bkHNsgr3li0oQw/pvW47ctPhx7IiPSuC+XeQXkBP72dR8Y3GlLpy6jxhsl
	acmWvK8fu7MfUFnWjPasxJVLWKGksTUsV8jYbrMF/tJvC5l3fkNE9e1hp9QE7scx8wZE83
	vOUsrnWnwd5hRSQpqMRf6np1lDm9pihnVdlmtxTlnEzSChyoHN9+TGji+L/nRg==
Date: Wed, 3 Dec 2025 17:51:05 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/300] 5.10.247-rc1 review
Message-ID: <aTBqeSZ+E2bghkjW@duo.ucw.cz>
References: <20251203152400.447697997@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q1MpGQx/xgCsWvME"
Content-Disposition: inline
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--q1MpGQx/xgCsWvME
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.247 release.
> There are 300 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.24=
7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-5.10.y
> and the diffstat can be found below.

Something tagged 5.10.247-rc1 has compile problems in our testing.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2=
194166780

Gitlab says:

"Linux 5.10.247-rc1 (527f7b9e9a2b)

Retry
Failed
 Created 1 hour ago by cip-ci, finished 39 minutes ago"

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Best regards,
										Pavel


  CC      drivers/soc/tegra/regulators-tegra30.o
2663
drivers/soc/tegra/fuse/fuse-tegra30.c:250:3: error: 'const struct tegra_fus=
e_soc' has no member named 'cells'
2664
  250 |  .cells =3D tegra114_fuse_cells,
2665
      |   ^~~~~
2666
drivers/soc/tegra/fuse/fuse-tegra30.c:250:11: error: initialization of 'con=
st struct attribute_group *' from incompatible pointer type 'const struct n=
vmem_cell_info *' [-Werror=3Dincompatible-pointer-types]
2667
  250 |  .cells =3D tegra114_fuse_cells,
2668
      |           ^~~~~~~~~~~~~~~~~~~
2669
drivers/soc/tegra/fuse/fuse-tegra30.c:250:11: note: (near initialization fo=
r 'tegra114_fuse_soc.soc_attr_group')
2670
drivers/soc/tegra/fuse/fuse-tegra30.c:251:3: error: 'const struct tegra_fus=
e_soc' has no member named 'num_cells'
2671
  251 |  .num_cells =3D ARRAY_SIZE(tegra114_fuse_cells),
2672
      |   ^~~~~~~~~
2673
In file included from ./include/asm-generic/bug.h:20,
2674
                 from ./arch/arm/include/asm/bug.h:60,
2675
                 from ./include/linux/bug.h:5,
2676
                 from ./include/linux/thread_info.h:12,
2677
                 from ./include/asm-generic/current.h:5,
2678
                 from ./arch/arm/include/generated/asm/current.h:1,
2679
                 from ./include/linux/sched.h:12,
2680
                 from ./include/linux/ratelimit.h:6,
2681
                 from ./include/linux/dev_printk.h:16,
2682
                 from ./include/linux/device.h:15,
2683
                 from drivers/soc/tegra/fuse/fuse-tegra30.c:6:
2684
=2E/include/linux/kernel.h:49:25: warning: excess elements in struct initia=
lizer
2685
   49 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be=
_array(arr))
2686
      |                         ^
2687
drivers/soc/tegra/fuse/fuse-tegra30.c:251:15: note: in expansion of macro '=
ARRAY_SIZE'
2688
  251 |  .num_cells =3D ARRAY_SIZE(tegra114_fuse_cells),
2689
      |               ^~~~~~~~~~
2690
=2E/include/linux/kernel.h:49:25: note: (near initialization for 'tegra114_=
fuse_soc')
2691
   49 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be=
_array(arr))
2692
      |                         ^
2693
drivers/soc/tegra/fuse/fuse-tegra30.c:251:15: note: in expansion of macro '=
ARRAY_SIZE'
2694
  251 |  .num_cells =3D ARRAY_SIZE(tegra114_fuse_cells),
2695
      |               ^~~~~~~~~~
2696
cc1: some warnings being treated as errors
2697
make[4]: *** [scripts/Makefile.build:286: drivers/soc/tegra/fuse/fuse-tegra=
30.o] Error 1
2698
make[4]: *** Waiting for unfinished jobs....
2699
  CC      drivers/soc/renesas/rcar-sysc.o
 =20
>=20
> thanks,
>=20
> greg k-h
>=20
> -------------
> Pseudo-Shortlog of commits:
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.10.247-rc1
>=20
> Florian Westphal <fw@strlen.de>
>     netfilter: nf_set_pipapo_avx2: fix initial map fill
>=20
> Vasiliy Kovalev <kovalev@altlinux.org>
>     ovl: fix UAF in ovl_dentry_update_reval by moving dput() in ovl_link_=
up
>=20
> Owen Gu <guhuinan@xiaomi.com>
>     usb: uas: fix urb unmapping issue when the uas device is remove durin=
g ongoing data transfer
>=20
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>     usb: renesas_usbhs: Fix synchronous external abort on unbind
>=20
> Jameson Thies <jthies@google.com>
>     usb: typec: ucsi: psy: Set max current to zero when disconnected
>=20
> Paulo Alcantara <pc@manguebit.org>
>     smb: client: fix memory leak in cifs_construct_tcon()
>=20
> Jiayuan Chen <jiayuan.chen@linux.dev>
>     mptcp: Fix proto fallback detection with BPF
>=20
> Igor Pylypiv <ipylypiv@google.com>
>     scsi: pm80xx: Set phy->enable_completion only when we
>=20
> Florian Westphal <fw@strlen.de>
>     netfilter: nf_set_pipapo: fix initial map fill
>=20
> Alex Lu <alex_lu@realsil.com.cn>
>     Bluetooth: Add more enc key size check
>=20
> Jiufei Xue <jiufei.xue@samsung.com>
>     fs: writeback: fix use-after-free in __mark_inode_dirty()
>=20
> Ilya Dryomov <idryomov@gmail.com>
>     libceph: fix potential use-after-free in have_mon_and_osd_map()
>=20
> Alex Hung <alex.hung@amd.com>
>     drm/amd/display: Check NULL before accessing
>=20
> Johan Hovold <johan@kernel.org>
>     drm: sti: fix device leaks at component probe
>=20
> Vanillan Wang <vanillanwang@163.com>
>     USB: serial: option: add support for Rolling RW101R-GL
>=20
> Oleksandr Suvorov <cryosay@gmail.com>
>     USB: serial: ftdi_sio: add support for u-blox EVK-M101
>=20
> Mathias Nyman <mathias.nyman@linux.intel.com>
>     xhci: dbgtty: Fix data corruption when transmitting data form DbC to =
host
>=20
> Manish Nagar <manish.nagar@oss.qualcomm.com>
>     usb: dwc3: Fix race condition between concurrent dwc3_remove_requests=
() call paths
>=20
> Tianchu Chen <flynnnchen@tencent.com>
>     usb: storage: sddr55: Reject out-of-bound new_pba
>=20
> Alan Stern <stern@rowland.harvard.edu>
>     USB: storage: Remove subclass and protocol overrides from Novatek qui=
rk
>=20
> Desnes Nunes <desnesn@redhat.com>
>     usb: storage: Fix memory leak in USB bulk transport
>=20
> Kuen-Han Tsai <khtsai@google.com>
>     usb: gadget: f_eem: Fix memory leak in eem_unwrap
>=20
> Miaoqian Lin <linmq006@gmail.com>
>     usb: cdns3: Fix double resource release in cdns3_pci_probe
>=20
> Johan Hovold <johan@kernel.org>
>     most: usb: fix double free on late probe failure
>=20
> Miaoqian Lin <linmq006@gmail.com>
>     serial: amba-pl011: prefer dma_mapping_error() over explicit address =
checking
>=20
> Khairul Anuar Romli <khairul.anuar.romli@altera.com>
>     firmware: stratix10-svc: fix bug in saving controller data
>=20
> Miaoqian Lin <linmq006@gmail.com>
>     slimbus: ngd: Fix reference count leak in qcom_slim_ngd_notify_slaves
>=20
> Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
>     thunderbolt: Add support for Intel Wildcat Lake
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm-verity: fix unreliable memory allocation
>=20
> Marc Kleine-Budde <mkl@pengutronix.de>
>     can: sun4i_can: sun4i_can_interrupt(): fix max irq loop handling
>=20
> Thomas M=C3=BChlbacher <tmuehlbacher@posteo.net>
>     can: sja1000: fix max irq loop handling
>=20
> Gui-Dong Han <hanguidong02@gmail.com>
>     atm/fore200e: Fix possible data race in fore200e_open()
>=20
> Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>     MIPS: mm: kmalloc tlb_vpn array to avoid stack overflow
>=20
> Maciej W. Rozycki <macro@orcam.me.uk>
>     MIPS: mm: Prevent a TLB shutdown on initial uniquification
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     iio:common:ssp_sensors: Fix an error handling path ssp_probe()
>=20
> Francesco Lavra <flavra@baylibre.com>
>     iio: imu: st_lsm6dsx: fix array size for st_lsm6dsx_settings fields
>=20
> Jiri Olsa <jolsa@kernel.org>
>     Revert "perf/x86: Always store regs->ip in perf_callchain_kernel()"
>=20
> Hang Zhou <929513338@qq.com>
>     spi: bcm63xx: fix premature CS deassertion on RX-only transactions
>=20
> Haotian Zhang <vulab@iscas.ac.cn>
>     mailbox: mailbox-test: Fix debugfs_create_dir error checking
>=20
> Jiefeng Zhang <jiefeng.z.zhang@gmail.com>
>     net: atlantic: fix fragment overflow handling in RX path
>=20
> Alexey Kodanev <aleksei.kodanev@bell-sw.com>
>     net: sxgbe: fix potential NULL dereference in sxgbe_rx()
>=20
> Danielle Costantino <dcostantino@meta.com>
>     net/mlx5e: Fix validation logic in rate limiting
>=20
> Kai-Heng Feng <kaihengf@nvidia.com>
>     net: aquantia: Add missing descriptor cache invalidation on ATL2
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: SMP: Fix not generating mackey and ltk when repairing
>=20
> Seungjin Bae <eeodqql09@gmail.com>
>     can: kvaser_usb: leaf: Fix potential infinite loop in command parsers
>=20
> Seungjin Bae <eeodqql09@gmail.com>
>     Input: pegasus-notetaker - fix potential out-of-bounds access
>=20
> Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>     Input: remove third argument of usb_maxpacket()
>=20
> Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>     usb: deprecate the third argument of usb_maxpacket()
>=20
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: do not fallback when OoO is present
>=20
> Eric Dumazet <edumazet@google.com>
>     mptcp: fix a race in mptcp_pm_del_add_timer()
>=20
> Vlastimil Babka <vbabka@suse.cz>
>     mm/mempool: fix poisoning order>0 pages with HIGHMEM
>=20
> Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
>     mm/mempool: replace kmap_atomic() with kmap_local_page()
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>     dt-bindings: pinctrl: toshiba,visconti: Fix number of items in groups
>=20
> Eric Dumazet <edumazet@google.com>
>     mptcp: fix race condition in mptcp_schedule_work()
>=20
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: introduce mptcp_schedule_work
>=20
> Niklas Cassel <cassel@kernel.org>
>     ata: libata-scsi: Fix system suspend for a security locked drive
>=20
> Sudeep Holla <sudeep.holla@arm.com>
>     pmdomain: arm: scmi: Fix genpd leak on provider registration failure
>=20
> Miaoqian Lin <linmq006@gmail.com>
>     pmdomain: imx: Fix reference count leak in imx_gpc_remove
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Fix potential overflow of PCM transfer buffer
>=20
> Breno Leitao <leitao@debian.org>
>     net: netpoll: fix incorrect refcount handling causing incorrect clean=
up
>=20
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     Revert "NFS: Don't set NFS_INO_REVAL_PAGECACHE in the inode cache val=
idity"
>=20
> Nick Desaulniers <ndesaulniers@google.com>
>     Makefile.compiler: replace cc-ifversion with compiler-specific macros
>=20
> Nathan Chancellor <nathan@kernel.org>
>     net: qede: Initialize qede_ll_ops with designated initializer
>=20
> Long Li <longli@microsoft.com>
>     uio_hv_generic: Set event for all channels on the device
>=20
> Nishanth Menon <nm@ti.com>
>     net: ethernet: ti: netcp: Standardize knav_dma_open_channel to return=
 NULL on error
>=20
> Ren=C3=A9 Rebe <rene@exactco.de>
>     ALSA: usb-audio: fix uac2 clock source at terminal parser
>=20
> Isaac J. Manjarres <isaacmanjarres@google.com>
>     mm/mm_init: fix hash table order logging in alloc_large_system_hash()
>=20
> Jakub Hork=C3=BD <jakub.git@horky.net>
>     kconfig/nconf: Initialize the default locale at startup
>=20
> Jakub Hork=C3=BD <jakub.git@horky.net>
>     kconfig/mconf: Initialize the default locale at startup
>=20
> Shahar Shitrit <shshitrit@nvidia.com>
>     net: tls: Cancel RX async resync request on rcd_delta overflow
>=20
> Bart Van Assche <bvanassche@acm.org>
>     scsi: core: Fix a regression triggered by scsi_host_busy()
>=20
> Michal Luczaj <mhal@rbox.co>
>     vsock: Ignore signal/timeout on connect() if already established
>=20
> Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
>     s390/ctcm: Fix double-kfree
>=20
> Ilya Maximets <i.maximets@ovn.org>
>     net: openvswitch: remove never-working support for setting nsh fields
>=20
> Zilin Guan <zilin@seu.edu.cn>
>     mlxsw: spectrum: Fix memory leak in mlxsw_sp_flower_stats()
>=20
> Ma Ke <make24@iscas.ac.cn>
>     drm/tegra: dc: Fix reference leak in tegra_dc_couple()
>=20
> Maciej W. Rozycki <macro@orcam.me.uk>
>     MIPS: Malta: Fix !EVA SOC-it PCI MMIO
>=20
> Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
>     scsi: target: tcm_loop: Fix segfault in tcm_loop_tpg_address_show()
>=20
> Bart Van Assche <bvanassche@acm.org>
>     scsi: sg: Do not sleep in atomic context
>=20
> Ewan D. Milne <emilne@redhat.com>
>     nvme: nvme-fc: Ensure ->ioerr_work is cancelled in nvme_fc_delete_ctr=
l()
>=20
> Dan Carpenter <dan.carpenter@linaro.org>
>     Input: imx_sc_key - fix memory corruption on unload
>=20
> Tzung-Bi Shih <tzungbi@kernel.org>
>     Input: cros_ec_keyb - fix an invalid memory access
>=20
> Andrey Vatoropin <a.vatoropin@crpt.ru>
>     be2net: pass wrb_params in case of OS2BMC
>=20
> Yongpeng Yang <yangyongpeng@xiaomi.com>
>     exfat: check return value of sb_min_blocksize in exfat_read_boot_sect=
or
>=20
> Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
>     mtd: rawnand: cadence: fix DMA device NULL pointer dereference
>=20
> Zhang Heng <zhangheng@kylinos.cn>
>     HID: quirks: work around VID/PID conflict for 0x4c4a/0x4155
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     isdn: mISDN: hfcsusb: fix memory leak in hfcsusb_probe()
>=20
> Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
>     EDAC/altera: Use INTTEST register for Ethernet and USB SBE injection
>=20
> Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
>     EDAC/altera: Handle OCRAM ECC enable after warm reset
>=20
> Hans de Goede <hansg@kernel.org>
>     spi: Try to get ACPI GPIO IRQ earlier
>=20
> Wei Yang <albinwyang@tencent.com>
>     fs/proc: fix uaf in proc_readdir_de()
>=20
> Chuang Wang <nashuiliang@gmail.com>
>     ipv4: route: Prevent rt_bind_exception() from rebinding stale fnhe
>=20
> Nate Karstens <nate.karstens@garmin.com>
>     strparser: Fix signed/unsigned mismatch bug
>=20
> Peter Oberparleiter <oberpar@linux.ibm.com>
>     gcov: add support for GCC 15
>=20
> Olga Kornievskaia <okorniev@redhat.com>
>     NFSD: free copynotify stateid in nfs4_free_ol_stateid()
>=20
> Masami Ichikawa <masami256@gmail.com>
>     HID: hid-ntrig: Prevent memory leak in ntrig_report_version()
>=20
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nf_tables: reject duplicate device on updates
>=20
> Dan Carpenter <dan.carpenter@linaro.org>
>     mtd: onenand: Pass correct pointer to IRQ handler
>=20
> Eric Biggers <ebiggers@kernel.org>
>     lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
>=20
> Jakub Acs <acsjakub@amazon.de>
>     mm/ksm: fix flag-dropping behavior in ksm_madvise
>=20
> Christoph Hellwig <hch@lst.de>
>     fsdax: mark the iomap argument to dax_iomap_sector as const
>=20
> Haein Lee <lhi0729@kaist.ac.kr>
>     ALSA: usb-audio: Fix NULL pointer dereference in snd_usb_mixer_contro=
ls_badd
>=20
> Ian Forbes <ian.forbes@broadcom.com>
>     drm/vmwgfx: Validate command header size against SVGA_CMD_MAX_DATASIZE
>=20
> Haotian Zhang <vulab@iscas.ac.cn>
>     ASoC: cs4271: Fix regulator leak on probe failure
>=20
> Haotian Zhang <vulab@iscas.ac.cn>
>     regulator: fixed: fix GPIO descriptor leak on register failure
>=20
> Chris Morgan <macromorgan@hotmail.com>
>     regulator: fixed: use dev_err_probe for register
>=20
> Shuai Xue <xueshuai@linux.alibaba.com>
>     acpi,srat: Fix incorrect device handle check for Generic Initiator
>=20
> Pauli Virtanen <pav@iki.fi>
>     Bluetooth: L2CAP: export l2cap_chan_hold for modules
>=20
> Felix Maurer <fmaurer@redhat.com>
>     hsr: Fix supervision frame sending on HSRv0
>=20
> Eric Dumazet <edumazet@google.com>
>     net_sched: limit try_bulk_dequeue_skb() batches
>=20
> Gal Pressman <gal@nvidia.com>
>     net/mlx5e: Fix wraparound in rate limiting for values above 255 Gbps
>=20
> Gal Pressman <gal@nvidia.com>
>     net/mlx5e: Fix maxrate wraparound in threshold between units
>=20
> Ranganath V N <vnranganath.20@gmail.com>
>     net: sched: act_ife: initialize struct tc_ife to fix KMSAN kernel-inf=
oleak
>=20
> Benjamin Berg <benjamin.berg@intel.com>
>     wifi: mac80211: skip rate verification for not captured PSDUs
>=20
> Buday Csaba <buday.csaba@prolan.hu>
>     net: mdio: fix resource leak in mdiobus_register_device()
>=20
> Kuniyuki Iwashima <kuniyu@google.com>
>     tipc: Fix use-after-free in tipc_mon_reinit_self().
>=20
> D. Wythe <alibuda@linux.alibaba.com>
>     net/smc: fix mismatch between CLC header and proposal
>=20
> Eric Dumazet <edumazet@google.com>
>     sctp: prevent possible shift-out-of-bounds in sctp_transport_update_r=
to
>=20
> Pauli Virtanen <pav@iki.fi>
>     Bluetooth: 6lowpan: Don't hold spin lock over sleeping functions
>=20
> Pauli Virtanen <pav@iki.fi>
>     Bluetooth: 6lowpan: fix BDADDR_LE vs ADDR_LE_DEV address type confusi=
on
>=20
> Pauli Virtanen <pav@iki.fi>
>     Bluetooth: 6lowpan: reset link-local header on ipv6 recv path
>=20
> Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
>     Bluetooth: btusb: reorder cleanup in btusb_disconnect to avoid UAF
>=20
> Wei Fang <wei.fang@nxp.com>
>     net: fec: correct rx_bytes statistic for the case SHIFT16 is set
>=20
> Sharique Mohammad <sharq0406@gmail.com>
>     ASoC: max98090/91: fixed max98091 ALSA widget powering up/down
>=20
> Tristan Lobb <tristan.lobb@it-lobb.de>
>     HID: quirks: avoid Cooler Master MM712 dongle wakeup bug
>=20
> Joshua Watt <jpewhacker@gmail.com>
>     NFS4: Fix state renewals missing after boot
>=20
> Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>
>     RISC-V: clear hot-unplugged cores from all task mm_cpumasks to avoid =
rfence errors
>=20
> Peter Zijlstra <peterz@infradead.org>
>     compiler_types: Move unused static inline functions warning to W=3D2
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>     extcon: adc-jack: Cleanup wakeup source only if it was enabled
>=20
> Nathan Chancellor <nathan@kernel.org>
>     lib/crypto: curve25519-hacl64: Fix older clang KASAN workaround for G=
CC
>=20
> Zilin Guan <zilin@seu.edu.cn>
>     tracing: Fix memory leaks in create_field_var()
>=20
> Qendrim Maxhuni <qendrim.maxhuni@garderos.com>
>     net: usb: qmi_wwan: initialize MAC header offset in qmimux_rx_fixup
>=20
> Stefan Wiehler <stefan.wiehler@nokia.com>
>     sctp: Hold sock lock while iterating over address list
>=20
> Xin Long <lucien.xin@gmail.com>
>     sctp: hold endpoint before calling cb in sctp_transport_lookup_process
>=20
> Yajun Deng <yajun.deng@linux.dev>
>     net: Use nlmsg_unicast() instead of netlink_unicast()
>=20
> Lu Wei <luwei32@huawei.com>
>     net: sctp: Fix some typos
>=20
> Stefan Wiehler <stefan.wiehler@nokia.com>
>     sctp: Prevent TOCTOU out-of-bounds write
>=20
> Stefan Wiehler <stefan.wiehler@nokia.com>
>     sctp: Hold RCU read lock while iterating over address list
>=20
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: stop reading ARL entries if search is done
>=20
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: fix enabling ip multicast
>=20
> Jonas Gorski <jonas.gorski@gmail.com>
>     net: dsa: b53: fix resetting speed and pause on forced link
>=20
> Hangbin Liu <liuhangbin@gmail.com>
>     net: vlan: sync VLAN features with lower device
>=20
> Josephine Pfeiffer <hi@josie.lol>
>     riscv: ptdump: use seq_puts() in pt_dump_seq_puts() macro
>=20
> Kailang Yang <kailang@realtek.com>
>     ALSA: hda/realtek: Audio disappears on HP 15-fc000 after warm boot ag=
ain
>=20
> Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>     ceph: add checking of wait_for_completion_killable() return value
>=20
> Valerio Setti <vsetti@baylibre.com>
>     ASoC: meson: aiu-encoder-i2s: fix bit clock polarity
>=20
> Albin Babu Varghese <albinbabuvarghese20@gmail.com>
>     fbdev: Add bounds checking in bit_putcs to fix vmalloc-out-of-bounds
>=20
> Ian Rogers <irogers@google.com>
>     tools bitmap: Add missing asm-generic/bitsperlong.h include
>=20
> Sakari Ailus <sakari.ailus@linux.intel.com>
>     ACPI: property: Return present device nodes only on fwnode interface
>=20
> Randall P. Embry <rpembry@gmail.com>
>     9p: sysfs_init: don't hardcode error to ENOMEM
>=20
> Randall P. Embry <rpembry@gmail.com>
>     9p: fix /sys/fs/9p/caches overwriting itself
>=20
> Nicolas Ferre <nicolas.ferre@microchip.com>
>     ARM: at91: pm: save and restore ACR during PLL disable/enable
>=20
> Tiwei Bie <tiwei.btw@antgroup.com>
>     um: Fix help message for ssl-non-raw
>=20
> Yikang Yue <yikangy2@illinois.edu>
>     fs/hpfs: Fix error code for new_inode() failure in mkdir/create/mknod=
/symlink
>=20
> austinchang <austinchang@synology.com>
>     btrfs: mark dirty extent range for out of bound prealloc extents
>=20
> Saket Dumbre <saket.dumbre@intel.com>
>     ACPICA: Update dsmethod.c to get rid of unused variable warning
>=20
> Mike Marshall <hubcap@omnibond.com>
>     orangefs: fix xattr related buffer overflow...
>=20
> Dragos Tatulea <dtatulea@nvidia.com>
>     page_pool: Clamp pool size to max 16K pages
>=20
> Chi Zhiling <chizhiling@kylinos.cn>
>     exfat: limit log print for IO error
>=20
> Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
>     ALSA: usb-audio: add mono main switch to Presonus S1824c
>=20
> Ivan Pravdin <ipravdin.official@gmail.com>
>     Bluetooth: bcsp: receive data only if registered
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: SCO: Fix UAF on sco_conn_free
>=20
> Th=C3=A9o Lebrun <theo.lebrun@bootlin.com>
>     net: macb: avoid dealing with endianness in macb_set_hwaddr()
>=20
> chuguangqing <chuguangqing@inspur.com>
>     fs: ext4: change GFP_KERNEL to GFP_NOFS to avoid deadlock
>=20
> Al Viro <viro@zeniv.linux.org.uk>
>     nfs4_setup_readdir(): insufficient locking for ->d_parent->d_inode de=
referencing
>=20
> Anthony Iliopoulos <ailiop@suse.com>
>     NFSv4.1: fix mount hang after CREATE_SESSION failure
>=20
> Olga Kornievskaia <okorniev@redhat.com>
>     NFSv4: handle ERR_GRACE on delegation recalls
>=20
> Stephan Gerhold <stephan.gerhold@linaro.org>
>     remoteproc: qcom: q6v5: Avoid handling handover twice
>=20
> Koakuma <koachan@protonmail.com>
>     sparc/module: Add R_SPARC_UA64 relocation handling
>=20
> Chen Wang <unicorn_wang@outlook.com>
>     PCI: cadence: Check for the existence of cdns_pcie::ops before using =
it
>=20
> ChunHao Lin <hau@realtek.com>
>     r8169: set EEE speed down ratio to 1
>=20
> Brahmajit Das <listout@listout.xyz>
>     net: intel: fm10k: Fix parameter idx set but not used
>=20
> Loic Poulain <loic.poulain@oss.qualcomm.com>
>     wifi: ath10k: Fix connection after GTK rekeying
>=20
> Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
>     jfs: fix uninitialized waitqueue in transaction manager
>=20
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>     jfs: Verify inode mode when loading from disk
>=20
> Eric Dumazet <edumazet@google.com>
>     ipv6: np->rxpmtu race annotation
>=20
> Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
>     usb: xhci: plat: Facilitate using autosuspend for xhci plat devices
>=20
> Forest Crossman <cyrozap@gmail.com>
>     usb: mon: Increase BUFF_MAX to 64 MiB to support multi-MB URBs
>=20
> Al Viro <viro@zeniv.linux.org.uk>
>     allow finish_no_open(file, ERR_PTR(-E...))
>=20
> Justin Tee <justin.tee@broadcom.com>
>     scsi: lpfc: Define size of debugfs entry for xri rebalancing
>=20
> Nai-Chen Cheng <bleach1827@gmail.com>
>     selftests/Makefile: include $(INSTALL_DEP_TARGETS) in clean target to=
 clean net/lib dependency
>=20
> Yafang Shao <laoar.shao@gmail.com>
>     net/cls_cgroup: Fix task_get_classid() during qdisc run
>=20
> Alok Tiwari <alok.a.tiwari@oracle.com>
>     udp_tunnel: use netdev_warn() instead of netdev_WARN()
>=20
> David Ahern <dsahern@kernel.org>
>     selftests: Replace sleep with slowwait
>=20
> Daniel Palmer <daniel@thingy.jp>
>     eth: 8139too: Make 8139TOO_PIO depend on !NO_IOPORT_MAP
>=20
> David Ahern <dsahern@kernel.org>
>     selftests: Disable dad for ipv6 in fcnal-test.sh
>=20
> Li RongQing <lirongqing@baidu.com>
>     x86/kvm: Prefer native qspinlock for dedicated vCPUs irrespective of =
PV_UNHALT
>=20
> Ido Schimmel <idosch@nvidia.com>
>     selftests: traceroute: Use require_command()
>=20
> Qianfeng Rong <rongqianfeng@vivo.com>
>     media: redrat3: use int type to store negative error codes
>=20
> Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>
>     net: sh_eth: Disable WoL if system can not suspend
>=20
> Harikrishna Shenoy <h-shenoy@ti.com>
>     phy: cadence: cdns-dphy: Enable lower resolutions in dphy
>=20
> Rohan G Thomas <rohan.g.thomas@altera.com>
>     net: phy: marvell: Fix 88e1510 downshift counter errata
>=20
> William Wu <william.wu@rock-chips.com>
>     usb: gadget: f_hid: Fix zero length packet transfer
>=20
> Ashish Kalra <ashish.kalra@amd.com>
>     iommu/amd: Skip enabling command/event buffers for kdump
>=20
> Eric Dumazet <edumazet@google.com>
>     net: call cond_resched() less often in __release_sock()
>=20
> Cryolitia PukNgae <cryolitia@uniontech.com>
>     ALSA: usb-audio: apply quirk for MOONDROP Quark2
>=20
> Juraj =C5=A0arinay <juraj@sarinay.com>
>     net: nfc: nci: Increase NCI_DATA_TIMEOUT to 3000 ms
>=20
> Yue Haibing <yuehaibing@huawei.com>
>     ipv6: Add sanity checks on ipv6_devconf.rpl_seg_enabled
>=20
> Devendra K Verma <devverma@amd.com>
>     dmaengine: dw-edma: Set status for callback_result
>=20
> Rosen Penev <rosenp@gmail.com>
>     dmaengine: mv_xor: match alloc_wc and free_wc
>=20
> Thomas Andreatta <thomasandreatta2000@gmail.com>
>     dmaengine: sh: setup_xref error handling
>=20
> Qianfeng Rong <rongqianfeng@vivo.com>
>     scsi: pm8001: Use int instead of u32 to store error codes
>=20
> Aleksander Jan Bajkowski <olek2@wp.pl>
>     mips: lantiq: xway: sysctrl: rename stp clock
>=20
> Aleksander Jan Bajkowski <olek2@wp.pl>
>     mips: lantiq: danube: add missing device_type in pci node
>=20
> Aleksander Jan Bajkowski <olek2@wp.pl>
>     mips: lantiq: danube: add missing properties to cpu node
>=20
> Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
>     media: fix uninitialized symbol warnings
>=20
> Amber Lin <Amber.Lin@amd.com>
>     drm/amdkfd: Tie UNMAP_LATENCY to queue_preemption
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>     extcon: adc-jack: Fix wakeup source leaks on device unbind
>=20
> Francisco Gutierrez <frankramirez@google.com>
>     scsi: pm80xx: Fix race condition caused by static variables
>=20
> Ujwal Kundur <ujwal.kundur@gmail.com>
>     rds: Fix endianness annotation for RDS_MPATH_HASH
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Add validation of UAC2/UAC3 effect units
>=20
> Sungho Kim <sungho.kim@furiosa.ai>
>     PCI/P2PDMA: Fix incorrect pointer usage in devm_kfree() call
>=20
> Kuniyuki Iwashima <kuniyu@google.com>
>     net: Call trace_sock_exceed_buf_limit() for memcg failure with SK_MEM=
_RECV.
>=20
> Christoph Paasch <cpaasch@openai.com>
>     net: When removing nexthops, don't call synchronize_net if it is not =
necessary
>=20
> Zijun Hu <zijun.hu@oss.qualcomm.com>
>     char: misc: Does not request module for miscdevice with dynamic minor
>=20
> raub camaioni <raubcameo@gmail.com>
>     usb: gadget: f_ncm: Fix MAC assignment NCM ethernet
>=20
> Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
>     iio: adc: spear_adc: mask SPEAR_ADC_STATUS channel and avg sample bef=
ore setting register
>=20
> Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
>     drm/bridge: display-connector: don't set OP_DETECT for DisplayPorts
>=20
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>     media: imon: make send_packet() more robust
>=20
> Charalampos Mitrodimas <charmitro@posteo.net>
>     net: ipv6: fix field-spanning memcpy warning in AH output
>=20
> Ido Schimmel <idosch@nvidia.com>
>     bridge: Redirect to backup port when port is administratively down
>=20
> Niklas Schnelle <schnelle@linux.ibm.com>
>     powerpc/eeh: Use result of error_detected() in uevent
>=20
> Tiezhu Yang <yangtiezhu@loongson.cn>
>     net: stmmac: Check stmmac_hw_setup() in stmmac_resume()
>=20
> Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>     x86/vsyscall: Do not require X86_PF_INSTR to emulate vsyscall
>=20
> Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
>     drm/tidss: Use the crtc_* timings when programming the HW
>=20
> Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>     media: pci: ivtv: Don't create fake v4l2_fh
>=20
> Geoffrey McRae <geoffrey.mcrae@amd.com>
>     drm/amdkfd: return -ENOTTY for unsupported IOCTLs
>=20
> Wake Liu <wakel@google.com>
>     selftests/net: Ensure assert() triggers in psock_tpacket.c
>=20
> Wake Liu <wakel@google.com>
>     selftests/net: Replace non-standard __WORDSIZE with sizeof(long) * 8
>=20
> Marcos Del Sol Vives <marcos@orca.pet>
>     PCI: Disable MSI on RDC PCI to PCIe bridges
>=20
> Seyediman Seyedarab <imandevel@gmail.com>
>     drm/nouveau: replace snprintf() with scnprintf() in nvkm_snprintbf()
>=20
> Sathishkumar S <sathishkumar.sundararaju@amd.com>
>     drm/amdgpu/jpeg: Hold pg_lock before jpeg poweroff
>=20
> Lijo Lazar <lijo.lazar@amd.com>
>     drm/amd/pm: Use cached metrics data on arcturus
>=20
> Jens Kehne <jens.kehne@agilent.com>
>     mfd: da9063: Split chip variant reading in two bus transactions
>=20
> Arnd Bergmann <arnd@arndb.de>
>     mfd: madera: Work around false-positive -Wininitialized warning
>=20
> Alexander Stein <alexander.stein@ew.tq-group.com>
>     mfd: stmpe-i2c: Add missing MODULE_LICENSE
>=20
> Alexander Stein <alexander.stein@ew.tq-group.com>
>     mfd: stmpe: Remove IRQ domain upon removal
>=20
> Len Brown <len.brown@intel.com>
>     tools/power x86_energy_perf_policy: Prefer driver HWP limits
>=20
> Len Brown <len.brown@intel.com>
>     tools/power x86_energy_perf_policy: Enhance HWP enable
>=20
> Kaushlendra Kumar <kaushlendra.kumar@intel.com>
>     tools/power x86_energy_perf_policy: Fix incorrect fopen mode usage
>=20
> Kaushlendra Kumar <kaushlendra.kumar@intel.com>
>     tools/cpupower: Fix incorrect size in cpuidle_state_disable()
>=20
> Armin Wolf <W_Armin@gmx.de>
>     hwmon: (dell-smm) Add support for Dell OptiPlex 7040
>=20
> Jiri Olsa <jolsa@kernel.org>
>     uprobe: Do not emulate/sstep original instruction when ip is changed
>=20
> Daniel Lezcano <daniel.lezcano@linaro.org>
>     clocksource/drivers/vf-pit: Replace raw_readl/writel to readl/writel
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     cpuidle: Fail cpuidle device registration if there is one already
>=20
> Svyatoslav Ryhel <clamor95@gmail.com>
>     video: backlight: lp855x_bl: Set correct EPROM start for LP8556
>=20
> Daniel Wagner <wagi@kernel.org>
>     nvme-fc: use lock accessing port_state and rport state
>=20
> Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>
>     tee: allow a driver to allocate a tee_device without a pool
>=20
> Hans de Goede <hansg@kernel.org>
>     ACPICA: dispatcher: Use acpi_ds_clear_operands() in acpi_ds_call_cont=
rol_method()
>=20
> Sarthak Garg <quic_sartgarg@quicinc.com>
>     mmc: sdhci-msm: Enable tuning for SDR50 mode for SD card
>=20
> Svyatoslav Ryhel <clamor95@gmail.com>
>     soc/tegra: fuse: Add Tegra114 nvmem cells and fuse lookups
>=20
> Christian Bruel <christian.bruel@foss.st.com>
>     irqchip/gic-v2m: Handle Multiple MSI base IRQ Alignment
>=20
> Kees Cook <kees@kernel.org>
>     arc: Fix __fls() const-foldability via __builtin_clzl()
>=20
> Dennis Beier <nanovim@gmail.com>
>     cpufreq/longhaul: handle NULL policy in longhaul_exit
>=20
> Ricardo B. Marli=C3=A8re <rbm@suse.com>
>     selftests/bpf: Fix bpf_prog_detach2 usage in test_lirc_mode2
>=20
> Mario Limonciello (AMD) <superm1@kernel.org>
>     ACPI: video: force native for Lenovo 82K8
>=20
> Jiayi Li <lijiayi@kylinos.cn>
>     memstick: Add timeout to prevent indefinite waiting
>=20
> Biju Das <biju.das.jz@bp.renesas.com>
>     mmc: host: renesas_sdhi: Fix the actual clock
>=20
> Chi Zhang <chizhang@asrmicro.com>
>     pinctrl: single: fix bias pull up/down handling in pin_config_set
>=20
> Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
>     bpf: Don't use %pK through printk
>=20
> Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
>     soc: ti: pruss: don't use %pK through printk
>=20
> Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
>     spi: loopback-test: Don't use %pK through printk
>=20
> Jens Reidel <adrian@mainlining.org>
>     soc: qcom: smem: Fix endian-unaware access of num_entries
>=20
> Damien Le Moal <dlemoal@kernel.org>
>     block: make REQ_OP_ZONE_OPEN a write operation
>=20
> Owen Gu <guhuinan@xiaomi.com>
>     usb: gadget: f_fs: Fix epfile null pointer access after ep enable.
>=20
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     tracing: fix declaration-after-statement warning
>=20
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     arch: back to -std=3Dgnu89 in < v5.18
>=20
> Alexey Dobriyan <adobriyan@gmail.com>
>     x86/boot: Compile boot code with -std=3Dgnu11 too
>=20
> Babu Moger <babu.moger@amd.com>
>     x86/resctrl: Fix miscount of bandwidth event when reactivating previo=
usly unavailable RMID
>=20
> Artem Shimko <a.shimko.dev@gmail.com>
>     serial: 8250_dw: handle reset control deassert error
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     serial: 8250_dw: Use devm_add_action_or_reset()
>=20
> Celeste Liu <uwu@coelacanthus.name>
>     can: gs_usb: increase max interface to U8_MAX
>=20
> Maarten Lankhorst <dev@lankhorst.se>
>     devcoredump: Fix circular locking dependency with devcd->mutex.
>=20
> Darrick J. Wong <djwong@kernel.org>
>     xfs: always warn about deprecated mount options
>=20
> Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>     net: ravb: Enforce descriptor type ordering
>=20
> Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
>     net: phy: dp83867: Disable EEE support as not implemented
>=20
> Alexey Klimov <alexey.klimov@linaro.org>
>     regmap: slimbus: fix bus_context pointer in regmap init calls
>=20
> Damien Le Moal <dlemoal@kernel.org>
>     block: fix op_is_zone_mgmt() to handle REQ_OP_ZONE_RESET_ALL
>=20
> John Smith <itistotalbotnet@gmail.com>
>     drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Iceland
>=20
> John Smith <itistotalbotnet@gmail.com>
>     drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Fiji
>=20
> Yang Wang <kevinyang.wang@amd.com>
>     drm/amd/pm: fix smu table id bound check issue in smu_cmn_update_tabl=
e()
>=20
> Tomeu Vizoso <tomeu@tomeuvizoso.net>
>     drm/etnaviv: fix flush sequence logic
>=20
> Lizhi Xu <lizhi.xu@windriver.com>
>     usbnet: Prevents free active kevent
>=20
> Noorain Eqbal <nooraineqbal@gmail.com>
>     bpf: Sync pending IRQ work before freeing ring buffer
>=20
> Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
>     ALSA: usb-audio: fix control pipe direction
>=20
> Akhil P Oommen <akhilpo@oss.qualcomm.com>
>     drm/msm/a6xx: Fix GMU firmware parser
>=20
> Loic Poulain <loic.poulain@oss.qualcomm.com>
>     wifi: ath10k: Fix memory leak on unsupported WMI command
>=20
> Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
>     ASoC: qdsp6: q6asm: do not sleep while atomic
>=20
> Miaoqian Lin <linmq006@gmail.com>
>     fbdev: valkyriefb: Fix reference count leak in valkyriefb_init
>=20
> Florian Fuchs <fuchsfl@gmail.com>
>     fbdev: pvr2fb: Fix leftover reference to ONCHIP_NR_DMA_CHANNELS
>=20
> Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
>     wifi: brcmfmac: fix crash while sending Action Frames in standalone A=
P Mode
>=20
> Junjie Cao <junjie.cao@intel.com>
>     fbdev: bitblit: bound-check glyph index in bit_putcs*
>=20
> Yuhao Jiang <danisjiang@gmail.com>
>     ACPI: video: Fix use-after-free in acpi_video_switch_brightness()
>=20
> Daniel Palmer <daniel@0x0f.com>
>     fbdev: atyfb: Check if pll_ops->init_pll failed
>=20
> Miaoqian Lin <linmq006@gmail.com>
>     net: usb: asix_devices: Check return value of usbnet_get_endpoints
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     NFSD: Fix crash in nfsd4_read_release()
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: use smp_mb__after_atomic() when forcing COW in create_pending_=
snapshot()
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: always drop log root tree reference in btrfs_replay_log()
>=20
> David Kaplan <david.kaplan@amd.com>
>     x86/bugs: Fix reporting of LFENCE retpoline
>=20
> Xiang Mei <xmei5@asu.edu>
>     net/sched: sch_qfq: Fix null-deref in agg_dequeue
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  .../bindings/pinctrl/toshiba,visconti-pinctrl.yaml |  26 ++--
>  Documentation/kbuild/makefiles.rst                 |  29 +++--
>  Makefile                                           |   8 +-
>  arch/arc/include/asm/bitops.h                      |   2 +
>  arch/arm/crypto/Kconfig                            |   2 +-
>  arch/arm/mach-at91/pm_suspend.S                    |   8 +-
>  arch/mips/boot/dts/lantiq/danube.dtsi              |   6 +
>  arch/mips/lantiq/xway/sysctrl.c                    |   2 +-
>  arch/mips/loongson64/Platform                      |   2 +-
>  arch/mips/mm/tlb-r4k.c                             | 118 ++++++++++++---=
---
>  arch/mips/mti-malta/malta-init.c                   |  20 +--
>  arch/parisc/boot/compressed/Makefile               |   2 +-
>  arch/powerpc/Makefile                              |   4 +-
>  arch/powerpc/kernel/eeh_driver.c                   |   2 +-
>  arch/riscv/kernel/cpu-hotplug.c                    |   1 +
>  arch/riscv/mm/ptdump.c                             |   2 +-
>  arch/s390/Makefile                                 |   6 +-
>  arch/s390/purgatory/Makefile                       |   2 +-
>  arch/sparc/include/asm/elf_64.h                    |   1 +
>  arch/sparc/kernel/module.c                         |   1 +
>  arch/um/drivers/ssl.c                              |   5 +-
>  arch/x86/Makefile                                  |   2 +-
>  arch/x86/boot/compressed/Makefile                  |   2 +-
>  arch/x86/entry/vsyscall/vsyscall_64.c              |  17 ++-
>  arch/x86/events/core.c                             |  10 +-
>  arch/x86/kernel/cpu/bugs.c                         |   5 +-
>  arch/x86/kernel/cpu/resctrl/monitor.c              |  10 +-
>  arch/x86/kernel/kvm.c                              |  20 +--
>  drivers/acpi/acpi_video.c                          |   4 +-
>  drivers/acpi/acpica/dsmethod.c                     |  10 +-
>  drivers/acpi/numa/srat.c                           |   2 +-
>  drivers/acpi/property.c                            |  24 +++-
>  drivers/acpi/video_detect.c                        |   8 ++
>  drivers/ata/libata-scsi.c                          |   8 ++
>  drivers/atm/fore200e.c                             |   2 +
>  drivers/base/devcoredump.c                         | 138 +++++++++++++--=
------
>  drivers/base/regmap/regmap-slimbus.c               |   6 +-
>  drivers/bluetooth/btusb.c                          |  13 +-
>  drivers/bluetooth/hci_bcsp.c                       |   3 +
>  drivers/char/misc.c                                |   8 +-
>  drivers/clocksource/timer-vf-pit.c                 |  22 ++--
>  drivers/cpufreq/longhaul.c                         |   3 +
>  drivers/cpuidle/cpuidle.c                          |   8 +-
>  drivers/dma/dw-edma/dw-edma-core.c                 |  22 ++++
>  drivers/dma/mv_xor.c                               |   4 +-
>  drivers/dma/sh/shdma-base.c                        |  25 +++-
>  drivers/dma/sh/shdmac.c                            |  17 ++-
>  drivers/edac/altera_edac.c                         |  22 +++-
>  drivers/extcon/extcon-adc-jack.c                   |   2 +
>  drivers/firmware/arm_scmi/scmi_pm_domain.c         |  13 +-
>  drivers/firmware/efi/libstub/Makefile              |   2 +-
>  drivers/firmware/stratix10-svc.c                   |   7 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c           |   6 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   8 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   9 +-
>  drivers/gpu/drm/amd/display/dc/calcs/Makefile      |   2 +-
>  drivers/gpu/drm/amd/display/dc/core/dc_stream.c    |  11 +-
>  drivers/gpu/drm/amd/display/dc/dcn20/Makefile      |   2 +-
>  drivers/gpu/drm/amd/display/dc/dcn21/Makefile      |   2 +-
>  drivers/gpu/drm/amd/display/dc/dcn30/Makefile      |   2 +-
>  drivers/gpu/drm/amd/display/dc/dml/Makefile        |   2 +-
>  drivers/gpu/drm/amd/display/dc/dsc/Makefile        |   2 +-
>  .../gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c  |   2 +-
>  .../drm/amd/pm/powerplay/smumgr/iceland_smumgr.c   |   2 +-
>  drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |   2 +-
>  drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c             |   2 +-
>  drivers/gpu/drm/bridge/display-connector.c         |   3 +-
>  drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |   2 +-
>  drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   5 +-
>  drivers/gpu/drm/nouveau/nvkm/core/enum.c           |   2 +-
>  drivers/gpu/drm/sti/sti_vtg.c                      |   7 +-
>  drivers/gpu/drm/tegra/dc.c                         |   1 +
>  drivers/gpu/drm/tidss/tidss_crtc.c                 |   2 +-
>  drivers/gpu/drm/tidss/tidss_dispc.c                |  16 +--
>  drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   5 +
>  drivers/hid/hid-ids.h                              |   7 +-
>  drivers/hid/hid-ntrig.c                            |   7 +-
>  drivers/hid/hid-quirks.c                           |  14 ++-
>  drivers/hwmon/dell-smm-hwmon.c                     |   7 ++
>  drivers/iio/adc/spear_adc.c                        |   9 +-
>  drivers/iio/common/ssp_sensors/ssp_dev.c           |   4 +-
>  drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h            |  22 ++--
>  drivers/input/keyboard/cros_ec_keyb.c              |   6 +
>  drivers/input/keyboard/imx_sc_key.c                |   2 +-
>  drivers/input/misc/ati_remote2.c                   |   2 +-
>  drivers/input/misc/cm109.c                         |   2 +-
>  drivers/input/misc/powermate.c                     |   2 +-
>  drivers/input/misc/yealink.c                       |   2 +-
>  drivers/input/tablet/acecad.c                      |   2 +-
>  drivers/input/tablet/pegasus_notetaker.c           |  11 +-
>  drivers/iommu/amd/init.c                           |  28 +++--
>  drivers/irqchip/irq-gic-v2m.c                      |  13 +-
>  drivers/isdn/hardware/mISDN/hfcsusb.c              |  18 ++-
>  drivers/mailbox/mailbox-test.c                     |   2 +-
>  drivers/md/dm-verity-fec.c                         |   6 +-
>  drivers/media/i2c/ir-kbd-i2c.c                     |   6 +-
>  drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |   2 -
>  drivers/media/pci/ivtv/ivtv-driver.h               |   3 +-
>  drivers/media/pci/ivtv/ivtv-fileops.c              |  18 +--
>  drivers/media/pci/ivtv/ivtv-irq.c                  |   4 +-
>  drivers/media/rc/imon.c                            |  61 +++++----
>  drivers/media/rc/redrat3.c                         |   2 +-
>  drivers/media/tuners/xc4000.c                      |   8 +-
>  drivers/media/tuners/xc5000.c                      |  12 +-
>  drivers/memstick/core/memstick.c                   |   8 +-
>  drivers/mfd/da9063-i2c.c                           |  27 +++-
>  drivers/mfd/madera-core.c                          |   4 +-
>  drivers/mfd/stmpe-i2c.c                            |   1 +
>  drivers/mfd/stmpe.c                                |   3 +
>  drivers/mmc/host/renesas_sdhi_core.c               |   6 +-
>  drivers/mmc/host/sdhci-msm.c                       |  15 +++
>  drivers/most/most_usb.c                            |  14 +--
>  drivers/mtd/nand/onenand/onenand_samsung.c         |   2 +-
>  drivers/mtd/nand/raw/cadence-nand-controller.c     |   3 +-
>  drivers/net/can/sja1000/sja1000.c                  |   4 +-
>  drivers/net/can/sun4i_can.c                        |   4 +-
>  drivers/net/can/usb/gs_usb.c                       |  23 ++--
>  drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |   4 +-
>  drivers/net/dsa/b53/b53_common.c                   |  15 ++-
>  drivers/net/dsa/b53/b53_regs.h                     |   3 +-
>  .../net/ethernet/aquantia/atlantic/aq_hw_utils.c   |  22 ++++
>  .../net/ethernet/aquantia/atlantic/aq_hw_utils.h   |   1 +
>  drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |   5 +
>  .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |  19 +--
>  .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c   |   2 +-
>  drivers/net/ethernet/cadence/macb_main.c           |   4 +-
>  drivers/net/ethernet/emulex/benet/be_main.c        |   7 +-
>  drivers/net/ethernet/freescale/fec_main.c          |   2 +
>  drivers/net/ethernet/intel/fm10k/fm10k_common.c    |   5 +-
>  drivers/net/ethernet/intel/fm10k/fm10k_common.h    |   2 +-
>  drivers/net/ethernet/intel/fm10k/fm10k_pf.c        |   2 +-
>  drivers/net/ethernet/intel/fm10k/fm10k_vf.c        |   2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  15 ++-
>  .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |   6 +-
>  drivers/net/ethernet/qlogic/qede/qede_main.c       |   2 +-
>  drivers/net/ethernet/realtek/Kconfig               |   2 +-
>  drivers/net/ethernet/realtek/r8169_main.c          |   6 +-
>  drivers/net/ethernet/renesas/ravb_main.c           |  16 ++-
>  drivers/net/ethernet/renesas/sh_eth.c              |   4 +
>  drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |   4 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   9 +-
>  drivers/net/ethernet/ti/netcp_core.c               |  10 +-
>  drivers/net/phy/dp83867.c                          |   6 +
>  drivers/net/phy/marvell.c                          |  39 +++++-
>  drivers/net/phy/mdio_bus.c                         |   5 +-
>  drivers/net/usb/asix_devices.c                     |  12 +-
>  drivers/net/usb/qmi_wwan.c                         |   6 +
>  drivers/net/usb/usbnet.c                           |   2 +
>  drivers/net/wireless/ath/ath10k/mac.c              |  12 +-
>  drivers/net/wireless/ath/ath10k/wmi.c              |   1 +
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   3 +-
>  .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  28 ++---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |   3 +-
>  drivers/nvme/host/fc.c                             |  12 +-
>  drivers/pci/controller/cadence/pcie-cadence-host.c |   2 +-
>  drivers/pci/controller/cadence/pcie-cadence.c      |   4 +-
>  drivers/pci/controller/cadence/pcie-cadence.h      |   6 +-
>  drivers/pci/p2pdma.c                               |   2 +-
>  drivers/pci/quirks.c                               |   1 +
>  drivers/phy/cadence/cdns-dphy.c                    |   4 +-
>  drivers/pinctrl/pinctrl-single.c                   |   4 +-
>  drivers/regulator/fixed.c                          |   6 +-
>  drivers/remoteproc/qcom_q6v5.c                     |   5 +
>  drivers/s390/net/ctcm_mpc.c                        |   1 -
>  drivers/scsi/hosts.c                               |   5 +-
>  drivers/scsi/lpfc/lpfc_debugfs.h                   |   3 +
>  drivers/scsi/pm8001/pm8001_ctl.c                   |  24 ++--
>  drivers/scsi/pm8001/pm8001_init.c                  |   1 +
>  drivers/scsi/pm8001/pm8001_sas.c                   |   4 +-
>  drivers/scsi/pm8001/pm8001_sas.h                   |   4 +
>  drivers/scsi/sg.c                                  |  10 +-
>  drivers/slimbus/qcom-ngd-ctrl.c                    |   1 +
>  drivers/soc/imx/gpc.c                              |   2 +
>  drivers/soc/qcom/smem.c                            |   2 +-
>  drivers/soc/tegra/fuse/fuse-tegra30.c              | 122 +++++++++++++++=
+++
>  drivers/soc/ti/knav_dma.c                          |  14 +--
>  drivers/soc/ti/pruss.c                             |   2 +-
>  drivers/spi/spi-bcm63xx.c                          |  14 +++
>  drivers/spi/spi-loopback-test.c                    |  12 +-
>  drivers/spi/spi.c                                  |  10 ++
>  drivers/target/loopback/tcm_loop.c                 |   3 +
>  drivers/tee/tee_core.c                             |   2 +-
>  drivers/thunderbolt/nhi.c                          |   2 +
>  drivers/thunderbolt/nhi.h                          |   1 +
>  drivers/tty/serial/8250/8250_dw.c                  |  67 +++++-----
>  drivers/tty/serial/amba-pl011.c                    |   2 +-
>  drivers/uio/uio_hv_generic.c                       |  21 +++-
>  drivers/usb/cdns3/cdns3-pci-wrap.c                 |   5 +-
>  drivers/usb/dwc3/ep0.c                             |   1 +
>  drivers/usb/dwc3/gadget.c                          |   7 ++
>  drivers/usb/gadget/function/f_eem.c                |   7 +-
>  drivers/usb/gadget/function/f_fs.c                 |   8 +-
>  drivers/usb/gadget/function/f_hid.c                |   4 +-
>  drivers/usb/gadget/function/f_ncm.c                |   3 +-
>  drivers/usb/host/xhci-dbgcap.h                     |   1 +
>  drivers/usb/host/xhci-dbgtty.c                     |  17 ++-
>  drivers/usb/host/xhci-plat.c                       |   1 +
>  drivers/usb/mon/mon_bin.c                          |  14 ++-
>  drivers/usb/renesas_usbhs/common.c                 |  14 +--
>  drivers/usb/serial/ftdi_sio.c                      |   1 +
>  drivers/usb/serial/ftdi_sio_ids.h                  |   1 +
>  drivers/usb/serial/option.c                        |  10 +-
>  drivers/usb/storage/sddr55.c                       |   6 +
>  drivers/usb/storage/transport.c                    |  16 +++
>  drivers/usb/storage/uas.c                          |   7 +-
>  drivers/usb/storage/unusual_devs.h                 |   2 +-
>  drivers/usb/typec/ucsi/psy.c                       |   5 +
>  drivers/video/backlight/lp855x_bl.c                |   2 +-
>  drivers/video/fbdev/aty/atyfb_base.c               |   8 +-
>  drivers/video/fbdev/core/bitblit.c                 |  33 ++++-
>  drivers/video/fbdev/pvr2fb.c                       |   2 +-
>  drivers/video/fbdev/valkyriefb.c                   |   2 +
>  fs/9p/v9fs.c                                       |   9 +-
>  fs/btrfs/disk-io.c                                 |   2 +-
>  fs/btrfs/file.c                                    |  10 ++
>  fs/btrfs/transaction.c                             |   2 +-
>  fs/btrfs/tree-log.c                                |   1 -
>  fs/ceph/locks.c                                    |   5 +-
>  fs/cifs/connect.c                                  |   1 +
>  fs/dax.c                                           |   2 +-
>  fs/exfat/fatent.c                                  |  11 +-
>  fs/exfat/super.c                                   |   5 +-
>  fs/ext4/xattr.c                                    |   2 +-
>  fs/fs-writeback.c                                  |   7 +-
>  fs/hpfs/namei.c                                    |  18 ++-
>  fs/jfs/inode.c                                     |   8 +-
>  fs/jfs/jfs_txnmgr.c                                |   9 +-
>  fs/nfs/inode.c                                     |   6 +-
>  fs/nfs/nfs4client.c                                |   1 +
>  fs/nfs/nfs4proc.c                                  |   7 +-
>  fs/nfs/nfs4state.c                                 |   3 +
>  fs/nfsd/nfs4proc.c                                 |   7 +-
>  fs/nfsd/nfs4state.c                                |   3 +-
>  fs/open.c                                          |  10 +-
>  fs/orangefs/xattr.c                                |  12 +-
>  fs/overlayfs/copy_up.c                             |   2 +-
>  fs/proc/generic.c                                  |  12 +-
>  fs/xfs/xfs_super.c                                 |  33 +++--
>  include/linux/ata.h                                |   1 +
>  include/linux/blk_types.h                          |  11 +-
>  include/linux/compiler_types.h                     |   5 +-
>  include/linux/filter.h                             |   2 +-
>  include/linux/mm.h                                 |   2 +-
>  include/linux/shdma-base.h                         |   2 +-
>  include/linux/usb.h                                |  16 +--
>  include/net/cls_cgroup.h                           |   2 +-
>  include/net/nfc/nci_core.h                         |   2 +-
>  include/net/pkt_sched.h                            |  25 +++-
>  include/net/sctp/sctp.h                            |   3 +-
>  include/net/tls.h                                  |   6 +
>  kernel/bpf/ringbuf.c                               |   2 +
>  kernel/events/uprobes.c                            |   7 ++
>  kernel/gcov/gcc_4_7.c                              |   4 +-
>  kernel/trace/trace_events_hist.c                   |   6 +-
>  kernel/trace/trace_events_synth.c                  |   3 +-
>  lib/crypto/Makefile                                |   2 +-
>  mm/mempool.c                                       |  32 ++++-
>  mm/page_alloc.c                                    |   2 +-
>  net/8021q/vlan.c                                   |   2 +
>  net/bluetooth/6lowpan.c                            | 103 ++++++++++-----
>  net/bluetooth/hci_event.c                          |  21 +++-
>  net/bluetooth/l2cap_core.c                         |   1 +
>  net/bluetooth/sco.c                                |   7 ++
>  net/bluetooth/smp.c                                |  31 ++---
>  net/bridge/br_forward.c                            |   3 +-
>  net/ceph/ceph_common.c                             |  53 ++++----
>  net/ceph/debugfs.c                                 |  16 ++-
>  net/core/netpoll.c                                 |   7 +-
>  net/core/page_pool.c                               |   6 +-
>  net/core/sock.c                                    |  15 ++-
>  net/hsr/hsr_device.c                               |   3 +
>  net/ipv4/fib_frontend.c                            |   2 +-
>  net/ipv4/inet_diag.c                               |   5 +-
>  net/ipv4/nexthop.c                                 |   6 +
>  net/ipv4/raw_diag.c                                |   7 +-
>  net/ipv4/route.c                                   |   5 +
>  net/ipv4/udp_diag.c                                |   6 +-
>  net/ipv4/udp_tunnel_nic.c                          |   2 +-
>  net/ipv6/addrconf.c                                |   4 +-
>  net/ipv6/ah6.c                                     |  50 +++++---
>  net/ipv6/raw.c                                     |   2 +-
>  net/ipv6/udp.c                                     |   2 +-
>  net/mac80211/rx.c                                  |  10 +-
>  net/mptcp/mptcp_diag.c                             |   6 +-
>  net/mptcp/pm.c                                     |   3 +-
>  net/mptcp/pm_netlink.c                             |  20 +--
>  net/mptcp/protocol.c                               |  59 ++++++---
>  net/mptcp/protocol.h                               |   1 +
>  net/netfilter/nf_tables_api.c                      |  15 +++
>  net/netfilter/nft_set_pipapo.c                     |   4 +-
>  net/netfilter/nft_set_pipapo.h                     |  21 ++++
>  net/netfilter/nft_set_pipapo_avx2.c                |  31 ++++-
>  net/netlink/af_netlink.c                           |   2 +-
>  net/openvswitch/actions.c                          |  68 +---------
>  net/openvswitch/flow_netlink.c                     |  64 ++--------
>  net/openvswitch/flow_netlink.h                     |   2 -
>  net/rds/rds.h                                      |   2 +-
>  net/sched/act_ife.c                                |  12 +-
>  net/sched/sch_api.c                                |  10 --
>  net/sched/sch_generic.c                            |  17 +--
>  net/sched/sch_hfsc.c                               |  16 ---
>  net/sched/sch_qfq.c                                |   2 +-
>  net/sctp/diag.c                                    |  73 ++++++-----
>  net/sctp/sm_make_chunk.c                           |   2 +-
>  net/sctp/socket.c                                  |  24 ++--
>  net/sctp/transport.c                               |  13 +-
>  net/smc/smc_clc.c                                  |   1 +
>  net/strparser/strparser.c                          |   2 +-
>  net/tipc/net.c                                     |   2 +
>  net/tls/tls_device.c                               |   4 +-
>  net/unix/diag.c                                    |   6 +-
>  net/vmw_vsock/af_vsock.c                           |  40 ++++--
>  scripts/Kbuild.include                             |  10 +-
>  scripts/kconfig/mconf.c                            |   3 +
>  scripts/kconfig/nconf.c                            |   3 +
>  sound/pci/hda/patch_realtek.c                      |  17 +--
>  sound/soc/codecs/cs4271.c                          |  10 +-
>  sound/soc/codecs/max98090.c                        |   6 +-
>  sound/soc/meson/aiu-encoder-i2s.c                  |   9 +-
>  sound/soc/qcom/qdsp6/q6asm.c                       |   2 +-
>  sound/usb/endpoint.c                               |   5 +
>  sound/usb/mixer.c                                  |  11 +-
>  sound/usb/mixer_s1810c.c                           |  28 ++++-
>  sound/usb/validate.c                               |   9 +-
>  tools/include/linux/bitmap.h                       |   1 +
>  tools/power/cpupower/lib/cpuidle.c                 |   5 +-
>  .../x86_energy_perf_policy.c                       |  30 +++--
>  tools/testing/selftests/Makefile                   |   2 +-
>  tools/testing/selftests/bpf/test_lirc_mode2_user.c |   2 +-
>  tools/testing/selftests/net/fcnal-test.sh          |   4 +-
>  tools/testing/selftests/net/psock_tpacket.c        |   4 +-
>  tools/testing/selftests/net/traceroute.sh          |  13 +-
>  332 files changed, 2243 insertions(+), 1164 deletions(-)
>=20
>=20

--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--q1MpGQx/xgCsWvME
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaTBqeQAKCRAw5/Bqldv6
8pMsAJ9M81M7/TBNUPs/pK81WUtJsLUcmQCdETlbYnNhuf4AhHHtbAxDHB0JxXQ=
=fpgQ
-----END PGP SIGNATURE-----

--q1MpGQx/xgCsWvME--
