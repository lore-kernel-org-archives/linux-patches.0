Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DE9361DB7;
	Wed,  3 Dec 2025 16:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781020; cv=none; b=C/QOix15aQ9jVR4SW4D27k0/JEbxJ4QBajolLMA0g4okMzdmJRwsSxq2I6A6BcsOtgvMkv/g0RGAgwuHEmJb0o9jtKNimt4mWoJl5mx0o9VUEMCBUIkDbEqsBlVghskUyAnmESpsskHa7pfbfx97BrAkW9fM6AUW496eOaaibFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781020; c=relaxed/simple;
	bh=f+EC6NoO8HAKhfYFh5T4u2O6FJuVgBco1yOESOsLU+c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gKTd81ifO1J5cjdmVlI7auh7DqzpzYM2l9A6Sm1DuUoPfcGWNHsSj8xZfQOg6xg7Tojw44IWbBqxOvtvSOa+XF++4PAfJ3e1eCQ/WxLaPwJtYd+dk3n5ILc3dCtkqrpOJIri+GrJXEf4M9lryjYZRXMNUji6kQISMZIRfcdeVK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyXxb9nZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyXxb9nZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CBDC4CEF5;
	Wed,  3 Dec 2025 16:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781020;
	bh=f+EC6NoO8HAKhfYFh5T4u2O6FJuVgBco1yOESOsLU+c=;
	h=From:To:Cc:Subject:Date:From;
	b=pyXxb9nZb0t4L9Sm+khMDdXMXQq18MyY30iG8yHeFWVxXhxEprUnCnOV2aRRoIdua
	 LYiJm9X20RYMKJHQuFCbo829xKnkNoPv5Sqj70ElYEglTMu85o9Pji46Jju50EyU/M
	 vEzUSuNna+oWGkLxOFcojThfvXWGFtRMW6SpF7VA=
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
Subject: [PATCH 6.6 00/93] 6.6.119-rc1 review
Date: Wed,  3 Dec 2025 16:28:53 +0100
Message-ID: <20251203152336.494201426@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.119-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.119-rc1
X-KernelTest-Deadline: 2025-12-05T15:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.119 release.
There are 93 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.119-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.119-rc1

Alan Stern <stern@rowland.harvard.edu>
    HID: core: Harden s32ton() against conversion to 0 bits

Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
    net: dsa: microchip: Free previously initialized ports on init failures

Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
    net: dsa: microchip: Fix symetry in ksz_ptp_msg_irq_{setup/free}()

Sean Heelan <seanheelan@gmail.com>
    ksmbd: fix use-after-free in session logoff

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix duplicate reset on fastclose

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: properly kill background tasks

Philipp Hortmann <philipp.g.hortmann@gmail.com>
    staging: rtl8712: Remove driver using deprecated API wext

luoguangfei <15388634752@163.com>
    net: macb: fix unregister_netdev call order in macb_remove()

ChiYuan Huang <cy_huang@richtek.com>
    iio: adc: rtq6056: Correct the sign bit index

Biju Das <biju.das.jz@bp.renesas.com>
    can: rcar_canfd: Fix CAN-FD mode as default

Jameson Thies <jthies@google.com>
    usb: typec: ucsi: psy: Set max current to zero when disconnected

Jimmy Hu <hhhuuu@google.com>
    usb: gadget: udc: fix use-after-free in usb_gadget_state_work

Kuen-Han Tsai <khtsai@google.com>
    usb: udc: Add trace event for usb_gadget_set_state

NeilBrown <neil@brown.name>
    nfsd: Replace clamp_t in nfsd4_get_drc_mem()

Wang Liang <wangliang74@huawei.com>
    bonding: check xdp prog when set bond mode

Hangbin Liu <liuhangbin@gmail.com>
    bonding: return detailed error when loading native XDP fails

ziming zhang <ezrakiez@gmail.com>
    libceph: replace BUG_ON with bounds check for map->max_osd

ziming zhang <ezrakiez@gmail.com>
    libceph: prevent potential out-of-bounds writes in handle_auth_session_key()

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix potential use-after-free in have_mon_and_osd_map()

Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
    net: dsa: microchip: ptp: Fix checks on irq_find_mapping()

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

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: Sort out the Intel device IDs

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Nova Lake -S

Owen Gu <guhuinan@xiaomi.com>
    usb: uas: fix urb unmapping issue when the uas device is remove during ongoing data transfer

Tianchu Chen <flynnnchen@tencent.com>
    usb: storage: sddr55: Reject out-of-bound new_pba

Alan Stern <stern@rowland.harvard.edu>
    USB: storage: Remove subclass and protocol overrides from Novatek quirk

Desnes Nunes <desnesn@redhat.com>
    usb: storage: Fix memory leak in USB bulk transport

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    usb: renesas_usbhs: Fix synchronous external abort on unbind

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_eem: Fix memory leak in eem_unwrap

Miaoqian Lin <linmq006@gmail.com>
    usb: cdns3: Fix double resource release in cdns3_pci_probe

Johan Hovold <johan@kernel.org>
    most: usb: fix double free on late probe failure

Miaoqian Lin <linmq006@gmail.com>
    serial: amba-pl011: prefer dma_mapping_error() over explicit address checking

Paolo Abeni <pabeni@redhat.com>
    mptcp: clear scheduled subflows on retransmit

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

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: fix crash in process_v2_sparse_read() for encrypted directories

Marc Kleine-Budde <mkl@pengutronix.de>
    can: sun4i_can: sun4i_can_interrupt(): fix max irq loop handling

Thomas Mühlbacher <tmuehlbacher@posteo.net>
    can: sja1000: fix max irq loop handling

Gui-Dong Han <hanguidong02@gmail.com>
    atm/fore200e: Fix possible data race in fore200e_open()

Maarten Zanders <maarten@zanders.be>
    ARM: dts: nxp: imx6ul: correct SAI3 interrupt line

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

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: nxp-fspi: Propagate fwnode in ACPI case as well

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: nxp-fspi: Support per spi-mem operation frequency switches

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: spi-mem: Add a new controller capability

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: spi-mem: Extend spi-mem operations with a per-operation maximum frequency

Tudor Ambarus <tudor.ambarus@linaro.org>
    spi: spi-mem: Allow specifying the byte order in Octal DTR mode

Haotian Zhang <vulab@iscas.ac.cn>
    spi: amlogic-spifc-a1: Handle devm_pm_runtime_enable() errors

Francesco Lavra <flavra@baylibre.com>
    spi: tegra114: remove Kconfig dependency on TEGRA20_APB_DMA

Jamie Iles <jamie.iles@oss.qualcomm.com>
    mailbox: pcc: don't zero error register

Sudeep Holla <sudeep.holla@arm.com>
    mailbox: pcc: Refactor error handling in irq handler into separate function

Haotian Zhang <vulab@iscas.ac.cn>
    mailbox: mailbox-test: Fix debugfs_create_dir error checking

Haotian Zhang <vulab@iscas.ac.cn>
    usb: gadget: renesas_usbf: Handle devm_pm_runtime_enable() errors

Mario Tesi <martepisa@gmail.com>
    iio: st_lsm6dsx: Fixed calibrated timestamp calculation

Wei Fang <wei.fang@nxp.com>
    net: fec: do not register PPS event for PEROUT

Wei Fang <wei.fang@nxp.com>
    net: fec: do not allow enabling PPS and PEROUT simultaneously

Wei Fang <wei.fang@nxp.com>
    net: fec: do not update PEROUT if it is enabled

Wei Fang <wei.fang@nxp.com>
    net: fec: cancel perout_timer when PEROUT is disabled

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

Daniel Golle <daniel@makrotopia.org>
    net: phy: mxl-gpy: fix bogus error on USXGMII and integrated PHY

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SMP: Fix not generating mackey and ltk when repairing

Edward Adam Davis <eadavis@qq.com>
    Bluetooth: hci_sock: Prevent race in socket write iter and sock bind

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_receive_bulk_callback(): check actual_length before accessing data

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_receive_bulk_callback(): check actual_length before accessing header

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_xmit_callback(): fix handling of failed transmitted URBs

Seungjin Bae <eeodqql09@gmail.com>
    can: kvaser_usb: leaf: Fix potential infinite loop in command parsers


-------------

Diffstat:

 MAINTAINERS                                        |    6 -
 Makefile                                           |    4 +-
 arch/arm/boot/dts/nxp/imx/imx6ul.dtsi              |    2 +-
 arch/mips/mm/tlb-r4k.c                             |  118 +-
 arch/x86/events/core.c                             |   10 +-
 drivers/atm/fore200e.c                             |    2 +
 drivers/firmware/stratix10-svc.c                   |    7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |    2 +
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c    |   11 +-
 drivers/gpu/drm/sti/sti_vtg.c                      |    7 +-
 drivers/hid/hid-core.c                             |    7 +-
 drivers/iio/accel/adxl355_core.c                   |   44 +-
 drivers/iio/accel/bmc150-accel-core.c              |    5 +
 drivers/iio/accel/bmc150-accel.h                   |    1 +
 drivers/iio/adc/ad7280a.c                          |    2 +-
 drivers/iio/adc/rtq6056.c                          |    2 +-
 drivers/iio/common/ssp_sensors/ssp_dev.c           |    4 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h            |   40 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |   19 +-
 drivers/mailbox/mailbox-test.c                     |    2 +-
 drivers/mailbox/pcc.c                              |   32 +-
 drivers/md/dm-verity-fec.c                         |    6 +-
 drivers/most/most_usb.c                            |   14 +-
 drivers/mtd/nand/spi/core.c                        |    2 +
 drivers/net/bonding/bond_main.c                    |   11 +-
 drivers/net/bonding/bond_options.c                 |    3 +
 drivers/net/can/rcar/rcar_canfd.c                  |   53 +-
 drivers/net/can/sja1000/sja1000.c                  |    4 +-
 drivers/net/can/sun4i_can.c                        |    4 +-
 drivers/net/can/usb/gs_usb.c                       |  102 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |    4 +-
 drivers/net/dsa/microchip/ksz_common.c             |   30 +-
 drivers/net/dsa/microchip/ksz_ptp.c                |   22 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |   66 +-
 .../net/ethernet/aquantia/atlantic/aq_hw_utils.c   |   22 +
 .../net/ethernet/aquantia/atlantic/aq_hw_utils.h   |    1 +
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |    5 +
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |   19 +-
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c   |    2 +-
 drivers/net/ethernet/cadence/macb_main.c           |    2 +-
 drivers/net/ethernet/freescale/fec.h               |    1 +
 drivers/net/ethernet/freescale/fec_ptp.c           |   64 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |    2 +-
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |    5 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |    4 +-
 drivers/net/phy/mxl-gpy.c                          |    2 +-
 drivers/platform/x86/intel/punit_ipc.c             |    2 +-
 drivers/slimbus/qcom-ngd-ctrl.c                    |    1 +
 drivers/spi/Kconfig                                |    4 +-
 drivers/spi/spi-amlogic-spifc-a1.c                 |    4 +-
 drivers/spi/spi-bcm63xx.c                          |   14 +
 drivers/spi/spi-mem.c                              |   37 +
 drivers/spi/spi-nxp-fspi.c                         |   22 +-
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
 drivers/staging/rtl8712/os_intfs.c                 |  482 ----
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
 drivers/staging/rtl8712/rtl8712_efuse.h            |   44 -
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
 drivers/staging/rtl8712/rtl8712_recv.c             | 1080 ---------
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
 drivers/staging/rtl8712/rtl8712_xmit.c             |  744 -------
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
 drivers/staging/rtl8712/rtl871x_mlme.c             | 1710 --------------
 drivers/staging/rtl8712/rtl871x_mlme.h             |  205 --
 drivers/staging/rtl8712/rtl871x_mp.c               |  724 ------
 drivers/staging/rtl8712/rtl871x_mp.h               |  275 ---
 drivers/staging/rtl8712/rtl871x_mp_ioctl.c         |  883 --------
 drivers/staging/rtl8712/rtl871x_mp_ioctl.h         |  328 ---
 drivers/staging/rtl8712/rtl871x_mp_phy_regdef.h    | 1034 ---------
 drivers/staging/rtl8712/rtl871x_pwrctrl.c          |  234 --
 drivers/staging/rtl8712/rtl871x_pwrctrl.h          |  113 -
 drivers/staging/rtl8712/rtl871x_recv.c             |  671 ------
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
 drivers/thunderbolt/nhi.c                          |    2 +
 drivers/thunderbolt/nhi.h                          |    1 +
 drivers/tty/serial/amba-pl011.c                    |    2 +-
 drivers/usb/cdns3/cdns3-pci-wrap.c                 |    5 +-
 drivers/usb/dwc3/core.c                            |    3 +-
 drivers/usb/dwc3/dwc3-pci.c                        |   82 +-
 drivers/usb/dwc3/ep0.c                             |    1 +
 drivers/usb/dwc3/gadget.c                          |    7 +
 drivers/usb/gadget/function/f_eem.c                |    7 +-
 drivers/usb/gadget/udc/core.c                      |   18 +-
 drivers/usb/gadget/udc/renesas_usbf.c              |    4 +-
 drivers/usb/gadget/udc/trace.h                     |    5 +
 drivers/usb/host/xhci-dbgcap.h                     |    1 +
 drivers/usb/host/xhci-dbgtty.c                     |   23 +-
 drivers/usb/renesas_usbhs/common.c                 |   14 +-
 drivers/usb/serial/ftdi_sio.c                      |    1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    1 +
 drivers/usb/serial/option.c                        |   10 +-
 drivers/usb/storage/sddr55.c                       |    6 +
 drivers/usb/storage/transport.c                    |   16 +
 drivers/usb/storage/uas.c                          |    5 +
 drivers/usb/storage/unusual_devs.h                 |    2 +-
 drivers/usb/typec/ucsi/psy.c                       |    5 +
 fs/nfsd/nfs4state.c                                |    6 +-
 fs/smb/client/connect.c                            |    1 +
 fs/smb/server/smb2pdu.c                            |    4 -
 include/linux/spi/spi-mem.h                        |   22 +-
 include/linux/usb/gadget.h                         |    5 +
 include/net/bonding.h                              |    1 +
 net/bluetooth/hci_sock.c                           |    2 +
 net/bluetooth/smp.c                                |   31 +-
 net/ceph/auth_x.c                                  |    2 +
 net/ceph/ceph_common.c                             |   53 +-
 net/ceph/debugfs.c                                 |   16 +-
 net/ceph/messenger_v2.c                            |   11 +-
 net/ceph/osdmap.c                                  |   18 +-
 net/mptcp/protocol.c                               |   48 +-
 sound/usb/quirks.c                                 |    3 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   14 +-
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     |   21 +
 196 files changed, 914 insertions(+), 28087 deletions(-)


