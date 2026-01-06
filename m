Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1561B346A15;
	Tue,  6 Jan 2026 17:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719783; cv=none; b=urlo5d2wcTMJMvtDaFR31FXTQ/ybQo2cT8j2K070OBdQXMtuk70K05HhXwgJmZ9eYEmX8DhJEdb6QVSzw+0uupSv2yu5Tyr8LutaLpkeuw3v3Fq4oUdoZYa5mukTxNY/kM36Bl8mkKRt64xCb7CTw/66GqPtcZUNQm6DEneAHzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719783; c=relaxed/simple;
	bh=c1+lM1AUoy0NLNoz9Wkr/14bpSu+ONYcxbFvUlkXH2c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JQQYOemGJSZHLUtsJLYRDqC+heQyOB8jX2a0/2aMFf43gnua989dwp+EWNDr/LLA4rPNDHXGIMxkPNDlQ4DJM1BbBOAk6I7LP6th8Bz+NCYjM/cM3Pq18XNtHOtffn/I3rkeILHSnPi3o3LFgv/yZJqbAhFkmIh4hntRgbUDlyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5+yiikG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5+yiikG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEBEC116C6;
	Tue,  6 Jan 2026 17:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719782;
	bh=c1+lM1AUoy0NLNoz9Wkr/14bpSu+ONYcxbFvUlkXH2c=;
	h=From:To:Cc:Subject:Date:From;
	b=b5+yiikGOqVz2EJ6XjvaP9epaM35+96V71VXg5f3aZfeFjGr+9i75qyxkFsANrX+V
	 cpA1GN/NFAFmQjSygS+bO7BSIqQYOp9qDeMvIn3VOoiKuoNxcZ3aR0bWqp82jLC/RN
	 YIZmPWRFnAvMFhn0z8KKZa7UMC1pdPPUyTzJOj8k=
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
Subject: [PATCH 6.12 000/567] 6.12.64-rc1 review
Date: Tue,  6 Jan 2026 17:56:22 +0100
Message-ID: <20260106170451.332875001@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.64-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.64-rc1
X-KernelTest-Deadline: 2026-01-08T17:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.64 release.
There are 567 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 08 Jan 2026 17:03:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.64-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.64-rc1

Damien Le Moal <dlemoal@kernel.org>
    block: fix NULL pointer dereference in blk_zone_reset_all_bio_endio()

Christoph Hellwig <hch@lst.de>
    iomap: allocate s_dio_done_wq for async reads as well

SeongJae Park <sj@kernel.org>
    mm/damon/tests/vaddr-kunit: handle alloc failures on damon_do_test_apply_three_regions()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failres in damon_test_new_filter()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_regions_of()

Kevin Tian <kevin.tian@intel.com>
    vfio/pci: Disable qword access to the PCI ROM bar

Ming Qian <ming.qian@oss.nxp.com>
    media: amphion: Remove vpu_vb_is_codecconfig

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: amphion: Make some vpu_v4l2 functions static

Ming Qian <ming.qian@oss.nxp.com>
    media: amphion: Add a frame flush mode for decoder

Chen-Yu Tsai <wenst@chromium.org>
    media: mediatek: vcodec: Use spinlock for context list protection lock

David Hildenbrand <david@redhat.com>
    powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages

David Hildenbrand <david@redhat.com>
    mm/balloon_compaction: convert balloon_page_delete() to balloon_page_finalize()

David Hildenbrand <david@redhat.com>
    mm/balloon_compaction: we cannot have isolated pages in the balloon list

Jim Quinlan <james.quinlan@broadcom.com>
    PCI: brcmstb: Fix disabling L0s capability

Jim Quinlan <james.quinlan@broadcom.com>
    PCI: brcmstb: Set MLW based on "num-lanes" DT property if present

Stanimir Varbanov <svarbanov@suse.de>
    PCI: brcmstb: Reuse pcie_cfg_data structure

Biju Das <biju.das.jz@bp.renesas.com>
    ASoC: renesas: rz-ssi: Fix rz_ssi_priv::hw_params_cache::sample_width

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: sdw: fix memory leak for sdw_stream_runtime

Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
    soundwire: stream: extend sdw_alloc_stream() to take 'type' parameter

Damien Le Moal <dlemoal@kernel.org>
    block: handle zone management operations completions

Biju Das <biju.das.jz@bp.renesas.com>
    ASoC: renesas: rz-ssi: Fix channel swap issue in full duplex mode

Ankit Garg <nktgrg@google.com>
    gve: defer interrupt enabling until NAPI registration

Thomas Gleixner <tglx@linutronix.de>
    hrtimers: Make hrtimer_update_function() less expensive

Joshua Hay <joshua.a.hay@intel.com>
    idpf: remove obsolete stashing code

Joshua Hay <joshua.a.hay@intel.com>
    idpf: stop Tx if there are insufficient buffer resources

Joshua Hay <joshua.a.hay@intel.com>
    idpf: replace flow scheduling buffer ring with buffer pool

Joshua Hay <joshua.a.hay@intel.com>
    idpf: simplify and fix splitq Tx packet rollback error path

Joshua Hay <joshua.a.hay@intel.com>
    idpf: improve when to set RE bit logic

Joshua Hay <joshua.a.hay@intel.com>
    idpf: add support for Tx refillqs in flow scheduling mode

Joshua Hay <joshua.a.hay@intel.com>
    idpf: trigger SW interrupt when exiting wb_on_itr mode

Joshua Hay <joshua.a.hay@intel.com>
    idpf: add support for SW triggered interrupts

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt7925: add handler to hif suspend/resume event

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt7925: fix CLC command timeout when suspend/resume

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt7925: fix the unfinished command of regd_notifier before suspend

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: i2c: imx219: Fix 1920x1080 mode to use 1:1 pixel aspect ratio

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Select which microcode patch to load

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: fix tty_port_tty_*hangup() kernel-doc

Alexander Stein <alexander.stein@ew.tq-group.com>
    serial: core: Fix serial device initialization

Zqiang <qiang.zhang@linux.dev>
    usbnet: Fix using smp_processor_id() in preemptible code warnings

Eric Dumazet <edumazet@google.com>
    net: use dst_dev_rcu() in sk_setup_caps()

Eric Dumazet <edumazet@google.com>
    ipv6: adopt dst_dev() helper

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: ioam6: use consistent dst names

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Flush shmem writes before mapping buffers CPU-uncached

Xiao Ni <xni@redhat.com>
    md/raid10: wait barrier before returning discard request with REQ_NOWAIT

Andrii Melnychenko <a.melnychenko@vyos.io>
    netfilter: nft_ct: add seqadj extension for natted connections

Askar Safin <safinaskar@gmail.com>
    gpiolib: acpi: Add quirk for Dell Precision 7780

Mario Limonciello (AMD) <superm1@kernel.org>
    gpiolib: acpi: Add quirk for ASUS ProArt PX13

Mario Limonciello <mario.limonciello@amd.com>
    gpiolib: acpi: Add a quirk for Acer Nitro V15

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: acpi: Move quirks to a separate file

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: acpi: Add acpi_gpio_need_run_edge_events_on_boot() getter

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: acpi: Handle deferred list via new API

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: acpi: Switch to use enum in acpi_gpio_in_ignore_list()

Chao Yu <chao@kernel.org>
    f2fs: fix to propagate error from f2fs_enable_checkpoint()

Chao Yu <chao@kernel.org>
    f2fs: dump more information for f2fs_{enable,disable}_checkpoint()

Chao Yu <chao@kernel.org>
    f2fs: add timeout in f2fs_enable_checkpoint()

Sheng Yong <shengyong@oppo.com>
    f2fs: clear SBI_POR_DOING before initing inmem curseg

j.turek <jakub.turek@elsta.tech>
    serial: xilinx_uartps: fix rs485 delay_rts_after_send

Nam Cao <namcao@linutronix.de>
    serial: xilinx_uartps: Use helper function hrtimer_update_function()

Nam Cao <namcao@linutronix.de>
    hrtimers: Introduce hrtimer_update_function()

Jani Nikula <jani.nikula@intel.com>
    drm/displayid: add quirk to ignore DisplayID checksum errors

Tejun Heo <tj@kernel.org>
    sched_ext: Fix missing post-enqueue handling in move_local_task_to_local_dsq()

Tejun Heo <tj@kernel.org>
    sched_ext: Factor out local_dsq_post_enq() from dispatch_enqueue()

Jarkko Sakkinen <jarkko@kernel.org>
    tpm2-sessions: Fix tpm2_read_public range checks

Damien Le Moal <dlemoal@kernel.org>
    block: freeze queue when updating zone resources

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: dts: microchip: sama7g5: fix uart fifo size to 32

Joshua Rogers <linux@joshua.hu>
    svcrdma: bound check rq_pages index in inline path

xu xin <xu.xin16@zte.com.cn>
    mm/ksm: fix exec/fork inheritance support for prctl

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ignore unknown endpoint flags

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: core: Restore sysfs fwnode information

Johan Hovold <johan@kernel.org>
    serial: core: fix OF node leak

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid updating compression context during writeback

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: drop inode from the donation list when the last file is closed

Chao Yu <chao@kernel.org>
    f2fs: use global inline_xattr_slab instead of per-sb slab cache

Chao Yu <chao@kernel.org>
    f2fs: fix to detect recoverable inode during dryrun of find_fsync_dnodes()

Łukasz Bartosik <ukaszb@chromium.org>
    xhci: dbgtty: fix device unregister: fixup

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: introduce and use tty_port_tty_vhangup() helper

Ye Bin <yebin10@huawei.com>
    jbd2: fix the inconsistency between checksum and data in memory for journal sb

Zqiang <qiang.zhang@linux.dev>
    sched_ext: Fix incorrect sched_class settings for per-cpu migration tasks

Junbeom Yeom <junbeom.yeom@samsung.com>
    erofs: fix unexpected EIO under memory pressure

Peter Zijlstra <peterz@infradead.org>
    sched/eevdf: Fix min_vruntime vs avg_vruntime

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't rewrite ret from inode_permission

Alexey Velichayshiy <a.velichayshiy@ispras.ru>
    gfs2: fix freeze error handling

Vivian Wang <wangruikang@iscas.ac.cn>
    lib/crypto: riscv/chacha: Avoid s0/fp register

Alessio Belle <alessio.belle@imgtec.com>
    drm/imagination: Disallow exporting of PM/FW protected objects

Lyude Paul <lyude@redhat.com>
    drm/nouveau/dispnv50: Don't call drm_atomic_get_crtc_state() in prepare_fb

Krzysztof Niemiec <krzysztof.niemiec@intel.com>
    drm/i915/gem: Zero-initialize the eb.vma array in i915_gem_do_execbuffer

Nikolay Kuratov <kniv@yandex-team.ru>
    drm/msm/dpu: Add missing NULL pointer check for pingpong interface

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Drop preempt-fences when destroying imported dma-bufs.

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Use usleep_range for accurate long-running workload timeslicing

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Adjust long-running workload timeslices to reasonable values

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: Disallow 0 OA property values

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe/bo: Don't include the CCS metadata in the dma-buf sg-table

René Rebe <rene@exactco.de>
    drm/mgag200: Fix big-endian support

Simon Richter <Simon.Richter@hogyros.de>
    drm/ttm: Avoid NULL pointer deref for evicted BOs

Ard Biesheuvel <ardb@kernel.org>
    drm/i915: Fix format string truncation warning

Jay Cornwall <jay.cornwall@amd.com>
    drm/amdkfd: Trap handler support for expert scheduling mode

Jonathan Kim <jonathan.kim@amd.com>
    drm/amdkfd: bump minimum vgpr size for gfx1151

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdkfd: Export the cwsr_size and ctl_stack_size to userspace

Johan Hovold <johan@kernel.org>
    drm/mediatek: Fix probe device leaks

Johan Hovold <johan@kernel.org>
    drm/mediatek: Fix probe memory leak

Johan Hovold <johan@kernel.org>
    drm/mediatek: Fix probe resource leaks

Miaoqian Lin <linmq006@gmail.com>
    drm/mediatek: Fix device node reference leak in mtk_dp_dt_parse()

Sanjay Yadav <sanjay.kumar.yadav@intel.com>
    drm/xe/oa: Fix potential UAF in xe_oa_add_config_ioctl()

Jani Nikula <jani.nikula@intel.com>
    drm/edid: add DRM_EDID_IDENT_INIT() to initialize struct drm_edid_ident

Thomas Zimmermann <tzimmermann@suse.de>
    drm/gma500: Remove unused helper psb_fbdev_fb_setcolreg()

Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
    drm/buddy: Separate clear and dirty free block trees

Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
    drm/buddy: Optimize free block management with RB tree

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix out of bound IO access in a6xx_get_gmu_registers

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gmc11: add amdgpu_vm_handle_fault() handling

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu: add missing lock to amdgpu_ttm_access_memory_sdma

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gmc12: add amdgpu_vm_handle_fault() handling

Mario Limonciello (AMD) <superm1@kernel.org>
    Revert "drm/amd: Skip power ungate during suspend for VPE"

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

Chenghao Duan <duanchenghao@kylinos.cn>
    LoongArch: Refactor register restoration in ftrace_common_return

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

Ran Xiaokai <ran.xiaokai@zte.com.cn>
    mm/page_owner: fix memory leak in page_owner_stack_fops->release()

Matthew Wilcox (Oracle) <willy@infradead.org>
    idr: fix idr_alloc() returning an ID out of range

NeilBrown <neil@brown.name>
    lockd: fix vfs_test_lock() calls

Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
    kasan: unpoison vms[area] addresses with a common tag

Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
    kasan: refactor pcpu kasan vmalloc unpoison

Jiayuan Chen <jiayuan.chen@linux.dev>
    mm/kasan: fix incorrect unpoisoning in vrealloc for KASAN

H. Peter Anvin <hpa@zytor.com>
    compiler_types.h: add "auto" as a macro for "__auto_type"

Wentao Liang <vulab@iscas.ac.cn>
    pmdomain: imx: Fix reference count leak in imx_gpc_probe()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failure on damon_test_set_attrs()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures in damon_test_ops_registration()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures in damon_test_update_monitoring_result()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures in damon_test_set_regions()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures on damon_test_merge_two()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures on dasmon_test_merge_regions_of()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle memory alloc failure from damon_test_aggregate()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle memory failure from damon_test_target()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle allocation failures in damon_test_regions()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_at()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/vaddr-kunit: handle alloc failures on damon_test_split_evenly_succ()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/vaddr-kunit: handle alloc failures in damon_test_split_evenly_fail()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/sysfs-kunit: handle alloc failures on damon_sysfs_test_add_targets()

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

Johan Hovold <johan@kernel.org>
    media: platform: mtk-mdp3: fix device leaks at probe

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

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Fix the return value of amd_uncore_df_event_init() on error

Sven Schnelle <svens@stackframe.org>
    parisc: entry: set W bit for !compat tasks in syscall_restore_rfi()

Sven Schnelle <svens@stackframe.org>
    parisc: entry.S: fix space adjustment on interruption for 64-bit userspace

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spi-nor: winbond: Add support for W25H02NWxxAM chips

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spi-nor: winbond: Add support for W25H01NWxxAM chips

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spi-nor: winbond: Add support for W25H512NWxxAM chips

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spi-nor: winbond: Add support for W25Q02NWxxIM chips

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spi-nor: winbond: Add support for W25Q01NWxxIM chips

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spi-nor: winbond: Add support for W25Q01NWxxIQ chips

Christian Marangi <ansuelsmth@gmail.com>
    mtd: mtdpart: ignore error -ENOENT from parsers on subpartitions

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: verisilicon: Fix CPU stalls on G2 bus error

Haotian Zhang <vulab@iscas.ac.cn>
    media: rc: st_rc: Fix reset control resource leak

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mfd: max77620: Fix potential IRQ chip conflict when probing two devices

Johan Hovold <johan@kernel.org>
    mfd: altera-sysmgr: Fix device leak on sysmgr regmap lookup

Nathan Chancellor <nathan@kernel.org>
    clk: samsung: exynos-clkout: Assign .num before accessing .hws

Damien Le Moal <dlemoal@kernel.org>
    block: Clear BLK_ZONE_WPLUG_PLUGGED when aborting plugged BIOs

Christian Hitz <christian.hitz@bbv.ch>
    leds: leds-lp50xx: Enable chip before any communication

Christian Hitz <christian.hitz@bbv.ch>
    leds: leds-lp50xx: LP5009 supports 3 modules for a total of 9 LEDs

Christian Hitz <christian.hitz@bbv.ch>
    leds: leds-lp50xx: Allow LED 0 to be added to module bank

Thomas Weißschuh <linux@weissschuh.net>
    leds: leds-cros_ec: Skip LEDs without color components

Donet Tom <donettom@linux.ibm.com>
    powerpc/64s/slb: Fix SLB multihit issue during SLB preload

Dave Vasilevsky <dave@vasilevsky.ca>
    powerpc, mm: Fix mprotect on book3s 32-bit

Siddharth Vadapalli <s-vadapalli@ti.com>
    arm64: dts: ti: k3-j721e-sk: Fix pinmux for pin Y1 used by power regulator

Lukas Wunner <lukas@wunner.de>
    PCI/PM: Reinstate clearing state_saved in legacy and !PM codepaths

Shengming Hu <hu.shengming@zte.com.cn>
    fgraph: Check ftrace_pids_enabled on registration for early filtering

Shengming Hu <hu.shengming@zte.com.cn>
    fgraph: Initialize ftrace_ops->private for function graph ops

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
    iommu/amd: Propagate the error code returned by __modify_irte_ga() in modify_irte_ga()

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

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: codecs: lpass-tx-macro: fix SM6115 support

Johan Hovold <johan@kernel.org>
    ASoC: stm32: sai: fix OF node leak on probe

Johan Hovold <johan@kernel.org>
    ASoC: stm32: sai: fix clk prepare imbalance on probe failure

Johan Hovold <johan@kernel.org>
    ASoC: stm32: sai: fix device leak on probe

Johan Hovold <johan@kernel.org>
    ASoC: codecs: wcd939x: fix regmap leak on probe failure

Matthew Wilcox (Oracle) <willy@infradead.org>
    ntfs: Do not overwrite uptodate pages

Yipeng Zou <zouyipeng@huawei.com>
    selftests/ftrace: traceonoff_triggers: strip off names

Cong Zhang <cong.zhang@oss.qualcomm.com>
    blk-mq: skip CPU offline notify on unmapped hctx

Thomas Fourier <fourier.thomas@gmail.com>
    RDMA/bnxt_re: fix dma_free_coherent() pointer

Honggang LI <honggangli@163.com>
    RDMA/rtrs: Fix clt_path::max_pages_per_mr calculation

Zilin Guan <zilin@seu.edu.cn>
    ksmbd: Fix memory leak in get_file_all_info()

Tuo Li <islituo@gmail.com>
    md/raid5: fix possible null-pointer dereferences in raid5_store_group_thread_cnt()

Li Nan <linan122@huawei.com>
    md: Fix static checker warning in analyze_sbs

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix to use correct page size for PDE table

Alok Tiwari <alok.a.tiwari@oracle.com>
    RDMA/bnxt_re: Fix IB_SEND_IP_CSUM handling in post_send

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    RDMA/core: always drop device refcount in ib_del_sub_device_and_put()

Alok Tiwari <alok.a.tiwari@oracle.com>
    RDMA/bnxt_re: Fix incorrect BAR check in bnxt_qplib_map_creq_db()

Jang Ingyu <ingyujang25@korea.ac.kr>
    RDMA/core: Fix logic error in ib_get_gids_from_rdma_hdr()

Michael Margolin <mrgolin@amazon.com>
    RDMA/efa: Remove possible negative shift

Michal Schmidt <mschmidt@redhat.com>
    RDMA/irdma: avoid invalid read in irdma_net_event

Jiayuan Chen <jiayuan.chen@linux.dev>
    ipv6: fix a BUG in rt6_get_pcpu_route() under PREEMPT_RT

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

Zilin Guan <zilin@seu.edu.cn>
    vfio/pds: Fix memory leak in pds_vfio_dirty_enable()

Bagas Sanjaya <bagasdotme@gmail.com>
    net: bridge: Describe @tunnel_hash member in net_bridge_vlan_group struct

Deepanshu Kartikey <kartikey406@gmail.com>
    net: usb: asix: validate PHY address before use

Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>
    kbuild: fix compilation of dtb specified on command-line without make rule

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

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix missing put_device() in dsa_tree_find_first_conduit()

Jiri Pirko <jiri@resnulli.us>
    team: fix check for port enabled in team_queue_override_port_prio_changed()

Junrui Luo <moonafterrain@outlook.com>
    platform/x86: ibm_rtl: fix EBDA signature search pointer arithmetic

Thomas Fourier <fourier.thomas@gmail.com>
    platform/x86: msi-laptop: add missing sysfs_remove_group()

Shravan Kumar Ramani <shravankr@nvidia.com>
    platform/mellanox: mlxbf-pmc: Remove trailing whitespaces from event names

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

Brian Vazquez <brianvv@google.com>
    idpf: reduce mbx_task schedule delay to 300us

Kohei Enju <enjuk@amazon.com>
    iavf: fix off-by-one issues in iavf_config_rss_reg()

Gregory Herrero <gregory.herrero@oracle.com>
    i40e: validate ring_len parameter against hardware-specific values

Przemyslaw Korba <przemyslaw.korba@intel.com>
    i40e: fix scheduling in set_rx_mode

Aloka Dixit <aloka.dixit@oss.qualcomm.com>
    wifi: mac80211: do not use old MBSSID elements

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: cfg80211: sme: store capped length in __cfg80211_connect_result()

Morning Star <alexbestoso@gmail.com>
    wifi: rtlwifi: 8192cu: fix tid out of range in rtl92cu_tx_fill_desc()

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw88: limit indirect IO under powered off for RTL8822CS

Joanne Koong <joannelkoong@gmail.com>
    fuse: fix readahead reclaim deadlock

Johan Hovold <johan@kernel.org>
    iommu/mediatek: fix use-after-free on probe deferral

Thomas Gleixner <tglx@linutronix.de>
    x86/msi: Make irq_retrigger() functional for posted MSI

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: dts: microchip: sama5d2: fix spi flexcom fifo size to 32

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (w83l786ng) Convert macros to functions to avoid TOCTOU

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (w83791d) Convert macros to functions to avoid TOCTOU

Johan Hovold <johan@kernel.org>
    hwmon: (max6697) fix regmap leak on probe failure

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (max16065) Use local variable to avoid TOCTOU

Raviteja Laggyshetty <quic_rlaggysh@quicinc.com>
    interconnect: qcom: sdx75: Drop QPIC interconnect and BCM nodes

Ma Ke <make24@iscas.ac.cn>
    i2c: amd-mp2: fix reference leak in MP2 PCI device

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    platform/x86: intel: chtwc_int33fe: don't dereference swnode args

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    rpmsg: glink: fix rpmsg device leak

Johan Hovold <johan@kernel.org>
    soc: amlogic: canvas: fix device leak on lookup

Johan Hovold <johan@kernel.org>
    soc: apple: mailbox: fix device leak on lookup

Johan Hovold <johan@kernel.org>
    soc: qcom: ocmem: fix device leak on lookup

Johan Hovold <johan@kernel.org>
    soc: qcom: pbs: fix device leak on lookup

Johan Hovold <johan@kernel.org>
    soc: samsung: exynos-pmu: fix device leak on regmap lookup

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix fixed array of synthetic event

Miaoqian Lin <linmq006@gmail.com>
    virtio: vdpa: Fix reference count leak in octep_sriov_enable()

Johan Hovold <johan@kernel.org>
    amba: tegra-ahb: Fix device leak on SMMU enable

Guangshuo Li <lgs201920130244@gmail.com>
    crypto: caam - Add check for kcalloc() in test_len()

Shivani Agarwal <shivani.agarwal@broadcom.com>
    crypto: af_alg - zero initialize memory allocated via sock_kmalloc

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: PCI: qcom,pcie-sm8550: Add missing required power-domains and resets

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: PCI: qcom,pcie-sm8450: Add missing required power-domains and resets

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: PCI: qcom,pcie-sm8350: Add missing required power-domains and resets

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: PCI: qcom,pcie-sm8250: Add missing required power-domains and resets

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: PCI: qcom,pcie-sm8150: Add missing required power-domains and resets

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: PCI: qcom,pcie-sc8280xp: Add missing required power-domains and resets

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: PCI: qcom,pcie-sc7280: Add missing required power-domains and resets

Marc Zyngier <maz@kernel.org>
    arm64: Revamp HCR_EL2.E2H RES1 detection

Ahmed Genidi <ahmed.genidi@arm.com>
    KVM: arm64: Initialize SCTLR_EL1 in __kvm_hyp_init_cpu()

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Initialize HCR_EL2.E2H early

Harshit Agarwal <harshit@nutanix.com>
    sched/rt: Fix race in push_rt_task

Hangbin Liu <liuhangbin@gmail.com>
    hsr: hold rcu and dev lock for hsr_get_port_ndev

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Fix ISEL restore on resume

Junrui Luo <moonafterrain@outlook.com>
    ALSA: wavefront: Clear substream pointers on close

Takashi Iwai <tiwai@suse.de>
    ALSA: wavefront: Use guard() for spin locks

Denis Arefev <arefev@swemel.ru>
    ALSA: hda: cs35l41: Fix NULL pointer dereference in cs35l41_hda_read_acpi()

Jani Nikula <jani.nikula@intel.com>
    drm/displayid: pass iter to drm_find_displayid_extension()

Ray Wu <ray.wu@amd.com>
    drm/amd/display: Fix scratch registers offsets for DCN351

Ray Wu <ray.wu@amd.com>
    drm/amd/display: Fix scratch registers offsets for DCN35

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: Use GFP_ATOMIC in dc_create_plane_state()

Mario Limonciello <mario.limonciello@amd.com>
    Revert "drm/amd/display: Fix pbn to kbps Conversion"

Jens Axboe <axboe@kernel.dk>
    io_uring: fix min_wait wakeups for SQPOLL

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
    svcrdma: use rc_pageoff for memcpy byte offset

Joshua Rogers <linux@joshua.hu>
    svcrdma: return 0 on success from svc_rdma_copy_inline_range

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    nfsd: Mark variable __maybe_unused to avoid W=1 build break

Chuck Lever <chuck.lever@oracle.com>
    NFSD: NFSv4 file creation neglects setting ACL

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clear SECLABEL in the suppattr_exclcreat bitmap

caoping <caoping@cmss.chinamobile.com>
    net/handshake: restore destructor on submit failure

Amir Goldstein <amir73il@gmail.com>
    fsnotify: do not generate ACCESS/MODIFY events on child for special files

Thorsten Blum <thorsten.blum@linux.dev>
    net: phy: marvell-88q2xxx: Fix clamped value in mv88q2xxx_hwmon_write

René Rebe <rene@exactco.de>
    r8169: fix RTL8117 Wake-on-Lan in DASH mode

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Do not clear needs_force_resume with enabled runtime PM

Steven Rostedt <rostedt@goodmis.org>
    tracing: Do not register unsupported perf events

Darrick J. Wong <djwong@kernel.org>
    xfs: fix a UAF problem in xattr repair

Darrick J. Wong <djwong@kernel.org>
    xfs: fix stupid compiler warning

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    xfs: fix a memory leak in xfs_buf_item_init()

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Clear exit_code_hi in VMCB when synthesizing nested VM-Exits

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Set exit_code_hi to -1 when synthesizing SVM_EXIT_ERR (failed VMRUN)

Dongli Zhang <dongli.zhang@oracle.com>
    KVM: nVMX: Immediately refresh APICv controls as needed on nested VM-Exit

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

Finn Thain <fthain@linux-m68k.org>
    powerpc: Add reloc_offset() to font bitmap pointer used for bootx_printf()

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

Sean Christopherson <seanjc@google.com>
    KVM: Disallow toggling KVM_MEM_GUEST_MEMFD on an existing memslot

Alison Schofield <alison.schofield@intel.com>
    tools/testing/nvdimm: Use per-DIMM device handle

Chao Yu <chao@kernel.org>
    f2fs: fix return value of f2fs_recover_fsync_data()

Xiaole He <hexiaole1994@126.com>
    f2fs: fix uninitialized one_time_gc in victim_sel_policy

Xiaole He <hexiaole1994@126.com>
    f2fs: fix age extent cache insertion skip on counter overflow

Deepanshu Kartikey <kartikey406@gmail.com>
    f2fs: invalidate dentry cache on failed whiteout creation

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid updating zero-sized extent in extent cache

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential deadlock

Jan Prusakowski <jprusakowski@google.com>
    f2fs: ensure node page reads complete before f2fs_put_super() finishes

Seunghwan Baek <sh8267.baek@samsung.com>
    scsi: ufs: core: Add ufshcd_update_evt_hist() for UFS suspend error

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Read missing IOCFacts flag for reply queue full overflow

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

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Check that the DMA cookie is valid

Junxiao Chang <junxiao.chang@intel.com>
    mei: gsc: add dependency on Xe driver

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
    usb: gadget: lpc32xx_udc: fix clock imbalance in error path

Johan Hovold <johan@kernel.org>
    usb: phy: isp1301: fix non-OF device reference imbalance

Duoming Zhou <duoming@zju.edu.cn>
    usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal

Ma Ke <make24@iscas.ac.cn>
    USB: lpc32xx_udc: Fix error handling in probe

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    usb: typec: altmodes/displayport: Drop the device reference in dp_altmode_probe()

Johan Hovold <johan@kernel.org>
    usb: ohci-nxp: fix device leak on probe failure

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

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: pm: ensure unknown flags are ignored

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

Fedor Pchelkin <pchelkin@ispras.ru>
    ext4: fix string copying in parse_apply_sb_mount_options()

Jarkko Sakkinen <jarkko.sakkinen@opinsys.com>
    tpm: Cap the number of PCR banks

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

Sven Eckelmann (Plasma Cloud) <se@simonwunderlich.de>
    wifi: mt76: Fix DTS power-limits on little endian systems

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Fix gendisk parent after copy pair swap

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: x86/blake2s: Fix 32-bit arg treated as 64-bit

Ma Ke <make24@iscas.ac.cn>
    perf: arm_cspmu: fix error handling in arm_cspmu_impl_unregister()

Sarthak Garg <sarthak.garg@oss.qualcomm.com>
    mmc: sdhci-msm: Avoid early clock doubling during HS400 transition

Avadhut Naik <avadhut.naik@amd.com>
    x86/mce: Do not clear bank's poll bit in mce_poll_banks on AMD SMCA systems

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

John Garry <john.g.garry@oracle.com>
    scsi: scsi_debug: Fix atomic write enable module param description

Gregory CLEMENT <gregory.clement@bootlin.com>
    MIPS: ftrace: Fix memory corruption when kernel is located beyond 32 bits

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    platform/x86/intel/hid: Add Dell Pro Rugged 10/12 tablet to VGBS DMI quirks

Justin Tee <justintee8345@gmail.com>
    nvme-fabrics: add ENOKEY to no retry criteria for authentication failures

Daniel Wagner <wagi@kernel.org>
    nvme-fc: don't hold rport lock when putting ctrl

Jinhui Guo <guojinhui.liam@bytedance.com>
    i2c: designware: Disable SMBus interrupts to prevent storms from mis-configured firmware

Jens Reidel <adrian@mainlining.org>
    clk: qcom: dispcc-sm7150: Fix dispcc_mdss_pclk0_clk_src

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
    exfat: zero out post-EOF page cache on file extension

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

David Strahan <David.Strahan@microchip.com>
    scsi: smartpqi: Add support for Hurray Data new controller PCI device

Matthias Schiffer <matthias.schiffer@tq-group.com>
    ti-sysc: allow OMAP2 and OMAP4 timers to be reserved on AM33xx

Peng Fan <peng.fan@nxp.com>
    firmware: imx: scu-irq: Init workqueue before request mbox channel

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Fix shutdown/suspend race condition

Jinhui Guo <guojinhui.liam@bytedance.com>
    ipmi: Fix __scan_channels() failing to rescan channels

Jinhui Guo <guojinhui.liam@bytedance.com>
    ipmi: Fix the race between __scan_channels() and deliver_response()

Shardul Bankar <shardul.b@mpiricsoftware.com>
    nfsd: fix memory leak in nfsd_create_serv error paths

Mike Snitzer <snitzer@kernel.org>
    nfsd: rename nfsd_serv_ prefixed methods and variables with nfsd_net_

Mike Snitzer <snitzer@kernel.org>
    nfsd: update percpu_ref to manage references on nfsd_net

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak4458: remove the reset operation in probe and remove

Shipei Qu <qu@darknavy.com>
    ALSA: usb-mixer: us16x08: validate meter packet indices

Haotian Zhang <vulab@iscas.ac.cn>
    ALSA: pcmcia: Fix resource leak in snd_pdacf_probe error path

Haotian Zhang <vulab@iscas.ac.cn>
    ALSA: vxpocket: Fix resource leak in vxpocket_probe error path

Yongxin Liu <yongxin.liu@windriver.com>
    x86/fpu: Fix FPU state core dump truncation on CPUs with no extended xfeatures

Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
    net/hsr: fix NULL pointer dereference in prp_get_untagged_frame()

Andrew Jeffery <andrew@codeconstruct.com.au>
    dt-bindings: mmc: sdhci-of-aspeed: Switch ref to sdhci-common.yaml

Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
    mmc: sdhci-of-arasan: Increase CD stable timeout to 2 seconds

Jared Kangas <jkangas@redhat.com>
    mmc: sdhci-esdhc-imx: add alternate ARCH_S32 dependency to Kconfig

Christophe Leroy <christophe.leroy@csgroup.eu>
    spi: fsl-cpm: Check length parity before switching to 16 bit mode

Pengjie Zhang <zhangpengjie2@huawei.com>
    ACPI: CPPC: Fix missing PCC check for guaranteed_perf

Pengjie Zhang <zhangpengjie2@huawei.com>
    ACPI: PCC: Fix race condition by removing static qualifier

Kartik Rajput <kkartik@nvidia.com>
    soc/tegra: fuse: Do not register SoC device on ACPI boot

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_can_open(): fix error handling

Christoph Hellwig <hch@lst.de>
    xfs: don't leak a locked dquot when xfs_dquot_attach_buf fails

Christoffer Sandberg <cs@tuxedo.de>
    Input: i8042 - add TUXEDO InfinityBook Max Gen10 AMD to i8042 quirk table

Duoming Zhou <duoming@zju.edu.cn>
    Input: alps - fix use-after-free bugs caused by dev3_register_work

Minseong Kim <ii4gsp@gmail.com>
    Input: lkkbd - disable pending work before freeing device

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

Nuno Sá <nuno.sa@analog.com>
    hwmon: (ltc4282): Fix reset_history file permissions

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/oa: Limit num_syncs to prevent oversized allocations

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe: Limit num_syncs to prevent oversized allocations

Thomas Fourier <fourier.thomas@gmail.com>
    block: rnbd-clt: Fix leaked ID in init_dev()

Anurag Dutta <a-dutta@ti.com>
    spi: cadence-quadspi: Fix clock disable on probe failure path

Jianpeng Chang <jianpeng.chang.cn@windriver.com>
    arm64: kdump: Fix elfcorehdr overlap caused by reserved memory processing reorder

Juergen Gross <jgross@suse.com>
    x86/xen: Fix sparse warning in enlighten_pv.c

Brian Gerst <brgerst@gmail.com>
    x86/xen: Move Xen upcall handler

Marijn Suijten <marijn.suijten@somainline.org>
    drm/panel: sony-td4353-jdi: Enable prepare_prev_first

Haoxiang Li <haoxiang_li2024@163.com>
    MIPS: Fix a reference leak bug in ip22_check_gio()

Jan Maslak <jan.maslak@intel.com>
    drm/xe: Restore engine registers before restarting schedulers after GT reset

Junxiao Chang <junxiao.chang@intel.com>
    drm/me/gsc: mei interrupt top half should be in irq disabled context

Alexey Simakov <bigalex934@gmail.com>
    hwmon: (tmp401) fix overflow caused by default conversion rate value

Junrui Luo <moonafterrain@outlook.com>
    hwmon: (ibmpex) fix use-after-free in high/low store

Denis Sergeev <denserg.edu@gmail.com>
    hwmon: (dell-smm) Limit fan multiplier to avoid overflow

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

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd/selftest: Make it clearer to gcc that the access is not out of bounds

Nicolin Chen <nicolinc@nvidia.com>
    iommufd/selftest: Update hw_info coverage for an input data_type

Yi Liu <yi.l.liu@intel.com>
    iommufd/selftest: Add coverage for reporting max_pasid_log2 via IOMMU_HW_INFO

Florian Westphal <fw@strlen.de>
    selftests: netfilter: packetdrill: avoid failure on HZ=100 kernel

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: remove redundant chain validation on register store

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat: remove bogus direction check

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

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix XDP_TX path

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

Max Chou <max.chou@realtek.com>
    Bluetooth: btusb: Add new VID/PID 0x0489/0xE12F for RTL8852BE-VT

Gongwei Li <ligongwei@kylinos.cn>
    Bluetooth: btusb: Add new VID/PID 13d3/3533 for RTL8821CE

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: MT7920: Add VID/PID 0489/e135

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: MT7922: Add VID/PID 0489/e170

Chingbin Li <liqb365@163.com>
    Bluetooth: btusb: Add new VID/PID 2b89/6275 for RTL8761BUV

Qianchang Zhao <pioooooooooip@gmail.com>
    ksmbd: vfs: fix race on m_flags in vfs_cache

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in ksmbd_tree_connect_put under concurrency

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: fix return value of smb2_ioctl()

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix "gfs2: Switch to wait_event in gfs2_quotad"

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: fix remote evict for read-only filesystems

Qu Wenruo <wqu@suse.com>
    btrfs: scrub: always update btrfs_scrub_progress::last_physical

Hans de Goede <hansg@kernel.org>
    wifi: brcmfmac: Add DMI nvram filename quirk for Acer A1 840 tablet

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt792x: fix wifi init fail by setting MCU_RUNNING after CLC load

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: use cfg80211_leave() in iftype change

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: stop radar detection in cfg80211_leave()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix HT40 channel config for RTL8192CU, RTL8723AU

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: check for shutdown in fsync

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

Armin Wolf <W_Armin@gmx.de>
    ACPI: fan: Workaround for 64-bit firmware bug

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

Pankaj Raghav <p.raghav@samsung.com>
    scripts/faddr2line: Fix "Argument list too long" error

Joanne Koong <joannelkoong@gmail.com>
    iomap: account for unaligned end offsets when truncating read range

Joanne Koong <joannelkoong@gmail.com>
    iomap: adjust read range correctly for non-block-aligned positions

Al Viro <viro@zeniv.linux.org.uk>
    shmem: fix recovery on rename failures

Deepanshu Kartikey <kartikey406@gmail.com>
    btrfs: fix memory leak of fs_devices in degraded seed device path

Ondrej Mosnacek <omosnace@redhat.com>
    bpf, arm64: Do not audit capability check in do_jit()

Qu Wenruo <wqu@suse.com>
    btrfs: fix a potential path leak in print_data_reloc_error()

Filipe Manana <fdmanana@suse.com>
    btrfs: do not skip logging new dentries when logging a new name


-------------

Diffstat:

 .../devicetree/bindings/mmc/aspeed,sdhci.yaml      |   2 +-
 .../devicetree/bindings/pci/qcom,pcie-sc7280.yaml  |   5 +
 .../bindings/pci/qcom,pcie-sc8280xp.yaml           |   3 +
 .../devicetree/bindings/pci/qcom,pcie-sm8150.yaml  |   5 +
 .../devicetree/bindings/pci/qcom,pcie-sm8250.yaml  |   5 +
 .../devicetree/bindings/pci/qcom,pcie-sm8350.yaml  |   5 +
 .../devicetree/bindings/pci/qcom,pcie-sm8450.yaml  |   5 +
 .../devicetree/bindings/pci/qcom,pcie-sm8550.yaml  |   5 +
 Documentation/driver-api/soundwire/stream.rst      |   2 +-
 Documentation/driver-api/tty/tty_port.rst          |   5 +-
 Documentation/filesystems/nfs/localio.rst          |  81 +--
 Makefile                                           |   4 +-
 arch/arm/boot/dts/microchip/sama5d2.dtsi           |  10 +-
 arch/arm/boot/dts/microchip/sama7g5.dtsi           |   4 +-
 arch/arm64/boot/dts/ti/k3-j721e-sk.dts             |  12 +-
 arch/arm64/include/asm/el2_setup.h                 |  57 +-
 arch/arm64/kernel/head.S                           |  22 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |  10 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c               |   3 +
 arch/arm64/net/bpf_jit_comp.c                      |   2 +-
 arch/loongarch/include/asm/pgtable.h               |   4 +-
 arch/loongarch/kernel/mcount_dyn.S                 |  14 +-
 arch/loongarch/kernel/relocate.c                   |   4 +-
 arch/loongarch/kernel/setup.c                      |   8 +-
 arch/loongarch/kernel/switch.S                     |   4 +-
 arch/loongarch/net/bpf_jit.c                       |  18 +
 arch/loongarch/net/bpf_jit.h                       |  26 +
 arch/loongarch/pci/pci.c                           |   2 +
 arch/mips/kernel/ftrace.c                          |  25 +-
 arch/mips/sgi-ip22/ip22-gio.c                      |   3 +-
 arch/parisc/kernel/asm-offsets.c                   |   2 +
 arch/parisc/kernel/entry.S                         |  16 +-
 arch/powerpc/boot/addnote.c                        |   7 +-
 arch/powerpc/include/asm/book3s/32/tlbflush.h      |   5 +-
 arch/powerpc/include/asm/book3s/64/mmu-hash.h      |   1 -
 arch/powerpc/kernel/btext.c                        |   3 +-
 arch/powerpc/kernel/process.c                      |   5 -
 arch/powerpc/kexec/core_64.c                       |  19 +
 arch/powerpc/mm/book3s32/tlb.c                     |   9 +
 arch/powerpc/mm/book3s64/internal.h                |   2 -
 arch/powerpc/mm/book3s64/mmu_context.c             |   2 -
 arch/powerpc/mm/book3s64/slb.c                     |  88 ---
 arch/powerpc/platforms/pseries/cmm.c               |   5 +-
 arch/riscv/crypto/chacha-riscv64-zvkb.S            |   5 +-
 arch/s390/include/uapi/asm/ipl.h                   |   1 +
 arch/s390/kernel/ipl.c                             |  48 +-
 arch/x86/crypto/blake2s-core.S                     |   4 +-
 arch/x86/entry/common.c                            |  72 --
 arch/x86/events/amd/core.c                         |   7 +-
 arch/x86/events/amd/uncore.c                       |   5 +-
 arch/x86/include/asm/irq_remapping.h               |   7 +
 arch/x86/include/asm/ptrace.h                      |  20 +-
 arch/x86/kernel/cpu/mce/threshold.c                |   3 +-
 arch/x86/kernel/cpu/microcode/amd.c                | 106 ++-
 arch/x86/kernel/fpu/xstate.c                       |   4 +-
 arch/x86/kernel/irq.c                              |  23 +
 arch/x86/kvm/lapic.c                               |  32 +-
 arch/x86/kvm/svm/nested.c                          |   6 +-
 arch/x86/kvm/svm/svm.c                             |  54 +-
 arch/x86/kvm/svm/svm.h                             |   7 +-
 arch/x86/kvm/vmx/nested.c                          |   3 +-
 arch/x86/kvm/x86.c                                 |  25 +-
 arch/x86/xen/enlighten_pv.c                        |  69 ++
 block/blk-mq.c                                     |   2 +-
 block/blk-zoned.c                                  | 193 +++--
 block/blk.h                                        |  14 +
 block/genhd.c                                      |   2 +-
 crypto/af_alg.c                                    |   5 +-
 crypto/algif_hash.c                                |   3 +-
 crypto/algif_rng.c                                 |   3 +-
 crypto/seqiv.c                                     |   8 +-
 drivers/acpi/acpi_pcc.c                            |   2 +-
 drivers/acpi/acpica/nswalk.c                       |   9 +-
 drivers/acpi/cppc_acpi.c                           |   3 +-
 drivers/acpi/fan.h                                 |  33 +
 drivers/acpi/fan_hwmon.c                           |  10 +-
 drivers/acpi/property.c                            |   8 +-
 drivers/amba/tegra-ahb.c                           |   1 +
 drivers/base/power/runtime.c                       |  22 +-
 drivers/block/floppy.c                             |   2 +-
 drivers/block/rnbd/rnbd-clt.c                      |  13 +-
 drivers/block/rnbd/rnbd-clt.h                      |   2 +-
 drivers/bluetooth/btusb.c                          |  22 +-
 drivers/bus/ti-sysc.c                              |  11 +-
 drivers/char/applicom.c                            |   5 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  20 +-
 drivers/char/tpm/tpm-chip.c                        |   1 -
 drivers/char/tpm/tpm1-cmd.c                        |   5 -
 drivers/char/tpm/tpm2-cmd.c                        |  11 +-
 drivers/char/tpm/tpm2-sessions.c                   |  85 ++-
 drivers/clk/mvebu/cp110-system-controller.c        |  20 +
 drivers/clk/qcom/dispcc-sm7150.c                   |   2 +-
 drivers/clk/samsung/clk-exynos-clkout.c            |   2 +-
 drivers/cpufreq/cpufreq-dt-platdev.c               |   1 +
 drivers/cpufreq/cpufreq-nforce2.c                  |   3 +
 drivers/cpufreq/s5pv210-cpufreq.c                  |   6 +-
 drivers/cpuidle/governors/menu.c                   |   9 +-
 drivers/cpuidle/governors/teo.c                    |   7 +-
 drivers/crypto/caam/caamrng.c                      |   4 +-
 drivers/firewire/nosy.c                            |  10 +-
 drivers/firmware/imx/imx-scu-irq.c                 |   4 +-
 drivers/firmware/stratix10-svc.c                   |  11 +
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-regmap.c                         |   2 +-
 .../gpio/{gpiolib-acpi.c => gpiolib-acpi-core.c}   | 344 +--------
 drivers/gpio/gpiolib-acpi-quirks.c                 | 412 +++++++++++
 drivers/gpio/gpiolib-acpi.h                        |  15 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   2 +
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c             |  27 +
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c             |  27 +
 drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h     |  62 +-
 .../gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx12.asm |  37 +
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |   1 +
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |   4 +
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  59 +-
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c   |   2 +-
 .../amd/display/dc/resource/dcn35/dcn35_resource.c |   8 +-
 .../display/dc/resource/dcn351/dcn351_resource.c   |   8 +-
 drivers/gpu/drm/drm_buddy.c                        | 390 ++++++----
 drivers/gpu/drm/drm_displayid.c                    |  58 +-
 drivers/gpu/drm/drm_displayid_internal.h           |   2 +
 drivers/gpu/drm/gma500/fbdev.c                     |  43 --
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |  37 +-
 drivers/gpu/drm/i915/intel_memory_region.h         |   2 +-
 drivers/gpu/drm/imagination/pvr_gem.c              |  11 +
 drivers/gpu/drm/mediatek/mtk_ddp_comp.c            |  33 +-
 drivers/gpu/drm/mediatek/mtk_ddp_comp.h            |   2 +-
 drivers/gpu/drm/mediatek/mtk_dp.c                  |   1 +
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   4 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |  25 +
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c        |   2 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c    |  10 +-
 drivers/gpu/drm/nouveau/dispnv50/atom.h            |  13 +
 drivers/gpu/drm/nouveau/dispnv50/wndw.c            |   2 +-
 drivers/gpu/drm/panel/panel-sony-td4353-jdi.c      |   2 +
 drivers/gpu/drm/panthor/panthor_gem.c              |  18 +
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |   6 +
 drivers/gpu/drm/xe/xe_bo.c                         |  15 +-
 drivers/gpu/drm/xe/xe_dma_buf.c                    |   2 +-
 drivers/gpu/drm/xe/xe_exec.c                       |   3 +-
 drivers/gpu/drm/xe/xe_gt.c                         |   7 +-
 drivers/gpu/drm/xe/xe_guc_submit.c                 |  20 +-
 drivers/gpu/drm/xe/xe_heci_gsc.c                   |   4 +-
 drivers/gpu/drm/xe/xe_oa.c                         |  13 +-
 drivers/gpu/drm/xe/xe_vm.c                         |   8 +-
 drivers/gpu/drm/xe/xe_vm_types.h                   |   2 +-
 drivers/hid/hid-input.c                            |  18 +-
 drivers/hid/hid-logitech-dj.c                      |  56 +-
 drivers/hwmon/dell-smm-hwmon.c                     |   9 +
 drivers/hwmon/ibmpex.c                             |   9 +-
 drivers/hwmon/ltc4282.c                            |   9 +-
 drivers/hwmon/max16065.c                           |   7 +-
 drivers/hwmon/max6697.c                            |   2 +-
 drivers/hwmon/tmp401.c                             |   2 +-
 drivers/hwmon/w83791d.c                            |  19 +-
 drivers/hwmon/w83l786ng.c                          |  26 +-
 drivers/hwtracing/intel_th/core.c                  |  20 +-
 drivers/i2c/busses/i2c-amd-mp2-pci.c               |   5 +-
 drivers/i2c/busses/i2c-designware-core.h           |   1 +
 drivers/i2c/busses/i2c-designware-master.c         |   7 +
 drivers/iio/adc/ti_am335x_adc.c                    |   2 +-
 drivers/infiniband/core/addr.c                     |  33 +-
 drivers/infiniband/core/cma.c                      |   3 +
 drivers/infiniband/core/device.c                   |   4 +-
 drivers/infiniband/core/verbs.c                    |   2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   7 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |   8 +-
 drivers/infiniband/hw/efa/efa_verbs.c              |   4 -
 drivers/infiniband/hw/irdma/utils.c                |   3 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |   1 +
 drivers/input/keyboard/lkkbd.c                     |   5 +-
 drivers/input/mouse/alps.c                         |   1 +
 drivers/input/serio/i8042-acpipnpio.h              |   7 +
 drivers/input/touchscreen/ti_am335x_tsc.c          |   2 +-
 drivers/interconnect/qcom/sdx75.c                  |  26 -
 drivers/interconnect/qcom/sdx75.h                  |   2 -
 drivers/iommu/amd/init.c                           |  15 +-
 drivers/iommu/amd/iommu.c                          |   2 +-
 drivers/iommu/apple-dart.c                         |   2 +
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |  10 +-
 drivers/iommu/exynos-iommu.c                       |   9 +-
 drivers/iommu/intel/irq_remapping.c                |   8 +-
 drivers/iommu/iommu-sva.c                          |   3 +
 drivers/iommu/iommufd/selftest.c                   |   8 +-
 drivers/iommu/ipmmu-vmsa.c                         |   2 +
 drivers/iommu/mtk_iommu.c                          |  27 +-
 drivers/iommu/mtk_iommu_v1.c                       |  25 +-
 drivers/iommu/omap-iommu.c                         |   2 +-
 drivers/iommu/omap-iommu.h                         |   2 -
 drivers/iommu/sun50i-iommu.c                       |   2 +
 drivers/iommu/tegra-smmu.c                         |   5 +-
 drivers/isdn/capi/capi.c                           |   8 +-
 drivers/leds/leds-cros_ec.c                        |   5 +-
 drivers/leds/leds-lp50xx.c                         |  67 +-
 drivers/md/dm-bufio.c                              |  10 +-
 drivers/md/dm-ebs-target.c                         |   2 +-
 drivers/md/md.c                                    |   5 +-
 drivers/md/raid10.c                                |   3 +-
 drivers/md/raid5.c                                 |  10 +-
 drivers/media/cec/core/cec-core.c                  |   1 +
 .../media/common/videobuf2/videobuf2-dma-contig.c  |   1 +
 drivers/media/i2c/adv7604.c                        |   4 +-
 drivers/media/i2c/adv7842.c                        |  11 +-
 drivers/media/i2c/imx219.c                         |   9 +-
 drivers/media/i2c/msp3400-kthreads.c               |   2 +
 drivers/media/i2c/tda1997x.c                       |   1 -
 drivers/media/platform/amphion/vpu_malone.c        |  35 +-
 drivers/media/platform/amphion/vpu_v4l2.c          |  28 +-
 drivers/media/platform/amphion/vpu_v4l2.h          |  18 -
 .../media/platform/mediatek/mdp3/mtk-mdp3-core.c   |  14 +
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
 drivers/media/platform/verisilicon/hantro_g2.c     |  84 ++-
 .../platform/verisilicon/hantro_g2_hevc_dec.c      |  17 +-
 .../media/platform/verisilicon/hantro_g2_regs.h    |  13 +
 .../media/platform/verisilicon/hantro_g2_vp9_dec.c |   2 -
 drivers/media/platform/verisilicon/hantro_hw.h     |   1 +
 drivers/media/platform/verisilicon/imx8m_vpu_hw.c  |   2 +
 drivers/media/rc/st_rc.c                           |   2 +-
 drivers/media/test-drivers/vidtv/vidtv_channel.c   |   3 +
 drivers/media/usb/dvb-usb/dtv5100.c                |   5 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   2 +-
 drivers/mfd/altera-sysmgr.c                        |   2 +
 drivers/mfd/max77620.c                             |  15 +-
 drivers/misc/mei/Kconfig                           |   2 +-
 drivers/misc/vmw_balloon.c                         |   3 +-
 drivers/mmc/host/Kconfig                           |   4 +-
 drivers/mmc/host/sdhci-msm.c                       |  27 +-
 drivers/mmc/host/sdhci-of-arasan.c                 |   2 +-
 drivers/mtd/mtdpart.c                              |   7 +-
 drivers/mtd/spi-nor/winbond.c                      |  24 +
 drivers/net/can/usb/gs_usb.c                       |   2 +-
 drivers/net/dsa/b53/b53_common.c                   |   3 +
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |   2 +
 drivers/net/ethernet/broadcom/b44.c                |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   3 +-
 drivers/net/ethernet/cadence/macb_main.c           |   3 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   3 +-
 drivers/net/ethernet/freescale/fec_main.c          |   7 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   2 +-
 drivers/net/ethernet/google/gve/gve_utils.c        |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   3 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |  10 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |  11 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  12 -
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   1 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   4 +-
 drivers/net/ethernet/intel/idpf/idpf_dev.c         |   3 +
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |   2 +-
 .../net/ethernet/intel/idpf/idpf_singleq_txrx.c    |  61 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        | 782 ++++++++-------------
 drivers/net/ethernet/intel/idpf/idpf_txrx.h        |  95 ++-
 drivers/net/ethernet/intel/idpf/idpf_vf_dev.c      |   3 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   5 +
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  97 ++-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.h   |   1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  48 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c  |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  27 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   5 +-
 drivers/net/ethernet/smsc/smc91x.c                 |  10 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  17 +-
 drivers/net/fjes/fjes_hw.c                         |  12 +-
 drivers/net/ipvlan/ipvlan_core.c                   |   3 +
 drivers/net/mdio/mdio-aspeed.c                     |   7 +
 drivers/net/phy/marvell-88q2xxx.c                  |   2 +-
 drivers/net/team/team_core.c                       |   2 +-
 drivers/net/usb/asix_common.c                      |   5 +
 drivers/net/usb/rtl8150.c                          |   2 +
 drivers/net/usb/sr9700.c                           |   4 +-
 drivers/net/usb/usbnet.c                           |   2 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |  14 +
 drivers/net/wireless/mediatek/mt76/eeprom.c        |  37 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |   4 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   4 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7925/init.c   |  24 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |  51 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h |  21 +
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c    |  33 +-
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c    |  20 +-
 drivers/net/wireless/mediatek/mt76/mt792x.h        |   2 +
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |   7 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |   3 +-
 drivers/net/wireless/realtek/rtw88/sdio.c          |   4 +-
 drivers/nfc/pn533/usb.c                            |   2 +-
 drivers/nvme/host/fabrics.c                        |   2 +-
 drivers/nvme/host/fc.c                             |   6 +-
 drivers/of/fdt.c                                   |   2 +-
 drivers/parisc/gsc.c                               |   4 +-
 drivers/pci/controller/pcie-brcmstb.c              | 107 +--
 drivers/pci/pci-driver.c                           |   4 +
 drivers/perf/arm_cspmu/arm_cspmu.c                 |   4 +-
 drivers/phy/broadcom/phy-bcm63xx-usbh.c            |   6 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |  75 +-
 drivers/platform/chrome/cros_ec_ishtp.c            |   1 +
 drivers/platform/mellanox/mlxbf-pmc.c              |  14 +-
 .../platform/x86/hp/hp-bioscfg/enum-attributes.c   |   4 +-
 .../platform/x86/hp/hp-bioscfg/int-attributes.c    |   2 +-
 .../x86/hp/hp-bioscfg/order-list-attributes.c      |   5 +
 .../x86/hp/hp-bioscfg/passwdobj-attributes.c       |   5 +
 .../platform/x86/hp/hp-bioscfg/string-attributes.c |   2 +-
 drivers/platform/x86/ibm_rtl.c                     |   2 +-
 drivers/platform/x86/intel/chtwc_int33fe.c         |  29 +-
 drivers/platform/x86/intel/hid.c                   |  12 +
 drivers/platform/x86/msi-laptop.c                  |   3 +
 drivers/pmdomain/imx/gpc.c                         |   5 +-
 drivers/rpmsg/qcom_glink_native.c                  |   8 +
 drivers/s390/block/dasd_eckd.c                     |   8 +
 drivers/scsi/aic94xx/aic94xx_init.c                |   3 +
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h                |   1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |   2 +
 drivers/scsi/qla2xxx/qla_def.h                     |   1 -
 drivers/scsi/qla2xxx/qla_gbl.h                     |   2 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  32 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   2 +
 drivers/scsi/qla2xxx/qla_mid.c                     |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  14 +-
 drivers/scsi/scsi_debug.c                          |   2 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   4 +
 drivers/soc/amlogic/meson-canvas.c                 |   5 +-
 drivers/soc/apple/mailbox.c                        |  15 +-
 drivers/soc/qcom/ocmem.c                           |   2 +-
 drivers/soc/qcom/qcom-pbs.c                        |   2 +
 drivers/soc/samsung/exynos-pmu.c                   |   2 +
 drivers/soc/tegra/fuse/fuse-tegra.c                |   2 -
 drivers/soundwire/stream.c                         |   6 +-
 drivers/spi/spi-cadence-quadspi.c                  |   4 +-
 drivers/spi/spi-fsl-spi.c                          |   2 +-
 drivers/staging/greybus/uart.c                     |   7 +-
 drivers/target/target_core_transport.c             |   1 +
 drivers/tty/serial/serial_base_bus.c               |   8 +-
 drivers/tty/serial/serial_core.c                   |   7 +-
 drivers/tty/serial/sh-sci.c                        |   2 +-
 drivers/tty/serial/sprd_serial.c                   |   6 +
 drivers/tty/serial/xilinx_uartps.c                 |  16 +-
 drivers/tty/tty_port.c                             |  17 +-
 drivers/ufs/core/ufshcd.c                          |   5 +-
 drivers/ufs/host/ufs-mediatek.c                    |   5 +
 drivers/usb/class/cdc-acm.c                        |   7 +-
 drivers/usb/dwc3/dwc3-of-simple.c                  |   7 +-
 drivers/usb/dwc3/gadget.c                          |   2 +-
 drivers/usb/dwc3/host.c                            |   2 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c               |  21 +-
 drivers/usb/host/ohci-nxp.c                        |   2 +
 drivers/usb/host/xhci-dbgtty.c                     |   2 +-
 drivers/usb/host/xhci-hub.c                        |   2 +-
 drivers/usb/phy/phy-fsl-usb.c                      |   1 +
 drivers/usb/phy/phy-isp1301.c                      |   7 +-
 drivers/usb/renesas_usbhs/pipe.c                   |   2 +
 drivers/usb/serial/usb-serial.c                    |   7 +-
 drivers/usb/storage/unusual_uas.h                  |   2 +-
 drivers/usb/typec/altmodes/displayport.c           |   8 +-
 drivers/usb/typec/ucsi/ucsi.c                      |   6 +
 drivers/usb/usbip/vhci_hcd.c                       |   6 +-
 drivers/vdpa/octeon_ep/octep_vdpa_main.c           |   1 +
 drivers/vfio/pci/nvgrace-gpu/main.c                |   4 +-
 drivers/vfio/pci/pds/dirty.c                       |   7 +-
 drivers/vfio/pci/vfio_pci_rdwr.c                   |  24 +-
 drivers/vhost/vsock.c                              |  15 +-
 drivers/video/fbdev/gbefb.c                        |   5 +-
 drivers/video/fbdev/pxafb.c                        |  12 +-
 drivers/video/fbdev/tcx.c                          |   2 +-
 drivers/virtio/virtio_balloon.c                    |   4 +-
 drivers/watchdog/via_wdt.c                         |   1 +
 fs/btrfs/inode.c                                   |   1 +
 fs/btrfs/ioctl.c                                   |   4 +-
 fs/btrfs/scrub.c                                   |   5 +
 fs/btrfs/tree-log.c                                |  46 +-
 fs/btrfs/volumes.c                                 |   1 +
 fs/erofs/zdata.c                                   |   8 +-
 fs/exfat/file.c                                    |   5 +
 fs/exfat/super.c                                   |  19 +-
 fs/ext4/ialloc.c                                   |   1 -
 fs/ext4/inode.c                                    |   1 -
 fs/ext4/mballoc.c                                  |   2 +
 fs/ext4/orphan.c                                   |   4 +-
 fs/ext4/super.c                                    |   6 +-
 fs/ext4/xattr.c                                    |   6 +-
 fs/f2fs/compress.c                                 |   5 +-
 fs/f2fs/data.c                                     |  17 +
 fs/f2fs/extent_cache.c                             |   5 +-
 fs/f2fs/f2fs.h                                     |  17 +-
 fs/f2fs/file.c                                     |  20 +-
 fs/f2fs/gc.c                                       |   2 +-
 fs/f2fs/inode.c                                    |   2 +-
 fs/f2fs/namei.c                                    |   6 +-
 fs/f2fs/recovery.c                                 |  20 +-
 fs/f2fs/segment.c                                  |   9 +-
 fs/f2fs/super.c                                    | 160 ++---
 fs/f2fs/xattr.c                                    |  30 +-
 fs/f2fs/xattr.h                                    |  10 +-
 fs/fuse/file.c                                     |  37 +-
 fs/gfs2/glops.c                                    |   3 +-
 fs/gfs2/lops.c                                     |   2 +-
 fs/gfs2/quota.c                                    |   2 +-
 fs/gfs2/super.c                                    |   4 +-
 fs/hfsplus/bnode.c                                 |   4 +-
 fs/hfsplus/dir.c                                   |   7 +-
 fs/hfsplus/inode.c                                 |  32 +-
 fs/iomap/buffered-io.c                             |  41 +-
 fs/iomap/direct-io.c                               |  10 +-
 fs/jbd2/journal.c                                  |  20 +-
 fs/jbd2/transaction.c                              |   2 +-
 fs/libfs.c                                         |  50 +-
 fs/lockd/svc4proc.c                                |   4 +-
 fs/lockd/svclock.c                                 |  21 +-
 fs/lockd/svcproc.c                                 |   5 +-
 fs/locks.c                                         |  12 +-
 fs/nfs_common/nfslocalio.c                         |  10 +-
 fs/nfsd/blocklayout.c                              |   3 +-
 fs/nfsd/export.c                                   |   2 +-
 fs/nfsd/filecache.c                                |   2 +-
 fs/nfsd/localio.c                                  |   4 +-
 fs/nfsd/netns.h                                    |  11 +-
 fs/nfsd/nfs4state.c                                |   4 +-
 fs/nfsd/nfs4xdr.c                                  |   5 +
 fs/nfsd/nfssvc.c                                   |  45 +-
 fs/nfsd/vfs.h                                      |   3 +-
 fs/notify/fsnotify.c                               |   9 +-
 fs/ntfs3/file.c                                    |  14 +-
 fs/ntfs3/frecord.c                                 |  35 +-
 fs/ntfs3/ntfs_fs.h                                 |   9 +-
 fs/ntfs3/run.c                                     |   6 +-
 fs/ntfs3/super.c                                   |   5 +
 fs/ocfs2/suballoc.c                                |  10 +
 fs/smb/client/fs_context.c                         |   2 +
 fs/smb/server/mgmt/tree_connect.c                  |  18 +-
 fs/smb/server/mgmt/tree_connect.h                  |   1 -
 fs/smb/server/mgmt/user_session.c                  |   4 +-
 fs/smb/server/smb2pdu.c                            |  20 +-
 fs/smb/server/vfs.c                                |   5 +-
 fs/smb/server/vfs_cache.c                          |  88 ++-
 fs/xfs/scrub/attr_repair.c                         |   2 +-
 fs/xfs/xfs_attr_item.c                             |   2 +-
 fs/xfs/xfs_buf_item.c                              |   1 +
 fs/xfs/xfs_qm.c                                    |   5 +-
 include/drm/drm_buddy.h                            |  11 +-
 include/drm/drm_edid.h                             |   6 +
 include/linux/balloon_compaction.h                 |  43 +-
 include/linux/compiler_types.h                     |  13 +
 include/linux/fs.h                                 |   2 +-
 include/linux/genalloc.h                           |   1 +
 include/linux/hrtimer.h                            |  23 +
 include/linux/jbd2.h                               |   6 +
 include/linux/kasan.h                              |  16 +
 include/linux/nfslocalio.h                         |  12 +-
 include/linux/reset.h                              |   1 +
 include/linux/soundwire/sdw.h                      |   2 +-
 include/linux/tpm.h                                |   8 +-
 include/linux/tty_port.h                           |  21 +-
 include/linux/vfio_pci_core.h                      |  10 +-
 include/media/v4l2-mem2mem.h                       |   3 +-
 include/net/ip.h                                   |   6 +-
 include/net/ip6_route.h                            |   4 +-
 include/net/route.h                                |   2 +-
 include/uapi/drm/xe_drm.h                          |   1 +
 include/uapi/linux/mptcp.h                         |   1 +
 io_uring/io_uring.c                                |   3 +
 io_uring/openclose.c                               |   2 +-
 io_uring/poll.c                                    |   9 +-
 kernel/kallsyms.c                                  |   5 +-
 kernel/livepatch/core.c                            |   8 +-
 kernel/sched/cpudeadline.c                         |  34 +-
 kernel/sched/cpudeadline.h                         |   4 +-
 kernel/sched/deadline.c                            |   8 +-
 kernel/sched/debug.c                               |   8 +-
 kernel/sched/ext.c                                 |  58 +-
 kernel/sched/fair.c                                | 103 +--
 kernel/sched/rt.c                                  |  52 +-
 kernel/sched/sched.h                               |   4 +-
 kernel/scs.c                                       |   2 +-
 kernel/trace/fgraph.c                              |  10 +-
 kernel/trace/trace_events.c                        |   2 +
 kernel/trace/trace_events_synth.c                  |   1 -
 lib/idr.c                                          |   2 +
 mm/balloon_compaction.c                            |   9 +-
 mm/damon/tests/core-kunit.h                        |  99 ++-
 mm/damon/tests/sysfs-kunit.h                       |  25 +
 mm/damon/tests/vaddr-kunit.h                       |  26 +-
 mm/kasan/common.c                                  |  32 +
 mm/kasan/hw_tags.c                                 |   2 +-
 mm/kasan/shadow.c                                  |   4 +-
 mm/ksm.c                                           |  18 +-
 mm/page_owner.c                                    |   2 +-
 mm/shmem.c                                         |  24 +-
 mm/vmalloc.c                                       |   8 +-
 net/bluetooth/rfcomm/tty.c                         |   7 +-
 net/bridge/br_private.h                            |   1 +
 net/caif/cffrml.c                                  |   9 +-
 net/ceph/osdmap.c                                  | 116 ++-
 net/core/sock.c                                    |  16 +-
 net/dsa/dsa.c                                      |   8 +-
 net/ethtool/ioctl.c                                |  30 +-
 net/handshake/request.c                            |   8 +-
 net/hsr/hsr_device.c                               |   7 +-
 net/hsr/hsr_forward.c                              |   2 +
 net/ipv4/fib_trie.c                                |   7 +-
 net/ipv6/calipso.c                                 |   3 +-
 net/ipv6/exthdrs.c                                 |   2 +-
 net/ipv6/icmp.c                                    |   4 +-
 net/ipv6/ila/ila_lwt.c                             |   2 +-
 net/ipv6/ioam6_iptunnel.c                          |  37 +-
 net/ipv6/ip6_gre.c                                 |  17 +-
 net/ipv6/ip6_output.c                              |  19 +-
 net/ipv6/ip6_tunnel.c                              |   4 +-
 net/ipv6/ip6_udp_tunnel.c                          |   2 +-
 net/ipv6/ip6_vti.c                                 |   2 +-
 net/ipv6/ndisc.c                                   |   6 +-
 net/ipv6/netfilter/nf_dup_ipv6.c                   |   2 +-
 net/ipv6/output_core.c                             |   2 +-
 net/ipv6/route.c                                   |  33 +-
 net/ipv6/rpl_iptunnel.c                            |   4 +-
 net/ipv6/seg6_iptunnel.c                           |  20 +-
 net/ipv6/seg6_local.c                              |   2 +-
 net/mac80211/cfg.c                                 |  10 -
 net/mptcp/pm_netlink.c                             |   3 +-
 net/mptcp/protocol.c                               |  22 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   3 +
 net/netfilter/nf_conncount.c                       |  25 +-
 net/netfilter/nf_nat_core.c                        |  14 +-
 net/netfilter/nf_tables_api.c                      |  11 -
 net/netfilter/nft_ct.c                             |   5 +
 net/netrom/nr_out.c                                |   4 +-
 net/nfc/core.c                                     |   9 +-
 net/openvswitch/flow_netlink.c                     |  13 +-
 net/openvswitch/vport-netdev.c                     |  17 +-
 net/rose/af_rose.c                                 |   2 +-
 net/sched/sch_ets.c                                |   6 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |   3 +-
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  |   7 +-
 net/wireless/core.c                                |   1 +
 net/wireless/core.h                                |   1 +
 net/wireless/mlme.c                                |  19 +
 net/wireless/sme.c                                 |   2 +-
 net/wireless/util.c                                |  23 +-
 samples/ftrace/ftrace-direct-modify.c              |   8 +-
 samples/ftrace/ftrace-direct-multi-modify.c        |   8 +-
 samples/ftrace/ftrace-direct-multi.c               |   4 +-
 samples/ftrace/ftrace-direct-too.c                 |   4 +-
 samples/ftrace/ftrace-direct.c                     |   4 +-
 scripts/Makefile.build                             |  26 +-
 scripts/Makefile.modinst                           |   2 +-
 scripts/faddr2line                                 |  13 +-
 security/keys/trusted-keys/trusted_tpm2.c          |   6 +-
 sound/isa/wavefront/wavefront_midi.c               | 131 ++--
 sound/isa/wavefront/wavefront_synth.c              |  18 +-
 sound/pci/hda/cs35l41_hda.c                        |   2 +
 sound/pcmcia/pdaudiocf/pdaudiocf.c                 |   8 +-
 sound/pcmcia/vx/vxpocket.c                         |   8 +-
 sound/soc/codecs/ak4458.c                          |   4 -
 sound/soc/codecs/lpass-tx-macro.c                  |   3 +-
 sound/soc/codecs/wcd939x-sdw.c                     |   8 +-
 sound/soc/qcom/qdsp6/q6adm.c                       | 146 ++--
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |   2 +
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |   7 +-
 sound/soc/qcom/sc7280.c                            |   2 +-
 sound/soc/qcom/sc8280xp.c                          |   2 +-
 sound/soc/qcom/sdw.c                               | 107 +--
 sound/soc/qcom/sdw.h                               |   1 +
 sound/soc/qcom/sm8250.c                            |   2 +-
 sound/soc/qcom/x1e80100.c                          |   2 +-
 sound/soc/sh/rz-ssi.c                              |  64 +-
 sound/soc/stm/stm32_sai.c                          |  14 +-
 sound/soc/stm/stm32_sai_sub.c                      |  51 +-
 sound/usb/mixer_us16x08.c                          |  20 +-
 tools/lib/perf/cpumap.c                            |  10 +-
 tools/mm/page_owner_sort.c                         |   6 +-
 tools/testing/ktest/config-bisect.pl               |   4 +-
 tools/testing/nvdimm/test/nfit.c                   |   7 +-
 tools/testing/radix-tree/idr-test.c                |  21 +
 .../test.d/ftrace/func_traceonoff_triggers.tc      |   5 +-
 tools/testing/selftests/iommu/iommufd.c            |  54 +-
 tools/testing/selftests/iommu/iommufd_fail_nth.c   |   3 +-
 tools/testing/selftests/iommu/iommufd_utils.h      |  36 +-
 tools/testing/selftests/net/mptcp/pm_netlink.sh    |   4 +
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |  11 +
 .../net/netfilter/conntrack_reverse_clash.c        |  13 +-
 .../net/netfilter/conntrack_reverse_clash.sh       |   2 +
 .../packetdrill/conntrack_syn_challenge_ack.pkt    |   2 +-
 tools/testing/selftests/net/tap.c                  |  16 +-
 virt/kvm/kvm_main.c                                |   2 +-
 607 files changed, 5906 insertions(+), 3784 deletions(-)


