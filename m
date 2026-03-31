Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1294029DB8F;
	Tue, 31 Mar 2026 16:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976272; cv=none; b=DJ7HBfmtgU8lu+VfjRTiBR/lZ8x2Poc9e18puv7NcdRRvlDAr6nXM/ln/SNqVXuXmrpSitSpfIPieNcgCQWYBAtcCZrvL2vnC341tDvfgbG46f0Po/QodAfqDqCpA/NGBP6Q2X6ann9UYVjtHReXkRIkwVLeTap/+imJvQBQVAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976272; c=relaxed/simple;
	bh=oTiPNirPJq/rMgBTdjP2ESLyQUY8IRqTWDUNkyLVz9E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WLcjv5+o3oMkOL/qJ2j13HGf1cbBWImVK0t5308uW+4ZCoIccJ9jgayn0Nw+4iz81avp9ybyDLZmy/Sdn4NVj8YBr3YEnJMqMHjrMYm58guI8i8ZYCnOUmfrzGJ2+U86/zqtlQOTxHD3H8Nant01T7/dz4r3plMkop/SE1agB3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZ2IDsZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZ2IDsZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA48C19423;
	Tue, 31 Mar 2026 16:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976272;
	bh=oTiPNirPJq/rMgBTdjP2ESLyQUY8IRqTWDUNkyLVz9E=;
	h=From:To:Cc:Subject:Date:From;
	b=JZ2IDsZQvqVzgR+9YMFk5kL30Oakess7KuO3Md2oX+rjUHIWbRF2eXSGNedfPZQF7
	 q7ZaKzsHPkrNGmc44ma4KwyiFRlHyUG9VMDHbRkuW6QKXyj6A7Bbk5wIk1Q5o3cgvi
	 2osw9jCWG4TaNNdKfQF1vI5szjPG9bXUKGsSnzj4=
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
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.18 000/309] 6.18.21-rc1 review
Date: Tue, 31 Mar 2026 18:18:23 +0200
Message-ID: <20260331161753.468533260@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.21-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.21-rc1
X-KernelTest-Deadline: 2026-04-02T16:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.21 release.
There are 309 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.21-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.21-rc1

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix regressions caused by reusing ident

Hao-Yu Yang <naup96721@gmail.com>
    futex: Fix UaF between futex_key_to_node_opt() and vma_replace_policy()

Peter Zijlstra <peterz@infradead.org>
    futex: Require sys_futex_requeue() to have identical flags

Biju Das <biju.das.jz@bp.renesas.com>
    irqchip/renesas-rzv2h: Fix error path in rzv2h_icu_probe_common()

David Howells <dhowells@redhat.com>
    netfs: Fix the handling of stream->front by removing it

GuoHan Zhao <zhaoguohan@kylinos.cn>
    xen/privcmd: unregister xenstore notifier on module exit

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost error when running device stats on multiple devices fs

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    btrfs: fix leak of kobject name for sub-group space_info

Mark Harmstone <mark@harmstone.com>
    btrfs: fix super block offset in error message in btrfs_validate_super()

David Howells <dhowells@redhat.com>
    netfs: Fix read abandonment during retry

Christian Brauner <brauner@kernel.org>
    selftests/mount_setattr: increase tmpfs size for idmapped mount tests

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    dmaengine: xilinx_dma: Fix reset related timeout with two-channel AXIDMA

Marek Vasut <marex@nabladev.com>
    dmaengine: xilinx: xilinx_dma: Fix unmasked residue subtraction

Marek Vasut <marex@nabladev.com>
    dmaengine: xilinx: xilinx_dma: Fix residue calculation for cyclic DMA

Marek Vasut <marex@nabladev.com>
    dmaengine: xilinx: xilinx_dma: Fix dma_device directions

Tuo Li <islituo@gmail.com>
    dmaengine: idxd: fix possible wrong descriptor completion in llist_abort_desc()

Deepanshu Kartikey <kartikey406@gmail.com>
    netfs: Fix NULL pointer dereference in netfs_unbuffered_write() on retry

Deepanshu Kartikey <kartikey406@gmail.com>
    netfs: Fix kernel BUG in netfs_limit_iter() for ITER_KVEC iterators

Alexander Stein <alexander.stein@ew.tq-group.com>
    dmaengine: xilinx: xdma: Fix regmap init error handling

LUO Haowen <luo-hw@foxmail.com>
    dmaengine: dw-edma: Fix multiple times setting of the CYCLE_STATE and CYCLE_BIT bits for HDMA.

Felix Gu <ustc.gu@gmail.com>
    phy: ti: j721e-wiz: Fix device node reference leak in wiz_get_lane_phy_types()

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix leaking event log memory

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix freeing the allocated ida too late

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix memory leak when a wq is reset

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix not releasing workqueue on .release()

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix possible invalid memory access after FLR

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix crash when the event log is disabled

Lorenzo Stoakes (Oracle) <ljs@kernel.org>
    mm/mseal: update VMA end correctly on merge

Werner Kasselman <werner@verivus.com>
    ksmbd: fix use-after-free and NULL deref in smb_grant_oplock()

Jinjiang Tu <tujinjiang@huawei.com>
    mm/huge_memory: fix folio isn't locked in softleaf_to_folio()

Josh Law <objecting@objecting.org>
    mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure

SeongJae Park <sj@kernel.org>
    mm/damon/core: avoid use of half-online-committed context

SeongJae Park <sj@kernel.org>
    mm/damon/stat: monitor all System RAM resources

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix amdgpu_irq enabled counter unbalanced on smu v11.0

Benno Lossin <lossin@kernel.org>
    rust: pin-init: internal: init: document load-bearing fact of field accessors

Peter Zijlstra <peterz@infradead.org>
    unwind_user/x86: Fix arch=um build

Hari Bathini <hbathini@linux.ibm.com>
    powerpc64/bpf: do not increment tailcall count when prog is NULL

Markus Niebel <Markus.Niebel@ew.tq-group.com>
    arm64: dts: imx8mn-tqma8mqnl: fix LDO5 power off

Theodore Ts'o <tytso@mit.edu>
    ext4: always drain queued discard work in ext4_mb_release()

Baokun Li <libaokun@linux.alibaba.com>
    ext4: fix iloc.bh leak in ext4_fc_replay_inode() error paths

Theodore Ts'o <tytso@mit.edu>
    ext4: handle wraparound when searching for blocks for indirect mapped blocks

Zqiang <qiang.zhang@linux.dev>
    ext4: fix the might_sleep() warnings in kvfree()

Jiayuan Chen <jiayuan.chen@shopee.com>
    ext4: fix use-after-free in update_super_work when racing with umount

Helen Koike <koike@igalia.com>
    ext4: reject mount if bigalloc with s_first_data_block != 0

Ye Bin <yebin10@huawei.com>
    ext4: avoid allocate block from corrupted group in ext4_mb_find_by_goal()

Edward Adam Davis <eadavis@qq.com>
    ext4: avoid infinite loops caused by residual data

Tejas Bharambe <tejas.bharambe@outlook.com>
    ext4: validate p_idx bounds in ext4_ext_correct_indexes

Ye Bin <yebin10@huawei.com>
    ext4: test if inode's all dirty pages are submitted to disk

Li Chen <me@linux.beauty>
    ext4: publish jinode after initialization

Yuto Ohnuki <ytohnuki@amazon.com>
    ext4: replace BUG_ON with proper error handling in ext4_read_inline_folio

Jan Kara <jack@suse.cz>
    ext4: make recently_deleted() properly work with lazy itable initialization

Jan Kara <jack@suse.cz>
    ext4: fix fsync(2) for nojournal mode

Zhang Yi <yi.zhang@huawei.com>
    ext4: do not check fast symlink during orphan recovery

Jan Kara <jack@suse.cz>
    ext4: fix stale xarray tags after writeback

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: convert inline data to extents when truncate exceeds inline size

Simon Weber <simon.weber.39@gmail.com>
    ext4: fix journal credit check when setting fscrypt context

Darrick J. Wong <djwong@kernel.org>
    xfs: remove file_path tracepoint data

Darrick J. Wong <djwong@kernel.org>
    xfs: don't irele after failing to iget in xfs_attri_recover_work

Long Li <leo.lilong@huawei.com>
    xfs: fix ri_total validation in xlog_recover_attri_commit_pass2

hongao <hongao@uniontech.com>
    xfs: scrub: unlock dquot before early return in quota scrub

Yuto Ohnuki <ytohnuki@amazon.com>
    xfs: avoid dereferencing log items after push callbacks

Yuto Ohnuki <ytohnuki@amazon.com>
    xfs: save ailp before dropping the AIL lock in push callbacks

Yuto Ohnuki <ytohnuki@amazon.com>
    xfs: stop reclaim before pushing AIL during unmount

Max Boone <mboone@akamai.com>
    mm/pagewalk: fix race between concurrent split and refault

Josh Law <objecting@objecting.org>
    mm/damon/sysfs: check contexts->nr in repeat_call_fn

Josh Law <objecting@objecting.org>
    mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]

Asad Kamal <asad.kamal@amd.com>
    drm/amd/pm: Return -EOPNOTSUPP for unsupported OD_MCLK on smu_v13_0_6

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: KVM: Handle the case that EIOINTC's coremap is empty

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: KVM: Make kvm_get_vcpu_by_cpuid() more robust

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Workaround LS2K/LS7A GPU DMA hang bug

Xi Ruoyao <xry111@xry111.site>
    LoongArch: vDSO: Emit GNU_EH_FRAME correctly

Li Jun <lijun01@kylinos.cn>
    LoongArch: Fix missing NULL checks for kstrdup()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Unlink NV12 planes earlier

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Order OP vs. timeout correctly in __wait_for()

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_tunnel: Fix error handling when clearing stream BW in atomic state

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Fix drm_edid leak in amdgpu_dm

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdgpu: prevent immediate PASID reuse case

Claudiu Beznea <claudiu.beznea@tuxon.dev>
    dmaengine: sh: rz-dmac: Move CHCTRL updates under spinlock

Claudiu Beznea <claudiu.beznea@tuxon.dev>
    dmaengine: sh: rz-dmac: Protect the driver specific lists

Joy Zou <joy.zou@nxp.com>
    dmaengine: fsl-edma: fix channel parameter config for fixed channel requests

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    i2c: imx: ensure no clock is generated after last read

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    i2c: imx: fix i2c issue when reading multiple messages

Davidlohr Bueso <dave@stgolabs.net>
    futex: Clear stale exiting pointer in futex_lock_pi() retry path

Pratap Nirujogi <pratap.nirujogi@amd.com>
    i2c: designware: amdisp: Fix resume-probe race condition issue

Jassi Brar <jassisinghbrar@gmail.com>
    irqchip/qcom-mpm: Add missing mailbox TX done acknowledgment

Milos Nikic <nikic.milos@gmail.com>
    jbd2: gracefully abort on checkpointing state corruptions

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Only WARN in direct MMUs when overwriting shadow-present SPTE

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Drop/zap existing present SPTE even when creating an MMIO SPTE

Kevin Hao <haokexin@gmail.com>
    net: macb: Use dev_consume_skb_any() to free TX SKBs

Kevin Hao <haokexin@gmail.com>
    net: macb: Protect access to net_device::ip_ptr with RCU lock

Kevin Hao <haokexin@gmail.com>
    net: macb: Move devm_{free,request}_irq() out of spin lock area

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    scsi: ses: Handle positive SCSI error from ses_recv_diag()

Tyllis Xu <livelycarpet87@gmail.com>
    scsi: ibmvfc: Fix OOB access in ibmvfc_discover_targets_done()

Amir Goldstein <amir73il@gmail.com>
    ovl: fix wrong detection of 32bit inode numbers

Fei Lv <feilv@asrmicro.com>
    ovl: make fsync after metadata copy-up opt-in mount option

Abel Vesa <abel.vesa@oss.qualcomm.com>
    phy: qcom: qmp-ufs: Fix SM8650 PCS table for Gear 4

Nikunj A Dadhania <nikunj@amd.com>
    x86/fred: Fix early boot failures on SEV-ES/SNP guests

Borislav Petkov (AMD) <bp@alien8.de>
    x86/cpu: Remove X86_CR4_FRED from the CR4 pinned bits mask

Nikunj A Dadhania <nikunj@amd.com>
    x86/cpu: Enable FSGSBASE early in cpu_init_exception_handling()

Joanne Koong <joannelkoong@gmail.com>
    writeback: don't block sync for filesystems with no data integrity guarantees

Zhan Xusheng <zhanxusheng1024@gmail.com>
    alarmtimer: Fix argument order in alarm_timer_forward()

Jiucheng Xu <jiucheng.xu@amlogic.com>
    erofs: add GFP_NOIO in the bio completion if needed

xietangxin <xietangxin@yeah.net>
    virtio_net: Fix UAF on dst_ops when IFF_XMIT_DST_RELEASE is cleared and napi_tx is false

Zubin Mithra <zsm@google.com>
    virt: tdx-guest: Fix handling of host controlled 'quote' buffer length

Paul Moses <p@1g4.org>
    xfrm: iptfs: only publish mode_data after clone setup

Roshan Kumar <roshaen09@gmail.com>
    xfrm: iptfs: validate inner IPv4 header length in IPTFS payload

Yuchan Nam <entropy1110@gmail.com>
    media: mc, v4l2: serialize REINIT and REQBUFS with req_queue_mutex

Sanman Pradhan <psanman@juniper.net>
    hwmon: (peci/cputemp) Fix off-by-one in cputemp_is_visible()

Sanman Pradhan <psanman@juniper.net>
    hwmon: (peci/cputemp) Fix crit_hyst returning delta instead of absolute temperature

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/isl68137) Add mutex protection for AVS enable sysfs attributes

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/ina233) Fix error handling and sign extension in shunt voltage read

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Discard PC update state on vcpu reset

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Correct locked bit width

Abhijit Gangurde <abhijit.gangurde@amd.com>
    RDMA/ionic: Preserve and set Ethernet source MAC after ib_ud_header_init()

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: intel: int340x: soc_slider: Set offset only for balanced mode

Charles Mirabile <cmirabil@redhat.com>
    kbuild: Delete .builtin-dtbs.S when running make clean

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: conservative: Reset requested_freq on limits change

Marc Kleine-Budde <mkl@pengutronix.de>
    can: netlink: can_changelink(): add missing error handling to call can_ctrlmode_changelink()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: fix tx.buf use-after-free in isotp_sendmsg()

Ali Norouzi <ali.norouzi@keysight.com>
    can: gw: fix OOB heap access in cgw_csum_crc8_rel()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Allow bytes controls without initial payload

Guangshuo Li <lgs201920130244@gmail.com>
    ASoC: sma1307: fix double free of devm_kzalloc() memory

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: codecs: wcd934x: fix typo in dt parsing

Alexey Nepomnyashih <sdl@nppct.ru>
    ALSA: firewire-lib: fix uninitialized local variable

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: add quirk for ASUS Strix G16 G615JMR

Mario Limonciello <mario.limonciello@amd.com>
    Revert "ALSA: hda/intel: Add MSI X870E Tomahawk to denylist"

Hyunwoo Kim <imv4bel@gmail.com>
    ksmbd: do not expire session on binding failure

Werner Kasselman <werner@verivus.com>
    ksmbd: fix memory leaks and NULL deref in smb2_lock()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix potencial OOB in get_file_all_info() for compound requests

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: replace hardcoded hdr2_len with offsetof() in smb2_calc_max_out_buf_len()

Matthew Auld <matthew.auld@intel.com>
    drm/xe: always keep track of remap prev/next

Luo Haiyang <luo.haiyang@zte.com.cn>
    tracing: Fix potential deadlock in cpu hotplug with osnoise

Vasily Gorbik <gor@linux.ibm.com>
    s390/entry: Scrub r12 register on kernel entry

Vasily Gorbik <gor@linux.ibm.com>
    s390/barrier: Make array_index_mask_nospec() __always_inline

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    s390/syscalls: Add spectre boundary for syscall dispatch table

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Exclude Scarlett 2i4 1st Gen from SKIP_IFACE_SETUP

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: spi-fsl-lpspi: fix teardown order issue (UAF)

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ASoC: adau1372: Fix clock leak on PLL lock failure

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ASoC: adau1372: Fix unchecked clk_prepare_enable() return value

Marc Buerg <buermarc@googlemail.com>
    sysctl: fix uninitialized variable in proc_do_large_bitmap

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/core) Protect regulator operations with mutex

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Introduce the concept of "write-only" attributes

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Mark lowest/average/highest/rated attributes as read-only

Sanman Pradhan <psanman@juniper.net>
    hwmon: (adm1177) fix sysfs ABI violation and current unit conversion

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix fence put before wait in amdgpu_amdkfd_submit_ib

Weiming Shi <bestswngs@gmail.com>
    ACPI: EC: clean up handlers on probe failure in acpi_ec_setup()

Danilo Krummrich <dakr@kernel.org>
    spi: use generic driver_override infrastructure

Matt Roper <matthew.d.roper@intel.com>
    drm/xe: Implement recent spec updates to Wa_16025250150

Alice Ryhl <aliceryhl@google.com>
    rust: regulator: do not assume that regulator_get() returns non-null

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ASoC: dt-bindings: stm32: Fix incorrect compatible string in stm32h7-sai match

Yussuf Khalil <dev@pp3345.net>
    drm/amd/display: Do not skip unrelated mode changes in DSC validation

Felix Gu <ustc.gu@gmail.com>
    spi: meson-spicc: Fix double-put in remove path

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: catpt: Fix the device initialization

Felix Gu <ustc.gu@gmail.com>
    spi: sn-f-ospi: Fix resource leak in f_ospi_probe()

Youngjun Park <youngjun.park@lge.com>
    PM: sleep: Drop spurious WARN_ON() from pm_restore_gfp_mask()

Alberto Garcia <berto@igalia.com>
    PM: hibernate: Drain trailing zero pages on userspace restore

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    drm/i915/gmbus: fix spurious timeout on 512-byte burst reads

Luca Leonardo Scorcia <l.scorcia@gmail.com>
    drm/mediatek: dsi: Store driver data before invoking mipi_dsi_host_register

Mike Rapoport (Microsoft) <rppt@kernel.org>
    x86/efi: efi_unmap_boot_services: fix calculation of ranges_to_free size

Yihang Li <liyihang9@huawei.com>
    scsi: scsi_transport_sas: Fix the maximum channel scanning issue

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl: imx-card: initialize playback_only and capture_only

Shiraz Saleem <shiraz.saleem@intel.com>
    RDMA/irdma: Harden depth calculation functions

Tatyana Nikolova <tatyana.e.nikolova@intel.com>
    RDMA/irdma: Return EINVAL for invalid arp index error

Anil Samal <anil.samal@intel.com>
    RDMA/irdma: Fix deadlock during netdev reset with active connections

Tatyana Nikolova <tatyana.e.nikolova@intel.com>
    RDMA/irdma: Remove reset check from irdma_modify_qp_to_err()

Ivan Barrera <ivan.d.barrera@intel.com>
    RDMA/irdma: Clean up unnecessary dereference of event->cm_node

Tatyana Nikolova <tatyana.e.nikolova@intel.com>
    RDMA/irdma: Remove a NOP wait_event() in irdma_modify_qp_roce()

Tatyana Nikolova <tatyana.e.nikolova@intel.com>
    RDMA/irdma: Update ibqp state to error if QP is already in error state

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Initialize free_qp completion before using it

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Exclude Scarlett 2i2 1st Gen from SKIP_IFACE_SETUP

Ethan Tidmore <ethantidmore06@gmail.com>
    RDMA/efa: Fix possible deadlock

Chuck Lever <chuck.lever@oracle.com>
    RDMA/rw: Fall back to direct SGE on MR pool exhaustion

Sean Rhodes <sean@starlabs.systems>
    ALSA: hda/realtek: Sequence GPIO2 on Star Labs StarFighter

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    regmap: Synchronize cache for the page selector

Yonatan Nachum <ynachum@amazon.com>
    RDMA/efa: Fix use of completion ctx after free

Yonatan Nachum <ynachum@amazon.com>
    RDMA/efa: Improve admin completion context state machine

Yonatan Nachum <ynachum@amazon.com>
    RDMA/efa: Check stored completion CTX command ID with received one

Paolo Valerio <pvalerio@redhat.com>
    net: macb: use the current queue number for stats

David Carlier <devnexen@gmail.com>
    netfilter: ctnetlink: use netlink policy range checks

Weiming Shi <bestswngs@gmail.com>
    netfilter: nf_conntrack_sip: fix use of uninitialized rtp_addr in process_sdp

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: skip expectations in other netns via proc

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: revisit array resize logic

Ren Wei <n05ec@lzu.edu.cn>
    netfilter: ip6t_rt: reject oversized addrnr in rt_mt6_check()

Weiming Shi <bestswngs@gmail.com>
    netfilter: nfnetlink_log: fix uninitialized padding leak in NFULA_PAYLOAD

Chuck Lever <chuck.lever@oracle.com>
    tls: Purge async_hold in tls_decrypt_async_wait()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    Bluetooth: btusb: clamp SCO altsetting table indices

Hyunwoo Kim <imv4bel@gmail.com>
    Bluetooth: L2CAP: Fix ERTM re-init and zero pdu_len infinite loop

Hyunwoo Kim <imv4bel@gmail.com>
    Bluetooth: L2CAP: Fix deadlock in l2cap_conn_del()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix not tracking outstanding TX ident

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: btintel: serialize btintel_hw_error() with hci_req_sync_lock

Zhang Chen <zhangchen01@kylinos.cn>
    Bluetooth: L2CAP: Fix send LE flow credits in ACL link

Miguel Ojeda <ojeda@kernel.org>
    dma-mapping: add missing `inline` for `dma_free_attrs`

Sabrina Dubroca <sd@queasysnail.net>
    rtnetlink: fix leak of SRCU struct in rtnl_link_register

Thangaraj Samynathan <thangaraj.s@microchip.com>
    net: lan743x: fix duplex configuration in mac_link_up

Jiayuan Chen <jiayuan.chen@shopee.com>
    team: fix header_ops type confusion with non-Ethernet ports

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    virtio-net: correct hdr_len handling for tunnel gso

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    virtio-net: correct hdr_len handling for VIRTIO_NET_F_GUEST_HDRLEN

Wei Fang <wei.fang@nxp.com>
    net: enetc: fix the output issue of 'ethtool --show-ring'

Martin KaFai Lau <martin.lau@kernel.org>
    udp: Fix wildcard bind conflict check when using hash2

Qingfang Deng <dqfext@gmail.com>
    net: airoha: add RCU lock around dev_fill_forward_path

Yochai Eisenrich <echelonh@gmail.com>
    net: fix fanout UAF in packet_release() via NETDEV_UP race

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Don't remove permanent routes with exceptions from tb6_gc_hlist.

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Remove permanent routes from tb6_gc_hlist when all exceptions expire.

Kohei Enju <kohei@enjuk.jp>
    iavf: fix out-of-bounds writes in iavf_get_ethtool_stats()

Petr Oros <poros@redhat.com>
    ice: use ice_update_eth_stats() for representor stats

Petr Oros <poros@redhat.com>
    ice: fix inverted ready check for VF representors

David McFarland <corngood@gmail.com>
    platform/x86: intel-hid: disable wakeup_mode during hibernation

Alok Tiwari <alok.a.tiwari@oracle.com>
    platform/olpc: olpc-xo175-ec: Fix overflow error message to print inlen

Nathan Chancellor <nathan@kernel.org>
    platform/x86: lenovo: wmi-gamezone: Drop gz_chain_head

Li RongQing <lirongqing@baidu.com>
    platform/x86: ISST: Check HWP support before MSR access

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: fix double disable of clk

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: fix double free of WoL irq

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: streamline early exit in probe

Sabrina Dubroca <sd@queasysnail.net>
    rtnetlink: count IFLA_INFO_SLAVE_KIND in if_nlmsg_size

Sabrina Dubroca <sd@queasysnail.net>
    rtnetlink: count IFLA_PARENT_DEV_{NAME,BUS_NAME} in if_nlmsg_size

Qi Tang <tpluszz77@gmail.com>
    net/smc: fix double-free of smc_spd_priv when tee() duplicates splice pipe buffer

Yang Yang <n05ec@lzu.edu.cn>
    openvswitch: validate MPLS set/set_masked payload length

Yang Yang <n05ec@lzu.edu.cn>
    openvswitch: defer tunnel netdev_put to RCU release

Toke Høiland-Jørgensen <toke@redhat.com>
    net: openvswitch: Avoid releasing netdev before teardown completes

Jakub Kicinski <kuba@kernel.org>
    nfc: nci: fix circular locking dependency in nci_close_device

Mohammad Heib <mheib@redhat.com>
    ionic: fix persistent MAC address override on PF

Luca Leonardo Scorcia <l.scorcia@gmail.com>
    pinctrl: mediatek: common: Fix probe failure for devices without EINT

Helen Koike <koike@igalia.com>
    Bluetooth: L2CAP: Fix null-ptr-deref on l2cap_sock_ready_cb

Anas Iqbal <mohd.abd.6602@gmail.com>
    Bluetooth: hci_ll: Fix firmware leak on error path

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix dangling pointer on mgmt_add_adv_patterns_monitor_complete

Hyunwoo Kim <imv4bel@gmail.com>
    Bluetooth: SCO: Fix use-after-free in sco_recv_frame() due to missing sock_hold

Hyunwoo Kim <imv4bel@gmail.com>
    Bluetooth: L2CAP: Validate PDU length before reading SDU length in l2cap_ecred_data_rcv()

Minseo Park <jacob.park.9436@gmail.com>
    Bluetooth: L2CAP: Fix stack-out-of-bounds read in l2cap_ecred_conn_req

Amelie Delaunay <amelie.delaunay@foss.st.com>
    pinctrl: stm32: fix HDP driver dependency on GPIO_GENERIC

Oliver Hartkopp <socketcan@hartkopp.net>
    can: statistics: add missing atomic access in hot path

Sheng Yong <shengyong1@xiaomi.com>
    erofs: set fileio bio failed in short read case

Shigeru Yoshida <syoshida@redhat.com>
    dma: swiotlb: add KMSAN annotations to swiotlb_bounce()

Eric Dumazet <edumazet@google.com>
    af_key: validate families in pfkey_send_migrate()

Minwoo Ra <raminwo0202@gmail.com>
    xfrm: prevent policy_hthresh.work from racing with netns teardown

Hyunwoo Kim <imv4bel@gmail.com>
    xfrm: Fix work re-schedule after cancel in xfrm_nat_keepalive_net_fini()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    pinctrl: renesas: rza1: Normalize return value of gpio_get()

Fernando Fernandez Mancera <fmancera@suse.de>
    xfrm: iptfs: fix skb_put() panic on non-linear skb during reassembly

Felix Gu <ustc.gu@gmail.com>
    pinctrl: renesas: rzt2h: Fix device node leak in rzt2h_gpio_register()

Sabrina Dubroca <sd@queasysnail.net>
    esp: fix skb leak with espintcp and async crypto

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: call xdo_dev_state_delete during state update

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: fix the condition on x->pcpu_num in xfrm_sa_len

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: add missing extack for XFRMA_SA_PCPU in add_acquire and allocspi

Peter Yin <peteryin.openbmc@gmail.com>
    i3c: master: dw-i3c: Fix missing of_node for virtual I2C adapter

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: add quirk for ASUS UM6702RC

Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
    spi: intel-pci: Add support for Nova Lake mobile SPI flash

Jie Deng <dengjie03@kylinos.cn>
    usb: core: new quirk to handle devices with zero configurations

Yang Wang <kevinyang.wang@amd.com>
    drm/amdgpu: fix gpu idle power consumption issue for gfx v12

Chaitanya Kulkarni <kch@nvidia.com>
    nvmet: move async event work off nvmet-wq

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Handle Clang RSP musical chairs

Uzair Mughal <contact@uzair.is-a.dev>
    ALSA: hda/realtek: Add headset jack quirk for Thinkpad X390

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Gigabyte Technology to fix headphone

Liucheng Lu <luliucheng100@outlook.com>
    ALSA: hda/realtek: add HP Laptop 14s-dr5xxx mute LED quirk

Hari Bathini <hbathini@linux.ibm.com>
    powerpc64/ftrace: fix OOL stub count with clang

Boris Burkov <boris@bur.io>
    btrfs: set BTRFS_ROOT_ORPHAN_CLEANUP during subvol create

zhidao su <soolaugust@gmail.com>
    sched_ext: Use WRITE_ONCE() for the write side of dsq->seq update

Günther Noack <gnoack@google.com>
    HID: apple: avoid memory leak in apple_report_fixup()

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Fix u32/s32 bounds when ranges cross min/max boundary

Simon Trimmer <simont@opensource.cirrus.com>
    ASoC: amd: acp: Add ACP6.3 match entries for Cirrus Logic parts

Maarten Lankhorst <dev@lankhorst.se>
    drm/ttm/tests: Fix build failure on PREEMPT_RT

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: hda/senary: Ensure EAPD is enabled during init

Nilay Shroff <nilay@linux.ibm.com>
    block: break pcpu_alloc_mutex dependency on freeze_lock

Isaac J. Manjarres <isaacmanjarres@google.com>
    dma-buf: Include ioctl.h in UAPI header

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Only patch ASP registers if the DAI is part of a DAIlink

Mark Brown <broonie@kernel.org>
    ASoC: fsl_easrc: Fix event generation in fsl_easrc_iec958_put_bits()

Sheetal <sheetal@nvidia.com>
    ALSA: hda/hdmi: Add Tegra238 HDA codec device ID

Oliver Freyermuth <o.freyermuth@googlemail.com>
    ASoC: Intel: sof_sdw: Add quirk for Alienware Area 51 (2025) 0CCD SKU

Florian Fuchs <fuchsfl@gmail.com>
    scsi: devinfo: Add BLIST_SKIP_IO_HINTS for Iomega ZIP

Shuming Fan <shumingf@realtek.com>
    ASoC: rt1321: fix DMIC ch2/3 mask issue

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Clear reset history on ready and recheck state after timeout

Mark Brown <broonie@kernel.org>
    ASoC: fsl_easrc: Fix event generation in fsl_easrc_iec958_set_reg()

Ihor Solodrai <ihor.solodrai@linux.dev>
    module: Fix kernel panic when a symbol st_shndx is out of bounds

Denis Benato <denis.benato@linux.dev>
    HID: asus: add xg mobile 2023 external hardware support

Romain Sioen <romain.sioen@microchip.com>
    HID: mcp2221: cancel last I2C command on read error

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86: oxpec: Add support for OneXPlayer X1 Air

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86: oxpec: Add support for Aokzoe A2 Pro

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kbuild: install-extmod-build: Package resolve_btfids if necessary

Valentin Spreckels <valentin@spreckels.dev>
    net: usb: r8152: add TRENDnet TUC-ET2G

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86: oxpec: Add support for OneXPlayer X1z

Takashi Iwai <tiwai@suse.de>
    HID: apple: Add EPOMAKER TH87 to the non-apple keyboards list

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86: oxpec: Add support for OneXPlayer APEX

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: ipc: Add Nova Lake-H/S PCI device IDs

Günther Noack <gnoack@google.com>
    HID: magicmouse: avoid memory leak in magicmouse_report_fixup()

Julius Lehmann <lehmanju@devpi.de>
    HID: magicmouse: fix battery reporting for Apple Magic Trackpad 2

Keith Busch <kbusch@kernel.org>
    nvme-pci: ensure we're polling a polled queue

Hans de Goede <johannes.goede@oss.qualcomm.com>
    platform/x86: touchscreen_dmi: Add quirk for y-inverted Goodix touchscreen on SUPI S10

Leif Skunberg <diamondback@cohunt.app>
    platform/x86: intel-hid: Enable 5-button array on ThinkPad X1 Fold 16 Gen 1

Krishna Chomal <krishna.chomal108@gmail.com>
    platform/x86: hp-wmi: Add Omen 16-xd0xxx fan and thermal support

Daniel Hodges <hodgesd@meta.com>
    nvme-fabrics: use kfree_sensitive() for DHCHAP secrets

Keith Busch <kbusch@kernel.org>
    nvme-pci: cap queue creation to used queues

Peter Metz <peter.metz@unarin.com>
    platform/x86: intel-hid: Add Dell 14 Plus 2-in-1 to dmi_vgbs_allow_list

Günther Noack <gnoack@google.com>
    HID: asus: avoid memory leak in asus_report_fixup()

Krishna Chomal <krishna.chomal108@gmail.com>
    platform/x86: hp-wmi: Add Omen 16-wf0xxx fan and thermal support

Xuewen Yan <xuewen.yan@unisoc.com>
    tracing: Revert "tracing: Remove pid in task_rename tracing output"

Daniel Wade <danjwade95@gmail.com>
    bpf: Fix unsound scalar forking in maybe_fork_scalars() for BPF_OR

Jenny Guanni Qu <qguanni@gmail.com>
    bpf: Fix undefined behavior in interpreter sdiv/smod for INT_MIN

Ihor Solodrai <ihor.solodrai@linux.dev>
    bpf: Fix exception exit lock checking for subprogs

Cui Chao <cuichao1753@phytium.com.cn>
    cxl: Adjust the startup priority of cxl_pmem to be higher than that of cxl_acpi

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Release module BTF IDR before module unload

Danilo Krummrich <dakr@kernel.org>
    driver core: platform: use generic driver_override infrastructure

Danilo Krummrich <dakr@kernel.org>
    driver core: generalize driver_override in struct device

Danilo Krummrich <dakr@kernel.org>
    sh: platform_early: remove pdev->driver_override check

Danilo Krummrich <dakr@kernel.org>
    hwmon: axi-fan: don't use driver_override as IRQ name

Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
    cxl/hdm: Avoid incorrect DVSEC fallback when HDM decoders are enabled

Janosch Frank <frankja@linux.ibm.com>
    s390/mm: Add missing secure storage access fixups for donated memory

Peter Zijlstra <peterz@infradead.org>
    perf: Make sure to use pmu_ctx->pmu for groups

Peter Zijlstra <peterz@infradead.org>
    x86/perf: Make sure to program the counter value for stopped events on migration

Sachin Kumar <xcyfun@protonmail.com>
    bpf: Fix constant blinding for PROBE_MEM32 stores

Yazhou Tang <tangyazhou518@outlook.com>
    bpf: Reset register ID for BPF_END value tracking

Alison Schofield <alison.schofield@intel.com>
    cxl/port: Fix use after free of parent_port in cxl_detach_ep()


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   3 +
 .../devicetree/bindings/sound/st,stm32-sai.yaml    |   2 +-
 Documentation/filesystems/overlayfs.rst            |  50 +++
 Documentation/hwmon/adm1177.rst                    |   8 +-
 Documentation/hwmon/peci-cputemp.rst               |  10 +-
 Makefile                                           |   6 +-
 .../boot/dts/freescale/imx8mn-tqma8mqnl-mba8mx.dts |  13 +-
 .../arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi |  22 ++
 arch/arm64/kvm/reset.c                             |  14 +
 arch/loongarch/include/asm/linkage.h               |  36 ++
 arch/loongarch/include/asm/sigframe.h              |   9 +
 arch/loongarch/kernel/asm-offsets.c                |   2 +
 arch/loongarch/kernel/env.c                        |   7 +-
 arch/loongarch/kernel/signal.c                     |   6 +-
 arch/loongarch/kvm/intc/eiointc.c                  |   2 +-
 arch/loongarch/kvm/vcpu.c                          |   3 +
 arch/loongarch/pci/pci.c                           |  80 ++++
 arch/loongarch/vdso/Makefile                       |   4 +-
 arch/loongarch/vdso/sigreturn.S                    |   6 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |  23 +-
 arch/powerpc/tools/ftrace-gen-ool-stubs.sh         |   4 +-
 arch/s390/include/asm/barrier.h                    |   4 +-
 arch/s390/kernel/entry.S                           |   3 +
 arch/s390/kernel/syscall.c                         |   5 +-
 arch/s390/mm/fault.c                               |  11 +-
 arch/sh/drivers/platform_early.c                   |   4 -
 arch/x86/coco/sev/noinstr.c                        |   6 +
 arch/x86/entry/entry_fred.c                        |  14 +
 arch/x86/events/core.c                             |   4 +-
 arch/x86/include/asm/unwind_user.h                 |   4 +
 arch/x86/kernel/cpu/common.c                       |  20 +-
 arch/x86/kvm/mmu/mmu.c                             |  17 +-
 arch/x86/platform/efi/quirks.c                     |   2 +-
 block/blk-mq.c                                     |  45 ++-
 drivers/acpi/ec.c                                  |   2 +
 drivers/base/bus.c                                 |  43 ++-
 drivers/base/core.c                                |   2 +
 drivers/base/dd.c                                  |  60 +++
 drivers/base/platform.c                            |  37 +-
 drivers/base/regmap/regmap.c                       |  30 +-
 drivers/bluetooth/btintel.c                        |  11 +-
 drivers/bluetooth/btusb.c                          |   5 +-
 drivers/bluetooth/hci_ll.c                         |   2 +
 drivers/bus/simple-pm-bus.c                        |   4 +-
 drivers/clk/imx/clk-scu.c                          |   3 +-
 drivers/cpufreq/cpufreq_conservative.c             |  12 +
 drivers/cpufreq/cpufreq_governor.c                 |   3 +
 drivers/cpufreq/cpufreq_governor.h                 |   1 +
 drivers/cxl/core/hdm.c                             |  25 +-
 drivers/cxl/core/port.c                            |   8 +-
 drivers/cxl/pmem.c                                 |   2 +-
 drivers/dma/dw-edma/dw-hdma-v0-core.c              |   6 +-
 drivers/dma/fsl-edma-main.c                        |  26 +-
 drivers/dma/idxd/cdev.c                            |   8 +-
 drivers/dma/idxd/device.c                          |   6 +-
 drivers/dma/idxd/init.c                            |   4 +-
 drivers/dma/idxd/submit.c                          |   2 +-
 drivers/dma/idxd/sysfs.c                           |   1 +
 drivers/dma/sh/rz-dmac.c                           |  68 ++--
 drivers/dma/xilinx/xdma.c                          |   4 +-
 drivers/dma/xilinx/xilinx_dma.c                    |  46 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c            |  45 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   1 +
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |   5 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   8 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |   1 +
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   4 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   7 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |   7 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c   |   2 +-
 drivers/gpu/drm/i915/display/intel_display.c       |   8 +-
 drivers/gpu/drm/i915/display/intel_dp_tunnel.c     |  20 +-
 drivers/gpu/drm/i915/display/intel_dp_tunnel.h     |  11 +-
 drivers/gpu/drm/i915/display/intel_gmbus.c         |   4 +-
 drivers/gpu/drm/i915/display/intel_plane.c         |  11 +-
 drivers/gpu/drm/i915/i915_wait_util.h              |   2 +-
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |   9 +-
 drivers/gpu/drm/ttm/tests/ttm_bo_test.c            |   4 +-
 drivers/gpu/drm/xe/regs/xe_gt_regs.h               |   1 +
 drivers/gpu/drm/xe/xe_pt.c                         |  12 +-
 drivers/gpu/drm/xe/xe_vm.c                         |  22 +-
 drivers/gpu/drm/xe/xe_vm_types.h                   |   4 +
 drivers/gpu/drm/xe/xe_wa.c                         |   3 +-
 drivers/hid/hid-apple.c                            |   7 +-
 drivers/hid/hid-asus.c                             |  18 +-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-magicmouse.c                       |   6 +-
 drivers/hid/hid-mcp2221.c                          |   2 +
 drivers/hid/intel-ish-hid/ipc/hw-ish.h             |   2 +
 drivers/hid/intel-ish-hid/ipc/pci-ish.c            |  12 +
 drivers/hwmon/adm1177.c                            |  54 +--
 drivers/hwmon/axi-fan-control.c                    |   2 +-
 drivers/hwmon/peci/cputemp.c                       |   4 +-
 drivers/hwmon/pmbus/ina233.c                       |   3 +-
 drivers/hwmon/pmbus/isl68137.c                     |  21 +-
 drivers/hwmon/pmbus/pmbus_core.c                   | 192 ++++++++--
 drivers/i2c/busses/i2c-designware-amdisp.c         |  11 +-
 drivers/i2c/busses/i2c-imx.c                       |  51 ++-
 drivers/i3c/master/dw-i3c-master.c                 |   2 +
 drivers/infiniband/core/rw.c                       |  27 +-
 drivers/infiniband/hw/efa/efa_com.c                | 175 ++++-----
 drivers/infiniband/hw/ionic/ionic_controlpath.c    |   4 +-
 drivers/infiniband/hw/irdma/cm.c                   |  29 +-
 drivers/infiniband/hw/irdma/uk.c                   |  39 +-
 drivers/infiniband/hw/irdma/utils.c                |   2 -
 drivers/infiniband/hw/irdma/verbs.c                |   9 +-
 drivers/irqchip/irq-qcom-mpm.c                     |   3 +
 drivers/irqchip/irq-renesas-rzv2h.c                |   2 +-
 drivers/media/mc/mc-request.c                      |   5 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |   5 +-
 drivers/net/can/dev/netlink.c                      |   4 +-
 drivers/net/ethernet/airoha/airoha_ppe.c           |   2 +
 drivers/net/ethernet/broadcom/asp2/bcmasp.c        |  66 ++--
 drivers/net/ethernet/cadence/macb_main.c           |  41 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   2 +
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  31 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  14 +-
 drivers/net/ethernet/intel/ice/ice_repr.c          |   5 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   5 +
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  17 +-
 drivers/net/team/team_core.c                       |  65 +++-
 drivers/net/tun_vnet.h                             |   2 +-
 drivers/net/usb/r8152.c                            |   1 +
 drivers/net/virtio_net.c                           |   7 +-
 drivers/nvme/host/fabrics.c                        |   4 +-
 drivers/nvme/host/pci.c                            |  11 +-
 drivers/nvme/target/admin-cmd.c                    |   2 +-
 drivers/nvme/target/core.c                         |  14 +-
 drivers/nvme/target/nvmet.h                        |   1 +
 drivers/nvme/target/rdma.c                         |   1 +
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c            |   3 +-
 drivers/phy/ti/phy-j721e-wiz.c                     |   2 +
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |   9 +-
 drivers/pinctrl/renesas/pinctrl-rza1.c             |   2 +-
 drivers/pinctrl/renesas/pinctrl-rzt2h.c            |   1 +
 drivers/pinctrl/stm32/Kconfig                      |   1 +
 drivers/platform/olpc/olpc-xo175-ec.c              |   2 +-
 drivers/platform/x86/hp/hp-wmi.c                   |   8 +
 drivers/platform/x86/intel/hid.c                   |  23 +-
 .../x86/intel/speed_select_if/isst_tpmi_core.c     |   5 +-
 drivers/platform/x86/lenovo/wmi-gamezone.c         |   2 -
 drivers/platform/x86/oxpec.c                       |  30 +-
 drivers/platform/x86/touchscreen_dmi.c             |  18 +
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   3 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  10 +
 drivers/scsi/scsi_devinfo.c                        |   2 +-
 drivers/scsi/scsi_transport_sas.c                  |   2 +-
 drivers/scsi/ses.c                                 |   2 +-
 drivers/slimbus/qcom-ngd-ctrl.c                    |   6 +-
 drivers/spi/spi-fsl-lpspi.c                        |   3 +-
 drivers/spi/spi-intel-pci.c                        |   1 +
 drivers/spi/spi-meson-spicc.c                      |   2 -
 drivers/spi/spi-sn-f-ospi.c                        |  17 +-
 drivers/spi/spi.c                                  |  19 +-
 .../int340x_thermal/processor_thermal_soc_slider.c |   8 +-
 drivers/usb/core/config.c                          |   6 +-
 drivers/usb/core/quirks.c                          |   5 +
 drivers/virt/coco/tdx-guest/tdx-guest.c            |  12 +-
 drivers/xen/privcmd.c                              |   3 +
 fs/btrfs/block-group.c                             |   2 +-
 fs/btrfs/disk-io.c                                 |   4 +-
 fs/btrfs/ioctl.c                                   |   7 +
 fs/btrfs/volumes.c                                 |   5 +-
 fs/erofs/fileio.c                                  |   6 +-
 fs/erofs/zdata.c                                   |   3 +
 fs/ext4/crypto.c                                   |   9 +-
 fs/ext4/ext4.h                                     |   1 +
 fs/ext4/extents.c                                  |  23 +-
 fs/ext4/fast_commit.c                              |  17 +-
 fs/ext4/fsync.c                                    |  16 +-
 fs/ext4/ialloc.c                                   |   6 +
 fs/ext4/inline.c                                   |  10 +-
 fs/ext4/inode.c                                    |  75 +++-
 fs/ext4/mballoc.c                                  |  30 +-
 fs/ext4/page-io.c                                  |  10 +-
 fs/ext4/super.c                                    |  16 +-
 fs/ext4/sysfs.c                                    |  10 +-
 fs/fs-writeback.c                                  |  18 +-
 fs/fuse/file.c                                     |   4 +-
 fs/fuse/inode.c                                    |   1 +
 fs/jbd2/checkpoint.c                               |  15 +-
 fs/netfs/buffered_read.c                           |   3 +-
 fs/netfs/direct_read.c                             |   3 +-
 fs/netfs/direct_write.c                            |  15 +-
 fs/netfs/iterator.c                                |  43 +++
 fs/netfs/read_collect.c                            |   4 +-
 fs/netfs/read_retry.c                              |   5 +-
 fs/netfs/read_single.c                             |   1 -
 fs/netfs/write_collect.c                           |   4 +-
 fs/netfs/write_issue.c                             |   3 +-
 fs/overlayfs/copy_up.c                             |   6 +-
 fs/overlayfs/overlayfs.h                           |  21 ++
 fs/overlayfs/ovl_entry.h                           |   7 +-
 fs/overlayfs/params.c                              |  33 +-
 fs/overlayfs/super.c                               |   2 +-
 fs/overlayfs/util.c                                |   5 +-
 fs/smb/server/oplock.c                             |  72 ++--
 fs/smb/server/smb2pdu.c                            |  73 ++--
 fs/xfs/scrub/quota.c                               |   4 +-
 fs/xfs/scrub/trace.h                               |  12 +-
 fs/xfs/xfs_attr_item.c                             |   5 +-
 fs/xfs/xfs_dquot_item.c                            |   9 +-
 fs/xfs/xfs_inode_item.c                            |   9 +-
 fs/xfs/xfs_mount.c                                 |   7 +-
 fs/xfs/xfs_trace.h                                 |  47 ++-
 fs/xfs/xfs_trans_ail.c                             |  26 +-
 include/linux/damon.h                              |   6 +
 include/linux/device.h                             |  54 +++
 include/linux/device/bus.h                         |   4 +
 include/linux/dma-mapping.h                        |   4 +-
 include/linux/fs.h                                 |   1 +
 include/linux/mempolicy.h                          |   1 +
 include/linux/netfs.h                              |   1 -
 include/linux/pagemap.h                            |  11 -
 include/linux/platform_device.h                    |   5 -
 include/linux/spi/spi.h                            |   5 -
 include/linux/swapops.h                            |  27 +-
 include/linux/usb/quirks.h                         |   3 +
 include/linux/usb/r8152.h                          |   1 +
 include/linux/virtio_net.h                         |  53 ++-
 include/net/bluetooth/l2cap.h                      |   2 +-
 include/net/inet_hashtables.h                      |  14 +
 include/net/ip6_fib.h                              |  21 +-
 include/sound/cs35l56.h                            |   1 +
 include/trace/events/netfs.h                       |   8 +-
 include/trace/events/task.h                        |   7 +-
 include/uapi/linux/dma-buf.h                       |   1 +
 include/uapi/linux/netfilter/nf_conntrack_common.h |   4 +
 kernel/bpf/btf.c                                   |  24 +-
 kernel/bpf/core.c                                  |  43 ++-
 kernel/bpf/verifier.c                              |  36 +-
 kernel/dma/swiotlb.c                               |  21 +-
 kernel/events/core.c                               |  19 +-
 kernel/futex/core.c                                |   2 +-
 kernel/futex/pi.c                                  |   3 +-
 kernel/futex/syscalls.c                            |   8 +
 kernel/module/main.c                               |   7 +
 kernel/power/main.c                                |   2 +-
 kernel/power/snapshot.c                            |  11 +
 kernel/sched/ext.c                                 |   2 +-
 kernel/sysctl.c                                    |   2 +-
 kernel/time/alarmtimer.c                           |   2 +-
 kernel/trace/trace_osnoise.c                       |  10 +-
 mm/damon/core.c                                    |   8 +
 mm/damon/stat.c                                    |  36 +-
 mm/damon/sysfs.c                                   |  10 +-
 mm/mempolicy.c                                     |  10 +-
 mm/mseal.c                                         |   5 +-
 mm/pagewalk.c                                      |  25 +-
 net/bluetooth/l2cap_core.c                         | 103 +++--
 net/bluetooth/l2cap_sock.c                         |   3 +
 net/bluetooth/mgmt.c                               |   2 +-
 net/bluetooth/sco.c                                |  10 +-
 net/can/af_can.c                                   |   4 +-
 net/can/af_can.h                                   |   2 +-
 net/can/gw.c                                       |   6 +-
 net/can/isotp.c                                    |  24 +-
 net/can/proc.c                                     |   3 +-
 net/core/rtnetlink.c                               |  28 +-
 net/ipv4/esp4.c                                    |   9 +-
 net/ipv4/inet_connection_sock.c                    |  20 +-
 net/ipv4/udp.c                                     |   2 +-
 net/ipv6/addrconf.c                                |   4 +-
 net/ipv6/esp6.c                                    |   9 +-
 net/ipv6/ip6_fib.c                                 |  15 +-
 net/ipv6/netfilter/ip6t_rt.c                       |   4 +
 net/ipv6/route.c                                   |   2 +-
 net/key/af_key.c                                   |  19 +-
 net/netfilter/nf_conntrack_expect.c                |   4 +
 net/netfilter/nf_conntrack_netlink.c               |  16 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  10 +-
 net/netfilter/nf_conntrack_sip.c                   |  14 +-
 net/netfilter/nfnetlink_log.c                      |   8 +-
 net/netfilter/nft_set_rbtree.c                     |  92 ++++-
 net/nfc/nci/core.c                                 |  10 +-
 net/openvswitch/flow_netlink.c                     |   2 +
 net/openvswitch/vport-netdev.c                     |  11 +-
 net/packet/af_packet.c                             |   1 +
 net/smc/smc_rx.c                                   |   9 +-
 net/tls/tls_sw.c                                   |   2 +-
 net/xfrm/xfrm_iptfs.c                              |  17 +-
 net/xfrm/xfrm_nat_keepalive.c                      |   2 +-
 net/xfrm/xfrm_policy.c                             |   2 +
 net/xfrm/xfrm_state.c                              |   1 +
 net/xfrm/xfrm_user.c                               |   7 +-
 rust/kernel/regulator.rs                           |  33 +-
 rust/pin-init/src/macros.rs                        |  16 +
 scripts/package/install-extmod-build               |   4 +
 sound/firewire/amdtp-stream.c                      |   2 +-
 sound/hda/codecs/hdmi/tegrahdmi.c                  |   1 +
 sound/hda/codecs/realtek/alc269.c                  |  42 ++-
 sound/hda/codecs/realtek/alc662.c                  |   9 +
 sound/hda/codecs/senarytech.c                      |   5 +
 sound/hda/controllers/intel.c                      |   1 -
 sound/soc/amd/acp/amd-acp63-acpi-match.c           | 413 +++++++++++++++++++++
 sound/soc/codecs/adau1372.c                        |  34 +-
 sound/soc/codecs/cs35l56-shared.c                  |  16 +-
 sound/soc/codecs/cs35l56.c                         |   8 +
 sound/soc/codecs/rt1320-sdw.c                      |   5 +-
 sound/soc/codecs/sma1307.c                         |   6 +-
 sound/soc/codecs/wcd934x.c                         |   2 +-
 sound/soc/fsl/fsl_easrc.c                          |  14 +-
 sound/soc/fsl/imx-card.c                           |   2 +
 sound/soc/intel/boards/sof_sdw.c                   |   8 +
 sound/soc/intel/catpt/device.c                     |  10 +-
 sound/soc/intel/catpt/dsp.c                        |   3 -
 sound/soc/samsung/i2s.c                            |   6 +-
 sound/soc/sof/ipc4-topology.c                      |   2 +-
 sound/usb/quirks.c                                 |   2 +
 tools/objtool/arch/x86/decode.c                    |  68 ++--
 tools/objtool/check.c                              |  14 +
 .../testing/selftests/bpf/prog_tests/reg_bounds.c  |  62 +++-
 .../testing/selftests/bpf/progs/exceptions_fail.c  |   9 +-
 .../selftests/mount_setattr/mount_setattr_test.c   |   2 +-
 316 files changed, 3581 insertions(+), 1178 deletions(-)


