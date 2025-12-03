Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43F5327BF9;
	Wed,  3 Dec 2025 15:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776967; cv=none; b=Y0u/UMM5yNTShklC0djhBliIg8XOLSpLoGxJ5L1Wze37VGkTRVmw07oTHudN12Kvw2MSzyWA+7rOFe7MOVsYiji6U+T1puC84p2Jh+nxlW7ePa/lksnPeS0ESHfp+K7oL+HtSD6MHuOShWGruz2nnIf2ZhAYQCeMGmyb+H9hwpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776967; c=relaxed/simple;
	bh=/ZLhSTc33vhI8KTBmmveUGuqQ1SjfzowJrgoP2L7ikE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qdp150CtRmWDbz9DLny9NEHXfQ76EbzDxKC7EVNac61v7q5/aXjyZYTUT4tpqPCbYxneA9oFj4BoxCzP6dMVRyIwGS0in1wv/JNfWhHFL5sFddQypsADg9I76Jpi9C5q/fKOMd+aAXhXCjFPbTY7yEt0r2wZiMxKR85d45I7rTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBIiCSrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBIiCSrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA52C4CEF5;
	Wed,  3 Dec 2025 15:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776966;
	bh=/ZLhSTc33vhI8KTBmmveUGuqQ1SjfzowJrgoP2L7ikE=;
	h=From:To:Cc:Subject:Date:From;
	b=oBIiCSrrD4Jsk1VSEHhsf8sbau/2M/orjBUd1E3ldtd5SQxse6cLGsFHImZQiDYXa
	 g/e13chXuWwsWQn5Sp/xBYj6io4F70RZvrAykom7aU7Pz+GBNRet9OgoGFjqPSZ74i
	 X1qN4o+21iHpajG84xIEWomH1izE1aR3lLtcA5oI=
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
Subject: [PATCH 6.17 000/146] 6.17.11-rc1 review
Date: Wed,  3 Dec 2025 16:26:18 +0100
Message-ID: <20251203152346.456176474@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.17.11-rc1
X-KernelTest-Deadline: 2025-12-05T15:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.17.11 release.
There are 146 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.17.11-rc1

Siddharth Vadapalli <s-vadapalli@ti.com>
    spi: cadence-quadspi: Fix cqspi_probe() error handling for runtime pm

Punit Agrawal <punit.agrawal@oss.qualcomm.com>
    Revert "ACPI: Suppress misleading SPCR console message when SPCR table is absent"

Jimmy Hu <hhhuuu@google.com>
    usb: gadget: udc: fix use-after-free in usb_gadget_state_work

Kuen-Han Tsai <khtsai@google.com>
    usb: udc: Add trace event for usb_gadget_set_state

Youngjun Park <youngjun.park@lge.com>
    mm: swap: remove duplicate nr_swap_pages decrement in get_swap_page_of_type()

ziming zhang <ezrakiez@gmail.com>
    libceph: replace BUG_ON with bounds check for map->max_osd

ziming zhang <ezrakiez@gmail.com>
    libceph: prevent potential out-of-bounds writes in handle_auth_session_key()

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix potential use-after-free in have_mon_and_osd_map()

Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
    net: dsa: microchip: Fix symetry in ksz_ptp_msg_irq_{setup/free}()

Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
    net: dsa: microchip: Free previously initialized ports on init failures

Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
    net: dsa: microchip: Don't free uninitialized ksz_irq

Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
    net: dsa: microchip: ptp: Fix checks on irq_find_mapping()

Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
    net: dsa: microchip: common: Fix checks on irq_find_mapping()

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd/display: Increase EDID read retries

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd/display: Don't change brightness for disabled connectors

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check NULL before accessing

Michael Chen <michael.chen@amd.com>
    drm/amd/amdgpu: reserve vm invalidation engine for uni_mes

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: attach tlb fence to the PTs update

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe/guc: Fix stack_depot usage

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/psr: Reject async flips when selective fetch is enabled

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

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix stale flag preventig URBs after link state error is cleared

Manish Nagar <manish.nagar@oss.qualcomm.com>
    usb: dwc3: Fix race condition between concurrent dwc3_remove_requests() call paths

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: Sort out the Intel device IDs

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Nova Lake -S

Owen Gu <guhuinan@xiaomi.com>
    usb: uas: fix urb unmapping issue when the uas device is remove during ongoing data transfer

Jameson Thies <jthies@google.com>
    usb: typec: ucsi: psy: Set max current to zero when disconnected

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

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Fix 8250_rsa symbol loop

Kuniyuki Iwashima <kuniyu@google.com>
    mptcp: Initialise rcv_mss before calling tcp_send_active_reset() in mptcp_do_fastclose().

Paolo Abeni <pabeni@redhat.com>
    mptcp: clear scheduled subflows on retransmit

Jisheng Zhang <jszhang@kernel.org>
    mmc: sdhci-of-dwcmshc: Promote the th1520 reset handling to ip level

Deepanshu Kartikey <kartikey406@gmail.com>
    mm/memfd: fix information leak in hugetlb folios

Wei Yang <richard.weiyang@gmail.com>
    mm/huge_memory: fix NULL pointer deference when splitting folio

Gustavo A. R. Silva <gustavoars@kernel.org>
    iommufd/driver: Fix counter initialization for counted_by annotation

Khairul Anuar Romli <khairul.anuar.romli@altera.com>
    firmware: stratix10-svc: fix bug in saving controller data

Jens Axboe <axboe@kernel.dk>
    io_uring/net: ensure vectored buffer node import is tied to notification

ChiYuan Huang <cy_huang@richtek.com>
    regulator: rtq2208: Correct LDO2 logic judgment bits

ChiYuan Huang <cy_huang@richtek.com>
    regulator: rtq2208: Correct buck group2 phase mapping logic

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix RTL8127 hang on suspend/shutdown

Jon Hunter <jonathanh@nvidia.com>
    pmdomain: tegra: Add GENPD_FLAG_NO_STAY_ON flag

Wentao Guan <guanwentao@uniontech.com>
    nvmem: layouts: fix nvmem_layout_bus_uevent

Miaoqian Lin <linmq006@gmail.com>
    slimbus: ngd: Fix reference count leak in qcom_slim_ngd_notify_slaves

Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
    thunderbolt: Add support for Intel Wildcat Lake

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix memory leak in cifs_construct_tcon()

Thomas Zimmermann <tzimmermann@suse.de>
    drm, fbcon, vga_switcheroo: Avoid race condition in fbcon setup

Jamie Iles <jamie.iles@oss.qualcomm.com>
    drivers/usb/dwc3: fix PCI parent check

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: fix unreliable memory allocation

Dharma Balasubiramani <dharma.b@microchip.com>
    counter: microchip-tcb-capture: Allow shared IRQ for multi-channel TCBs

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: fix crash in process_v2_sparse_read() for encrypted directories

Marc Kleine-Budde <mkl@pengutronix.de>
    can: sun4i_can: sun4i_can_interrupt(): fix max irq loop handling

Thomas Mühlbacher <tmuehlbacher@posteo.net>
    can: sja1000: fix max irq loop handling

Biju Das <biju.das.jz@bp.renesas.com>
    can: rcar_canfd: Fix CAN-FD mode as default

Douglas Anderson <dianders@chromium.org>
    Bluetooth: btusb: mediatek: Avoid btusb_mtk_claim_iso_intf() NULL deref

Gui-Dong Han <hanguidong02@gmail.com>
    atm/fore200e: Fix possible data race in fore200e_open()

Maarten Zanders <maarten@zanders.be>
    ARM: dts: nxp: imx6ul: correct SAI3 interrupt line

Xu Yang <xu.yang_2@nxp.com>
    arm64: dts: imx8qm-mek: fix mux-controller select/enable-gpios polarity

Frank Li <Frank.Li@nxp.com>
    arm64: dts: imx8dxl: Correct pcie-ep interrupt number

Frank Li <Frank.Li@nxp.com>
    arm64: dts: imx8dxl-ss-conn: swap interrupts number of eqos

Ivan Zhaldak <i.v.zhaldak@gmail.com>
    ALSA: usb-audio: Add DSD quirk for LEAK Stereo 230

René Rebe <rene@exactco.de>
    ALSA: hda/cirrus fix cs420x MacPro 6,1 inverted jack detection

Deepanshu Kartikey <kartikey406@gmail.com>
    tracing: Fix WARN_ON in tracing_buffers_mmap_close for split VMAs

Jason Wang <jasowang@redhat.com>
    vhost: rewind next_avail_head while discarding descriptors

Jon Kohler <jon@nutanix.com>
    virtio-net: avoid unnecessary checksum calculation on guest RX

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: mm: kmalloc tlb_vpn array to avoid stack overflow

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: mm: Prevent a TLB shutdown on initial uniquification

ChiYuan Huang <cy_huang@richtek.com>
    iio: adc: rtq6056: Correct the sign bit index

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7380: fix SPI offload trigger rate

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7280a: fix ad7280_store_balance_timer()

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7124: fix temperature channel

Marcelo Schmitt <marcelo.schmitt@analog.com>
    iio: adc: ad4030: Fix _scale value for common-mode channels

Valek Andrej <andrej.v@skyrain.eu>
    iio: accel: fix ADXL355 startup race condition

Linus Walleij <linus.walleij@linaro.org>
    iio: accel: bmc150: Fix irq assumption regression

Olivier Moysan <olivier.moysan@foss.st.com>
    iio: adc: stm32-dfsdm: fix st,adc-alt-channel property handling

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio:common:ssp_sensors: Fix an error handling path ssp_probe()

Achim Gratz <Achim.Gratz@Stromeko.DE>
    iio: pressure: bmp280: correct meas_time_us calculation

Francesco Lavra <flavra@baylibre.com>
    iio: imu: st_lsm6dsx: fix array size for st_lsm6dsx_settings fields

Dimitri Fedrau <dimitri.fedrau@liebherr.com>
    iio: humditiy: hdc3020: fix units for thresholds and hysteresis

Dimitri Fedrau <dimitri.fedrau@liebherr.com>
    iio: humditiy: hdc3020: fix units for temperature and humidity measurement

Nuno Sá <nuno.sa@analog.com>
    iio: buffer: support getting dma channel from the buffer

Nuno Sá <nuno.sa@analog.com>
    iio: buffer-dmaengine: enable .get_dma_dev()

Nuno Sá <nuno.sa@analog.com>
    iio: buffer-dma: support getting the DMA channel

Jiri Olsa <jolsa@kernel.org>
    Revert "perf/x86: Always store regs->ip in perf_callchain_kernel()"

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amd/display: Move setup_stream_attribute"

Dan Carpenter <dan.carpenter@linaro.org>
    timekeeping: Fix error code in tk_aux_sysfs_init()

David Howells <dhowells@redhat.com>
    afs: Fix uninit var in afs_alloc_anon_key()

Hang Zhou <929513338@qq.com>
    spi: bcm63xx: fix premature CS deassertion on RX-only transactions

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: nxp-fspi: Propagate fwnode in ACPI case as well

Haibo Chen <haibo.chen@nxp.com>
    spi: spi-nxp-fspi: Add OCT-DTR mode support

Haotian Zhang <vulab@iscas.ac.cn>
    spi: amlogic-spifc-a1: Handle devm_pm_runtime_enable() errors

Francesco Lavra <flavra@baylibre.com>
    spi: tegra114: remove Kconfig dependency on TEGRA20_APB_DMA

Sergey Matyukevich <geomatsi@gmail.com>
    riscv: dts: allwinner: d1: fix vlenb property

NeilBrown <neil@brown.name>
    ovl: fail ovl_lock_rename_workdir() if either target is unhashed

David Howells <dhowells@redhat.com>
    afs: Fix delayed allocation of a cell's anonymous key

Andrei Vagin <avagin@google.com>
    fs/namespace: fix reference leak in grab_requested_mnt_ns

Anurag Dutta <a-dutta@ti.com>
    spi: spi-cadence-quadspi: Enable pm runtime earlier to avoid imbalance

Anurag Dutta <a-dutta@ti.com>
    spi: spi-cadence-quadspi: Remove duplicate pm_runtime_put_autosuspend() call

Jamie Iles <jamie.iles@oss.qualcomm.com>
    mailbox: pcc: don't zero error register

Jason-JH Lin <jason-jh.lin@mediatek.com>
    mailbox: mtk-cmdq: Refine DMA address handling for the command buffer

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

Jeremy Kerr <jk@codeconstruct.com.au>
    net: mctp: unconditionally set skb->dev on dst output

Jiefeng Zhang <jiefeng.z.zhang@gmail.com>
    net: atlantic: fix fragment overflow handling in RX path

Mohsin Bashir <mohsin.bashr@gmail.com>
    eth: fbnic: Fix counter roll-over issue

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: fix SGMII linking at 10M or 100M but not passing traffic

Slark Xiao <slark_xiao@163.com>
    net: wwan: mhi: Keep modem name match with Foxconn T99W640

Pranjal Shrivastava <praan@google.com>
    dma-direct: Fix missing sg_dma_len assignment in P2PDMA bus mappings

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix cyan_skillfish2 gpu info fw handling

Fernando Fernandez Mancera <fmancera@suse.de>
    xsk: avoid data corruption on cq descriptor number

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: avoid overwriting skb fields for multi-buffer traffic

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    net: sxgbe: fix potential NULL dereference in sxgbe_rx()

Nikola Z. Ivanov <zlatistiv@gmail.com>
    team: Move team device type change at the end of team_port_add

Danielle Costantino <dcostantino@meta.com>
    net/mlx5e: Fix validation logic in rate limiting

Harish Chegondi <harish.chegondi@intel.com>
    drm/xe: Fix conversion from clock ticks to milliseconds

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix the initialization of taprio

Daniel Golle <daniel@makrotopia.org>
    net: phy: mxl-gpy: fix link properties on USXGMII and internal PHYs

Kai-Heng Feng <kaihengf@nvidia.com>
    net: aquantia: Add missing descriptor cache invalidation on ATL2

Dan Carpenter <dan.carpenter@linaro.org>
    platform/x86: intel: punit_ipc: fix memory corruption

Daniel Golle <daniel@makrotopia.org>
    net: phy: mxl-gpy: fix bogus error on USXGMII and integrated PHY

Devarsh Thakkar <devarsht@ti.com>
    drm/bridge: sii902x: Fix HDMI detection with DRM_BRIDGE_ATTACH_NO_CONNECTOR

Jesper Dangaard Brouer <hawk@kernel.org>
    veth: reduce XDP no_direct return section to fix race

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SMP: Fix not generating mackey and ltk when repairing

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_core: lookup hci_conn on RX path on protocol side

Edward Adam Davis <eadavis@qq.com>
    Bluetooth: hci_sock: Prevent race in socket write iter and sock bind

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix triggering cmd_timer for HCI_OP_NOP

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: mediatek: Fix kernel crash when releasing mtk iso interface

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

 Makefile                                           |   4 +-
 arch/arm/boot/dts/nxp/imx/imx6ul.dtsi              |   2 +-
 arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi |   4 +-
 arch/arm64/boot/dts/freescale/imx8dxl-ss-hsio.dtsi |   5 +
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts       |   4 +-
 arch/arm64/kernel/acpi.c                           |  10 +-
 arch/mips/mm/tlb-r4k.c                             | 118 ++++++++++-----
 arch/riscv/boot/dts/allwinner/sun20i-d1s.dtsi      |   2 +-
 arch/x86/events/core.c                             |  10 +-
 drivers/atm/fore200e.c                             |   2 +
 drivers/bluetooth/btusb.c                          |  39 ++++-
 drivers/counter/microchip-tcb-capture.c            |   2 +-
 drivers/firmware/stratix10-svc.c                   |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  15 ++
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |   8 +-
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c    |  11 +-
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |   1 -
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    |   2 -
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  |   2 -
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c    |   3 +
 .../display/dc/virtual/virtual_stream_encoder.c    |   7 -
 drivers/gpu/drm/bridge/sii902x.c                   |  20 ++-
 drivers/gpu/drm/drm_fb_helper.c                    |  14 --
 drivers/gpu/drm/i915/display/intel_display.c       |   8 ++
 drivers/gpu/drm/i915/display/intel_psr.c           |   6 -
 drivers/gpu/drm/sti/sti_vtg.c                      |   7 +-
 drivers/gpu/drm/xe/xe_gt_clock.c                   |   7 +-
 drivers/gpu/drm/xe/xe_guc_ct.c                     |   3 +
 drivers/iio/accel/adxl355_core.c                   |  44 +++++-
 drivers/iio/accel/bmc150-accel-core.c              |   5 +
 drivers/iio/accel/bmc150-accel.h                   |   1 +
 drivers/iio/adc/ad4030.c                           |   2 +-
 drivers/iio/adc/ad7124.c                           |  12 +-
 drivers/iio/adc/ad7280a.c                          |   2 +-
 drivers/iio/adc/ad7380.c                           |   8 ++
 drivers/iio/adc/rtq6056.c                          |   2 +-
 drivers/iio/adc/stm32-dfsdm-adc.c                  |   5 +-
 drivers/iio/buffer/industrialio-buffer-dma.c       |   6 +
 drivers/iio/buffer/industrialio-buffer-dmaengine.c |   2 +
 drivers/iio/common/ssp_sensors/ssp_dev.c           |   4 +-
 drivers/iio/humidity/hdc3020.c                     |  73 ++++++----
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h            |  40 ++++--
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |  19 ++-
 drivers/iio/industrialio-buffer.c                  |  21 ++-
 drivers/iio/pressure/bmp280-core.c                 |  15 +-
 drivers/iommu/iommufd/driver.c                     |   2 +-
 drivers/mailbox/mailbox-test.c                     |   2 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |  45 ++++--
 drivers/mailbox/pcc.c                              |   8 +-
 drivers/md/dm-verity-fec.c                         |   6 +-
 drivers/mmc/host/sdhci-of-dwcmshc.c                |  29 ++--
 drivers/most/most_usb.c                            |  14 +-
 drivers/net/can/rcar/rcar_canfd.c                  |  53 ++++---
 drivers/net/can/sja1000/sja1000.c                  |   4 +-
 drivers/net/can/sun4i_can.c                        |   4 +-
 drivers/net/can/usb/gs_usb.c                       | 102 +++++++++++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |   4 +-
 drivers/net/dsa/microchip/ksz_common.c             |  31 ++--
 drivers/net/dsa/microchip/ksz_ptp.c                |  22 ++-
 drivers/net/dsa/sja1105/sja1105_main.c             |   7 -
 .../net/ethernet/aquantia/atlantic/aq_hw_utils.c   |  22 +++
 .../net/ethernet/aquantia/atlantic/aq_hw_utils.h   |   1 +
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |   5 +
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |  19 +--
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c   |   2 +-
 drivers/net/ethernet/freescale/fec.h               |   1 +
 drivers/net/ethernet/freescale/fec_ptp.c           |  64 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   2 +-
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c         |   2 +-
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |   5 +-
 drivers/net/ethernet/realtek/r8169_main.c          |  19 ++-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |   4 +-
 drivers/net/phy/mxl-gpy.c                          |  20 +--
 drivers/net/team/team_core.c                       |  23 +--
 drivers/net/tun_vnet.h                             |   2 +-
 drivers/net/veth.c                                 |   7 +-
 drivers/net/virtio_net.c                           |   3 +-
 drivers/net/wwan/mhi_wwan_mbim.c                   |   2 +-
 drivers/nvmem/layouts.c                            |   2 +-
 drivers/platform/x86/intel/punit_ipc.c             |   2 +-
 drivers/pmdomain/tegra/powergate-bpmp.c            |   1 +
 drivers/regulator/rtq2208-regulator.c              |   6 +-
 drivers/slimbus/qcom-ngd-ctrl.c                    |   1 +
 drivers/spi/Kconfig                                |   4 +-
 drivers/spi/spi-amlogic-spifc-a1.c                 |   4 +-
 drivers/spi/spi-bcm63xx.c                          |  14 ++
 drivers/spi/spi-cadence-quadspi.c                  |  18 ++-
 drivers/spi/spi-nxp-fspi.c                         |  28 +++-
 drivers/thunderbolt/nhi.c                          |   2 +
 drivers/thunderbolt/nhi.h                          |   1 +
 drivers/tty/serial/8250/8250.h                     |   4 +-
 drivers/tty/serial/8250/8250_platform.c            |   2 +-
 drivers/tty/serial/8250/8250_rsa.c                 |  26 ++--
 drivers/tty/serial/8250/Makefile                   |   2 +-
 drivers/tty/serial/amba-pl011.c                    |   2 +-
 drivers/usb/cdns3/cdns3-pci-wrap.c                 |   5 +-
 drivers/usb/dwc3/core.c                            |   3 +-
 drivers/usb/dwc3/dwc3-pci.c                        |  82 +++++------
 drivers/usb/dwc3/ep0.c                             |   1 +
 drivers/usb/dwc3/gadget.c                          |   7 +
 drivers/usb/gadget/function/f_eem.c                |   7 +-
 drivers/usb/gadget/udc/core.c                      |  18 ++-
 drivers/usb/gadget/udc/renesas_usbf.c              |   4 +-
 drivers/usb/gadget/udc/trace.h                     |   5 +
 drivers/usb/host/xhci-dbgcap.h                     |   1 +
 drivers/usb/host/xhci-dbgtty.c                     |  23 ++-
 drivers/usb/host/xhci-ring.c                       |  15 +-
 drivers/usb/host/xhci.c                            |   1 +
 drivers/usb/renesas_usbhs/common.c                 |  14 +-
 drivers/usb/serial/ftdi_sio.c                      |   1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   1 +
 drivers/usb/serial/option.c                        |  10 +-
 drivers/usb/storage/sddr55.c                       |   6 +
 drivers/usb/storage/transport.c                    |  16 +++
 drivers/usb/storage/uas.c                          |   5 +
 drivers/usb/storage/unusual_devs.h                 |   2 +-
 drivers/usb/typec/ucsi/psy.c                       |   5 +
 drivers/vhost/net.c                                |  53 ++++---
 drivers/vhost/vhost.c                              |  76 ++++++++--
 drivers/vhost/vhost.h                              |  10 +-
 drivers/video/fbdev/core/fbcon.c                   |   9 ++
 fs/afs/cell.c                                      |  43 ++----
 fs/afs/internal.h                                  |   1 +
 fs/afs/security.c                                  |  49 +++++--
 fs/namespace.c                                     |   7 +-
 fs/overlayfs/util.c                                |   4 +-
 fs/smb/client/connect.c                            |   1 +
 include/linux/iio/buffer-dma.h                     |   1 +
 include/linux/iio/buffer_impl.h                    |   2 +
 include/linux/mailbox/mtk-cmdq-mailbox.h           |  10 ++
 include/linux/usb/gadget.h                         |   5 +
 include/linux/virtio_net.h                         |   7 +-
 include/net/bluetooth/hci_core.h                   |  21 ++-
 io_uring/net.c                                     |   6 +-
 kernel/dma/direct.c                                |   1 +
 kernel/time/timekeeping.c                          |   4 +-
 kernel/trace/trace.c                               |  10 ++
 mm/huge_memory.c                                   |  22 ++-
 mm/memfd.c                                         |  27 ++++
 mm/swapfile.c                                      |   4 +-
 net/bluetooth/hci_core.c                           |  89 +++++-------
 net/bluetooth/hci_sock.c                           |   2 +
 net/bluetooth/iso.c                                |  30 +++-
 net/bluetooth/l2cap_core.c                         |  23 ++-
 net/bluetooth/sco.c                                |  35 +++--
 net/bluetooth/smp.c                                |  31 +---
 net/ceph/auth_x.c                                  |   2 +
 net/ceph/ceph_common.c                             |  53 ++++---
 net/ceph/debugfs.c                                 |  16 ++-
 net/ceph/messenger_v2.c                            |  11 +-
 net/ceph/osdmap.c                                  |  18 ++-
 net/mctp/route.c                                   |   1 +
 net/mptcp/protocol.c                               |  19 ++-
 net/xdp/xsk.c                                      | 160 +++++++++++++--------
 sound/hda/codecs/cirrus/cs420x.c                   |   1 +
 sound/usb/quirks.c                                 |   3 +
 159 files changed, 1538 insertions(+), 807 deletions(-)


