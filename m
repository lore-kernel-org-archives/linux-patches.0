Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A2925B660;
	Tue, 25 Feb 2025 06:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740466230; cv=none; b=jH575Isg2TszLR9Hne8qGaOOUcw7fh44Ivp0wKjhNGNdquGQPNIkxzplCEqiGaBaSvtut8JLsQt2sTqhta8pbNP0fEfFtHFCGw/rW+Et3maq5JZB+7jUA3L2O8diKMXBONliK3BIFhIKH5o1GXMLz66sNtxdzK1aY5IEawl8ZhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740466230; c=relaxed/simple;
	bh=TqgKcziyX+Yb6+MW3kyZPWtlNfAB6Zie0WispqMfTME=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Sitya/QfpY5wpHu8sugTQtdOY5dI9aEopOi1MwgkJ9pgsvNszFkP7VF+PjRpFnfeNatbKCyB3ApVi5pb31UYUPq3ckFgm025g2qwrLZezLvJgQujwl90zhx2uVOEbekW0gGPfKqKUEnVMDsbg4ZiJIwrxgUU2ISuMk/uGVxOfcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6WUWXUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6WUWXUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D95C4CEDD;
	Tue, 25 Feb 2025 06:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740466229;
	bh=TqgKcziyX+Yb6+MW3kyZPWtlNfAB6Zie0WispqMfTME=;
	h=From:To:Cc:Subject:Date:From;
	b=X6WUWXUVIaUby+SY8mvSQ7mo5RC1aa4jjb0WNXINF92p8m0vMZbJHd/wZKI0DAqyh
	 f4v7jR4CuDTSFrcM9ahvbuQSImDwrmrn9ln6UJIW47l/6aeRnQBaN1yENashcbSno7
	 mlkW+KTxrrO4s4GpGwS6K6mvVDa4rts3WwSOgqbQ=
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
Subject: [PATCH 6.12 000/153] 6.12.17-rc2 review
Date: Tue, 25 Feb 2025 07:49:14 +0100
Message-ID: <20250225064751.133174920@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.17-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.17-rc2
X-KernelTest-Deadline: 2025-02-27T06:47+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.17 release.
There are 153 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 27 Feb 2025 06:47:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.17-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.17-rc2

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: bump version for RV/PCO compute fix

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9: manually control gfxoff for CS on RV

Tianling Shen <cnsztl@gmail.com>
    arm64: dts: rockchip: change eth phy mode to rgmii-id for orangepi r1 plus lts

Kevin Brodsky <kevin.brodsky@arm.com>
    selftests/mm: build with -O2

Tejun Heo <tj@kernel.org>
    sched_ext: Fix incorrect assumption about migration disabled tasks in task_can_run_on_remote_rq()

Kory Maincent <kory.maincent@bootlin.com>
    net: pse-pd: Fix deadlock in current limit functions

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix using ret variable in tracing_set_tracer()

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Do not add duplicate entries in subops manager ops

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Fix accounting of adding subops to a manager ops

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    ftrace: Correct preemption accounting for function tracing.

Komal Bajaj <quic_kbajaj@quicinc.com>
    EDAC/qcom: Correct interrupt enable register configuration

Haoxiang Li <haoxiang_li2024@163.com>
    smb: client: Add check for next_buffer in receive_encrypted_standard()

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3: Fix rk3399 workaround when secure interrupts are enabled

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix event constraints for LNC

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    mtd: rawnand: cadence: fix incorrect device in dma_unmap_single

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    mtd: rawnand: cadence: use dma_map_resource for sdma address

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    mtd: rawnand: cadence: fix error code in cadence_nand_init()

Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
    mtd: spi-nor: sst: Fix SST write failure

Ricardo Cañuelo Navarro <rcn@igalia.com>
    mm,madvise,hugetlb: check for 0-length range after end address adjustment

Christian Brauner <brauner@kernel.org>
    acct: block access to kernel internal filesystems

Christian Brauner <brauner@kernel.org>
    acct: perform last write from workqueue

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: pcm: Clear the susbstream pointer to NULL on close

John Veness <john-linux@pelago.org.uk>
    ALSA: hda/conexant: Add quirk for HP ProBook 450 G4 mute LED

Wentao Liang <vulab@iscas.ac.cn>
    ALSA: hda: Add error check for snd_ctl_rename_id() in snd_hda_create_dig_out_ctls()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    ASoC: fsl_micfil: Enable default case in micfil_set_quality()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: stream-ipc: Check for cstream nullity in sof_ipc_msg_data()

Joshua Washington <joshwash@google.com>
    gve: set xdp redirect target only when it is available

Haoxiang Li <haoxiang_li2024@163.com>
    nfp: bpf: Add check for nfp_app_ctrl_msg_alloc()

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix chmod(2) regression with ATTR_READONLY

Pavel Begunkov <asml.silence@gmail.com>
    lib/iov_iter: fix import_iovec_ubuf iovec management

Darrick J. Wong <djwong@kernel.org>
    xfs: fix online repair probing when CONFIG_XFS_ONLINE_REPAIR=n

Heiko Carstens <hca@linux.ibm.com>
    s390/boot: Fix ESSA detection

Haoxiang Li <haoxiang_li2024@163.com>
    soc: loongson: loongson2_guts: Add check for devm_kstrdup()

Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
    arm64: dts: rockchip: Disable DMA for uart5 on px30-ringneck

Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
    arm64: dts: rockchip: Move uart5 pin configuration to px30 ringneck SoM

Alexander Shiyan <eagle.alexander923@gmail.com>
    arm64: dts: rockchip: Fix broken tsadc pinctrl names for rk3588

David Hildenbrand <david@redhat.com>
    mm/migrate_device: don't add folio to be freed to LRU in migrate_device_finalize()

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    drop_monitor: fix incorrect initialization order

Sumit Garg <sumit.garg@linaro.org>
    tee: optee: Fix supplicant wait loop

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: protect gpio_chip with SRCU in array_info paths in multi get/set

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: prevent opcode speculation

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/rw: forbid multishot async reads

Krzysztof Karas <krzysztof.karas@intel.com>
    drm/i915/gt: Use spin_lock_irqsave() in interruptible context

Imre Deak <imre.deak@intel.com>
    drm/i915/ddi: Fix HDMI port width programming in DDI_BUF_CTL

Imre Deak <imre.deak@intel.com>
    drm/i915/dp: Fix error handling during 128b/132b link training

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Make sure all planes in use by the joiner have their crtc included

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm/msm/dpu: Disable dither in phys encoder cleanup

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    drm: panel: jd9365da-h3: fix reset signal polarity

Artur Rojek <contact@artur-rojek.eu>
    irqchip/jcore-aic, clocksource/drivers/jcore: Fix jcore-pit interrupt request

Aaron Kling <webgeek1234@gmail.com>
    drm/nouveau/pmu: Fix gp10b firmware guard

Yan Zhai <yan@cloudflare.com>
    bpf: skip non exist keys in generic_map_lookup_batch

Caleb Sander Mateos <csander@purestorage.com>
    nvme/ioctl: add missing space in err message

Caleb Sander Mateos <csander@purestorage.com>
    nvme-tcp: fix connect failure on receiving partial ICResp PDU

Damien Le Moal <dlemoal@kernel.org>
    nvme: tcp: Fix compilation warning with W=1

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/msm/dsi/phy: Do not overwite PHY_CMN_CLK_CFG1 when choosing bitclk source

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/msm/dsi/phy: Protect PHY_CMN_CLK_CFG1 against clock driver

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/msm/dsi/phy: Protect PHY_CMN_CLK_CFG0 updated from driver side

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dpu: Don't leak bits_per_component into random DSC_ENC fields

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: enable DPU_WB_INPUT_CTRL for DPU 5.x

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: skip watchdog timer programming through TOP on >= SM8450

Rob Clark <robdclark@chromium.org>
    drm/msm: Avoid rounding up to one jiffy

David Hildenbrand <david@redhat.com>
    nouveau/svm: fix missing folio unlock + put after make_device_exclusive_range()

Geert Uytterhoeven <geert+renesas@glider.be>
    platform: cznic: CZNIC_PLATFORMS should depend on ARCH_MVEBU

Geert Uytterhoeven <geert+renesas@glider.be>
    firmware: imx: IMX_SCMI_MISC_DRV should depend on ARCH_MXC

Bart Van Assche <bvanassche@acm.org>
    md/raid*: Fix the set_queue_limits implementations

Peng Fan <peng.fan@nxp.com>
    firmware: arm_scmi: imx: Correct tx size of scmi_imx_misc_ctrl_set

Patrick Wildt <patrick@blueri.se>
    arm64: dts: rockchip: adjust SMMU interrupt type on rk3588

Alan Maguire <alan.maguire@oracle.com>
    bpf: Fix softlockup in arena_map_free on 64k page kernel

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Add rx_skb of kfree_skb to raw_tp_null_args[].

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    selftests/bpf: Add tests for raw_tp null handling

Chris Morgan <macromorgan@hotmail.com>
    power: supply: axp20x_battery: Fix fault handling for AXP717

Andrey Vatoropin <a.vatoropin@crpt.ru>
    power: supply: da9150-fg: fix potential overflow

Andy Yan <andyshrk@163.com>
    arm64: dts: rockchip: Fix lcdpwr_en pin for Cool Pi GenBook

Abel Wu <wuyun.abel@bytedance.com>
    bpf: Fix deadlock when freeing cgroup storage

Jiayuan Chen <mrpre@163.com>
    bpf: Disable non stream socket for strparser

Jiayuan Chen <mrpre@163.com>
    bpf: Fix wrong copied_seq calculation

Jiayuan Chen <mrpre@163.com>
    strparser: Add read_sock callback

Andrii Nakryiko <andrii@kernel.org>
    bpf: avoid holding freeze_mutex during mmap operation

Andrii Nakryiko <andrii@kernel.org>
    bpf: unify VM_WRITE vs VM_MAYWRITE use in BPF map mmaping logic

Shigeru Yoshida <syoshida@redhat.com>
    bpf, test_run: Fix use-after-free issue in eth_skb_pkt_type()

Paolo Abeni <pabeni@redhat.com>
    net: allow small head cache usage with large MAX_SKB_FRAGS values

Sabrina Dubroca <sd@queasysnail.net>
    tcp: drop secpath at the same time as we currently drop dst

Nick Hu <nick.hu@sifive.com>
    net: axienet: Set mac_managed_pm

Breno Leitao <leitao@debian.org>
    arp: switch to dev_getbyhwaddr() in arp_req_set_public()

Breno Leitao <leitao@debian.org>
    net: Add non-RCU dev_getbyhwaddr() helper

Cong Wang <xiyou.wangcong@gmail.com>
    flow_dissector: Fix port range key handling in BPF conversion

Cong Wang <xiyou.wangcong@gmail.com>
    flow_dissector: Fix handling of mixed port and port-range keys

Kuniyuki Iwashima <kuniyu@amazon.com>
    geneve: Suppress list corruption splat in geneve_destroy_tunnels().

Kuniyuki Iwashima <kuniyu@amazon.com>
    gtp: Suppress list corruption splat in gtp_net_exit_batch_rtnl().

Kory Maincent <kory.maincent@bootlin.com>
    net: pse-pd: pd692x0: Fix power limit retrieval

Kory Maincent <kory.maincent@bootlin.com>
    net: pse-pd: Use power limit at driver side instead of current limit

Kory Maincent <kory.maincent@bootlin.com>
    net: pse-pd: Avoid setting max_uA in regulator constraints

Jakub Kicinski <kuba@kernel.org>
    tcp: adjust rcvq_space after updating scaling ratio

Michal Luczaj <mhal@rbox.co>
    vsock/bpf: Warn on socket without transport

Michal Luczaj <mhal@rbox.co>
    sockmap, vsock: For connectible sockets allow only connected

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Don't reference skb after sending to VIOS

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Add stat for tx direct vs tx batched

Julian Ruess <julianr@linux.ibm.com>
    s390/ism: add release function for struct device

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Drop UMP events when no UMP-conversion is set

Pierre Riteau <pierre@stackhpc.com>
    net/sched: cls_api: fix error handling causing NULL dereference

Vitaly Rodionov <vitalyr@opensource.cirrus.com>
    ALSA: hda/cirrus: Correct the full scale volume set logic

Kuniyuki Iwashima <kuniyu@amazon.com>
    geneve: Fix use-after-free in geneve_find_dev().

Junnan Wu <junnan01.wu@samsung.com>
    vsock/virtio: fix variables initialization during resuming

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: imx-audmix: remove cpu_mclk which is from cpu dai device

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/code-patching: Fix KASAN hit by not flagging text patching area as VM_ALLOC

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Fixup ALC225 depop procedure

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/64s: Rewrite __real_pte() and __rpte_to_hidx() as static inline

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/code-patching: Disable KASAN report during patching via temporary mm

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Harden loops for looking up ALH copiers

John Keeping <jkeeping@inmusicbrands.com>
    ASoC: rockchip: i2s-tdm: fix shift config for SND_SOC_DAIFMT_DSP_[AB]

Tejun Heo <tj@kernel.org>
    sched_ext: Fix migration disabled handling in targeted dispatches

Tejun Heo <tj@kernel.org>
    sched_ext: Factor out move_task_between_dsqs() from scx_dispatch_from_dsq()

Jill Donahue <jilliandonahue58@gmail.com>
    USB: gadget: f_midi: f_midi_complete to call queue_work

Steven Rostedt <rostedt@goodmis.org>
    tracing: Have the error of __tracing_resize_ring_buffer() passed to user

Steven Rostedt <rostedt@goodmis.org>
    tracing: Switch trace.c code over to use guard()

Lancelot SIX <lancelot.six@amd.com>
    drm/amdkfd: Ensure consistent barrier state saved in gfx12 trap handler

Jay Cornwall <jay.cornwall@amd.com>
    drm/amdkfd: Move gfx12 trap handler to separate file

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Fix error handling in recovery/reset

Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>
    accel/ivpu: Add FW state dump on TDR

Karol Wachowski <karol.wachowski@intel.com>
    accel/ivpu: Add coredump support

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Limit FW version string length

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183: Disable DSI display output by default

Fabien Parent <fparent@baylibre.com>
    arm64: dts: mediatek: mt8183-pumpkin: add HDMI support

Takashi Iwai <tiwai@suse.de>
    PCI: Restore original INTX_DISABLE bit by pcim_intx()

Philipp Stanner <pstanner@redhat.com>
    PCI: Remove devres from pci_intx()

Philipp Stanner <pstanner@redhat.com>
    PCI: Export pci_intx_unmanaged() and pcim_intx()

Philipp Stanner <pstanner@redhat.com>
    PCI: Make pcim_request_all_regions() a public function

Dan Carpenter <dan.carpenter@linaro.org>
    ASoC: renesas: rz-ssi: Add a check for negative sample_space

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    ASoC: renesas: rz-ssi: Terminate all the DMA transactions

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics - fix crash when enabling pass-through port

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: serio - define serio_pause_rx guard to pause and resume serio ports

Zijun Hu <quic_zijuhu@quicinc.com>
    Bluetooth: qca: Fix poor RF performance for WCN6855

Cheng Jiang <quic_chejiang@quicinc.com>
    Bluetooth: qca: Update firmware-name to support board specific nvm

loanchen <lo-an.chen@amd.com>
    drm/amd/display: Correct register address in dcn35

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: update dcn351 used clock offset

Lohita Mudimela <lohita.mudimela@amd.com>
    drm/amd/display: Refactoring if and endif statements to enable DC_LOGGER

Chao Gao <chao.gao@intel.com>
    KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2 is active w/o VID

Sean Christopherson <seanjc@google.com>
    KVM: x86: Inline kvm_get_apic_mode() in lapic.h

Sean Christopherson <seanjc@google.com>
    KVM: x86: Get vcpu->arch.apic_base directly and drop kvm_get_apic_base()

Qu Wenruo <wqu@suse.com>
    btrfs: fix double accounting race when extent_writepage_io() failed

Qu Wenruo <wqu@suse.com>
    btrfs: fix double accounting race when btrfs_run_delalloc_range() failed

David Sterba <dsterba@suse.com>
    btrfs: use btrfs_inode in extent_writepage()

Qu Wenruo <wqu@suse.com>
    btrfs: rename btrfs_folio_(set|start|end)_writer_lock()

Qu Wenruo <wqu@suse.com>
    btrfs: unify to use writer locks for subpage locking

Qu Wenruo <wqu@suse.com>
    btrfs: remove unused btrfs_folio_start_writer_lock()

Qu Wenruo <wqu@suse.com>
    btrfs: mark all dirty sectors as locked inside writepage_delalloc()

Qu Wenruo <wqu@suse.com>
    btrfs: move the delalloc range bitmap search into extent_io.c

Qu Wenruo <wqu@suse.com>
    btrfs: do not assume the full page range is not dirty in extent_writepage_io()

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    xe/oa: Fix query mode of operation for OAR/OAC

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: Add input fence dependencies

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa/uapi: Define and parse OA sync properties

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: Separate batch submission from waiting for completion

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Do not allow PROT_MTE on MAP_HUGETLB user mappings


-------------

Diffstat:

 Documentation/networking/strparser.rst             |    9 +-
 Makefile                                           |    4 +-
 arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts    |  123 ++-
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |    1 +
 .../boot/dts/rockchip/px30-ringneck-haikou.dts     |    1 -
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi    |    6 +
 .../dts/rockchip/rk3328-orangepi-r1-plus-lts.dts   |    6 +-
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi      |   22 +-
 .../dts/rockchip/rk3588-coolpi-cm5-genbook.dts     |    4 +-
 arch/arm64/include/asm/mman.h                      |    9 +-
 arch/powerpc/include/asm/book3s/64/hash-4k.h       |   12 +-
 arch/powerpc/lib/code-patching.c                   |    4 +-
 arch/s390/boot/startup.c                           |    2 +-
 arch/x86/events/intel/core.c                       |   20 +-
 arch/x86/events/intel/ds.c                         |    2 +-
 arch/x86/kvm/lapic.c                               |   11 +
 arch/x86/kvm/lapic.h                               |    8 +-
 arch/x86/kvm/vmx/nested.c                          |    5 +
 arch/x86/kvm/vmx/vmx.c                             |   21 +
 arch/x86/kvm/vmx/vmx.h                             |    1 +
 arch/x86/kvm/x86.c                                 |   17 +-
 drivers/accel/ivpu/Kconfig                         |    1 +
 drivers/accel/ivpu/Makefile                        |    1 +
 drivers/accel/ivpu/ivpu_coredump.c                 |   39 +
 drivers/accel/ivpu/ivpu_coredump.h                 |   25 +
 drivers/accel/ivpu/ivpu_drv.c                      |    5 +-
 drivers/accel/ivpu/ivpu_drv.h                      |    1 +
 drivers/accel/ivpu/ivpu_fw.c                       |    7 +-
 drivers/accel/ivpu/ivpu_fw.h                       |    6 +-
 drivers/accel/ivpu/ivpu_fw_log.h                   |    8 -
 drivers/accel/ivpu/ivpu_hw.c                       |    3 +
 drivers/accel/ivpu/ivpu_ipc.c                      |   26 +
 drivers/accel/ivpu/ivpu_ipc.h                      |    2 +
 drivers/accel/ivpu/ivpu_jsm_msg.c                  |    8 +
 drivers/accel/ivpu/ivpu_jsm_msg.h                  |    2 +
 drivers/accel/ivpu/ivpu_pm.c                       |   85 +-
 drivers/bluetooth/btqca.c                          |  118 +-
 drivers/clocksource/jcore-pit.c                    |   15 +-
 drivers/edac/qcom_edac.c                           |    4 +-
 .../firmware/arm_scmi/vendors/imx/imx-sm-misc.c    |    4 +-
 drivers/firmware/imx/Kconfig                       |    1 +
 drivers/gpio/gpiolib.c                             |   48 +-
 drivers/gpio/gpiolib.h                             |    4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |    3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   32 +-
 drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h     |    3 +-
 .../gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx10.asm |  202 +---
 .../gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx12.asm | 1130 ++++++++++++++++++++
 drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile    |    2 +-
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c   |    5 +-
 .../amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c   |    5 +-
 .../amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c |    6 +-
 .../amd/display/dc/clk_mgr/dcn35/dcn351_clk_mgr.c  |  140 +++
 .../amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c   |  131 ++-
 .../amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.h   |    4 +
 .../drm/amd/display/dc/inc/hw/clk_mgr_internal.h   |   59 +
 .../display/dc/link/protocols/link_dp_capability.c |    3 +-
 drivers/gpu/drm/i915/display/intel_ddi.c           |    2 +-
 drivers/gpu/drm/i915/display/intel_display.c       |   18 +
 .../gpu/drm/i915/display/intel_dp_link_training.c  |   15 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |    4 +-
 drivers/gpu/drm/i915/i915_reg.h                    |    2 +-
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h |    2 +-
 .../drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h    |    2 +-
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_5_4_sm6125.h |    2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |    3 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c         |    3 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_top.c         |    2 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c          |   53 +-
 drivers/gpu/drm/msm/msm_drv.h                      |   11 +-
 .../gpu/drm/msm/registers/display/dsi_phy_7nm.xml  |   11 +-
 drivers/gpu/drm/nouveau/nouveau_svm.c              |    9 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c    |    2 +-
 drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c   |    8 +-
 drivers/gpu/drm/xe/xe_oa.c                         |  265 +++--
 drivers/gpu/drm/xe/xe_oa_types.h                   |    6 +
 drivers/gpu/drm/xe/xe_query.c                      |    2 +-
 drivers/gpu/drm/xe/xe_ring_ops.c                   |    5 +-
 drivers/gpu/drm/xe/xe_sched_job_types.h            |    2 +
 drivers/input/mouse/synaptics.c                    |   56 +-
 drivers/input/mouse/synaptics.h                    |    1 +
 drivers/irqchip/irq-gic-v3.c                       |   49 +-
 drivers/irqchip/irq-jcore-aic.c                    |    2 +-
 drivers/md/raid0.c                                 |    4 +-
 drivers/md/raid1.c                                 |    4 +-
 drivers/md/raid10.c                                |    4 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |   42 +-
 drivers/mtd/spi-nor/sst.c                          |    2 +-
 drivers/net/ethernet/google/gve/gve.h              |   10 +
 drivers/net/ethernet/google/gve/gve_main.c         |    6 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   27 +-
 drivers/net/ethernet/ibm/ibmvnic.h                 |    3 +-
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c      |    2 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |    1 +
 drivers/net/geneve.c                               |   16 +-
 drivers/net/gtp.c                                  |    5 -
 drivers/net/pse-pd/pd692x0.c                       |   45 +-
 drivers/net/pse-pd/pse_core.c                      |   98 +-
 drivers/nvme/host/ioctl.c                          |    3 +-
 drivers/nvme/host/tcp.c                            |    7 +-
 drivers/pci/devres.c                               |   61 +-
 drivers/pci/pci.c                                  |   16 +-
 drivers/platform/cznic/Kconfig                     |    1 +
 drivers/power/supply/axp20x_battery.c              |   31 +-
 drivers/power/supply/da9150-fg.c                   |    4 +-
 drivers/s390/net/ism_drv.c                         |   14 +-
 drivers/soc/loongson/loongson2_guts.c              |    5 +-
 drivers/tee/optee/supp.c                           |   35 +-
 drivers/usb/gadget/function/f_midi.c               |    2 +-
 fs/btrfs/compression.c                             |    3 +-
 fs/btrfs/extent_io.c                               |  174 ++-
 fs/btrfs/inode.c                                   |    3 +-
 fs/btrfs/subpage.c                                 |  202 +---
 fs/btrfs/subpage.h                                 |   39 +-
 fs/smb/client/inode.c                              |    4 +-
 fs/smb/client/smb2ops.c                            |    4 +
 fs/xfs/scrub/common.h                              |    5 -
 fs/xfs/scrub/repair.h                              |   11 +-
 fs/xfs/scrub/scrub.c                               |   12 +
 include/linux/netdevice.h                          |    2 +
 include/linux/pci.h                                |    2 +
 include/linux/pse-pd/pse.h                         |   16 +-
 include/linux/serio.h                              |    3 +
 include/linux/skmsg.h                              |    2 +
 include/net/gro.h                                  |    3 +
 include/net/strparser.h                            |    2 +
 include/net/tcp.h                                  |   22 +
 include/uapi/drm/xe_drm.h                          |   17 +
 io_uring/io_uring.c                                |    2 +
 io_uring/rw.c                                      |   13 +-
 kernel/acct.c                                      |  134 ++-
 kernel/bpf/arena.c                                 |    2 +-
 kernel/bpf/bpf_cgrp_storage.c                      |    2 +-
 kernel/bpf/btf.c                                   |    2 +
 kernel/bpf/ringbuf.c                               |    4 -
 kernel/bpf/syscall.c                               |   43 +-
 kernel/sched/ext.c                                 |  150 ++-
 kernel/trace/ftrace.c                              |   36 +-
 kernel/trace/trace.c                               |  277 ++---
 kernel/trace/trace_functions.c                     |    6 +-
 lib/iov_iter.c                                     |    3 +-
 mm/madvise.c                                       |   11 +-
 mm/migrate_device.c                                |   13 +-
 net/bpf/test_run.c                                 |    5 +-
 net/core/dev.c                                     |   37 +-
 net/core/drop_monitor.c                            |   39 +-
 net/core/flow_dissector.c                          |   49 +-
 net/core/gro.c                                     |    3 -
 net/core/skbuff.c                                  |   10 +-
 net/core/skmsg.c                                   |    7 +
 net/core/sock_map.c                                |    8 +-
 net/ipv4/arp.c                                     |    2 +-
 net/ipv4/tcp.c                                     |   29 +-
 net/ipv4/tcp_bpf.c                                 |   36 +
 net/ipv4/tcp_fastopen.c                            |    4 +-
 net/ipv4/tcp_input.c                               |   20 +-
 net/ipv4/tcp_ipv4.c                                |    2 +-
 net/sched/cls_api.c                                |    2 +-
 net/strparser/strparser.c                          |   11 +-
 net/vmw_vsock/af_vsock.c                           |    3 +
 net/vmw_vsock/virtio_transport.c                   |   10 +-
 net/vmw_vsock/vsock_bpf.c                          |    2 +-
 sound/core/seq/seq_clientmgr.c                     |   12 +-
 sound/pci/hda/hda_codec.c                          |    4 +-
 sound/pci/hda/patch_conexant.c                     |    1 +
 sound/pci/hda/patch_cs8409-tables.c                |    6 +-
 sound/pci/hda/patch_cs8409.c                       |   20 +-
 sound/pci/hda/patch_cs8409.h                       |    5 +-
 sound/pci/hda/patch_realtek.c                      |    1 +
 sound/soc/fsl/fsl_micfil.c                         |    2 +
 sound/soc/fsl/imx-audmix.c                         |   31 -
 sound/soc/rockchip/rockchip_i2s_tdm.c              |    4 +-
 sound/soc/sh/rz-ssi.c                              |   10 +-
 sound/soc/sof/ipc4-topology.c                      |   12 +-
 sound/soc/sof/pcm.c                                |    2 +
 sound/soc/sof/stream-ipc.c                         |    6 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod-events.h |    8 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |    2 +
 .../testing/selftests/bpf/prog_tests/raw_tp_null.c |   25 +
 tools/testing/selftests/bpf/progs/raw_tp_null.c    |   32 +
 tools/testing/selftests/mm/Makefile                |    9 +-
 181 files changed, 3561 insertions(+), 1545 deletions(-)


