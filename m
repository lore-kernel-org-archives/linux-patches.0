Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0212C326C;
	Mon, 27 Oct 2025 19:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592622; cv=none; b=E8GSSiPxdy7woMyfmeX143QUxgnSXo4IK0KXWIk0vq6CDoTxfwLMEsJn2z0n5AybSGTSgBiL07+rWkYrGmc2CZbUetLnlXOhuzoPJeLVpjBKSRycaDcpImyRxPBLueHn8BfOXAEFCb6GgF2MAJT5ffbrDknKpfxnwJpZ0erIKhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592622; c=relaxed/simple;
	bh=Kl409PUFDpQq0U8Vqlh8agS/GKJXWUId6mDy2nlEM9U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YqLTI14HY5VFk9yec3ocorZIEFwdBpffagA4MVpuqnRvVD3+keFjAgNz+yHBa5WZrvj2rYl87U5bY47TRYdD0QA67vnAo01omwyL7tE3A/M/To5tf2veuqPorVfZao/OkA6EAES5qBMl1zsX9w4VbJmVadBXCpFLhZ+uqyle07E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ek4TzVln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ek4TzVln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8DDC4CEF1;
	Mon, 27 Oct 2025 19:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592622;
	bh=Kl409PUFDpQq0U8Vqlh8agS/GKJXWUId6mDy2nlEM9U=;
	h=From:To:Cc:Subject:Date:From;
	b=Ek4TzVlngjR9fgoSOCMYKh61fXQoI5opnfgnbCb/7IIT3VoH/oK+y8YjNKWrIo7TA
	 VHlq/a2sxEYHgGuR3bORnHFjKy25l0YCNOZ42XGQ9ePq55VitqIoiq5LFFxPBFWVEY
	 40/5c4ZQpPWAWW1CJ+9WYFRiTnSbSowDaUSDKAS0=
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
Subject: [PATCH 6.6 00/84] 6.6.115-rc1 review
Date: Mon, 27 Oct 2025 19:35:49 +0100
Message-ID: <20251027183438.817309828@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.115-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.115-rc1
X-KernelTest-Deadline: 2025-10-29T18:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.115 release.
There are 84 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.115-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.115-rc1

Haoyu Li <lihaoyu499@gmail.com>
    gpio: ljca: Initialize num before accessing item in ljca_gpio_config

Darrick J. Wong <djwong@kernel.org>
    fuse: fix livelock in synchronous file put from fuseblk workers

Amir Goldstein <amir73il@gmail.com>
    fuse: allocate ff->release_args only if release is needed

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Update purge function to unregister the unused subchannels

Babu Moger <babu.moger@amd.com>
    x86/resctrl: Fix miscount of bandwidth event when reactivating previously unavailable RMID

Jakub Acs <acsjakub@amazon.de>
    fs/notify: call exportfs_encode_fid with s_umount

Darrick J. Wong <djwong@kernel.org>
    xfs: always warn about deprecated mount options

Maarten Lankhorst <dev@lankhorst.se>
    devcoredump: Fix circular locking dependency with devcd->mutex.

Daniel Golle <daniel@makrotopia.org>
    serial: 8250_mtk: Enable baud clock and manage in runtime PM

Florian Eckert <fe@dev.tdt.de>
    serial: 8250_exar: add support for Advantech 2 port card with Device ID 0x0018

Artem Shimko <a.shimko.dev@gmail.com>
    serial: 8250_dw: handle reset control deassert error

Xu Yang <xu.yang_2@nxp.com>
    dt-bindings: usb: dwc3-imx8mp: dma-range is required only for imx8mp

Michael Grzeschik <m.grzeschik@pengutronix.de>
    tcpm: switch check for role_sw device with fw_node

Victoria Votokina <Victoria.Votokina@kaspersky.com>
    most: usb: hdm_probe: Fix calling put_device() before device initialization

Victoria Votokina <Victoria.Votokina@kaspersky.com>
    most: usb: Fix use-after-free in hdm_disconnect

Junhao Xie <bigfoot@radxa.com>
    misc: fastrpc: Fix dma_buf object leak in fastrpc_map_lookup

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add wildcat lake P DID

Deepanshu Kartikey <kartikey406@gmail.com>
    comedi: fix divide-by-zero in comedi_buf_munge()

Alice Ryhl <aliceryhl@google.com>
    binder: remove "invalid inc weak" check

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/microcode: Fix Entrysign revision check for Zen1/Naples

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: enable back DbC in resume if it was enabled before suspend

Andrey Konovalov <andreyknvl@gmail.com>
    usb: raw-gadget: do not limit transfer length

Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
    usb/core/quirks: Add Huawei ME906S to wakeup quirk

LI Qingwu <Qing-wu.Li@leica-geosystems.com.cn>
    USB: serial: option: add Telit FN920C04 ECM compositions

Reinhard Speyerer <rspmn@arcor.de>
    USB: serial: option: add Quectel RG255C

Renjun Wang <renjunw0@foxmail.com>
    USB: serial: option: add UNISOC UIS7720

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    sched: Remove never used code in mm_cid_get()

Alok Tiwari <alok.a.tiwari@oracle.com>
    io_uring: correct __must_hold annotation in io_install_fixed_file

Haotian Zhang <vulab@iscas.ac.cn>
    gpio: ljca: Fix duplicated IRQ mapping

Wentong Wu <wentong.wu@intel.com>
    gpio: update Intel LJCA USB GPIO driver

Guenter Roeck <linux@roeck-us.net>
    hwmon: (sht3x) Fix error handling

Anup Patel <apatel@ventanamicro.com>
    RISC-V: Don't print details of CPUs disabled in DT

Anup Patel <apatel@ventanamicro.com>
    RISC-V: Define pgprot_dmacoherent() for non-coherent devices

Artem Shimko <a.shimko.dev@gmail.com>
    firmware: arm_scmi: Fix premature SCMI_XFER_FLAG_IS_RAW clearing in raw mode

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Account for failed debug initialization

Han Xu <han.xu@nxp.com>
    spi: spi-nxp-fspi: add extra delay after dll locked

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: mark implicit tests as skipped if not supported

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: mark 'flush re-add' as skipped if not supported

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    net: ravb: Ensure memory write completes before ringing TX doorbell

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    net: ravb: Enforce descriptor type ordering

Michal Pecio <michal.pecio@gmail.com>
    net: usb: rtl8150: Fix frame padding

Sebastian Reichel <sebastian.reichel@collabora.com>
    net: stmmac: dwmac-rk: Fix disabling set_clock_selection

Stefano Garzarella <sgarzare@redhat.com>
    vsock: fix lock inversion in vsock_assign_transport()

Deepanshu Kartikey <kartikey406@gmail.com>
    ocfs2: clear extent cache after moving/defragmenting extents

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Malta: Fix keyboard resource preventing i8042 driver from registering

David Howells <dhowells@redhat.com>
    cifs: Fix TCP_Server_Info::credits to be signed

Marc Kleine-Budde <mkl@pengutronix.de>
    can: netlink: can_changelink(): allow disabling of automatic restart

Xi Ruoyao <xry111@xry111.site>
    ACPICA: Work around bogus -Wstringop-overread warning since GCC 11

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "cpuidle: menu: Avoid discarding useful information"

William Breathitt Gray <wbg@kernel.org>
    gpio: 104-idio-16: Define maximum valid register address offset

William Breathitt Gray <wbg@kernel.org>
    gpio: pci-idio-16: Define maximum valid register address offset

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    arch_topology: Fix incorrect error check in topology_parse_cpu_capacity()

Marek Szyprowski <m.szyprowski@samsung.com>
    dma-debug: don't report false positives with DMA_BOUNCE_UNALIGNED_KMALLOC

Tonghao Zhang <tonghao@bamaicloud.com>
    net: bonding: fix possible peer notify event loss or dup issue

Alexey Simakov <bigalex934@gmail.com>
    sctp: avoid NULL dereference when chunk data buffer is missing

Huang Ying <ying.huang@linux.alibaba.com>
    arm64, mm: avoid always making PTE dirty in pte_mkwrite()

Amery Hung <ameryhung@gmail.com>
    net/mlx5e: RX, Fix generating skb from non-linear xdp_buff for striding RQ

Amery Hung <ameryhung@gmail.com>
    net/mlx5e: RX, Fix generating skb from non-linear xdp_buff for legacy RQ

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Reuse per-RQ XDP buffer to avoid stack zeroing overhead

Xin Long <lucien.xin@gmail.com>
    selftests: net: fix server bind failure in sctp_vrf.sh

Hangbin Liu <liuhangbin@gmail.com>
    selftests/net: convert sctp_vrf.sh to run it in unique namespace

Marc Kleine-Budde <mkl@pengutronix.de>
    can: bxcan: bxcan_start_xmit(): use can_dev_dropped_skb() instead of can_dropped_invalid_skb()

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-eth: fix the pointer passed to PTR_ALIGN on Tx path

Wei Fang <wei.fang@nxp.com>
    net: enetc: correct the value of ENETC_RXB_TRUESIZE

Jianpeng Chang <jianpeng.chang.cn@windriver.com>
    net: enetc: fix the deadlock of enetc_mdio_lock

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    net: Tree wide: Replace xdp_do_flush_map() with xdp_do_flush().

Johannes Wiesböck <johannes.wiesboeck@aisec.fraunhofer.de>
    rtnetlink: Allow deleting FDB entries in user namespace

Nathan Chancellor <nathan@kernel.org>
    net/mlx5e: Return 1 instead of 0 in invalid case in mlx5e_mpwrq_umr_entry_size()

Linus Torvalds <torvalds@linux-foundation.org>
    Unbreak 'make tools/*' for user-space targets

Stefan Metzmacher <metze@samba.org>
    smb: server: let smb_direct_flush_send_list() invalidate a remote key first

Yicong Yang <yangyicong@hisilicon.com>
    drivers/perf: hisi: Relax the event ID check in the framework

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Remove PAGE_KERNEL_TEXT to fix startup failure

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: bitops: Fix find_*_bit() signatures

Junjie Cao <junjie.cao@intel.com>
    lkdtm: fortify: Fix potential NULL dereference on kmalloc failure

Yangtao Li <frank.li@vivo.com>
    hfsplus: return EIO when type of hidden directory mismatch in hfsplus_fill_super()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: fix KMSAN uninit-value issue in hfs_find_set_zero_bits()

Alexander Aring <aahringo@redhat.com>
    dlm: check for defined force value in dlm_lockspace_release

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix KMSAN uninit-value issue in hfsplus_delete_cat()

Yang Chenzhi <yang.chenzhi@vivo.com>
    hfs: validate record offset in hfsplus_bmap_alloc

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix KMSAN uninit-value issue in __hfsplus_ext_cache_extent()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: make proper initalization of struct hfs_find_data

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: clear offset and space out of valid records in b-tree node

Simon Schuster <schuster.simon@siemens-energy.com>
    nios2: ensure that memblock.current_limit is set when setting pfn limits

Xichao Zhao <zhao.xichao@vivo.com>
    exec: Fix incorrect type for ret


-------------

Diffstat:

 .../devicetree/bindings/usb/fsl,imx8mp-dwc3.yaml   |  10 +-
 Makefile                                           |   8 +-
 arch/arm64/include/asm/pgtable.h                   |   3 +-
 arch/m68k/include/asm/bitops.h                     |  25 ++-
 arch/mips/mti-malta/malta-setup.c                  |   2 +-
 arch/nios2/kernel/setup.c                          |  15 ++
 arch/powerpc/include/asm/pgtable.h                 |  12 -
 arch/powerpc/mm/book3s32/mmu.c                     |   4 +-
 arch/powerpc/mm/pgtable_32.c                       |   2 +-
 arch/riscv/include/asm/pgtable.h                   |   2 +
 arch/riscv/kernel/cpu.c                            |   4 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   2 +-
 arch/x86/kernel/cpu/resctrl/monitor.c              |  12 +-
 drivers/acpi/acpica/tbprint.c                      |   6 +
 drivers/android/binder.c                           |  11 +-
 drivers/base/arch_topology.c                       |   2 +-
 drivers/base/devcoredump.c                         | 138 +++++++-----
 drivers/comedi/comedi_buf.c                        |   2 +-
 drivers/cpuidle/governors/menu.c                   |  21 +-
 drivers/firmware/arm_scmi/common.h                 |  24 +-
 drivers/firmware/arm_scmi/driver.c                 |  47 ++--
 drivers/gpio/Kconfig                               |   4 +-
 drivers/gpio/gpio-104-idio-16.c                    |   1 +
 drivers/gpio/gpio-ljca.c                           | 248 ++++++++++++---------
 drivers/gpio/gpio-pci-idio-16.c                    |   1 +
 drivers/hwmon/sht3x.c                              |  27 ++-
 drivers/misc/fastrpc.c                             |   2 +
 drivers/misc/lkdtm/fortify.c                       |   6 +
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/most/most_usb.c                            |  13 +-
 drivers/net/bonding/bond_main.c                    |  40 ++--
 drivers/net/can/bxcan.c                            |   2 +-
 drivers/net/can/dev/netlink.c                      |   6 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   3 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  27 ++-
 drivers/net/ethernet/freescale/enetc/enetc.h       |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   2 +-
 drivers/net/ethernet/marvell/mvneta.c              |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   7 +
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   6 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 128 +++++++----
 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c      |   2 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  24 +-
 drivers/net/ethernet/sfc/efx_channels.c            |   2 +-
 drivers/net/ethernet/sfc/siena/efx_channels.c      |   2 +-
 drivers/net/ethernet/socionext/netsec.c            |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   9 +-
 drivers/net/ethernet/ti/cpsw_priv.c                |   2 +-
 drivers/net/usb/rtl8150.c                          |  11 +-
 drivers/perf/hisilicon/hisi_uncore_pmu.c           |   2 +-
 drivers/perf/hisilicon/hisi_uncore_pmu.h           |   3 +-
 drivers/s390/cio/device.c                          |  37 +--
 drivers/spi/spi-nxp-fspi.c                         |   6 +
 drivers/tty/serial/8250/8250_dw.c                  |   4 +-
 drivers/tty/serial/8250/8250_exar.c                |  11 +
 drivers/tty/serial/8250/8250_mtk.c                 |   6 +-
 drivers/usb/core/quirks.c                          |   2 +
 drivers/usb/gadget/legacy/raw_gadget.c             |   2 -
 drivers/usb/host/xhci-dbgcap.c                     |   9 +-
 drivers/usb/serial/option.c                        |  10 +
 drivers/usb/typec/tcpm/tcpm.c                      |   4 +-
 fs/dlm/lockspace.c                                 |   2 +-
 fs/exec.c                                          |   2 +-
 fs/fuse/dir.c                                      |   2 +-
 fs/fuse/file.c                                     |  75 ++++---
 fs/fuse/fuse_i.h                                   |   2 +-
 fs/hfs/bfind.c                                     |   8 +-
 fs/hfs/brec.c                                      |  27 ++-
 fs/hfs/mdb.c                                       |   2 +-
 fs/hfsplus/bfind.c                                 |   8 +-
 fs/hfsplus/bnode.c                                 |  41 ----
 fs/hfsplus/btree.c                                 |   6 +
 fs/hfsplus/hfsplus_fs.h                            |  42 ++++
 fs/hfsplus/super.c                                 |  25 ++-
 fs/notify/fdinfo.c                                 |   6 +
 fs/ocfs2/move_extents.c                            |   5 +
 fs/smb/client/cifsglob.h                           |   2 +-
 fs/smb/server/transport_rdma.c                     |  11 +-
 fs/xfs/xfs_super.c                                 |  33 ++-
 io_uring/filetable.c                               |   2 +-
 kernel/dma/debug.c                                 |   5 +-
 kernel/sched/sched.h                               |   2 -
 net/core/rtnetlink.c                               |   3 -
 net/sctp/inqueue.c                                 |  13 +-
 net/vmw_vsock/af_vsock.c                           |  38 ++--
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   6 +-
 tools/testing/selftests/net/sctp_hello.c           |  17 +-
 tools/testing/selftests/net/sctp_vrf.sh            |  85 ++++---
 98 files changed, 917 insertions(+), 604 deletions(-)


