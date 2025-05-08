Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DA61A841B;
	Thu,  8 May 2025 11:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746703828; cv=none; b=DrIJtwORPvS9f7i8uO07r0woZ28E8RVXRyE83yKbn9mZW9tD76j3+e2xi26vERd88/jnOgSl0dA4MeMTFUUfKxo5X+uVF24COvClDY9Bmp6RhlhmeXmKwfPfgkAOKmAv71XQty2WV2bheaWAImBreIXs7A2ZQpOkLV/czK0Vmt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746703828; c=relaxed/simple;
	bh=ofxfrc/jjeQAeBWbyB/kRBlM3m1TQr+KaT8zeECZoAM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=B7heF47PJg+1ZfafBf4bTcxdIN5Y7ghsWz8gaPnODsu5XyjlTtZztjiMAD41Co2+onL51r5ZioG1o2r2GRQsQOeYY86PfACX/n9e1RwZp9u/cijUMLONC+4wwE/Efh6zpryA3/Zxi/YI8urpTtKmvyGwi6fBRTbUnOvYotR0ibk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdazvFFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdazvFFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA67C4CEE7;
	Thu,  8 May 2025 11:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746703827;
	bh=ofxfrc/jjeQAeBWbyB/kRBlM3m1TQr+KaT8zeECZoAM=;
	h=From:To:Cc:Subject:Date:From;
	b=tdazvFFlzrAst8iH0km6QA2DxEUBlk8gtlSzeIpgNCcDlhsdA04J6Q3rUwTAQGRDx
	 uuS6BLa9eZz8gOrpmr42dVdIeM6JR3BvOeQ+1VgwiPBT47RukHxXeBGkwx2ZtlEJXJ
	 t7DoanLbapwbeSjdYPjvST22T0F81jrO/ws8jSYs=
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
	hargar@microsoft.com,
	broonie@kernel.org
Subject: [PATCH 6.1 00/97] 6.1.138-rc2 review
Date: Thu,  8 May 2025 13:30:23 +0200
Message-ID: <20250508112609.711621924@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.138-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.138-rc2
X-KernelTest-Deadline: 2025-05-10T11:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.138 release.
There are 97 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 10 May 2025 11:25:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.138-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.138-rc2

Geert Uytterhoeven <geert+renesas@glider.be>
    ASoC: soc-core: Stop using of_property_read_bool() for non-boolean properties

Rob Herring (Arm) <robh@kernel.org>
    ASoC: Use of_property_read_bool()

Chris Bainbridge <chris.bainbridge@gmail.com>
    drm/amd/display: Fix slab-use-after-free in hdcp

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Add scoped mutexes for amdgpu_dm_dhcp

Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>
    drm/amd/display: Change HDCP update sequence for DM

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Clean up style problems in amdgpu_dm_hdcp.c

hersen wu <hersenxs.wu@amd.com>
    drm/amd/display: phase2 enable mst hdcp multiple displays

Nicolin Chen <nicolinc@nvidia.com>
    iommu/arm-smmu-v3: Fix iommu_device_probe bug due to duplicated stream ids

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/arm-smmu-v3: Use the new rb tree helpers

Tudor Ambarus <tudor.ambarus@linaro.org>
    dm: fix copying after src array boundaries

Björn Töpel <bjorn@rivosinc.com>
    riscv: uprobes: Add missing fence.i after building the XOL buffer

Suzuki K Poulose <suzuki.poulose@arm.com>
    irqchip/gic-v2m: Prevent use after free of gicv2m_get_fwnode()

Thomas Gleixner <tglx@linutronix.de>
    irqchip/gic-v2m: Mark a few functions __init

Christian Hewitt <christianshewitt@gmail.com>
    Revert "drm/meson: vclk: fix calculation of 59.94 fractional rates"

Fiona Klute <fiona.klute@gmx.de>
    net: phy: microchip: force IRQ polling mode for lan88xx

Sébastien Szymanski <sebastien.szymanski@armadeus.com>
    ARM: dts: opos6ul: add ksz8081 phy properties

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Skip Rx buffer ownership release if not acquired

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Balance device refcount when destroying devices

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "x86/kexec: Allocate PGD for x86_64 transition page tables separately"

Cong Wang <xiyou.wangcong@gmail.com>
    sch_ets: make est_qlen_notify() idempotent

Cong Wang <xiyou.wangcong@gmail.com>
    sch_qfq: make qfq_qlen_notify() idempotent

Cong Wang <xiyou.wangcong@gmail.com>
    sch_hfsc: make hfsc_qlen_notify() idempotent

Cong Wang <xiyou.wangcong@gmail.com>
    sch_drr: make drr_qlen_notify() idempotent

Cong Wang <xiyou.wangcong@gmail.com>
    sch_htb: make htb_qlen_notify() idempotent

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Skip controller_id generation logic for i.MX7D

Yu Kuai <yukuai3@huawei.com>
    md: move initialization and destruction of 'io_acct_set' to md.c

Stefan Wahren <wahrenst@gmx.net>
    net: vertexcom: mse102x: Fix RX error handling

Stefan Wahren <wahrenst@gmx.net>
    net: vertexcom: mse102x: Add range check for CMD_RTS

Stefan Wahren <wahrenst@gmx.net>
    net: vertexcom: mse102x: Fix LEN_MASK

Stefan Wahren <wahrenst@gmx.net>
    net: vertexcom: mse102x: Fix possible stuck of SPI interrupt

Jian Shen <shenjian15@huawei.com>
    net: hns3: defer calling ptp_clock_register()

Hao Lan <lanhao@huawei.com>
    net: hns3: fixed debugfs tm_qset size

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix an interrupt residual problem

Jian Shen <shenjian15@huawei.com>
    net: hns3: store rx VLAN tag offload state for VF

Mattias Barthel <mattias.barthel@atlascopco.com>
    net: fec: ERR007885 Workaround for conventional TX

Thangaraj Samynathan <thangaraj.s@microchip.com>
    net: lan743x: Fix memleak issue when GSO enabled

Michael Liang <mliang@purestorage.com>
    nvme-tcp: fix premature queue removal and I/O failover

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix ethtool -d byte order for 32-bit values

Shruti Parab <shruti.parab@broadcom.com>
    bnxt_en: Fix out-of-bound memcpy() during ethtool -w

Shruti Parab <shruti.parab@broadcom.com>
    bnxt_en: Fix coredump logic to free allocated buffer

Felix Fietkau <nbd@nbd.name>
    net: ipv6: fix UDPv6 GSO segmentation with NAT

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: fix broken taprio gate states after clock jump

Simon Horman <horms@kernel.org>
    net: dlink: Correct endianness handling of led_mode

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    ice: Check VF VSI Pointer Value in ice_vc_add_fdir_fltr()

Victor Nogueira <victor@mojatatu.com>
    net_sched: qfq: Fix double list add in class with netem as child qdisc

Victor Nogueira <victor@mojatatu.com>
    net_sched: ets: Fix double list add in class with netem as child qdisc

Victor Nogueira <victor@mojatatu.com>
    net_sched: hfsc: Fix a UAF vulnerability in class with netem as child qdisc

Victor Nogueira <victor@mojatatu.com>
    net_sched: drr: Fix double list add in class with netem as child qdisc

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    net: ethernet: mtk-star-emac: rearm interrupts in rx_poll only when advised

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    net: ethernet: mtk-star-emac: fix spinlock recursion issues on rx/tx poll

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: delete PVID VLAN when readding it as non-PVID

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: treat 802.1ad tagged traffic as 802.1Q-untagged

Chris Mi <cmi@nvidia.com>
    net/mlx5: E-switch, Fix error handling for enabling roce

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: E-Switch, Initialize MAC Address for Default GID

Ido Schimmel <idosch@nvidia.com>
    vxlan: vnifilter: Fix unlocked deletion of default FDB entry

Murad Masimov <m.masimov@mt-integration.ru>
    wifi: plfxlc: Remove erroneous assert in plfxlc_mac_release

Sheetal <sheetal@nvidia.com>
    ASoC: soc-pcm: Fix hw_params() and DAPM widget sequence

LongPing Wei <weilongping@oppo.com>
    dm-bufio: don't schedule in atomic context

Sean Christopherson <seanjc@google.com>
    KVM: x86: Load DR6 with guest value only before entering .vcpu_run() loop

Darrick J. Wong <djwong@kernel.org>
    xfs: restrict when we try to align cow fork delalloc to cowextsz hints

Darrick J. Wong <djwong@kernel.org>
    xfs: allow unlinked symlinks and dirs with zero size

Christoph Hellwig <hch@lst.de>
    xfs: fix freeing speculative preallocations for preallocated files

Wengang Wang <wen.gang.wang@oracle.com>
    xfs: make sure sb_fdblocks is non-negative

Darrick J. Wong <djwong@kernel.org>
    xfs: allow symlinks with short remote targets

Zhang Yi <yi.zhang@huawei.com>
    xfs: convert delayed extents to unwritten when zeroing post eof blocks

Zhang Yi <yi.zhang@huawei.com>
    xfs: make xfs_bmapi_convert_delalloc() to allocate the target offset

Zhang Yi <yi.zhang@huawei.com>
    xfs: make the seq argument to xfs_bmapi_convert_delalloc() optional

Zhang Yi <yi.zhang@huawei.com>
    xfs: match lock mode in xfs_buffered_write_iomap_begin()

Darrick J. Wong <djwong@kernel.org>
    xfs: revert commit 44af6c7e59b12

Darrick J. Wong <djwong@kernel.org>
    xfs: validate recovered name buffers when recovering xattr items

Darrick J. Wong <djwong@kernel.org>
    xfs: check opcode and iovec count match in xlog_recover_attri_commit_pass2

Darrick J. Wong <djwong@kernel.org>
    xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr log intent item recovery

Christoph Hellwig <hch@lst.de>
    xfs: remove a racy if_bytes check in xfs_reflink_end_cow_extent

Christoph Hellwig <hch@lst.de>
    xfs: fix xfs_bmap_add_extent_delay_real for partial conversions

Christoph Hellwig <hch@lst.de>
    xfs: fix error returns from xfs_bmapi_write

Jeongjun Park <aha310510@gmail.com>
    tracing: Fix oob write in trace_seq_to_buffer()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Fix setting policy limits when frequency tables are used

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Avoid using inconsistent policy->min and policy->max

Sean Heelan <seanheelan@gmail.com>
    ksmbd: fix use-after-free in kerberos authentication

Shouye Liu <shouyeliu@tencent.com>
    platform/x86/intel-uncore-freq: Fix missing uncore sysfs during CPU hotplug

Mingcong Bai <jeffbai@aosc.io>
    iommu/vt-d: Apply quirk_iommu_igfx for 8086:0044 (QM57/QS57)

Pavel Paklov <Pavel.Paklov@cyberprotect.ru>
    iommu/amd: Fix potential buffer overflow in parse_ivrs_acpihid

Benjamin Marzinski <bmarzins@redhat.com>
    dm: always update the array size in realloc_argv on success

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: fix a warning on invalid table line

Wentao Liang <vulab@iscas.ac.cn>
    wifi: brcm80211: fmac: Add error handling for brcmf_usb_dl_writeimage()

Ruslan Piasetskyi <ruslan.piasetskyi@gmail.com>
    mmc: renesas_sdhi: Fix error handling in renesas_sdhi_probe

Stephan Gerhold <stephan.gerhold@linaro.org>
    irqchip/qcom-mpm: Prevent crash when trying to handle non-wake GPIOs

Vishal Badole <Vishal.Badole@amd.com>
    amd-xgbe: Fix to ensure dependent features are toggled with RX checksum offload

Sean Christopherson <seanjc@google.com>
    perf/x86/intel: KVM: Mask PEBS_ENABLE loaded for guest with vCPU's value.

Helge Deller <deller@gmx.de>
    parisc: Fix double SIGFPE crash

Will Deacon <will@kernel.org>
    arm64: errata: Add missing sentinels to Spectre-BHB MIDR arrays

Clark Wang <xiaoning.wang@nxp.com>
    i2c: imx-lpi2c: Fix clock count when probe defers

Niravkumar L Rabara <niravkumar.l.rabara@altera.com>
    EDAC/altera: Set DDR and SDMMC interrupt mask before registration

Niravkumar L Rabara <niravkumar.l.rabara@altera.com>
    EDAC/altera: Test the correct error reg offset

Philipp Stanner <phasta@kernel.org>
    drm/nouveau: Fix WARN_ON in nouveau_fence_context_kill()

Joachim Priesner <joachim.priesner@web.de>
    ALSA: usb-audio: Add second USB ID for Jabra Evolve 65 headset

Christian Heusel <christian@heusel.eu>
    Revert "rndis_host: Flag RNDIS modems as WWAN devices"


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6ul-imx6ull-opos6ul.dtsi      |   3 +
 arch/arm64/kernel/proton-pack.c                    |   2 +
 arch/parisc/math-emu/driver.c                      |  16 +-
 arch/riscv/kernel/probes/uprobes.c                 |  10 +-
 arch/x86/events/intel/core.c                       |   2 +-
 arch/x86/include/asm/kexec.h                       |  18 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   1 +
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/kernel/machine_kexec_64.c                 |  45 ++-
 arch/x86/kvm/svm/svm.c                             |  13 +-
 arch/x86/kvm/vmx/vmx.c                             |  11 +-
 arch/x86/kvm/x86.c                                 |   3 +
 drivers/cpufreq/cpufreq.c                          |  42 ++-
 drivers/cpufreq/cpufreq_ondemand.c                 |   3 +-
 drivers/cpufreq/freq_table.c                       |   6 +-
 drivers/edac/altera_edac.c                         |   9 +-
 drivers/edac/altera_edac.h                         |   2 +
 drivers/firmware/arm_ffa/driver.c                  |   3 +-
 drivers/firmware/arm_scmi/bus.c                    |   3 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c | 417 ++++++++++++---------
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h |   5 +-
 drivers/gpu/drm/meson/meson_vclk.c                 |   6 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |   2 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |   4 +-
 drivers/iommu/amd/init.c                           |   8 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  79 ++--
 drivers/iommu/intel/iommu.c                        |   4 +-
 drivers/irqchip/irq-gic-v2m.c                      |   8 +-
 drivers/irqchip/irq-qcom-mpm.c                     |   3 +
 drivers/md/dm-bufio.c                              |   3 +-
 drivers/md/dm-integrity.c                          |   2 +-
 drivers/md/dm-table.c                              |   5 +-
 drivers/md/md.c                                    |  27 +-
 drivers/md/md.h                                    |   2 -
 drivers/md/raid0.c                                 |  16 +-
 drivers/md/raid5.c                                 |  41 +-
 drivers/mmc/host/renesas_sdhi_core.c               |  10 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   5 +-
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c          |   9 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |  24 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  11 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c |  30 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  36 +-
 drivers/net/ethernet/dlink/dl2k.c                  |   2 +-
 drivers/net/ethernet/dlink/dl2k.h                  |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  82 ++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |  13 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  25 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |   5 +
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |  13 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.h     |   4 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   8 +-
 drivers/net/ethernet/microchip/lan743x_main.h      |   1 +
 drivers/net/ethernet/mscc/ocelot.c                 | 194 +++++++++-
 drivers/net/ethernet/mscc/ocelot_vcap.c            |   1 +
 drivers/net/ethernet/vertexcom/mse102x.c           |  36 +-
 drivers/net/phy/microchip.c                        |  46 +--
 drivers/net/usb/rndis_host.c                       |  16 +-
 drivers/net/vxlan/vxlan_vnifilter.c                |   8 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   6 +-
 drivers/net/wireless/purelifi/plfxlc/mac.c         |   1 -
 drivers/nvme/host/tcp.c                            |  31 +-
 drivers/pci/controller/dwc/pci-imx6.c              |   5 +-
 .../x86/intel/uncore-frequency/uncore-frequency.c  |  13 +-
 fs/smb/server/auth.c                               |  14 +-
 fs/smb/server/smb2pdu.c                            |   5 -
 fs/xfs/libxfs/xfs_attr_remote.c                    |   1 -
 fs/xfs/libxfs/xfs_bmap.c                           | 130 +++++--
 fs/xfs/libxfs/xfs_da_btree.c                       |  20 +-
 fs/xfs/libxfs/xfs_inode_buf.c                      |  49 ++-
 fs/xfs/libxfs/xfs_sb.c                             |   7 +-
 fs/xfs/scrub/attr.c                                |   5 +
 fs/xfs/xfs_aops.c                                  |  54 +--
 fs/xfs/xfs_attr_item.c                             |  88 ++++-
 fs/xfs/xfs_bmap_util.c                             |  65 ++--
 fs/xfs/xfs_bmap_util.h                             |   2 +-
 fs/xfs/xfs_dquot.c                                 |   1 -
 fs/xfs/xfs_icache.c                                |   2 +-
 fs/xfs/xfs_inode.c                                 |  14 +-
 fs/xfs/xfs_iomap.c                                 |  81 ++--
 fs/xfs/xfs_reflink.c                               |  20 -
 fs/xfs/xfs_rtalloc.c                               |   2 -
 include/linux/cpufreq.h                            |  83 ++--
 include/soc/mscc/ocelot_vcap.h                     |   2 +
 kernel/trace/trace.c                               |   5 +-
 net/ipv4/udp_offload.c                             |  61 ++-
 net/sched/sch_drr.c                                |  16 +-
 net/sched/sch_ets.c                                |  17 +-
 net/sched/sch_hfsc.c                               |  10 +-
 net/sched/sch_htb.c                                |   2 +
 net/sched/sch_qfq.c                                |  18 +-
 sound/soc/codecs/ak4613.c                          |   4 +-
 sound/soc/soc-core.c                               |  36 +-
 sound/soc/soc-pcm.c                                |   5 +-
 sound/usb/format.c                                 |   3 +-
 102 files changed, 1471 insertions(+), 847 deletions(-)


