Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F72D2D1F64;
	Fri, 21 Nov 2025 16:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763741243; cv=none; b=BIjNpDFHnSbQAvGMa+YjJH5DHWdLp34JeZEKaEpLssA2bYqB7b9aukf8kgQh2+jy53C+KfnsuTdonQgs7a5AWO8E13HfJ9a2USt8kwnC/r9XCJZ2JqMuXRM4hXqpavza03HimVST4K5PhfYbTpcsYspiyPjkPJMrLSCSAEVE07E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763741243; c=relaxed/simple;
	bh=exdW0EHRxcgb7plfM8UveNYNOXkjdMUsw3UX8F00piU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pZvcaaRy5npjjzQzP/AS8wdIlD2Ais8pRnAytTCvc0iJytdeoql5RBqoAjEMcslMCJePtlOKos+GGdslMpTzu7mzHX5RDLJi1XmOLjxMRyswIJFH+1cHCobrwePVUtiTz/Eu2IAAzLBpWETJAPk0BxvnwBxvLBJoGX9K+Ivd3U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kaZ2GcXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaZ2GcXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5281EC4CEF1;
	Fri, 21 Nov 2025 16:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763741243;
	bh=exdW0EHRxcgb7plfM8UveNYNOXkjdMUsw3UX8F00piU=;
	h=From:To:Cc:Subject:Date:From;
	b=kaZ2GcXLf74fdB+yxwI3lgNlb6MPszxHauNkeXFfzatC454Kt4xrbISu7FKDcfOdK
	 f/Q3jr0k9vIU6zLOjGoSsdZ0K2dlRIR5HnQLjK3yFPJbeLU0rD50tX1E44hNcXZYZ5
	 0UdDjEJEvE5wT/3DuBpr+VktsvMnXl7lTMg6njVQ=
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
Subject: [PATCH 6.17 000/244] 6.17.9-rc2 review
Date: Fri, 21 Nov 2025 17:07:19 +0100
Message-ID: <20251121160640.254872094@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.9-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.17.9-rc2
X-KernelTest-Deadline: 2025-11-23T16:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.17.9 release.
There are 244 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 23 Nov 2025 16:05:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.9-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.17.9-rc2

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: phy: micrel: Fix lan8814_config_init

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    isdn: mISDN: hfcsusb: fix memory leak in hfcsusb_probe()

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Inject #UD if guest tries to execute SEAMCALL or TDCALL

Xin Li <xin@zytor.com>
    KVM: x86: Add support for RDMSR/WRMSRNS w/ immediate on Intel

Sean Christopherson <seanjc@google.com>
    KVM: x86: Rename local "ecx" variables to "msr" and "pmc" as appropriate

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    ASoC: da7213: Use component driver suspend/resume

Geert Uytterhoeven <geert+renesas@glider.be>
    ASoC: da7213: Convert to DEFINE_RUNTIME_DEV_PM_OPS()

Carlos Llamas <cmllamas@google.com>
    scripts/decode_stacktrace.sh: fix build ID and PC source parsing

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    scripts/decode_stacktrace.sh: symbol: preserve alignment

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    scripts/decode_stacktrace.sh: symbol: avoid trailing whitespaces

Kiryl Shutsemau <kas@kernel.org>
    mm/memory: do not populate page table entries beyond i_size

Zi Yan <ziy@nvidia.com>
    mm/huge_memory: do not change split_huge_page*() target order silently

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: properly kill background tasks

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: userspace: longer transfer

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: trunc: read all recv data

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: endpoints: longer transfer

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: rm: set backup flag

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: fix fallback note due to OoO

Marek Szyprowski <m.szyprowski@samsung.com>
    pmdomain: samsung: Rework legacy splash-screen handover workaround

André Draszik <andre.draszik@linaro.org>
    pmdomain: samsung: plug potential memleak during probe

Miaoqian Lin <linmq006@gmail.com>
    pmdomain: imx: Fix reference count leak in imx_gpc_remove

Sudeep Holla <sudeep.holla@arm.com>
    pmdomain: arm: scmi: Fix genpd leak on provider registration failure

Nitin Gote <nitin.r.gote@intel.com>
    drm/xe/xe3: Add WA_14024681466 for Xe3_LPG

Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>
    drm/xe/xe3: Extend wa_14023061436

Nitin Gote <nitin.r.gote@intel.com>
    drm/xe/xe3lpg: Extend Wa_15016589081 for xe3lpg

Jani Nikula <jani.nikula@intel.com>
    drm/i915/psr: fix pipe to vblank conversion

Vitaly Prosyak <vitaly.prosyak@amd.com>
    drm/amdgpu: disable peer-to-peer access for DCC-enabled GC12 VRAM surfaces

Jesse.Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: fix lock warning in amdgpu_userq_fence_driver_process

Jonathan Kim <jonathan.kim@amd.com>
    drm/amdkfd: relax checks for over allocation of save area

Zilin Guan <zilin@seu.edu.cn>
    btrfs: release root after error in data_reloc_print_warning_inode()

Filipe Manana <fdmanana@suse.com>
    btrfs: do not update last_log_commit when logging inode due to a new name

Zilin Guan <zilin@seu.edu.cn>
    btrfs: scrub: put bio after errors in scrub_raid56_parity_stripe()

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix stripe width calculation

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix conventional zone capacity calculation

Mario Limonciello (AMD) <superm1@kernel.org>
    PM: hibernate: Use atomic64_t for compressed_size variable

Mario Limonciello (AMD) <superm1@kernel.org>
    PM: hibernate: Emit an error when image writing fails

Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
    EDAC/altera: Use INTTEST register for Ethernet and USB SBE injection

Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
    EDAC/altera: Handle OCRAM ECC enable after warm reset

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Use physical addresses for CSR_MERRENTRY/CSR_TLBRENTRY

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Consolidate max_pfn & max_low_pfn calculation

Song Liu <song@kernel.org>
    ftrace: Fix BPF fexit with livepatch

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: ensure allocated iovec gets cleared for early failure

Sami Tolvanen <samitolvanen@google.com>
    gendwarfksyms: Skip files with no exports

Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
    selftests/user_events: fix type cast for write_index packed member in perf_test

Mario Limonciello <mario.limonciello@amd.com>
    x86/CPU/AMD: Add additional fixed RDSEED microcode revisions

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Add Zen5 model 0x44, stepping 0x1 minrev

Hans de Goede <hansg@kernel.org>
    spi: Try to get ACPI GPIO IRQ earlier

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix cifs_pick_channel when channel needs reconnect

Miaoqian Lin <linmq006@gmail.com>
    crypto: hisilicon/qm - Fix device reference leak in qm_get_qos_value

Sourabh Jain <sourabhjain@linux.ibm.com>
    crash: fix crashkernel resource shrink

Hao Ge <gehao@kylinos.cn>
    codetag: debug: handle existing CODETAG_EMPTY in mark_objexts_empty for slabobj_ext

Edward Adam Davis <eadavis@qq.com>
    cifs: client: fix memory leak in smb3_fs_context_parse_param

Miaoqian Lin <linmq006@gmail.com>
    ASoC: sdw_utils: fix device reference leak in is_sdca_endpoint_present()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix potential overflow of PCM transfer buffer

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Fix breakage at probing nvhdmi-mcp driver

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: dw_mmc-rockchip: Fix wrong internal phase calculate

Rakuram Eswaran <rakuram.e96@gmail.com>
    mmc: pxamci: Simplify pxamci_probe() error handling using devm APIs

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: sdhci-of-dwcmshc: Change DLL_STRBIN_TAPNUM_DEFAULT to 0x4

Zi Yan <ziy@nvidia.com>
    mm/huge_memory: fix folio split check for anon folios in swapcache

Kairui Song <kasong@tencent.com>
    mm, swap: fix potential UAF issue for VMA readahead

Dev Jain <dev.jain@arm.com>
    mm/mremap: honour writable bit in mremap pte batching

Kairui Song <kasong@tencent.com>
    mm/shmem: fix THP allocation and fallback loop

Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
    mm/kmsan: fix kmsan kmalloc hook when no stack depots are allocated yet

Quanmin Yan <yanquanmin1@huawei.com>
    mm/damon/stat: change last_refresh_jiffies to a global variable

Isaac J. Manjarres <isaacmanjarres@google.com>
    mm/mm_init: fix hash table order logging in alloc_large_system_hash()

Wei Yang <albinwyang@tencent.com>
    fs/proc: fix uaf in proc_readdir_de()

Zi Yan <ziy@nvidia.com>
    mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: reject address change while connecting

Steven Rostedt <rostedt@goodmis.org>
    selftests/tracing: Run sample events to clear page cache events

Lance Yang <lance.yang@linux.dev>
    mm/secretmem: fix use-after-free race in fault handler

Breno Leitao <leitao@debian.org>
    net: netpoll: fix incorrect refcount handling causing incorrect cleanup

Edward Adam Davis <eadavis@qq.com>
    nilfs2: avoid having an active sc_timer before freeing sci

Quanmin Yan <yanquanmin1@huawei.com>
    mm/damon/sysfs: change next_update_jiffies to a global variable

Chuang Wang <nashuiliang@gmail.com>
    ipv4: route: Prevent rt_bind_exception() from rebinding stale fnhe

Tianyang Zhang <zhangtianyang@loongson.cn>
    LoongArch: Let {pte,pmd}_modify() record the status of _PAGE_DIRTY

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Use correct accessor to read FWPC/MWPC

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Consolidate early_ioremap()/ioremap_prot()

Martin Kaiser <martin@kaiser.cx>
    maple_tree: fix tracepoint string pointers

Qinxin Xia <xiaqinxin@huawei.com>
    dma-mapping: benchmark: Restore padding to ensure uABI remained consistent

Nate Karstens <nate.karstens@garmin.com>
    strparser: Fix signed/unsigned mismatch bug

Pratyush Yadav <pratyush@kernel.org>
    kho: warn and exit when unpreserved page wasn't preserved

Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
    ksm: use range-walk function to jump over holes in scan_get_next_rmap_item

Joshua Rogers <linux@joshua.hu>
    ksmbd: close accepted socket when per-IP limit rejects connection

Peter Oberparleiter <oberpar@linux.ibm.com>
    gcov: add support for GCC 15

Olga Kornievskaia <okorniev@redhat.com>
    NFSD: free copynotify stateid in nfs4_free_ol_stateid()

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: add missing FATTR4_WORD2_CLONE_BLKSIZE from supported attributes

NeilBrown <neil@brown.name>
    nfsd: fix refcount leak in nfsd_set_fh_dentry()

Sukrit Bhatnagar <Sukrit.Bhatnagar@sony.com>
    KVM: VMX: Fix check for valid GVA on an EPT violation

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: nSVM: Fix and simplify LBR virtualization handling with nested

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: nSVM: Always recalculate LBR MSR intercepts in svm_update_lbrv()

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: SVM: Mark VMCB_LBR dirty when MSR_IA32_DEBUGCTLMSR is updated

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Make all 32bit ID registers fully writable

Sean Christopherson <seanjc@google.com>
    KVM: guest_memfd: Remove bindings on memslot deletion when gmem is dying

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Fix max supported vCPUs set with EIOINTC

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Add delay until timer interrupt injected

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Restore guest PMU if it is enabled

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    HID: uclogic: Fix potential memory leak in error path

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    HID: playstation: Fix memory leak in dualshock4_get_calibration_data()

Luke Wang <ziniu.wang_1@nxp.com>
    pwm: adp5585: Correct mismatched pwm chip info

Chukun Pan <amadeus@jmu.edu.cn>
    arm64: dts: rockchip: drop reset from rk3576 i2c9 node

Andrey Leonchikov <andreil499@gmail.com>
    arm64: dts: rockchip: Fix USB power enable pin for BTT CB2 and Pi2

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM53573: Fix address of Luxul XAP-1440's Ethernet PHY

Masami Ichikawa <masami256@gmail.com>
    HID: hid-ntrig: Prevent memory leak in ntrig_report_version()

Frieder Schrempf <frieder.schrempf@kontron.de>
    arm64: dts: imx8mp-kontron: Fix USB OTG role switching

João Paulo Gonçalves <joao.goncalves@toradex.com>
    arm64: dts: imx8-ss-img: Avoid gpio0_mipi_csi GPIOs being deferred

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: imx51-zii-rdu1: Fix audmux node names

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    ARM: dts: imx6ull-engicam-microgea-rmm: fix report-rate-hz value

Dragan Simic <dsimic@manjaro.org>
    arm64: dts: rockchip: Make RK3588 GPU OPP table naming less generic

Andrey Leonchikov <andreil499@gmail.com>
    arm64: dts: rockchip: Fix PCIe power enable pin for BigTreeTech CB2 and Pi2

Anand Moon <linux.amoon@gmail.com>
    arm64: dts: rockchip: Set correct pinctrl for I2S1 8ch TX on odroid-m1

Ravi Bangoria <ravi.bangoria@amd.com>
    perf test: Fix lock contention test

Ian Rogers <irogers@google.com>
    perf test shell lock_contention: Extra debug diagnostics

Ravi Bangoria <ravi.bangoria@amd.com>
    perf lock: Fix segfault due to missing kernel map

Arnaldo Carvalho de Melo <acme@kernel.org>
    perf build: Don't fail fast path feature detection when binutils-devel is not available

Thomas Falcon <thomas.falcon@intel.com>
    perf header: Write bpf_prog (infos|btfs)_cnt to data file

Zqiang <qiang.zhang@linux.dev>
    sched_ext: Fix unsafe locking in the scx_dump_state()

Andrei Vagin <avagin@google.com>
    fs/namespace: correctly handle errors returned by grab_requested_mnt_ns

Zilin Guan <zilin@seu.edu.cn>
    binfmt_misc: restore write access before closing files opened by open_exec()

Alok Tiwari <alok.a.tiwari@oracle.com>
    virtio-fs: fix incorrect check for fsvq->kobj

Dan Carpenter <dan.carpenter@linaro.org>
    mtd: onenand: Pass correct pointer to IRQ handler

David Howells <dhowells@redhat.com>
    afs: Fix dynamic lookup to fail on cell lookup failure

Hongbo Li <lihongbo22@huawei.com>
    hostfs: Fix only passing host root in boot stage with new mount

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN

Eslam Khafagy <eslam.medhat1993@gmail.com>
    posix-timers: Plug potential memory leak in do_timer_create()

Nick Hu <nick.hu@sifive.com>
    irqchip/riscv-intc: Add missing free() callback in riscv_intc_domain_ops

Eduard Zingerman <eddyz87@gmail.com>
    bpf: account for current allocated stack depth in widen_imprecise_scalars()

Eric Dumazet <edumazet@google.com>
    bpf: Add bpf_prog_run_data_pointers()

Randy Dunlap <rdunlap@infradead.org>
    drm/client: fix MODULE_PARM_DESC string for "active"

Haotian Zhang <vulab@iscas.ac.cn>
    ASoC: rsnd: fix OF node reference leak in rsnd_ssiu_probe()

Dave Jiang <dave.jiang@intel.com>
    acpi/hmat: Fix lockdep warning for hmem_register_resource()

Sultan Alsawaf <sultan@kerneltoast.com>
    drm/amd/amdgpu: Ensure isp_kernel_buffer_alloc() creates a new BO

Haein Lee <lhi0729@kaist.ac.kr>
    ALSA: usb-audio: Fix NULL pointer dereference in snd_usb_mixer_controls_badd

Dai Ngo <dai.ngo@oracle.com>
    NFS: Fix LTP test failures when timestamps are delegated

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix an incorrect parameter when calling nfs4_call_sync()

Yang Xiuwei <yangxiuwei@kylinos.cn>
    NFS: sysfs: fix leak when nfs_client kobject add fails

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv2/v3: Fix error handling in nfs_atomic_open_v23()

Al Viro <viro@zeniv.linux.org.uk>
    simplify nfs_atomic_open_v23()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Check the TLS certificate fields in nfs_match_client()

Trond Myklebust <trond.myklebust@hammerspace.com>
    pnfs: Set transport security policy to RPC_XPRTSEC_NONE unless using TLS

Trond Myklebust <trond.myklebust@hammerspace.com>
    pnfs: Fix TLS logic in _nfs4_pnfs_v4_ds_connect()

Trond Myklebust <trond.myklebust@hammerspace.com>
    pnfs: Fix TLS logic in _nfs4_pnfs_v3_ds_connect()

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Flush shmem writes before mapping buffers CPU-uncached

Shenghao Ding <shenghao-ding@ti.com>
    ASoC: tas2781: fix getting the wrong device number

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Restore Guest-Backed only cursor plane support

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Validate command header size against SVGA_CMD_MAX_DATASIZE

Haotian Zhang <vulab@iscas.ac.cn>
    ASoC: codecs: va-macro: fix resource leak in probe error path

Haotian Zhang <vulab@iscas.ac.cn>
    ASoC: cs4271: Fix regulator leak on probe failure

Haotian Zhang <vulab@iscas.ac.cn>
    regulator: fixed: fix GPIO descriptor leak on register failure

Shuai Xue <xueshuai@linux.alibaba.com>
    acpi,srat: Fix incorrect device handle check for Generic Initiator

Caleb Sander Mateos <csander@purestorage.com>
    io_uring/rsrc: don't use blk_rq_nr_phys_segments() as number of bvecs

Andrii Melnychenko <a.melnychenko@vyos.io>
    netfilter: nft_ct: add seqadj extension for natted connections

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: export l2cap_chan_hold for modules

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    cpufreq: intel_pstate: Check IDA only before MSR_IA32_PERF_CTL writes

Gautham R. Shenoy <gautham.shenoy@amd.com>
    ACPI: CPPC: Limit perf ctrs in PCC check only to online CPUs

Gautham R. Shenoy <gautham.shenoy@amd.com>
    ACPI: CPPC: Perform fast check switch only for online CPUs

Gautham R. Shenoy <gautham.shenoy@amd.com>
    ACPI: CPPC: Check _CPC validity for only the online CPUs

Gautham R. Shenoy <gautham.shenoy@amd.com>
    ACPI: CPPC: Detect preferred core availability on online CPUs

Felix Maurer <fmaurer@redhat.com>
    hsr: Follow standard for HSRv0 supervision frames

Felix Maurer <fmaurer@redhat.com>
    hsr: Fix supervision frame sending on HSRv0

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    virtio-net: fix incorrect flags recording in big mode

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mld: always take beacon ies in link grading

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: fix beacon template/fixed rate

Eric Dumazet <edumazet@google.com>
    net_sched: limit try_bulk_dequeue_skb() batches

Akiva Goldberger <agoldberger@nvidia.com>
    mlx5: Fix default values in create CQ

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Prepare for using different CQ doorbells

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: Store the global doorbell in mlx5_priv

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: Fix typo of MLX5_EQ_DOORBEL_OFFSET

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix potentially misleading debug message

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix wraparound in rate limiting for values above 255 Gbps

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix maxrate wraparound in threshold between units

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Fix missing error assignment in mlx5e_xfrm_add_state()

Ranganath V N <vnranganath.20@gmail.com>
    net: sched: act_ife: initialize struct tc_ife to fix KMSAN kernel-infoleak

Ranganath V N <vnranganath.20@gmail.com>
    net: sched: act_connmark: initialize struct tc_ife to fix kernel leak

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix not handling PA Sync Lost event

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Initialise scc_index in unix_add_edge().

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211: skip rate verification for not captured PSDUs

Buday Csaba <buday.csaba@prolan.hu>
    net: mdio: fix resource leak in mdiobus_register_device()

Kuniyuki Iwashima <kuniyu@google.com>
    tipc: Fix use-after-free in tipc_mon_reinit_self().

Aksh Garg <a-garg7@ti.com>
    net: ethernet: ti: am65-cpsw-qos: fix IET verify retry mechanism

Aksh Garg <a-garg7@ti.com>
    net: ethernet: ti: am65-cpsw-qos: fix IET verify/response timeout

Zilin Guan <zilin@seu.edu.cn>
    net/handshake: Fix memory leak in tls_handshake_accept()

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix mismatch between CLC header and proposal

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: tag_brcm: do not mark link local traffic as offloaded

Eric Dumazet <edumazet@google.com>
    sctp: prevent possible shift-out-of-bounds in sctp_transport_update_rto

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Fix not cleaning up PA_LINK connections

Pauli Virtanen <pav@iki.fi>
    Bluetooth: 6lowpan: Don't hold spin lock over sleeping functions

Pauli Virtanen <pav@iki.fi>
    Bluetooth: 6lowpan: fix BDADDR_LE vs ADDR_LE_DEV address type confusion

Pauli Virtanen <pav@iki.fi>
    Bluetooth: 6lowpan: reset link-local header on ipv6 recv path

Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
    Bluetooth: btusb: reorder cleanup in btusb_disconnect to avoid UAF

Pauli Virtanen <pav@iki.fi>
    Bluetooth: MGMT: cancel mesh send timer when hdev removed

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Skip close replay processing if XDR encoding fails

Xi Ruoyao <xry111@xry111.site>
    rust: Add -fno-isolate-erroneous-paths-dereference to bindgen_skip_c_flags

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: phy: micrel: lan8814 fix reset of the QSGMII interface

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: phy: micrel: Replace hardcoded pages with defines

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: phy: micrel: Introduce lanphy_modify_page_reg

Wei Fang <wei.fang@nxp.com>
    net: fec: correct rx_bytes statistic for the case SHIFT16 is set

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    selftests: net: local_termination: Wait for interfaces to come up

Gao Xiang <xiang@kernel.org>
    erofs: avoid infinite loop due to incomplete zstd-compressed data

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath11k: zero init info->status in wmi_process_mgmt_tx_comp()

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbe: handle IXGBE_VF_FEATURES_NEGOTIATE mbox cmd

Dawn Gardner <dawn.auroali@gmail.com>
    ALSA: hda/realtek: Fix mute led for HP Omen 17-cb0xxx

Sharique Mohammad <sharq0406@gmail.com>
    ASoC: max98090/91: fixed max98091 ALSA widget powering up/down

Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
    HID: logitech-hidpp: Add HIDPP_QUIRK_RESET_HI_RES_SCROLL

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix possible refcount leak in smb2_sess_setup()

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix possible memory leak in smb2_read()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix unexpected placement on same size resizing

Jaehun Gou <p22gone@gmail.com>
    exfat: fix improper check of dentry.stream.valid_size

Oleg Makarenko <oleg@makarenk.ooo>
    HID: quirks: Add ALWAYS_POLL quirk for VRS R295 steering wheel

Scott Mayhew <smayhew@redhat.com>
    NFS: check if suid/sgid was cleared after a write as needed

Vicki Pfau <vi@endrift.com>
    HID: nintendo: Wait longer for initial probe

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbe: handle IXGBE_VF_GET_PF_LINK_STATE mailbox operation

Tristan Lobb <tristan.lobb@it-lobb.de>
    HID: quirks: avoid Cooler Master MM712 dongle wakeup bug

Abhishek Tamboli <abhishektamboli9@gmail.com>
    HID: intel-thc-hid: intel-quickspi: Add ARL PCI Device Id's

Joshua Watt <jpewhacker@gmail.com>
    NFS4: Apply delay_retrans to async operations

Jonathan Kim <jonathan.kim@amd.com>
    drm/amdkfd: fix suspend/resume all calls in mes based eviction path

Joshua Watt <jpewhacker@gmail.com>
    NFS4: Fix state renewals missing after boot

Jesse.Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: Fix NULL pointer dereference in VRAM logic for APU devices

Christian König <christian.koenig@amd.com>
    drm/amdgpu: hide VRAM sysfs attributes on GPUs without VRAM

Christian König <christian.koenig@amd.com>
    drm/amdgpu: remove two invalid BUG_ON()s

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Avoid unnecessary blocking in IRQ handler

Andrey Albershteyn <aalbersh@redhat.com>
    fs: return EOPNOTSUPP from file_setattr/file_getattr syscalls

Han Gao <rabenda.cn@gmail.com>
    riscv: acpi: avoid errors caused by probing DT devices when ACPI is used

Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>
    RISC-V: clear hot-unplugged cores from all task mm_cpumasks to avoid rfence errors

Feng Jiang <jiangfeng@kylinos.cn>
    riscv: Build loader.bin exclusively for Canaan K210

Peter Zijlstra <peterz@infradead.org>
    compiler_types: Move unused static inline functions warning to W=2

Yang Shi <yang@os.amperecomputing.com>
    arm64: kprobes: check the return value of set_memory_rox()

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd: Disable ASPM on SI

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Disable MCLK switching on SI at high pixel clocks

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Disable fastboot on DCE 6 too

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Use pm_display_cfg in legacy DPM (v2)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Add pixel_clock to amd_pp_display_configuration

Jouni Högander <jouni.hogander@intel.com>
    drm/xe: Do clean shutdown also when using flr

Tejas Upadhyay <tejas.upadhyay@intel.com>
    drm/xe: Move declarations under conditional branch

Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
    drm/xe/guc: Synchronize Dead CT worker with unbind

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Fix suspend failure with secure display TA

Peter Zijlstra <peterz@infradead.org>
    futex: Optimize per-cpu reference counting

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Make vfio_compat's unmap succeed if the range is already empty

Shuhao Fu <sfual@cse.ust.hk>
    smb: client: fix refcount leak in smb2_set_path_attr

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd/display: Don't stretch non-native images by default in eDP

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: set default gfx reset masks for gfx6-8

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    drm/i915: Fix conversion between clock ticks and nanoseconds

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915: Avoid lock inversion when pinning to GGTT on CHV/BXT+VTD

Jason-JH Lin <jason-jh.lin@mediatek.com>
    drm/mediatek: Add pm_runtime support for GCE power control

Nicolin Chen <nicolinc@nvidia.com>
    iommufd/selftest: Fix ioctl return value in _test_cmd_trigger_vevents()


-------------

Diffstat:

 Makefile                                           |   4 +-
 .../boot/dts/broadcom/bcm47189-luxul-xap-1440.dts  |   4 +-
 arch/arm/boot/dts/nxp/imx/imx51-zii-rdu1.dts       |   4 +-
 .../dts/nxp/imx/imx6ull-engicam-microgea-rmm.dts   |   2 +-
 arch/arm/crypto/Kconfig                            |   2 +-
 arch/arm64/boot/dts/freescale/imx8-ss-img.dtsi     |   2 -
 .../boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts |  24 +-
 .../boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi  |   6 +-
 arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts  |   2 +
 arch/arm64/boot/dts/rockchip/rk3576.dtsi           |   2 -
 arch/arm64/boot/dts/rockchip/rk3588-opp.dtsi       |   2 +-
 arch/arm64/boot/dts/rockchip/rk3588j.dtsi          |   2 +-
 arch/arm64/kernel/probes/kprobes.c                 |   5 +-
 arch/arm64/kvm/sys_regs.c                          |  59 +--
 arch/loongarch/include/asm/hw_breakpoint.h         |   4 +-
 arch/loongarch/include/asm/io.h                    |   5 +-
 arch/loongarch/include/asm/pgtable.h               |  11 +-
 arch/loongarch/kernel/mem.c                        |   7 +-
 arch/loongarch/kernel/numa.c                       |  23 +-
 arch/loongarch/kernel/setup.c                      |   5 +-
 arch/loongarch/kernel/traps.c                      |   4 +-
 arch/loongarch/kvm/intc/eiointc.c                  |   2 +-
 arch/loongarch/kvm/timer.c                         |   2 +
 arch/loongarch/kvm/vcpu.c                          |   5 +
 arch/loongarch/mm/init.c                           |   2 -
 arch/loongarch/mm/ioremap.c                        |   2 +-
 arch/riscv/Makefile                                |   2 +-
 arch/riscv/kernel/cpu-hotplug.c                    |   1 +
 arch/riscv/kernel/setup.c                          |   7 +-
 arch/x86/include/asm/kvm_host.h                    |   3 +
 arch/x86/include/uapi/asm/vmx.h                    |   7 +-
 arch/x86/kernel/acpi/cppc.c                        |   2 +-
 arch/x86/kernel/cpu/amd.c                          |   7 +
 arch/x86/kernel/cpu/microcode/amd.c                |   1 +
 arch/x86/kvm/svm/nested.c                          |  20 +-
 arch/x86/kvm/svm/svm.c                             |  73 ++-
 arch/x86/kvm/vmx/common.h                          |   2 +-
 arch/x86/kvm/vmx/nested.c                          |  21 +-
 arch/x86/kvm/vmx/vmx.c                             |  29 ++
 arch/x86/kvm/vmx/vmx.h                             |   5 +
 arch/x86/kvm/x86.c                                 |  75 ++-
 drivers/acpi/cppc_acpi.c                           |   6 +-
 drivers/acpi/numa/hmat.c                           |  46 +-
 drivers/acpi/numa/srat.c                           |   2 +-
 drivers/bluetooth/btusb.c                          |  13 +-
 drivers/cpufreq/intel_pstate.c                     |   9 +-
 drivers/crypto/hisilicon/qm.c                      |   2 +
 drivers/edac/altera_edac.c                         |  22 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |  12 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_isp.c            |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c    |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |   3 +
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   2 -
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |   2 -
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c              |   5 +
 drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c              |   5 +
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c              |   5 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  73 +--
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |  12 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c   |   1 +
 .../amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c |   2 +-
 drivers/gpu/drm/amd/display/dc/dm_services_types.h |   2 +-
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |   6 +-
 drivers/gpu/drm/amd/include/dm_pp_interface.h      |   1 +
 drivers/gpu/drm/amd/pm/amdgpu_dpm_internal.c       |  67 +++
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm_internal.h   |   2 +
 drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c         |   4 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/legacy_dpm.c     |   6 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |  70 ++-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |  11 +-
 drivers/gpu/drm/clients/drm_client_setup.c         |   4 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |   3 +-
 drivers/gpu/drm/i915/gt/intel_gt_clock_utils.c     |   4 +-
 drivers/gpu/drm/i915/i915_vma.c                    |  16 +-
 drivers/gpu/drm/mediatek/mtk_crtc.c                |   7 +
 drivers/gpu/drm/panthor/panthor_gem.c              |  18 +
 drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.c       |  16 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.h       |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   5 +
 drivers/gpu/drm/xe/regs/xe_gt_regs.h               |   1 +
 drivers/gpu/drm/xe/xe_device.c                     |  14 +-
 drivers/gpu/drm/xe/xe_guc_ct.c                     |   3 +
 drivers/gpu/drm/xe/xe_wa.c                         |  11 +
 drivers/hid/hid-ids.h                              |   4 +
 drivers/hid/hid-logitech-hidpp.c                   |  21 +
 drivers/hid/hid-nintendo.c                         |   2 +-
 drivers/hid/hid-ntrig.c                            |   7 +-
 drivers/hid/hid-playstation.c                      |   2 +
 drivers/hid/hid-quirks.c                           |   2 +
 drivers/hid/hid-uclogic-params.c                   |   4 +-
 .../intel-thc-hid/intel-quickspi/pci-quickspi.c    |   6 +
 .../intel-thc-hid/intel-quickspi/quickspi-dev.h    |   2 +
 drivers/infiniband/hw/mlx5/cq.c                    |  15 +-
 drivers/iommu/iommufd/io_pagetable.c               |  12 +-
 drivers/iommu/iommufd/ioas.c                       |   4 +
 drivers/irqchip/irq-riscv-intc.c                   |   3 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |  18 +-
 drivers/mmc/host/dw_mmc-rockchip.c                 |   4 +-
 drivers/mmc/host/pxamci.c                          |  56 +--
 drivers/mmc/host/sdhci-of-dwcmshc.c                |   2 +-
 drivers/mtd/nand/onenand/onenand_samsung.c         |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |   2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h       |  15 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |  79 ++++
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |  24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   5 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  33 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   8 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c  |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  11 +-
 .../mellanox/mlx5/core/steering/hws/send.c         |  15 +-
 .../mellanox/mlx5/core/steering/sws/dr_send.c      |  29 +-
 drivers/net/ethernet/mellanox/mlx5/core/wc.c       |   4 +-
 drivers/net/ethernet/ti/am65-cpsw-qos.c            |  53 ++-
 drivers/net/phy/mdio_bus.c                         |   5 +-
 drivers/net/phy/micrel.c                           | 515 +++++++++++++--------
 drivers/net/virtio_net.c                           |  16 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   3 +
 drivers/net/wireless/intel/iwlwifi/mld/link.c      |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  12 +-
 drivers/pmdomain/arm/scmi_pm_domain.c              |  13 +-
 drivers/pmdomain/imx/gpc.c                         |   2 +
 drivers/pmdomain/samsung/exynos-pm-domains.c       |  29 +-
 drivers/pwm/pwm-adp5585.c                          |   4 +-
 drivers/regulator/fixed.c                          |   1 +
 drivers/spi/spi.c                                  |  10 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   6 +-
 fs/afs/cell.c                                      |  78 +++-
 fs/afs/dynroot.c                                   |   3 +-
 fs/afs/internal.h                                  |  12 +-
 fs/afs/mntpt.c                                     |   3 +-
 fs/afs/proc.c                                      |   3 +-
 fs/afs/super.c                                     |   2 +-
 fs/afs/vl_alias.c                                  |   3 +-
 fs/binfmt_misc.c                                   |   4 +-
 fs/btrfs/inode.c                                   |   4 +-
 fs/btrfs/scrub.c                                   |   2 +
 fs/btrfs/tree-log.c                                |   2 +-
 fs/btrfs/zoned.c                                   |  60 ++-
 fs/erofs/decompressor_zstd.c                       |  11 +-
 fs/exfat/namei.c                                   |   6 +-
 fs/file_attr.c                                     |   4 +
 fs/fuse/virtio_fs.c                                |   2 +-
 fs/hostfs/hostfs_kern.c                            |  29 +-
 fs/namespace.c                                     |  32 +-
 fs/nfs/client.c                                    |   8 +
 fs/nfs/dir.c                                       |  23 +-
 fs/nfs/inode.c                                     |  18 +-
 fs/nfs/nfs3client.c                                |  14 +-
 fs/nfs/nfs4client.c                                |  15 +-
 fs/nfs/nfs4proc.c                                  |  22 +-
 fs/nfs/pnfs_nfs.c                                  |  66 +--
 fs/nfs/sysfs.c                                     |   1 +
 fs/nfs/write.c                                     |   3 +-
 fs/nfsd/nfs4state.c                                |   3 +-
 fs/nfsd/nfs4xdr.c                                  |   3 +-
 fs/nfsd/nfsd.h                                     |   1 +
 fs/nfsd/nfsfh.c                                    |   6 +-
 fs/nilfs2/segment.c                                |   7 +-
 fs/proc/generic.c                                  |  12 +-
 fs/smb/client/fs_context.c                         |   2 +
 fs/smb/client/smb2inode.c                          |   2 +
 fs/smb/client/transport.c                          |   2 +-
 fs/smb/server/smb2pdu.c                            |   2 +
 fs/smb/server/transport_tcp.c                      |   5 +-
 include/linux/compiler_types.h                     |   5 +-
 include/linux/filter.h                             |  20 +
 include/linux/huge_mm.h                            |  55 +--
 include/linux/map_benchmark.h                      |   1 +
 include/linux/mlx5/cq.h                            |   2 +-
 include/linux/mlx5/driver.h                        |   3 +-
 include/linux/nfs_xdr.h                            |   1 +
 include/net/bluetooth/hci.h                        |   5 +
 include/uapi/linux/mount.h                         |   2 +-
 io_uring/register.c                                |   7 -
 io_uring/rsrc.c                                    |  16 +-
 io_uring/rw.c                                      |   3 +
 kernel/bpf/trampoline.c                            |   5 -
 kernel/bpf/verifier.c                              |   6 +-
 kernel/crash_core.c                                |   2 +-
 kernel/futex/core.c                                |  12 +-
 kernel/gcov/gcc_4_7.c                              |   4 +-
 kernel/kexec_handover.c                            |   8 +-
 kernel/power/swap.c                                |  17 +-
 kernel/sched/ext.c                                 |   4 +-
 kernel/time/posix-timers.c                         |  12 +-
 kernel/trace/ftrace.c                              |  20 +-
 lib/maple_tree.c                                   |  30 +-
 mm/damon/stat.c                                    |   9 +-
 mm/damon/sysfs.c                                   |  10 +-
 mm/filemap.c                                       |  20 +-
 mm/huge_memory.c                                   |  38 +-
 mm/kmsan/core.c                                    |   3 -
 mm/kmsan/hooks.c                                   |   6 +-
 mm/kmsan/shadow.c                                  |   2 +-
 mm/ksm.c                                           | 113 ++++-
 mm/memory.c                                        |  20 +-
 mm/mm_init.c                                       |   2 +-
 mm/mremap.c                                        |   2 +-
 mm/secretmem.c                                     |   2 +-
 mm/shmem.c                                         |   9 +-
 mm/slub.c                                          |   6 +-
 mm/swap_state.c                                    |  13 +
 mm/truncate.c                                      |   6 +-
 net/bluetooth/6lowpan.c                            | 103 +++--
 net/bluetooth/hci_conn.c                           |  33 +-
 net/bluetooth/hci_event.c                          |  56 ++-
 net/bluetooth/hci_sync.c                           |   2 +-
 net/bluetooth/l2cap_core.c                         |   1 +
 net/bluetooth/mgmt.c                               |   1 +
 net/core/netpoll.c                                 |   7 +-
 net/dsa/tag_brcm.c                                 |   6 +-
 net/handshake/tlshd.c                              |   1 +
 net/hsr/hsr_device.c                               |   5 +-
 net/hsr/hsr_forward.c                              |  22 +-
 net/ipv4/route.c                                   |   5 +
 net/mac80211/iface.c                               |  14 +-
 net/mac80211/rx.c                                  |  10 +-
 net/netfilter/nft_ct.c                             |   5 +
 net/sched/act_bpf.c                                |   6 +-
 net/sched/act_connmark.c                           |  12 +-
 net/sched/act_ife.c                                |  12 +-
 net/sched/cls_bpf.c                                |   6 +-
 net/sched/sch_generic.c                            |  17 +-
 net/sctp/transport.c                               |  13 +-
 net/smc/smc_clc.c                                  |   1 +
 net/strparser/strparser.c                          |   2 +-
 net/tipc/net.c                                     |   2 +
 net/unix/garbage.c                                 |  14 +-
 rust/Makefile                                      |   2 +-
 scripts/decode_stacktrace.sh                       |  43 +-
 scripts/gendwarfksyms/gendwarfksyms.c              |   3 +-
 scripts/gendwarfksyms/gendwarfksyms.h              |   2 +-
 scripts/gendwarfksyms/symbols.c                    |   4 +-
 sound/hda/codecs/hdmi/nvhdmi-mcp.c                 |   4 +-
 sound/hda/codecs/realtek/alc269.c                  |   1 +
 sound/soc/codecs/cs4271.c                          |  10 +-
 sound/soc/codecs/da7213.c                          |  65 ++-
 sound/soc/codecs/da7213.h                          |   1 +
 sound/soc/codecs/lpass-va-macro.c                  |   2 +-
 sound/soc/codecs/max98090.c                        |   6 +-
 sound/soc/codecs/nau8821.c                         |  22 +-
 sound/soc/codecs/nau8821.h                         |   2 +-
 sound/soc/codecs/tas2781-i2c.c                     |   9 +-
 sound/soc/renesas/rcar/ssiu.c                      |   3 +-
 sound/soc/sdw_utils/soc_sdw_utils.c                |  20 +-
 sound/usb/endpoint.c                               |   5 +
 sound/usb/mixer.c                                  |   2 +
 tools/build/feature/Makefile                       |   4 +-
 tools/perf/Makefile.config                         |   5 +-
 tools/perf/builtin-lock.c                          |   2 +
 tools/perf/tests/shell/lock_contention.sh          |  21 +-
 tools/perf/util/header.c                           |  10 +-
 .../ftrace/test.d/filter/event-filter-function.tc  |   4 +
 tools/testing/selftests/iommu/iommufd.c            |   2 +
 tools/testing/selftests/iommu/iommufd_utils.h      |   4 +-
 .../selftests/net/forwarding/local_termination.sh  |   2 +
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |  18 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  90 ++--
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     |  21 +
 tools/testing/selftests/user_events/perf_test.c    |   2 +-
 virt/kvm/guest_memfd.c                             |  47 +-
 277 files changed, 2501 insertions(+), 1388 deletions(-)


