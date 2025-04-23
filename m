Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36FEC8EB;
	Wed, 23 Apr 2025 14:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419540; cv=none; b=q12/iS8RQgen9hR99kUdOao7/thlN+80iV4ECRMGZ/Tl6vHXilG1UrpQF3159LhiGY1doxv3jhQBe7jBhyoX+P9rdOMO+hw3QiUQj4ByxYX4+XsiGmSwp2a6QQOO6atlTAlDn2rgTRVFFUqpuc//Lr8rkjcWpcvLRZc75uLn4dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419540; c=relaxed/simple;
	bh=JQgRwSYrbnE/tPk8RxPjh638ejdFE7IACaoqgQqITC8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VD0SbR/WIhjpJ5HP94tHwkvQ9UYil1k6r5lZvCZXabnK+NLfSuqFNdyzqcjw+HjYxefvbrFhqBryxhct2ZCF3bDzkgCpPMUNBAaMs2ReCLQz4pp9GY7vLkEqTN9HjALJwkrdLW5risyATMgzOln5eqeggdcqvj2mVt7A8iNn8zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEfAIvd5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEfAIvd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3A5C4CEE2;
	Wed, 23 Apr 2025 14:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419539;
	bh=JQgRwSYrbnE/tPk8RxPjh638ejdFE7IACaoqgQqITC8=;
	h=From:To:Cc:Subject:Date:From;
	b=GEfAIvd5+No1V9fBLYqwgyFZKu/lNbIQqSbDJMRjealG8sVkja4fmB1e6K6yAxpzd
	 g1NebFcQuDl6I57r+fIoJHHycI61/4udXxdw2xx+ZubY6CMm0XhuyFoFpr/jAcZX6I
	 cxJlKfUGvuLLK7e6/i8Xo9J80fI+od+1SvLU85oQ=
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
Subject: [PATCH 6.12 000/223] 6.12.25-rc1 review
Date: Wed, 23 Apr 2025 16:41:12 +0200
Message-ID: <20250423142617.120834124@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.25-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.25-rc1
X-KernelTest-Deadline: 2025-04-25T14:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.25 release.
There are 223 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.25-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.25-rc1

Jens Axboe <axboe@kernel.dk>
    block: make struct rq_list available for !CONFIG_BLOCK

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: extend changes_pkt_data with cases w/o subprograms

Eduard Zingerman <eddyz87@gmail.com>
    bpf: fix null dereference when computing changes_pkt_data of prog w/o subprogs

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: validate that tail call invalidates packet pointers

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: freplace tests for tracking of changes_packet_data

Eduard Zingerman <eddyz87@gmail.com>
    bpf: check changes_pkt_data property for extension programs

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: test for changing packet data from global functions

Eduard Zingerman <eddyz87@gmail.com>
    bpf: track changes_pkt_data property for global functions

Eduard Zingerman <eddyz87@gmail.com>
    bpf: add find_containing_subprog() utility function

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process

WangYuli <wangyuli@uniontech.com>
    MIPS: ds1287: Match ds1287_set_base_clock() function types

WangYuli <wangyuli@uniontech.com>
    MIPS: cevt-ds1287: Add missing ds1287.h include

WangYuli <wangyuli@uniontech.com>
    MIPS: dec: Declare which_prom() as static

Alexander Tsoy <alexander@tsoy.me>
    Revert "wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process"

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm/vma: add give_up_on_oom option on modify/merge, use in uffd release

Christoph Hellwig <hch@lst.de>
    block: don't reorder requests in blk_add_rq_to_plug

Christoph Hellwig <hch@lst.de>
    block: add a rq_list type

Christoph Hellwig <hch@lst.de>
    block: remove rq_list_move

WangYuli <wangyuli@uniontech.com>
    nvmet-fc: Remove unused functions

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: Temporarily disable hostvm on DCN31

Yuli Wang <wangyuli@uniontech.com>
    LoongArch: Eliminate superfluous get_numa_distances_cnt()

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    efi/libstub: Bump up EFI_MMAP_NR_SLACK_SLOTS to 32

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Fix 'irq_type' to convey the correct type

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Avoid issue of interrupts remaining after request_irq error

Shung-Hsi Yu <shung-hsi.yu@suse.com>
    selftests/bpf: Fix raw_tp null handling test

Yu Kuai <yukuai3@huawei.com>
    md: fix mddev uaf while iterating all_mddevs list

Armin Wolf <W_Armin@gmx.de>
    platform/x86: msi-wmi-platform: Workaround a ACPI firmware bug

Armin Wolf <W_Armin@gmx.de>
    platform/x86: msi-wmi-platform: Rename "data" variable

Nathan Chancellor <nathan@kernel.org>
    kbuild: Add '-fno-builtin-wcslen'

Lukas Fischer <kernel@o1oo11oo.de>
    scripts: generate_rust_analyzer: Add ffi crate

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Reference count policy in cpufreq_update_limits()

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/sysreg: Add register fields for HFGWTR2_EL2

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/sysreg: Add register fields for HFGRTR2_EL2

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/sysreg: Add register fields for HFGITR2_EL2

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/sysreg: Add register fields for HDFGWTR2_EL2

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/sysreg: Add register fields for HDFGRTR2_EL2

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/sysreg: Update register fields for ID_AA64MMFR0_EL1

Thomas Zimmermann <tzimmermann@suse.de>
    drm/mgag200: Fix value in <VBLKSTR> register

ZhenGuo Yin <zhenguo.yin@amd.com>
    drm/amdgpu: fix warning of drm_mm_clean

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe: Set LRC addresses before guc load

Matthew Auld <matthew.auld@intel.com>
    drm/xe/userptr: fix notifier vs folio deadlock

Matthew Auld <matthew.auld@intel.com>
    drm/xe/dma_buf: stop relying on placement in unmap

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Add HP Probook 445 and 465 to the quirk list for eDP on DP1

Huacai Chen <chenhuacai@kernel.org>
    drm/amd/display: Protect FPU in dml2_init()/dml21_init()

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Do not enable Replay and PSR while VRR is on in amdgpu_dm_commit_planes()

Christian König <christian.koenig@amd.com>
    drm/amdgpu: immediately use GTT for new allocations

Jani Nikula <jani.nikula@intel.com>
    drm/i915/gvt: fix unterminated-string-initialization warning

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Fix an out-of-bounds shift when invalidating TLB

Rolf Eike Beer <eb@emlix.com>
    drm/sti: remove duplicate object names

Brendan King <Brendan.King@imgtec.com>
    drm/imagination: take paired job reference

Brendan King <Brendan.King@imgtec.com>
    drm/imagination: fix firmware memory leaks

Chris Bainbridge <chris.bainbridge@gmail.com>
    drm/nouveau: prime: fix ttm_bo_delayed_delete oops

Matthew Auld <matthew.auld@intel.com>
    drm/amdgpu/dma_buf: fix page_link check

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mes11: optimize MES pipe FW version fetching

Huacai Chen <chenhuacai@kernel.org>
    drm/amd/display: Protect FPU in dml21_copy()

Huacai Chen <chenhuacai@kernel.org>
    drm/amd/display: Protect FPU in dml2_validate()/dml21_validate()

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Add HP Elitebook 645 to the quirk list for eDP on DP1

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Use local fence in error path of xe_migrate_clear

Ankit Nautiyal <ankit.k.nautiyal@intel.com>
    drm/i915/vrr: Add vrr.vsync_{start, end} in vrr_params_changed

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mes12: optimize MES pipe FW version fetching

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/powerplay/hwmgr/vega20_thermal: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/swsmu/smu13/smu_v13_0: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/powerplay/hwmgr/smu7_thermal: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/smu11: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/powerplay: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm: Prevent division by zero

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Increase vblank offdelay for PSR panels

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Actually do immediate vblank disable

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Handle being compiled without SI or CIK support better

Brendan Tam <Brendan.Tam@amd.com>
    drm/amd/display: prevent hang on link training fail

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Prefer shadow rom when available

Akhil P Oommen <quic_akhilpo@quicinc.com>
    drm/msm/a6xx: Fix stale rpmh votes from GPU

Haoxiang Li <haoxiang_li2024@163.com>
    drm/msm/dsi: Add check for devm_kstrdup()

Jocelyn Falempe <jfalempe@redhat.com>
    drm/ast: Fix ast_dp connection status

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/repaper: fix integer overflows in repeat functions

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix the scale of IIO free running counters on SPR

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix the scale of IIO free running counters on ICX

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix the scale of IIO free running counters on SNR

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Allow to update user space GPRs from PEBS records

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86: amd: pmf: Fix STT limits

Yazen Ghannam <yazen.ghannam@amd.com>
    RAS/AMD/FMPM: Get masked address

Yazen Ghannam <yazen.ghannam@amd.com>
    RAS/AMD/ATL: Include row[13] bit in row retirement

Sharath Srinivasan <sharath.srinivasan@oracle.com>
    RDMA/cma: Fix workqueue crash in cma_netevent_work_handler

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: Ensure consistent phy reference counts

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: megaraid_sas: Block zero-length ATA VPD inquiry

Ard Biesheuvel <ardb@kernel.org>
    x86/boot/sev: Avoid shared GHCB page for early memory acceptance

Sandipan Das <sandipan.das@amd.com>
    x86/cpu/amd: Fix workaround for erratum 1054

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Extend the SHA check to Zen5, block loading of any unreleased standalone Zen5 microcode patches

Xiangsheng Hou <xiangsheng.hou@mediatek.com>
    virtiofs: add filesystem context source name check

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix filter string testing

Peter Collingbourne <pcc@google.com>
    string: Add load_unaligned_zeropad() code path to sized_strscpy()

Chunjie Zhu <chunjie.zhu@cloud.com>
    smb3 client: fix open hardlink on deferred close file error

Suren Baghdasaryan <surenb@google.com>
    slab: ensure slab->obj_exts is clear in a newly allocated slab page

Mark Brown <broonie@kernel.org>
    selftests/mm: generate a temporary mountpoint for cgroup filesystem

Nathan Chancellor <nathan@kernel.org>
    riscv: Avoid fortify warning in syscall_get_arguments()

Kuniyuki Iwashima <kuniyu@amazon.com>
    Revert "smb: client: fix TCP timers deadlock after rmmod"

Kuniyuki Iwashima <kuniyu@amazon.com>
    Revert "smb: client: Fix netns refcount imbalance causing leaks and use-after-free"

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix the warning from __kernel_write_iter

Denis Arefev <arefev@swemel.ru>
    ksmbd: Prevent integer overflow in calculation of deadtime

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in smb_break_all_levII_oplock()

Sean Heelan <seanheelan@gmail.com>
    ksmbd: Fix dangling pointer in krb_authenticate

Miklos Szeredi <mszeredi@redhat.com>
    ovl: don't allow datadir only

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm: fix apply_to_existing_page_range()

Vishal Moola (Oracle) <vishal.moola@gmail.com>
    mm: fix filemap_get_folios_contig returning batches of identical folios

Baoquan He <bhe@redhat.com>
    mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()

Vishal Moola (Oracle) <vishal.moola@gmail.com>
    mm/compaction: fix bug in hugetlb handling pathway

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    loop: LOOP_SET_FD: send uevents for partitions

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    loop: properly send KOBJ_CHANGED uevent for disk device

Edward Adam Davis <eadavis@qq.com>
    isofs: Prevent the use of too small fid

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    i2c: cros-ec-tunnel: defer probe if parent EC is not present

Vasiliy Kovalev <kovalev@altlinux.org>
    hfs/hfsplus: fix slab-out-of-bounds in hfs_bnode_read_key

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: caam/qi - Fix drv_ctx refcount bug

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Avoid using inconsistent policy->min and policy->max

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq/sched: Explicitly synchronize limits_changed flag handling

Johannes Kimmel <kernel@bareminimum.eu>
    btrfs: correctly escape subvol in btrfs_show_options()

Kees Cook <kees@kernel.org>
    Bluetooth: vhci: Avoid needless snprintf() calls

Frédéric Danis <frederic.danis@collabora.com>
    Bluetooth: l2cap: Process valid commands in too long frame

Rob Clark <robdclark@chromium.org>
    drm/msm/a6xx+: Don't let IB_SIZE overflow

Menglong Dong <menglong8.dong@gmail.com>
    ftrace: fix incorrect hash size in register_ftrace_direct()

Christoph Hellwig <hch@lst.de>
    fs: move the bdex_statx call to vfs_getattr_nosec

Su Hui <suhui@nfschina.com>
    fs/stat.c: avoid harmless garbage value problem in vfs_statx_path()

Stefan Berger <stefanb@linux.ibm.com>
    fs: Simplify getattr interface function checking AT_GETATTR_NOSEC flag

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: atr: Fix wrong include

Li Lingfeng <lilingfeng3@huawei.com>
    nfsd: decrease sc_count directly if fail to queue dl_recall

Eric Biggers <ebiggers@google.com>
    nfs: add missing selections of CONFIG_CRC32

Dan Carpenter <dan.carpenter@linaro.org>
    dma-buf/sw_sync: Decrement refcount on error in sw_sync_ioctl_get_deadline()

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Fix Indirect Dispatch configuration for V3D 7.1.6 and later

Martin K. Petersen <martin.petersen@oracle.com>
    block: integrity: Do not call set_page_dirty_lock()

Denis Arefev <arefev@swemel.ru>
    asus-laptop: Fix an uninitialized variable

Evgeny Pimenov <pimenoveu12@gmail.com>
    ASoC: qcom: Fix sc7280 lpass potential buffer overflow

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: Intel: sof_sdw: Add quirk for Asus Zenbook S16

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs:lpass-wsa-macro: Fix logic of enabling vi channels

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs:lpass-wsa-macro: Fix vi feedback rate

Herve Codina <herve.codina@bootlin.com>
    ASoC: fsl: fsl_qmc_audio: Reset audio data pointers on TRIGGER_START event

Alex Williamson <alex.williamson@redhat.com>
    Revert "PCI: Avoid reset when disabled via sysfs"

Andreas Gruenbacher <agruenba@redhat.com>
    writeback: fix false warning in inode_to_wb()

Miguel Ojeda <ojeda@kernel.org>
    rust: kbuild: use `pound` to support GNU Make < 4.3

Miguel Ojeda <ojeda@kernel.org>
    rust: disable `clippy::needless_continue`

Miguel Ojeda <ojeda@kernel.org>
    rust: kasan/kbuild: fix missing flags on first build

Miguel Ojeda <ojeda@kernel.org>
    objtool/rust: add one more `noreturn` Rust function for Rust 1.86.0

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq/sched: Fix the usage of CPUFREQ_NEED_UPDATE_LIMITS

WangYuli <wangyuli@uniontech.com>
    riscv: KGDB: Remove ".option norvc/.option rvc" for kgdb_compiled_break

WangYuli <wangyuli@uniontech.com>
    riscv: KGDB: Do not inline arch_kgdb_breakpoint()

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kunit: qemu_configs: SH: Respect kunit cmdline

Samuel Holland <samuel.holland@sifive.com>
    riscv: module: Allocate PLT entries for R_RISCV_PLT32

Samuel Holland <samuel.holland@sifive.com>
    riscv: module: Fix out-of-bounds relocation access

Björn Töpel <bjorn@rivosinc.com>
    riscv: Properly export reserved regions in /proc/iomem

Will Pierce <wgpierce17@gmail.com>
    riscv: Use kvmalloc_array on relocation_hashtable

Bo-Cun Chen <bc-bocun.chen@mediatek.com>
    net: ethernet: mtk_eth_soc: revise QDMA packet scheduler settings

Bo-Cun Chen <bc-bocun.chen@mediatek.com>
    net: ethernet: mtk_eth_soc: correct the max weight of the queue limit for 100Mbps

Bo-Cun Chen <bc-bocun.chen@mediatek.com>
    net: ethernet: mtk_eth_soc: reapply mdc divider on reset

Meghana Malladi <m-malladi@ti.com>
    net: ti: icss-iep: Fix possible NULL pointer dereference for perout request

Meghana Malladi <m-malladi@ti.com>
    net: ti: icss-iep: Add phase offset configuration for perout signal

Meghana Malladi <m-malladi@ti.com>
    net: ti: icss-iep: Add pwidth configuration for perout signal

Sagi Maimon <maimon.sagi@gmail.com>
    ptp: ocp: fix start time alignment in ptp_ocp_signal_set

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: avoid refcount warnings when ds->ops->tag_8021q_vlan_del() fails

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: free routing table on probe failure

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: clean up FDB, MDB, VLAN entries on unbind

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: fix -ENOENT when deleting VLANs and MST is unsupported

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: avoid unregistering devlink regions which were never registered

Abdun Nihaal <abdun.nihaal@gmail.com>
    net: txgbe: fix memory leak in txgbe_probe() error path

Jonas Gorski <jonas.gorski@gmail.com>
    net: bridge: switchdev: do not notify new brentries as changed

Jonas Gorski <jonas.gorski@gmail.com>
    net: b53: enable BPDU reception for management port

Jakub Kicinski <kuba@kernel.org>
    netlink: specs: rt-link: adjust mctp attribute naming

Jakub Kicinski <kuba@kernel.org>
    netlink: specs: rt-link: add an attr layer around alt-ifname

Jakub Kicinski <kuba@kernel.org>
    tools: ynl-gen: make sure we validate subtype of array-nest

Jakub Kicinski <kuba@kernel.org>
    tools: ynl-gen: individually free previous values on double set

Abdun Nihaal <abdun.nihaal@gmail.com>
    cxgb4: fix memory leak in cxgb4_init_ethtool_filters() error path

Niklas Cassel <cassel@kernel.org>
    ata: libata-sata: Save all fields from sense data descriptor

Christoph Hellwig <hch@lst.de>
    loop: stop using vfs_iter_{read,write} for buffered I/O

Yunlong Xing <yunlong.xing@unisoc.com>
    loop: aio inherit the ioprio of original request

Jakub Kicinski <kuba@kernel.org>
    eth: bnxt: fix missing ring index trim on error path

Michael Walle <mwalle@kernel.org>
    net: ethernet: ti: am65-cpsw: fix port_np reference counting

Abdun Nihaal <abdun.nihaal@gmail.com>
    net: ngbe: fix memory leak in ngbe_probe() error path

Weizhao Ouyang <o451686892@gmail.com>
    can: rockchip_canfd: fix broken quirks checks

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix nested key length validation in the set() action

Jakub Kicinski <kuba@kernel.org>
    netlink: specs: ovs_vport: align with C codegen capabilities

Zheng Qixing <zhengqixing@huawei.com>
    block: fix resource leak in blk_register_queue() error path

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp: Set SOCK_RCU_FREE

Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
    ethtool: cmis_cdb: use correct rpl size in ethtool_cmis_module_poll()

Abdun Nihaal <abdun.nihaal@gmail.com>
    pds_core: fix memory leak in pdsc_debugfs_add_qcq()

Matthew Wilcox (Oracle) <willy@infradead.org>
    test suite: use %zu to print size_t

Kuniyuki Iwashima <kuniyu@amazon.com>
    smc: Fix lockdep false-positive for IPPROTO_SMC.

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: soc: fsl: fsl,ls1028a-reset: Fix maintainer entry

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: add lock preventing multiple simultaneous PTM transactions

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: cleanup PTP module if probe fails

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: handle the IGC_PTP_ENABLED flag correctly

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: move ktime snapshot into PTM retry loop

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: increase wait time before retrying PTM

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: fix PTM cycle trigger logic

Johannes Berg <johannes.berg@intel.com>
    Revert "wifi: mac80211: Update skb's control block key in ieee80211_tx_dequeue()"

Juergen Gross <jgross@suse.com>
    xen: fix multicall debug feature

Xin Long <lucien.xin@gmail.com>
    ipv6: add exception routes to GC list in rt6_insert_exception

Frédéric Danis <frederic.danis@collabora.com>
    Bluetooth: l2cap: Check encryption key size on incoming connection

Dan Carpenter <dan.carpenter@linaro.org>
    Bluetooth: btrtl: Prevent potential NULL dereference

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix sending MGMT_EV_DEVICE_FOUND for invalid address

Shay Drory <shayd@nvidia.com>
    RDMA/core: Silence oversized kvmalloc() warning

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l43: Reset clamp override on jack removal

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed ASUS platform headset Mic issue

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Workaround for resume on Dell Venue 11 Pro 7130

Jaroslav Kysela <perex@perex.cz>
    ALSA: hda: improve bass speaker support for ASUS Zenbook UM5606WA

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda/cirrus_scodec_test: Don't select dependencies

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix wrong maximum DMA segment size

Yue Haibing <yuehaibing@huawei.com>
    RDMA/usnic: Fix passing zero to PTR_ERR in usnic_ib_pci_probe()

Giuseppe Scrivano <gscrivan@redhat.com>
    ovl: remove unused forward declaration

Akhil R <akhilrajeev@nvidia.com>
    crypto: tegra - Fix IV usage for AES ECB

Akhil R <akhilrajeev@nvidia.com>
    crypto: tegra - Do not use fixed size buffers

Colin Ian King <colin.i.king@gmail.com>
    crypto: tegra - remove redundant error check on ret

Henry Martin <bsdhenrymartin@gmail.com>
    ASoC: Intel: avs: Fix null-ptr-deref in avs_component_probe()

Brady Norander <bradynorander@gmail.com>
    ASoC: dwc: always enable/disable i2s irqs

Zheng Qixing <zhengqixing@huawei.com>
    md/md-bitmap: fix stats collection for external bitmaps

Yu Kuai <yukuai3@huawei.com>
    md/raid10: fix missing discard IO accounting

Martin Wilck <mwilck@suse.com>
    scsi: smartpqi: Use is_kdump_kernel() to check for kdump

Daniel Wagner <wagi@kernel.org>
    scsi: replace blk_mq_pci_map_queues with blk_mq_map_hw_queues

Daniel Wagner <wagi@kernel.org>
    blk-mq: introduce blk_mq_map_hw_queues

Daniel Wagner <wagi@kernel.org>
    driver core: bus: add irq_get_affinity callback to bus_type

Miaoqian Lin <linmq006@gmail.com>
    scsi: iscsi: Fix missing scsi_host_put() in error path

Abdun Nihaal <abdun.nihaal@gmail.com>
    wifi: wl1251: fix memory leak in wl1251_tx_work

Remi Pommarel <repk@triplefau.lt>
    wifi: mac80211: Purge vif txq in ieee80211_do_stop()

Remi Pommarel <repk@triplefau.lt>
    wifi: mac80211: Update skb's control block key in ieee80211_tx_dequeue()

Abdun Nihaal <abdun.nihaal@gmail.com>
    wifi: at76c50x: fix use after free access in at76_disconnect

Xingui Yang <yangxingui@huawei.com>
    scsi: hisi_sas: Enable force phy when SATA disk directly connected


-------------

Diffstat:

 Documentation/arch/arm64/booting.rst               |  22 +++
 .../bindings/soc/fsl/fsl,ls1028a-reset.yaml        |   2 +-
 Documentation/netlink/specs/ovs_vport.yaml         |   4 +-
 Documentation/netlink/specs/rt_link.yaml           |  14 +-
 Documentation/wmi/devices/msi-wmi-platform.rst     |   4 +
 Makefile                                           |   8 +-
 arch/arm64/include/asm/el2_setup.h                 |  25 ++++
 arch/arm64/tools/sysreg                            | 104 ++++++++++++++
 arch/loongarch/kernel/acpi.c                       |  12 --
 arch/mips/dec/prom/init.c                          |   2 +-
 arch/mips/include/asm/ds1287.h                     |   2 +-
 arch/mips/kernel/cevt-ds1287.c                     |   1 +
 arch/riscv/include/asm/kgdb.h                      |   9 +-
 arch/riscv/include/asm/syscall.h                   |   7 +-
 arch/riscv/kernel/kgdb.c                           |   6 +
 arch/riscv/kernel/module-sections.c                |  13 +-
 arch/riscv/kernel/module.c                         |  11 +-
 arch/riscv/kernel/setup.c                          |  36 ++++-
 arch/x86/boot/compressed/mem.c                     |   5 +-
 arch/x86/boot/compressed/sev.c                     |  67 +++------
 arch/x86/boot/compressed/sev.h                     |   2 +
 arch/x86/events/intel/ds.c                         |   8 +-
 arch/x86/events/intel/uncore_snbep.c               | 107 ++-------------
 arch/x86/kernel/cpu/amd.c                          |  19 ++-
 arch/x86/kernel/cpu/microcode/amd.c                |   9 +-
 arch/x86/xen/multicalls.c                          |  26 ++--
 arch/x86/xen/smp_pv.c                              |   1 -
 arch/x86/xen/xen-ops.h                             |   3 -
 block/bdev.c                                       |   3 +-
 block/bio-integrity.c                              |  17 +--
 block/blk-core.c                                   |   6 +-
 block/blk-merge.c                                  |   2 +-
 block/blk-mq-cpumap.c                              |  37 +++++
 block/blk-mq.c                                     |  42 +++---
 block/blk-mq.h                                     |   2 +-
 block/blk-sysfs.c                                  |   2 +
 drivers/ata/libata-sata.c                          |  15 +++
 drivers/block/loop.c                               | 121 +++--------------
 drivers/block/null_blk/main.c                      |   9 +-
 drivers/block/virtio_blk.c                         |  13 +-
 drivers/bluetooth/btrtl.c                          |   2 +
 drivers/bluetooth/hci_vhci.c                       |  10 +-
 drivers/cpufreq/cpufreq.c                          |  40 +++++-
 drivers/crypto/caam/qi.c                           |   6 +-
 drivers/crypto/tegra/tegra-se-aes.c                | 131 +++++++++---------
 drivers/crypto/tegra/tegra-se-hash.c               |  38 ++++--
 drivers/crypto/tegra/tegra-se.h                    |   2 -
 drivers/dma-buf/sw_sync.c                          |  19 ++-
 drivers/firmware/efi/libstub/efistub.h             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |  34 ++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  44 +++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   4 +-
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   4 +
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |  21 +--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  62 ++++++++-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   6 +-
 .../drm/amd/display/dc/dml2/dml21/dml21_wrapper.c  |  17 ++-
 drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c |   9 ++
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    |   6 +-
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  |   7 +-
 .../amd/display/dc/resource/dcn31/dcn31_resource.c |   2 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_thermal.c  |   4 +-
 .../drm/amd/pm/powerplay/hwmgr/vega10_thermal.c    |   4 +-
 .../drm/amd/pm/powerplay/hwmgr/vega20_thermal.c    |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |   3 +
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   2 +-
 drivers/gpu/drm/ast/ast_dp.c                       |   6 +
 drivers/gpu/drm/i915/display/intel_display.c       |   4 +-
 drivers/gpu/drm/i915/gvt/opregion.c                |   7 +-
 drivers/gpu/drm/imagination/pvr_fw.c               |  27 +++-
 drivers/gpu/drm/imagination/pvr_job.c              |   7 +
 drivers/gpu/drm/imagination/pvr_queue.c            |   4 +
 drivers/gpu/drm/mgag200/mgag200_mode.c             |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  82 +++++------
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   8 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   9 +-
 .../gpu/drm/msm/registers/adreno/adreno_pm4.xml    |   7 +
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   3 +
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   3 -
 drivers/gpu/drm/sti/Makefile                       |   2 -
 drivers/gpu/drm/tiny/repaper.c                     |   4 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |  16 ++-
 drivers/gpu/drm/xe/xe_dma_buf.c                    |   5 +-
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c        |  12 +-
 drivers/gpu/drm/xe/xe_guc_ads.c                    |  75 ++++++-----
 drivers/gpu/drm/xe/xe_hmm.c                        |  24 ----
 drivers/gpu/drm/xe/xe_migrate.c                    |   2 +-
 drivers/i2c/busses/i2c-cros-ec-tunnel.c            |   3 +
 drivers/i2c/i2c-atr.c                              |   2 +-
 drivers/infiniband/core/cma.c                      |   4 +-
 drivers/infiniband/core/umem_odp.c                 |   6 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c        |  14 +-
 drivers/md/md-bitmap.c                             |   5 +-
 drivers/md/md.c                                    |  22 +--
 drivers/md/raid10.c                                |   1 +
 drivers/misc/pci_endpoint_test.c                   |   4 +
 drivers/net/can/rockchip/rockchip_canfd-core.c     |   7 +-
 drivers/net/dsa/b53/b53_common.c                   |  10 ++
 drivers/net/dsa/mv88e6xxx/chip.c                   |  13 +-
 drivers/net/dsa/mv88e6xxx/devlink.c                |   3 +-
 drivers/net/ethernet/amd/pds_core/debugfs.c        |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |   1 +
 drivers/net/ethernet/intel/igc/igc.h               |   1 +
 drivers/net/ethernet/intel/igc/igc_defines.h       |   6 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   1 +
 drivers/net/ethernet/intel/igc/igc_ptp.c           | 113 ++++++++++------
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  49 ++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   1 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  15 ++-
 drivers/net/ethernet/ti/icssg/icss_iep.c           | 150 ++++++++++++++-------
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c      |   3 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |   3 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c           |   4 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |   2 +-
 drivers/net/wireless/ti/wl1251/tx.c                |   4 +-
 drivers/nvme/host/apple.c                          |   2 +-
 drivers/nvme/host/pci.c                            |  15 +--
 drivers/nvme/target/fc.c                           |  14 --
 drivers/pci/pci.c                                  |   4 -
 drivers/platform/x86/amd/pmf/auto-mode.c           |   4 +-
 drivers/platform/x86/amd/pmf/cnqf.c                |   8 +-
 drivers/platform/x86/amd/pmf/core.c                |  14 ++
 drivers/platform/x86/amd/pmf/pmf.h                 |   1 +
 drivers/platform/x86/amd/pmf/sps.c                 |  12 +-
 drivers/platform/x86/amd/pmf/tee-if.c              |   6 +-
 drivers/platform/x86/asus-laptop.c                 |   9 +-
 drivers/platform/x86/msi-wmi-platform.c            |  99 +++++++++-----
 drivers/ptp/ptp_ocp.c                              |   1 +
 drivers/ras/amd/atl/internal.h                     |   3 +
 drivers/ras/amd/atl/umc.c                          |  19 ++-
 drivers/ras/amd/fmpm.c                             |   9 +-
 drivers/scsi/fnic/fnic_main.c                      |   3 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |   1 -
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |   9 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  18 ++-
 drivers/scsi/megaraid/megaraid_sas_base.c          |  12 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   5 +-
 drivers/scsi/mpi3mr/mpi3mr.h                       |   1 -
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   3 +-
 drivers/scsi/pm8001/pm8001_init.c                  |   2 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |   1 -
 drivers/scsi/qla2xxx/qla_nvme.c                    |   3 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   4 +-
 drivers/scsi/scsi_transport_iscsi.c                |   7 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |  20 +--
 drivers/ufs/host/ufs-exynos.c                      |   6 +
 fs/Kconfig                                         |   1 +
 fs/btrfs/super.c                                   |   3 +-
 fs/ecryptfs/inode.c                                |  12 +-
 fs/fuse/virtio_fs.c                                |   3 +
 fs/hfs/bnode.c                                     |   6 +
 fs/hfsplus/bnode.c                                 |   6 +
 fs/isofs/export.c                                  |   2 +-
 fs/nfs/Kconfig                                     |   2 +-
 fs/nfs/internal.h                                  |   7 -
 fs/nfs/nfs4session.h                               |   4 -
 fs/nfsd/Kconfig                                    |   1 +
 fs/nfsd/nfs4state.c                                |   2 +-
 fs/nfsd/nfsfh.h                                    |   7 -
 fs/overlayfs/inode.c                               |  10 +-
 fs/overlayfs/overlayfs.h                           |  10 --
 fs/overlayfs/super.c                               |   5 +
 fs/smb/client/cifsproto.h                          |   2 +
 fs/smb/client/connect.c                            |  34 ++---
 fs/smb/client/file.c                               |  28 ++++
 fs/smb/server/oplock.c                             |  29 ++--
 fs/smb/server/oplock.h                             |   1 -
 fs/smb/server/smb2pdu.c                            |   4 +-
 fs/smb/server/transport_ipc.c                      |   7 +-
 fs/smb/server/vfs.c                                |   3 +-
 fs/stat.c                                          |  39 +++---
 include/linux/backing-dev.h                        |   1 +
 include/linux/blk-mq.h                             | 111 +++++++--------
 include/linux/blkdev.h                             |  17 ++-
 include/linux/bpf.h                                |   1 +
 include/linux/bpf_verifier.h                       |   1 +
 include/linux/device/bus.h                         |   3 +
 include/linux/nfs.h                                |   7 -
 include/uapi/linux/fcntl.h                         |   4 -
 io_uring/rw.c                                      |   4 +-
 kernel/bpf/verifier.c                              |  79 +++++++++--
 kernel/sched/cpufreq_schedutil.c                   |  46 ++++++-
 kernel/trace/ftrace.c                              |   7 +-
 kernel/trace/trace_events_filter.c                 |   4 +-
 lib/string.c                                       |  13 +-
 mm/compaction.c                                    |   6 +-
 mm/filemap.c                                       |   1 +
 mm/gup.c                                           |   4 +-
 mm/memory.c                                        |   4 +-
 mm/slub.c                                          |  10 ++
 mm/userfaultfd.c                                   |  13 +-
 mm/vma.c                                           |  38 +++++-
 mm/vma.h                                           |   9 +-
 net/bluetooth/hci_event.c                          |   5 +-
 net/bluetooth/l2cap_core.c                         |  21 ++-
 net/bridge/br_vlan.c                               |   4 +-
 net/dsa/dsa.c                                      |  59 ++++++--
 net/dsa/tag_8021q.c                                |   2 +-
 net/ethtool/cmis_cdb.c                             |   2 +-
 net/ipv6/route.c                                   |   1 +
 net/mac80211/iface.c                               |   3 +
 net/mctp/af_mctp.c                                 |   3 +
 net/openvswitch/flow_netlink.c                     |   3 +-
 net/smc/af_smc.c                                   |   5 +
 scripts/Makefile.compiler                          |   4 +-
 scripts/generate_rust_analyzer.py                  |  12 +-
 sound/pci/hda/Kconfig                              |   4 +-
 sound/pci/hda/patch_realtek.c                      |  55 ++++++--
 sound/soc/codecs/cs42l43-jack.c                    |   3 +
 sound/soc/codecs/lpass-wsa-macro.c                 | 139 +++++++++++++------
 sound/soc/dwc/dwc-i2s.c                            |  13 +-
 sound/soc/fsl/fsl_qmc_audio.c                      |   3 +
 sound/soc/intel/avs/pcm.c                          |   3 +-
 sound/soc/intel/boards/sof_sdw.c                   |   1 +
 sound/soc/qcom/lpass.h                             |   3 +-
 tools/net/ynl/ynl-gen-c.py                         |  69 +++++++---
 tools/objtool/check.c                              |   1 +
 tools/testing/kunit/qemu_configs/sh.py             |   4 +-
 .../selftests/bpf/prog_tests/changes_pkt_data.c    | 107 +++++++++++++++
 .../testing/selftests/bpf/progs/changes_pkt_data.c |  39 ++++++
 .../bpf/progs/changes_pkt_data_freplace.c          |  18 +++
 tools/testing/selftests/bpf/progs/raw_tp_null.c    |  19 ++-
 tools/testing/selftests/bpf/progs/verifier_sock.c  |  56 ++++++++
 .../selftests/mm/charge_reserved_hugetlb.sh        |   4 +-
 .../selftests/mm/hugetlb_reparenting_test.sh       |   2 +-
 tools/testing/shared/linux.c                       |   4 +-
 232 files changed, 2369 insertions(+), 1282 deletions(-)


