Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B565B244665;
	Tue, 30 Sep 2025 15:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246055; cv=none; b=oc/NH+mzK2YWULhyfht2Q7C1l6aXJ1amIQQ3ZxPwlOQhbd6Cb3VYECkJ6MAMhHZGIaU2upB295U26EIoxJZaakHY4gXtCs2OPdfsUUuMdSrQiSsAdg9Em0C/c0M3DqOrNxVw3/tk6PuCjCLCjchQPrcPFZ9Fm9CLRqwl1O0JFMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246055; c=relaxed/simple;
	bh=SjAZLXMySJv/jlKWs+2hsloe85BtQeaRtdFtGsA3GcU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZShxnYsT/jGOWGLo82MCVALvXrNF+FIIGAknKhtJWzVwgaz8mRqe4rnGAlC8b6rwmG2tKG0YOXOXmollJqG3E4E6yuPF3XFe6H6XND132LSmjJW0MApgTWlL6udd+rLUjlTruHuVQBetzkK4MNh20vpRpqAnd/nJWA4Ld/L9Q/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0v7eUo6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0v7eUo6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4F7C4CEF0;
	Tue, 30 Sep 2025 15:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246055;
	bh=SjAZLXMySJv/jlKWs+2hsloe85BtQeaRtdFtGsA3GcU=;
	h=From:To:Cc:Subject:Date:From;
	b=0v7eUo6mY22XFuGCfNsp0PBQ1lsp4T7SuC6OBmpTDktGqUQRacpjwqWAHpkYipnJ5
	 fklmXS1KUG1pA/AhvMtIiRhGPQ2Kqq6FLK7dBJIoHuQAxNigHLNE1466+5e+3o1i93
	 R2GSoS/Kqs6fzrHAatMC2Hwmj1Lld27+tpysnzgI=
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
	achill@achill.org
Subject: [PATCH 6.12 00/89] 6.12.50-rc1 review
Date: Tue, 30 Sep 2025 16:47:14 +0200
Message-ID: <20250930143821.852512002@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.50-rc1
X-KernelTest-Deadline: 2025-10-02T14:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.50 release.
There are 89 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.50-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.50-rc1

Niklas Neronin <niklas.neronin@linux.intel.com>
    Revert "usb: xhci: remove option to change a default ring's TRB cycle bit"

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Fix race during abort for file descriptors

Thomas Zimmermann <tzimmermann@suse.de>
    fbcon: Fix OOB access in font allocation

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    fbcon: fix integer overflow in fbcon_do_set_font

Jinjiang Tu <tujinjiang@huawei.com>
    mm/hugetlb: fix folio is still mapped when deleted

Eric Biggers <ebiggers@kernel.org>
    kmsan: fix out-of-bounds access to shadow memory

Hans de Goede <hansg@kernel.org>
    gpiolib: Extend software-node support to support secondary software-nodes

Jakub Acs <acsjakub@amazon.de>
    fs/proc/task_mmu: check p->vec_buf for NULL

Zhen Ni <zhen.ni@easystack.cn>
    afs: Fix potential null pointer dereference in afs_put_server

Nirmoy Das <nirmoyd@nvidia.com>
    drm/ast: Use msleep instead of mdelay for edid read

Josua Mayer <josua@solid-run.com>
    arm64: dts: marvell: cn9132-clearfog: fix multi-lane pci x2 and x4 ports

Josua Mayer <josua@solid-run.com>
    arm64: dts: marvell: cn9132-clearfog: disable eMMC high-speed modes

Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
    ARM: dts: socfpga: sodia: Fix mdio bus probe and PHY address

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: dynevent: Add a missing lockdown check on dynevent

Eric Biggers <ebiggers@kernel.org>
    crypto: af_alg - Fix incorrect boolean values in af_alg_ctx

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: improve VF MAC filters accounting

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: add mask to apply valid bits for itr_idx

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: add max boundary check for VF filters

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix validation of VF state in get resources

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix input validation logic for action_meta

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix idx validation in config queues msg

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix idx validation in i40e_validate_queue_map

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: add validation for ring_len param

Amit Chaudhari <amitchaudhari@mac.com>
    HID: asus: add support for missing PX series fn keys

Sang-Heon Jeon <ekffu200098@gmail.com>
    smb: client: fix wrong index reference in smb2_compound_op()

Daniel Lee <dany97@live.ca>
    platform/x86: lg-laptop: Fix WMAB call in fan_mode_store()

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panthor: Defer scheduler entitiy destruction to queue release

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    futex: Prevent use-after-free during requeue-PI

Zabelin Nikita <n.zabelin@mt-integration.ru>
    drm/gma500: Fix null dereference in hdmi teardown

Hugh Dickins <hughd@google.com>
    mm: folio_may_be_lru_cached() unless folio_test_large()

Hugh Dickins <hughd@google.com>
    mm: revert "mm/gup: clear the LRU flag of a page before adding to LRU batch"

Hugh Dickins <hughd@google.com>
    mm/gup: local lru_add_drain() to avoid lru_add_drain_all()

Dan Carpenter <dan.carpenter@linaro.org>
    octeontx2-pf: Fix potential use after free in otx2_tc_add_flow()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: lantiq_gswip: suppress -EINVAL errors for bridge FDB entries added to the CPU port

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: lantiq_gswip: move gswip_add_single_port_br() call to port_setup()

Ido Schimmel <idosch@nvidia.com>
    selftests: fib_nexthops: Fix creation of non-FDB nexthops

Ido Schimmel <idosch@nvidia.com>
    nexthop: Forbid FDB status change while nexthop is in a group

Jason Baron <jbaron@akamai.com>
    net: allow alloc_skb_with_frags() to use MAX_SKB_FRAGS

Alok Tiwari <alok.a.tiwari@oracle.com>
    bnxt_en: correct offset handling for IPv6 destination address

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    vhost: Take a reference on the task in struct vhost_task.

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix UAF in hci_acl_create_conn_sync

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix hci_resume_advertising_sync

Petr Malat <oss@malat.biz>
    ethernet: rvu-af: Remove slash from the driver name

Sidraya Jayagond <sidraya@linux.ibm.com>
    net/smc: fix warning in smc_rx_splice() when calling get_page()

Wang Liang <wangliang74@huawei.com>
    net: tun: Update napi->skb after XDP process

Stéphane Grosjean <stephane.grosjean@hms-networks.com>
    can: peak_usb: fix shift-out-of-bounds issue

Vincent Mailhol <mailhol@kernel.org>
    can: mcba_usb: populate ndo_change_mtu() to prevent buffer overflow

Vincent Mailhol <mailhol@kernel.org>
    can: sun4i_can: populate ndo_change_mtu() to prevent buffer overflow

Vincent Mailhol <mailhol@kernel.org>
    can: hi311x: populate ndo_change_mtu() to prevent buffer overflow

Vincent Mailhol <mailhol@kernel.org>
    can: etas_es58x: populate ndo_change_mtu() to prevent buffer overflow

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: xfrm_alloc_spi shouldn't use 0 as SPI

Leon Hwang <leon.hwang@linux.dev>
    bpf: Reject bpf_timer for PREEMPT_RT

Geert Uytterhoeven <geert+renesas@glider.be>
    can: rcar_can: rcar_can_resume(): fix s2ram with PSCI

James Guan <guan_yufei@163.com>
    wifi: virt_wifi: Fix page fault on connect

Mark Harmstone <mark@harmstone.com>
    btrfs: don't allow adding block device of less than 1 MB

Jiri Olsa <olsajiri@gmail.com>
    bpf: Check the helper function is valid in get_helper_proto

Stefan Metzmacher <metze@samba.org>
    smb: server: use disable_work_sync in transport_rdma.c

Stefan Metzmacher <metze@samba.org>
    smb: server: don't use delayed_work for post_recv_credits_work

Christian Loehle <christian.loehle@arm.com>
    cpufreq: Initialize cpufreq-based invariance before subsys

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: kirkwood: Fix sound DAI cells for OpenRD clients

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp: Correct thermal sensor index

Peng Fan <peng.fan@nxp.com>
    firmware: imx: Add stub functions for SCMI MISC API

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Add sync across amd sfh work functions

Or Har-Toov <ohartoov@nvidia.com>
    IB/mlx5: Fix obj_type mismatch for SRQ event subscriptions

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: sfp: add quirk for FLYPRO copper SFP+ module

qaqland <anguoli@uniontech.com>
    ALSA: usb-audio: Add mute TLV for playback volumes on more devices

Cryolitia PukNgae <cryolitia@uniontech.com>
    ALSA: usb-audio: move mixer_quirks' min_mute into common quirk

noble.yang <noble.yang@comtrue-inc.com>
    ALSA: usb-audio: Add DSD support for Comtrue USB Audio device

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    i2c: designware: Add quirk for Intel Xe

Benoît Monin <benoit.monin@bootlin.com>
    mmc: sdhci-cadence: add Mobileye eyeQ support

Chris Morgan <macromorgan@hotmail.com>
    net: sfp: add quirk for Potron SFP+ XGSPON ONU Stick

Marc Kleine-Budde <mkl@pengutronix.de>
    net: fec: rename struct fec_devinfo fec_imx6x_info -> fec_imx6sx_info

Jiayi Li <lijiayi@kylinos.cn>
    usb: core: Add 0x prefix to quirks debug output

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix build with CONFIG_INPUT=n

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add support for ASUS NUC using CS35L41 HDA

Chen Ni <nichen@iscas.ac.cn>
    ALSA: usb-audio: Convert comma to semicolon

Kerem Karabay <kekrby@gmail.com>
    HID: multitouch: specify that Apple Touch Bar is direct

Kerem Karabay <kekrby@gmail.com>
    HID: multitouch: take cls->maxcontacts into account for Apple Touch Bar even without a HID_DG_CONTACTMAX field

Kerem Karabay <kekrby@gmail.com>
    HID: multitouch: support getting the tip state from HID_DG_TOUCH fields in Apple Touch Bar

Kerem Karabay <kekrby@gmail.com>
    HID: multitouch: Get the contact ID from HID_DG_TRANSDUCER_INDEX fields in case of Apple Touch Bar

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Add mixer quirk for Sony DualSense PS5

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Remove unneeded wmb() in mixer_quirks

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Simplify NULL comparison in mixer_quirks

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Avoid multiple assignments in mixer_quirks

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Drop unnecessary parentheses in mixer_quirks

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Fix block comments in mixer_quirks

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Fix code alignment in mixer_quirks

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: fix overlooked update of subsystem ABI version

Alok Tiwari <alok.a.tiwari@oracle.com>
    scsi: ufs: mcq: Fix memory allocation checks for SQE and CQE


-------------

Diffstat:

 Documentation/admin-guide/laptops/lg-laptop.rst    |   4 +-
 Makefile                                           |   4 +-
 .../dts/intel/socfpga/socfpga_cyclone5_sodia.dts   |   6 +-
 .../boot/dts/marvell/kirkwood-openrd-client.dts    |   2 +-
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |   4 +-
 arch/arm64/boot/dts/marvell/cn9132-clearfog.dts    |  16 +-
 arch/arm64/boot/dts/marvell/cn9132-sr-cex7.dtsi    |   8 +
 drivers/cpufreq/cpufreq.c                          |  20 +-
 drivers/firewire/core-cdev.c                       |   2 +-
 drivers/gpio/gpiolib.c                             |  21 +-
 drivers/gpu/drm/ast/ast_dp.c                       |   2 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c             |   2 +-
 drivers/gpu/drm/panthor/panthor_sched.c            |   8 +-
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |  12 +-
 drivers/hid/amd-sfh-hid/amd_sfh_common.h           |   3 +
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c             |   4 +
 drivers/hid/hid-asus.c                             |   3 +
 drivers/hid/hid-multitouch.c                       |  45 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |   7 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   1 +
 drivers/iommu/iommufd/fault.c                      |   4 +-
 drivers/iommu/iommufd/main.c                       |  34 +-
 drivers/mmc/host/sdhci-cadence.c                   |  11 +
 drivers/net/can/rcar/rcar_can.c                    |   8 +-
 drivers/net/can/spi/hi311x.c                       |   1 +
 drivers/net/can/sun4i_can.c                        |   1 +
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   3 +-
 drivers/net/can/usb/mcba_usb.c                     |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   2 +-
 drivers/net/dsa/lantiq_gswip.c                     |  21 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |   4 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  26 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 110 +++--
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   3 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   2 +-
 drivers/net/phy/sfp.c                              |  24 +-
 drivers/net/tun.c                                  |   3 +
 drivers/net/wireless/virtual/virt_wifi.c           |   4 +-
 drivers/platform/x86/lg-laptop.c                   |  34 +-
 drivers/ufs/core/ufs-mcq.c                         |   4 +-
 drivers/usb/core/quirks.c                          |   2 +-
 drivers/usb/host/xhci-dbgcap.c                     |   2 +-
 drivers/usb/host/xhci-mem.c                        |  50 +-
 drivers/usb/host/xhci.c                            |   2 +-
 drivers/usb/host/xhci.h                            |   6 +-
 drivers/video/fbdev/core/fbcon.c                   |  13 +-
 fs/afs/server.c                                    |   3 +-
 fs/btrfs/volumes.c                                 |   5 +
 fs/hugetlbfs/inode.c                               |  10 +-
 fs/proc/task_mmu.c                                 |   3 +
 fs/smb/client/smb2inode.c                          |   2 +-
 fs/smb/server/transport_rdma.c                     |  22 +-
 include/crypto/if_alg.h                            |   2 +-
 include/linux/firmware/imx/sm.h                    |  12 +
 include/linux/swap.h                               |  10 +
 include/net/bluetooth/hci_core.h                   |  21 +
 kernel/bpf/core.c                                  |   5 +-
 kernel/bpf/verifier.c                              |   6 +-
 kernel/futex/requeue.c                             |   6 +-
 kernel/trace/trace_dynevent.c                      |   4 +
 kernel/vhost_task.c                                |   3 +-
 mm/gup.c                                           |  15 +-
 mm/kmsan/core.c                                    |  10 +-
 mm/kmsan/kmsan_test.c                              |  16 +
 mm/mlock.c                                         |   6 +-
 mm/swap.c                                          |  51 +-
 net/bluetooth/hci_event.c                          |  26 +-
 net/bluetooth/hci_sync.c                           |   7 +
 net/core/skbuff.c                                  |   2 +-
 net/ipv4/nexthop.c                                 |   7 +
 net/smc/smc_loopback.c                             |  14 +-
 net/xfrm/xfrm_state.c                              |   3 +
 sound/pci/hda/patch_realtek.c                      |  11 +
 sound/usb/mixer_quirks.c                           | 545 +++++++++++++++------
 sound/usb/quirks.c                                 |  24 +-
 sound/usb/usbaudio.h                               |   4 +
 tools/testing/selftests/net/fib_nexthops.sh        |  12 +-
 80 files changed, 1037 insertions(+), 387 deletions(-)


