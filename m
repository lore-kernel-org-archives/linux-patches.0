Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21C61DB356
	for <patches@lists.linux.dev>; Sun,  7 Jun 2026 16:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780851553; cv=none; b=hY/IQhy3FoVXGVoaFktJDMzTJ9Hr1hne/e92rvDwshTZgRa8NX3xWRIP7Bhg+46FWyE3d4aHg56jqgBAQBmI1Dms+A2KxXg1/tJnMdjMTJpFB3mfoHDv9f+8j0Wm/+V5wxGhkdUwgBBUVFO60gqidc+am4ZxIcyj8RWzqRh9otk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780851553; c=relaxed/simple;
	bh=5DRXczbAlVYZFokpk6YWzMuyRjz3GA8lEwkAk0hL93c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hy2Kgf2YgWrfScFS4rLvwPuNgRiYI+93F9yDsPD/agHgYZHj/68JzSr5ykf6uGgSXh8JCbnmhoyXr3XI7Sek7FcbyxhNhOJoU4UkG142hQMx809gPtf0PlywNwlFAbsmqdrrmFD+1RVUY2cI7795NxUAV5BVeKw4svRqxkQoTlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=ga1EOovf; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="ga1EOovf"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 670D7116AF9;
	Sun,  7 Jun 2026 18:58:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1780851539;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=beJ1IyGeFA1w6sToyhs6FzhYTxp8yDpPy7EBaqUuzuA=;
	b=ga1EOovfgxzH2+7K7ikigv/Ic9mYN63Yg+kGKtjJXEc4Mvbkri9m/M3p1wcb0KbBKQRAAh
	+tLHrzBn0M4skAxmU9W+8CwW45wDPfbImGAZc9qaP5zZBYUACubtSivlJE/rMudlh6UjdY
	Fl4w6wO79AXPEEApFlEIOgLIZk+qjN6+iuEDVYLb4/Agw35l8XEbg8/gww3eBTOj7hlwgK
	vGlCKOgYE50wy/k8V2lFoS0FiP+E5/r/5V3ufmuHywynxvFnTxJ+bRTS14pyySH8ovRixQ
	kvIWiYkMednuNOnGNYqhLKFRquYv7CuGe9nzcoLxnFgRrlKidFiIQDfeaU4FLg==
Date: Sun, 7 Jun 2026 18:58:52 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/315] 6.18.35-rc1 review
Message-ID: <aiWjTGe7fRnSvIl4@duo.ucw.cz>
References: <20260607095727.528828913@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qHeIyAqtDGI99tvc"
Content-Disposition: inline
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--qHeIyAqtDGI99tvc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.18.35 release.
> There are 315 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We see build problem here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/147322=
23960
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2=
582906697

Best regards,
										Pavel



arch/arm64/kvm/nested.c: In function 'kvm_init_nv_sysregs':
1807
12:45:08
arch/arm64/kvm/nested.c:1776:9: error: 'resx' undeclared (first use in this=
 function); did you mean 'res1'?
1808
12:45:08
 1776 |         resx.res0 =3D ZCR_ELx_RES0 | GENMASK_ULL(8, 4);
1809
12:45:08
      |         ^~~~
1810
12:45:08
      |         res1
1811
12:45:08
arch/arm64/kvm/nested.c:1776:9: note: each undeclared identifier is reporte=
d only once for each function it appears in
1812
12:45:08
arch/arm64/kvm/nested.c:1778:9: error: too few arguments to function 'set_s=
ysreg_masks'
1813
12:45:08
 1778 |         set_sysreg_masks(kvm, ZCR_EL2, resx);
1814
12:45:08
      |         ^~~~~~~~~~~~~~~~
1815
12:45:08
arch/arm64/kvm/nested.c:1641:29: note: declared here
1816
12:45:08
 1641 | static __always_inline void set_sysreg_masks(struct kvm *kvm, int s=
r, u64 res0, u64 res1)
1817
12:45:08
      |                             ^~~~~~~~~~~~~~~~
1818
12:45:08
  CC      block/holder.o
1819
12:45:08
  CC      drivers/irqchip/irq-ls-scfg-msi.o
1820
12:45:09
make[4]: *** [scripts/Makefile.build:287: arch/arm64/kvm/nested.o]
Error 1

>=20
> thanks,
>=20
> greg k-h
>=20
> -------------
> Pseudo-Shortlog of commits:
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 6.18.35-rc1
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     thunderbolt: property: Cap recursion depth in __tb_property_parse_dir=
()
>=20
> Jouni H=F6gander <jouni.hogander@intel.com>
>     drm/i915/psr: Use DC_OFF wake reference to block DC6 on vblank enable
>=20
> Jassi Brar <jassisinghbrar@gmail.com>
>     mailbox: Fix NULL message support in mbox_send_message()
>=20
> Wei-Cheng Chen <weichengc@nvidia.com>
>     xhci: tegra: Fix ghost USB device on dual-role port unplug
>=20
> Robert Marko <robert.marko@sartura.hr>
>     net: phy: micrel: fix LAN8814 QSGMII soft reset
>=20
> Qing Wang <wangqing7171@gmail.com>
>     mm/slub: hold cpus_read_lock around flush_rcu_sheaves_on_cache()
>=20
> Abdurrahman Hussain <abdurrahman@nexthop.ai>
>     hwmon: (pmbus/adm1266) serialize GPIO PMBus accesses with pmbus_lock
>=20
> Abdurrahman Hussain <abdurrahman@nexthop.ai>
>     hwmon: (pmbus/adm1266) serialize sequencer_state debugfs read with pm=
bus_lock
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (pmbus) Add support for guarded PMBus lock
>=20
> Johan Hovold <johan@kernel.org>
>     USB: serial: mct_u232: fix memory corruption with small endpoint
>=20
> Johan Hovold <johan@kernel.org>
>     USB: serial: digi_acceleport: fix memory corruption with small endpoi=
nts
>=20
> Johan Hovold <johan@kernel.org>
>     USB: serial: cypress_m8: fix memory corruption with small endpoint
>=20
> Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
>     usb: dwc3: xilinx: fix error handling in zynqmp init error paths
>=20
> Shaomin Chen <eeesssooo020@gmail.com>
>     xfrm: iptfs: reset runtime state when cloning SAs
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     cpufreq: intel_pstate: Use correct scaling factor on Raptor Lake-E
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     cpufreq: intel_pstate: Add and use hybrid_get_cpu_type()
>=20
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: reset rcv wnd on disconnect
>=20
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: cleanup fallback dummy mapping generation
>=20
> Dawei Feng <dawei.feng@seu.edu.cn>
>     octeontx2-pf: avoid double free of pool->stack on AQ init failure
>=20
> Zeng Heng <zengheng4@huawei.com>
>     arm64: tlb: Flush walk cache when unsharing PMD tables
>=20
> Shardul Bankar <shardul.b@mpiricsoftware.com>
>     mptcp: do not drop partial packets
>=20
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: borrow forward memory from subflow
>=20
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: handle first subflow closing consistently
>=20
> David Carlier <devnexen@gmail.com>
>     net: devmem: reject dma-buf bind with non-page-aligned size or SG len=
gth
>=20
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     selftests: mptcp: drop nanoseconds width specifier
>=20
> Shuai Zhang <shuai.zhang@oss.qualcomm.com>
>     Bluetooth: hci_qca: Convert timeout from jiffies to ms
>=20
> Uwe Kleine-K=F6nig <u.kleine-koenig@baylibre.com>
>     Bluetooth: hci_qca: Migrate to serdev specific shutdown function
>=20
> Uwe Kleine-K=F6nig <u.kleine-koenig@baylibre.com>
>     serdev: Provide a bustype shutdown function
>=20
> David Howells <dhowells@redhat.com>
>     rxrpc: Fix RESPONSE packet verification to extract skb to a linear bu=
ffer
>=20
> David Howells <dhowells@redhat.com>
>     rxrpc: Fix DATA decrypt vs splice() by copying data to buffer in recv=
msg
>=20
> Tom Lendacky <thomas.lendacky@amd.com>
>     x86/mm: Disable broadcast TLB flush when PCID is disabled
>=20
> Lukas Wunner <lukas@wunner.de>
>     platform/x86/intel/vsec: Fix enable_cnt imbalance on PCIe error recov=
ery
>=20
> David E. Box <david.e.box@linux.intel.com>
>     platform/x86/intel/vsec: Make driver_data info const
>=20
> David E. Box <david.e.box@linux.intel.com>
>     platform/x86/intel/vsec: Refactor base_addr handling
>=20
> Jacques Nilo <jnilo@free.fr>
>     serial: 8250_dw: dispatch SysRq character in dw8250_handle_irq()
>=20
> Jacques Nilo <jnilo@free.fr>
>     serial: 8250: dispatch SysRq character in serial8250_handle_irq()
>=20
> Jacques Nilo <jnilo@free.fr>
>     serial: core: introduce guard(uart_port_lock_check_sysrq_irqsave)
>=20
> Maciej W. Rozycki <macro@orcam.me.uk>
>     serial: zs: Convert to use a platform device
>=20
> Maciej W. Rozycki <macro@orcam.me.uk>
>     serial: zs: Switch to using channel reset
>=20
> Maciej W. Rozycki <macro@orcam.me.uk>
>     serial: zs: Fix bootconsole handover lockup
>=20
> Maciej W. Rozycki <macro@orcam.me.uk>
>     serial: dz: Convert to use a platform device
>=20
> Maciej W. Rozycki <macro@orcam.me.uk>
>     serial: dz: Fix bootconsole handover lockup
>=20
> Maciej W. Rozycki <macro@orcam.me.uk>
>     serial: dz: Fix bootconsole message clobbering at chip reset
>=20
> Ziyi Guo <n7l8m4@u.northwestern.edu>
>     drm/amdgpu: check num_entries in GEM_OP GET_MAPPING_INFO
>=20
> Christian K=F6nig <christian.koenig@amd.com>
>     drm/amdgpu: fix calling VM invalidation in amdgpu_hmm_invalidate_gfx
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     drm/amdgpu: fix lock leak on ENOMEM in AMDGPU_GEM_OP_GET_MAPPING_INFO
>=20
> David Francis <David.Francis@amd.com>
>     drm/amdkfd: Check for pdd drm file first in CRIU restore path
>=20
> Eric Huang <jinhuieric.huang@amd.com>
>     drm/amdkfd: fix a vulnerability of integer overflow in kfd debugger
>=20
> Eric Huang <jinhuieric.huang@amd.com>
>     drm/amdkfd: fix NULL pointer bug in svm_range_set_attr
>=20
> Shitalkumar Gandhi <shital.gandhi45@gmail.com>
>     serial: fsl_lpuart: fix rx buffer and DMA map leaks in start_rx_dma
>=20
> Maciej W. Rozycki <macro@orcam.me.uk>
>     serial: zs: Fix swapped RI/DSR modem line transition counting
>=20
> Hongling Zeng <zenghongling@kylinos.cn>
>     serial: sh-sci: fix memory region release in error path
>=20
> Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
>     serial: qcom_geni: fix kfifo underflow when flush precedes DMA comple=
tion IRQ
>=20
> Prasanna S <prasanna.s@oss.qualcomm.com>
>     serial: qcom-geni: fix UART_RX_PAR_EN bit position
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     serial: altera_jtaguart: handle uart_add_one_port() failures
>=20
> Timur Krist=F3f <timur.kristof@gmail.com>
>     drm/amd/pm/si: Disregard vblank time when no displays are connected
>=20
> Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
>     drm/i915: Fix potential UAF in TTM object purge
>=20
> Jouni H=F6gander <jouni.hogander@intel.com>
>     drm/i915/psr: Block DC states on vblank enable when Panel Replay supp=
orted
>=20
> Zhenghang Xiao <kipreyyy@gmail.com>
>     drm/gem: fix race between change_handle and handle_delete
>=20
> Berkant Koc <me@berkoc.com>
>     drm/hyperv: validate VMBus packet size in receive callback
>=20
> Berkant Koc <me@berkoc.com>
>     drm/hyperv: validate resolution_count and fix WIN8 fallback
>=20
> Alexandru Hossu <hossu.alexandru@gmail.com>
>     scsi: target: iscsi: Validate CHAP_R length before base64 decode
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     scsi: target: iscsi: Bound iscsi_encode_text_output() appends to rsp_=
buf
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     scsi: target: iscsi: Fix CRC overread and double-free in iscsit_handl=
e_text_cmd()
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     scsi: scsi_transport_fc: Widen FPIN pname walker counter to u32
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     scsi: fcoe: Reject FIP descriptors with zero fip_dlen in CVL walker
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     thunderbolt: property: Reject dir_len < 4 to prevent size_t underflow
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     thunderbolt: property: Reject u32 wrap in tb_property_entry_valid()
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     usb: gadget: f_fs: serialize DMABUF cancel against request completion
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     usb: gadget: f_fs: copy only received bytes on short ep0 read
>=20
> Seungjin Bae <eeodqql09@gmail.com>
>     usb: gadget: dummy_hcd: Reject hub port requests for non-existent por=
ts
>=20
> Jeremy Erazo <mendozayt13@gmail.com>
>     usb: gadget: composite: fix integer underflow in WebUSB GET_URL handl=
ing
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     usb: gadget: f_hid: fix device reference leak in hidg_alloc()
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     usb: gadget: net2280: Fix double free in probe error path
>=20
> Kai Aizen <kai.aizen.dev@gmail.com>
>     usb: gadget: uvc: hold opts->lock across XU walks in uvc_function_bind
>=20
> Johan Hovold <johan@kernel.org>
>     USB: serial: mct_u232: fix missing interrupt-in transfer sanity check
>=20
> Johan Hovold <johan@kernel.org>
>     USB: serial: mxuport: fix memory corruption with small endpoint
>=20
> Johan Hovold <johan@kernel.org>
>     USB: serial: keyspan: fix missing indat transfer sanity check
>=20
> Zhang Cen <rollkingzzc@gmail.com>
>     USB: serial: cypress_m8: validate interrupt packet headers
>=20
> Zhang Cen <rollkingzzc@gmail.com>
>     USB: serial: belkin_sa: validate interrupt status length
>=20
> Wanquan Zhong <wanquan.zhong@fibocom.com>
>     USB: serial: option: add missing RSVD(5) flag for Rolling RW135R-GL
>=20
> Jan Volckaert <janvolck@gmail.com>
>     USB: serial: option: add MeiG SRM813Q
>=20
> Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
>     usb: typec: ucsi: Don't update power_supply on power role change if n=
ot connected
>=20
> Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
>     usb: typec: ucsi: Check if power role change actually happened before=
 handling
>=20
> Sebastian Reichel <sebastian.reichel@collabora.com>
>     usb: typec: tcpm: improve handling of DISCOVER_MODES failures
>=20
> Dan Carpenter <error27@gmail.com>
>     usb: typec: tipd: Fix error code in tps6598x_probe()
>=20
> Heitor Alves de Siqueira <halves@igalia.com>
>     usb: usbtmc: reject interrupt endpoints with small wMaxPacketSize
>=20
> Heitor Alves de Siqueira <halves@igalia.com>
>     usb: usbtmc: check URB actual_length for interrupt-IN notifications
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     usbip: vudc: Fix use after free bug in vudc_remove due to race condit=
ion
>=20
> Sam Burkels <sam@1a38.nl>
>     usb: storage: Add quirks for PNY Elite Portable SSD
>=20
> Stephen J. Fuhry <fuhrysteve@gmail.com>
>     USB: quirks: add NO_LPM for Lenovo ThinkPad USB-C Dock Gen2 hub contr=
ollers
>=20
> Wentao Liang <vulab@iscas.ac.cn>
>     usb: musb: omap2430: Fix use-after-free in omap2430_probe()
>=20
> Michal Pecio <michal.pecio@gmail.com>
>     usb: core: Fix up Interrupt IN endpoints with bogus wBytesPerInterval
>=20
> Xu Yang <xu.yang_2@nxp.com>
>     usb: chipidea: core: convert ci_role_switch to local variable
>=20
> Tudor Ambarus <tudor.ambarus@linaro.org>
>     tty: serial: samsung: Remove redundant port lock acquisition in rx he=
lpers
>=20
> Zhaoyang Yu <2426767509@qq.com>
>     tty: serial: pch_uart: add check for dma_alloc_coherent()
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     counter: Fix refcount leak in counter_alloc() error path
>=20
> Ian Abbott <abbotti@mev.co.uk>
>     comedi: comedi_test: Fix limiting of convert_arg in waveform_ai_cmdte=
st()
>=20
> Ian Abbott <abbotti@mev.co.uk>
>     comedi: comedi_test: fix check for valid scan_begin_src in waveform_a=
i_cmdtest()
>=20
> Hongling Zeng <zenghongling@kylinos.cn>
>     gpib: cb7210: Fix region leak when request_irq fails
>=20
> Nicol=E1s Bazaes <contacto@bazaes.cl>
>     Input: synaptics - add LEN2058 to SMBus passlist for ThinkPad E490
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: atmel_mxt_ts - fix boundary check in mxt_prepare_cfg_mem
>=20
> Xiaolei Wang <xiaolei.wang@windriver.com>
>     misc: rp1: Send IACK on IRQ activate to fix kdump/kexec
>=20
> Ali Ganiyev <ali.qaniyev@gmail.com>
>     ksmbd: OOB read regression in smb_check_perm_dacl() ACE-walk loops
>=20
> Dmitriy Zharov <contact@zharov.dev>
>     Input: xpad - add support for ASUS ROG RAIKIRI II
>=20
> Qbeliw Tanaka <q.tanaka@gmx.com>
>     Input: xpad - add "Nova 2 Lite" from GameSir
>=20
> Zhang Heng <zhangheng@kylinos.cn>
>     ALSA: hda/realtek: Fix speaker output on ASUS ROG Strix G615LP
>=20
> Jingguo Tan <tanjingguo@huawei.com>
>     xfrm: esp: restore combined single-frag length gate
>=20
> Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
>     ASoC: qcom: q6asm-dai: do not set stream state in event and trigger c=
allbacks
>=20
> Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
>     ASoC: qcom: q6asm-dai: close stream only when running
>=20
> Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
>     netfilter: conntrack: tcp: do not force CLOSE on invalid-seq RST with=
out direction check
>=20
> C=E1ssio Gabriel <cassiogabrielcontato@gmail.com>
>     ALSA: firewire-motu: Protect register DSP event queue positions
>=20
> Geoffrey D. Bennett <g@b4.vu>
>     ALSA: scarlett2: Fix 2i2 Gen 4 direct monitor gain on firmware 2417
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     xfrm: ah: use skb_to_full_sk in async output callbacks
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     xfrm: ipcomp: Free destination pages on acomp errors
>=20
> Maoyi Xie <maoyixie.tju@gmail.com>
>     xfrm: route MIGRATE notifications to caller's netns
>=20
> Ashutosh Desai <ashutoshdesai993@gmail.com>
>     nfc: hci: fix out-of-bounds read in HCP header parsing
>=20
> Arnd Bergmann <arnd@arndb.de>
>     iommu, debugobjects: avoid gcc-16.1 section mismatch warnings
>=20
> Lee Jones <lee@kernel.org>
>     HID: wacom: Fix OOB write in wacom_hid_set_device_mode()
>=20
> Santhosh Kumar K <s-k6@ti.com>
>     spi: spi-mem: avoid mutating op template in spi_mem_supports_op()
>=20
> Minh Nguyen <minhnguyen.080505@gmail.com>
>     net: skbuff: fix missing zerocopy reference in pskb_carve helpers
>=20
> Kuniyuki Iwashima <kuniyu@google.com>
>     ip6: vti: Use ip6_tnl.net in vti6_changelink().
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     l2tp: use refcount_inc_not_zero in l2tp_session_get_by_ifname
>=20
> Zhengchuan Liang <zcliangcn@gmail.com>
>     xfrm: input: hold netns during deferred transport reinjection
>=20
> Qi Tang <tpluszz77@gmail.com>
>     ipv6: validate extension header length before copying to cmsg
>=20
> Maoyi Xie <maoyixie.tju@gmail.com>
>     ip6: vti: Use ip6_tnl.net in vti6_siocdevprivate().
>=20
> Zhengchuan Liang <zcliangcn@gmail.com>
>     ipv6: exthdrs: refresh nh after handling HAO option
>=20
> Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
>     ASoC: qcom: q6asm-dai: fix error handling in prepare and set_params
>=20
> Justin Iurman <justin.iurman@gmail.com>
>     ipv6: exthdrs: refresh nh pointer after ipv6_hop_jumbo()
>=20
> Junrui Luo <moonafterrain@outlook.com>
>     macsec: fix replay protection at XPN lower-PN wrap
>=20
> Yuqi Xu <xuyq21@lenovo.com>
>     bpf: sockmap: fix tail fragment offset in bpf_msg_push_data
>=20
> Jason A. Donenfeld <Jason@zx2c4.com>
>     wireguard: send: append trailer after expanding head
>=20
> Alexis Lothor=E9 (eBPF Foundation) <alexis.lothore@bootlin.com>
>     x86/ftrace: Relocate %rip-relative percpu refs in dynamic trampolines
>=20
> Chaitanya Sabnis <chaitanya.msabnis@gmail.com>
>     i2c: davinci: fix division by zero on missing clock-frequency
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: elan_i2c - validate firmware size before use
>=20
> Dan Carpenter <error27@gmail.com>
>     usb: dwc2: Fix use after free in debug code
>=20
> Peter Chen <peter.chen@cixtech.com>
>     usb: cdns3: plat: fix unbalanced pm_runtime_forbid() call permanently=
 leaks the runtime PM usage counter across bind/unbind cycles
>=20
> Peter Chen <peter.chen@cixtech.com>
>     usb: cdns3: plat: fix leaked usb2_phy initialization on usb3_phy acqu=
isition failure
>=20
> Yongchao Wu <yongchao.wu@autochips.com>
>     usb: cdns3: gadget: fix request skipping after clearing halt
>=20
> Johan Hovold <johan@kernel.org>
>     USB: serial: omninet: fix memory corruption with small endpoint
>=20
> Beno=EEt Monin <benoit.monin@bootlin.com>
>     iio: buffer: Fix DMA fence leak in iio_buffer_enqueue_dmabuf()
>=20
> Felix Gu <ustc.gu@gmail.com>
>     iio: buffer: hw-consumer: fix use-after-free in error path
>=20
> Aldo Conte <aldocontelk@gmail.com>
>     iio: light: cm3323: fix reg_conf not being initialized correctly
>=20
> Antoniu Miclaus <antoniu.miclaus@analog.com>
>     iio: chemical: scd30: fix division by zero in write_raw
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     iio: chemical: mhz19b: reject oversized serial replies
>=20
> Svyatoslav Ryhel <clamor95@gmail.com>
>     iio: Fix iio_multiply_value use in iio_read_channel_processed_scale
>=20
> Felix Gu <ustc.gu@gmail.com>
>     iio: light: veml6070: Fix resource leak in probe error path
>=20
> Advait Dhamorikar <advaitd@mechasystems.com>
>     iio: magnetometer: st_magn: fix default DRDY pin selection for LIS2MDL
>=20
> Salah Triki <salah.triki@gmail.com>
>     iio: temperature: tsys01: fix broken PROM checksum validation
>=20
> Sanjay Chitroda <sanjayembeddedse@gmail.com>
>     iio: ssp_sensors: cancel delayed work_refresh on remove
>=20
> Antoniu Miclaus <antoniu.miclaus@analog.com>
>     iio: gyro: adis16260: fix division by zero in write_raw
>=20
> David Carlier <devnexen@gmail.com>
>     iio: gyro: itg3200: fix i2c read into the wrong stack location
>=20
> Radu Sabau <radu.sabau@analog.com>
>     iio: adc: ad4695: Fix call ordering in offload buffer postenable
>=20
> Salah Triki <salah.triki@gmail.com>
>     iio: adc: viperboard: Fix error handling in vprbrd_iio_read_raw
>=20
> Salah Triki <salah.triki@gmail.com>
>     iio: adc: mt6359: fix unchecked return value in mt6358_read_imp
>=20
> Rodrigo Alencar <rodrigo.alencar@analog.com>
>     iio: dac: ad5686: fix powerdown control on dual-channel devices
>=20
> Rodrigo Alencar <rodrigo.alencar@analog.com>
>     iio: dac: ad5686: acquire lock when doing powerdown control
>=20
> Rodrigo Alencar <rodrigo.alencar@analog.com>
>     iio: dac: ad5686: fix input raw value check
>=20
> Rodrigo Alencar <rodrigo.alencar@analog.com>
>     iio: dac: ad5686: fix ref bit initialization for single-channel parts
>=20
> Salah Triki <salah.triki@gmail.com>
>     iio: dac: max5821: fix return value check in powerdown sync
>=20
> Kim Seer Paller <kimseer.paller@analog.com>
>     iio: dac: ad3530r: Fix AD3531/AD3531R powerdown mode strings
>=20
> David Carlier <devnexen@gmail.com>
>     iio: adc: npcm: fix unbalanced clk_disable_unprepare()
>=20
> Christofer Jonason <christofer.jonason@guidelinegeo.com>
>     iio: adc: xilinx-xadc: Fix sequencer mode in postdisable for dual mux
>=20
> Nathan Chancellor <nathan@kernel.org>
>     Disable -Wattribute-alias for clang-23 and newer
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: SEV: Don't explicitly pass PSC buffer to snp_begin_psc()
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: SEV: Use READ_ONCE() when reading entries/indices from PSC buffer
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: SEV: Check PSC request indices against the actual size of the bu=
ffer
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: SEV: Compute the correct max length of the in-GHCB scratch area
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: SEV: WARN if KVM attempts to setup scratch area with min_len=3D=
=3D0
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: SEV: Use the size of the PSC header as the minimum size for PSC =
requests
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: SEV: Ignore Port I/O requests of length '0'
>=20
> Michael Roth <michael.roth@amd.com>
>     KVM: SEV: Require in-GHCB scratch area if GHCB v2+ is in use
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: SVM: Flush the current TLB when transitioning from xAVIC =3D> x2=
AVIC
>=20
> Qiang Ma <maqianga@uniontech.com>
>     KVM: arm64: PMU: Preserve AArch32 counter low bits
>=20
> Mark Brown <broonie@kernel.org>
>     KVM: arm64: Correctly cap ZCR_EL2 provided by a guest hypervisor
>=20
> Wentao Guan <guanwentao@uniontech.com>
>     USB: cdc-acm: Fix bit overlap and move quirk definitions to header
>=20
> Alice Ryhl <aliceryhl@google.com>
>     rust_binder: avoid calling pending_oneway_finished() on TF_UPDATE_TXN
>=20
> Matthew Maurer <mmaurer@google.com>
>     rust_binder: Avoid holding lock when dropping delivered_death
>=20
> Ben Hutchings <benh@debian.org>
>     parport: Fix race between port and client registration
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: xpad - fix out-of-bounds access for Share button
>=20
> Doruk Tan Ozturk <doruk@0sec.ai>
>     Bluetooth: hci_sync: fix UAF in hci_le_create_cis_sync
>=20
> Shuai Zhang <shuai.zhang@oss.qualcomm.com>
>     Bluetooth: hci_qca: Use 100 ms SSR delay for rampatch and NVM loading
>=20
> Pavitra Jha <jhapavitra98@gmail.com>
>     Bluetooth: hci_conn: Fix memory leak in hci_le_big_terminate()
>=20
> Muhammad Bilal <meatuni001@gmail.com>
>     Bluetooth: ISO: serialize iso_sock_clear_timer with socket lock
>=20
> Muhammad Bilal <meatuni001@gmail.com>
>     Bluetooth: ISO: fix UAF in iso_recv_frame
>=20
> Muhammad Bilal <meatuni001@gmail.com>
>     Bluetooth: HIDP: fix missing length checks in hidp_input_report()
>=20
> Siwei Zhang <oss@fourdim.xyz>
>     Bluetooth: L2CAP: fix chan ref leak in l2cap_chan_timeout() on !conn
>=20
> Siwei Zhang <oss@fourdim.xyz>
>     Bluetooth: L2CAP: use chan timer to close channels in cleanup_listen()
>=20
> Steve French <stfrench@microsoft.com>
>     smb: client: fix uninitialized variable in smb2_writev_callback
>=20
> Stepan Ionichev <sozdayvek@gmail.com>
>     auxdisplay: line-display: fix OOB read on zero-length message_store()
>=20
> Dev Jain <dev.jain@arm.com>
>     mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one
>=20
> Pratyush Yadav (Google) <pratyush@kernel.org>
>     memfd: deny writeable mappings when implying SEAL_WRITE
>=20
> Alexandre Ghiti <alex@ghiti.fr>
>     mm: memcontrol: propagate NMI slab stats to memcg vmstats
>=20
> Linpu Yu <linpu5433@gmail.com>
>     ipc: limit next_id allocation to the valid ID range
>=20
> SeongJae Park <sj@kernel.org>
>     mm/damon/sysfs-schemes: delete tried region in regions_rmdirs()
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     hpfs: fix a crash if hpfs_map_dnode_bitmap fails
>=20
> Shuai Zhang <shuai.zhang@oss.qualcomm.com>
>     Bluetooth: btusb: Allow firmware re-download when version matches
>=20
> hlleng <a909204013@gmail.com>
>     HID: quirks: Add ALWAYS_POLL quirk for SIGMACHIP USB mouse
>=20
> Thomas Fourier <fourier.thomas@gmail.com>
>     Input: ims-pcu - fix usb_free_coherent() size in ims_pcu_buffers_free=
()
>=20
> Henri A <contact@henrialfonso.com>
>     media: rc: igorplugusb: fix control request setup packet
>=20
> Johan Hovold <johan@kernel.org>
>     USB: serial: safe_serial: fix memory corruption with small endpoint
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     usb: typec: ucsi: validate connector number in ucsi_connector_change()
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     usb: typec: tcpm/tcpci_maxim: validate header NDO against RX_BYTE_CNT
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     usb: typec: wcove: don't write past struct pd_message in wcove_read_r=
x_buffer()
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     usb: typec: altmodes/displayport: validate count before reading Statu=
s Update VDO
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     usb: typec: ucsi: displayport: NAK DP_CMD_CONFIGURE without a payload=
 VDO
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     usb: typec: tcpm: bound altmode_desc[] per iteration in svdm_consume_=
modes()
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     usb: typec: tcpm: validate VDO count in Discover Identity ACK handlers
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     usb: typec: ucsi: ccg: reject firmware images without a ':' record he=
ader
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     iio: pressure: bmp280: fix stack leak in bmp580 trigger handler
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     iio: imu: adis16550: fix stack leak in trigger handler
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     iio: imu: st_lsm6dsx: fix stack leak in tagged FIFO buffer
>=20
> Horatiu Vultur <horatiu.vultur@microchip.com>
>     phy: mscc: Use PHY_ID_MATCH_EXACT for VSC8584, VSC8582, VSC8575, VSC8=
56X
>=20
> Jouni H=F6gander <jouni.hogander@intel.com>
>     drm/i915/psr: Apply Intel DPCD workaround when SDP on prior line used
>=20
> Jouni H=F6gander <jouni.hogander@intel.com>
>     drm/i915/psr: Read Intel DPCD workaround register
>=20
> Jouni H=F6gander <jouni.hogander@intel.com>
>     drm/i915/psr: Add defininitions for INTEL_WA_REGISTER_CAPS DPCD regis=
ter
>=20
> Peter Oberparleiter <oberpar@linux.ibm.com>
>     s390/cio: Restore GFP_DMA for CHSC allocation
>=20
> Andrei Vagin <avagin@google.com>
>     Revert "x86/fpu: Refine and simplify the magic number check during si=
gnal return"
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     smb: client: validate the whole DACL before rewriting it in cifsacl
>=20
> Oliver Neukum <oneukum@suse.com>
>     media: rc: ttusbir: fix inverted error logic
>=20
> Sean Young <sean@mess.org>
>     media: rc: fix race between unregister and urb/irq callbacks
>=20
> Pavel Begunkov <asml.silence@gmail.com>
>     net: skbuff: fix pskb_carve leaking zcopy pages
>=20
> Jiayuan Chen <jiayuan.chen@linux.dev>
>     ipv6: fix possible infinite loop in fib6_select_path()
>=20
> Jiayuan Chen <jiayuan.chen@linux.dev>
>     ipv6: fix possible infinite loop in rt6_fill_node()
>=20
> Jingguo Tan <tanjingguo@huawei.com>
>     vsock/virtio: bind uarg before filling zerocopy skb
>=20
> Zhenghang Xiao <kipreyyy@gmail.com>
>     sctp: fix race between sctp_wait_for_connect and peeloff
>=20
> Dipayaan Roy <dipayanroy@linux.microsoft.com>
>     net: mana: Skip redundant detach on already-detached port
>=20
> Dipayaan Roy <dipayanroy@linux.microsoft.com>
>     net: mana: Add NULL guards in teardown path to prevent panic on attac=
h failure
>=20
> Marco Scardovi <scardracs@disroot.org>
>     gpio: rockchip: teardown bugs and resource leaks
>=20
> Marco Scardovi <scardracs@disroot.org>
>     gpio: rockchip: convert bank->clk to devm_clk_get_enabled()
>=20
> Dan Carpenter <error27@gmail.com>
>     gpio: virtuser: Fix uninitialized data bug in gpio_virtuser_direction=
_do_write()
>=20
> Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
>     gpio: adnp: fix flow control regression caused by scoped_guard()
>=20
> Heitor Alves de Siqueira <halves@igalia.com>
>     Bluetooth: hci_sync: Reset device counters in hci_dev_close_sync()
>=20
> Heitor Alves de Siqueira <halves@igalia.com>
>     Bluetooth: hci_sync: Set HCI_CMD_DRAIN_WORKQUEUE during device close
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: L2CAP: Fix possible crash on l2cap_ecred_conn_rsp
>=20
> Zhenghang Xiao <kipreyyy@gmail.com>
>     Bluetooth: l2cap: clear chan->ident on ECRED reconfiguration success
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     net/handshake: Pass negative errno through handshake_complete()
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     nvme-tcp: store negative errno in queue->tls_err
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     net/handshake: Use spin_lock_bh for hn_lock
>=20
> Jijie Shao <shaojijie@huawei.com>
>     net: hibmcge: disable Relaxed Ordering to fix RX packet corruption
>=20
> Jamal Hadi Salim <jhs@mojatatu.com>
>     net/sched: Revert "net/sched: Restrict conditions for adding duplicat=
ing netems to qdisc tree"
>=20
> Rahul Chandelkar <rc@rexion.ai>
>     ipv6: rpl: fix hdrlen overflow in ipv6_rpl_srh_decompress()
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: eeprom: add more safeties to EEPROM Netlink fallback
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: eeprom: add missing ethnl_ops_begin() / _complete() during f=
allback
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: strset: fix header attribute index in ethnl_req_get_phydev()
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: tsinfo: don't pass ERR_PTR to genlmsg_cancel on prepare fail=
ure
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: tsinfo: fix uninitialized stats on the by-PHC path
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: tsconfig: fix missing ethnl_ops_complete()
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: pse-pd: fix missing ethnl_ops_complete()
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: linkstate: fix unbalanced ethnl_ops_complete() on PHY lookup=
 error
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: tsconfig: fix reply error handling
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: coalesce: cap profile updates at NET_DIM_PARAMS_NUM_PROFILES
>=20
> Ido Schimmel <idosch@nvidia.com>
>     bridge: Fix sleep in atomic context in sysfs path
>=20
> Ido Schimmel <idosch@nvidia.com>
>     bridge: Fix sleep in atomic context in netlink path
>=20
> Oliver Hartkopp <socketcan@hartkopp.net>
>     bonding: refuse to enslave CAN devices
>=20
> Zhao Dongdong <zhaodongdong@kylinos.cn>
>     Bluetooth: 6lowpan: check skb_clone() return value in send_mcast_pkt()
>=20
> Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
>     drm/xe: Restore IDLEDLY regiter on engine reset
>=20
> C=E1ssio Gabriel <cassiogabrielcontato@gmail.com>
>     ASoC: codecs: simple-mux: Fix enum control bounds check
>=20
> Sean Shen <grayhat@foxmail.com>
>     ksmbd: fix FSCTL permission bypass by adding a permission check for F=
SCTL_SET_SPARSE
>=20
> Eric Dumazet <edumazet@google.com>
>     tunnels: do not assume transport header in iptunnel_pmtud_check_icmp()
>=20
> Eric Dumazet <edumazet@google.com>
>     vxlan: do not reuse cached ip_hdr() value after skb_tunnel_check_pmtu=
()
>=20
> Eric Dumazet <edumazet@google.com>
>     tunnels: load network headers after skb_cow() in iptunnel_pmtud_build=
_icmp[v6]()
>=20
> Li Ming <ming.li@zohomail.com>
>     cxl/test: Update mock dev array before calling platform_device_add()
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: cmis: validate fw->size against start_cmd_payload_size
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: cmis: validate start_cmd_payload_size from module
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: cmis: fix u16-to-u8 truncation of msleep_pre_rpl
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: cmis: require exact CDB reply length
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: module: fix cleanup if socket used for flashing multiple dev=
ices
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: module: check fw_flash_in_progress under rtnl_lock
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: module: avoid racy updates to dev->ethtool bitfield
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: module: avoid leaking a netdev ref on module flash errors
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: module: call ethnl_ops_complete() on module flash errors
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: rss: avoid device context leak on reply-build failure
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: rss: fix hkey leak when indir_size is 0
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: rss: fix indir_table and hkey leak on get_rxfh failure
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: rss: fix falsely ignoring indir table updates
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: rss: add missing errno on RSS context delete
>=20
> Jakub Kicinski <kuba@kernel.org>
>     ethtool: rss: avoid modifying the RSS context response
>=20
> Bj=F6rn T=F6pel <bjorn@kernel.org>
>     net: Avoid checksumming unreadable skb tail on trim
>=20
> Weiming Shi <bestswngs@gmail.com>
>     net: team: fix NULL pointer dereference in team_xmit during mode chan=
ge
>=20
> Marc Harvey <marcharvey@google.com>
>     net: team: Rename port_disabled team mode op to port_tx_disabled
>=20
> Marc Harvey <marcharvey@google.com>
>     net: team: Remove unused team_mode_op, port_enabled
>=20
> Alexander Stein <alexander.stein@ew.tq-group.com>
>     gpio: mxc: fix irq_high handling
>=20
> Luka Gejak <luka.gejak@linux.dev>
>     net: hsr: fix potential OOB access in supervision frame handling
>=20
> Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
>     net/mlx5: HWS: Reject unsupported remove-header action
>=20
> C=E1ssio Gabriel <cassiogabrielcontato@gmail.com>
>     ASoC: Intel: bytcht_es8316: Fix MCLK leak on init errors
>=20
> C=E1ssio Gabriel <cassiogabrielcontato@gmail.com>
>     ALSA: pcm: oss: Fix setup list UAF on proc write error
>=20
> Eric Dumazet <edumazet@google.com>
>     ipv4: free net->ipv4.sysctl_local_reserved_ports after unregister_net=
_sysctl_table()
>=20
> David Jeffery <djeffery@redhat.com>
>     scsi: core: Run queues for all non-SDEV_DEL devices from scsi_run_hos=
t_queues
>=20
> Breno Leitao <leitao@debian.org>
>     net/iucv: fix locking in .getsockopt
>=20
> Alexandra Winter <wintera@linux.ibm.com>
>     net/smc: Do not re-initialize smc hashtables
>=20
> Ilya Maximets <i.maximets@ovn.org>
>     net: netlink: don't set nsid on local notifications
>=20
> Ilya Maximets <i.maximets@ovn.org>
>     net: netlink: fix sending unassigned nsid after assigned one
>=20
> Ziyu Zhang <ziyuzhang201@gmail.com>
>     vsock: keep poll shutdown state consistent
>=20
> Weiming Shi <bestswngs@gmail.com>
>     tun: free page on build_skb failure in tun_xdp_one()
>=20
> Weiming Shi <bestswngs@gmail.com>
>     tun: free page on short-frame rejection in tun_xdp_one()
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     netfilter: nf_tables: fix dst corruption in same register operation
>=20
> Florian Westphal <fw@strlen.de>
>     netfilter: ebtables: fix OOB read in compat_mtw_from_user
>=20
> Florian Westphal <fw@strlen.de>
>     netfilter: xt_cpu: prefer raw_smp_processor_id
>=20
> Chris Mason <clm@meta.com>
>     netfilter: synproxy: refresh tcphdr after skb_ensure_writable
>=20
> Deepanshu Kartikey <kartikey406@gmail.com>
>     kernel/fork: validate exit_signal in kernel_clone()
>=20
> Dhabaleshwar Das <dhabal123@gmail.com>
>     accel/rocket: fix UAF via dangling GEM handle in create_bo
>=20
> Florian Schmaus <florian.schmaus@codasip.com>
>     kunit: fix use-after-free in debugfs when using kunit.filter
>=20
> Liu Kai <lukace97@outlook.com>
>     HID: remove duplicate hid_warn_ratelimited definition
>=20
> Hongtao Lee <lihongtao@kylinos.cn>
>     tools/bootconfig: Fix buf leaks in apply_xbc
>=20
> Carl Lee <carl.lee@amd.com>
>     nfc: nxp-nci: i2c: use rising-edge IRQ on ACPI systems
>=20
> David Ahern <dahern@nvidia.com>
>     xfrm: Check for underflow in xfrm_state_mtu
>=20
> Lee Jones <lee@kernel.org>
>     nfc: llcp: Fix use-after-free race in nfc_llcp_recv_cc()
>=20
> Lee Jones <lee@kernel.org>
>     nfc: llcp: Fix use-after-free in llcp_sock_release()
>=20
> Mingzhe Zou <mingzhe.zou@easystack.cn>
>     bcache: fix uninitialized closure object
>=20
> Victor Nogueria <victor@mojatatu.com>
>     net/sched: sch_sfb: Replace direct dequeue call with peek and qdisc_d=
equeue_peeked
>=20
> Usama Arif <usama.arif@linux.dev>
>     xfrm: move policy_bydst RCU sync from per-netns .exit to .pre_exit
>=20
> Jeremy Kerr <jk@codeconstruct.com.au>
>     net: mctp: ensure our nlmsg responses are initialised
>=20
> Davide Caratti <dcaratti@redhat.com>
>     net/sched: cls_fw: fix NULL dereference of "old" filters before chang=
e()
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Input: usbtouchscreen - clamp NEXIO data_len/x_len to URB buffer size
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Documentation/netlink/specs/handshake.yaml         |   8 +
>  Makefile                                           |   4 +-
>  arch/arm64/include/asm/kvm_host.h                  |   2 +-
>  arch/arm64/include/asm/tlb.h                       |   2 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h            |  16 +-
>  arch/arm64/kvm/nested.c                            |   5 +
>  arch/arm64/kvm/pmu-emul.c                          |   4 +-
>  arch/arm64/kvm/sys_regs.c                          |  11 +-
>  arch/mips/dec/platform.c                           | 109 ++++++++++-
>  arch/riscv/include/asm/syscall_wrapper.h           |   4 +
>  arch/x86/kernel/cpu/cpuid-deps.c                   |   1 +
>  arch/x86/kernel/fpu/signal.c                       |  11 +-
>  arch/x86/kernel/ftrace.c                           |   7 +
>  arch/x86/kvm/svm/avic.c                            |  35 +++-
>  arch/x86/kvm/svm/sev.c                             |  76 ++++---
>  drivers/accel/rocket/rocket_gem.c                  |  17 +-
>  drivers/android/binder/allocation.rs               |   8 +
>  drivers/android/binder/process.rs                  |   7 +-
>  drivers/android/binder/transaction.rs              |  11 +-
>  drivers/auxdisplay/line-display.c                  |   2 +-
>  drivers/bluetooth/btusb.c                          |   8 +-
>  drivers/bluetooth/hci_qca.c                        |  42 ++--
>  drivers/comedi/drivers/comedi_test.c               |   5 +-
>  drivers/counter/counter-core.c                     |   3 +-
>  drivers/cpufreq/intel_pstate.c                     |  13 +-
>  drivers/gpio/gpio-adnp.c                           |   4 +-
>  drivers/gpio/gpio-mxc.c                            |   2 +-
>  drivers/gpio/gpio-rockchip.c                       |  23 ++-
>  drivers/gpio/gpio-virtuser.c                       |   4 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  11 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c            |   1 +
>  drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   7 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  10 +-
>  .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   8 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   3 +
>  drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |   4 +
>  drivers/gpu/drm/bridge/sil-sii8620.c               |   1 +
>  drivers/gpu/drm/drm_gem.c                          |   2 +
>  drivers/gpu/drm/hyperv/hyperv_drm_proto.c          | 113 +++++++++--
>  drivers/gpu/drm/i915/display/intel_display_core.h  |   1 +
>  drivers/gpu/drm/i915/display/intel_display_irq.c   |   8 +-
>  drivers/gpu/drm/i915/display/intel_display_types.h |   3 +
>  drivers/gpu/drm/i915/display/intel_dpcd.h          |  15 ++
>  drivers/gpu/drm/i915/display/intel_psr.c           |  60 ++++--
>  drivers/gpu/drm/i915/gem/i915_gem_ttm.c            |  28 +--
>  drivers/gpu/drm/xe/xe_guc_ads.c                    |   5 +
>  drivers/hid/hid-ids.h                              |   1 +
>  drivers/hid/hid-picolcd_cir.c                      |   1 +
>  drivers/hid/hid-quirks.c                           |   1 +
>  drivers/hid/wacom_sys.c                            |  13 +-
>  drivers/hid/wacom_wac.h                            |   1 +
>  drivers/hwmon/pmbus/adm1266.c                      |   7 +
>  drivers/hwmon/pmbus/pmbus.h                        |   5 +
>  drivers/hwmon/pmbus/pmbus_core.c                   |   8 +
>  drivers/i2c/busses/i2c-davinci.c                   |   2 +-
>  drivers/iio/adc/ad4695.c                           |  23 +--
>  drivers/iio/adc/mt6359-auxadc.c                    |   1 +
>  drivers/iio/adc/npcm_adc.c                         |  25 +--
>  drivers/iio/adc/viperboard_adc.c                   |   4 +-
>  drivers/iio/adc/xilinx-xadc-core.c                 |  11 +-
>  drivers/iio/buffer/industrialio-hw-consumer.c      |   4 +-
>  drivers/iio/chemical/mhz19b.c                      |  17 ++
>  drivers/iio/chemical/scd30_core.c                  |   2 +-
>  drivers/iio/common/ssp_sensors/ssp_dev.c           |   1 +
>  drivers/iio/dac/ad3530r.c                          |  54 +++--
>  drivers/iio/dac/ad5686.c                           |  56 ++++--
>  drivers/iio/dac/ad5686.h                           |   1 +
>  drivers/iio/dac/max5821.c                          |   9 +-
>  drivers/iio/gyro/adis16260.c                       |   3 +
>  drivers/iio/gyro/itg3200_buffer.c                  |   2 +-
>  drivers/iio/imu/adis16550.c                        |   2 +-
>  drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |   2 +-
>  drivers/iio/industrialio-buffer.c                  |   1 +
>  drivers/iio/inkern.c                               |   6 +-
>  drivers/iio/light/cm3323.c                         |   5 +-
>  drivers/iio/light/veml6070.c                       |  14 +-
>  drivers/iio/magnetometer/st_magn_core.c            |  13 +-
>  drivers/iio/pressure/bmp280-core.c                 |   2 +-
>  drivers/iio/temperature/tsys01.c                   |   2 +-
>  drivers/input/joystick/xpad.c                      |  14 +-
>  drivers/input/misc/ims-pcu.c                       |   2 +-
>  drivers/input/mouse/elan_i2c_core.c                |   5 +
>  drivers/input/mouse/synaptics.c                    |   1 +
>  drivers/input/touchscreen/atmel_mxt_ts.c           |   2 +-
>  drivers/input/touchscreen/usbtouchscreen.c         |   5 +
>  drivers/iommu/io-pgtable-arm-v7s.c                 |  18 +-
>  drivers/mailbox/mailbox.c                          |  15 +-
>  drivers/mailbox/tegra-hsp.c                        |   2 +-
>  drivers/md/bcache/super.c                          |   3 +-
>  drivers/media/cec/core/cec-core.c                  |   2 +-
>  drivers/media/common/siano/smsir.c                 |   1 +
>  drivers/media/i2c/ir-kbd-i2c.c                     |   2 +
>  drivers/media/pci/bt8xx/bttv-input.c               |   3 +-
>  drivers/media/pci/cx23885/cx23885-input.c          |   1 +
>  drivers/media/pci/cx88/cx88-input.c                |   3 +-
>  drivers/media/pci/dm1105/dm1105.c                  |   1 +
>  drivers/media/pci/mantis/mantis_input.c            |   1 +
>  drivers/media/pci/saa7134/saa7134-input.c          |   1 +
>  drivers/media/pci/smipcie/smipcie-ir.c             |   1 +
>  drivers/media/pci/ttpci/budget-ci.c                |   1 +
>  drivers/media/rc/ati_remote.c                      |   6 +-
>  drivers/media/rc/ene_ir.c                          |   2 +-
>  drivers/media/rc/fintek-cir.c                      |   3 +-
>  drivers/media/rc/igorplugusb.c                     |   3 +-
>  drivers/media/rc/iguanair.c                        |   1 +
>  drivers/media/rc/img-ir/img-ir-hw.c                |   3 +-
>  drivers/media/rc/img-ir/img-ir-raw.c               |   3 +-
>  drivers/media/rc/imon.c                            |   3 +-
>  drivers/media/rc/ir-hix5hd2.c                      |   2 +-
>  drivers/media/rc/ir_toy.c                          |   1 +
>  drivers/media/rc/ite-cir.c                         |   2 +-
>  drivers/media/rc/mceusb.c                          |   1 +
>  drivers/media/rc/rc-ir-raw.c                       |   5 -
>  drivers/media/rc/rc-loopback.c                     |   1 +
>  drivers/media/rc/rc-main.c                         |   6 +-
>  drivers/media/rc/redrat3.c                         |   4 +-
>  drivers/media/rc/st_rc.c                           |   2 +-
>  drivers/media/rc/streamzap.c                       |   7 +-
>  drivers/media/rc/sunxi-cir.c                       |   1 +
>  drivers/media/rc/ttusbir.c                         |   4 +-
>  drivers/media/rc/winbond-cir.c                     |   2 +-
>  drivers/media/rc/xbox_remote.c                     |   5 +-
>  drivers/media/usb/au0828/au0828-input.c            |   1 +
>  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |   1 +
>  drivers/media/usb/dvb-usb/dvb-usb-remote.c         |   6 +-
>  drivers/media/usb/em28xx/em28xx-input.c            |   1 +
>  drivers/misc/rp1/rp1_pci.c                         |   1 +
>  drivers/net/bonding/bond_main.c                    |   6 +
>  drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c  |   3 +
>  .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   2 +
>  .../mellanox/mlx5/core/steering/hws/fs_hws.c       |   4 +-
>  drivers/net/ethernet/microsoft/mana/mana_en.c      |  78 +++++---
>  drivers/net/macsec.c                               |   3 +-
>  drivers/net/phy/micrel.c                           |  15 +-
>  drivers/net/phy/mscc/mscc.h                        |   8 +-
>  drivers/net/phy/mscc/mscc_main.c                   |  23 +--
>  drivers/net/team/team_core.c                       |  51 +++--
>  drivers/net/team/team_mode_loadbalance.c           |   4 +-
>  drivers/net/tun.c                                  |   5 +-
>  drivers/net/vxlan/vxlan_core.c                     |   4 +-
>  drivers/net/wireguard/send.c                       |  20 +-
>  drivers/nfc/nxp-nci/i2c.c                          |  21 +-
>  drivers/nvme/host/tcp.c                            |   2 +-
>  drivers/parport/share.c                            |  11 +-
>  drivers/platform/x86/intel/vsec.c                  |  91 ++++-----
>  drivers/s390/cio/chsc.c                            |   4 +-
>  drivers/s390/cio/chsc_sch.c                        |  20 +-
>  drivers/s390/cio/scm.c                             |   2 +-
>  drivers/scsi/fcoe/fcoe_ctlr.c                      |   2 +-
>  drivers/scsi/scsi_lib.c                            |  27 ++-
>  drivers/scsi/scsi_transport_fc.c                   |  77 ++++----
>  drivers/spi/spi-mem.c                              |  15 +-
>  drivers/staging/gpib/cb7210/cb7210.c               |  10 +-
>  drivers/staging/media/av7110/av7110_ir.c           |   1 +
>  drivers/target/iscsi/iscsi_target.c                |   5 +-
>  drivers/target/iscsi/iscsi_target_auth.c           |  19 +-
>  drivers/target/iscsi/iscsi_target_nego.c           |   7 +-
>  drivers/target/iscsi/iscsi_target_parameters.c     |  62 ++++--
>  drivers/target/iscsi/iscsi_target_parameters.h     |   2 +-
>  drivers/thunderbolt/property.c                     |  32 ++-
>  drivers/tty/serdev/core.c                          |  21 ++
>  drivers/tty/serial/8250/8250_dw.c                  |   2 +-
>  drivers/tty/serial/8250/8250_port.c                |   7 +-
>  drivers/tty/serial/altera_jtaguart.c               |   7 +-
>  drivers/tty/serial/dz.c                            | 171 ++++++++--------
>  drivers/tty/serial/fsl_lpuart.c                    |  15 +-
>  drivers/tty/serial/pch_uart.c                      |  19 +-
>  drivers/tty/serial/qcom_geni_serial.c              |  16 +-
>  drivers/tty/serial/samsung_tty.c                   |   8 -
>  drivers/tty/serial/sh-sci.c                        |   2 +-
>  drivers/tty/serial/zs.c                            | 218 ++++++++-------=
------
>  drivers/tty/serial/zs.h                            |   1 -
>  drivers/usb/cdns3/cdns3-gadget.c                   |  12 +-
>  drivers/usb/cdns3/cdns3-plat.c                     |  11 +-
>  drivers/usb/chipidea/core.c                        |  16 +-
>  drivers/usb/class/cdc-acm.c                        |   2 -
>  drivers/usb/class/cdc-acm.h                        |   2 +
>  drivers/usb/class/usbtmc.c                         |  14 ++
>  drivers/usb/core/config.c                          |   9 +-
>  drivers/usb/core/quirks.c                          |   4 +
>  drivers/usb/dwc2/hcd.c                             |   4 +-
>  drivers/usb/dwc3/dwc3-xilinx.c                     |  27 +--
>  drivers/usb/gadget/composite.c                     |   5 +-
>  drivers/usb/gadget/function/f_fs.c                 |  26 ++-
>  drivers/usb/gadget/function/f_hid.c                |   3 +-
>  drivers/usb/gadget/function/f_uvc.c                |  28 ++-
>  drivers/usb/gadget/udc/dummy_hcd.c                 |   4 +
>  drivers/usb/gadget/udc/net2280.c                   |   4 +-
>  drivers/usb/host/xhci-tegra.c                      |  77 ++++----
>  drivers/usb/musb/omap2430.c                        |   3 +-
>  drivers/usb/serial/belkin_sa.c                     |   3 +
>  drivers/usb/serial/cypress_m8.c                    |  20 +-
>  drivers/usb/serial/digi_acceleport.c               |  23 ++-
>  drivers/usb/serial/keyspan.c                       |   4 +
>  drivers/usb/serial/mct_u232.c                      |  26 ++-
>  drivers/usb/serial/mxuport.c                       |   8 +
>  drivers/usb/serial/omninet.c                       |   9 +-
>  drivers/usb/serial/option.c                        |   9 +-
>  drivers/usb/serial/safe_serial.c                   |  11 ++
>  drivers/usb/storage/unusual_uas.h                  |   7 +
>  drivers/usb/typec/altmodes/displayport.c           |   2 +
>  drivers/usb/typec/tcpm/tcpci_maxim_core.c          |   9 +
>  drivers/usb/typec/tcpm/tcpm.c                      | 117 ++++++-----
>  drivers/usb/typec/tcpm/wcove.c                     |  13 +-
>  drivers/usb/typec/tipd/core.c                      |   1 +
>  drivers/usb/typec/ucsi/displayport.c               |   4 +
>  drivers/usb/typec/ucsi/ucsi.c                      |  24 ++-
>  drivers/usb/typec/ucsi/ucsi_ccg.c                  |   5 +
>  drivers/usb/usbip/vudc_dev.c                       |   1 +
>  drivers/usb/usbip/vudc_transfer.c                  |   3 +-
>  fs/hpfs/alloc.c                                    |   2 +-
>  fs/smb/client/cifsacl.c                            | 116 ++++++++---
>  fs/smb/client/smb2pdu.c                            |   2 +-
>  fs/smb/server/smb2pdu.c                            |  11 ++
>  fs/smb/server/smbacl.c                             |   8 +-
>  include/kunit/test.h                               |   1 +
>  include/linux/compat.h                             |   4 +
>  include/linux/compiler-clang.h                     |   6 +
>  include/linux/compiler_attributes.h                |  11 ++
>  include/linux/compiler_types.h                     |   4 +
>  include/linux/hid.h                                |   2 -
>  include/linux/if_team.h                            |   3 +-
>  include/linux/intel_vsec.h                         |   4 +-
>  include/linux/mailbox_controller.h                 |   3 +
>  include/linux/parport.h                            |   1 +
>  include/linux/serdev.h                             |   1 +
>  include/linux/serial_core.h                        |  12 ++
>  include/linux/syscalls.h                           |   4 +
>  include/media/rc-core.h                            |   2 -
>  include/net/netfilter/nf_tables.h                  |   7 +
>  include/net/xfrm.h                                 |   3 +-
>  ipc/util.c                                         |   2 +-
>  kernel/fork.c                                      |  11 +-
>  lib/debugobjects.c                                 |   2 +-
>  lib/kunit/executor.c                               |  19 +-
>  lib/kunit/test.c                                   |   1 +
>  mm/damon/sysfs-schemes.c                           |   8 +-
>  mm/memcontrol.c                                    |   6 +
>  mm/memfd.c                                         |  12 +-
>  mm/rmap.c                                          |   2 +
>  mm/slab_common.c                                   |   2 +
>  mm/slub.c                                          |   1 +
>  net/bluetooth/6lowpan.c                            |   2 +
>  net/bluetooth/hci_conn.c                           |   4 +-
>  net/bluetooth/hci_sync.c                           |  16 +-
>  net/bluetooth/hidp/core.c                          |  23 ++-
>  net/bluetooth/iso.c                                |  12 +-
>  net/bluetooth/l2cap_core.c                         |  41 +++-
>  net/bluetooth/l2cap_sock.c                         |  16 +-
>  net/bridge/br_netlink.c                            |  17 +-
>  net/bridge/br_switchdev.c                          |   1 -
>  net/bridge/br_sysfs_if.c                           |  30 ++-
>  net/bridge/netfilter/ebtables.c                    |  30 +++
>  net/core/devmem.c                                  |  11 ++
>  net/core/filter.c                                  |   2 +-
>  net/core/skbuff.c                                  |  45 ++++-
>  net/ethtool/cmis.h                                 |   4 +-
>  net/ethtool/cmis_cdb.c                             |   9 +-
>  net/ethtool/cmis_fw_update.c                       |  44 +++--
>  net/ethtool/coalesce.c                             |   6 +
>  net/ethtool/eeprom.c                               |  10 +-
>  net/ethtool/linkstate.c                            |   6 +-
>  net/ethtool/module.c                               |  41 ++--
>  net/ethtool/netlink.c                              |   4 +-
>  net/ethtool/netlink.h                              |   4 +-
>  net/ethtool/pse-pd.c                               |  10 +-
>  net/ethtool/rss.c                                  |  37 ++--
>  net/ethtool/strset.c                               |   2 +-
>  net/ethtool/tsconfig.c                             |  15 +-
>  net/ethtool/tsinfo.c                               |  19 +-
>  net/handshake/genl.c                               |   3 +-
>  net/handshake/genl.h                               |   1 +
>  net/handshake/handshake-test.c                     |   2 +-
>  net/handshake/handshake.h                          |   4 +-
>  net/handshake/netlink.c                            |   6 +-
>  net/handshake/request.c                            |  16 +-
>  net/handshake/tlshd.c                              |   6 +-
>  net/hsr/hsr_forward.c                              |   4 +-
>  net/ipv4/ah4.c                                     |   2 +-
>  net/ipv4/esp4.c                                    |   4 +-
>  net/ipv4/ip_tunnel_core.c                          |  22 ++-
>  net/ipv4/sysctl_net_ipv4.c                         |   2 +-
>  net/ipv6/ah6.c                                     |   2 +-
>  net/ipv6/datagram.c                                |  54 ++++-
>  net/ipv6/esp6.c                                    |   4 +-
>  net/ipv6/exthdrs.c                                 |   6 +-
>  net/ipv6/ip6_vti.c                                 |  23 ++-
>  net/ipv6/route.c                                   |   5 +
>  net/iucv/af_iucv.c                                 |  20 +-
>  net/key/af_key.c                                   |   6 +-
>  net/l2tp/l2tp_core.c                               |  11 +-
>  net/mctp/device.c                                  |   1 +
>  net/mctp/neigh.c                                   |   1 +
>  net/mctp/route.c                                   |   1 +
>  net/mptcp/fastopen.c                               |   4 +-
>  net/mptcp/mib.c                                    |   1 -
>  net/mptcp/mib.h                                    |   1 -
>  net/mptcp/protocol.c                               |  65 ++++--
>  net/mptcp/protocol.h                               |  31 ++-
>  net/mptcp/subflow.c                                |   8 +-
>  net/netfilter/nf_conntrack_proto_tcp.c             |   3 +-
>  net/netfilter/nf_synproxy_core.c                   |   2 +
>  net/netfilter/nft_bitwise.c                        |  18 +-
>  net/netfilter/nft_byteorder.c                      |  13 +-
>  net/netfilter/xt_cpu.c                             |   2 +-
>  net/netlink/af_netlink.c                           |  11 +-
>  net/nfc/hci/core.c                                 |  10 +
>  net/nfc/llcp_core.c                                |  11 ++
>  net/nfc/llcp_sock.c                                |   2 +
>  net/nfc/nci/hci.c                                  |  10 +
>  net/rxrpc/ar-internal.h                            |  14 +-
>  net/rxrpc/call_event.c                             |  22 +--
>  net/rxrpc/call_object.c                            |   2 +
>  net/rxrpc/conn_event.c                             |  30 ++-
>  net/rxrpc/insecure.c                               |   8 +-
>  net/rxrpc/recvmsg.c                                |  68 +++++--
>  net/rxrpc/rxgk.c                                   | 147 ++++++--------
>  net/rxrpc/rxgk_app.c                               |  46 ++---
>  net/rxrpc/rxgk_common.h                            |  66 +++----
>  net/rxrpc/rxkad.c                                  | 115 ++++-------
>  net/sched/cls_fw.c                                 |   6 +-
>  net/sched/sch_netem.c                              |  40 ----
>  net/sched/sch_sfb.c                                |   2 +-
>  net/sctp/socket.c                                  |   2 +
>  net/smc/af_smc.c                                   |   4 +-
>  net/vmw_vsock/af_vsock.c                           |  49 +++--
>  net/vmw_vsock/hyperv_transport.c                   |   9 +-
>  net/vmw_vsock/virtio_transport_common.c            |  26 ++-
>  net/vmw_vsock/vmci_transport.c                     |   8 +-
>  net/xfrm/xfrm_input.c                              |  16 +-
>  net/xfrm/xfrm_ipcomp.c                             |  12 +-
>  net/xfrm/xfrm_iptfs.c                              |  29 ++-
>  net/xfrm/xfrm_policy.c                             |  17 +-
>  net/xfrm/xfrm_state.c                              |  23 ++-
>  net/xfrm/xfrm_user.c                               |   5 +-
>  sound/core/oss/pcm_oss.c                           |  18 +-
>  .../motu/motu-register-dsp-message-parser.c        |  11 +-
>  sound/hda/codecs/realtek/alc269.c                  |   1 +
>  sound/soc/codecs/simple-mux.c                      |   2 +-
>  sound/soc/intel/boards/bytcht_es8316.c             |  29 ++-
>  sound/soc/qcom/qdsp6/q6asm-dai.c                   |  43 ++--
>  sound/usb/mixer_scarlett2.c                        |  33 +++-
>  tools/bootconfig/main.c                            |   4 +-
>  tools/testing/cxl/test/cxl.c                       | 105 ++++------
>  tools/testing/selftests/net/mptcp/mptcp_connect.sh |   6 +-
>  tools/testing/selftests/net/mptcp/mptcp_lib.sh     |  10 +-
>  346 files changed, 3284 insertions(+), 1733 deletions(-)
>=20
>=20

--=20

--qHeIyAqtDGI99tvc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaiWjTAAKCRAw5/Bqldv6
8nQiAJ9bcmoNdDkKRTFv56kuijikTg5GZACgpwRP/yE/UOnBsWmtIoX3+P0gLo0=
=4/sm
-----END PGP SIGNATURE-----

--qHeIyAqtDGI99tvc--
