Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B089F17B505;
	Wed,  5 Mar 2025 18:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197954; cv=none; b=OavV6UHL9CzR/n2Uwb7g1y+tGoSHhhAmPECYBADCvBy4+iM+YpkQwqSpwP1Xr7AA/0Wm0xRnV3L2lEhAd43cWg5hMrJyXIquUoG69zASPWapZxhh7wSHtis0T3Oz2qqXbVoX4U63bckXB+v23TQq6Blw192s/qHQot3KL0Z+IQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197954; c=relaxed/simple;
	bh=TZlA1+5v2AXN1ACtdZgxY47BmEUk/hzYTzgDFqfPFME=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hkiQf8Ql+KhXrrwpJ2EePxw58Q+lZmiFnQN2FbFvn5Wxkuvz9nfdTJQSV0Y6MdpdhkoxWCMN3Gdl/RlxCuGmNJKJcdttN9AMWAwA+jjQFmAMc7kA4L2xbdMoJOgDLFetCQrvxQAL3OhmMjskgNZM5cQ4fldpQw5uuIG+WirEZ7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eBZ8Vyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eBZ8Vyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06F1C4CED1;
	Wed,  5 Mar 2025 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197954;
	bh=TZlA1+5v2AXN1ACtdZgxY47BmEUk/hzYTzgDFqfPFME=;
	h=From:To:Cc:Subject:Date:From;
	b=1eBZ8VythM2xNo39m0xaNvaaEigphv9Z/NygTLe4c/ApzS7hFOGsS5XzlrLz4U1qK
	 oR7ioeoJYj2+nbH0Op4cIYNnwHp8DyQVCyjvdvSbNO5Q7Exw86gIExrl7Gwvw/ckUA
	 l2EyM7M6LSXDmBP9QjuxqPyCChHdIbFAEErlt/E4=
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
Subject: [PATCH 6.12 000/150] 6.12.18-rc1 review
Date: Wed,  5 Mar 2025 18:47:09 +0100
Message-ID: <20250305174503.801402104@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.18-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.18-rc1
X-KernelTest-Deadline: 2025-03-07T17:45+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.18 release.
There are 150 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 07 Mar 2025 17:44:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.18-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.18-rc1

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Load only SHA256-checksummed patches

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Add get_patch_level()

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Get rid of the _load_microcode_amd() forward declaration

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Merge early_apply_microcode() into its single callsite

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Remove unused save_microcode_in_initrd_amd() declarations

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Remove ugly linebreak in __verify_patch_section() signature

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Have __apply_microcode_amd() return bool

Nikolay Borisov <nik.borisov@suse.com>
    x86/microcode/AMD: Return bool from find_blobs_in_containers()

chr[] <chris@rudorff.com>
    amdgpu/pm/legacy: fix suspend/resume issues

Peter Jones <pjones@redhat.com>
    efi: Don't map the entire mokvar table to determine its size

Clément Léger <cleger@rivosinc.com>
    riscv: cpufeature: use bitmap_equal() instead of memcmp()

Yong-Xuan Wang <yongxuan.wang@sifive.com>
    riscv: signal: fix signal_minsigstksz

Rob Herring <robh@kernel.org>
    riscv: cacheinfo: Use of_property_present() for non-boolean properties

Yong-Xuan Wang <yongxuan.wang@sifive.com>
    riscv: signal: fix signal frame size

Andreas Schwab <schwab@suse.de>
    riscv/futex: sign extend compare value in atomic cmpxchg

Stafford Horne <shorne@gmail.com>
    rseq/selftests: Fix riscv rseq_offset_deref_addv inline asm

Arthur Simchaev <arthur.simchaev@sandisk.com>
    scsi: ufs: core: bsg: Fix crash when arpmb command fails

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Reset IMA_NONACTION_RULE_FLAGS after post_setattr

Ken Raeburn <raeburn@redhat.com>
    dm vdo: add missing spin_lock_init

Milan Broz <gmazyland@gmail.com>
    dm-integrity: Avoid divide by zero in table status in Inline mode

Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
    selftests/landlock: Test TCP accesses with protocol=IPPROTO_TCP

Tejun Heo <tj@kernel.org>
    sched_ext: Fix pick_task_scx() picking non-queued tasks when it's called without balance()

Thomas Gleixner <tglx@linutronix.de>
    sched/core: Prevent rescheduling when interrupts are disabled

Thomas Gleixner <tglx@linutronix.de>
    rcuref: Plug slowpath race in rcuref_put()

Ard Biesheuvel <ardb@kernel.org>
    vmlinux.lds: Ensure that const vars with relocations are mapped R/O

Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
    selftests/landlock: Test that MPTCP actions are not restricted

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: reset when MPTCP opts are dropped after join

Paolo Abeni <pabeni@redhat.com>
    mptcp: always handle address removal under msk socket lock

Thomas Gleixner <tglx@linutronix.de>
    intel_idle: Handle older CPUs, which stop the TSC in deeper C states, correctly

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix suspicious RCU usage

Jerry Snitselaar <jsnitsel@redhat.com>
    iommu/vt-d: Remove device comparison in context_setup_pass_through_cb

André Draszik <andre.draszik@linaro.org>
    phy: exynos5-usbdrd: gs101: ensure power is gated to SS phy in phy_exit()

Kaustabh Chakraborty <kauschluss@disroot.org>
    phy: exynos5-usbdrd: fix MPLL_MULTIPLIER and SSC_REFCLKSEL masks in refclk

BH Hsieh <bhsieh@nvidia.com>
    phy: tegra: xusb: reset VBUS & ID OVERRIDE

Wei Fang <wei.fang@nxp.com>
    net: enetc: fix the off-by-one issue in enetc_map_tx_tso_buffs()

Wei Fang <wei.fang@nxp.com>
    net: enetc: correct the xdp_tx statistics

Wei Fang <wei.fang@nxp.com>
    net: enetc: update UDP checksum when updating originTimestamp field

Wei Fang <wei.fang@nxp.com>
    net: enetc: VFs do not support HWTSTAMP_TX_ONESTEP_SYNC

Wei Fang <wei.fang@nxp.com>
    net: enetc: keep track of correct Tx BD count in enetc_map_tx_tso_buffs()

Wei Fang <wei.fang@nxp.com>
    net: enetc: fix the off-by-one issue in enetc_map_tx_buffs()

George Moussalem <george.moussalem@outlook.com>
    net: phy: qcom: qca807x fix condition for DAC_DSP_BIAS_CURRENT

Qunqin Zhao <zhaoqunqin@loongson.cn>
    net: stmmac: dwmac-loongson: Add fix_soc_reset() callback

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    usbnet: gl620a: fix endpoint checking in genelink_bind()

Binbin Zhou <zhoubinbin@loongson.cn>
    i2c: ls2x: Fix frequency division register access

Tyrone Ting <kfting@nuvoton.com>
    i2c: npcm: disable interrupt enable bit before devm_request_irq

Damien Le Moal <dlemoal@kernel.org>
    block: Remove zone write plugs when handling native zone append writes

Ryan Roberts <ryan.roberts@arm.com>
    arm64: hugetlb: Fix flush_hugetlb_tlb_range() invalidation level

Ryan Roberts <ryan.roberts@arm.com>
    arm64: hugetlb: Fix huge_ptep_get_and_clear() for non-present ptes

Ryan Roberts <ryan.roberts@arm.com>
    arm64/mm: Fix Boot panic on Ampere Altra

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Fix HPD after gpu reset

Yilin Chen <Yilin.Chen@amd.com>
    drm/amd/display: add a quirk to enable eDP0 on DP1

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Disable PSR-SU on eDP panels

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu: init return value in amdgpu_ttm_clear_buffer

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: disable BAR resize on Dell G5 SE

David Yat Sin <David.YatSin@amd.com>
    drm/amdkfd: Preserve cp_hqd_pq_control on update_mqd

Matthew Auld <matthew.auld@intel.com>
    drm/xe/userptr: fix EFAULT handling

Matthew Auld <matthew.auld@intel.com>
    drm/xe/userptr: restore invalidation list on error

Mingcong Bai <jeffbai@aosc.io>
    drm/xe/regs: remove a duplicate definition for RING_CTL_SIZE(size)

Kan Liang <kan.liang@linux.intel.com>
    perf/core: Fix low freq setting via IOC_PERIOD

Kan Liang <kan.liang@linux.intel.com>
    perf/x86: Fix low freqency setting issue

Breno Leitao <leitao@debian.org>
    perf/core: Add RCU read lock protection to perf_iterate_ctx()

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Ensure a VMID is allocated before programming VTTBR_EL2

Adrien Vergé <adrienverge@gmail.com>
    ALSA: hda/realtek: Fix microphone regression on ASUS N705UD

Dmitry Panchenko <dmitry@d-systems.ee>
    ALSA: usb-audio: Re-add sample rate quirk for Pioneer DJM-900NXS2

Nikolay Kuratov <kniv@yandex-team.ru>
    ftrace: Avoid potential division by zero in function_stat_show()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix bad hist from corrupting named_triggers list

Andrew Jones <ajones@ventanamicro.com>
    riscv: KVM: Fix SBI TIME error generation

Andrew Jones <ajones@ventanamicro.com>
    riscv: KVM: Fix SBI IPI error generation

Andrew Jones <ajones@ventanamicro.com>
    riscv: KVM: Fix hart suspend_type use

Andrew Jones <ajones@ventanamicro.com>
    riscv: KVM: Fix hart suspend status check

Chukun Pan <amadeus@jmu.edu.cn>
    phy: rockchip: naneng-combphy: compatible reset with old DT

Arnd Bergmann <arnd@arndb.de>
    phy: rockchip: fix Kconfig dependency more

Russell Senior <russell@personaltelco.net>
    x86/CPU: Fix warm boot hang regression on AMD SC1100 SoC systems

Ard Biesheuvel <ardb@kernel.org>
    objtool: Fix C jump table annotations for Clang

Peter Zijlstra <peterz@infradead.org>
    objtool: Remove annotate_{,un}reachable()

Peter Zijlstra <peterz@infradead.org>
    unreachable: Unify

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/net: save msg_control for compat

Yu-Che Cheng <giver@chromium.org>
    thermal: gov_power_allocator: Update total_weight on bind and cdev updates

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Move lists of thermal instances to trip descriptors

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal/of: Fix cdev lookup in thermal_of_should_bind()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    thermal: of: Simplify thermal_of_should_bind with scoped for each OF child

Tong Tiangen <tongtiangen@huawei.com>
    uprobes: Reject the shared zeropage in uprobe_write_opcode()

Luo Gengkun <luogengkun@huaweicloud.com>
    perf/core: Order the PMU list to fix warning about unordered pmu_ctx_list

Yu-Che Cheng <giver@chromium.org>
    thermal: gov_power_allocator: Fix incorrect calculation in divvy_up_power()

Meghana Malladi <m-malladi@ti.com>
    net: ti: icss-iep: Reject perout generation request

Eric Dumazet <edumazet@google.com>
    idpf: fix checksums set in idpf_rx_rsc()

Joe Damato <jdamato@fastly.com>
    selftests: drv-net: Check if combined-count exists

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: fix dst ref loop on input in rpl lwt

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: fix dst ref loop on input in seg6 lwt

Shay Drory <shayd@nvidia.com>
    net/mlx5: IRQ, Fix null string in debug print

Harshal Chaudhari <hchaudhari@marvell.com>
    net: mvpp2: cls: Fixed Non IP flow, with vlan tag flow defination.

Mohammad Heib <mheib@redhat.com>
    net: Clear old fragment checksum value in napi_reuse_skb

Tejas Upadhyay <tejas.upadhyay@intel.com>
    drm/xe: cancel pending job timer before freeing scheduler

Wang Hai <wanghai38@huawei.com>
    tcp: Defer ts_recent changes until req is owned

Marcin Szycik <marcin.szycik@linux.intel.com>
    ice: Avoid setting default Rx VSI twice in switchdev setup

Marcin Szycik <marcin.szycik@linux.intel.com>
    ice: Fix deinitializing VF in error path

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: add E830 HW VF mailbox message limit support

Stanislav Fomichev <sdf@fomichev.me>
    tcp: devmem: don't write truncated dmabuf CMSGs to userspace

Sascha Hauer <s.hauer@pengutronix.de>
    net: ethernet: ti: am65-cpsw: select PAGE_POOL

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix wrong mic setup for ASUS VivoBook 15

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Prevent races when soft-resetting using SPI control

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Remove async regmap writes

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    drm/xe/oa: Allow oa_exponent value of 0

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: Allow only certain property changes from config

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: Add syncs support to OA config ioctl

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: Move functions up so they can be reused for config ioctl

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: Signal output fences

Philo Lu <lulie@linux.alibaba.com>
    ipvs: Always clear ipvs_property flag in skb_scrub_packet()

Chancel Liu <chancel.liu@nxp.com>
    ASoC: fsl: Rename stream name of SAI DAI driver

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    ASoC: es8328: fix route from DAC to output

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366rb: Fix compilation problem

Sean Anderson <sean.anderson@linux.dev>
    net: cadence: macb: Synchronize stats calculations

Eric Dumazet <edumazet@google.com>
    ipvlan: ensure network headers are in skb linear part

Guillaume Nault <gnault@redhat.com>
    ipvlan: Prepare ipvlan_process_v4_outbound() to future .flowi4_tos conversion.

Guillaume Nault <gnault@redhat.com>
    ipv4: Convert ip_route_input() to dscp_t.

Guillaume Nault <gnault@redhat.com>
    ipv4: Convert icmp_route_lookup() to dscp_t.

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    net: set the minimum for net_hotdata.netdev_budget_usecs

Ido Schimmel <idosch@nvidia.com>
    net: loopback: Avoid sending IP packets without an Ethernet header

David Howells <dhowells@redhat.com>
    afs: Give an afs_server object a ref on the afs_cell object it points to

David Howells <dhowells@redhat.com>
    afs: Fix the server_list to unuse a displaced server rather than putting it

David Howells <dhowells@redhat.com>
    rxrpc: rxperf: Fix missing decoding of terminal magic cookie

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix L2CAP_ECRED_CONN_RSP response

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Avoid dropping MIDI events at closing multiple ports

Arnd Bergmann <arnd@arndb.de>
    sunrpc: suppress warnings for unused procfs functions

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Fix the page details for the srq created by kernel consumers

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix bind QP error cleanup flow

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    scsi: ufs: core: Set default runtime/system PM levels before ufshcd_hba_init()

Ye Bin <yebin10@huawei.com>
    scsi: core: Clear driver private data when retrying request

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix AH static rate parsing

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Fix implicit ODP hang on parent deregistration

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Handle -ETIMEDOUT return from tlshd

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a deadlock when recovering state on a sillyrenamed file

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Prevent looping due to rpc_signal_task() races

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Adjust delegated timestamps for O_DIRECT reads and writes

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: O_DIRECT writes must check and adjust the file length

Vasiliy Kovalev <kovalev@altlinux.org>
    ovl: fix UAF in ovl_dentry_update_reval by moving dput() in ovl_link_up

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Fix ufshcd_is_ufs_dev_busy() and ufshcd_eh_timed_out()

Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
    landlock: Fix non-TCP sockets restriction

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix the statistics for Gen P7 VF

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Allocate dev_attr information dynamically

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Add sanity checks on rdev validity

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Cache MSIx info to a local structure

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Refactor NQ allocation

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fail probe early when not enough MSI-x vectors are reserved

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix mbox timing out by adding retry mechanism

Konstantin Taranov <kotaranov@microsoft.com>
    RDMA/mana_ib: Allocate PAGE aligned doorbell index

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Fix a WARN during dereg_mr for DM type

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Fix a race for DMABUF MR which can lead to CQE with error

Mark Zhang <markzhang@nvidia.com>
    IB/mlx5: Set and get correct qp_num for a DCT QP

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Fix the recovery flow of the UMR QP


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/include/asm/hugetlb.h                   |  22 +-
 arch/arm64/include/asm/kvm_host.h                  |   2 +-
 arch/arm64/kvm/arm.c                               |  22 +-
 arch/arm64/kvm/vmid.c                              |  11 +-
 arch/arm64/mm/hugetlbpage.c                        |  51 +-
 arch/arm64/mm/init.c                               |   7 +-
 arch/riscv/include/asm/futex.h                     |   2 +-
 arch/riscv/kernel/cacheinfo.c                      |  12 +-
 arch/riscv/kernel/cpufeature.c                     |   2 +-
 arch/riscv/kernel/setup.c                          |   2 +-
 arch/riscv/kernel/signal.c                         |   6 -
 arch/riscv/kvm/vcpu_sbi_hsm.c                      |  11 +-
 arch/riscv/kvm/vcpu_sbi_replace.c                  |  15 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/events/core.c                             |   2 +-
 arch/x86/kernel/cpu/cyrix.c                        |   4 +-
 arch/x86/kernel/cpu/microcode/amd.c                | 283 ++++++---
 arch/x86/kernel/cpu/microcode/amd_shas.c           | 444 ++++++++++++++
 arch/x86/kernel/cpu/microcode/internal.h           |   2 -
 block/blk-zoned.c                                  |  76 ++-
 drivers/firmware/cirrus/cs_dsp.c                   |  24 +-
 drivers/firmware/efi/mokvar-table.c                |  42 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c   |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c   |   5 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c   |   5 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |   5 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  69 ++-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c  |  14 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c  |   3 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c         |  25 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/legacy_dpm.c     |   8 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |  26 +-
 drivers/gpu/drm/xe/regs/xe_engine_regs.h           |   1 -
 drivers/gpu/drm/xe/xe_guc_submit.c                 |   2 +
 drivers/gpu/drm/xe/xe_oa.c                         | 657 ++++++++++++---------
 drivers/gpu/drm/xe/xe_oa_types.h                   |   6 +
 drivers/gpu/drm/xe/xe_vm.c                         |  40 +-
 drivers/i2c/busses/i2c-ls2x.c                      |  16 +-
 drivers/i2c/busses/i2c-npcm7xx.c                   |   7 +
 drivers/idle/intel_idle.c                          |   4 +
 drivers/infiniband/hw/bnxt_re/bnxt_re.h            |  18 +-
 drivers/infiniband/hw/bnxt_re/hw_counters.c        |   4 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  46 +-
 drivers/infiniband/hw/bnxt_re/main.c               | 153 +++--
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |   7 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.h          |  12 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |   4 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.h           |   3 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  64 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   2 +
 drivers/infiniband/hw/mana/main.c                  |   2 +-
 drivers/infiniband/hw/mlx5/ah.c                    |   3 +-
 drivers/infiniband/hw/mlx5/counters.c              |   8 +-
 drivers/infiniband/hw/mlx5/mr.c                    |  16 +-
 drivers/infiniband/hw/mlx5/odp.c                   |   1 +
 drivers/infiniband/hw/mlx5/qp.c                    |  10 +-
 drivers/infiniband/hw/mlx5/qp.h                    |   1 +
 drivers/infiniband/hw/mlx5/umr.c                   |  83 ++-
 drivers/iommu/intel/dmar.c                         |   1 +
 drivers/iommu/intel/iommu.c                        |  10 +-
 drivers/md/dm-integrity.c                          |   8 +-
 drivers/md/dm-vdo/dedupe.c                         |   1 +
 drivers/net/dsa/realtek/Kconfig                    |   6 +
 drivers/net/dsa/realtek/Makefile                   |   3 +
 drivers/net/dsa/realtek/rtl8366rb-leds.c           | 177 ++++++
 drivers/net/dsa/realtek/rtl8366rb.c                | 258 +-------
 drivers/net/dsa/realtek/rtl8366rb.h                | 107 ++++
 drivers/net/ethernet/cadence/macb.h                |   2 +
 drivers/net/ethernet/cadence/macb_main.c           |  12 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       | 103 +++-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   7 +-
 drivers/net/ethernet/intel/ice/ice.h               |   1 +
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |   3 +-
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h    |   3 +
 drivers/net/ethernet/intel/ice/ice_lib.c           |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c          |  24 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c         |   4 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |  34 +-
 .../net/ethernet/intel/ice/ice_vf_lib_private.h    |   1 +
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c        |  32 +
 drivers/net/ethernet/intel/ice/ice_vf_mbx.h        |   9 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |   8 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |   3 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |  14 +
 drivers/net/ethernet/ti/Kconfig                    |   1 +
 drivers/net/ethernet/ti/icssg/icss_iep.c           |  21 +-
 drivers/net/ipvlan/ipvlan_core.c                   |  22 +-
 drivers/net/loopback.c                             |  14 +
 drivers/net/phy/qcom/qca807x.c                     |   2 +-
 drivers/net/usb/gl620a.c                           |   4 +-
 drivers/phy/rockchip/Kconfig                       |   1 +
 drivers/phy/rockchip/phy-rockchip-naneng-combphy.c |   5 +-
 drivers/phy/samsung/phy-exynos5-usbdrd.c           |  25 +-
 drivers/phy/tegra/xusb-tegra186.c                  |  11 +
 drivers/scsi/scsi_lib.c                            |  14 +-
 drivers/thermal/gov_bang_bang.c                    |  11 +-
 drivers/thermal/gov_fair_share.c                   |  16 +-
 drivers/thermal/gov_power_allocator.c              |  68 ++-
 drivers/thermal/gov_step_wise.c                    |  16 +-
 drivers/thermal/thermal_core.c                     |  33 +-
 drivers/thermal/thermal_core.h                     |   5 +-
 drivers/thermal/thermal_helpers.c                  |   5 +-
 drivers/thermal/thermal_of.c                       |  53 +-
 drivers/ufs/core/ufs_bsg.c                         |   6 +-
 drivers/ufs/core/ufshcd.c                          |  38 +-
 fs/afs/server.c                                    |   3 +
 fs/afs/server_list.c                               |   4 +-
 fs/nfs/delegation.c                                |  37 ++
 fs/nfs/delegation.h                                |   1 +
 fs/nfs/direct.c                                    |  23 +
 fs/nfs/nfs4proc.c                                  |   3 +
 fs/overlayfs/copy_up.c                             |   2 +-
 include/asm-generic/vmlinux.lds.h                  |   2 +-
 include/linux/blkdev.h                             |   7 +-
 include/linux/compiler-gcc.h                       |  12 -
 include/linux/compiler.h                           |  39 +-
 include/linux/rcuref.h                             |   9 +-
 include/linux/socket.h                             |   2 +
 include/linux/sunrpc/sched.h                       |   3 +-
 include/net/ip.h                                   |   5 +
 include/net/route.h                                |   5 +-
 include/sound/cs35l56.h                            |  31 +
 include/trace/events/afs.h                         |   2 +
 include/trace/events/sunrpc.h                      |   3 +-
 io_uring/net.c                                     |   4 +-
 kernel/events/core.c                               |  31 +-
 kernel/events/uprobes.c                            |   5 +
 kernel/sched/core.c                                |   2 +-
 kernel/sched/ext.c                                 |  11 +-
 kernel/trace/ftrace.c                              |  27 +-
 kernel/trace/trace_events_hist.c                   |  34 +-
 lib/rcuref.c                                       |   5 +-
 net/bluetooth/l2cap_core.c                         |   9 +-
 net/bridge/br_netfilter_hooks.c                    |   8 +-
 net/core/gro.c                                     |   1 +
 net/core/scm.c                                     |  10 +
 net/core/skbuff.c                                  |   2 +-
 net/core/sysctl_net_core.c                         |   3 +-
 net/ipv4/icmp.c                                    |  19 +-
 net/ipv4/ip_options.c                              |   3 +-
 net/ipv4/tcp.c                                     |  26 +-
 net/ipv4/tcp_minisocks.c                           |  10 +-
 net/ipv6/ip6_tunnel.c                              |   4 +-
 net/ipv6/rpl_iptunnel.c                            |  14 +-
 net/ipv6/seg6_iptunnel.c                           |  14 +-
 net/mptcp/pm_netlink.c                             |   5 -
 net/mptcp/subflow.c                                |  15 +-
 net/rxrpc/rxperf.c                                 |  12 +
 net/sunrpc/cache.c                                 |  10 +-
 net/sunrpc/sched.c                                 |   2 -
 net/sunrpc/xprtsock.c                              |  10 +-
 security/integrity/ima/ima.h                       |   3 +
 security/integrity/ima/ima_main.c                  |   7 +-
 security/landlock/net.c                            |   3 +-
 sound/pci/hda/cs35l56_hda_spi.c                    |   3 +
 sound/pci/hda/patch_realtek.c                      |   2 +-
 sound/soc/codecs/cs35l56-shared.c                  |  80 +++
 sound/soc/codecs/cs35l56-spi.c                     |   3 +
 sound/soc/codecs/es8328.c                          |  15 +-
 sound/soc/fsl/fsl_sai.c                            |   6 +-
 sound/soc/fsl/imx-audmix.c                         |   4 +-
 sound/usb/midi.c                                   |   2 +-
 sound/usb/quirks.c                                 |   1 +
 tools/objtool/check.c                              |  50 +-
 tools/objtool/include/objtool/special.h            |   2 +-
 tools/testing/selftests/drivers/net/queues.py      |   7 +-
 tools/testing/selftests/landlock/common.h          |   1 +
 tools/testing/selftests/landlock/config            |   2 +
 tools/testing/selftests/landlock/net_test.c        | 124 +++-
 tools/testing/selftests/rseq/rseq-riscv-bits.h     |   6 +-
 tools/testing/selftests/rseq/rseq-riscv.h          |   2 +-
 176 files changed, 2965 insertions(+), 1448 deletions(-)


