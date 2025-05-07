Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF751E22E9;
	Wed,  7 May 2025 19:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644889; cv=none; b=hhkIoZaRCuk6zcr4sA3dKCyDkrLhVVFF0CBfgqytHV87rt086I9IuNS6wKm1rFVKIIENXqPWmIe9buQPJmMeme/1kWa7UKHRE/YV33haQpqEUp6MBlrMOd8MDq5aFszqHqq7d5vv4zyKlTT+Jec3hb96Z0TNHLXSKut8Rxf/528=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644889; c=relaxed/simple;
	bh=LbsFdh8soTAXsH/VrIvJgpdRms11hg8syYvuYbJxwLk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XI6kaohW8Amd2dMUCOD3YEaAJ1C+XOlnk4x0mWTF0Pp/8rcWjiQX+S+rg+btuyGad57sD0JfM41NLGAAVl96dQyZ54lRzhR3Llo5ab9kuTscTpE1lrch6wrso31TQ+RAJw+fgdIn0oZhrFw7O3ItQpobopxJhswkE2Y89U34FYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=btuA/B9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="btuA/B9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE03AC4CEE2;
	Wed,  7 May 2025 19:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644889;
	bh=LbsFdh8soTAXsH/VrIvJgpdRms11hg8syYvuYbJxwLk=;
	h=From:To:Cc:Subject:Date:From;
	b=btuA/B9cGfx49H89yc17j+4O8rM+Ex1uwvtQlNzkmHsSJh1/rhIqbkw3OgMrXg15I
	 7iv1xWDqPfqV9sUvj44UuLbzIi37xjWxfLveQVEn4wNJ8itWNMv7XZKmTp6uHAx/2Y
	 ui+OFnvTU9YU1CP1PbSXRPNW2tEWJAsN4WJ8F7w8=
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
Subject: [PATCH 6.6 000/129] 6.6.90-rc1 review
Date: Wed,  7 May 2025 20:38:56 +0200
Message-ID: <20250507183813.500572371@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.90-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.90-rc1
X-KernelTest-Deadline: 2025-05-09T18:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.90 release.
There are 129 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.90-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.90-rc1

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix possible null pointer dereference at secondary interrupter removal

Marc Zyngier <maz@kernel.org>
    usb: xhci: Check for xhci->interrupters being allocated in xhci_mem_clearup()

Chris Bainbridge <chris.bainbridge@gmail.com>
    drm/amd/display: Fix slab-use-after-free in hdcp

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Add scoped mutexes for amdgpu_dm_dhcp

Nicolin Chen <nicolinc@nvidia.com>
    iommu/arm-smmu-v3: Fix iommu_device_probe bug due to duplicated stream ids

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/arm-smmu-v3: Use the new rb tree helpers

Shyam Saini <shyamsaini@linux.microsoft.com>
    drivers: base: handle module_kobject creation

Shyam Saini <shyamsaini@linux.microsoft.com>
    kernel: globalize lookup_or_create_module_kobject()

Shyam Saini <shyamsaini@linux.microsoft.com>
    kernel: param: rename locate_module_kobject

Björn Töpel <bjorn@rivosinc.com>
    riscv: uprobes: Add missing fence.i after building the XOL buffer

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: drain obj stock on cpu hotplug teardown

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Limit time spent with xHC interrupts disabled during bus resume

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: support setting interrupt moderation IMOD for secondary interrupters

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: check if 'requested segments' exceeds ERST capacity

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Add helper to set an interrupters interrupt moderation interval

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: add support to allocate several interrupters

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: split free interrupter into separate remove and free parts

Lukas Wunner <lukas@wunner.de>
    xhci: Clean up stale comment on ERST_SIZE macro

Jonathan Bell <jonathan@raspberrypi.com>
    xhci: Use more than one Event Ring segment

Lukas Wunner <lukas@wunner.de>
    xhci: Set DESI bits in ERDP register correctly

Christian Hewitt <christianshewitt@gmail.com>
    Revert "drm/meson: vclk: fix calculation of 59.94 fractional rates"

Christian Bruel <christian.bruel@foss.st.com>
    arm64: dts: st: Use 128kB size for aliased GIC400 register access on stm32mp25 SoCs

Christian Bruel <christian.bruel@foss.st.com>
    arm64: dts: st: Adjust interrupt-controller for stm32mp25 SoCs

Sébastien Szymanski <sebastien.szymanski@armadeus.com>
    ARM: dts: opos6ul: add ksz8081 phy properties

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Skip Rx buffer ownership release if not acquired

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Balance device refcount when destroying devices

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

Samuel Holland <samuel.holland@sifive.com>
    riscv: Pass patch_text() the length in bytes

Geert Uytterhoeven <geert+renesas@glider.be>
    ASoC: soc-core: Stop using of_property_read_bool() for non-boolean properties

Rob Herring (Arm) <robh@kernel.org>
    ASoC: Use of_property_read_bool()

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

Sathesh B Edara <sedara@marvell.com>
    octeon_ep: Fix host hang issue during device reboot

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

Chad Monroe <chad@monroe.io>
    net: ethernet: mtk_eth_soc: fix SER panic with 4GB+ RAM

Jacob Keller <jacob.e.keller@intel.com>
    igc: fix lock order in igc_ptp_reset

Da Xue <da@libre.computer>
    net: mdio: mux-meson-gxl: set reversed bit when using internal phy

Simon Horman <horms@kernel.org>
    net: dlink: Correct endianness handling of led_mode

Keith Busch <kbusch@kernel.org>
    nvme-pci: fix queue unquiesce check on slot_reset

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Fix buffer overflow at UMP SysEx message conversion

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

Shannon Nelson <shannon.nelson@amd.com>
    pds_core: remove write-after-free of client_id

Shannon Nelson <shannon.nelson@amd.com>
    pds_core: specify auxiliary_device to be created

Shannon Nelson <shannon.nelson@amd.com>
    pds_core: make pdsc_auxbus_dev_del() void

Shannon Nelson <shannon.nelson@amd.com>
    pds_core: delete VF dev on reset

Shannon Nelson <shannon.nelson@amd.com>
    pds_core: check health in devcmd wait

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    net: ethernet: mtk-star-emac: rearm interrupts in rx_poll only when advised

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    net: ethernet: mtk-star-emac: fix spinlock recursion issues on rx/tx poll

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: delete PVID VLAN when readding it as non-PVID

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: treat 802.1ad tagged traffic as 802.1Q-untagged

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: copy RX timestamp to new fragments

Abhishek Chauhan <quic_abchauha@quicinc.com>
    net: Rename mono_delivery_time to tstamp_type for scalabilty

En-Wei Wu <en-wei.wu@canonical.com>
    Bluetooth: btusb: avoid NULL pointer dereference in skb_dequeue()

Chris Mi <cmi@nvidia.com>
    net/mlx5: E-switch, Fix error handling for enabling roce

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: E-Switch, Initialize MAC Address for Default GID

Ido Schimmel <idosch@nvidia.com>
    vxlan: vnifilter: Fix unlocked deletion of default FDB entry

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc/boot: Fix dash warning

Murad Masimov <m.masimov@mt-integration.ru>
    wifi: plfxlc: Remove erroneous assert in plfxlc_mac_release

Chen Linxuan <chenlinxuan@uniontech.com>
    drm/i915/pxp: fix undefined reference to `intel_pxp_gsccs_is_ready_for_sessions'

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc/boot: Check for ld-option support

Donet Tom <donettom@linux.ibm.com>
    book3s64/radix : Align section vmemmap start address to PAGE_SIZE

Sheetal <sheetal@nvidia.com>
    ASoC: soc-pcm: Fix hw_params() and DAPM widget sequence

Robin Murphy <robin.murphy@arm.com>
    iommu: Handle race with default domain setup

Sean Christopherson <seanjc@google.com>
    KVM: x86: Load DR6 with guest value only before entering .vcpu_run() loop

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Skip controller_id generation logic for i.MX7D

Ryan Matthews <ryanmatthews@fastmail.com>
    Revert "PCI: imx6: Skip controller_id generation logic for i.MX7D"

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: extend changes_pkt_data with cases w/o subprograms

Eduard Zingerman <eddyz87@gmail.com>
    bpf: fix null dereference when computing changes_pkt_data of prog w/o subprogs

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: validate that tail call invalidates packet pointers

Eduard Zingerman <eddyz87@gmail.com>
    bpf: consider that tail calls invalidate packet pointers

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: freplace tests for tracking of changes_packet_data

Eduard Zingerman <eddyz87@gmail.com>
    bpf: check changes_pkt_data property for extension programs

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: test for changing packet data from global functions

Eduard Zingerman <eddyz87@gmail.com>
    bpf: track changes_pkt_data property for global functions

Eduard Zingerman <eddyz87@gmail.com>
    bpf: refactor bpf_helper_changes_pkt_data to use helper number

Eduard Zingerman <eddyz87@gmail.com>
    bpf: add find_containing_subprog() utility function

Jeongjun Park <aha310510@gmail.com>
    tracing: Fix oob write in trace_seq_to_buffer()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Fix setting policy limits when frequency tables are used

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Avoid using inconsistent policy->min and policy->max

Jethro Donaldson <devel@jro.nz>
    smb: client: fix zero length for mkdir POSIX create context

Sean Heelan <seanheelan@gmail.com>
    ksmbd: fix use-after-free in kerberos authentication

Shouye Liu <shouyeliu@tencent.com>
    platform/x86/intel-uncore-freq: Fix missing uncore sysfs during CPU hotplug

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: pmc: Require at least 2.5 seconds between HW sleep cycles

Mingcong Bai <jeffbai@aosc.io>
    iommu/vt-d: Apply quirk_iommu_igfx for 8086:0044 (QM57/QS57)

Pavel Paklov <Pavel.Paklov@cyberprotect.ru>
    iommu/amd: Fix potential buffer overflow in parse_ivrs_acpihid

Benjamin Marzinski <bmarzins@redhat.com>
    dm: always update the array size in realloc_argv on success

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: fix a warning on invalid table line

LongPing Wei <weilongping@oppo.com>
    dm-bufio: don't schedule in atomic context

Wentao Liang <vulab@iscas.ac.cn>
    wifi: brcm80211: fmac: Add error handling for brcmf_usb_dl_writeimage()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Do not take trace_event_sem in print_event_fields()

Aaron Kling <webgeek1234@gmail.com>
    spi: tegra114: Don't fail set_cs_timing when delays are zero

Ruslan Piasetskyi <ruslan.piasetskyi@gmail.com>
    mmc: renesas_sdhi: Fix error handling in renesas_sdhi_probe

Wei Yang <richard.weiyang@gmail.com>
    mm/memblock: repeat setting reserved region nid if array is doubled

Wei Yang <richard.weiyang@gmail.com>
    mm/memblock: pass size instead of end to memblock_set_node()

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

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/fdinfo: Protect against driver unbind

Dave Chen <davechen@synology.com>
    btrfs: fix COW handling in run_delalloc_nocow()

Joachim Priesner <joachim.priesner@web.de>
    ALSA: usb-audio: Add second USB ID for Jabra Evolve 65 headset

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Add retry on -EPROTO from usb_set_interface()

Christian Heusel <christian@heusel.eu>
    Revert "rndis_host: Flag RNDIS modems as WWAN devices"


-------------

Diffstat:

 Makefile                                           |   4 +-
 .../boot/dts/nxp/imx/imx6ul-imx6ull-opos6ul.dtsi   |   3 +
 arch/arm64/boot/dts/st/stm32mp251.dtsi             |   9 +-
 arch/arm64/kernel/proton-pack.c                    |   2 +
 arch/parisc/math-emu/driver.c                      |  16 +-
 arch/powerpc/boot/wrapper                          |   6 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |  17 +-
 arch/riscv/include/asm/patch.h                     |   2 +-
 arch/riscv/kernel/patch.c                          |  14 +-
 arch/riscv/kernel/probes/kprobes.c                 |  18 +-
 arch/riscv/kernel/probes/uprobes.c                 |  10 +-
 arch/riscv/net/bpf_jit_comp64.c                    |   7 +-
 arch/x86/events/intel/core.c                       |   2 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   1 +
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/kvm/svm/svm.c                             |  13 +-
 arch/x86/kvm/vmx/vmx.c                             |  11 +-
 arch/x86/kvm/x86.c                                 |   3 +
 drivers/base/module.c                              |  13 +-
 drivers/bluetooth/btusb.c                          | 101 ++++++++---
 drivers/cpufreq/cpufreq.c                          |  42 ++++-
 drivers/cpufreq/cpufreq_ondemand.c                 |   3 +-
 drivers/cpufreq/freq_table.c                       |   6 +-
 drivers/edac/altera_edac.c                         |   9 +-
 drivers/edac/altera_edac.h                         |   2 +
 drivers/firmware/arm_ffa/driver.c                  |   3 +-
 drivers/firmware/arm_scmi/bus.c                    |   3 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |  56 +++---
 drivers/gpu/drm/drm_file.c                         |   6 +
 drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.h         |   8 +-
 drivers/gpu/drm/meson/meson_vclk.c                 |   6 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |   2 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |   4 +-
 drivers/iommu/amd/init.c                           |   8 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  79 +++++----
 drivers/iommu/intel/iommu.c                        |   4 +-
 drivers/iommu/iommu.c                              |  18 ++
 drivers/irqchip/irq-qcom-mpm.c                     |   3 +
 drivers/md/dm-bufio.c                              |   9 +-
 drivers/md/dm-integrity.c                          |   2 +-
 drivers/md/dm-table.c                              |   5 +-
 drivers/mmc/host/renesas_sdhi_core.c               |  10 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   5 +-
 drivers/net/ethernet/amd/pds_core/auxbus.c         |  49 +++---
 drivers/net/ethernet/amd/pds_core/core.h           |   7 +-
 drivers/net/ethernet/amd/pds_core/dev.c            |  11 +-
 drivers/net/ethernet/amd/pds_core/devlink.c        |   7 +-
 drivers/net/ethernet/amd/pds_core/main.c           |  23 ++-
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c          |   9 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |  24 ++-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  11 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c |  30 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  36 +++-
 drivers/net/ethernet/dlink/dl2k.c                  |   2 +-
 drivers/net/ethernet/dlink/dl2k.h                  |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  82 +++++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |  13 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  25 ++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |   5 +
 drivers/net/ethernet/intel/igc/igc_ptp.c           |   6 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  14 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |  13 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.h     |   4 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   8 +-
 drivers/net/ethernet/microchip/lan743x_main.h      |   1 +
 drivers/net/ethernet/mscc/ocelot.c                 | 194 +++++++++++++++++++--
 drivers/net/ethernet/mscc/ocelot_vcap.c            |   1 +
 drivers/net/ethernet/vertexcom/mse102x.c           |  36 +++-
 drivers/net/mdio/mdio-mux-meson-gxl.c              |   3 +-
 drivers/net/usb/rndis_host.c                       |  16 +-
 drivers/net/vxlan/vxlan_vnifilter.c                |   8 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   6 +-
 drivers/net/wireless/purelifi/plfxlc/mac.c         |   1 -
 drivers/nvme/host/pci.c                            |   2 +-
 drivers/nvme/host/tcp.c                            |  31 +++-
 drivers/pci/controller/dwc/pci-imx6.c              |   3 +-
 drivers/platform/x86/amd/pmc/pmc.c                 |   7 +-
 .../x86/intel/uncore-frequency/uncore-frequency.c  |  13 +-
 drivers/spi/spi-tegra114.c                         |   6 +-
 drivers/usb/host/xhci-debugfs.c                    |   2 +-
 drivers/usb/host/xhci-hub.c                        |  30 ++--
 drivers/usb/host/xhci-mem.c                        | 175 +++++++++++++++----
 drivers/usb/host/xhci-ring.c                       |   4 +-
 drivers/usb/host/xhci.c                            |  80 ++++++---
 drivers/usb/host/xhci.h                            |  20 ++-
 fs/btrfs/inode.c                                   |   9 +-
 fs/smb/client/smb2pdu.c                            |   1 +
 fs/smb/server/auth.c                               |  14 +-
 fs/smb/server/smb2pdu.c                            |   5 -
 include/linux/bpf.h                                |   1 +
 include/linux/bpf_verifier.h                       |   1 +
 include/linux/cpufreq.h                            |  83 ++++++---
 include/linux/filter.h                             |   2 +-
 include/linux/module.h                             |   2 +
 include/linux/pds/pds_core_if.h                    |   1 +
 include/linux/skbuff.h                             |  52 ++++--
 include/net/inet_frag.h                            |   4 +-
 include/soc/mscc/ocelot_vcap.h                     |   2 +
 include/sound/ump_convert.h                        |   2 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/bpf/verifier.c                              |  81 +++++++--
 kernel/params.c                                    |   6 +-
 kernel/trace/trace.c                               |   5 +-
 kernel/trace/trace_output.c                        |   4 +-
 mm/memblock.c                                      |  12 +-
 mm/memcontrol.c                                    |   9 +
 net/bluetooth/l2cap_core.c                         |   3 +
 net/bridge/netfilter/nf_conntrack_bridge.c         |   6 +-
 net/core/dev.c                                     |   2 +-
 net/core/filter.c                                  |  73 ++++----
 net/ieee802154/6lowpan/reassembly.c                |   2 +-
 net/ipv4/inet_fragment.c                           |   2 +-
 net/ipv4/ip_fragment.c                             |   2 +-
 net/ipv4/ip_output.c                               |   9 +-
 net/ipv4/tcp_output.c                              |  14 +-
 net/ipv4/udp_offload.c                             |  61 ++++++-
 net/ipv6/ip6_output.c                              |   6 +-
 net/ipv6/netfilter.c                               |   6 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   2 +-
 net/ipv6/reassembly.c                              |   2 +-
 net/ipv6/tcp_ipv6.c                                |   2 +-
 net/sched/act_bpf.c                                |   4 +-
 net/sched/cls_bpf.c                                |   4 +-
 net/sched/sch_drr.c                                |  16 +-
 net/sched/sch_ets.c                                |  17 +-
 net/sched/sch_hfsc.c                               |  10 +-
 net/sched/sch_htb.c                                |   2 +
 net/sched/sch_qfq.c                                |  18 +-
 sound/soc/codecs/ak4613.c                          |   4 +-
 sound/soc/soc-core.c                               |  36 ++--
 sound/soc/soc-pcm.c                                |   5 +-
 sound/usb/endpoint.c                               |   7 +
 sound/usb/format.c                                 |   3 +-
 .../selftests/bpf/prog_tests/changes_pkt_data.c    | 107 ++++++++++++
 .../testing/selftests/bpf/progs/changes_pkt_data.c |  39 +++++
 .../bpf/progs/changes_pkt_data_freplace.c          |  18 ++
 tools/testing/selftests/bpf/progs/verifier_sock.c  |  56 ++++++
 144 files changed, 1772 insertions(+), 662 deletions(-)


