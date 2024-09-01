Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880EC185B4B;
	Sun,  1 Sep 2024 16:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209175; cv=none; b=bAuSoFMwbvQgum1VKPAhorzGRWamA6Ga5nvgYEcqtHSa/QcbKq2G5asdhw1SKLIMJN4xSgE3C5BqeiWM4gD1THjYeWJpMTt7wL/pMrUOKmvdkDNMoXoiznuZF+AO2RL8tGD853vG6ZBo7FUsZrYl5a2bAbGJlWU8FtbGoXHsGWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209175; c=relaxed/simple;
	bh=EKiZpxBfHDySwvJYmUYc/IYxWzdoQ2mEHLxMUNEr054=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uXodlwAR7wFr18sJWxTmPYX8jPYbhUW9kZmeuPYs7eiGZhgrcgfl2GwNOHcmt6S+kgOV1557lk5euS1SFS8PTQcLScf38CB3Wglbwy2TnNkNjb80EvBGo+poAOHrIi+wZ2Js+oestMtovms1UPYMLibtXEcYvN3t2BMJHiRZOLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DagbEKap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DagbEKap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53ECC4CEC3;
	Sun,  1 Sep 2024 16:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209175;
	bh=EKiZpxBfHDySwvJYmUYc/IYxWzdoQ2mEHLxMUNEr054=;
	h=From:To:Cc:Subject:Date:From;
	b=DagbEKapF/msThzZ7rxHzsc3GaNg8tVU41lU/x5nRHJ+Fn2bZcpR3UlFN7t6/7hLC
	 JXUNtYXC20u1T/+DseEEKNkm0dFLkdVgdCaqQo4qjlO75zJCqjbX4mgS1rpp1kUcyx
	 Q3EGEuvCUaX+LCTSZZvTaVg3BySLmVHTitWaxMgk=
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
Subject: [PATCH 6.1 00/71] 6.1.108-rc1 review
Date: Sun,  1 Sep 2024 18:17:05 +0200
Message-ID: <20240901160801.879647959@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.108-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.108-rc1
X-KernelTest-Deadline: 2024-09-03T16:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.108 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.108-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.108-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    fbdev: offb: fix up missing cleanup.h

Guenter Roeck <linux@roeck-us.net>
    apparmor: fix policy_unpack_test on big endian systems

Ben Hutchings <benh@debian.org>
    scsi: aacraid: Fix double-free on probe failure

Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
    igc: Fix qbv tx latency by setting gtxoffset

Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
    igc: Fix reset adapter logics when tx mode change

Sean Anderson <sean.anderson@linux.dev>
    phy: zynqmp: Enable reference clock correctly

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: fix for Link TRB with TC

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: fix incorrect index in cdnsp_get_hw_deq function

Zijun Hu <quic_zijuhu@quicinc.com>
    usb: core: sysfs: Unmerge @usb3_hardware_lpm_attr_group in remove_power_attributes()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    usb: dwc3: st: add missing depopulate in probe error path

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    usb: dwc3: st: fix probed platform device ref count on probe error path

Selvarasu Ganesan <selvarasu.g@samsung.com>
    usb: dwc3: core: Prevent USB core invalid event buffer address access

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    usb: dwc3: omap: add missing depopulate in probe error path

ZHANG Yuntian <yt@radxa.com>
    USB: serial: option: add MeiG Smart SRM825L

Ian Ray <ian.ray@gehealthcare.com>
    cdc-acm: Add DISABLE_ECHO quirk for GE HealthCare UI Controller

Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
    soc: qcom: cmd-db: Map shared memory as WC, not WB

Aleksandr Mishin <amishin@t-argos.ru>
    nfc: pn533: Add poll mod list filling check

Eric Dumazet <edumazet@google.com>
    net: busy-poll: use ktime_get_ns() instead of local_clock()

Ma Ke <make24@iscas.ac.cn>
    drm/amd/display: avoid using null object of framebuffer

Ondrej Mosnacek <omosnace@redhat.com>
    sctp: fix association labeling in the duplicate COOKIE-ECHO case

Cong Wang <cong.wang@bytedance.com>
    gtp: fix a potential NULL pointer dereference

Jianbo Liu <jianbol@nvidia.com>
    bonding: implement xdo_dev_state_free and call it after deletion

Petr Machata <petrm@nvidia.com>
    selftests: forwarding: local_termination: Down ports on cleanup

Petr Machata <petrm@nvidia.com>
    selftests: forwarding: no_forwarding: Down ports on cleanup

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables_ipv6: consider network offset in netdev/egress validation

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    ethtool: check device is present when getting link settings

Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: iwlwifi: fw: fix wgds rev 3 exact size

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: restore IP sanity checks for netdev/egress

Jason Gunthorpe <jgg@ziepe.ca>
    iommu: Do not return 0 from map_pages if it doesn't do anything

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix not handling hibernation actions

Serge Semin <fancer.lancer@gmail.com>
    dmaengine: dw: Add memory bus width verification

Serge Semin <fancer.lancer@gmail.com>
    dmaengine: dw: Add peripheral bus width verification

Piyush Mehta <piyush.mehta@amd.com>
    phy: xilinx: phy-zynqmp: Fix SGMII linkup failure on resume

Piyush Mehta <piyush.mehta@amd.com>
    phy: xilinx: phy-zynqmp: dynamic clock support for power-save

Piyush Mehta <piyush.mehta@amd.com>
    phy: xilinx: add runtime PM support

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soundwire: stream: fix programming slave ports for non-continous port maps

Filipe Manana <fdmanana@suse.com>
    btrfs: fix extent map use-after-free when adding pages to compressed bio

David Howells <dhowells@redhat.com>
    mm: Fix missing folio invalidation calls during truncation

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    pinctrl: mediatek: common-v2: Fix broken bias-disable for PULL_PU_PD_RSEL_TYPE

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: Fix for acp init sequence

Yuntao Liu <liuyuntao12@huawei.com>
    ASoC: amd: acp: fix module autoloading

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    thermal: of: Fix OF node leak in of_thermal_zone_find() error paths

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    thermal: of: Fix OF node leak in thermal_of_trips_init() error path

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    of: Introduce for_each_*_child_of_node_scoped() to automate of_node_put() handling

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: check add_addr_accept_max before accepting new ADD_ADDR

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: only mark 'subflow' endp as available

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: remove mptcp_pm_remove_subflow()

Geliang Tang <geliang.tang@suse.com>
    mptcp: unify pm get_local_id interfaces

Mengqi Zhang <mengqi.zhang@mediatek.com>
    mmc: mtk-sd: receive cmd8 data when hs400 tuning fail

ChanWoo Lee <cw9316.lee@samsung.com>
    mmc: Avoid open coding by using mmc_op_tuning()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: fix up incorrectly backported "usb: typec: tcpm: unregister existing source caps before re-registration"

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Fix null pointer dereference on error

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/swsmu: always force a state reprogram on init

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: align pp_power_profile_mode with kernel docs

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR 0 is not a new address

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: do not remove already closed subflows

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: send ACK on an active subflow

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: reset MPC endp ID when re-added

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: skip connecting to already established sf

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: sched: check both backup in retrans

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: close subflow when receiving TCP+FIN

Haiyang Zhang <haiyangz@microsoft.com>
    net: mana: Fix race of mana_hwc_post_rx_wqe and new hwc response

Sascha Hauer <s.hauer@pengutronix.de>
    wifi: mwifiex: duplicate static structs used in driver instances

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    wifi: wfx: repair open network AP mode

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    of: Add cleanup.h based auto release via __free(device_node) markings

Ma Ke <make24@iscas.ac.cn>
    pinctrl: single: fix potential NULL dereference in pcs_get_function()

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: correct RK3328 iomux width flag for GPIO2-B pins

Stefan Metzmacher <metze@samba.org>
    smb/client: avoid dereferencing rdata=NULL in smb2_new_read_req()

Josef Bacik <josef@toxicpanda.com>
    btrfs: run delayed iputs when flushing delalloc

Miao Wang <shankerwangmiao@gmail.com>
    LoongArch: Remove the unused dma-direct.h

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdgpu: Using uninitialized value *size when calling amdgpu_vce_cs_reloc


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/loongarch/include/asm/dma-direct.h            |  11 --
 drivers/ata/libata-core.c                          |   3 +
 drivers/dma/dw/core.c                              |  89 +++++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |   3 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |   9 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  21 +--
 drivers/iommu/io-pgtable-arm-v7s.c                 |   3 +-
 drivers/iommu/io-pgtable-arm.c                     |   3 +-
 drivers/iommu/io-pgtable-dart.c                    |   3 +-
 drivers/mmc/core/core.c                            |   3 +-
 drivers/mmc/host/dw_mmc.c                          |   3 +-
 drivers/mmc/host/mtk-sd.c                          |  14 +-
 drivers/mmc/host/sdhci-msm.c                       |   3 +-
 drivers/mmc/host/sdhci-pci-o2micro.c               |   3 +-
 drivers/mmc/host/sdhci-tegra.c                     |   8 +-
 drivers/mmc/host/sdhci.c                           |   9 +-
 drivers/net/bonding/bond_main.c                    |  36 +++++
 drivers/net/ethernet/intel/igc/igc_tsn.c           |   9 +-
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |  68 ++++-----
 drivers/net/gtp.c                                  |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  13 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  32 ++++-
 drivers/net/wireless/silabs/wfx/sta.c              |   5 +-
 drivers/nfc/pn533/pn533.c                          |   5 +
 drivers/phy/xilinx/phy-zynqmp.c                    | 152 ++++++++++++++-------
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c   |  55 ++++----
 drivers/pinctrl/pinctrl-rockchip.c                 |   2 +-
 drivers/pinctrl/pinctrl-single.c                   |   2 +
 drivers/scsi/aacraid/comminit.c                    |   2 +
 drivers/soc/qcom/cmd-db.c                          |   2 +-
 drivers/soundwire/stream.c                         |   8 +-
 drivers/thermal/thermal_of.c                       |  17 +--
 drivers/usb/cdns3/cdnsp-gadget.h                   |   3 +
 drivers/usb/cdns3/cdnsp-ring.c                     |  30 +++-
 drivers/usb/class/cdc-acm.c                        |   3 +
 drivers/usb/core/sysfs.c                           |   1 +
 drivers/usb/dwc3/core.c                            |   8 ++
 drivers/usb/dwc3/dwc3-omap.c                       |   4 +-
 drivers/usb/dwc3/dwc3-st.c                         |  16 +--
 drivers/usb/serial/option.c                        |   5 +
 drivers/usb/typec/tcpm/tcpm.c                      |  14 +-
 drivers/video/fbdev/offb.c                         |   1 +
 fs/btrfs/compression.c                             |   2 +-
 fs/btrfs/qgroup.c                                  |   2 +
 fs/smb/client/smb2pdu.c                            |   2 +-
 include/linux/of.h                                 |  15 ++
 include/net/busy_poll.h                            |   2 +-
 include/net/netfilter/nf_tables_ipv4.h             |  10 +-
 include/net/netfilter/nf_tables_ipv6.h             |   5 +-
 mm/truncate.c                                      |   4 +-
 net/bluetooth/hci_core.c                           |  10 +-
 net/core/net-sysfs.c                               |   2 +-
 net/ethtool/ioctl.c                                |   3 +
 net/mptcp/pm.c                                     |  32 +++--
 net/mptcp/pm_netlink.c                             | 110 ++++++++-------
 net/mptcp/protocol.c                               |   7 +-
 net/mptcp/protocol.h                               |   7 +-
 net/mptcp/subflow.c                                |   8 +-
 net/sctp/sm_statefuns.c                            |  22 ++-
 security/apparmor/policy_unpack_test.c             |   6 +-
 sound/soc/amd/acp/acp-legacy-mach.c                |   2 +
 sound/soc/sof/amd/acp.c                            |  19 ++-
 sound/soc/sof/amd/acp.h                            |   7 +-
 .../selftests/net/forwarding/local_termination.sh  |   4 +
 .../selftests/net/forwarding/no_forwarding.sh      |   3 +
 66 files changed, 653 insertions(+), 318 deletions(-)


