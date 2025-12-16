Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B7E2459D7;
	Tue, 16 Dec 2025 11:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883911; cv=none; b=Pyh1cGWp+4ZKkcDImbV2eqb7PNzXOK6Svrk2x3+MOgnbP0KBznjJ2nDrdk+PBBZfbZ4a24cB/+Ow1CuehL8/sTfQtDPOv/oS1TTsZi7z9/IaJOMHRd2Vo3b+w0fSzRBo0Nmna7MTzUjHkIATO1ptvp5kARPyd7dOvj8DxGqbNzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883911; c=relaxed/simple;
	bh=P/EvSgiBGy62A3abPrk6vofcCeJAbce3SK7+WMwb4Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S+HaVEhZcxmZgmRD60mDPe6fJpq2vaOfOazlsuV2uszgRaUGcPfTrm8hwpwOEnpaVikr0a70kQPpDh2ftjILmeAK0nB7kv7d2S3q674OCnGw8JJDVsYkCxzuF1BO7EqtvPrMcurEHuSRqHIyCnJG7AhLMU/vla3WD5GV0tVYzhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiH7paQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiH7paQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC737C4CEF1;
	Tue, 16 Dec 2025 11:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883911;
	bh=P/EvSgiBGy62A3abPrk6vofcCeJAbce3SK7+WMwb4Ac=;
	h=From:To:Cc:Subject:Date:From;
	b=xiH7paQjQDUDvMu70EsOm5927CE0mZpZHbxPE4Q7D9oPPRA/hN5QlcpWKPOn18TQ9
	 kMFqwK4LEYL/fyxXP+OssueIBMHeOUYvHahz5blUDBb04xT49PyG4VbfsgK6bTTe9+
	 nhP5o3/03cA5kdTDWAe3/2TDVZxpojyI22K3S+LU=
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
Subject: [PATCH 6.12 000/354] 6.12.63-rc1 review
Date: Tue, 16 Dec 2025 12:09:27 +0100
Message-ID: <20251216111320.896758933@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.63-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.63-rc1
X-KernelTest-Deadline: 2025-12-18T11:13+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.63 release.
There are 354 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.63-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.63-rc1

Junrui Luo <moonafterrain@outlook.com>
    ALSA: wavefront: Fix integer overflow in sample size validation

Junrui Luo <moonafterrain@outlook.com>
    ALSA: dice: fix buffer overflow in detect_stream_formats()

Sven Peter <sven@kernel.org>
    usb: dwc3: dwc3_power_off_all_roothub_ports: Use ioremap_np when required

Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
    usb: phy: Initialize struct usb_phy list_head

Haotien Hsu <haotienh@nvidia.com>
    usb: gadget: tegra-xudc: Always reinitialize data toggle when clear halt

Eric Dumazet <edumazet@google.com>
    tcp_metrics: use dst_dev_net_rcu()

Eric Dumazet <edumazet@google.com>
    net: dst: introduce dst->dev_rcu

Thangaraj Samynathan <thangaraj.s@microchip.com>
    net: lan743x: Allocate rings outside ZONE_DMA

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Add machine_kexec_mask_interrupts() implementation

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix memory leak in ocfs2_merge_rec_left()

Dan Carpenter <dan.carpenter@linaro.org>
    irqchip/mchp-eic: Fix error code in mchp_eic_domain_alloc()

Duoming Zhou <duoming@zju.edu.cn>
    scsi: imm: Fix use-after-free bug caused by unfinished delayed work

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    efi/cper: align ARM CPER type with UEFI 2.9A/2.10 specs

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    efi/cper: Adjust infopfx size to accept an extra space

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    efi/cper: Add a new helper function to print bitmasks

Haotian Zhang <vulab@iscas.ac.cn>
    dm log-writes: Add missing set_freezable() for freezable kthread

Alexey Simakov <bigalex934@gmail.com>
    dm-raid: fix possible NULL dereference with undefined raid type

Christoph Hellwig <hch@lst.de>
    block: return unsigned int from queue_dma_alignment

Mohamed Khalfella <mkhalfella@purestorage.com>
    block: Use RCU in blk_mq_[un]quiesce_tagset() instead of set->tag_list_lock

Liyuan Pang <pangliyuan1@huawei.com>
    ARM: 9464/1: fix input-only operand modification in load_unaligned_zeropad()

Junrui Luo <moonafterrain@outlook.com>
    ALSA: firewire-motu: add bounds check in put_user loop for DSP events

Haotian Zhang <vulab@iscas.ac.cn>
    rtc: gamecube: Check the return value of ioremap()

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Use huge page size to check split svm range alignment

Andres J Rosa <andyrosa@gmail.com>
    ALSA: uapi: Fix typo in asound.h comment

Dave Kleikamp <dave.kleikamp@oracle.com>
    dma/pool: eliminate alloc_pages warning in atomic_pool_expand

Kathara Sasikumar <katharasasikumar007@gmail.com>
    docs: hwmon: fix link to g762 devicetree binding

David Howells <dhowells@redhat.com>
    cifs: Fix handling of a beyond-EOF DIO/unbuffered read over SMB2

Madhur Kumar <madhurkumar004@gmail.com>
    drm/nouveau: refactor deprecated strcpy

Junrui Luo <moonafterrain@outlook.com>
    ALSA: firewire-motu: fix buffer overflow in hwdep read for DSP events

Mark Brown <broonie@kernel.org>
    regulator: fixed: Rely on the core freeing the enable GPIO

Dan Carpenter <dan.carpenter@linaro.org>
    drm/plane: Fix IS_ERR() vs NULL check in drm_plane_create_hotspot_properties()

Israel Rukshin <israelr@nvidia.com>
    nvme-auth: use kvfree() for memory allocated with kvcalloc()

Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
    block: fix memory leak in __blkdev_issue_zero_pages

shechenglong <shechenglong@xfusion.com>
    block: fix comment for op_is_zone_mgmt() to include RESET_ALL

Cong Zhang <cong.zhang@oss.qualcomm.com>
    blk-mq: Abort suspend when wakeup events are pending

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak5558: Disable regulator when error happens

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak4458: Disable regulator when error happens

Haotian Zhang <vulab@iscas.ac.cn>
    ASoC: bcm: bcm63xx-pcm-whistler: Check return value of of_dma_configure()

Anton Khirnov <anton@khirnov.net>
    platform/x86: asus-wmi: use brightness_set_blocking() for kbd led

Armin Wolf <W_Armin@gmx.de>
    fs/nls: Fix inconsistency between utf8_to_utf32() and utf32_to_utf8()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix inheritance of the block sizes when automounting

Trond Myklebust <trond.myklebust@primarydata.com>
    Expand the type of nfs_fattr->valid

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Automounted filesystems should inherit ro,noexec,nodev,sync flags

Trond Myklebust <trond.myklebust@hammerspace.com>
    Revert "nfs: ignore SB_RDONLY when mounting nfs"

Trond Myklebust <trond.myklebust@hammerspace.com>
    Revert "nfs: clear SB_RDONLY before getting superblock"

Trond Myklebust <trond.myklebust@hammerspace.com>
    Revert "nfs: ignore SB_RDONLY when remounting nfs"

Jonathan Curley <jcurley@purestorage.com>
    NFSv4/pNFS: Clear NFS_INO_LAYOUTCOMMIT in pnfs_mark_layout_stateid_invalid

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Initialise verifiers for visible dentries in _nfs4_open_and_get_state

NeilBrown <neilb@suse.de>
    nfs/vfs: discard d_exact_alias()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Initialise verifiers for visible dentries in nfs_atomic_open()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Initialise verifiers for visible dentries in readdir and lookup

Armin Wolf <W_Armin@gmx.de>
    fs/nls: Fix utf16 to utf8 conversion

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Avoid changing nlink when file removes and attribute updates race

Daeho Jeong <daehojeong@google.com>
    f2fs: maintain one time GC mode is enabled during whole zoned GC cycle

Daeho Jeong <daehojeong@google.com>
    f2fs: add gc_boost_gc_greedy sysfs node

Daeho Jeong <daehojeong@google.com>
    f2fs: add gc_boost_gc_multiple sysfs node

Chao Yu <chao@kernel.org>
    f2fs: introduce reserved_pin_section sysfs entry

Chao Yu <chao@kernel.org>
    f2fs: sysfs: add encoding_flags entry

Daeho Jeong <daehojeong@google.com>
    f2fs: add carve_out sysfs node

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid running out of free segments

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: add a sysfs entry to reclaim POSIX_FADV_NOREUSE pages

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: keep POSIX_FADV_NOREUSE ranges

Xi Pardee <xi.pardee@linux.intel.com>
    platform/x86:intel/pmc: Update Arrow Lake telemetry GUID

xupengbo <xupengbo@oppo.com>
    sched/fair: Fix unfairness caused by stalled tg_load_avg_contrib when the last task migrates out

Eric Sandeen <sandeen@redhat.com>
    9p: fix cache/debug options printing in v9fs_show_options

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: ssd1307fb: fix potential page leak in ssd1307fb_probe()

Haotian Zhang <vulab@iscas.ac.cn>
    pinctrl: single: Fix incorrect type for error return variable

Ian Rogers <irogers@google.com>
    perf hist: In init, ensure mem_info is put on error paths

Namhyung Kim <namhyung@kernel.org>
    perf tools: Fix split kallsyms DSO counting

Namhyung Kim <namhyung@kernel.org>
    perf tools: Mark split kallsyms DSOs as loaded

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_cake: Fix incorrect qlen reduction in cake_drop

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: xrs700x: reject unsupported HSR configurations

Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
    net: hsr: create an API to get hsr port type

MD Danish Anwar <danishanwar@ti.com>
    net: hsr: Create and export hsr_get_port_ndev()

Eric Dumazet <edumazet@google.com>
    net: hsr: remove synchronize_rcu() from hsr_add_port()

Eric Dumazet <edumazet@google.com>
    net: hsr: remove one synchronize_rcu() from hsr_del_port()

Johan Hovold <johan@kernel.org>
    clk: keystone: fix compile testing

Yu Kuai <yukuai@fnnas.com>
    md/raid5: fix IO hang when array is broken with IO inflight

Alexandru Gagniuc <mr.nuke.me@gmail.com>
    remoteproc: qcom_q6v5_wcss: fix parsing of qcom,halt-regs

Ivan Stepchenko <sid@itb.spb.ru>
    mtd: lpddr_cmds: fix signed shifts in lpddr_cmds

Hangbin Liu <liuhangbin@gmail.com>
    selftests: bonding: add delay before each xvlan_over_bond connectivity check

Etienne Champetier <champetier.etienne@gmail.com>
    selftests: bonding: add ipvlan over bond testing

Robert Marko <robimarko@gmail.com>
    net: phy: aquantia: check for NVMEM deferral

Alex Williamson <alex.williamson@nvidia.com>
    vfio/pci: Use RCU for error/request triggers to avoid circular locking

Tianchu Chen <flynnnchen@tencent.com>
    spi: ch341: fix out-of-bounds memory access in ch341_transfer_one

Haotian Zhang <vulab@iscas.ac.cn>
    mtd: rawnand: renesas: Handle devm_pm_runtime_enable() errors

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    net: stmmac: fix rx limit check in stmmac_rx_zc()

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nft_connlimit: update the count if add was skipped

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_conncount: rework API to use sk_buff directly

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: check for maximum number of encapsulations in bridge vlan

Ilias Stamatis <ilstam@amazon.com>
    Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res()"

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    resource: introduce is_type_match() helper and use it

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    resource: replace open coded resource_intersection()

sparkhuang <huangshaobo3@xiaomi.com>
    regulator: core: Protect regulator_supply_alias_list with regulator_list_mutex

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: samsung: exynos4412-midas: turn off SDIO WLAN chip during system suspend

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: samsung: exynos4210-trats: turn off SDIO WLAN chip during system suspend

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: samsung: exynos4210-i9100: turn off SDIO WLAN chip during system suspend

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: samsung: universal_c210: turn off SDIO WLAN chip during system suspend

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    spi: airoha-snfi: en7523: workaround flash damaging if UART_TXD was short to GND

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: catpt: Fix error path in hw_params()

Alok Tiwari <alok.a.tiwari@oracle.com>
    vdpa/pds: use %pe for ERR_PTR() in event handler registration

Mike Christie <michael.christie@oracle.com>
    vhost: Fix kthread worker cgroup failure handling

Alok Tiwari <alok.a.tiwari@oracle.com>
    vdpa/mlx5: Fix incorrect error code reporting in query_virtqueues

Michael S. Tsirkin <mst@redhat.com>
    virtio: fix virtqueue_set_affinity() docs

Michael S. Tsirkin <mst@redhat.com>
    virtio: fix grammar in virtio_queue_info docs

Michael S. Tsirkin <mst@redhat.com>
    virtio: fix whitespace in virtio_config_ops

Michael S. Tsirkin <mst@redhat.com>
    virtio: fix typo in virtio_device_ready() comment

Alok Tiwari <alok.a.tiwari@oracle.com>
    virtio_vdpa: fix misleading return in void function

Guenter Roeck <linux@roeck-us.net>
    of: Skip devicetree kunit tests when RISCV+ACPI doesn't populate root node

Yongjian Sun <sunyongjian1@huawei.com>
    ext4: improve integrity checking in __mb_check_buddy by enhancing order-0 validation

Kevin Brodsky <kevin.brodsky@arm.com>
    ublk: prevent invalid access with DEBUG

René Rebe <rene@exactco.de>
    ACPI: processor_core: fix map_x2apic_id for amd-pstate on am4

Haotian Zhang <vulab@iscas.ac.cn>
    hwmon: sy7636a: Fix regulator_enable resource leak on error path

Dan Carpenter <dan.carpenter@linaro.org>
    drm/amd/display: Fix logical vs bitwise bug in get_embedded_panel_info_v2_1()

Will Rosenberg <whrosenb@asu.edu>
    kernfs: fix memory leak of kernfs_iattrs in __kernfs_new_node

Haotian Zhang <vulab@iscas.ac.cn>
    greybus: gb-beagleplay: Fix timeout handling in bootloader functions

Alexandre Courbot <acourbot@nvidia.com>
    firmware_loader: make RUST_FW_LOADER_ABSTRACTIONS select FW_LOADER

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_xcvr: clear the channel status control memory

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Prevent recursive memory reclaim

Jaroslav Kysela <perex@perex.cz>
    ASoC: nau8325: add missing build config

Jaroslav Kysela <perex@perex.cz>
    ASoC: nau8325: use simple i2c probe function

Akash Goel <akash.goel@arm.com>
    drm/panthor: Avoid adding of kernel BOs to extobj list

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Do not directly rely on IB_PD_UNSAFE_GLOBAL_RKEY

Krzysztof Czurylo <krzysztof.czurylo@intel.com>
    RDMA/irdma: Fix data race in irdma_free_pble

Krzysztof Czurylo <krzysztof.czurylo@intel.com>
    RDMA/irdma: Fix data race in irdma_sc_ccq_arm

Stephan Gerhold <stephan.gerhold@linaro.org>
    iommu/arm-smmu-qcom: Enable use of all SMR groups when running bare-metal

Randy Dunlap <rdunlap@infradead.org>
    backlight: lp855x: Fix lp855x.h kernel-doc warnings

Luca Ceresoli <luca.ceresoli@bootlin.com>
    backlight: led-bl: Add devlink to supplier LEDs

Ria Thomas <ria.thomas@morsemicro.com>
    wifi: ieee80211: correct FILS status codes

Christoph Hellwig <hch@lst.de>
    iomap: always run error completions in user context

Christoph Hellwig <hch@lst.de>
    iomap: factor out a iomap_dio_done helper

David Gow <davidgow@google.com>
    um: Don't rename vmap to kernel_vmap

Timur Tabi <ttabi@nvidia.com>
    drm/nouveau: restrict the flush page to a 32-bit address

Shawn Lin <shawn.lin@rock-chips.com>
    PCI: dwc: Fix wrong PORT_LOGIC_LTSSM_STATE_MASK definition

Filipe Manana <fdmanana@suse.com>
    btrfs: fix leaf leak in an error path in btrfs_del_items()

Ryan Huang <tzukui@google.com>
    iommu/arm-smmu-v3: Fix error check in arm_smmu_alloc_cd_tables

Jianglei Nie <niejianglei2021@163.com>
    staging: fbtft: core: fix potential memory leak in fbtft_probe_common()

Dinh Nguyen <dinguyen@kernel.org>
    firmware: stratix10-svc: fix make htmldocs warning for stratix10_svc

Zilin Guan <zilin@seu.edu.cn>
    mt76: mt7615: Fix memory leak in mt7615_mcu_wtbl_sta_add()

Shenghao Ding <shenghao-ding@ti.com>
    ASoC: tas2781: correct the wrong period

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Pass correct flag for dma mr creation

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix the inline size for GenP7 devices

Gao Xiang <xiang@kernel.org>
    erofs: limit the level of fs stacking for file-backed mounts

Fangyu Yu <fangyu.yu@linux.alibaba.com>
    RISC-V: KVM: Fix guest page fault within HLV* instructions

Haotian Zhang <vulab@iscas.ac.cn>
    crypto: ccree - Correctly handle return of sg_nents_for_len

Haotian Zhang <vulab@iscas.ac.cn>
    crypto: starfive - Correctly handle return of sg_nents_for_len

Matt Bobrowski <mattbobrowski@google.com>
    selftests/bpf: Improve reliability of test_perf_branches_no_hw()

Matt Bobrowski <mattbobrowski@google.com>
    selftests/bpf: skip test_perf_branches_hw() on unsupported platforms

Gopi Krishna Menon <krishnagopi487@gmail.com>
    usb: raw-gadget: cap raw_io transfer length to KMALLOC_MAX_SIZE

Jisheng Zhang <jszhang@kernel.org>
    usb: dwc2: fix hang during suspend if set as peripheral

Jisheng Zhang <jszhang@kernel.org>
    usb: dwc2: fix hang during shutdown if set as peripheral

Jisheng Zhang <jszhang@kernel.org>
    usb: dwc2: disable platform lowlevel hw resources during shutdown

Oliver Neukum <oneukum@suse.com>
    usb: chaoskey: fix locking for O_NONBLOCK

Zhao Yipeng <zhaoyipeng5@huawei.com>
    ima: Handle error code returned by ima_filter_rule_match()

Jason Tian <jason@os.amperecomputing.com>
    RAS: Report all ARM processor CPER information to userspace

Seungjin Bae <eeodqql09@gmail.com>
    wifi: rtl818x: rtl8187: Fix potential buffer underflow in rtl8187_rx_cb()

Chen Ridong <chenridong@huawei.com>
    cpuset: Treat cpusets in attaching as populated

Alexander Dahl <ada@thorsis.com>
    net: phy: adin1100: Fix software power-down ready condition

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    phy: rockchip: samsung-hdptx: Prevent Inter-Pair Skew from exceeding the limits

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    phy: rockchip: samsung-hdptx: Reduce ROPLL loop bandwidth

Xiaolei Wang <xiaolei.wang@windriver.com>
    phy: freescale: Initialize priv->lock

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    phy: renesas: rcar-gen3-usb2: Fix an error handling path in rcar_gen3_phy_usb2_probe()

Fenglin Wu <fenglin.wu@oss.qualcomm.com>
    leds: rgb: leds-qcom-lpg: Don't enable TRILED when configuring PWM

Haotian Zhang <vulab@iscas.ac.cn>
    mfd: mt6358-irq: Fix missing irq_domain_remove() in error path

Haotian Zhang <vulab@iscas.ac.cn>
    mfd: mt6397-irq: Fix missing irq_domain_remove() in error path

Chien Wong <m@xv97.com>
    wifi: mac80211: fix CMAC functions not handling errors

Aashish Sharma <aashish@aashishsharma.net>
    iommu/vt-d: Fix unused invalidation hint in qi_desc_iotlb

Zilin Guan <zilin@seu.edu.cn>
    scsi: qla2xxx: Fix improper freeing of purex item

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: bcm2835: Make sure the channel is enabled after pwm_request()

Leo Yan <leo.yan@arm.com>
    perf arm_spe: Fix memset subclass in operation

Leo Yan <leo.yan@arm.com>
    perf arm-spe: Extend branch operations

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv6: clear RA flags when adding a static route

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Improve MX rail fallback in RPMH vote init

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix the gemnoc workaround

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Flush LRZ cache before PT switch

Jay Liu <jay.liu@mediatek.com>
    drm/mediatek: Fix CCORR mtk_ctm_s31_32_to_s1_n function issue

Edward Adam Davis <eadavis@qq.com>
    fs/ntfs3: Prevent memory leaks in add sub record

Edward Adam Davis <eadavis@qq.com>
    fs/ntfs3: out1 also needs to put mi

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/64s/ptdump: Fix kernel_hash_pagetable dump for ISA v3.00 HPTE format

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/64s/hash: Restrict stress_hpt_struct memblock region to within RMA limit

Pu Lehui <pulehui@huawei.com>
    bpf: Fix invalid prog->stats access when update_effective_progs fails

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: rtl818x: Fix potential memory leaks in rtl8180_init_rx_ring()

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/a2xx: stop over-complaining about the legacy firmware

Guenter Roeck <linux@roeck-us.net>
    block/blk-throttle: Fix throttle slice time for SSDs

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD/blocklayout: Fix minlength check in proc_layoutget

Al Viro <viro@zeniv.linux.org.uk>
    tracefs: fix a leak in eventfs_create_events_dir()

Haotian Zhang <vulab@iscas.ac.cn>
    watchdog: starfive: Fix resource leak in probe error path

Haotian Zhang <vulab@iscas.ac.cn>
    watchdog: wdat_wdt: Fix ACPI table leak in probe function

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: Check skb->transport_header is set in bpf_skb_check_mtu

Alexei Starovoitov <ast@kernel.org>
    selftests/bpf: Fix failure paths in send_signal test

Menglong Dong <menglong8.dong@gmail.com>
    bpf: Handle return value of ftrace_set_filter_ip in register_fentry

Rene Rebe <rene@exactco.de>
    ps3disk: use memcpy_{from,to}_bvec index

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/dpu: drop dpu_hw_dsc_destroy() prototype

Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
    s390/fpu: Fix false-positive kmsan report in fpu_vstl()

Zilin Guan <zilin@seu.edu.cn>
    crypto: iaa - Fix incorrect return value in save_iaa_wq()

FUKAUMI Naoki <naoki@radxa.com>
    arm64: dts: rockchip: Add eeprom vcc-supply for Radxa ROCK 3C

FUKAUMI Naoki <naoki@radxa.com>
    arm64: dts: rockchip: Add eeprom vcc-supply for Radxa ROCK 5A

FUKAUMI Naoki <naoki@radxa.com>
    arm64: dts: rockchip: Move the EEPROM to correct I2C bus on Radxa ROCK 5A

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: keystone: Exit ks_pcie_probe() for invalid mode

Leon Hwang <leon.hwang@linux.dev>
    bpf: Free special fields when update [lru_,]percpu_hash maps

Haotian Zhang <vulab@iscas.ac.cn>
    leds: netxbig: Fix GPIO descriptor leak in error paths

Haotian Zhang <vulab@iscas.ac.cn>
    scsi: sim710: Fix resource leak by adding missing ioport_unmap() calls

Haotian Zhang <vulab@iscas.ac.cn>
    ACPI: property: Fix fwnode refcount leak in acpi_fwnode_graph_parse_endpoint()

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: relax BUG() to ocfs2_error() in __ocfs2_move_extent()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    lib/vsprintf: Check pointer before dereferencing in time_and_date()

Haotian Zhang <vulab@iscas.ac.cn>
    clk: renesas: r9a06g032: Fix memory leak in error path

Leo Yan <leo.yan@arm.com>
    coresight: etm4x: Add context synchronization before enabling trace

Leo Yan <leo.yan@arm.com>
    coresight: etm4x: Extract the trace unit controlling

Leo Yan <leo.yan@arm.com>
    coresight: etm4x: Correct polling IDLE bit

Leo Yan <leo.yan@arm.com>
    coresight: Change device mode to atomic type

Zheng Qixing <zhengqixing@huawei.com>
    nbd: defer config unlock in nbd_genl_connect

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: cw1200: Fix potential memory leak in cw1200_bh_rx_helper()

Long Li <leo.lilong@huawei.com>
    macintosh/mac_hid: fix race condition in mac_hid_toggle_emumouse

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Fix unpaired stwcx. on interrupt exit

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/kdump: Fix size calculation for hot-removed memory ranges

Gautham R. Shenoy <gautham.shenoy@amd.com>
    cpufreq/amd-pstate: Call cppc_set_auto_sel() only for online CPUs

Bean Huo <beanhuo@micron.com>
    scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_string_desc()

Akash Goel <akash.goel@arm.com>
    drm/panthor: Fix potential memleak of vma structure

Edward Adam Davis <eadavis@qq.com>
    ntfs3: init run lock for extend inode

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: stm32: stm32mp157c-phycore: Fix STMPE811 touchscreen node properties

Ma Ke <make24@iscas.ac.cn>
    RDMA/rtrs: server: Fix error handling in get_or_create_srv

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    dt-bindings: PCI: amlogic: Fix the register name of the DBI region

Mike McGowen <mike.mcgowen@microchip.com>
    scsi: smartpqi: Fix device resources accessed after device removal

Haotian Zhang <vulab@iscas.ac.cn>
    scsi: stex: Fix reboot_notifier leak in probe error path

Zheng Qixing <zhengqixing@huawei.com>
    nbd: defer config put in recv_work

Yun Zhou <yun.zhou@windriver.com>
    md: fix rcu protection in md_wakeup_thread

Gabor Juhos <j4g8y7@gmail.com>
    regulator: core: disable supply if enabling main regulator fails

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Correct large PEBS flag check

Zhang Yi <yi.zhang@huawei.com>
    ext4: correct the checking of quota files before moving extents

Haotian Zhang <vulab@iscas.ac.cn>
    mfd: da9055: Fix missing regmap_del_irq_chip() in error path

Wang Liang <wangliang74@huawei.com>
    locktorture: Fix memory leak in param_set_cpumask()

Usama Arif <usamaarif642@gmail.com>
    efi/libstub: Fix page table access in 5-level to 4-level paging transition

Usama Arif <usamaarif642@gmail.com>
    x86/boot: Fix page table access in 5-level to 4-level paging transition

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: omap3: n900: Correct obsolete TWL4030 power compatible

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: omap3: beagle-xm: Correct obsolete TWL4030 power compatible

Yegor Yefremov <yegorslists@googlemail.com>
    ARM: dts: am335x-netcom-plus-2xx: add missing GPIO labels

Alan Maguire <alan.maguire@oracle.com>
    libbpf: Fix parsing of multi-split BTF

Vishwaroop A <va@nvidia.com>
    spi: tegra210-quad: Fix timeout handling

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Fix UAF on kernel BO VA nodes

Ketil Johnsen <ketil.johnsen@arm.com>
    drm/panthor: Fix race with suspend during unplug

Ketil Johnsen <ketil.johnsen@arm.com>
    drm/panthor: Fix UAF race between device unplug and FW event processing

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Fix group_free_queue() for partially initialized queues

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Handle errors returned by drm_sched_entity_init()

Tingmao Wang <m@maowtm.org>
    fs/9p: Don't open remote file with APPEND mode when writeback cache is used

Bart Van Assche <bvanassche@acm.org>
    scsi: target: Do not write NUL characters into ASCII configfs output

Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
    power: supply: apm_power: only unset own apm_get_power_status

Ivan Abramov <i.abramov@mt-integration.ru>
    power: supply: wm831x: Check wm831x_set_bits() return value

Murad Masimov <m.masimov@mt-integration.ru>
    power: supply: rt9467: Prevent using uninitialized local variable in rt9467_set_value_from_ranges()

Ivan Abramov <i.abramov@mt-integration.ru>
    power: supply: rt9467: Return error on failure in rt9467_set_value_from_ranges()

Ivan Abramov <i.abramov@mt-integration.ru>
    power: supply: max17040: Check iio_read_channel_processed() return code

Ivan Abramov <i.abramov@mt-integration.ru>
    power: supply: cw2015: Check devm_delayed_work_autocancel() return code

Haotian Zhang <vulab@iscas.ac.cn>
    power: supply: rt5033_charger: Fix device node reference leaks

Shuai Xue <xueshuai@linux.alibaba.com>
    perf record: skip synthesize event when open evsel failed

Namhyung Kim <namhyung@kernel.org>
    perf lock contention: Load kernel map before lookup

Geert Uytterhoeven <geert+renesas@glider.be>
    drm/imagination: Fix reference to devm_platform_get_and_ioremap_resource()

Kuan-Wei Chiu <visitorckw@gmail.com>
    interconnect: debugfs: Fix incorrect error handling for NULL path

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: msm8996: add interconnect paths to USB2 controller

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    interconnect: qcom: msm8996: add missing link to SLAVE_USB_HS

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: ath12k: fix potential memory leak in ath12k_wow_arp_ns_offload()

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Prevent incomplete IBI transaction

Frank Li <Frank.Li@nxp.com>
    i3c: fix refcount inconsistency in i3c_master_register

Haotian Zhang <vulab@iscas.ac.cn>
    pinctrl: stm32: fix hwspinlock resource leak in probe function

Haotian Zhang <vulab@iscas.ac.cn>
    soc: qcom: smem: fix hwspinlock resource leak in probe error paths

Benjamin Berg <benjamin.berg@intel.com>
    tools/nolibc/stdio: let perror work when NOLIBC_IGNORE_ERRNO is set

Tengda Wu <wutengda@huaweicloud.com>
    x86/dumpstack: Prevent KASAN false positive warnings in __show_regs()

Peter Zijlstra <peterz@infradead.org>
    task_work: Fix NMI race condition

Zhang Rui <rui.zhang@intel.com>
    perf/x86/intel/cstate: Remove PC3 support from LunarLake

Arnaud Lecomte <contact@arnaud-lcm.com>
    bpf: Fix stackmap overflow check in __bpf_get_stackid()

Arnaud Lecomte <contact@arnaud-lcm.com>
    bpf: Refactor stack map trace depth calculation into helper function

Josh Poimboeuf <jpoimboe@kernel.org>
    perf: Remove get_perf_callchain() init_nr argument

Haotian Zhang <vulab@iscas.ac.cn>
    mtd: rawnand: lpc32xx_slc: fix GPIO descriptor leak on probe error and remove

Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>
    mtd: nand: relax ECC parameter validation check

Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>
    Revert "mtd: rawnand: marvell: fix layouts"

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ARM: dts: renesas: r9a06g032-rzn1d400-db: Drop invalid #cells properties

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ARM: dts: renesas: gose: Remove superfluous port property

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix null deref on srq->rq.queue after resize failure

Kuniyuki Iwashima <kuniyu@google.com>
    sctp: Defer SCTP_DBG_OBJCNT_DEC() to sctp_destroy_sock().

Horatiu Vultur <horatiu.vultur@microchip.com>
    phy: mscc: Fix PTP for VSC8574 and VSC8572

Alexander Martinz <amartinz@shiftphones.com>
    arm64: dts: qcom: qcm6490-shift-otter: Add missing reserved-memory

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sm8650: set ufs as dma coherent

Gergo Koteles <soyer@irl.hu>
    arm64: dts: qcom: sdm845-oneplus: Correct gpio used for slider

Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
    arm64: dts: qcom: x1e80100: Add missing quirk for HS only USB controller

Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
    arm64: dts: qcom: x1e80100: Fix compile warnings for USB HS controller

Peng Fan <peng.fan@nxp.com>
    firmware: imx: scu-irq: fix OF node leak in

Randolph Sapp <rs@ti.com>
    arm64: dts: ti: k3-am62p: Fix memory ranges for GPU

Heiko Carstens <hca@linux.ibm.com>
    s390/ap: Don't leak debug feature files if AP instructions are not available

Heiko Carstens <hca@linux.ibm.com>
    s390/smp: Fix fallback CPU detection

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath11k: fix peer HE MCS assignment

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath11k: fix VHT MCS assignment

nieweiqiang <nieweiqiang@huawei.com>
    crypto: hisilicon/qm - restore original qos values

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: asymmetric_keys - prevent overflow in asymmetric_key_generate_id

Haotian Zhang <vulab@iscas.ac.cn>
    soc: qcom: gsbi: fix double disable caused by devm

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    soc: Switch back to struct platform_driver::remove()

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: camcc-sm7150: Fix PLL config of PLL2

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: camcc-sm6350: Fix PLL config of PLL2

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    clk: qcom: camcc-sm6350: Specify Titan GDSC power domain as a parent to other

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    clk: qcom: camcc-sm8550: Specify Titan GDSC power domain as a parent to other

Li Qiang <liqiang01@kylinos.cn>
    uio: uio_fsl_elbc_gpcm:: Add null pointer check to uio_fsl_elbc_gpcm_probe

Geert Uytterhoeven <geert+renesas@glider.be>
    PCI: rcar-gen2: Drop ARM dependency from PCI_RCAR_GEN2

Peter Griffin <peter.griffin@linaro.org>
    arm64: dts: exynos: gs101: fix sysreg_apm reg property

Tianyou Li <tianyou.li@intel.com>
    perf annotate: Check return value of evsel__get_arch() properly

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mp-venice-gw702x: remove off-board sdhc1

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mp-venice-gw702x: remove off-board uart

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mm-venice-gw72xx: remove unused sdhc1 pinctrl

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: freescale: imx8mp-venice-gw7905-2x: remove duplicate usdhc1 props

Bart Van Assche <bvanassche@acm.org>
    block/mq-deadline: Switch back to a single dispatch list

Bart Van Assche <bvanassche@acm.org>
    block/mq-deadline: Introduce dd_start_request()

Randy Dunlap <rdunlap@infradead.org>
    firmware: qcom: tzmem: fix qcom_tzmem_policy kernel-doc

Francesco Lavra <flavra@baylibre.com>
    iio: imu: st_lsm6dsx: Fix measurement unit for odr struct member

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    inet: Avoid ehash lookup race in inet_twsk_hashdance_schedule()

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    inet: Avoid ehash lookup race in inet_ehash_insert()

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    rculist: Add hlist_nulls_replace_rcu() and hlist_nulls_replace_init_rcu()

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: gcc-x1e80100: Add missing USB4 clocks/resets

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    dt-bindings: clock: qcom,x1e80100-gcc: Add missing USB4 clocks/resets

Stephan Gerhold <stephan.gerhold@linaro.org>
    dt-bindings: clock: qcom,x1e80100-gcc: Add missing video resets

Sidharth Seela <sidharthseela@gmail.com>
    ntfs3: Fix uninit buffer allocated by __getname()

Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
    ntfs3: fix uninit memory after failed mi_read in mi_format_new

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: authenc - Correctly pass EINPROGRESS back up to the caller

Johan Hovold <johan@kernel.org>
    irqchip/qcom-irq-combiner: Fix section mismatch

Johan Hovold <johan@kernel.org>
    irqchip/starfive-jh8100: Fix section mismatch

Johan Hovold <johan@kernel.org>
    irqchip/renesas-rzg2l: Fix section mismatch

Johan Hovold <johan@kernel.org>
    irqchip/imx-mu-msi: Fix section mismatch

Johan Hovold <johan@kernel.org>
    irqchip/irq-brcmstb-l2: Fix section mismatch

Johan Hovold <johan@kernel.org>
    irqchip/irq-bcm7120-l2: Fix section mismatch

Johan Hovold <johan@kernel.org>
    irqchip/irq-bcm7038-l1: Fix section mismatch

Fernand Sieber <sieberf@amazon.com>
    sched/fair: Forfeit vruntime on yield

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath11k: restore register window after global reset

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath10k: move recovery check logic into a new work

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath10k: Add missing include of export.h

Loic Poulain <loic.poulain@oss.qualcomm.com>
    wifi: ath10k: Avoid vdev delete timeout when firmware is already down

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Fix weak symbol detection

Dylan Hatch <dylanbhatch@google.com>
    objtool: Fix standalone --hacks=jump_label

Mavroudis Chatzilazaridis <mavchatz@protonmail.com>
    HID: logitech-hidpp: Do not assume FAP in hidpp_send_message_sync()

Cyrille Pitchen <cyrille.pitchen@microchip.com>
    drm: atmel-hlcdc: fix atmel_xlcdc_plane_setup_scaler()

Marek Vasut <marek.vasut+renesas@mailbox.org>
    clk: renesas: cpg-mssr: Read back reset registers to assure values latched

Thierry Bultel <thierry.bultel.yh@bp.renesas.com>
    clk: renesas: Pass sub struct of cpg_mssr_priv to cpg_clk_register

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: Use str_on_off() helper

Marek Vasut <marek.vasut+renesas@mailbox.org>
    clk: renesas: cpg-mssr: Add missing 1ms delay into reset toggle callback

Biju Das <biju.das.jz@bp.renesas.com>
    pinctrl: renesas: rzg2l: Fix PMC restore

Seungjin Bae <eeodqql09@gmail.com>
    USB: Fix descriptor count when handling invalid MBIM extended descriptor

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/vgem-fence: Fix potential deadlock on release

Karol Wachowski <karol.wachowski@linux.intel.com>
    accel/ivpu: Fix DCT active percent format

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Make function parameter names consistent

Guido Günther <agx@sigxcpu.org>
    drm/panel: visionox-rm69299: Don't clear all mode flags

Karol Wachowski <karol.wachowski@linux.intel.com>
    accel/ivpu: Ensure rpm_runtime_put in case of engine reset/resume fail

Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>
    accel/ivpu: Prevent runtime suspend during context abort work

Mainak Sen <msen@nvidia.com>
    gpu: host1x: Fix race in syncpt alloc/free

Konstantin Andreev <andreev@swemel.ru>
    smack: fix bug: setting task label silently ignores input garbage

Konstantin Andreev <andreev@swemel.ru>
    smack: fix bug: unprivileged task can create labels

Konstantin Andreev <andreev@swemel.ru>
    smack: fix bug: invalid label of unix socket file

Konstantin Andreev <andreev@swemel.ru>
    smack: always "instantiate" inode in smack_inode_init_security()

Konstantin Andreev <andreev@swemel.ru>
    smack: deduplicate xattr setting in smack_inode_init_security()

Konstantin Andreev <andreev@swemel.ru>
    smack: fix bug: SMACK64TRANSMUTE set on non-directory

Konstantin Andreev <andreev@swemel.ru>
    smack: deduplicate "does access rule request transmutation"


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-fs-f2fs            |  52 ++
 Documentation/admin-guide/LSM/Smack.rst            |  16 +-
 .../bindings/clock/qcom,x1e80100-gcc.yaml          |  62 +-
 .../devicetree/bindings/pci/amlogic,axg-pcie.yaml  |   6 +-
 Documentation/hwmon/g762.rst                       |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/renesas/r8a7793-gose.dts         |   1 -
 .../arm/boot/dts/renesas/r9a06g032-rzn1d400-db.dts |   2 -
 arch/arm/boot/dts/samsung/exynos4210-i9100.dts     |   1 +
 arch/arm/boot/dts/samsung/exynos4210-trats.dts     |   1 +
 .../boot/dts/samsung/exynos4210-universal_c210.dts |   1 +
 arch/arm/boot/dts/samsung/exynos4412-midas.dtsi    |   1 +
 .../dts/st/stm32mp157c-phycore-stm32mp15-som.dtsi  |   8 +-
 .../boot/dts/ti/omap/am335x-netcom-plus-2xx.dts    |   8 +-
 arch/arm/boot/dts/ti/omap/omap3-beagle-xm.dts      |   2 +-
 arch/arm/boot/dts/ti/omap/omap3-n900.dts           |   2 +-
 arch/arm/include/asm/word-at-a-time.h              |  10 +-
 arch/arm64/boot/dts/exynos/google/gs101.dtsi       |   4 +-
 .../boot/dts/freescale/imx8mm-venice-gw72xx.dtsi   |  11 -
 .../boot/dts/freescale/imx8mp-venice-gw702x.dtsi   |  51 --
 .../boot/dts/freescale/imx8mp-venice-gw72xx.dtsi   |  11 -
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   3 +
 arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts   |   5 +
 .../arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi |   4 +-
 arch/arm64/boot/dts/qcom/sm8650.dtsi               |   2 +
 arch/arm64/boot/dts/qcom/x1e80100.dtsi             |  12 +-
 arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts    |   1 +
 arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts   |  15 +-
 arch/arm64/boot/dts/ti/k3-am62p.dtsi               |   2 +-
 arch/loongarch/kernel/machine_kexec.c              |  22 +
 arch/powerpc/kernel/entry_32.S                     |  10 +-
 arch/powerpc/kexec/ranges.c                        |   2 +-
 arch/powerpc/mm/book3s64/hash_utils.c              |  10 +-
 arch/powerpc/mm/ptdump/hashpagetable.c             |   6 +
 arch/riscv/kvm/vcpu_insn.c                         |  22 +
 arch/s390/include/asm/fpu-insn.h                   |   3 +
 arch/s390/kernel/smp.c                             |   1 +
 arch/um/Makefile                                   |  12 +-
 arch/x86/boot/compressed/pgtable_64.c              |  11 +-
 arch/x86/events/intel/core.c                       |   4 +-
 arch/x86/events/intel/cstate.c                     |   3 +-
 arch/x86/kernel/dumpstack.c                        |  23 +-
 block/blk-lib.c                                    |   6 +-
 block/blk-mq.c                                     |  35 +-
 block/blk-throttle.c                               |   9 +-
 block/mq-deadline.c                                | 129 ++--
 crypto/asymmetric_keys/asymmetric_type.c           |  12 +-
 crypto/authenc.c                                   |  75 ++-
 drivers/accel/ivpu/ivpu_fw.h                       |   2 +-
 drivers/accel/ivpu/ivpu_hw_btrs.c                  |   2 +-
 drivers/accel/ivpu/ivpu_hw_btrs.h                  |   2 +-
 drivers/accel/ivpu/ivpu_job.c                      |  14 +-
 drivers/accel/ivpu/ivpu_pm.c                       |   9 +-
 drivers/acpi/apei/ghes.c                           |  27 +-
 drivers/acpi/processor_core.c                      |   2 +-
 drivers/acpi/property.c                            |   1 +
 drivers/base/firmware_loader/Kconfig               |   2 +-
 drivers/block/nbd.c                                |   5 +-
 drivers/block/ps3disk.c                            |   4 +
 drivers/block/ublk_drv.c                           |   4 +-
 drivers/clk/Makefile                               |   3 +-
 drivers/clk/qcom/camcc-sm6350.c                    |  13 +-
 drivers/clk/qcom/camcc-sm7150.c                    |   6 +-
 drivers/clk/qcom/camcc-sm8550.c                    |  10 +
 drivers/clk/qcom/gcc-x1e80100.c                    | 698 ++++++++++++++++++++-
 drivers/clk/renesas/r7s9210-cpg-mssr.c             |   7 +-
 drivers/clk/renesas/r8a77970-cpg-mssr.c            |   8 +-
 drivers/clk/renesas/r9a06g032-clocks.c             |   6 +-
 drivers/clk/renesas/rcar-gen2-cpg.c                |   5 +-
 drivers/clk/renesas/rcar-gen2-cpg.h                |   3 +-
 drivers/clk/renesas/rcar-gen3-cpg.c                |   6 +-
 drivers/clk/renesas/rcar-gen3-cpg.h                |   3 +-
 drivers/clk/renesas/rcar-gen4-cpg.c                |   6 +-
 drivers/clk/renesas/rcar-gen4-cpg.h                |   3 +-
 drivers/clk/renesas/renesas-cpg-mssr.c             | 150 ++---
 drivers/clk/renesas/renesas-cpg-mssr.h             |  20 +-
 drivers/clk/renesas/rzg2l-cpg.c                    |   3 +-
 drivers/cpufreq/amd-pstate.c                       |   2 +-
 drivers/crypto/ccree/cc_buffer_mgr.c               |   6 +-
 drivers/crypto/hisilicon/qm.c                      |  14 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |   2 +-
 drivers/crypto/starfive/jh7110-hash.c              |   6 +-
 drivers/firmware/efi/cper-arm.c                    |  52 +-
 drivers/firmware/efi/cper.c                        |  60 ++
 drivers/firmware/efi/libstub/x86-5lvl.c            |   4 +-
 drivers/firmware/imx/imx-scu-irq.c                 |   4 +-
 drivers/firmware/stratix10-svc.c                   |   1 +
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |  46 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |   8 +-
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c    |  27 +-
 drivers/gpu/drm/drm_plane.c                        |   8 +-
 drivers/gpu/drm/imagination/pvr_device.c           |   2 +-
 drivers/gpu/drm/mediatek/mtk_disp_ccorr.c          |  23 +-
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c              |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  34 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  10 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.h         |   6 -
 drivers/gpu/drm/nouveau/nouveau_fence.c            |   6 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c      |   2 +-
 drivers/gpu/drm/panel/panel-visionox-rm69299.c     |   2 +-
 drivers/gpu/drm/panthor/panthor_device.c           |   4 +-
 drivers/gpu/drm/panthor/panthor_gem.c              |  20 +-
 drivers/gpu/drm/panthor/panthor_mmu.c              |  18 +-
 drivers/gpu/drm/panthor/panthor_sched.c            |   6 +-
 drivers/gpu/drm/vgem/vgem_fence.c                  |   2 +-
 drivers/gpu/host1x/syncpt.c                        |   4 +-
 drivers/greybus/gb-beagleplay.c                    |  12 +-
 drivers/hid/hid-logitech-hidpp.c                   |   9 +-
 drivers/hwmon/sy7636a-hwmon.c                      |   7 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 130 ++--
 drivers/i3c/master.c                               |   8 +-
 drivers/i3c/master/svc-i3c-master.c                |  22 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h            |   2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   8 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |   8 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.h           |   2 +-
 drivers/infiniband/hw/irdma/cm.c                   |   2 +-
 drivers/infiniband/hw/irdma/ctrl.c                 |   3 +
 drivers/infiniband/hw/irdma/main.h                 |   2 +-
 drivers/infiniband/hw/irdma/pble.c                 |   6 +-
 drivers/infiniband/hw/irdma/verbs.c                |  15 +-
 drivers/infiniband/hw/irdma/verbs.h                |   3 +-
 drivers/infiniband/sw/rxe/rxe_srq.c                |   7 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   2 +-
 drivers/interconnect/debugfs-client.c              |   7 +-
 drivers/interconnect/qcom/msm8996.c                |   1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   2 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |  27 +-
 drivers/iommu/intel/iommu.h                        |   2 +-
 drivers/irqchip/irq-bcm7038-l1.c                   |   8 +-
 drivers/irqchip/irq-bcm7120-l2.c                   |  17 +-
 drivers/irqchip/irq-brcmstb-l2.c                   |  12 +-
 drivers/irqchip/irq-imx-mu-msi.c                   |  14 +-
 drivers/irqchip/irq-mchp-eic.c                     |   2 +-
 drivers/irqchip/irq-renesas-rzg2l.c                |   6 +-
 drivers/irqchip/irq-starfive-jh8100-intc.c         |   3 +-
 drivers/irqchip/qcom-irq-combiner.c                |   2 +-
 drivers/leds/leds-netxbig.c                        |  36 +-
 drivers/leds/rgb/leds-qcom-lpg.c                   |   4 +-
 drivers/macintosh/mac_hid.c                        |   3 +-
 drivers/md/dm-log-writes.c                         |   1 +
 drivers/md/dm-raid.c                               |   2 +
 drivers/md/md.c                                    |  14 +-
 drivers/md/md.h                                    |   8 +-
 drivers/md/raid5.c                                 |   6 +-
 drivers/mfd/da9055-core.c                          |   1 +
 drivers/mfd/mt6358-irq.c                           |   1 +
 drivers/mfd/mt6397-irq.c                           |   1 +
 drivers/mtd/lpddr/lpddr_cmds.c                     |   8 +-
 drivers/mtd/nand/raw/lpc32xx_slc.c                 |   2 +
 drivers/mtd/nand/raw/marvell_nand.c                |  13 +-
 drivers/mtd/nand/raw/nand_base.c                   |  13 +-
 drivers/mtd/nand/raw/renesas-nand-controller.c     |   5 +-
 drivers/net/dsa/xrs700x/xrs700x.c                  |  11 +
 drivers/net/ethernet/microchip/lan743x_main.c      |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
 drivers/net/phy/adin1100.c                         |   2 +-
 drivers/net/phy/aquantia/aquantia_firmware.c       |   2 +-
 drivers/net/phy/mscc/mscc_main.c                   |   6 +-
 drivers/net/wireless/ath/ath10k/bmi.c              |   2 +
 drivers/net/wireless/ath/ath10k/ce.c               |   2 +
 drivers/net/wireless/ath/ath10k/core.c             |  22 +-
 drivers/net/wireless/ath/ath10k/core.h             |   2 +-
 drivers/net/wireless/ath/ath10k/coredump.c         |   2 +
 drivers/net/wireless/ath/ath10k/debug.c            |   2 +
 drivers/net/wireless/ath/ath10k/htc.c              |   3 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   3 +
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   2 +
 drivers/net/wireless/ath/ath10k/mac.c              |  36 +-
 drivers/net/wireless/ath/ath10k/trace.c            |   2 +
 drivers/net/wireless/ath/ath11k/mac.c              |   8 +-
 drivers/net/wireless/ath/ath11k/pci.c              |  20 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  20 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |   2 +
 drivers/net/wireless/ath/ath12k/wow.c              |   1 +
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   4 +-
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |   9 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |  27 +-
 drivers/net/wireless/st/cw1200/bh.c                |   6 +-
 drivers/nvme/host/auth.c                           |   2 +-
 drivers/of/of_kunit_helpers.c                      |   5 +-
 drivers/pci/controller/Kconfig                     |   7 +-
 drivers/pci/controller/dwc/pci-keystone.c          |   2 +
 drivers/pci/controller/dwc/pcie-designware.h       |   2 +-
 drivers/phy/freescale/phy-fsl-imx8qm-hsio.c        |   5 +-
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |  20 +-
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c  |  13 +-
 drivers/pinctrl/pinctrl-single.c                   |   7 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   6 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   2 +-
 drivers/platform/x86/asus-wmi.c                    |   8 +-
 drivers/platform/x86/intel/pmc/core.h              |   2 +-
 drivers/power/supply/apm_power.c                   |   3 +-
 drivers/power/supply/cw2015_battery.c              |   8 +-
 drivers/power/supply/max17040_battery.c            |   6 +-
 drivers/power/supply/rt5033_charger.c              |   2 +
 drivers/power/supply/rt9467-charger.c              |   6 +-
 drivers/power/supply/wm831x_power.c                |  10 +-
 drivers/pwm/pwm-bcm2835.c                          |  28 +-
 drivers/ras/ras.c                                  |  40 +-
 drivers/regulator/core.c                           |  37 +-
 drivers/regulator/fixed.c                          |  11 +-
 drivers/remoteproc/qcom_q6v5_wcss.c                |   8 +-
 drivers/rtc/rtc-gamecube.c                         |   4 +
 drivers/s390/crypto/ap_bus.c                       |   8 +-
 drivers/scsi/imm.c                                 |   1 +
 drivers/scsi/qla2xxx/qla_nvme.c                    |   2 +-
 drivers/scsi/sim710.c                              |   2 +
 drivers/scsi/smartpqi/smartpqi_init.c              |  19 +
 drivers/scsi/stex.c                                |   1 +
 drivers/soc/aspeed/aspeed-lpc-ctrl.c               |   2 +-
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |   2 +-
 drivers/soc/aspeed/aspeed-p2a-ctrl.c               |   2 +-
 drivers/soc/aspeed/aspeed-uart-routing.c           |   2 +-
 drivers/soc/fsl/dpaa2-console.c                    |   2 +-
 drivers/soc/fsl/qe/qmc.c                           |   2 +-
 drivers/soc/fsl/qe/tsa.c                           |   2 +-
 drivers/soc/fujitsu/a64fx-diag.c                   |   2 +-
 drivers/soc/hisilicon/kunpeng_hccs.c               |   2 +-
 drivers/soc/ixp4xx/ixp4xx-npe.c                    |   2 +-
 drivers/soc/ixp4xx/ixp4xx-qmgr.c                   |   2 +-
 drivers/soc/litex/litex_soc_ctrl.c                 |   2 +-
 drivers/soc/loongson/loongson2_guts.c              |   2 +-
 drivers/soc/mediatek/mtk-devapc.c                  |   2 +-
 drivers/soc/mediatek/mtk-mmsys.c                   |   2 +-
 drivers/soc/mediatek/mtk-socinfo.c                 |   2 +-
 drivers/soc/microchip/mpfs-sys-controller.c        |   2 +-
 drivers/soc/pxa/ssp.c                              |   2 +-
 drivers/soc/qcom/icc-bwmon.c                       |   2 +-
 drivers/soc/qcom/llcc-qcom.c                       |   2 +-
 drivers/soc/qcom/ocmem.c                           |   2 +-
 drivers/soc/qcom/pmic_glink.c                      |   2 +-
 drivers/soc/qcom/qcom_aoss.c                       |   2 +-
 drivers/soc/qcom/qcom_gsbi.c                       |   8 -
 drivers/soc/qcom/qcom_stats.c                      |   2 +-
 drivers/soc/qcom/ramp_controller.c                 |   4 +-
 drivers/soc/qcom/rmtfs_mem.c                       |   2 +-
 drivers/soc/qcom/rpm-proc.c                        |   2 +-
 drivers/soc/qcom/rpm_master_stats.c                |   2 +-
 drivers/soc/qcom/smem.c                            |   5 +-
 drivers/soc/qcom/smp2p.c                           |   2 +-
 drivers/soc/qcom/smsm.c                            |   6 +-
 drivers/soc/qcom/socinfo.c                         |   2 +-
 drivers/soc/rockchip/io-domain.c                   |   8 +-
 drivers/soc/samsung/exynos-chipid.c                |   4 +-
 drivers/soc/tegra/cbb/tegra194-cbb.c               |   2 +-
 drivers/soc/ti/k3-ringacc.c                        |   2 +-
 drivers/soc/ti/knav_dma.c                          |   4 +-
 drivers/soc/ti/knav_qmss_queue.c                   |   2 +-
 drivers/soc/ti/pm33xx.c                            |   2 +-
 drivers/soc/ti/pruss.c                             |   4 +-
 drivers/soc/ti/smartreflex.c                       |   2 +-
 drivers/soc/ti/wkup_m3_ipc.c                       |   2 +-
 drivers/soc/xilinx/xlnx_event_manager.c            |   2 +-
 drivers/soc/xilinx/zynqmp_power.c                  |   2 +-
 drivers/spi/spi-airoha-snfi.c                      |  25 +-
 drivers/spi/spi-ch341.c                            |   2 +-
 drivers/spi/spi-tegra210-quad.c                    |  22 +-
 drivers/staging/fbtft/fbtft-core.c                 |   4 +-
 drivers/target/target_core_configfs.c              |   1 -
 drivers/ufs/core/ufshcd.c                          |   2 +-
 drivers/uio/uio_fsl_elbc_gpcm.c                    |   7 +
 drivers/usb/core/message.c                         |   2 +-
 drivers/usb/dwc2/platform.c                        |  16 +-
 drivers/usb/dwc3/host.c                            |   5 +-
 drivers/usb/gadget/legacy/raw_gadget.c             |   3 +
 drivers/usb/gadget/udc/tegra-xudc.c                |   6 -
 drivers/usb/misc/chaoskey.c                        |  16 +-
 drivers/usb/phy/phy.c                              |   4 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   2 +-
 drivers/vdpa/pds/vdpa_dev.c                        |   2 +-
 drivers/vfio/pci/vfio_pci_core.c                   |  68 +-
 drivers/vfio/pci/vfio_pci_intrs.c                  |  52 +-
 drivers/vfio/pci/vfio_pci_priv.h                   |   4 +
 drivers/vhost/vhost.c                              |   4 +-
 drivers/video/backlight/led_bl.c                   |  13 +
 drivers/video/fbdev/ssd1307fb.c                    |   4 +-
 drivers/virtio/virtio_vdpa.c                       |   2 +-
 drivers/watchdog/starfive-wdt.c                    |   4 +-
 drivers/watchdog/wdat_wdt.c                        |  64 +-
 fs/9p/v9fs.c                                       |   4 +-
 fs/9p/vfs_file.c                                   |  11 +-
 fs/9p/vfs_inode.c                                  |   3 +-
 fs/9p/vfs_inode_dotl.c                             |   2 +-
 fs/btrfs/ctree.c                                   |   2 +-
 fs/dcache.c                                        |  46 --
 fs/erofs/super.c                                   |  16 +
 fs/ext4/mballoc.c                                  |  49 +-
 fs/ext4/move_extent.c                              |   2 +-
 fs/f2fs/debug.c                                    |   3 +
 fs/f2fs/f2fs.h                                     |  20 +-
 fs/f2fs/file.c                                     |  77 ++-
 fs/f2fs/gc.c                                       |  21 +-
 fs/f2fs/gc.h                                       |   2 +
 fs/f2fs/inode.c                                    |  14 +
 fs/f2fs/shrinker.c                                 |  90 +++
 fs/f2fs/super.c                                    |   8 +-
 fs/f2fs/sysfs.c                                    | 101 +++
 fs/gfs2/glock.c                                    |   5 +-
 fs/gfs2/inode.c                                    |  15 +
 fs/gfs2/inode.h                                    |   1 +
 fs/gfs2/ops_fstype.c                               |   2 +-
 fs/iomap/direct-io.c                               |  79 ++-
 fs/kernfs/dir.c                                    |   5 +-
 fs/nfs/client.c                                    |  21 +-
 fs/nfs/dir.c                                       |  27 +-
 fs/nfs/inode.c                                     |   2 +-
 fs/nfs/internal.h                                  |   3 +-
 fs/nfs/namespace.c                                 |  11 +-
 fs/nfs/nfs4client.c                                |  18 +-
 fs/nfs/nfs4proc.c                                  |  29 +-
 fs/nfs/pnfs.c                                      |   1 +
 fs/nfs/super.c                                     |  33 +-
 fs/nfsd/blocklayout.c                              |   4 +-
 fs/nls/nls_base.c                                  |  27 +-
 fs/ntfs3/frecord.c                                 |   8 +-
 fs/ntfs3/fsntfs.c                                  |   9 +-
 fs/ntfs3/inode.c                                   |   2 +
 fs/ocfs2/alloc.c                                   |   1 -
 fs/ocfs2/move_extents.c                            |   8 +-
 fs/smb/client/smb2pdu.c                            |   2 +-
 fs/tracefs/event_inode.c                           |   3 +-
 include/dt-bindings/clock/qcom,x1e80100-gcc.h      |  63 ++
 include/linux/blk_types.h                          |   5 +-
 include/linux/blkdev.h                             |   2 +-
 include/linux/coresight.h                          |  25 +-
 include/linux/cper.h                               |  12 +-
 include/linux/dcache.h                             |   1 -
 include/linux/filter.h                             |  12 +-
 include/linux/firmware/qcom/qcom_tzmem.h           |  15 +-
 include/linux/ieee80211.h                          |   4 +-
 include/linux/if_hsr.h                             |  26 +
 include/linux/nfs_fs_sb.h                          |   7 +-
 include/linux/nfs_xdr.h                            |  54 +-
 include/linux/perf_event.h                         |   2 +-
 include/linux/platform_data/lp855x.h               |   4 +-
 include/linux/ras.h                                |  16 +-
 include/linux/rculist_nulls.h                      |  59 ++
 include/linux/vfio_pci_core.h                      |  10 +-
 include/linux/virtio_config.h                      |   8 +-
 include/net/dst.h                                  |  16 +-
 include/net/netfilter/nf_conntrack_count.h         |  15 +-
 include/net/sock.h                                 |  13 +
 include/ras/ras_event.h                            |  49 +-
 include/uapi/sound/asound.h                        |   2 +-
 kernel/bpf/hashtab.c                               |  10 +-
 kernel/bpf/stackmap.c                              |  66 +-
 kernel/bpf/syscall.c                               |   3 +
 kernel/bpf/trampoline.c                            |   4 +-
 kernel/cgroup/cpuset.c                             |  35 +-
 kernel/dma/pool.c                                  |   2 +-
 kernel/events/callchain.c                          |  12 +-
 kernel/events/core.c                               |   2 +-
 kernel/locking/locktorture.c                       |   8 +-
 kernel/resource.c                                  |  46 +-
 kernel/sched/fair.c                                |  17 +-
 kernel/task_work.c                                 |   8 +-
 lib/vsprintf.c                                     |   6 +-
 net/core/dst.c                                     |   2 +-
 net/core/filter.c                                  |   9 +-
 net/hsr/hsr_device.c                               |  33 +
 net/hsr/hsr_main.h                                 |  10 +-
 net/hsr/hsr_slave.c                                |  12 +-
 net/ipv4/inet_hashtables.c                         |   8 +-
 net/ipv4/inet_timewait_sock.c                      |  35 +-
 net/ipv4/route.c                                   |   4 +-
 net/ipv4/tcp_metrics.c                             |   6 +-
 net/ipv6/ip6_fib.c                                 |   4 +
 net/mac80211/aes_cmac.c                            |  63 +-
 net/mac80211/aes_cmac.h                            |   8 +-
 net/mac80211/wpa.c                                 |  20 +-
 net/netfilter/nf_conncount.c                       | 195 ++++--
 net/netfilter/nft_connlimit.c                      |  34 +-
 net/netfilter/nft_flow_offload.c                   |   9 +-
 net/netfilter/xt_connlimit.c                       |  14 +-
 net/openvswitch/conntrack.c                        |  16 +-
 net/sched/sch_cake.c                               |  60 +-
 net/sctp/socket.c                                  |   5 +-
 security/integrity/ima/ima_policy.c                |   2 +-
 security/smack/smack.h                             |   3 +
 security/smack/smack_access.c                      |  93 ++-
 security/smack/smack_lsm.c                         | 277 +++++---
 sound/firewire/dice/dice-extension.c               |   4 +-
 sound/firewire/motu/motu-hwdep.c                   |   7 +-
 sound/isa/wavefront/wavefront_synth.c              |   4 +-
 sound/soc/bcm/bcm63xx-pcm-whistler.c               |   4 +-
 sound/soc/codecs/Kconfig                           |   5 +
 sound/soc/codecs/Makefile                          |   2 +
 sound/soc/codecs/ak4458.c                          |  10 +-
 sound/soc/codecs/ak5558.c                          |  10 +-
 sound/soc/codecs/nau8325.c                         |   3 +-
 sound/soc/codecs/tas2781-i2c.c                     |   2 +-
 sound/soc/fsl/fsl_xcvr.c                           |   2 +-
 sound/soc/intel/catpt/pcm.c                        |   4 +-
 tools/include/nolibc/stdio.h                       |   4 +
 tools/lib/bpf/btf.c                                |   4 +-
 tools/objtool/check.c                              |   3 +-
 tools/objtool/elf.c                                |   8 +-
 tools/perf/builtin-record.c                        |   2 +-
 tools/perf/util/annotate.c                         |   2 +-
 .../util/arm-spe-decoder/arm-spe-pkt-decoder.c     |  37 +-
 .../util/arm-spe-decoder/arm-spe-pkt-decoder.h     |  26 +-
 tools/perf/util/bpf_lock_contention.c              |   6 +-
 tools/perf/util/hist.c                             |   6 +-
 tools/perf/util/symbol.c                           |   5 +-
 .../selftests/bpf/prog_tests/perf_branches.c       |  22 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |   5 +
 .../selftests/bpf/progs/test_perf_branches.c       |   3 +
 .../testing/selftests/drivers/net/bonding/Makefile |   2 +-
 .../selftests/drivers/net/bonding/bond_macvlan.sh  |  99 ---
 .../drivers/net/bonding/bond_macvlan_ipvlan.sh     |  97 +++
 tools/testing/selftests/drivers/net/bonding/config |   1 +
 412 files changed, 4306 insertions(+), 1929 deletions(-)


