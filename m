Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A95423A7C;
	Tue, 31 Mar 2026 16:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975663; cv=none; b=hNXrIoe5YELdwOADMGEHSgipeDILcYAYbBgJg7WVTfG/hwIR+QhchKdB+NZ96IsXlpT3cJxUu4jEd61Zj7LUT/6OE3Wlk2717AcdZ6Au1iCfk1oi7RmBFeoXmQHT48QhzntnJ9n04wD/hsc38WKMWe7xJHUNDkaz8JC6EFQjC3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975663; c=relaxed/simple;
	bh=M2fiBh5CO2Pslxh0fSInxYUlHm+W9DcOBWMcGb/Eh6g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tvkpauWqiXPhQRky/lyBvhz9RQLwexwPdVcgxUPbFbe+FrnAW6opIziQZu0oqVaRnMdSU52chWMRpvjMI7lXDoqauft9RjYdNKmQS18NveELum9iLdgMzgfG/cNemxGtCJzqS84PPCKvGytlwts4wuwKVvWBcWugHSKTMi1ePKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+rjcIGK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+rjcIGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1E2C19424;
	Tue, 31 Mar 2026 16:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975663;
	bh=M2fiBh5CO2Pslxh0fSInxYUlHm+W9DcOBWMcGb/Eh6g=;
	h=From:To:Cc:Subject:Date:From;
	b=c+rjcIGK0NviDOZICzlvNIGI+Ui4O5etOMYDAgtP81YL66xzcVR5SfAtn12cLy3q2
	 ujSYENFMzKI6y8Lrd6pmEnBqWoV7OhJ1aKoFUiky04Rt2EOaeaVpYGZciuvO8cRrkC
	 eKqG88V0kmv3rZtAhTU+CgwAJvk0N6xOTSGMfjj4=
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
Subject: [PATCH 6.12 000/244] 6.12.80-rc1 review
Date: Tue, 31 Mar 2026 18:19:10 +0200
Message-ID: <20260331161741.651718120@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.80-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.80-rc1
X-KernelTest-Deadline: 2026-04-02T16:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.80 release.
There are 244 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.80-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.80-rc1

Li Li <boolli@google.com>
    idpf: nullify pointers after they are freed

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: Fix network filter wake for asp-3.0

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmasp: Restore programming of TX map vector register

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix leaking event log memory

Peter Zijlstra <peterz@infradead.org>
    futex: Require sys_futex_requeue() to have identical flags

GuoHan Zhao <zhaoguohan@kylinos.cn>
    xen/privcmd: unregister xenstore notifier on module exit

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost error when running device stats on multiple devices fs

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    btrfs: fix leak of kobject name for sub-group space_info

Mark Harmstone <mark@harmstone.com>
    btrfs: fix super block offset in error message in btrfs_validate_super()

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
    netfs: Fix kernel BUG in netfs_limit_iter() for ITER_KVEC iterators

Alexander Stein <alexander.stein@ew.tq-group.com>
    dmaengine: xilinx: xdma: Fix regmap init error handling

LUO Haowen <luo-hw@foxmail.com>
    dmaengine: dw-edma: Fix multiple times setting of the CYCLE_STATE and CYCLE_BIT bits for HDMA.

Felix Gu <ustc.gu@gmail.com>
    phy: ti: j721e-wiz: Fix device node reference leak in wiz_get_lane_phy_types()

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix freeing the allocated ida too late

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix memory leak when a wq is reset

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix not releasing workqueue on .release()

Takashi Iwai <tiwai@suse.de>
    ASoC: ak4458: Convert to RUNTIME_PM_OPS() & co

Sreedevi Joshi <sreedevi.joshi@intel.com>
    idpf: Fix RSS LUT NULL ptr issue after soft reset

Sreedevi Joshi <sreedevi.joshi@intel.com>
    idpf: Fix RSS LUT NULL pointer crash on early ethtool operations

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: detach and close netdevs while handling a reset

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: check error for register_netdev() on init

Aaron Ma <aaron.ma@canonical.com>
    ice: Fix PTP NULL pointer dereference during VSI rebuild

Mateusz Polchlopek <mateusz.polchlopek@intel.com>
    ice: fix using untrusted value of pkt_len in ice_vc_fdir_parse_raw()

Mickaël Salaün <mic@digikod.net>
    landlock: Fix handling of disconnected directories

Mickaël Salaün <mic@digikod.net>
    landlock: Optimize file path walks and prepare for audit support

Eric Dumazet <edumazet@google.com>
    net: add proper RCU protection to /proc/net/ptype

Zubin Mithra <zsm@google.com>
    virt: tdx-guest: Fix handling of host controlled 'quote' buffer length

Yuto Ohnuki <ytohnuki@amazon.com>
    xfs: avoid dereferencing log items after push callbacks

Fei Lv <feilv@asrmicro.com>
    ovl: make fsync after metadata copy-up opt-in mount option

Thorsten Blum <thorsten.blum@linux.dev>
    ovl: Use str_on_off() helper in ovl_show_options()

Benno Lossin <lossin@kernel.org>
    rust: pin-init: internal: init: document load-bearing fact of field accessors

Benno Lossin <lossin@kernel.org>
    rust: pin-init: add references to previously initialized fields

Josh Law <objecting@objecting.org>
    mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]

Richard Leitner <richard.leitner@linux.dev>
    media: nxp: imx8-isi: Fix streaming cleanup on release

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Protect curr_xfer check in IRQ handler

Xi Ruoyao <xry111@xry111.site>
    LoongArch: vDSO: Emit GNU_EH_FRAME correctly

Matthew Auld <matthew.auld@intel.com>
    drm/xe: always keep track of remap prev/next

Luo Haiyang <luo.haiyang@zte.com.cn>
    tracing: Fix potential deadlock in cpu hotplug with osnoise

Steven Rostedt <rostedt@goodmis.org>
    tracing: Switch trace_osnoise.c code over to use guard() and __free()

Werner Kasselman <werner@verivus.com>
    ksmbd: fix use-after-free and NULL deref in smb_grant_oplock()

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

Yuto Ohnuki <ytohnuki@amazon.com>
    ext4: replace BUG_ON with proper error handling in ext4_read_inline_folio

Jan Kara <jack@suse.cz>
    ext4: make recently_deleted() properly work with lazy itable initialization

Jan Kara <jack@suse.cz>
    ext4: fix fsync(2) for nojournal mode

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
    xfs: save ailp before dropping the AIL lock in push callbacks

Yuto Ohnuki <ytohnuki@amazon.com>
    xfs: stop reclaim before pushing AIL during unmount

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: KVM: Make kvm_get_vcpu_by_cpuid() more robust

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Workaround LS2K/LS7A GPU DMA hang bug

Li Jun <lijun01@kylinos.cn>
    LoongArch: Fix missing NULL checks for kstrdup()

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_tunnel: Fix error handling when clearing stream BW in atomic state

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdgpu: prevent immediate PASID reuse case

Claudiu Beznea <claudiu.beznea@tuxon.dev>
    dmaengine: sh: rz-dmac: Move CHCTRL updates under spinlock

Claudiu Beznea <claudiu.beznea@tuxon.dev>
    dmaengine: sh: rz-dmac: Protect the driver specific lists

Joy Zou <joy.zou@nxp.com>
    dmaengine: fsl-edma: fix channel parameter config for fixed channel requests

Davidlohr Bueso <dave@stgolabs.net>
    futex: Clear stale exiting pointer in futex_lock_pi() retry path

Jassi Brar <jassisinghbrar@gmail.com>
    irqchip/qcom-mpm: Add missing mailbox TX done acknowledgment

Milos Nikic <nikic.milos@gmail.com>
    jbd2: gracefully abort on checkpointing state corruptions

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

Abel Vesa <abel.vesa@oss.qualcomm.com>
    phy: qcom: qmp-ufs: Fix SM8650 PCS table for Gear 4

Borislav Petkov (AMD) <bp@alien8.de>
    x86/cpu: Remove X86_CR4_FRED from the CR4 pinned bits mask

Nikunj A Dadhania <nikunj@amd.com>
    x86/cpu: Enable FSGSBASE early in cpu_init_exception_handling()

Zhan Xusheng <zhanxusheng1024@gmail.com>
    alarmtimer: Fix argument order in alarm_timer_forward()

Jiucheng Xu <jiucheng.xu@amlogic.com>
    erofs: add GFP_NOIO in the bio completion if needed

xietangxin <xietangxin@yeah.net>
    virtio_net: Fix UAF on dst_ops when IFF_XMIT_DST_RELEASE is cleared and napi_tx is false

Yuchan Nam <entropy1110@gmail.com>
    media: mc, v4l2: serialize REINIT and REQBUFS with req_queue_mutex

Sanman Pradhan <psanman@juniper.net>
    hwmon: (peci/cputemp) Fix off-by-one in cputemp_is_visible()

Sanman Pradhan <psanman@juniper.net>
    hwmon: (peci/cputemp) Fix crit_hyst returning delta instead of absolute temperature

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/isl68137) Add mutex protection for AVS enable sysfs attributes

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Discard PC update state on vcpu reset

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Correct locked bit width

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: conservative: Reset requested_freq on limits change

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: fix tx.buf use-after-free in isotp_sendmsg()

Ali Norouzi <ali.norouzi@keysight.com>
    can: gw: fix OOB heap access in cgw_csum_crc8_rel()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Allow bytes controls without initial payload

Alexey Nepomnyashih <sdl@nppct.ru>
    ALSA: firewire-lib: fix uninitialized local variable

Hyunwoo Kim <imv4bel@gmail.com>
    ksmbd: do not expire session on binding failure

Werner Kasselman <werner@verivus.com>
    ksmbd: fix memory leaks and NULL deref in smb2_lock()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix potencial OOB in get_file_all_info() for compound requests

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: replace hardcoded hdr2_len with offsetof() in smb2_calc_max_out_buf_len()

Vasily Gorbik <gor@linux.ibm.com>
    s390/entry: Scrub r12 register on kernel entry

Vasily Gorbik <gor@linux.ibm.com>
    s390/barrier: Make array_index_mask_nospec() __always_inline

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    s390/syscalls: Add spectre boundary for syscall dispatch table

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: spi-fsl-lpspi: fix teardown order issue (UAF)

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ASoC: adau1372: Fix clock leak on PLL lock failure

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ASoC: adau1372: Fix unchecked clk_prepare_enable() return value

Marc Buerg <buermarc@googlemail.com>
    sysctl: fix uninitialized variable in proc_do_large_bitmap

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Introduce the concept of "write-only" attributes

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Mark lowest/average/highest/rated attributes as read-only

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/core) Fix various coding style issues

Sanman Pradhan <psanman@juniper.net>
    hwmon: (adm1177) fix sysfs ABI violation and current unit conversion

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix fence put before wait in amdgpu_amdkfd_submit_ib

Weiming Shi <bestswngs@gmail.com>
    ACPI: EC: clean up handlers on probe failure in acpi_ec_setup()

Danilo Krummrich <dakr@kernel.org>
    spi: use generic driver_override infrastructure

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: Group CS related fields in struct spi_device

Yussuf Khalil <dev@pp3345.net>
    drm/amd/display: Do not skip unrelated mode changes in DSC validation

Felix Gu <ustc.gu@gmail.com>
    spi: meson-spicc: Fix double-put in remove path

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: catpt: Fix the device initialization

Felix Gu <ustc.gu@gmail.com>
    spi: sn-f-ospi: Fix resource leak in f_ospi_probe()

Alberto Garcia <berto@igalia.com>
    PM: hibernate: Drain trailing zero pages on userspace restore

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    drm/i915/gmbus: fix spurious timeout on 512-byte burst reads

Mike Rapoport (Microsoft) <rppt@kernel.org>
    x86/efi: efi_unmap_boot_services: fix calculation of ranges_to_free size

Yihang Li <liyihang9@huawei.com>
    scsi: scsi_transport_sas: Fix the maximum channel scanning issue

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

Chuck Lever <chuck.lever@oracle.com>
    RDMA/rw: Fall back to direct SGE on MR pool exhaustion

Sean Rhodes <sean@starlabs.systems>
    ALSA: hda/realtek: Sequence GPIO2 on Star Labs StarFighter

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    regmap: Synchronize cache for the page selector

Paolo Valerio <pvalerio@redhat.com>
    net: macb: use the current queue number for stats

David Carlier <devnexen@gmail.com>
    netfilter: ctnetlink: use netlink policy range checks

Weiming Shi <bestswngs@gmail.com>
    netfilter: nf_conntrack_sip: fix use of uninitialized rtp_addr in process_sdp

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: skip expectations in other netns via proc

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

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: btintel: serialize btintel_hw_error() with hci_req_sync_lock

Zhang Chen <zhangchen01@kylinos.cn>
    Bluetooth: L2CAP: Fix send LE flow credits in ACL link

Miguel Ojeda <ojeda@kernel.org>
    dma-mapping: add missing `inline` for `dma_free_attrs`

Thangaraj Samynathan <thangaraj.s@microchip.com>
    net: lan743x: fix duplex configuration in mac_link_up

Jiayuan Chen <jiayuan.chen@shopee.com>
    team: fix header_ops type confusion with non-Ethernet ports

Wei Fang <wei.fang@nxp.com>
    net: enetc: fix the output issue of 'ethtool --show-ring'

Martin KaFai Lau <martin.lau@kernel.org>
    udp: Fix wildcard bind conflict check when using hash2

Eric Dumazet <edumazet@google.com>
    tcp: optimize inet_use_bhash2_on_bind()

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

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: fix double disable of clk

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: Add support for asp-v3.0

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: fix double free of WoL irq

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: streamline early exit in probe

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: Remove support for asp-v2.0

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: bcm: asp2: convert to phylib managed EEE

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: bcm: asp2: remove tx_lpi_enabled

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: bcm: asp2: fix LPI timer handling

Sabrina Dubroca <sd@queasysnail.net>
    rtnetlink: count IFLA_INFO_SLAVE_KIND in if_nlmsg_size

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

Sabrina Dubroca <sd@queasysnail.net>
    esp: fix skb leak with espintcp and async crypto

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Fix the usage of skb->sk

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

Liucheng Lu <luliucheng100@outlook.com>
    ALSA: hda/realtek: add HP Laptop 14s-dr5xxx mute LED quirk

Boris Burkov <boris@bur.io>
    btrfs: set BTRFS_ROOT_ORPHAN_CLEANUP during subvol create

zhidao su <soolaugust@gmail.com>
    sched_ext: Use WRITE_ONCE() for the write side of dsq->seq update

Günther Noack <gnoack@google.com>
    HID: apple: avoid memory leak in apple_report_fixup()

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Fix u32/s32 bounds when ranges cross min/max boundary

Maarten Lankhorst <dev@lankhorst.se>
    drm/ttm/tests: Fix build failure on PREEMPT_RT

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: hda/senary: Ensure EAPD is enabled during init

Isaac J. Manjarres <isaacmanjarres@google.com>
    dma-buf: Include ioctl.h in UAPI header

Mark Brown <broonie@kernel.org>
    ASoC: fsl_easrc: Fix event generation in fsl_easrc_iec958_put_bits()

Florian Fuchs <fuchsfl@gmail.com>
    scsi: devinfo: Add BLIST_SKIP_IO_HINTS for Iomega ZIP

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

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kbuild: install-extmod-build: Package resolve_btfids if necessary

Valentin Spreckels <valentin@spreckels.dev>
    net: usb: r8152: add TRENDnet TUC-ET2G

Takashi Iwai <tiwai@suse.de>
    HID: apple: Add EPOMAKER TH87 to the non-apple keyboards list

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

Daniel Hodges <hodgesd@meta.com>
    nvme-fabrics: use kfree_sensitive() for DHCHAP secrets

Keith Busch <kbusch@kernel.org>
    nvme-pci: cap queue creation to used queues

Peter Metz <peter.metz@unarin.com>
    platform/x86: intel-hid: Add Dell 14 Plus 2-in-1 to dmi_vgbs_allow_list

Günther Noack <gnoack@google.com>
    HID: asus: avoid memory leak in asus_report_fixup()

Daniel Wade <danjwade95@gmail.com>
    bpf: Fix unsound scalar forking in maybe_fork_scalars() for BPF_OR

Jenny Guanni Qu <qguanni@gmail.com>
    bpf: Fix undefined behavior in interpreter sdiv/smod for INT_MIN

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

Peter Zijlstra <peterz@infradead.org>
    perf: Make sure to use pmu_ctx->pmu for groups

Sachin Kumar <xcyfun@protonmail.com>
    bpf: Fix constant blinding for PROBE_MEM32 stores

Alison Schofield <alison.schofield@intel.com>
    cxl/port: Fix use after free of parent_port in cxl_detach_ep()


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   3 +
 Documentation/filesystems/overlayfs.rst            |  50 +++++
 Documentation/hwmon/adm1177.rst                    |   8 +-
 Documentation/hwmon/peci-cputemp.rst               |  10 +-
 Makefile                                           |   4 +-
 .../boot/dts/freescale/imx8mn-tqma8mqnl-mba8mx.dts |  13 +-
 .../arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi |  22 ++
 arch/arm64/kvm/reset.c                             |  14 ++
 arch/loongarch/include/asm/linkage.h               |  36 ++++
 arch/loongarch/include/asm/sigframe.h              |   9 +
 arch/loongarch/kernel/asm-offsets.c                |   2 +
 arch/loongarch/kernel/env.c                        |   7 +-
 arch/loongarch/kernel/signal.c                     |   6 +-
 arch/loongarch/kvm/vcpu.c                          |   3 +
 arch/loongarch/pci/pci.c                           |  80 +++++++
 arch/loongarch/vdso/Makefile                       |   4 +-
 arch/loongarch/vdso/sigreturn.S                    |   6 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |  23 +-
 arch/s390/include/asm/barrier.h                    |   4 +-
 arch/s390/kernel/entry.S                           |   3 +
 arch/s390/kernel/syscall.c                         |   2 +
 arch/sh/drivers/platform_early.c                   |   4 -
 arch/x86/kernel/cpu/common.c                       |  20 +-
 arch/x86/kvm/mmu/mmu.c                             |  14 +-
 arch/x86/platform/efi/quirks.c                     |   2 +-
 drivers/acpi/ec.c                                  |   2 +
 drivers/base/bus.c                                 |  43 +++-
 drivers/base/core.c                                |   2 +
 drivers/base/dd.c                                  |  60 ++++++
 drivers/base/platform.c                            |  37 +---
 drivers/base/regmap/regmap.c                       |  30 ++-
 drivers/bluetooth/btintel.c                        |  11 +-
 drivers/bluetooth/btusb.c                          |   5 +-
 drivers/bluetooth/hci_ll.c                         |   2 +
 drivers/bus/simple-pm-bus.c                        |   4 +-
 drivers/clk/imx/clk-scu.c                          |   3 +-
 drivers/cpufreq/cpufreq_conservative.c             |  12 ++
 drivers/cpufreq/cpufreq_governor.c                 |   3 +
 drivers/cpufreq/cpufreq_governor.h                 |   1 +
 drivers/cxl/core/hdm.c                             |  25 +--
 drivers/cxl/core/port.c                            |   8 +-
 drivers/dma/dw-edma/dw-hdma-v0-core.c              |   6 +-
 drivers/dma/fsl-edma-main.c                        |  26 +--
 drivers/dma/idxd/cdev.c                            |   8 +-
 drivers/dma/idxd/device.c                          |   7 +-
 drivers/dma/idxd/submit.c                          |   2 +-
 drivers/dma/idxd/sysfs.c                           |   1 +
 drivers/dma/sh/rz-dmac.c                           |  68 +++---
 drivers/dma/xilinx/xdma.c                          |   4 +-
 drivers/dma/xilinx/xilinx_dma.c                    |  46 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c            |  45 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   1 +
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |   5 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   5 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |   1 +
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   4 +-
 drivers/gpu/drm/i915/display/intel_display.c       |   8 +-
 drivers/gpu/drm/i915/display/intel_dp_tunnel.c     |  20 +-
 drivers/gpu/drm/i915/display/intel_dp_tunnel.h     |  11 +-
 drivers/gpu/drm/i915/display/intel_gmbus.c         |   4 +-
 drivers/gpu/drm/ttm/tests/ttm_bo_test.c            |   4 +-
 drivers/gpu/drm/xe/xe_pt.c                         |  12 +-
 drivers/gpu/drm/xe/xe_vm.c                         |  22 +-
 drivers/gpu/drm/xe/xe_vm_types.h                   |   4 +
 drivers/hid/hid-apple.c                            |   7 +-
 drivers/hid/hid-asus.c                             |  18 +-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-magicmouse.c                       |   6 +-
 drivers/hid/hid-mcp2221.c                          |   2 +
 drivers/hwmon/adm1177.c                            |  54 +++--
 drivers/hwmon/axi-fan-control.c                    |   2 +-
 drivers/hwmon/peci/cputemp.c                       |   4 +-
 drivers/hwmon/pmbus/isl68137.c                     |  21 +-
 drivers/hwmon/pmbus/pmbus_core.c                   | 117 +++++++----
 drivers/i3c/master/dw-i3c-master.c                 |   2 +
 drivers/infiniband/core/rw.c                       |  27 ++-
 drivers/infiniband/hw/irdma/cm.c                   |  29 +--
 drivers/infiniband/hw/irdma/utils.c                |   2 -
 drivers/infiniband/hw/irdma/verbs.c                |   9 +-
 drivers/irqchip/irq-qcom-mpm.c                     |   3 +
 drivers/media/mc/mc-request.c                      |   5 +
 .../media/platform/nxp/imx8-isi/imx8-isi-video.c   | 156 +++++---------
 drivers/media/v4l2-core/v4l2-ioctl.c               |   5 +-
 drivers/net/ethernet/broadcom/asp2/bcmasp.c        | 231 +++++++++-----------
 drivers/net/ethernet/broadcom/asp2/bcmasp.h        |  82 ++++----
 .../net/ethernet/broadcom/asp2/bcmasp_ethtool.c    |  75 +------
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   |  38 ++--
 .../net/ethernet/broadcom/asp2/bcmasp_intf_defs.h  |   3 +-
 drivers/net/ethernet/cadence/macb_main.c           |  41 ++--
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   2 +
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  31 ++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  14 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   3 +
 drivers/net/ethernet/intel/ice/ice_ptp.c           |  17 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h           |   5 +
 drivers/net/ethernet/intel/ice/ice_repr.c          |   5 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |  24 ++-
 drivers/net/ethernet/intel/idpf/idpf.h             |   2 -
 drivers/net/ethernet/intel/idpf/idpf_lib.c         | 233 +++++++++++----------
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |  38 ++--
 drivers/net/ethernet/intel/idpf/idpf_txrx.h        |   5 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |   9 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   5 +
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  17 +-
 drivers/net/team/team_core.c                       |  65 +++++-
 drivers/net/usb/r8152.c                            |   1 +
 drivers/net/virtio_net.c                           |   1 +
 drivers/nvme/host/fabrics.c                        |   4 +-
 drivers/nvme/host/pci.c                            |  11 +-
 drivers/nvme/target/admin-cmd.c                    |   2 +-
 drivers/nvme/target/core.c                         |  14 +-
 drivers/nvme/target/nvmet.h                        |   1 +
 drivers/nvme/target/rdma.c                         |   1 +
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c            |   3 +-
 drivers/phy/ti/phy-j721e-wiz.c                     |   2 +
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |   9 +-
 drivers/platform/olpc/olpc-xo175-ec.c              |   2 +-
 drivers/platform/x86/intel/hid.c                   |  23 +-
 .../x86/intel/speed_select_if/isst_tpmi_core.c     |   2 +-
 drivers/platform/x86/touchscreen_dmi.c             |  18 ++
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
 drivers/spi/spi-tegra210-quad.c                    |  20 ++
 drivers/spi/spi.c                                  |  19 +-
 drivers/usb/core/config.c                          |   6 +-
 drivers/usb/core/quirks.c                          |   5 +
 drivers/virt/coco/tdx-guest/tdx-guest.c            |  14 +-
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
 fs/ext4/fast_commit.c                              |  13 +-
 fs/ext4/fsync.c                                    |  16 +-
 fs/ext4/ialloc.c                                   |   6 +
 fs/ext4/inline.c                                   |  10 +-
 fs/ext4/inode.c                                    |  12 ++
 fs/ext4/mballoc.c                                  |  30 +--
 fs/ext4/page-io.c                                  |  10 +-
 fs/ext4/super.c                                    |  16 +-
 fs/ext4/sysfs.c                                    |  10 +-
 fs/jbd2/checkpoint.c                               |  15 +-
 fs/netfs/iterator.c                                |  43 ++++
 fs/overlayfs/copy_up.c                             |   6 +-
 fs/overlayfs/overlayfs.h                           |  21 ++
 fs/overlayfs/ovl_entry.h                           |   7 +-
 fs/overlayfs/params.c                              |  42 +++-
 fs/overlayfs/super.c                               |   2 +-
 fs/overlayfs/util.c                                |   5 +-
 fs/smb/server/oplock.c                             |  72 ++++---
 fs/smb/server/smb2pdu.c                            |  73 +++++--
 fs/xfs/scrub/quota.c                               |   4 +-
 fs/xfs/scrub/trace.h                               |  12 +-
 fs/xfs/xfs_attr_item.c                             |   5 +-
 fs/xfs/xfs_dquot_item.c                            |   9 +-
 fs/xfs/xfs_inode_item.c                            |   9 +-
 fs/xfs/xfs_mount.c                                 |   7 +-
 fs/xfs/xfs_trace.h                                 |  47 +++--
 fs/xfs/xfs_trans_ail.c                             |  26 ++-
 include/linux/device.h                             |  54 +++++
 include/linux/device/bus.h                         |   4 +
 include/linux/dma-mapping.h                        |   4 +-
 include/linux/platform_device.h                    |   5 -
 include/linux/spi/spi.h                            |  42 ++--
 include/linux/usb/quirks.h                         |   3 +
 include/linux/usb/r8152.h                          |   1 +
 include/net/inet_hashtables.h                      |  14 ++
 include/net/ip6_fib.h                              |  21 +-
 include/uapi/linux/dma-buf.h                       |   1 +
 include/uapi/linux/netfilter/nf_conntrack_common.h |   4 +
 kernel/bpf/btf.c                                   |  24 ++-
 kernel/bpf/core.c                                  |  43 +++-
 kernel/bpf/verifier.c                              |  26 ++-
 kernel/dma/swiotlb.c                               |  21 +-
 kernel/events/core.c                               |  19 +-
 kernel/futex/pi.c                                  |   3 +-
 kernel/futex/syscalls.c                            |   8 +
 kernel/module/main.c                               |   7 +
 kernel/power/snapshot.c                            |  11 +
 kernel/sched/ext.c                                 |   2 +-
 kernel/sysctl.c                                    |   2 +-
 kernel/time/alarmtimer.c                           |   2 +-
 kernel/trace/trace_osnoise.c                       |  48 ++---
 mm/damon/sysfs.c                                   |   3 +
 net/bluetooth/l2cap_core.c                         |  34 ++-
 net/bluetooth/l2cap_sock.c                         |   3 +
 net/bluetooth/mgmt.c                               |   2 +-
 net/bluetooth/sco.c                                |  10 +-
 net/can/af_can.c                                   |   4 +-
 net/can/af_can.h                                   |   2 +-
 net/can/gw.c                                       |   6 +-
 net/can/isotp.c                                    |  24 ++-
 net/can/proc.c                                     |   3 +-
 net/core/net-procfs.c                              |  49 +++--
 net/core/rtnetlink.c                               |   9 +-
 net/ipv4/esp4.c                                    |  11 +-
 net/ipv4/inet_connection_sock.c                    |  22 +-
 net/ipv4/udp.c                                     |   2 +-
 net/ipv6/addrconf.c                                |   4 +-
 net/ipv6/esp6.c                                    |  11 +-
 net/ipv6/ip6_fib.c                                 |  15 +-
 net/ipv6/netfilter/ip6t_rt.c                       |   4 +
 net/ipv6/route.c                                   |   2 +-
 net/ipv6/xfrm6_output.c                            |   4 +-
 net/key/af_key.c                                   |  19 +-
 net/netfilter/nf_conntrack_expect.c                |   4 +
 net/netfilter/nf_conntrack_netlink.c               |  16 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  10 +-
 net/netfilter/nf_conntrack_sip.c                   |  14 +-
 net/netfilter/nfnetlink_log.c                      |   8 +-
 net/nfc/nci/core.c                                 |  10 +-
 net/openvswitch/flow_netlink.c                     |   2 +
 net/openvswitch/vport-netdev.c                     |  11 +-
 net/packet/af_packet.c                             |   1 +
 net/smc/smc_rx.c                                   |   9 +-
 net/tls/tls_sw.c                                   |   2 +-
 net/xfrm/xfrm_interface_core.c                     |   2 +-
 net/xfrm/xfrm_nat_keepalive.c                      |   2 +-
 net/xfrm/xfrm_output.c                             |   7 +-
 net/xfrm/xfrm_policy.c                             |   4 +-
 net/xfrm/xfrm_state.c                              |   1 +
 net/xfrm/xfrm_user.c                               |   7 +-
 rust/kernel/init/macros.rs                         | 165 ++++++++++++---
 scripts/package/install-extmod-build               |   4 +
 security/landlock/errata/abi-1.h                   |  16 ++
 security/landlock/fs.c                             |  78 ++++---
 sound/firewire/amdtp-stream.c                      |   2 +-
 sound/pci/hda/patch_realtek.c                      |  41 +++-
 sound/pci/hda/patch_senarytech.c                   |   5 +
 sound/soc/codecs/adau1372.c                        |  34 ++-
 sound/soc/codecs/ak4458.c                          |  13 +-
 sound/soc/fsl/fsl_easrc.c                          |  14 +-
 sound/soc/intel/catpt/device.c                     |  10 +-
 sound/soc/intel/catpt/dsp.c                        |   3 -
 sound/soc/samsung/i2s.c                            |   6 +-
 sound/soc/sof/ipc4-topology.c                      |   2 +-
 tools/objtool/arch/x86/decode.c                    |  68 +++---
 tools/objtool/check.c                              |  14 ++
 .../testing/selftests/bpf/prog_tests/reg_bounds.c  |  62 +++++-
 254 files changed, 2911 insertions(+), 1476 deletions(-)


