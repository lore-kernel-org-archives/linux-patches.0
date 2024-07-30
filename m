Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F2D1BA867;
	Tue, 30 Jul 2024 15:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354725; cv=none; b=fdTN/JWbjMGlh0G2Cdmmp8+fu4WzrHtmj1pweWWVcHPCBWDTZwz2YhyN2vsNuv6FPBgj6nnQ/1sm43FOwpV3v0/s/+Cjn8uiWvRnBGKWMNIYT6OUrjsyQ/E4VzFVSAUPlAulfGhL3sUGzB2U/RYUWASC6jc9Ghz7O0wJRnUPWzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354725; c=relaxed/simple;
	bh=mTxLnEtkA3Hd9AXNyK5w4aN+hu/cTDs6a7WCKkcOR9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UxR0Ft1xxT0HvQWBr/bw8CUMV7LZs3KLb58PUGgJPUEBYyJwLWvcWn/8bJUgKHXoe2pyUZz/m+U0zHUUUxx27V8pkl1ohgGJ8bWACBVoMoQtMjARrEnEyuoBmPO+whVx387nSPaVXTxWEDZ0VRbFB5YbyFTmRWW7kSOQTvV0Kxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZXZb8ge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZXZb8ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E55C32782;
	Tue, 30 Jul 2024 15:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354725;
	bh=mTxLnEtkA3Hd9AXNyK5w4aN+hu/cTDs6a7WCKkcOR9g=;
	h=From:To:Cc:Subject:Date:From;
	b=pZXZb8gez0avi6it72YXDITwl5gez6Pmu/+QnH+pU2HvC4YfDtwqX6PMdmQyvhz6N
	 ss7XWbi3rHTj0g3DPWQIWFkJiqq7FX3MBjzpv94JQ1ogQMqG1amzD2yy7nqXQndzWx
	 eKBynxyewMSAVXULcAycO2f5D3rhUV8IQYyMxTUE=
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
Subject: [PATCH 6.10 000/809] 6.10.3-rc1 review
Date: Tue, 30 Jul 2024 17:37:56 +0200
Message-ID: <20240730151724.637682316@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.10.3-rc1
X-KernelTest-Deadline: 2024-08-01T15:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.10.3 release.
There are 809 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.10.3-rc1

James Clark <james.clark@linaro.org>
    perf dso: Fix build when libunwind is enabled

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: fix mbssid max interface advertisement

Seth Forshee (DigitalOcean) <sforshee@kernel.org>
    fs: don't allow non-init s_user_ns for filesystems without FS_USERNS_MOUNT

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: mipi-i3c-hci: Fix number of DAT/DCT entries for HCI versions < 1.1

Leon Romanovsky <leon@kernel.org>
    nvme-pci: add missing condition check for existence of mapped data

Georgia Garcia <georgia.garcia@canonical.com>
    apparmor: unpack transition table if dfa is not present

Ming Lei <ming.lei@redhat.com>
    ublk: fix UBLK_CMD_DEL_DEV_ASYNC handling

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix io_match_task must_hold

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Back off when polling thermal zones on errors

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: trip: Split thermal_zone_device_set_mode()

Artem Chernyshev <artem.chernyshev@red-soft.ru>
    iommu: sprd: Avoid NULL deref in sprd_iommu_hw_en

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_cf: Fix endless loop in CF_DIAG event stop

Vasily Gorbik <gor@linux.ibm.com>
    s390/setup: Fix __pa/__va for modules under non-GPL licenses

Gerd Bayer <gbayer@linux.ibm.com>
    s390/pci: Allow allocation of more than 1 MSI interrupt

Gerd Bayer <gbayer@linux.ibm.com>
    s390/pci: Refactor arch_setup_msi_irqs()

ethanwu <ethanwu@synology.com>
    ceph: fix incorrect kmalloc size of pagevec mempool

Anna-Maria Behnsen <anna-maria@linutronix.de>
    timers/migration: Do not rely always on group->parent

Dan Carpenter <dan.carpenter@linaro.org>
    ASoC: TAS2781: Fix tasdev_load_calibrated_data()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: use soc_intel_is_byt_cr() only when IOSF_MBI is reachable

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/pf: Limit fair VF LMEM provisioning

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/exec: Fix minor bug related to xe_sync_entry_cleanup

Conor Dooley <conor.dooley@microchip.com>
    spi: spidev: add correct compatible for Rohm BH2228FV

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: sof: amd: fix for firmware reload failure in Vangogh platform

Curtis Malainey <cujomalainey@chromium.org>
    ASoC: Intel: Fix RT5650 SSP lookup

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASOC: SOF: Intel: hda-loader: only wait for HDaudio IOC for IPC4 devices

Bart Van Assche <bvanassche@acm.org>
    nvme-pci: Fix the instructions for disabling power management

Steve Wilkins <steve.wilkins@raymarine.com>
    spi: microchip-core: ensure TX and RX FIFOs are empty at start of a transfer

Steve Wilkins <steve.wilkins@raymarine.com>
    spi: microchip-core: fix init function not setting the master and motorola modes

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

Stanislav Fomichev <sdf@fomichev.me>
    xsk: Require XDP_UMEM_TX_METADATA_LEN to actuate tx_metadata_len

Fred Li <dracodingfly@gmail.com>
    bpf: Fix a segment issue when downgrading gso_size

Breno Leitao <leitao@debian.org>
    net: mediatek: Fix potential NULL pointer dereference in dummy net_device handling

Petr Machata <petrm@nvidia.com>
    net: nexthop: Initialize all fields in dumped nexthops

Simon Horman <horms@kernel.org>
    net: stmmac: Correct byte order of perfect_match

Hangbin Liu <liuhangbin@gmail.com>
    selftests: forwarding: skip if kernel not support setting bridge fdb learning limit

Shigeru Yoshida <syoshida@redhat.com>
    tipc: Return non-zero value from tipc_udp_addr2str() on error

David Howells <dhowells@redhat.com>
    netfs: Fix writeback that needs to go to both server and cache

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

Daejun Park <daejun7.park@samsung.com>
    f2fs: fix null reference error when checking end of zone

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    watchdog: rzg2l_wdt: Check return status of pm_runtime_put()

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    watchdog: rzg2l_wdt: Use pm_runtime_resume_and_get()

Sheng Yong <shengyong@oppo.com>
    f2fs: fix start segno of large section

Johannes Berg <johannes.berg@intel.com>
    um: time-travel: fix signal blocking race/hang

David Gow <davidgow@google.com>
    arch: um: rust: Use the generated target.json again

Johannes Berg <johannes.berg@intel.com>
    um: time-travel: fix time-travel-start option

Sean Anderson <sean.anderson@linux.dev>
    phy: zynqmp: Enable reference clock correctly

Ma Ke <make24@iscas.ac.cn>
    phy: cadence-torrent: Check return value on register read

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    phy: phy-rockchip-samsung-hdptx: Select CONFIG_MFD_SYSCON

Vignesh Raghavendra <vigneshr@ti.com>
    dmaengine: ti: k3-udma: Fix BCHAN count with UHC and HC channels

Jeongjun Park <aha310510@gmail.com>
    jfs: Fix array-index-out-of-bounds in diFree

Douglas Anderson <dianders@chromium.org>
    kdb: Use the passed prompt in kdb_position_cursor()

Arnd Bergmann <arnd@arndb.de>
    kdb: address -Wformat-security warnings

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    phy: qcom: qmp-pcie: restore compatibility with existing DTs

Chao Yu <chao@kernel.org>
    f2fs: fix to truncate preallocated blocks in f2fs_file_open()

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: scsi: fix mis-use of 'clamp()' in sr.c

WangYuli <wangyuli@uniontech.com>
    Bluetooth: btusb: Add Realtek RTL8852BE support ID 0x13d3:0x3591

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add RTL8852BE device 0489:e125 to device tables

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

Kim Phillips <kim.phillips@amd.com>
    crypto: ccp - Fix null pointer dereference in __sev_snp_shutdown_locked

Bart Van Assche <bvanassche@acm.org>
    RDMA/iwcm: Fix a use-after-free related to destroying CM IDs

Jiaxun Yang <jiaxun.yang@flygoat.com>
    platform: mips: cpu_hwmon: Disable driver on unsupported hardware

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Use correct queue_id for requesting input pin format

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wcd939x: Fix typec mux and switch leak during device removal

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    bus: mhi: ep: Do not allocate memory for MHI objects from DMA zone

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

Tim Huang <tim.huang@amd.com>
    drm/amdgpu: add missed harvest check for VCN IP v4/v5

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

Mateusz Jończyk <mat.jonczyk@o2.pl>
    md/raid1: set max_sectors during early return from choose_slow_rdev()

Herve Codina <herve.codina@bootlin.com>
    irqdomain: Fixed unbalanced fwnode get and put

Zijun Hu <quic_zijuhu@quicinc.com>
    devres: Fix memory leakage caused by driver API devm_free_percpu()

Zijun Hu <quic_zijuhu@quicinc.com>
    devres: Fix devm_krealloc() wasting memory

Yijie Yang <quic_yijiyang@quicinc.com>
    dt-bindings: phy: qcom,qmp-usb: fix spelling error

Ahmed Zaki <ahmed.zaki@intel.com>
    ice: Add a per-VF limit on number of FDIR filters

Bailey Forrest <bcf@google.com>
    gve: Fix an edge case for TSO skb validity check

Zijun Hu <quic_zijuhu@quicinc.com>
    kobject_uevent: Fix OOB access within zap_modalias_env()

Will Deacon <will@kernel.org>
    arm64: mm: Fix lockless walks with static and dynamic page-table folding

Takashi Iwai <tiwai@suse.de>
    ASoC: amd: yc: Support mic on Lenovo Thinkpad E16 Gen 2

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Preserve the DMA Link ID for ChainDMA on unprepare

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Only handle dai_config with HW_PARAMS for ChainDMA

Suren Baghdasaryan <surenb@google.com>
    alloc_tag: outline and export free_reserved_page()

Nathan Chancellor <nathan@kernel.org>
    kbuild: Fix '-S -c' in x86 stack protector scripts

Ross Lagerwall <ross.lagerwall@citrix.com>
    decompress_bunzip2: fix rare decompression failure

Ram Tummala <rtummala@nvidia.com>
    mm: fix old/young bit handling in the faulting path

Yang Yang <yang.yang@vivo.com>
    block: fix deadlock between sd_remove & sd_release

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    clk: samsung: fix getting Exynos4 fin_pll rate from external clocks

Fedor Pchelkin <pchelkin@ispras.ru>
    ubi: eba: properly rollback inside self_check_eba

Bastien Curutchet <bastien.curutchet@bootlin.com>
    clk: davinci: da8xx-cfgchip: Initialize clk_init_data before use

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: handle inconsistent state in nilfs_btnode_create_block()

Joy Zou <joy.zou@nxp.com>
    dmaengine: fsl-edma: change the memory access from local into remote mode in i.MX 8QM

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

Li Zhijian <lizhijian@fujitsu.com>
    mm/page_alloc: fix pcp->count race between drain_pages_zone() vs __rmqueue_pcplist()

Gao Xiang <xiang@kernel.org>
    erofs: fix race in z_erofs_get_gbuf()

Qiang Ma <maqianga@uniontech.com>
    efi/libstub: Zero initialize heap allocated struct screen_info

Johannes Berg <johannes.berg@intel.com>
    hostfs: fix dev_t handling

tuhaowen <tuhaowen@uniontech.com>
    dev/parport: fix the array out-of-bounds risk

Reka Norman <rekanorman@chromium.org>
    xhci: Apply XHCI_RESET_TO_DEFAULT quirk to TGL

Carlos Llamas <cmllamas@google.com>
    binder: fix hang of unregistered readers

Huacai Chen <chenhuacai@kernel.org>
    PCI: loongson: Enable MSI in LS7A Root Complex

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI: rockchip: Use GPIOD_OUT_LOW flag while requesting ep_gpio

Niklas Cassel <cassel@kernel.org>
    PCI: dw-rockchip: Fix initial PERST# GPIO value

Wei Liu <wei.liu@kernel.org>
    PCI: hv: Return zero, not garbage, when reading PCI_INTERRUPT_PIN

Lukas Wunner <lukas@wunner.de>
    PCI/DPC: Fix use-after-free on concurrent DPC and hot-removal

John David Anglin <dave@mx3210.local>
    parisc: Fix warning at drivers/pci/msi/msi.h:121

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    hwrng: amd - Convert PCIBIOS_* return codes to errnos

Thomas Huth <thuth@redhat.com>
    drm/fbdev-dma: Fix framebuffer mode for big endian devices

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: vesafb: Detect VGA compatibility from screen info's VESA attributes

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

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-lib: fix wrong value as length of header for CIP_NO_HEADER case

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: cs35l41: Fixup remaining asus strix models

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Fold requested virtual interrupt check into has_nested_events()

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Check for pending posted interrupts when looking for nested events

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Request immediate exit iff pending nested event needs injection

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Add a helper to get highest pending from Posted Interrupt vector

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Split out the non-virtualization part of vmx_interrupt_blocked()

Gautam Menghani <gautam@linux.ibm.com>
    KVM: PPC: Book3S HV nestedv2: Add DPDES support in helper library for Guest state buffer

Gautam Menghani <gautam@linux.ibm.com>
    KVM: PPC: Book3S HV nestedv2: Fix doorbell emulation

Jason Chen <Jason-ch.Chen@mediatek.com>
    remoteproc: mediatek: Increase MT8188/MT8195 SCP core0 DRAM size

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

Tommaso Merciai <tomm.merciai@gmail.com>
    media: i2c: alvium: Move V4L2_CID_GAIN to V4L2_CID_ANALOG_GAIN

Wentong Wu <wentong.wu@intel.com>
    media: ivsc: csi: add separate lock for v4l2 control handler

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    leds: mt6360: Fix memory leak in mt6360_init_isnk_properties()

Thomas Weißschuh <linux@weissschuh.net>
    leds: triggers: Flush pending brightness before activating trigger

Ofir Gal <ofir.gal@volumez.com>
    md/md-bitmap: fix writing non bitmap pages

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    leds: ss4200: Convert PCIBIOS_* return codes to errnos

Jay Buddhabhatti <jay.buddhabhatti@amd.com>
    drivers: soc: xilinx: check return status of get_api_version()

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    cpufreq: qcom-nvmem: fix memory leaks in probe error paths

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: usb: Further limit the TX aggregation

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: usb: Fix disconnection after beacon loss

Po-Hao Huang <phhuang@realtek.com>
    wifi: rtw89: fix HW scan not aborting properly

Rafael Beims <rafael.beims@toradex.com>
    wifi: mwifiex: Fix interface type change

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    genirq: Set IRQF_COND_ONESHOT in request_irq()

levi.yun <yeoreum.yun@arm.com>
    trace/pid_list: Change gfp flags in pid_list_fill_irq()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't allow netpolling with SETUP_IOPOLL

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: tighten task exit cancellations

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix lost getsockopt completions

Baokun Li <libaokun1@huawei.com>
    ext4: make sure the first directory block is not a hole

Baokun Li <libaokun1@huawei.com>
    ext4: check dot and dotdot of dx_root before making dir indexed

Ming Lei <ming.lei@redhat.com>
    block: check bio alignment in blk_mq_submit_bio

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

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: fix corruption with high refresh rates on DCN 3.0

Ma Ke <make24@iscas.ac.cn>
    drm/gma500: fix null pointer dereference in psb_intel_lvds_get_modes

Ma Ke <make24@iscas.ac.cn>
    drm/gma500: fix null pointer dereference in cdv_intel_lvds_get_modes

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/io-wq: limit retrying worker initialisation

Paul Moore <paul@paul-moore.com>
    lsm: fixup the inode xattr capability handling

Kory Maincent <kory.maincent@bootlin.com>
    media: i2c: Kconfig: Fix missing firmware upload config select

Jan Kara <jack@suse.cz>
    ext2: Verify bitmap and itable block numbers before using them

Chao Yu <chao@kernel.org>
    hfs: fix to initialize fields of hfs_inode_info after hfs_alloc_inode()

Thomas Weißschuh <linux@weissschuh.net>
    sysctl: always initialize i_uid/i_gid

Igor Pylypiv <ipylypiv@google.com>
    ata: libata-scsi: Honor the D_SENSE bit for CK_COND=1 and no error

Igor Pylypiv <ipylypiv@google.com>
    ata: libata-scsi: Do not overwrite valid sense data when CK_COND=1

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: venus: fix use after free in vdec_close

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    char: tpm: Fix possible memory leak in tpm_bios_measurements_open()

Vitor Soares <vitor.soares@toradex.com>
    tpm_tis_spi: add missing attpm20p SPI device ID entry

Thomas Weißschuh <linux@weissschuh.net>
    selftests/nolibc: fix printf format mismatch in expect_str_buf_eq()

Igor Pylypiv <ipylypiv@google.com>
    ata: libata-scsi: Fix offsets for the fixed format sense data

Damien Le Moal <dlemoal@kernel.org>
    null_blk: Fix description of the fua parameter

Alain Volmat <alain.volmat@foss.st.com>
    media: stm32: dcmipp: correct error handling in dcmipp_create_subdevs

Yu Kuai <yukuai3@huawei.com>
    md/raid5: fix spares errors about rcu usage

Eric Sandeen <sandeen@redhat.com>
    fuse: verify {g,u}id mount options correctly

Tejun Heo <tj@kernel.org>
    sched/fair: set_load_weight() must also call reweight_task() for SCHED_IDLE tasks

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: mac80211: chanctx emulation set CHANGE_CHANNEL when in_reconfig

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Support write delegations in LAYOUTGET

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Use write-back caching mode for system memory on DGFX

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: take care of scope when choosing the src addr

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv4: fix source address selection with route leak

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: fix source address selection with route leak

Pavel Begunkov <asml.silence@gmail.com>
    kernel: rerun task_work while freezing in get_signal()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix extent map use-after-free when adding pages to compressed bio

Lai Jiangshan <jiangshan.ljs@antgroup.com>
    workqueue: Always queue work items to the newest PWQ for order workqueues

Chengen Du <chengen.du@canonical.com>
    af_packet: Handle outgoing VLAN packets without hardware offloading

Breno Leitao <leitao@debian.org>
    net: netconsole: Disable target before netpoll cleanup

Yu Liao <liaoyu15@huawei.com>
    tick/broadcast: Make takeover of broadcast hrtimer reliable

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: thermal: correct thermal zone node name limit

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    thermal/drivers/broadcom: Fix race between removal and clock disable

Sungjong Seo <sj1557.seo@samsung.com>
    exfat: fix potential deadlock on __exfat_get_dentry_set

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    Revert "firewire: Annotate struct fw_iso_packet with __counted_by()"

Ard Biesheuvel <ardb@kernel.org>
    x86/efistub: Revert to heap allocated boot_params for PE entrypoint

Ard Biesheuvel <ardb@kernel.org>
    x86/efistub: Avoid returning EFI_SUCCESS on error

Yu Zhao <yuzhao@google.com>
    mm/mglru: fix ineffective protection calculation

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

Gavin Shan <gshan@redhat.com>
    mm/huge_memory: avoid PMD-size page cache if needed

Yang Shi <yang@os.amperecomputing.com>
    mm: huge_memory: use !CONFIG_64BIT to relax huge page alignment on 32 bit machines

Jann Horn <jannh@google.com>
    landlock: Don't lose track of restrictions on cred_transfer

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Add cred_transfer test

Jason-JH.Lin <jason-jh.lin@mediatek.com>
    mailbox: mtk-cmdq: Move devm_mbox_controller_register() after devm_pm_runtime_enable()

Peng Fan <peng.fan@nxp.com>
    mailbox: imx: fix TXDB_V2 channel race condition

Andrew Davis <afd@ti.com>
    mailbox: omap: Fix mailbox interrupt sharing

Richard Genoud <richard.genoud@bootlin.com>
    remoteproc: k3-r5: Fix IPC-only mode detection

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    remoteproc: mediatek: Don't attempt to remap l1tcm memory if missing

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    power: supply: ingenic: Fix some error handling paths in ingenic_battery_get_property()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    power: supply: ab8500: Fix error handling when calling iio_read_channel_processed()

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Check TIF_LOAD_WATCH to enable user space watchpoint

Yang Yang <yang.yang@vivo.com>
    sbitmap: fix io hung due to race on sbitmap_word::cleared

Suren Baghdasaryan <surenb@google.com>
    alloc_tag: fix page_ext_get/page_ext_put sequence during page splitting

Suren Baghdasaryan <surenb@google.com>
    lib: reuse page_ext_data() to obtain codetag_ref

Suren Baghdasaryan <surenb@google.com>
    lib: add missing newline character in the warning message

Carlos López <clopez@suse.de>
    s390/dasd: fix error checks in dasd_copy_pair_store()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/8xx: fix size given to set_huge_pte_at()

Heming Zhao <heming.zhao@suse.com>
    md-cluster: fix hanging issue while a new disk adding

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

SeongJae Park <sj@kernel.org>
    selftests/damon/access_memory: use user-defined region size

David Hildenbrand <david@redhat.com>
    fs/proc/task_mmu: properly detect PM_MMAP_EXCLUSIVE per page of PMD-mapped THPs

David Hildenbrand <david@redhat.com>
    fs/proc/task_mmu: don't indicate PM_MMAP_EXCLUSIVE without PM_PRESENT

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

Richard Genoud <richard.genoud@bootlin.com>
    rtc: tps6594: Fix memleak in probe

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

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: ctnetlink: use helper function to calculate expect ID

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Fix fallback march for SB1

Konstantin Taranov <kotaranov@microsoft.com>
    RDMA/mana_ib: Set correct device into ib

Konstantin Taranov <kotaranov@microsoft.com>
    RDMA/mana_ib: set node_guid

Jack Wang <jinpu.wang@ionos.com>
    bnxt_re: Fix imm_data endianness

David Ahern <dsahern@kernel.org>
    RDMA: Fix netdev tracker in ib_device_set_netdev

David Gstir <david@sigma-star.at>
    crypto: mxs-dcp - Ensure payload is zero when using key slot

Jon Pan-Doh <pandoh@google.com>
    iommu/vt-d: Fix identity map bounds in si_domain_init()

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix mbx timing out before CMD execution is completed

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
    RDMA/hns: Fix soft lockup under heavy CEQE load

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Check atomic wr length

Nick Bowler <nbowler@draconx.ca>
    macintosh/therm_windtunnel: fix module unload.

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/xmon: Fix disassembly CPU feature checks

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix aligned pages in calculate_psi_aligned_address()

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Limit max address mask to MAX_AGAW_PFN_WIDTH

Frank Li <Frank.Li@nxp.com>
    PCI: dwc: Fix index 0 incorrectly being interpreted as a free ATU slot

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI: qcom-ep: Disable resources unconditionally during PERST# assert

Dominique Martinet <dominique.martinet@atmark-techno.com>
    MIPS: Octeron: remove source file executable bit

Lorenzo Bianconi <lorenzo@kernel.org>
    clk: en7523: fix rate divider for slic and spi clocks

Stephen Boyd <swboyd@chromium.org>
    clk: qcom: Park shared RCGs upon registration

Abel Vesa <abel.vesa@linaro.org>
    clk: qcom: gcc-x1e80100: Set parent rate for USB3 sec and tert PHY pipe clks

Chen Ni <nichen@iscas.ac.cn>
    clk: qcom: kpss-xcc: Return of_clk_add_hw_provider to transfer the error

Nivas Varadharajan Mugunthakumar <nivasx.varadharajan.mugunthakumar@intel.com>
    crypto: qat - extend scope of lock in adf_cfg_add_key_value_param()

Heiko Stuebner <heiko.stuebner@cherry.de>
    nvmem: rockchip-otp: set add_legacy_fixed_of_cells config option

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Revise lpfc_prep_embed_io routine with proper endian macro usages

Denis Arefev <arefev@swemel.ru>
    net: missing check virtio

Michael S. Tsirkin <mst@redhat.com>
    vhost/vsock: always initialize seqpacket_allow

Dan Carpenter <dan.carpenter@linaro.org>
    PCI: endpoint: Fix error handling in epf_ntb_epc_cleanup()

Dan Carpenter <dan.carpenter@linaro.org>
    PCI: endpoint: Clean up error handling in vpci_scan_bus()

Georgi Djakov <quic_c_gdjako@quicinc.com>
    iommu/arm-smmu-qcom: Register the TBU driver in qcom_smmu_impl_init

Aleksandr Mishin <amishin@t-argos.ru>
    ASoC: amd: Adjust error handling in case of absent codec device

Guenter Roeck <linux@roeck-us.net>
    eeprom: ee1004: Call i2c_new_scanned_device to instantiate thermal sensor

Christoph Schlameuss <schlameuss@linux.ibm.com>
    kvm: s390: Reject memory region operations for ucontrol VMs

Benjamin Marzinski <bmarzins@redhat.com>
    dm-raid: Fix WARN_ON_ONCE check for sync_thread in raid_resume

Abel Vesa <abel.vesa@linaro.org>
    clk: qcom: gcc-x1e80100: Fix halt_check for all pipe clocks

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: elan_i2c - do not leave interrupt disabled on suspend failure

Leon Romanovsky <leon@kernel.org>
    RDMA/device: Return error earlier if port in not valid

Arnd Bergmann <arnd@arndb.de>
    mtd: make mtd_test.c a separate module

Joao Martins <joao.m.martins@oracle.com>
    iommufd/iova_bitmap: Check iova_bitmap_done() after set ahead

Joao Martins <joao.m.martins@oracle.com>
    iommufd/selftest: Fix tests to use MOCK_PAGE_SIZE based buffer sizes

Joao Martins <joao.m.martins@oracle.com>
    iommufd/selftest: Add tests for <= u8 bitmap sizes

Joao Martins <joao.m.martins@oracle.com>
    iommufd/selftest: Fix iommufd_test_dirty() to handle <u8 bitmaps

Joao Martins <joao.m.martins@oracle.com>
    iommufd/selftest: Fix dirty bitmap tests with u8 bitmaps

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

Michael Walle <mwalle@kernel.org>
    mtd: spi-nor: winbond: fix w25q128 regression

Leon Romanovsky <leon@kernel.org>
    RDMA/cache: Release GID table even if leak is detected

Hao Ge <gehao@kylinos.cn>
    ASoc: PCM6240: Return directly after a failed devm_kzalloc() in pcmdevice_i2c_probe()

Neil Armstrong <neil.armstrong@linaro.org>
    usb: typec-mux: nb7vpq904m: unregister typec switch on probe error and remove

Neil Armstrong <neil.armstrong@linaro.org>
    usb: typec-mux: ptn36502: unregister typec switch on probe error and remove

Simon Trimmer <simont@opensource.cirrus.com>
    ASoC: cs35l56: Accept values greater than 0 as IRQ numbers

Shenghao Ding <shenghao-ding@ti.com>
    ASoc: tas2781: Enable RCA-based playback without DSP firmware download

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/kexec_file: fix cpus node update to FDT

Chiara Meiohas <cmeiohas@nvidia.com>
    RDMA/mlx5: Set mkeys for dmabuf at PAGE_SIZE

James Clark <james.clark@arm.com>
    coresight: Fix ref leak when of_coresight_parse_endpoint() fails

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    KVM: PPC: Book3S HV: Fix the get_one_reg of SDAR

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    KVM: PPC: Book3S HV: Fix the set_one_reg for MMCR3

Mostafa Saleh <smostafa@google.com>
    iommu/arm-smmu-v3: Avoid uninitialized asid in case of error

Nuno Sa <nuno.sa@analog.com>
    iio: adc: adi-axi-adc: don't allow concurrent enable/disable calls

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: frequency: adrf6780: rm clk provider include

Nuno Sa <nuno.sa@analog.com>
    iio: adc: ad9467: use DMA safe buffer for spi

Xianwei Zhao <xianwei.zhao@amlogic.com>
    clk: meson: s4: fix pwm_j_div parent clock

Xianwei Zhao <xianwei.zhao@amlogic.com>
    clk: meson: s4: fix fixed_pll_dco clock

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: camcc-sc7280: Add parent dependency to all camera GDSCs

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: gcc-sc7280: Update force mem core bit for UFS ICE clock

Lothar Rubusch <l.rubusch@gmail.com>
    crypto: atmel-sha204a - fix negated return value

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: tegra - Remove an incorrect iommu_fwspec_free() call in tegra_se_remove()

Minwoo Im <minwoo.im@samsung.com>
    scsi: ufs: mcq: Fix missing argument 'hba' in MCQ_OPR_OFFSET_n

Andy Chiu <andy.chiu@sifive.com>
    riscv: smp: fail booting up smp if inconsistent vlen is detected

Jon Hunter <jonathanh@nvidia.com>
    PCI: tegra194: Set EP alignment restriction for inbound ATU

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

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI: endpoint: pci-epf-test: Make use of cached 'epc_features' in pci_epf_test_core_init()

Chenyuan Yang <chenyuan0y@gmail.com>
    iio: Fix the sorting functionality in iio_gts_build_avail_time_table

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Fixup gss_status tracepoint error output

Christoph Hellwig <hch@lst.de>
    nfs: pass explicit offset/count to trace events

Luke D. Jones <luke@ljones.dev>
    platform/x86: asus-wmi: fix TUF laptop RGB variant

Ian Rogers <irogers@google.com>
    perf dso: Fix address sanitizer build

Andreas Larsson <andreas@gaisler.com>
    sparc64: Fix incorrect function signature and add prototype for prom_cif_init

Dan Carpenter <dan.carpenter@linaro.org>
    leds: flash: leds-qcom-flash: Test the correct variable in init

Thomas Zimmermann <tzimmermann@suse.de>
    drm/qxl: Pin buffer objects for internal mappings

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

Steven Price <steven.price@arm.com>
    drm/panthor: Record devfreq busy as soon as a job is started

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix exclude_guest setting

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix aux_watermark calculation for 64-bit size

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: venus: flush all buffers in output plane streamoff

Namhyung Kim <namhyung@kernel.org>
    perf stat: Fix a segfault with --per-cluster --metric-only

Michael Walle <mwalle@kernel.org>
    drm/mediatek/dp: Fix spurious kfree()

Michael Walle <mwalle@kernel.org>
    drm/mediatek: dpi/dsi: Fix possible_crtcs calculation

James Clark <james.clark@arm.com>
    perf pmu: Restore full PMU name wildcard support

Ian Rogers <irogers@google.com>
    perf tests: Add some pmu core functionality tests

Ma Ke <make24@iscas.ac.cn>
    drm/amd/display: Add null check before access structs

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix infinite loop when replaying fast_commit

Hsiao Chien Sung <shawn.sung@mediatek.com>
    drm/mediatek: Remove less-than-zero comparison of an unsigned value

Geert Uytterhoeven <geert+renesas@glider.be>
    drm/panic: Do not select DRM_KMS_HELPER

Jocelyn Falempe <jfalempe@redhat.com>
    drm/panic: depends on !VT_CONSOLE

Luca Ceresoli <luca.ceresoli@bootlin.com>
    Revert "leds: led-core: Fix refcount leak in of_led_get()"

Anjelique Melendez <quic_amelende@quicinc.com>
    leds: rgb: leds-qcom-lpg: Add PPG check for setting/clearing PBS triggers

Chen Ni <nichen@iscas.ac.cn>
    drm/qxl: Add check for drm_cvt_mode

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: fix DMA direction handling for cached RW buffers

Namhyung Kim <namhyung@kernel.org>
    perf report: Fix condition in sort__sym_cmp()

Junhao He <hejunhao3@huawei.com>
    perf pmus: Fixes always false when compare duplicates aliases

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    tools/perf: Fix the string match for "/tmp/perf-$PID.map" files in dso__load

James Clark <james.clark@arm.com>
    perf test: Make test_arm_callgraph_fp.sh more robust

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    platform/arm64: build drivers even on non-ARM64 platforms

Geert Uytterhoeven <geert+renesas@glider.be>
    drm/panic: Fix off-by-one logo size checks

Jocelyn Falempe <jfalempe@redhat.com>
    drm/panic: only draw the foreground color in drm_panic_blit()

Karolina Stolarek <karolina.stolarek@intel.com>
    drm/ttm/tests: Fix a warning in ttm_bo_unreserve_bulk

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dpu: drop validity checks for clear_pending_flush() ctl op

Jonathan Marek <jonathan@marek.ca>
    drm/msm/dsi: set VIDEO_COMPRESSION_MODE_CTRL_WC

Jonathan Marek <jonathan@marek.ca>
    drm/msm/dsi: set video mode widebus enable bit when widebus is enabled

Hans de Goede <hdegoede@redhat.com>
    leds: trigger: Unregister sysfs attributes before calling deactivate()

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Drop initial source change event if capture has been setup

Konrad Dybcio <konrad.dybcio@linaro.org>
    drm/msm/a6xx: Fix A702 UBWC mode

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/a6xx: use __unused__ to fix compiler warnings for gen7_* includes

Hsiao Chien Sung <shawn.sung@mediatek.com>
    drm/mediatek: Set DRM mode configs accordingly

Hsiao Chien Sung <shawn.sung@mediatek.com>
    drm/mediatek: Add DRM_MODE_ROTATE_0 to rotation property

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

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    drm/ttm/tests: Let ttm_bo_test consider different ww_mutex implementation.

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

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Set SU area width as pipe src width

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

Conor Dooley <conor.dooley@microchip.com>
    media: i2c: imx219: fix msr access command sequence

Ricardo Ribalda <ribalda@chromium.org>
    media: c8sectpfe: Add missing parameter names

Aleksandr Burakov <a.burakov@rosalinux.ru>
    saa7134: Unchecked i2c_transfer function result fixed

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: use pre-allocated temp structure for bounding box

Dan Carpenter <dan.carpenter@linaro.org>
    ipmi: ssif_bmc: prevent integer overflow on 32bit systems

Jiri Olsa <jolsa@kernel.org>
    x86/shstk: Make return uprobe work with shadow stack

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Print Panel Replay status instead of frame lock status

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/display: Skip Panel Replay on pipe comparison if no active planes

Adam Ford <aford173@gmail.com>
    drm/bridge: samsung-dsim: Set P divider based on min/max of fin pll

Yunfei Dong <yunfei.dong@mediatek.com>
    media: mediatek: vcodec: Fix unreasonable data conversion

Irui Wang <irui.wang@mediatek.com>
    media: mediatek: vcodec: Handle invalid decoder vsi

Ian Rogers <irogers@google.com>
    perf maps: Fix use after free in __maps__fixup_overlap_and_insert

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dp: fix runtime_pm handling in dp_wait_hpd_asserted

Junhao Xie <bigfoot@classfun.cn>
    drm/msm/dpu: drop duplicate drm formats from wb2_formats arrays

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    Revert "drm/msm/dpu: drop dpu_encoder_phys_ops.atomic_mode_set"

Barnabás Czémán <trabarni@gmail.com>
    drm/msm/dpu: fix encoder irq wait skip

David Hildenbrand <david@redhat.com>
    s390/uv: Don't call folio_wait_writeback() without a folio reference

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix type mismatch in amdgpu_gfx_kiq_init_ring

ChiYuan Huang <cy_huang@richtek.com>
    media: v4l: async: Fix NULL pointer dereference in adding ancillary links

Ricardo Ribalda <ribalda@chromium.org>
    media: i2c: hi846: Fix V4L2_SUBDEV_FORMAT_TRY get_selection()

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: i2c: Fix imx412 exposure control

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Use enable boolean from intel_crtc_state for Early Transport

Ricardo Ribalda <ribalda@chromium.org>
    media: imon: Fix race getting ictx->lock

Zheng Yejian <zhengyejian1@huawei.com>
    media: dvb-usb: Fix unexpected infinite loop in dvb_usb_read_remote_control()

Mikhail Kobuk <m.kobuk@ispras.ru>
    media: pci: ivtv: Add check for DMA map result

Arnd Bergmann <arnd@arndb.de>
    drm/amd/display: Move 'struct scaler_data' off stack

Arnd Bergmann <arnd@arndb.de>
    drm/amd/display: fix graphics_object_id size

Arnd Bergmann <arnd@arndb.de>
    drm/amd/display: dynamically allocate dml2_configuration_options structures

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix snprintf usage in amdgpu_gfx_kiq_init_ring

Kuro Chung <kuro.chung@ite.com.tw>
    drm/bridge: it6505: fix hibernate to resume no display issue

Douglas Anderson <dianders@chromium.org>
    drm/panel: ilitek-ili9882t: Check for errors on the NOP in prepare()

Douglas Anderson <dianders@chromium.org>
    drm/panel: ilitek-ili9882t: If prepare fails, disable GPIO before regulators

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

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/panel: lg-sw43408: add missing error handling

Douglas Anderson <dianders@chromium.org>
    drm/mipi-dsi: Fix theoretical int overflow in mipi_dsi_generic_write_seq()

Douglas Anderson <dianders@chromium.org>
    drm/mipi-dsi: Fix theoretical int overflow in mipi_dsi_dcs_write_seq()

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/display: Do not print "psr: enabled" for on Panel Replay

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Rename has_psr2 as has_sel_update

Mukul Joshi <mukul.joshi@amd.com>
    drm/amdkfd: Fix CU Masking for GFX 9.4.3

Faiz Abbas <faiz.abbas@arm.com>
    drm/arm/komeda: Fix komeda probe failing if there are no links in the secondary pipeline

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Fix the port mux of VP2

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Don't access uninit tcp_rsk(req)->ao_keyid in tcp_create_openreq_child().

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix usage of __hci_cmd_sync_status

Elliot Ayrey <elliot.ayrey@alliedtelesis.co.nz>
    net: bridge: mst: Check vlan state for egress decision

Taehee Yoo <ap420073@gmail.com>
    xdp: fix invalid wait context of page_pool_destroy()

Breno Leitao <leitao@debian.org>
    virtio_net: Fix napi_skb_cache_put warning

Jiri Pirko <jiri@resnulli.us>
    virtio_net: add support for Byte Queue Limits

Dmitry Antipov <dmantipov@yandex.ru>
    Bluetooth: hci_core, hci_sync: cleanup struct discovery_state

Iulia Tanasescu <iulia.tanasescu@nxp.com>
    Bluetooth: hci_event: Set QoS encryption from BIGInfo report

Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
    Bluetooth: btnxpuart: Add handling for boot-signature timeout errors

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Fix irq leak

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel: Refactor btintel_set_ppag()

Sven Peter <sven@svenpeter.dev>
    Bluetooth: hci_bcm4377: Use correct unit for timeouts

Amit Cohen <amcohen@nvidia.com>
    selftests: forwarding: devlink_lib: Wait for udev events after reloading

Kory Maincent <kory.maincent@bootlin.com>
    net: ethtool: pse-pd: Fix possible null-deref

Kory Maincent <kory.maincent@bootlin.com>
    net: pse-pd: Do not return EOPNOSUPP if config is null

Tengda Wu <wutengda@huaweicloud.com>
    bpf: Fix null pointer dereference in resolve_prog_type() for BPF_PROG_TYPE_EXT

Jeff Layton <jlayton@kernel.org>
    nfsd: nfsd_file_lease_notifier_call gets a file_lease as an argument

Shung-Hsi Yu <shung-hsi.yu@suse.com>
    bpf: fix overflow check in adjust_jmp_off()

Alan Maguire <alan.maguire@oracle.com>
    bpf: Eliminate remaining "make W=1" warnings in kernel/bpf/btf.o

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    bna: adjust 'name' buf size of bna_tcb and bna_ccb structures

Alan Maguire <alan.maguire@oracle.com>
    bpf: annotate BTF show functions with __printf

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    selftests/resctrl: Fix closing IMC fds on error and open-code R+W instead of loops

Puranjay Mohan <puranjay@kernel.org>
    bpf, arm64: Fix trampoline for BPF_TRAMP_F_CALL_ORIG

Geliang Tang <geliang@kernel.org>
    selftests/bpf: Close obj in error path in xdp_adjust_tail

Geliang Tang <geliang@kernel.org>
    selftests/bpf: Null checks for links in bpf_tcp_ca

Geliang Tang <geliang@kernel.org>
    selftests/bpf: Close fd in error path in drop_on_reuseport

John Stultz <jstultz@google.com>
    locking/rwsem: Add __always_inline annotation to __down_write_common() and inlined callers

Johannes Berg <johannes.berg@intel.com>
    wifi: virt_wifi: don't use strlen() in const context

Johannes Berg <johannes.berg@intel.com>
    net: page_pool: fix warning code

Gaosheng Cui <cuigaosheng1@huawei.com>
    gss_krb5: Fix the error handling path for crypto_sync_skcipher_setkey

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix nfsdcld warning

Benjamin Tissoires <bentiss@kernel.org>
    bpf: helpers: fix bpf_wq_set_callback_impl signature

En-Wei Wu <en-wei.wu@canonical.com>
    wifi: virt_wifi: avoid reporting connection success with wrong SSID

Jianbo Liu <jianbol@nvidia.com>
    xfrm: call xfrm_dev_policy_delete when kill policy

Jianbo Liu <jianbol@nvidia.com>
    xfrm: fix netdev reference count imbalance

Aleksandr Mishin <amishin@t-argos.ru>
    wifi: rtw89: Fix array index mistake in rtw89_sta_info_get_iter()

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Fix DF and UMC domain identification

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Avoid PMU registration if counters are unavailable

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

Ilya Leoshkevich <iii@linux.ibm.com>
    bpf: Fix atomic probe zero-extension

Tao Chen <chen.dylane@gmail.com>
    bpftool: Mount bpffs when pinmaps path not under the bpffs

Pu Lehui <pulehui@huawei.com>
    riscv, bpf: Fix out-of-bounds issue when preparing trampoline image

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Export symbol xfrm_dev_state_delete.

Martin Kaistra <martin.kaistra@linutronix.de>
    wifi: rtl8xxxu: 8188f: Limit TX power index

Kuan-Chung Chen <damon.chen@realtek.com>
    wifi: rtw89: 8852b: fix definition of KIP register number

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: wow: fix GTK offload H2C skbuff issue

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: fix peer metadata parsing

Aloka Dixit <quic_alokad@quicinc.com>
    wifi: ath12k: advertise driver capabilities for MBSSID and EMA

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: always unblock EMLSR on ROC end

Daniel Gabay <daniel.gabay@intel.com>
    wifi: iwlwifi: fix iwl_mvm_get_valid_rx_ant()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: correcty limit wider BW TDLS STAs

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: add ieee80211_tdls_sta_link_id()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: rise cap on SELinux secmark context

Ismael Luceno <iluceno@suse.de>
    ipvs: Avoid unnecessary calls to skb_is_gso_sctp

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Fix unregister netdevice hang on hardware offload.

Antoine Tenart <atenart@kernel.org>
    libbpf: Skip base btf sanity checks

Donglin Peng <dolinux.peng@gmail.com>
    libbpf: Checking the btf_type kind when fixing variable offsets

Jiri Olsa <jolsa@kernel.org>
    bpf: Change bpf_session_cookie return value to __u64 *

Lukasz Majewski <lukma@denx.de>
    net: dsa: ksz_common: Allow only up to two HSR HW offloaded ports for KSZ9477

Csókás, Bence <csokas.bence@prolan.hu>
    net: fec: Fix FEC_ECR_EN1588 being cleared on link-down

Jan Kara <jack@suse.cz>
    udf: Fix bogus checksum computation in udf_rename()

Antony Antony <antony.antony@secunet.com>
    xfrm: Log input direction mismatch error in one place

Antony Antony <antony.antony@secunet.com>
    xfrm: Fix input error path memory access

Daniel Xu <dxu@dxuuu.xyz>
    bpf: Make bpf_session_cookie() kfunc return long *

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: separate non-BSS/ROC EMLSR blocking

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mvm: fix re-enabling EMLSR

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: expose can-monitor channel property

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: cfg80211: handle 2x996 RU allocation in cfg80211_calculate_bitrate_he()

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: cfg80211: fix typo in cfg80211_calculate_bitrate_he()

Aditya Kumar Singh <quic_adisi@quicinc.com>
    wifi: ath12k: fix per pdev debugfs registration

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: fix wrong handling of CCMP256 and GCMP ciphers

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: fix ACPI warning when resume

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

Sean Christopherson <seanjc@google.com>
    sched/core: Drop spinlocks on contention iff kernel is preemptible

Sean Christopherson <seanjc@google.com>
    sched/core: Move preempt_model_*() helpers from sched.h to preempt.h

Jan Kara <jack@suse.cz>
    udf: Fix lock ordering in udf_evict_inode()

Geliang Tang <geliang@kernel.org>
    selftests/bpf: Check length of recv in test_sockmap

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: set rmb's SG_MAX_SINGLE_ALLOC limitation only when CONFIG_ARCH_NO_SG_CHAIN is defined

Andrii Nakryiko <andrii@kernel.org>
    libbpf: keep FD_CLOEXEC flag when dup()'ing FD

Arnd Bergmann <arnd@arndb.de>
    hns3: avoid linking objects into multiple modules

Eric Dumazet <edumazet@google.com>
    tcp: fix races in tcp_v[46]_err()

Eric Dumazet <edumazet@google.com>
    tcp: fix races in tcp_abort()

Eric Dumazet <edumazet@google.com>
    tcp: fix race in tcp_write_err()

Eric Dumazet <edumazet@google.com>
    tcp: add tcp_done_with_error() helper

Linus Walleij <linus.walleij@linaro.org>
    net: ethernet: cortina: Restore TSO support

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: fix wrong definition of CE ring's base address

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: fix wrong definition of CE ring's base address

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: 8852c: correct logic and restore PCI PHY EQ after device resume

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: fix firmware crash during reo reinject

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: fix invalid memory access while processing fragmented packets

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: change DMA direction while mapping reinjected packets

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: restore country code during resume

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: refactor setting country code logic

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: reset negotiated TTLM on disconnect

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: cancel TTLM teardown work earlier

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: cancel multi-link reconf work on disconnect

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix TTLM teardown work

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mvm: don't skip link selection

Hagar Hemdan <hagarhem@amazon.com>
    net: esp: cleanup esp_output_tail_tcp() in case of unsupported ESPINTCP

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: 8852b: restore setting for RFE type 5 after device resume

Geliang Tang <geliang@kernel.org>
    selftests/bpf: Fix prog numbers in test_sockmap

Ivan Babrou <ivan@cloudflare.com>
    bpftool: Un-const bpf_func_info to fix it for llvm 17 and newer

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: fix Smatch warnings on ath12k_core_suspend()

Nithyanantham Paramasivam <quic_nithp@quicinc.com>
    wifi: ath12k: Fix tx completion ring (WBM2SW) setup failure

Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>
    wifi: ath12k: Correct 6 GHz frequency value in rx status

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    wifi: brcmsmac: LCN PHY code is used for BCM4313 2G-only device

Kang Yang <quic_kangyang@quicinc.com>
    wifi: ath12k: avoid duplicated vdev stop

Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
    wifi: ath12k: drop failed transmitted frames from metric calculation.

Sven Eckelmann <sven@narfation.org>
    wifi: ath12k: Don't drop tx_status in failure case

Marek Behún <kabel@kernel.org>
    firmware: turris-mox-rwtm: Initialize completion before mailbox

Marek Behún <kabel@kernel.org>
    firmware: turris-mox-rwtm: Fix checking return value of wait_for_completion_timeout()

Marek Behún <kabel@kernel.org>
    firmware: turris-mox-rwtm: Do not complete if there are no waiters

Christophe Leroy <christophe.leroy@csgroup.eu>
    vmlinux.lds.h: catch .bss..L* sections into BSS")

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sev: Do RMP memory coverage check after max_pfn has been set

Yanjun Yang <yangyj.ee@gmail.com>
    ARM: Remove address checking for MMUless devices

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    ARM: spitz: fix GPIO assignment for backlight

Thorsten Blum <thorsten.blum@toblux.com>
    m68k: cmpxchg: Fix return value for default case in __arch_xchg()

Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
    cpufreq/amd-pstate: Fix the scaling_max_freq setting on shared memory CPPC systems

Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
    cpufreq/amd-pstate-ut: Convert nominal_freq to khz during comparisons

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

Dang Huynh <danct12@riseup.net>
    arm64: dts: qcom: qrb4210-rb2: Correct max current draw for VBUS

Chen Ni <nichen@iscas.ac.cn>
    x86/xen: Convert comma to semicolon

Abel Vesa <abel.vesa@linaro.org>
    arm64: dts: qcom: x1e80100: Fix USB HS PHY 0.8V supply

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mp: Fix pgc vpu locations

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mp: Fix pgc_mlmix location

Eero Tamminen <oak@helsinkinet.fi>
    m68k: atari: Fix TT bootup freeze / unexpected (SCU) interrupt messages

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r9a08g045: Add missing hypervisor virtual timer IRQ

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

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r8a779h0: Drop "opp-shared" from opp-table-0

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

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    soc: mediatek: mtk-mutex: Add MDP_TCC0 mod to MT8188 mutex table

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-kukui-jacuzzi: Add ports node for anx7625

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-pico6: Fix wake-on-X event node names

Hsin-Te Yuan <yuanhsinte@chromium.org>
    arm64: dts: mediatek: mt8183-kukui: Fix the value of `dlg,jack-det-rate` mismatch

Rafał Miłecki <rafal@milecki.pl>
    arm64: dts: mediatek: mt7622: fix "emmc" pinctrl mux

Rafał Miłecki <rafal@milecki.pl>
    arm64: dts: mediatek: mt7981: fix code alignment for PWM clocks

Pin-yen Lin <treapking@chromium.org>
    arm64: dts: mediatek: mt8192-asurada: Add off-on-delay-us for pp3300_mipibrdg

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-kukui: Drop bogus output-enable property

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: medaitek: mt8395-nio-12l: Set i2c6 pins to bias-disable

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8192: Fix GPU thermal zone name for SVS

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

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    arm64: dts: qcom: sc7180-trogdor: Disable pwmleds node where unused

Jai Luthra <j-luthra@ti.com>
    arm64: dts: ti: k3-am62p5-sk: Fix pinmux for McASP1 TX

Jai Luthra <j-luthra@ti.com>
    arm64: dts: ti: k3-am625-phyboard-lyra-rdk: Drop McASP AFIFOs

Jai Luthra <j-luthra@ti.com>
    arm64: dts: ti: k3-am62-verdin: Drop McASP AFIFOs

Jai Luthra <j-luthra@ti.com>
    arm64: dts: ti: k3-am625-beagleplay: Drop McASP AFIFOs

Jai Luthra <j-luthra@ti.com>
    arm64: dts: ti: k3-am62p5: Drop McASP AFIFOs

Jai Luthra <j-luthra@ti.com>
    arm64: dts: ti: k3-am62a7: Drop McASP AFIFOs

Jai Luthra <j-luthra@ti.com>
    arm64: dts: ti: k3-am62x: Drop McASP AFIFOs

Vaishnav Achath <vaishnav.a@ti.com>
    arm64: dts: ti: k3-j722s: Fix main domain GPIO count

Josua Mayer <josua@solid-run.com>
    arm64: dts: ti: k3-am642-hummingboard-t: correct rs485 rts polarity

Jayesh Choudhary <j-choudhary@ti.com>
    arm64: dts: ti: k3-am62p-main: Fix the reg-range for main_pktdma

Jayesh Choudhary <j-choudhary@ti.com>
    arm64: dts: ti: k3-am62a-main: Fix the reg-range for main_pktdma

Jayesh Choudhary <j-choudhary@ti.com>
    arm64: dts: ti: k3-am62-main: Fix the reg-range for main_pktdma

Esben Haabendal <esben@geanix.com>
    memory: fsl_ifc: Make FSL_IFC config visible and selectable

Primoz Fiser <primoz.fiser@norik.com>
    OPP: ti: Fix ti_opp_supply_probe wrong return values

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: sc8280xp: Throttle the GPU when overheating

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: sc8280xp-*: Remove thermal zone polling delays

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

Viresh Kumar <viresh.kumar@linaro.org>
    OPP: Fix missing cleanup on error in _opp_attach_genpd()

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    cpufreq: sun50i: fix memory leak in dt_has_supported_hw()

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
    arm64: dts: qcom: sm6350: add power-domain to UFS PHY

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm6115: add power-domain to UFS PHY

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sdm845: add power-domain to UFS PHY

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sc8180x: add power-domain to UFS PHY

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sc7180: drop extra UFS PHY compat

Rayyan Ansari <rayyan@ansari.sh>
    ARM: dts: qcom: msm8226-microsoft-common: Enable smbb explicitly

Viken Dadhaniya <quic_vdadhani@quicinc.com>
    arm64: dts: qcom: sc7280: Remove CTS/RTS configuration

Bjorn Andersson <quic_bjorande@quicinc.com>
    arm64: dts: qcom: sc8180x: Correct PCIe slave ports

Konrad Dybcio <konrad.dybcio@linaro.org>
    soc: qcom: socinfo: Update X1E PMICs

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max6697) Fix swapped temp{1,8} critical alarms

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max6697) Fix underflow when writing limit attributes

Nirmoy Das <nirmoy.das@intel.com>
    drm/xe/display/xe_hdcp_gsc: Free arbiter on driver removal

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: atmel-tcb: Fix race condition and convert to guards

Yao Zi <ziyao@disroot.org>
    drm/meson: fix canvas release in bind function

Gaosheng Cui <cuigaosheng1@huawei.com>
    nvmet-auth: fix nvmet_auth hash error handling

Jinjie Ruan <ruanjinjie@huawei.com>
    arm64: smp: Fix missing IPI statistics

Adam Ford <aford173@gmail.com>
    drm/bridge: adv7511: Fix Intermittent EDID failures

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: stm32: Always do lazy disabling

Dan Carpenter <dan.carpenter@linaro.org>
    hwmon: (ltc2991) re-order conditions to fix off by one bug

Benjamin Marzinski <bmarzins@redhat.com>
    md/raid5: recheck if reshape has finished with device_lock held

Yu Kuai <yukuai3@huawei.com>
    md: Don't wait for MD_RECOVERY_NEEDED for HOT_REMOVE_DISK ioctl

Rob Herring (Arm) <robh@kernel.org>
    perf: arm_pmuv3: Avoid assigning fixed cycle counter with threshold

Christoph Hellwig <hch@lst.de>
    xen-blkfront: fix sector_size propagation to the block layer

Bart Van Assche <bvanassche@acm.org>
    block/mq-deadline: Fix the tag reservation code

Bart Van Assche <bvanassche@acm.org>
    block: Call .limit_depth() after .hctx has been set

Wayne Tung <chineweff@gmail.com>
    hwmon: (adt7475) Fix default duty on fan is disabled

Chen Ridong <chenridong@huawei.com>
    cgroup/cpuset: Prevent UAF in proc_cpuset_show()

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/syscall: Mark exit[_group] syscall handlers __noreturn

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

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix remote root partition creation problem

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Optimize isolated partition only generate_sched_domains() calls

Gabriel Krisman Bertazi <krisman@suse.de>
    io_uring: Fix probe of disabled operations

Damien Le Moal <dlemoal@kernel.org>
    dm: Call dm_revalidate_zones() after setting the queue limits

Christoph Hellwig <hch@lst.de>
    block: initialize integrity buffer to zero before writing it to media

Christoph Hellwig <hch@lst.de>
    ubd: untagle discard vs write zeroes not support handling

Christoph Hellwig <hch@lst.de>
    ubd: refactor the interrupt handler

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_debugfs: fix wrong EC message version

Christoph Hellwig <hch@lst.de>
    md/raid1: don't free conf on raid0_run failure

Christoph Hellwig <hch@lst.de>
    md/raid0: don't free conf on raid0_run failure

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

 Documentation/admin-guide/kernel-parameters.txt    |   4 +-
 Documentation/arch/powerpc/kvm-nested.rst          |   4 +-
 .../phy/qcom,sc8280xp-qmp-usb3-uni-phy.yaml        |   2 +-
 .../devicetree/bindings/thermal/thermal-zones.yaml |   5 +-
 Documentation/networking/xsk-tx-metadata.rst       |  16 +-
 Documentation/virt/kvm/api.rst                     |  12 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/allwinner/Makefile               |  62 --
 .../arm/boot/dts/nxp/imx/imx6q-kontron-samx6i.dtsi |  23 -
 .../boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi   |  14 +-
 .../dts/qcom/qcom-msm8226-microsoft-common.dtsi    |   4 +
 arch/arm/boot/dts/st/stm32mp151.dtsi               |   1 +
 arch/arm/mach-pxa/spitz.c                          |  30 +-
 arch/arm/mm/fault.c                                |   4 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   5 +
 arch/arm64/boot/dts/amlogic/meson-g12.dtsi         |   4 +
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi        |  10 +-
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |  10 +-
 arch/arm64/boot/dts/amlogic/meson-sm1.dtsi         |   8 +-
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |  89 +--
 .../boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts  |   4 +-
 arch/arm64/boot/dts/mediatek/mt7622-rfb1.dts       |   4 +-
 arch/arm64/boot/dts/mediatek/mt7981b.dtsi          |   8 +-
 .../dts/mediatek/mt8183-kukui-audio-da7219.dtsi    |   2 +-
 .../dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts    |   8 +-
 .../boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi    |  25 +-
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi     |   4 +-
 arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi   |   1 +
 arch/arm64/boot/dts/mediatek/mt8192.dtsi           |   2 +-
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |   2 +-
 .../boot/dts/mediatek/mt8395-radxa-nio-12l.dts     |   2 +-
 .../arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi |   1 -
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |   1 -
 arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts |   1 -
 arch/arm64/boot/dts/qcom/qcm6490-idp.dts           |   1 -
 arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts       |   1 -
 arch/arm64/boot/dts/qcom/qdu1000.dtsi              |  15 +
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts           |   4 +-
 arch/arm64/boot/dts/qcom/sa8775p.dtsi              |   2 +
 .../boot/dts/qcom/sc7180-trogdor-lazor-r1-kb.dts   |   2 +-
 .../boot/dts/qcom/sc7180-trogdor-lazor-r1-lte.dts  |   2 +-
 .../boot/dts/qcom/sc7180-trogdor-lazor-r10-kb.dts  |   2 +-
 .../boot/dts/qcom/sc7180-trogdor-lazor-r10-lte.dts |   2 +-
 .../boot/dts/qcom/sc7180-trogdor-lazor-r3-kb.dts   |   2 +-
 .../boot/dts/qcom/sc7180-trogdor-lazor-r3-lte.dts  |   2 +-
 .../boot/dts/qcom/sc7180-trogdor-lazor-r9-kb.dts   |   2 +-
 .../boot/dts/qcom/sc7180-trogdor-lazor-r9-lte.dts  |   2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi       |   5 +-
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |   3 +-
 arch/arm64/boot/dts/qcom/sc7280-idp.dtsi           |   1 -
 arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi         |   1 -
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |  14 +-
 arch/arm64/boot/dts/qcom/sc8180x.dtsi              |   8 +-
 .../dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts     |   2 +-
 arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi       |   4 +-
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi             |  28 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   2 +
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |   1 +
 arch/arm64/boot/dts/qcom/sm6115.dtsi               |   2 +
 arch/arm64/boot/dts/qcom/sm6350.dtsi               |   4 +
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   2 +
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   2 +
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   2 +
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts          |   6 +-
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts          |   6 +-
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi          |   5 +-
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi          |   5 +-
 arch/arm64/boot/dts/renesas/r8a779g0.dtsi          |   5 +-
 arch/arm64/boot/dts/renesas/r8a779h0.dtsi          |   1 -
 arch/arm64/boot/dts/renesas/r9a07g043u.dtsi        |   5 +-
 arch/arm64/boot/dts/renesas/r9a07g044.dtsi         |   5 +-
 arch/arm64/boot/dts/renesas/r9a07g054.dtsi         |   5 +-
 arch/arm64/boot/dts/renesas/r9a08g045.dtsi         |   5 +-
 arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts  |  71 +-
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   4 +-
 arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts     |   2 +-
 arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts   |   2 +-
 .../boot/dts/rockchip/rk3568-fastrhino-r66s.dts    |   4 +
 .../boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi   |  48 +-
 .../boot/dts/rockchip/rk3568-fastrhino-r68s.dts    |  16 +-
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts    |   4 -
 arch/arm64/boot/dts/rockchip/rk356x.dtsi           |   1 +
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi           |   4 +-
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |   4 -
 arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts     |   2 -
 .../boot/dts/ti/k3-am625-phyboard-lyra-rdk.dts     |   2 -
 arch/arm64/boot/dts/ti/k3-am62a-main.dtsi          |   4 +-
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts            |   2 -
 arch/arm64/boot/dts/ti/k3-am62p-main.dtsi          |   4 +-
 arch/arm64/boot/dts/ti/k3-am62p5-sk.dts            |   4 +-
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi     |   2 -
 arch/arm64/boot/dts/ti/k3-am642-hummingboard-t.dts |   1 -
 arch/arm64/boot/dts/ti/k3-j722s.dtsi               |   8 +
 arch/arm64/include/asm/pgtable.h                   |  22 +
 arch/arm64/kernel/smp.c                            |   6 +-
 arch/arm64/net/bpf_jit_comp.c                      |   4 +-
 arch/loongarch/kernel/hw_breakpoint.c              |   2 +-
 arch/loongarch/kernel/ptrace.c                     |   3 +
 arch/m68k/amiga/config.c                           |   9 +
 arch/m68k/atari/ataints.c                          |   6 +-
 arch/m68k/include/asm/cmpxchg.h                    |   2 +-
 arch/mips/Makefile                                 |   2 +-
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
 arch/powerpc/include/asm/guest-state-buffer.h      |   3 +-
 arch/powerpc/include/asm/kvm_book3s.h              |   1 +
 arch/powerpc/kernel/prom.c                         |  12 +-
 arch/powerpc/kexec/core_64.c                       |  55 +-
 arch/powerpc/kvm/book3s_hv.c                       |   9 +-
 arch/powerpc/kvm/book3s_hv_nestedv2.c              |   7 +
 arch/powerpc/kvm/powerpc.c                         |   4 +-
 arch/powerpc/kvm/test-guest-state-buffer.c         |   2 +-
 arch/powerpc/mm/nohash/8xx.c                       |   3 +-
 arch/powerpc/xmon/ppc-dis.c                        |  33 +-
 arch/riscv/kernel/head.S                           |  19 +-
 arch/riscv/kernel/smpboot.c                        |  14 +-
 arch/riscv/net/bpf_jit_comp64.c                    |  18 +-
 arch/s390/kernel/perf_cpum_cf.c                    |  14 +-
 arch/s390/kernel/setup.c                           |   2 +-
 arch/s390/kernel/uv.c                              |   8 +
 arch/s390/kvm/kvm-s390.c                           |   3 +
 arch/s390/pci/pci_irq.c                            | 110 ++--
 arch/sparc/include/asm/oplib_64.h                  |   1 +
 arch/sparc/prom/init_64.c                          |   3 -
 arch/sparc/prom/p1275.c                            |   2 +-
 arch/um/drivers/ubd_kern.c                         |  50 +-
 arch/um/kernel/time.c                              |   4 +-
 arch/um/os-Linux/signal.c                          | 118 +++-
 arch/x86/Kconfig.assembler                         |   2 +-
 arch/x86/Makefile.um                               |   1 +
 arch/x86/entry/syscall_32.c                        |  10 +-
 arch/x86/entry/syscall_64.c                        |   9 +-
 arch/x86/entry/syscall_x32.c                       |   7 +-
 arch/x86/entry/syscalls/syscall_32.tbl             |   6 +-
 arch/x86/entry/syscalls/syscall_64.tbl             |   6 +-
 arch/x86/events/amd/uncore.c                       |  28 +-
 arch/x86/events/core.c                             |   3 +
 arch/x86/events/intel/cstate.c                     |   7 +-
 arch/x86/events/intel/ds.c                         |   8 +-
 arch/x86/events/intel/pt.c                         |   4 +-
 arch/x86/events/intel/pt.h                         |   4 +-
 arch/x86/events/intel/uncore_snbep.c               |   6 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   1 -
 arch/x86/include/asm/kvm_host.h                    |   3 +-
 arch/x86/include/asm/shstk.h                       |   2 +
 arch/x86/kernel/devicetree.c                       |   2 +-
 arch/x86/kernel/shstk.c                            |  11 +
 arch/x86/kernel/uprobes.c                          |   7 +-
 arch/x86/kvm/vmx/main.c                            |   1 -
 arch/x86/kvm/vmx/nested.c                          |  47 +-
 arch/x86/kvm/vmx/posted_intr.h                     |  10 +
 arch/x86/kvm/vmx/vmx.c                             |  31 +-
 arch/x86/kvm/vmx/vmx.h                             |   1 +
 arch/x86/kvm/vmx/x86_ops.h                         |   1 -
 arch/x86/kvm/x86.c                                 |  14 +-
 arch/x86/pci/intel_mid_pci.c                       |   4 +-
 arch/x86/pci/xen.c                                 |   4 +-
 arch/x86/platform/intel/iosf_mbi.c                 |   4 +-
 arch/x86/um/sys_call_table_32.c                    |  10 +-
 arch/x86/um/sys_call_table_64.c                    |  11 +-
 arch/x86/virt/svm/sev.c                            |  44 +-
 arch/x86/xen/p2m.c                                 |   4 +-
 block/bio-integrity.c                              |  11 +-
 block/blk-mq.c                                     |  32 +-
 block/genhd.c                                      |   2 +-
 block/mq-deadline.c                                |  20 +-
 drivers/android/binder.c                           |   4 +-
 drivers/ata/libata-scsi.c                          | 176 ++---
 drivers/auxdisplay/ht16k33.c                       |   1 +
 drivers/base/devres.c                              |  11 +-
 drivers/block/null_blk/main.c                      |   2 +-
 drivers/block/rbd.c                                |  35 +-
 drivers/block/ublk_drv.c                           |   5 +-
 drivers/block/xen-blkfront.c                       |  16 +-
 drivers/bluetooth/btintel.c                        | 119 +---
 drivers/bluetooth/btintel_pcie.c                   |   6 +
 drivers/bluetooth/btnxpuart.c                      |  52 +-
 drivers/bluetooth/btusb.c                          |   4 +
 drivers/bluetooth/hci_bcm4377.c                    |   2 +-
 drivers/bus/mhi/ep/main.c                          |  14 +-
 drivers/char/hw_random/amd-rng.c                   |   4 +-
 drivers/char/hw_random/core.c                      |   4 +-
 drivers/char/ipmi/ssif_bmc.c                       |   6 +-
 drivers/char/tpm/eventlog/common.c                 |   2 +
 drivers/char/tpm/tpm_tis_spi_main.c                |   1 +
 drivers/clk/clk-en7523.c                           |   9 +-
 drivers/clk/davinci/da8xx-cfgchip.c                |   4 +-
 drivers/clk/meson/s4-peripherals.c                 |   2 +-
 drivers/clk/meson/s4-pll.c                         |   5 +
 drivers/clk/qcom/camcc-sc7280.c                    |   5 +
 drivers/clk/qcom/clk-rcg2.c                        |  32 +
 drivers/clk/qcom/gcc-sa8775p.c                     |  40 ++
 drivers/clk/qcom/gcc-sc7280.c                      |   3 +
 drivers/clk/qcom/gcc-x1e80100.c                    |  46 +-
 drivers/clk/qcom/gpucc-sa8775p.c                   |  41 +-
 drivers/clk/qcom/gpucc-sm8350.c                    |   5 +-
 drivers/clk/qcom/kpss-xcc.c                        |   4 +-
 drivers/clk/samsung/clk-exynos4.c                  |  13 +-
 drivers/cpufreq/amd-pstate-ut.c                    |  12 +-
 drivers/cpufreq/amd-pstate.c                       |  43 +-
 drivers/cpufreq/qcom-cpufreq-nvmem.c               |  13 +-
 drivers/cpufreq/sun50i-cpufreq-nvmem.c             |   4 +-
 drivers/cpufreq/ti-cpufreq.c                       |   2 +-
 drivers/crypto/atmel-sha204a.c                     |   2 +-
 drivers/crypto/ccp/sev-dev.c                       |   8 +-
 drivers/crypto/intel/qat/qat_common/adf_cfg.c      |   6 +-
 drivers/crypto/mxs-dcp.c                           |   3 +-
 drivers/crypto/tegra/tegra-se-main.c               |   1 -
 drivers/dma/fsl-edma-common.c                      |   3 +
 drivers/dma/fsl-edma-common.h                      |   1 +
 drivers/dma/fsl-edma-main.c                        |   2 +-
 drivers/dma/ti/k3-udma.c                           |   4 +-
 drivers/edac/Makefile                              |  10 +-
 drivers/edac/skx_common.c                          |  21 +-
 drivers/edac/skx_common.h                          |   4 +-
 drivers/firmware/efi/libstub/screen_info.c         |   2 +
 drivers/firmware/efi/libstub/x86-stub.c            |  25 +-
 drivers/firmware/turris-mox-rwtm.c                 |  23 +-
 drivers/gpu/drm/Kconfig                            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   9 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |   2 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |  12 +
 drivers/gpu/drm/amd/amdgpu/smu_v13_0_10.c          |   2 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |   6 +
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c            |   6 +
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c            |   6 +
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |   2 +-
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c   |   3 +-
 drivers/gpu/drm/amd/display/dc/dc.h                |   1 +
 .../drm/amd/display/dc/dml2/dml2_mall_phantom.c    |   2 +
 .../amd/display/dc/dml2/dml2_translation_helper.c  |  56 +-
 .../gpu/drm/amd/display/dc/optc/dcn10/dcn10_optc.c |  15 +-
 .../gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c |  10 +
 .../amd/display/dc/resource/dcn32/dcn32_resource.c |  12 +-
 .../display/dc/resource/dcn321/dcn321_resource.c   |  12 +-
 .../gpu/drm/amd/display/include/grph_object_id.h   |   4 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   4 +-
 drivers/gpu/drm/arm/display/komeda/komeda_crtc.c   |  43 +-
 drivers/gpu/drm/bridge/adv7511/adv7511.h           |   2 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c       |  13 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |  22 +-
 drivers/gpu/drm/bridge/ite-it6505.c                |  81 ++-
 drivers/gpu/drm/bridge/samsung-dsim.c              |   4 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |   4 +-
 drivers/gpu/drm/drm_fbdev_dma.c                    |   3 +-
 drivers/gpu/drm/drm_panic.c                        |  70 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |   6 +-
 drivers/gpu/drm/etnaviv/etnaviv_sched.c            |   9 +-
 drivers/gpu/drm/gma500/cdv_intel_lvds.c            |   3 +
 drivers/gpu/drm/gma500/psb_intel_lvds.c            |   3 +
 .../gpu/drm/i915/display/intel_crtc_state_dump.c   |   7 +-
 drivers/gpu/drm/i915/display/intel_display.c       |   6 +-
 drivers/gpu/drm/i915/display/intel_display_types.h |   2 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   4 +-
 .../gpu/drm/i915/display/intel_dp_link_training.c  |  55 +-
 drivers/gpu/drm/i915/display/intel_fbc.c           |   2 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |  36 +-
 .../gpu/drm/i915/gt/intel_execlists_submission.c   |   6 +-
 drivers/gpu/drm/mediatek/mtk_ddp_comp.c            | 107 +--
 drivers/gpu/drm/mediatek/mtk_ddp_comp.h            |   8 +-
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c            |  41 +-
 drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c    |   2 +-
 drivers/gpu/drm/mediatek/mtk_dp.c                  |  10 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |   5 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  24 +
 drivers/gpu/drm/mediatek/mtk_drm_drv.h             |   4 +
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |   5 +-
 drivers/gpu/drm/mediatek/mtk_ethdr.c               |  21 +-
 drivers/gpu/drm/mediatek/mtk_plane.c               |   4 +-
 drivers/gpu/drm/meson/meson_drv.c                  |  37 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c        |  13 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   7 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h   |   5 +
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c   |  32 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   |  13 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c    |  14 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c     |   6 -
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.h         |   3 +-
 drivers/gpu/drm/msm/dp/dp_aux.c                    |   5 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   6 +-
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c     |   8 +-
 drivers/gpu/drm/panel/panel-himax-hx8394.c         |   3 +-
 drivers/gpu/drm/panel/panel-ilitek-ili9882t.c      |   8 +-
 drivers/gpu/drm/panel/panel-lg-sw43408.c           |  33 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |   1 +
 drivers/gpu/drm/panthor/panthor_sched.c            |   1 +
 drivers/gpu/drm/qxl/qxl_display.c                  |  17 +-
 drivers/gpu/drm/qxl/qxl_object.c                   |  13 +-
 drivers/gpu/drm/qxl/qxl_object.h                   |   4 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |   2 +-
 drivers/gpu/drm/ttm/tests/ttm_bo_test.c            |  48 +-
 drivers/gpu/drm/ttm/tests/ttm_kunit_helpers.c      |   7 +-
 drivers/gpu/drm/ttm/tests/ttm_kunit_helpers.h      |   3 +-
 drivers/gpu/drm/ttm/tests/ttm_pool_test.c          |   4 +-
 drivers/gpu/drm/ttm/tests/ttm_resource_test.c      |   2 +-
 drivers/gpu/drm/ttm/tests/ttm_tt_test.c            |  20 +-
 drivers/gpu/drm/udl/udl_modeset.c                  |   3 +-
 drivers/gpu/drm/xe/display/xe_hdcp_gsc.c           |  12 +-
 drivers/gpu/drm/xe/xe_bo.c                         |  47 +-
 drivers/gpu/drm/xe/xe_bo_types.h                   |   3 +-
 drivers/gpu/drm/xe/xe_exec.c                       |  14 +-
 drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c         |   1 +
 drivers/gpu/drm/xlnx/zynqmp_dpsub.c                |   1 +
 drivers/gpu/drm/xlnx/zynqmp_kms.c                  |  12 +-
 drivers/hwmon/adt7475.c                            |   2 +-
 drivers/hwmon/ltc2991.c                            |   4 +-
 drivers/hwmon/max6697.c                            |   5 +-
 drivers/hwtracing/coresight/coresight-platform.c   |   4 +-
 drivers/i3c/master/mipi-i3c-hci/core.c             |   8 +
 drivers/iio/adc/ad9467.c                           |  65 +-
 drivers/iio/adc/adi-axi-adc.c                      |   2 +
 drivers/iio/frequency/adrf6780.c                   |   1 -
 drivers/iio/industrialio-gts-helper.c              |   7 +-
 drivers/infiniband/core/cache.c                    |  14 +-
 drivers/infiniband/core/device.c                   |  14 +-
 drivers/infiniband/core/iwcm.c                     |  11 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   8 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   6 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   7 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         | 164 +++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   6 +
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   5 +
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   4 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   2 +-
 drivers/infiniband/hw/mana/device.c                |  16 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c            |   2 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  13 +
 drivers/infiniband/hw/mlx5/odp.c                   |   6 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |   7 +-
 drivers/input/keyboard/qt1050.c                    |   7 +-
 drivers/input/mouse/elan_i2c_core.c                |   2 +
 drivers/interconnect/qcom/qcm2290.c                |   2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   2 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom-debug.c   |  17 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |  39 ++
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.h         |   2 +
 drivers/iommu/intel/cache.c                        |   3 +-
 drivers/iommu/intel/iommu.c                        |   2 +-
 drivers/iommu/iommufd/iova_bitmap.c                |   5 +-
 drivers/iommu/iommufd/selftest.c                   |   2 +-
 drivers/iommu/sprd-iommu.c                         |   2 +-
 drivers/irqchip/irq-imx-irqsteer.c                 |  24 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |   7 +-
 drivers/leds/flash/leds-mt6360.c                   |   5 +-
 drivers/leds/flash/leds-qcom-flash.c               |  10 +-
 drivers/leds/led-class.c                           |   1 -
 drivers/leds/led-triggers.c                        |   8 +-
 drivers/leds/leds-ss4200.c                         |   7 +-
 drivers/leds/rgb/leds-qcom-lpg.c                   |   8 +-
 drivers/leds/trigger/ledtrig-timer.c               |   5 -
 drivers/macintosh/therm_windtunnel.c               |   2 +-
 drivers/mailbox/imx-mailbox.c                      |  10 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |  12 +-
 drivers/mailbox/omap-mailbox.c                     |   3 +-
 drivers/md/dm-raid.c                               |   7 +-
 drivers/md/dm-table.c                              |  15 +-
 drivers/md/dm-verity-target.c                      |  16 +-
 drivers/md/dm-zone.c                               |  25 +-
 drivers/md/dm.h                                    |   1 +
 drivers/md/md-bitmap.c                             |   6 +-
 drivers/md/md-cluster.c                            |  22 +-
 drivers/md/md.c                                    |  32 +-
 drivers/md/raid0.c                                 |  21 +-
 drivers/md/raid1.c                                 |  15 +-
 drivers/md/raid5.c                                 |  76 ++-
 drivers/media/i2c/Kconfig                          |   1 +
 drivers/media/i2c/alvium-csi2.c                    |   6 +-
 drivers/media/i2c/hi846.c                          |   2 +-
 drivers/media/i2c/imx219.c                         |   2 +-
 drivers/media/i2c/imx412.c                         |   9 +-
 drivers/media/pci/intel/ivsc/mei_csi.c             |  14 +-
 drivers/media/pci/ivtv/ivtv-udma.c                 |   8 +
 drivers/media/pci/ivtv/ivtv-yuv.c                  |   6 +
 drivers/media/pci/ivtv/ivtvfb.c                    |   6 +-
 drivers/media/pci/saa7134/saa7134-dvb.c            |   8 +-
 .../mediatek/vcodec/decoder/vdec/vdec_vp8_if.c     |   2 +-
 .../platform/mediatek/vcodec/decoder/vdec_vpu_if.c |   6 +
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |   3 +
 drivers/media/platform/nxp/imx-pxp.c               |   3 +
 drivers/media/platform/qcom/venus/vdec.c           |   3 +-
 drivers/media/platform/renesas/rcar-csi2.c         |   5 +-
 drivers/media/platform/renesas/rcar-vin/rcar-dma.c |  16 +-
 drivers/media/platform/renesas/vsp1/vsp1_histo.c   |  20 +-
 drivers/media/platform/renesas/vsp1/vsp1_pipe.h    |   2 +-
 drivers/media/platform/renesas/vsp1/vsp1_rpf.c     |   8 +-
 .../platform/st/sti/c8sectpfe/c8sectpfe-debugfs.h  |   4 +-
 .../platform/st/stm32/stm32-dcmipp/dcmipp-core.c   |   4 +-
 drivers/media/rc/imon.c                            |   5 +-
 drivers/media/rc/lirc_dev.c                        |   4 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |  35 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |   9 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  12 +-
 drivers/media/usb/uvc/uvc_video.c                  |  21 +-
 drivers/media/usb/uvc/uvcvideo.h                   |   1 +
 drivers/media/v4l2-core/v4l2-async.c               |   3 +
 drivers/memory/Kconfig                             |   2 +-
 drivers/mfd/Makefile                               |   6 +-
 drivers/mfd/omap-usb-tll.c                         |   3 +-
 drivers/mfd/rsmu_core.c                            |   2 +
 drivers/misc/eeprom/ee1004.c                       |   6 +-
 drivers/mtd/nand/raw/Kconfig                       |   3 +-
 drivers/mtd/spi-nor/winbond.c                      |   2 +
 drivers/mtd/tests/Makefile                         |  34 +-
 drivers/mtd/tests/mtd_test.c                       |   9 +
 drivers/mtd/ubi/eba.c                              |   3 +-
 drivers/net/bonding/bond_main.c                    |   7 +-
 drivers/net/dsa/b53/b53_common.c                   |   3 +
 drivers/net/dsa/microchip/ksz_common.c             |   7 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   3 +-
 drivers/net/ethernet/brocade/bna/bna_types.h       |   2 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |  11 +-
 drivers/net/ethernet/cortina/gemini.c              |  23 +-
 drivers/net/ethernet/freescale/fec_main.c          |   6 +
 drivers/net/ethernet/google/gve/gve_tx.c           |   5 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |  22 +-
 drivers/net/ethernet/hisilicon/hns3/Makefile       |  11 +-
 .../hisilicon/hns3/hns3_common/hclge_comm_cmd.c    |  11 +
 .../hisilicon/hns3/hns3_common/hclge_comm_rss.c    |  14 +
 .../hns3/hns3_common/hclge_comm_tqp_stats.c        |   5 +
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_fdir.h          |   3 +
 drivers/net/ethernet/intel/ice/ice_switch.c        |   8 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |  16 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.h |   1 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   3 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl_atcam.c   |  18 +-
 .../mellanox/mlxsw/spectrum_acl_bloom_filter.c     |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c |  13 -
 .../ethernet/mellanox/mlxsw/spectrum_acl_tcam.h    |   9 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  19 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
 drivers/net/netconsole.c                           |   2 +-
 drivers/net/pse-pd/pse_core.c                      |   4 +-
 drivers/net/virtio_net.c                           |  85 ++-
 drivers/net/wireless/ath/ath11k/ce.h               |   6 +-
 drivers/net/wireless/ath/ath11k/core.c             |  29 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   3 +-
 drivers/net/wireless/ath/ath11k/dp_rx.h            |   3 +
 drivers/net/wireless/ath/ath11k/mac.c              |  28 +-
 drivers/net/wireless/ath/ath11k/reg.c              |  14 +-
 drivers/net/wireless/ath/ath11k/reg.h              |   4 +-
 drivers/net/wireless/ath/ath12k/acpi.c             |   2 +
 drivers/net/wireless/ath/ath12k/ce.h               |   6 +-
 drivers/net/wireless/ath/ath12k/core.c             |   7 +-
 drivers/net/wireless/ath/ath12k/dp.c               |  18 +-
 drivers/net/wireless/ath/ath12k/dp.h               |   1 +
 drivers/net/wireless/ath/ath12k/dp_rx.c            |  67 +-
 drivers/net/wireless/ath/ath12k/dp_tx.c            |  47 +-
 drivers/net/wireless/ath/ath12k/hal_desc.h         |  48 +-
 drivers/net/wireless/ath/ath12k/hw.c               |   8 +-
 drivers/net/wireless/ath/ath12k/hw.h               |   3 +-
 drivers/net/wireless/ath/ath12k/mac.c              |  17 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |  23 +-
 drivers/net/wireless/ath/ath12k/wmi.h              |  12 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |  18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/link.c      |   9 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   9 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   5 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   2 +
 drivers/net/wireless/realtek/rtl8xxxu/8188f.c      |  15 +
 drivers/net/wireless/realtek/rtw88/mac.c           |   9 +
 drivers/net/wireless/realtek/rtw88/main.h          |   2 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8703b.c      |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   1 +
 drivers/net/wireless/realtek/rtw88/usb.c           |   6 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |   2 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |  13 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   5 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |  23 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |   6 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c  |   2 +-
 drivers/net/wireless/virtual/virt_wifi.c           |  20 +-
 drivers/nvme/host/pci.c                            |   5 +-
 drivers/nvme/target/auth.c                         |  14 +-
 drivers/nvmem/rockchip-otp.c                       |   1 +
 drivers/opp/core.c                                 |   6 +-
 drivers/opp/ti-opp-supply.c                        |   6 +-
 drivers/parport/procfs.c                           |  24 +-
 drivers/pci/controller/dwc/pci-keystone.c          | 156 +++--
 drivers/pci/controller/dwc/pcie-designware-ep.c    |  13 +-
 drivers/pci/controller/dwc/pcie-dw-rockchip.c      |   2 +-
 drivers/pci/controller/dwc/pcie-qcom-ep.c          |   6 -
 drivers/pci/controller/dwc/pcie-tegra194.c         |   1 +
 drivers/pci/controller/pci-hyperv.c                |   4 +-
 drivers/pci/controller/pci-loongson.c              |  13 +
 drivers/pci/controller/pcie-rcar-host.c            |   6 +-
 drivers/pci/controller/pcie-rockchip.c             |   2 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |  14 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |  19 +-
 drivers/pci/pci.c                                  |   6 +-
 drivers/pci/setup-bus.c                            |   6 +-
 drivers/perf/arm_pmuv3.c                           |  10 +-
 drivers/phy/cadence/phy-cadence-torrent.c          |   3 +
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c           |   9 +-
 drivers/phy/rockchip/Kconfig                       |   2 +
 drivers/phy/xilinx/phy-zynqmp.c                    |  14 +-
 drivers/pinctrl/core.c                             |  12 +-
 drivers/pinctrl/freescale/pinctrl-mxs.c            |   4 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  17 +-
 drivers/pinctrl/pinctrl-single.c                   |   7 +-
 drivers/pinctrl/renesas/pfc-r8a779g0.c             | 716 ++++++++++-----------
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c            |  11 +-
 drivers/platform/Makefile                          |   2 +-
 drivers/platform/chrome/cros_ec_debugfs.c          |   1 +
 drivers/platform/mips/cpu_hwmon.c                  |   3 +
 drivers/platform/x86/asus-wmi.c                    |   6 +-
 drivers/power/supply/ab8500_charger.c              |  16 +-
 drivers/power/supply/ingenic-battery.c             |  10 +-
 drivers/pwm/pwm-atmel-tcb.c                        |  12 +-
 drivers/pwm/pwm-stm32.c                            |   5 +-
 drivers/remoteproc/imx_rproc.c                     |  10 +-
 drivers/remoteproc/mtk_scp.c                       |  21 +-
 drivers/remoteproc/stm32_rproc.c                   |   2 +-
 drivers/remoteproc/ti_k3_r5_remoteproc.c           |  13 +-
 drivers/rtc/interface.c                            |   9 +-
 drivers/rtc/rtc-abx80x.c                           |  12 +-
 drivers/rtc/rtc-cmos.c                             |  10 +-
 drivers/rtc/rtc-isl1208.c                          |  11 +-
 drivers/rtc/rtc-tps6594.c                          |   4 -
 drivers/s390/block/dasd_devmap.c                   |  10 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |   5 +
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  19 +-
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
 drivers/soc/mediatek/mtk-mutex.c                   |   1 +
 drivers/soc/qcom/icc-bwmon.c                       |   4 +-
 drivers/soc/qcom/pdr_interface.c                   |   8 +-
 drivers/soc/qcom/pmic_glink.c                      |  13 +-
 drivers/soc/qcom/rpmh-rsc.c                        |   7 +-
 drivers/soc/qcom/rpmh.c                            |   1 -
 drivers/soc/qcom/socinfo.c                         |   3 +-
 drivers/soc/xilinx/xlnx_event_manager.c            |  15 +-
 drivers/soc/xilinx/zynqmp_power.c                  |   4 +-
 drivers/spi/atmel-quadspi.c                        |  11 +-
 drivers/spi/spi-microchip-core.c                   | 139 ++--
 drivers/spi/spidev.c                               |   1 +
 drivers/thermal/broadcom/bcm2835_thermal.c         |  19 +-
 drivers/thermal/thermal_core.c                     |  89 ++-
 drivers/thermal/thermal_core.h                     |  10 +-
 drivers/ufs/core/ufs-mcq.c                         |  10 +-
 drivers/usb/host/xhci-pci.c                        |   4 +-
 drivers/usb/typec/mux/nb7vpq904m.c                 |   7 +-
 drivers/usb/typec/mux/ptn36502.c                   |  11 +-
 drivers/vhost/vsock.c                              |   4 +-
 drivers/video/fbdev/vesafb.c                       |   2 +-
 drivers/watchdog/rzg2l_wdt.c                       |  22 +-
 fs/btrfs/compression.c                             |   2 +-
 fs/ceph/super.c                                    |   3 +-
 fs/erofs/zutil.c                                   |   3 +
 fs/exfat/dir.c                                     |   2 +-
 fs/ext2/balloc.c                                   |  11 +-
 fs/ext4/extents_status.c                           |   2 +
 fs/ext4/fast_commit.c                              |   6 +
 fs/ext4/namei.c                                    |  73 ++-
 fs/ext4/xattr.c                                    |   6 +
 fs/f2fs/checkpoint.c                               |  10 +-
 fs/f2fs/data.c                                     |  10 +-
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
 fs/netfs/write_issue.c                             |   1 +
 fs/nfs/file.c                                      |   5 +-
 fs/nfs/nfs4client.c                                |   6 +-
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/nfs/nfstrace.h                                  |  36 +-
 fs/nfs/read.c                                      |   8 +-
 fs/nfs/write.c                                     |  10 +-
 fs/nfsd/Kconfig                                    |   2 +-
 fs/nfsd/filecache.c                                |   2 +-
 fs/nfsd/nfs4proc.c                                 |   5 +-
 fs/nfsd/nfs4recover.c                              |   4 +-
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
 fs/proc/proc_sysctl.c                              |   6 +-
 fs/proc/task_mmu.c                                 |  30 +-
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
 include/linux/alloc_tag.h                          |   2 +-
 include/linux/bpf_verifier.h                       |   2 +-
 include/linux/firewire.h                           |   5 +-
 include/linux/huge_mm.h                            |  12 +-
 include/linux/hugetlb.h                            |   1 +
 include/linux/interrupt.h                          |   2 +-
 include/linux/jbd2.h                               |  12 +-
 include/linux/lsm_hook_defs.h                      |   1 +
 include/linux/mlx5/qp.h                            |   9 +-
 include/linux/mm.h                                 |  16 +-
 include/linux/objagg.h                             |   1 -
 include/linux/perf_event.h                         |   1 +
 include/linux/pgalloc_tag.h                        |   7 +-
 include/linux/preempt.h                            |  41 ++
 include/linux/sbitmap.h                            |   5 +
 include/linux/sched.h                              |  41 --
 include/linux/screen_info.h                        |  10 +
 include/linux/spinlock.h                           |  14 +-
 include/linux/task_work.h                          |   3 +-
 include/linux/virtio_net.h                         |  11 +
 include/net/bluetooth/hci_core.h                   |   4 -
 include/net/ip6_route.h                            |  22 +-
 include/net/ip_fib.h                               |   1 +
 include/net/mana/mana.h                            |   2 +
 include/net/tcp.h                                  |   1 +
 include/net/xfrm.h                                 |  36 +-
 include/sound/tas2781-dsp.h                        |  11 +-
 include/trace/events/rpcgss.h                      |   2 +-
 include/uapi/drm/xe_drm.h                          |   8 +-
 include/uapi/linux/if_xdp.h                        |   4 +
 include/uapi/linux/netfilter/nf_tables.h           |   2 +-
 include/uapi/linux/zorro_ids.h                     |   3 +
 include/ufs/ufshcd.h                               |   6 +
 io_uring/io-wq.c                                   |  10 +-
 io_uring/io_uring.c                                |   5 +-
 io_uring/napi.c                                    |   2 +
 io_uring/opdef.c                                   |   8 +
 io_uring/opdef.h                                   |   4 +-
 io_uring/register.c                                |   2 +-
 io_uring/timeout.c                                 |   2 +-
 io_uring/uring_cmd.c                               |   2 +-
 kernel/bpf/btf.c                                   |  10 +-
 kernel/bpf/helpers.c                               |   2 +-
 kernel/bpf/verifier.c                              |   5 +-
 kernel/cgroup/cpuset.c                             |  76 ++-
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
 kernel/time/timer_migration.c                      |  33 +-
 kernel/time/timer_migration.h                      |  12 +-
 kernel/trace/pid_list.c                            |   4 +-
 kernel/watchdog_perf.c                             |  11 +-
 kernel/workqueue.c                                 |   6 +-
 lib/decompress_bunzip2.c                           |   3 +-
 lib/kobject_uevent.c                               |  17 +-
 lib/objagg.c                                       |  18 +-
 lib/sbitmap.c                                      |  36 +-
 mm/huge_memory.c                                   |  14 +-
 mm/hugetlb.c                                       |  49 +-
 mm/memory.c                                        |   2 +-
 mm/mempolicy.c                                     |  18 +-
 mm/mmap_lock.c                                     | 175 +----
 mm/page_alloc.c                                    |  35 +-
 mm/vmscan.c                                        |  83 ++-
 net/bluetooth/hci_core.c                           |  27 +-
 net/bluetooth/hci_event.c                          |   2 +
 net/bluetooth/hci_sync.c                           |   2 -
 net/bridge/br_forward.c                            |   4 +-
 net/core/filter.c                                  |  15 +-
 net/core/flow_dissector.c                          |   2 +-
 net/core/page_pool.c                               |   2 +-
 net/core/xdp.c                                     |   4 +-
 net/ethtool/pse-pd.c                               |   8 +-
 net/ipv4/esp4.c                                    |   3 +-
 net/ipv4/esp4_offload.c                            |   7 +
 net/ipv4/fib_semantics.c                           |  13 +-
 net/ipv4/fib_trie.c                                |   1 +
 net/ipv4/nexthop.c                                 |   7 +-
 net/ipv4/route.c                                   |  18 +-
 net/ipv4/tcp.c                                     |   8 +-
 net/ipv4/tcp_input.c                               |  32 +-
 net/ipv4/tcp_ipv4.c                                |  11 +-
 net/ipv4/tcp_minisocks.c                           |  15 +-
 net/ipv4/tcp_timer.c                               |   6 +-
 net/ipv6/addrconf.c                                |   3 +-
 net/ipv6/esp6.c                                    |   3 +-
 net/ipv6/esp6_offload.c                            |   7 +
 net/ipv6/ip6_output.c                              |   1 +
 net/ipv6/route.c                                   |   2 +-
 net/ipv6/tcp_ipv6.c                                |  10 +-
 net/mac80211/chan.c                                |  11 +
 net/mac80211/main.c                                |   2 +-
 net/mac80211/mlme.c                                |  15 +-
 net/mac80211/sta_info.h                            |   6 +
 net/mac80211/tx.c                                  |   6 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  10 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   4 +-
 net/netfilter/nf_conntrack_netlink.c               |   3 +-
 net/netfilter/nft_set_pipapo.c                     |   4 +-
 net/netfilter/nft_set_pipapo.h                     |  21 +
 net/netfilter/nft_set_pipapo_avx2.c                |  22 +-
 net/packet/af_packet.c                             |  86 ++-
 net/smc/smc_core.c                                 |   5 +-
 net/sunrpc/auth_gss/gss_krb5_keys.c                |   2 +-
 net/sunrpc/clnt.c                                  |   3 +-
 net/sunrpc/xprtrdma/frwr_ops.c                     |   3 +-
 net/sunrpc/xprtrdma/verbs.c                        |  16 +-
 net/tipc/udp_media.c                               |   5 +-
 net/unix/af_unix.c                                 |  41 +-
 net/unix/unix_bpf.c                                |   3 +
 net/wireless/nl80211.c                             |   3 +
 net/wireless/util.c                                |   8 +-
 net/xdp/xdp_umem.c                                 |   9 +-
 net/xfrm/xfrm_input.c                              |   8 +-
 net/xfrm/xfrm_policy.c                             |   5 +-
 net/xfrm/xfrm_state.c                              |  65 +-
 net/xfrm/xfrm_user.c                               |   1 -
 scripts/Kconfig.include                            |   3 +-
 scripts/Makefile.lib                               |   6 +-
 scripts/gcc-x86_32-has-stack-protector.sh          |   2 +-
 scripts/gcc-x86_64-has-stack-protector.sh          |   2 +-
 scripts/syscalltbl.sh                              |  18 +-
 security/apparmor/lsm.c                            |   7 +
 security/apparmor/policy.c                         |   2 +-
 security/apparmor/policy_unpack.c                  |  43 +-
 security/keys/keyctl.c                             |   2 +-
 security/landlock/cred.c                           |  11 +-
 security/security.c                                |  70 +-
 security/selinux/hooks.c                           |  28 +-
 security/smack/smack_lsm.c                         |  31 +-
 sound/core/ump.c                                   |  13 +
 sound/firewire/amdtp-stream.c                      |   3 +-
 sound/pci/hda/patch_realtek.c                      |   6 +-
 sound/soc/amd/acp-es8336.c                         |   4 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/cs35l56-shared.c                  |   2 +-
 sound/soc/codecs/max98088.c                        |  10 +-
 sound/soc/codecs/pcm6240.c                         |   6 +-
 sound/soc/codecs/tas2781-fmwlib.c                  |  20 +-
 sound/soc/codecs/tas2781-i2c.c                     |  39 +-
 sound/soc/codecs/wcd939x.c                         | 113 ++--
 sound/soc/fsl/fsl_qmc_audio.c                      |   2 +
 sound/soc/intel/common/soc-acpi-intel-ssp-common.c |   9 +
 sound/soc/intel/common/soc-intel-quirks.h          |   2 +-
 sound/soc/qcom/lpass-cpu.c                         |   4 +
 sound/soc/sof/amd/pci-vangogh.c                    |   1 -
 sound/soc/sof/imx/imx8m.c                          |   2 +-
 sound/soc/sof/intel/hda-loader.c                   |  18 +-
 sound/soc/sof/intel/hda.c                          |  17 +-
 sound/soc/sof/ipc4-topology.c                      |  46 +-
 sound/usb/mixer.c                                  |   7 +
 sound/usb/quirks.c                                 |   4 +
 tools/bpf/bpftool/common.c                         |   2 +-
 tools/bpf/bpftool/prog.c                           |   4 +
 tools/bpf/resolve_btfids/main.c                    |   2 +-
 tools/lib/bpf/btf.c                                |   2 +-
 tools/lib/bpf/btf_dump.c                           |   8 +-
 tools/lib/bpf/libbpf_internal.h                    |  10 +-
 tools/lib/bpf/linker.c                             |  11 +-
 tools/memory-model/lock.cat                        |  20 +-
 tools/objtool/noreturns.h                          |   4 +
 tools/perf/arch/powerpc/util/skip-callchain-idx.c  |   8 +-
 tools/perf/arch/x86/util/intel-pt.c                |  15 +-
 tools/perf/tests/pmu.c                             | 177 +++++
 tools/perf/tests/shell/test_arm_callgraph_fp.sh    |  27 +-
 tools/perf/tests/workloads/leafloop.c              |  20 +-
 tools/perf/ui/gtk/annotate.c                       |   5 +-
 tools/perf/util/cs-etm.c                           |  10 +-
 tools/perf/util/disasm.c                           |  10 +-
 tools/perf/util/dso.c                              |  14 +-
 tools/perf/util/dso.h                              |  19 +
 tools/perf/util/maps.c                             |   9 +-
 tools/perf/util/pmu.c                              |   2 +-
 tools/perf/util/pmus.c                             |   5 +-
 tools/perf/util/sort.c                             |   2 +-
 tools/perf/util/srcline.c                          |  12 +-
 tools/perf/util/stat-display.c                     |   3 +
 tools/perf/util/stat-shadow.c                      |   7 +
 tools/perf/util/symbol.c                           |  18 +-
 tools/perf/util/unwind-libdw.c                     |  12 +-
 tools/perf/util/unwind-libunwind-local.c           |  18 +-
 tools/testing/selftests/bpf/DENYLIST.aarch64       |   1 -
 tools/testing/selftests/bpf/bpf_kfuncs.h           |   2 +-
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |  16 +-
 .../testing/selftests/bpf/prog_tests/fexit_sleep.c |   8 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c |   2 +-
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |   2 +-
 .../bpf/progs/btf_dump_test_case_multidim.c        |   4 +-
 .../bpf/progs/btf_dump_test_case_syntax.c          |   4 +-
 .../bpf/progs/kprobe_multi_session_cookie.c        |   2 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   9 +-
 tools/testing/selftests/damon/access_memory.c      |   2 +-
 .../drivers/net/mlxsw/spectrum-2/tc_flower.sh      |  55 +-
 tools/testing/selftests/iommu/iommufd.c            |  76 ++-
 tools/testing/selftests/iommu/iommufd_utils.h      |   6 +-
 tools/testing/selftests/landlock/base_test.c       |  74 +++
 tools/testing/selftests/landlock/config            |   1 +
 tools/testing/selftests/net/fib_tests.sh           |  24 +-
 .../net/forwarding/bridge_fdb_learning_limit.sh    |  18 +
 .../selftests/net/forwarding/devlink_lib.sh        |   2 +
 tools/testing/selftests/nolibc/nolibc-test.c       |   2 +-
 tools/testing/selftests/resctrl/resctrl_val.c      |  54 +-
 .../selftests/sigaltstack/current_stack_pointer.h  |   2 +-
 860 files changed, 7695 insertions(+), 4547 deletions(-)


