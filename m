Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFF21B5833;
	Tue, 30 Jul 2024 15:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354714; cv=none; b=i4DBHouSV/z7f1UV/mEiG5tfIkstzjDW4/QvXRMoJr/UBpxUU5c99ToN2iddHiouZeuMqMe/Rgwl9wfO2V5+MshOj5jdHdDpDjqeQNvh01dwxIQxik0k20bu/+irCAmuyOAghyMDPmmSu/5kxDs0f3nhsbUd+Ua6fQVkDd5xQXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354714; c=relaxed/simple;
	bh=7vEEh+kpUqQo4c8hOHRNKKXSRPnbHzxBi9aSTzTHmgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=f9GHgLo0TFViv5b7HmFDS0E0PwKnTmBgALjf03/YWIsVVIKxj1cHZyZyQHHci21aXVtYsnIUSrADc+/FVgf/tJmGtTLaRp5PP7+rzq0+7Co/Rf6g6EKfN2Std+cs4Yye1dO7Zc3H5WbBYRoIuGVse6VQOLtBednAJk0NwoFu1gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqRaJjuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqRaJjuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A10C32782;
	Tue, 30 Jul 2024 15:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354714;
	bh=7vEEh+kpUqQo4c8hOHRNKKXSRPnbHzxBi9aSTzTHmgQ=;
	h=From:To:Cc:Subject:Date:From;
	b=GqRaJjuGcq9Is/xoSZzNHUxRjz6RIT6LvHZVzWWk6i5CJnmMwXcim0fBoODysMDdA
	 HOU8ShYlsh3EGwsnNnIXAvtma/e8NYtu8w4+RPGtREMMdxxbEmJAikTfYMomG/neJS
	 iiOFVl6qnUibcfZWuJF2T+pWkVTeUh95mNcAYFws=
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
Subject: [PATCH 6.6 000/568] 6.6.44-rc1 review
Date: Tue, 30 Jul 2024 17:41:47 +0200
Message-ID: <20240730151639.792277039@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.44-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.44-rc1
X-KernelTest-Deadline: 2024-08-01T15:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.44 release.
There are 568 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.44-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.44-rc1

Seth Forshee (DigitalOcean) <sforshee@kernel.org>
    fs: don't allow non-init s_user_ns for filesystems without FS_USERNS_MOUNT

Leon Romanovsky <leon@kernel.org>
    nvme-pci: add missing condition check for existence of mapped data

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix io_match_task must_hold

Artem Chernyshev <artem.chernyshev@red-soft.ru>
    iommu: sprd: Avoid NULL deref in sprd_iommu_hw_en

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_cf: Fix endless loop in CF_DIAG event stop

Gerd Bayer <gbayer@linux.ibm.com>
    s390/pci: Allow allocation of more than 1 MSI interrupt

Gerd Bayer <gbayer@linux.ibm.com>
    s390/pci: Refactor arch_setup_msi_irqs()

ethanwu <ethanwu@synology.com>
    ceph: fix incorrect kmalloc size of pagevec mempool

Dan Carpenter <dan.carpenter@linaro.org>
    ASoC: TAS2781: Fix tasdev_load_calibrated_data()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: use soc_intel_is_byt_cr() only when IOSF_MBI is reachable

Conor Dooley <conor.dooley@microchip.com>
    spi: spidev: add correct compatible for Rohm BH2228FV

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: sof: amd: fix for firmware reload failure in Vangogh platform

Bart Van Assche <bvanassche@acm.org>
    nvme-pci: Fix the instructions for disabling power management

Steve Wilkins <steve.wilkins@raymarine.com>
    spi: microchip-core: ensure TX and RX FIFOs are empty at start of a transfer

Steve Wilkins <steve.wilkins@raymarine.com>
    spi: microchip-core: fix init function not setting the master and motorola modes

Yang Yingliang <yangyingliang@huawei.com>
    spi: microchip-core: switch to use modern name

Steve Wilkins <steve.wilkins@raymarine.com>
    spi: microchip-core: only disable SPI controller when register value change requires it

Steve Wilkins <steve.wilkins@raymarine.com>
    spi: microchip-core: defer asserting chip select until just before write to TX FIFO

Naga Sureshkumar Relli <nagasuresh.relli@microchip.com>
    spi: microchip-core: fix the issues in the isr

Daniel Baluta <daniel.baluta@nxp.com>
    ASoC: SOF: imx8m: Fix DSP control regmap retrieval

Markus Elfring <elfring@users.sourceforge.net>
    auxdisplay: ht16k33: Drop reference after LED registration

Al Viro <viro@zeniv.linux.org.uk>
    lirc: rc_dev_get_from_fd(): fix file leak

Al Viro <viro@zeniv.linux.org.uk>
    powerpc: fix a file leak in kvm_vcpu_ioctl_enable_cap()

Xiao Liang <shaw.leon@gmail.com>
    apparmor: Fix null pointer deref when receiving skb during sock creation

Dan Carpenter <dan.carpenter@linaro.org>
    mISDN: Fix a use after free in hfcmulti_tx()

Fred Li <dracodingfly@gmail.com>
    bpf: Fix a segment issue when downgrading gso_size

Petr Machata <petrm@nvidia.com>
    net: nexthop: Initialize all fields in dumped nexthops

Simon Horman <horms@kernel.org>
    net: stmmac: Correct byte order of perfect_match

Shigeru Yoshida <syoshida@redhat.com>
    tipc: Return non-zero value from tipc_udp_addr2str() on error

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo_avx2: disable softinterrupts

Wojciech Drewek <wojciech.drewek@intel.com>
    ice: Fix recipe read procedure

Johannes Berg <johannes.berg@intel.com>
    net: bonding: correctly annotate RCU in bond_should_notify_peers()

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix incorrect source address in Record Route option

Gregory CLEMENT <gregory.clement@bootlin.com>
    MIPS: SMP-CPS: Fix address for GCR_ACCESS register for CM3 and later

Liwei Song <liwei.song.lsong@gmail.com>
    tools/resolve_btfids: Fix comparison of distinct pointer types warning in resolve_btfids

Hou Tao <houtao1@huawei.com>
    bpf, events: Use prog to emit ksymbol event for main program

Lance Richardson <rlance@google.com>
    dma: fix call order in dmam_free_coherent

Michal Luczaj <mhal@rbox.co>
    af_unix: Disable MSG_OOB handling for sockets in sockmap/sockhash

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix no-args func prototype BTF dumping syntax

Puranjay Mohan <puranjay@kernel.org>
    selftests/bpf: fexit_sleep: Fix stack allocation for arm64

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: avoid build error when single DTB is turned into composite DTB

Chao Yu <chao@kernel.org>
    f2fs: fix to update user block counts in block_operations()

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    watchdog: rzg2l_wdt: Check return status of pm_runtime_put()

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    watchdog: rzg2l_wdt: Use pm_runtime_resume_and_get()

Sheng Yong <shengyong@oppo.com>
    f2fs: fix start segno of large section

Johannes Berg <johannes.berg@intel.com>
    um: time-travel: fix signal blocking race/hang

Johannes Berg <johannes.berg@intel.com>
    um: time-travel: fix time-travel-start option

Sean Anderson <sean.anderson@linux.dev>
    phy: zynqmp: Enable reference clock correctly

Ma Ke <make24@iscas.ac.cn>
    phy: cadence-torrent: Check return value on register read

Vignesh Raghavendra <vigneshr@ti.com>
    dmaengine: ti: k3-udma: Fix BCHAN count with UHC and HC channels

Jeongjun Park <aha310510@gmail.com>
    jfs: Fix array-index-out-of-bounds in diFree

Douglas Anderson <dianders@chromium.org>
    kdb: Use the passed prompt in kdb_position_cursor()

Arnd Bergmann <arnd@arndb.de>
    kdb: address -Wformat-security warnings

Chao Yu <chao@kernel.org>
    f2fs: fix to truncate preallocated blocks in f2fs_file_open()

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/mm: Fix VM_FAULT_HWPOISON handling in do_exception()

Lukas Wunner <lukas@wunner.de>
    PCI/DPC: Fix use-after-free on concurrent DPC and hot-removal

Ira Weiny <ira.weiny@intel.com>
    PCI: Introduce cleanup helpers for device reference counts and locks

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: track capability/opmode NSS separately

Yu Zhao <yuzhao@google.com>
    mm/mglru: fix ineffective protection calculation

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: handle inconsistent state in nilfs_btnode_create_block()

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: scsi: fix mis-use of 'clamp()' in sr.c

WangYuli <wangyuli@uniontech.com>
    Bluetooth: btusb: Add Realtek RTL8852BE support ID 0x13d3:0x3591

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add RTL8852BE device 0489:e125 to device tables

Lucas Stach <l.stach@pengutronix.de>
    video: logo: Drop full path of the input filename in generated file

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    lib/build_OID_registry: don't mention the full path of the script in output

Ilya Dryomov <idryomov@gmail.com>
    rbd: don't assume RBD_LOCK_STATE_LOCKED for exclusive mappings

Ilya Dryomov <idryomov@gmail.com>
    rbd: rename RBD_LOCK_STATE_RELEASING and releasing_wait

Dragan Simic <dsimic@manjaro.org>
    drm/panfrost: Mark simple_ondemand governor as softdep

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: don't block scheduler when GPU is still active

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: Test register availability before use

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: reset: Prioritise firmware service

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: Remove memory node for builtin-dtb

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: env: Hook up Loongsson-2K

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: dts: loongson: Fix GMAC phy node

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: ip30: ip30-console: Add missing include

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: dts: loongson: Add ISA node

Aleksandr Mishin <amishin@t-argos.ru>
    remoteproc: imx_rproc: Fix refcount mistake in imx_rproc_addr_init

Aleksandr Mishin <amishin@t-argos.ru>
    remoteproc: imx_rproc: Skip over memory region when node value is NULL

Gwenael Treuveur <gwenael.treuveur@foss.st.com>
    remoteproc: stm32_rproc: Fix mailbox interrupts queuing

Ilya Dryomov <idryomov@gmail.com>
    rbd: don't assume rbd_is_lock_owner() for exclusive mappings

Eric Biggers <ebiggers@kernel.org>
    dm-verity: fix dm_is_verity_target() when dm-verity is builtin

Michael Ellerman <mpe@ellerman.id.au>
    selftests/sigaltstack: Fix ppc64 GCC build

Bart Van Assche <bvanassche@acm.org>
    RDMA/iwcm: Fix a use-after-free related to destroying CM IDs

Jiaxun Yang <jiaxun.yang@flygoat.com>
    platform: mips: cpu_hwmon: Disable driver on unsupported hardware

Thomas Gleixner <tglx@linutronix.de>
    watchdog/perf: properly initialize the turbo mode timestamp and rearm counter

Joy Chakraborty <joychakr@google.com>
    rtc: abx80x: Fix return value of nvmem callback on read

Joy Chakraborty <joychakr@google.com>
    rtc: isl1208: Fix return value of nvmem callbacks

Imre Deak <imre.deak@intel.com>
    drm/i915/dp: Don't switch the LTTPR mode on an active link

Imre Deak <imre.deak@intel.com>
    drm/i915/dp: Reset intel_dp->link_trained before retraining the link

Ma Ke <make24@iscas.ac.cn>
    drm/amd/amdgpu: Fix uninitialized variable warnings

ZhenGuo Yin <zhenguo.yin@amd.com>
    drm/amdgpu: reset vm state machine after gpu reset(vram lost)

Wayne Lin <Wayne.Lin@amd.com>
    drm/dp_mst: Fix all mstb marked as not probed after suspend/resume

Thomas Zimmermann <tzimmermann@suse.de>
    drm/udl: Remove DRM_CONNECTOR_POLL_HPD

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma5.2: Update wptr registers as well as doorbell

Nitin Gote <nitin.r.gote@intel.com>
    drm/i915/gt: Do not consider preemption during execlists_dequeue for gen8

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix a topa_entry base address calculation

Marco Cavenati <cavenati.marco@gmail.com>
    perf/x86/intel/pt: Fix topa_entry base length

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/ds: Fix non 0 retire latency on Raptorlake

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix the bits of the CHA extended umask for SPR

Kan Liang <kan.liang@linux.intel.com>
    perf stat: Fix the hard-coded metrics calculation on the hybrid

Frederic Weisbecker <frederic@kernel.org>
    perf: Fix event leak upon exec and file release

Frederic Weisbecker <frederic@kernel.org>
    perf: Fix event leak upon exit

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: validate nvme_local_port correctly

Shreyas Deodhar <sdeodhar@marvell.com>
    scsi: qla2xxx: Complete command early within lock

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix flash read failure

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Reduce fabric scan duplicate code

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Use QP lock to search for bsg

Shreyas Deodhar <sdeodhar@marvell.com>
    scsi: qla2xxx: Fix for possible memory corruption

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Unable to act on RSCN for port online

Manish Rangankar <mrangankar@marvell.com>
    scsi: qla2xxx: During vport delete send async logout explicitly

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Allow DEVICE_RECOVERY mode after RSCN receipt if in PRLI_ISSUE state

Joy Chakraborty <joychakr@google.com>
    rtc: cmos: Fix return value of nvmem callbacks

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    mm/numa_balancing: teach mpol_to_str about the balancing mode

Shenwei Wang <shenwei.wang@nxp.com>
    irqchip/imx-irqsteer: Handle runtime power management correctly

Herve Codina <herve.codina@bootlin.com>
    irqdomain: Fixed unbalanced fwnode get and put

Zijun Hu <quic_zijuhu@quicinc.com>
    devres: Fix memory leakage caused by driver API devm_free_percpu()

Zijun Hu <quic_zijuhu@quicinc.com>
    devres: Fix devm_krealloc() wasting memory

Ahmed Zaki <ahmed.zaki@intel.com>
    ice: Add a per-VF limit on number of FDIR filters

Bailey Forrest <bcf@google.com>
    gve: Fix an edge case for TSO skb validity check

Zijun Hu <quic_zijuhu@quicinc.com>
    kobject_uevent: Fix OOB access within zap_modalias_env()

Takashi Iwai <tiwai@suse.de>
    ASoC: amd: yc: Support mic on Lenovo Thinkpad E16 Gen 2

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Preserve the DMA Link ID for ChainDMA on unprepare

Nathan Chancellor <nathan@kernel.org>
    kbuild: Fix '-S -c' in x86 stack protector scripts

Ross Lagerwall <ross.lagerwall@citrix.com>
    decompress_bunzip2: fix rare decompression failure

Ram Tummala <rtummala@nvidia.com>
    mm: fix old/young bit handling in the faulting path

Yang Yang <yang.yang@vivo.com>
    block: fix deadlock between sd_remove & sd_release

Fedor Pchelkin <pchelkin@ispras.ru>
    ubi: eba: properly rollback inside self_check_eba

Bastien Curutchet <bastien.curutchet@bootlin.com>
    clk: davinci: da8xx-cfgchip: Initialize clk_init_data before use

Sunmin Jeong <s_min.jeong@samsung.com>
    f2fs: use meta inode for GC of COW file

Sunmin Jeong <s_min.jeong@samsung.com>
    f2fs: use meta inode for GC of atomic file

Chao Yu <chao@kernel.org>
    f2fs: fix return value of f2fs_convert_inline_inode()

Chao Yu <chao@kernel.org>
    f2fs: fix to don't dirty inode for readonly filesystem

Chao Yu <chao@kernel.org>
    f2fs: fix to force buffered IO on inline_data inode

Herve Codina <herve.codina@bootlin.com>
    ASoC: fsl: fsl_qmc_audio: Check devm_kasprintf() returned value

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Return ENOBUFS if sg_cnt is more than one for ELS cmds

Huacai Chen <chenhuacai@kernel.org>
    fs/ntfs3: Update log->page_{mask,bits} if log->page_size changed

Qiang Ma <maqianga@uniontech.com>
    efi/libstub: Zero initialize heap allocated struct screen_info

Johannes Berg <johannes.berg@intel.com>
    hostfs: fix dev_t handling

tuhaowen <tuhaowen@uniontech.com>
    dev/parport: fix the array out-of-bounds risk

Carlos Llamas <cmllamas@google.com>
    binder: fix hang of unregistered readers

Huacai Chen <chenhuacai@kernel.org>
    PCI: loongson: Enable MSI in LS7A Root Complex

Manivannan Sadhasivam <mani@kernel.org>
    PCI: rockchip: Use GPIOD_OUT_LOW flag while requesting ep_gpio

Niklas Cassel <cassel@kernel.org>
    PCI: dw-rockchip: Fix initial PERST# GPIO value

Wei Liu <wei.liu@kernel.org>
    PCI: hv: Return zero, not garbage, when reading PCI_INTERRUPT_PIN

John David Anglin <dave@mx3210.local>
    parisc: Fix warning at drivers/pci/msi/msi.h:121

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    hwrng: amd - Convert PCIBIOS_* return codes to errnos

Alan Stern <stern@rowland.harvard.edu>
    tools/memory-model: Fix bug in lock.cat

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: usb-audio: Add a quirk for Sonix HD USB Camera

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Move HD Webcam quirk to the right place

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: usb-audio: Fix microphone sound on HD webcam.

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Force 1 Group for MIDI1 FBs

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Don't update FB name for static blocks

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Request immediate exit iff pending nested event needs injection

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Split out the non-virtualization part of vmx_interrupt_blocked()

Wentong Wu <wentong.wu@intel.com>
    media: ivsc: csi: don't count privacy on as error

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix integer overflow calculating timestamp

Jan Kara <jack@suse.cz>
    jbd2: avoid infinite transaction commit loop

Jan Kara <jack@suse.cz>
    jbd2: precompute number of transaction descriptor blocks

Jan Kara <jack@suse.cz>
    jbd2: make jbd2_journal_get_max_txn_bufs() internal

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    media: imx-pxp: Fix ERR_PTR dereference in pxp_probe()

Wentong Wu <wentong.wu@intel.com>
    media: ivsc: csi: add separate lock for v4l2 control handler

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    leds: mt6360: Fix memory leak in mt6360_init_isnk_properties()

Ofir Gal <ofir.gal@volumez.com>
    md/md-bitmap: fix writing non bitmap pages

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    leds: ss4200: Convert PCIBIOS_* return codes to errnos

Jay Buddhabhatti <jay.buddhabhatti@amd.com>
    drivers: soc: xilinx: check return status of get_api_version()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: usb: Fix disconnection after beacon loss

Rafael Beims <rafael.beims@toradex.com>
    wifi: mwifiex: Fix interface type change

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Add cred_transfer test

levi.yun <yeoreum.yun@arm.com>
    trace/pid_list: Change gfp flags in pid_list_fill_irq()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: tighten task exit cancellations

Baokun Li <libaokun1@huawei.com>
    ext4: make sure the first directory block is not a hole

Baokun Li <libaokun1@huawei.com>
    ext4: check dot and dotdot of dx_root before making dir indexed

Paolo Pisati <p.pisati@gmail.com>
    m68k: amiga: Turn off Warp1260 interrupts during boot

Jan Kara <jack@suse.cz>
    udf: Avoid using corrupted block bitmap buffer

Frederic Weisbecker <frederic@kernel.org>
    task_work: Introduce task_work_cancel() again

Frederic Weisbecker <frederic@kernel.org>
    task_work: s/task_work_cancel()/task_work_cancel_func()/

Steve French <stfrench@microsoft.com>
    cifs: mount with "unix" mount option for SMB1 incorrectly handled

Steve French <stfrench@microsoft.com>
    cifs: fix reconnect with SMB1 UNIX Extensions

Steve French <stfrench@microsoft.com>
    cifs: fix potential null pointer use in destroy_workqueue in init_cifs error path

Fedor Pchelkin <pchelkin@ispras.ru>
    apparmor: use kvfree_sensitive to free data->data

Sung Joon Kim <sungjoon.kim@amd.com>
    drm/amd/display: Check for NULL pointer

Shreyas Deodhar <sdeodhar@marvell.com>
    scsi: qla2xxx: Fix optrom version displayed in FDMI

Ma Ke <make24@iscas.ac.cn>
    drm/gma500: fix null pointer dereference in psb_intel_lvds_get_modes

Ma Ke <make24@iscas.ac.cn>
    drm/gma500: fix null pointer dereference in cdv_intel_lvds_get_modes

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/io-wq: limit retrying worker initialisation

Jan Kara <jack@suse.cz>
    ext2: Verify bitmap and itable block numbers before using them

Chao Yu <chao@kernel.org>
    hfs: fix to initialize fields of hfs_inode_info after hfs_alloc_inode()

Igor Pylypiv <ipylypiv@google.com>
    ata: libata-scsi: Honor the D_SENSE bit for CK_COND=1 and no error

Igor Pylypiv <ipylypiv@google.com>
    ata: libata-scsi: Do not overwrite valid sense data when CK_COND=1

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: venus: fix use after free in vdec_close

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    char: tpm: Fix possible memory leak in tpm_bios_measurements_open()

Igor Pylypiv <ipylypiv@google.com>
    ata: libata-scsi: Fix offsets for the fixed format sense data

Eric Sandeen <sandeen@redhat.com>
    fuse: verify {g,u}id mount options correctly

Tejun Heo <tj@kernel.org>
    sched/fair: set_load_weight() must also call reweight_task() for SCHED_IDLE tasks

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Support write delegations in LAYOUTGET

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: take care of scope when choosing the src addr

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv4: fix source address selection with route leak

Pavel Begunkov <asml.silence@gmail.com>
    kernel: rerun task_work while freezing in get_signal()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix extent map use-after-free when adding pages to compressed bio

Chengen Du <chengen.du@canonical.com>
    af_packet: Handle outgoing VLAN packets without hardware offloading

Breno Leitao <leitao@debian.org>
    net: netconsole: Disable target before netpoll cleanup

Yu Liao <liaoyu15@huawei.com>
    tick/broadcast: Make takeover of broadcast hrtimer reliable

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: thermal: correct thermal zone node name limit

Sungjong Seo <sj1557.seo@samsung.com>
    exfat: fix potential deadlock on __exfat_get_dentry_set

Ard Biesheuvel <ardb@kernel.org>
    x86/efistub: Revert to heap allocated boot_params for PE entrypoint

Ard Biesheuvel <ardb@kernel.org>
    x86/efistub: Avoid returning EFI_SUCCESS on error

Yu Zhao <yuzhao@google.com>
    mm/mglru: fix overshooting shrinker memory

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    mm: mmap_lock: replace get_memcg_path_buf() with on-stack buffer

Yu Zhao <yuzhao@google.com>
    mm/mglru: fix div-by-zero in vmpressure_calc_level()

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugetlb: fix possible recursive locking detected warning

Aristeu Rozanski <aris@redhat.com>
    hugetlb: force allocating surplus hugepages on mempolicy allowed nodes

Jann Horn <jannh@google.com>
    landlock: Don't lose track of restrictions on cred_transfer

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Check TIF_LOAD_WATCH to enable user space watchpoint

Yang Yang <yang.yang@vivo.com>
    sbitmap: fix io hung due to race on sbitmap_word::cleared

linke li <lilinke99@qq.com>
    sbitmap: use READ_ONCE to access map->word

Carlos López <clopez@suse.de>
    s390/dasd: fix error checks in dasd_copy_pair_store()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/8xx: fix size given to set_huge_pte_at()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Keep runs for $MFT::$ATTR_DATA and $MFT::$ATTR_BITMAP

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Missed error return

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix the format of the "nocase" mount option

Csókás, Bence <csokas.bence@prolan.hu>
    rtc: interface: Add RTC offset to alarm after fix-up

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: avoid undefined behavior in nilfs_cnt32_ge macro

David Hildenbrand <david@redhat.com>
    fs/proc/task_mmu: properly detect PM_MMAP_EXCLUSIVE per page of PMD-mapped THPs

David Hildenbrand <david@redhat.com>
    fs/proc/task_mmu: don't indicate PM_MMAP_EXCLUSIVE without PM_PRESENT

Hui Zhu <teawater@antgroup.com>
    fs/proc/task_mmu.c: add_to_pagemap: remove useless parameter addr

David Hildenbrand <david@redhat.com>
    fs/proc/task_mmu: indicate PM_FILE for PMD-mapped file THP

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: r8a779g0: Fix TPU suffixes

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: r8a779g0: Fix TCLK suffixes

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: r8a779g0: FIX PWM suffixes

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: r8a779g0: Fix IRQ suffixes

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: r8a779g0: Fix (H)SCIF3 suffixes

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: r8a779g0: Fix (H)SCIF1 suffixes

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: r8a779g0: Fix FXR_TXEN[AB] suffixes

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: r8a779g0: Fix CANFD5 suffix

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix field-spanning write in INDEX_HDR

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    fs/ntfs3: Drop stray '\' (backslash) in formatting string

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Correct undo if ntfs_create_inode failed

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Replace inode_trylock with inode_lock

Peng Fan <peng.fan@nxp.com>
    pinctrl: freescale: mxs: Fix refcount of child

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: ti: ti-iodelay: fix possible memory leak when pinctrl_enable() fails

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pinctrl: ti: ti-iodelay: Drop if block with always false condition

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: single: fix possible memory leak when pinctrl_enable() fails

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: core: fix possible memory leak when pinctrl_enable() fails

Dmitry Yashin <dmt.yashin@gmail.com>
    pinctrl: rockchip: update rk3308 iomux routes

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Add missing .dirty_folio in address_space_operations

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix getting file type

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Missed NI_FLAG_UPDATE_PARENT setting

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Deny getting attr data block in compressed frame

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix transform resident to nonresident for compressed files

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Merge synonym COMPRESSION_UNIT and NTFS_LZNT_CUNIT

Martin Willi <martin@strongswan.org>
    net: dsa: b53: Limit chip-wide jumbo frame config to CPU ports

Martin Willi <martin@strongswan.org>
    net: dsa: mv88e6xxx: Limit chip-wide frame size config to CPU ports

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix incorrect TOS in fibmatch route get reply

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix incorrect TOS in route get reply

Pablo Neira Ayuso <pablo@netfilter.org>
    net: flow_dissector: use DEBUG_NET_WARN_ON_ONCE

Joshua Washington <joshwash@google.com>
    gve: Fix XDP TX completion handling when counters overflow

Chen Hanxiao <chenhx.fnst@fujitsu.com>
    ipvs: properly dereference pe in ip_vs_add_service

Florian Westphal <fw@strlen.de>
    netfilter: nf_set_pipapo: fix initial map fill

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: constify lookup fn args where possible

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: ctnetlink: use helper function to calculate expect ID

Jack Wang <jinpu.wang@ionos.com>
    bnxt_re: Fix imm_data endianness

David Ahern <dsahern@kernel.org>
    RDMA: Fix netdev tracker in ib_device_set_netdev

Jules Irenge <jbi.octave@gmail.com>
    RDMA/core: Remove NULL check before dev_{put, hold}

Jon Pan-Doh <pandoh@google.com>
    iommu/vt-d: Fix identity map bounds in si_domain_init()

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix insufficient extend DB for VFs.

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix undifined behavior caused by invalid max_sge

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix shift-out-bounds when max_inline_data is 0

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix missing pagesize and alignment check in FRMR

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix unmatch exception handling when init eq table fails

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Check atomic wr length

Nick Bowler <nbowler@draconx.ca>
    macintosh/therm_windtunnel: fix module unload.

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/xmon: Fix disassembly CPU feature checks

Frank Li <Frank.Li@nxp.com>
    PCI: dwc: Fix index 0 incorrectly being interpreted as a free ATU slot

Manivannan Sadhasivam <mani@kernel.org>
    PCI: qcom-ep: Disable resources unconditionally during PERST# assert

Dominique Martinet <dominique.martinet@atmark-techno.com>
    MIPS: Octeron: remove source file executable bit

Lorenzo Bianconi <lorenzo@kernel.org>
    clk: en7523: fix rate divider for slic and spi clocks

Stephen Boyd <swboyd@chromium.org>
    clk: qcom: Park shared RCGs upon registration

Chen Ni <nichen@iscas.ac.cn>
    clk: qcom: kpss-xcc: Return of_clk_add_hw_provider to transfer the error

Nivas Varadharajan Mugunthakumar <nivasx.varadharajan.mugunthakumar@intel.com>
    crypto: qat - extend scope of lock in adf_cfg_add_key_value_param()

Heiko Stuebner <heiko.stuebner@cherry.de>
    nvmem: rockchip-otp: set add_legacy_fixed_of_cells config option

Denis Arefev <arefev@swemel.ru>
    net: missing check virtio

Michael S. Tsirkin <mst@redhat.com>
    vhost/vsock: always initialize seqpacket_allow

Dan Carpenter <dan.carpenter@linaro.org>
    PCI: endpoint: Fix error handling in epf_ntb_epc_cleanup()

Dan Carpenter <dan.carpenter@linaro.org>
    PCI: endpoint: Clean up error handling in vpci_scan_bus()

Aleksandr Mishin <amishin@t-argos.ru>
    ASoC: amd: Adjust error handling in case of absent codec device

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: elan_i2c - do not leave interrupt disabled on suspend failure

Leon Romanovsky <leon@kernel.org>
    RDMA/device: Return error earlier if port in not valid

Arnd Bergmann <arnd@arndb.de>
    mtd: make mtd_test.c a separate module

Chen Ni <nichen@iscas.ac.cn>
    ASoC: max98088: Check for clk_prepare_enable() error

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/prom: Add CPU info to hardware description string later

Harald Freudenberger <freude@linux.ibm.com>
    hwrng: core - Fix wrong quality calculation at hw rng registration

Huai-Yuan Liu <qq810974084@gmail.com>
    scsi: lpfc: Fix a possible null pointer dereference

Aleksandr Mishin <amishin@t-argos.ru>
    ASoC: qcom: Adjust issues in case of DT error in asoc_qcom_lpass_cpu_platform_probe()

Honggang LI <honggangli@163.com>
    RDMA/rxe: Don't set BTH_ACK_MASK for UC or UD QPs

Or Har-Toov <ohartoov@nvidia.com>
    RDMA/mlx5: Use sq timestamp as QP timestamp when RoCE is disabled

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx4: Fix truncated output warning in alias_GUID.c

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx4: Fix truncated output warning in mad.c

Andrei Lalaev <andrei.lalaev@anton-paar.com>
    Input: qt1050 - handle CHIP_ID reading error

Konrad Dybcio <konrad.dybcio@linaro.org>
    interconnect: qcom: qcm2290: Fix mas_snoc_bimc RPM master ID

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: gpucc-sa8775p: Update wait_val fields for GPU GDSC's

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: gpucc-sa8775p: Park RCG's clk source at XO during disable

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: gpucc-sa8775p: Remove the CLK_IS_CRITICAL and ALWAYS_ON flags

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: gcc-sa8775p: Update the GDSC wait_val fields and flags

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: gpucc-sm8350: Park RCG's clk source at XO during disable

Leon Romanovsky <leon@kernel.org>
    RDMA/cache: Release GID table even if leak is detected

Neil Armstrong <neil.armstrong@linaro.org>
    usb: typec-mux: nb7vpq904m: unregister typec switch on probe error and remove

Simon Trimmer <simont@opensource.cirrus.com>
    ASoC: cs35l56: Accept values greater than 0 as IRQ numbers

Shenghao Ding <shenghao-ding@ti.com>
    ASoc: tas2781: Enable RCA-based playback without DSP firmware download

Chiara Meiohas <cmeiohas@nvidia.com>
    RDMA/mlx5: Set mkeys for dmabuf at PAGE_SIZE

James Clark <james.clark@arm.com>
    coresight: Fix ref leak when of_coresight_parse_endpoint() fails

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    KVM: PPC: Book3S HV: Fix the get_one_reg of SDAR

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    KVM: PPC: Book3S HV: Fix the set_one_reg for MMCR3

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: frequency: adrf6780: rm clk provider include

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: camcc-sc7280: Add parent dependency to all camera GDSCs

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: gcc-sc7280: Update force mem core bit for UFS ICE clock

Minwoo Im <minwoo.im@samsung.com>
    scsi: ufs: mcq: Fix missing argument 'hba' in MCQ_OPR_OFFSET_n

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: rcar: Demote WARN() to dev_warn_ratelimited() in rcar_pcie_wakeup()

Aleksandr Mishin <amishin@t-argos.ru>
    PCI: keystone: Fix NULL pointer dereference in case of DT error in ks_pcie_setup_rc_app_regs()

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: keystone: Don't enable BAR 0 for AM654x

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: keystone: Relocate ks_pcie_set/clear_dbi_mode()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Fix resource double counting on remove & rescan

Chenyuan Yang <chenyuan0y@gmail.com>
    iio: Fix the sorting functionality in iio_gts_build_avail_time_table

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Fixup gss_status tracepoint error output

Andreas Larsson <andreas@gaisler.com>
    sparc64: Fix incorrect function signature and add prototype for prom_cif_init

Dan Carpenter <dan.carpenter@linaro.org>
    leds: flash: leds-qcom-flash: Test the correct variable in init

Jan Kara <jack@suse.cz>
    ext4: avoid writing unitialized memory to disk in EA inodes

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: don't track ranges in fast_commit if inode has inlined data

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.1 another fix for EXCHGID4_FLAG_USE_PNFS_DS for DS server

NeilBrown <neilb@suse.de>
    SUNRPC: avoid soft lockup when transmitting UDP to reachable server.

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix rpcrdma_reqs_reset()

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    mfd: omap-usb-tll: Use struct_size to allocate tll

Arnd Bergmann <arnd@arndb.de>
    mfd: rsmu: Split core code into separate module

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix exclude_guest setting

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix aux_watermark calculation for 64-bit size

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: venus: flush all buffers in output plane streamoff

Michael Walle <mwalle@kernel.org>
    drm/mediatek/dp: Fix spurious kfree()

Jani Nikula <jani.nikula@intel.com>
    drm/mediatek/dp: switch to ->edid_read callback

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix infinite loop when replaying fast_commit

Hsiao Chien Sung <shawn.sung@mediatek.com>
    drm/mediatek: Remove less-than-zero comparison of an unsigned value

Luca Ceresoli <luca.ceresoli@bootlin.com>
    Revert "leds: led-core: Fix refcount leak in of_led_get()"

Chen Ni <nichen@iscas.ac.cn>
    drm/qxl: Add check for drm_cvt_mode

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: fix DMA direction handling for cached RW buffers

Namhyung Kim <namhyung@kernel.org>
    perf report: Fix condition in sort__sym_cmp()

Junhao He <hejunhao3@huawei.com>
    perf pmus: Fixes always false when compare duplicates aliases

James Clark <james.clark@arm.com>
    perf test: Make test_arm_callgraph_fp.sh more robust

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dpu: drop validity checks for clear_pending_flush() ctl op

Jonathan Marek <jonathan@marek.ca>
    drm/msm/dsi: set VIDEO_COMPRESSION_MODE_CTRL_WC

Hans de Goede <hdegoede@redhat.com>
    leds: trigger: Unregister sysfs attributes before calling deactivate()

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Drop initial source change event if capture has been setup

Hsiao Chien Sung <shawn.sung@mediatek.com>
    drm/mediatek: Add OVL compatible name for MT8195

Hsiao Chien Sung <shawn.sung@mediatek.com>
    drm/mediatek: Turn off the layers with zero width or height

Hsiao Chien Sung <shawn.sung@mediatek.com>
    drm/mediatek: Fix destination alpha error in OVL

Hsiao Chien Sung <shawn.sung@mediatek.com>
    drm/mediatek: Fix XRGB setting error in Mixer

Hsiao Chien Sung <shawn.sung@mediatek.com>
    drm/mediatek: Fix XRGB setting error in OVL

Hsiao Chien Sung <shawn.sung@mediatek.com>
    drm/mediatek: Use 8-bit alpha in ETHDR

Hsiao Chien Sung <shawn.sung@mediatek.com>
    drm/mediatek: Add missing plane settings when async update

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: renesas: vsp1: Store RPF partition configuration per RPF instance

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: renesas: vsp1: Fix _irqsave and _irq mix

Jacopo Mondi <jacopo.mondi@ideasonboard.com>
    media: rcar-csi2: Cleanup subdevice in remove()

Jacopo Mondi <jacopo.mondi@ideasonboard.com>
    media: rcar-csi2: Disable runtime_pm in probe error

Jacopo Mondi <jacopo.mondi@ideasonboard.com>
    media: rcar-vin: Fix YUYV8_1X16 handling for CSI-2

Sean Anderson <sean.anderson@linux.dev>
    drm: zynqmp_kms: Fix AUX bus not getting unregistered

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm: zynqmp_dpsub: Fix an error handling path in zynqmp_dpsub_probe()

Daniel Schaefer <dhs@frame.work>
    media: uvcvideo: Override default flags

Oleksandr Natalenko <oleksandr@natalenko.name>
    media: uvcvideo: Add quirk for invalid dev_sof in Logitech C920

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Quirk for invalid dev_sof in Logitech C922

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Disable autosuspend for Insta360 Link

Conor Dooley <conor.dooley@microchip.com>
    media: i2c: imx219: fix msr access command sequence

Aleksandr Burakov <a.burakov@rosalinux.ru>
    saa7134: Unchecked i2c_transfer function result fixed

Dan Carpenter <dan.carpenter@linaro.org>
    ipmi: ssif_bmc: prevent integer overflow on 32bit systems

Jiri Olsa <jolsa@kernel.org>
    x86/shstk: Make return uprobe work with shadow stack

Irui Wang <irui.wang@mediatek.com>
    media: mediatek: vcodec: Handle invalid decoder vsi

David Hildenbrand <david@redhat.com>
    s390/uv: Don't call folio_wait_writeback() without a folio reference

Matthew Wilcox (Oracle) <willy@infradead.org>
    s390/mm: Convert gmap_make_secure to use a folio

Matthew Wilcox (Oracle) <willy@infradead.org>
    s390/mm: Convert make_page_secure to use a folio

ChiYuan Huang <cy_huang@richtek.com>
    media: v4l: async: Fix NULL pointer dereference in adding ancillary links

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: i2c: Fix imx412 exposure control

Ricardo Ribalda <ribalda@chromium.org>
    media: imon: Fix race getting ictx->lock

Zheng Yejian <zhengyejian1@huawei.com>
    media: dvb-usb: Fix unexpected infinite loop in dvb_usb_read_remote_control()

Mikhail Kobuk <m.kobuk@ispras.ru>
    media: pci: ivtv: Add check for DMA map result

Kuro Chung <kuro.chung@ite.com.tw>
    drm/bridge: it6505: fix hibernate to resume no display issue

xiazhengqiao <xiazhengqiao@huaqin.corp-partner.google.com>
    drm/bridge: Fixed a DP link training bug

Douglas Anderson <dianders@chromium.org>
    drm/panel: boe-tv101wum-nl6: Check for errors on the NOP in prepare()

Douglas Anderson <dianders@chromium.org>
    drm/panel: boe-tv101wum-nl6: If prepare fails, disable GPIO before regulators

Douglas Anderson <dianders@chromium.org>
    drm/panel: himax-hx8394: Handle errors from mipi_dsi_dcs_set_display_on() better

Tim Van Patten <timvp@google.com>
    drm/amdgpu: Remove GC HW IP 9.3.0 from noretry=1

Friedrich Vock <friedrich.vock@gmx.de>
    drm/amdgpu: Check if NBIO funcs are NULL in amdgpu_device_baco_exit

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Fix memory range calculation

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Fix aldebaran pcie speed reporting

Douglas Anderson <dianders@chromium.org>
    drm/mipi-dsi: Fix theoretical int overflow in mipi_dsi_generic_write_seq()

Douglas Anderson <dianders@chromium.org>
    drm/mipi-dsi: Fix theoretical int overflow in mipi_dsi_dcs_write_seq()

Mukul Joshi <mukul.joshi@amd.com>
    drm/amdkfd: Fix CU Masking for GFX 9.4.3

Faiz Abbas <faiz.abbas@arm.com>
    drm/arm/komeda: Fix komeda probe failing if there are no links in the secondary pipeline

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Fix the port mux of VP2

Elliot Ayrey <elliot.ayrey@alliedtelesis.co.nz>
    net: bridge: mst: Check vlan state for egress decision

Taehee Yoo <ap420073@gmail.com>
    xdp: fix invalid wait context of page_pool_destroy()

Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
    Bluetooth: btnxpuart: Add handling for boot-signature timeout errors

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel: Refactor btintel_set_ppag()

Sven Peter <sven@svenpeter.dev>
    Bluetooth: hci_bcm4377: Use correct unit for timeouts

Amit Cohen <amcohen@nvidia.com>
    selftests: forwarding: devlink_lib: Wait for udev events after reloading

Tengda Wu <wutengda@huaweicloud.com>
    bpf: Fix null pointer dereference in resolve_prog_type() for BPF_PROG_TYPE_EXT

Alan Maguire <alan.maguire@oracle.com>
    bpf: Eliminate remaining "make W=1" warnings in kernel/bpf/btf.o

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    bna: adjust 'name' buf size of bna_tcb and bna_ccb structures

Alan Maguire <alan.maguire@oracle.com>
    bpf: annotate BTF show functions with __printf

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    selftests/resctrl: Fix closing IMC fds on error and open-code R+W instead of loops

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    selftests/resctrl: Convert perror() to ksft_perror() or ksft_print_msg()

Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
    selftests/resctrl: Move run_benchmark() to a more fitting file

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Close obj in error path in xdp_adjust_tail

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Null checks for links in bpf_tcp_ca

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Close fd in error path in drop_on_reuseport

John Stultz <jstultz@google.com>
    locking/rwsem: Add __always_inline annotation to __down_write_common() and inlined callers

Johannes Berg <johannes.berg@intel.com>
    wifi: virt_wifi: don't use strlen() in const context

Gaosheng Cui <cuigaosheng1@huawei.com>
    gss_krb5: Fix the error handling path for crypto_sync_skcipher_setkey

En-Wei Wu <en-wei.wu@canonical.com>
    wifi: virt_wifi: avoid reporting connection success with wrong SSID

Jianbo Liu <jianbol@nvidia.com>
    xfrm: call xfrm_dev_policy_delete when kill policy

Jianbo Liu <jianbol@nvidia.com>
    xfrm: fix netdev reference count imbalance

Aleksandr Mishin <amishin@t-argos.ru>
    wifi: rtw89: Fix array index mistake in rtw89_sta_info_get_iter()

Zhang Rui <rui.zhang@intel.com>
    perf/x86/intel/cstate: Fix Alderlake/Raptorlake/Meteorlake

Adrian Hunter <adrian.hunter@intel.com>
    perf: Fix default aux_watermark calculation

Adrian Hunter <adrian.hunter@intel.com>
    perf: Prevent passing zero nr_pages to rb_alloc_aux()

Adrian Hunter <adrian.hunter@intel.com>
    perf: Fix perf_aux_size() for greater-than 32-bit size

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix pt_topa_entry_for_page() address calculation

Tao Chen <chen.dylane@gmail.com>
    bpftool: Mount bpffs when pinmaps path not under the bpffs

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Export symbol xfrm_dev_state_delete.

Martin Kaistra <martin.kaistra@linutronix.de>
    wifi: rtl8xxxu: 8188f: Limit TX power index

Kuan-Chung Chen <damon.chen@realtek.com>
    wifi: rtw89: 8852b: fix definition of KIP register number

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: rise cap on SELinux secmark context

Ismael Luceno <iluceno@suse.de>
    ipvs: Avoid unnecessary calls to skb_is_gso_sctp

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Fix unregister netdevice hang on hardware offload.

Donglin Peng <dolinux.peng@gmail.com>
    libbpf: Checking the btf_type kind when fixing variable offsets

Csókás, Bence <csokas.bence@prolan.hu>
    net: fec: Fix FEC_ECR_EN1588 being cleared on link-down

Csókás Bence <csokas.bence@prolan.hu>
    net: fec: Refactor: #define magic constants

Jan Kara <jack@suse.cz>
    udf: Fix bogus checksum computation in udf_rename()

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: cfg80211: handle 2x996 RU allocation in cfg80211_calculate_bitrate_he()

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: cfg80211: fix typo in cfg80211_calculate_bitrate_he()

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: fix wrong handling of CCMP256 and GCMP ciphers

Thomas Gleixner <tglx@linutronix.de>
    jump_label: Fix concurrency issues in static_key_slow_dec()

Thomas Gleixner <tglx@linutronix.de>
    perf/x86: Serialize set_attr_rdpmc()

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_acl: Fix ACL scale regression and firmware errors

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_acl_erp: Fix object nesting warning

Ido Schimmel <idosch@nvidia.com>
    lib: objagg: Fix general protection fault

Jan Kara <jack@suse.cz>
    udf: Fix lock ordering in udf_evict_inode()

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Check length of recv in test_sockmap

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: set rmb's SG_MAX_SINGLE_ALLOC limitation only when CONFIG_ARCH_NO_SG_CHAIN is defined

Eric Dumazet <edumazet@google.com>
    tcp: fix races in tcp_v[46]_err()

Eric Dumazet <edumazet@google.com>
    tcp: fix race in tcp_write_err()

Eric Dumazet <edumazet@google.com>
    tcp: add tcp_done_with_error() helper

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: fix wrong definition of CE ring's base address

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: fix wrong definition of CE ring's base address

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: ath11k: Update Qualcomm Innovation Center, Inc. copyrights

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: fix firmware crash during reo reinject

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: fix invalid memory access while processing fragmented packets

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: change DMA direction while mapping reinjected packets

Hagar Hemdan <hagarhem@amazon.com>
    net: esp: cleanup esp_output_tail_tcp() in case of unsupported ESPINTCP

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Fix prog numbers in test_sockmap

Ivan Babrou <ivan@cloudflare.com>
    bpftool: Un-const bpf_func_info to fix it for llvm 17 and newer

Nithyanantham Paramasivam <quic_nithp@quicinc.com>
    wifi: ath12k: Fix tx completion ring (WBM2SW) setup failure

Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>
    wifi: ath12k: Correct 6 GHz frequency value in rx status

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    wifi: brcmsmac: LCN PHY code is used for BCM4313 2G-only device

Marek Behún <kabel@kernel.org>
    firmware: turris-mox-rwtm: Initialize completion before mailbox

Marek Behún <kabel@kernel.org>
    firmware: turris-mox-rwtm: Fix checking return value of wait_for_completion_timeout()

Marek Behún <kabel@kernel.org>
    firmware: turris-mox-rwtm: Do not complete if there are no waiters

Christophe Leroy <christophe.leroy@csgroup.eu>
    vmlinux.lds.h: catch .bss..L* sections into BSS")

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    ARM: spitz: fix GPIO assignment for backlight

Thorsten Blum <thorsten.blum@toblux.com>
    m68k: cmpxchg: Fix return value for default case in __arch_xchg()

Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
    cpufreq/amd-pstate: Fix the scaling_max_freq setting on shared memory CPPC systems

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm6350: Add missing qcom,non-secure-domain property

Chukun Pan <amadeus@jmu.edu.cn>
    arm64: dts: rockchip: fixes PHY reset for Lunzn Fastrhino R68S

Chukun Pan <amadeus@jmu.edu.cn>
    arm64: dts: rockchip: disable display subsystem for Lunzn Fastrhino R6xS

Chukun Pan <amadeus@jmu.edu.cn>
    arm64: dts: rockchip: remove unused usb2 nodes for Lunzn Fastrhino R6xS

Chukun Pan <amadeus@jmu.edu.cn>
    arm64: dts: rockchip: fix pmu_io supply for Lunzn Fastrhino R6xS

Chukun Pan <amadeus@jmu.edu.cn>
    arm64: dts: rockchip: fix usb regulator for Lunzn Fastrhino R6xS

Chukun Pan <amadeus@jmu.edu.cn>
    arm64: dts: rockchip: fix regulator name for Lunzn Fastrhino R6xS

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    arm64: dts: rockchip: Add missing power-domains for rk356x vop_mmu

Chen Ni <nichen@iscas.ac.cn>
    x86/xen: Convert comma to semicolon

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mp: Fix pgc vpu locations

Lucas Stach <l.stach@pengutronix.de>
    arm64: dts: imx8mp: add HDMI power-domains

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mp: Fix pgc_mlmix location

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mp: Add NPU Node

Eero Tamminen <oak@helsinkinet.fi>
    m68k: atari: Fix TT bootup freeze / unexpected (SCU) interrupt messages

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r9a07g054: Add missing hypervisor virtual timer IRQ

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r9a07g044: Add missing hypervisor virtual timer IRQ

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r9a07g043u: Add missing hypervisor virtual timer IRQ

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r8a779g0: Add missing hypervisor virtual timer IRQ

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r8a779f0: Add missing hypervisor virtual timer IRQ

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r8a779a0: Add missing hypervisor virtual timer IRQ

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    arm64: dts: rockchip: Fix mic-in-differential usage on rk3568-evb1-v10

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    arm64: dts: rockchip: Fix mic-in-differential usage on rk3566-roc-pc

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    arm64: dts: rockchip: Drop invalid mic-in-differential on rk3568-rock-3a

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: amlogic: setup hdmi system clock

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: amlogic: add power domain to hdmitx

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: amlogic: gx: correct hdmi clocks

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-kukui-jacuzzi: Add ports node for anx7625

Hsin-Te Yuan <yuanhsinte@chromium.org>
    arm64: dts: mediatek: mt8183-kukui: Fix the value of `dlg,jack-det-rate` mismatch

Rafał Miłecki <rafal@milecki.pl>
    arm64: dts: mediatek: mt7622: fix "emmc" pinctrl mux

Pin-yen Lin <treapking@chromium.org>
    arm64: dts: mediatek: mt8192-asurada: Add off-on-delay-us for pp3300_mipibrdg

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-kukui: Drop bogus output-enable property

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8195: Fix GPU thermal zone name for SVS

Michael Walle <mwalle@kernel.org>
    ARM: dts: imx6qdl-kontron-samx6i: fix PCIe reset polarity

Michael Walle <mwalle@kernel.org>
    ARM: dts: imx6qdl-kontron-samx6i: fix SPI0 chip selects

Michael Walle <mwalle@kernel.org>
    ARM: dts: imx6qdl-kontron-samx6i: fix board reset

Michael Walle <mwalle@kernel.org>
    ARM: dts: imx6qdl-kontron-samx6i: fix PHY reset

Michael Walle <mwalle@kernel.org>
    ARM: dts: imx6qdl-kontron-samx6i: fix phy-mode

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: amlogic: sm1: fix spdif compatibles

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Increase VOP clk rate on RK3328

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    soc: qcom: pdr: fix parsing of domains lists

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    soc: qcom: pdr: protect locator_addr with the main mutex

Sibi Sankar <quic_sibis@quicinc.com>
    soc: qcom: icc-bwmon: Fix refcount imbalance seen during bwmon_remove

Komal Bajaj <quic_kbajaj@quicinc.com>
    arm64: dts: qcom: qdu1000: Add secure qfprom node

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: qdu1000-idp: drop unused LLCC multi-ch-bit-off

Jai Luthra <j-luthra@ti.com>
    arm64: dts: ti: k3-am62-verdin: Drop McASP AFIFOs

Jai Luthra <j-luthra@ti.com>
    arm64: dts: ti: k3-am625-beagleplay: Drop McASP AFIFOs

Jai Luthra <j-luthra@ti.com>
    arm64: dts: ti: k3-am62x: Drop McASP AFIFOs

Esben Haabendal <esben@geanix.com>
    memory: fsl_ifc: Make FSL_IFC config visible and selectable

Primoz Fiser <primoz.fiser@norik.com>
    OPP: ti: Fix ti_opp_supply_probe wrong return values

Primoz Fiser <primoz.fiser@norik.com>
    cpufreq: ti-cpufreq: Handle deferred probe with dev_err_probe()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: qrb4210-rb2: make L9A always-on

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Add arm,no-tick-in-suspend to STM32MP15xx STGEN timer

Pavel Löbl <pavel@loebl.cz>
    ARM: dts: sunxi: remove duplicated entries in makefile

Jay Buddhabhatti <jay.buddhabhatti@amd.com>
    soc: xilinx: rename cpu_number1 to dummy_cpu_number

Sagar Cheluvegowda <quic_scheluve@quicinc.com>
    arm64: dts: qcom: sa8775p: mark ethernet devices as DMA-coherent

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8996: specify UFS core_clk frequencies

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Update WIFi/BT related nodes on rk3308-rock-pi-s

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Add mdio and ethernet-phy nodes to rk3308-rock-pi-s

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Add pinctrl for UART0 to rk3308-rock-pi-s

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Add sdmmc related properties on rk3308-rock-pi-s

Stephen Boyd <swboyd@chromium.org>
    soc: qcom: rpmh-rsc: Ensure irqs aren't disabled by rpmh_rsc_send_data() callers

Chen Ni <nichen@iscas.ac.cn>
    soc: qcom: pmic_glink: Handle the return value of pmic_glink_init

Marc Gonzalez <mgonzalez@freebox.fr>
    arm64: dts: qcom: msm8998: enable adreno_smmu by default

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sdm850-lenovo-yoga-c630: fix IPA firmware path

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8996-xiaomi-common: drop excton from the USB PHY

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8450: add power-domain to UFS PHY

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8350: add power-domain to UFS PHY

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8250: add power-domain to UFS PHY

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8250: switch UFS QMP PHY to new style of bindings

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm6350: add power-domain to UFS PHY

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm6115: add power-domain to UFS PHY

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sdm845: add power-domain to UFS PHY

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sc8180x: add power-domain to UFS PHY

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sc8180x: switch UFS QMP PHY to new style of bindings

Bjorn Andersson <quic_bjorande@quicinc.com>
    arm64: dts: qcom: sc8180x: Correct PCIe slave ports

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max6697) Fix swapped temp{1,8} critical alarms

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max6697) Fix underflow when writing limit attributes

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: atmel-tcb: Fix race condition and convert to guards

Yao Zi <ziyao@disroot.org>
    drm/meson: fix canvas release in bind function

Gaosheng Cui <cuigaosheng1@huawei.com>
    nvmet-auth: fix nvmet_auth hash error handling

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: stm32: Always do lazy disabling

Yu Kuai <yukuai3@huawei.com>
    md: Don't wait for MD_RECOVERY_NEEDED for HOT_REMOVE_DISK ioctl

Bart Van Assche <bvanassche@acm.org>
    block/mq-deadline: Fix the tag reservation code

Bart Van Assche <bvanassche@acm.org>
    block: Call .limit_depth() after .hctx has been set

Wayne Tung <chineweff@gmail.com>
    hwmon: (adt7475) Fix default duty on fan is disabled

Chen Ridong <chenridong@huawei.com>
    cgroup/cpuset: Prevent UAF in proc_cpuset_show()

Kees Cook <keescook@chromium.org>
    kernfs: Convert kernfs_path_from_node_locked() from strlcpy() to strscpy()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    x86/platform/iosf_mbi: Convert PCIBIOS_* return codes to errnos

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    x86/pci/xen: Fix PCIBIOS_* return code handling

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    x86/pci/intel_mid_pci: Fix PCIBIOS_* return code handling

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    x86/of: Return consistent error type from x86_of_pci_irq_enable()

Chao Yu <chao@kernel.org>
    hfsplus: fix to avoid false alarm of circular locking

Masahiro Yamada <masahiroy@kernel.org>
    x86/kconfig: Add as-instr64 macro to properly evaluate AS_WRUSS

Christoph Hellwig <hch@lst.de>
    block: initialize integrity buffer to zero before writing it to media

Christoph Hellwig <hch@lst.de>
    ubd: untagle discard vs write zeroes not support handling

Christoph Hellwig <hch@lst.de>
    ubd: refactor the interrupt handler

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_debugfs: fix wrong EC message version

Li Nan <linan122@huawei.com>
    md: fix deadlock between mddev_suspend and flush bio

Frederic Weisbecker <frederic@kernel.org>
    rcu/tasks: Fix stale task snaphot for Tasks Trace

Arnd Bergmann <arnd@arndb.de>
    EDAC, i10nm: make skx_common.o a separate module

Chen Ni <nichen@iscas.ac.cn>
    spi: atmel-quadspi: Add missing check for clk_prepare

Prajna Rajendra Kumar <prajna.rajendrakumar@microchip.com>
    spi: spi-microchip-core: Fix the number of chip selects supported


-------------

Diffstat:

 .../devicetree/bindings/thermal/thermal-zones.yaml |   5 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/allwinner/Makefile               |  62 --
 .../arm/boot/dts/nxp/imx/imx6q-kontron-samx6i.dtsi |  23 -
 .../boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi   |  14 +-
 arch/arm/boot/dts/st/stm32mp151.dtsi               |   1 +
 arch/arm/mach-pxa/spitz.c                          |  30 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   5 +
 arch/arm64/boot/dts/amlogic/meson-g12.dtsi         |   4 +
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi        |  10 +-
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |  10 +-
 arch/arm64/boot/dts/amlogic/meson-sm1.dtsi         |   8 +-
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          | 130 +++-
 .../boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts  |   4 +-
 arch/arm64/boot/dts/mediatek/mt7622-rfb1.dts       |   4 +-
 .../dts/mediatek/mt8183-kukui-audio-da7219.dtsi    |   2 +-
 .../boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi    |  25 +-
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi     |   2 -
 arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi   |   1 +
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |   2 +-
 .../arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi |   1 -
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |   1 -
 arch/arm64/boot/dts/qcom/qdu1000.dtsi              |  16 +-
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts           |   2 +
 arch/arm64/boot/dts/qcom/sa8775p.dtsi              |   2 +
 arch/arm64/boot/dts/qcom/sc8180x.dtsi              |  28 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   2 +
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |   1 +
 arch/arm64/boot/dts/qcom/sm6115.dtsi               |   2 +
 arch/arm64/boot/dts/qcom/sm6350.dtsi               |   4 +
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |  22 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   2 +
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   2 +
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi          |   5 +-
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi          |   5 +-
 arch/arm64/boot/dts/renesas/r8a779g0.dtsi          |   5 +-
 arch/arm64/boot/dts/renesas/r9a07g043u.dtsi        |   5 +-
 arch/arm64/boot/dts/renesas/r9a07g044.dtsi         |   5 +-
 arch/arm64/boot/dts/renesas/r9a07g054.dtsi         |   5 +-
 arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts  |  71 +-
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   4 +-
 arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts     |   2 +-
 arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts   |   2 +-
 .../boot/dts/rockchip/rk3568-fastrhino-r66s.dts    |   4 +
 .../boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi   |  48 +-
 .../boot/dts/rockchip/rk3568-fastrhino-r68s.dts    |  16 +-
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts    |   4 -
 arch/arm64/boot/dts/rockchip/rk356x.dtsi           |   1 +
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |   4 -
 arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts     |   2 -
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi     |   2 -
 arch/loongarch/kernel/hw_breakpoint.c              |   2 +-
 arch/loongarch/kernel/ptrace.c                     |   3 +
 arch/m68k/amiga/config.c                           |   9 +
 arch/m68k/atari/ataints.c                          |   6 +-
 arch/m68k/include/asm/cmpxchg.h                    |   2 +-
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi |  21 +-
 arch/mips/include/asm/mach-loongson64/boot_param.h |   2 +
 arch/mips/include/asm/mips-cm.h                    |   4 +
 arch/mips/kernel/smp-cps.c                         |   5 +-
 arch/mips/loongson64/env.c                         |   8 +
 arch/mips/loongson64/reset.c                       |  38 +-
 arch/mips/loongson64/smp.c                         |  23 +-
 arch/mips/pci/pcie-octeon.c                        |   0
 arch/mips/sgi-ip30/ip30-console.c                  |   1 +
 arch/parisc/Kconfig                                |   1 +
 arch/powerpc/kernel/prom.c                         |  12 +-
 arch/powerpc/kvm/book3s_hv.c                       |   4 +-
 arch/powerpc/kvm/powerpc.c                         |   4 +-
 arch/powerpc/mm/nohash/8xx.c                       |   3 +-
 arch/powerpc/xmon/ppc-dis.c                        |  33 +-
 arch/s390/kernel/perf_cpum_cf.c                    |  14 +-
 arch/s390/kernel/uv.c                              |  58 +-
 arch/s390/mm/fault.c                               |   6 +-
 arch/s390/pci/pci_irq.c                            | 110 ++--
 arch/sparc/include/asm/oplib_64.h                  |   1 +
 arch/sparc/prom/init_64.c                          |   3 -
 arch/sparc/prom/p1275.c                            |   2 +-
 arch/um/drivers/ubd_kern.c                         |  50 +-
 arch/um/kernel/time.c                              |   4 +-
 arch/um/os-Linux/signal.c                          | 118 +++-
 arch/x86/Kconfig.assembler                         |   2 +-
 arch/x86/events/core.c                             |   3 +
 arch/x86/events/intel/cstate.c                     |   7 +-
 arch/x86/events/intel/ds.c                         |   8 +-
 arch/x86/events/intel/pt.c                         |   4 +-
 arch/x86/events/intel/pt.h                         |   4 +-
 arch/x86/events/intel/uncore_snbep.c               |   6 +-
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/include/asm/shstk.h                       |   2 +
 arch/x86/kernel/devicetree.c                       |   2 +-
 arch/x86/kernel/shstk.c                            |  11 +
 arch/x86/kernel/uprobes.c                          |   7 +-
 arch/x86/kvm/vmx/nested.c                          |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |  11 +-
 arch/x86/kvm/vmx/vmx.h                             |   1 +
 arch/x86/kvm/x86.c                                 |   4 +-
 arch/x86/pci/intel_mid_pci.c                       |   4 +-
 arch/x86/pci/xen.c                                 |   4 +-
 arch/x86/platform/intel/iosf_mbi.c                 |   4 +-
 arch/x86/xen/p2m.c                                 |   4 +-
 block/bio-integrity.c                              |  11 +-
 block/blk-mq.c                                     |  12 +-
 block/genhd.c                                      |   2 +-
 block/mq-deadline.c                                |  20 +-
 drivers/android/binder.c                           |   4 +-
 drivers/ata/libata-scsi.c                          | 176 ++---
 drivers/auxdisplay/ht16k33.c                       |   1 +
 drivers/base/devres.c                              |  11 +-
 drivers/block/rbd.c                                |  35 +-
 drivers/bluetooth/btintel.c                        | 119 +---
 drivers/bluetooth/btnxpuart.c                      |  52 +-
 drivers/bluetooth/btusb.c                          |   4 +
 drivers/bluetooth/hci_bcm4377.c                    |   2 +-
 drivers/char/hw_random/amd-rng.c                   |   4 +-
 drivers/char/hw_random/core.c                      |   4 +-
 drivers/char/ipmi/ssif_bmc.c                       |   6 +-
 drivers/char/tpm/eventlog/common.c                 |   2 +
 drivers/clk/clk-en7523.c                           |   9 +-
 drivers/clk/davinci/da8xx-cfgchip.c                |   4 +-
 drivers/clk/qcom/camcc-sc7280.c                    |   5 +
 drivers/clk/qcom/clk-rcg2.c                        |  32 +
 drivers/clk/qcom/gcc-sa8775p.c                     |  40 ++
 drivers/clk/qcom/gcc-sc7280.c                      |   3 +
 drivers/clk/qcom/gpucc-sa8775p.c                   |  41 +-
 drivers/clk/qcom/gpucc-sm8350.c                    |   5 +-
 drivers/clk/qcom/kpss-xcc.c                        |   4 +-
 drivers/cpufreq/amd-pstate.c                       |  43 +-
 drivers/cpufreq/ti-cpufreq.c                       |   2 +-
 drivers/crypto/intel/qat/qat_common/adf_cfg.c      |   6 +-
 drivers/dma/ti/k3-udma.c                           |   4 +-
 drivers/edac/Makefile                              |  10 +-
 drivers/edac/skx_common.c                          |  21 +-
 drivers/edac/skx_common.h                          |   4 +-
 drivers/firmware/efi/libstub/screen_info.c         |   2 +
 drivers/firmware/efi/libstub/x86-stub.c            |  25 +-
 drivers/firmware/turris-mox-rwtm.c                 |  23 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   9 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |   2 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |  12 +
 drivers/gpu/drm/amd/amdgpu/smu_v13_0_10.c          |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |   2 +-
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c   |   3 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   4 +-
 drivers/gpu/drm/arm/display/komeda/komeda_crtc.c   |  43 +-
 drivers/gpu/drm/bridge/ite-it6505.c                |  85 ++-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |   4 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |   6 +-
 drivers/gpu/drm/etnaviv/etnaviv_sched.c            |   9 +-
 drivers/gpu/drm/gma500/cdv_intel_lvds.c            |   3 +
 drivers/gpu/drm/gma500/psb_intel_lvds.c            |   3 +
 drivers/gpu/drm/i915/display/intel_dp.c            |   2 +
 .../gpu/drm/i915/display/intel_dp_link_training.c  |  55 +-
 .../gpu/drm/i915/gt/intel_execlists_submission.c   |   6 +-
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c            |  24 +-
 drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c    |   2 +-
 drivers/gpu/drm/mediatek/mtk_dp.c                  |  39 +-
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c        |   2 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   2 +
 drivers/gpu/drm/mediatek/mtk_drm_plane.c           |   2 +
 drivers/gpu/drm/mediatek/mtk_ethdr.c               |  21 +-
 drivers/gpu/drm/meson/meson_drv.c                  |  37 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   3 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c    |   3 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.h         |   3 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   3 +
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c     |   8 +-
 drivers/gpu/drm/panel/panel-himax-hx8394.c         |   3 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |   1 +
 drivers/gpu/drm/qxl/qxl_display.c                  |   3 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |   2 +-
 drivers/gpu/drm/udl/udl_modeset.c                  |   3 +-
 drivers/gpu/drm/xlnx/zynqmp_dpsub.c                |   1 +
 drivers/gpu/drm/xlnx/zynqmp_kms.c                  |  12 +-
 drivers/hwmon/adt7475.c                            |   2 +-
 drivers/hwmon/max6697.c                            |   5 +-
 drivers/hwtracing/coresight/coresight-platform.c   |   4 +-
 drivers/iio/frequency/adrf6780.c                   |   1 -
 drivers/iio/industrialio-gts-helper.c              |   7 +-
 drivers/infiniband/core/cache.c                    |  14 +-
 drivers/infiniband/core/device.c                   |  22 +-
 drivers/infiniband/core/iwcm.c                     |  11 +-
 drivers/infiniband/core/lag.c                      |   3 +-
 drivers/infiniband/core/roce_gid_mgmt.c            |   3 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   8 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   6 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   6 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  40 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   5 +
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   4 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   2 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c            |   2 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  13 +
 drivers/infiniband/hw/mlx5/odp.c                   |   6 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |   7 +-
 drivers/input/keyboard/qt1050.c                    |   7 +-
 drivers/input/mouse/elan_i2c_core.c                |   2 +
 drivers/interconnect/qcom/qcm2290.c                |   2 +-
 drivers/iommu/intel/iommu.c                        |   2 +-
 drivers/iommu/sprd-iommu.c                         |   2 +-
 drivers/irqchip/irq-imx-irqsteer.c                 |  24 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |   7 +-
 drivers/leds/flash/leds-mt6360.c                   |   5 +-
 drivers/leds/flash/leds-qcom-flash.c               |  10 +-
 drivers/leds/led-class.c                           |   1 -
 drivers/leds/led-triggers.c                        |   2 +-
 drivers/leds/leds-ss4200.c                         |   7 +-
 drivers/macintosh/therm_windtunnel.c               |   2 +-
 drivers/md/dm-verity-target.c                      |  16 +-
 drivers/md/md-bitmap.c                             |   6 +-
 drivers/md/md.c                                    |  32 +-
 drivers/media/i2c/imx219.c                         |   2 +-
 drivers/media/i2c/imx412.c                         |   9 +-
 drivers/media/pci/intel/ivsc/mei_csi.c             |  14 +-
 drivers/media/pci/ivtv/ivtv-udma.c                 |   8 +
 drivers/media/pci/ivtv/ivtv-yuv.c                  |   6 +
 drivers/media/pci/ivtv/ivtvfb.c                    |   6 +-
 drivers/media/pci/saa7134/saa7134-dvb.c            |   8 +-
 .../platform/mediatek/vcodec/decoder/vdec_vpu_if.c |   6 +
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |   3 +
 drivers/media/platform/nxp/imx-pxp.c               |   3 +
 drivers/media/platform/qcom/venus/vdec.c           |   3 +-
 .../media/platform/renesas/rcar-vin/rcar-csi2.c    |   5 +-
 drivers/media/platform/renesas/rcar-vin/rcar-dma.c |  16 +-
 drivers/media/platform/renesas/vsp1/vsp1_histo.c   |  20 +-
 drivers/media/platform/renesas/vsp1/vsp1_pipe.h    |   2 +-
 drivers/media/platform/renesas/vsp1/vsp1_rpf.c     |   8 +-
 drivers/media/rc/imon.c                            |   5 +-
 drivers/media/rc/lirc_dev.c                        |   4 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |  35 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |   9 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  26 +-
 drivers/media/usb/uvc/uvc_video.c                  |  21 +-
 drivers/media/usb/uvc/uvcvideo.h                   |   2 +
 drivers/media/v4l2-core/v4l2-async.c               |   3 +
 drivers/memory/Kconfig                             |   2 +-
 drivers/mfd/Makefile                               |   6 +-
 drivers/mfd/omap-usb-tll.c                         |   3 +-
 drivers/mfd/rsmu_core.c                            |   2 +
 drivers/mtd/nand/raw/Kconfig                       |   3 +-
 drivers/mtd/tests/Makefile                         |  34 +-
 drivers/mtd/tests/mtd_test.c                       |   9 +
 drivers/mtd/ubi/eba.c                              |   3 +-
 drivers/net/bonding/bond_main.c                    |   7 +-
 drivers/net/dsa/b53/b53_common.c                   |   3 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   3 +-
 drivers/net/ethernet/brocade/bna/bna_types.h       |   2 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |  11 +-
 drivers/net/ethernet/freescale/fec_main.c          |  52 +-
 drivers/net/ethernet/google/gve/gve_tx.c           |   5 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |  22 +-
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_fdir.h          |   3 +
 drivers/net/ethernet/intel/ice/ice_switch.c        |   8 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |  16 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.h |   1 +
 .../ethernet/mellanox/mlxsw/spectrum_acl_atcam.c   |  18 +-
 .../mellanox/mlxsw/spectrum_acl_bloom_filter.c     |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c |  13 -
 .../ethernet/mellanox/mlxsw/spectrum_acl_tcam.h    |   9 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
 drivers/net/netconsole.c                           |   2 +-
 drivers/net/wireless/ath/ath11k/ce.c               |   2 +-
 drivers/net/wireless/ath/ath11k/ce.h               |   5 +-
 drivers/net/wireless/ath/ath11k/dbring.c           |   1 +
 drivers/net/wireless/ath/ath11k/dbring.h           |   1 +
 drivers/net/wireless/ath/ath11k/debug.c            |   1 +
 drivers/net/wireless/ath/ath11k/debug.h            |   2 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |   1 +
 drivers/net/wireless/ath/ath11k/debugfs.h          |   1 +
 .../net/wireless/ath/ath11k/debugfs_htt_stats.c    |   2 +-
 .../net/wireless/ath/ath11k/debugfs_htt_stats.h    |   2 +-
 drivers/net/wireless/ath/ath11k/debugfs_sta.c      |   1 +
 drivers/net/wireless/ath/ath11k/debugfs_sta.h      |   1 +
 drivers/net/wireless/ath/ath11k/dp.c               |   2 +-
 drivers/net/wireless/ath/ath11k/dp.h               |   2 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   4 +-
 drivers/net/wireless/ath/ath11k/dp_rx.h            |   3 +
 drivers/net/wireless/ath/ath11k/dp_tx.c            |   2 +-
 drivers/net/wireless/ath/ath11k/dp_tx.h            |   1 +
 drivers/net/wireless/ath/ath11k/hal.c              |   2 +-
 drivers/net/wireless/ath/ath11k/hal.h              |   2 +-
 drivers/net/wireless/ath/ath11k/hal_desc.h         |   1 +
 drivers/net/wireless/ath/ath11k/hal_rx.c           |   1 +
 drivers/net/wireless/ath/ath11k/hal_rx.h           |   1 +
 drivers/net/wireless/ath/ath11k/hif.h              |   1 +
 drivers/net/wireless/ath/ath11k/htc.c              |   1 +
 drivers/net/wireless/ath/ath11k/htc.h              |   1 +
 drivers/net/wireless/ath/ath11k/hw.c               |   2 +-
 drivers/net/wireless/ath/ath11k/hw.h               |   2 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  15 +-
 drivers/net/wireless/ath/ath11k/mac.h              |   1 +
 drivers/net/wireless/ath/ath11k/mhi.c              |   2 +-
 drivers/net/wireless/ath/ath11k/mhi.h              |   1 +
 drivers/net/wireless/ath/ath11k/pcic.c             |   2 +-
 drivers/net/wireless/ath/ath11k/peer.c             |   2 +-
 drivers/net/wireless/ath/ath11k/peer.h             |   2 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   2 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |   2 +-
 drivers/net/wireless/ath/ath11k/reg.c              |   1 +
 drivers/net/wireless/ath/ath11k/reg.h              |   1 +
 drivers/net/wireless/ath/ath11k/rx_desc.h          |   1 +
 drivers/net/wireless/ath/ath11k/spectral.c         |   1 +
 drivers/net/wireless/ath/ath11k/spectral.h         |   1 +
 drivers/net/wireless/ath/ath11k/thermal.c          |   1 +
 drivers/net/wireless/ath/ath11k/thermal.h          |   1 +
 drivers/net/wireless/ath/ath11k/trace.h            |   1 +
 drivers/net/wireless/ath/ath11k/wmi.c              |   2 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |   2 +-
 drivers/net/wireless/ath/ath11k/wow.h              |   1 +
 drivers/net/wireless/ath/ath12k/ce.h               |   6 +-
 drivers/net/wireless/ath/ath12k/dp.c               |  18 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |  27 +-
 drivers/net/wireless/ath/ath12k/hw.c               |   8 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |  10 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |  18 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   2 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c |  15 +
 drivers/net/wireless/realtek/rtw88/usb.c           |   2 +
 drivers/net/wireless/realtek/rtw89/debug.c         |   2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c  |   2 +-
 drivers/net/wireless/virtual/virt_wifi.c           |  20 +-
 drivers/nvme/host/pci.c                            |   5 +-
 drivers/nvme/target/auth.c                         |  14 +-
 drivers/nvmem/rockchip-otp.c                       |   1 +
 drivers/opp/ti-opp-supply.c                        |   6 +-
 drivers/parport/procfs.c                           |  24 +-
 drivers/pci/controller/dwc/pci-keystone.c          | 156 +++--
 drivers/pci/controller/dwc/pcie-designware-ep.c    |  13 +-
 drivers/pci/controller/dwc/pcie-dw-rockchip.c      |   2 +-
 drivers/pci/controller/dwc/pcie-qcom-ep.c          |   6 -
 drivers/pci/controller/pci-hyperv.c                |   4 +-
 drivers/pci/controller/pci-loongson.c              |  13 +
 drivers/pci/controller/pcie-rcar-host.c            |   6 +-
 drivers/pci/controller/pcie-rockchip.c             |   2 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |  19 +-
 drivers/pci/pci.c                                  |   6 +-
 drivers/pci/setup-bus.c                            |   6 +-
 drivers/phy/cadence/phy-cadence-torrent.c          |   3 +
 drivers/phy/xilinx/phy-zynqmp.c                    |  14 +-
 drivers/pinctrl/core.c                             |  12 +-
 drivers/pinctrl/freescale/pinctrl-mxs.c            |   4 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  17 +-
 drivers/pinctrl/pinctrl-single.c                   |   7 +-
 drivers/pinctrl/renesas/pfc-r8a779g0.c             | 716 ++++++++++-----------
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c            |  14 +-
 drivers/platform/chrome/cros_ec_debugfs.c          |   1 +
 drivers/platform/mips/cpu_hwmon.c                  |   3 +
 drivers/pwm/pwm-atmel-tcb.c                        |  12 +-
 drivers/pwm/pwm-stm32.c                            |   5 +-
 drivers/remoteproc/imx_rproc.c                     |  10 +-
 drivers/remoteproc/stm32_rproc.c                   |   2 +-
 drivers/rtc/interface.c                            |   9 +-
 drivers/rtc/rtc-abx80x.c                           |  12 +-
 drivers/rtc/rtc-cmos.c                             |  10 +-
 drivers/rtc/rtc-isl1208.c                          |  11 +-
 drivers/s390/block/dasd_devmap.c                   |  10 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |   5 +
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   2 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  98 +--
 drivers/scsi/qla2xxx/qla_def.h                     |  17 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   6 +-
 drivers/scsi/qla2xxx/qla_gs.c                      | 473 +++++++-------
 drivers/scsi/qla2xxx/qla_init.c                    |  92 ++-
 drivers/scsi/qla2xxx/qla_inline.h                  |   8 +
 drivers/scsi/qla2xxx/qla_mid.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   5 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  19 +-
 drivers/scsi/qla2xxx/qla_sup.c                     | 108 +++-
 drivers/scsi/sr_ioctl.c                            |   2 +-
 drivers/soc/qcom/icc-bwmon.c                       |   4 +-
 drivers/soc/qcom/pdr_interface.c                   |   8 +-
 drivers/soc/qcom/pmic_glink.c                      |  13 +-
 drivers/soc/qcom/rpmh-rsc.c                        |   7 +-
 drivers/soc/qcom/rpmh.c                            |   1 -
 drivers/soc/xilinx/xlnx_event_manager.c            |  15 +-
 drivers/soc/xilinx/zynqmp_power.c                  |   4 +-
 drivers/spi/atmel-quadspi.c                        |  11 +-
 drivers/spi/spi-microchip-core.c                   | 211 +++---
 drivers/spi/spidev.c                               |   1 +
 drivers/ufs/core/ufs-mcq.c                         |  10 +-
 drivers/usb/typec/mux/nb7vpq904m.c                 |   7 +-
 drivers/vhost/vsock.c                              |   4 +-
 drivers/video/logo/pnmtologo.c                     |   2 -
 drivers/watchdog/rzg2l_wdt.c                       |  22 +-
 fs/btrfs/compression.c                             |   2 +-
 fs/ceph/super.c                                    |   3 +-
 fs/exfat/dir.c                                     |   2 +-
 fs/ext2/balloc.c                                   |  11 +-
 fs/ext4/extents_status.c                           |   2 +
 fs/ext4/fast_commit.c                              |   6 +
 fs/ext4/namei.c                                    |  73 ++-
 fs/ext4/xattr.c                                    |   6 +
 fs/f2fs/checkpoint.c                               |  10 +-
 fs/f2fs/data.c                                     |   6 +-
 fs/f2fs/f2fs.h                                     |  19 +-
 fs/f2fs/file.c                                     |  47 +-
 fs/f2fs/gc.c                                       |  13 +-
 fs/f2fs/inline.c                                   |   8 +-
 fs/f2fs/inode.c                                    |  14 +-
 fs/f2fs/segment.c                                  |   6 +-
 fs/f2fs/segment.h                                  |   3 +-
 fs/fuse/inode.c                                    |  24 +-
 fs/hfs/inode.c                                     |   3 +
 fs/hfsplus/bfind.c                                 |  15 +-
 fs/hfsplus/extents.c                               |   9 +-
 fs/hfsplus/hfsplus_fs.h                            |  21 +
 fs/hostfs/hostfs.h                                 |   7 +-
 fs/hostfs/hostfs_kern.c                            |  10 +-
 fs/hostfs/hostfs_user.c                            |   7 +-
 fs/jbd2/commit.c                                   |   2 +-
 fs/jbd2/journal.c                                  |  56 +-
 fs/jbd2/transaction.c                              |  45 +-
 fs/jfs/jfs_imap.c                                  |   5 +-
 fs/kernfs/dir.c                                    |  34 +-
 fs/nfs/nfs4client.c                                |   6 +-
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/nfsd/nfs4proc.c                                 |   5 +-
 fs/nilfs2/btnode.c                                 |  25 +-
 fs/nilfs2/btree.c                                  |   4 +-
 fs/nilfs2/segment.c                                |   2 +-
 fs/ntfs3/attrib.c                                  |  30 +-
 fs/ntfs3/bitmap.c                                  |   2 +-
 fs/ntfs3/dir.c                                     |   3 +-
 fs/ntfs3/file.c                                    |   5 +-
 fs/ntfs3/frecord.c                                 |   2 +-
 fs/ntfs3/fslog.c                                   |   5 +-
 fs/ntfs3/index.c                                   |   4 +-
 fs/ntfs3/inode.c                                   |  13 +-
 fs/ntfs3/ntfs.h                                    |  12 +-
 fs/ntfs3/super.c                                   |   4 +-
 fs/proc/task_mmu.c                                 |  43 +-
 fs/smb/client/cifsfs.c                             |   8 +-
 fs/smb/client/connect.c                            |  24 +-
 fs/super.c                                         |  11 +
 fs/udf/balloc.c                                    |  15 +-
 fs/udf/file.c                                      |   2 +
 fs/udf/inode.c                                     |  11 +-
 fs/udf/namei.c                                     |   2 -
 fs/udf/super.c                                     |   3 +-
 include/asm-generic/vmlinux.lds.h                  |   2 +-
 include/drm/drm_mipi_dsi.h                         |  46 +-
 include/linux/bpf_verifier.h                       |   2 +-
 include/linux/hugetlb.h                            |   1 +
 include/linux/jbd2.h                               |  12 +-
 include/linux/mlx5/qp.h                            |   9 +-
 include/linux/objagg.h                             |   1 -
 include/linux/pci.h                                |   2 +
 include/linux/perf_event.h                         |   1 +
 include/linux/sbitmap.h                            |   5 +
 include/linux/task_work.h                          |   3 +-
 include/linux/virtio_net.h                         |  11 +
 include/net/ip_fib.h                               |   1 +
 include/net/tcp.h                                  |   1 +
 include/net/xfrm.h                                 |  36 +-
 include/sound/tas2781-dsp.h                        |  11 +-
 include/trace/events/rpcgss.h                      |   2 +-
 include/uapi/linux/netfilter/nf_tables.h           |   2 +-
 include/uapi/linux/zorro_ids.h                     |   3 +
 include/ufs/ufshcd.h                               |   6 +
 io_uring/io-wq.c                                   |  10 +-
 io_uring/io_uring.c                                |   5 +-
 io_uring/timeout.c                                 |   2 +-
 kernel/bpf/btf.c                                   |  10 +-
 kernel/cgroup/cgroup-v1.c                          |   2 +-
 kernel/cgroup/cgroup.c                             |   4 +-
 kernel/cgroup/cpuset.c                             |  15 +-
 kernel/debug/kdb/kdb_io.c                          |   6 +-
 kernel/dma/mapping.c                               |   2 +-
 kernel/events/core.c                               |  77 ++-
 kernel/events/internal.h                           |   2 +-
 kernel/events/ring_buffer.c                        |   4 +-
 kernel/irq/irqdomain.c                             |   7 +-
 kernel/irq/manage.c                                |   2 +-
 kernel/jump_label.c                                |  45 +-
 kernel/locking/rwsem.c                             |   6 +-
 kernel/rcu/tasks.h                                 |  10 +
 kernel/sched/core.c                                |  37 +-
 kernel/sched/fair.c                                |   7 +-
 kernel/sched/sched.h                               |   2 +-
 kernel/signal.c                                    |   8 +
 kernel/task_work.c                                 |  34 +-
 kernel/time/tick-broadcast.c                       |  23 +
 kernel/trace/pid_list.c                            |   4 +-
 kernel/watchdog_perf.c                             |  11 +-
 lib/build_OID_registry                             |   5 +-
 lib/decompress_bunzip2.c                           |   3 +-
 lib/kobject_uevent.c                               |  17 +-
 lib/objagg.c                                       |  18 +-
 lib/sbitmap.c                                      |  44 +-
 mm/hugetlb.c                                       |  49 +-
 mm/memory.c                                        |   2 +-
 mm/mempolicy.c                                     |  18 +-
 mm/mmap_lock.c                                     | 175 +----
 mm/vmscan.c                                        |  84 ++-
 net/bridge/br_forward.c                            |   4 +-
 net/core/filter.c                                  |  15 +-
 net/core/flow_dissector.c                          |   2 +-
 net/core/xdp.c                                     |   4 +-
 net/ipv4/esp4.c                                    |   3 +-
 net/ipv4/fib_semantics.c                           |  13 +-
 net/ipv4/fib_trie.c                                |   1 +
 net/ipv4/nexthop.c                                 |   7 +-
 net/ipv4/route.c                                   |  18 +-
 net/ipv4/tcp.c                                     |   2 +-
 net/ipv4/tcp_input.c                               |  32 +-
 net/ipv4/tcp_ipv4.c                                |  11 +-
 net/ipv4/tcp_timer.c                               |   6 +-
 net/ipv6/addrconf.c                                |   3 +-
 net/ipv6/esp6.c                                    |   3 +-
 net/ipv6/tcp_ipv6.c                                |  10 +-
 net/mac80211/cfg.c                                 |   2 +-
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/rate.c                                |   2 +-
 net/mac80211/sta_info.h                            |   6 +-
 net/mac80211/vht.c                                 |  46 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  10 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   4 +-
 net/netfilter/nf_conntrack_netlink.c               |   3 +-
 net/netfilter/nft_set_pipapo.c                     |  22 +-
 net/netfilter/nft_set_pipapo.h                     |  27 +-
 net/netfilter/nft_set_pipapo_avx2.c                |  81 ++-
 net/packet/af_packet.c                             |  86 ++-
 net/smc/smc_core.c                                 |   5 +-
 net/sunrpc/auth_gss/gss_krb5_keys.c                |   2 +-
 net/sunrpc/clnt.c                                  |   3 +-
 net/sunrpc/xprtrdma/frwr_ops.c                     |   3 +-
 net/sunrpc/xprtrdma/verbs.c                        |  16 +-
 net/tipc/udp_media.c                               |   5 +-
 net/unix/af_unix.c                                 |  41 +-
 net/unix/unix_bpf.c                                |   3 +
 net/wireless/util.c                                |   8 +-
 net/xfrm/xfrm_policy.c                             |   5 +-
 net/xfrm/xfrm_state.c                              |  65 +-
 net/xfrm/xfrm_user.c                               |   1 -
 scripts/Kconfig.include                            |   3 +-
 scripts/Makefile.lib                               |   6 +-
 scripts/gcc-x86_32-has-stack-protector.sh          |   2 +-
 scripts/gcc-x86_64-has-stack-protector.sh          |   2 +-
 security/apparmor/lsm.c                            |   7 +
 security/apparmor/policy.c                         |   2 +-
 security/apparmor/policy_unpack.c                  |   1 +
 security/keys/keyctl.c                             |   2 +-
 security/landlock/cred.c                           |  11 +-
 sound/core/ump.c                                   |  13 +
 sound/soc/amd/acp-es8336.c                         |   4 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/cs35l56-shared.c                  |   2 +-
 sound/soc/codecs/max98088.c                        |  10 +-
 sound/soc/codecs/tas2781-fmwlib.c                  |  20 +-
 sound/soc/codecs/tas2781-i2c.c                     |  39 +-
 sound/soc/fsl/fsl_qmc_audio.c                      |   2 +
 sound/soc/intel/common/soc-intel-quirks.h          |   2 +-
 sound/soc/qcom/lpass-cpu.c                         |   4 +
 sound/soc/sof/amd/pci-vangogh.c                    |   1 -
 sound/soc/sof/imx/imx8m.c                          |   2 +-
 sound/soc/sof/ipc4-topology.c                      |   8 +-
 sound/usb/mixer.c                                  |   7 +
 sound/usb/quirks.c                                 |   4 +
 tools/bpf/bpftool/common.c                         |   2 +-
 tools/bpf/bpftool/prog.c                           |   4 +
 tools/bpf/resolve_btfids/main.c                    |   2 +-
 tools/lib/bpf/btf_dump.c                           |   8 +-
 tools/lib/bpf/linker.c                             |  11 +-
 tools/memory-model/lock.cat                        |  20 +-
 tools/perf/arch/x86/util/intel-pt.c                |  15 +-
 tools/perf/tests/shell/test_arm_callgraph_fp.sh    |  27 +-
 tools/perf/tests/workloads/leafloop.c              |  20 +-
 tools/perf/util/pmus.c                             |   5 +-
 tools/perf/util/sort.c                             |   2 +-
 tools/perf/util/stat-shadow.c                      |   7 +
 tools/testing/selftests/bpf/DENYLIST.aarch64       |   1 -
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |  16 +-
 .../testing/selftests/bpf/prog_tests/fexit_sleep.c |   8 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c |   2 +-
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |   2 +-
 .../bpf/progs/btf_dump_test_case_multidim.c        |   4 +-
 .../bpf/progs/btf_dump_test_case_syntax.c          |   4 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   9 +-
 .../drivers/net/mlxsw/spectrum-2/tc_flower.sh      |  55 +-
 tools/testing/selftests/landlock/base_test.c       |  74 +++
 tools/testing/selftests/landlock/config            |   1 +
 tools/testing/selftests/net/fib_tests.sh           |  24 +-
 .../selftests/net/forwarding/devlink_lib.sh        |   2 +
 tools/testing/selftests/resctrl/cache.c            |  10 +-
 tools/testing/selftests/resctrl/cat_test.c         |   8 +-
 tools/testing/selftests/resctrl/cmt_test.c         |   2 +-
 tools/testing/selftests/resctrl/fill_buf.c         |   2 +-
 tools/testing/selftests/resctrl/mba_test.c         |   2 +-
 tools/testing/selftests/resctrl/mbm_test.c         |   2 +-
 tools/testing/selftests/resctrl/resctrl.h          |   4 +-
 tools/testing/selftests/resctrl/resctrl_val.c      | 164 +++--
 tools/testing/selftests/resctrl/resctrlfs.c        |  94 +--
 .../selftests/sigaltstack/current_stack_pointer.h  |   2 +-
 601 files changed, 5320 insertions(+), 3401 deletions(-)


