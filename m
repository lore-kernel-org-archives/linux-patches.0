Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40E018C03A;
	Fri, 27 Sep 2024 12:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440239; cv=none; b=D6xxxNG2O2AQg6VWJHat0AMbLwx6VJvF8Ekx6RMQ/AoTQ/3eq7h9ZKK4HwrIXhgqapAbIbgkr7mAJ0mgkD/s1pk+4ipwVVo6jaoWM6N7Bm7VcKujKCMP3PuKgFr/qL4YgHHxDOvvOFAStno+owDwTNNdY6C3f2FdFJJSCfFbRK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440239; c=relaxed/simple;
	bh=nekBDy0fbUvFRTlF5bIpPVFtYPCKCeGrG35Ogbg/6G0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=l0FKekl/N4RC8mn8ZLd3DZ96ElT6kmjySU2h3PW6FnBLFYDRc0w6EWHS8Ji0MExg3S8nGDV16I204J0vHo25r1Vxgi8qJ+0/ItWOWBfBDTz+y6339GCYh6wPp1yQsmFsUbxwQrFCeM0YwJR3p3Ov5kdR4GrxHUXqmpxxyVzFB9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H4mRp4lM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H4mRp4lM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F44AC4CEC4;
	Fri, 27 Sep 2024 12:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440239;
	bh=nekBDy0fbUvFRTlF5bIpPVFtYPCKCeGrG35Ogbg/6G0=;
	h=From:To:Cc:Subject:Date:From;
	b=H4mRp4lM6ITn4qLlz2jMn1kWrG7pp5wDUiAfI1VXiXJyQJ//kFEl50++jI5KD6V7C
	 hOY1wEJgvcxXyuA5HYDHWwMURaemX+hFCDte5lsIGQFeZ2THaPzuOY5UiDGhV7Lud5
	 Mn7MjrraLkCzyet6rFb4wWk+Dex1xH56OHybpwgs=
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
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 6.1 00/73] 6.1.112-rc1 review
Date: Fri, 27 Sep 2024 14:23:11 +0200
Message-ID: <20240927121719.897851549@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.112-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.112-rc1
X-KernelTest-Deadline: 2024-09-29T12:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.112 release.
There are 73 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.112-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.112-rc1

Edward Adam Davis <eadavis@qq.com>
    USB: usbtmc: prevent kernel-usb-infoleak

Junhao Xie <bigfoot@classfun.cn>
    USB: serial: pl2303: add device id for Macrosilicon MS3020

Tony Luck <tony.luck@intel.com>
    x86/mm: Switch to new Intel CPU model defines

Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
    powercap: RAPL: fix invalid initialization for pl4_supported field

Filipe Manana <fdmanana@suse.com>
    btrfs: calculate the right space for delayed refs when updating global reserve

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: restrict fullmesh endp on 1st sf

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: move mcp251xfd_timestamp_start()/stop() into mcp251xfd_chip_start/stop()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: properly indent labels

Hagar Hemdan <hagarhem@amazon.com>
    gpio: prevent potential speculation leaks in gpio_device_get_desc()

Kent Gibson <warthog618@gmail.com>
    gpiolib: cdev: Ignore reconfiguration without direction

Ping-Ke Shih <pkshih@realtek.com>
    Revert "wifi: cfg80211: check wiphy mutex is held for wdev mutex"

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: missing iterator type in lookup walk

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_pipapo: walk over current view on netlink dump

Dan Carpenter <dan.carpenter@linaro.org>
    netfilter: nft_socket: Fix a NULL vs IS_ERR() bug in nft_socket_cgroup_subtree_level()

Florian Westphal <fw@strlen.de>
    netfilter: nft_socket: make cgroupsv2 matching work with namespaces

Dave Chinner <dchinner@redhat.com>
    xfs: journal geometry is not properly bounds checked

Darrick J. Wong <djwong@kernel.org>
    xfs: set bnobt/cntbt numrecs correctly when formatting new AGs

Darrick J. Wong <djwong@kernel.org>
    xfs: fix reloading entire unlinked bucket lists

Darrick J. Wong <djwong@kernel.org>
    xfs: make inode unlinked bucket recovery work with quotacheck

Darrick J. Wong <djwong@kernel.org>
    xfs: reload entire unlinked bucket lists

Darrick J. Wong <djwong@kernel.org>
    xfs: use i_prev_unlinked to distinguish inodes that are not on the unlinked list

Shiyang Ruan <ruansy.fnst@fujitsu.com>
    xfs: correct calculation for agend and blockcount

Dave Chinner <dchinner@redhat.com>
    xfs: fix unlink vs cluster buffer instantiation race

Darrick J. Wong <djwong@kernel.org>
    xfs: fix negative array access in xfs_getbmap

Darrick J. Wong <djwong@kernel.org>
    xfs: load uncached unlinked inodes into memory on demand

Shiyang Ruan <ruansy.fnst@fujitsu.com>
    xfs: fix the calculation for "end" and "length"

Dave Chinner <dchinner@redhat.com>
    xfs: remove WARN when dquot cache insertion fails

Long Li <leo.lilong@huaweicloud.com>
    xfs: fix ag count overflow during growfs

Dave Chinner <dchinner@redhat.com>
    xfs: collect errors from inodegc for unlinked inode recovery

Dave Chinner <dchinner@redhat.com>
    xfs: fix AGF vs inode cluster buffer deadlock

Dave Chinner <dchinner@redhat.com>
    xfs: defered work could create precommits

Dave Chinner <dchinner@redhat.com>
    xfs: buffer pins need to hold a buffer reference

Ye Bin <yebin10@huawei.com>
    xfs: fix BUG_ON in xfs_getbmap()

Dave Chinner <dchinner@redhat.com>
    xfs: quotacheck failure can race with background inode inactivation

Darrick J. Wong <djwong@kernel.org>
    xfs: fix uninitialized variable access

Dave Chinner <dchinner@redhat.com>
    xfs: block reservation too large for minleft allocation

Dave Chinner <dchinner@redhat.com>
    xfs: prefer free inodes at ENOSPC over chunk allocation

Dave Chinner <dchinner@redhat.com>
    xfs: fix low space alloc deadlock

Dave Chinner <dchinner@redhat.com>
    xfs: don't use BMBT btree split workers for IO completion

Wengang Wang <wen.gang.wang@oracle.com>
    xfs: fix extent busy updating

Wu Guanghao <wuguanghao3@huawei.com>
    xfs: Fix deadlock on xfs_inodegc_worker

Dave Chinner <dchinner@redhat.com>
    xfs: dquot shrinker doesn't check for XFS_DQFLAG_FREEING

Ferry Meng <mengferry@linux.alibaba.com>
    ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()

Ferry Meng <mengferry@linux.alibaba.com>
    ocfs2: add bounds checking to ocfs2_xattr_find_entry()

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: spidev: Add missing spi_device_id for jg10309-01

Hongyu Jin <hongyu.jin@unisoc.com>
    block: Fix where bio IO priority gets set

zhang jiao <zhangjiao2@cmss.chinamobile.com>
    tools: hv: rm .*.cmd when make clean

Michael Kelley <mhklinux@outlook.com>
    x86/hyperv: Set X86_FEATURE_TSC_KNOWN_FREQ when Hyper-V provides frequency

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix hang in wait_for_response() for negproto

Liao Chen <liaochen4@huawei.com>
    spi: bcm63xx: Enable module autoloading

hongchi.peng <hongchi.peng@siengine.com>
    drm: komeda: Fix an issue related to normalized zpos

Fabio Estevam <festevam@gmail.com>
    spi: spidev: Add an entry for elgin,jg10309-01

Liao Chen <liaochen4@huawei.com>
    ASoC: tda7419: fix module autoloading

Liao Chen <liaochen4@huawei.com>
    ASoC: intel: fix module autoloading

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: soc-acpi-cht: Make Lenovo Yoga Tab 3 X90F DMI match less strict

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_ring_init(): check TX-coalescing configuration

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: clear trans->state earlier upon error

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: mac80211: free skb on error path in ieee80211_beacon_get_ap()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: don't wait for tx queues if firmware is dead

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: pause TCM when the firmware is stopped

Daniel Gabay <daniel.gabay@intel.com>
    wifi: iwlwifi: mvm: fix iwl_mvm_scan_fits() calculation

Benjamin Berg <benjamin.berg@intel.com>
    wifi: iwlwifi: lower message level for FW buffer destination

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Define ARCH_IRQ_INIT_FLAGS as IRQ_NOPROBE

Jacky Chou <jacky_chou@aspeedtech.com>
    net: ftgmac100: Ensure tx descriptor updates are visible

Mike Rapoport <rppt@kernel.org>
    microblaze: don't treat zero reserved memory regions as error

Ross Brown <true.robot.ross@gmail.com>
    hwmon: (asus-ec-sensors) remove VRM temp X570-E GAMING

Thomas Blocher <thomas.blocher@ek-dev.de>
    pinctrl: at91: make it work with current gpiolib

Sherry Yang <sherry.yang@oracle.com>
    scsi: lpfc: Fix overflow build issue

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - FIxed ALC285 headphone no sound

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed ALC256 headphone no sound

Hongbo Li <lihongbo22@huawei.com>
    ASoC: allow module autoloading for table board_ids

Hongbo Li <lihongbo22@huawei.com>
    ASoC: allow module autoloading for table db1200_pids

Albert Jakieła <jakiela@google.com>
    ASoC: SOF: mediatek: Add missing board compatible


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/loongarch/include/asm/hw_irq.h                |   2 +
 arch/loongarch/kernel/irq.c                        |   3 -
 arch/microblaze/mm/init.c                          |   5 -
 arch/x86/kernel/cpu/mshyperv.c                     |   1 +
 arch/x86/mm/init.c                                 |  16 +-
 block/blk-core.c                                   |  10 +
 block/blk-mq.c                                     |  10 -
 drivers/gpio/gpiolib-cdev.c                        |  12 +-
 drivers/gpio/gpiolib.c                             |   3 +-
 drivers/gpu/drm/arm/display/komeda/komeda_kms.c    |  10 +-
 drivers/hwmon/asus-ec-sensors.c                    |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  42 ++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c     |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c   |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c     |  14 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c      |   2 +-
 .../net/can/spi/mcp251xfd/mcp251xfd-timestamp.c    |   7 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |   1 +
 drivers/net/ethernet/faraday/ftgmac100.c           |  26 ++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  23 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |   3 +-
 drivers/pinctrl/pinctrl-at91.c                     |   5 +-
 drivers/powercap/intel_rapl_msr.c                  |  12 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |   2 +-
 drivers/spi/spi-bcm63xx.c                          |   1 +
 drivers/spi/spidev.c                               |   2 +
 drivers/usb/class/usbtmc.c                         |   2 +-
 drivers/usb/serial/pl2303.c                        |   1 +
 drivers/usb/serial/pl2303.h                        |   4 +
 fs/btrfs/block-rsv.c                               |  14 +-
 fs/btrfs/block-rsv.h                               |  12 +
 fs/btrfs/delayed-ref.h                             |  21 ++
 fs/ocfs2/xattr.c                                   |  27 ++-
 fs/smb/client/connect.c                            |  14 +-
 fs/xfs/libxfs/xfs_ag.c                             |  19 +-
 fs/xfs/libxfs/xfs_alloc.c                          |  69 +++++-
 fs/xfs/libxfs/xfs_bmap.c                           |  16 +-
 fs/xfs/libxfs/xfs_bmap.h                           |   2 +
 fs/xfs/libxfs/xfs_bmap_btree.c                     |  19 +-
 fs/xfs/libxfs/xfs_btree.c                          |  18 +-
 fs/xfs/libxfs/xfs_fs.h                             |   2 +
 fs/xfs/libxfs/xfs_ialloc.c                         |  17 ++
 fs/xfs/libxfs/xfs_log_format.h                     |   9 +-
 fs/xfs/libxfs/xfs_sb.c                             |  56 ++++-
 fs/xfs/libxfs/xfs_trans_inode.c                    | 113 +--------
 fs/xfs/xfs_attr_inactive.c                         |   1 -
 fs/xfs/xfs_bmap_util.c                             |  18 +-
 fs/xfs/xfs_buf_item.c                              |  88 +++++--
 fs/xfs/xfs_dquot.c                                 |   1 -
 fs/xfs/xfs_export.c                                |  14 ++
 fs/xfs/xfs_extent_busy.c                           |   1 +
 fs/xfs/xfs_fsmap.c                                 |   1 +
 fs/xfs/xfs_fsops.c                                 |  13 +-
 fs/xfs/xfs_icache.c                                |  58 ++++-
 fs/xfs/xfs_icache.h                                |   4 +-
 fs/xfs/xfs_inode.c                                 | 260 ++++++++++++++++++---
 fs/xfs/xfs_inode.h                                 |  36 ++-
 fs/xfs/xfs_inode_item.c                            | 149 ++++++++++++
 fs/xfs/xfs_inode_item.h                            |   1 +
 fs/xfs/xfs_itable.c                                |  11 +
 fs/xfs/xfs_log.c                                   |  47 ++--
 fs/xfs/xfs_log_recover.c                           |  19 +-
 fs/xfs/xfs_mount.h                                 |  11 +-
 fs/xfs/xfs_notify_failure.c                        |  15 +-
 fs/xfs/xfs_qm.c                                    |  72 ++++--
 fs/xfs/xfs_super.c                                 |   1 +
 fs/xfs/xfs_trace.h                                 |  46 ++++
 fs/xfs/xfs_trans.c                                 |   9 +-
 include/net/netfilter/nf_tables.h                  |  13 ++
 net/mac80211/tx.c                                  |   4 +-
 net/netfilter/nf_tables_api.c                      |   5 +
 net/netfilter/nft_lookup.c                         |   1 +
 net/netfilter/nft_set_pipapo.c                     |   6 +-
 net/netfilter/nft_socket.c                         |  41 +++-
 net/wireless/core.h                                |   8 +-
 sound/pci/hda/patch_realtek.c                      |  76 ++++--
 sound/soc/amd/acp/acp-sof-mach.c                   |   2 +
 sound/soc/au1x/db1200.c                            |   1 +
 sound/soc/codecs/tda7419.c                         |   1 +
 sound/soc/intel/common/soc-acpi-intel-cht-match.c  |   1 -
 sound/soc/intel/keembay/kmb_platform.c             |   1 +
 sound/soc/sof/mediatek/mt8195/mt8195.c             |   3 +
 tools/hv/Makefile                                  |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   4 +-
 89 files changed, 1255 insertions(+), 462 deletions(-)


