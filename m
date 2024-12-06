Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934D645BE3;
	Fri,  6 Dec 2024 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496458; cv=none; b=GCqlNfjBX0T2C8QpxIwjUI91QxRBplTVL3CelEKqM5Kx3/g5/VUSn9gGSH6EFalD8ZyhXk4sSTgYtSX0b7obrWebnTrdSGdbD7lubAuwjXUjgC5fYpcCRcLkYO4Js5FWkUYORSTqEp67oaIQFFsJyNI+144VWnC2hytX5WNu97k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496458; c=relaxed/simple;
	bh=BH5XUN//h9Pib6rOJw/AFg2bOIe4/3huK7KE3E9XSiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LJqDAfsjw1Wo+kx//1EmdGVAl+0vJAwQAx63LDiGDVK5OOizOK05TbZvTOYwjgeN6caGiLUFCsa/rG4po7qJOjMsEWPSQo4UUDg9KqRrs+oBm2JcwzVR7k/uf5ZIeSqBQoZnpc1Bsb39jIe3tMfNwrefe0vOYcGX/W3ww+OFhxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsyALMHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsyALMHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766A2C4CED1;
	Fri,  6 Dec 2024 14:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496458;
	bh=BH5XUN//h9Pib6rOJw/AFg2bOIe4/3huK7KE3E9XSiQ=;
	h=From:To:Cc:Subject:Date:From;
	b=UsyALMHovjcNw+bmYC+Uw5EPEBskIdtEee8hhcBDYkd72CRxl8d7Qbn1+sgwN2CXU
	 1nstv6OVU7eHwLpL3bgaABWx9pZS32boPMmO3CCpizP59IOZN+ACUvARFW3zCZU7ox
	 QfAMxZCPLPHeV6N6f9PylTsL+KweGesE+5+D0BwE=
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
Subject: [PATCH 6.6 000/676] 6.6.64-rc1 review
Date: Fri,  6 Dec 2024 15:26:59 +0100
Message-ID: <20241206143653.344873888@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.64-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.64-rc1
X-KernelTest-Deadline: 2024-12-08T14:37+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.64 release.
There are 676 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 08 Dec 2024 14:34:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.64-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.64-rc1

Frederic Weisbecker <frederic@kernel.org>
    posix-timers: Target group sigqueue to current task only if not exiting

Umio Yasuno <coelacanth_dream@protonmail.com>
    drm/amd/pm: update current_socclk and current_uclk in gpu_metrics on smu v13.0.7

Vitaly Prosyak <vitaly.prosyak@amd.com>
    drm/amdgpu: fix usage slab after free

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdkfd: Use the correct wptr size

Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
    drm: xlnx: zynqmp_dpsub: fix hotplug detection

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: flush shader L1 cache after user commandstream

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    drm/mediatek: Fix child node refcount handling in early exit

Ma Ke <make24@iscas.ac.cn>
    drm/sti: avoid potential dereference of error pointers

Ma Ke <make24@iscas.ac.cn>
    drm/sti: avoid potential dereference of error pointers in sti_gdp_atomic_check

Ma Ke <make24@iscas.ac.cn>
    drm/sti: avoid potential dereference of error pointers in sti_hqvdp_atomic_check

Vivek Kasireddy <vivek.kasireddy@intel.com>
    udmabuf: use vmf_insert_pfn and VM_PFNMAP for handling mmap

Jarkko Sakkinen <jarkko@kernel.org>
    tpm: Lock TPM chip in tpm_pm_suspend() first

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't BUG_ON on ENOMEM from btrfs_lookup_extent_info() in walk_down_proc()

Nathan Chancellor <nathan@kernel.org>
    powerpc: Adjust adding stack protector flags to KBUILD_CLAGS for clang

Nathan Chancellor <nathan@kernel.org>
    powerpc: Fix stack protector Kconfig test for clang

Zicheng Qu <quzicheng@huawei.com>
    iio: gts: fix infinite loop for gain_to_scaletables()

Nuno Sa <nuno.sa@analog.com>
    iio: adc: ad7923: Fix buffer overflow for tx_buf and ring_xfer

Zicheng Qu <quzicheng@huawei.com>
    iio: Fix fwnode_handle in __fwnode_iio_channel_get_by_name()

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: accel: kx022a: Fix raw read format

Yang Erkun <yangerkun@huawei.com>
    nfsd: fix nfs4_openowner leak when concurrent nfsd4_open occur

Yang Erkun <yangerkun@huawei.com>
    nfsd: make sure exp active before svc_export_show

Damien Le Moal <dlemoal@kernel.org>
    PCI: rockchip-ep: Fix address translation unit programming

Andrea della Porta <andrea.porta@suse.com>
    PCI: of_property: Assign PCI instead of CPU bus address to dynamic PCI nodes

Yuan Can <yuancan@huawei.com>
    dm thin: Add missing destroy_work_on_stack()

Ssuhung Yeh <ssuhung@gmail.com>
    dm: Fix typo in error message

Oleksandr Tymoshenko <ovt@google.com>
    ovl: properly handle large files in ovl_security_fileattr

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    leds: flash: mt6360: Fix device_for_each_child_node() refcounting in error paths

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: int3400: Fix reading of current_uuid for active policy

Jiri Olsa <jolsa@kernel.org>
    fs/proc/kcore.c: Clear ret value in read_kcore_iter after successful iov_iter_zero

Zijun Hu <quic_zijuhu@quicinc.com>
    PCI: endpoint: Clear secondary (not primary) EPC in pci_epc_remove_epf()

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: keystone: Add link up check to ks_pcie_other_map_bus()

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: keystone: Set mode as Root Complex for "ti,keystone-pcie" compatible

Frank Li <Frank.Li@nxp.com>
    i3c: master: Fix miss free init_dyn_addr at i3c_master_put_i3c_addrs()

Jinjie Ruan <ruanjinjie@huawei.com>
    i3c: master: svc: Fix pm_runtime_set_suspended() with runtime pm enabled

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: Fix hibern8 notify callbacks

Alexandru Ardelean <aardelean@baylibre.com>
    util_macros.h: fix/rework find_closest() macros

Patrick Donnelly <pdonnell@redhat.com>
    ceph: extract entity name from device id

yuan.gao <yuan.gao@ucloud.cn>
    mm/slub: Avoid list corruption when removing a slab from the full list

Linus Walleij <linus.walleij@linaro.org>
    ARM: 9431/1: mm: Pair atomic_set_release() with _read_acquire()

Linus Walleij <linus.walleij@linaro.org>
    ARM: 9430/1: entry: Do a dummy read from VMAP shadow

Vasily Gorbik <gor@linux.ibm.com>
    s390/entry: Mark IRQ entries to fix stack depot warnings

Linus Walleij <linus.walleij@linaro.org>
    ARM: 9429/1: ioremap: Sync PGDs for VMALLOC shadow

Zicheng Qu <quzicheng@huawei.com>
    ad7780: fix division by zero in ad7780_write_raw()

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: gcc-qcs404: fix initial rate of GPLL3

Michal Vokáč <michal.vokac@ysoft.com>
    leds: lp55xx: Remove redundant test for invalid channel number

Mostafa Saleh <smostafa@google.com>
    iommu/io-pgtable-arm: Fix stage-2 map/unmap for concatenated tables

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: clear IDLE flag after recompression

MengEn Sun <mengensun@tencent.com>
    vmstat: call fold_vm_zone_numa_events() before show per zone NUMA event

guoweikang <guoweikang.kernel@gmail.com>
    ftrace: Fix regression with module command in stack_trace_filter

Wei Yang <richard.weiyang@gmail.com>
    maple_tree: refine mas_store_root() on storing NULL

Vasiliy Kovalev <kovalev@altlinux.org>
    ovl: Filter invalid inodes with missing lookup function

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    media: uvcvideo: Require entities to have a non-zero unique ID

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Stop stream during unregister

Gaosheng Cui <cuigaosheng1@huawei.com>
    media: platform: allegro-dvt: Fix possible memory leak in allocate_buffers_internal()

Jinjie Ruan <ruanjinjie@huawei.com>
    media: gspca: ov534-ov772x: Fix off-by-one error in set_frame_rate()

Jinjie Ruan <ruanjinjie@huawei.com>
    media: venus: Fix pm_runtime_set_suspended() with runtime pm enabled

Jinjie Ruan <ruanjinjie@huawei.com>
    media: amphion: Fix pm_runtime_set_suspended() with runtime pm enabled

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub: Free correct pointer on failure

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    media: platform: exynos4-is: Fix an OF node reference leak in fimc_md_is_isp_available

Li Zetao <lizetao1@huawei.com>
    media: ts2020: fix null-ptr-deref in ts2020_probe()

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    media: verisilicon: av1: Fix reference video buffer pointer assignment

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Ensure power suppliers be suspended before detach them

Alexander Shiyan <eagle.alexander923@gmail.com>
    media: i2c: tc358743: Fix crash in the probe error path when using polling

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: freescale: imx8mp-verdin: Fix SD regulator startup delay

Jinjie Ruan <ruanjinjie@huawei.com>
    media: i2c: dw9768: Fix pm_runtime_set_suspended() with runtime pm enabled

Guoqing Jiang <guoqing.jiang@canonical.com>
    media: mtk-jpeg: Fix null-ptr-deref during unload module

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Set video drvdata before register video device

Ming Qian <ming.qian@nxp.com>
    media: amphion: Set video drvdata before register video device

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: ti: k3-am62-verdin: Fix SD regulator startup delay

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: freescale: imx8mm-verdin: Fix SD regulator startup delay

Dragan Simic <dsimic@manjaro.org>
    arm64: dts: allwinner: pinephone: Add mount matrix to accelerometer

Yuan Can <yuancan@huawei.com>
    md/md-bitmap: Add missing destroy_work_on_stack()

Filipe Manana <fdmanana@suse.com>
    btrfs: ref-verify: fix use-after-free after invalid ref action

Lizhi Xu <lizhi.xu@windriver.com>
    btrfs: add a sanity check for btrfs root in btrfs_search_slot()

Filipe Manana <fdmanana@suse.com>
    btrfs: don't loop for nowait writes when checking for cross references

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    quota: flush quota_release_work upon quota writeback

Long Li <leo.lilong@huawei.com>
    xfs: remove unknown compat feature check in superblock write validation

Dan Carpenter <dan.carpenter@linaro.org>
    sh: intc: Fix use-after-free bug in register_intc_controller()

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix bfqq uaf in bfq_limit_depth()

Liu Jian <liujian56@huawei.com>
    sunrpc: fix one UAF issue caused by sunrpc kernel tcp socket

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: timeout and cancel TLS handshake with -ETIMEDOUT

Liu Jian <liujian56@huawei.com>
    sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport

Li Lingfeng <lilingfeng3@huawei.com>
    nfs: ignore SB_RDONLY when mounting nfs

Dan Carpenter <dan.carpenter@linaro.org>
    cifs: unlock on error in smb3_reconfigure()

Shyam Prasad N <sprasad@microsoft.com>
    cifs: during remount, make sure passwords are in sync

Masahiro Yamada <masahiroy@kernel.org>
    modpost: remove incorrect code in do_eisa_entry()

Paul Aurich <paul@darkrain42.org>
    smb: Initialize cfid->tcon before performing network ops

Masahiro Yamada <masahiroy@kernel.org>
    Rename .data.once to .data..once to fix resetting WARN*_ONCE

Masahiro Yamada <masahiroy@kernel.org>
    Rename .data.unlikely to .data..unlikely

Masahiro Yamada <masahiroy@kernel.org>
    init/modpost: conditionally check section mismatch to __meminit*

Masahiro Yamada <masahiroy@kernel.org>
    modpost: squash ALL_{INIT,EXIT}_TEXT_SECTIONS to ALL_TEXT_SECTIONS

Masahiro Yamada <masahiroy@kernel.org>
    modpost: use ALL_INIT_SECTIONS for the section check from DATA_SECTIONS

Masahiro Yamada <masahiroy@kernel.org>
    modpost: disallow the combination of EXPORT_SYMBOL and __meminit*

Masahiro Yamada <masahiroy@kernel.org>
    modpost: remove EXIT_SECTIONS macro

Masahiro Yamada <masahiroy@kernel.org>
    modpost: remove MEM_INIT_SECTIONS macro

Masahiro Yamada <masahiroy@kernel.org>
    modpost: disallow *driver to reference .meminit* sections

Masahiro Yamada <masahiroy@kernel.org>
    modpost: remove ALL_EXIT_DATA_SECTIONS macro

Maxime Chevallier <maxime.chevallier@bootlin.com>
    rtc: ab-eoz9: don't fail temperature reads on undervoltage notification

Pali Rohár <pali@kernel.org>
    cifs: Fix parsing reparse point with native symlink in SMB1 non-UNICODE session

Pali Rohár <pali@kernel.org>
    cifs: Fix parsing native symlinks relative to the export

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: disable directory caching when dir_cache_timeout is zero

Namhyung Kim <namhyung@kernel.org>
    perf/arm-cmn: Ensure port and device id bits are set properly

Chun-Tse Shao <ctshao@google.com>
    perf/arm-smmuv3: Fix lockdep assert in ->event_init()

Alex Zenla <alex@edera.dev>
    9p/xen: fix release of IRQ

Alex Zenla <alex@edera.dev>
    9p/xen: fix init sequence

Christoph Hellwig <hch@lst.de>
    block: return unsigned int from bdev_io_min

Breno Leitao <leitao@debian.org>
    nvme/multipath: Fix RCU list traversal to use SRCU primitive

Hannes Reinecke <hare@kernel.org>
    nvme-multipath: avoid hang on inaccessible namespaces

Thomas Song <tsong@purestorage.com>
    nvme-multipath: implement "queue-depth" iopolicy

John Meneghini <jmeneghi@redhat.com>
    nvme-multipath: prepare for "queue-depth" iopolicy

Wolfram Sang <wsa+renesas@sang-engineering.com>
    rtc: rzn1: fix BCD to rtc_time conversion errors

Qingfang Deng <qingfang.deng@siflower.com.cn>
    jffs2: fix use of uninitialized variable

Waqar Hameed <waqar.hameed@axis.com>
    ubifs: authentication: Fix use-after-free in ubifs_tnc_end_commit

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Fix duplicate slab cache names while attaching

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Correct the total block count by deducting journal reservation

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: wl: Schedule fm_work if wear-leveling pool is empty

Yongliang Gao <leonylgao@tencent.com>
    rtc: check if __rtc_read_time was successful in rtc_timer_do_work()

Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
    rtc: abx80x: Fix WDT bit position of the status register

Jinjie Ruan <ruanjinjie@huawei.com>
    rtc: st-lpc: Use IRQF_NO_AUTOEN flag in request_irq()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.0: Fix a use-after-free problem in the asynchronous open()

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Always dump trace for specified task in show_stack

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the return value of elf_core_copy_task_fpregs

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix potential integer overflow during physmem setup

Yang Erkun <yangerkun@huawei.com>
    SUNRPC: make sure cache entry active before cache_show

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent a potential integer overflow

Ma Wupeng <mawupeng1@huawei.com>
    ipc: fix memleak if msg_init_ns failed in create_ipc_ns

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on node blkaddr in truncate_node()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    lib: string_helpers: silence snprintf() output truncation warning

Ming Lei <ming.lei@redhat.com>
    ublk: fix error code for unsupported command

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix looping of queued SG entries

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix checking for number of TRBs left

Hubert Wiśniewski <hubert.wisniewski.25632@gmail.com>
    usb: musb: Fix hardware lockup on first Rx endpoint request

Paul Aurich <paul@darkrain42.org>
    smb: During unmount, ensure all cached dir instances drop their dentry

Paul Aurich <paul@darkrain42.org>
    smb: prevent use-after-free due to open_cached_dir error paths

Paul Aurich <paul@darkrain42.org>
    smb: Don't leak cfid when reconnect races with open_cached_dir

Paulo Alcantara <pc@manguebit.com>
    smb: client: handle max length for SMB symlinks

Steve French <stfrench@microsoft.com>
    smb3: request handle caching when caching directories

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Apply quirk for Medion E15433

Dinesh Kumar <desikumar81@gmail.com>
    ALSA: hda/realtek: Fix Internal Speaker and Mic boost of Infinix Y4 Max

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Set PCBeep to default value for ALC274

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Update ALC225 depop procedure

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Add sanity NULL check for the default mmap fault handler

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Fix evaluation of MIDI 1.0 FB info

Hans Verkuil <hverkuil@xs4all.nl>
    media: v4l2-core: v4l2-dv-timings: check cvt/gtf result

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    soc: fsl: rcpm: fix missing of_node_put() in copy_ippdexpcr1_setting()

Qiu-ji Chen <chenqiuji666@gmail.com>
    media: wl128x: Fix atomicity violation in fmc_send_cmd()

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Interpret tilt data from Intuos Pro BT as signed values

Bart Van Assche <bvanassche@acm.org>
    blk-mq: Make blk_mq_quiesce_tagset() hold the tag list mutex less long

Muchun Song <muchun.song@linux.dev>
    block: fix ordering between checking BLK_MQ_S_STOPPED request adding

Muchun Song <muchun.song@linux.dev>
    block: fix ordering between checking QUEUE_FLAG_QUIESCED request adding

Muchun Song <muchun.song@linux.dev>
    block: fix missing dispatching request when queue is started or unquiesced

Will Deacon <will@kernel.org>
    arm64: tls: Fix context-switching of tpidrro_el0 when kpti is enabled

Ming Lei <ming.lei@redhat.com>
    ublk: fix ublk_ch_mmap() for 64K page size

Zicheng Qu <quzicheng@huawei.com>
    iio: gts: Fix uninitialized symbol 'ret'

Huacai Chen <chenhuacai@kernel.org>
    sh: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Tiwei Bie <tiwei.btw@antgroup.com>
    um: vector: Do not use drvdata in release

Bin Liu <b-liu@ti.com>
    serial: 8250: omap: Move pm_runtime_get_sync

Filip Brozovic <fbrozovic@gmail.com>
    serial: 8250_fintek: Add support for F81216E

Michal Simek <michal.simek@amd.com>
    dt-bindings: serial: rs485: Fix rs485-rts-delay property

Tiwei Bie <tiwei.btw@antgroup.com>
    um: net: Do not use drvdata in release

Tiwei Bie <tiwei.btw@antgroup.com>
    um: ubd: Do not use drvdata in release

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: wl: Put source PEB into correct list if trying locking LEB failed

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    platform/chrome: cros_ec_typec: fix missing fwnode reference decrement

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix NULL ptr deref in crypto_aead_setkey()

Yunseong Kim <yskelg@gmail.com>
    ksmbd: fix use-after-free in SMB request handling

Josh Poimboeuf <jpoimboe@kernel.org>
    parisc/ftrace: Fix function graph tracing disablement

Meetakshi Setiya <msetiya@microsoft.com>
    cifs: support mounting with alternate password to allow password rotation

Jinjie Ruan <ruanjinjie@huawei.com>
    cpufreq: mediatek-hw: Fix wrong return value in mtk_cpufreq_get_cpu_power()

Cheng Ming Lin <chengminglin@mxic.com.tw>
    mtd: spi-nor: core: replace dummy buswidth from addr to data

Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
    spi: Fix acpi deferred irq probe

Jeongjun Park <aha310510@gmail.com>
    netfilter: ipset: add missing range check in bitmap_ip_uadt

Sai Kumar Cholleti <skmr537@gmail.com>
    gpio: exar: set value when external pull-up or pull-down is present

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "serial: sh-sci: Clean sci_ports[0] after at earlycon exit"

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Clean sci_ports[0] after at earlycon exit

Michal Vrastil <michal.vrastil@hidglobal.com>
    Revert "usb: gadget: composite: fix OS descriptors w_value logic"

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    wifi: brcmfmac: release 'root' node in all execution paths

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    wifi: ath12k: fix crash when unbinding

Guilherme G. Piccoli <gpiccoli@igalia.com>
    wifi: rtlwifi: Drastically reduce the attempts to read efuse in case of failures

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    wifi: ath12k: fix warning when unbinding

Andreas Kemnade <andreas@kemnade.info>
    ARM: dts: omap36xx: declare 1GHz OPP as turbo again

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Fix TD invalidation under pending Set TR Dequeue

Jan Hendrik Farr <kernel@jfarr.cc>
    Compiler Attributes: disable __counted_by for clang < 19.1.3

Andrej Shadura <andrew.shadura@collabora.co.uk>
    Bluetooth: Fix type of len in rfcomm_sock_getsockopt{,_old}()

Namjae Jeon <linkinjeon@kernel.org>
    exfat: fix uninit-value in __exfat_get_dentry_set

Angelo Dureghello <adureghello@baylibre.com>
    dt-bindings: iio: dac: ad3552r: fix maximum spi speed

Johan Hovold <johan+linaro@kernel.org>
    pinctrl: qcom: spmi: fix debugfs drive strength

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    tools/nolibc: s390: include std.h

Ahmed Ehab <bottaawesome633@gmail.com>
    locking/lockdep: Avoid creating new name string literals in lockdep_set_subclass()

Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
    tty: ldsic: fix tty_ldisc_autoload sysctl's proc_handler

Jinjie Ruan <ruanjinjie@huawei.com>
    apparmor: test: Fix memory leak for aa_unpack_strdup()

Jann Horn <jannh@google.com>
    comedi: Flush partial mappings in error case

Amir Goldstein <amir73il@gmail.com>
    fsnotify: fix sending inotify event with unexpected filename

Lukas Wunner <lukas@wunner.de>
    PCI: Fix use-after-free of slot->bus on hot remove

Kunkun Jiang <jiangkunkun@huawei.com>
    KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device

Jing Zhang <jingzhangos@google.com>
    KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*

Raghavendra Rao Ananta <rananta@google.com>
    KVM: arm64: Get rid of userspace_irqchip_in_use

Kunkun Jiang <jiangkunkun@huawei.com>
    KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE

Raghavendra Rao Ananta <rananta@google.com>
    KVM: arm64: Ignore PMCNTENSET_EL0 while checking for overflow status

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic-v3: Sanitise guest writes to GICR_INVLPIR

Gautam Menghani <gautam@linux.ibm.com>
    powerpc/pseries: Fix KVM guest detection for disabling hardlockup detector

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Skip the "try unsync" path iff the old SPTE was a leaf SPTE

Eric Biggers <ebiggers@google.com>
    crypto: x86/aegis128 - access 32-bit arguments as 32-bit

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix buffer full but size is 0 case

Qiu-ji Chen <chenqiuji666@gmail.com>
    ASoC: codecs: Fix atomicity violation in snd_soc_component_get_drvdata()

Ilya Zverev <ilya@zverev.info>
    ASoC: amd: yc: Add a quirk for microfone on Lenovo ThinkPad P14s Gen 5 21MES00B00

Artem Sadovnikov <ancowi69@gmail.com>
    jfs: xattr: check invalid xattr size more strictly

Theodore Ts'o <tytso@mit.edu>
    ext4: fix FS_IOC_GETFSMAP handling

Jeongjun Park <aha310510@gmail.com>
    ext4: supress data-race warnings in ext4_free_inodes_{count,set}()

Manikanta Mylavarapu <quic_mmanikan@quicinc.com>
    soc: qcom: socinfo: fix revision check in qcom_socinfo_probe()

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: sst: Fix used of uninitialized ctx to log an error

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8195-cherry: Mark USB 3.0 on xhci1 as disabled

Chen-Yu Tsai <wenst@chromium.org>
    Revert "arm64: dts: mediatek: mt8195-cherry: Mark USB 3.0 on xhci1 as disabled"

Benoît Sevens <bsevens@google.com>
    ALSA: usb-audio: Fix potential out-of-bound accesses for Extigy and Mbox devices

Filipe Manana <fdmanana@suse.com>
    btrfs: do not BUG_ON() when freeing tree block after error

Daejun Park <daejun7.park@samsung.com>
    f2fs: fix null reference error when checking end of zone

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Hide Topdown metrics events if the feature is not enumerated

Mikulas Patocka <mpatocka@redhat.com>
    dm-bufio: fix warnings about duplicate slab caches

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Add NULL pointer check for kzalloc

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check phantom_stream before it is used

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add NULL check for function pointer in dcn20_set_output_transfer_func

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Check null pointer before try to access it

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add NULL check for clk_mgr in dcn32_init_hw

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add NULL check for clk_mgr and clk_mgr->funcs in dcn30_init_hw

Mikulas Patocka <mpatocka@redhat.com>
    dm-cache: fix warnings about duplicate slab caches

Kent Overstreet <kent.overstreet@linux.dev>
    closures: Change BUG_ON() to WARN_ON()

Vitalii Mordan <mordan@ispras.ru>
    usb: ehci-spear: fix call balance of sehci clk handling routines

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix out of bounds reads when finding clock sources

Qiu-ji Chen <chenqiuji666@gmail.com>
    xen: Fix the issue of resource not being properly released in xenbus_dev_probe()

lei lu <llfamsec@gmail.com>
    xfs: add bounds checking to xlog_recover_process_data

Puranjay Mohan <pjy@amazon.com>
    nvme: fix metadata handling in nvme-passthrough

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Validate hdwq pointers before dereferencing in reset/errata paths

Jason-JH.Lin <jason-jh.lin@mediatek.com>
    mailbox: mtk-cmdq: Move devm_mbox_controller_register() after devm_pm_runtime_enable()

Xiuhong Wang <xiuhong.wang@unisoc.com>
    f2fs: fix fiemap failure issue when page size is 16KB

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Remove and replace gfs2_glock_queue_work

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Don't set GLF_LOCK in gfs2_dispose_glock_lru

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: amd: yc: Fix for enabling DMIC on acp6x via _DSD entry

chao liu <liuzgyid@outlook.com>
    apparmor: fix 'Do simple duplicate message elimination'

Zicheng Qu <quzicheng@huawei.com>
    drm/amd/display: Fix null check for pipe_ctx->plane_state in hwss_setup_dpp

Steven 'Steve' Kendall <skend@chromium.org>
    drm/radeon: Fix spurious unplug event on radeon HDMI

Wu Hoi Pok <wuhoipok@gmail.com>
    drm/radeon: change rdev->ddev to rdev_to_drm(rdev)

Wu Hoi Pok <wuhoipok@gmail.com>
    drm/radeon: add helper rdev_to_drm(rdev)

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Update ALC256 depop procedure

Gaosheng Cui <cuigaosheng1@huawei.com>
    firmware_loader: Fix possible resource leak in fw_log_firmware_info()

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    counter: ti-ecap-capture: Add check for clk_enable()

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    counter: stm32-timer-cnt: Add check for clk_enable()

Jinjie Ruan <ruanjinjie@huawei.com>
    misc: apds990x: Fix missing pm_runtime_disable()

Edward Adam Davis <eadavis@qq.com>
    USB: chaoskey: Fix possible deadlock chaoskey_list_lock

Oliver Neukum <oneukum@suse.com>
    USB: chaoskey: fail open after removal

Oliver Neukum <oneukum@suse.com>
    usb: yurex: make waiting on yurex_write interruptible

Jeongjun Park <aha310510@gmail.com>
    usb: using mutex lock and supporting O_NONBLOCK flag in iowarrior_read()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: light: al3010: Fix an error handling path in al3010_probe()

Paolo Abeni <pabeni@redhat.com>
    ipmr: fix tables suspicious RCU usage

Paolo Abeni <pabeni@redhat.com>
    ip6mr: fix tables suspicious RCU usage

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix use-after-free of nreq in reqsk_timer_handler().

Michal Luczaj <mhal@rbox.co>
    rxrpc: Improve setsockopt() handling of malformed user input

Michal Luczaj <mhal@rbox.co>
    llc: Improve setsockopt() handling of malformed user input

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix possible deadlocks

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix slab-use-after-free Read in set_powered_sync

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Unregister PTP during PCI shutdown and suspend

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Refactor bnxt_ptp_init()

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    bnxt_en: Reserve rings after PCIe AER recovery if NIC interface is down

Eric Dumazet <edumazet@google.com>
    net: hsr: fix hsr_init_sk() vs network/transport headers.

Csókás, Bence <csokas.bence@prolan.hu>
    spi: atmel-quadspi: Fix register name in verbose logging function

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: Quiesce traffic before NIX block reset

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: RPM: fix stale FCFEC counters

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: RPM: fix stale RSFEC counters

Sai Krishna <saikrishnag@marvell.com>
    octeontx2-pf: Reset MAC stats during probe

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: RPM: Fix low network performance

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: RPM: Fix mismatch in lmac type

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwmac-socfpga: Set RX watchdog interrupt as broken

Vitalii Mordan <mordan@ispras.ru>
    marvell: pxa168_eth: fix call balance of pep->clk handling routines

Rosen Penev <rosenp@gmail.com>
    net: mdio-ipq4019: add missing error check

Hangbin Liu <liuhangbin@gmail.com>
    net/ipv6: delete temporary address if mngtmpaddr is removed or unmanaged

Sidraya Jayagond <sidraya@linux.ibm.com>
    s390/iucv: MSG_PEEK causes memory leak in iucv_sock_destruct()

Guenter Roeck <linux@roeck-us.net>
    net: microchip: vcap: Add typegroup table terminators in kunit tests

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: Fix refcounting and autosuspend on invalid WoL configuration

Pavan Chebbi <pavan.chebbi@broadcom.com>
    tg3: Set coherent DMA mask bits to 31 for BCM57766 chipsets

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: Fix memory leak on device unplug by freeing PHY device

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: Fix double free issue with interrupt buffer allocation

ChiYuan Huang <cy_huang@richtek.com>
    power: supply: rt9471: Use IC status regfield to report real charger status

ChiYuan Huang <cy_huang@richtek.com>
    power: supply: rt9471: Fix wrong WDT function regfield declaration

Barnabás Czémán <barnabas.czeman@mainlining.org>
    power: supply: bq27xxx: Fix registers of bq27426

Bart Van Assche <bvanassche@acm.org>
    power: supply: core: Remove might_sleep() from power_supply_put()

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Sign-extend return values

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Fix build failure with GCC 15 (-std=gnu23)

Randy Dunlap <rdunlap@infradead.org>
    fs_parser: update mount_api doc to match function signature

Avihai Horon <avihaih@nvidia.com>
    vfio/pci: Properly hide first-in-list PCIe extended capability

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: zevio: Add missed label initialisation

Michael Ellerman <mpe@ellerman.id.au>
    selftests/mount_setattr: Fix failures on 64K PAGE_SIZE kernels

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: Fix suboptimal range on iotlb iteration

Murad Masimov <m.masimov@maxima.ru>
    hwmon: (tps23861) Fix reporting of negative temperatures

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix nfsd4_shutdown_copy()

Ye Bin <yebin10@huawei.com>
    svcrdma: fix miss destroy percpu_counter in svc_rdma_proc_init()

Yang Erkun <yangerkun@huawei.com>
    nfsd: release svc_expkey/svc_export with rcu_work

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Cap the number of bytes copied by nfs4_reset_recoverydir()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent NULL dereference in nfsd4_process_cb_update()

Zhongqiu Han <quic_zhonhan@quicinc.com>
    PCI: endpoint: epf-mhi: Avoid NULL dereference if DT lacks 'mmio'

Sibi Sankar <quic_sibis@quicinc.com>
    remoteproc: qcom_q6v5_mss: Re-order writes to the IMEM region

Jonathan Marek <jonathan@marek.ca>
    rpmsg: glink: use only lower 16-bits of param2 for CMD_OPEN name length

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    remoteproc: qcom: pas: add minidump_id to SM8350 resources

Benjamin Peterson <benjamin@engflow.com>
    perf trace: Avoid garbage when not printing a syscall's arguments

Benjamin Peterson <benjamin@engflow.com>
    perf trace: Do not lose last events in a race

Howard Chu <howardchu95@gmail.com>
    perf trace: Fix tracing itself, creating feedback loops

Jean-Philippe Romain <jean-philippe.romain@foss.st.com>
    perf list: Fix topic and pmu_name argument order

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Address an integer overflow

Antonio Quartulli <antonio@mandelbit.com>
    m68k: coldfire/device.c: only build FEC when HW macros are defined

Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
    m68k: mcfgpio: Fix incorrect register offset for CONFIG_M5441x

Benjamin Peterson <benjamin@engflow.com>
    perf trace: avoid garbage when not printing a trace event's arguments

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid forcing direct write to use buffered IO on inline_data inode

Long Li <leo.lilong@huawei.com>
    f2fs: fix race in concurrent f2fs_stop_gc_thread

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: j721e: Deassert PERST# after a delay of PCIE_T_PVPERL_MS milliseconds

Théo Lebrun <theo.lebrun@bootlin.com>
    PCI: j721e: Add suspend and resume support

Thomas Richard <thomas.richard@bootlin.com>
    PCI: j721e: Use T_PERST_CLK_US macro

Théo Lebrun <theo.lebrun@bootlin.com>
    PCI: j721e: Add reset GPIO to struct j721e_pcie

Thomas Richard <thomas.richard@bootlin.com>
    PCI: cadence: Set cdns_pcie_host_init() global

Thomas Richard <thomas.richard@bootlin.com>
    PCI: cadence: Extract link setup sequence from cdns_pcie_host_setup()

Matt Ranostay <mranostay@ti.com>
    PCI: j721e: Add PCIe 4x lane selection support

Matt Ranostay <mranostay@ti.com>
    PCI: j721e: Add per platform maximum lane settings

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    PCI: Add T_PVPERL macro

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to avoid use GC_AT when setting gc_mode as GC_URGENT_LOW or GC_URGENT_MID

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential deadlock in f2fs_record_stop_reason()

Yongpeng Yang <yangyongpeng1@oppo.com>
    f2fs: check curseg->inited before write_sum_page in change_curseg

LongPing Wei <weilongping@oppo.com>
    f2fs: fix the wrong f2fs_bug_on condition in f2fs_do_replace_block

Arnaldo Carvalho de Melo <acme@kernel.org>
    perf ftrace latency: Fix unit on histogram first entry when using --use-nsec

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: cpqphp: Fix PCIBIOS_* return value confusion

weiyufeng <weiyufeng@kylinos.cn>
    PCI: cpqphp: Use PCI_POSSIBLE_ERROR() to check config reads

Paolo Bonzini <pbonzini@redhat.com>
    rust: macros: fix documentation of the paste! macro

Leo Yan <leo.yan@arm.com>
    perf probe: Correct demangled symbols in C++ program

Ian Rogers <irogers@google.com>
    perf probe: Fix libdw memory leak

Chao Yu <chao@kernel.org>
    f2fs: fix to account dirty data in __get_secs_required()

Qi Han <hanqi@vivo.com>
    f2fs: compress: fix inconsistent update of i_blocks in release_compress_blocks and reserve_compress_blocks

Veronika Molnarova <vmolnaro@redhat.com>
    perf test attr: Add back missing topdown events

Michael Petlan <mpetlan@redhat.com>
    perf trace: Keep exited threads for summary

Ian Rogers <irogers@google.com>
    perf stat: Fix affinity memory leaks on error path

Levi Yun <yeoreum.yun@arm.com>
    perf stat: Close cork_fd when create_perf_stat_counter() failed

Todd Kjos <tkjos@google.com>
    PCI: Fix reset_method_store() memory leak

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix unlinked inode cleanup

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Allow immediate GLF_VERIFY_DELETE work

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Rename GLF_VERIFY_EVICT to GLF_VERIFY_DELETE

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Replace gfs2_glock_queue_put with gfs2_glock_put_async

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Get rid of gfs2_glock_queue_put in signal_our_withdraw

James Clark <james.clark@linaro.org>
    perf cs-etm: Don't flush when packet_queue fills up

Dan Carpenter <dan.carpenter@linaro.org>
    mailbox: arm_mhuv2: clean up loop in get_irq_chan_comb()

Paul Aurich <paul@darkrain42.org>
    smb: cached directories can be more than root file handle

zhang jiao <zhangjiao2@cmss.chinamobile.com>
    pinctrl: k210: Undef K210_PC_DEFAULT

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8180x: Add a SoC-specific compatible to cpufreq-hw

Nuno Sa <nuno.sa@analog.com>
    clk: clk-axi-clkgen: make sure to enable the AXI bus clock

Nuno Sa <nuno.sa@analog.com>
    dt-bindings: clock: axi-clkgen: include AXI clk

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    clk: ralink: mtmips: fix clocks probe order in oldest ralink SoCs

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    clk: ralink: mtmips: fix clock plan for Ralink SoC RT3883

Charles Han <hanchunchao@inspur.com>
    clk: clk-apple-nco: Add NULL check in applnco_probe

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Move events notifier registration to be after device registration

Jianbo Liu <jianbol@nvidia.com>
    IB/mlx5: Allocate resources just before first QP/SRQ is created

Zhen Lei <thunder.leizhen@huawei.com>
    fbdev: sh7760fb: Fix a possible memory leak in sh7760fb_alloc_mem()

Zhang Zekun <zhangzekun11@huawei.com>
    powerpc/kexec: Fix return of uninitialized variable

Michal Suchanek <msuchanek@suse.de>
    powerpc/sstep: make emulate_vsx_load and emulate_vsx_store static

Gautam Menghani <gautam@linux.ibm.com>
    KVM: PPC: Book3S HV: Avoid returning to nested hypervisor on pending doorbells

Gautam Menghani <gautam@linux.ibm.com>
    KVM: PPC: Book3S HV: Stop using vc->dpdes for nested KVM guests

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    dax: delete a stale directory pmem

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix uninitialized value in ocfs2_file_read_iter()

Jinjie Ruan <ruanjinjie@huawei.com>
    cpufreq: CPPC: Fix wrong return value in cppc_get_cpu_power()

Jinjie Ruan <ruanjinjie@huawei.com>
    cpufreq: CPPC: Fix wrong return value in cppc_get_cpu_cost()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix NULL pointer derefernce in hns_roce_map_mr_sg()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix out-of-order issue of requester when setting FENCE

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/tdx: Dynamically disable SEPT violations from causing #VEs

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/tdx: Rename tdx_parse_tdinfo() to tdx_setup()

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/tdx: Introduce wrappers to read and write TD metadata

Kai Huang <kai.huang@intel.com>
    x86/tdx: Pass TDCALL/SEAMCALL input/output registers via a structure

Kai Huang <kai.huang@intel.com>
    x86/tdx: Rename __tdx_module_call() to __tdcall()

Kai Huang <kai.huang@intel.com>
    x86/tdx: Make macros of TDCALLs consistent with the spec

Kai Huang <kai.huang@intel.com>
    x86/tdx: Skip saving output regs when SEAMCALL fails with VMFailInvalid

Bart Van Assche <bvanassche@acm.org>
    scsi: sg: Enable runtime power management

Zhen Lei <thunder.leizhen@huawei.com>
    scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()

Zhen Lei <thunder.leizhen@huawei.com>
    scsi: qedf: Fix a possible memory leak in qedf_alloc_and_init_sb()

Zeng Heng <zengheng4@huawei.com>
    scsi: fusion: Remove unused variable 'rc'

Ye Bin <yebin10@huawei.com>
    scsi: bfa: Fix use-after-free in bfad_im_module_exit()

Mirsad Todorovac <mtodorovac69@gmail.com>
    fs/proc/kcore.c: fix coccinelle reported ERROR instances

Zhang Changzhong <zhangchangzhong@huawei.com>
    mfd: rt5033: Fix missing regmap_del_irq_chip()

Tamir Duberstein <tamird@gmail.com>
    checkpatch: always parse orig_commit in fixes tag

Dan Carpenter <dan.carpenter@linaro.org>
    checkpatch: check for missing Fixes tags

Zhenzhong Duan <zhenzhong.duan@intel.com>
    iommu/vt-d: Fix checks and print in pgtable_walk()

Zhenzhong Duan <zhenzhong.duan@intel.com>
    iommu/vt-d: Fix checks and print in dmar_fault_dump_ptes()

Yang Yingliang <yangyingliang@huawei.com>
    clk: imx: imx8-acm: Fix return value check in clk_imx_acm_attach_pm_domains()

Dong Aisheng <aisheng.dong@nxp.com>
    clk: imx: clk-scu: fix clk enable state save and restore

Peng Fan <peng.fan@nxp.com>
    clk: imx: fracn-gppll: fix pll power up

Peng Fan <peng.fan@nxp.com>
    clk: imx: fracn-gppll: correct PLL initialization flow

Peng Fan <peng.fan@nxp.com>
    clk: imx: lpcg-scu: SW workaround for errata (e10858)

Yong-Xuan Wang <yongxuan.wang@sifive.com>
    RISC-V: KVM: Fix APLIC in_clrip and clripnum write emulation

Liu Jian <liujian56@huawei.com>
    RDMA/rxe: Set queue pair cur_qp_state when being queried

Biju Das <biju.das.jz@bp.renesas.com>
    clk: renesas: rzg2l: Fix FOUTPOSTDIV clk

Andre Przywara <andre.przywara@arm.com>
    clk: sunxi-ng: d1: Fix PLL_AUDIO0 preset

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Check cqe flags to know imm_data vs inv_irkey

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix the qp flush warnings in req

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix cpu stuck caused by printings during reset

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Use dev_* printings in hem code instead of ibdev_*

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix an AEQE overflow error caused by untimely update of eq_db_ci

Jinjie Ruan <ruanjinjie@huawei.com>
    cpufreq: CPPC: Fix possible null-ptr-deref for cppc_get_cpu_cost()

Jinjie Ruan <ruanjinjie@huawei.com>
    cpufreq: CPPC: Fix possible null-ptr-deref for cpufreq_cpu_get_raw()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Fix dtl_access_lock to be a rw_semaphore

Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
    mtd: spi-nor: spansion: Use nor->addr_nbytes in octal DTR mode in RD_ANY_REG_OP

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/mm/fault: Fix kfence page fault reporting

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: atmel: Fix possible memory leak

Biju Das <biju.das.jz@bp.renesas.com>
    mtd: hyperbus: rpc-if: Add missing MODULE_DEVICE_TABLE

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mtd: hyperbus: rpc-if: Convert to platform remove callback returning void

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/fadump: Move fadump_cma_init to setup_arch() after initmem_init()

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/fadump: Refactor and prepare fadump_cma_init for late init

Yuan Can <yuancan@huawei.com>
    cpufreq: loongson2: Unregister platform_driver on failure

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use IRQ domain for PMIC devices

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use IRQ domain for TMU device

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use IRQ domain for USB Type-C device

Marcus Folkesson <marcus.folkesson@gmail.com>
    mfd: da9052-spi: Change read-mask to write-mask

Jinjie Ruan <ruanjinjie@huawei.com>
    mfd: tps65010: Use IRQF_NO_AUTOEN flag in request_irq() to fix race

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/vdso: Flag VDSO64 entry points as functions

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Enable all PHYs that are not disabled by user during controller reset

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: zynqmp: drop excess struct member description

Levi Yun <yeoreum.yun@arm.com>
    trace/trace_event_perf: remove duplicate samples on the first tracepoint event

Lukas Bulwahn <lukas.bulwahn@redhat.com>
    clk: mediatek: drop two dead config options

Jie Zhan <zhanjie9@hisilicon.com>
    cppc_cpufreq: Use desired perf if feedback ctrs are 0 or unchanged

André Almeida <andrealmeid@igalia.com>
    unicode: Fix utf8_load() error path

Jiayuan Chen <mrpre@163.com>
    bpf: fix recursive lock when verdict program return SK_PASS

Hangbin Liu <liuhangbin@gmail.com>
    wireguard: selftests: load nf_conntrack if not present

Breno Leitao <leitao@debian.org>
    netpoll: Use rcu_access_pointer() in netpoll_poll_lock

Gao Xiang <xiang@kernel.org>
    erofs: handle NONHEAD !delta[1] lclusters gracefully

Dmitry Antipov <dmantipov@yandex.ru>
    Bluetooth: fix use-after-free in device_for_each_child()

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Release resources at card release

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Use snd_card_free_when_closed() at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: us122l: Use snd_card_free_when_closed() at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: usx2y: Use snd_card_free_when_closed() at disconnection

Mingwei Zheng <zmw12306@gmail.com>
    net: rfkill: gpio: Add check for clk_enable()

Jiri Olsa <jolsa@kernel.org>
    bpf: Force uprobe bpf program to always return 0

Yuan Can <yuancan@huawei.com>
    drm/amdkfd: Fix wrong usage of INIT_WORK()

Paolo Abeni <pabeni@redhat.com>
    selftests: net: really check for bg process completion

Paolo Abeni <pabeni@redhat.com>
    ipv6: release nexthop on device removal

Eric Dumazet <edumazet@google.com>
    net: use unrcu_pointer() helper

Eric Dumazet <edumazet@google.com>
    sock_diag: allow concurrent operation in sock_diag_rcv_msg()

Eric Dumazet <edumazet@google.com>
    sock_diag: allow concurrent operations

Eric Dumazet <edumazet@google.com>
    sock_diag: add module pointer to "struct sock_diag_handler"

Zijian Zhang <zijianzhang@bytedance.com>
    bpf, sockmap: Fix sk_msg_reset_curr

Zijian Zhang <zijianzhang@bytedance.com>
    bpf, sockmap: Several fixes to bpf_msg_pop_data

Zijian Zhang <zijianzhang@bytedance.com>
    bpf, sockmap: Several fixes to bpf_msg_push_data

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Add push/pop checking for msg_verify_data in test_sockmap

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Fix total_bytes in msg_loop_rx in test_sockmap

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Fix SENDPAGE data logic in test_sockmap

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Add txmsg_pass to pull/push/pop in test_sockmap

Maurice Lambert <mauricelambert434@gmail.com>
    netlink: typographical error in nlmsg_type constants definition

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: must hold rcu read lock while iterating object type list

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: skip transaction if update object is not implemented

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: must hold rcu read lock while iterating expression type list

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: avoid false-positive lockdep splat on rule deletion

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Introduce nf_tables_getrule_single()

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Open-code audit log call in nf_tables_getrule()

Jonathan Gray <jsg@jsg.id.au>
    drm: use ATOMIC64_INIT() for atomic64_t

José Expósito <jose.exposito89@gmail.com>
    drm/vkms: Drop unnecessary call to drm_crtc_cleanup()

Leon Hwang <leon.hwang@linux.dev>
    bpf, bpftool: Fix incorrect disasm pc

Zichen Xie <zichenxie0106@gmail.com>
    drm/msm/dpu: cast crtc_clk calculation to u64 in _dpu_core_perf_calc_clk()

Yuan Can <yuancan@huawei.com>
    wifi: wfx: Fix error handling in wfx_core_init()

Sean Anderson <sean.anderson@linux.dev>
    drm: zynqmp_kms: Unplug DRM device before removal

Li Huafei <lihuafei1@huawei.com>
    drm/nouveau/gr/gf100: Fix missing unlock in gf100_gr_chan_new()

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: hold GPU lock across perfmon sampling

Xiaolei Wang <xiaolei.wang@windriver.com>
    drm/etnaviv: Request pages from DMA32 zone on addressing_limited

Lukasz Luba <lukasz.luba@arm.com>
    drm/msm/gpu: Check the status of registration to PM QoS

Jinjie Ruan <ruanjinjie@huawei.com>
    drm/msm/adreno: Use IRQF_NO_AUTOEN flag in request_irq()

Xu Kuohai <xukuohai@huawei.com>
    bpf, arm64: Remove garbage frame for struct_ops trampoline

Steven Price <steven.price@arm.com>
    drm/panfrost: Remove unused id_mask from struct panfrost_model

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: fix test_spin_lock_fail.c's global vars usage

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_dcbnl.c

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_dmac_flt.c

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in cn10k.c

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_flows.c

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_ethtool.c

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_common.c

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: drop LM_3 / LM_4 on MSM8998

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: drop LM_3 / LM_4 on SDM845

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: on SDM845 move DSPP_3 to LM_5 block

Matthias Schiffer <matthias.schiffer@tq-group.com>
    drm: fsl-dcu: enable PIXCLK on LS1021A

Alper Nebi Yasak <alpernebiyasak@gmail.com>
    wifi: mwifiex: Fix memcpy() field-spanning write warning in mwifiex_config_scan()

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Fix txmsg_redir of test_txmsg_pull in test_sockmap

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Fix msg_verify_data in test_sockmap

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/bridge: tc358767: Fix link properties discovery

Hangbin Liu <liuhangbin@gmail.com>
    netdevsim: copy addresses for both in and out paths

Andrii Nakryiko <andrii@kernel.org>
    libbpf: never interpret subprogs in .text as entry programs

Everest K.C <everestkc@everestkc.com.np>
    ASoC: rt722-sdca: Remove logically deadcode in rt722-sdca.c

Andrii Nakryiko <andrii@kernel.org>
    libbpf: fix sym_is_subprog() logic for weak global subprogs

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: Match drm_dev_enter and exit calls in vc4_hvs_atomic_flush

Jacob Keller <jacob.e.keller@intel.com>
    ice: consistently use q_idx in ice_vc_cfg_qs_msg()

Haiyue Wang <haiyue.wang@intel.com>
    ice: Support FCS/CRC strip disable for VF

Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
    virtchnl: Add CRC stripping capability

Balaji Pothunoori <quic_bpothuno@quicinc.com>
    wifi: ath11k: Fix CE offset address calculation for WCN6750 in SSR

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Fix the xdp_adjust_tail sample prog issue

Tony Ambardar <tony.ambardar@gmail.com>
    libbpf: Fix output .symtab byte-order during linking

Tao Chen <chen.dylane@gmail.com>
    libbpf: Fix expected_attach_type set handling in program load callback

Pin-yen Lin <treapking@chromium.org>
    drm/bridge: it6505: Drop EDID cache on bridge power off

Pin-yen Lin <treapking@chromium.org>
    drm/bridge: anx7625: Drop EDID cache on bridge power off

Macpaul Lin <macpaul.lin@mediatek.com>
    ASoC: dt-bindings: mt6359: Update generic node name and dmic-mode

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: fix regmap_write_bits usage

Igor Prusov <ivprusov@salutedevices.com>
    dt-bindings: vendor-prefixes: Add NeoFidelity, Inc

Ramya Gnanasekar <quic_rgnanase@quicinc.com>
    wifi: ath12k: Skip Rx TID cleanup for self peer

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath10k: fix invalid VHT parameters in supported_vht_mcs_rate_nss2

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath10k: fix invalid VHT parameters in supported_vht_mcs_rate_nss1

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Address race-condition in MMU flush

Jinjie Ruan <ruanjinjie@huawei.com>
    drm/imx/ipuv3: Use IRQF_NO_AUTOEN flag in request_irq()

Jinjie Ruan <ruanjinjie@huawei.com>
    drm/imx/dcss: Use IRQF_NO_AUTOEN flag in request_irq()

Jinjie Ruan <ruanjinjie@huawei.com>
    wifi: mwifiex: Use IRQF_NO_AUTOEN flag in request_irq()

Jinjie Ruan <ruanjinjie@huawei.com>
    wifi: p54: Use IRQF_NO_AUTOEN flag in request_irq()

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/omap: Fix locking in omap_gem_new_dmabuf()

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/omap: Fix possible NULL dereference

Jeongjun Park <aha310510@gmail.com>
    wifi: ath9k: add range check for conn_rsp_epid in htc_connect_service()

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Correct logic on stopping an HVS channel

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Remove incorrect limit from hvs_dlist debugfs function

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Fix dlist debug not resetting the next entry pointer

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Avoid hang with debug registers when suspended

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Don't write gamma luts on 2711

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/mm: Mark drm_mm_interval_tree*() functions with __maybe_unused

Yao Zi <ziyao@disroot.org>
    platform/x86: panasonic-laptop: Return errno correctly in show callback

Vitaly Kuznetsov <vkuznets@redhat.com>
    HID: hyperv: streamline driver probe to avoid devres issues

Chris Morgan <macromorgan@hotmail.com>
    arm64: dts: rockchip: correct analog audio name on Indiedroid Nova

Li Huafei <lihuafei1@huawei.com>
    media: atomisp: Add check for rgby_data memory allocation failure

Luo Qiu <luoqiu@kylinsec.com.cn>
    firmware: arm_scpi: Check the DVFS OPP count returned by the firmware

Reinette Chatre <reinette.chatre@intel.com>
    selftests/resctrl: Protect against array overrun during iMC config parsing

Reinette Chatre <reinette.chatre@intel.com>
    selftests/resctrl: Fix memory overflow due to unhandled wraparound

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    selftests/resctrl: Refactor fill_buf functions

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    selftests/resctrl: Split fill_buf to allow tests finer-grained control

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-kukui-jacuzzi: Add supplies for fixed regulators

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-kukui-jacuzzi: Fix DP bridge supply names

Macpaul Lin <macpaul.lin@mediatek.com>
    arm64: dts: mediatek: mt6358: fix dtbs_check error

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: Add ADC node on MT6357, MT6358, MT6359 PMICs

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    arm64: dts: renesas: hihope: Drop #sound-dai-cells

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    regmap: irq: Set lockdep class for hierarchical IRQ domains

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: zynqmp-gqspi: Undo runtime PM changes at driver exit time​

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Avoid shift-out-of-bounds

Zhang Zekun <zhangzekun11@huawei.com>
    pmdomain: ti-sci: Add missing of_node_put() for args.np

Usama Arif <usamaarif642@gmail.com>
    of/fdt: add dt_phys arg to early_init_dt_scan and early_init_dt_verify

Stephen Boyd <sboyd@kernel.org>
    x86/of: Unconditionally call unflatten_and_copy_device_tree()

Stephen Boyd <sboyd@kernel.org>
    um: Unconditionally call unflatten_device_tree()

Anurag Dutta <a-dutta@ti.com>
    arm64: dts: ti: k3-j721s2: Fix clock IDs for MCSPI instances

Anurag Dutta <a-dutta@ti.com>
    arm64: dts: ti: k3-j721e: Fix clock IDs for MCSPI instances

Anurag Dutta <a-dutta@ti.com>
    arm64: dts: ti: k3-j7200: Fix clock ids for MCSPI instances

Jared McArthur <j-mcarthur@ti.com>
    arm64: dts: ti: k3-j7200: Fix register map for main domain pmx

Thomas Richard <thomas.richard@bootlin.com>
    arm64: dts: ti: k3-j7200: use ti,j7200-padconf compatible

Andre Przywara <andre.przywara@arm.com>
    ARM: dts: cubieboard4: Fix DCDC5 regulator constraints

Clark Wang <xiaoning.wang@nxp.com>
    pwm: imx27: Workaround of the pwm output bug when decrease the duty cycle

Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
    arm64: dts: mt8183: Damu: add i2c2's i2c-scl-internal-delay-ns

Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
    arm64: dts: mt8183: cozmo: add i2c2's i2c-scl-internal-delay-ns

Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
    arm64: dts: mt8183: burnet: add i2c2's i2c-scl-internal-delay-ns

Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
    arm64: dts: mt8183: fennel: add i2c2's i2c-scl-internal-delay-ns

Dragan Simic <dsimic@manjaro.org>
    regulator: rk808: Restrict DVS GPIOs to the RK808 variant only

Chen Ridong <chenridong@huawei.com>
    cgroup/bpf: only cgroup v2 can be attached by bpf programs

Chen Ridong <chenridong@huawei.com>
    Revert "cgroup: Fix memory leak caused by missing cgroup_bpf_offline"

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-elm-hana: Add vdd-supply to second source trackpad

Hsin-Te Yuan <yuanhsinte@chromium.org>
    arm64: dts: mt8183: kukui: Fix the address of eeprom at i2c4

Hsin-Te Yuan <yuanhsinte@chromium.org>
    arm64: dts: mt8183: krane: Fix the address of eeprom at i2c4

Colin Ian King <colin.i.king@gmail.com>
    media: i2c: ds90ub960: Fix missing return check on ub960_rxport_read call

Gregory Price <gourry@gourry.net>
    tpm: fix signed/unsigned bug when checking event logs

Jonathan Marek <jonathan@marek.ca>
    efi/libstub: fix efi_parse_options() ignoring the default command line

Stafford Horne <shorne@gmail.com>
    openrisc: Implement fixmap to fix earlycon

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    mmc: mmc_spi: drop buggy snprintf()

Andrei Simion <andrei.simion@microchip.com>
    ARM: dts: microchip: sam9x60: Add missing property atmel,usart-mode

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm6350: Fix GPU frequencies missing on some speedbins

Dan Carpenter <dan.carpenter@linaro.org>
    soc: qcom: geni-se: fix array underflow in geni_se_clk_tbl_get()

Jinjie Ruan <ruanjinjie@huawei.com>
    soc: ti: smartreflex: Use IRQF_NO_AUTOEN flag in request_irq()

Macpaul Lin <macpaul.lin@mediatek.com>
    arm64: dts: mt8195: Fix dtbs_check error for infracfg_ao node

Macpaul Lin <macpaul.lin@mediatek.com>
    arm64: dts: mt8195: Fix dtbs_check error for mutex node

Michal Simek <michal.simek@amd.com>
    microblaze: Export xmb_manager functions

Gaosheng Cui <cuigaosheng1@huawei.com>
    drivers: soc: xilinx: add the missing kfree in xlnx_add_cb_for_suspend()

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: spi-fsl-lpspi: Use IRQF_NO_AUTOEN flag in request_irq()

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    clocksource/drivers/timer-ti-dm: Fix child node refcount handling

Mark Brown <broonie@kernel.org>
    clocksource/drivers:sp804: Make user selectable

Marco Elver <elver@google.com>
    kcsan, seqlock: Fix incorrect assumption in read_seqbegin()

Marco Elver <elver@google.com>
    kcsan, seqlock: Support seqcount_latch_t

Miguel Ojeda <ojeda@kernel.org>
    time: Fix references to _msecs_to_jiffies() handling of values

Miguel Ojeda <ojeda@kernel.org>
    time: Partially revert cleanup on msecs_to_jiffies() documentation

Zheng Yejian <zhengyejian@huaweicloud.com>
    x86/unwind/orc: Fix unwind for newly forked tasks

Daniel Lezcano <daniel.lezcano@linaro.org>
    thermal/lib: Fix memory leak on error in thermal_genl_auto()

Daniel Lezcano <daniel.lezcano@linaro.org>
    tools/lib/thermal: Make more generic the command encoding function

Uladzislau Rezki (Sony) <urezki@gmail.com>
    rcuscale: Do a proper cleanup if kfree_scale_init() fails

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: cavium - Fix an error handling path in cpt_ucode_load_fw()

Chen Ridong <chenridong@huawei.com>
    crypto: bcm - add error check in the ahash_hmac_init function

Chen Ridong <chenridong@huawei.com>
    crypto: caam - add error check to caam_rsa_set_priv_key_form

Lifeng Zheng <zhenglifeng1@huawei.com>
    ACPI: CPPC: Fix _CPC register setting issue

Pei Xiao <xiaopei01@kylinos.cn>
    hwmon: (nct6775-core) Fix overflows seen when writing limit attributes

Jerome Brunet <jbrunet@baylibre.com>
    hwmon: (pmbus/core) clear faults after setting smbalert mask

Patrick Rudolph <patrick.rudolph@9elements.com>
    hwmon: (pmbus_core) Allow to hook PMBUS_SMBALERT_MASK

Uladzislau Rezki (Sony) <urezki@gmail.com>
    rcu/kvfree: Fix data-race in __mod_timer / kvfree_call_rcu

Baruch Siach <baruch@tkos.co.il>
    doc: rcu: update printed dynticks counter bits

Li Huafei <lihuafei1@huawei.com>
    crypto: inside-secure - Fix the return value of safexcel_xcbcmac_cra_init()

Orange Kao <orange@aiven.io>
    EDAC/igen6: Avoid segmentation fault on module unload

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - disable same error report before resetting

Gautham R. Shenoy <gautham.shenoy@amd.com>
    amd-pstate: Set min_perf to nominal_perf for active mode performance gov

Everest K.C <everestkc@everestkc.com.np>
    crypto: cavium - Fix the if condition to exit loop after timeout

Yi Yang <yiyang13@huawei.com>
    crypto: pcrypt - Call crypto layer directly when padata_do_parallel() return -EBUSY

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/{skx_common,i10nm}: Fix incorrect far-memory error source indicator

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/skx_common: Differentiate memory error sources

Priyanka Singh <priyanka.singh@nxp.com>
    EDAC/fsl_ddr: Fix bad bit shift operations

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Initialize thermal zones before registering them

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - remove faulty arbiter config reset

David Thompson <davthompson@nvidia.com>
    EDAC/bluefield: Fix potential integer overflow

Yuan Can <yuancan@huawei.com>
    firmware: google: Unregister driver_info on failure

Dan Carpenter <dan.carpenter@linaro.org>
    crypto: qat/qat_4xxx - fix off by one in uof_get_name()

Cabiddu, Giovanni <giovanni.cabiddu@intel.com>
    crypto: qat - remove check after debugfs_create_dir()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: caam - Fix the pointer passed to caam_qi_shutdown()

Christoph Hellwig <hch@lst.de>
    virtio_blk: reverse request order in virtio_queue_rqs

Christoph Hellwig <hch@lst.de>
    nvme-pci: reverse request order in nvme_queue_rqs

Long Li <leo.lilong@huawei.com>
    ext4: fix race in buffer_head read fault injection

Matthew Wilcox (Oracle) <willy@infradead.org>
    ext4: remove array of buffer_heads from mext_page_mkuptodate()

Matthew Wilcox (Oracle) <willy@infradead.org>
    ext4: pipeline buffer reads in mext_page_mkuptodate()

Matthew Wilcox (Oracle) <willy@infradead.org>
    ext4: remove calls to to set/clear the folio error flag

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    hfsplus: don't query the device logical block size multiple times

Masahiro Yamada <masahiroy@kernel.org>
    s390/syscalls: Avoid creation of arch/arch/ directory

Christoph Hellwig <hch@lst.de>
    block: fix bio_split_rw_at to take zone_write_granularity into account

Zizhi Wo <wozizhi@huawei.com>
    netfs/fscache: Add a memory barrier for FSCACHE_VOLUME_CREATING

Zizhi Wo <wozizhi@huawei.com>
    cachefiles: Fix missing pos updates in cachefiles_ondemand_fd_write_iter()

Aleksandr Mishin <amishin@t-argos.ru>
    acpi/arm64: Adjust error handling procedure in gtdt_parse_timer_block()

Masahiro Yamada <masahiroy@kernel.org>
    arm64: fix .data.rel.ro size assertion when CONFIG_LTO_CLANG

Daniel Palmer <daniel@0x0f.com>
    m68k: mvme147: Reinstate early console

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: mvme16x: Add and use "mvme16x.h"

Daniel Palmer <daniel@0x0f.com>
    m68k: mvme147: Fix SCSI controller IRQ numbers

Christoph Hellwig <hch@lst.de>
    nvme-pci: fix freeing of the HMB descriptor table

David Disseldorp <ddiss@suse.de>
    initramfs: avoid filename buffer overrun

Jonas Gorski <jonas.gorski@gmail.com>
    mips: asm: fix warning when disabling MIPS_FP_SUPPORT

Jan Kara <jack@suse.cz>
    ext4: avoid remount errors with 'abort' mount option

Yang Erkun <yangerkun@huawei.com>
    brd: defer automatic disk creation until module initialization succeeds

Ard Biesheuvel <ardb@kernel.org>
    x86/pvh: Call C code via the kernel virtual mapping

Jason Andryuk <jason.andryuk@amd.com>
    x86/pvh: Set phys_base when calling xen_prepare_pvh()

Heiko Carstens <hca@linux.ibm.com>
    s390/pageattr: Implement missing kernel_page_present()

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Do not unregister the subchannel based on DNV

Andre Przywara <andre.przywara@arm.com>
    kselftest/arm64: mte: fix printf type warnings about longs

Andre Przywara <andre.przywara@arm.com>
    kselftest/arm64: mte: fix printf type warnings about __u64

Kristina Martsenko <kristina.martsenko@arm.com>
    arm64: probes: Disable kprobes/uprobes on MOPS instructions

Andrii Nakryiko <andrii@kernel.org>
    bpf: support non-r10 register spill/fill to/from stack in precision tracking

Dmitry Kandybka <d.kandybka@gmail.com>
    mptcp: fix possible integer overflow in mptcp_reset_tout_timer

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add null check for pipe_ctx->plane_state in dcn20_program_pipe

Hans de Goede <hdegoede@redhat.com>
    platform/x86: x86-android-tablets: Unregister devices in reverse order

Keith Busch <kbusch@kernel.org>
    nvme: apple: fix device reference counting

Oleg Nesterov <oleg@redhat.com>
    fs/proc: do_task_stat: use sig->stats_lock to gather the threads/children stats

Wayne Lin <wayne.lin@amd.com>
    drm/amd/display: Don't refer to dc_sink in is_dsc_need_re_compute

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check null-initialized variables

Li Zhijian <lizhijian@fujitsu.com>
    fs/inode: Prevent dump_mapping() accessing invalid dentry.d_name.name

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Initialize denominators' default to 1

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add NULL check for function pointer in dcn32_set_output_transfer_func

Ard Biesheuvel <ardb@kernel.org>
    x86/stackprotector: Work around strict Clang TLS symbol requirements

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix invalid FIFO access with special register set

Holger Dengler <dengler@linux.ibm.com>
    s390/pkey: Wipe copies of clear-key structures on failure

Alexander Stein <alexander.stein@ew.tq-group.com>
    i2c: lpi2c: Avoid calling clk_get_rate during transfer

Breno Leitao <leitao@debian.org>
    ipmr: Fix access to mfc_cache_list without lock held

Harith G <harith.g@alifsemi.com>
    ARM: 9420/1: smp: Fix SMP for xip kernels

Eryk Zagorski <erykzagorski@gmail.com>
    ALSA: usb-audio: Fix Yamaha P-125 Quirk Entry

Yuli Wang <wangyuli@uniontech.com>
    LoongArch: Define a default value for VM_DATA_DEFAULT_FLAGS

John Watts <contact@jookia.org>
    ASoC: audio-graph-card2: Purge absent supplies for device tree nodes

David Wang <00107082@163.com>
    proc/softirqs: replace seq_printf with seq_put_decimal_ull_width

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Make Lenovo Yoga Tab 3 X90F DMI match less strict

Luo Yifan <luoyifan@cmss.chinamobile.com>
    ASoC: stm: Prevent potential division by zero in stm32_sai_get_clk_div()

Luo Yifan <luoyifan@cmss.chinamobile.com>
    ASoC: stm: Prevent potential division by zero in stm32_sai_mclk_round_rate()

Markus Petri <mp@mpetri.org>
    ASoC: amd: yc: Support dmic on another model of Lenovo Thinkpad E14 Gen 6

Vishnu Sankar <vishnuocv@gmail.com>
    platform/x86: thinkpad_acpi: Fix for ThinkPad's with ECFW showing incorrect fan speed

Alexander Hölzl <alexander.hoelzl@gmx.net>
    can: j1939: fix error in J1939 documentation.

zhang jiao <zhangjiao2@cmss.chinamobile.com>
    tools/lib/thermal: Remove the thermal.h soft link when doing make clean

Shenghao Ding <shenghao-ding@ti.com>
    ASoC: tas2781: Add new driver version for tas2563 & tas2781 qfn chip

Kurt Borja <kuurtb@gmail.com>
    platform/x86: dell-wmi-base: Handle META key Lock/Unlock events

Kurt Borja <kuurtb@gmail.com>
    platform/x86: dell-smbios-base: Extends support to Alienware products

Mikhail Rudenko <mike.rudenko@gmail.com>
    regulator: rk808: Add apply_bit for BUCK3 on RK809

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Reject clear channel request on A2P

Charles Han <hanchunchao@inspur.com>
    soc: qcom: Add check devm_kasprintf() returned value

Benoît Monin <benoit.monin@gmx.fr>
    net: usb: qmi_wwan: add Quectel RG650V

Jiayuan Chen <mrpre@163.com>
    bpf: fix filed access without lock

Arnd Bergmann <arnd@arndb.de>
    x86/amd_nb: Fix compile-testing without CONFIG_AMD_NB

Piyush Raj Chouhan <piyushchouhan1598@gmail.com>
    ALSA: hda/realtek: Add subwoofer quirk for Infinix ZERO BOOK 13

Li Zhijian <lizhijian@fujitsu.com>
    selftests/watchdog-test: Fix system accidentally reset after watchdog-test

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    usb: typec: use cleanup facility for 'altmodes_node'

Benjamin Große <ste3ls@gmail.com>
    usb: add support for new USB device ID 0x17EF:0x3098 for the r8152 driver

Ben Greear <greearb@candelatech.com>
    mac80211: fix user-power when emulating chanctx

Daniel Gabay <daniel.gabay@intel.com>
    wifi: iwlwifi: mvm: Use the sync timepoint API in suspend

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: sst: Support LPE0F28 ACPI HID

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add DMI quirk for Vexia Edu Atla 10 tablet

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add support for non ACPI instantiated codec

Hans de Goede <hdegoede@redhat.com>
    ASoC: codecs: rt5640: Always disable IRQs from rt5640_cancel_work()

Gustavo A. R. Silva <gustavoars@kernel.org>
    wifi: radiotap: Avoid -Wflex-array-member-not-at-end warnings


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-fs-f2fs            |   7 +-
 Documentation/RCU/stallwarn.rst                    |   2 +-
 .../devicetree/bindings/clock/adi,axi-clkgen.yaml  |  22 +-
 .../devicetree/bindings/iio/dac/adi,ad3552r.yaml   |   2 +-
 .../devicetree/bindings/serial/rs485.yaml          |  19 +-
 .../devicetree/bindings/sound/mt6359.yaml          |  10 +-
 .../devicetree/bindings/vendor-prefixes.yaml       |   2 +
 Documentation/filesystems/mount_api.rst            |   3 +-
 Documentation/locking/seqlock.rst                  |   2 +-
 Documentation/networking/j1939.rst                 |   2 +-
 Makefile                                           |   4 +-
 arch/arc/kernel/devtree.c                          |   2 +-
 .../boot/dts/allwinner/sun9i-a80-cubieboard4.dts   |   4 +-
 arch/arm/boot/dts/microchip/sam9x60.dtsi           |  12 ++
 arch/arm/boot/dts/ti/omap/omap36xx.dtsi            |   1 +
 arch/arm/kernel/devtree.c                          |   2 +-
 arch/arm/kernel/entry-armv.S                       |   8 +
 arch/arm/kernel/head.S                             |   4 +
 arch/arm/kernel/psci_smp.c                         |   7 +
 arch/arm/mm/idmap.c                                |   7 +
 arch/arm/mm/ioremap.c                              |  35 +++-
 .../boot/dts/allwinner/sun50i-a64-pinephone.dtsi   |   3 +
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi   |   2 +-
 arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi   |   2 +-
 arch/arm64/boot/dts/mediatek/mt6357.dtsi           |   5 +
 arch/arm64/boot/dts/mediatek/mt6358.dtsi           |   9 +-
 arch/arm64/boot/dts/mediatek/mt6359.dtsi           |   5 +
 arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi  |   8 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts   |   3 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts    |   2 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-damu.dts     |   3 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi  |   3 +
 .../boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi    |  30 +--
 .../boot/dts/mediatek/mt8183-kukui-kakadu.dtsi     |   4 +-
 .../boot/dts/mediatek/mt8183-kukui-kodama.dtsi     |   4 +-
 .../boot/dts/mediatek/mt8183-kukui-krane.dtsi      |   4 +-
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi    |   2 +-
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |   4 +-
 arch/arm64/boot/dts/qcom/sc8180x.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/sm6350.dtsi               |  14 +-
 arch/arm64/boot/dts/renesas/hihope-rev2.dtsi       |   3 -
 arch/arm64/boot/dts/renesas/hihope-rev4.dtsi       |   3 -
 .../boot/dts/rockchip/rk3588s-indiedroid-nova.dts  |   2 +-
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |   2 +-
 .../boot/dts/ti/k3-j7200-common-proc-board.dts     |   2 +-
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi          |  46 +++--
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi    |  18 +-
 arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi    |   6 +-
 arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi         |  16 +-
 arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi   |   6 +-
 arch/arm64/include/asm/insn.h                      |   1 +
 arch/arm64/include/asm/kvm_host.h                  |   2 -
 arch/arm64/kernel/probes/decode-insn.c             |   7 +-
 arch/arm64/kernel/process.c                        |   2 +-
 arch/arm64/kernel/setup.c                          |   6 +-
 arch/arm64/kernel/vmlinux.lds.S                    |   6 +-
 arch/arm64/kvm/arch_timer.c                        |   3 +-
 arch/arm64/kvm/arm.c                               |  18 +-
 arch/arm64/kvm/pmu-emul.c                          |   1 -
 arch/arm64/kvm/vgic/vgic-its.c                     |  32 +--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   7 +-
 arch/arm64/kvm/vgic/vgic.h                         |  23 +++
 arch/arm64/net/bpf_jit_comp.c                      |  47 +++--
 arch/csky/kernel/setup.c                           |   4 +-
 arch/loongarch/include/asm/page.h                  |   5 +-
 arch/loongarch/kernel/setup.c                      |   2 +-
 arch/loongarch/net/bpf_jit.c                       |   2 +-
 arch/loongarch/vdso/Makefile                       |   2 +-
 arch/m68k/coldfire/device.c                        |   8 +-
 arch/m68k/include/asm/mcfgpio.h                    |   2 +-
 arch/m68k/include/asm/mvme147hw.h                  |   4 +-
 arch/m68k/kernel/early_printk.c                    |   9 +-
 arch/m68k/mvme147/config.c                         |  30 +++
 arch/m68k/mvme147/mvme147.h                        |   6 +
 arch/m68k/mvme16x/config.c                         |   2 +
 arch/m68k/mvme16x/mvme16x.h                        |   6 +
 arch/microblaze/kernel/microblaze_ksyms.c          |  10 +
 arch/microblaze/kernel/prom.c                      |   2 +-
 arch/mips/include/asm/switch_to.h                  |   2 +-
 arch/mips/kernel/prom.c                            |   2 +-
 arch/mips/kernel/relocate.c                        |   2 +-
 arch/nios2/kernel/prom.c                           |   4 +-
 arch/openrisc/Kconfig                              |   3 +
 arch/openrisc/include/asm/fixmap.h                 |  21 +-
 arch/openrisc/kernel/prom.c                        |   2 +-
 arch/openrisc/mm/init.c                            |  37 ++++
 arch/parisc/kernel/ftrace.c                        |   2 +-
 arch/powerpc/Kconfig                               |   4 +-
 arch/powerpc/Makefile                              |  13 +-
 arch/powerpc/include/asm/dtl.h                     |   4 +-
 arch/powerpc/include/asm/fadump.h                  |   7 +
 arch/powerpc/include/asm/sstep.h                   |   5 -
 arch/powerpc/include/asm/vdso.h                    |   1 +
 arch/powerpc/kernel/dt_cpu_ftrs.c                  |   2 +-
 arch/powerpc/kernel/fadump.c                       |  23 +--
 arch/powerpc/kernel/prom.c                         |   2 +-
 arch/powerpc/kernel/setup-common.c                 |   6 +-
 arch/powerpc/kernel/setup_64.c                     |   1 +
 arch/powerpc/kernel/vmlinux.lds.S                  |   2 -
 arch/powerpc/kexec/file_load_64.c                  |   9 +-
 arch/powerpc/kvm/book3s_hv.c                       |  10 +-
 arch/powerpc/kvm/book3s_hv_nested.c                |  14 +-
 arch/powerpc/lib/sstep.c                           |  12 +-
 arch/powerpc/mm/fault.c                            |  10 +-
 arch/powerpc/platforms/pseries/dtl.c               |   8 +-
 arch/powerpc/platforms/pseries/lpar.c              |   8 +-
 arch/powerpc/platforms/pseries/plpks.c             |   2 +-
 arch/riscv/kernel/setup.c                          |   2 +-
 arch/riscv/kvm/aia_aplic.c                         |   3 +-
 arch/s390/include/asm/set_memory.h                 |   1 +
 arch/s390/kernel/entry.S                           |   4 +
 arch/s390/kernel/kprobes.c                         |   6 +
 arch/s390/kernel/syscalls/Makefile                 |   2 +-
 arch/s390/mm/pageattr.c                            |  15 ++
 arch/sh/kernel/cpu/proc.c                          |   2 +-
 arch/sh/kernel/setup.c                             |   2 +-
 arch/um/drivers/net_kern.c                         |   2 +-
 arch/um/drivers/ubd_kern.c                         |   2 +-
 arch/um/drivers/vector_kern.c                      |   3 +-
 arch/um/kernel/dtb.c                               |  14 +-
 arch/um/kernel/physmem.c                           |   6 +-
 arch/um/kernel/process.c                           |   2 +-
 arch/um/kernel/sysrq.c                             |   2 +-
 arch/x86/Makefile                                  |   3 +-
 arch/x86/coco/tdx/tdcall.S                         |  60 +++---
 arch/x86/coco/tdx/tdx-shared.c                     |   8 +-
 arch/x86/coco/tdx/tdx.c                            | 145 +++++++++----
 arch/x86/crypto/aegis128-aesni-asm.S               |  29 +--
 arch/x86/entry/entry.S                             |  15 ++
 arch/x86/events/intel/core.c                       |  34 ++-
 arch/x86/events/intel/pt.c                         |  11 +-
 arch/x86/events/intel/pt.h                         |   2 +
 arch/x86/include/asm/amd_nb.h                      |   5 +-
 arch/x86/include/asm/asm-prototypes.h              |   3 +
 arch/x86/include/asm/shared/tdx.h                  |  29 ++-
 arch/x86/kernel/asm-offsets.c                      |  12 +-
 arch/x86/kernel/cpu/common.c                       |   2 +
 arch/x86/kernel/devicetree.c                       |  24 ++-
 arch/x86/kernel/unwind_orc.c                       |   2 +-
 arch/x86/kernel/vmlinux.lds.S                      |   3 +
 arch/x86/kvm/mmu/spte.c                            |  18 +-
 arch/x86/platform/pvh/head.S                       |  22 +-
 arch/x86/virt/vmx/tdx/tdxcall.S                    | 104 +++++-----
 arch/xtensa/kernel/setup.c                         |   2 +-
 block/bfq-iosched.c                                |  37 ++--
 block/blk-merge.c                                  |  10 +-
 block/blk-mq.c                                     |  58 ++++--
 block/blk-mq.h                                     |  13 ++
 crypto/pcrypt.c                                    |  12 +-
 drivers/acpi/arm64/gtdt.c                          |   2 +-
 drivers/acpi/cppc_acpi.c                           |   1 -
 drivers/base/firmware_loader/main.c                |   5 +-
 drivers/base/regmap/regmap-irq.c                   |   4 +
 drivers/block/brd.c                                |  66 ++++--
 drivers/block/ublk_drv.c                           |  17 +-
 drivers/block/virtio_blk.c                         |  46 ++---
 drivers/block/zram/zram_drv.c                      |   7 +
 drivers/char/tpm/tpm-chip.c                        |   4 -
 drivers/char/tpm/tpm-interface.c                   |  29 ++-
 drivers/clk/clk-apple-nco.c                        |   3 +
 drivers/clk/clk-axi-clkgen.c                       |  22 +-
 drivers/clk/imx/clk-fracn-gppll.c                  |  10 +-
 drivers/clk/imx/clk-imx8-acm.c                     |   4 +-
 drivers/clk/imx/clk-lpcg-scu.c                     |  37 +++-
 drivers/clk/imx/clk-scu.c                          |   2 +-
 drivers/clk/mediatek/Kconfig                       |  15 --
 drivers/clk/qcom/gcc-qcs404.c                      |   1 +
 drivers/clk/ralink/clk-mtmips.c                    |  26 ++-
 drivers/clk/renesas/rzg2l-cpg.c                    |  11 +-
 drivers/clk/sunxi-ng/ccu-sun20i-d1.c               |   2 +-
 drivers/clocksource/Kconfig                        |   3 +-
 drivers/clocksource/timer-ti-dm-systimer.c         |   4 +-
 drivers/comedi/comedi_fops.c                       |  12 ++
 drivers/counter/stm32-timer-cnt.c                  |  16 +-
 drivers/counter/ti-ecap-capture.c                  |   7 +-
 drivers/cpufreq/amd-pstate.c                       |   2 +-
 drivers/cpufreq/cppc_cpufreq.c                     |  63 +++++-
 drivers/cpufreq/loongson2_cpufreq.c                |   4 +-
 drivers/cpufreq/mediatek-cpufreq-hw.c              |   2 +-
 drivers/crypto/bcm/cipher.c                        |   5 +-
 drivers/crypto/caam/caampkc.c                      |  11 +-
 drivers/crypto/caam/qi.c                           |   2 +-
 drivers/crypto/cavium/cpt/cptpf_main.c             |   6 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |  35 +++-
 drivers/crypto/hisilicon/qm.c                      |  47 ++---
 drivers/crypto/hisilicon/sec2/sec_main.c           |  35 +++-
 drivers/crypto/hisilicon/zip/zip_main.c            |  35 +++-
 drivers/crypto/inside-secure/safexcel_hash.c       |   2 +-
 .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   |   2 +-
 drivers/crypto/intel/qat/qat_common/adf_dbgfs.c    |  13 +-
 .../crypto/intel/qat/qat_common/adf_hw_arbiter.c   |   4 -
 drivers/dax/pmem/Makefile                          |   7 -
 drivers/dax/pmem/pmem.c                            |  10 -
 drivers/dma-buf/udmabuf.c                          |   8 +-
 drivers/edac/bluefield_edac.c                      |   2 +-
 drivers/edac/fsl_ddr_edac.c                        |  22 +-
 drivers/edac/i10nm_base.c                          |   1 +
 drivers/edac/igen6_edac.c                          |   2 +
 drivers/edac/skx_common.c                          |  57 +++--
 drivers/edac/skx_common.h                          |   8 +
 drivers/firmware/arm_scmi/common.h                 |   2 +
 drivers/firmware/arm_scmi/driver.c                 |   6 +
 drivers/firmware/arm_scpi.c                        |   3 +
 drivers/firmware/efi/libstub/efi-stub.c            |   4 +-
 drivers/firmware/efi/tpm.c                         |  17 +-
 drivers/firmware/google/gsmi.c                     |   6 +-
 drivers/gpio/gpio-exar.c                           |  10 +-
 drivers/gpio/gpio-zevio.c                          |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c      |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |   5 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   4 +
 .../amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c   |   8 +
 .../amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c   |   8 +
 .../gpu/drm/amd/display/dc/core/dc_hw_sequencer.c  |   3 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  31 ++-
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |   7 +-
 .../gpu/drm/amd/display/dc/dcn30/dcn30_resource.c  |   3 +
 .../gpu/drm/amd/display/dc/dcn31/dcn31_resource.c  |   5 +
 .../drm/amd/display/dc/dcn314/dcn314_resource.c    |   5 +
 .../drm/amd/display/dc/dcn315/dcn315_resource.c    |   2 +
 .../drm/amd/display/dc/dcn316/dcn316_resource.c    |   2 +
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c |  11 +-
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource.c  |   8 +
 .../drm/amd/display/dc/dcn321/dcn321_resource.c    |   2 +
 .../display/dc/dml/dcn20/display_rq_dlg_calc_20.c  |   2 +-
 .../gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c   |   7 +-
 .../amd/display/dc/dml/dml1_display_rq_dlg_calc.c  |   2 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |   2 +
 drivers/gpu/drm/bridge/analogix/anx7625.c          |   2 +
 drivers/gpu/drm/bridge/ite-it6505.c                |   2 +
 drivers/gpu/drm/bridge/tc358767.c                  |   7 +
 drivers/gpu/drm/drm_file.c                         |   2 +-
 drivers/gpu/drm/drm_mm.c                           |   2 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   1 -
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |   3 +-
 drivers/gpu/drm/etnaviv/etnaviv_drv.c              |  10 +
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  28 +--
 drivers/gpu/drm/fsl-dcu/Kconfig                    |   1 +
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c          |  15 ++
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h          |   3 +
 drivers/gpu/drm/imx/dcss/dcss-crtc.c               |   6 +-
 drivers/gpu/drm/imx/ipuv3/ipuv3-crtc.c             |   6 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   4 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   4 +-
 .../drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h    |  12 --
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h |  14 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c      |   2 +-
 drivers/gpu/drm/msm/msm_gpu_devfreq.c              |   9 +-
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c     |   1 +
 drivers/gpu/drm/omapdrm/dss/base.c                 |  25 +--
 drivers/gpu/drm/omapdrm/dss/omapdss.h              |   3 +-
 drivers/gpu/drm/omapdrm/omap_drv.c                 |   4 +-
 drivers/gpu/drm/omapdrm/omap_gem.c                 |  10 +-
 drivers/gpu/drm/panfrost/panfrost_gpu.c            |   1 -
 drivers/gpu/drm/radeon/atombios_encoders.c         |   2 +-
 drivers/gpu/drm/radeon/cik.c                       |  14 +-
 drivers/gpu/drm/radeon/dce6_afmt.c                 |   2 +-
 drivers/gpu/drm/radeon/evergreen.c                 |  12 +-
 drivers/gpu/drm/radeon/ni.c                        |   2 +-
 drivers/gpu/drm/radeon/r100.c                      |  24 +--
 drivers/gpu/drm/radeon/r300.c                      |   6 +-
 drivers/gpu/drm/radeon/r420.c                      |   6 +-
 drivers/gpu/drm/radeon/r520.c                      |   2 +-
 drivers/gpu/drm/radeon/r600.c                      |  12 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |   2 +-
 drivers/gpu/drm/radeon/r600_dpm.c                  |   4 +-
 drivers/gpu/drm/radeon/r600_hdmi.c                 |   2 +-
 drivers/gpu/drm/radeon/radeon.h                    |   5 +
 drivers/gpu/drm/radeon/radeon_acpi.c               |  10 +-
 drivers/gpu/drm/radeon/radeon_agp.c                |   2 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |   2 +-
 drivers/gpu/drm/radeon/radeon_audio.c              |  14 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |  12 +-
 drivers/gpu/drm/radeon/radeon_device.c             |  10 +-
 drivers/gpu/drm/radeon/radeon_display.c            |  74 +++----
 drivers/gpu/drm/radeon/radeon_fbdev.c              |  26 +--
 drivers/gpu/drm/radeon/radeon_fence.c              |   8 +-
 drivers/gpu/drm/radeon/radeon_gem.c                |   2 +-
 drivers/gpu/drm/radeon/radeon_i2c.c                |   2 +-
 drivers/gpu/drm/radeon/radeon_ib.c                 |   2 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |  12 +-
 drivers/gpu/drm/radeon/radeon_object.c             |   2 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |  20 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |   2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |   6 +-
 drivers/gpu/drm/radeon/rs400.c                     |   6 +-
 drivers/gpu/drm/radeon/rs600.c                     |  14 +-
 drivers/gpu/drm/radeon/rs690.c                     |   2 +-
 drivers/gpu/drm/radeon/rv515.c                     |   4 +-
 drivers/gpu/drm/radeon/rv770.c                     |   2 +-
 drivers/gpu/drm/radeon/si.c                        |   4 +-
 drivers/gpu/drm/sti/sti_cursor.c                   |   3 +
 drivers/gpu/drm/sti/sti_gdp.c                      |   3 +
 drivers/gpu/drm/sti/sti_hqvdp.c                    |   3 +
 drivers/gpu/drm/v3d/v3d_mmu.c                      |  29 +--
 drivers/gpu/drm/vc4/vc4_drv.h                      |   1 +
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   4 +
 drivers/gpu/drm/vc4/vc4_hvs.c                      |  23 ++-
 drivers/gpu/drm/vkms/vkms_output.c                 |   5 +-
 drivers/gpu/drm/xlnx/zynqmp_kms.c                  |   6 +-
 drivers/hid/hid-hyperv.c                           |  58 ++++--
 drivers/hid/wacom_wac.c                            |   4 +-
 drivers/hwmon/nct6775-core.c                       |   7 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |  12 +-
 drivers/hwmon/tps23861.c                           |   2 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |  10 +-
 drivers/i3c/master.c                               |   2 +-
 drivers/i3c/master/svc-i3c-master.c                |   2 +-
 drivers/iio/accel/kionix-kx022a.c                  |   2 +-
 drivers/iio/adc/ad7780.c                           |   2 +-
 drivers/iio/adc/ad7923.c                           |   4 +-
 drivers/iio/industrialio-gts-helper.c              |   4 +-
 drivers/iio/inkern.c                               |   2 +-
 drivers/iio/light/al3010.c                         |  11 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   7 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   2 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |   4 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   1 +
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  48 ++---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         | 150 ++++++++------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   6 +
 drivers/infiniband/hw/hns/hns_roce_mr.c            |  11 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  56 +++--
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   4 +-
 drivers/infiniband/hw/mlx5/main.c                  | 193 +++++++++++------
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   6 +-
 drivers/infiniband/hw/mlx5/qp.c                    |   4 +
 drivers/infiniband/hw/mlx5/srq.c                   |   4 +
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   1 +
 drivers/infiniband/sw/rxe/rxe_req.c                |   6 +-
 drivers/iommu/intel/iommu.c                        |  40 ++--
 drivers/iommu/io-pgtable-arm.c                     |  18 +-
 drivers/leds/flash/leds-mt6360.c                   |   3 +-
 drivers/leds/leds-lp55xx-common.c                  |   3 -
 drivers/mailbox/arm_mhuv2.c                        |   8 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |  12 +-
 drivers/md/bcache/closure.c                        |  10 +-
 drivers/md/dm-bufio.c                              |  12 +-
 drivers/md/dm-cache-background-tracker.c           |  25 +--
 drivers/md/dm-cache-background-tracker.h           |   8 +
 drivers/md/dm-cache-target.c                       |  25 ++-
 drivers/md/dm-thin.c                               |   1 +
 drivers/md/md-bitmap.c                             |   1 +
 drivers/md/persistent-data/dm-space-map-common.c   |   2 +-
 drivers/media/dvb-frontends/ts2020.c               |   8 +-
 drivers/media/i2c/adv7604.c                        |   5 +-
 drivers/media/i2c/adv7842.c                        |  13 +-
 drivers/media/i2c/ds90ub960.c                      |   2 +-
 drivers/media/i2c/dw9768.c                         |  10 +-
 drivers/media/i2c/tc358743.c                       |   4 +-
 drivers/media/platform/allegro-dvt/allegro-core.c  |   4 +-
 drivers/media/platform/amphion/vpu_drv.c           |   2 +-
 drivers/media/platform/amphion/vpu_v4l2.c          |   2 +-
 .../media/platform/mediatek/jpeg/mtk_jpeg_core.c   |  10 +
 .../media/platform/mediatek/jpeg/mtk_jpeg_dec_hw.c |  11 -
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |   4 +-
 drivers/media/platform/qcom/venus/core.c           |   2 +-
 .../media/platform/samsung/exynos4-is/media-dev.h  |   5 +-
 .../verisilicon/rockchip_vpu981_hw_av1_dec.c       |   3 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |   3 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |  15 +-
 drivers/media/usb/gspca/ov534.c                    |   2 +-
 drivers/media/usb/uvc/uvc_driver.c                 | 102 ++++++---
 drivers/media/v4l2-core/v4l2-dv-timings.c          | 132 ++++++------
 drivers/message/fusion/mptsas.c                    |   4 +-
 drivers/mfd/da9052-spi.c                           |   2 +-
 drivers/mfd/intel_soc_pmic_bxtwc.c                 | 138 ++++++++-----
 drivers/mfd/rt5033.c                               |   4 +-
 drivers/mfd/tps65010.c                             |   8 +-
 drivers/misc/apds990x.c                            |  12 +-
 drivers/misc/lkdtm/bugs.c                          |   4 +-
 drivers/mmc/host/mmc_spi.c                         |   9 +-
 drivers/mtd/hyperbus/rpc-if.c                      |  13 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 |   8 +-
 drivers/mtd/nand/raw/atmel/pmecc.h                 |   2 -
 drivers/mtd/spi-nor/core.c                         |   2 +-
 drivers/mtd/spi-nor/spansion.c                     |   1 +
 drivers/mtd/ubi/attach.c                           |  12 +-
 drivers/mtd/ubi/fastmap-wl.c                       |  19 +-
 drivers/mtd/ubi/wl.c                               |  11 +-
 drivers/mtd/ubi/wl.h                               |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  20 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h      |   3 +-
 drivers/net/ethernet/broadcom/tg3.c                |   3 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |  28 ++-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  97 ++++++++-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   6 +
 .../ethernet/marvell/octeontx2/af/lmac_common.h    |   8 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   1 +
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    | 104 ++++++++--
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |  21 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  74 ++++++-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |   5 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   4 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   1 +
 .../ethernet/marvell/octeontx2/nic/otx2_dcbnl.c    |   5 +
 .../ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c |   9 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  10 +
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  10 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  20 ++
 drivers/net/ethernet/marvell/pxa168_eth.c          |  14 +-
 .../net/ethernet/microchip/vcap/vcap_api_kunit.c   |  17 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |   2 +
 drivers/net/mdio/mdio-ipq4019.c                    |   5 +-
 drivers/net/netdevsim/ipsec.c                      |  11 +-
 drivers/net/usb/lan78xx.c                          |  42 ++--
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/r8152.c                            |   1 +
 drivers/net/wireless/ath/ath10k/mac.c              |   4 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   3 +
 drivers/net/wireless/ath/ath12k/dp.c               |   5 +-
 drivers/net/wireless/ath/ath12k/mac.c              |   5 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   3 +
 drivers/net/wireless/ath/wil6210/txrx.c            |   2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   3 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |   2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.h       |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   2 +
 drivers/net/wireless/intersil/p54/p54spi.c         |   4 +-
 drivers/net/wireless/marvell/libertas/radiotap.h   |   4 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |   2 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |   4 +-
 drivers/net/wireless/microchip/wilc1000/mon.c      |   4 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |  11 +-
 drivers/net/wireless/silabs/wfx/main.c             |  17 +-
 drivers/net/wireless/virtual/mac80211_hwsim.c      |   4 +-
 drivers/nvme/host/apple.c                          |  27 ++-
 drivers/nvme/host/core.c                           |   2 +-
 drivers/nvme/host/ioctl.c                          |   8 +-
 drivers/nvme/host/multipath.c                      | 134 ++++++++++--
 drivers/nvme/host/nvme.h                           |   4 +
 drivers/nvme/host/pci.c                            |  55 +++--
 drivers/of/fdt.c                                   |  14 +-
 drivers/of/kexec.c                                 |   2 +-
 drivers/of/unittest.c                              |   4 -
 drivers/pci/controller/cadence/pci-j721e.c         | 123 +++++++++--
 drivers/pci/controller/cadence/pcie-cadence-host.c |  44 ++--
 drivers/pci/controller/cadence/pcie-cadence.h      |  12 ++
 drivers/pci/controller/dwc/pci-keystone.c          |  12 ++
 drivers/pci/controller/pcie-rockchip-ep.c          |  16 +-
 drivers/pci/controller/pcie-rockchip.h             |   4 +
 drivers/pci/endpoint/functions/pci-epf-mhi.c       |   6 +
 drivers/pci/endpoint/pci-epc-core.c                |   6 +-
 drivers/pci/hotplug/cpqphp_pci.c                   |  19 +-
 drivers/pci/of_property.c                          |   2 +-
 drivers/pci/pci.c                                  |   5 +-
 drivers/pci/pci.h                                  |   3 +
 drivers/pci/slot.c                                 |   4 +-
 drivers/perf/arm-cmn.c                             |   4 +-
 drivers/perf/arm_smmuv3_pmu.c                      |  19 +-
 drivers/pinctrl/pinctrl-k210.c                     |   2 +-
 drivers/pinctrl/pinctrl-zynqmp.c                   |   1 -
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |   2 +-
 drivers/platform/chrome/cros_ec_typec.c            |   1 +
 drivers/platform/x86/dell/dell-smbios-base.c       |   1 +
 drivers/platform/x86/dell/dell-wmi-base.c          |   6 +
 drivers/platform/x86/intel/bxtwc_tmu.c             |  22 +-
 drivers/platform/x86/panasonic-laptop.c            |  10 +-
 drivers/platform/x86/thinkpad_acpi.c               |  28 ++-
 drivers/platform/x86/x86-android-tablets/core.c    |   6 +-
 drivers/pmdomain/ti/ti_sci_pm_domains.c            |   4 +
 drivers/power/supply/bq27xxx_battery.c             |  37 +++-
 drivers/power/supply/power_supply_core.c           |   2 -
 drivers/power/supply/rt9471.c                      |  52 +++--
 drivers/pwm/pwm-imx27.c                            |  98 ++++++++-
 drivers/regulator/rk808-regulator.c                |  17 +-
 drivers/remoteproc/qcom_q6v5_mss.c                 |   6 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |   2 +
 drivers/rpmsg/qcom_glink_native.c                  |   3 +-
 drivers/rtc/interface.c                            |   7 +-
 drivers/rtc/rtc-ab-eoz9.c                          |   7 -
 drivers/rtc/rtc-abx80x.c                           |   2 +-
 drivers/rtc/rtc-rzn1.c                             |   8 +-
 drivers/rtc/rtc-st-lpc.c                           |   5 +-
 drivers/s390/cio/cio.c                             |   6 +-
 drivers/s390/cio/device.c                          |  18 +-
 drivers/s390/crypto/pkey_api.c                     |  16 +-
 drivers/scsi/bfa/bfad.c                            |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   8 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   3 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  13 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  11 +
 drivers/scsi/qedf/qedf_main.c                      |   1 +
 drivers/scsi/qedi/qedi_main.c                      |   1 +
 drivers/scsi/sg.c                                  |   9 +-
 drivers/sh/intc/core.c                             |   2 +-
 drivers/soc/fsl/rcpm.c                             |   1 +
 drivers/soc/qcom/qcom-geni-se.c                    |   3 +-
 drivers/soc/qcom/socinfo.c                         |   8 +-
 drivers/soc/ti/smartreflex.c                       |   4 +-
 drivers/soc/xilinx/xlnx_event_manager.c            |   4 +-
 drivers/spi/atmel-quadspi.c                        |   2 +-
 drivers/spi/spi-fsl-lpspi.c                        |  12 +-
 drivers/spi/spi-tegra210-quad.c                    |   2 +-
 drivers/spi/spi-zynqmp-gqspi.c                     |   2 +
 drivers/spi/spi.c                                  |  13 +-
 drivers/staging/media/atomisp/pci/sh_css_params.c  |   2 +
 .../intel/int340x_thermal/int3400_thermal.c        |   2 +-
 drivers/thermal/thermal_core.c                     |   2 +-
 drivers/tty/serial/8250/8250_fintek.c              |  14 +-
 drivers/tty/serial/8250/8250_omap.c                |   4 +-
 drivers/tty/serial/sc16is7xx.c                     |   4 +
 drivers/tty/tty_io.c                               |   2 +-
 drivers/ufs/host/ufs-exynos.c                      |  16 +-
 drivers/usb/dwc3/gadget.c                          |  15 +-
 drivers/usb/gadget/composite.c                     |  18 +-
 drivers/usb/host/ehci-spear.c                      |   7 +-
 drivers/usb/host/xhci-ring.c                       |  18 +-
 drivers/usb/misc/chaoskey.c                        |  35 +++-
 drivers/usb/misc/iowarrior.c                       |  50 +++--
 drivers/usb/misc/yurex.c                           |   5 +-
 drivers/usb/musb/musb_gadget.c                     |  13 +-
 drivers/usb/typec/class.c                          |   6 +-
 drivers/usb/typec/tcpm/wcove.c                     |   4 -
 drivers/vdpa/mlx5/core/mr.c                        |   4 +-
 drivers/vfio/pci/vfio_pci_config.c                 |  16 +-
 drivers/video/fbdev/sh7760fb.c                     |   3 +-
 drivers/xen/xenbus/xenbus_probe.c                  |   8 +-
 fs/btrfs/ctree.c                                   |  57 ++++-
 fs/btrfs/extent-tree.c                             |  25 ++-
 fs/btrfs/extent-tree.h                             |   8 +-
 fs/btrfs/free-space-tree.c                         |  10 +-
 fs/btrfs/ioctl.c                                   |   6 +-
 fs/btrfs/qgroup.c                                  |   6 +-
 fs/btrfs/ref-verify.c                              |   1 +
 fs/cachefiles/ondemand.c                           |   4 +-
 fs/ceph/super.c                                    |  10 +-
 fs/erofs/zmap.c                                    |  17 +-
 fs/exfat/namei.c                                   |   1 +
 fs/ext4/balloc.c                                   |   4 +-
 fs/ext4/ext4.h                                     |  12 +-
 fs/ext4/extents.c                                  |   2 +-
 fs/ext4/fsmap.c                                    |  54 ++++-
 fs/ext4/ialloc.c                                   |   5 +-
 fs/ext4/indirect.c                                 |   2 +-
 fs/ext4/inode.c                                    |   4 +-
 fs/ext4/mballoc.c                                  |  18 +-
 fs/ext4/mballoc.h                                  |   1 +
 fs/ext4/mmp.c                                      |   2 +-
 fs/ext4/move_extent.c                              |  47 +++--
 fs/ext4/page-io.c                                  |   3 -
 fs/ext4/readpage.c                                 |   1 -
 fs/ext4/resize.c                                   |   2 +-
 fs/ext4/super.c                                    |  42 ++--
 fs/f2fs/checkpoint.c                               |   2 +-
 fs/f2fs/data.c                                     |  26 +--
 fs/f2fs/f2fs.h                                     |   3 +-
 fs/f2fs/file.c                                     |  17 +-
 fs/f2fs/gc.c                                       |   2 +
 fs/f2fs/node.c                                     |  10 +
 fs/f2fs/segment.c                                  |   5 +-
 fs/f2fs/segment.h                                  |  35 +++-
 fs/f2fs/super.c                                    |  13 +-
 fs/fscache/volume.c                                |   3 +-
 fs/gfs2/glock.c                                    |  82 ++++----
 fs/gfs2/glock.h                                    |   3 +-
 fs/gfs2/incore.h                                   |   2 +-
 fs/gfs2/log.c                                      |   2 +-
 fs/gfs2/rgrp.c                                     |   2 +-
 fs/gfs2/super.c                                    |   6 +-
 fs/gfs2/util.c                                     |   2 +-
 fs/hfsplus/hfsplus_fs.h                            |   3 +-
 fs/hfsplus/wrapper.c                               |   2 +
 fs/inode.c                                         |  10 +-
 fs/jffs2/erase.c                                   |   7 +-
 fs/jfs/xattr.c                                     |   2 +-
 fs/nfs/internal.h                                  |   2 +-
 fs/nfs/nfs4proc.c                                  |   8 +-
 fs/nfsd/export.c                                   |  36 +++-
 fs/nfsd/export.h                                   |   4 +-
 fs/nfsd/nfs4callback.c                             |  16 +-
 fs/nfsd/nfs4proc.c                                 |   7 +-
 fs/nfsd/nfs4recover.c                              |   3 +-
 fs/nfsd/nfs4state.c                                |  19 ++
 fs/notify/fsnotify.c                               |  23 ++-
 fs/ocfs2/aops.h                                    |   2 +
 fs/ocfs2/file.c                                    |   4 +
 fs/overlayfs/inode.c                               |   7 +-
 fs/overlayfs/util.c                                |   3 +
 fs/proc/array.c                                    |  57 ++---
 fs/proc/kcore.c                                    |  11 +-
 fs/proc/softirqs.c                                 |   2 +-
 fs/quota/dquot.c                                   |   2 +
 fs/smb/client/cached_dir.c                         | 229 ++++++++++++++-------
 fs/smb/client/cached_dir.h                         |   6 +-
 fs/smb/client/cifsfs.c                             |  12 +-
 fs/smb/client/cifsglob.h                           |   4 +-
 fs/smb/client/cifsproto.h                          |   1 +
 fs/smb/client/connect.c                            |  59 +++++-
 fs/smb/client/fs_context.c                         |  85 +++++++-
 fs/smb/client/fs_context.h                         |   1 +
 fs/smb/client/inode.c                              |   4 +-
 fs/smb/client/reparse.c                            |  95 +++++++--
 fs/smb/client/reparse.h                            |   6 +-
 fs/smb/client/smb1ops.c                            |   4 +-
 fs/smb/client/smb2file.c                           |  21 +-
 fs/smb/client/smb2inode.c                          |   6 +-
 fs/smb/client/smb2ops.c                            |   2 +-
 fs/smb/client/smb2pdu.c                            |   4 +-
 fs/smb/client/smb2proto.h                          |   9 +-
 fs/smb/client/trace.h                              |   3 +
 fs/smb/server/server.c                             |   4 +
 fs/ubifs/super.c                                   |   6 +-
 fs/ubifs/tnc_commit.c                              |   2 +
 fs/unicode/utf8-core.c                             |   2 +-
 fs/xfs/libxfs/xfs_sb.c                             |   7 -
 fs/xfs/xfs_log_recover.c                           |   5 +-
 include/asm-generic/vmlinux.lds.h                  |  22 +-
 include/linux/avf/virtchnl.h                       |  11 +-
 include/linux/blkdev.h                             |   2 +-
 include/linux/bpf_verifier.h                       |  33 ++-
 include/linux/compiler_attributes.h                |  13 --
 include/linux/compiler_types.h                     |  19 ++
 include/linux/hisi_acc_qm.h                        |   8 +-
 include/linux/init.h                               |  14 +-
 include/linux/jiffies.h                            |   2 +-
 include/linux/lockdep.h                            |   2 +-
 include/linux/mmdebug.h                            |   6 +-
 include/linux/netpoll.h                            |   2 +-
 include/linux/of_fdt.h                             |   5 +-
 include/linux/once.h                               |   4 +-
 include/linux/once_lite.h                          |   2 +-
 include/linux/rcupdate.h                           |   2 +-
 include/linux/seqlock.h                            |  98 ++++++---
 include/linux/sock_diag.h                          |  10 +-
 include/linux/util_macros.h                        |  56 +++--
 include/media/v4l2-dv-timings.h                    |  18 +-
 include/net/ieee80211_radiotap.h                   |  37 ++--
 include/net/net_debug.h                            |   2 +-
 include/net/sock.h                                 |   2 +-
 include/uapi/linux/rtnetlink.h                     |   2 +-
 init/Kconfig                                       |   9 +
 init/initramfs.c                                   |  15 ++
 ipc/namespace.c                                    |   4 +-
 kernel/bpf/verifier.c                              | 175 +++++++++-------
 kernel/cgroup/cgroup.c                             |  21 +-
 kernel/rcu/rcuscale.c                              |   6 +-
 kernel/rcu/tree.c                                  |  14 +-
 kernel/signal.c                                    |   9 +-
 kernel/time/time.c                                 |   4 +-
 kernel/trace/bpf_trace.c                           |   5 +-
 kernel/trace/ftrace.c                              |   3 +
 kernel/trace/trace_event_perf.c                    |   6 +
 lib/maple_tree.c                                   |  13 +-
 lib/string_helpers.c                               |   2 +-
 mm/internal.h                                      |   2 +-
 mm/slab.h                                          |   5 +
 mm/slub.c                                          |   9 +-
 mm/vmstat.c                                        |   1 +
 net/9p/trans_xen.c                                 |   9 +-
 net/bluetooth/hci_sysfs.c                          |  15 +-
 net/bluetooth/mgmt.c                               |  38 +++-
 net/bluetooth/rfcomm/sock.c                        |  10 +-
 net/core/filter.c                                  |  88 ++++----
 net/core/gen_estimator.c                           |   2 +-
 net/core/skmsg.c                                   |   4 +-
 net/core/sock_diag.c                               | 114 +++++-----
 net/hsr/hsr_device.c                               |   4 +-
 net/ipv4/cipso_ipv4.c                              |   2 +-
 net/ipv4/inet_connection_sock.c                    |   2 +-
 net/ipv4/inet_diag.c                               |  11 +-
 net/ipv4/ipmr.c                                    |  44 ++--
 net/ipv4/ipmr_base.c                               |   3 +-
 net/ipv4/tcp.c                                     |   2 +-
 net/ipv4/tcp_bpf.c                                 |   7 +-
 net/ipv4/tcp_fastopen.c                            |   7 +-
 net/ipv4/udp.c                                     |   2 +-
 net/ipv6/addrconf.c                                |  41 ++--
 net/ipv6/af_inet6.c                                |   2 +-
 net/ipv6/ip6_fib.c                                 |   2 +-
 net/ipv6/ip6mr.c                                   |  40 ++--
 net/ipv6/ipv6_sockglue.c                           |   3 +-
 net/ipv6/route.c                                   |  10 +-
 net/iucv/af_iucv.c                                 |  26 ++-
 net/llc/af_llc.c                                   |   2 +-
 net/mac80211/main.c                                |   2 +
 net/mptcp/protocol.c                               |   4 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c             |   7 +-
 net/netfilter/nf_tables_api.c                      | 161 +++++++++------
 net/netlink/diag.c                                 |   1 +
 net/packet/diag.c                                  |   1 +
 net/rfkill/rfkill-gpio.c                           |   8 +-
 net/rxrpc/af_rxrpc.c                               |   7 +-
 net/sched/act_api.c                                |   2 +-
 net/smc/smc_diag.c                                 |   1 +
 net/sunrpc/cache.c                                 |   4 +-
 net/sunrpc/svcsock.c                               |   4 +
 net/sunrpc/xprtrdma/svc_rdma.c                     |  19 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |   8 +-
 net/sunrpc/xprtsock.c                              |  17 +-
 net/tipc/diag.c                                    |   1 +
 net/unix/diag.c                                    |   1 +
 net/vmw_vsock/diag.c                               |   1 +
 net/xdp/xsk_diag.c                                 |   1 +
 rust/macros/lib.rs                                 |   2 +-
 samples/bpf/xdp_adjust_tail_kern.c                 |   1 +
 scripts/checkpatch.pl                              |  61 ++++--
 scripts/mod/file2alias.c                           |   5 +-
 scripts/mod/modpost.c                              |  45 +---
 security/apparmor/capability.c                     |   2 +
 security/apparmor/policy_unpack_test.c             |   6 +
 sound/core/pcm_native.c                            |   6 +-
 sound/core/ump.c                                   |   5 +-
 sound/hda/intel-dsp-config.c                       |   4 +
 sound/pci/hda/patch_realtek.c                      | 155 +++++++-------
 sound/soc/amd/yc/acp6x-mach.c                      |  32 ++-
 sound/soc/codecs/da7219.c                          |   9 +-
 sound/soc/codecs/rt5640.c                          |  27 +--
 sound/soc/codecs/rt722-sdca.c                      |   8 +-
 sound/soc/codecs/tas2781-fmwlib.c                  |   1 +
 sound/soc/fsl/fsl_micfil.c                         |   4 +-
 sound/soc/generic/audio-graph-card2.c              |   3 +
 sound/soc/intel/atom/sst/sst_acpi.c                |  64 +++++-
 sound/soc/intel/boards/bytcr_rt5640.c              |  48 ++++-
 sound/soc/stm/stm32_sai_sub.c                      |   6 +-
 sound/usb/6fire/chip.c                             |  10 +-
 sound/usb/caiaq/audio.c                            |  10 +-
 sound/usb/caiaq/audio.h                            |   1 +
 sound/usb/caiaq/device.c                           |  19 +-
 sound/usb/caiaq/input.c                            |  12 +-
 sound/usb/caiaq/input.h                            |   1 +
 sound/usb/clock.c                                  |  24 ++-
 sound/usb/quirks-table.h                           |  14 +-
 sound/usb/quirks.c                                 |  27 ++-
 sound/usb/usx2y/us122l.c                           |   5 +-
 sound/usb/usx2y/usbusx2y.c                         |   2 +-
 tools/bpf/bpftool/jit_disasm.c                     |  40 +++-
 tools/include/nolibc/arch-s390.h                   |   1 +
 tools/lib/bpf/libbpf.c                             |  16 +-
 tools/lib/bpf/linker.c                             |   2 +
 tools/lib/thermal/Makefile                         |   4 +-
 tools/lib/thermal/commands.c                       |  52 +++--
 tools/perf/builtin-ftrace.c                        |   2 +-
 tools/perf/builtin-list.c                          |   4 +-
 tools/perf/builtin-stat.c                          |  52 +++--
 tools/perf/builtin-trace.c                         |  23 ++-
 tools/perf/tests/attr/test-stat-default            |  94 ++++++---
 tools/perf/tests/attr/test-stat-detailed-1         | 110 +++++++---
 tools/perf/tests/attr/test-stat-detailed-2         | 134 ++++++++----
 tools/perf/tests/attr/test-stat-detailed-3         | 142 ++++++++-----
 tools/perf/util/cs-etm.c                           |  25 ++-
 tools/perf/util/evlist.c                           |  19 +-
 tools/perf/util/evlist.h                           |   1 +
 tools/perf/util/pfm.c                              |   4 +-
 tools/perf/util/pmus.c                             |   2 +-
 tools/perf/util/probe-finder.c                     |  21 +-
 tools/perf/util/probe-finder.h                     |   4 +-
 .../selftests/arm64/mte/check_tags_inclusion.c     |   4 +-
 .../testing/selftests/arm64/mte/mte_common_util.c  |   4 +-
 .../selftests/bpf/progs/test_spin_lock_fail.c      |   4 +-
 .../bpf/progs/verifier_subprog_precision.c         |  23 ++-
 tools/testing/selftests/bpf/test_sockmap.c         | 165 ++++++++++++---
 tools/testing/selftests/bpf/verifier/precise.c     |  38 ++--
 .../selftests/mount_setattr/mount_setattr_test.c   |   2 +-
 tools/testing/selftests/net/pmtu.sh                |   2 +-
 tools/testing/selftests/resctrl/fill_buf.c         |  74 +++----
 tools/testing/selftests/resctrl/resctrl.h          |   2 +-
 tools/testing/selftests/resctrl/resctrl_val.c      |   3 +-
 tools/testing/selftests/vDSO/parse_vdso.c          |   3 +-
 tools/testing/selftests/watchdog/watchdog-test.c   |   6 +
 tools/testing/selftests/wireguard/netns.sh         |   1 +
 767 files changed, 7277 insertions(+), 3528 deletions(-)


