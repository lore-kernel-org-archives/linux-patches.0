Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC48226D0B;
	Mon, 10 Mar 2025 17:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627953; cv=none; b=YSWJJwkHkI4ZoFTntJ3YatwOiN3fuub5h5hhMSYnJpedc0XcgUrTahEWWKz3lATvFkTpGHjkpbgsbYiW7NDr+tJX32GOx3VUUjZxD3iQDRaxQYkraadLwl+xjmMOOWts+eEaLFfPGlqHWgR5Zu6vK7Fc/VAZBEGht9ZQUUg8E5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627953; c=relaxed/simple;
	bh=tzFE5K+FCH8TLWxObDwKZagzwBJ57Ge/X3zmxVH/89A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Dq3qda1oF17URkJbV3kcmN7RLUuZ5w6BrlyrjQr3TNO6WCuz/4DVipI73j9auZEDCO2TnSMpPo3FSIckkec5iwuvNLGAADpWkJQ0+l1YnDlnFHCRgnUB1HvWdJfEs5mYMn7Li3Vn+fk7HkPH+ka9XEEVq1DrLF55AS/sxTfr+58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGdfURBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGdfURBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B86CC4CEF0;
	Mon, 10 Mar 2025 17:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627952;
	bh=tzFE5K+FCH8TLWxObDwKZagzwBJ57Ge/X3zmxVH/89A=;
	h=From:To:Cc:Subject:Date:From;
	b=YGdfURBYOcIb1HcyrQijzQYrI/MxsRA48aoDOZJKFKNK6COa89Ebb1iuesXGHbIYT
	 /a8XetGjdiw9rqbWKy0jIS4C0v49ajzNTbuORlvzAeBe+vHiFieqEMhoDEcSEG32LR
	 MukEn2A1bgO/bAo+u/XLjtzinlETJmRfiq32WMFI=
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
Subject: [PATCH 6.6 000/145] 6.6.83-rc1 review
Date: Mon, 10 Mar 2025 18:04:54 +0100
Message-ID: <20250310170434.733307314@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.83-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.83-rc1
X-KernelTest-Deadline: 2025-03-12T17:04+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.83 release.
There are 145 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.83-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.83-rc1

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kbuild: userprogs: use correct lld when linking through clang

Quang Le <quanglex97@gmail.com>
    pfifo_tail_enqueue: Drop new packet when sch->limit == 0

Ralf Schlatterbeck <rsc@runtux.com>
    spi-mxs: Fix chipselect glitch

Ard Biesheuvel <ardb@kernel.org>
    x86/boot: Sanitize boot params before parsing command line

Ard Biesheuvel <ardb@kernel.org>
    x86/boot: Rename conflicting 'boot_params' pointer to 'boot_params_ptr'

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Reset IMA_NONACTION_RULE_FLAGS after post_setattr

Xi Ruoyao <xry111@xry111.site>
    x86/mm: Don't disable PCID when INVLPG has been fixed by microcode

Jiri Olsa <jolsa@kernel.org>
    uprobes: Fix race in uprobe_free_utask

Imre Deak <imre.deak@intel.com>
    drm/i915/dsi: Use TRANS_DDI_FUNC_CTL's own port width macro

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "KVM: PPC: e500: Mark "struct page" dirty in kvmppc_e500_shadow_map()"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "KVM: PPC: e500: Mark "struct page" pfn accessed before dropping mmu_lock"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "KVM: PPC: e500: Use __kvm_faultin_pfn() to handle page faults"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "KVM: e500: always restore irqs"

Samuel Holland <samuel.holland@sifive.com>
    riscv: Save/restore envcfg CSR during CPU suspend

Samuel Holland <samuel.holland@sifive.com>
    riscv: Fix enabling cbo.zero when running in M-mode

Arnd Bergmann <arnd@arndb.de>
    ALSA: hda: realtek: fix incorrect IS_REACHABLE() usage

Arnd Bergmann <arnd@arndb.de>
    kbuild: hdrcheck: fix cross build with clang

Ryan Roberts <ryan.roberts@arm.com>
    arm64: hugetlb: Fix huge_ptep_get_and_clear() for non-present ptes

Ryan Roberts <ryan.roberts@arm.com>
    mm: hugetlb: Add huge page size param to huge_ptep_get_and_clear()

Nayab Sayed <nayabbasha.sayed@microchip.com>
    iio: adc: at91-sama5d2_adc: fix sama7g5 realbits value

Angelo Dureghello <adureghello@baylibre.com>
    iio: dac: ad3552r: clear reset status flag

Sam Winchenbach <swinchenbach@arka.org>
    iio: filter: admv8818: Force initialization of SDO

Haoyu Li <lihaoyu499@gmail.com>
    drivers: virt: acrn: hsm: Use kzalloc to avoid info leak in pmcmd_ioctl

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    eeprom: digsy_mtc: Make GPIO lookup table match the device

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: host: pci_generic: Use pci_try_reset_function() to avoid deadlock

Visweswara Tanuku <quic_vtanuku@quicinc.com>
    slimbus: messaging: Free transaction ID in delayed interrupt scenario

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drivers: core: fix device leak in __fw_devlink_relax_cycles()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    char: misc: deallocate static minor in error path

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Panther Lake-P/U support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Panther Lake-H support

Pawel Chmielewski <pawel.chmielewski@intel.com>
    intel_th: pci: Add Arrow Lake support

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add panther lake P DID

Qiu-ji Chen <chenqiuji666@gmail.com>
    cdx: Fix possible UAF error in driver_override_show()

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: x86: Explicitly zero EAX and EBX when PERFMON_V2 isn't supported by KVM

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Suppress DEBUGCTL.BTF on AMD

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Drop DEBUGCTL[5:2] from guest's effective value

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Enable the TRB overfetch quirk on VIA VL805

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    xhci: pci: Fix indentation in the PCI device ID definitions

Prashanth K <prashanth.k@oss.qualcomm.com>
    usb: gadget: Check bmAttributes only if configuration is valid

Marek Szyprowski <m.szyprowski@samsung.com>
    usb: gadget: Fix setting self-powered state on suspend

Prashanth K <prashanth.k@oss.qualcomm.com>
    usb: gadget: Set self-powered based on MaxPower and bmAttributes

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    usb: typec: tcpci_rt1711h: Unmask alert interrupts to fix functionality

Fedor Pchelkin <boddah8794@gmail.com>
    usb: typec: ucsi: increase timeout for PPM reset operations

Badhri Jagan Sridharan <badhri@google.com>
    usb: dwc3: gadget: Prevent irq storm when TH re-executes

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: Set SUSPENDENABLE soon after phy init

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    usb: atm: cxacru: fix a flaw in existing endpoint checks

Prashanth K <prashanth.k@oss.qualcomm.com>
    usb: gadget: u_ether: Set is_suspend flag if remote wakeup fails

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    usb: renesas_usbhs: Flush the notify_hotplug_work

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: ucsi: Fix NULL pointer access

Miao Li <limiao@kylinos.cn>
    usb: quirks: Add DELAY_INIT and NO_LPM for Prolific Mass Storage Card Reader

Pawel Laszczak <pawell@cadence.com>
    usb: hub: lack of clearing xHC resources

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    usb: renesas_usbhs: Use devm_usb_get_phy()

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    usb: renesas_usbhs: Call clk_put()

Christian Heusel <christian@heusel.eu>
    Revert "drivers/card_reader/rtsx_usb: Restore interrupt based detection"

Fabrizio Castro <fabrizio.castro.jz@renesas.com>
    gpio: rcar: Fix missing of_node_put() call

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: fix missing dst ref drop in ila lwtunnel

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: fix dst ref loop in ila lwtunnel

Lorenzo Bianconi <lorenzo@kernel.org>
    net: dsa: mt7530: Fix traffic flooding for MMIO devices

Zecheng Li <zecheng@google.com>
    sched/fair: Fix potential memory corruption in child_cfs_rq_on_list

Uday Shankar <ushankar@purestorage.com>
    ublk: set_params: properly check if parameters can be applied

Jason Xing <kerneljasonxing@gmail.com>
    net-timestamp: support TCP GSO case for a few missing flags

Namjae Jeon <linkinjeon@kernel.org>
    exfat: fix soft lockup in exfat_clear_bitmap

Jarkko Sakkinen <jarkko@kernel.org>
    x86/sgx: Fix size overflows in sgx_encl_create()

Oscar Maes <oscmaes92@gmail.com>
    vlan: enforce underlying device type

Jiayuan Chen <jiayuan.chen@linux.dev>
    ppp: Fix KMSAN uninit-value warning with bpf

Luca Weiss <luca.weiss@fairphone.com>
    net: ipa: Enable checksum for IPA_ENDPOINT_AP_MODEM_{RX,TX} for v4.7

Luca Weiss <luca.weiss@fairphone.com>
    net: ipa: Fix QSB data for v4.7

Luca Weiss <luca.weiss@fairphone.com>
    net: ipa: Fix v4.7 resource group names

Vicki Pfau <vi@endrift.com>
    HID: hid-steam: Fix use-after-free when detaching device

Peiyang Wang <wangpeiyang1@huawei.com>
    net: hns3: make sure ptp clock is unregister and freed if hclge_ptp_get_cycle returns an error

Nikolay Aleksandrov <razor@blackwall.org>
    be2net: fix sleeping while atomic bugs in be_ndo_bridge_getlink

Philipp Stanner <phasta@kernel.org>
    drm/sched: Fix preprocessor guard

Xinghuo Chen <xinghuo.chen@foxmail.com>
    hwmon: fix a NULL vs IS_ERR_OR_NULL() check in xgene_hwmon_probe()

Eric Dumazet <edumazet@google.com>
    llc: do not use skb_get() before dev_queue_xmit()

Murad Masimov <m.masimov@mt-integration.ru>
    ALSA: usx2y: validate nrpacks module parameter on probe

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: probe-events: Remove unused MAX_ARG_BUF_LEN macro

Erik Schumacher <erik.schumacher@iris-sensing.com>
    hwmon: (ad7314) Validate leading zero bits and return error

Maud Spierings <maudspierings@gocontroll.com>
    hwmon: (ntc_thermistor) Fix the ncpXXxh103 sensor table

Titus Rwantare <titusr@google.com>
    hwmon: (pmbus) Initialise page count in pmbus_identify()

Peter Zijlstra <peterz@infradead.org>
    perf/core: Fix pmus_lock vs. pmus_srcu ordering

Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
    caif_virtio: fix wrong pointer check in cfv_probe()

Antoine Tenart <atenart@kernel.org>
    net: gso: fix ownership in __udp_gso_segment

Meir Elisha <meir.elisha@volumez.com>
    nvmet-tcp: Fix a possible sporadic response drops in weakly ordered arch

Salah Triki <salah.triki@gmail.com>
    bluetooth: btusb: Initialize .owner field of force_poll_sync_fops

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: Fix use-after-free issue in ishtp_hid_remove()

Yu-Chun Lin <eleanor15x@gmail.com>
    HID: google: fix unused variable warning under !CONFIG_ACPI

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: limit printed string from FW file

Ryan Roberts <ryan.roberts@arm.com>
    mm: don't skip arch_sync_kernel_mappings() in error paths

Hao Zhang <zhanghao1@kylinos.cn>
    mm/page_alloc: fix uninitialized variable

Olivier Gayot <olivier.gayot@canonical.com>
    block: fix conversion of GPT partition name to 7-bit

Mike Snitzer <snitzer@kernel.org>
    NFS: fix nfs_release_folio() to not deadlock via kcompactd writeback

Heiko Carstens <hca@linux.ibm.com>
    s390/traps: Fix test_monitor_call() inline assembly

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    dma: kmsan: export kmsan_handle_dma() for modules

Haoxiang Li <haoxiang_li2024@163.com>
    rapidio: fix an API misues when rio_add_net() fails

Haoxiang Li <haoxiang_li2024@163.com>
    rapidio: add check for rio_add_net() in rio_scan_alloc_net()

Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
    wifi: nl80211: reject cooked mode if it is set along with other flags

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    wifi: cfg80211: regulatory: improve invalid hints checking

Haoxiang Li <haoxiang_li2024@163.com>
    Bluetooth: Add check for mgmt_alloc_skb() in mgmt_device_connected()

Haoxiang Li <haoxiang_li2024@163.com>
    Bluetooth: Add check for mgmt_alloc_skb() in mgmt_remote_name()

Krister Johansen <kjlx@templeofstupid.com>
    mptcp: fix 'scheduling while atomic' in mptcp_pm_nl_append_new_local_addr

Ahmed S. Darwish <darwi@linutronix.de>
    x86/cpu: Properly parse CPUID leaf 0x2 TLB descriptor 0x63

Ahmed S. Darwish <darwi@linutronix.de>
    x86/cpu: Validate CPUID leaf 0x2 EDX output

Ahmed S. Darwish <darwi@linutronix.de>
    x86/cacheinfo: Validate CPUID leaf 0x2 EDX output

Mingcong Bai <jeffbai@aosc.io>
    platform/x86: thinkpad_acpi: Add battery quirk for ThinkPad X131e

Richard Thier <u9vata@gmail.com>
    drm/radeon: Fix rs400_gpu_init for ATI mobility radeon Xpress 200M

Ma Ke <make24@iscas.ac.cn>
    drm/amd/display: Fix null check for pipe_ctx->plane_state in resource_build_scaling_params

Paul Fertser <fercerpav@gmail.com>
    hwmon: (peci/dimmtemp) Do not provide fake thresholds data

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: update ALC222 depop optimize

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - add supported Mic Mute LED for Lenovo platform

Hoku Ishibe <me@hokuishi.be>
    ALSA: hda: intel: Add Dell ALC3271 to power_save denylist

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Avoid module auto-load handling at event delivery

Koichiro Den <koichiro.den@canonical.com>
    gpio: aggregator: protect driver attr handlers against module unload

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    gpio: rcar: Use raw_spinlock to protect register access

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix bug on trap in smb2_lock

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in smb2_lock

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix out-of-bounds in parse_sec_desc()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix type confusion via race condition when using ipc_msg_send_request

Daniil Dulov <d.dulov@aladdin.ru>
    HID: appleir: Fix potential NULL dereference at raw event handle

Bibo Mao <maobibo@loongson.cn>
    LoongArch: Set max_pfn with the PFN of the last page

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Use polling play_dead() when resuming from hibernation

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Convert unreachable() to BUG()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: tprobe-events: Fix a memory leak when tprobe with $retval

Rob Herring (Arm) <robh@kernel.org>
    Revert "of: reserved-memory: Fix using wrong number of cells to get property 'alignment'"

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Add some forgotten models to the SHA check

Yong-Xuan Wang <yongxuan.wang@sifive.com>
    riscv: signal: fix signal_minsigstksz

Andrew Jones <ajones@ventanamicro.com>
    RISC-V: Enable cbo.zero in usermode

Rob Herring <robh@kernel.org>
    riscv: cacheinfo: Use of_property_present() for non-boolean properties

Miquel Sabaté Solà <mikisabate@gmail.com>
    riscv: Prevent a bad reference count on CPU nodes

Yunhui Cui <cuiyunhui@bytedance.com>
    riscv: cacheinfo: initialize cacheinfo's level and type from ACPI PPTT

Yunhui Cui <cuiyunhui@bytedance.com>
    riscv: cacheinfo: remove the useless input parameter (node) of ci_leaf_init()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: O_DIRECT writes must check and adjust the file length

Waiman Long <longman@redhat.com>
    x86/speculation: Add __update_spec_ctrl() helper

Wei Fang <wei.fang@nxp.com>
    net: enetc: VFs do not support HWTSTAMP_TX_ONESTEP_SYNC

Martyn Welch <martyn.welch@collabora.com>
    net: enetc: Replace ifdef with IS_ENABLED

Gal Pressman <gal@nvidia.com>
    net: enetc: Remove setting of RX software timestamp

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: disable BAR resize on Dell G5 SE

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Check extended configuration space register when system uses large bar

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Inspect header requirements before using scrq direct

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Perform tx CSO during send scrq direct

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix chmod(2) regression with ATTR_READONLY

Farouk Bouabid <farouk.bouabid@theobroma-systems.com>
    arm64: dts: rockchip: add rs485 support on uart5 of px30-ringneck-haikou

Imre Deak <imre.deak@intel.com>
    drm/i915/ddi: Fix HDMI port width programming in DDI_BUF_CTL

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/i915/xe2lpd: Move D2D enable/disable

Peter Jones <pjones@redhat.com>
    efi: Don't map the entire mokvar table to determine its size

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/amd_nb: Use rdmsr_safe() in amd_get_mmconfig_range()


-------------

Diffstat:

 Makefile                                           |   9 +-
 .../boot/dts/rockchip/px30-ringneck-haikou.dts     |   1 +
 arch/arm64/include/asm/hugetlb.h                   |   4 +-
 arch/arm64/mm/hugetlbpage.c                        |  59 +++---
 arch/loongarch/include/asm/hugetlb.h               |   6 +-
 arch/loongarch/kernel/machine_kexec.c              |   4 +-
 arch/loongarch/kernel/setup.c                      |   3 +
 arch/loongarch/kernel/smp.c                        |  47 ++++-
 arch/mips/include/asm/hugetlb.h                    |   6 +-
 arch/parisc/include/asm/hugetlb.h                  |   2 +-
 arch/parisc/mm/hugetlbpage.c                       |   2 +-
 arch/powerpc/include/asm/hugetlb.h                 |   6 +-
 arch/powerpc/kvm/e500_mmu_host.c                   |  21 ++-
 arch/riscv/include/asm/cpufeature.h                |   1 +
 arch/riscv/include/asm/csr.h                       |   3 +
 arch/riscv/include/asm/hugetlb.h                   |   3 +-
 arch/riscv/include/asm/hwcap.h                     |  16 ++
 arch/riscv/include/asm/suspend.h                   |   1 +
 arch/riscv/kernel/cacheinfo.c                      |  54 ++++--
 arch/riscv/kernel/cpufeature.c                     |   6 +
 arch/riscv/kernel/setup.c                          |   6 +-
 arch/riscv/kernel/smpboot.c                        |   4 +
 arch/riscv/kernel/suspend.c                        |   4 +
 arch/riscv/mm/hugetlbpage.c                        |   2 +-
 arch/s390/include/asm/hugetlb.h                    |  17 +-
 arch/s390/kernel/traps.c                           |   6 +-
 arch/s390/mm/hugetlbpage.c                         |   4 +-
 arch/sparc/include/asm/hugetlb.h                   |   2 +-
 arch/sparc/mm/hugetlbpage.c                        |   2 +-
 arch/x86/boot/compressed/acpi.c                    |  14 +-
 arch/x86/boot/compressed/cmdline.c                 |   4 +-
 arch/x86/boot/compressed/ident_map_64.c            |   7 +-
 arch/x86/boot/compressed/kaslr.c                   |  26 +--
 arch/x86/boot/compressed/mem.c                     |   6 +-
 arch/x86/boot/compressed/misc.c                    |  26 +--
 arch/x86/boot/compressed/misc.h                    |   1 -
 arch/x86/boot/compressed/pgtable_64.c              |  11 +-
 arch/x86/boot/compressed/sev.c                     |   2 +-
 arch/x86/include/asm/boot.h                        |   2 +
 arch/x86/include/asm/spec-ctrl.h                   |  11 ++
 arch/x86/kernel/amd_nb.c                           |   9 +-
 arch/x86/kernel/cpu/cacheinfo.c                    |   2 +-
 arch/x86/kernel/cpu/intel.c                        |  52 ++++--
 arch/x86/kernel/cpu/microcode/amd.c                |   6 +
 arch/x86/kernel/cpu/sgx/ioctl.c                    |   7 +
 arch/x86/kvm/cpuid.c                               |   2 +-
 arch/x86/kvm/svm/svm.c                             |  21 +++
 arch/x86/kvm/svm/svm.h                             |   2 +-
 arch/x86/mm/init.c                                 |  23 ++-
 block/partitions/efi.c                             |   2 +-
 drivers/base/core.c                                |   1 +
 drivers/block/ublk_drv.c                           |   7 +-
 drivers/bluetooth/btusb.c                          |   1 +
 drivers/bus/mhi/host/pci_generic.c                 |   5 +-
 drivers/cdx/cdx.c                                  |   6 +-
 drivers/char/misc.c                                |   2 +-
 drivers/firmware/efi/libstub/x86-stub.c            |   2 +-
 drivers/firmware/efi/libstub/x86-stub.h            |   2 -
 drivers/firmware/efi/mokvar-table.c                |  42 ++---
 drivers/gpio/gpio-aggregator.c                     |  20 ++-
 drivers/gpio/gpio-rcar.c                           |  31 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  11 ++
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   3 +-
 drivers/gpu/drm/i915/display/icl_dsi.c             |   4 +-
 drivers/gpu/drm/i915/display/intel_ddi.c           |  46 +++--
 drivers/gpu/drm/i915/i915_reg.h                    |   4 +-
 drivers/gpu/drm/radeon/r300.c                      |   3 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   1 +
 drivers/gpu/drm/radeon/rs400.c                     |  18 +-
 drivers/gpu/drm/scheduler/gpu_scheduler_trace.h    |   4 +-
 drivers/hid/hid-appleir.c                          |   2 +-
 drivers/hid/hid-google-hammer.c                    |   2 +
 drivers/hid/hid-steam.c                            |   2 +-
 drivers/hid/intel-ish-hid/ishtp-hid.c              |   4 +-
 drivers/hwmon/ad7314.c                             |  10 ++
 drivers/hwmon/ntc_thermistor.c                     |  66 +++----
 drivers/hwmon/peci/dimmtemp.c                      |  10 +-
 drivers/hwmon/pmbus/pmbus.c                        |   2 +
 drivers/hwmon/xgene-hwmon.c                        |   2 +-
 drivers/hwtracing/intel_th/pci.c                   |  15 ++
 drivers/iio/adc/at91-sama5d2_adc.c                 |  68 ++++---
 drivers/iio/dac/ad3552r.c                          |   6 +
 drivers/iio/filter/admv8818.c                      |  14 +-
 drivers/misc/cardreader/rtsx_usb.c                 |  15 --
 drivers/misc/eeprom/digsy_mtc_eeprom.c             |   2 +-
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/net/caif/caif_virtio.c                     |   2 +-
 drivers/net/dsa/mt7530.c                           |   8 +-
 drivers/net/ethernet/emulex/benet/be.h             |   2 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        | 197 ++++++++++-----------
 drivers/net/ethernet/emulex/benet/be_main.c        |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  25 ++-
 drivers/net/ethernet/freescale/enetc/enetc.h       |   9 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |  27 +--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  21 ++-
 drivers/net/ipa/data/ipa_data-v4.7.c               |  18 +-
 drivers/net/ppp/ppp_generic.c                      |  28 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +-
 drivers/nvme/target/tcp.c                          |  15 +-
 drivers/of/of_reserved_mem.c                       |   4 +-
 drivers/platform/x86/thinkpad_acpi.c               |   1 +
 drivers/rapidio/devices/rio_mport_cdev.c           |   3 +-
 drivers/rapidio/rio-scan.c                         |   5 +-
 drivers/slimbus/messaging.c                        |   5 +-
 drivers/spi/spi-mxs.c                              |   3 +-
 drivers/usb/atm/cxacru.c                           |  13 +-
 drivers/usb/core/hub.c                             |  33 ++++
 drivers/usb/core/quirks.c                          |   4 +
 drivers/usb/dwc3/core.c                            |  85 +++++----
 drivers/usb/dwc3/core.h                            |   2 +-
 drivers/usb/dwc3/drd.c                             |   4 +-
 drivers/usb/dwc3/gadget.c                          |  10 +-
 drivers/usb/gadget/composite.c                     |  17 +-
 drivers/usb/gadget/function/u_ether.c              |   4 +-
 drivers/usb/host/xhci-mem.c                        |   3 +-
 drivers/usb/host/xhci-pci.c                        |  18 +-
 drivers/usb/host/xhci.h                            |   2 +-
 drivers/usb/renesas_usbhs/common.c                 |   6 +-
 drivers/usb/renesas_usbhs/mod_gadget.c             |   2 +-
 drivers/usb/typec/tcpm/tcpci_rt1711h.c             |  11 ++
 drivers/usb/typec/ucsi/ucsi.c                      |  15 +-
 drivers/virt/acrn/hsm.c                            |   6 +-
 fs/exfat/balloc.c                                  |  10 +-
 fs/exfat/exfat_fs.h                                |   2 +-
 fs/exfat/fatent.c                                  |  11 +-
 fs/nfs/direct.c                                    |  19 ++
 fs/nfs/file.c                                      |   3 +-
 fs/smb/client/inode.c                              |   4 +-
 fs/smb/server/smb2pdu.c                            |   8 +-
 fs/smb/server/smbacl.c                             |  16 ++
 fs/smb/server/transport_ipc.c                      |   1 +
 include/asm-generic/hugetlb.h                      |   2 +-
 include/linux/compaction.h                         |   5 +
 include/linux/hugetlb.h                            |   4 +-
 include/linux/sched.h                              |   2 +-
 kernel/events/core.c                               |   4 +-
 kernel/events/uprobes.c                            |   2 +-
 kernel/sched/fair.c                                |   6 +-
 kernel/trace/trace_fprobe.c                        |   2 +
 kernel/trace/trace_probe.h                         |   1 -
 mm/compaction.c                                    |   3 +
 mm/hugetlb.c                                       |   4 +-
 mm/kmsan/hooks.c                                   |   1 +
 mm/memory.c                                        |   6 +-
 mm/page_alloc.c                                    |   1 +
 mm/vmalloc.c                                       |   4 +-
 net/8021q/vlan.c                                   |   3 +-
 net/bluetooth/mgmt.c                               |   5 +
 net/ipv4/tcp_offload.c                             |  11 +-
 net/ipv4/udp_offload.c                             |   8 +-
 net/ipv6/ila/ila_lwt.c                             |   4 +-
 net/llc/llc_s_ac.c                                 |  49 ++---
 net/mptcp/pm_netlink.c                             |  18 +-
 net/sched/sch_fifo.c                               |   3 +
 net/wireless/nl80211.c                             |   5 +
 net/wireless/reg.c                                 |   3 +-
 security/integrity/ima/ima_main.c                  |   7 +-
 security/integrity/integrity.h                     |   3 +
 sound/core/seq/seq_clientmgr.c                     |  46 +++--
 sound/pci/hda/Kconfig                              |   1 +
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_realtek.c                      |  99 ++++++++++-
 sound/usb/usx2y/usbusx2y.c                         |  11 ++
 sound/usb/usx2y/usbusx2y.h                         |  26 +++
 sound/usb/usx2y/usbusx2yaudio.c                    |  27 ---
 usr/include/Makefile                               |   2 +-
 168 files changed, 1335 insertions(+), 707 deletions(-)


