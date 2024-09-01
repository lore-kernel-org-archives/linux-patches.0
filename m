Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A1D44C97;
	Sun,  1 Sep 2024 16:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207976; cv=none; b=lcLeiamS63mZbLToW5CzXFjL8cbo7xb+uvG2Jyah03oYNnS2VHi+DJYAirLwVo1ho8wmDMDx2kNQrU7jbxzCP60IpEWpZWYQint4dJnFBSTjgWP0yFamA9cvyL83jPiMlkE2zxc3mv1cT/3puHaSIBze5VRJegj4CgXdfomfbCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207976; c=relaxed/simple;
	bh=hrd09dmZdqqZayX/XqSaWjhV6Mw/lk2lk6aBbETW9i8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qHz27ogiM3mnpgEBO03LpdGww6aqwlBMdNme7ztyUnHDVrJObHgCo8cbYA8oR/wN/f0UPXdMqEJ0cEjGgg5kno72+JZnuFpEN4aDz6EquoeGVDMAY6GLPyHb+o2UzTQcqNU0pt8AZ1fAp89IqSh6xQDSrraXbEYiPr8nWjBGiKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PsiiCtYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PsiiCtYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D532C4CEC3;
	Sun,  1 Sep 2024 16:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207976;
	bh=hrd09dmZdqqZayX/XqSaWjhV6Mw/lk2lk6aBbETW9i8=;
	h=From:To:Cc:Subject:Date:From;
	b=PsiiCtYnRSMfcXNNo1ENslVt3nb2TmadzDElu5vr0C41YJzncY7Q0SKraFdywdjT0
	 1UMkYJaO9v9oslTYOpoAiLJqsfOHWCJITRmgiSp5anxIClfJHAZV8N1BxSe/j29Y8/
	 d3BuJMKSJLjLsPdWbPEYtRjXnGN+RdavWaEisvXA=
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
Subject: [PATCH 6.6 00/93] 6.6.49-rc1 review
Date: Sun,  1 Sep 2024 18:15:47 +0200
Message-ID: <20240901160807.346406833@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.49-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.49-rc1
X-KernelTest-Deadline: 2024-09-03T16:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.49 release.
There are 93 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.49-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.49-rc1

Guenter Roeck <linux@roeck-us.net>
    apparmor: fix policy_unpack_test on big endian systems

Ben Hutchings <benh@debian.org>
    scsi: aacraid: Fix double-free on probe failure

Markus Niebel <Markus.Niebel@ew.tq-group.com>
    arm64: dts: freescale: imx93-tqma9352-mba93xxla: fix typo

Markus Niebel <Markus.Niebel@ew.tq-group.com>
    arm64: dts: freescale: imx93-tqma9352: fix CMA alloc-ranges

Shenwei Wang <shenwei.wang@nxp.com>
    arm64: dts: imx93: update default value for snps,clk-csr

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx93: add nvmem property for eqos

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx93: add nvmem property for fec1

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mp-beacon-kit: Fix Stereo Audio on WM8962

Sicelo A. Mhlongo <absicsz@gmail.com>
    ARM: dts: omap3-n900: correct the accelerometer orientation

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

Michal Vokáč <michal.vokac@ysoft.com>
    ARM: dts: imx6dl-yapp43: Increase LED current to match the yapp4 HW design

ZHANG Yuntian <yt@radxa.com>
    USB: serial: option: add MeiG Smart SRM825L

Yihang Li <liyihang9@huawei.com>
    scsi: sd: Ignore command SYNCHRONIZE CACHE error if format in progress

Murali Nalajala <quic_mnalajal@quicinc.com>
    firmware: qcom: scm: Mark get_wq_ctx() as atomic call

Ian Ray <ian.ray@gehealthcare.com>
    cdc-acm: Add DISABLE_ECHO quirk for GE HealthCare UI Controller

Bjorn Andersson <quic_bjorande@quicinc.com>
    soc: qcom: pmic_glink: Fix race during initialization

Bjorn Andersson <quic_bjorande@quicinc.com>
    soc: qcom: pmic_glink: Actually communicate when remote goes down

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
    bonding: change ipsec_lock from spin lock to mutex

Jianbo Liu <jianbol@nvidia.com>
    bonding: extract the use of real_device into local variable

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

Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
    Bluetooth: btnxpuart: Fix random crash seen while removing driver

Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
    Bluetooth: btnxpuart: Handle FW Download Abort scenario

Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
    Bluetooth: btnxpuart: Resolve TX timeout error in power save stress test

Serge Semin <fancer.lancer@gmail.com>
    dmaengine: dw: Add memory bus width verification

Serge Semin <fancer.lancer@gmail.com>
    dmaengine: dw: Add peripheral bus width verification

Piyush Mehta <piyush.mehta@amd.com>
    phy: xilinx: phy-zynqmp: Fix SGMII linkup failure on resume

Mrinmay Sarkar <quic_msarkar@quicinc.com>
    dmaengine: dw-edma: Do not enable watermark interrupts for HDMA

Mrinmay Sarkar <quic_msarkar@quicinc.com>
    dmaengine: dw-edma: Fix unmasking STOP and ABORT interrupts for HDMA

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soundwire: stream: fix programming slave ports for non-continous port maps

Xu Yang <xu.yang_2@nxp.com>
    phy: fsl-imx8mq-usb: fix tuning parameter name

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Do not allow creating areas without READ or WRITE

Scott Mayhew <smayhew@redhat.com>
    selinux,smack: don't bypass permissions check in inode_setsecctx hook

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "change alloc_pages name in dma_map_ops to avoid name conflicts"

David Howells <dhowells@redhat.com>
    cifs: Fix FALLOC_FL_PUNCH_HOLE support

David Howells <dhowells@redhat.com>
    mm: Fix missing folio invalidation calls during truncation

Zhihao Cheng <chengzhihao1@huawei.com>
    ovl: ovl_parse_param_lowerdir: Add missed '\n' for pr_err

Zhihao Cheng <chengzhihao1@huawei.com>
    ovl: fix wrong lowerdir number check for parameter Opt_lowerdir

Christian Brauner <brauner@kernel.org>
    ovl: pass string to ovl_parse_layer()

Hal Feng <hal.feng@starfivetech.com>
    pinctrl: starfive: jh7110: Correct the level trigger configuration of iev register

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

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: fix up incorrectly backported "usb: typec: tcpm: unregister existing source caps before re-registration"

Steven Rostedt <rostedt@goodmis.org>
    tracing: Have format file honor EVENT_FILE_FL_FREED

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Fix prime with external buffers

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/swsmu: always force a state reprogram on init

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: align pp_power_profile_mode with kernel docs

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check re-re-adding ID 0 endp

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: no extra msg if no counter

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check removing ID 0 endpoint

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR 0 is not a new address

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: fix ID 0 endp usage after multiple re-creations

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: do not remove already closed subflows

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: send ACK on an active subflow

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: reset MPC endp ID when re-added

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: skip connecting to already established sf

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: reuse ID 0 after delete and re-add

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

Qu Wenruo <wqu@suse.com>
    btrfs: fix a use-after-free when hitting errors inside btrfs_submit_chunk()

Miao Wang <shankerwangmiao@gmail.com>
    LoongArch: Remove the unused dma-direct.h

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Skip event type filtering for UMP events


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/alpha/kernel/pci_iommu.c                      |   2 +-
 .../arm/boot/dts/nxp/imx/imx6dl-yapp43-common.dtsi |  12 +-
 arch/arm/boot/dts/ti/omap/omap3-n900.dts           |   2 +-
 .../arm64/boot/dts/freescale/imx8mp-beacon-kit.dts |  12 +-
 .../dts/freescale/imx93-tqma9352-mba93xxla.dts     |   2 +-
 arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi  |   2 +-
 arch/arm64/boot/dts/freescale/imx93.dtsi           |  15 +-
 arch/loongarch/include/asm/dma-direct.h            |  11 --
 arch/mips/jazz/jazzdma.c                           |   2 +-
 arch/powerpc/kernel/dma-iommu.c                    |   2 +-
 arch/powerpc/platforms/ps3/system-bus.c            |   4 +-
 arch/powerpc/platforms/pseries/vio.c               |   2 +-
 arch/x86/kernel/amd_gart_64.c                      |   2 +-
 drivers/bluetooth/btnxpuart.c                      |  89 +++++++++---
 drivers/dma/dw-edma/dw-hdma-v0-core.c              |  26 ++--
 drivers/dma/dw/core.c                              |  89 +++++++++++-
 drivers/firmware/qcom_scm-smc.c                    |   2 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |   9 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  21 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_blit.c               | 114 ++++++++++++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c               |  12 +-
 drivers/iommu/dma-iommu.c                          |   2 +-
 drivers/iommu/io-pgtable-arm-v7s.c                 |   3 +-
 drivers/iommu/io-pgtable-arm.c                     |   3 +-
 drivers/iommu/io-pgtable-dart.c                    |   3 +-
 drivers/iommu/iommufd/ioas.c                       |   8 ++
 drivers/net/bonding/bond_main.c                    | 159 ++++++++++++++-------
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |  68 +++++----
 drivers/net/gtp.c                                  |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  13 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  32 ++++-
 drivers/net/wireless/silabs/wfx/sta.c              |   5 +-
 drivers/nfc/pn533/pn533.c                          |   5 +
 drivers/parisc/ccio-dma.c                          |   2 +-
 drivers/parisc/sba_iommu.c                         |   2 +-
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c         |   2 +-
 drivers/phy/xilinx/phy-zynqmp.c                    |  56 ++++++++
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c   |  55 +++----
 drivers/pinctrl/pinctrl-rockchip.c                 |   2 +-
 drivers/pinctrl/pinctrl-single.c                   |   2 +
 drivers/pinctrl/starfive/pinctrl-starfive-jh7110.c |   4 +-
 drivers/power/supply/qcom_battmgr.c                |  16 ++-
 drivers/scsi/aacraid/comminit.c                    |   2 +
 drivers/scsi/sd.c                                  |  12 +-
 drivers/soc/qcom/cmd-db.c                          |   2 +-
 drivers/soc/qcom/pmic_glink.c                      |  30 ++--
 drivers/soc/qcom/pmic_glink_altmode.c              |  17 ++-
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
 drivers/usb/typec/ucsi/ucsi_glink.c                |  16 ++-
 drivers/xen/grant-dma-ops.c                        |   2 +-
 drivers/xen/swiotlb-xen.c                          |   2 +-
 fs/btrfs/bio.c                                     |  26 ++--
 fs/btrfs/qgroup.c                                  |   2 +
 fs/overlayfs/params.c                              |  51 ++-----
 fs/smb/client/smb2ops.c                            |  22 +++
 fs/smb/client/smb2pdu.c                            |   2 +-
 include/linux/dma-map-ops.h                        |   2 +-
 include/linux/of.h                                 |  15 ++
 include/linux/soc/qcom/pmic_glink.h                |  11 +-
 include/net/bonding.h                              |   2 +-
 include/net/busy_poll.h                            |   2 +-
 include/net/netfilter/nf_tables_ipv4.h             |  10 +-
 include/net/netfilter/nf_tables_ipv6.h             |   5 +-
 kernel/dma/mapping.c                               |   4 +-
 kernel/trace/trace.h                               |  23 +++
 kernel/trace/trace_events.c                        |  33 +++--
 kernel/trace/trace_events_hist.c                   |   4 +-
 kernel/trace/trace_events_inject.c                 |   2 +-
 kernel/trace/trace_events_trigger.c                |   6 +-
 mm/truncate.c                                      |   4 +-
 net/bluetooth/hci_core.c                           |  10 +-
 net/core/net-sysfs.c                               |   2 +-
 net/ethtool/ioctl.c                                |   3 +
 net/mptcp/pm.c                                     |   4 +-
 net/mptcp/pm_netlink.c                             |  59 ++++++--
 net/mptcp/protocol.c                               |   7 +-
 net/mptcp/protocol.h                               |   2 +
 net/mptcp/subflow.c                                |   8 +-
 net/sctp/sm_statefuns.c                            |  22 ++-
 security/apparmor/policy_unpack_test.c             |   6 +-
 security/selinux/hooks.c                           |   4 +-
 security/smack/smack_lsm.c                         |   4 +-
 sound/core/seq/seq_clientmgr.c                     |   3 +
 sound/soc/amd/acp/acp-legacy-mach.c                |   2 +
 sound/soc/sof/amd/acp.c                            |  19 ++-
 sound/soc/sof/amd/acp.h                            |   7 +-
 tools/testing/selftests/iommu/iommufd.c            |   6 +-
 .../selftests/net/forwarding/local_termination.sh  |   4 +
 .../selftests/net/forwarding/no_forwarding.sh      |   3 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  46 +++---
 102 files changed, 1075 insertions(+), 448 deletions(-)


