Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1E756458;
	Thu, 13 Jun 2024 12:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280317; cv=none; b=q1jZGSzjc4xW+TaJ7KxEd59TulpiqggDmkG9K6BKPRqplUwFT6ihyWJFN/4q0zWYDjaBxBXeD7MVBTOyRmu6AkKlfJ+JKdoTNn4IQPInRWCQLfjWMsv3x5aQo8hnZhU0sxH7jg1hWeV2zp+DEOxzg/BLT3VoaYfF3tu7jEqIDW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280317; c=relaxed/simple;
	bh=SK0Vs/B7GBJ1e5JQQ5qFPF4xDwS0Uul9JI2yPSlf0YM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GpXxaa4HdTS/uaMJP8XiHUsdC0+8NUWvb4yqGdkhJlLjo2laUMRnAUYxQpam3c82pDZfdBCszyKK4S5ICz5ex87S80E7cePIiCC+sI6hCNiIYz7OtugjHmHnLOwMS9ed7YHAk9C08v7GB2yjMCFOwok/PIoXNww1uTT6b2EJxdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+QqAkdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+QqAkdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12087C32786;
	Thu, 13 Jun 2024 12:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280317;
	bh=SK0Vs/B7GBJ1e5JQQ5qFPF4xDwS0Uul9JI2yPSlf0YM=;
	h=From:To:Cc:Subject:Date:From;
	b=u+QqAkdOEFym1lIsrcMvarbawhk57T62c8V/ANGXIJ61Lfd09Dz5mojMaVNu1S2SR
	 rlVUrjHtSUxOyRk4ZjYgfAOJma0M/Bu2D2IC+dEeVgXGut9hYvHXiUzRGsMsf3BDMd
	 G5Qck+pATbgXJxBUjRLRgGNKgXcVRzN0dWMu4RTU=
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
Subject: [PATCH 6.6 000/137] 6.6.34-rc1 review
Date: Thu, 13 Jun 2024 13:33:00 +0200
Message-ID: <20240613113223.281378087@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.34-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.34-rc1
X-KernelTest-Deadline: 2024-06-15T11:32+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.34 release.
There are 137 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.34-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.34-rc1

Paolo Abeni <pabeni@redhat.com>
    selftests: net: more strict check in net_helper

Enzo Matsumiya <ematsumiya@suse.de>
    smb: client: fix deadlock in smb2_find_smb_tcon()

Puranjay Mohan <puranjay@kernel.org>
    powerpc/bpf: enforce full ordering for ATOMIC operations with BPF_FETCH

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/64/bpf: fix tail calls for PCREL addressing

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix incorrect UMP type for system messages

Filipe Manana <fdmanana@suse.com>
    btrfs: fix leak of qgroup extent records after transaction abort

Omar Sandoval <osandov@fb.com>
    btrfs: fix crash on racing fsync and size-extending write into prealloc

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracefs: Clear EVENT_INODE flag in tracefs_drop_inode()

Steven Rostedt (Google) <rostedt@goodmis.org>
    eventfs: Keep the directories from having the same inode number as files

Hao Ge <gehao@kylinos.cn>
    eventfs: Fix a possible null pointer dereference in eventfs_find_events()

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFS: Fix READ_PLUS when server doesn't support OP_READ_PLUS

Sergey Shtylyov <s.shtylyov@omp.ru>
    nfs: fix undefined behavior in nfs_block_bits()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    EDAC/igen6: Convert PCIBIOS_* return codes to errnos

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    EDAC/amd64: Convert PCIBIOS_* return codes to errnos

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Don't accept an invalid UMP protocol number

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Don't clear bank selection after sending a program change

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Fix input format query of process modules without base extension

dicken.ding <dicken.ding@mediatek.com>
    genirq/irqdesc: Prevent use-after-free in irq_find_at_or_after()

Frank Li <Frank.Li@nxp.com>
    i3c: master: svc: fix invalidate IBI type and miss call client IBI handler

Harald Freudenberger <freude@linux.ibm.com>
    s390/cpacf: Make use of invalid opcode produce a link error

Harald Freudenberger <freude@linux.ibm.com>
    s390/cpacf: Split and rework cpacf query functions

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: Fix crash in AP internal function modify_bitmap()

Helge Deller <deller@kernel.org>
    parisc: Define sigset_t in parisc uapi header

Helge Deller <deller@gmx.de>
    parisc: Define HAVE_ARCH_HUGETLB_UNMAPPED_AREA

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: samsung: exynos4412-origen: fix keypad no-autorepeat

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: samsung: smdk4412: fix keypad no-autorepeat

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: samsung: smdkv310: fix keypad no-autorepeat

Shengyu Qu <wiagn233@outlook.com>
    riscv: dts: starfive: Remove PMIC interrupt info for Visionfive 2 board

Baokun Li <libaokun1@huawei.com>
    ext4: fix mb_cache_entry's e_refcnt leak in ext4_xattr_block_cache_find()

Baokun Li <libaokun1@huawei.com>
    ext4: set type of ac_groups_linear_remaining to __u32 to avoid overflow

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    ext4: Fixes len calculation in mpage_journal_page_buffers

Lang Yu <Lang.Yu@amd.com>
    drm/amdkfd: handle duplicate BOs in reserve_bo_and_cond_vms

Mike Gilbert <floppym@gentoo.org>
    sparc: move struct termio to asm/termios.h

Hui Wang <hui.wang@canonical.com>
    e1000e: move force SMBUS near the end of enable_ulp function

Eric Dumazet <edumazet@google.com>
    net: fix __dst_negative_advice() race

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Use format-specifiers rather than memset() for padding in kdb_read()

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Merge identical case statements in kdb_read()

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Fix console handling when editing and tab-completing commands

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Use format-strings rather than '\0' injection in kdb_read()

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Fix buffer overflow during tab-complete

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    wifi: ath10k: fix QCOM_RPROC_COMMON dependency

Tony Battersby <tonyb@cybernetics.com>
    bonding: fix oops during rmmod

Judith Mendez <jm@ti.com>
    watchdog: rti_wdt: Set min_hw_heartbeat_ms to accommodate a safety margin

Michael Ellerman <mpe@ellerman.id.au>
    selftests/mm: fix build warnings on ppc64

Dev Jain <dev.jain@arm.com>
    selftests/mm: compaction_test: fix incorrect write of zero to nr_hugepages

Hailong.Liu <hailong.liu@oppo.com>
    mm/vmalloc: fix vmalloc which may return null if called with __GFP_NOFAIL

Yuanyuan Zhong <yzhong@purestorage.com>
    mm: /proc/pid/smaps_rollup: avoid skipping vma after getting mmap_lock again

Frank van der Linden <fvdl@google.com>
    mm/hugetlb: pass correct order_per_bit to cma_declare_contiguous_nid

Frank van der Linden <fvdl@google.com>
    mm/cma: drop incorrect alignment check in cma_init_reserved_mem

Sam Ravnborg <sam@ravnborg.org>
    sparc64: Fix number of online CPUs

John Kacur <jkacur@redhat.com>
    rtla/timerlat: Fix histogram report when a cpu count is 0

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Meteor Lake-S CPU support

Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
    cpufreq: amd-pstate: Fix the inconsistency in max frequency units

Jan Beulich <jbeulich@suse.com>
    tpm_tis: Do *not* flush uninitialized work

Alexander Potapenko <glider@google.com>
    kmsan: do not wipe out origin when doing partial unpoisoning

Chengming Zhou <chengming.zhou@linux.dev>
    mm/ksm: fix ksm_zero_pages accounting

Chengming Zhou <chengming.zhou@linux.dev>
    mm/ksm: fix ksm_pages_scanned accounting

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    net/9p: fix uninit-value in p9_client_rpc()

xu xin <xu.xin16@zte.com.cn>
    net/ipv6: Fix route deleting failure when metric equals 0

Martin K. Petersen <martin.petersen@oracle.com>
    scsi: core: Handle devices which return an unusually large VPD page count

Johan Hovold <johan+linaro@kernel.org>
    HID: i2c-hid: elan: fix reset suspend current leakage

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    i2c: acpi: Unbind mux adapters before delete

Xu Yang <xu.yang_2@nxp.com>
    iomap: fault in smaller chunks for non-large folio mappings

Xu Yang <xu.yang_2@nxp.com>
    filemap: add helper mapping_max_folio_size()

Ryan Roberts <ryan.roberts@arm.com>
    mm: fix race between __split_huge_pmd_locked() and GUP-fast

Nathan Chancellor <nathan@kernel.org>
    kbuild: Remove support for Clang's ThinLTO caching

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: qat - Fix ADF_DEV_RESET_SYNC memory leak

Vitaly Chikunov <vt@altlinux.org>
    crypto: ecrdsa - Fix module auto-load on add_key

Stefan Berger <stefanb@linux.ibm.com>
    crypto: ecdsa - Fix module auto-load on add-key

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: clk-alpha-pll: fix rate setting for Stromer PLLs

Nathan Chancellor <nathan@kernel.org>
    clk: bcm: rpi: Assign ->num before accessing ->hws

Nathan Chancellor <nathan@kernel.org>
    clk: bcm: dvp: Assign ->num before accessing ->hws

Jiaxun Yang <jiaxun.yang@flygoat.com>
    LoongArch: Override higher address bits in JUMP_VIRT_ADDR

Jiaxun Yang <jiaxun.yang@flygoat.com>
    LoongArch: Add all CPUs enabled by fdt to NUMA node 0

Marc Zyngier <maz@kernel.org>
    KVM: arm64: AArch32: Fix spurious trapping of conditional instructions

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix AArch32 register narrowing on userspace write

Sean Christopherson <seanjc@google.com>
    KVM: SVM: WARN on vNMI + NMI window iff NMIs are outright masked

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amdkfd: fix gfx_target_version for certain 11.0.3 devices"

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Fix shutdown (again) on some SMU v13.0.4/11 platforms

Dominique Martinet <asmadeus@codewreck.org>
    9p: add missing locking around taking dentry fid list

Li Ma <li.ma@amd.com>
    drm/amdgpu/atomfirmware: add intergrated info v2.3 table

Cai Xinchen <caixinchen1@huawei.com>
    fbdev: savage: Handle err return when savagefb_check_var failed

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fbdev-generic: Do not set physical framebuffer address

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-acpi: Add quirk to enable pull-up on the card-detect GPIO on Asus T100TA

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-acpi: Disable write protect detection on Toshiba WT10-A

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-acpi: Fix Lenovo Yoga Tablet 2 Pro 1380 sdcard slot not working

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-acpi: Sort DMI quirks alphabetically

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Add support for "Tuning Error" interrupts

Hans de Goede <hdegoede@redhat.com>
    mmc: core: Add mmc_gpiod_set_cd_config() function

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mmc: davinci: Don't strip remove function when driver is builtin

Alexander Stein <alexander.stein@ew.tq-group.com>
    media: v4l: async: Fix notifier list entry init

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: async: Don't set notifier's V4L2 device if registering fails

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: async: Properly re-initialise notifier entry in unregister

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-core: hold videodev_lock until dev reg, finishes

Nathan Chancellor <nathan@kernel.org>
    media: mxl5xx: Move xpt structures off stack

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: mc: mark the media devnode as registered from the, start

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: mc: Fix graph walk in media_pipeline_start

Max Krummenacher <max.krummenacher@toradex.com>
    arm64: dts: ti: verdin-am62: Set memory size to 2gb

Yang Xiwen <forbidden405@outlook.com>
    arm64: dts: hi3798cv200: fix the size of GICR

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sc8280xp: add missing PCIe minimum OPP

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8192de: Fix endianness issue in RX path

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8192de: Fix low speed with WPA3-SAE

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8192de: Fix 5 GHz TX power

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix the TX power of RTL8192CU, RTL8723AU

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: correct TX resource checking for PCI DMA channel of firmware command

Yu Kuai <yukuai3@huawei.com>
    md/raid5: fix deadlock that raid5d() wait for itself to clear MD_SB_CHANGE_PENDING

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: qcs404: fix bluetooth device address

Krzysztof Kozlowski <krzk@kernel.org>
    arm64: tegra: Correct Tegra132 I2C alias

Christoffer Sandberg <cs@tuxedo.de>
    ACPI: resource: Do IRQ override on TongFang GXxHRXx and GMxHGxx

Maulik Shah <quic_mkshah@quicinc.com>
    soc: qcom: rpmh-rsc: Enhance check for VRM in-flight request

Konrad Dybcio <konrad.dybcio@linaro.org>
    thermal/drivers/qcom/lmh: Check for SCM availability at probe

Karthikeyan Ramasubramanian <kramasub@chromium.org>
    platform/chrome: cros_ec: Handle events during suspend after resume completion

Tyler Hicks (Microsoft) <code@tyhicks.com>
    proc: Move fdinfo PTRACE_MODE_READ check into the inode .permission operation

Eric Biggers <ebiggers@google.com>
    fsverity: use register_sysctl_init() to avoid kmemleak warning

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: pata_legacy: make legacy_exit() work again

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: correct aSIFSTime for 6GHz band

Matthew Mirvish <matthew@mm12.xyz>
    bcache: fix variable length array abuse in btree_iter

Bob Zhou <bob.zhou@amd.com>
    drm/amdgpu: add error handle to avoid out-of-bounds

Zheyu Ma <zheyuma97@gmail.com>
    media: lgdt3306a: Add a check against null-pointer-def

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on i_xattr_nid in sanity_check_inode()

Maxime Ripard <mripard@kernel.org>
    drm/sun4i: hdmi: Move mode_set into enable

Maxime Ripard <mripard@kernel.org>
    drm/sun4i: hdmi: Convert encoder to atomic

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: net: List helper scripts in TEST_FILES Makefile variable

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: net: included needed helper in the install targets

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests/net: synchronize udpgro tests' tx and rx connection

Daniel Borkmann <daniel@iogearbox.net>
    vxlan: Fix regression when dropping packets due to invalid src addresses

Shakeel Butt <shakeelb@google.com>
    mm: ratelimit stat flush from workingset shrinker

Gao Xiang <xiang@kernel.org>
    erofs: avoid allocating DEFLATE streams before mounting

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: fix full TCP keep-alive support

Paolo Abeni <pabeni@redhat.com>
    mptcp: cleanup SOL_TCP handling

Paolo Abeni <pabeni@redhat.com>
    mptcp: avoid some duplicate code in socket option handling

Haorong Lu <ancientmodern4@gmail.com>
    riscv: signal: handle syscall restart before get_signal

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: sfp-bus: fix SFP mode detect from bitrate

Marc Dionne <marc.dionne@auristor.com>
    afs: Don't cross .backup mountpoint from backup volume

Jorge Ramirez-Ortiz <jorge@foundries.io>
    mmc: core: Do not force a retune before RPMB switch

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/i915/hwmon: Get rid of devm


-------------

Diffstat:

 Documentation/mm/arch_pgtable_helpers.rst          |   6 +-
 Makefile                                           |   9 +-
 arch/arm/boot/dts/samsung/exynos4210-smdkv310.dts  |   2 +-
 arch/arm/boot/dts/samsung/exynos4412-origen.dts    |   2 +-
 arch/arm/boot/dts/samsung/exynos4412-smdk4412.dts  |   2 +-
 arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi     |   2 +-
 arch/arm64/boot/dts/nvidia/tegra132-norrin.dts     |   4 +-
 arch/arm64/boot/dts/nvidia/tegra132.dtsi           |   2 +-
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi           |   2 +-
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi             |   5 +
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |   2 +-
 arch/arm64/kvm/guest.c                             |   3 +-
 arch/arm64/kvm/hyp/aarch32.c                       |  18 ++-
 arch/loongarch/include/asm/numa.h                  |   1 +
 arch/loongarch/include/asm/stackframe.h            |   2 +-
 arch/loongarch/kernel/smp.c                        |   5 +-
 arch/parisc/include/asm/page.h                     |   1 +
 arch/parisc/include/asm/signal.h                   |  12 --
 arch/parisc/include/uapi/asm/signal.h              |  10 ++
 arch/powerpc/mm/book3s64/pgtable.c                 |   1 +
 arch/powerpc/net/bpf_jit_comp32.c                  |  12 ++
 arch/powerpc/net/bpf_jit_comp64.c                  |  42 ++++---
 .../dts/starfive/jh7110-starfive-visionfive-2.dtsi |   1 -
 arch/riscv/kernel/signal.c                         |  95 ++++++++--------
 arch/s390/include/asm/cpacf.h                      | 109 ++++++++++++++----
 arch/s390/include/asm/pgtable.h                    |   4 +-
 arch/sparc/include/asm/smp_64.h                    |   2 -
 arch/sparc/include/uapi/asm/termbits.h             |  10 --
 arch/sparc/include/uapi/asm/termios.h              |   9 ++
 arch/sparc/kernel/prom_64.c                        |   4 +-
 arch/sparc/kernel/setup_64.c                       |   1 -
 arch/sparc/kernel/smp_64.c                         |  14 ---
 arch/sparc/mm/tlb.c                                |   1 +
 arch/x86/kvm/svm/svm.c                             |  27 +++--
 arch/x86/mm/pgtable.c                              |   2 +
 crypto/ecdsa.c                                     |   3 +
 crypto/ecrdsa.c                                    |   1 +
 drivers/acpi/resource.c                            |  12 ++
 drivers/ata/pata_legacy.c                          |   8 +-
 drivers/char/tpm/tpm_tis_core.c                    |   3 +-
 drivers/clk/bcm/clk-bcm2711-dvp.c                  |   3 +-
 drivers/clk/bcm/clk-raspberrypi.c                  |   2 +-
 drivers/clk/qcom/clk-alpha-pll.c                   |   2 +
 drivers/cpufreq/amd-pstate.c                       |   2 +-
 drivers/crypto/intel/qat/qat_common/adf_aer.c      |  19 +---
 drivers/edac/amd64_edac.c                          |   8 +-
 drivers/edac/igen6_edac.c                          |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c   |  15 +++
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   3 +
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  11 +-
 drivers/gpu/drm/amd/include/atomfirmware.h         |  43 +++++++
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c   |  20 ++--
 drivers/gpu/drm/drm_fbdev_generic.c                |   1 -
 drivers/gpu/drm/i915/i915_hwmon.c                  |  46 +++++---
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c             |  47 ++++----
 drivers/hid/i2c-hid/i2c-hid-of-elan.c              |  59 ++++++++--
 drivers/hwtracing/intel_th/pci.c                   |   5 +
 drivers/i2c/i2c-core-acpi.c                        |  19 +++-
 drivers/i3c/master/svc-i3c-master.c                |  16 ++-
 drivers/md/bcache/bset.c                           |  44 ++++----
 drivers/md/bcache/bset.h                           |  28 +++--
 drivers/md/bcache/btree.c                          |  40 +++----
 drivers/md/bcache/super.c                          |   5 +-
 drivers/md/bcache/sysfs.c                          |   2 +-
 drivers/md/bcache/writeback.c                      |  10 +-
 drivers/md/raid5.c                                 |  15 +--
 drivers/media/dvb-frontends/lgdt3306a.c            |   5 +
 drivers/media/dvb-frontends/mxl5xx.c               |  22 ++--
 drivers/media/mc/mc-devnode.c                      |   5 +-
 drivers/media/mc/mc-entity.c                       |   6 +
 drivers/media/v4l2-core/v4l2-async.c               |  12 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |   3 +
 drivers/mmc/core/host.c                            |   3 +-
 drivers/mmc/core/slot-gpio.c                       |  20 ++++
 drivers/mmc/host/davinci_mmc.c                     |   4 +-
 drivers/mmc/host/sdhci-acpi.c                      |  61 +++++++++-
 drivers/mmc/host/sdhci.c                           |  10 +-
 drivers/mmc/host/sdhci.h                           |   3 +-
 drivers/net/bonding/bond_main.c                    |  13 ++-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  22 ++++
 drivers/net/ethernet/intel/e1000e/netdev.c         |  18 ---
 drivers/net/phy/sfp-bus.c                          |   8 +-
 drivers/net/vxlan/vxlan_core.c                     |   4 -
 drivers/net/wireless/ath/ath10k/Kconfig            |   1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  25 ++---
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |  21 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.h   |  79 ++++---------
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   2 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   3 +-
 drivers/platform/chrome/cros_ec.c                  |  16 +--
 drivers/s390/crypto/ap_bus.c                       |   2 +-
 drivers/scsi/scsi.c                                |   7 ++
 drivers/soc/qcom/cmd-db.c                          |  32 +++++-
 drivers/soc/qcom/rpmh-rsc.c                        |   3 +-
 drivers/thermal/qcom/lmh.c                         |   3 +
 drivers/video/fbdev/savage/savagefb_driver.c       |   5 +-
 drivers/watchdog/rti_wdt.c                         |  34 +++---
 fs/9p/vfs_dentry.c                                 |   9 +-
 fs/afs/mntpt.c                                     |   5 +
 fs/btrfs/disk-io.c                                 |  10 +-
 fs/btrfs/tree-log.c                                |  17 ++-
 fs/erofs/decompressor_deflate.c                    |  55 ++++-----
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/mballoc.h                                  |   2 +-
 fs/ext4/xattr.c                                    |   4 +-
 fs/f2fs/inode.c                                    |   6 +
 fs/iomap/buffered-io.c                             |   2 +-
 fs/nfs/internal.h                                  |   4 +-
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/proc/base.c                                     |   2 +-
 fs/proc/fd.c                                       |  42 ++++---
 fs/proc/task_mmu.c                                 |   9 +-
 fs/smb/client/smb2transport.c                      |   2 +-
 fs/tracefs/event_inode.c                           |  13 ++-
 fs/tracefs/inode.c                                 |  33 +++---
 fs/verity/init.c                                   |   7 +-
 include/linux/ksm.h                                |  17 ++-
 include/linux/mm_types.h                           |   2 +-
 include/linux/mmc/slot-gpio.h                      |   1 +
 include/linux/pagemap.h                            |  34 +++---
 include/net/dst_ops.h                              |   2 +-
 include/net/sock.h                                 |  13 +--
 include/soc/qcom/cmd-db.h                          |  10 +-
 kernel/debug/kdb/kdb_io.c                          |  99 ++++++++++-------
 kernel/irq/irqdesc.c                               |   5 +-
 mm/cma.c                                           |   4 -
 mm/huge_memory.c                                   |  49 ++++----
 mm/hugetlb.c                                       |   6 +-
 mm/kmsan/core.c                                    |  15 ++-
 mm/ksm.c                                           |  17 ++-
 mm/pgtable-generic.c                               |   2 +
 mm/vmalloc.c                                       |   5 +-
 mm/workingset.c                                    |   2 +-
 net/9p/client.c                                    |   2 +
 net/ipv4/route.c                                   |  22 ++--
 net/ipv6/route.c                                   |  34 +++---
 net/mptcp/protocol.h                               |   3 +
 net/mptcp/sockopt.c                                | 123 ++++++++++++++-------
 net/xfrm/xfrm_policy.c                             |  11 +-
 sound/core/seq/seq_ump_convert.c                   |   2 +
 sound/core/ump.c                                   |   7 ++
 sound/core/ump_convert.c                           |   1 -
 sound/soc/sof/ipc4-topology.c                      |   8 ++
 tools/testing/selftests/mm/compaction_test.c       |   2 +
 tools/testing/selftests/mm/gup_test.c              |   1 +
 tools/testing/selftests/mm/uffd-common.h           |   1 +
 tools/testing/selftests/net/Makefile               |   4 +-
 tools/testing/selftests/net/net_helper.sh          |  25 +++++
 tools/testing/selftests/net/udpgro.sh              |  13 +--
 tools/testing/selftests/net/udpgro_bench.sh        |   5 +-
 tools/testing/selftests/net/udpgro_frglist.sh      |   5 +-
 tools/tracing/rtla/src/timerlat_hist.c             |  60 +++++++---
 154 files changed, 1372 insertions(+), 845 deletions(-)


