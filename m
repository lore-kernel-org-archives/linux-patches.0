Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7779B16A956;
	Tue, 30 Sep 2025 15:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245708; cv=none; b=cyTEzIeNsfmpYx/IFM67Xwup4+8zOaTi5hZQjXpOBlf6ro8JaT4YCGb/PSn133ONz+IdsAiOoV8NJqXPzz/D4Lzago3MWMaT2QCsyJsgtC8wsON9XC7fs+DXZ6VoPqYoF8QjX1a4HOScCPMM9VXoqxg8wckQm79cUxeDYrsa0IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245708; c=relaxed/simple;
	bh=5W35ecsu9fpZQ2WKKjdhG3S6eyGyqlGndR4ehZ8pNmE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=H+0emo0cBxBDfvwJnz2RG9X4T8EPDRWMvr948O+2re94QXjoKLq+lj9YkXNtsLTRS54lX05w4nhggg+mHj1wUsn+StRKSNJHdWyNhDMKX5EWJ6GIViHRrTW+4UWTaLpQQTMQuBKTjxdysZNs3XlmrR6pRWcM/S7A821FrH2JwaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tP4QyKPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tP4QyKPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6B8C4CEF0;
	Tue, 30 Sep 2025 15:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245708;
	bh=5W35ecsu9fpZQ2WKKjdhG3S6eyGyqlGndR4ehZ8pNmE=;
	h=From:To:Cc:Subject:Date:From;
	b=tP4QyKPCECF4LrZXTrr9Opp7ySudJJ6ZtZmX/EOsRFcxsHNXkIu8puhvZcLw11RFl
	 8Z06XePNvbGTXcP/ywe4L1NCwmuX0EZBqZ92VKzb7J8PFhY0p9e0CX2UYK+supPW0I
	 8ufF+Df9eUnSLcCBvwLr9wvZGqj80oAo0BHpcrzg=
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
Subject: [PATCH 6.6 00/91] 6.6.109-rc1 review
Date: Tue, 30 Sep 2025 16:46:59 +0200
Message-ID: <20250930143821.118938523@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.109-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.109-rc1
X-KernelTest-Deadline: 2025-10-02T14:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.109 release.
There are 91 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.109-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.109-rc1

David Laight <David.Laight@ACULAB.COM>
    minmax.h: remove some #defines that are only expanded once

David Laight <David.Laight@ACULAB.COM>
    minmax.h: simplify the variants of clamp()

David Laight <David.Laight@ACULAB.COM>
    minmax.h: move all the clamp() definitions after the min/max() ones

David Laight <David.Laight@ACULAB.COM>
    minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()

David Laight <David.Laight@ACULAB.COM>
    minmax.h: reduce the #define expansion of min(), max() and clamp()

David Laight <David.Laight@ACULAB.COM>
    minmax.h: update some comments

David Laight <David.Laight@ACULAB.COM>
    minmax.h: add whitespace around operators and after commas

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: fix up min3() and max3() too

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: improve macro expansion and type checking

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: don't use max() in situations that want a C constant expression

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: simplify min()/max()/clamp() implementation

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: make generic MIN() and MAX() macros available everywhere

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: add validation for ring_len param

Justin Bronder <jsbronder@cold-front.org>
    i40e: increase max descriptors for XL710

Nirmoy Das <nirmoyd@nvidia.com>
    drm/ast: Use msleep instead of mdelay for edid read

Hans de Goede <hansg@kernel.org>
    gpiolib: Extend software-node support to support secondary software-nodes

Jan Kara <jack@suse.cz>
    loop: Avoid updating block size under exclusive owner

David Hildenbrand <david@redhat.com>
    mm/migrate_device: don't add folio to be freed to LRU in migrate_device_finalize()

Kefeng Wang <wangkefeng.wang@huawei.com>
    mm: migrate_device: use more folio in migrate_device_finalize()

Florian Fainelli <florian.fainelli@broadcom.com>
    ARM: bcm: Select ARM_GIC_V3 for ARCH_BRCMSTB

Nathan Chancellor <nathan@kernel.org>
    s390/cpum_cf: Fix uninitialized warning after backport of ce971233242b

Thomas Zimmermann <tzimmermann@suse.de>
    fbcon: Fix OOB access in font allocation

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    fbcon: fix integer overflow in fbcon_do_set_font

Jinjiang Tu <tujinjiang@huawei.com>
    mm/hugetlb: fix folio is still mapped when deleted

Eric Biggers <ebiggers@kernel.org>
    kmsan: fix out-of-bounds access to shadow memory

Zhen Ni <zhen.ni@easystack.cn>
    afs: Fix potential null pointer dereference in afs_put_server

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

Amit Chaudhari <amitchaudhari@mac.com>
    HID: asus: add support for missing PX series fn keys

Sang-Heon Jeon <ekffu200098@gmail.com>
    smb: client: fix wrong index reference in smb2_compound_op()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    futex: Prevent use-after-free during requeue-PI

Zabelin Nikita <n.zabelin@mt-integration.ru>
    drm/gma500: Fix null dereference in hdmi teardown

Dan Carpenter <dan.carpenter@linaro.org>
    octeontx2-pf: Fix potential use after free in otx2_tc_add_flow()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: lantiq_gswip: suppress -EINVAL errors for bridge FDB entries added to the CPU port

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: lantiq_gswip: move gswip_add_single_port_br() call to port_setup()

Martin Schiller <ms@dev.tdt.de>
    net: dsa: lantiq_gswip: do also enable or disable cpu port

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

Stefan Metzmacher <metze@samba.org>
    smb: server: don't use delayed_work for post_recv_credits_work

Christian Loehle <christian.loehle@arm.com>
    cpufreq: Initialize cpufreq-based invariance before subsys

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: kirkwood: Fix sound DAI cells for OpenRD clients

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp: Correct thermal sensor index

Hugh Dickins <hughd@google.com>
    mm: folio_may_be_lru_cached() unless folio_test_large()

Hugh Dickins <hughd@google.com>
    mm/gup: local lru_add_drain() to avoid lru_add_drain_all()

Hugh Dickins <hughd@google.com>
    mm/gup: check ref_count instead of lru before migration

Shivank Garg <shivankg@amd.com>
    mm: add folio_expected_ref_count() for reference count calculation

David Hildenbrand <david@redhat.com>
    mm/gup: revert "mm: gup: fix infinite loop within __get_longterm_locked"

Or Har-Toov <ohartoov@nvidia.com>
    IB/mlx5: Fix obj_type mismatch for SRQ event subscriptions

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

Jiayi Li <lijiayi@kylinos.cn>
    usb: core: Add 0x prefix to quirks debug output

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix build with CONFIG_INPUT=n

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

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: fix overlooked update of subsystem ABI version

Alok Tiwari <alok.a.tiwari@oracle.com>
    scsi: ufs: mcq: Fix memory allocation checks for SQE and CQE


-------------

Diffstat:

 Makefile                                           |   4 +-
 .../dts/intel/socfpga/socfpga_cyclone5_sodia.dts   |   6 +-
 .../boot/dts/marvell/kirkwood-openrd-client.dts    |   2 +-
 arch/arm/mach-bcm/Kconfig                          |   1 +
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |   4 +-
 arch/s390/kernel/perf_cpum_cf.c                    |   4 +-
 arch/um/drivers/mconsole_user.c                    |   2 +
 drivers/block/loop.c                               |  40 ++-
 drivers/cpufreq/cpufreq.c                          |  20 +-
 drivers/edac/skx_common.h                          |   1 -
 drivers/firewire/core-cdev.c                       |   2 +-
 drivers/gpio/gpiolib.c                             |  19 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   2 +
 .../gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c    |   2 +
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h |  14 +-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |   2 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |   3 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |   3 +
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c             |   2 +-
 drivers/gpu/drm/ast/ast_dp.c                       |   2 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c             |   2 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |   2 +
 drivers/hid/hid-asus.c                             |   3 +
 drivers/hid/hid-multitouch.c                       |  45 +++-
 drivers/hwmon/adt7475.c                            |  24 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |   7 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   1 +
 drivers/input/touchscreen/cyttsp4_core.c           |   2 +-
 drivers/irqchip/irq-sun6i-r.c                      |   2 +-
 drivers/media/dvb-frontends/stv0367_priv.h         |   3 +
 drivers/mmc/host/sdhci-cadence.c                   |  11 +
 drivers/net/can/rcar/rcar_can.c                    |   8 +-
 drivers/net/can/spi/hi311x.c                       |   1 +
 drivers/net/can/sun4i_can.c                        |   1 +
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   3 +-
 drivers/net/can/usb/etas_es58x/es58x_devlink.c     |   2 +-
 drivers/net/can/usb/mcba_usb.c                     |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   2 +-
 drivers/net/dsa/lantiq_gswip.c                     |  41 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |   2 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  25 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  26 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 110 ++++----
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   3 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   2 +-
 drivers/net/fjes/fjes_main.c                       |   4 +-
 drivers/net/wireless/virtual/virt_wifi.c           |   4 +-
 drivers/nfc/pn544/i2c.c                            |   2 -
 drivers/platform/x86/sony-laptop.c                 |   1 -
 drivers/scsi/isci/init.c                           |   6 +-
 .../pci/hive_isp_css_include/math_support.h        |   5 -
 drivers/ufs/core/ufs-mcq.c                         |   4 +-
 drivers/usb/core/quirks.c                          |   2 +-
 drivers/video/fbdev/core/fbcon.c                   |  13 +-
 fs/afs/server.c                                    |   3 +-
 fs/btrfs/tree-checker.c                            |   2 +-
 fs/hugetlbfs/inode.c                               |  10 +-
 fs/smb/client/smb2inode.c                          |   2 +-
 fs/smb/server/transport_rdma.c                     |  18 +-
 include/crypto/if_alg.h                            |   2 +-
 include/linux/compiler.h                           |   9 +
 include/linux/minmax.h                             | 234 +++++++++-------
 include/linux/mm.h                                 |  55 ++++
 include/linux/swap.h                               |  10 +
 include/net/bluetooth/hci_core.h                   |  21 ++
 kernel/bpf/verifier.c                              |   4 +
 kernel/futex/requeue.c                             |   6 +-
 kernel/trace/preemptirq_delay_test.c               |   2 -
 kernel/trace/trace_dynevent.c                      |   4 +
 kernel/vhost_task.c                                |   3 +-
 lib/btree.c                                        |   1 -
 lib/decompress_unlzma.c                            |   2 +
 lib/vsprintf.c                                     |   2 +-
 mm/gup.c                                           |  28 +-
 mm/kmsan/core.c                                    |  10 +-
 mm/kmsan/kmsan_test.c                              |  16 ++
 mm/migrate_device.c                                |  42 ++-
 mm/mlock.c                                         |   6 +-
 mm/swap.c                                          |   4 +-
 mm/zsmalloc.c                                      |   2 -
 net/bluetooth/hci_event.c                          |  26 +-
 net/bluetooth/hci_sync.c                           |   7 +
 net/core/skbuff.c                                  |   2 +-
 net/ipv4/nexthop.c                                 |   7 +
 net/xfrm/xfrm_state.c                              |   3 +
 sound/usb/mixer_quirks.c                           | 295 +++++++++++++++++++--
 sound/usb/quirks.c                                 |  24 +-
 sound/usb/usbaudio.h                               |   4 +
 tools/testing/selftests/mm/mremap_test.c           |   2 +
 tools/testing/selftests/net/fib_nexthops.sh        |  12 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   2 +
 93 files changed, 1031 insertions(+), 363 deletions(-)


