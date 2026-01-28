Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEE227BF79;
	Wed, 28 Jan 2026 15:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615523; cv=none; b=W8eY/npSR3QAA76C/q4qqKKsItwt24yKta0NTpH8mtwrU5IOeMRT+oWtX6YvW3GcB6cJllfwOgVTT2UDQo4QpF6rtcu+oLNo0quteHHslgyZFKv1wWUNj63RMjknlTP7ebI0fU//dwyVPrtdAQnPfogKM63fyuy/8CuESCxPuAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615523; c=relaxed/simple;
	bh=7d+1MMx3aSOF4SG56/It42d1+fNtxad6nvWm7BZ20gs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kh37HKub/5Cd1cCD4Bm2q7i0FSsRmlmAz8GlYXjqL+XswWde+lVQ3BNQmfFRf8PO96aBSSN6elr2zH1OonhdfooKnhtGFEOoLTF2G3PjhAMsV7Pa1s8XXDeZh/CrHJuhb6l3NbRMaUw+QcIIfuV8FsD7Zo5ldrrkOp+PE5Palnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lo/8kdrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lo/8kdrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E288C4CEF1;
	Wed, 28 Jan 2026 15:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615523;
	bh=7d+1MMx3aSOF4SG56/It42d1+fNtxad6nvWm7BZ20gs=;
	h=From:To:Cc:Subject:Date:From;
	b=lo/8kdrR3XSLGsCqB3C37HXIUxw7nYNsLJ6Mi6kqlUuVJ3PeQqJ0V7v2rQv4NVPlb
	 DDuKjDoHp2d7lhhsFYffc5ztuOdS3Mr9LZc/OJ1MM5WIWGZ2HHUwvoacvFXTctO3rr
	 SK/+xiHQA6K1lfG8/G2Co1qPjrXmtz5O/4lczYiw=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.18 000/227] 6.18.8-rc1 review
Date: Wed, 28 Jan 2026 16:20:45 +0100
Message-ID: <20260128145344.331957407@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.8-rc1
X-KernelTest-Deadline: 2026-01-30T14:53+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.8 release.
There are 227 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.8-rc1

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge

Biju Das <biju.das.jz@bp.renesas.com>
    irqchip/renesas-rzv2h: Prevent TINT spurious interrupt during resume

Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
    arm64: dts: qcom: talos: Correct UFS clocks ordering

Rasmus Villemoes <ravi@prevas.dk>
    iio: core: add separate lockdep class for info_exist_lock

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: core: Replace lockdep_set_class() + mutex_init() by combined call

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/hugetlb: fix two comments related to huge_pmd_unshare()

jianyun.gao <jianyungao89@gmail.com>
    mm: fix some typos in mm module

Ravindra <ravindra@intel.com>
    Bluetooth: btintel_pcie: Support for S4 (Hibernate)

Tzung-Bi Shih <tzungbi@kernel.org>
    gpio: cdev: Fix resource leaks on errors in gpiolib_cdev_register()

Tzung-Bi Shih <tzungbi@kernel.org>
    gpio: cdev: Fix resource leaks on errors in lineinfo_changed_notify()

Tzung-Bi Shih <tzungbi@kernel.org>
    gpio: cdev: Correct return code on memory allocation failure

Marco Crivellari <marco.crivellari@suse.com>
    drm/xe: fix WQ_MEM_RECLAIM passed as max_active to alloc_workqueue()

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Adjust page count tracepoints in shrinker

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/bridge: synopsys: dw-dp: fix error paths of dw_dp_bind

Likun Gao <Likun.Gao@amd.com>
    drm/amdgpu: remove frame cntl for gfx v12

Marc Kleine-Budde <mkl@pengutronix.de>
    can: usb_8dev: usb_8dev_read_bulk_callback(): fix URB memory leak

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcba_usb: mcba_usb_read_bulk_callback(): fix URB memory leak

Marc Kleine-Budde <mkl@pengutronix.de>
    can: kvaser_usb: kvaser_usb_read_bulk_callback(): fix URB memory leak

Marc Kleine-Budde <mkl@pengutronix.de>
    can: esd_usb: esd_usb_read_bulk_callback(): fix URB memory leak

Marc Kleine-Budde <mkl@pengutronix.de>
    can: ems_usb: ems_usb_read_bulk_callback(): fix URB memory leak

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: remove the redundant data return in SW-FW mailbox

Hamza Mahfooz <someguy@effective-light.com>
    net: sfp: add potron quirk to the H-COM SPP425H-GAB4 SFP+ Stick

Clemens Gruber <mail@clemensgruber.at>
    net: fec: account for VLAN header in frame length calculations

Arnd Bergmann <arnd@arndb.de>
    irqchip/gic-v3-its: Avoid truncating memory addresses

Fernand Sieber <sieberf@amazon.com>
    perf/x86/intel: Do not enable BTS for guests

David Howells <dhowells@redhat.com>
    rxrpc: Fix data-race warning and potential load/store tearing

Alexandre Courbot <acourbot@nvidia.com>
    rust: irq: always inline functions using build_assert with arguments

Alexandre Courbot <acourbot@nvidia.com>
    rust: io: always inline functions using build_assert with arguments

Frank Zhang <rmxpzlb@gmail.com>
    pmdomain:rockchip: Fix init genpd as GENPD_STATE_ON before regulator ready

Ming Qian <ming.qian@oss.nxp.com>
    pmdomain: imx8m-blk-ctrl: Remove separate rst and clk mask for 8mq vpu

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86: hp-bioscfg: Fix automatic module loading

Jeongjun Park <aha310510@gmail.com>
    netrom: fix double-free in nr_route_frame()

Chenghai Huang <huangchenghai2@huawei.com>
    uacce: ensure safe queue release with state management

Yang Shen <shenyang39@huawei.com>
    uacce: implement mremap in uacce_vm_ops to return -EPERM

Chenghai Huang <huangchenghai2@huawei.com>
    uacce: fix isolate sysfs check condition

Wenkai Lin <linwenkai6@hisilicon.com>
    uacce: fix cdev handling in the cleanup path

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/boot/vmlinux.lds.S: Ensure bzImage ends with SecureBoot trailer

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: Fix wrong APQN fill calculation

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: trace: treat reg parameter as string

Johan Hovold <johan@kernel.org>
    intel_th: fix device leak on output open()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix crash on synthetic stacktrace field usage

Johan Hovold <johan@kernel.org>
    slimbus: core: fix device reference leak on report present

Johan Hovold <johan@kernel.org>
    slimbus: core: fix runtime PM imbalance on report present

Thomas Fourier <fourier.thomas@gmail.com>
    octeontx2: Fix otx2_dma_map_page() error return code

Thomas Fourier <fourier.thomas@gmail.com>
    ksmbd: smbd: fix dma_unmap_sg() nents

Zhaoyang Huang <zhaoyang.huang@unisoc.com>
    arm64: Set __nocfi on swsusp_arch_resume()

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: signal: Fix restoration of SVE context

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: signal: Allocate SSVE storage when restoring ZA

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: ptrace: Fix SVE writes on !SME systems

Marek Vasut <marex@nabladev.com>
    wifi: rsi: Fix memory corruption due to not set vif driver data size

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: mwifiex: Fix a loop in mwifiex_update_ampdu_rxwinsize()

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: ath12k: fix dma_free_coherent() pointer

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: ath10k: fix dma_free_coherent() pointer

Lyude Paul <lyude@redhat.com>
    drm/nouveau/disp: Set drm_mode_config_funcs.atomic_(check|commit)

Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
    iommu/io-pgtable-arm: fix size_t signedness bug in unmap path

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: sdhci-of-dwcmshc: Prevent illegal clock reduction in HS200/HS400 mode

Matthew Schwartz <matthew.schwartz@linux.dev>
    mmc: rtsx_pci_sdmmc: implement sdmmc_card_busy function

Berk Cem Goksel <berkcgoksel@gmail.com>
    ALSA: usb-audio: Fix use-after-free in snd_usb_mixer_free()

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    ALSA: scarlett2: Fix buffer overflow in config retrieval

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Samsung 730QED to fix headphone

Takashi Iwai <tiwai@suse.de>
    ALSA: ctxfi: Fix potential OOB access in audio mixer handling

Kübrich, Andreas <andreas.kuebrich@spektra-dresden.de>
    iio: dac: ad5686: add AD5695R to ad5686_chip_info_tbl

Miaoqian Lin <linmq006@gmail.com>
    iio: dac: ad3552r-hs: fix out-of-bound write in ad3552r_hs_write_data_source

Fiona Klute <fiona.klute@gmx.de>
    iio: chemical: scd4x: fix reported channel endianness

Thorsten Blum <thorsten.blum@linux.dev>
    iio: adc: pac1934: Fix clamped value in pac1934_reg_snapshot

Johan Hovold <johan@kernel.org>
    iio: adc: exynos_adc: fix OF populate on driver rebind

Pei Xiao <xiaopei01@kylinos.cn>
    iio: adc: at91-sama5d2_adc: Fix potential use-after-free in sama5d2_adc driver

Tomas Melin <tomas.melin@vaisala.com>
    iio: adc: ad9467: fix ad9434 vref mask

Markus Koeniger <markus.koeniger@liebherr.com>
    iio: accel: iis328dq: fix gain values

Francesco Lavra <flavra@baylibre.com>
    iio: accel: adxl380: fix handling of unavailable "INT1" interrupt

Matthew Wilcox (Oracle) <willy@infradead.org>
    migrate: correct lock ordering for hugetlb file folios

Rob Herring (Arm) <robh@kernel.org>
    of: platform: Use default match table for /firmware

Weigang He <geoffreyhe2@gmail.com>
    of: fix reference count leak in of_alias_scan()

Gal Pressman <gal@nvidia.com>
    panic: only warn about deprecated panic_print on write access

Hans de Goede <johannes.goede@oss.qualcomm.com>
    leds: led-class: Only Add LED to leds_list when it is fully ready

Srish Srinivasan <ssrish@linux.ibm.com>
    keys/trusted_keys: fix handle passed to tpm_buf_append_name during unseal

Cedric Xing <cedric.xing@intel.com>
    x86: make page fault handling disable interrupts properly

Hariprasad Kelam <hkelam@marvell.com>
    Octeontx2-af: Add proper checks for fwdata

Ivan Vecera <ivecera@redhat.com>
    dpll: Prevent duplicate registrations

Eric Dumazet <edumazet@google.com>
    net/sched: act_ife: avoid possible NULL deref

Fan Gong <gongfan1@huawei.com>
    hinic3: Fix netif_queue_set_napi queue_index input parameter error

Melbin K Mathew <mlbnkm1@gmail.com>
    vsock/virtio: cap TX credit to local buffer size

Stefano Garzarella <sgarzare@redhat.com>
    vsock/test: fix seqpacket message bounds test

Melbin K Mathew <mlbnkm1@gmail.com>
    vsock/virtio: fix potential underflow in virtio_transport_get_credit()

David Yang <mmyangfl@gmail.com>
    net: openvswitch: fix data race in ovs_vport_get_upcall_stats

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: Fix error handling

Daniel Golle <daniel@makrotopia.org>
    net: pcs: pcs-mtk-lynxi: report in-band capability for 2500Base-X

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix off-by-one in maximum bridge ID determination

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: Fix network filter wake for asp-3.0

Eric Dumazet <edumazet@google.com>
    bonding: provide a net pointer to __skb_flow_dissect()

Taehee Yoo <ap420073@gmail.com>
    selftests: net: amt: wait longer for connection before sending packets

Andrey Vatoropin <a.vatoropin@crpt.ru>
    be2net: Fix NULL pointer dereference in be_cmd_get_mac_from_list

Alex Ramírez <lxrmrz732@rocketmail.com>
    drm/nouveau: implement missing DCB connector types; gracefully handle unknown connectors

Alex Ramírez <lxrmrz732@rocketmail.com>
    drm/nouveau: add missing DCB connector types

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix type for wptr in ring backup

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Workaround SI powertune issue on Radeon 430 (v2)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Don't clear SI SMC table when setting power limit

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Fix si_dpm mmCG_THERMAL_INT setting

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix pelt clock sync when entering idle

Will Rosenberg <whrosenb@asu.edu>
    perf: Fix refcount warning on event->mmap_count increment

Ming Lei <ming.lei@redhat.com>
    selftests/ublk: fix garbage output in foreground mode

Ming Lei <ming.lei@redhat.com>
    selftests/ublk: fix error handling for starting device

Ming Lei <ming.lei@redhat.com>
    selftests/ublk: fix IO thread idle check

Seamus Connor <sconnor@purestorage.com>
    ublk: fix ublksrv pid handling for pid namespaces

Lukasz Laguna <lukasz.laguna@intel.com>
    drm/xe: Update wedged.mode only after successful reset policy change

Matt Roper <matthew.d.roper@intel.com>
    drm/xe/pm: Add scope-based cleanup helper for runtime PM

Matthew Auld <matthew.auld@intel.com>
    drm/xe/migrate: fix job lock assert

Matthew Auld <matthew.auld@intel.com>
    drm/xe/uapi: disallow bind queue sharing

Thomas Gleixner <tglx@linutronix.de>
    clocksource: Reduce watchdog readout delay limit to prevent false positives

Hariprasad Kelam <hkelam@marvell.com>
    Octeontx2-pf: Update xdp features

Laurent Vivier <lvivier@redhat.com>
    usbnet: limit max_mtu based on device's hard_mtu

Eric Dumazet <edumazet@google.com>
    ipv6: annotate data-race in ndisc_router_discovery()

Eric Dumazet <edumazet@google.com>
    mISDN: annotate data-race around dev->work

Jijie Shao <shaojijie@huawei.com>
    net: hns3: fix the HCLGE_FD_AD_NXT_KEY error setting issue

Jijie Shao <shaojijie@huawei.com>
    net: hns3: fix wrong GENMASK() for HCLGE_FD_AD_COUNTER_NUM_M

David Yang <mmyangfl@gmail.com>
    be2net: fix data race in be_get_new_eqd

David Yang <mmyangfl@gmail.com>
    idpf: Fix data race in idpf_net_dim

David Yang <mmyangfl@gmail.com>
    net: hns3: fix data race in hns3_fetch_stats

Daniel Golle <daniel@makrotopia.org>
    net: phy: intel-xway: fix OF node refcount leakage

Mina Almasry <almasrymina@google.com>
    idpf: read lower clock bits inside the time sandwich

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: fix devlink reload call trace

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: add missing ice_deinit_hw() in devlink reinit path

Cody Haas <chaas@riotgames.com>
    ice: Fix persistent failure in ice_get_rxfh

Yun Lu <luyun@kylinos.cn>
    netdevsim: fix a race issue related to the operation on bpf_bound_progs list

Michal Luczaj <mhal@rbox.co>
    vsock/test: Do not filter kallsyms by symbol type

Brajesh Gupta <brajesh.gupta@imgtec.com>
    drm/imagination: Wait for FW trace update command completion

Chen-Yu Tsai <wenst@chromium.org>
    drm/mediatek: dpi: Find next bridge during probe

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Disable timestamp WA on VFs

Jani Nikula <jani.nikula@intel.com>
    drm/xe/vm: fix xe_vm_validation_exec() kernel-doc

Jani Nikula <jani.nikula@intel.com>
    drm/xe/xe_late_bind_fw: fix enum xe_late_bind_fw_id kernel-doc

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Fix error path in amd_iommu_probe_device()

Dave Jiang <dave.jiang@intel.com>
    ntb: transport: Fix uninitialized mutex

Arun Raghavan <arunr@valvesoftware.com>
    ALSA: usb: Increase volume range that triggers a warning

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    scsi: qla2xxx: Sanitize payload size to prevent member overflow

David Jeffery <djeffery@redhat.com>
    scsi: core: Wake up the error handler when final completions race against each other

Zilin Guan <zilin@seu.edu.cn>
    platform/x86/amd: Fix memory leak in wbrf_record()

Oleksandr Shamray <oleksandrs@nvidia.com>
    platform/mellanox: Fix SN5640/SN5610 LED platform data

Naohiko Shimizu <naohiko.shimizu@gmail.com>
    riscv: suspend: Fix stimecmp update hazard on RV32

Naohiko Shimizu <naohiko.shimizu@gmail.com>
    riscv: clocksource: Fix stimecmp update hazard on RV32

Arkadiusz Kozdra <floss@arusekk.pl>
    kconfig: fix static linking of nconf

Cheng-Yu Lee <cylee12@realtek.com>
    regmap: Fix race condition in hwspinlock irqsave routine

Felix Gu <gu_0233@qq.com>
    spi: spi-sprd-adi: Fix double free in probe error path

Georgi Djakov <djakov@kernel.org>
    interconnect: debugfs: initialize src_node and dst_node to empty strings

Haotian Zhang <vulab@iscas.ac.cn>
    iio: adc: ad7606: Fix incorrect type for error return variable

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    iio: adc: ad7280a: handle spi_setup() errors in probe()

Francesco Lavra <flavra@baylibre.com>
    iio: imu: st_lsm6dsx: fix iio_chan_spec for sensors without event detection

Jens Axboe <axboe@kernel.dk>
    io_uring/io-wq: check IO_WQ_BIT_EXIT inside work run loop

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    timekeeping: Adjust the leap state for the correct auxiliary timekeeper

Yosry Ahmed <yosry.ahmed@linux.dev>
    mm: restore per-memcg proactive reclaim with !CONFIG_NUMA

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/rmap: fix two comments related to huge_pmd_unshare()

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/hugetlb: fix hugetlb_pmd_shared()

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86: hp-bioscfg: Fix kernel panic in GET_INSTANCE_ID macro

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86: hp-bioscfg: Fix kobject warnings for empty attribute names

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm, drm/xe: Fix xe userptr in the absence of CONFIG_DEVICE_PRIVATE

Joanne Koong <joannelkoong@gmail.com>
    fs/writeback: skip AS_NO_DATA_INTEGRITY mappings in wait_sb_inodes()

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix getting range information for subdevices 16 to 255

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/kfence: avoid writing L1TF-vulnerable PTEs

David Howells <dhowells@redhat.com>
    rxrpc: Fix recvmsg() unconditional requeue

Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
    slab: fix kmalloc_nolock() context check for PREEMPT_RT

Alexey Charkov <alchark@gmail.com>
    arm64: dts: rockchip: Configure MCLK for analog sound on NanoPi M5

Alexey Charkov <alchark@gmail.com>
    arm64: dts: rockchip: Fix headphones widget name on NanoPi M5

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: fix unit-address for RK3588 NPU's core1 and core2's IOMMU

Ondrej Jirman <megi@xff.cz>
    arm64: dts: rockchip: Fix voltage threshold for volume keys for Pinephone Pro

Geraldo Nascimento <geraldogabriel@gmail.com>
    arm64: dts: rockchip: remove dangerous max-link-speed from helios64

Geraldo Nascimento <geraldogabriel@gmail.com>
    arm64: dts: rockchip: remove redundant max-link-speed from nanopi-r4s

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: dts: microchip: sama7d65: fix size-cells property for i2c3

Hari Prasath Gujulan Elango <hari.prasathge@microchip.com>
    ARM: dts: microchip: sama7d65: fix the ranges property for flx9

Yixun Lan <dlan@kernel.org>
    i2c: spacemit: drop IRQF_ONESHOT flag from IRQ request

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    scsi: xen: scsiback: Fix potential memory leak in scsiback_remove()

Long Li <longli@microsoft.com>
    scsi: storvsc: Process unsupported MODE_SENSE_10

feng <alec.jiang@gmail.com>
    Input: i8042 - add quirk for ASUS Zenbook UX425QA_UM425QA

gongqi <550230171hxy@gmail.com>
    Input: i8042 - add quirks for MECHREVO Wujie 15X Pro

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    Revert "nfc/nci: Add the inconsistency check between the input data length and count"

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    w1: fix redundant counter decrement in w1_attach_slave_device()

Thorsten Blum <thorsten.blum@linux.dev>
    w1: therm: Fix off-by-one buffer overflow in alarms_store

Ian Abbott <abbotti@mev.co.uk>
    comedi: dmm32at: serialize use of paged registers

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    serial: Fix not set tty->port race condition

Marnix Rijnart <marnix.rijnart@iwell.eu>
    serial: 8250_pci: Fix broken RS485 for F81504/508/512

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: mac80211: don't perform DA check on S1G beacon

Taeyang Lee <0wn@theori.io>
    crypto: authencesn - reject too-short AAD (assoclen<8) to match ESP/ESN spec

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: qfq: Use cl_is_active to determine whether class is active in qfq_rm_from_ag

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: Enforce that teql can only be used as root qdisc

Alok Tiwari <alok.a.tiwari@oracle.com>
    octeontx2: cn10k: fix RX flowid TCAM mask handling

Dmitry Skorodumov <dskr99@gmail.com>
    ipvlan: Make the addrs_lock be per port

Eric Dumazet <edumazet@google.com>
    l2tp: avoid one data-race in l2tp_tunnel_del_work()

Richard Genoud <richard.genoud@bootlin.com>
    pwm: max7360: Populate missing .sizeof_wfhw in max7360_pwm_ops

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: Ensure ioctl() returns a negative errno on error

David Yang <mmyangfl@gmail.com>
    veth: fix data race in veth_get_ethtool_stats

Kuniyuki Iwashima <kuniyu@google.com>
    fou: Don't allow 0 for FOU_ATTR_IPPROTO.

Kuniyuki Iwashima <kuniyu@google.com>
    tools: ynl: Specify --no-line-number in ynl-regen.sh.

Kuniyuki Iwashima <kuniyu@google.com>
    gue: Fix skb memleak with inner IP protocol 0.

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: avoid misleading per-packet error log

Xin Long <lucien.xin@gmail.com>
    sctp: move SCTP_CMD_ASSOC_SHKEY right after SCTP_CMD_PEER_INIT

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_receive_bulk_callback(): unanchor URL on usb_submit_urb() error

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: freescale: ucc_geth: Return early when TBI PHY can't be found

Ricardo B. Marlière <rbm@suse.com>
    selftests: net: fib-onlink-tests: Convert to use namespaces by default

Kuniyuki Iwashima <kuniyu@google.com>
    l2tp: Fix memleak in l2tp_udp_encap_recv().

Eric Dumazet <edumazet@google.com>
    bonding: limit BOND_MODE_8023AD to Ethernet devices

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    net: usb: dm9601: remove broken SR9700 support

Michal Luczaj <mhal@rbox.co>
    vsock/virtio: Coalesce only linear skb

Chwee-Lin Choong <chwee.lin.choong@intel.com>
    igc: Reduce TSN TX packet buffer from 7KB to 5KB per queue

Chwee-Lin Choong <chwee.lin.choong@intel.com>
    igc: fix race condition in TX timestamp read for register 0

Kurt Kanzenbach <kurt@linutronix.de>
    igc: Restore default Qbv schedule when changing channels

Ding Hui <dinghui@sangfor.com.cn>
    ice: Fix incorrect timeout ice_release_res()

Dave Ertman <david.m.ertman@intel.com>
    ice: Avoid detrimental cleanup for bond during interface stop

Jacob Keller <jacob.e.keller@intel.com>
    ice: initialize ring_stats->syncp

Yingying Tang <yingying.tang@oss.qualcomm.com>
    wifi: ath12k: Fix wrong P2P device link id issue

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: fix dead lock while flushing management frames

Yingying Tang <yingying.tang@oss.qualcomm.com>
    wifi: ath12k: Fix scan state stuck in ABORTING after cancel_remain_on_channel

Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
    wifi: ath12k: cancel scan only on active scan vdev

Niklas Cassel <cassel@kernel.org>
    ata: libata: Print features also for ATAPI devices

Niklas Cassel <cassel@kernel.org>
    ata: libata: Add DIPM and HIPM to ata_dev_print_features() early return

Niklas Cassel <cassel@kernel.org>
    ata: libata: Add cpr_log to ata_dev_print_features() early return

Niklas Cassel <cassel@kernel.org>
    ata: libata-sata: Improve link_power_management_supported sysfs attribute

Niklas Cassel <cassel@kernel.org>
    ata: libata: Call ata_dev_config_lpm() for ATAPI devices

Niklas Cassel <cassel@kernel.org>
    ata: ahci: Do not read the per port area for unimplemented ports

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: don't force radio frequency check in freq_to_idx()

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    pmdomain: qcom: rpmhpd: Add MXC to SC8280XP

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    dt-bindings: power: qcom,rpmpd: Add SC8280XP_MXC_AO

Mark Harmstone <mark@harmstone.com>
    btrfs: fix missing fields in superblock backup with BLOCK_GROUP_TREE

Michael Kelley <mhklinux@outlook.com>
    Drivers: hv: Always do Hyper-V panic notification in hv_kmsg_dump()

Faisal Bukhari <faisalbukhari523@gmail.com>
    perf parse-events: Fix evsel allocation failure

Chaoyi Chen <chaoyi.chen@rock-chips.com>
    arm64: dts: rockchip: Fix wrong register range of rk3576 gpu

Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
    arm64: dts: qcom: sm8650: Fix compile warnings in USB controller node

Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
    arm64: dts: qcom: sm8550: Fix compile warnings in USB controller node

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8280xp: Add missing VDD_MXC links


-------------

Diffstat:

 Documentation/netlink/specs/fou.yaml               |   2 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/microchip/sama7d65.dtsi          |   4 +-
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi             |  16 +++-
 arch/arm64/boot/dts/qcom/sm6150.dtsi               |   4 +-
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |   2 -
 arch/arm64/boot/dts/qcom/sm8650.dtsi               |   3 -
 .../boot/dts/rockchip/rk3399-kobol-helios64.dts    |   1 -
 .../arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dtsi |   1 -
 .../boot/dts/rockchip/rk3399-pinephone-pro.dts     |   4 +-
 arch/arm64/boot/dts/rockchip/rk3576-nanopi-m5.dts  |  12 ++-
 arch/arm64/boot/dts/rockchip/rk3576.dtsi           |   2 +-
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi      |   4 +-
 arch/arm64/kernel/hibernate.c                      |   2 +-
 arch/arm64/kernel/ptrace.c                         |  26 +++---
 arch/arm64/kernel/signal.c                         |  26 ++++--
 arch/riscv/kernel/suspend.c                        |   3 +-
 arch/s390/boot/vmlinux.lds.S                       |  17 ++--
 arch/x86/events/perf_event.h                       |  13 ++-
 arch/x86/include/asm/kfence.h                      |  29 +++++-
 arch/x86/mm/fault.c                                |  15 +--
 crypto/authencesn.c                                |   6 ++
 drivers/ata/ahci.c                                 |  10 +-
 drivers/ata/libata-core.c                          |   8 +-
 drivers/ata/libata-sata.c                          |   2 +-
 drivers/base/regmap/regmap.c                       |   4 +-
 drivers/block/ublk_drv.c                           |  39 +++++++-
 drivers/bluetooth/btintel_pcie.c                   |  41 +++++++++
 drivers/bluetooth/btintel_pcie.h                   |   2 +
 drivers/clocksource/timer-riscv.c                  |   3 +-
 drivers/comedi/comedi_fops.c                       |   2 +-
 drivers/comedi/drivers/dmm32at.c                   |  32 ++++++-
 drivers/comedi/range.c                             |   2 +-
 drivers/dpll/dpll_core.c                           |  12 +--
 drivers/gpio/gpiolib-cdev.c                        |  12 ++-
 drivers/gpu/drm/Kconfig                            |   2 +-
 drivers/gpu/drm/Makefile                           |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |  12 ---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |  31 ++++---
 drivers/gpu/drm/bridge/synopsys/dw-dp.c            |  20 ++--
 drivers/gpu/drm/imagination/pvr_fw_trace.c         |   8 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |  23 ++---
 .../drm/nouveau/include/nvkm/subdev/bios/conn.h    |  95 ++++++++++++++-----
 drivers/gpu/drm/nouveau/nouveau_display.c          |   2 +
 drivers/gpu/drm/nouveau/nvkm/engine/disp/uconn.c   |  73 +++++++++++----
 drivers/gpu/drm/xe/Kconfig                         |   2 +-
 drivers/gpu/drm/xe/xe_bo.c                         |   9 +-
 drivers/gpu/drm/xe/xe_debugfs.c                    |  72 ++++++++++++---
 drivers/gpu/drm/xe/xe_device_types.h               |  18 ++++
 drivers/gpu/drm/xe/xe_exec_queue.c                 |  32 ++++++-
 drivers/gpu/drm/xe/xe_exec_queue.h                 |   1 +
 drivers/gpu/drm/xe/xe_exec_queue_types.h           |   6 ++
 drivers/gpu/drm/xe/xe_ggtt.c                       |   2 +-
 drivers/gpu/drm/xe/xe_guc_ads.c                    |  14 +--
 drivers/gpu/drm/xe/xe_guc_ads.h                    |   5 +-
 drivers/gpu/drm/xe/xe_late_bind_fw_types.h         |   4 +-
 drivers/gpu/drm/xe/xe_lrc.c                        |   3 +
 drivers/gpu/drm/xe/xe_migrate.c                    |   4 +-
 drivers/gpu/drm/xe/xe_pm.c                         |  21 +++++
 drivers/gpu/drm/xe/xe_pm.h                         |  17 ++++
 drivers/gpu/drm/xe/xe_sriov_vf_ccs.c               |   2 +-
 drivers/gpu/drm/xe/xe_vm.c                         |   7 +-
 drivers/gpu/drm/xe/xe_vm.h                         |   2 +-
 drivers/hv/hv_common.c                             |  12 ++-
 drivers/hwtracing/intel_th/core.c                  |  19 +++-
 drivers/i2c/busses/i2c-k1.c                        |   2 +-
 drivers/iio/accel/adxl380.c                        |   6 +-
 drivers/iio/accel/st_accel_core.c                  |  72 ++++++++++++++-
 drivers/iio/adc/ad7280a.c                          |   4 +-
 drivers/iio/adc/ad7606_par.c                       |   3 +-
 drivers/iio/adc/ad9467.c                           |   2 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |   1 +
 drivers/iio/adc/exynos_adc.c                       |  15 +--
 drivers/iio/adc/pac1934.c                          |   6 +-
 drivers/iio/chemical/scd4x.c                       |   6 +-
 drivers/iio/dac/ad3552r-hs.c                       |   5 +-
 drivers/iio/dac/ad5686.c                           |   6 ++
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |  15 ++-
 drivers/iio/industrialio-core.c                    |   7 +-
 drivers/input/serio/i8042-acpipnpio.h              |  18 ++++
 drivers/interconnect/debugfs-client.c              |   5 +
 drivers/iommu/amd/iommu.c                          |   3 +-
 drivers/iommu/io-pgtable-arm.c                     |   2 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   8 +-
 drivers/irqchip/irq-renesas-rzv2h.c                |  11 ++-
 drivers/isdn/mISDN/timerdev.c                      |  13 ++-
 drivers/leds/led-class.c                           |  10 +-
 drivers/misc/mei/mei-trace.h                       |  18 ++--
 drivers/misc/uacce/uacce.c                         |  48 ++++++++--
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |  41 +++++++++
 drivers/mmc/host/sdhci-of-dwcmshc.c                |   7 ++
 drivers/net/bonding/bond_main.c                    |  11 ++-
 drivers/net/can/usb/ems_usb.c                      |   8 +-
 drivers/net/can/usb/esd_usb.c                      |   9 +-
 drivers/net/can/usb/gs_usb.c                       |   7 ++
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   9 +-
 drivers/net/can/usb/mcba_usb.c                     |   8 +-
 drivers/net/can/usb/usb_8dev.c                     |   8 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   5 +-
 drivers/net/ethernet/broadcom/asp2/bcmasp.c        |   5 +-
 drivers/net/ethernet/broadcom/asp2/bcmasp.h        |   1 +
 drivers/net/ethernet/emulex/benet/be_cmds.c        |   3 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |   8 +-
 drivers/net/ethernet/freescale/fec_main.c          |  13 +--
 drivers/net/ethernet/freescale/ucc_geth.c          |   4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  69 +++++++-------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   2 +-
 drivers/net/ethernet/huawei/hinic3/hinic3_irq.c    |  22 +++--
 drivers/net/ethernet/intel/ice/devlink/devlink.c   |   1 +
 drivers/net/ethernet/intel/ice/ice.h               |   1 +
 drivers/net/ethernet/intel/ice/ice_common.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   6 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |  29 ++++--
 drivers/net/ethernet/intel/ice/ice_main.c          |  31 ++++++-
 drivers/net/ethernet/intel/idpf/idpf_ptp.c         |   2 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |  16 +++-
 drivers/net/ethernet/intel/igc/igc_defines.h       |   5 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |   4 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   5 +
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  43 +++++----
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  86 ++++++++++++-----
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   3 +
 .../net/ethernet/marvell/octeontx2/af/rvu_sdp.c    |   2 +-
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   7 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   4 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c     |   4 +-
 drivers/net/ipvlan/ipvlan.h                        |   2 +-
 drivers/net/ipvlan/ipvlan_core.c                   |  16 ++--
 drivers/net/ipvlan/ipvlan_main.c                   |  49 ++++++----
 drivers/net/netdevsim/bpf.c                        |   6 ++
 drivers/net/netdevsim/dev.c                        |   2 +
 drivers/net/netdevsim/netdevsim.h                  |   1 +
 drivers/net/pcs/pcs-mtk-lynxi.c                    |   4 +-
 drivers/net/phy/intel-xway.c                       |   7 +-
 drivers/net/phy/sfp.c                              |   2 +
 drivers/net/usb/dm9601.c                           |   4 -
 drivers/net/usb/usbnet.c                           |   9 +-
 drivers/net/veth.c                                 |   8 +-
 drivers/net/wireless/ath/ath10k/ce.c               |  16 ++--
 drivers/net/wireless/ath/ath12k/ce.c               |  12 +--
 drivers/net/wireless/ath/ath12k/mac.c              |  16 ++--
 drivers/net/wireless/ath/ath12k/wmi.c              |   9 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |   6 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   1 +
 drivers/nfc/virtual_ncidev.c                       |   4 -
 drivers/ntb/ntb_transport.c                        |   1 +
 drivers/of/base.c                                  |   8 +-
 drivers/of/platform.c                              |   2 +-
 drivers/platform/mellanox/mlx-platform.c           |   2 +-
 drivers/platform/x86/amd/wbrf.c                    |   4 +-
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c       |   8 ++
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.h       |  12 ++-
 drivers/pmdomain/imx/imx8m-blk-ctrl.c              |  11 ++-
 drivers/pmdomain/qcom/rpmhpd.c                     |   4 +
 drivers/pmdomain/rockchip/pm-domains.c             |  10 ++
 drivers/pwm/core.c                                 |  10 +-
 drivers/pwm/pwm-max7360.c                          |   1 +
 drivers/s390/crypto/ap_card.c                      |   2 +-
 drivers/s390/crypto/ap_queue.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |   7 ++
 drivers/scsi/scsi_error.c                          |  11 ++-
 drivers/scsi/scsi_lib.c                            |   8 ++
 drivers/scsi/storvsc_drv.c                         |   3 +-
 drivers/slimbus/core.c                             |  19 ++--
 drivers/spi/spi-sprd-adi.c                         |  33 ++-----
 drivers/tty/serial/8250/8250_pci.c                 |   2 +-
 drivers/tty/serial/serial_core.c                   |   6 ++
 drivers/w1/slaves/w1_therm.c                       |  60 ++++--------
 drivers/w1/w1.c                                    |   2 -
 drivers/xen/xen-scsiback.c                         |   1 +
 fs/btrfs/disk-io.c                                 |   2 +-
 fs/fs-writeback.c                                  |   7 +-
 fs/fuse/file.c                                     |   4 +-
 fs/smb/server/transport_rdma.c                     |  15 ++-
 include/drm/drm_pagemap.h                          |  19 +++-
 include/dt-bindings/power/qcom,rpmhpd.h            |   1 +
 include/linux/hugetlb.h                            |   2 +-
 include/linux/iio/iio-opaque.h                     |   2 +
 include/linux/pagemap.h                            |  11 +++
 include/trace/events/rxrpc.h                       |   4 +
 include/uapi/linux/comedi.h                        |   2 +-
 io_uring/io-wq.c                                   |   2 +-
 kernel/events/core.c                               |   9 ++
 kernel/panic.c                                     |   4 +-
 kernel/sched/fair.c                                |   6 --
 kernel/sched/idle.c                                |   6 ++
 kernel/time/clocksource.c                          |   2 +-
 kernel/time/timekeeping.c                          |   2 +-
 kernel/trace/trace_events_hist.c                   |   9 ++
 kernel/trace/trace_events_synth.c                  |   8 +-
 mm/damon/sysfs.c                                   |   2 +-
 mm/gup.c                                           |   2 +-
 mm/hugetlb.c                                       |  28 ++----
 mm/hugetlb_vmemmap.c                               |   6 +-
 mm/internal.h                                      |   8 --
 mm/kmsan/core.c                                    |   2 +-
 mm/ksm.c                                           |   2 +-
 mm/memory-tiers.c                                  |   2 +-
 mm/memory.c                                        |   4 +-
 mm/migrate.c                                       |  12 +--
 mm/rmap.c                                          |  20 +---
 mm/secretmem.c                                     |   2 +-
 mm/slab_common.c                                   |   2 +-
 mm/slub.c                                          |  10 +-
 mm/swapfile.c                                      |   2 +-
 mm/userfaultfd.c                                   |   2 +-
 mm/vma.c                                           | 102 ++++++++++++++-------
 mm/vma.h                                           |   3 +
 mm/vmscan.c                                        |  13 ++-
 net/dsa/dsa.c                                      |   2 +-
 net/ipv4/fou_core.c                                |   3 +
 net/ipv4/fou_nl.c                                  |   2 +-
 net/ipv6/ndisc.c                                   |   4 +-
 net/l2tp/l2tp_core.c                               |   8 +-
 net/mac80211/scan.c                                |   9 +-
 net/netrom/nr_route.c                              |  13 ++-
 net/openvswitch/vport.c                            |  11 ++-
 net/rxrpc/ar-internal.h                            |   9 +-
 net/rxrpc/conn_event.c                             |   2 +-
 net/rxrpc/output.c                                 |  14 +--
 net/rxrpc/peer_event.c                             |  17 +++-
 net/rxrpc/proc.c                                   |   4 +-
 net/rxrpc/recvmsg.c                                |  19 +++-
 net/rxrpc/rxgk.c                                   |   2 +-
 net/rxrpc/rxkad.c                                  |   2 +-
 net/sched/act_ife.c                                |   6 +-
 net/sched/sch_qfq.c                                |   2 +-
 net/sched/sch_teql.c                               |   5 +
 net/sctp/sm_statefuns.c                            |  10 +-
 net/vmw_vsock/virtio_transport_common.c            |  36 +++++---
 rust/kernel/io.rs                                  |   9 +-
 rust/kernel/io/resource.rs                         |   2 +
 rust/kernel/irq/flags.rs                           |   2 +
 scripts/kconfig/nconf-cfg.sh                       |  11 ++-
 security/keys/trusted-keys/trusted_tpm2.c          |   4 +-
 sound/hda/codecs/realtek/alc269.c                  |   1 +
 sound/pci/ctxfi/ctamixer.c                         |   2 +
 sound/usb/mixer.c                                  |  22 ++++-
 sound/usb/mixer_scarlett2.c                        |   6 +-
 tools/net/ynl/ynl-regen.sh                         |   2 +-
 tools/perf/util/parse-events.c                     |   7 +-
 tools/testing/selftests/net/amt.sh                 |   7 +-
 tools/testing/selftests/net/fib-onlink-tests.sh    |  71 ++++++--------
 tools/testing/selftests/ublk/kublk.c               |  11 ++-
 tools/testing/vsock/util.h                         |   2 +-
 tools/testing/vsock/vsock_test.c                   |  11 +++
 249 files changed, 1889 insertions(+), 875 deletions(-)


