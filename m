Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2AE35CB76;
	Tue,  6 Jan 2026 17:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721627; cv=none; b=kZORdNoXsjxegTFPKtGUuJg7btSCyPB53jpU/ZRojpqryQBOrjm44KKdPe80IEcEyCTM3T6L2Jyh75d6otMekTF6ZdEQKxIAN0jZsuaqcfRnKa714s6qDoz7gi/3UDE6XEgxibbp+ZMZXgO+lekzF4Xe5y8eEWAxLmDVSMjD8E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721627; c=relaxed/simple;
	bh=yw10lGT1QuoB+4jMDriCqT0D2lACDAv1RsPBNvhY/b8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pD0wZXolnfsAYvYuSVxMeMM/iXmnHtw3KJIILG+OqxoCWzn3FZgTwkxbKn2O57A9JYSK9GNcKaqs1hSU6Up7MInFDLqzT65jO5m45x6R4FSOqAUr63QlfJWi48NVguwwV/zaZBBn/mSUxludZtdwuQ1KtDC8DTsv+7w3JyTAbhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGdBD8Sb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGdBD8Sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48E2C116C6;
	Tue,  6 Jan 2026 17:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721627;
	bh=yw10lGT1QuoB+4jMDriCqT0D2lACDAv1RsPBNvhY/b8=;
	h=From:To:Cc:Subject:Date:From;
	b=LGdBD8SbVLnkJOy+u2/Hi5S6iIV/UsXZp17JWaKduLBu/yqeU+08sjwK3NtbWku47
	 tVpYCtWScvcnwwES25dPwtilAW2oSoOTwoKTHAv0Uu+pSP1BauBw49+TQTAcAagVaF
	 ZHudZKzta60/463CxpVPj88XiFi2/P3+U5R1ODT4=
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
Subject: [PATCH 6.18 000/312] 6.18.4-rc1 review
Date: Tue,  6 Jan 2026 18:01:14 +0100
Message-ID: <20260106170547.832845344@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.4-rc1
X-KernelTest-Deadline: 2026-01-08T17:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.4 release.
There are 312 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 08 Jan 2026 17:04:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.4-rc1

Charles Keepax <ckeepax@opensource.cirrus.com>
    Revert "gpio: swnode: don't use the swnode's name as the key for GPIO lookup"

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_regions_of()

Kevin Tian <kevin.tian@intel.com>
    vfio/pci: Disable qword access to the PCI ROM bar

Chenghao Duan <duanchenghao@kylinos.cn>
    LoongArch: BPF: Enhance the bpf_arch_text_poke() function

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    powercap: intel_rapl: Add support for Nova Lake processors

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    powercap: intel_rapl: Add support for Wildcat Lake platform

Damien Le Moal <dlemoal@kernel.org>
    block: fix NULL pointer dereference in blk_zone_reset_all_bio_endio()

Junbeom Yeom <junbeom.yeom@samsung.com>
    erofs: fix unexpected EIO under memory pressure

Alessio Belle <alessio.belle@imgtec.com>
    drm/imagination: Disallow exporting of PM/FW protected objects

Lyude Paul <lyude@redhat.com>
    drm/nouveau/dispnv50: Don't call drm_atomic_get_crtc_state() in prepare_fb

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/pagemap, drm/xe: Ensure that the devmem allocation is idle before use

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe/svm: Fix a debug printout

Krzysztof Niemiec <krzysztof.niemiec@intel.com>
    drm/i915/gem: Zero-initialize the eb.vma array in i915_gem_do_execbuffer

Anna Maniscalco <anna.maniscalco2000@gmail.com>
    drm/msm: add PERFCTR_CNTL to ifpc_reglist

Nikolay Kuratov <kniv@yandex-team.ru>
    drm/msm/dpu: Add missing NULL pointer check for pingpong interface

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Drop preempt-fences when destroying imported dma-bufs.

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Use usleep_range for accurate long-running workload timeslicing

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Adjust long-running workload timeslices to reasonable values

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/eustall: Disallow 0 EU stall property values

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: Disallow 0 OA property values

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe/bo: Don't include the CCS metadata in the dma-buf sg-table

Karol Wachowski <karol.wachowski@linux.intel.com>
    drm: Fix object leak in DRM_IOCTL_GEM_CHANGE_HANDLE

René Rebe <rene@exactco.de>
    drm/mgag200: Fix big-endian support

Simon Richter <Simon.Richter@hogyros.de>
    drm/ttm: Avoid NULL pointer deref for evicted BOs

Kory Maincent (TI.com) <kory.maincent@bootlin.com>
    drm/tilcdc: Fix removal actions in case of failed probe

Ard Biesheuvel <ardb@kernel.org>
    drm/i915: Fix format string truncation warning

Jay Cornwall <jay.cornwall@amd.com>
    drm/amdkfd: Trap handler support for expert scheduling mode

Jonathan Kim <jonathan.kim@amd.com>
    drm/amdkfd: bump minimum vgpr size for gfx1151

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdkfd: Export the cwsr_size and ctl_stack_size to userspace

Lyude Paul <lyude@redhat.com>
    drm/nouveau/gsp: Allocate fwsec-sb at boot

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/bridge: ti-sn65dsi83: ignore PLL_UNLOCK errors

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Use OVL_LAYER_SEL configuration instead of use win_mask calculate used layers

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd: Fix unbind/rebind for VCN 4.0.5

Johan Hovold <johan@kernel.org>
    drm/mediatek: ovl_adaptor: Fix probe device leaks

Johan Hovold <johan@kernel.org>
    drm/mediatek: mtk_hdmi: Fix probe device leaks

Johan Hovold <johan@kernel.org>
    drm/mediatek: Fix probe device leaks

Johan Hovold <johan@kernel.org>
    drm/mediatek: Fix probe memory leak

Johan Hovold <johan@kernel.org>
    drm/mediatek: Fix probe resource leaks

Miaoqian Lin <linmq006@gmail.com>
    drm/mediatek: Fix device node reference leak in mtk_dp_dt_parse()

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/rockchip: Set VOP for the DRM DMA device

Sanjay Yadav <sanjay.kumar.yadav@intel.com>
    drm/xe/oa: Fix potential UAF in xe_oa_add_config_ioctl()

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

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu/sdma6: Update SDMA 6.0.3 FW version to include UMQ protected-fence fix

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu: add missing lock to amdgpu_ttm_access_memory_sdma

Natalie Vock <natalie.vock@gmx.de>
    drm/amdgpu: Forward VMID reservation errors

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gmc12: add amdgpu_vm_handle_fault() handling

Mario Limonciello (AMD) <superm1@kernel.org>
    Revert "drm/amd: Skip power ungate during suspend for VPE"

Kurt Borja <kuurtb@gmail.com>
    platform/x86: alienware-wmi-wmax: Add support for Alienware 16X Aurora

Kurt Borja <kuurtb@gmail.com>
    platform/x86: alienware-wmi-wmax: Add AWCC support for Alienware x16

Kurt Borja <kuurtb@gmail.com>
    platform/x86: alienware-wmi-wmax: Add support for new Area-51 laptops

Armin Wolf <W_Armin@gmx.de>
    platform/x86: samsung-galaxybook: Fix problematic pointer cast

Xiaolei Wang <xiaolei.wang@windriver.com>
    net: macb: Relocate mog_init_rings() callback from macb_mac_link_up() to macb_open()

Deepanshu Kartikey <kartikey406@gmail.com>
    net: nfc: fix deadlock between nfc_unregister_device and rfkill_fop_write

Miaoqian Lin <linmq006@gmail.com>
    net: phy: mediatek: fix nvmem cell reference leak in mt798x_phy_calibration

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    net: usb: sr9700: fix incorrect command used to write single register

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    nfsd: Drop the client reference in client_states_open()

Jeff Layton <jlayton@kernel.org>
    nfsd: use ATTR_DELEG in nfsd4_finalize_deleg_timestamps()

Chuck Lever <chuck.lever@oracle.com>
    nfsd: fix nfsd_file reference leak in nfsd4_add_rdaccess_to_wrdeleg()

Chenghao Duan <duanchenghao@kylinos.cn>
    LoongArch: BPF: Adjust the jump offset of tail calls

Chenghao Duan <duanchenghao@kylinos.cn>
    LoongArch: BPF: Enable trampoline-based tracing for module functions

Chenghao Duan <duanchenghao@kylinos.cn>
    LoongArch: BPF: Save return address register ra to t0 before trampoline

Hengqi Chen <hengqi.chen@gmail.com>
    LoongArch: BPF: Sign extend kfunc call arguments

Hengqi Chen <hengqi.chen@gmail.com>
    LoongArch: BPF: Zero-extend bpf_tail_call() index

Chenghao Duan <duanchenghao@kylinos.cn>
    LoongArch: Refactor register restoration in ftrace_common_return

Ankit Garg <nktgrg@google.com>
    gve: defer interrupt enabling until NAPI registration

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    fjes: Add missing iounmap in fjes_hw_init()

Frode Nordahl <fnordahl@ubuntu.com>
    erspan: Initialize options_len before referencing options.

Guangshuo Li <lgs201920130244@gmail.com>
    e1000: fix OOB in e1000_tbi_should_accept()

Jouni Malinen <jouni.malinen@oss.qualcomm.com>
    wifi: mac80211: Discard Beacon frames to non-broadcast address

Ville Syrjälä <ville.syrjala@linux.intel.com>
    wifi: iwlwifi: Fix firmware version handling

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cm: Fix leaking the multicast GID table reference

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/core: Check for the presence of LS_NLA_TYPE_DGID correctly

Alice Ryhl <aliceryhl@google.com>
    rust: maple_tree: rcu_read_lock() in destructor to silence lockdep

Chenghao Duan <duanchenghao@kylinos.cn>
    samples/ftrace: Adjust LoongArch register restore order in direct calls

Wake Liu <wakel@google.com>
    selftests/mm: fix thread state check in uffd-unit-tests

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/mm/page_owner_sort: fix timestamp comparison for stable sorting

Rong Zhang <i@rong.moe>
    x86/microcode/AMD: Fix Entrysign revision check for Zen5/Strix Halo

Bijan Tabatabai <bijan311@gmail.com>
    mm: consider non-anon swap cache folios in folio_expected_ref_count()

Ran Xiaokai <ran.xiaokai@zte.com.cn>
    mm/page_owner: fix memory leak in page_owner_stack_fops->release()

Alexander Gordeev <agordeev@linux.ibm.com>
    mm/page_alloc: change all pageblocks migrate type on coalescing

Matthew Wilcox (Oracle) <willy@infradead.org>
    idr: fix idr_alloc() returning an ID out of range

NeilBrown <neil@brown.name>
    lockd: fix vfs_test_lock() calls

Pingfan Liu <piliu@redhat.com>
    kernel/kexec: fix IMA when allocation happens in CMA area

Pingfan Liu <piliu@redhat.com>
    kernel/kexec: change the prototype of kimage_map_segment()

Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
    kasan: unpoison vms[area] addresses with a common tag

Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
    kasan: refactor pcpu kasan vmalloc unpoison

Jiayuan Chen <jiayuan.chen@linux.dev>
    mm/kasan: fix incorrect unpoisoning in vrealloc for KASAN

Paolo Abeni <pabeni@redhat.com>
    mptcp: fallback earlier on simult connection

H. Peter Anvin <hpa@zytor.com>
    compiler_types.h: add "auto" as a macro for "__auto_type"

Jens Axboe <axboe@kernel.dk>
    af_unix: don't post cmsg for SO_INQ unless explicitly asked for

Wentao Liang <vulab@iscas.ac.cn>
    pmdomain: imx: Fix reference count leak in imx_gpc_probe()

Macpaul Lin <macpaul.lin@mediatek.com>
    pmdomain: mtk-pm-domains: Fix spinlock recursion fix in probe

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failure on damos_test_commit_filter()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failure on damon_test_set_attrs()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures in damon_test_ops_registration()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures on damos_test_filter_out()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: handle alloc failures on damon_test_set_filters_default_reject()

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
    mm/damon/tests/core-kunit: handle alloc failres in damon_test_new_filter()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/core-kunit: fix memory leak in damon_test_set_filters_default_reject()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/vaddr-kunit: handle alloc failures on damon_test_split_evenly_succ()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/vaddr-kunit: handle alloc failures in damon_test_split_evenly_fail()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/vaddr-kunit: handle alloc failures on damon_do_test_apply_three_regions()

SeongJae Park <sj@kernel.org>
    mm/damon/tests/sysfs-kunit: handle alloc failures on damon_sysfs_test_add_targets()

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Use unsigned long for _end and _text

WangYuli <wangyl5933@chinaunicom.cn>
    LoongArch: Use __pmd()/__pte() for swap entry conversions

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix build errors for CONFIG_RANDSTRUCT

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix arch_dup_task_struct() for CONFIG_RANDSTRUCT

Qiang Ma <maqianga@uniontech.com>
    LoongArch: Correct the calculation logic of thread_count

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Add new PCI ID for pci_fixup_vgadev()

Haoxiang Li <haoxiang_li2024@163.com>
    media: mediatek: vcodec: Fix a reference leak in mtk_vcodec_fw_vpu_init()

Chen-Yu Tsai <wenst@chromium.org>
    media: mediatek: vcodec: Use spinlock for context list protection lock

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: i2c: imx219: Fix 1920x1080 mode to use 1:1 pixel aspect ratio

Duoming Zhou <duoming@zju.edu.cn>
    media: i2c: adv7842: Remove redundant cancel_delayed_work in probe

Duoming Zhou <duoming@zju.edu.cn>
    media: i2c: ADV7604: Remove redundant cancel_delayed_work in probe

Ming Qian <ming.qian@oss.nxp.com>
    media: amphion: Cancel message work before releasing the VPU core

Ming Qian <ming.qian@oss.nxp.com>
    media: amphion: Remove vpu_vb_is_codecconfig

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

Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
    media: iris: Refine internal buffer reconfiguration logic for resolution change

Haotian Zhang <vulab@iscas.ac.cn>
    media: cec: Fix debugfs leak on bus_register() failure

René Rebe <rene@exactco.de>
    fbdev: tcx.c fix mem_map to correct smem_start offset

Thorsten Blum <thorsten.blum@linux.dev>
    fbdev: pxafb: Fix multiple clamped values in pxafb_adjust_timing

Rene Rebe <rene@exactco.de>
    fbdev: gbefb: fix to use physical address instead of dma address

Li Chen <chenl311@chinatelecom.cn>
    dm pcache: fix segment info indexing

Li Chen <chenl311@chinatelecom.cn>
    dm pcache: fix cache info indexing

Mikulas Patocka <mpatocka@redhat.com>
    dm-bufio: align write boundary on physical block size

Uladzislau Rezki (Sony) <urezki@gmail.com>
    dm-ebs: Mark full buffer dirty even on partial write

Mahesh Rao <mahesh.rao@altera.com>
    firmware: stratix10-svc: Add mutex in stratix10 memory management

Ivan Abramov <i.abramov@mt-integration.ru>
    media: adv7842: Avoid possible out-of-bounds array accesses in adv7842_cp_log_status()

David Hildenbrand <david@kernel.org>
    powerpc/pseries/cmm: call balloon_devinfo_init() also without CONFIG_BALLOON_COMPACTION

David Hildenbrand <david@kernel.org>
    powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages

Krzysztof Kozlowski <krzk@kernel.org>
    power: supply: max77705: Fix potential IRQ chip conflict when probing two devices

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Fix the return value of amd_uncore_df_event_init() on error

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    PCI: meson: Fix parsing the DBI register region

Jim Quinlan <james.quinlan@broadcom.com>
    PCI: brcmstb: Fix disabling L0s capability

Sven Schnelle <svens@stackframe.org>
    parisc: entry: set W bit for !compat tasks in syscall_restore_rfi()

Sven Schnelle <svens@stackframe.org>
    parisc: entry.S: fix space adjustment on interruption for 64-bit userspace

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    nvmet: pci-epf: move DMA initialization to EPC init callback

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Make FILE_SYNC WRITEs comply with spec

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

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm6350: Fix wrong order of freq-table-hz for UFS

Patrice Chotard <patrice.chotard@foss.st.com>
    arm64: dts: st: Add memory-region-names property for stm32mp257f-ev1

Paresh Bhagat <p-bhagat@ti.com>
    arm64: dts: ti: k3-am62d2-evm: Fix PMIC padconfig

Paresh Bhagat <p-bhagat@ti.com>
    arm64: dts: ti: k3-am62d2-evm: Fix regulator properties

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: verisilicon: Fix CPU stalls on G2 bus error

Haotian Zhang <vulab@iscas.ac.cn>
    media: rc: st_rc: Fix reset control resource leak

Krzysztof Kozlowski <krzk@kernel.org>
    mfd: max77620: Fix potential IRQ chip conflict when probing two devices

Johan Hovold <johan@kernel.org>
    mfd: altera-sysmgr: Fix device leak on sysmgr regmap lookup

Nathan Chancellor <nathan@kernel.org>
    clk: qcom: Fix dependencies of QCS_{DISP,GPU,VIDEO}CC_615

Nathan Chancellor <nathan@kernel.org>
    clk: qcom: Fix SM_VIDEOCC_6350 dependencies

Alexey Minnekhanov <alexeymin@postmarketos.org>
    clk: qcom: mmcc-sdm660: Add missing MDSS reset

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

Kairui Song <kasong@tencent.com>
    mm, swap: do not perform synchronous discard during allocation

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

Raghavendra Rao Ananta <rananta@google.com>
    hisi_acc_vfio_pci: Add .match_token_uuid callback in hisi_acc_vfio_pci_migrn_ops

Hans de Goede <johannes.goede@oss.qualcomm.com>
    HID: logitech-dj: Remove duplicate error logging

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Fix off-by-one error in dell_smm_is_visible()

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

Ma Ke <make24@iscas.ac.cn>
    ASoC: codecs: Fix error handling in pm4125 audio codec driver

Eric Naim <dnaim@cachyos.org>
    ASoC: cs35l41: Always return 0 when a subsystem ID is found

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: sdw: fix memory leak for sdw_stream_runtime

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: codecs: lpass-tx-macro: fix SM6115 support

Krzysztof Kozlowski <krzk@kernel.org>
    ASoC: codecs: pm4125: Remove irq_chip on component unbind

Krzysztof Kozlowski <krzk@kernel.org>
    ASoC: codecs: pm4125: Fix potential conflict when probing two devices

Ma Ke <make24@iscas.ac.cn>
    ASoC: codecs: wcd937x: Fix error handling in wcd937x codec driver

Biju Das <biju.das.jz@bp.renesas.com>
    ASoC: renesas: rz-ssi: Fix rz_ssi_priv::hw_params_cache::sample_width

Biju Das <biju.das.jz@bp.renesas.com>
    ASoC: renesas: rz-ssi: Fix channel swap issue in full duplex mode

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

Damien Le Moal <dlemoal@kernel.org>
    block: handle zone management operations completions

Yipeng Zou <zouyipeng@huawei.com>
    selftests/ftrace: traceonoff_triggers: strip off names

Cong Zhang <cong.zhang@oss.qualcomm.com>
    blk-mq: skip CPU offline notify on unmapped hctx

Thomas Fourier <fourier.thomas@gmail.com>
    RDMA/bnxt_re: fix dma_free_coherent() pointer

Honggang LI <honggangli@163.com>
    RDMA/rtrs: Fix clt_path::max_pages_per_mr calculation

Li Zhijian <lizhijian@fujitsu.com>
    IB/rxe: Fix missing umem_odp->umem_mutex unlock on error path

Zilin Guan <zilin@seu.edu.cn>
    ksmbd: Fix memory leak in get_file_all_info()

Jonathan Cavitt <jonathan.cavitt@intel.com>
    drm/xe/guc: READ/WRITE_ONCE g2h_fence->done

Ming Lei <ming.lei@redhat.com>
    ublk: scan partition in async way

Ming Lei <ming.lei@redhat.com>
    ublk: implement NUMA-aware memory allocation

Tuo Li <islituo@gmail.com>
    md/raid5: fix possible null-pointer dereferences in raid5_store_group_thread_cnt()

Li Nan <linan122@huawei.com>
    md: Fix static checker warning in analyze_sbs

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix to use correct page size for PDE table

David Gow <davidgow@google.com>
    kunit: Enforce task execution in {soft,hard}irq contexts

Ding Hui <dinghui@sangfor.com.cn>
    RDMA/bnxt_re: Fix OOB write in bnxt_re_copy_err_stats()

Alok Tiwari <alok.a.tiwari@oracle.com>
    RDMA/bnxt_re: Fix IB_SEND_IP_CSUM handling in post_send

Thomas Zimmermann <tzimmermann@suse.de>
    drm/gem-shmem: Fix the MODULE_LICENSE() string

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

Konstantin Taranov <kotaranov@microsoft.com>
    RDMA/mana_ib: check cqe length for kernel CQs

Arnd Bergmann <arnd@arndb.de>
    RDMA/irdma: Fix irdma_alloc_ucontext_resp padding

Arnd Bergmann <arnd@arndb.de>
    RDMA/ucma: Fix rdma_ucm_query_ib_service_resp struct padding

Jiayuan Chen <jiayuan.chen@linux.dev>
    ipv6: fix a BUG in rt6_get_pcpu_route() under PREEMPT_RT

Pwnverse <stanksal@purdue.edu>
    net: rose: fix invalid array index in rose_kill_by_device()

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    net: fib: restore ECMP balance from loopback

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix reference count leak when using error routes with nexthop objects

Will Rosenberg <whrosenb@asu.edu>
    ipv6: BUG() in pskb_expand_head() as part of calipso_skbuff_setattr()

Wei Fang <wei.fang@nxp.com>
    net: stmmac: fix the crash issue for zero copy XDP_TX action

Anshumali Gaur <agaur@marvell.com>
    octeontx2-pf: fix "UBSAN: shift-out-of-bounds error"

Alok Tiwari <alok.a.tiwari@oracle.com>
    platform/x86/intel/pmt/discovery: use valid device pointer in dev_err_probe

Junrui Luo <moonafterrain@outlook.com>
    platform/x86: hp-bioscfg: Fix out-of-bounds array access in ACPI package parsing

Zilin Guan <zilin@seu.edu.cn>
    vfio/pds: Fix memory leak in pds_vfio_dirty_enable()

Kohei Enju <enjuk@amazon.com>
    tools/sched_ext: fix scx_show_state.py for scx_root change

Bagas Sanjaya <bagasdotme@gmail.com>
    net: bridge: Describe @tunnel_hash member in net_bridge_vlan_group struct

Deepanshu Kartikey <kartikey406@gmail.com>
    net: usb: asix: validate PHY address before use

Rosen Penev <rosenp@gmail.com>
    net: mdio: rtl9300: use scoped for loops

Jose Javier Rodriguez Barbarin <dev-josejavier.rodriguez@duagon.com>
    mcb: Add missing modpost build support

Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>
    kbuild: fix compilation of dtb specified on command-line without make rule

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: skip multicast entries for fdb_dump()

Rajashekar Hudumula <rajashekar.hudumula@broadcom.com>
    bng_en: update module description

Thomas Fourier <fourier.thomas@gmail.com>
    firewire: nosy: Fix dma_free_coherent() size

Andrew Morton <akpm@linux-foundation.org>
    genalloc.h: fix htmldocs warning

Yeoreum Yun <yeoreum.yun@arm.com>
    smc91x: fix broken irq-context in PREEMPT_RT

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    platform/x86/intel/pmt: Fix kobject memory leak on init failure

Arnd Bergmann <arnd@arndb.de>
    net: wangxun: move PHYLINK dependency

Alice C. Munduruca <alice.munduruca@canonical.com>
    selftests: net: fix "buffer overflow detected" for tap.c

Deepakkumar Karn <dkarn@redhat.com>
    net: usb: rtl8150: fix memory leak on usb_submit_urb() failure

Daniel Zahka <daniel.zahka@gmail.com>
    selftests: drv-net: psp: fix test names in ipver_test_builder()

Daniel Zahka <daniel.zahka@gmail.com>
    selftests: drv-net: psp: fix templated test names in psp_ip_ver_test_builder()

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: reset retries and mode on RX adapt failures

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix missing put_device() in dsa_tree_find_first_conduit()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: properly keep track of conduit reference

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Move net_devs registration in a dedicated routine

Jiri Pirko <jiri@resnulli.us>
    team: fix check for port enabled in team_queue_override_port_prio_changed()

Junrui Luo <moonafterrain@outlook.com>
    platform/x86: ibm_rtl: fix EBDA signature search pointer arithmetic

Thomas Fourier <fourier.thomas@gmail.com>
    platform/x86: msi-laptop: add missing sysfs_remove_group()

Shravan Kumar Ramani <shravankr@nvidia.com>
    platform/mellanox: mlxbf-pmc: Remove trailing whitespaces from event names

Jan Stancek <jstancek@redhat.com>
    powerpc/tools: drop `-o pipefail` in gcc check scripts

Eric Dumazet <edumazet@google.com>
    ip6_gre: make ip6gre_header() robust

Toke Høiland-Jørgensen <toke@redhat.com>
    net: openvswitch: Avoid needlessly taking the RTNL on vport destroy

Jacky Chou <jacky_chou@aspeedtech.com>
    net: mdio: aspeed: add dummy read to avoid read-after-write issue

Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
    Bluetooth: btusb: revert use of devm_kzalloc in btusb

Pauli Virtanen <pav@iki.fi>
    Bluetooth: MGMT: report BIS capability flags in supported settings

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: seqiv - Do not use req->iv after crypto_aead_encrypt

Chen Ridong <chenridong@huawei.com>
    cpuset: fix warning when disabling remote partition

Brian Vazquez <brianvv@google.com>
    idpf: reduce mbx_task schedule delay to 300us

Larysa Zaremba <larysa.zaremba@intel.com>
    idpf: fix LAN memory regions command on some NVMs

Kohei Enju <enjuk@amazon.com>
    iavf: fix off-by-one issues in iavf_config_rss_reg()

Gregory Herrero <gregory.herrero@oracle.com>
    i40e: validate ring_len parameter against hardware-specific values

Przemyslaw Korba <przemyslaw.korba@intel.com>
    i40e: fix scheduling in set_rx_mode

Liang Jie <liangjie@lixiang.com>
    sched_ext: fix uninitialized ret on alloc_percpu() failure

Aloka Dixit <aloka.dixit@oss.qualcomm.com>
    wifi: mac80211: do not use old MBSSID elements

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: cfg80211: sme: store capped length in __cfg80211_connect_result()

Morning Star <alexbestoso@gmail.com>
    wifi: rtlwifi: 8192cu: fix tid out of range in rtl92cu_tx_fill_desc()

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw88: limit indirect IO under powered off for RTL8822CS

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: don't attach the tlb fence for SI

Jani Nikula <jani.nikula@intel.com>
    drm/displayid: add quirk to ignore DisplayID checksum errors

Jani Nikula <jani.nikula@intel.com>
    drm/edid: add DRM_EDID_IDENT_INIT() to initialize struct drm_edid_ident

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: Fix gmap_helper_zap_one_page() again

Wei Yang <richard.weiyang@gmail.com>
    mm/huge_memory: merge uniform_split_supported() and non_uniform_split_supported()

Zqiang <qiang.zhang@linux.dev>
    sched_ext: Fix incorrect sched_class settings for per-cpu migration tasks

Peter Zijlstra <peterz@infradead.org>
    sched/eevdf: Fix min_vruntime vs avg_vruntime

Peter Zijlstra <peterz@infradead.org>
    sched/core: Add comment explaining force-idle vruntime snapshots

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Select which microcode patch to load

Danilo Krummrich <dakr@kernel.org>
    drm: nova: depend on CONFIG_64BIT

Fernand Sieber <sieberf@amazon.com>
    sched/proxy: Yield the donor task


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/qcom/sm6350.dtsi               |   4 +-
 arch/arm64/boot/dts/st/stm32mp257f-ev1.dts         |   1 +
 arch/arm64/boot/dts/ti/k3-am62d2-evm.dts           |   9 +-
 arch/arm64/boot/dts/ti/k3-j721e-sk.dts             |  12 +-
 arch/loongarch/include/asm/pgtable.h               |   4 +-
 arch/loongarch/kernel/mcount_dyn.S                 |  14 +-
 arch/loongarch/kernel/process.c                    |   5 +
 arch/loongarch/kernel/relocate.c                   |   4 +-
 arch/loongarch/kernel/setup.c                      |   8 +-
 arch/loongarch/kernel/switch.S                     |   4 +-
 arch/loongarch/net/bpf_jit.c                       |  58 ++-
 arch/loongarch/net/bpf_jit.h                       |  26 ++
 arch/loongarch/pci/pci.c                           |   2 +
 arch/parisc/kernel/asm-offsets.c                   |   2 +
 arch/parisc/kernel/entry.S                         |  16 +-
 arch/powerpc/include/asm/book3s/32/tlbflush.h      |   5 +-
 arch/powerpc/include/asm/book3s/64/mmu-hash.h      |   1 -
 arch/powerpc/kernel/process.c                      |   5 -
 arch/powerpc/mm/book3s32/tlb.c                     |   9 +
 arch/powerpc/mm/book3s64/internal.h                |   2 -
 arch/powerpc/mm/book3s64/mmu_context.c             |   2 -
 arch/powerpc/mm/book3s64/slb.c                     |  88 -----
 arch/powerpc/platforms/pseries/cmm.c               |   3 +-
 .../tools/gcc-check-fpatchable-function-entry.sh   |   1 -
 arch/powerpc/tools/gcc-check-mprofile-kernel.sh    |   1 -
 arch/s390/mm/gmap_helpers.c                        |   9 +-
 arch/x86/events/amd/uncore.c                       |   5 +-
 arch/x86/kernel/cpu/microcode/amd.c                | 115 +++---
 block/blk-mq.c                                     |   2 +-
 block/blk-zoned.c                                  | 152 +++++---
 block/blk.h                                        |  14 +
 crypto/seqiv.c                                     |   8 +-
 drivers/block/ublk_drv.c                           | 119 +++++--
 drivers/bluetooth/btusb.c                          |  12 +-
 drivers/clk/qcom/Kconfig                           |   4 +
 drivers/clk/qcom/mmcc-sdm660.c                     |   1 +
 drivers/clk/samsung/clk-exynos-clkout.c            |   2 +-
 drivers/firewire/nosy.c                            |  10 +-
 drivers/firmware/stratix10-svc.c                   |  11 +
 drivers/gpio/gpiolib-swnode.c                      |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   7 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c             |  27 ++
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c             |  27 ++
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c            |   2 +
 drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h     |  62 ++--
 .../gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx12.asm |  37 ++
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |   1 +
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |   4 +
 drivers/gpu/drm/bridge/ti-sn65dsi83.c              |  11 +-
 drivers/gpu/drm/drm_buddy.c                        | 390 +++++++++++++--------
 drivers/gpu/drm/drm_displayid.c                    |  41 ++-
 drivers/gpu/drm/drm_displayid_internal.h           |   2 +
 drivers/gpu/drm/drm_gem.c                          |   8 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |   2 +-
 drivers/gpu/drm/drm_pagemap.c                      |  17 +-
 drivers/gpu/drm/gma500/fbdev.c                     |  43 ---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |  37 +-
 drivers/gpu/drm/i915/intel_memory_region.h         |   2 +-
 drivers/gpu/drm/imagination/pvr_gem.c              |  11 +
 drivers/gpu/drm/mediatek/mtk_ddp_comp.c            |  33 +-
 drivers/gpu/drm/mediatek/mtk_ddp_comp.h            |   2 +-
 drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c    |  12 +
 drivers/gpu/drm/mediatek/mtk_dp.c                  |   1 +
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   4 +-
 drivers/gpu/drm/mediatek/mtk_hdmi.c                |  15 +
 drivers/gpu/drm/mgag200/mgag200_mode.c             |  25 ++
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c          |   1 +
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c        |   2 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c    |  10 +-
 drivers/gpu/drm/nouveau/dispnv50/atom.h            |  13 +
 drivers/gpu/drm/nouveau/dispnv50/wndw.c            |   2 +-
 drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h  |   4 +
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c    |  61 +++-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/priv.h     |   3 +
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c  |  10 +-
 drivers/gpu/drm/nova/Kconfig                       |   1 +
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c        |   3 +
 drivers/gpu/drm/rockchip/rockchip_vop2_reg.c       |  49 ++-
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c               |   2 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |  53 ++-
 drivers/gpu/drm/tilcdc/tilcdc_drv.h                |   2 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |   6 +
 drivers/gpu/drm/xe/xe_bo.c                         |  15 +-
 drivers/gpu/drm/xe/xe_dma_buf.c                    |   2 +-
 drivers/gpu/drm/xe/xe_eu_stall.c                   |   2 +-
 drivers/gpu/drm/xe/xe_guc_ct.c                     |  14 +-
 drivers/gpu/drm/xe/xe_guc_submit.c                 |  20 +-
 drivers/gpu/drm/xe/xe_migrate.c                    |  25 +-
 drivers/gpu/drm/xe/xe_migrate.h                    |   6 +-
 drivers/gpu/drm/xe/xe_oa.c                         |  10 +-
 drivers/gpu/drm/xe/xe_svm.c                        |  51 ++-
 drivers/gpu/drm/xe/xe_vm.c                         |   5 +-
 drivers/gpu/drm/xe/xe_vm_types.h                   |   2 +-
 drivers/hid/hid-logitech-dj.c                      |  56 ++-
 drivers/hwmon/dell-smm-hwmon.c                     |   4 +-
 drivers/infiniband/core/addr.c                     |  33 +-
 drivers/infiniband/core/cma.c                      |   3 +
 drivers/infiniband/core/device.c                   |   4 +-
 drivers/infiniband/core/verbs.c                    |   2 +-
 drivers/infiniband/hw/bnxt_re/hw_counters.h        |   6 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   7 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |   8 +-
 drivers/infiniband/hw/efa/efa_verbs.c              |   4 -
 drivers/infiniband/hw/irdma/utils.c                |   3 +-
 drivers/infiniband/hw/mana/cq.c                    |   4 +
 drivers/infiniband/sw/rxe/rxe_odp.c                |   4 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |   1 +
 drivers/iommu/amd/init.c                           |  15 +-
 drivers/iommu/amd/iommu.c                          |   2 +-
 drivers/iommu/apple-dart.c                         |   2 +
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |  10 +-
 drivers/iommu/exynos-iommu.c                       |   9 +-
 drivers/iommu/iommu-sva.c                          |   3 +
 drivers/iommu/ipmmu-vmsa.c                         |   2 +
 drivers/iommu/mtk_iommu.c                          |   2 +
 drivers/iommu/mtk_iommu_v1.c                       |  25 +-
 drivers/iommu/omap-iommu.c                         |   2 +-
 drivers/iommu/omap-iommu.h                         |   2 -
 drivers/iommu/sun50i-iommu.c                       |   2 +
 drivers/iommu/tegra-smmu.c                         |   5 +-
 drivers/leds/leds-cros_ec.c                        |   5 +-
 drivers/leds/leds-lp50xx.c                         |  67 ++--
 drivers/md/dm-bufio.c                              |  10 +-
 drivers/md/dm-ebs-target.c                         |   2 +-
 drivers/md/dm-pcache/cache.c                       |   5 +-
 drivers/md/dm-pcache/cache_segment.c               |   5 +-
 drivers/md/md.c                                    |   5 +-
 drivers/md/raid5.c                                 |  10 +-
 drivers/media/cec/core/cec-core.c                  |   1 +
 .../media/common/videobuf2/videobuf2-dma-contig.c  |   1 +
 drivers/media/i2c/adv7604.c                        |   4 +-
 drivers/media/i2c/adv7842.c                        |  11 +-
 drivers/media/i2c/imx219.c                         |   9 +-
 drivers/media/i2c/msp3400-kthreads.c               |   2 +
 drivers/media/i2c/tda1997x.c                       |   1 -
 drivers/media/platform/amphion/vpu_malone.c        |  23 +-
 drivers/media/platform/amphion/vpu_v4l2.c          |  16 +-
 drivers/media/platform/amphion/vpu_v4l2.h          |  10 -
 .../media/platform/mediatek/mdp3/mtk-mdp3-core.c   |  14 +
 .../mediatek/vcodec/common/mtk_vcodec_fw_vpu.c     |  14 +-
 .../mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c   |  12 +-
 .../mediatek/vcodec/decoder/mtk_vcodec_dec_drv.h   |   2 +-
 .../platform/mediatek/vcodec/decoder/vdec_vpu_if.c |   5 +-
 .../mediatek/vcodec/encoder/mtk_vcodec_enc_drv.c   |  12 +-
 .../mediatek/vcodec/encoder/mtk_vcodec_enc_drv.h   |   2 +-
 .../platform/mediatek/vcodec/encoder/venc_vpu_if.c |   5 +-
 drivers/media/platform/qcom/iris/iris_common.c     |   7 +-
 drivers/media/platform/renesas/rcar_drif.c         |   1 +
 .../media/platform/samsung/exynos4-is/media-dev.c  |  10 +-
 drivers/media/platform/ti/davinci/vpif_capture.c   |   4 +-
 drivers/media/platform/ti/davinci/vpif_display.c   |   4 +-
 drivers/media/platform/verisilicon/hantro_g2.c     |  84 ++++-
 .../platform/verisilicon/hantro_g2_hevc_dec.c      |  17 +-
 .../media/platform/verisilicon/hantro_g2_regs.h    |  13 +
 .../media/platform/verisilicon/hantro_g2_vp9_dec.c |   2 -
 drivers/media/platform/verisilicon/hantro_hw.h     |   1 +
 drivers/media/platform/verisilicon/imx8m_vpu_hw.c  |   2 +
 drivers/media/rc/st_rc.c                           |   2 +-
 drivers/mfd/altera-sysmgr.c                        |   2 +
 drivers/mfd/max77620.c                             |  15 +-
 drivers/mtd/mtdpart.c                              |   7 +-
 drivers/mtd/spi-nor/winbond.c                      |  24 ++
 drivers/net/dsa/b53/b53_common.c                   |   3 +
 drivers/net/ethernet/airoha/airoha_eth.c           |  39 ++-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |   2 +
 drivers/net/ethernet/broadcom/Kconfig              |   8 +-
 drivers/net/ethernet/broadcom/bnge/bnge.h          |   2 +-
 drivers/net/ethernet/broadcom/bnge/bnge_core.c     |   2 +-
 drivers/net/ethernet/cadence/macb_main.c           |   3 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   2 +-
 drivers/net/ethernet/google/gve/gve_utils.c        |   2 +
 drivers/net/ethernet/intel/e1000/e1000_main.c      |  10 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |  11 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  12 -
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   1 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   4 +-
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |   2 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |   5 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   8 +
 drivers/net/ethernet/smsc/smc91x.c                 |  10 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  17 +-
 drivers/net/ethernet/wangxun/Kconfig               |   4 +-
 drivers/net/fjes/fjes_hw.c                         |  12 +-
 drivers/net/mdio/mdio-aspeed.c                     |   7 +
 drivers/net/mdio/mdio-realtek-rtl9300.c            |   6 +-
 drivers/net/phy/mediatek/mtk-ge-soc.c              |   2 +-
 drivers/net/team/team_core.c                       |   2 +-
 drivers/net/usb/asix_common.c                      |   5 +
 drivers/net/usb/ax88172a.c                         |   6 +-
 drivers/net/usb/rtl8150.c                          |   2 +
 drivers/net/usb/sr9700.c                           |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |   3 +-
 drivers/net/wireless/realtek/rtw88/sdio.c          |   4 +-
 drivers/nvme/target/pci-epf.c                      |   4 +-
 drivers/pci/controller/dwc/pci-meson.c             |  18 +-
 drivers/pci/controller/dwc/pcie-designware.c       |  12 +-
 drivers/pci/controller/pcie-brcmstb.c              |  10 +-
 drivers/pci/pci-driver.c                           |   4 +
 drivers/platform/mellanox/mlxbf-pmc.c              |  14 +-
 drivers/platform/x86/dell/alienware-wmi-wmax.c     |  32 ++
 .../platform/x86/hp/hp-bioscfg/enum-attributes.c   |   4 +-
 .../platform/x86/hp/hp-bioscfg/int-attributes.c    |   2 +-
 .../x86/hp/hp-bioscfg/order-list-attributes.c      |   5 +
 .../x86/hp/hp-bioscfg/passwdobj-attributes.c       |   5 +
 .../platform/x86/hp/hp-bioscfg/string-attributes.c |   2 +-
 drivers/platform/x86/ibm_rtl.c                     |   2 +-
 drivers/platform/x86/intel/pmt/discovery.c         |   8 +-
 drivers/platform/x86/msi-laptop.c                  |   3 +
 drivers/platform/x86/samsung-galaxybook.c          |   9 +-
 drivers/pmdomain/imx/gpc.c                         |   5 +-
 drivers/pmdomain/mediatek/mtk-pm-domains.c         |  21 +-
 drivers/power/supply/max77705_charger.c            |  14 +-
 drivers/powercap/intel_rapl_common.c               |   3 +
 drivers/powercap/intel_rapl_msr.c                  |   3 +
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |   1 +
 drivers/vfio/pci/nvgrace-gpu/main.c                |   4 +-
 drivers/vfio/pci/pds/dirty.c                       |   7 +-
 drivers/vfio/pci/vfio_pci_rdwr.c                   |  25 +-
 drivers/video/fbdev/gbefb.c                        |   5 +-
 drivers/video/fbdev/pxafb.c                        |  12 +-
 drivers/video/fbdev/tcx.c                          |   2 +-
 fs/erofs/zdata.c                                   |  10 +-
 fs/lockd/svc4proc.c                                |   4 +-
 fs/lockd/svclock.c                                 |  21 +-
 fs/lockd/svcproc.c                                 |   5 +-
 fs/locks.c                                         |  12 +-
 fs/nfsd/nfs4state.c                                |  20 +-
 fs/nfsd/vfs.c                                      |  14 +-
 fs/ntfs3/frecord.c                                 |  35 +-
 fs/smb/server/smb2pdu.c                            |   4 +-
 include/drm/drm_buddy.h                            |  11 +-
 include/drm/drm_edid.h                             |   6 +
 include/drm/drm_pagemap.h                          |  17 +-
 include/kunit/run-in-irq-context.h                 |  53 +--
 include/linux/compiler_types.h                     |  13 +
 include/linux/genalloc.h                           |   1 +
 include/linux/huge_mm.h                            |   8 +-
 include/linux/kasan.h                              |  16 +
 include/linux/kexec.h                              |   4 +-
 include/linux/mm.h                                 |   8 +-
 include/linux/vfio_pci_core.h                      |  10 +-
 include/net/dsa.h                                  |   1 +
 include/uapi/rdma/irdma-abi.h                      |   2 +-
 include/uapi/rdma/rdma_user_cm.h                   |   4 +-
 kernel/cgroup/cpuset.c                             |  21 +-
 kernel/kexec_core.c                                |  16 +-
 kernel/sched/deadline.c                            |   2 +-
 kernel/sched/debug.c                               |   8 +-
 kernel/sched/ext.c                                 |  22 +-
 kernel/sched/fair.c                                | 249 +++++++++----
 kernel/sched/rt.c                                  |   2 +-
 kernel/sched/sched.h                               |   4 +-
 kernel/sched/syscalls.c                            |   5 +-
 kernel/trace/fgraph.c                              |  10 +-
 lib/idr.c                                          |   2 +
 mm/damon/tests/core-kunit.h                        | 132 ++++++-
 mm/damon/tests/sysfs-kunit.h                       |  25 ++
 mm/damon/tests/vaddr-kunit.h                       |  26 +-
 mm/huge_memory.c                                   |  71 ++--
 mm/kasan/common.c                                  |  32 ++
 mm/kasan/hw_tags.c                                 |   2 +-
 mm/kasan/shadow.c                                  |   4 +-
 mm/page_alloc.c                                    |  24 +-
 mm/page_owner.c                                    |   2 +-
 mm/swapfile.c                                      |  40 ++-
 mm/vmalloc.c                                       |   8 +-
 net/bluetooth/mgmt.c                               |   6 +
 net/bridge/br_private.h                            |   1 +
 net/dsa/dsa.c                                      |  67 ++--
 net/ipv4/fib_semantics.c                           |  26 +-
 net/ipv4/fib_trie.c                                |   7 +-
 net/ipv4/ip_gre.c                                  |   6 +-
 net/ipv6/calipso.c                                 |   3 +-
 net/ipv6/ip6_gre.c                                 |  15 +-
 net/ipv6/route.c                                   |  13 +-
 net/mac80211/cfg.c                                 |  10 -
 net/mac80211/rx.c                                  |   5 +
 net/mptcp/options.c                                |  10 +
 net/mptcp/protocol.h                               |   6 +-
 net/mptcp/subflow.c                                |   6 -
 net/nfc/core.c                                     |   9 +-
 net/openvswitch/vport-netdev.c                     |  17 +-
 net/rose/af_rose.c                                 |   2 +-
 net/unix/af_unix.c                                 |  11 +-
 net/wireless/sme.c                                 |   2 +-
 rust/kernel/maple_tree.rs                          |  11 +-
 samples/ftrace/ftrace-direct-modify.c              |   8 +-
 samples/ftrace/ftrace-direct-multi-modify.c        |   8 +-
 samples/ftrace/ftrace-direct-multi.c               |   4 +-
 samples/ftrace/ftrace-direct-too.c                 |   4 +-
 samples/ftrace/ftrace-direct.c                     |   4 +-
 scripts/Makefile.build                             |  26 +-
 scripts/mod/devicetable-offsets.c                  |   3 +
 scripts/mod/file2alias.c                           |   9 +
 security/integrity/ima/ima_kexec.c                 |   4 +-
 sound/soc/codecs/cs35l41.c                         |   7 +-
 sound/soc/codecs/lpass-tx-macro.c                  |   3 +-
 sound/soc/codecs/pm4125.c                          |  40 ++-
 sound/soc/codecs/wcd937x.c                         |  43 ++-
 sound/soc/codecs/wcd939x-sdw.c                     |   8 +-
 sound/soc/qcom/qdsp6/q6adm.c                       | 146 ++++----
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |   2 +
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |   7 +-
 sound/soc/qcom/sc7280.c                            |   2 +-
 sound/soc/qcom/sc8280xp.c                          |   2 +-
 sound/soc/qcom/sdw.c                               | 105 +++---
 sound/soc/qcom/sdw.h                               |   1 +
 sound/soc/qcom/sm8250.c                            |   2 +-
 sound/soc/qcom/x1e80100.c                          |   2 +-
 sound/soc/renesas/rz-ssi.c                         |  64 +++-
 sound/soc/stm/stm32_sai.c                          |  14 +-
 sound/soc/stm/stm32_sai_sub.c                      |  51 ++-
 tools/mm/page_owner_sort.c                         |   6 +-
 tools/sched_ext/scx_show_state.py                  |   7 +-
 tools/testing/radix-tree/idr-test.c                |  21 ++
 tools/testing/selftests/drivers/net/psp.py         |   6 +-
 .../test.d/ftrace/func_traceonoff_triggers.tc      |   5 +-
 tools/testing/selftests/mm/uffd-unit-tests.c       |   2 +-
 tools/testing/selftests/net/tap.c                  |  16 +-
 326 files changed, 3276 insertions(+), 1649 deletions(-)


