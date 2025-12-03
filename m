Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0150A357736;
	Wed,  3 Dec 2025 16:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778715; cv=none; b=UOOemaaLQr0G9yBUmywValtbhGQ8pWAR7wEpF+66Q41SPztRoh6cuY8deVM0Mote3c2AB0eseTvZHtTqGf2qQDGrVU18tGUnHVbhrNhY+/YbFrUaisOTMRRJPyD9wBQ9G4/4X2ccd7f6t9cXoSpkYN7CG3iI/coHqCFh0ANEtdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778715; c=relaxed/simple;
	bh=JCXTiS2dPcUsCP06PU9hWNFiIwfGEVjgf/yplh4HxUs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aM/j9CLrnezWZGxH5Hha+Y7fqnM8Szk/WaiprNsc+k6Ee/0YfZn1qOz2f42GdzBxP/YiA5sCGfSov7Blw/LQHJr12UNn2u8bXZsREdv9/aFvfXqwFXkgClj4cRgvUNlVxTLicT10Df5+G3hgo3JGwu3jXs4KoFuRnNwUbOptFvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOG1ujAj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOG1ujAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B23C4CEF5;
	Wed,  3 Dec 2025 16:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778714;
	bh=JCXTiS2dPcUsCP06PU9hWNFiIwfGEVjgf/yplh4HxUs=;
	h=From:To:Cc:Subject:Date:From;
	b=GOG1ujAjvH6dEN+Vxbq2ZLGIg9BJwyRaZyL3oSC8pHFrzgkYlFqXM4n0J+GiyEXS/
	 gxEakxvhliEbAHFFIgXUFJ9UkCNgj9UtkqhWWcHN/zKsFnfFWhrD1Z3e0dXJmrWS9r
	 EAlrkav2AfJTYYhrRqT5ZiIfyMmNzc+vQlAGnglc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.1 000/568] 6.1.159-rc1 review
Date: Wed,  3 Dec 2025 16:20:02 +0100
Message-ID: <20251203152440.645416925@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.159-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.159-rc1
X-KernelTest-Deadline: 2025-12-05T15:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.159 release.
There are 568 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.159-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.159-rc1

Alan Stern <stern@rowland.harvard.edu>
    HID: core: Harden s32ton() against conversion to 0 bits

Sudeep Holla <sudeep.holla@arm.com>
    i2c: xgene-slimpro: Migrate to use generic PCC shmem related macros

Igor Pylypiv <ipylypiv@google.com>
    scsi: pm80xx: Set phy->enable_completion only when we

Jimmy Hu <hhhuuu@google.com>
    usb: gadget: udc: fix use-after-free in usb_gadget_state_work

Kuen-Han Tsai <khtsai@google.com>
    usb: udc: Add trace event for usb_gadget_set_state

Jameson Thies <jthies@google.com>
    usb: typec: ucsi: psy: Set max current to zero when disconnected

Sean Heelan <seanheelan@gmail.com>
    ksmbd: fix use-after-free in session logoff

Philipp Hortmann <philipp.g.hortmann@gmail.com>
    staging: rtl8712: Remove driver using deprecated API wext

Jiayuan Chen <jiayuan.chen@linux.dev>
    mptcp: Fix proto fallback detection with BPF

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix duplicate reset on fastclose

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: endpoints: longer transfer

luoguangfei <15388634752@163.com>
    net: macb: fix unregister_netdev call order in macb_remove()

ChiYuan Huang <cy_huang@richtek.com>
    iio: adc: rtq6056: Correct the sign bit index

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    usb: renesas_usbhs: Fix synchronous external abort on unbind

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: renesas_usbhs: Convert to platform remove callback returning void

NeilBrown <neil@brown.name>
    nfsd: Replace clamp_t in nfsd4_get_drc_mem()

ziming zhang <ezrakiez@gmail.com>
    libceph: replace BUG_ON with bounds check for map->max_osd

ziming zhang <ezrakiez@gmail.com>
    libceph: prevent potential out-of-bounds writes in handle_auth_session_key()

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix potential use-after-free in have_mon_and_osd_map()

Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
    net: dsa: microchip: common: Fix checks on irq_find_mapping()

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check NULL before accessing

Johan Hovold <johan@kernel.org>
    drm: sti: fix device leaks at component probe

Vanillan Wang <vanillanwang@163.com>
    USB: serial: option: add support for Rolling RW101R-GL

Oleksandr Suvorov <cryosay@gmail.com>
    USB: serial: ftdi_sio: add support for u-blox EVK-M101

Łukasz Bartosik <ukaszb@chromium.org>
    xhci: dbgtty: fix device unregister

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbgtty: Fix data corruption when transmitting data form DbC to host

Manish Nagar <manish.nagar@oss.qualcomm.com>
    usb: dwc3: Fix race condition between concurrent dwc3_remove_requests() call paths

Owen Gu <guhuinan@xiaomi.com>
    usb: uas: fix urb unmapping issue when the uas device is remove during ongoing data transfer

Tianchu Chen <flynnnchen@tencent.com>
    usb: storage: sddr55: Reject out-of-bound new_pba

Alan Stern <stern@rowland.harvard.edu>
    USB: storage: Remove subclass and protocol overrides from Novatek quirk

Desnes Nunes <desnesn@redhat.com>
    usb: storage: Fix memory leak in USB bulk transport

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_eem: Fix memory leak in eem_unwrap

Miaoqian Lin <linmq006@gmail.com>
    usb: cdns3: Fix double resource release in cdns3_pci_probe

Johan Hovold <johan@kernel.org>
    most: usb: fix double free on late probe failure

Miaoqian Lin <linmq006@gmail.com>
    serial: amba-pl011: prefer dma_mapping_error() over explicit address checking

Khairul Anuar Romli <khairul.anuar.romli@altera.com>
    firmware: stratix10-svc: fix bug in saving controller data

Miaoqian Lin <linmq006@gmail.com>
    slimbus: ngd: Fix reference count leak in qcom_slim_ngd_notify_slaves

Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
    thunderbolt: Add support for Intel Wildcat Lake

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix memory leak in cifs_construct_tcon()

Jamie Iles <jamie.iles@oss.qualcomm.com>
    drivers/usb/dwc3: fix PCI parent check

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: fix unreliable memory allocation

Marc Kleine-Budde <mkl@pengutronix.de>
    can: sun4i_can: sun4i_can_interrupt(): fix max irq loop handling

Thomas Mühlbacher <tmuehlbacher@posteo.net>
    can: sja1000: fix max irq loop handling

Gui-Dong Han <hanguidong02@gmail.com>
    atm/fore200e: Fix possible data race in fore200e_open()

Ivan Zhaldak <i.v.zhaldak@gmail.com>
    ALSA: usb-audio: Add DSD quirk for LEAK Stereo 230

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: mm: kmalloc tlb_vpn array to avoid stack overflow

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: mm: Prevent a TLB shutdown on initial uniquification

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7280a: fix ad7280_store_balance_timer()

Valek Andrej <andrej.v@skyrain.eu>
    iio: accel: fix ADXL355 startup race condition

Linus Walleij <linus.walleij@linaro.org>
    iio: accel: bmc150: Fix irq assumption regression

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio:common:ssp_sensors: Fix an error handling path ssp_probe()

Francesco Lavra <flavra@baylibre.com>
    iio: imu: st_lsm6dsx: fix array size for st_lsm6dsx_settings fields

Jiri Olsa <jolsa@kernel.org>
    Revert "perf/x86: Always store regs->ip in perf_callchain_kernel()"

Hang Zhou <929513338@qq.com>
    spi: bcm63xx: fix premature CS deassertion on RX-only transactions

Jamie Iles <jamie.iles@oss.qualcomm.com>
    mailbox: pcc: don't zero error register

Sudeep Holla <sudeep.holla@arm.com>
    mailbox: pcc: Refactor error handling in irq handler into separate function

Adam Young <admiyo@os.amperecomputing.com>
    mailbox: pcc: Check before sending MCTP PCC response ACK

Sudeep Holla <sudeep.holla@arm.com>
    ACPI: PCC: Add PCC shared memory region command and status bitfields

Huisong Li <lihuisong@huawei.com>
    mailbox: pcc: Support shared interrupt for multiple subspaces

Huisong Li <lihuisong@huawei.com>
    mailbox: pcc: Add support for platform notification handling

Elliot Berman <quic_eberman@quicinc.com>
    mailbox: pcc: Use mbox_bind_client

Elliot Berman <quic_eberman@quicinc.com>
    mailbox: Allow direct registration to a channel

Haotian Zhang <vulab@iscas.ac.cn>
    mailbox: mailbox-test: Fix debugfs_create_dir error checking

Jiefeng Zhang <jiefeng.z.zhang@gmail.com>
    net: atlantic: fix fragment overflow handling in RX path

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: fix SGMII linking at 10M or 100M but not passing traffic

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: dsa: sja1105: simplify static configuration reload

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix cyan_skillfish2 gpu info fw handling

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    net: sxgbe: fix potential NULL dereference in sxgbe_rx()

Danielle Costantino <dcostantino@meta.com>
    net/mlx5e: Fix validation logic in rate limiting

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix the initialization of taprio

Kai-Heng Feng <kaihengf@nvidia.com>
    net: aquantia: Add missing descriptor cache invalidation on ATL2

Dan Carpenter <dan.carpenter@linaro.org>
    platform/x86: intel: punit_ipc: fix memory corruption

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SMP: Fix not generating mackey and ltk when repairing

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_receive_bulk_callback(): check actual_length before accessing header

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_xmit_callback(): fix handling of failed transmitted URBs

Seungjin Bae <eeodqql09@gmail.com>
    can: kvaser_usb: leaf: Fix potential infinite loop in command parsers

Kiryl Shutsemau <kas@kernel.org>
    mm/memory: do not populate page table entries beyond i_size

Pankaj Raghav <p.raghav@samsung.com>
    filemap: cap PTE range to be created to allowed zero fill in folio_map_range()

Miaoqian Lin <linmq006@gmail.com>
    pmdomain: imx: Fix reference count leak in imx_gpc_remove

Sudeep Holla <sudeep.holla@arm.com>
    pmdomain: arm: scmi: Fix genpd leak on provider registration failure

André Draszik <andre.draszik@linaro.org>
    pmdomain: samsung: plug potential memleak during probe

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: fix fallback note due to OoO

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: rm: set backup flag

Mario Limonciello (AMD) <superm1@kernel.org>
    HID: amd_sfh: Stop sensor before starting

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: Fix system suspend for a security locked drive

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: pinctrl: toshiba,visconti: Fix number of items in groups

Vlastimil Babka <vbabka@suse.cz>
    mm/mempool: fix poisoning order>0 pages with HIGHMEM

Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
    mm/mempool: replace kmap_atomic() with kmap_local_page()

Eric Dumazet <edumazet@google.com>
    mptcp: fix a race in mptcp_pm_del_add_timer()

Paolo Abeni <pabeni@redhat.com>
    mptcp: decouple mptcp fastclose from tcp close

Martin Kaiser <martin@kaiser.cx>
    maple_tree: fix tracepoint string pointers

Kiryl Shutsemau <kas@kernel.org>
    mm/truncate: unmap large folio on split failure

Long Li <longli@microsoft.com>
    uio_hv_generic: Set event for all channels on the device

Zhang Chujun <zhangchujun@cmss.chinamobile.com>
    tracing/tools: Fix incorrcet short option in usage text for --threads

Nishanth Menon <nm@ti.com>
    net: ethernet: ti: netcp: Standardize knav_dma_open_channel to return NULL on error

René Rebe <rene@exactco.de>
    ALSA: usb-audio: fix uac2 clock source at terminal parser

Isaac J. Manjarres <isaacmanjarres@google.com>
    mm/mm_init: fix hash table order logging in alloc_large_system_hash()

Lance Yang <lance.yang@linux.dev>
    mm/secretmem: fix use-after-free race in fault handler

Jakub Horký <jakub.git@horky.net>
    kconfig/nconf: Initialize the default locale at startup

Jakub Horký <jakub.git@horky.net>
    kconfig/mconf: Initialize the default locale at startup

Shahar Shitrit <shshitrit@nvidia.com>
    net: tls: Cancel RX async resync request on rcd_delta overflow

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: net: use BASH for bareudp testing

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Fix a regression triggered by scsi_host_busy()

Steve French <stfrench@microsoft.com>
    cifs: fix typo in enable_gcm_256 module parameter

Rafał Miłecki <rafal@milecki.pl>
    bcma: don't register devices disabled in OF

Michal Luczaj <mhal@rbox.co>
    vsock: Ignore signal/timeout on connect() if already established

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    net: qlogic/qede: fix potential out-of-bounds read in qede_tpa_cont() and qede_tpa_end()

Alejandro Colomar <alx@kernel.org>
    kernel.h: Move ARRAY_SIZE() to a separate header

Haotian Zhang <vulab@iscas.ac.cn>
    platform/x86/intel/speed_select_if: Convert PCIBIOS_* return codes to errnos

Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
    s390/ctcm: Fix double-kfree

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    nvme-multipath: fix lockdep WARN due to partition scan work

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: remove never-working support for setting nsh fields

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    net: mlxsw: linecards: fix missing error check in mlxsw_linecard_devlink_info_get()

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    net: dsa: hellcreek: fix missing error handling in LED registration

Prateek Agarwal <praagarwal@nvidia.com>
    drm/tegra: Add call to put_pid()

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Select context device based on attached IOMMU

Zilin Guan <zilin@seu.edu.cn>
    mlxsw: spectrum: Fix memory leak in mlxsw_sp_flower_stats()

Jianbo Liu <jianbol@nvidia.com>
    xfrm: Determine inner GSO type from packet inner protocol

Yifan Zha <Yifan.Zha@amd.com>
    drm/amdgpu: Skip emit de meta data on gfx11 with rs64 enabled

Ma Ke <make24@iscas.ac.cn>
    drm/tegra: dc: Fix reference leak in tegra_dc_couple()

Paolo Abeni <pabeni@redhat.com>
    mptcp: do not fallback when OoO is present

Paolo Abeni <pabeni@redhat.com>
    mptcp: avoid unneeded subflow-level drops

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix premature close in case of fallback

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix ack generation for fallback msk

Eric Dumazet <edumazet@google.com>
    mptcp: fix race condition in mptcp_schedule_work()

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Don't panic if no valid cache info for PCI

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Malta: Fix !EVA SOC-it PCI MMIO

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    scsi: target: tcm_loop: Fix segfault in tcm_loop_tpg_address_show()

Bart Van Assche <bvanassche@acm.org>
    scsi: sg: Do not sleep in atomic context

Ewan D. Milne <emilne@redhat.com>
    nvme: nvme-fc: Ensure ->ioerr_work is cancelled in nvme_fc_delete_ctrl()

Seungjin Bae <eeodqql09@gmail.com>
    Input: pegasus-notetaker - fix potential out-of-bounds access

Dan Carpenter <dan.carpenter@linaro.org>
    Input: imx_sc_key - fix memory corruption on unload

Tzung-Bi Shih <tzungbi@kernel.org>
    Input: cros_ec_keyb - fix an invalid memory access

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: microchip: lan937x: Fix RGMII delay tuning

Andrey Vatoropin <a.vatoropin@crpt.ru>
    be2net: pass wrb_params in case of OS2BMC

Yihang Li <liyihang9@h-partners.com>
    ata: libata-scsi: Add missing scsi_device_put() in ata_scsi_dev_rescan()

Jiayuan Chen <jiayuan.chen@linux.dev>
    mptcp: Disallow MPTCP subflows from sockmap

Yongpeng Yang <yangyongpeng@xiaomi.com>
    exfat: check return value of sb_min_blocksize in exfat_read_boot_sector

Dan Carpenter <dan.carpenter@linaro.org>
    mtdchar: fix integer overflow in read/write ioctls

Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
    mtd: rawnand: cadence: fix DMA device NULL pointer dereference

Zhang Heng <zhangheng@kylinos.cn>
    HID: quirks: work around VID/PID conflict for 0x4c4a/0x4155

Yipeng Zou <zouyipeng@huawei.com>
    timers: Fix NULL function pointer race in timer_shutdown_sync()

Armen Ratner <armeng@nvidia.com>
    net/mlx5e: Preserve shared buffer capacity during headroom updates

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5e: Do not update SBCM when prio2buffer command is invalid

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: act_connmark: handle errno on tcf_idr_check_alloc

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Fix memory leak in error flow of port set buffer

Arnd Bergmann <arnd@arndb.de>
    asm-generic: partially revert "Unify uapi bitsperlong.h for arm64, riscv and loongarch"

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    isdn: mISDN: hfcsusb: fix memory leak in hfcsusb_probe()

Michal Hocko <mhocko@suse.com>
    mm, percpu: do not consider sleepable allocations atomic

Nam Cao <namcao@linutronix.de>
    eventpoll: Replace rwlock with spinlock

Breno Leitao <leitao@debian.org>
    net: netpoll: fix incorrect refcount handling causing incorrect cleanup

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: SVM: Mark VMCB_LBR dirty when MSR_IA32_DEBUGCTLMSR is updated

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Don't overflow during division for dirty tracking

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: core: Add a quirk to suppress link_startup_again

Bui Quang Minh <minhquangbui99@gmail.com>
    virtio-net: fix received length check in big packets

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: trunc: read all recv data

Filipe Manana <fdmanana@suse.com>
    btrfs: do not update last_log_commit when logging inode due to a new name

Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
    EDAC/altera: Use INTTEST register for Ethernet and USB SBE injection

Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
    EDAC/altera: Handle OCRAM ECC enable after warm reset

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Use physical addresses for CSR_MERRENTRY/CSR_TLBRENTRY

Hans de Goede <hansg@kernel.org>
    spi: Try to get ACPI GPIO IRQ earlier

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix potential overflow of PCM transfer buffer

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: sdhci-of-dwcmshc: Change DLL_STRBIN_TAPNUM_DEFAULT to 0x4

Wei Yang <albinwyang@tencent.com>
    fs/proc: fix uaf in proc_readdir_de()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: reject address change while connecting

Chuang Wang <nashuiliang@gmail.com>
    ipv4: route: Prevent rt_bind_exception() from rebinding stale fnhe

Tianyang Zhang <zhangtianyang@loongson.cn>
    LoongArch: Let {pte,pmd}_modify() record the status of _PAGE_DIRTY

Qinxin Xia <xiaqinxin@huawei.com>
    dma-mapping: benchmark: Restore padding to ensure uABI remained consistent

Nate Karstens <nate.karstens@garmin.com>
    strparser: Fix signed/unsigned mismatch bug

Joshua Rogers <linux@joshua.hu>
    ksmbd: close accepted socket when per-IP limit rejects connection

Peter Oberparleiter <oberpar@linux.ibm.com>
    gcov: add support for GCC 15

Olga Kornievskaia <okorniev@redhat.com>
    NFSD: free copynotify stateid in nfs4_free_ol_stateid()

Masami Ichikawa <masami256@gmail.com>
    HID: hid-ntrig: Prevent memory leak in ntrig_report_version()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: reject duplicate device on updates

Dan Carpenter <dan.carpenter@linaro.org>
    mtd: onenand: Pass correct pointer to IRQ handler

Tiezhu Yang <yangtiezhu@loongson.cn>
    asm-generic: Unify uapi bitsperlong.h for arm64, riscv and loongarch

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN

Sabrina Dubroca <sd@queasysnail.net>
    espintcp: fix skb leaks

Arseniy Krasnov <avkrasnov@salutedevices.com>
    Bluetooth: hci_sync: fix double free in 'hci_discovery_filter_clear()'

Sumanth Gavini <sumanth.gavini@yahoo.com>
    softirq: Add trace points for tasklet entry/exit

Eric Dumazet <edumazet@google.com>
    bpf: Add bpf_prog_run_data_pointers()

Haein Lee <lhi0729@kaist.ac.kr>
    ALSA: usb-audio: Fix NULL pointer dereference in snd_usb_mixer_controls_badd

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix an incorrect parameter when calling nfs4_call_sync()

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Validate command header size against SVGA_CMD_MAX_DATASIZE

Haotian Zhang <vulab@iscas.ac.cn>
    ASoC: codecs: va-macro: fix resource leak in probe error path

Haotian Zhang <vulab@iscas.ac.cn>
    ASoC: cs4271: Fix regulator leak on probe failure

Haotian Zhang <vulab@iscas.ac.cn>
    regulator: fixed: fix GPIO descriptor leak on register failure

Shuai Xue <xueshuai@linux.alibaba.com>
    acpi,srat: Fix incorrect device handle check for Generic Initiator

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: export l2cap_chan_hold for modules

Gautham R. Shenoy <gautham.shenoy@amd.com>
    ACPI: CPPC: Limit perf ctrs in PCC check only to online CPUs

Gautham R. Shenoy <gautham.shenoy@amd.com>
    ACPI: CPPC: Perform fast check switch only for online CPUs

Gautham R. Shenoy <gautham.shenoy@amd.com>
    ACPI: CPPC: Check _CPC validity for only the online CPUs

Felix Maurer <fmaurer@redhat.com>
    hsr: Fix supervision frame sending on HSRv0

Eric Dumazet <edumazet@google.com>
    net_sched: limit try_bulk_dequeue_skb() batches

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix potentially misleading debug message

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Remove mlx5e_dbg() and msglvl support

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5e: Consider internal buffers size in port buffer calculations

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5e: Update shared buffer along with device buffer changes

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5e: Add API to query/modify SBPR and SBCM registers

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Expose shared buffer registers bits and structs

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix wraparound in rate limiting for values above 255 Gbps

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix maxrate wraparound in threshold between units

Ranganath V N <vnranganath.20@gmail.com>
    net: sched: act_ife: initialize struct tc_ife to fix KMSAN kernel-infoleak

Ranganath V N <vnranganath.20@gmail.com>
    net: sched: act_connmark: initialize struct tc_ife to fix kernel leak

Eric Dumazet <edumazet@google.com>
    net_sched: act_connmark: use RCU in tcf_connmark_dump()

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: act_connmark: transition to percpu stats and rcu

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Initialise scc_index in unix_add_edge().

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211: skip rate verification for not captured PSDUs

Buday Csaba <buday.csaba@prolan.hu>
    net: mdio: fix resource leak in mdiobus_register_device()

Kuniyuki Iwashima <kuniyu@google.com>
    tipc: Fix use-after-free in tipc_mon_reinit_self().

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix mismatch between CLC header and proposal

Eric Dumazet <edumazet@google.com>
    sctp: prevent possible shift-out-of-bounds in sctp_transport_update_rto

Pauli Virtanen <pav@iki.fi>
    Bluetooth: 6lowpan: Don't hold spin lock over sleeping functions

Pauli Virtanen <pav@iki.fi>
    Bluetooth: 6lowpan: fix BDADDR_LE vs ADDR_LE_DEV address type confusion

Pauli Virtanen <pav@iki.fi>
    Bluetooth: 6lowpan: reset link-local header on ipv6 recv path

Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
    Bluetooth: btusb: reorder cleanup in btusb_disconnect to avoid UAF

Pauli Virtanen <pav@iki.fi>
    Bluetooth: MGMT: cancel mesh send timer when hdev removed

Wei Fang <wei.fang@nxp.com>
    net: fec: correct rx_bytes statistic for the case SHIFT16 is set

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    selftests: net: local_termination: Wait for interfaces to come up

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath11k: zero init info->status in wmi_process_mgmt_tx_comp()

Abinaya Kalaiselvan <quic_akalaise@quicinc.com>
    wifi: ath11k: Add tx ack signal support for management packets

Sharique Mohammad <sharq0406@gmail.com>
    ASoC: max98090/91: fixed max98091 ALSA widget powering up/down

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix possible refcount leak in smb2_sess_setup()

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix possible memory leak in smb2_read()

Scott Mayhew <smayhew@redhat.com>
    NFS: check if suid/sgid was cleared after a write as needed

Tristan Lobb <tristan.lobb@it-lobb.de>
    HID: quirks: avoid Cooler Master MM712 dongle wakeup bug

Joshua Watt <jpewhacker@gmail.com>
    NFS4: Fix state renewals missing after boot

Jesse.Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: Fix NULL pointer dereference in VRAM logic for APU devices

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Disable MCLK switching on SI at high pixel clocks

Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>
    RISC-V: clear hot-unplugged cores from all task mm_cpumasks to avoid rfence errors

Peter Zijlstra <peterz@infradead.org>
    compiler_types: Move unused static inline functions warning to W=2

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Fix suspend failure with secure display TA

Shuhao Fu <sfual@cse.ust.hk>
    smb: client: fix refcount leak in smb2_set_path_attr

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    drm/i915: Fix conversion between clock ticks and nanoseconds

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915: Avoid lock inversion when pinning to GGTT on CHV/BXT+VTD

Jakub Kicinski <kuba@kernel.org>
    selftests: netdevsim: set test timeout to 10 minutes

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix function header names in amdgpu_connectors.c

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    extcon: adc-jack: Cleanup wakeup source only if it was enabled

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers

Nathan Chancellor <nathan@kernel.org>
    lib/crypto: curve25519-hacl64: Fix older clang KASAN workaround for GCC

Joshua Rogers <linux@joshua.hu>
    smb: client: validate change notify buffer before copy

Yuta Hayama <hayama@lineo.co.jp>
    rtc: rx8025: fix incorrect register reference

Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
    Bluetooth: MGMT: Fix OOB access in parse_adv_monitor_pattern()

Zilin Guan <zilin@seu.edu.cn>
    tracing: Fix memory leaks in create_field_var()

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: fix MST static key usage

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: fix use-after-free due to MST port state bypass

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: Fix reserved multicast address table programming

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: SHAMPO, Fix skb size check for 64K pages

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    bnxt_en: Fix a possible memory leak in bnxt_ptp_init

Qendrim Maxhuni <qendrim.maxhuni@garderos.com>
    net: usb: qmi_wwan: initialize MAC header offset in qmimux_rx_fixup

Stefan Wiehler <stefan.wiehler@nokia.com>
    sctp: Hold sock lock while iterating over address list

Stefan Wiehler <stefan.wiehler@nokia.com>
    sctp: Prevent TOCTOU out-of-bounds write

Stefan Wiehler <stefan.wiehler@nokia.com>
    sctp: Hold RCU read lock while iterating over address list

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: stop reading ARL entries if search is done

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix enabling ip multicast

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix resetting speed and pause on forced link

Hangbin Liu <liuhangbin@gmail.com>
    net: vlan: sync VLAN features with lower device

Wang Liang <wangliang74@huawei.com>
    selftests: netdevsim: Fix ethtool-coalesce.sh fail by installing ethtool-common.sh

David Wei <dw@davidwei.uk>
    netdevsim: add Makefile for selftests

Anubhav Singh <anubhavsinggh@google.com>
    selftests/net: use destination options instead of hop-by-hop

Richard Gobert <richardbgobert@gmail.com>
    selftests/net: fix GRO coalesce test and add ext header coalesce tests

Anubhav Singh <anubhavsinggh@google.com>
    selftests/net: fix out-of-order delivery of FIN in gro:tcp test

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: tag_brcm: legacy: fix untagged rx on unbridged ports for bcm63xx

Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
    Bluetooth: hci_event: validate skb length for unknown CC opcode

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    Revert "wifi: ath10k: avoid unnecessary wait for service ready message"

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Audio disappears on HP 15-fc000 after warm boot again

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: add checking of wait_for_completion_killable() return value

Valerio Setti <vsetti@baylibre.com>
    ASoC: meson: aiu-encoder-i2s: fix bit clock polarity

Geert Uytterhoeven <geert@linux-m68k.org>
    kbuild: uapi: Strip comments before size type check

Albin Babu Varghese <albinbabuvarghese20@gmail.com>
    fbdev: Add bounds checking in bit_putcs to fix vmalloc-out-of-bounds

Sascha Hauer <s.hauer@pengutronix.de>
    tools: lib: thermal: use pkg-config to locate libnl3

Emil Dahl Juhl <juhl.emildahl@gmail.com>
    tools: lib: thermal: don't preserve owner in install

Ian Rogers <irogers@google.com>
    tools bitmap: Add missing asm-generic/bitsperlong.h include

Sakari Ailus <sakari.ailus@linux.intel.com>
    ACPI: property: Return present device nodes only on fwnode interface

Hoyoung Seo <hy50.seo@samsung.com>
    scsi: ufs: core: Include UTP error in INT_FATAL_ERRORS

Randall P. Embry <rpembry@gmail.com>
    9p: sysfs_init: don't hardcode error to ENOMEM

Aaron Kling <webgeek1234@gmail.com>
    cpufreq: tegra186: Initialize all cores to max frequencies

Randall P. Embry <rpembry@gmail.com>
    9p: fix /sys/fs/9p/caches overwriting itself

Jerome Brunet <jbrunet@baylibre.com>
    NTB: epf: Allow arbitrary BAR mapping

Matthias Schiffer <matthias.schiffer@tq-group.com>
    clk: ti: am33xx: keep WKUP_DEBUGSS_CLKCTRL enabled

Nicolas Ferre <nicolas.ferre@microchip.com>
    clk: at91: clk-sam9x60-pll: force write to PLL_UPDT register

Ryan Wanner <Ryan.Wanner@microchip.com>
    clk: at91: clk-master: Add check for divide by 3

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: at91: pm: save and restore ACR during PLL disable/enable

Josua Mayer <josua@solid-run.com>
    rtc: pcf2127: clear minute/second interrupt

Chen-Yu Tsai <wens@csie.org>
    clk: sunxi-ng: sun6i-rtc: Add A523 specifics

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix help message for ssl-non-raw

Yikang Yue <yikangy2@illinois.edu>
    fs/hpfs: Fix error code for new_inode() failure in mkdir/create/mknod/symlink

austinchang <austinchang@synology.com>
    btrfs: mark dirty extent range for out of bound prealloc extents

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix wrong WQE data when QP wraps around

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix the modification of max_send_sge

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Set irdma_cq cq_num field during CQ create

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Remove unused struct irdma_cq fields

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Fix SD index calculation

Saket Dumbre <saket.dumbre@intel.com>
    ACPICA: Update dsmethod.c to get rid of unused variable warning

Fiona Ebner <f.ebner@proxmox.com>
    smb: client: transport: avoid reconnects triggered by pending task work

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use sock_create_kern interface to create kernel socket

Vladimir Riabchun <ferr.lambarginio@gmail.com>
    ftrace: Fix softlockup in ftrace_module_enable

Mike Marshall <hubcap@omnibond.com>
    orangefs: fix xattr related buffer overflow...

Dragos Tatulea <dtatulea@nvidia.com>
    page_pool: Clamp pool size to max 16K pages

Qingfang Deng <dqfext@gmail.com>
    6pack: drop redundant locking and refcounting

Chi Zhiling <chizhiling@kylinos.cn>
    exfat: limit log print for IO error

Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
    ALSA: usb-audio: add mono main switch to Presonus S1824c

Ivan Pravdin <ipravdin.official@gmail.com>
    Bluetooth: bcsp: receive data only if registered

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SCO: Fix UAF on sco_conn_free

Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>
    Bluetooth: btusb: Check for unexpected bytes when defragmenting HCI frames

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: avoid dealing with endianness in macb_set_hwaddr()

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Don't query FEC statistics when FEC is disabled

Julian Sun <sunjunchao@bytedance.com>
    ext4: increase IO priority of fastcommit

chuguangqing <chuguangqing@inspur.com>
    fs: ext4: change GFP_KERNEL to GFP_NOFS to avoid deadlock

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpt3sas: Add support for 22.5 Gbps SAS link rate

Alok Tiwari <alok.a.tiwari@oracle.com>
    scsi: libfc: Fix potential buffer overflow in fc_ct_ms_fill()

Petr Machata <petrm@nvidia.com>
    net: bridge: Install FDB for bridge MAC on VLAN 0

Al Viro <viro@zeniv.linux.org.uk>
    nfs4_setup_readdir(): insufficient locking for ->d_parent->d_inode dereferencing

Anthony Iliopoulos <ailiop@suse.com>
    NFSv4.1: fix mount hang after CREATE_SESSION failure

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4: handle ERR_GRACE on delegation recalls

Stephan Gerhold <stephan.gerhold@linaro.org>
    remoteproc: qcom: q6v5: Avoid handling handover twice

Mario Limonciello <mario.limonciello@amd.com>
    PCI/PM: Skip resuming to D0 if device is disconnected

Alex Mastro <amastro@fb.com>
    vfio: return -ENOTTY for unsupported device feature

Al Viro <viro@zeniv.linux.org.uk>
    sparc64: fix prototypes of reads[bwl]()

Koakuma <koachan@protonmail.com>
    sparc/module: Add R_SPARC_UA64 relocation handling

Chen Wang <unicorn_wang@outlook.com>
    PCI: cadence: Check for the existence of cdns_pcie::ops before using it

ChunHao Lin <hau@realtek.com>
    r8169: set EEE speed down ratio to 1

Brahmajit Das <listout@listout.xyz>
    net: intel: fm10k: Fix parameter idx set but not used

Loic Poulain <loic.poulain@oss.qualcomm.com>
    wifi: ath10k: Fix connection after GTK rekeying

Seyediman Seyedarab <ImanDevel@gmail.com>
    iommu/vt-d: Replace snprintf with scnprintf in dmar_latency_snapshot()

Robert Marko <robert.marko@sartura.hr>
    net: ethernet: microchip: sparx5: make it selectable for ARCH_LAN969X

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: qcom: sc8280xp: explicitly set S16LE format in sc8280xp_be_hw_params_fixup()

Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
    jfs: fix uninitialized waitqueue in transaction manager

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    jfs: Verify inode mode when loading from disk

Eric Dumazet <edumazet@google.com>
    ipv6: np->rxpmtu race annotation

Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
    usb: xhci: plat: Facilitate using autosuspend for xhci plat devices

Forest Crossman <cyrozap@gmail.com>
    usb: mon: Increase BUFF_MAX to 64 MiB to support multi-MB URBs

Al Viro <viro@zeniv.linux.org.uk>
    allow finish_no_open(file, ERR_PTR(-E...))

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Define size of debugfs entry for xri rebalancing

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Remove ndlp kref decrement clause for F_Port_Ctrl in lpfc_cleanup

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Check return status of lpfc_reset_flush_io_context during TGT_RESET

Nai-Chen Cheng <bleach1827@gmail.com>
    selftests/Makefile: include $(INSTALL_DEP_TARGETS) in clean target to clean net/lib dependency

Christian König <christian.koenig@amd.com>
    drm/amdgpu: reject gang submissions under SRIOV

Stefan Wahren <wahrenst@gmx.net>
    ethernet: Extend device_get_mac_address() to use NVMEM

Jakub Kicinski <kuba@kernel.org>
    page_pool: always add GFP_NOWARN for ATOMIC allocations

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd: Avoid evicting resources at S5

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/amdgpu: Use memdup_array_user in amdgpu_cs_wait_fences_ioctl

John Keeping <jkeeping@inmusicbrands.com>
    ALSA: serial-generic: remove shared static buffer

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt7921: Add 160MHz beamformee capability for mt7922 device

Yafang Shao <laoar.shao@gmail.com>
    net/cls_cgroup: Fix task_get_classid() during qdisc run

Sangwook Shin <sw617.shin@samsung.com>
    watchdog: s3c2410_wdt: Fix max_timeout being calculated larger

Alok Tiwari <alok.a.tiwari@oracle.com>
    udp_tunnel: use netdev_warn() instead of netdev_WARN()

David Ahern <dsahern@kernel.org>
    selftests: Replace sleep with slowwait

Daniel Palmer <daniel@thingy.jp>
    eth: 8139too: Make 8139TOO_PIO depend on !NO_IOPORT_MAP

David Ahern <dsahern@kernel.org>
    selftests: Disable dad for ipv6 in fcnal-test.sh

Li RongQing <lirongqing@baidu.com>
    x86/kvm: Prefer native qspinlock for dedicated vCPUs irrespective of PV_UNHALT

Florian Westphal <fw@strlen.de>
    netfilter: nf_reject: don't reply to icmp error messages

Ido Schimmel <idosch@nvidia.com>
    selftests: traceroute: Use require_command()

Qianfeng Rong <rongqianfeng@vivo.com>
    media: redrat3: use int type to store negative error codes

Jakub Kicinski <kuba@kernel.org>
    selftests: net: replace sleeps in fcnal-test with waits

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    net: sh_eth: Disable WoL if system can not suspend

Michael Riesch <michael.riesch@collabora.com>
    phy: rockchip: phy-rockchip-inno-csidphy: allow writes to grf register 0

Harikrishna Shenoy <h-shenoy@ti.com>
    phy: cadence: cdns-dphy: Enable lower resolutions in dphy

Ilan Peer <ilan.peer@intel.com>
    wifi: mac80211: Fix HE capabilities element check

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    ntfs3: pretend $Extend records as regular files

Rohan G Thomas <rohan.g.thomas@altera.com>
    net: phy: marvell: Fix 88e1510 downshift counter errata

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Enhance recovery on resume failure

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: i2c: og01a1b: Specify monochrome media bus format instead of Bayer

Antonino Maniscalco <antomani103@gmail.com>
    drm/msm: make sure to not queue up recovery more than once

Chen Yufeng <chenyufeng@iie.ac.cn>
    usb: cdns3: gadget: Use-after-free during failed initialization and exit of cdnsp gadget

William Wu <william.wu@rock-chips.com>
    usb: gadget: f_hid: Fix zero length packet transfer

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add support for cyan skillfish gpu_info

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: don't enable SMU on cyan skillfish

Alex Deucher <alexander.deucher@amd.com>
    drm/amd: add more cyan skillfish PCI ids

Ashish Kalra <ashish.kalra@amd.com>
    iommu/amd: Skip enabling command/event buffers for kdump

Colin Foster <colin.foster@in-advantage.com>
    smsc911x: add second read of EEPROM mac when possible corruption seen

Eric Dumazet <edumazet@google.com>
    net: call cond_resched() less often in __release_sock()

Cryolitia PukNgae <cryolitia@uniontech.com>
    ALSA: usb-audio: apply quirk for MOONDROP Quark2

Paul Kocialkowski <paulk@sys-base.io>
    media: verisilicon: Explicitly disable selection api ioctls for decoders

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: adv7180: Only validate format in querystd

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: adv7180: Do not write format to device in set_fmt

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: adv7180: Add missing lock in suspend callback

Juraj Šarinay <juraj@sarinay.com>
    net: nfc: nci: Increase NCI_DATA_TIMEOUT to 3000 ms

Yue Haibing <yuehaibing@huawei.com>
    ipv6: Add sanity checks on ipv6_devconf.rpl_seg_enabled

David Francis <David.Francis@amd.com>
    drm/amdgpu: Allow kfd CRIU with no buffer objects

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/msm/dsi/phy_7nm: Fix missing initial VCO rate

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/msm/dsi/phy: Toggle back buffer resync after preparing PLL

Devendra K Verma <devverma@amd.com>
    dmaengine: dw-edma: Set status for callback_result

Rosen Penev <rosenp@gmail.com>
    dmaengine: mv_xor: match alloc_wc and free_wc

Thomas Andreatta <thomasandreatta2000@gmail.com>
    dmaengine: sh: setup_xref error handling

Miroslav Lichvar <mlichvar@redhat.com>
    ptp: Limit time setting of PTP clocks

Qianfeng Rong <rongqianfeng@vivo.com>
    scsi: pm8001: Use int instead of u32 to store error codes

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: danube: rename stp node on EASY50712 reference board

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: xway: sysctrl: rename stp clock

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: danube: add missing device_type in pci node

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: danube: add model to EASY50712 dts

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: danube: add missing properties to cpu node

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Respect max pixel clock for HDMI and DVI-D (v2)

Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
    media: fix uninitialized symbol warnings

Amber Lin <Amber.Lin@amd.com>
    drm/amdkfd: Tie UNMAP_LATENCY to queue_preemption

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdkfd: fix vram allocation failure for a special case

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fixed_phy: let fixed_phy_unregister free the phy_device

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    extcon: adc-jack: Fix wakeup source leaks on device unbind

Francisco Gutierrez <frankramirez@google.com>
    scsi: pm80xx: Fix race condition caused by static variables

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix controller init failure on fault during queue creation

Ujwal Kundur <ujwal.kundur@gmail.com>
    rds: Fix endianness annotation for RDS_MPATH_HASH

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add validation of UAC2/UAC3 effect units

Sungho Kim <sungho.kim@furiosa.ai>
    PCI/P2PDMA: Fix incorrect pointer usage in devm_kfree() call

Kuniyuki Iwashima <kuniyu@google.com>
    net: Call trace_sock_exceed_buf_limit() for memcg failure with SK_MEM_RECV.

Christoph Paasch <cpaasch@openai.com>
    net: When removing nexthops, don't call synchronize_net if it is not necessary

Zijun Hu <zijun.hu@oss.qualcomm.com>
    char: misc: Does not request module for miscdevice with dynamic minor

raub camaioni <raubcameo@gmail.com>
    usb: gadget: f_ncm: Fix MAC assignment NCM ethernet

Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
    iio: adc: spear_adc: mask SPEAR_ADC_STATUS channel and avg sample before setting register

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/bridge: display-connector: don't set OP_DETECT for DisplayPorts

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    media: imon: make send_packet() more robust

Charalampos Mitrodimas <charmitro@posteo.net>
    net: ipv6: fix field-spanning memcpy warning in AH output

Alice Chao <alice.chao@mediatek.com>
    scsi: ufs: host: mediatek: Fix invalid access in vccqx handling

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Change reset sequence for improved stability

Alice Chao <alice.chao@mediatek.com>
    scsi: ufs: host: mediatek: Assign power mode userdata before FASTAUTO mode change

Ido Schimmel <idosch@nvidia.com>
    bridge: Redirect to backup port when port is administratively down

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Use pci_uevent_ers() in PCI recovery

Niklas Schnelle <schnelle@linux.ibm.com>
    powerpc/eeh: Use result of error_detected() in uevent

Lukas Wunner <lukas@wunner.de>
    thunderbolt: Use is_pciehp instead of is_hotplug_bridge

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    ice: Don't use %pK through printk or tracepoints

Tiezhu Yang <yangtiezhu@loongson.cn>
    net: stmmac: Check stmmac_hw_setup() in stmmac_resume()

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/vsyscall: Do not require X86_PF_INSTR to emulate vsyscall

Mehdi Djait <mehdi.djait@linux.intel.com>
    media: i2c: Kconfig: Ensure a dependency on HAVE_CLK for VIDEO_CAMERA_SENSOR

Jayesh Choudhary <j-choudhary@ti.com>
    drm/tidss: Set crtc modesetting parameters with adjusted mode

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/tidss: Use the crtc_* timings when programming the HW

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: amphion: Delete v4l2_fh synchronously in .release()

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: pci: ivtv: Don't create fake v4l2_fh

Geoffrey McRae <geoffrey.mcrae@amd.com>
    drm/amdkfd: return -ENOTTY for unsupported IOCTLs

Wake Liu <wakel@google.com>
    selftests/net: Ensure assert() triggers in psock_tpacket.c

Wake Liu <wakel@google.com>
    selftests/net: Replace non-standard __WORDSIZE with sizeof(long) * 8

Marcos Del Sol Vives <marcos@orca.pet>
    PCI: Disable MSI on RDC PCI to PCIe bridges

Seyediman Seyedarab <imandevel@gmail.com>
    drm/nouveau: replace snprintf() with scnprintf() in nvkm_snprintbf()

Sathishkumar S <sathishkumar.sundararaju@amd.com>
    drm/amdgpu/jpeg: Hold pg_lock before jpeg poweroff

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Use cached metrics data on arcturus

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Use cached metrics data on aldebaran

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: add more cyan skillfish devices

Jens Kehne <jens.kehne@agilent.com>
    mfd: da9063: Split chip variant reading in two bus transactions

Arnd Bergmann <arnd@arndb.de>
    mfd: madera: Work around false-positive -Wininitialized warning

Alexander Stein <alexander.stein@ew.tq-group.com>
    mfd: stmpe-i2c: Add missing MODULE_LICENSE

Alexander Stein <alexander.stein@ew.tq-group.com>
    mfd: stmpe: Remove IRQ domain upon removal

Len Brown <len.brown@intel.com>
    tools/power x86_energy_perf_policy: Prefer driver HWP limits

Len Brown <len.brown@intel.com>
    tools/power x86_energy_perf_policy: Enhance HWP enable

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/power x86_energy_perf_policy: Fix incorrect fopen mode usage

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/cpupower: Fix incorrect size in cpuidle_state_disable()

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Add support for Dell OptiPlex 7040

Ben Copeland <ben.copeland@linaro.org>
    hwmon: (asus-ec-sensors) increase timeout for locking ACPI mutex

Jiri Olsa <jolsa@kernel.org>
    uprobe: Do not emulate/sstep original instruction when ip is changed

Alistair Francis <alistair.francis@wdc.com>
    nvme: Use non zero KATO for persistent discovery connections

Amery Hung <ameryhung@gmail.com>
    bpf: Clear pfmemalloc flag when freeing all fragments

Daniel Lezcano <daniel.lezcano@linaro.org>
    clocksource/drivers/vf-pit: Replace raw_readl/writel to readl/writel

Biju Das <biju.das.jz@bp.renesas.com>
    spi: rpc-if: Add resume support for RZ/G3E

Pranav Tyagi <pranav.tyagi03@gmail.com>
    futex: Don't leak robust_list pointer on exec race

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: Fail cpuidle device registration if there is one already

Tom Stellard <tstellar@redhat.com>
    bpftool: Fix -Wuninitialized-const-pointer warnings with clang >= 21

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/cpupower: fix error return value in cpupower_write_sysfs()

Svyatoslav Ryhel <clamor95@gmail.com>
    video: backlight: lp855x_bl: Set correct EPROM start for LP8556

Daniel Wagner <wagi@kernel.org>
    nvme-fc: use lock accessing port_state and rport state

Daniel Wagner <wagi@kernel.org>
    nvmet-fc: avoid scheduling association deletion twice

Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>
    tee: allow a driver to allocate a tee_device without a pool

Hans de Goede <hansg@kernel.org>
    ACPICA: dispatcher: Use acpi_ds_clear_operands() in acpi_ds_call_control_method()

Sarthak Garg <quic_sartgarg@quicinc.com>
    mmc: sdhci-msm: Enable tuning for SDR50 mode for SD card

Svyatoslav Ryhel <clamor95@gmail.com>
    soc/tegra: fuse: Add Tegra114 nvmem cells and fuse lookups

Ming Wang <wangming01@loongson.cn>
    irqchip/loongson-pch-lpc: Use legacy domain for PCH-LPC IRQ controller

Andreas Kemnade <andreas@kemnade.info>
    hwmon: sy7636a: add alias

Fabien Proriol <fabien.proriol@viavisolutions.com>
    power: supply: sbs-charger: Support multiple devices

Chuande Chen <chuachen@cisco.com>
    hwmon: (sbtsi_temp) AMD CPU extended temperature range support

Hans de Goede <hansg@kernel.org>
    ACPI: scan: Add Intel CVS ACPI HIDs to acpi_ignore_dep_ids[]

Shang song (Lenovo) <shangsong2@foxmail.com>
    ACPI: PRM: Skip handlers with NULL handler_address or NULL VA

Christian Bruel <christian.bruel@foss.st.com>
    irqchip/gic-v2m: Handle Multiple MSI base IRQ Alignment

Ricardo B. Marlière <rbm@suse.com>
    selftests/bpf: Upon failures, exit with code 1 in test_xsk.sh

Kees Cook <kees@kernel.org>
    arc: Fix __fls() const-foldability via __builtin_clzl()

Dennis Beier <nanovim@gmail.com>
    cpufreq/longhaul: handle NULL policy in longhaul_exit

Ricardo B. Marlière <rbm@suse.com>
    selftests/bpf: Fix bpf_prog_detach2 usage in test_lirc_mode2

Inochi Amaoto <inochiama@gmail.com>
    irqchip/sifive-plic: Respect mask state when setting affinity

Jiayi Li <lijiayi@kylinos.cn>
    memstick: Add timeout to prevent indefinite waiting

Biju Das <biju.das.jz@bp.renesas.com>
    mmc: host: renesas_sdhi: Fix the actual clock

Chi Zhang <chizhang@asrmicro.com>
    pinctrl: single: fix bias pull up/down handling in pin_config_set

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    bpf: Don't use %pK through printk

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    soc: ti: pruss: don't use %pK through printk

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    spi: loopback-test: Don't use %pK through printk

Jens Reidel <adrian@mainlining.org>
    soc: qcom: smem: Fix endian-unaware access of num_entries

Ryan Chen <ryan_chen@aspeedtech.com>
    soc: aspeed: socinfo: Add AST27xx silicon IDs

Gerd Bayer <gbayer@linux.ibm.com>
    s390/pci: Avoid deadlock between PCI error recovery and mlx5 crdump

Philipp Stanner <phasta@kernel.org>
    drm/sched: Fix race in drm_sched_entity_select_rq()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: Do not dereference NULL pointer in plane reset

Owen Gu <guhuinan@xiaomi.com>
    usb: gadget: f_fs: Fix epfile null pointer access after ep enable.

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix deadlock warnings caused by lock dependency in init_nilfs()

Darrick J. Wong <djwong@kernel.org>
    block: fix race between set_blocksize and read paths

Christoph Hellwig <hch@lst.de>
    block: open code __generic_file_write_iter for blkdev writes

Al Viro <viro@zeniv.linux.org.uk>
    direct_write_fallback(): on error revert the ->ki_pos update from buffered write

Christoph Hellwig <hch@lst.de>
    fs: factor out a direct_write_fallback helper

Christoph Hellwig <hch@lst.de>
    filemap: update ki_pos in generic_perform_write

Christoph Hellwig <hch@lst.de>
    filemap: add a kiocb_invalidate_post_direct_write helper

Christoph Hellwig <hch@lst.de>
    filemap: add a kiocb_invalidate_pages helper

Pierre Gondois <pierre.gondois@arm.com>
    arm64: tegra: Update cache properties

K Prateek Nayak <kprateek.nayak@amd.com>
    drivers: base: cacheinfo: Update cpu_map_populated during CPU Hotplug

Yicong Yang <yangyicong@hisilicon.com>
    cacheinfo: Fix LLC is not exported through sysfs

Pierre Gondois <pierre.gondois@arm.com>
    cacheinfo: Initialize variables in fetch_cache_info()

Pierre Gondois <pierre.gondois@arm.com>
    arch_topology: Build cacheinfo from primary CPU

Pierre Gondois <pierre.gondois@arm.com>
    ACPI: PPTT: Update acpi_find_last_cache_level() to acpi_get_cache_info()

Pierre Gondois <pierre.gondois@arm.com>
    ACPI: PPTT: Remove acpi_find_cache_levels()

Pierre Gondois <pierre.gondois@arm.com>
    cacheinfo: Check 'cache-unified' property to count cache leaves

Pierre Gondois <pierre.gondois@arm.com>
    cacheinfo: Return error code in init_of_cache_level()

Pierre Gondois <pierre.gondois@arm.com>
    cacheinfo: Use RISC-V's init_cache_level() as generic OF implementation

Celeste Liu <uwu@coelacanthus.name>
    can: gs_usb: increase max interface to U8_MAX

Paolo Abeni <pabeni@redhat.com>
    mptcp: drop bogus optimization in __mptcp_check_push()

Geliang Tang <geliang.tang@suse.com>
    mptcp: change 'first' as a parameter

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    net: phy: dp83867: Disable EEE support as not implemented

Farhan Ali <alifm@linux.ibm.com>
    s390/pci: Restore IRQ unconditionally for the zPCI device

Alex Deucher <alexander.deucher@amd.com>
    Reapply "Revert drm/amd/display: Enable Freesync Video Mode by default"

Alexey Klimov <alexey.klimov@linaro.org>
    regmap: slimbus: fix bus_context pointer in regmap init calls

Damien Le Moal <dlemoal@kernel.org>
    block: make REQ_OP_ZONE_OPEN a write operation

Damien Le Moal <dlemoal@kernel.org>
    block: fix op_is_zone_mgmt() to handle REQ_OP_ZONE_RESET_ALL

John Smith <itistotalbotnet@gmail.com>
    drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Iceland

John Smith <itistotalbotnet@gmail.com>
    drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Fiji

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix smu table id bound check issue in smu_cmn_update_table()

Jijie Shao <shaojijie@huawei.com>
    net: hns3: return error code when function fails

Tomeu Vizoso <tomeu@tomeuvizoso.net>
    drm/etnaviv: fix flush sequence logic

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix another instance of dst_type handling

Claudia Draghicescu <claudia.rosu@nxp.com>
    Bluetooth: ISO: Add support for periodic adv reports processing

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: HCI: Fix tracking of advertisement set/instance 0x00

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio: Add pmctrl handling for BT closed state during reset

Cen Zhang <zzzccc427@163.com>
    Bluetooth: hci_sync: fix race in hci_cmd_sync_dequeue_once

Lizhi Xu <lizhi.xu@windriver.com>
    usbnet: Prevents free active kevent

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix powerpc's stack register definition in bpf_tracing.h

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: fix bit order for DSD format

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Unprepare a stream when XRUN occurs

Ondrej Mosnacek <omosnace@redhat.com>
    bpf: Do not audit capability check in do_jit()

Wonkon Kim <wkon.kim@samsung.com>
    scsi: ufs: core: Initialize value of an attribute returned by uic cmd

Noorain Eqbal <nooraineqbal@gmail.com>
    bpf: Sync pending IRQ work before freeing ring buffer

Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
    ALSA: usb-audio: fix control pipe direction

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix GMU firmware parser

Loic Poulain <loic.poulain@oss.qualcomm.com>
    wifi: ath10k: Fix memory leak on unsupported WMI command

Chang S. Bae <chang.seok.bae@intel.com>
    x86/fpu: Ensure XFD state on signal delivery

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qdsp6: q6asm: do not sleep while atomic

Paolo Abeni <pabeni@redhat.com>
    mptcp: restore window probe

Miaoqian Lin <linmq006@gmail.com>
    fbdev: valkyriefb: Fix reference count leak in valkyriefb_init

Florian Fuchs <fuchsfl@gmail.com>
    fbdev: pvr2fb: Fix leftover reference to ONCHIP_NR_DMA_CHANNELS

Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
    wifi: brcmfmac: fix crash while sending Action Frames in standalone AP Mode

Junjie Cao <junjie.cao@intel.com>
    fbdev: bitblit: bound-check glyph index in bit_putcs*

Yuhao Jiang <danisjiang@gmail.com>
    ACPI: video: Fix use-after-free in acpi_video_switch_brightness()

Daniel Palmer <daniel@0x0f.com>
    fbdev: atyfb: Check if pll_ops->init_pll failed

Quanmin Yan <yanquanmin1@huawei.com>
    fbcon: Set fb_display[i]->mode to NULL when the mode is released

Miaoqian Lin <linmq006@gmail.com>
    net: usb: asix_devices: Check return value of usbnet_get_endpoints

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix crash in nfsd4_read_release()

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: remove useless enable of enhanced features

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: refactor EFR lock

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: reorder code to remove prototype declarations

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: remove unused to_sc16is7xx_port macro

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: fix bogus 1024 byte prefix if ttyDBC read races with stall event

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Avoid event polling busyloop if pending rx transfers are inactive.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Improve performance by removing delay in transfer event polling.

Uday M Bhat <uday.m.bhat@intel.com>
    xhci: dbc: Allow users to modify DbC poll interval via sysfs

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: poll at different rate depending on data transfer activity

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Provide sysfs option to configure dbc descriptors

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: mark 'delete re-add signal' as skipped if not supported

Geliang Tang <tanggeliang@kylinos.cn>
    selftests: mptcp: disable add_addr retrans in endpoint_tests

Xu Yang <xu.yang_2@nxp.com>
    dt-bindings: usb: dwc3-imx8mp: dma-range is required only for imx8mp

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: in-kernel: C-flag: handle late ADD_ADDR

Menglong Dong <menglong8.dong@gmail.com>
    arch: Add the macro COMPILE_OFFSETS to all the asm-offsets.c

Filipe Manana <fdmanana@suse.com>
    btrfs: use smp_mb__after_atomic() when forcing COW in create_pending_snapshot()

Filipe Manana <fdmanana@suse.com>
    btrfs: always drop log root tree reference in btrfs_replay_log()

Thorsten Blum <thorsten.blum@linux.dev>
    btrfs: scrub: replace max_t()/min_t() with clamp() in scrub_throttle_dev_io()

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: refine extent allocator hint selection

Avadhut Naik <avadhut.naik@amd.com>
    EDAC/mc_sysfs: Increase legacy channel support to 16

David Kaplan <david.kaplan@amd.com>
    x86/bugs: Fix reporting of LFENCE retpoline

Josh Poimboeuf <jpoimboe@kernel.org>
    perf: Have get_perf_callchain() return NULL if crosstask and user are set

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Fix null-deref in agg_dequeue


-------------

Diffstat:

 .../ABI/testing/sysfs-bus-pci-drivers-xhci_hcd     |   62 +
 .../bindings/pinctrl/toshiba,visconti-pinctrl.yaml |   26 +-
 .../devicetree/bindings/usb/fsl,imx8mp-dwc3.yaml   |   10 +-
 MAINTAINERS                                        |    7 +-
 Makefile                                           |    4 +-
 arch/alpha/kernel/asm-offsets.c                    |    1 +
 arch/arc/include/asm/bitops.h                      |    2 +
 arch/arc/kernel/asm-offsets.c                      |    1 +
 arch/arm/crypto/Kconfig                            |    2 +-
 arch/arm/kernel/asm-offsets.c                      |    2 +
 arch/arm/mach-at91/pm_suspend.S                    |    8 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |   15 +
 arch/arm64/boot/dts/nvidia/tegra210.dtsi           |    1 +
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           |   33 +
 arch/arm64/kernel/asm-offsets.c                    |    1 +
 arch/arm64/kernel/cacheinfo.c                      |   11 +-
 arch/csky/kernel/asm-offsets.c                     |    1 +
 arch/hexagon/kernel/asm-offsets.c                  |    1 +
 arch/loongarch/include/asm/pgtable.h               |   11 +-
 arch/loongarch/include/uapi/asm/bitsperlong.h      |    9 -
 arch/loongarch/kernel/asm-offsets.c                |    2 +
 arch/loongarch/kernel/traps.c                      |    4 +-
 arch/loongarch/pci/pci.c                           |    8 +-
 arch/m68k/kernel/asm-offsets.c                     |    1 +
 arch/microblaze/kernel/asm-offsets.c               |    1 +
 arch/mips/boot/dts/lantiq/danube.dtsi              |    6 +
 arch/mips/boot/dts/lantiq/danube_easy50712.dts     |    4 +-
 arch/mips/kernel/asm-offsets.c                     |    2 +
 arch/mips/lantiq/xway/sysctrl.c                    |    2 +-
 arch/mips/mm/tlb-r4k.c                             |  118 +-
 arch/mips/mti-malta/malta-init.c                   |   20 +-
 arch/nios2/kernel/asm-offsets.c                    |    1 +
 arch/openrisc/kernel/asm-offsets.c                 |    1 +
 arch/parisc/kernel/asm-offsets.c                   |    1 +
 arch/powerpc/kernel/asm-offsets.c                  |    1 +
 arch/powerpc/kernel/eeh_driver.c                   |    2 +-
 arch/riscv/kernel/asm-offsets.c                    |    1 +
 arch/riscv/kernel/cacheinfo.c                      |   42 -
 arch/riscv/kernel/cpu-hotplug.c                    |    1 +
 arch/s390/include/asm/pci.h                        |    1 -
 arch/s390/kernel/asm-offsets.c                     |    1 +
 arch/s390/pci/pci_event.c                          |    7 +-
 arch/s390/pci/pci_irq.c                            |    9 +-
 arch/sh/kernel/asm-offsets.c                       |    1 +
 arch/sparc/include/asm/elf_64.h                    |    1 +
 arch/sparc/include/asm/io_64.h                     |    6 +-
 arch/sparc/kernel/asm-offsets.c                    |    1 +
 arch/sparc/kernel/module.c                         |    1 +
 arch/um/drivers/ssl.c                              |    5 +-
 arch/um/kernel/asm-offsets.c                       |    2 +
 arch/x86/entry/vsyscall/vsyscall_64.c              |   17 +-
 arch/x86/events/core.c                             |   10 +-
 arch/x86/kernel/cpu/bugs.c                         |    5 +-
 arch/x86/kernel/fpu/core.c                         |    3 +
 arch/x86/kernel/kvm.c                              |   20 +-
 arch/x86/kvm/svm/svm.c                             |   10 +-
 arch/x86/net/bpf_jit_comp.c                        |    2 +-
 arch/xtensa/kernel/asm-offsets.c                   |    1 +
 block/bdev.c                                       |   17 +
 block/blk-zoned.c                                  |    5 +-
 block/fops.c                                       |   61 +-
 block/ioctl.c                                      |    6 +
 drivers/acpi/acpi_video.c                          |    4 +-
 drivers/acpi/acpica/dsmethod.c                     |   10 +-
 drivers/acpi/cppc_acpi.c                           |    6 +-
 drivers/acpi/numa/srat.c                           |    2 +-
 drivers/acpi/pptt.c                                |   93 +-
 drivers/acpi/prmt.c                                |   19 +-
 drivers/acpi/property.c                            |   24 +-
 drivers/acpi/scan.c                                |    2 +
 drivers/ata/libata-scsi.c                          |   12 +-
 drivers/atm/fore200e.c                             |    2 +
 drivers/base/arch_topology.c                       |   12 +-
 drivers/base/cacheinfo.c                           |  168 +-
 drivers/base/regmap/regmap-slimbus.c               |    6 +-
 drivers/bcma/main.c                                |    6 +
 drivers/bluetooth/btmtksdio.c                      |   12 +
 drivers/bluetooth/btusb.c                          |   30 +-
 drivers/bluetooth/hci_bcsp.c                       |    3 +
 drivers/char/misc.c                                |    8 +-
 drivers/clk/at91/clk-master.c                      |    3 +
 drivers/clk/at91/clk-sam9x60-pll.c                 |   75 +-
 drivers/clk/sunxi-ng/ccu-sun6i-rtc.c               |   11 +
 drivers/clk/ti/clk-33xx.c                          |    2 +
 drivers/clocksource/timer-vf-pit.c                 |   22 +-
 drivers/cpufreq/longhaul.c                         |    3 +
 drivers/cpufreq/tegra186-cpufreq.c                 |   27 +-
 drivers/cpuidle/cpuidle.c                          |    8 +-
 drivers/dma/dw-edma/dw-edma-core.c                 |   22 +
 drivers/dma/mv_xor.c                               |    4 +-
 drivers/dma/sh/shdma-base.c                        |   25 +-
 drivers/dma/sh/shdmac.c                            |   17 +-
 drivers/edac/altera_edac.c                         |   22 +-
 drivers/edac/edac_mc_sysfs.c                       |   24 +
 drivers/extcon/extcon-adc-jack.c                   |    2 +
 drivers/firmware/arm_scmi/scmi_pm_domain.c         |   13 +-
 drivers/firmware/stratix10-svc.c                   |    7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |   66 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   23 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   10 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |    5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |    5 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c           |    6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |    7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |    5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |    4 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |    4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   19 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |    9 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   12 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |    8 +-
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c    |   11 +-
 drivers/gpu/drm/amd/display/include/dal_asic_id.h  |    5 +
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |    5 +
 .../gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c  |    2 +-
 .../drm/amd/pm/powerplay/smumgr/iceland_smumgr.c   |    2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |    2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |    2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c             |    2 +-
 drivers/gpu/drm/bridge/display-connector.c         |    3 +-
 drivers/gpu/drm/drm_gem_atomic_helper.c            |    6 +-
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |    2 +-
 drivers/gpu/drm/i915/gt/intel_gt_clock_utils.c     |    4 +-
 drivers/gpu/drm/i915/i915_vma.c                    |   16 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |    5 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |    3 +
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c          |   10 +
 drivers/gpu/drm/nouveau/nvkm/core/enum.c           |    2 +-
 drivers/gpu/drm/scheduler/sched_entity.c           |    3 +-
 drivers/gpu/drm/sti/sti_vtg.c                      |    7 +-
 drivers/gpu/drm/tegra/dc.c                         |    1 +
 drivers/gpu/drm/tegra/uapi.c                       |    7 +-
 drivers/gpu/drm/tidss/tidss_crtc.c                 |    7 +-
 drivers/gpu/drm/tidss/tidss_dispc.c                |   16 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |    5 +
 drivers/gpu/host1x/context.c                       |    4 +
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c      |    2 +
 drivers/hid/hid-core.c                             |    7 +-
 drivers/hid/hid-ids.h                              |    7 +-
 drivers/hid/hid-ntrig.c                            |    7 +-
 drivers/hid/hid-quirks.c                           |   14 +-
 drivers/hwmon/asus-ec-sensors.c                    |    2 +-
 drivers/hwmon/dell-smm-hwmon.c                     |    7 +
 drivers/hwmon/sbtsi_temp.c                         |   46 +-
 drivers/hwmon/sy7636a-hwmon.c                      |    1 +
 drivers/i2c/busses/i2c-xgene-slimpro.c             |   16 +-
 drivers/iio/accel/adxl355_core.c                   |   44 +-
 drivers/iio/accel/bmc150-accel-core.c              |    5 +
 drivers/iio/accel/bmc150-accel.h                   |    1 +
 drivers/iio/adc/ad7280a.c                          |    2 +-
 drivers/iio/adc/rtq6056.c                          |    2 +-
 drivers/iio/adc/spear_adc.c                        |    9 +-
 drivers/iio/common/ssp_sensors/ssp_dev.c           |    4 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h            |   22 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   11 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |    2 -
 drivers/infiniband/hw/irdma/pble.c                 |    2 +-
 drivers/infiniband/hw/irdma/verbs.c                |    4 +-
 drivers/infiniband/hw/irdma/verbs.h                |    8 +-
 drivers/input/keyboard/cros_ec_keyb.c              |    6 +
 drivers/input/keyboard/imx_sc_key.c                |    2 +-
 drivers/input/tablet/pegasus_notetaker.c           |    9 +
 drivers/iommu/amd/init.c                           |   28 +-
 drivers/iommu/intel/debugfs.c                      |   10 +-
 drivers/iommu/intel/perf.c                         |   10 +-
 drivers/iommu/intel/perf.h                         |    5 +-
 drivers/irqchip/irq-gic-v2m.c                      |   13 +-
 drivers/irqchip/irq-loongson-pch-lpc.c             |    9 +-
 drivers/irqchip/irq-sifive-plic.c                  |    6 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |   18 +-
 drivers/mailbox/mailbox-test.c                     |    2 +-
 drivers/mailbox/mailbox.c                          |   96 +-
 drivers/mailbox/pcc.c                              |  248 ++-
 drivers/md/dm-verity-fec.c                         |    6 +-
 drivers/media/i2c/Kconfig                          |    2 +-
 drivers/media/i2c/adv7180.c                        |   48 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |    6 +-
 drivers/media/i2c/og01a1b.c                        |    6 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |    2 -
 drivers/media/pci/ivtv/ivtv-driver.h               |    3 +-
 drivers/media/pci/ivtv/ivtv-fileops.c              |   18 +-
 drivers/media/pci/ivtv/ivtv-irq.c                  |    4 +-
 drivers/media/platform/amphion/vpu_v4l2.c          |    7 +-
 drivers/media/platform/verisilicon/hantro_drv.c    |    2 +
 drivers/media/platform/verisilicon/hantro_v4l2.c   |    6 +-
 drivers/media/rc/imon.c                            |   61 +-
 drivers/media/rc/redrat3.c                         |    2 +-
 drivers/media/tuners/xc4000.c                      |    8 +-
 drivers/media/tuners/xc5000.c                      |   12 +-
 drivers/memstick/core/memstick.c                   |    8 +-
 drivers/mfd/da9063-i2c.c                           |   27 +-
 drivers/mfd/madera-core.c                          |    4 +-
 drivers/mfd/stmpe-i2c.c                            |    1 +
 drivers/mfd/stmpe.c                                |    3 +
 drivers/mmc/host/renesas_sdhi_core.c               |    6 +-
 drivers/mmc/host/sdhci-msm.c                       |   15 +
 drivers/mmc/host/sdhci-of-dwcmshc.c                |    2 +-
 drivers/most/most_usb.c                            |   14 +-
 drivers/mtd/mtdchar.c                              |    6 +-
 drivers/mtd/nand/onenand/onenand_samsung.c         |    2 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |    3 +-
 drivers/net/can/sja1000/sja1000.c                  |    4 +-
 drivers/net/can/sun4i_can.c                        |    4 +-
 drivers/net/can/usb/gs_usb.c                       |   64 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |    4 +-
 drivers/net/dsa/b53/b53_common.c                   |   15 +-
 drivers/net/dsa/b53/b53_regs.h                     |    3 +-
 drivers/net/dsa/dsa_loop.c                         |    9 +-
 drivers/net/dsa/hirschmann/hellcreek_ptp.c         |   14 +-
 drivers/net/dsa/microchip/ksz9477.c                |   98 +-
 drivers/net/dsa/microchip/ksz9477_reg.h            |    3 +-
 drivers/net/dsa/microchip/ksz_common.c             |   12 +-
 drivers/net/dsa/microchip/ksz_common.h             |    2 +
 drivers/net/dsa/microchip/lan937x_main.c           |    1 +
 drivers/net/dsa/sja1105/sja1105_main.c             |   66 +-
 .../net/ethernet/aquantia/atlantic/aq_hw_utils.c   |   22 +
 .../net/ethernet/aquantia/atlantic/aq_hw_utils.h   |    1 +
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |    5 +
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |   19 +-
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c   |    2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |    4 +-
 drivers/net/ethernet/cadence/macb_main.c           |    6 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |    7 +-
 drivers/net/ethernet/freescale/fec_main.c          |    2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |    3 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |    9 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h    |    2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_common.c    |    5 +-
 drivers/net/ethernet/intel/fm10k/fm10k_common.h    |    2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c        |    2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_vf.c        |    2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |    2 +-
 drivers/net/ethernet/intel/ice/ice_trace.h         |   10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   10 -
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |   72 +
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h  |    6 +
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |  280 ++-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.h   |    7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   62 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |    5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |    5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   12 +-
 .../net/ethernet/mellanox/mlxsw/core_linecards.c   |    2 +
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |    6 +-
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |    5 +-
 drivers/net/ethernet/microchip/sparx5/Kconfig      |    2 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |    5 +-
 drivers/net/ethernet/realtek/Kconfig               |    2 +-
 drivers/net/ethernet/realtek/r8169_main.c          |    6 +-
 drivers/net/ethernet/renesas/sh_eth.c              |    4 +
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |    4 +-
 drivers/net/ethernet/smsc/smsc911x.c               |   14 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    9 +-
 drivers/net/ethernet/ti/netcp_core.c               |   10 +-
 drivers/net/hamradio/6pack.c                       |   57 +-
 drivers/net/mdio/of_mdio.c                         |    1 -
 drivers/net/phy/dp83867.c                          |    6 +
 drivers/net/phy/fixed_phy.c                        |    1 +
 drivers/net/phy/marvell.c                          |   39 +-
 drivers/net/phy/mdio_bus.c                         |    5 +-
 drivers/net/usb/asix_devices.c                     |   12 +-
 drivers/net/usb/qmi_wwan.c                         |    6 +
 drivers/net/usb/usbnet.c                           |    2 +
 drivers/net/virtio_net.c                           |   26 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   12 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   40 +-
 drivers/net/wireless/ath/ath11k/hw.c               |    1 +
 drivers/net/wireless/ath/ath11k/mac.c              |    5 +
 drivers/net/wireless/ath/ath11k/wmi.c              |   30 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |    3 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    3 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   28 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |    2 +
 drivers/ntb/hw/epf/ntb_hw_epf.c                    |  103 +-
 drivers/nvme/host/core.c                           |    8 +-
 drivers/nvme/host/fc.c                             |   12 +-
 drivers/nvme/host/multipath.c                      |    2 +-
 drivers/nvme/target/fc.c                           |   16 +-
 drivers/pci/controller/cadence/pcie-cadence-host.c |    2 +-
 drivers/pci/controller/cadence/pcie-cadence.c      |    4 +-
 drivers/pci/controller/cadence/pcie-cadence.h      |    6 +-
 drivers/pci/p2pdma.c                               |    2 +-
 drivers/pci/pci-driver.c                           |    2 +-
 drivers/pci/pci.c                                  |    5 +
 drivers/pci/quirks.c                               |    3 +-
 drivers/phy/cadence/cdns-dphy.c                    |    4 +-
 drivers/phy/rockchip/phy-rockchip-inno-csidphy.c   |    5 +-
 drivers/pinctrl/pinctrl-single.c                   |    4 +-
 drivers/platform/x86/intel/punit_ipc.c             |    2 +-
 .../x86/intel/speed_select_if/isst_if_mmio.c       |    4 +-
 drivers/power/supply/sbs-charger.c                 |   16 +-
 drivers/ptp/ptp_clock.c                            |   13 +-
 drivers/regulator/fixed.c                          |    1 +
 drivers/remoteproc/qcom_q6v5.c                     |    5 +
 drivers/rtc/rtc-pcf2127.c                          |    4 +-
 drivers/rtc/rtc-rx8025.c                           |    2 +-
 drivers/s390/net/ctcm_mpc.c                        |    1 -
 drivers/scsi/hosts.c                               |    5 +-
 drivers/scsi/libfc/fc_encode.h                     |    2 +-
 drivers/scsi/lpfc/lpfc_debugfs.h                   |    3 +
 drivers/scsi/lpfc/lpfc_els.c                       |    6 +-
 drivers/scsi/lpfc/lpfc_init.c                      |    7 -
 drivers/scsi/lpfc/lpfc_scsi.c                      |   14 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |   10 +
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |    3 +
 drivers/scsi/pm8001/pm8001_ctl.c                   |   24 +-
 drivers/scsi/pm8001/pm8001_init.c                  |    1 +
 drivers/scsi/pm8001/pm8001_sas.c                   |    4 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |    4 +
 drivers/scsi/sg.c                                  |   10 +-
 drivers/slimbus/qcom-ngd-ctrl.c                    |    1 +
 drivers/soc/aspeed/aspeed-socinfo.c                |    4 +
 drivers/soc/imx/gpc.c                              |    2 +
 drivers/soc/qcom/smem.c                            |    2 +-
 drivers/soc/samsung/pm_domains.c                   |   11 +-
 drivers/soc/tegra/fuse/fuse-tegra30.c              |  122 +
 drivers/soc/ti/knav_dma.c                          |   14 +-
 drivers/soc/ti/pruss.c                             |    2 +-
 drivers/spi/spi-bcm63xx.c                          |   14 +
 drivers/spi/spi-loopback-test.c                    |   12 +-
 drivers/spi/spi-rpc-if.c                           |    2 +
 drivers/spi/spi.c                                  |   10 +
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/rtl8712/Kconfig                    |   21 -
 drivers/staging/rtl8712/Makefile                   |   35 -
 drivers/staging/rtl8712/TODO                       |   13 -
 drivers/staging/rtl8712/basic_types.h              |   28 -
 drivers/staging/rtl8712/drv_types.h                |  175 --
 drivers/staging/rtl8712/ethernet.h                 |   21 -
 drivers/staging/rtl8712/hal_init.c                 |  401 ----
 drivers/staging/rtl8712/ieee80211.c                |  415 ----
 drivers/staging/rtl8712/ieee80211.h                |  165 --
 drivers/staging/rtl8712/mlme_linux.c               |  160 --
 drivers/staging/rtl8712/mlme_osdep.h               |   31 -
 drivers/staging/rtl8712/mp_custom_oid.h            |  287 ---
 drivers/staging/rtl8712/os_intfs.c                 |  465 ----
 drivers/staging/rtl8712/osdep_intf.h               |   32 -
 drivers/staging/rtl8712/osdep_service.h            |   60 -
 drivers/staging/rtl8712/recv_linux.c               |  139 --
 drivers/staging/rtl8712/recv_osdep.h               |   39 -
 drivers/staging/rtl8712/rtl8712_bitdef.h           |   26 -
 drivers/staging/rtl8712/rtl8712_cmd.c              |  409 ----
 drivers/staging/rtl8712/rtl8712_cmd.h              |  231 --
 drivers/staging/rtl8712/rtl8712_cmdctrl_bitdef.h   |   95 -
 drivers/staging/rtl8712/rtl8712_cmdctrl_regdef.h   |   19 -
 drivers/staging/rtl8712/rtl8712_debugctrl_bitdef.h |   41 -
 drivers/staging/rtl8712/rtl8712_debugctrl_regdef.h |   32 -
 .../staging/rtl8712/rtl8712_edcasetting_bitdef.h   |   65 -
 .../staging/rtl8712/rtl8712_edcasetting_regdef.h   |   24 -
 drivers/staging/rtl8712/rtl8712_efuse.c            |  564 -----
 drivers/staging/rtl8712/rtl8712_efuse.h            |   43 -
 drivers/staging/rtl8712/rtl8712_event.h            |   86 -
 drivers/staging/rtl8712/rtl8712_fifoctrl_bitdef.h  |  131 --
 drivers/staging/rtl8712/rtl8712_fifoctrl_regdef.h  |   61 -
 drivers/staging/rtl8712/rtl8712_gp_bitdef.h        |   68 -
 drivers/staging/rtl8712/rtl8712_gp_regdef.h        |   29 -
 drivers/staging/rtl8712/rtl8712_hal.h              |  142 --
 drivers/staging/rtl8712/rtl8712_interrupt_bitdef.h |   44 -
 drivers/staging/rtl8712/rtl8712_io.c               |   99 -
 drivers/staging/rtl8712/rtl8712_led.c              | 1830 ---------------
 .../staging/rtl8712/rtl8712_macsetting_bitdef.h    |   31 -
 .../staging/rtl8712/rtl8712_macsetting_regdef.h    |   20 -
 drivers/staging/rtl8712/rtl8712_powersave_bitdef.h |   39 -
 drivers/staging/rtl8712/rtl8712_powersave_regdef.h |   26 -
 drivers/staging/rtl8712/rtl8712_ratectrl_bitdef.h  |   36 -
 drivers/staging/rtl8712/rtl8712_ratectrl_regdef.h  |   43 -
 drivers/staging/rtl8712/rtl8712_recv.c             | 1079 ---------
 drivers/staging/rtl8712/rtl8712_recv.h             |  145 --
 drivers/staging/rtl8712/rtl8712_regdef.h           |   32 -
 drivers/staging/rtl8712/rtl8712_security_bitdef.h  |   34 -
 drivers/staging/rtl8712/rtl8712_spec.h             |  121 -
 drivers/staging/rtl8712/rtl8712_syscfg_bitdef.h    |  163 --
 drivers/staging/rtl8712/rtl8712_syscfg_regdef.h    |   42 -
 drivers/staging/rtl8712/rtl8712_timectrl_bitdef.h  |   49 -
 drivers/staging/rtl8712/rtl8712_timectrl_regdef.h  |   26 -
 drivers/staging/rtl8712/rtl8712_wmac_bitdef.h      |   49 -
 drivers/staging/rtl8712/rtl8712_wmac_regdef.h      |   36 -
 drivers/staging/rtl8712/rtl8712_xmit.c             |  745 -------
 drivers/staging/rtl8712/rtl8712_xmit.h             |  108 -
 drivers/staging/rtl8712/rtl871x_cmd.c              |  796 -------
 drivers/staging/rtl8712/rtl871x_cmd.h              |  761 -------
 drivers/staging/rtl8712/rtl871x_debug.h            |  130 --
 drivers/staging/rtl8712/rtl871x_eeprom.c           |  220 --
 drivers/staging/rtl8712/rtl871x_eeprom.h           |   88 -
 drivers/staging/rtl8712/rtl871x_event.h            |  109 -
 drivers/staging/rtl8712/rtl871x_ht.h               |   33 -
 drivers/staging/rtl8712/rtl871x_io.c               |  147 --
 drivers/staging/rtl8712/rtl871x_io.h               |  236 --
 drivers/staging/rtl8712/rtl871x_ioctl.h            |   94 -
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      | 2330 --------------------
 drivers/staging/rtl8712/rtl871x_ioctl_rtl.c        |  519 -----
 drivers/staging/rtl8712/rtl871x_ioctl_rtl.h        |  109 -
 drivers/staging/rtl8712/rtl871x_ioctl_set.c        |  354 ---
 drivers/staging/rtl8712/rtl871x_ioctl_set.h        |   45 -
 drivers/staging/rtl8712/rtl871x_led.h              |  118 -
 drivers/staging/rtl8712/rtl871x_mlme.c             | 1709 --------------
 drivers/staging/rtl8712/rtl871x_mlme.h             |  205 --
 drivers/staging/rtl8712/rtl871x_mp.c               |  724 ------
 drivers/staging/rtl8712/rtl871x_mp.h               |  275 ---
 drivers/staging/rtl8712/rtl871x_mp_ioctl.c         |  883 --------
 drivers/staging/rtl8712/rtl871x_mp_ioctl.h         |  328 ---
 drivers/staging/rtl8712/rtl871x_mp_phy_regdef.h    | 1034 ---------
 drivers/staging/rtl8712/rtl871x_pwrctrl.c          |  234 --
 drivers/staging/rtl8712/rtl871x_pwrctrl.h          |  113 -
 drivers/staging/rtl8712/rtl871x_recv.c             |  669 ------
 drivers/staging/rtl8712/rtl871x_recv.h             |  208 --
 drivers/staging/rtl8712/rtl871x_rf.h               |   55 -
 drivers/staging/rtl8712/rtl871x_security.c         | 1386 ------------
 drivers/staging/rtl8712/rtl871x_security.h         |  218 --
 drivers/staging/rtl8712/rtl871x_sta_mgt.c          |  263 ---
 drivers/staging/rtl8712/rtl871x_wlan_sme.h         |   35 -
 drivers/staging/rtl8712/rtl871x_xmit.c             | 1059 ---------
 drivers/staging/rtl8712/rtl871x_xmit.h             |  288 ---
 drivers/staging/rtl8712/sta_info.h                 |  132 --
 drivers/staging/rtl8712/usb_halinit.c              |  307 ---
 drivers/staging/rtl8712/usb_intf.c                 |  638 ------
 drivers/staging/rtl8712/usb_ops.c                  |  195 --
 drivers/staging/rtl8712/usb_ops.h                  |   38 -
 drivers/staging/rtl8712/usb_ops_linux.c            |  515 -----
 drivers/staging/rtl8712/usb_osintf.h               |   35 -
 drivers/staging/rtl8712/wifi.h                     |  196 --
 drivers/staging/rtl8712/wlan_bssdef.h              |  223 --
 drivers/staging/rtl8712/xmit_linux.c               |  181 --
 drivers/staging/rtl8712/xmit_osdep.h               |   52 -
 drivers/target/loopback/tcm_loop.c                 |    3 +
 drivers/tee/tee_core.c                             |    2 +-
 drivers/thunderbolt/nhi.c                          |    2 +
 drivers/thunderbolt/nhi.h                          |    1 +
 drivers/thunderbolt/tb.c                           |    2 +-
 drivers/tty/serial/amba-pl011.c                    |    2 +-
 drivers/tty/serial/sc16is7xx.c                     |  185 +-
 drivers/ufs/core/ufshcd.c                          |    7 +-
 drivers/ufs/host/ufs-mediatek.c                    |   46 +-
 drivers/ufs/host/ufshcd-pci.c                      |   70 +-
 drivers/uio/uio_hv_generic.c                       |   21 +-
 drivers/usb/cdns3/cdns3-pci-wrap.c                 |    5 +-
 drivers/usb/cdns3/cdnsp-gadget.c                   |    8 +-
 drivers/usb/dwc3/core.c                            |    3 +-
 drivers/usb/dwc3/ep0.c                             |    1 +
 drivers/usb/dwc3/gadget.c                          |    7 +
 drivers/usb/gadget/function/f_eem.c                |    7 +-
 drivers/usb/gadget/function/f_fs.c                 |    8 +-
 drivers/usb/gadget/function/f_hid.c                |    4 +-
 drivers/usb/gadget/function/f_ncm.c                |    3 +-
 drivers/usb/gadget/udc/core.c                      |   18 +-
 drivers/usb/gadget/udc/trace.h                     |    5 +
 drivers/usb/host/xhci-dbgcap.c                     |  261 ++-
 drivers/usb/host/xhci-dbgcap.h                     |   12 +-
 drivers/usb/host/xhci-dbgtty.c                     |   23 +-
 drivers/usb/host/xhci-plat.c                       |    1 +
 drivers/usb/mon/mon_bin.c                          |   14 +-
 drivers/usb/renesas_usbhs/common.c                 |   18 +-
 drivers/usb/serial/ftdi_sio.c                      |    1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    1 +
 drivers/usb/serial/option.c                        |   10 +-
 drivers/usb/storage/sddr55.c                       |    6 +
 drivers/usb/storage/transport.c                    |   16 +
 drivers/usb/storage/uas.c                          |    5 +
 drivers/usb/storage/unusual_devs.h                 |    2 +-
 drivers/usb/typec/ucsi/psy.c                       |    5 +
 drivers/vfio/iova_bitmap.c                         |    5 +-
 drivers/vfio/vfio_main.c                           |    2 +-
 drivers/video/backlight/lp855x_bl.c                |    2 +-
 drivers/video/fbdev/aty/atyfb_base.c               |    8 +-
 drivers/video/fbdev/core/bitblit.c                 |   33 +-
 drivers/video/fbdev/core/fbcon.c                   |   19 +
 drivers/video/fbdev/core/fbmem.c                   |    1 +
 drivers/video/fbdev/pvr2fb.c                       |    2 +-
 drivers/video/fbdev/valkyriefb.c                   |    2 +
 drivers/watchdog/s3c2410_wdt.c                     |   10 +-
 fs/9p/v9fs.c                                       |    9 +-
 fs/btrfs/disk-io.c                                 |    2 +-
 fs/btrfs/extent-tree.c                             |    6 +-
 fs/btrfs/file.c                                    |   10 +
 fs/btrfs/scrub.c                                   |    3 +-
 fs/btrfs/transaction.c                             |    2 +-
 fs/btrfs/tree-log.c                                |    3 +-
 fs/ceph/file.c                                     |    2 -
 fs/ceph/locks.c                                    |    5 +-
 fs/direct-io.c                                     |   10 +-
 fs/eventpoll.c                                     |  139 +-
 fs/exfat/fatent.c                                  |   11 +-
 fs/exfat/super.c                                   |    5 +-
 fs/ext4/fast_commit.c                              |    2 +-
 fs/ext4/file.c                                     |    9 +-
 fs/ext4/xattr.c                                    |    2 +-
 fs/f2fs/file.c                                     |    1 -
 fs/hpfs/namei.c                                    |   18 +-
 fs/iomap/direct-io.c                               |   12 +-
 fs/jfs/inode.c                                     |    8 +-
 fs/jfs/jfs_txnmgr.c                                |    9 +-
 fs/libfs.c                                         |   42 +
 fs/nfs/file.c                                      |    1 -
 fs/nfs/nfs4client.c                                |    1 +
 fs/nfs/nfs4proc.c                                  |   15 +-
 fs/nfs/nfs4state.c                                 |    3 +
 fs/nfs/write.c                                     |    3 +-
 fs/nfsd/nfs4proc.c                                 |    7 +-
 fs/nfsd/nfs4state.c                                |    9 +-
 fs/nilfs2/the_nilfs.c                              |    3 -
 fs/ntfs3/inode.c                                   |    1 +
 fs/open.c                                          |   10 +-
 fs/orangefs/xattr.c                                |   12 +-
 fs/proc/generic.c                                  |   12 +-
 fs/smb/client/cifsfs.c                             |    2 +-
 fs/smb/client/connect.c                            |    1 +
 fs/smb/client/smb2inode.c                          |    2 +
 fs/smb/client/smb2pdu.c                            |    7 +-
 fs/smb/client/transport.c                          |   10 +-
 fs/smb/server/smb2pdu.c                            |    6 +-
 fs/smb/server/transport_tcp.c                      |   12 +-
 include/acpi/pcc.h                                 |   20 +
 include/linux/array_size.h                         |   13 +
 include/linux/ata.h                                |    1 +
 include/linux/blk_types.h                          |   11 +-
 include/linux/cacheinfo.h                          |   11 +-
 include/linux/compiler_types.h                     |    5 +-
 include/linux/fbcon.h                              |    2 +
 include/linux/filter.h                             |   22 +-
 include/linux/fs.h                                 |    7 +-
 include/linux/host1x.h                             |    2 +
 include/linux/kernel.h                             |    7 +-
 include/linux/mailbox_client.h                     |    1 +
 include/linux/map_benchmark.h                      |    1 +
 include/linux/mlx5/driver.h                        |    2 +
 include/linux/mlx5/mlx5_ifc.h                      |   61 +
 include/linux/pagemap.h                            |    2 +
 include/linux/pci.h                                |    2 +-
 include/linux/shdma-base.h                         |    2 +-
 include/linux/string.h                             |    1 +
 include/linux/usb/gadget.h                         |    5 +
 include/net/bluetooth/hci.h                        |   12 +
 include/net/bluetooth/hci_core.h                   |    8 +-
 include/net/bluetooth/mgmt.h                       |    2 +-
 include/net/cls_cgroup.h                           |    2 +-
 include/net/nfc/nci_core.h                         |    2 +-
 include/net/pkt_sched.h                            |   25 +-
 include/net/tc_act/tc_connmark.h                   |   10 +-
 include/net/tls.h                                  |    6 +
 include/net/xdp.h                                  |    5 +
 include/net/xfrm.h                                 |    3 +-
 include/trace/events/irq.h                         |   47 +
 include/uapi/asm-generic/bitsperlong.h             |   13 +-
 include/ufs/ufshcd.h                               |    7 +
 include/ufs/ufshci.h                               |    4 +-
 kernel/bpf/ringbuf.c                               |    2 +
 kernel/events/callchain.c                          |   10 +-
 kernel/events/uprobes.c                            |    7 +
 kernel/futex/syscalls.c                            |  106 +-
 kernel/gcov/gcc_4_7.c                              |    4 +-
 kernel/softirq.c                                   |    9 +-
 kernel/time/timer.c                                |    7 +-
 kernel/trace/ftrace.c                              |    2 +
 kernel/trace/trace_events_hist.c                   |    6 +-
 lib/crypto/Makefile                                |    2 +-
 lib/maple_tree.c                                   |   30 +-
 mm/filemap.c                                       |  173 +-
 mm/memory.c                                        |   24 +-
 mm/mempool.c                                       |   32 +-
 mm/page_alloc.c                                    |    2 +-
 mm/percpu.c                                        |    8 +-
 mm/secretmem.c                                     |    2 +-
 mm/truncate.c                                      |   27 +-
 net/8021q/vlan.c                                   |    2 +
 net/bluetooth/6lowpan.c                            |  103 +-
 net/bluetooth/hci_event.c                          |   34 +
 net/bluetooth/hci_sync.c                           |   19 +-
 net/bluetooth/iso.c                                |   36 +-
 net/bluetooth/l2cap_core.c                         |    1 +
 net/bluetooth/mgmt.c                               |    7 +-
 net/bluetooth/sco.c                                |    7 +
 net/bluetooth/smp.c                                |   31 +-
 net/bridge/br.c                                    |    5 +
 net/bridge/br_forward.c                            |    5 +-
 net/bridge/br_if.c                                 |    1 +
 net/bridge/br_input.c                              |    4 +-
 net/bridge/br_mst.c                                |   10 +-
 net/bridge/br_private.h                            |   13 +-
 net/ceph/auth_x.c                                  |    2 +
 net/ceph/ceph_common.c                             |   53 +-
 net/ceph/debugfs.c                                 |   16 +-
 net/ceph/osdmap.c                                  |   18 +-
 net/core/filter.c                                  |    1 +
 net/core/netpoll.c                                 |    7 +-
 net/core/page_pool.c                               |   12 +-
 net/core/sock.c                                    |   15 +-
 net/dsa/tag_brcm.c                                 |   10 +-
 net/ethernet/eth.c                                 |    5 +-
 net/hsr/hsr_device.c                               |    3 +
 net/ipv4/esp4.c                                    |    4 +-
 net/ipv4/esp4_offload.c                            |    6 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   25 +
 net/ipv4/nexthop.c                                 |    6 +
 net/ipv4/route.c                                   |    5 +
 net/ipv4/udp_tunnel_nic.c                          |    2 +-
 net/ipv6/addrconf.c                                |    4 +-
 net/ipv6/ah6.c                                     |   50 +-
 net/ipv6/esp6.c                                    |    4 +-
 net/ipv6/esp6_offload.c                            |    6 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |   30 +
 net/ipv6/raw.c                                     |    2 +-
 net/ipv6/udp.c                                     |    2 +-
 net/mac80211/iface.c                               |   14 +-
 net/mac80211/mlme.c                                |    2 +-
 net/mac80211/rx.c                                  |   10 +-
 net/mptcp/options.c                                |   54 +-
 net/mptcp/pm_netlink.c                             |   26 +-
 net/mptcp/protocol.c                               |  125 +-
 net/mptcp/protocol.h                               |    5 +-
 net/mptcp/subflow.c                                |    8 +
 net/netfilter/nf_tables_api.c                      |   15 +
 net/openvswitch/actions.c                          |   68 +-
 net/openvswitch/flow_netlink.c                     |   64 +-
 net/openvswitch/flow_netlink.h                     |    2 -
 net/rds/rds.h                                      |    2 +-
 net/sched/act_bpf.c                                |    6 +-
 net/sched/act_connmark.c                           |  134 +-
 net/sched/act_ife.c                                |   12 +-
 net/sched/cls_bpf.c                                |    6 +-
 net/sched/sch_api.c                                |   10 -
 net/sched/sch_generic.c                            |   17 +-
 net/sched/sch_hfsc.c                               |   16 -
 net/sched/sch_qfq.c                                |    2 +-
 net/sctp/diag.c                                    |   23 +-
 net/sctp/transport.c                               |   13 +-
 net/smc/smc_clc.c                                  |    1 +
 net/strparser/strparser.c                          |    2 +-
 net/tipc/net.c                                     |    2 +
 net/tls/tls_device.c                               |    4 +-
 net/unix/garbage.c                                 |   14 +-
 net/vmw_vsock/af_vsock.c                           |   40 +-
 net/xfrm/espintcp.c                                |    4 +-
 scripts/kconfig/mconf.c                            |    3 +
 scripts/kconfig/nconf.c                            |    3 +
 sound/drivers/serial-generic.c                     |   12 +-
 sound/pci/hda/patch_realtek.c                      |   17 +-
 sound/soc/codecs/cs4271.c                          |   10 +-
 sound/soc/codecs/lpass-va-macro.c                  |    2 +-
 sound/soc/codecs/max98090.c                        |    6 +-
 sound/soc/fsl/fsl_sai.c                            |    3 +-
 sound/soc/intel/avs/pcm.c                          |    2 +
 sound/soc/meson/aiu-encoder-i2s.c                  |    9 +-
 sound/soc/qcom/qdsp6/q6asm.c                       |    2 +-
 sound/soc/qcom/sc8280xp.c                          |    3 +
 sound/usb/endpoint.c                               |    5 +
 sound/usb/mixer.c                                  |   11 +-
 sound/usb/mixer_s1810c.c                           |   28 +-
 sound/usb/quirks.c                                 |    3 +
 sound/usb/validate.c                               |    9 +-
 tools/bpf/bpftool/btf_dumper.c                     |    2 +-
 tools/bpf/bpftool/prog.c                           |    2 +-
 tools/include/linux/bitmap.h                       |    1 +
 tools/include/uapi/asm-generic/bitsperlong.h       |   14 +-
 tools/include/uapi/asm/bitsperlong.h               |    6 -
 tools/lib/bpf/bpf_tracing.h                        |    2 +-
 tools/lib/thermal/Makefile                         |    9 +-
 tools/power/cpupower/lib/cpuidle.c                 |    5 +-
 tools/power/cpupower/lib/cpupower.c                |    2 +-
 .../x86_energy_perf_policy.c                       |   30 +-
 tools/testing/selftests/Makefile                   |    2 +-
 tools/testing/selftests/bpf/test_lirc_mode2_user.c |    2 +-
 tools/testing/selftests/bpf/test_xsk.sh            |    2 +
 .../selftests/drivers/net/netdevsim/Makefile       |   21 +
 .../selftests/drivers/net/netdevsim/settings       |    1 +
 tools/testing/selftests/net/bareudp.sh             |    2 +-
 tools/testing/selftests/net/fcnal-test.sh          |  432 ++--
 .../selftests/net/forwarding/local_termination.sh  |    2 +
 tools/testing/selftests/net/gro.c                  |  101 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   18 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |    2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   65 +-
 tools/testing/selftests/net/psock_tpacket.c        |    4 +-
 tools/testing/selftests/net/traceroute.sh          |   13 +-
 tools/tracing/latency/latency-collector.c          |    2 +-
 usr/include/headers_check.pl                       |    2 +
 679 files changed, 5917 insertions(+), 30300 deletions(-)


