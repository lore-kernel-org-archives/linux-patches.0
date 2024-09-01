Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28928537FF;
	Sun,  1 Sep 2024 16:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208261; cv=none; b=JuAr/WyESSpiStazfFer67bDxSVysNSTTj5OkWjPis9Qmyk4bTv7fh6Lu62uZwoqaklz4du61U9ePb2iMu25gw12PjaF4TYyK6qSCQVr4K8lDH0/fMJ6RjmvzD4/MOGCcKobIbK7amaBWjTj4UxoZqqYgUKWLeERUnLyFCB5OSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208261; c=relaxed/simple;
	bh=F3SGQi5zJm66+praGessF98lB88GlhsRuFccAD2DFOU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mCJrUrZKclqGqXyrOJ2wz2p43bwjiJinBGSMFMefPVCW2FCnyM2zI/45+K8z3DWe8hT0Oli5T1cjnX1hT+3d3e3dfTDs3rWcwI3wKEMXNtbufpJjjKgJzZ2YvBMpRyAh36Mla1lwo890O+4fj5fwcywK3VNVSo7XxiNj7fI6wo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YI6wtXut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YI6wtXut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3872AC4CEC4;
	Sun,  1 Sep 2024 16:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208261;
	bh=F3SGQi5zJm66+praGessF98lB88GlhsRuFccAD2DFOU=;
	h=From:To:Cc:Subject:Date:From;
	b=YI6wtXut0G7KXEKO+239J5gdBi62g96RcBpgnxWU9sAvW6zybOolbH8mYIUZGJMWv
	 mVMc5xNxGSmGQk/CVTlP648e7gKWXZss70JnCgRjq9Kv2DUmOzwbS9jlTnj2NpAlbz
	 LZXlOF7CEWcNldrBQgMVLcI/QuatYuAD5RPY6TPs=
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
Subject: [PATCH 6.10 000/149] 6.10.8-rc1 review
Date: Sun,  1 Sep 2024 18:15:11 +0200
Message-ID: <20240901160817.461957599@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.10.8-rc1
X-KernelTest-Deadline: 2024-09-03T16:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.10.8 release.
There are 149 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.10.8-rc1

NeilBrown <neilb@suse.de>
    nfsd: fix nfsd4_deleg_getattr_conflict in presence of third party lease

Guenter Roeck <linux@roeck-us.net>
    apparmor: fix policy_unpack_test on big endian systems

Ben Hutchings <benh@debian.org>
    scsi: aacraid: Fix double-free on probe failure

Steve Wilkins <steve.wilkins@raymarine.com>
    firmware: microchip: fix incorrect error report of programming:timeout on success

Markus Niebel <Markus.Niebel@ew.tq-group.com>
    arm64: dts: freescale: imx93-tqma9352-mba93xxla: fix typo

Markus Niebel <Markus.Niebel@ew.tq-group.com>
    arm64: dts: freescale: imx93-tqma9352: fix CMA alloc-ranges

Shenwei Wang <shenwei.wang@nxp.com>
    arm64: dts: imx93: update default value for snps,clk-csr

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mp-beacon-kit: Fix Stereo Audio on WM8962

Sicelo A. Mhlongo <absicsz@gmail.com>
    ARM: dts: omap3-n900: correct the accelerometer orientation

Varadarajan Narayanan <quic_varada@quicinc.com>
    arm64: dts: qcom: ipq5332: Fix interrupt trigger type for usb

Bjorn Andersson <quic_bjorande@quicinc.com>
    usb: typec: ucsi: Move unregister out of atomic section

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

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    usb: dwc3: xilinx: add missing depopulate in probe error path

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: dwc3: ep0: Don't reset resource alloc flag (including ep0)

Michal Vokáč <michal.vokac@ysoft.com>
    ARM: dts: imx6dl-yapp43: Increase LED current to match the yapp4 HW design

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: x1e80100: fix PCIe domain numbers

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: x1e80100: add missing PCIe minimum OPP

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: x1e80100-qcp: fix PCIe4 PHY supply

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: x1e80100-crd: fix PCIe4 PHY supply

Xu Yang <xu.yang_2@nxp.com>
    usb: gadget: uvc: queue pump work in uvcg_video_enable()

ZHANG Yuntian <yt@radxa.com>
    USB: serial: option: add MeiG Smart SRM825L

Alexander Stein <alexander.stein@ew.tq-group.com>
    dt-bindings: usb: microchip,usb2514: Fix reference USB device schema

Yihang Li <liyihang9@huawei.com>
    scsi: sd: Ignore command SYNCHRONIZE CACHE error if format in progress

Murali Nalajala <quic_mnalajal@quicinc.com>
    firmware: qcom: scm: Mark get_wq_ctx() as atomic call

Luca Weiss <luca.weiss@fairphone.com>
    usb: typec: fsa4480: Relax CHIP_ID check

Ian Ray <ian.ray@gehealthcare.com>
    cdc-acm: Add DISABLE_ECHO quirk for GE HealthCare UI Controller

Bjorn Andersson <quic_bjorande@quicinc.com>
    soc: qcom: pmic_glink: Fix race during initialization

Bjorn Andersson <quic_bjorande@quicinc.com>
    soc: qcom: pmic_glink: Actually communicate when remote goes down

Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
    soc: qcom: cmd-db: Map shared memory as WC, not WB

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: return correct iovec count from classic buffer peek

Karthik Poosa <karthik.poosa@intel.com>
    drm/xe/hwmon: Fix WRITE_I1 param from u32 to u16

Aleksandr Mishin <amishin@t-argos.ru>
    nfc: pn533: Add poll mod list filling check

Eric Dumazet <edumazet@google.com>
    net: busy-poll: use ktime_get_ns() instead of local_clock()

Ma Ke <make24@iscas.ac.cn>
    drm/amd/display: avoid using null object of framebuffer

Ondrej Mosnacek <omosnace@redhat.com>
    sctp: fix association labeling in the duplicate COOKIE-ECHO case

Xueming Feng <kuro@kuroa.me>
    tcp: fix forever orphan socket caused by tcp_abort

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

Eric Dumazet <edumazet@google.com>
    net_sched: sch_fq: fix incorrect behavior for small weights

Cosmo Chou <chou.cosmo@gmail.com>
    hwmon: (pt5161l) Fix invalid temperature reading

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    ethtool: check device is present when getting link settings

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mvm: allow 6 GHz channels in MLO scan

Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: iwlwifi: fw: fix wgds rev 3 exact size

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: take the mutex before running link selection

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

Mario Limonciello <mario.limonciello@amd.com>
    cpufreq/amd-pstate-ut: Don't check for highest perf matching on prefcore

Eric Dumazet <edumazet@google.com>
    pktgen: use cpus_read_lock() in pg_net_init()

Kees Cook <kees@kernel.org>
    dmaengine: ti: omap-dma: Initialize sglen after allocation

Serge Semin <fancer.lancer@gmail.com>
    dmaengine: dw: Add memory bus width verification

Serge Semin <fancer.lancer@gmail.com>
    dmaengine: dw: Add peripheral bus width verification

Piyush Mehta <piyush.mehta@amd.com>
    phy: xilinx: phy-zynqmp: Fix SGMII linkup failure on resume

Abel Vesa <abel.vesa@linaro.org>
    phy: qcom: qmp-pcie: Fix X1E80100 PCIe Gen4 PHY initialisation

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

Gautham R. Shenoy <gautham.shenoy@amd.com>
    cpufreq/amd-pstate: Use topology_logical_package_id() instead of logical_die_id()

Scott Mayhew <smayhew@redhat.com>
    selinux,smack: don't bypass permissions check in inode_setsecctx hook

Jeff Layton <jlayton@kernel.org>
    fs/nfsd: fix update of inode attrs in CB_GETATTR

Jeff Layton <jlayton@kernel.org>
    nfsd: fix potential UAF in nfsd4_cb_getattr_release

Jeff Layton <jlayton@kernel.org>
    nfsd: hold reference to delegation when updating it for cb_getattr

David Howells <dhowells@redhat.com>
    cifs: Fix FALLOC_FL_PUNCH_HOLE support

Stefan Metzmacher <metze@samba.org>
    smb/client: remove unused rq_iter_size from struct smb_rqst

David Howells <dhowells@redhat.com>
    netfs: Fix interaction of streaming writes with zero-point tracker

David Howells <dhowells@redhat.com>
    netfs: Fix missing iterator reset on retry of short read

David Howells <dhowells@redhat.com>
    netfs: Fix trimming of streaming-write folios in netfs_inval_folio()

David Howells <dhowells@redhat.com>
    netfs: Fix netfs_release_folio() to say no if folio dirty

David Howells <dhowells@redhat.com>
    afs: Fix post-setattr file edit to do truncation correctly

David Howells <dhowells@redhat.com>
    mm: Fix missing folio invalidation calls during truncation

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: prevent panic for nfsv4.0 closed files in nfs4_show_open

Hal Feng <hal.feng@starfivetech.com>
    pinctrl: starfive: jh7110: Correct the level trigger configuration of iev register

Konrad Dybcio <quic_kdybcio@quicinc.com>
    pinctrl: qcom: x1e80100: Fix special pin offsets

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    pinctrl: mediatek: common-v2: Fix broken bias-disable for PULL_PU_PD_RSEL_TYPE

Ed Tsai <ed.tsai@mediatek.com>
    backing-file: convert to using fops->splice_write

Jeff Layton <jlayton@kernel.org>
    nfsd: ensure that nfsd4_fattr_args.context is zeroed out

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs-amp-lib: Ignore empty UEFI calibration entries

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs-amp-lib-test: Force test calibration blob entries to be valid

Simon Trimmer <simont@opensource.cirrus.com>
    ALSA: hda: cs35l56: Don't use the device index as a calibration index

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: Fix for acp init sequence

Yuntao Liu <liuyuntao12@huawei.com>
    ASoC: amd: acp: fix module autoloading

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: Fix for incorrect acp error register offsets

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: move iram-dram fence register programming sequence

Konrad Dybcio <konrad.dybcio@linaro.org>
    pinctrl: qcom: x1e80100: Update PDC hwirq map

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix eGPU hotplug regression

Victor Lu <victorchengchi.lu@amd.com>
    drm/amdgpu: Do not wait for MP0_C2PMSG_33 IFWI init in SRIOV

Matthew Auld <matthew.auld@intel.com>
    drm/xe: prevent UAF around preempt fence

Francois Dugast <francois.dugast@intel.com>
    drm/xe/exec_queue: Rename xe_exec_queue::compute to xe_exec_queue::lr

Thorsten Blum <thorsten.blum@toblux.com>
    drm/xe/vm: Simplify if condition

Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
    drm/xe/display: Make display suspend/resume work on discrete

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/xe: Prepare display for D3Cold

Alex Deucher <alexander.deucher@amd.com>
    video/aperture: optionally match the device in sysfb_disable()

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Disable coherent dumb buffers without 3d

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Fix prime with external buffers

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Prevent unmapping active read buffers

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/swsmu: always force a state reprogram on init

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: align pp_power_profile_mode with kernel docs

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_mst: Fix MST state after a sink reset

Hans de Goede <hdegoede@redhat.com>
    drm/i915/dsi: Make Lenovo Yoga Tab 3 X90F DMI match less strict

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/v3d: Disable preemption while updating GPU stats

Max Filippov <jcmvbkbc@gmail.com>
    binfmt_elf_fdpic: fix AUXV size calculation when ELF_HWCAP2 is defined

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check re-re-adding ID 0 endp

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: no extra msg if no counter

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check removing ID 0 endpoint

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: cannot rm sf if closed

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR 0 is not a new address

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: avoid duplicated SUB_CLOSED events

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: fix ID 0 endp usage after multiple re-creations

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: do not remove already closed subflows

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: fix RM_ADDR ID for the initial subflow

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: send ACK on an active subflow

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: reset MPC endp ID when re-added

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: skip connecting to already established sf

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: reuse ID 0 after delete and re-add

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pr_debug: add missing \n at the end

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

David Howells <dhowells@redhat.com>
    netfs, ceph: Partially revert "netfs: Replace PG_fscache by setting folio->private and marking dirty"

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

Stefan Berger <stefanb@linux.ibm.com>
    tpm: ibmvtpm: Call tpm2_sessions_init() to initialize session support

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Add ifdefs to fix LSX and LASX related warnings

Miao Wang <shankerwangmiao@gmail.com>
    LoongArch: Remove the unused dma-direct.h

Hendrik Borghorst <hendrikborghorst@gmail.com>
    ALSA: hda/realtek: support HP Pavilion Aero 13-bg0xxx Mute LED

John Sweeney <john.sweeney@runbox.com>
    ALSA: hda/realtek: Enable mute/micmute LEDs on HP Laptop 14-ey0xxx

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Skip event type filtering for UMP events

Gao Xiang <xiang@kernel.org>
    erofs: fix out-of-bound access when z_erofs_gbuf_growsize() partially fails

Jack Xiao <Jack.Xiao@amd.com>
    drm/amdgpu/mes: fix mes ring buffer overflow


-------------

Diffstat:

 .../devicetree/bindings/usb/microchip,usb2514.yaml |   9 +-
 Makefile                                           |   4 +-
 .../arm/boot/dts/nxp/imx/imx6dl-yapp43-common.dtsi |  12 +-
 arch/arm/boot/dts/ti/omap/omap3-n900.dts           |   2 +-
 .../arm64/boot/dts/freescale/imx8mp-beacon-kit.dts |  12 +-
 .../dts/freescale/imx93-tqma9352-mba93xxla.dts     |   2 +-
 arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi  |   2 +-
 arch/arm64/boot/dts/freescale/imx93.dtsi           |   2 +-
 arch/arm64/boot/dts/qcom/ipq5332.dtsi              |   4 +-
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts          |   2 +-
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts          |   2 +-
 arch/arm64/boot/dts/qcom/x1e80100.dtsi             |   6 +-
 arch/loongarch/include/asm/dma-direct.h            |  11 --
 arch/loongarch/kernel/fpu.S                        |   4 +
 arch/loongarch/kvm/switch.S                        |   4 +
 drivers/bluetooth/btnxpuart.c                      |  65 +++++++--
 drivers/char/tpm/tpm_ibmvtpm.c                     |   4 +
 drivers/cpufreq/amd-pstate-ut.c                    |  13 +-
 drivers/cpufreq/amd-pstate.c                       |   2 +-
 drivers/dma/dw-edma/dw-hdma-v0-core.c              |  26 ++--
 drivers/dma/dw/core.c                              |  89 +++++++++++-
 drivers/dma/ti/omap-dma.c                          |   6 +-
 drivers/firmware/microchip/mpfs-auto-update.c      |   2 +-
 drivers/firmware/qcom/qcom_scm-smc.c               |   2 +-
 drivers/firmware/sysfb.c                           |  19 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |  26 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |   2 +
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |  18 ++-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |   9 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  21 +--
 drivers/gpu/drm/i915/display/intel_dp.c            |  12 ++
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |  40 ++++++
 drivers/gpu/drm/i915/display/intel_dp_mst.h        |   1 +
 drivers/gpu/drm/i915/display/vlv_dsi.c             |   1 -
 drivers/gpu/drm/v3d/v3d_sched.c                    |   6 +
 drivers/gpu/drm/vmwgfx/vmwgfx_blit.c               | 114 ++++++++++++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                 |  13 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.h                 |   3 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c               |  12 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |   6 +-
 drivers/gpu/drm/xe/display/xe_display.c            |  33 ++++-
 drivers/gpu/drm/xe/display/xe_display.h            |   8 +-
 drivers/gpu/drm/xe/xe_exec_queue.c                 |   5 +-
 drivers/gpu/drm/xe/xe_exec_queue_types.h           |  14 +-
 drivers/gpu/drm/xe/xe_hwmon.c                      |   2 +-
 drivers/gpu/drm/xe/xe_pm.c                         |  20 ++-
 drivers/gpu/drm/xe/xe_preempt_fence.c              |   3 +-
 drivers/gpu/drm/xe/xe_preempt_fence_types.h        |   2 +
 drivers/gpu/drm/xe/xe_vm.c                         |  60 ++++----
 drivers/hwmon/pt5161l.c                            |   4 +-
 drivers/iommu/io-pgtable-arm-v7s.c                 |   3 +-
 drivers/iommu/io-pgtable-arm.c                     |   3 +-
 drivers/iommu/io-pgtable-dart.c                    |   3 +-
 drivers/iommu/iommufd/ioas.c                       |   8 ++
 drivers/net/bonding/bond_main.c                    | 159 ++++++++++++++-------
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |  68 +++++----
 drivers/net/gtp.c                                  |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  11 ++
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  32 ++++-
 drivers/net/wireless/silabs/wfx/sta.c              |   5 +-
 drivers/nfc/pn533/pn533.c                          |   5 +
 drivers/of/platform.c                              |   2 +-
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c         |   2 +-
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c           |  23 ++-
 drivers/phy/xilinx/phy-zynqmp.c                    |  56 ++++++++
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c   |  55 +++----
 drivers/pinctrl/pinctrl-rockchip.c                 |   2 +-
 drivers/pinctrl/pinctrl-single.c                   |   2 +
 drivers/pinctrl/qcom/pinctrl-x1e80100.c            |  35 ++---
 drivers/pinctrl/starfive/pinctrl-starfive-jh7110.c |   4 +-
 drivers/power/supply/qcom_battmgr.c                |  16 ++-
 drivers/scsi/aacraid/comminit.c                    |   2 +
 drivers/scsi/sd.c                                  |  12 +-
 drivers/soc/qcom/cmd-db.c                          |   2 +-
 drivers/soc/qcom/pmic_glink.c                      |  40 ++++--
 drivers/soc/qcom/pmic_glink_altmode.c              |  17 ++-
 drivers/soundwire/stream.c                         |   8 +-
 drivers/usb/cdns3/cdnsp-gadget.h                   |   3 +
 drivers/usb/cdns3/cdnsp-ring.c                     |  30 +++-
 drivers/usb/class/cdc-acm.c                        |   3 +
 drivers/usb/core/sysfs.c                           |   1 +
 drivers/usb/dwc3/core.c                            |   8 ++
 drivers/usb/dwc3/dwc3-omap.c                       |   4 +-
 drivers/usb/dwc3/dwc3-st.c                         |  16 +--
 drivers/usb/dwc3/dwc3-xilinx.c                     |   7 +-
 drivers/usb/dwc3/ep0.c                             |   3 +-
 drivers/usb/gadget/function/uvc_video.c            |   1 +
 drivers/usb/serial/option.c                        |   5 +
 drivers/usb/typec/mux/fsa4480.c                    |   2 +-
 drivers/usb/typec/ucsi/ucsi_glink.c                |  43 ++++--
 drivers/video/aperture.c                           |  11 +-
 fs/afs/inode.c                                     |  11 +-
 fs/attr.c                                          |  14 +-
 fs/backing-file.c                                  |   5 +-
 fs/binfmt_elf_fdpic.c                              |   3 +
 fs/btrfs/bio.c                                     |  26 ++--
 fs/btrfs/qgroup.c                                  |   2 +
 fs/ceph/inode.c                                    |   1 +
 fs/erofs/zutil.c                                   |   3 +-
 fs/netfs/io.c                                      |   1 +
 fs/netfs/misc.c                                    |  60 ++++++--
 fs/netfs/write_collect.c                           |   7 +
 fs/nfsd/nfs4state.c                                |  62 +++++---
 fs/nfsd/nfs4xdr.c                                  |   6 +-
 fs/nfsd/state.h                                    |   2 +-
 fs/smb/client/cifsglob.h                           |   1 -
 fs/smb/client/cifssmb.c                            |   1 -
 fs/smb/client/smb2ops.c                            |  24 +++-
 fs/smb/client/smb2pdu.c                            |   4 +-
 include/linux/fs.h                                 |   1 +
 include/linux/soc/qcom/pmic_glink.h                |  11 +-
 include/linux/sysfb.h                              |   4 +-
 include/net/bonding.h                              |   2 +-
 include/net/busy_poll.h                            |   2 +-
 include/net/netfilter/nf_tables_ipv4.h             |  10 +-
 include/net/netfilter/nf_tables_ipv6.h             |   5 +-
 io_uring/kbuf.c                                    |   2 +-
 mm/truncate.c                                      |   4 +-
 net/bluetooth/hci_core.c                           |  10 +-
 net/core/net-sysfs.c                               |   2 +-
 net/core/pktgen.c                                  |   4 +-
 net/ethtool/ioctl.c                                |   3 +
 net/ipv4/tcp.c                                     |  18 ++-
 net/mptcp/fastopen.c                               |   4 +-
 net/mptcp/options.c                                |  50 +++----
 net/mptcp/pm.c                                     |  32 +++--
 net/mptcp/pm_netlink.c                             | 107 +++++++++-----
 net/mptcp/protocol.c                               |  65 +++++----
 net/mptcp/protocol.h                               |   9 +-
 net/mptcp/sched.c                                  |   4 +-
 net/mptcp/sockopt.c                                |   4 +-
 net/mptcp/subflow.c                                |  56 ++++----
 net/sched/sch_fq.c                                 |   4 +-
 net/sctp/sm_statefuns.c                            |  22 ++-
 security/apparmor/policy_unpack_test.c             |   6 +-
 security/selinux/hooks.c                           |   4 +-
 security/smack/smack_lsm.c                         |   4 +-
 sound/core/seq/seq_clientmgr.c                     |   3 +
 sound/pci/hda/cs35l56_hda.c                        |   2 +-
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/amd/acp/acp-legacy-mach.c                |   2 +
 sound/soc/codecs/cs-amp-lib-test.c                 |   9 ++
 sound/soc/codecs/cs-amp-lib.c                      |   7 +-
 sound/soc/sof/amd/acp-dsp-offset.h                 |   6 +-
 sound/soc/sof/amd/acp.c                            |  52 ++++---
 sound/soc/sof/amd/acp.h                            |   9 +-
 sound/soc/sof/amd/pci-acp63.c                      |   2 +
 sound/soc/sof/amd/pci-rmb.c                        |   2 +
 sound/soc/sof/amd/pci-rn.c                         |   2 +
 tools/testing/selftests/iommu/iommufd.c            |   6 +-
 .../selftests/net/forwarding/local_termination.sh  |   4 +
 .../selftests/net/forwarding/no_forwarding.sh      |   3 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  57 +++++---
 156 files changed, 1613 insertions(+), 711 deletions(-)


