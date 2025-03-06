Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED2D18C92F;
	Thu,  6 Mar 2025 15:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741274448; cv=none; b=CM7LeBYEHJd2M9m7XH2LyGrDGPQauV8+Sh9O9eEnKcp/ePjdgrQYhBpzkD8z0oCO2WRp26jeAZvXcLXTWudUtiTzFAyQ6Ffs4WedGrVBCXjoZFnBH3lhT1jlopi8Wp4kEAuv7YC6Ip1O7VcumZgWIoX0dG1Jd1LNNPkruP9pmQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741274448; c=relaxed/simple;
	bh=ylkL8cU9/DeXwQ2YBVW7rMCHjsxDOOF1J4+L4kftzt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=exxtRVugn0bA6WnjYt+0sxmyZf0pI+ZRbbFG8fGEgknRLq/DDcpsTwAzrcfEogPM3Qby+oYm3pkVypklB9hlOW2y/ytRGYTINhPIvMDA6Ag3V5yaK60C72vw+TU3EhzzcgFrQAFrfVEm96ZOI+DgrMnnDwPFW51CntTyyHC8VQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isq87CSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isq87CSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E04C4CEE0;
	Thu,  6 Mar 2025 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741274447;
	bh=ylkL8cU9/DeXwQ2YBVW7rMCHjsxDOOF1J4+L4kftzt0=;
	h=From:To:Cc:Subject:Date:From;
	b=isq87CSLY6QAFMi79gJKjBhqJoMtu4Kz43ng4n3WmuZw7305iKJNNMTa1M+/fFDIK
	 vfboptccWoiarTmiCIogUyQLnsOvQNEG34r97TUzih8oecUWmUlPMkESdsAEgmf8y9
	 eas2UXUQ4aQFVbilJLwEltgmwMzO8rU+TUdl+YvY=
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
Subject: [PATCH 6.6 000/147] 6.6.81-rc2 review
Date: Thu,  6 Mar 2025 16:20:44 +0100
Message-ID: <20250306151412.957725234@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.81-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.81-rc2
X-KernelTest-Deadline: 2025-03-08T15:14+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.81 release.
There are 147 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.81-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.81-rc2

Manivannan Sadhasivam <mani@kernel.org>
    scsi: ufs: core: Cancel RTC work during ufshcd_remove()

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Start the RTC update work later

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Fix another deadlock during RTC update

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Fix a -Wsometimes-uninitialized clang false positive

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Fix deadlock during RTC update

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Load only SHA256-checksummed patches

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Add get_patch_level()

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Get rid of the _load_microcode_amd() forward declaration

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Merge early_apply_microcode() into its single callsite

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Have __apply_microcode_amd() return bool

Nikolay Borisov <nik.borisov@suse.com>
    x86/microcode/AMD: Make __verify_patch_size() return bool

Nikolay Borisov <nik.borisov@suse.com>
    x86/microcode/AMD: Return bool from find_blobs_in_containers()

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Flush patch buffer mapping after application

Chang S. Bae <chang.seok.bae@intel.com>
    x86/microcode/intel: Remove unnecessary cache writeback and invalidation

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Split load_microcode_amd()

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Pay attention to the stepping dynamically

Borislav Petkov <bp@alien8.de>
    x86/microcode/AMD: Use the family,model,stepping encoded in the patch ID

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/intel: Set new revision only after a successful update

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode: Rework early revisions reporting

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Prepare for minimal revision check

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Handle "offline" CPUs correctly

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Provide apic_force_nmi_on_cpu()

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Protect against instrumentation

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Rendezvous and load in NMI

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Replace the all-in-one rendevous handler

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Provide new control functions

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Add per CPU control field

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Add per CPU result state

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Sanitize __wait_for_cpus()

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Clarify the late load logic

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Handle "nosmt" correctly

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Clean up mc_cpu_down_prep()

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Get rid of the schedule work indirection

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Mop up early loading leftovers

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode/amd: Use cached microcode for AP load

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode/amd: Cache builtin/initrd microcode early

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode/amd: Cache builtin microcode too

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode/amd: Use correct per CPU ucode_cpu_info

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Remove pointless apply() invocation

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode/intel: Rework intel_find_matching_signature()

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode/intel: Reuse intel_cpu_collect_info()

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode/intel: Rework intel_cpu_collect_info()

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode/intel: Unify microcode apply() functions

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode/intel: Switch to kvmalloc()

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode/intel: Save the microcode only after a successful late-load

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode/intel: Simplify early loading

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode/intel: Cleanup code further

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode/intel: Simplify and rename generic_load_microcode()

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode/intel: Simplify scan_microcode()

Ashok Raj <ashok.raj@intel.com>
    x86/microcode/intel: Rip out mixed stepping support for Intel CPUs

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode/32: Move early loading after paging enable

Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
    arm64: dts: rockchip: Disable DMA for uart5 on px30-ringneck

Thomas Gleixner <tglx@linutronix.de>
    intel_idle: Handle older CPUs, which stop the TSC in deeper C states, correctly

Joshua Washington <joshwash@google.com>
    gve: set xdp redirect target only when it is available

chr[] <chris@rudorff.com>
    amdgpu/pm/legacy: fix suspend/resume issues

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_top: Set OSNOISE_WORKLOAD for kernel threads

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_hist: Set OSNOISE_WORKLOAD for kernel threads

Tomas Glozar <tglozar@redhat.com>
    Revert "rtla/timerlat_hist: Set OSNOISE_WORKLOAD for kernel threads"

Tomas Glozar <tglozar@redhat.com>
    Revert "rtla/timerlat_top: Set OSNOISE_WORKLOAD for kernel threads"

Yong-Xuan Wang <yongxuan.wang@sifive.com>
    riscv: signal: fix signal frame size

Andreas Schwab <schwab@suse.de>
    riscv/futex: sign extend compare value in atomic cmpxchg

Stafford Horne <shorne@gmail.com>
    rseq/selftests: Fix riscv rseq_offset_deref_addv inline asm

Arthur Simchaev <arthur.simchaev@sandisk.com>
    scsi: ufs: core: bsg: Fix crash when arpmb command fails

Thomas Gleixner <tglx@linutronix.de>
    sched/core: Prevent rescheduling when interrupts are disabled

Thomas Gleixner <tglx@linutronix.de>
    rcuref: Plug slowpath race in rcuref_put()

Ard Biesheuvel <ardb@kernel.org>
    vmlinux.lds: Ensure that const vars with relocations are mapped R/O

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: reset when MPTCP opts are dropped after join

Paolo Abeni <pabeni@redhat.com>
    mptcp: always handle address removal under msk socket lock

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
    net: enetc: keep track of correct Tx BD count in enetc_map_tx_tso_buffs()

Wei Fang <wei.fang@nxp.com>
    net: enetc: fix the off-by-one issue in enetc_map_tx_buffs()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    usbnet: gl620a: fix endpoint checking in genelink_bind()

Binbin Zhou <zhoubinbin@loongson.cn>
    i2c: ls2x: Fix frequency division register access

Tyrone Ting <kfting@nuvoton.com>
    i2c: npcm: disable interrupt enable bit before devm_request_irq

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Fix HPD after gpu reset

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Disable PSR-SU on eDP panels

Kan Liang <kan.liang@linux.intel.com>
    perf/core: Fix low freq setting via IOC_PERIOD

Kan Liang <kan.liang@linux.intel.com>
    perf/x86: Fix low freqency setting issue

Breno Leitao <leitao@debian.org>
    perf/core: Add RCU read lock protection to perf_iterate_ctx()

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
    riscv: KVM: Fix hart suspend status check

Yong-Xuan Wang <yongxuan.wang@sifive.com>
    RISCV: KVM: Introduce mp_state_lock to avoid lock inversion

Chukun Pan <amadeus@jmu.edu.cn>
    phy: rockchip: naneng-combphy: compatible reset with old DT

Russell Senior <russell@personaltelco.net>
    x86/CPU: Fix warm boot hang regression on AMD SC1100 SoC systems

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/net: save msg_control for compat

Tong Tiangen <tongtiangen@huawei.com>
    uprobes: Reject the shared zeropage in uprobe_write_opcode()

Luo Gengkun <luogengkun@huaweicloud.com>
    perf/core: Order the PMU list to fix warning about unordered pmu_ctx_list

Meghana Malladi <m-malladi@ti.com>
    net: ti: icss-iep: Reject perout generation request

Diogo Ivo <diogo.ivo@siemens.com>
    net: ti: icss-iep: Remove spinlock-based synchronization

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: fix dst ref loop on input in rpl lwt

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: rpl_iptunnel: mitigate 2-realloc issue

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: fix dst ref loop on input in seg6 lwt

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: seg6_iptunnel: mitigate 2-realloc issue

Justin Iurman <justin.iurman@uliege.be>
    include: net: add static inline dst_dev_overhead() to dst.h

Shay Drory <shayd@nvidia.com>
    net/mlx5: IRQ, Fix null string in debug print

Harshal Chaudhari <hchaudhari@marvell.com>
    net: mvpp2: cls: Fixed Non IP flow, with vlan tag flow defination.

Mohammad Heib <mheib@redhat.com>
    net: Clear old fragment checksum value in napi_reuse_skb

Wang Hai <wanghai38@huawei.com>
    tcp: Defer ts_recent changes until req is owned

Marcin Szycik <marcin.szycik@linux.intel.com>
    ice: Fix deinitializing VF in error path

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: add E830 HW VF mailbox message limit support

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: Add E830 device IDs, MAC type and registers

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix wrong mic setup for ASUS VivoBook 15

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add quirks for ASUS ROG 2023 models

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Remove async regmap writes

Philo Lu <lulie@linux.alibaba.com>
    ipvs: Always clear ipvs_property flag in skb_scrub_packet()

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    ASoC: es8328: fix route from DAC to output

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

Ido Schimmel <idosch@nvidia.com>
    ipvlan: Unmask upper DSCP bits in ipvlan_process_v4_outbound()

Ido Schimmel <idosch@nvidia.com>
    ipv4: icmp: Unmask upper DSCP bits in icmp_route_lookup()

Ido Schimmel <idosch@nvidia.com>
    ipv4: icmp: Pass full DS field to ip_route_input()

Peilin He <he.peilin@zte.com.cn>
    net/ipv4: add tracepoint for icmp_send

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    net: set the minimum for net_hotdata.netdev_budget_usecs

Ido Schimmel <idosch@nvidia.com>
    net: loopback: Avoid sending IP packets without an Ethernet header

David Howells <dhowells@redhat.com>
    afs: Fix the server_list to unuse a displaced server rather than putting it

David Howells <dhowells@redhat.com>
    afs: Make it possible to find the volumes that are using a server

David Howells <dhowells@redhat.com>
    rxrpc: rxperf: Fix missing decoding of terminal magic cookie

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix L2CAP_ECRED_CONN_RSP response

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Avoid dropping MIDI events at closing multiple ports

Arnd Bergmann <arnd@arndb.de>
    sunrpc: suppress warnings for unused procfs functions

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix bind QP error cleanup flow

Ye Bin <yebin10@huawei.com>
    scsi: core: Clear driver private data when retrying request

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix AH static rate parsing

Or Har-Toov <ohartoov@nvidia.com>
    IB/core: Add support for XDR link speed

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Handle -ETIMEDOUT return from tlshd

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Prevent looping due to rpc_signal_task() races

Stephen Brennan <stephen.s.brennan@oracle.com>
    SUNRPC: convert RPC_TASK_* constants to enum

Vasiliy Kovalev <kovalev@altlinux.org>
    ovl: fix UAF in ovl_dentry_update_reval by moving dput() in ovl_link_up

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Fix ufshcd_is_ufs_dev_busy() and ufshcd_eh_timed_out()

Avri Altman <avri.altman@wdc.com>
    scsi: ufs: core: Prepare to introduce a new clock_gating lock

Avri Altman <avri.altman@wdc.com>
    scsi: ufs: core: Introduce ufshcd_has_pending_tasks()

Bean Huo <beanhuo@micron.com>
    scsi: ufs: core: Add UFS RTC support

Bean Huo <beanhuo@micron.com>
    scsi: ufs: core: Add ufshcd_is_ufs_dev_busy()

Konstantin Taranov <kotaranov@microsoft.com>
    RDMA/mana_ib: Allocate PAGE aligned doorbell index

Mark Zhang <markzhang@nvidia.com>
    IB/mlx5: Set and get correct qp_num for a DCT QP


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   5 +
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi    |   5 +
 arch/riscv/include/asm/futex.h                     |   2 +-
 arch/riscv/include/asm/kvm_host.h                  |   8 +-
 arch/riscv/kernel/signal.c                         |   6 -
 arch/riscv/kvm/vcpu.c                              |  48 +-
 arch/riscv/kvm/vcpu_sbi.c                          |   7 +-
 arch/riscv/kvm/vcpu_sbi_hsm.c                      |  45 +-
 arch/riscv/kvm/vcpu_sbi_replace.c                  |  15 +-
 arch/x86/Kconfig                                   |  26 +-
 arch/x86/events/core.c                             |   2 +-
 arch/x86/include/asm/apic.h                        |   5 +-
 arch/x86/include/asm/cpu.h                         |  20 +-
 arch/x86/include/asm/microcode.h                   |  18 +-
 arch/x86/kernel/apic/apic_flat_64.c                |   2 +
 arch/x86/kernel/apic/ipi.c                         |   8 +
 arch/x86/kernel/apic/x2apic_cluster.c              |   1 +
 arch/x86/kernel/apic/x2apic_phys.c                 |   1 +
 arch/x86/kernel/cpu/common.c                       |  12 -
 arch/x86/kernel/cpu/cyrix.c                        |   4 +-
 arch/x86/kernel/cpu/microcode/amd.c                | 650 ++++++++++++------
 arch/x86/kernel/cpu/microcode/amd_shas.c           | 444 +++++++++++++
 arch/x86/kernel/cpu/microcode/core.c               | 723 +++++++++++++--------
 arch/x86/kernel/cpu/microcode/intel.c              | 706 ++++++--------------
 arch/x86/kernel/cpu/microcode/internal.h           |  49 +-
 arch/x86/kernel/head32.c                           |   3 +
 arch/x86/kernel/head_32.S                          |  10 -
 arch/x86/kernel/nmi.c                              |   9 +-
 arch/x86/kernel/smpboot.c                          |  12 +-
 drivers/firmware/cirrus/cs_dsp.c                   |  24 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c  |  14 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c  |   3 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c         |  25 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/legacy_dpm.c     |   8 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |  26 +-
 drivers/i2c/busses/i2c-ls2x.c                      |  16 +-
 drivers/i2c/busses/i2c-npcm7xx.c                   |   7 +
 drivers/idle/intel_idle.c                          |   4 +
 drivers/infiniband/core/sysfs.c                    |   4 +
 drivers/infiniband/core/uverbs_std_types_device.c  |   3 +-
 drivers/infiniband/core/verbs.c                    |   3 +
 drivers/infiniband/hw/mana/main.c                  |   2 +-
 drivers/infiniband/hw/mlx5/ah.c                    |   3 +-
 drivers/infiniband/hw/mlx5/counters.c              |   8 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  10 +-
 drivers/infiniband/hw/mlx5/qp.h                    |   1 +
 drivers/net/ethernet/cadence/macb.h                |   2 +
 drivers/net/ethernet/cadence/macb_main.c           |  12 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       | 100 ++-
 drivers/net/ethernet/google/gve/gve.h              |  10 +
 drivers/net/ethernet/google/gve/gve_main.c         |   6 +-
 drivers/net/ethernet/intel/ice/ice.h               |   1 +
 drivers/net/ethernet/intel/ice/ice_common.c        |  65 +-
 drivers/net/ethernet/intel/ice/ice_devids.h        |  10 +-
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c  |  24 +-
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h    |  55 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c          |  37 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c         |   4 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |   3 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |  34 +-
 .../net/ethernet/intel/ice/ice_vf_lib_private.h    |   1 +
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c        |  32 +
 drivers/net/ethernet/intel/ice/ice_vf_mbx.h        |   9 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |   8 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |  29 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   2 +-
 drivers/net/ethernet/ti/icssg/icss_iep.c           |  35 +-
 drivers/net/ipvlan/ipvlan_core.c                   |  24 +-
 drivers/net/loopback.c                             |  14 +
 drivers/net/usb/gl620a.c                           |   4 +-
 drivers/phy/rockchip/phy-rockchip-naneng-combphy.c |   5 +-
 drivers/phy/samsung/phy-exynos5-usbdrd.c           |  12 +-
 drivers/phy/tegra/xusb-tegra186.c                  |  11 +
 drivers/platform/x86/intel/ifs/load.c              |   8 +-
 drivers/scsi/scsi_lib.c                            |  14 +-
 drivers/ufs/core/ufs_bsg.c                         |   6 +-
 drivers/ufs/core/ufshcd-priv.h                     |   5 +
 drivers/ufs/core/ufshcd.c                          | 122 +++-
 fs/afs/cell.c                                      |   1 +
 fs/afs/internal.h                                  |  23 +-
 fs/afs/server.c                                    |   1 +
 fs/afs/server_list.c                               | 114 +++-
 fs/afs/vl_alias.c                                  |   2 +-
 fs/afs/volume.c                                    |  36 +-
 fs/overlayfs/copy_up.c                             |   2 +-
 include/asm-generic/vmlinux.lds.h                  |   2 +-
 include/linux/rcuref.h                             |   9 +-
 include/linux/sunrpc/sched.h                       |  17 +-
 include/net/dst.h                                  |   9 +
 include/net/ip.h                                   |   5 +
 include/net/route.h                                |   5 +-
 include/rdma/ib_verbs.h                            |   2 +
 include/trace/events/icmp.h                        |  67 ++
 include/trace/events/sunrpc.h                      |   3 +-
 include/uapi/rdma/ib_user_ioctl_verbs.h            |   3 +-
 include/ufs/ufs.h                                  |  13 +
 include/ufs/ufshcd.h                               |   4 +
 io_uring/net.c                                     |   4 +-
 kernel/events/core.c                               |  31 +-
 kernel/events/uprobes.c                            |   5 +
 kernel/sched/core.c                                |   2 +-
 kernel/trace/ftrace.c                              |  27 +-
 kernel/trace/trace_events_hist.c                   |  34 +-
 lib/rcuref.c                                       |   5 +-
 net/bluetooth/l2cap_core.c                         |   9 +-
 net/bridge/br_netfilter_hooks.c                    |   8 +-
 net/core/gro.c                                     |   1 +
 net/core/skbuff.c                                  |   2 +-
 net/core/sysctl_net_core.c                         |   3 +-
 net/ipv4/icmp.c                                    |  24 +-
 net/ipv4/ip_options.c                              |   3 +-
 net/ipv4/tcp_minisocks.c                           |  10 +-
 net/ipv6/ip6_tunnel.c                              |   4 +-
 net/ipv6/rpl_iptunnel.c                            |  58 +-
 net/ipv6/seg6_iptunnel.c                           |  97 ++-
 net/mptcp/pm_netlink.c                             |   5 -
 net/mptcp/subflow.c                                |  15 +-
 net/rxrpc/rxperf.c                                 |  12 +
 net/sunrpc/cache.c                                 |  10 +-
 net/sunrpc/sched.c                                 |   2 -
 net/sunrpc/xprtsock.c                              |  10 +-
 sound/pci/hda/patch_realtek.c                      |  32 +-
 sound/soc/codecs/es8328.c                          |  15 +-
 sound/usb/midi.c                                   |   2 +-
 sound/usb/quirks.c                                 |   1 +
 tools/testing/selftests/rseq/rseq-riscv-bits.h     |   6 +-
 tools/testing/selftests/rseq/rseq-riscv.h          |   2 +-
 tools/tracing/rtla/src/timerlat_hist.c             |   2 +-
 tools/tracing/rtla/src/timerlat_top.c              |   2 +-
 132 files changed, 2912 insertions(+), 1569 deletions(-)


