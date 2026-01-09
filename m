Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5556632BF21;
	Fri,  9 Jan 2026 11:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959408; cv=none; b=aaRWH5e4HPfRdEEf6kd6vlqMH0MOEnfcmauy5c3dsT4WqE7caJKlksdnB2O0nksJHCk/FPQdsXPua1/HKJKVGaR3rDdJ/7LVRSNphm7mT7MN2RgzaHgNRByZpJTXqY7NTDtUbd33o6tpKkW2UQAf37qJbVA3egFfeR3F7AENeWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959408; c=relaxed/simple;
	bh=zzAvaDLn21xTxi9+QRuPWAYu3gwlttt2HpM8SV10prA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=E8zmzT/2MFNKvf876hxzGRAkPTwKidqiS6h+HRa8+zqMiggQnRQztBtzp3+eBa/Tpnu7U0n9y+uagGcStlPg3F9ASzHZ5WoZl5Mw3lVXJdl5x4hZDXur1sgD3lvW6TyGzcEe74v8Ls3TBFk3Ro5lZFkizztjQD3lO2hrdLLNW+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/YIBSLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/YIBSLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9F7C4CEF1;
	Fri,  9 Jan 2026 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959407;
	bh=zzAvaDLn21xTxi9+QRuPWAYu3gwlttt2HpM8SV10prA=;
	h=From:To:Cc:Subject:Date:From;
	b=b/YIBSLWWSUz/WWkXiPFzMI4nYFz8E3sd+ZsY0eG+09jCZ0+dO88mievr+k7JWx8c
	 /ImYfqq/uHxICXXVtRvQDEDMTmWAcfdnmyN+d9r3NvMYGC5yPl7pltwgWhr4+u9NgE
	 Splj25L3dXK1tm+3bz7Erk1md9GAvKgxCIRzjCR8=
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
Subject: [PATCH 6.6 000/737] 6.6.120-rc1 review
Date: Fri,  9 Jan 2026 12:32:19 +0100
Message-ID: <20260109112133.973195406@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.120-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.120-rc1
X-KernelTest-Deadline: 2026-01-11T11:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.120 release.
There are 737 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.120-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.120-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "iommu/amd: Skip enabling command/event buffers for kdump"

Amitai Gottlieb <amitaig@hailo.ai>
    firmware: arm_scmi: Fix unused notifier-block in unregister

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: fix tty_port_tty_*hangup() kernel-doc

Ming Lei <ming.lei@redhat.com>
    blk-mq: setup queue ->tag_set before initializing hctx

Sean Nyekjaer <sean@geanix.com>
    pwm: stm32: Always program polarity

Alexis Lothoré <alexis.lothore@bootlin.com>
    net: stmmac: make sure that ptp_rate is not 0 before configuring EST

Lizhi Xu <lizhi.xu@windriver.com>
    ext4: filesystems without casefold feature cannot be mounted with siphash

Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>
    virtio_console: fix order of fields cols and rows

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures in damon_test_update_monitoring_result()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failure on damon_test_set_attrs()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures in damon_test_ops_registration()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures in damon_test_set_regions()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures on damos_test_filter_out()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle memory alloc failure from damon_test_aggregate()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_regions_of()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle memory failure from damon_test_target()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures on damon_test_merge_two()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures on dasmon_test_merge_regions_of()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_at()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle allocation failures in damon_test_regions()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failres in damon_test_new_filter()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/vaddr-kunit: handle alloc failures on damon_test_split_evenly_succ()

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix the failure of ibv_query_device() and ibv_query_device_ex() tests

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Remove the direct link to net_device

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    net: Allow to use SMP threads for backlog NAPI.

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    net: Remove conditional threaded-NAPI wakeup based on task state.

Peter Zijlstra (Intel) <peterz@infradead.org>
    sched/fair: Proportional newidle balance

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Small cleanup to update_newidle_cost()

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Small cleanup to sched_balance_newidle()

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/core: Fix "KASAN: slab-use-after-free Read in ib_register_device" problem

SeongJae Park <sj@kernel.org>
    mm/damon/tests/vaddr-kunit: handle alloc failures on damon_do_test_apply_three_regions()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/vaddr-kunit: handle alloc failures in damon_test_split_evenly_fail()

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: SVM: Fix redundant updates of LBR MSR intercepts

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: nSVM: Fix and simplify LBR virtualization handling with nested

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: nSVM: Always recalculate LBR MSR intercepts in svm_update_lbrv()

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: SVM: Introduce svm_recalc_lbr_msr_intercepts()

Chen-Yu Tsai <wenst@chromium.org>
    media: mediatek: vcodec: Use spinlock for context list protection lock

Ming Qian <ming.qian@oss.nxp.com>
    media: amphion: Remove vpu_vb_is_codecconfig

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: amphion: Make some vpu_v4l2 functions static

Ming Qian <ming.qian@oss.nxp.com>
    media: amphion: Add a frame flush mode for decoder

Dongli Zhang <dongli.zhang@oracle.com>
    KVM: nVMX: Immediately refresh APICv controls as needed on nested VM-Exit

David Hildenbrand <david@redhat.com>
    powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages

David Hildenbrand <david@redhat.com>
    mm/balloon_compaction: convert balloon_page_delete() to balloon_page_finalize()

David Hildenbrand <david@redhat.com>
    mm/balloon_compaction: we cannot have isolated pages in the balloon list

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: verisilicon: Fix CPU stalls on G2 bus error

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    media: verisilicon: g2: Use common helpers to compute chroma and mv offsets

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    media: verisilicon: Store chroma and motion vectors offset

Chao Yu <chao@kernel.org>
    f2fs: fix to detect recoverable inode during dryrun of find_fsync_dnodes()

Chao Yu <chao@kernel.org>
    f2fs: use global inline_xattr_slab instead of per-sb slab cache

Chao Yu <chao@kernel.org>
    f2fs: fix to propagate error from f2fs_enable_checkpoint()

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid updating compression context during writeback

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: drop inode from the donation list when the last file is closed

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: keep POSIX_FADV_NOREUSE ranges

Chao Yu <chao@kernel.org>
    f2fs: remove unused GC_FAILURE_PIN

Gyeyoung Baek <gye976@gmail.com>
    genirq/irq_sim: Initialize work context pointers properly

Jingbo Xu <jefflexu@linux.alibaba.com>
    mm: fix arithmetic for max_prop_frac when setting max_ratio

Jingbo Xu <jefflexu@linux.alibaba.com>
    mm: fix arithmetic for bdi min_ratio

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: fix kasan out-of-bounds warning in sja1105_table_delete_entry()

Dong Chenchen <dongchenchen2@huawei.com>
    page_pool: Fix use-after-free in page_pool_recycle_in_ring

Florian Westphal <fw@strlen.de>
    xfrm: state: fix out-of-bounds read during lookup

Ye Bin <yebin10@huawei.com>
    ext4: fix out-of-bound read in ext4_xattr_inode_dec_ref_all()

Ye Bin <yebin10@huawei.com>
    ext4: introduce ITAIL helper

Gabriel Krisman Bertazi <krisman@suse.de>
    ext4: fix error message when rejecting the default hash

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/64s/radix/kfence: map __kfence_pool at page granularity

Chenghao Duan <duanchenghao@kylinos.cn>
    LoongArch: Refactor register restoration in ftrace_common_return

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: Fix null pointer deref in dcn20_resource.c

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    net: Remove RTNL dance for SIOCBRADDIF and SIOCBRDELIF.

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Apply the link chain quirk on NEC isoc endpoints

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: move link chain bit quirk checks into one helper function.

Łukasz Bartosik <ukaszb@chromium.org>
    xhci: dbgtty: fix device unregister: fixup

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: introduce and use tty_port_tty_vhangup() helper

Kory Maincent (TI.com) <kory.maincent@bootlin.com>
    drm/tilcdc: Fix removal actions in case of failed probe

Philipp Stanner <pstanner@redhat.com>
    drm/tilcdc: request and mapp iomem with devres

Johan Hovold <johan@kernel.org>
    drm/mediatek: Fix probe resource leaks

Johan Hovold <johan@kernel.org>
    drm/mediatek: Fix probe memory leak

Natalie Vock <natalie.vock@gmx.de>
    drm/amdgpu: Forward VMID reservation errors

Paolo Abeni <pabeni@redhat.com>
    mptcp: ensure context reset on disconnect()

Miaoqian Lin <linmq006@gmail.com>
    net: phy: mediatek: fix nvmem cell reference leak in mt798x_phy_calibration

Wentao Liang <vulab@iscas.ac.cn>
    pmdomain: imx: Fix reference count leak in imx_gpc_probe()

Rob Herring <robh@kernel.org>
    pmdomain: Use device_get_match_data()

Bijan Tabatabai <bijan311@gmail.com>
    mm: consider non-anon swap cache folios in folio_expected_ref_count()

David Hildenbrand <david@redhat.com>
    mm: simplify folio_expected_ref_count()

Jouni Malinen <jouni.malinen@oss.qualcomm.com>
    wifi: mac80211: Discard Beacon frames to non-broadcast address

NeilBrown <neil@brown.name>
    lockd: fix vfs_test_lock() calls

Paolo Abeni <pabeni@redhat.com>
    mptcp: fallback earlier on simult connection

Jim Quinlan <james.quinlan@broadcom.com>
    PCI: brcmstb: Fix disabling L0s capability

Joanne Koong <joannelkoong@gmail.com>
    fuse: fix readahead reclaim deadlock

Joshua Rogers <linux@joshua.hu>
    svcrdma: bound check rq_pages index in inline path

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: dts: microchip: sama7g5: fix uart fifo size to 32

Askar Safin <safinaskar@gmail.com>
    gpiolib: acpi: Add quirk for Dell Precision 7780

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clear SECLABEL in the suppattr_exclcreat bitmap

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential deadlock

Chao Yu <chao@kernel.org>
    f2fs: use f2fs_err_ratelimited() to avoid redundant logs

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ignore unknown endpoint flags

Seunghwan Baek <sh8267.baek@samsung.com>
    scsi: ufs: core: Add ufshcd_update_evt_hist() for UFS suspend error

Johan Hovold <johan@kernel.org>
    usb: ohci-nxp: fix device leak on probe failure

Zhang Zekun <zhangzekun11@huawei.com>
    usb: ohci-nxp: Use helper function devm_clk_get_enabled()

xu xin <xu.xin16@zte.com.cn>
    mm/ksm: fix exec/fork inheritance support for prctl

Sven Eckelmann (Plasma Cloud) <se@simonwunderlich.de>
    wifi: mt76: Fix DTS power-limits on little endian systems

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't rewrite ret from inode_permission

Alexey Velichayshiy <a.velichayshiy@ispras.ru>
    gfs2: fix freeze error handling

Ye Bin <yebin10@huawei.com>
    jbd2: fix the inconsistency between checksum and data in memory for journal sb

Fedor Pchelkin <pchelkin@ispras.ru>
    ext4: fix string copying in parse_apply_sb_mount_options()

Denis Arefev <arefev@swemel.ru>
    ALSA: hda: cs35l41: Fix NULL pointer dereference in cs35l41_hda_read_acpi()

Junrui Luo <moonafterrain@outlook.com>
    ALSA: wavefront: Clear substream pointers on close

Takashi Iwai <tiwai@suse.de>
    ALSA: wavefront: Use guard() for spin locks

Junrui Luo <moonafterrain@outlook.com>
    ALSA: wavefront: Fix integer overflow in sample size validation

Takashi Iwai <tiwai@suse.de>
    ALSA: wavefront: Use standard print API

Kuniyuki Iwashima <kuniyu@google.com>
    mptcp: Initialise rcv_mss before calling tcp_send_active_reset() in mptcp_do_fastclose().

Jarkko Sakkinen <jarkko.sakkinen@opinsys.com>
    tpm: Cap the number of PCR banks

Ming Lei <ming.lei@redhat.com>
    blk-mq: add helper for checking if one CPU is mapped to specified hctx

Johan Hovold <johan@kernel.org>
    usb: gadget: lpc32xx_udc: fix clock imbalance in error path

Lyude Paul <lyude@redhat.com>
    drm/nouveau/dispnv50: Don't call drm_atomic_get_crtc_state() in prepare_fb

Krzysztof Niemiec <krzysztof.niemiec@intel.com>
    drm/i915/gem: Zero-initialize the eb.vma array in i915_gem_do_execbuffer

Nikolay Kuratov <kniv@yandex-team.ru>
    drm/msm/dpu: Add missing NULL pointer check for pingpong interface

René Rebe <rene@exactco.de>
    drm/mgag200: Fix big-endian support

Simon Richter <Simon.Richter@hogyros.de>
    drm/ttm: Avoid NULL pointer deref for evicted BOs

Miaoqian Lin <linmq006@gmail.com>
    drm/mediatek: Fix device node reference leak in mtk_dp_dt_parse()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/gma500: Remove unused helper psb_fbdev_fb_setcolreg()

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix out of bound IO access in a6xx_get_gmu_registers

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu: add missing lock to amdgpu_ttm_access_memory_sdma

Xiaolei Wang <xiaolei.wang@windriver.com>
    net: macb: Relocate mog_init_rings() callback from macb_mac_link_up() to macb_open()

Deepanshu Kartikey <kartikey406@gmail.com>
    net: nfc: fix deadlock between nfc_unregister_device and rfkill_fop_write

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    net: usb: sr9700: fix incorrect command used to write single register

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    nfsd: Drop the client reference in client_states_open()

Hengqi Chen <hengqi.chen@gmail.com>
    LoongArch: BPF: Sign extend kfunc call arguments

Hengqi Chen <hengqi.chen@gmail.com>
    LoongArch: BPF: Zero-extend bpf_tail_call() index

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    fjes: Add missing iounmap in fjes_hw_init()

Guangshuo Li <lgs201920130244@gmail.com>
    e1000: fix OOB in e1000_tbi_should_accept()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cm: Fix leaking the multicast GID table reference

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/core: Check for the presence of LS_NLA_TYPE_DGID correctly

Chenghao Duan <duanchenghao@kylinos.cn>
    samples/ftrace: Adjust LoongArch register restore order in direct calls

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/mm/page_owner_sort: fix timestamp comparison for stable sorting

Rong Zhang <i@rong.moe>
    x86/microcode/AMD: Fix Entrysign revision check for Zen5/Strix Halo

Matthew Wilcox (Oracle) <willy@infradead.org>
    idr: fix idr_alloc() returning an ID out of range

Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
    kasan: refactor pcpu kasan vmalloc unpoison

H. Peter Anvin <hpa@zytor.com>
    compiler_types.h: add "auto" as a macro for "__auto_type"

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Use unsigned long for _end and _text

WangYuli <wangyl5933@chinaunicom.cn>
    LoongArch: Use __pmd()/__pte() for swap entry conversions

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix build errors for CONFIG_RANDSTRUCT

Qiang Ma <maqianga@uniontech.com>
    LoongArch: Correct the calculation logic of thread_count

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Add new PCI ID for pci_fixup_vgadev()

Haoxiang Li <haoxiang_li2024@163.com>
    media: mediatek: vcodec: Fix a reference leak in mtk_vcodec_fw_vpu_init()

Duoming Zhou <duoming@zju.edu.cn>
    media: i2c: adv7842: Remove redundant cancel_delayed_work in probe

Duoming Zhou <duoming@zju.edu.cn>
    media: i2c: ADV7604: Remove redundant cancel_delayed_work in probe

Ming Qian <ming.qian@oss.nxp.com>
    media: amphion: Cancel message work before releasing the VPU core

Johan Hovold <johan@kernel.org>
    media: vpif_display: fix section mismatch

Johan Hovold <johan@kernel.org>
    media: vpif_capture: fix section mismatch

Haotian Zhang <vulab@iscas.ac.cn>
    media: videobuf2: Fix device reference leak in vb2_dc_alloc error path

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: verisilicon: Protect G2 HEVC decoder against invalid DPB index

Duoming Zhou <duoming@zju.edu.cn>
    media: TDA1997x: Remove redundant cancel_delayed_work in probe

Marek Szyprowski <m.szyprowski@samsung.com>
    media: samsung: exynos4-is: fix potential ABBA deadlock on init

Miaoqian Lin <linmq006@gmail.com>
    media: renesas: rcar_drif: fix device node reference leak in rcar_drif_bond_enabled

Ivan Abramov <i.abramov@mt-integration.ru>
    media: msp3400: Avoid possible out-of-bounds array accesses in msp3400c_thread()

Haotian Zhang <vulab@iscas.ac.cn>
    media: cec: Fix debugfs leak on bus_register() failure

René Rebe <rene@exactco.de>
    fbdev: tcx.c fix mem_map to correct smem_start offset

Thorsten Blum <thorsten.blum@linux.dev>
    fbdev: pxafb: Fix multiple clamped values in pxafb_adjust_timing

Rene Rebe <rene@exactco.de>
    fbdev: gbefb: fix to use physical address instead of dma address

Mikulas Patocka <mpatocka@redhat.com>
    dm-bufio: align write boundary on physical block size

Uladzislau Rezki (Sony) <urezki@gmail.com>
    dm-ebs: Mark full buffer dirty even on partial write

Mahesh Rao <mahesh.rao@altera.com>
    firmware: stratix10-svc: Add mutex in stratix10 memory management

Ivan Abramov <i.abramov@mt-integration.ru>
    media: adv7842: Avoid possible out-of-bounds array accesses in adv7842_cp_log_status()

David Hildenbrand <david@redhat.com>
    powerpc/pseries/cmm: call balloon_devinfo_init() also without CONFIG_BALLOON_COMPACTION

Sven Schnelle <svens@stackframe.org>
    parisc: entry: set W bit for !compat tasks in syscall_restore_rfi()

Sven Schnelle <svens@stackframe.org>
    parisc: entry.S: fix space adjustment on interruption for 64-bit userspace

Haotian Zhang <vulab@iscas.ac.cn>
    media: rc: st_rc: Fix reset control resource leak

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mfd: max77620: Fix potential IRQ chip conflict when probing two devices

Johan Hovold <johan@kernel.org>
    mfd: altera-sysmgr: Fix device leak on sysmgr regmap lookup

Nathan Chancellor <nathan@kernel.org>
    clk: samsung: exynos-clkout: Assign .num before accessing .hws

Christian Hitz <christian.hitz@bbv.ch>
    leds: leds-lp50xx: Enable chip before any communication

Christian Hitz <christian.hitz@bbv.ch>
    leds: leds-lp50xx: LP5009 supports 3 modules for a total of 9 LEDs

Christian Hitz <christian.hitz@bbv.ch>
    leds: leds-lp50xx: Allow LED 0 to be added to module bank

Donet Tom <donettom@linux.ibm.com>
    powerpc/64s/slb: Fix SLB multihit issue during SLB preload

Dave Vasilevsky <dave@vasilevsky.ca>
    powerpc, mm: Fix mprotect on book3s 32-bit

Siddharth Vadapalli <s-vadapalli@ti.com>
    arm64: dts: ti: k3-j721e-sk: Fix pinmux for pin Y1 used by power regulator

Lukas Wunner <lukas@wunner.de>
    PCI/PM: Reinstate clearing state_saved in legacy and !PM codepaths

Hans de Goede <johannes.goede@oss.qualcomm.com>
    HID: logitech-dj: Remove duplicate error logging

Lu Baolu <baolu.lu@linux.intel.com>
    iommu: disable SVA when CONFIG_X86 is set

Johan Hovold <johan@kernel.org>
    iommu/tegra: fix device leak on probe_device()

Johan Hovold <johan@kernel.org>
    iommu/sun50i: fix device leak on of_xlate()

Johan Hovold <johan@kernel.org>
    iommu/qcom: fix device leak on of_xlate()

Johan Hovold <johan@kernel.org>
    iommu/omap: fix device leaks on probe_device()

Johan Hovold <johan@kernel.org>
    iommu/mediatek: fix device leak on of_xlate()

Johan Hovold <johan@kernel.org>
    iommu/mediatek-v1: fix device leaks on probe()

Johan Hovold <johan@kernel.org>
    iommu/mediatek-v1: fix device leak on probe_device()

Johan Hovold <johan@kernel.org>
    iommu/ipmmu-vmsa: fix device leak on of_xlate()

Johan Hovold <johan@kernel.org>
    iommu/exynos: fix device leak on of_xlate()

Johan Hovold <johan@kernel.org>
    iommu/apple-dart: fix device leak on of_xlate()

Jinhui Guo <guojinhui.liam@bytedance.com>
    iommu/amd: Fix pci_segment memleak in alloc_pci_segment()

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: qdsp6: q6asm-dai: set 10 ms period and buffer alignment.

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6adm: the the copp device only during last instance

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6asm-dai: perform correct state check before closing

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6apm-dai: set flags to reflect correct operation of appl_ptr

Johan Hovold <johan@kernel.org>
    ASoC: stm32: sai: fix OF node leak on probe

Johan Hovold <johan@kernel.org>
    ASoC: stm32: sai: fix clk prepare imbalance on probe failure

Johan Hovold <johan@kernel.org>
    ASoC: stm32: sai: fix device leak on probe

Matthew Wilcox (Oracle) <willy@infradead.org>
    ntfs: Do not overwrite uptodate pages

Yipeng Zou <zouyipeng@huawei.com>
    selftests/ftrace: traceonoff_triggers: strip off names

Cong Zhang <cong.zhang@oss.qualcomm.com>
    blk-mq: skip CPU offline notify on unmapped hctx

Ming Lei <ming.lei@redhat.com>
    blk-mq: don't schedule block kworker on isolated CPUs

Thomas Fourier <fourier.thomas@gmail.com>
    RDMA/bnxt_re: fix dma_free_coherent() pointer

Honggang LI <honggangli@163.com>
    RDMA/rtrs: Fix clt_path::max_pages_per_mr calculation

Zilin Guan <zilin@seu.edu.cn>
    ksmbd: Fix memory leak in get_file_all_info()

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix to use correct page size for PDE table

Alok Tiwari <alok.a.tiwari@oracle.com>
    RDMA/bnxt_re: Fix IB_SEND_IP_CSUM handling in post_send

Alok Tiwari <alok.a.tiwari@oracle.com>
    RDMA/bnxt_re: Fix incorrect BAR check in bnxt_qplib_map_creq_db()

Jang Ingyu <ingyujang25@korea.ac.kr>
    RDMA/core: Fix logic error in ib_get_gids_from_rdma_hdr()

Michael Margolin <mrgolin@amazon.com>
    RDMA/efa: Remove possible negative shift

Michal Schmidt <mschmidt@redhat.com>
    RDMA/irdma: avoid invalid read in irdma_net_event

Pwnverse <stanksal@purdue.edu>
    net: rose: fix invalid array index in rose_kill_by_device()

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix reference count leak when using error routes with nexthop objects

Will Rosenberg <whrosenb@asu.edu>
    ipv6: BUG() in pskb_expand_head() as part of calipso_skbuff_setattr()

Wei Fang <wei.fang@nxp.com>
    net: stmmac: fix the crash issue for zero copy XDP_TX action

Anshumali Gaur <agaur@marvell.com>
    octeontx2-pf: fix "UBSAN: shift-out-of-bounds error"

Junrui Luo <moonafterrain@outlook.com>
    platform/x86: hp-bioscfg: Fix out-of-bounds array access in ACPI package parsing

Bagas Sanjaya <bagasdotme@gmail.com>
    net: bridge: Describe @tunnel_hash member in net_bridge_vlan_group struct

Deepanshu Kartikey <kartikey406@gmail.com>
    net: usb: asix: validate PHY address before use

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: skip multicast entries for fdb_dump()

Thomas Fourier <fourier.thomas@gmail.com>
    firewire: nosy: Fix dma_free_coherent() size

Andrew Morton <akpm@linux-foundation.org>
    genalloc.h: fix htmldocs warning

Yeoreum Yun <yeoreum.yun@arm.com>
    smc91x: fix broken irq-context in PREEMPT_RT

Alice C. Munduruca <alice.munduruca@canonical.com>
    selftests: net: fix "buffer overflow detected" for tap.c

Deepakkumar Karn <dkarn@redhat.com>
    net: usb: rtl8150: fix memory leak on usb_submit_urb() failure

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: reset retries and mode on RX adapt failures

Jiri Pirko <jiri@resnulli.us>
    team: fix check for port enabled in team_queue_override_port_prio_changed()

Junrui Luo <moonafterrain@outlook.com>
    platform/x86: ibm_rtl: fix EBDA signature search pointer arithmetic

Thomas Fourier <fourier.thomas@gmail.com>
    platform/x86: msi-laptop: add missing sysfs_remove_group()

Eric Dumazet <edumazet@google.com>
    ip6_gre: make ip6gre_header() robust

Toke Høiland-Jørgensen <toke@redhat.com>
    net: openvswitch: Avoid needlessly taking the RTNL on vport destroy

Jacky Chou <jacky_chou@aspeedtech.com>
    net: mdio: aspeed: add dummy read to avoid read-after-write issue

Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
    Bluetooth: btusb: revert use of devm_kzalloc in btusb

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: seqiv - Do not use req->iv after crypto_aead_encrypt

Kohei Enju <enjuk@amazon.com>
    iavf: fix off-by-one issues in iavf_config_rss_reg()

Przemyslaw Korba <przemyslaw.korba@intel.com>
    i40e: fix scheduling in set_rx_mode

Aloka Dixit <aloka.dixit@oss.qualcomm.com>
    wifi: mac80211: do not use old MBSSID elements

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: cfg80211: sme: store capped length in __cfg80211_connect_result()

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw88: limit indirect IO under powered off for RTL8822CS

Johan Hovold <johan@kernel.org>
    iommu/mediatek: fix use-after-free on probe deferral

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: dts: microchip: sama5d2: fix spi flexcom fifo size to 32

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (w83l786ng) Convert macros to functions to avoid TOCTOU

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (w83791d) Convert macros to functions to avoid TOCTOU

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (max16065) Use local variable to avoid TOCTOU

Ma Ke <make24@iscas.ac.cn>
    i2c: amd-mp2: fix reference leak in MP2 PCI device

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    platform/x86: intel: chtwc_int33fe: don't dereference swnode args

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    rpmsg: glink: fix rpmsg device leak

Johan Hovold <johan@kernel.org>
    soc: amlogic: canvas: fix device leak on lookup

Johan Hovold <johan@kernel.org>
    soc: qcom: ocmem: fix device leak on lookup

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix fixed array of synthetic event

Johan Hovold <johan@kernel.org>
    amba: tegra-ahb: Fix device leak on SMMU enable

Guangshuo Li <lgs201920130244@gmail.com>
    crypto: caam - Add check for kcalloc() in test_len()

Shivani Agarwal <shivani.agarwal@broadcom.com>
    crypto: af_alg - zero initialize memory allocated via sock_kmalloc

Adrian Moreno <amorenoz@redhat.com>
    selftests: openvswitch: Fix escape chars in regexp.

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: Use GFP_ATOMIC in dc_create_plane_state()

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: correctly handle io_poll_add() return value on update

Wentao Guan <guanwentao@uniontech.com>
    gpio: regmap: Fix memleak in error path in gpio_regmap_register()

Sven Schnelle <svens@linux.ibm.com>
    s390/ipl: Clear SBP flag when bootprog is set

Filipe Manana <fdmanana@suse.com>
    btrfs: don't log conflicting inode if it's a dir moved in the current transaction

Nysal Jan K.A. <nysal@linux.ibm.com>
    powerpc/kexec: Enable SMT before waking offline CPUs

Joshua Rogers <linux@joshua.hu>
    SUNRPC: svcauth_gss: avoid NULL deref on zero length gss_token in gss_read_proxy_verf

Joshua Rogers <linux@joshua.hu>
    svcrdma: return 0 on success from svc_rdma_copy_inline_range

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    nfsd: Mark variable __maybe_unused to avoid W=1 build break

caoping <caoping@cmss.chinamobile.com>
    net/handshake: restore destructor on submit failure

Amir Goldstein <amir73il@gmail.com>
    fsnotify: do not generate ACCESS/MODIFY events on child for special files

René Rebe <rene@exactco.de>
    r8169: fix RTL8117 Wake-on-Lan in DASH mode

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Do not clear needs_force_resume with enabled runtime PM

Steven Rostedt <rostedt@goodmis.org>
    tracing: Do not register unsupported perf events

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    xfs: fix a memory leak in xfs_buf_item_init()

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Clear exit_code_hi in VMCB when synthesizing nested VM-Exits

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Set exit_code_hi to -1 when synthesizing SVM_EXIT_ERR (failed VMRUN)

Jim Mattson <jmattson@google.com>
    KVM: SVM: Mark VMCB_PERM_MAP as dirty on nested VMRUN

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: nSVM: Propagate SVM_EXIT_CR0_SEL_WRITE correctly for LMSW emulation

Jim Mattson <jmattson@google.com>
    KVM: SVM: Mark VMCB_NPT as dirty on nested VMRUN

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: nSVM: Avoid incorrect injection of SVM_EXIT_CR0_SEL_WRITE

fuqiang wang <fuqiang.wng@gmail.com>
    KVM: x86: Fix VM hard lockup after prolonged inactivity with periodic HV timer

fuqiang wang <fuqiang.wng@gmail.com>
    KVM: x86: Explicitly set new periodic hrtimer expiration in apic_timer_fn()

Sean Christopherson <seanjc@google.com>
    KVM: x86: WARN if hrtimer callback for periodic APIC timer fires with period=0

Ilya Dryomov <idryomov@gmail.com>
    libceph: make decode_pool() more resilient against corrupted osdmaps

Helge Deller <deller@gmx.de>
    parisc: Do not reprogram affinitiy on ASP chip

Zhichi Lin <zhichi.lin@vivo.com>
    scs: fix a wrong parameter in __scs_magic

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_ishtp: Fix UAF after unbinding driver

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: Don't clear async #PF queue when CR0.PG is disabled (e.g. on #SMI)

Prithvi Tambewagh <activprithvi@gmail.com>
    ocfs2: fix kernel BUG in ocfs2_find_victim_chain

Jeongjun Park <aha310510@gmail.com>
    media: vidtv: initialize local pointers upon transfer of memory ownership

Alison Schofield <alison.schofield@intel.com>
    tools/testing/nvdimm: Use per-DIMM device handle

Chao Yu <chao@kernel.org>
    f2fs: fix return value of f2fs_recover_fsync_data()

Xiaole He <hexiaole1994@126.com>
    f2fs: fix age extent cache insertion skip on counter overflow

Deepanshu Kartikey <kartikey406@gmail.com>
    f2fs: invalidate dentry cache on failed whiteout creation

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid updating zero-sized extent in extent cache

Jan Prusakowski <jprusakowski@google.com>
    f2fs: ensure node page reads complete before f2fs_put_super() finishes

Andrey Vatoropin <a.vatoropin@crpt.ru>
    scsi: target: Reset t_task_cdb pointer in error case

Dai Ngo <dai.ngo@oracle.com>
    NFSD: use correct reservation type in nfsd4_scsi_fence_client

Junrui Luo <moonafterrain@outlook.com>
    scsi: aic94xx: fix use-after-free in device removal path

Tony Battersby <tonyb@cybernetics.com>
    scsi: Revert "scsi: qla2xxx: Perform lockless command completion in abort path"

Miaoqian Lin <linmq006@gmail.com>
    cpufreq: nforce2: fix reference count leak in nforce2

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: teo: Drop misguided target residency check

Ma Ke <make24@iscas.ac.cn>
    intel_th: Fix error handling in intel_th_output_open

Tianchu Chen <flynnnchen@tencent.com>
    char: applicom: fix NULL pointer dereference in ac_ioctl

Haoxiang Li <haoxiang_li2024@163.com>
    usb: renesas_usbhs: Fix a resource leak in usbhs_pipe_malloc()

Udipto Goswami <udipto.goswami@oss.qualcomm.com>
    usb: dwc3: keep susphy enabled during exit to avoid controller faults

Miaoqian Lin <linmq006@gmail.com>
    usb: dwc3: of-simple: fix clock resource leak in dwc3_of_simple_probe

Johan Hovold <johan@kernel.org>
    usb: phy: isp1301: fix non-OF device reference imbalance

Duoming Zhou <duoming@zju.edu.cn>
    usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal

Ma Ke <make24@iscas.ac.cn>
    USB: lpc32xx_udc: Fix error handling in probe

Johan Hovold <johan@kernel.org>
    phy: broadcom: bcm63xx-usbh: fix section mismatches

Colin Ian King <colin.i.king@gmail.com>
    media: pvrusb2: Fix incorrect variable used in trace message

Jeongjun Park <aha310510@gmail.com>
    media: dvb-usb: dtv5100: fix out-of-bounds in dtv5100_i2c_msg()

Chen Changcheng <chenchangcheng@kylinos.cn>
    usb: usb-storage: Maintain minimal modifications to the bcdDevice range.

Paolo Abeni <pabeni@redhat.com>
    mptcp: avoid deadlock on fallback while reinjecting

Paolo Abeni <pabeni@redhat.com>
    mptcp: schedule rtx timer only after pushing data

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: v4l2-mem2mem: Fix outdated documentation

Byungchul Park <byungchul@sk.com>
    jbd2: use a weaker annotation in journal handling

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    jbd2: use a per-journal lock_class_key for jbd2_trans_commit_key

Baokun Li <libaokun1@huawei.com>
    ext4: align max orphan file size with e2fsprogs limit

Yongjian Sun <sunyongjian1@huawei.com>
    ext4: fix incorrect group number assertion in mb_check_buddy

Haibo Chen <haibo.chen@nxp.com>
    ext4: clear i_state_flags when alloc inode

Karina Yankevich <k.yankevich@omp.ru>
    ext4: xattr: fix null pointer deref in ext4_raw_inode()

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Fix uninitialized var in config-bisect.pl

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: fix mount failure for sparse runs in run_unpack()

Zheng Yejian <zhengyejian@huaweicloud.com>
    kallsyms: Fix wrong "big" kernel symbol type read from procfs

Rene Rebe <rene@exactco.de>
    floppy: fix for PAGE_SIZE != 4KB

Li Chen <chenl311@chinatelecom.cn>
    block: rate-limit capacity change info log

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Fix gendisk parent after copy pair swap

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: x86/blake2s: Fix 32-bit arg treated as 64-bit

Sarthak Garg <sarthak.garg@oss.qualcomm.com>
    mmc: sdhci-msm: Avoid early clock doubling during HS400 transition

Prithvi Tambewagh <activprithvi@gmail.com>
    io_uring: fix filename leak in __io_openat_prep()

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Fix a memory leak in tpm2_load_cmd

Zilin Guan <zilin@seu.edu.cn>
    cifs: Fix memory and information leak in smb3_reconfigure()

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: improve RCU read sections around vhost_vsock_get()

Dan Carpenter <dan.carpenter@linaro.org>
    block: rnbd-clt: Fix signedness bug in init_dev()

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    platform/x86/intel/hid: Add Dell Pro Rugged 10/12 tablet to VGBS DMI quirks

Daniel Wagner <wagi@kernel.org>
    nvme-fc: don't hold rport lock when putting ctrl

Jinhui Guo <guojinhui.liam@bytedance.com>
    i2c: designware: Disable SMBus interrupts to prevent storms from mis-configured firmware

Ian Rogers <irogers@google.com>
    libperf cpumap: Fix perf_cpu_map__max for an empty/NULL map

Wenhua Lin <Wenhua.Lin@unisoc.com>
    serial: sprd: Return -EPROBE_DEFER when uart clock is not ready

Chen Changcheng <chenchangcheng@kylinos.cn>
    usb: usb-storage: No additional quirks need to be added to the EL-R12 optical drive.

Hongyu Xie <xiehongyu1@kylinos.cn>
    usb: xhci: limit run_graceperiod for only usb 3.0 devices

Pei Xiao <xiaopei01@kylinos.cn>
    iio: adc: ti_am335x_adc: Limit step_avg to valid range for gcc complains

Mark Pearson <mpearson-lenovo@squebb.ca>
    usb: typec: ucsi: Handle incorrect num_connectors capability

Lizhi Xu <lizhi.xu@windriver.com>
    usbip: Fix locking bug in RT-enabled kernels

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix remount failure in different process environments

Encrow Thorne <jyc0019@gmail.com>
    reset: fix BIT macro reference

Li Qiang <liqiang01@kylinos.cn>
    via_wdt: fix critical boot hang due to unnamed resource allocation

Bernd Schubert <bschubert@ddn.com>
    fuse: Invalidate the page cache after FOPEN_DIRECT_IO write

Bernd Schubert <bschubert@ddn.com>
    fuse: Always flush the page cache before FOPEN_DIRECT_IO write

Tony Battersby <tonyb@cybernetics.com>
    scsi: qla2xxx: Use reinit_completion on mbx_intr_comp

Tony Battersby <tonyb@cybernetics.com>
    scsi: qla2xxx: Fix initiator mode with qlini_mode=exclusive

Tony Battersby <tonyb@cybernetics.com>
    scsi: qla2xxx: Fix lost interrupts with qlini_mode=disabled

Ben Collins <bcollins@kernel.org>
    powerpc/addnote: Fix overflow on 32-bit builds

Josua Mayer <josua@solid-run.com>
    clk: mvebu: cp110 add CLK_IGNORE_UNUSED to pcie_x10, pcie_x11 & pcie_x4

Matthias Schiffer <matthias.schiffer@tq-group.com>
    ti-sysc: allow OMAP2 and OMAP4 timers to be reserved on AM33xx

Peng Fan <peng.fan@nxp.com>
    firmware: imx: scu-irq: Init workqueue before request mbox channel

Jinhui Guo <guojinhui.liam@bytedance.com>
    ipmi: Fix __scan_channels() failing to rescan channels

Jinhui Guo <guojinhui.liam@bytedance.com>
    ipmi: Fix the race between __scan_channels() and deliver_response()

Shipei Qu <qu@darknavy.com>
    ALSA: usb-mixer: us16x08: validate meter packet indices

Haotian Zhang <vulab@iscas.ac.cn>
    ALSA: pcmcia: Fix resource leak in snd_pdacf_probe error path

Haotian Zhang <vulab@iscas.ac.cn>
    ALSA: vxpocket: Fix resource leak in vxpocket_probe error path

Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
    net/hsr: fix NULL pointer dereference in prp_get_untagged_frame()

Andrew Jeffery <andrew@codeconstruct.com.au>
    dt-bindings: mmc: sdhci-of-aspeed: Switch ref to sdhci-common.yaml

Jared Kangas <jkangas@redhat.com>
    mmc: sdhci-esdhc-imx: add alternate ARCH_S32 dependency to Kconfig

Christophe Leroy <christophe.leroy@csgroup.eu>
    spi: fsl-cpm: Check length parity before switching to 16 bit mode

Pengjie Zhang <zhangpengjie2@huawei.com>
    ACPI: CPPC: Fix missing PCC check for guaranteed_perf

Pengjie Zhang <zhangpengjie2@huawei.com>
    ACPI: PCC: Fix race condition by removing static qualifier

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_can_open(): fix error handling

Christoffer Sandberg <cs@tuxedo.de>
    Input: i8042 - add TUXEDO InfinityBook Max Gen10 AMD to i8042 quirk table

Junjie Cao <junjie.cao@intel.com>
    Input: ti_am335x_tsc - fix off-by-one error in wire_order validation

Ping Cheng <pinglinux@gmail.com>
    HID: input: map HID_GD_Z to ABS_DISTANCE for stylus/pen

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix buffer validation by including null terminator size in EA length

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: Fix refcount leak when invalid session is found on session lookup

Qianchang Zhao <pioooooooooip@gmail.com>
    ksmbd: skip lock-range check on equal size to avoid size==0 underflow

Thomas Fourier <fourier.thomas@gmail.com>
    block: rnbd-clt: Fix leaked ID in init_dev()

Anurag Dutta <a-dutta@ti.com>
    spi: cadence-quadspi: Fix clock disable on probe failure path

Juergen Gross <jgross@suse.com>
    x86/xen: Fix sparse warning in enlighten_pv.c

Brian Gerst <brgerst@gmail.com>
    x86/xen: Move Xen upcall handler

Marijn Suijten <marijn.suijten@somainline.org>
    drm/panel: sony-td4353-jdi: Enable prepare_prev_first

Haoxiang Li <haoxiang_li2024@163.com>
    MIPS: Fix a reference leak bug in ip22_check_gio()

Alexey Simakov <bigalex934@gmail.com>
    hwmon: (tmp401) fix overflow caused by default conversion rate value

Junrui Luo <moonafterrain@outlook.com>
    hwmon: (ibmpex) fix use-after-free in high/low store

Jian Shen <shenjian15@huawei.com>
    net: hns3: add VLAN id validation before using

Jian Shen <shenjian15@huawei.com>
    net: hns3: using the num_tqps to check whether tqp_index is out of range when vf get ring info from mbx

Jian Shen <shenjian15@huawei.com>
    net: hns3: using the num_tqps in the vf driver to apply for resources

Wei Fang <wei.fang@nxp.com>
    net: enetc: do not transmit redirected XDP frames when the link is down

Scott Mayhew <smayhew@redhat.com>
    net/handshake: duplicate handshake cancellations leak socket

Shay Drory <shayd@nvidia.com>
    net/mlx5: Serialize firmware reset with devlink

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Skip HotPlug check on sync reset using hot reset

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer, Handle escaped percent properly

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer, Validate format string parameters

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Drain firmware reset in shutdown callback

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: fw reset, clear reset requested on drain_fw_reset

Gal Pressman <gal@nvidia.com>
    ethtool: Avoid overflowing userspace buffer on stats query

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd/selftest: Check for overflow in IOMMU_TEST_OP_ADD_RESERVED

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: remove redundant chain validation on register store

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: allow loads only when register is initialized

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: pass context structure to nft_parse_register_load

Dan Carpenter <dan.carpenter@linaro.org>
    nfc: pn533: Fix error code in pn533_acr122_poweron_rdr()

Victor Nogueira <victor@mojatatu.com>
    net/sched: ets: Remove drr class from the active list if it changes to strict

Junrui Luo <moonafterrain@outlook.com>
    caif: fix integer underflow in cffrml_receive()

Slavin Liu <slavin452@gmail.com>
    ipvs: fix ipv4 null-ptr-deref in route error path

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_conncount: fix leaked ct in error paths

Alexey Simakov <bigalex934@gmail.com>
    broadcom: b44: prevent uninitialized value usage

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix middle attribute validation in push_nsh() action

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_mr: Fix use-after-free when updating multicast route stats

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_router: Fix neighbour use-after-free

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_router: Fix possible neighbour reference count leak

Dmitry Skorodumov <skorodumov.dmitry@huawei.com>
    ipvlan: Ignore PACKET_LOOPBACK in handle_mode_l2()

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: ets: Always remove class from active list before deleting in ets_qdisc_change

Wang Liang <wangliang74@huawei.com>
    netrom: Fix memory leak in nr_sendmsg()

Wei Fang <wei.fang@nxp.com>
    net: fec: ERR007885 Workaround for XDP TX path

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix use of bio_chain

Gongwei Li <ligongwei@kylinos.cn>
    Bluetooth: btusb: Add new VID/PID 13d3/3533 for RTL8821CE

Chingbin Li <liqb365@163.com>
    Bluetooth: btusb: Add new VID/PID 2b89/6275 for RTL8761BUV

Qianchang Zhao <pioooooooooip@gmail.com>
    ksmbd: vfs: fix race on m_flags in vfs_cache

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in ksmbd_tree_connect_put under concurrency

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: fix return value of smb2_ioctl()

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: fix remote evict for read-only filesystems

Qu Wenruo <wqu@suse.com>
    btrfs: scrub: always update btrfs_scrub_progress::last_physical

Hans de Goede <hansg@kernel.org>
    wifi: brcmfmac: Add DMI nvram filename quirk for Acer A1 840 tablet

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix volume corruption issue for generic/073

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    hfsplus: Verify inode mode when loading from disk

Yang Chenzhi <yang.chenzhi@vivo.com>
    hfsplus: fix missing hfs_bnode_get() in __hfs_bnode_create

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix volume corruption issue for generic/070

Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
    ntfs: set dummy blocksize to read boot_block when mounting

Mikhail Malyshev <mike.malyshev@gmail.com>
    kbuild: Use objtree for module signing key path

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Support timestamps prior to epoch

Song Liu <song@kernel.org>
    livepatch: Match old_sympos 0 and 1 in klp_find_func()

Aboorva Devarajan <aboorvad@linux.ibm.com>
    cpuidle: menu: Use residency threshold in polling state override decisions

Shuhao Fu <sfual@cse.ust.hk>
    cpufreq: s5pv210: fix refcount leak

Hal Feng <hal.feng@starfivetech.com>
    cpufreq: dt-platdev: Add JH7110S SOC to the allowlist

Sakari Ailus <sakari.ailus@linux.intel.com>
    ACPI: property: Use ACPI functions in acpi_graph_get_next_endpoint() only

Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
    ACPICA: Avoid walking the Namespace if start_node is NULL

Peter Zijlstra <peterz@infradead.org>
    x86/ptrace: Always inline trivial accessors

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Revert max_newidle_lb_cost bump

Doug Berger <opendmb@gmail.com>
    sched/deadline: only set free_cpus for online runqueues

George Kennedy <george.kennedy@oracle.com>
    perf/x86/amd: Check event before enable to avoid GPF

Joanne Koong <joannelkoong@gmail.com>
    iomap: account for unaligned end offsets when truncating read range

Joanne Koong <joannelkoong@gmail.com>
    iomap: adjust read range correctly for non-block-aligned positions

Deepanshu Kartikey <kartikey406@gmail.com>
    btrfs: fix memory leak of fs_devices in degraded seed device path

Ondrej Mosnacek <omosnace@redhat.com>
    bpf, arm64: Do not audit capability check in do_jit()

Qu Wenruo <wqu@suse.com>
    btrfs: fix a potential path leak in print_data_reloc_error()

Filipe Manana <fdmanana@suse.com>
    btrfs: do not skip logging new dentries when logging a new name

Xin Long <lucien.xin@gmail.com>
    ipv6: add exception routes to GC list in rt6_insert_exception

Eric Dumazet <edumazet@google.com>
    ipv6: avoid possible NULL deref in modify_prefix_route()

Junrui Luo <moonafterrain@outlook.com>
    ALSA: dice: fix buffer overflow in detect_stream_formats()

Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
    usb: phy: Initialize struct usb_phy list_head

Haotien Hsu <haotienh@nvidia.com>
    usb: gadget: tegra-xudc: Always reinitialize data toggle when clear halt

Thangaraj Samynathan <thangaraj.s@microchip.com>
    net: lan743x: Allocate rings outside ZONE_DMA

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Add machine_kexec_mask_interrupts() implementation

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix memory leak in ocfs2_merge_rec_left()

Dan Carpenter <dan.carpenter@linaro.org>
    irqchip/mchp-eic: Fix error code in mchp_eic_domain_alloc()

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

Mohamed Khalfella <mkhalfella@purestorage.com>
    block: Use RCU in blk_mq_[un]quiesce_tagset() instead of set->tag_list_lock

Liyuan Pang <pangliyuan1@huawei.com>
    ARM: 9464/1: fix input-only operand modification in load_unaligned_zeropad()

Junrui Luo <moonafterrain@outlook.com>
    ALSA: firewire-motu: add bounds check in put_user loop for DSP events

Haotian Zhang <vulab@iscas.ac.cn>
    rtc: gamecube: Check the return value of ioremap()

Andres J Rosa <andyrosa@gmail.com>
    ALSA: uapi: Fix typo in asound.h comment

Dave Kleikamp <dave.kleikamp@oracle.com>
    dma/pool: eliminate alloc_pages warning in atomic_pool_expand

Junrui Luo <moonafterrain@outlook.com>
    ALSA: firewire-motu: fix buffer overflow in hwdep read for DSP events

Israel Rukshin <israelr@nvidia.com>
    nvme-auth: use kvfree() for memory allocated with kvcalloc()

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
    NFS: Initialise verifiers for visible dentries in nfs_atomic_open()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Initialise verifiers for visible dentries in readdir and lookup

Armin Wolf <W_Armin@gmx.de>
    fs/nls: Fix utf16 to utf8 conversion

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Avoid changing nlink when file removes and attribute updates race

Eric Sandeen <sandeen@redhat.com>
    9p: fix cache/debug options printing in v9fs_show_options

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    fbdev: ssd1307fb: fix potential page leak in ssd1307fb_probe()

Haotian Zhang <vulab@iscas.ac.cn>
    pinctrl: single: Fix incorrect type for error return variable

Matthijs Kooijman <matthijs@stdin.nl>
    pinctrl: single: Fix PIN_CONFIG_BIAS_DISABLE handling

Namhyung Kim <namhyung@kernel.org>
    perf tools: Fix split kallsyms DSO counting

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_cake: Fix incorrect qlen reduction in cake_drop

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

Benjamin Poirier <bpoirier@nvidia.com>
    selftests: bonding: Add more missing config options

Jakub Kicinski <kuba@kernel.org>
    selftests: bonding: add missing build configs

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

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    resource: Reuse for_each_resource() macro

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

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: catpt: Fix error path in hw_params()

Alok Tiwari <alok.a.tiwari@oracle.com>
    vdpa/pds: use %pe for ERR_PTR() in event handler registration

Michael S. Tsirkin <mst@redhat.com>
    virtio: fix virtqueue_set_affinity() docs

Michael S. Tsirkin <mst@redhat.com>
    virtio: fix whitespace in virtio_config_ops

Michael S. Tsirkin <mst@redhat.com>
    virtio: fix typo in virtio_device_ready() comment

Alok Tiwari <alok.a.tiwari@oracle.com>
    virtio_vdpa: fix misleading return in void function

Yongjian Sun <sunyongjian1@huawei.com>
    ext4: improve integrity checking in __mb_check_buddy by enhancing order-0 validation

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: remove unused return value of __mb_check_buddy

Kevin Brodsky <kevin.brodsky@arm.com>
    ublk: prevent invalid access with DEBUG

Caleb Sander Mateos <csander@purestorage.com>
    ublk: complete command synchronously on error

Ming Lei <ming.lei@redhat.com>
    ublk: make sure io cmd handled in submitter task context

René Rebe <rene@exactco.de>
    ACPI: processor_core: fix map_x2apic_id for amd-pstate on am4

Haotian Zhang <vulab@iscas.ac.cn>
    hwmon: sy7636a: Fix regulator_enable resource leak on error path

Dan Carpenter <dan.carpenter@linaro.org>
    drm/amd/display: Fix logical vs bitwise bug in get_embedded_panel_info_v2_1()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_xcvr: clear the channel status control memory

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Do not directly rely on IB_PD_UNSAFE_GLOBAL_RKEY

Sindhu Devale <sindhu.devale@intel.com>
    RDMA/irdma: Add support to re-register a memory region

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

Timur Tabi <ttabi@nvidia.com>
    drm/nouveau: restrict the flush page to a 32-bit address

Shawn Lin <shawn.lin@rock-chips.com>
    PCI: dwc: Fix wrong PORT_LOGIC_LTSSM_STATE_MASK definition

Filipe Manana <fdmanana@suse.com>
    btrfs: fix leaf leak in an error path in btrfs_del_items()

Jianglei Nie <niejianglei2021@163.com>
    staging: fbtft: core: fix potential memory leak in fbtft_probe_common()

Dinh Nguyen <dinguyen@kernel.org>
    firmware: stratix10-svc: fix make htmldocs warning for stratix10_svc

Zilin Guan <zilin@seu.edu.cn>
    mt76: mt7615: Fix memory leak in mt7615_mcu_wtbl_sta_add()

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix the inline size for GenP7 devices

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

Seungjin Bae <eeodqql09@gmail.com>
    wifi: rtl818x: rtl8187: Fix potential buffer underflow in rtl8187_rx_cb()

Chen Ridong <chenridong@huawei.com>
    cpuset: Treat cpusets in attaching as populated

Alexander Dahl <ada@thorsis.com>
    net: phy: adin1100: Fix software power-down ready condition

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    phy: renesas: rcar-gen3-usb2: Fix an error handling path in rcar_gen3_phy_usb2_probe()

Haotian Zhang <vulab@iscas.ac.cn>
    mfd: mt6358-irq: Fix missing irq_domain_remove() in error path

Haotian Zhang <vulab@iscas.ac.cn>
    mfd: mt6397-irq: Fix missing irq_domain_remove() in error path

Chien Wong <m@xv97.com>
    wifi: mac80211: fix CMAC functions not handling errors

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: remove RX_DROP_UNUSABLE

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

Kui-Feng Lee <thinker.li@gmail.com>
    net/ipv6: Remove expired routes with a separated list of routes.

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

Jose Fernandez <josef@netflix.com>
    bpf: Improve program stats run-time calculation

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: rtl818x: Fix potential memory leaks in rtl8180_init_rx_ring()

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/a2xx: stop over-complaining about the legacy firmware

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

Zheng Qixing <zhengqixing@huawei.com>
    nbd: defer config unlock in nbd_genl_connect

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: cw1200: Fix potential memory leak in cw1200_bh_rx_helper()

Long Li <leo.lilong@huawei.com>
    macintosh/mac_hid: fix race condition in mac_hid_toggle_emumouse

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Fix unpaired stwcx. on interrupt exit

Gautham R. Shenoy <gautham.shenoy@amd.com>
    cpufreq/amd-pstate: Call cppc_set_auto_sel() only for online CPUs

Bean Huo <beanhuo@micron.com>
    scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_string_desc()

Edward Adam Davis <eadavis@qq.com>
    ntfs3: init run lock for extend inode

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: stm32: stm32mp157c-phycore: Fix STMPE811 touchscreen node properties

Ma Ke <make24@iscas.ac.cn>
    RDMA/rtrs: server: Fix error handling in get_or_create_srv

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    dt-bindings: PCI: amlogic: Fix the register name of the DBI region

Johan Hovold <johan@kernel.org>
    staging: most: remove broken i2c driver

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    staging: most: i2c: Drop explicit initialization of struct i2c_device_id::driver_data to 0

Mike McGowen <mike.mcgowen@microchip.com>
    scsi: smartpqi: Fix device resources accessed after device removal

Haotian Zhang <vulab@iscas.ac.cn>
    scsi: stex: Fix reboot_notifier leak in probe error path

Zheng Qixing <zhengqixing@huawei.com>
    nbd: defer config put in recv_work

Gabor Juhos <j4g8y7@gmail.com>
    regulator: core: disable supply if enabling main regulator fails

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Correct large PEBS flag check

Zhang Yi <yi.zhang@huawei.com>
    ext4: correct the checking of quota files before moving extents

Haotian Zhang <vulab@iscas.ac.cn>
    mfd: da9055: Fix missing regmap_del_irq_chip() in error path

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

Vishwaroop A <va@nvidia.com>
    spi: tegra210-quad: Fix timeout handling

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
    power: supply: cw2015: Check devm_delayed_work_autocancel() return code

Shuai Xue <xueshuai@linux.alibaba.com>
    perf record: skip synthesize event when open evsel failed

Namhyung Kim <namhyung@kernel.org>
    perf lock contention: Load kernel map before lookup

Ian Rogers <irogers@google.com>
    perf maps: Add maps__load_first()

Kuan-Wei Chiu <visitorckw@gmail.com>
    interconnect: debugfs: Fix incorrect error handling for NULL path

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: msm8996: add interconnect paths to USB2 controller

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    interconnect: qcom: msm8996: add missing link to SLAVE_USB_HS

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Prevent incomplete IBI transaction

Frank Li <Frank.Li@nxp.com>
    i3c: fix refcount inconsistency in i3c_master_register

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: master: Inherit DMA masks and parameters from parent device

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

Gergo Koteles <soyer@irl.hu>
    arm64: dts: qcom: sdm845-oneplus: Correct gpio used for slider

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

nieweiqiang <nieweiqiang@huawei.com>
    crypto: hisilicon/qm - restore original qos values

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: asymmetric_keys - prevent overflow in asymmetric_key_generate_id

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: camcc-sm6350: Fix PLL config of PLL2

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    clk: qcom: camcc-sm6350: Specify Titan GDSC power domain as a parent to other

Li Qiang <liqiang01@kylinos.cn>
    uio: uio_fsl_elbc_gpcm:: Add null pointer check to uio_fsl_elbc_gpcm_probe

Geert Uytterhoeven <geert+renesas@glider.be>
    PCI: rcar-gen2: Drop ARM dependency from PCI_RCAR_GEN2

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mp-venice-gw702x: remove off-board sdhc1

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mp-venice-gw702x: remove off-board uart

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mm-venice-gw72xx: remove unused sdhc1 pinctrl

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: freescale: imx8mp-venice-gw7905-2x: remove duplicate usdhc1 props

Francesco Lavra <flavra@baylibre.com>
    iio: imu: st_lsm6dsx: Fix measurement unit for odr struct member

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    inet: Avoid ehash lookup race in inet_ehash_insert()

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    rculist: Add hlist_nulls_replace_rcu() and hlist_nulls_replace_init_rcu()

Sidharth Seela <sidharthseela@gmail.com>
    ntfs3: Fix uninit buffer allocated by __getname()

Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
    ntfs3: fix uninit memory after failed mi_read in mi_format_new

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: authenc - Correctly pass EINPROGRESS back up to the caller

Johan Hovold <johan@kernel.org>
    irqchip/qcom-irq-combiner: Fix section mismatch

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

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Fix weak symbol detection

Dylan Hatch <dylanbhatch@google.com>
    objtool: Fix standalone --hacks=jump_label

Mavroudis Chatzilazaridis <mavchatz@protonmail.com>
    HID: logitech-hidpp: Do not assume FAP in hidpp_send_message_sync()

Marek Vasut <marek.vasut+renesas@mailbox.org>
    clk: renesas: cpg-mssr: Read back reset registers to assure values latched

Thierry Bultel <thierry.bultel.yh@bp.renesas.com>
    clk: renesas: Pass sub struct of cpg_mssr_priv to cpg_clk_register

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: Use str_on_off() helper

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    clk: renesas: rzg2l: Use %x format specifier to print CLK_ON_R()

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    clk: renesas: rzg2l: Remove critical area

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    clk: renesas: rzg2l: Simplify the logic in rzg2l_mod_clock_endisable()

Marek Vasut <marek.vasut+renesas@mailbox.org>
    clk: renesas: cpg-mssr: Add missing 1ms delay into reset toggle callback

Seungjin Bae <eeodqql09@gmail.com>
    USB: Fix descriptor count when handling invalid MBIM extended descriptor

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/vgem-fence: Fix potential deadlock on release

Guido Günther <agx@sigxcpu.org>
    drm/panel: visionox-rm69299: Don't clear all mode flags

Mainak Sen <msen@nvidia.com>
    gpu: host1x: Fix race in syncpt alloc/free

Konstantin Andreev <andreev@swemel.ru>
    smack: fix bug: unprivileged task can create labels

Navaneeth K <knavaneeth786@gmail.com>
    staging: rtl8723bs: fix out-of-bounds read in OnBeacon ESR IE parsing

Navaneeth K <knavaneeth786@gmail.com>
    staging: rtl8723bs: fix stack buffer overflow in OnAssocReq IE parsing

Navaneeth K <knavaneeth786@gmail.com>
    staging: rtl8723bs: fix out-of-bounds read in rtw_get_ie() parser

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    comedi: check device's attached status in compat ioctls

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    comedi: multiq3: sanitize config options in multiq3_attach()

Ian Abbott <abbotti@mev.co.uk>
    comedi: c6xdigio: Fix invalid PNP driver unregistration

Zenm Chen <zenmchen@gmail.com>
    wifi: rtw88: Add USB ID 2001:3329 for D-Link AC13U rev. A1

Linus Torvalds <torvalds@linux-foundation.org>
    samples: work around glibc redefining some of our defines wrong

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Mask all interrupts during kexec/kdump

Naoki Ueki <naoki25519@gmail.com>
    HID: elecom: Add support for ELECOM M-XT3URBK (018F)

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86/amd/pmc: Add spurious_8042 to Xbox Ally

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86/amd: pmc: Add Lenovo Legion Go 2 to pmc quirk list

Jia Ston <ston.jia@outlook.com>
    platform/x86: huawei-wmi: add keys for HONOR models

April Grimoire <april@aprilg.moe>
    HID: apple: Add SONiX AK870 PRO to non_apple_keyboards quirk list

Armin Wolf <W_Armin@gmx.de>
    platform/x86: acer-wmi: Ignore backlight event

Praveen Talari <praveen.talari@oss.qualcomm.com>
    pinctrl: qcom: msm: Fix deadlock in pinmux configuration

Keith Busch <kbusch@kernel.org>
    nvme: fix admin request_queue lifetime

Mario Limonciello (AMD) <superm1@kernel.org>
    HID: hid-input: Extend Elan ignore battery quirk to USB

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    bfs: Reconstruct file type when loading from disk

Lushih Hsieh <bruce@mail.kh.edu.tw>
    ALSA: usb-audio: Add native DSD quirks for PureAudio DAC series

Yiqi Sun <sunyiqixm@gmail.com>
    smb: fix invalid username check in smb3_fs_context_parse_param()

Max Chou <max.chou@realtek.com>
    Bluetooth: btrtl: Avoid loading the config file on security chips

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Use kref in vmw_bo_dirty

Robin Gong <yibin.gong@nxp.com>
    spi: imx: keep dma request disabled before dma transfer setup

Alvaro Gamez Machado <alvaro.gamez@hazent.com>
    spi: xilinx: increase number of retries before declaring stall

Song Liu <song@kernel.org>
    ftrace: bpf: Fix IPMODIFY + DIRECT in modify_ftrace_direct()

Johan Hovold <johan@kernel.org>
    USB: serial: kobil_sct: fix TIOCMBIS and TIOCMBIC

Johan Hovold <johan@kernel.org>
    USB: serial: belkin_sa: fix TIOCMBIS and TIOCMBIC

Magne Bruno <magne.bruno@addi-data.com>
    serial: add support of CPCI cards

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: match on interface number for jtag

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: move Telit 0x10c7 composition in the right place

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FE910C04 new compositions

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add Foxconn T99W760

Omar Sandoval <osandov@fb.com>
    KVM: SVM: Don't skip unrelated instruction if INT3/INTO is replaced

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    comedi: pcl818: fix null-ptr-deref in pcl818_ai_cancel()

Alexey Nepomnyashih <sdl@nppct.ru>
    ext4: add i_data_sem protection in ext4_destroy_inline_data_nolock()

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    locking/spinlock/debug: Fix data-race in do_raw_write_lock

Qianchang Zhao <pioooooooooip@gmail.com>
    ksmbd: ipc: fix use-after-free in ipc_msg_send_request

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: refresh inline data size before write operations

Ye Bin <yebin10@huawei.com>
    jbd2: avoid bug_on in jbd2_journal_get_create_access() when file system corrupted

Bagas Sanjaya <bagasdotme@gmail.com>
    Documentation: process: Also mention Sasha Levin as stable tree maintainer

Stefan Kalscheuer <stefan@stklcode.de>
    leds: spi-byte: Use devm_led_classdev_register_ext()

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: flush all states in xfrm_state_fini

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: also call xfrm_state_delete_tunnel at destroy time for states that were never added

Sabrina Dubroca <sd@queasysnail.net>
    Revert "xfrm: destroy xfrm_state synchronously on net exit path"

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: delete x->tunnel as we delete x


-------------

Diffstat:

 .../devicetree/bindings/mmc/aspeed,sdhci.yaml      |   2 +-
 .../devicetree/bindings/pci/amlogic,axg-pcie.yaml  |   6 +-
 Documentation/driver-api/tty/tty_port.rst          |   5 +-
 Documentation/process/2.Process.rst                |   6 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/microchip/sama5d2.dtsi           |  10 +-
 arch/arm/boot/dts/microchip/sama7g5.dtsi           |   4 +-
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
 .../boot/dts/freescale/imx8mm-venice-gw72xx.dtsi   |  11 -
 .../boot/dts/freescale/imx8mp-venice-gw702x.dtsi   |  51 ---
 .../boot/dts/freescale/imx8mp-venice-gw72xx.dtsi   |  11 -
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   3 +
 .../arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi |   4 +-
 arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts   |  15 +-
 arch/arm64/boot/dts/ti/k3-am62p.dtsi               |   2 +-
 arch/arm64/boot/dts/ti/k3-j721e-sk.dts             |  12 +-
 arch/arm64/net/bpf_jit_comp.c                      |   2 +-
 arch/loongarch/include/asm/pgtable.h               |   4 +-
 arch/loongarch/kernel/machine_kexec.c              |  24 ++
 arch/loongarch/kernel/mcount_dyn.S                 |  14 +-
 arch/loongarch/kernel/relocate.c                   |   4 +-
 arch/loongarch/kernel/setup.c                      |   8 +-
 arch/loongarch/kernel/switch.S                     |   4 +-
 arch/loongarch/net/bpf_jit.c                       |  18 +
 arch/loongarch/net/bpf_jit.h                       |  26 ++
 arch/loongarch/pci/pci.c                           |   2 +
 arch/mips/sgi-ip22/ip22-gio.c                      |   3 +-
 arch/parisc/kernel/asm-offsets.c                   |   2 +
 arch/parisc/kernel/entry.S                         |  16 +-
 arch/powerpc/boot/addnote.c                        |   7 +-
 arch/powerpc/include/asm/book3s/32/tlbflush.h      |   5 +-
 arch/powerpc/include/asm/book3s/64/mmu-hash.h      |   1 -
 arch/powerpc/include/asm/kfence.h                  |  11 +-
 arch/powerpc/kernel/entry_32.S                     |  10 +-
 arch/powerpc/kernel/process.c                      |   5 -
 arch/powerpc/kexec/core_64.c                       |  19 ++
 arch/powerpc/mm/book3s32/tlb.c                     |   9 +
 arch/powerpc/mm/book3s64/hash_utils.c              |  10 +-
 arch/powerpc/mm/book3s64/internal.h                |   2 -
 arch/powerpc/mm/book3s64/mmu_context.c             |   2 -
 arch/powerpc/mm/book3s64/radix_pgtable.c           |  84 ++++-
 arch/powerpc/mm/book3s64/slb.c                     |  88 -----
 arch/powerpc/mm/init-common.c                      |   3 +
 arch/powerpc/mm/ptdump/hashpagetable.c             |   6 +
 arch/powerpc/platforms/pseries/cmm.c               |   5 +-
 arch/riscv/kvm/vcpu_insn.c                         |  22 ++
 arch/s390/include/uapi/asm/ipl.h                   |   1 +
 arch/s390/kernel/ipl.c                             |  48 ++-
 arch/s390/kernel/smp.c                             |   1 +
 arch/x86/boot/compressed/pgtable_64.c              |  11 +-
 arch/x86/crypto/blake2s-core.S                     |   4 +-
 arch/x86/entry/common.c                            |  72 ----
 arch/x86/events/amd/core.c                         |   7 +-
 arch/x86/events/intel/core.c                       |   4 +-
 arch/x86/include/asm/kvm_host.h                    |   9 +
 arch/x86/include/asm/ptrace.h                      |  20 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   2 +-
 arch/x86/kernel/dumpstack.c                        |  23 +-
 arch/x86/kvm/lapic.c                               |  32 +-
 arch/x86/kvm/svm/nested.c                          |  26 +-
 arch/x86/kvm/svm/svm.c                             | 176 +++++-----
 arch/x86/kvm/svm/svm.h                             |   8 +-
 arch/x86/kvm/vmx/nested.c                          |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |   2 +-
 arch/x86/kvm/vmx/vmx.h                             |   1 +
 arch/x86/kvm/x86.c                                 |  46 ++-
 arch/x86/xen/enlighten_pv.c                        |  69 ++++
 block/blk-mq.c                                     | 120 +++++--
 block/genhd.c                                      |   2 +-
 crypto/af_alg.c                                    |   5 +-
 crypto/algif_hash.c                                |   3 +-
 crypto/algif_rng.c                                 |   3 +-
 crypto/asymmetric_keys/asymmetric_type.c           |  12 +-
 crypto/authenc.c                                   |  75 +++--
 crypto/seqiv.c                                     |   8 +-
 drivers/acpi/acpi_pcc.c                            |   2 +-
 drivers/acpi/acpica/nswalk.c                       |   9 +-
 drivers/acpi/apei/ghes.c                           |  16 +-
 drivers/acpi/cppc_acpi.c                           |   3 +-
 drivers/acpi/processor_core.c                      |   2 +-
 drivers/acpi/property.c                            |   9 +-
 drivers/amba/tegra-ahb.c                           |   1 +
 drivers/base/power/runtime.c                       |  22 +-
 drivers/block/floppy.c                             |   2 +-
 drivers/block/nbd.c                                |   5 +-
 drivers/block/ps3disk.c                            |   4 +
 drivers/block/rnbd/rnbd-clt.c                      |  13 +-
 drivers/block/rnbd/rnbd-clt.h                      |   2 +-
 drivers/block/ublk_drv.c                           |  35 +-
 drivers/bluetooth/btrtl.c                          |  24 +-
 drivers/bluetooth/btusb.c                          |  16 +-
 drivers/bus/ti-sysc.c                              |  11 +-
 drivers/char/applicom.c                            |   5 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  20 +-
 drivers/char/tpm/tpm-chip.c                        |   1 -
 drivers/char/tpm/tpm1-cmd.c                        |   5 -
 drivers/char/tpm/tpm2-cmd.c                        |   8 +-
 drivers/char/virtio_console.c                      |   2 +-
 drivers/clk/Makefile                               |   3 +-
 drivers/clk/mvebu/cp110-system-controller.c        |  20 ++
 drivers/clk/qcom/camcc-sm6350.c                    |  13 +-
 drivers/clk/renesas/r7s9210-cpg-mssr.c             |   7 +-
 drivers/clk/renesas/r8a77970-cpg-mssr.c            |   8 +-
 drivers/clk/renesas/r9a06g032-clocks.c             |   6 +-
 drivers/clk/renesas/rcar-gen2-cpg.c                |   5 +-
 drivers/clk/renesas/rcar-gen2-cpg.h                |   3 +-
 drivers/clk/renesas/rcar-gen3-cpg.c                |   6 +-
 drivers/clk/renesas/rcar-gen3-cpg.h                |   3 +-
 drivers/clk/renesas/rcar-gen4-cpg.c                |   6 +-
 drivers/clk/renesas/rcar-gen4-cpg.h                |   3 +-
 drivers/clk/renesas/renesas-cpg-mssr.c             | 150 +++++----
 drivers/clk/renesas/renesas-cpg-mssr.h             |  20 +-
 drivers/clk/renesas/rzg2l-cpg.c                    |  15 +-
 drivers/clk/samsung/clk-exynos-clkout.c            |   2 +-
 drivers/comedi/comedi_fops.c                       |  42 ++-
 drivers/comedi/drivers/c6xdigio.c                  |  46 ++-
 drivers/comedi/drivers/multiq3.c                   |   9 +
 drivers/comedi/drivers/pcl818.c                    |   5 +-
 drivers/cpufreq/amd-pstate.c                       |   2 +-
 drivers/cpufreq/cpufreq-dt-platdev.c               |   1 +
 drivers/cpufreq/cpufreq-nforce2.c                  |   3 +
 drivers/cpufreq/s5pv210-cpufreq.c                  |   6 +-
 drivers/cpuidle/governors/menu.c                   |   9 +-
 drivers/cpuidle/governors/teo.c                    |   7 +-
 drivers/crypto/caam/caamrng.c                      |   4 +-
 drivers/crypto/ccree/cc_buffer_mgr.c               |   6 +-
 drivers/crypto/hisilicon/qm.c                      |  14 +-
 drivers/crypto/starfive/jh7110-hash.c              |   6 +-
 drivers/firewire/nosy.c                            |  10 +-
 drivers/firmware/arm_scmi/notify.c                 |   1 +
 drivers/firmware/efi/cper-arm.c                    |  52 ++-
 drivers/firmware/efi/cper.c                        |  60 ++++
 drivers/firmware/efi/libstub/x86-5lvl.c            |   4 +-
 drivers/firmware/imx/imx-scu-irq.c                 |   8 +-
 drivers/firmware/stratix10-svc.c                   |  12 +
 drivers/gpio/gpio-regmap.c                         |   2 +-
 drivers/gpio/gpiolib-acpi.c                        |  22 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   6 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |   8 +-
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c   |   2 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   9 +-
 drivers/gpu/drm/gma500/fbdev.c                     |  43 ---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |  37 +-
 drivers/gpu/drm/mediatek/mtk_disp_ccorr.c          |  23 +-
 drivers/gpu/drm/mediatek/mtk_dp.c                  |   1 +
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c        |  22 +-
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h        |   2 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   4 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |  25 ++
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c              |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c        |   2 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c    |  10 +-
 drivers/gpu/drm/nouveau/dispnv50/atom.h            |  13 +
 drivers/gpu/drm/nouveau/dispnv50/wndw.c            |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c      |   2 +-
 drivers/gpu/drm/panel/panel-sony-td4353-jdi.c      |   2 +
 drivers/gpu/drm/panel/panel-visionox-rm69299.c     |   2 +-
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c               |   2 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |  72 ++--
 drivers/gpu/drm/tilcdc/tilcdc_drv.h                |   2 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |   6 +
 drivers/gpu/drm/vgem/vgem_fence.c                  |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c         |  12 +-
 drivers/gpu/host1x/syncpt.c                        |   4 +-
 drivers/hid/hid-apple.c                            |   1 +
 drivers/hid/hid-elecom.c                           |   6 +-
 drivers/hid/hid-ids.h                              |   3 +-
 drivers/hid/hid-input.c                            |  23 +-
 drivers/hid/hid-logitech-dj.c                      |  56 ++-
 drivers/hid/hid-logitech-hidpp.c                   |   9 +-
 drivers/hid/hid-quirks.c                           |   3 +-
 drivers/hwmon/ibmpex.c                             |   9 +-
 drivers/hwmon/max16065.c                           |   7 +-
 drivers/hwmon/sy7636a-hwmon.c                      |   7 +-
 drivers/hwmon/tmp401.c                             |   2 +-
 drivers/hwmon/w83791d.c                            |  19 +-
 drivers/hwmon/w83l786ng.c                          |  26 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 130 ++++---
 drivers/hwtracing/intel_th/core.c                  |  20 +-
 drivers/i2c/busses/i2c-amd-mp2-pci.c               |   5 +-
 drivers/i2c/busses/i2c-designware-core.h           |   1 +
 drivers/i2c/busses/i2c-designware-master.c         |   7 +
 drivers/i3c/master.c                               |  12 +-
 drivers/i3c/master/svc-i3c-master.c                |  22 +-
 drivers/iio/adc/ti_am335x_adc.c                    |   2 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h            |   2 +-
 drivers/infiniband/core/addr.c                     |  33 +-
 drivers/infiniband/core/cma.c                      |   3 +
 drivers/infiniband/core/device.c                   |   6 +
 drivers/infiniband/core/verbs.c                    |   2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   7 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |   8 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |   2 +-
 drivers/infiniband/hw/efa/efa_verbs.c              |   4 -
 drivers/infiniband/hw/irdma/cm.c                   |   2 +-
 drivers/infiniband/hw/irdma/ctrl.c                 |   3 +
 drivers/infiniband/hw/irdma/main.h                 |   2 +-
 drivers/infiniband/hw/irdma/pble.c                 |   6 +-
 drivers/infiniband/hw/irdma/utils.c                |   3 +-
 drivers/infiniband/hw/irdma/verbs.c                | 241 ++++++++++---
 drivers/infiniband/hw/irdma/verbs.h                |   3 +
 drivers/infiniband/sw/rxe/rxe.c                    |  22 +-
 drivers/infiniband/sw/rxe/rxe.h                    |   3 +-
 drivers/infiniband/sw/rxe/rxe_mcast.c              |  22 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |  25 +-
 drivers/infiniband/sw/rxe/rxe_srq.c                |   7 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |  26 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |  11 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |   1 +
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   2 +-
 drivers/input/serio/i8042-acpipnpio.h              |   7 +
 drivers/input/touchscreen/ti_am335x_tsc.c          |   2 +-
 drivers/interconnect/debugfs-client.c              |   7 +-
 drivers/interconnect/qcom/msm8996.c                |   1 +
 drivers/iommu/amd/init.c                           |  43 ++-
 drivers/iommu/apple-dart.c                         |   2 +
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |  27 +-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |  10 +-
 drivers/iommu/exynos-iommu.c                       |   9 +-
 drivers/iommu/iommu-sva.c                          |   3 +
 drivers/iommu/iommufd/selftest.c                   |   8 +-
 drivers/iommu/ipmmu-vmsa.c                         |   2 +
 drivers/iommu/mtk_iommu.c                          |  27 +-
 drivers/iommu/mtk_iommu_v1.c                       |  25 +-
 drivers/iommu/omap-iommu.c                         |   2 +-
 drivers/iommu/omap-iommu.h                         |   2 -
 drivers/iommu/sun50i-iommu.c                       |   2 +
 drivers/iommu/tegra-smmu.c                         |   5 +-
 drivers/irqchip/irq-bcm7038-l1.c                   |   8 +-
 drivers/irqchip/irq-bcm7120-l2.c                   |  17 +-
 drivers/irqchip/irq-brcmstb-l2.c                   |  12 +-
 drivers/irqchip/irq-imx-mu-msi.c                   |  14 +-
 drivers/irqchip/irq-mchp-eic.c                     |   2 +-
 drivers/irqchip/qcom-irq-combiner.c                |   2 +-
 drivers/isdn/capi/capi.c                           |   8 +-
 drivers/leds/leds-lp50xx.c                         |  67 ++--
 drivers/leds/leds-netxbig.c                        |  36 +-
 drivers/leds/leds-spi-byte.c                       |  11 +-
 drivers/macintosh/mac_hid.c                        |   3 +-
 drivers/md/dm-bufio.c                              |  10 +-
 drivers/md/dm-ebs-target.c                         |   2 +-
 drivers/md/dm-log-writes.c                         |   1 +
 drivers/md/dm-raid.c                               |   2 +
 drivers/md/raid5.c                                 |   6 +-
 drivers/media/cec/core/cec-core.c                  |   1 +
 .../media/common/videobuf2/videobuf2-dma-contig.c  |   1 +
 drivers/media/i2c/adv7604.c                        |   4 +-
 drivers/media/i2c/adv7842.c                        |  11 +-
 drivers/media/i2c/msp3400-kthreads.c               |   2 +
 drivers/media/i2c/tda1997x.c                       |   1 -
 drivers/media/platform/amphion/vpu_malone.c        |  35 +-
 drivers/media/platform/amphion/vpu_v4l2.c          |  28 +-
 drivers/media/platform/amphion/vpu_v4l2.h          |  18 -
 .../mediatek/vcodec/common/mtk_vcodec_fw_vpu.c     |  14 +-
 .../mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c   |  12 +-
 .../mediatek/vcodec/decoder/mtk_vcodec_dec_drv.h   |   2 +-
 .../platform/mediatek/vcodec/decoder/vdec_vpu_if.c |   5 +-
 .../mediatek/vcodec/encoder/mtk_vcodec_enc_drv.c   |  12 +-
 .../mediatek/vcodec/encoder/mtk_vcodec_enc_drv.h   |   2 +-
 .../platform/mediatek/vcodec/encoder/venc_vpu_if.c |   5 +-
 drivers/media/platform/renesas/rcar_drif.c         |   1 +
 .../media/platform/samsung/exynos4-is/media-dev.c  |  10 +-
 drivers/media/platform/ti/davinci/vpif_capture.c   |   4 +-
 drivers/media/platform/ti/davinci/vpif_display.c   |   4 +-
 drivers/media/platform/verisilicon/hantro.h        |   2 +
 drivers/media/platform/verisilicon/hantro_g2.c     |  98 +++++-
 .../platform/verisilicon/hantro_g2_hevc_dec.c      |  35 +-
 .../media/platform/verisilicon/hantro_g2_regs.h    |  13 +
 .../media/platform/verisilicon/hantro_g2_vp9_dec.c |  30 +-
 drivers/media/platform/verisilicon/hantro_hw.h     |   4 +
 drivers/media/platform/verisilicon/imx8m_vpu_hw.c  |   2 +
 drivers/media/rc/st_rc.c                           |   2 +-
 drivers/media/test-drivers/vidtv/vidtv_channel.c   |   3 +
 drivers/media/usb/dvb-usb/dtv5100.c                |   5 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   2 +-
 drivers/mfd/altera-sysmgr.c                        |   2 +
 drivers/mfd/da9055-core.c                          |   1 +
 drivers/mfd/max77620.c                             |  15 +-
 drivers/mfd/mt6358-irq.c                           |   1 +
 drivers/mfd/mt6397-irq.c                           |   1 +
 drivers/misc/vmw_balloon.c                         |   3 +-
 drivers/mmc/host/Kconfig                           |   4 +-
 drivers/mmc/host/sdhci-msm.c                       |  27 +-
 drivers/mtd/lpddr/lpddr_cmds.c                     |   8 +-
 drivers/mtd/nand/raw/lpc32xx_slc.c                 |   2 +
 drivers/mtd/nand/raw/marvell_nand.c                |  13 +-
 drivers/mtd/nand/raw/nand_base.c                   |  13 +-
 drivers/mtd/nand/raw/renesas-nand-controller.c     |   5 +-
 drivers/net/can/usb/gs_usb.c                       |   2 +-
 drivers/net/dsa/b53/b53_common.c                   |   3 +
 drivers/net/dsa/sja1105/sja1105_static_config.c    |   6 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |   2 +
 drivers/net/ethernet/broadcom/b44.c                |   3 +
 drivers/net/ethernet/cadence/macb_main.c           |   3 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   3 +-
 drivers/net/ethernet/freescale/fec_main.c          |   7 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   3 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   5 +
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  97 +++++-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.h   |   1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  59 +++-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c  |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  27 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   3 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   5 +-
 drivers/net/ethernet/smsc/smc91x.c                 |  10 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       |   5 +
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   5 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  19 +-
 drivers/net/fjes/fjes_hw.c                         |  12 +-
 drivers/net/ipvlan/ipvlan_core.c                   |   3 +
 drivers/net/mdio/mdio-aspeed.c                     |   7 +
 drivers/net/phy/adin1100.c                         |   2 +-
 drivers/net/phy/mediatek-ge-soc.c                  |   2 +-
 drivers/net/phy/mscc/mscc_main.c                   |   6 +-
 drivers/net/team/team.c                            |   2 +-
 drivers/net/usb/asix_common.c                      |   5 +
 drivers/net/usb/rtl8150.c                          |   2 +
 drivers/net/usb/sr9700.c                           |   4 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   4 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   7 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |  14 +
 drivers/net/wireless/mediatek/mt76/eeprom.c        |  37 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   4 +-
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |   9 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |  27 +-
 drivers/net/wireless/realtek/rtw88/rtw8822cu.c     |   2 +
 drivers/net/wireless/realtek/rtw88/sdio.c          |   4 +-
 drivers/net/wireless/st/cw1200/bh.c                |   6 +-
 drivers/nfc/pn533/usb.c                            |   2 +-
 drivers/nvme/host/auth.c                           |   2 +-
 drivers/nvme/host/core.c                           |   3 +-
 drivers/nvme/host/fc.c                             |   6 +-
 drivers/parisc/gsc.c                               |   4 +-
 drivers/pci/controller/Kconfig                     |   7 +-
 drivers/pci/controller/dwc/pci-keystone.c          |   2 +
 drivers/pci/controller/dwc/pcie-designware.h       |   2 +-
 drivers/pci/controller/pcie-brcmstb.c              |  10 +-
 drivers/pci/pci-driver.c                           |   4 +
 drivers/phy/broadcom/phy-bcm63xx-usbh.c            |   6 +-
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |  20 +-
 drivers/pinctrl/pinctrl-single.c                   |  25 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |   2 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   2 +-
 drivers/platform/chrome/cros_ec_ishtp.c            |   1 +
 drivers/platform/x86/acer-wmi.c                    |   4 +
 drivers/platform/x86/amd/pmc/pmc-quirks.c          |  25 ++
 drivers/platform/x86/asus-wmi.c                    |   8 +-
 .../platform/x86/hp/hp-bioscfg/enum-attributes.c   |   4 +-
 .../platform/x86/hp/hp-bioscfg/int-attributes.c    |   2 +-
 .../x86/hp/hp-bioscfg/order-list-attributes.c      |   5 +
 .../x86/hp/hp-bioscfg/passwdobj-attributes.c       |   5 +
 .../platform/x86/hp/hp-bioscfg/string-attributes.c |   2 +-
 drivers/platform/x86/huawei-wmi.c                  |   4 +
 drivers/platform/x86/ibm_rtl.c                     |   2 +-
 drivers/platform/x86/intel/chtwc_int33fe.c         |  29 +-
 drivers/platform/x86/intel/hid.c                   |  12 +
 drivers/platform/x86/msi-laptop.c                  |   3 +
 drivers/pmdomain/actions/owl-sps.c                 |  16 +-
 drivers/pmdomain/imx/gpc.c                         |  12 +-
 drivers/pmdomain/rockchip/pm-domains.c             |  13 +-
 drivers/power/supply/apm_power.c                   |   3 +-
 drivers/power/supply/cw2015_battery.c              |   8 +-
 drivers/power/supply/rt9467-charger.c              |   6 +-
 drivers/power/supply/wm831x_power.c                |  10 +-
 drivers/pwm/pwm-bcm2835.c                          |  28 +-
 drivers/pwm/pwm-stm32.c                            |   3 +-
 drivers/regulator/core.c                           |  37 +-
 drivers/remoteproc/qcom_q6v5_wcss.c                |   8 +-
 drivers/rpmsg/qcom_glink_native.c                  |   8 +
 drivers/rtc/rtc-gamecube.c                         |   4 +
 drivers/s390/block/dasd_eckd.c                     |   8 +
 drivers/s390/crypto/ap_bus.c                       |   8 +-
 drivers/scsi/aic94xx/aic94xx_init.c                |   3 +
 drivers/scsi/qla2xxx/qla_def.h                     |   1 -
 drivers/scsi/qla2xxx/qla_gbl.h                     |   2 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  32 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   2 +
 drivers/scsi/qla2xxx/qla_mid.c                     |   4 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  14 +-
 drivers/scsi/sim710.c                              |   2 +
 drivers/scsi/smartpqi/smartpqi_init.c              |  19 ++
 drivers/scsi/stex.c                                |   1 +
 drivers/soc/amlogic/meson-canvas.c                 |   5 +-
 drivers/soc/qcom/ocmem.c                           |   2 +-
 drivers/soc/qcom/smem.c                            |   3 +-
 drivers/spi/spi-cadence-quadspi.c                  |   4 +-
 drivers/spi/spi-fsl-spi.c                          |   2 +-
 drivers/spi/spi-imx.c                              |  15 +-
 drivers/spi/spi-tegra210-quad.c                    |  22 +-
 drivers/spi/spi-xilinx.c                           |   2 +-
 drivers/staging/fbtft/fbtft-core.c                 |   4 +-
 drivers/staging/greybus/uart.c                     |   7 +-
 drivers/staging/most/Kconfig                       |   2 -
 drivers/staging/most/Makefile                      |   1 -
 drivers/staging/most/i2c/Kconfig                   |  13 -
 drivers/staging/most/i2c/Makefile                  |   4 -
 drivers/staging/most/i2c/i2c.c                     | 374 ---------------------
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |  14 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |  13 +-
 drivers/target/target_core_configfs.c              |   1 -
 drivers/target/target_core_transport.c             |   1 +
 drivers/tty/serial/8250/8250_pci.c                 |  37 ++
 drivers/tty/serial/serial_core.c                   |   7 +-
 drivers/tty/serial/sprd_serial.c                   |   6 +
 drivers/tty/tty_port.c                             |  17 +-
 drivers/ufs/core/ufshcd.c                          |   7 +-
 drivers/uio/uio_fsl_elbc_gpcm.c                    |   7 +
 drivers/usb/class/cdc-acm.c                        |   7 +-
 drivers/usb/core/message.c                         |   2 +-
 drivers/usb/dwc2/platform.c                        |  16 +-
 drivers/usb/dwc3/dwc3-of-simple.c                  |   7 +-
 drivers/usb/dwc3/gadget.c                          |   2 +-
 drivers/usb/dwc3/host.c                            |   2 +-
 drivers/usb/gadget/legacy/raw_gadget.c             |   3 +
 drivers/usb/gadget/udc/lpc32xx_udc.c               |  21 +-
 drivers/usb/gadget/udc/tegra-xudc.c                |   6 -
 drivers/usb/host/ohci-nxp.c                        |  20 +-
 drivers/usb/host/xhci-dbgtty.c                     |   2 +-
 drivers/usb/host/xhci-hub.c                        |   2 +-
 drivers/usb/host/xhci-mem.c                        |  10 +-
 drivers/usb/host/xhci-ring.c                       |   8 +-
 drivers/usb/host/xhci.h                            |  16 +-
 drivers/usb/misc/chaoskey.c                        |  16 +-
 drivers/usb/phy/phy-fsl-usb.c                      |   1 +
 drivers/usb/phy/phy-isp1301.c                      |   7 +-
 drivers/usb/phy/phy.c                              |   4 +
 drivers/usb/renesas_usbhs/pipe.c                   |   2 +
 drivers/usb/serial/belkin_sa.c                     |  28 +-
 drivers/usb/serial/ftdi_sio.c                      |  72 ++--
 drivers/usb/serial/kobil_sct.c                     |  18 +-
 drivers/usb/serial/option.c                        |  22 +-
 drivers/usb/serial/usb-serial.c                    |   7 +-
 drivers/usb/storage/unusual_uas.h                  |   2 +-
 drivers/usb/typec/ucsi/ucsi.c                      |   6 +
 drivers/usb/usbip/vhci_hcd.c                       |   6 +-
 drivers/vdpa/pds/vdpa_dev.c                        |   2 +-
 drivers/vhost/vsock.c                              |  15 +-
 drivers/video/backlight/led_bl.c                   |  13 +
 drivers/video/fbdev/gbefb.c                        |   5 +-
 drivers/video/fbdev/pxafb.c                        |  12 +-
 drivers/video/fbdev/ssd1307fb.c                    |   4 +-
 drivers/video/fbdev/tcx.c                          |   2 +-
 drivers/virtio/virtio_balloon.c                    |   4 +-
 drivers/virtio/virtio_vdpa.c                       |   2 +-
 drivers/watchdog/starfive-wdt.c                    |   4 +-
 drivers/watchdog/via_wdt.c                         |   1 +
 drivers/watchdog/wdat_wdt.c                        |  64 ++--
 fs/9p/v9fs.c                                       |   4 +-
 fs/9p/vfs_file.c                                   |  11 +-
 fs/9p/vfs_inode.c                                  |   3 +-
 fs/9p/vfs_inode_dotl.c                             |   2 +-
 fs/bfs/inode.c                                     |  19 +-
 fs/btrfs/ctree.c                                   |   2 +-
 fs/btrfs/inode.c                                   |   1 +
 fs/btrfs/ioctl.c                                   |   4 +-
 fs/btrfs/scrub.c                                   |   5 +
 fs/btrfs/tree-log.c                                |  46 ++-
 fs/btrfs/volumes.c                                 |   1 +
 fs/exfat/super.c                                   |  19 +-
 fs/ext4/ext4.h                                     |   1 +
 fs/ext4/ialloc.c                                   |   1 -
 fs/ext4/inline.c                                   |  14 +-
 fs/ext4/inode.c                                    |   6 +-
 fs/ext4/mballoc.c                                  |  58 ++--
 fs/ext4/move_extent.c                              |   2 +-
 fs/ext4/orphan.c                                   |   4 +-
 fs/ext4/super.c                                    |  34 +-
 fs/ext4/xattr.c                                    |  38 +--
 fs/ext4/xattr.h                                    |  10 +
 fs/f2fs/compress.c                                 |   5 +-
 fs/f2fs/data.c                                     |  17 +
 fs/f2fs/debug.c                                    |   3 +
 fs/f2fs/extent_cache.c                             |   5 +-
 fs/f2fs/f2fs.h                                     |  41 ++-
 fs/f2fs/file.c                                     |  92 ++++-
 fs/f2fs/inode.c                                    |  20 +-
 fs/f2fs/namei.c                                    |   6 +-
 fs/f2fs/recovery.c                                 |  23 +-
 fs/f2fs/segment.c                                  |   9 +-
 fs/f2fs/super.c                                    | 119 +++----
 fs/f2fs/xattr.c                                    |  30 +-
 fs/f2fs/xattr.h                                    |  10 +-
 fs/fuse/file.c                                     |  37 +-
 fs/gfs2/glops.c                                    |   3 +-
 fs/gfs2/lops.c                                     |   2 +-
 fs/gfs2/super.c                                    |   4 +-
 fs/hfsplus/bnode.c                                 |   4 +-
 fs/hfsplus/dir.c                                   |   7 +-
 fs/hfsplus/inode.c                                 |  32 +-
 fs/iomap/buffered-io.c                             |  41 ++-
 fs/iomap/direct-io.c                               |  79 +++--
 fs/jbd2/journal.c                                  |  20 +-
 fs/jbd2/transaction.c                              |  21 +-
 fs/lockd/svc4proc.c                                |   4 +-
 fs/lockd/svclock.c                                 |  21 +-
 fs/lockd/svcproc.c                                 |   5 +-
 fs/locks.c                                         |  12 +-
 fs/nfs/client.c                                    |  21 +-
 fs/nfs/dir.c                                       |  27 +-
 fs/nfs/inode.c                                     |   2 +-
 fs/nfs/internal.h                                  |   3 +-
 fs/nfs/namespace.c                                 |  11 +-
 fs/nfs/nfs4client.c                                |  18 +-
 fs/nfs/pnfs.c                                      |   1 +
 fs/nfs/super.c                                     |  33 +-
 fs/nfsd/blocklayout.c                              |   7 +-
 fs/nfsd/export.c                                   |   2 +-
 fs/nfsd/nfs4state.c                                |   4 +-
 fs/nfsd/nfs4xdr.c                                  |   5 +
 fs/nls/nls_base.c                                  |  27 +-
 fs/notify/fsnotify.c                               |   9 +-
 fs/ntfs3/frecord.c                                 |  43 ++-
 fs/ntfs3/fsntfs.c                                  |   9 +-
 fs/ntfs3/inode.c                                   |   2 +
 fs/ntfs3/ntfs_fs.h                                 |   9 +-
 fs/ntfs3/run.c                                     |   6 +-
 fs/ntfs3/super.c                                   |   5 +
 fs/ocfs2/alloc.c                                   |   1 -
 fs/ocfs2/move_extents.c                            |   8 +-
 fs/ocfs2/suballoc.c                                |  10 +
 fs/smb/client/fs_context.c                         |   4 +-
 fs/smb/server/mgmt/tree_connect.c                  |  18 +-
 fs/smb/server/mgmt/tree_connect.h                  |   1 -
 fs/smb/server/mgmt/user_session.c                  |   4 +-
 fs/smb/server/smb2pdu.c                            |  20 +-
 fs/smb/server/transport_ipc.c                      |   7 +-
 fs/smb/server/vfs.c                                |   5 +-
 fs/smb/server/vfs_cache.c                          |  88 +++--
 fs/tracefs/event_inode.c                           |   3 +-
 fs/xfs/xfs_buf_item.c                              |   1 +
 include/linux/balloon_compaction.h                 |  43 +--
 include/linux/blk_types.h                          |   5 +-
 include/linux/compiler_types.h                     |  13 +
 include/linux/cper.h                               |  12 +-
 include/linux/filter.h                             |  16 +-
 include/linux/genalloc.h                           |   1 +
 include/linux/ieee80211.h                          |   4 +-
 include/linux/if_bridge.h                          |   6 +-
 include/linux/jbd2.h                               |   6 +
 include/linux/kasan.h                              |  15 +
 include/linux/mm.h                                 |  10 +-
 include/linux/nfs_fs_sb.h                          |   7 +-
 include/linux/nfs_xdr.h                            |  54 +--
 include/linux/platform_data/lp855x.h               |   4 +-
 include/linux/rculist_nulls.h                      |  59 ++++
 include/linux/reset.h                              |   1 +
 include/linux/sched/topology.h                     |   3 +
 include/linux/tpm.h                                |   8 +-
 include/linux/tty_port.h                           |  21 +-
 include/linux/virtio_config.h                      |   6 +-
 include/media/v4l2-mem2mem.h                       |   3 +-
 include/net/ip6_fib.h                              |  46 ++-
 include/net/netfilter/nf_conntrack_count.h         |  15 +-
 include/net/netfilter/nf_tables.h                  |   4 +-
 include/net/sock.h                                 |  13 +
 include/net/xfrm.h                                 |  13 +-
 include/rdma/ib_verbs.h                            |   2 +
 include/sound/snd_wavefront.h                      |   4 -
 include/uapi/linux/mptcp.h                         |   1 +
 include/uapi/sound/asound.h                        |   2 +-
 io_uring/openclose.c                               |   2 +-
 io_uring/poll.c                                    |   9 +-
 kernel/bpf/hashtab.c                               |  10 +-
 kernel/bpf/syscall.c                               |   3 +
 kernel/bpf/trampoline.c                            |   7 +-
 kernel/cgroup/cpuset.c                             |  35 +-
 kernel/dma/pool.c                                  |   2 +-
 kernel/irq/irq_sim.c                               |   2 +-
 kernel/kallsyms.c                                  |   5 +-
 kernel/livepatch/core.c                            |   8 +-
 kernel/locking/spinlock_debug.c                    |   4 +-
 kernel/resource.c                                  |  78 +++--
 kernel/sched/core.c                                |   3 +
 kernel/sched/cpudeadline.c                         |  34 +-
 kernel/sched/cpudeadline.h                         |   4 +-
 kernel/sched/deadline.c                            |   8 +-
 kernel/sched/fair.c                                |  89 +++--
 kernel/sched/features.h                            |   5 +
 kernel/sched/sched.h                               |   7 +
 kernel/sched/topology.c                            |   6 +
 kernel/scs.c                                       |   2 +-
 kernel/task_work.c                                 |   8 +-
 kernel/trace/ftrace.c                              |  40 ++-
 kernel/trace/trace_events.c                        |   2 +
 kernel/trace/trace_events_synth.c                  |   1 -
 lib/idr.c                                          |   2 +
 lib/vsprintf.c                                     |   6 +-
 mm/balloon_compaction.c                            |   9 +-
 mm/damon/core-test.h                               | 110 +++++-
 mm/damon/vaddr-test.h                              |  26 +-
 mm/kasan/common.c                                  |  17 +
 mm/ksm.c                                           |  18 +-
 mm/page-writeback.c                                |   4 +-
 mm/vmalloc.c                                       |   4 +-
 net/bluetooth/rfcomm/tty.c                         |   7 +-
 net/bridge/br_ioctl.c                              |  36 +-
 net/bridge/br_private.h                            |   4 +-
 net/bridge/netfilter/nft_meta_bridge.c             |   2 +-
 net/caif/cffrml.c                                  |   9 +-
 net/ceph/osdmap.c                                  | 116 +++----
 net/core/dev.c                                     | 172 +++++++---
 net/core/dev_ioctl.c                               |  16 -
 net/core/filter.c                                  |   9 +-
 net/core/page_pool.c                               |  27 +-
 net/ethtool/ioctl.c                                |  30 +-
 net/handshake/request.c                            |   8 +-
 net/hsr/hsr_forward.c                              |   2 +
 net/ipv4/fib_trie.c                                |   7 +-
 net/ipv4/inet_hashtables.c                         |   8 +-
 net/ipv4/ipcomp.c                                  |   2 +
 net/ipv4/netfilter/nft_dup_ipv4.c                  |   4 +-
 net/ipv6/addrconf.c                                |  58 +++-
 net/ipv6/calipso.c                                 |   3 +-
 net/ipv6/ip6_fib.c                                 |  64 +++-
 net/ipv6/ip6_gre.c                                 |   9 +-
 net/ipv6/ipcomp6.c                                 |   2 +
 net/ipv6/ndisc.c                                   |  10 +-
 net/ipv6/netfilter/nft_dup_ipv6.c                  |   4 +-
 net/ipv6/route.c                                   |  14 +-
 net/ipv6/xfrm6_tunnel.c                            |   2 +-
 net/key/af_key.c                                   |   2 +-
 net/mac80211/aes_cmac.c                            |  63 +++-
 net/mac80211/aes_cmac.h                            |   8 +-
 net/mac80211/cfg.c                                 |  10 -
 net/mac80211/drop.h                                |  33 +-
 net/mac80211/rx.c                                  |  57 ++--
 net/mac80211/wep.c                                 |   9 +-
 net/mac80211/wpa.c                                 |  62 ++--
 net/mptcp/options.c                                |  10 +
 net/mptcp/pm_netlink.c                             |   3 +-
 net/mptcp/protocol.c                               |  36 +-
 net/mptcp/protocol.h                               |   9 +-
 net/mptcp/subflow.c                                |  10 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   3 +
 net/netfilter/nf_conncount.c                       | 208 ++++++++----
 net/netfilter/nf_tables_api.c                      |  52 ++-
 net/netfilter/nft_bitwise.c                        |   4 +-
 net/netfilter/nft_byteorder.c                      |   2 +-
 net/netfilter/nft_cmp.c                            |   6 +-
 net/netfilter/nft_connlimit.c                      |  34 +-
 net/netfilter/nft_ct.c                             |   2 +-
 net/netfilter/nft_dup_netdev.c                     |   2 +-
 net/netfilter/nft_dynset.c                         |   4 +-
 net/netfilter/nft_exthdr.c                         |   2 +-
 net/netfilter/nft_flow_offload.c                   |   9 +-
 net/netfilter/nft_fwd_netdev.c                     |   6 +-
 net/netfilter/nft_hash.c                           |   2 +-
 net/netfilter/nft_lookup.c                         |   2 +-
 net/netfilter/nft_masq.c                           |   4 +-
 net/netfilter/nft_meta.c                           |   2 +-
 net/netfilter/nft_nat.c                            |   8 +-
 net/netfilter/nft_objref.c                         |   2 +-
 net/netfilter/nft_payload.c                        |   2 +-
 net/netfilter/nft_queue.c                          |   2 +-
 net/netfilter/nft_range.c                          |   2 +-
 net/netfilter/nft_redir.c                          |   4 +-
 net/netfilter/nft_tproxy.c                         |   4 +-
 net/netfilter/xt_connlimit.c                       |  14 +-
 net/netrom/nr_out.c                                |   4 +-
 net/nfc/core.c                                     |   9 +-
 net/openvswitch/conntrack.c                        |  16 +-
 net/openvswitch/flow_netlink.c                     |  13 +-
 net/openvswitch/vport-netdev.c                     |  17 +-
 net/rose/af_rose.c                                 |   2 +-
 net/sched/sch_cake.c                               |  60 ++--
 net/sched/sch_ets.c                                |   6 +-
 net/sctp/socket.c                                  |   5 +-
 net/socket.c                                       |  19 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |   3 +-
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  |   5 +-
 net/wireless/sme.c                                 |   2 +-
 net/xfrm/xfrm_ipcomp.c                             |   1 -
 net/xfrm/xfrm_state.c                              | 125 ++++---
 net/xfrm/xfrm_user.c                               |   2 +-
 samples/ftrace/ftrace-direct-modify.c              |   8 +-
 samples/ftrace/ftrace-direct-multi-modify.c        |   8 +-
 samples/ftrace/ftrace-direct-multi.c               |   4 +-
 samples/ftrace/ftrace-direct-too.c                 |   4 +-
 samples/ftrace/ftrace-direct.c                     |   4 +-
 samples/vfs/test-statx.c                           |   6 +
 samples/watch_queue/watch_test.c                   |   6 +
 scripts/Makefile.modinst                           |   2 +-
 security/integrity/ima/ima_policy.c                |   2 +-
 security/keys/trusted-keys/trusted_tpm2.c          |   6 +-
 security/smack/smack_lsm.c                         |  41 ++-
 sound/firewire/dice/dice-extension.c               |   4 +-
 sound/firewire/motu/motu-hwdep.c                   |   7 +-
 sound/isa/wavefront/wavefront.c                    |  61 ++--
 sound/isa/wavefront/wavefront_fx.c                 |  36 +-
 sound/isa/wavefront/wavefront_midi.c               | 146 ++++----
 sound/isa/wavefront/wavefront_synth.c              | 216 ++++++------
 sound/pci/hda/cs35l41_hda.c                        |   2 +
 sound/pcmcia/pdaudiocf/pdaudiocf.c                 |   8 +-
 sound/pcmcia/vx/vxpocket.c                         |   8 +-
 sound/soc/bcm/bcm63xx-pcm-whistler.c               |   4 +-
 sound/soc/codecs/ak4458.c                          |  10 +-
 sound/soc/codecs/ak5558.c                          |  10 +-
 sound/soc/fsl/fsl_xcvr.c                           |   2 +-
 sound/soc/intel/catpt/pcm.c                        |   4 +-
 sound/soc/qcom/qdsp6/q6adm.c                       | 146 ++++----
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |   2 +
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |   7 +-
 sound/soc/stm/stm32_sai.c                          |  14 +-
 sound/soc/stm/stm32_sai_sub.c                      |  51 ++-
 sound/usb/mixer_us16x08.c                          |  20 +-
 sound/usb/quirks.c                                 |   6 +
 tools/include/nolibc/stdio.h                       |   4 +
 tools/lib/perf/cpumap.c                            |  10 +-
 tools/mm/page_owner_sort.c                         |   6 +-
 tools/objtool/check.c                              |   3 +-
 tools/objtool/elf.c                                |   8 +-
 tools/perf/builtin-record.c                        |   2 +-
 .../util/arm-spe-decoder/arm-spe-pkt-decoder.c     |  37 +-
 .../util/arm-spe-decoder/arm-spe-pkt-decoder.h     |  26 +-
 tools/perf/util/bpf_lock_contention.c              |   6 +-
 tools/perf/util/maps.c                             |  13 +
 tools/perf/util/maps.h                             |   2 +
 tools/perf/util/symbol.c                           |   4 +-
 tools/testing/ktest/config-bisect.pl               |   4 +-
 tools/testing/nvdimm/test/nfit.c                   |   7 +-
 tools/testing/radix-tree/idr-test.c                |  21 ++
 .../selftests/bpf/prog_tests/perf_branches.c       |  22 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |   5 +
 .../selftests/bpf/progs/test_perf_branches.c       |   3 +
 .../testing/selftests/drivers/net/bonding/Makefile |   2 +-
 .../selftests/drivers/net/bonding/bond_macvlan.sh  |  99 ------
 .../drivers/net/bonding/bond_macvlan_ipvlan.sh     |  97 ++++++
 tools/testing/selftests/drivers/net/bonding/config |   9 +
 .../test.d/ftrace/func_traceonoff_triggers.tc      |   5 +-
 .../testing/selftests/net/openvswitch/ovs-dpctl.py |  16 +-
 tools/testing/selftests/net/tap.c                  |  16 +-
 754 files changed, 6987 insertions(+), 4373 deletions(-)


