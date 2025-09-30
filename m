Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47A929ACF7;
	Tue, 30 Sep 2025 15:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245495; cv=none; b=Jzj4Zfhzw5hyydFy5g3Yz5kEd7+iVa4Uqxm0mhQaQeIYjm+IXYlLSK3TIp13RnvkGMkE34jPPSiEtgVexMKoPGkWEwePlN1xz++jmmXJxN89TZc+LK7BywHwQDVvyA2ElbacAvUrRLzZjzsYmoNMCbyCrXWKAxEs8xVUYM6ATMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245495; c=relaxed/simple;
	bh=Lq33fc62tIaKxbL9opYhms8xQzzgs5zS8V4h/eVTWvA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=n2uAybLazHnQRe19utzRKPEAJ+2bKOu0ICIHXirQfoblLSTqy4VL6vhUUpcigAAU9LRWKey6hck+3dKJAd2mpvLGP+2u6dlqpFPY0wzQFwQxF/THsSK1YXeSiYJ3by7drFC+YC0MY3SJIx0TY1L8qgvnpDAn6cJAau60y4txJ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPEjrgqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPEjrgqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3137AC116B1;
	Tue, 30 Sep 2025 15:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245494;
	bh=Lq33fc62tIaKxbL9opYhms8xQzzgs5zS8V4h/eVTWvA=;
	h=From:To:Cc:Subject:Date:From;
	b=wPEjrgqcLSjMamhU7LIZDeskZldiMe0JGUhdNdicSYXXEafltsjtLQ+tufnmLHzfB
	 nqpQ5gMczAIGQ2qH0O01HADHwiIpPOiaxo/fBrGJUSZP4RjlQczqxsNiHa4FZI2QBh
	 uE6qiAkQAR2TSRTu+3mW8cozLKS8Skf818Z6U2pM=
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
Subject: [PATCH 6.1 00/73] 6.1.155-rc1 review
Date: Tue, 30 Sep 2025 16:47:04 +0200
Message-ID: <20250930143820.537407601@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.155-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.155-rc1
X-KernelTest-Deadline: 2025-10-02T14:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.155 release.
There are 73 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.155-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.155-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: simplify and clarify min_t()/max_t() implementation

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: add a few more MIN_T/MAX_T users

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: make generic MIN() and MAX() macros available everywhere

Eric Biggers <ebiggers@kernel.org>
    kmsan: fix out-of-bounds access to shadow memory

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: add validation for ring_len param

Justin Bronder <jsbronder@cold-front.org>
    i40e: increase max descriptors for XL710

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix idx validation in config queues msg

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix validation of VF state in get resources

Nirmoy Das <nirmoyd@nvidia.com>
    drm/ast: Use msleep instead of mdelay for edid read

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: avoid overly complicated constant expressions in VM code

David Laight <David.Laight@ACULAB.COM>
    minmax: fix indentation of __cmp_once() and __clamp_once()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    minmax: deduplicate __unconst_integer_typeof()

Herve Codina <herve.codina@bootlin.com>
    minmax: Introduce {min,max}_array()

Matthew Wilcox (Oracle) <willy@infradead.org>
    minmax: add in_range() macro

David Hildenbrand <david@redhat.com>
    mm/migrate_device: don't add folio to be freed to LRU in migrate_device_finalize()

Kefeng Wang <wangkefeng.wang@huawei.com>
    mm: migrate_device: use more folio in migrate_device_finalize()

Nathan Chancellor <nathan@kernel.org>
    s390/cpum_cf: Fix uninitialized warning after backport of ce971233242b

Thomas Zimmermann <tzimmermann@suse.de>
    fbcon: Fix OOB access in font allocation

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    fbcon: fix integer overflow in fbcon_do_set_font

Jinjiang Tu <tujinjiang@huawei.com>
    mm/hugetlb: fix folio is still mapped when deleted

Zhen Ni <zhen.ni@easystack.cn>
    afs: Fix potential null pointer dereference in afs_put_server

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
    i40e: fix input validation logic for action_meta

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix idx validation in i40e_validate_queue_map

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

Alok Tiwari <alok.a.tiwari@oracle.com>
    bnxt_en: correct offset handling for IPv6 destination address

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

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: etas_es58x: sort the includes by alphabetic order

Leon Hwang <leon.hwang@linux.dev>
    bpf: Reject bpf_timer for PREEMPT_RT

Geert Uytterhoeven <geert+renesas@glider.be>
    can: rcar_can: rcar_can_resume(): fix s2ram with PSCI

Stefan Metzmacher <metze@samba.org>
    smb: server: don't use delayed_work for post_recv_credits_work

Christian Loehle <christian.loehle@arm.com>
    cpufreq: Initialize cpufreq-based invariance before subsys

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


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/mm/pageattr.c                             |   6 +-
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |   4 +-
 arch/s390/kernel/perf_cpum_cf.c                    |   4 +-
 arch/um/drivers/mconsole_user.c                    |   2 +
 arch/x86/mm/pgtable.c                              |   2 +-
 drivers/cpufreq/cpufreq.c                          |  20 +-
 drivers/edac/sb_edac.c                             |   4 +-
 drivers/edac/skx_common.h                          |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   2 +
 .../gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c    |   2 +
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h |  14 +-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |   2 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |   3 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |   3 +
 drivers/gpu/drm/arm/display/include/malidp_utils.h |   2 +-
 .../drm/arm/display/komeda/komeda_pipeline_state.c |  24 +-
 drivers/gpu/drm/ast/ast_dp.c                       |   2 +-
 drivers/gpu/drm/drm_color_mgmt.c                   |   2 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c             |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   6 -
 drivers/gpu/drm/radeon/evergreen_cs.c              |   2 +
 drivers/hid/hid-multitouch.c                       |  45 +++-
 drivers/hwmon/adt7475.c                            |  24 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   1 +
 drivers/md/dm-integrity.c                          |   2 +-
 drivers/media/dvb-frontends/stv0367_priv.h         |   3 +
 drivers/net/can/rcar/rcar_can.c                    |   8 +-
 drivers/net/can/spi/hi311x.c                       |   1 +
 drivers/net/can/sun4i_can.c                        |   1 +
 drivers/net/can/usb/etas_es58x/es581_4.c           |   4 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   7 +-
 drivers/net/can/usb/etas_es58x/es58x_core.h        |   8 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.c          |   4 +-
 drivers/net/can/usb/mcba_usb.c                     |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   2 +-
 drivers/net/dsa/lantiq_gswip.c                     |  41 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |   2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |  18 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  25 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  26 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 110 ++++----
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   3 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
 drivers/net/fjes/fjes_main.c                       |   4 +-
 drivers/nfc/pn544/i2c.c                            |   2 -
 drivers/platform/x86/sony-laptop.c                 |   1 -
 drivers/scsi/isci/init.c                           |   6 +-
 .../pci/hive_isp_css_include/math_support.h        |   5 -
 drivers/usb/core/quirks.c                          |   2 +-
 drivers/video/fbdev/core/fbcon.c                   |  13 +-
 drivers/virt/acrn/ioreq.c                          |   4 +-
 fs/afs/server.c                                    |   3 +-
 fs/btrfs/misc.h                                    |   2 -
 fs/ext2/balloc.c                                   |   2 -
 fs/ext4/ext4.h                                     |   2 -
 fs/hugetlbfs/inode.c                               |  10 +-
 fs/smb/server/transport_rdma.c                     |  18 +-
 fs/ufs/util.h                                      |   6 -
 include/crypto/if_alg.h                            |   2 +-
 include/linux/minmax.h                             | 122 +++++++--
 include/linux/mm.h                                 |  54 ++++
 include/linux/pageblock-flags.h                    |   2 +-
 include/linux/swap.h                               |  10 +
 include/net/bluetooth/hci_core.h                   |  21 ++
 kernel/bpf/verifier.c                              |   4 +
 kernel/futex/requeue.c                             |   6 +-
 kernel/trace/preemptirq_delay_test.c               |   2 -
 kernel/trace/trace_dynevent.c                      |   4 +
 lib/btree.c                                        |   1 -
 lib/decompress_unlzma.c                            |   2 +
 lib/logic_pio.c                                    |   3 -
 mm/gup.c                                           |  28 +-
 mm/kmsan/core.c                                    |  10 +-
 mm/kmsan/kmsan_test.c                              |  16 ++
 mm/migrate_device.c                                |  42 ++-
 mm/mlock.c                                         |   2 +-
 mm/swap.c                                          |   4 +-
 mm/zsmalloc.c                                      |   1 -
 net/bluetooth/hci_event.c                          |  26 +-
 net/bluetooth/hci_sync.c                           |   7 +
 net/ipv4/nexthop.c                                 |   7 +
 net/ipv4/proc.c                                    |   2 +-
 net/ipv6/proc.c                                    |   2 +-
 net/netfilter/nf_nat_core.c                        |   6 +-
 net/tipc/core.h                                    |   2 +-
 net/tipc/link.c                                    |  10 +-
 sound/usb/mixer_quirks.c                           | 295 +++++++++++++++++++--
 sound/usb/quirks.c                                 |  24 +-
 sound/usb/usbaudio.h                               |   4 +
 .../selftests/bpf/progs/get_branch_snapshot.c      |   4 +-
 tools/testing/selftests/net/fib_nexthops.sh        |  12 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   2 +
 tools/testing/selftests/vm/mremap_test.c           |   2 +
 97 files changed, 950 insertions(+), 331 deletions(-)


