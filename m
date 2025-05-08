Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08811957FC;
	Thu,  8 May 2025 11:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746703818; cv=none; b=j51Rc4TKbZF0QHxp9Z1YYg4V3rSm1RmFOvLLXp05LGJgpRijGgu8Zlwd+fx271ahAQIN9ez5Xro+kB4Px96Z/HL8dqkiphieaJh+G+ED43DCLVpvLFJ0T9Xqk+GFIaJvxlWAVKYBFo9CieSIdkb328RBqWoBgXNTL95K7QwJijE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746703818; c=relaxed/simple;
	bh=kWiar1yKSLq1SWYVn8+53Q+8+v+mt4jFD91lJQnBKsA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sHCVRy+QsgVTbGHsGzQdVQ71tAZwZFA7NyyPC8CY3GDK6vuyJVG2E3K/MBsbMyN+rKRHK3TDNsNrwX5x3ntiTOESArIFlfjt5TPq8q7vbkI94/MWreMTZyOMG+g6EinMg9tGarAUvrjSbMsP6MOm7xGiBz9pQmx9QC1V6tmelrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pq779Y8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pq779Y8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D1EC4CEE7;
	Thu,  8 May 2025 11:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746703817;
	bh=kWiar1yKSLq1SWYVn8+53Q+8+v+mt4jFD91lJQnBKsA=;
	h=From:To:Cc:Subject:Date:From;
	b=Pq779Y8WMtcWRmTWYwDVtdW+HJ1fQMZHOmsGbicLdyPwLmiBETMY/cblwC5YIqVmn
	 xDn1re0JyAAzY8EgDi3dAMFUwkkjjprzzwVvBl7DKOvrdxNAoTNXLIqY0IJP55kmpc
	 j1y2RnjAUkSxmjL6VQj6/oIGYkKzpch47ZRIuydE=
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
Subject: [PATCH 5.15 00/55] 5.15.182-rc2 review
Date: Thu,  8 May 2025 13:30:13 +0200
Message-ID: <20250508112559.173535641@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.182-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.182-rc2
X-KernelTest-Deadline: 2025-05-10T11:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.182 release.
There are 55 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 10 May 2025 11:25:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.182-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.182-rc2

Tudor Ambarus <tudor.ambarus@linaro.org>
    dm: fix copying after src array boundaries

Nicolin Chen <nicolinc@nvidia.com>
    iommu/arm-smmu-v3: Fix iommu_device_probe bug due to duplicated stream ids

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/arm-smmu-v3: Use the new rb tree helpers

Björn Töpel <bjorn@rivosinc.com>
    riscv: uprobes: Add missing fence.i after building the XOL buffer

Suzuki K Poulose <suzuki.poulose@arm.com>
    irqchip/gic-v2m: Prevent use after free of gicv2m_get_fwnode()

Thomas Gleixner <tglx@linutronix.de>
    irqchip/gic-v2m: Mark a few functions __init

Xiang wangx <wangxiang@cdjrlc.com>
    irqchip/gic-v2m: Add const to of_device_id

Christian Hewitt <christianshewitt@gmail.com>
    Revert "drm/meson: vclk: fix calculation of 59.94 fractional rates"

Fiona Klute <fiona.klute@gmx.de>
    net: phy: microchip: force IRQ polling mode for lan88xx

Sébastien Szymanski <sebastien.szymanski@armadeus.com>
    ARM: dts: opos6ul: add ksz8081 phy properties

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Balance device refcount when destroying devices

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix deadlock issue when externel_lb and reset are executed together

Sergey Shtylyov <s.shtylyov@omp.ru>
    of: module: add buffer overflow check in of_modalias()

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Skip controller_id generation logic for i.MX7D

Jian Shen <shenjian15@huawei.com>
    net: hns3: defer calling ptp_clock_register()

Hao Lan <lanhao@huawei.com>
    net: hns3: fixed debugfs tm_qset size

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix an interrupt residual problem

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: add support for external loopback test

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

Simon Horman <horms@kernel.org>
    net: dlink: Correct endianness handling of led_mode

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    ice: Check VF VSI Pointer Value in ice_vc_add_fdir_fltr()

Brett Creeley <brett.creeley@intel.com>
    ice: Refactor promiscuous functions

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

Biao Huang <biao.huang@mediatek.com>
    net: ethernet: mtk-star-emac: separate tx/rx handling with two NAPIs

Chris Mi <cmi@nvidia.com>
    net/mlx5: E-switch, Fix error handling for enabling roce

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: E-Switch, Initialize MAC Address for Default GID

Jakub Kicinski <kuba@kernel.org>
    net/sched: act_mirred: don't override retval if we already lost the skb

Sean Christopherson <seanjc@google.com>
    KVM: x86: Load DR6 with guest value only before entering .vcpu_run() loop

Jeongjun Park <aha310510@gmail.com>
    tracing: Fix oob write in trace_seq_to_buffer()

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

Vishal Badole <Vishal.Badole@amd.com>
    amd-xgbe: Fix to ensure dependent features are toggled with RX checksum offload

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


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6ul-imx6ull-opos6ul.dtsi      |   3 +
 arch/arm64/kernel/proton-pack.c                    |   2 +
 arch/parisc/math-emu/driver.c                      |  16 +-
 arch/riscv/kernel/probes/uprobes.c                 |  10 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   1 +
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/kvm/svm/svm.c                             |  13 +-
 arch/x86/kvm/vmx/vmx.c                             |  11 +-
 arch/x86/kvm/x86.c                                 |   3 +
 drivers/edac/altera_edac.c                         |   9 +-
 drivers/edac/altera_edac.h                         |   2 +
 drivers/firmware/arm_scmi/bus.c                    |   3 +
 drivers/gpu/drm/meson/meson_vclk.c                 |   6 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |   2 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |   4 +-
 drivers/iommu/amd/init.c                           |   8 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  79 ++---
 drivers/iommu/intel/iommu.c                        |   4 +-
 drivers/irqchip/irq-gic-v2m.c                      |   8 +-
 drivers/md/dm-integrity.c                          |   2 +-
 drivers/md/dm-table.c                              |   5 +-
 drivers/mmc/host/renesas_sdhi_core.c               |  10 +-
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c          |   9 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |  24 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  11 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c |  30 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  36 ++-
 drivers/net/ethernet/dlink/dl2k.c                  |   2 +-
 drivers/net/ethernet/dlink/dl2k.h                  |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 119 ++++++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   3 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  61 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  26 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |  13 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  25 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
 drivers/net/ethernet/intel/ice/ice_fltr.c          |  58 ++++
 drivers/net/ethernet/intel/ice/ice_fltr.h          |  12 +
 drivers/net/ethernet/intel/ice/ice_main.c          |  49 +--
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |   5 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   | 139 ++++-----
 drivers/net/ethernet/mediatek/mtk_star_emac.c      | 339 ++++++++++++---------
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.h     |   4 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   8 +-
 drivers/net/ethernet/microchip/lan743x_main.h      |   1 +
 drivers/net/phy/microchip.c                        |  46 +--
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   6 +-
 drivers/nvme/host/tcp.c                            |  31 +-
 drivers/of/device.c                                |   7 +-
 drivers/pci/controller/dwc/pci-imx6.c              |   5 +-
 kernel/trace/trace.c                               |   5 +-
 net/ipv4/udp_offload.c                             |  61 +++-
 net/sched/act_mirred.c                             |  22 +-
 net/sched/sch_drr.c                                |   9 +-
 net/sched/sch_ets.c                                |   9 +-
 net/sched/sch_hfsc.c                               |   2 +-
 net/sched/sch_qfq.c                                |  11 +-
 sound/usb/format.c                                 |   3 +-
 65 files changed, 926 insertions(+), 505 deletions(-)


