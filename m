Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9C985270;
	Wed,  7 Aug 2024 15:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043599; cv=none; b=hLMUBGz2ogMGEWLXBDiohFO2vMQrxNDxtMKKkxKb0sDVKe8oy63P+kb2JCqHIMKczoi3X15NLP31mpYz66uteUAUcpz5uv/e0jGQqCyob1I6uCvNdO/34uckbEhEYq3LnLC/1XC/wLNqlqr+BPPHEVFxnpIpy8w+phW3qHVW6wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043599; c=relaxed/simple;
	bh=Pqlg/QOKGgrrunWFL7BVWs4sxRIN51WP3XMUPiknHN4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=c6VGVcjcZJc+38yDCwyvjCcrlzG4LJcoDJBNlw6SaXvbSEkmY26rPwVHWob/1t3f5z7HiBRmUWliE6D6A9CWblVMUHizRzXapVZ95NrT206eJ6+vJdA9jgeBxqZymNy1dsFLi2s33i0B3mWfkea2GRZx2lxsElrhlzlZF7FYY7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhQb5W1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhQb5W1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BF6C4AF0D;
	Wed,  7 Aug 2024 15:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043599;
	bh=Pqlg/QOKGgrrunWFL7BVWs4sxRIN51WP3XMUPiknHN4=;
	h=From:To:Cc:Subject:Date:From;
	b=KhQb5W1fjpRwptBEq1l3gSQT2MxXsEkG5vNpyb84OigzWqNN6gcuLh4fTytPO3+iu
	 Z+bhdEXy0odNa5p9lmtSIA1nJvtPZU+JiDavI5UkP0I5bVOCFyqAM5DPpiKdVUwjj0
	 kMznLy2Ku34ttWlIiBi/KUqZy1DDZXrcSVRchH3M=
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
Subject: [PATCH 6.1 00/86] 6.1.104-rc1 review
Date: Wed,  7 Aug 2024 16:59:39 +0200
Message-ID: <20240807150039.247123516@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.104-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.104-rc1
X-KernelTest-Deadline: 2024-08-09T15:00+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.104 release.
There are 86 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 09 Aug 2024 15:00:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.104-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.104-rc1

Liu Jing <liujing@cmss.chinamobile.com>
    selftests: mptcp: always close input's FD if opened

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix duplicate data handling

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: only set request_bkup flag when sending MP_PRIO

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix bad RCVPRUNED mib accounting

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix NL PM announced address accounting

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: distinguish rcv vs sent backup flag in requests

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix user-space PM announced address accounting

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: don't increment tx_dropped in case of NETDEV_TX_BUSY

Ma Ke <make24@iscas.ac.cn>
    net: usb: sr9700: fix uninitialized variable use in sr_mdio_read

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/i915: Fix possible int overflow in skl_ddi_calculate_wrpll()

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Fix a deadlock in dma buf fence polling

Edmund Raile <edmund.raile@protonmail.com>
    Revert "ALSA: firewire-lib: operate for period elapse event in process context"

Edmund Raile <edmund.raile@protonmail.com>
    Revert "ALSA: firewire-lib: obsolete workqueue for period update"

Mavroudis Chatzilazaridis <mavchatz@protonmail.com>
    ALSA: hda/realtek: Add quirk for Acer Aspire E5-574G

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Correct surround channels in UAC1 channel map

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: sched: check both directions for backup

Al Viro <viro@zeniv.linux.org.uk>
    protect the fetch of ->fd[fd] in do_dup2() from mispredictions

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix zone_unusable accounting on making block group read-write again

Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>
    HID: wacom: Modify pen IDs

Patryk Duda <patrykd@google.com>
    platform/chrome: cros_ec_proto: Lock device when updating MKBP version

Alice Ryhl <aliceryhl@google.com>
    rust: SHADOW_CALL_STACK is incompatible with Rust

Will Deacon <will@kernel.org>
    arm64: jump_label: Ensure patched jump_labels are visible to all CPUs

Zhe Qiao <qiaozhe@iscas.ac.cn>
    riscv/mm: Add handling for VM_FAULT_SIGSEGV in mm_fault_error()

Maciej Żenczykowski <maze@google.com>
    ipv6: fix ndisc_is_useropt() handling for PIO

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Add a check for the return value from mlx5_port_set_eth_ptys

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Fix missing lock on sync reset reload

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: Lag, don't use the hardcoded value of the first port

Kuniyuki Iwashima <kuniyu@amazon.com>
    netfilter: iptables: Fix potential null-ptr-deref in ip6table_nat_table_init().

Kuniyuki Iwashima <kuniyu@amazon.com>
    netfilter: iptables: Fix null-ptr-deref in iptable_nat_table_init().

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Conditionally use snooping for AMD HDMI

Dan Carpenter <dan.carpenter@linaro.org>
    net: mvpp2: Don't re-use loop iterator

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/hdcp: Fix HDCP2_STREAM_STATUS macro

Alexandra Winter <wintera@linux.ibm.com>
    net/iucv: fix use after free in iucv_sock_close()

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: add missing WRITE_ONCE when clearing ice_rx_ring::xdp_prog

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: replace synchronize_rcu with synchronize_net

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: don't busy wait for Rx queue disable in ice_qp_dis()

Michal Kubiak <michal.kubiak@intel.com>
    ice: respect netif readiness in AF_XDP ZC related ndo's

Kuniyuki Iwashima <kuniyu@amazon.com>
    rtnetlink: Don't ignore IFLA_TARGET_NETNSID when ifname is specified in rtnl_dellink().

Andy Chiu <andy.chiu@sifive.com>
    net: axienet: start napi before enabling Rx/Tx

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix suspending with wrong filter policy

songxiebing <songxiebing@kylinos.cn>
    ALSA: hda: conexant: Fix headset auto detect fail in the polling mode

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: conexant: Reduce CONFIG_PM dependencies

Eric Dumazet <edumazet@google.com>
    sched: act_ct: take care of padding in struct zones_ht_key

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Trigger a modeset when the screen moves

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix overlay when using Screen Targets

Danilo Krummrich <dakr@kernel.org>
    drm/nouveau: prime: fix refcount underflow

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Move sensor discovery before HID device initialization

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Split sensor and HID initialization

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Remove duplicate cleanup

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: dts: loongson: Fix ls2k1000-rtc interrupt

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: dts: loongson: Fix liointc IRQ polarity

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: DTS: Fix PCIe port nodes for ls7a

Binbin Zhou <zhoubinbin@loongson.cn>
    MIPS: Loongson64: DTS: Add RTC support to Loongson-2K1000

Imre Deak <imre.deak@intel.com>
    drm/i915/dp: Don't switch the LTTPR mode on an active link

Thomas Zimmermann <tzimmermann@suse.de>
    drm/udl: Remove DRM_CONNECTOR_POLL_HPD

Thomas Zimmermann <tzimmermann@suse.de>
    drm/udl: Move connector to modesetting code

Thomas Zimmermann <tzimmermann@suse.de>
    drm/udl: Various improvements to the connector

Thomas Zimmermann <tzimmermann@suse.de>
    drm/udl: Use USB timeout constant when reading EDID

Thomas Zimmermann <tzimmermann@suse.de>
    drm/udl: Test pixel limit in mode-config's mode-valid function

Thomas Zimmermann <tzimmermann@suse.de>
    drm/udl: Rename struct udl_drm_connector to struct udl_connector

Herve Codina <herve.codina@bootlin.com>
    irqdomain: Fixed unbalanced fwnode get and put

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    irqdomain: Use return value of strreplace()

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: assign CURSEG_ALL_DATA_ATGC if blkaddr is valid

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to avoid use SSR allocate when do defragment

Li Zhijian <lizhijian@fujitsu.com>
    mm/page_alloc: fix pcp->count race between drain_pages_zone() vs __rmqueue_pcplist()

Lucas Stach <l.stach@pengutronix.de>
    mm: page_alloc: control latency caused by zone PCP draining

Huang Ying <ying.huang@intel.com>
    mm: restrict the pcp batch scale factor to avoid too long latency

Thomas Weißschuh <linux@weissschuh.net>
    leds: triggers: Flush pending brightness before activating trigger

Hans de Goede <hdegoede@redhat.com>
    leds: trigger: Call synchronize_rcu() before calling trig->activate()

Heiner Kallweit <hkallweit1@gmail.com>
    leds: trigger: Store brightness set by led_trigger_event()

Heiner Kallweit <hkallweit1@gmail.com>
    leds: trigger: Remove unused function led_trigger_rename_static()

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    cpufreq: qcom-nvmem: fix memory leaks in probe error paths

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    cpufreq: qcom-nvmem: Simplify driver data allocation

Yangtao Li <frank.li@vivo.com>
    cpufreq: qcom-nvmem: Convert to platform remove callback returning void

Zhang Yi <yi.zhang@huawei.com>
    ext4: check the extent status again before inserting delalloc block

Zhang Yi <yi.zhang@huawei.com>
    ext4: factor out a common helper to query extent map

Zhang Yi <yi.zhang@huawei.com>
    ext4: convert to exclusive lock while inserting delalloc extents

Zhang Yi <yi.zhang@huawei.com>
    ext4: refactor ext4_da_map_blocks()

Baokun Li <libaokun1@huawei.com>
    ext4: make ext4_es_insert_extent() return void

Thomas Weißschuh <linux@weissschuh.net>
    sysctl: always initialize i_uid/i_gid

Thomas Weißschuh <linux@weissschuh.net>
    sysctl: treewide: drop unused argument ctl_table_root::set_ownership(table)

Alexey Gladkov <legion@kernel.org>
    sysctl: allow to change limits for posix messages queues

Alexey Gladkov <legion@kernel.org>
    sysctl: allow change system v ipc sysctls inside ipc namespace

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: ipq8074: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: msm8998: Disable SS instance in Parkmode for USB

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8998: switch USB QMP PHY to new style of bindings


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |   2 +
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |  36 +++---
 arch/arm64/include/asm/jump_label.h                |   1 +
 arch/arm64/kernel/jump_label.c                     |  11 +-
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi |  84 +++++++++----
 arch/riscv/mm/fault.c                              |  17 +--
 drivers/cpufreq/qcom-cpufreq-nvmem.c               |  56 ++++-----
 .../gpu/drm/i915/display/intel_dp_link_training.c  |  54 +++++++-
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c      |   6 +-
 drivers/gpu/drm/i915/display/intel_hdcp_regs.h     |   2 +-
 drivers/gpu/drm/nouveau/nouveau_prime.c            |   3 +-
 drivers/gpu/drm/udl/Makefile                       |   2 +-
 drivers/gpu/drm/udl/udl_connector.c                | 139 ---------------------
 drivers/gpu/drm/udl/udl_connector.h                |  15 ---
 drivers/gpu/drm/udl/udl_drv.h                      |  11 ++
 drivers/gpu/drm/udl/udl_modeset.c                  | 135 ++++++++++++++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |  17 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c            |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c               |  29 ++++-
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |  55 ++++----
 drivers/hid/wacom_wac.c                            |   3 +-
 drivers/leds/led-triggers.c                        |  32 ++---
 drivers/leds/trigger/ledtrig-timer.c               |   5 -
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  19 +--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   2 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   8 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   2 +-
 drivers/net/usb/sr9700.c                           |  11 +-
 drivers/platform/chrome/cros_ec_proto.c            |   2 +
 fs/btrfs/block-group.c                             |  13 +-
 fs/btrfs/extent-tree.c                             |   3 +-
 fs/btrfs/free-space-cache.c                        |   4 +-
 fs/btrfs/space-info.c                              |   2 +-
 fs/btrfs/space-info.h                              |   1 +
 fs/ext4/extents.c                                  |   5 +-
 fs/ext4/extents_status.c                           |  14 +--
 fs/ext4/extents_status.h                           |   6 +-
 fs/ext4/inode.c                                    | 115 +++++++++--------
 fs/f2fs/segment.c                                  |   4 +-
 fs/file.c                                          |   1 +
 fs/proc/proc_sysctl.c                              |   8 +-
 include/linux/leds.h                               |  30 +++--
 include/linux/sysctl.h                             |   1 -
 include/trace/events/btrfs.h                       |   8 ++
 include/trace/events/mptcp.h                       |   2 +-
 init/Kconfig                                       |   1 +
 ipc/ipc_sysctl.c                                   |  36 +++++-
 ipc/mq_sysctl.c                                    |  35 ++++++
 kernel/irq/irqdomain.c                             |  11 +-
 mm/Kconfig                                         |  11 ++
 mm/page_alloc.c                                    |  19 ++-
 net/bluetooth/hci_sync.c                           |  21 ++++
 net/core/rtnetlink.c                               |   2 +-
 net/ipv4/netfilter/iptable_nat.c                   |  18 +--
 net/ipv6/ndisc.c                                   |  34 ++---
 net/ipv6/netfilter/ip6table_nat.c                  |  14 ++-
 net/iucv/af_iucv.c                                 |   4 +-
 net/mptcp/options.c                                |   2 +-
 net/mptcp/pm_netlink.c                             |  28 +++--
 net/mptcp/protocol.c                               |  18 +--
 net/mptcp/protocol.h                               |   1 +
 net/mptcp/subflow.c                                |  17 ++-
 net/sched/act_ct.c                                 |   4 +-
 net/sysctl_net.c                                   |   1 -
 sound/firewire/amdtp-stream.c                      |  38 +++---
 sound/firewire/amdtp-stream.h                      |   1 +
 sound/pci/hda/hda_controller.h                     |   2 +-
 sound/pci/hda/hda_intel.c                          |  10 +-
 sound/pci/hda/patch_conexant.c                     |  58 ++-------
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/usb/stream.c                                 |   4 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   8 +-
 77 files changed, 811 insertions(+), 590 deletions(-)


