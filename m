Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D7A154430;
	Thu, 17 Apr 2025 18:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915138; cv=none; b=f1lJ+dh5CDTgBcWykhb1wQiITcgbZcDDjUIbyD+HQIKxN2CVrTv8aKAw9myJaxUkjx9XVMdAFXBQ7dlELo5m3eM3+q25CrCBYPCR5Y89rBQYuz/e1SmuJR4/AxZnMLY9LzqP66idfIQuDZltF3Jv6zjZp3Z7hbfRdheLuGbidyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915138; c=relaxed/simple;
	bh=UYxOApkzxe2zJtRlPSbVtXNiC2yOdJ2JYZZSXS2c944=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=g05CtgP87AooWkTW774wcy39SJKLoXlXD94jjgohpxlF8e6NPJ7lKEKGQ/f8k57JBKe7GxceT8W3OAkx6D3XVnZ6WPyFBGCqZWO4foW8hiSEI6IGY8te2VzSXpNigBFBlmJd/gFjuF+UUFo+1qZQdc3t+7orpythwoNIj9JVea8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aR9s6NDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aR9s6NDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A63FC4CEE4;
	Thu, 17 Apr 2025 18:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915138;
	bh=UYxOApkzxe2zJtRlPSbVtXNiC2yOdJ2JYZZSXS2c944=;
	h=From:To:Cc:Subject:Date:From;
	b=aR9s6NDeZ+40Bjz0DvNIaNnE6ZFFesfyxDbdrhTwEd+7Bo2KgdpIlCOQN3E4YqHFE
	 mkhROo00UQIQW0fx5XjkKgoVX7Oc4/xww7SbrrP4vdvX+6wzJz8eZ6opHUD9KZ3jQ2
	 AkwMrQIqWoc7rfSbfiwapyLdxj7RgLiEE1a7hvHs=
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
Subject: [PATCH 6.12 000/393] 6.12.24-rc1 review
Date: Thu, 17 Apr 2025 19:46:49 +0200
Message-ID: <20250417175107.546547190@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.24-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.24-rc1
X-KernelTest-Deadline: 2025-04-19T17:51+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.24 release.
There are 393 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 19 Apr 2025 17:49:48 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.24-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.24-rc1

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpumf: Fix double free on error in cpumf_pmu_event_init()

Arseniy Krasnov <avkrasnov@salutedevices.com>
    Bluetooth: hci_uart: Fix another race during initialization

Arnd Bergmann <arnd@arndb.de>
    media: mediatek: vcodec: mark vdec_vp9_slice_map_counts_eob_coef noinline

Nathan Chancellor <nathan@kernel.org>
    kbuild: Add '-fno-builtin-wcslen'

Eder Zulian <ezulian@redhat.com>
    libbpf: Prevent compiler warnings/errors

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    x86/e820: Fix handling of subpage regions when calculating nosave ranges in e820__register_nosave_regions()

Jeff Layton <jlayton@kernel.org>
    nfsd: don't ignore the return code of svc_proc_register()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix CB_GETATTR status fix

Olga Kornievskaia <okorniev@redhat.com>
    NFSD: fix decoding in nfs4_xdr_dec_cb_getattr

Nathan Chancellor <nathan@kernel.org>
    ACPI: platform-profile: Fix CFI violation when accessing sysfs files

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/paravirt: Move halt paravirt calls under CONFIG_PARAVIRT

Yi Liu <yi.l.liu@intel.com>
    iommufd: Fail replace if device has not been attached

Nicolin Chen <nicolinc@nvidia.com>
    iommufd: Make attach_handle generic than fault specific

Douglas Anderson <dianders@chromium.org>
    arm64: errata: Add newer ARM cores to the spectre_bhb_loop_affected() lists

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    thermal/drivers/mediatek/lvts: Disable Stage 3 thermal threshold

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    thermal/drivers/mediatek/lvts: Disable monitor mode during suspend

Cong Liu <liucong2@kylinos.cn>
    selftests: mptcp: fix incorrect fd checks in main_loop

Geliang Tang <geliang@kernel.org>
    selftests: mptcp: close fd_in before returning in main_loop

Jake Hillion <jake@hillion.co.uk>
    sched_ext: create_dsq: Return -EEXIST on duplicate request

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390: Fix linker error when -no-pie option is unavailable

David Hildenbrand <david@redhat.com>
    s390/virtio_ccw: Don't allocate/assign airqs for non-existing queues

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix zpci_bus_is_isolated_vf() for non-VFs

Steven Rostedt <rostedt@goodmis.org>
    ring-buffer: Use flush_kernel_vmap_range() over flush_dcache_folio()

Peter Griffin <peter.griffin@linaro.org>
    pinctrl: samsung: add support for eint_fltcon_offset

Stephan Gerhold <stephan.gerhold@linaro.org>
    pinctrl: qcom: Clear latched interrupt status when changing IRQ type

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    phy: freescale: imx8m-pcie: assert phy reset and perst in power off

Philipp Stanner <phasta@kernel.org>
    PCI: Fix wrong length of devres array

Ma Ke <make24@iscas.ac.cn>
    PCI: Fix reference leak in pci_register_host_bridge()

Ma Ke <make24@iscas.ac.cn>
    PCI: Fix reference leak in pci_alloc_child_bus()

Lukas Wunner <lukas@wunner.de>
    PCI: pciehp: Avoid unnecessary device replacement check

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: j721e: Fix the value of .linkdown_irq_regfield for J784S4

Stanimir Varbanov <svarbanov@suse.de>
    PCI: brcmstb: Fix missing of_node_put() in brcm_pcie_probe()

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix device node refcount leakages in of_irq_init()

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix device node refcount leakage in API irq_of_parse_and_map()

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix device node refcount leakages in of_irq_count()

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix device node refcount leakage in API of_irq_parse_raw()

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix device node refcount leakage in API of_irq_parse_one()

Fedor Pchelkin <pchelkin@ispras.ru>
    ntb: use 64-bit arithmetic for the MSI doorbell mask

Haiyang Zhang <haiyangz@microsoft.com>
    net: mana: Switch to page pool for jumbo frames

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Fix displaying 'irq_type' after 'request_irq' error

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Add a new test for setuid()

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Split signal_scoping_threads tests

Mickaël Salaün <mic@digikod.net>
    landlock: Prepare to add second errata

Mickaël Salaün <mic@digikod.net>
    landlock: Always allow signals between threads of the same process

Mickaël Salaün <mic@digikod.net>
    landlock: Add erratum for TCP fix

Mickaël Salaün <mic@digikod.net>
    landlock: Add the errata interface

Mickaël Salaün <mic@digikod.net>
    landlock: Move code to ease future backports

Tudor Ambarus <tudor.ambarus@linaro.org>
    scsi: ufs: qcom: fix dev reference leaked through of_qcom_ice_get

Sean Christopherson <seanjc@google.com>
    KVM: x86: Acquire SRCU in KVM_GET_MP_STATE to protect guest memory accesses

Sean Christopherson <seanjc@google.com>
    KVM: x86: Explicitly zero-initialize on-stack CPUID unions

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Enable CAP_SPAPR_TCE_VFIO on pSeries KVM guests

Sean Christopherson <seanjc@google.com>
    KVM: Allow building irqbypass.ko as as module when kvm.ko is a module

Joshua Washington <joshwash@google.com>
    gve: handle overflow when reporting TX consumed descriptors

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    gpio: zynq: Fix wakeup source leaks on device unbind

Guixin Liu <kanie@linux.alibaba.com>
    gpio: tegra186: fix resource handling in ACPI probe path

Andy Chiu <andybnac@gmail.com>
    ftrace: Properly merge notrace hashes

zhoumin <teczm@foxmail.com>
    ftrace: Add cond_resched() to ftrace_graph_set_hash()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: coresight: qcom,coresight-tpdm: Fix too many 'reg'

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: coresight: qcom,coresight-tpda: Fix too many 'reg'

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: fix prefetch-vs-suspend race

Jo Van Bulck <jo.vanbulck@kuleuven.be>
    dm-integrity: fix non-constant-time tag verification

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: set ti->error on memory allocation failure

Mikulas Patocka <mpatocka@redhat.com>
    dm-ebs: fix prefetch-vs-suspend race

Alexander Aring <aahringo@redhat.com>
    dlm: fix error if active rsb is not hashed

Alexander Aring <aahringo@redhat.com>
    dlm: fix error if inactive rsb is not hashed

Dionna Glaze <dionnaglaze@google.com>
    crypto: ccp - Fix uAPI definitions of PSP errors

Tom Lendacky <thomas.lendacky@amd.com>
    crypto: ccp - Fix check for the primary ASP device

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: gdsc: Set retain_ff before moving to HW CTRL

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    clk: qcom: gdsc: Capture pm_genpd_add_subdomain result code

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    clk: qcom: gdsc: Release pm subdomains in reverse add order

Ajit Pandey <quic_ajipan@quicinc.com>
    clk: qcom: clk-branch: Fix invert halt status bit check for votable clocks

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    clk: renesas: r9a07g043: Fix HP clock source for RZ/Five

Pali Rohár <pali@kernel.org>
    cifs: Ensure that all non-client-specific reparse points are processed by the server

Roman Smirnov <r.smirnov@omp.ru>
    cifs: fix integer overflow in match_server()

Alexandra Diupina <adiupina@astralinux.ru>
    cifs: avoid NULL pointer dereference in dbg call

Aman <aman1@microsoft.com>
    CIFS: Propagate min offload along with other parameters from primary to secondary channels.

Trevor Woerner <twoerner@gmail.com>
    thermal/drivers/rockchip: Add missing rk3328 mapping entry

Steven Rostedt <rostedt@goodmis.org>
    tracing: Do not add length to print format in synthetic events

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: fprobe events: Fix possible UAF on modules

Roger Pau Monne <roger.pau@citrix.com>
    x86/xen: fix balloon target initialization for PVH dom0

Ricardo Cañuelo Navarro <rcn@igalia.com>
    sctp: detect and prevent references to a freed transport in sendmsg

Jinjiang Tu <tujinjiang@huawei.com>
    mm/hwpoison: introduce folio_contain_hwpoisoned_page() helper

Marc Herbert <Marc.Herbert@linux.intel.com>
    mm/hugetlb: move hugetlb_sysctl_init() to the __init section

Shuai Xue <xueshuai@linux.alibaba.com>
    mm/hwpoison: do not send SIGBUS to processes with recovered clean pages

Peter Xu <peterx@redhat.com>
    mm/userfaultfd: fix release hang over concurrent GUP

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    mm: add missing release barrier on PGDAT_RECLAIM_LOCKED unlock

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm/mremap: correctly handle partial mremap() of VMA starting at 0

Ryan Roberts <ryan.roberts@arm.com>
    mm: fix lazy mmu docs and usage

Jane Chu <jane.chu@oracle.com>
    mm: make page_mapped_in_vma() hugetlb walk aware

David Hildenbrand <david@redhat.com>
    mm/rmap: reject hugetlb folios in folio_make_device_exclusive()

Usama Arif <usamaarif642@gmail.com>
    mm/damon/ops: have damon_get_folio return folio even for tail pages

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix null-ptr-deref by sock_lock_init_class_and_name() and rmmod.

Ryan Roberts <ryan.roberts@arm.com>
    sparc/mm: avoid calling arch_enter/leave_lazy_mmu() in set_ptes

Ryan Roberts <ryan.roberts@arm.com>
    sparc/mm: disable preemption in lazy mmu mode

Sean Christopherson <seanjc@google.com>
    iommu/vt-d: Wire up irq_ack() to irq_move_irq() for posted MSIs

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix possible circular locking dependency

Sean Christopherson <seanjc@google.com>
    iommu/vt-d: Don't clobber posted vCPU IRTE when host IRQ affinity changes

Sean Christopherson <seanjc@google.com>
    iommu/vt-d: Put IRTE back into posted MSI mode if vCPU posting is disabled

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Fix warnings due to dmam_free_coherent()

Nicolin Chen <nicolinc@nvidia.com>
    iommufd: Fix uninitialized rc in iommufd_access_rw()

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix zone finishing with missing devices

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix zone activation with missing devices

Filipe Manana <fdmanana@suse.com>
    btrfs: tests: fix chunk map leak after failure to add it to the tree

Filipe Manana <fdmanana@suse.com>
    btrfs: fix non-empty delayed iputs list on unmount due to compressed write workers

Herve Codina <herve.codina@bootlin.com>
    backlight: led_bl: Hold led_access lock when calling led_sysfs_disable()

Peter Griffin <peter.griffin@linaro.org>
    arm64: dts: exynos: gs101: disable pinctrl_gsacore node

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173: Fix disp-pwm compatible string

Zhenhua Huang <quic_zhenhuah@quicinc.com>
    arm64: mm: Correct the update of max_pfn

Ninad Malwade <nmalwade@nvidia.com>
    arm64: tegra: Remove the Orin NX/Nano suspend key

Keir Fraser <keirf@google.com>
    arm64: mops: Do not dereference src reg for a set operation

Wentao Liang <vulab@iscas.ac.cn>
    mtd: rawnand: Add status chack in r852_ready()

Wentao Liang <vulab@iscas.ac.cn>
    mtd: inftlcore: Add error check for inftl_read_oob()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: only inc MPJoinAckHMacFailure for HMAC failures

Gang Yan <yangang@kylinos.cn>
    mptcp: fix NULL pointer in can_accept_new_subflow

T Pratham <t-pratham@ti.com>
    lib: scatterlist: fix sg_split_phys to preserve original scatterlist offsets

Boqun Feng <boqun.feng@gmail.com>
    locking/lockdep: Decrease nr_unused_locks if lock unused in zap_class()

Kartik Rajput <kkartik@nvidia.com>
    mailbox: tegra-hsp: Define dimensioning masks in SoC data

Chenyuan Yang <chenyuan0y@gmail.com>
    mfd: ene-kb3930: Fix a potential NULL pointer dereference

Abel Vesa <abel.vesa@linaro.org>
    leds: rgb: leds-qcom-lpg: Fix calculation of best period Hi-Res PWMs

Abel Vesa <abel.vesa@linaro.org>
    leds: rgb: leds-qcom-lpg: Fix pwm resolution max for Hi-Res PWMs

Kris Van Hees <kris.van.hees@oracle.com>
    kbuild: exclude .rodata.(cst|str)* when building ranges

Jan Kara <jack@suse.cz>
    jbd2: remove wrong sb->s_sequence check

Manjunatha Venkatesh <manjunatha.venkatesh@nxp.com>
    i3c: Add NULL pointer check in i3c_master_queue_ibi()

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Use readsb helper for reading MDB

Mimi Zohar <zohar@linux.ibm.com>
    ima: limit the number of ToMToU integrity violations

Mimi Zohar <zohar@linux.ibm.com>
    ima: limit the number of open-writers integrity violations

Steve French <stfrench@microsoft.com>
    smb311 client: fix missing tcon check when mounting with linux/posix extensions

Chenyuan Yang <chenyuan0y@gmail.com>
    soc: samsung: exynos-chipid: Add NULL pointer check in exynos_chipid_probe()

Olga Kornievskaia <okorniev@redhat.com>
    svcrdma: do not unregister device for listeners

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    tpm: do not start chip while suspended

Jan Kara <jack@suse.cz>
    udf: Fix inode_getblk() return value

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: Fix oversized null mkey longer than 32bit

Yeongjin Gil <youngjin.gil@samsung.com>
    f2fs: fix to avoid atomicity corruption of atomic file

Artem Sadovnikov <a.sadovnikov@ispras.ru>
    ext4: fix off-by-one error in do_split

Jeff Hugo <quic_jhugo@quicinc.com>
    bus: mhi: host: Fix race between unprepare and queue_buf

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Fix deadlock in ivpu_ms_cleanup()

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Fix warning in ivpu_ipc_send_receive_internal()

Sharan Kumar M <sharweshraajan@gmail.com>
    ALSA: hda/realtek: Enable Mute LED on HP OMEN 16 Laptop xd000xx

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: qdsp6: q6asm-dai: fix q6asm_dai_compr_set_params error path

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qdsp6: q6apm-dai: fix capture pipeline overruns.

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qdsp6: q6apm-dai: set 10 ms period and buffer alignment.

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: q6apm-dai: make use of q6apm_get_hw_pointer

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: q6apm-dai: schedule all available frames to avoid dsp under-runs

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: q6apm: add q6apm_get_hw_pointer helper

Haoxiang Li <haoxiang_li2024@163.com>
    ASoC: codecs: wcd937x: fix a potential memory leak in wcd937x_soc_codec_probe()

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: reject zero sized provided buffers

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/net: fix io_req_post_cqe abuse by send bundle

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/net: fix accept multishot handling

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925: fix the wrong simultaneous cap for MLO

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925: fix the wrong link_idx when a p2p_device is present

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925: fix country count limitation for CLC

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925: ensure wow pattern command align fw format

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    wifi: mac80211: fix integer overflow in hwmp_route_info_get()

Haoxiang Li <haoxiang_li2024@163.com>
    wifi: mt76: Add check for devm_kstrdup()

Alexandre Torgue <alexandre.torgue@foss.st.com>
    clocksource/drivers/stm32-lptimer: Use wakeup capable instead of init wakeup

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    mtd: Replace kcalloc() with devm_kcalloc()

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix internal PHYs for 6320 family

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: workaround RGMII transmit delay erratum for 6320 family

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    mtd: Add check for devm_kcalloc()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: sockopt: fix getting freebind & transparent

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: sockopt: fix getting IPV6_V6ONLY

Jackson.lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Fix timeout while testing 10bit hevc fluster

Jackson.lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Fix a hang after seeking

Jackson.lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Avoid race condition in the interrupt handler

Jackson.lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Fix gray color on screen

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: imx214: Rectify probe error handling related to runtime PM

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: imx219: Rectify runtime PM handling in probe and remove

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: imx319: Rectify runtime PM handling probe and remove

Vikash Garodia <quic_vgarodia@quicinc.com>
    media: venus: hfi_parser: refactor hfi packet parsing logic

Vikash Garodia <quic_vgarodia@quicinc.com>
    media: venus: hfi_parser: add check to avoid out of bound access

Ricardo Ribalda <ribalda@chromium.org>
    media: nuvoton: Fix reference handling of ece_pdev

Ricardo Ribalda <ribalda@chromium.org>
    media: nuvoton: Fix reference handling of ece_node

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: ov7251: Introduce 1 ms delay between regulators and en GPIO

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: ov7251: Set enable GPIO low in probe

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: ccs: Set the device's runtime PM status correctly in probe

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: ccs: Set the device's runtime PM status correctly in remove

Sakari Ailus <sakari.ailus@linux.intel.com>
    Revert "media: imx214: Fix the error handling in imx214_probe()"

Karina Yankevich <k.yankevich@omp.ru>
    media: v4l2-dv-timings: prevent possible overflow in v4l2_detect_gtf()

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: imx219: Adjust PLL settings based on the number of MIPI lanes

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: platform: stm32: Add check for clk_enable()

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: visl: Fix ERANGE error when setting enum controls

Hans de Goede <hdegoede@redhat.com>
    media: hi556: Fix memory leak (on error) in hi556_check_hwcfg()

Murad Masimov <m.masimov@mt-integration.ru>
    media: streamzap: prevent processing IR data on URB failure

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Fix PM related deadlocks in MS IOCTLs

Jonathan McDowell <noodles@meta.com>
    tpm, tpm_tis: Fix timeout handling when waiting for TPM status

Kamal Dasu <kamal.dasu@broadcom.com>
    mtd: rawnand: brcmnand: fix PM resume warning

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: cadence-qspi: Fix probe on AM62A LP SK

Will Deacon <will@kernel.org>
    KVM: arm64: Tear down vGIC on failed vCPU creation

Douglas Anderson <dianders@chromium.org>
    arm64: errata: Add KRYO 2XX/3XX/4XX silver cores to Spectre BHB safe list

Douglas Anderson <dianders@chromium.org>
    arm64: errata: Assume that unknown CPUs _are_ vulnerable to Spectre BHB

Douglas Anderson <dianders@chromium.org>
    arm64: errata: Add QCOM_KRYO_4XX_GOLD to the spectre_bhb_k24_list

Douglas Anderson <dianders@chromium.org>
    arm64: cputype: Add MIDR_CORTEX_A76AE

Jan Beulich <jbeulich@suse.com>
    xenfs/xensyms: respect hypervisor's "next" indication

John Keeping <jkeeping@inmusicbrands.com>
    media: rockchip: rga: fix rga offset lookup

Yuan Can <yuancan@huawei.com>
    media: siano: Fix error handling in smsdvb_module_init()

Matthew Majewski <mattwmajewski@gmail.com>
    media: vim2m: print device name after registering device

Vikash Garodia <quic_vgarodia@quicinc.com>
    media: venus: hfi: add check to handle incorrect queue size

Vikash Garodia <quic_vgarodia@quicinc.com>
    media: venus: hfi: add a check to handle OOB in sfr region

Bingbu Cao <bingbu.cao@intel.com>
    media: intel/ipu6: set the dev_parent of video device to pdev

Martin Tůma <martin.tuma@digiteqautomotive.com>
    media: mgb4: Fix switched CMT frequency range "magic values" sets

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: i2c: adv748x: Fix test pattern selection mask

Martin Tůma <martin.tuma@digiteqautomotive.com>
    media: mgb4: Fix CMT registers update logic

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: uapi: rkisp1-config: Fix typo in extensible params example

Arnd Bergmann <arnd@arndb.de>
    media: mtk-vcodec: venc: avoid -Wenum-compare-conditional warning

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: mediatek: vcodec: Fix a resource leak related to the scp device in FW initialization

Alain Volmat <alain.volmat@foss.st.com>
    dt-bindings: media: st,stmipid02: correct lane-polarities maxItems

Haoxiang Li <haoxiang_li2024@163.com>
    auxdisplay: hd44780: Fix an API misuse in hd44780.c

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Fix set_device_control()

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Fix 90 degrees direction name North -> East

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Compute INFINITE value instead of using hardcoded 0xffff

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Clamp effect playback LOOP_COUNT value

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Rename two functions to align them with naming convention

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Remove redundant call to pidff_find_special_keys

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Support device error response from PID_BLOCK_LOAD

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Comment and code style update

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: hid-universal-pidff: Add Asetek wheelbases support

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Make sure to fetch pool before checking SIMULTANEOUS_MAX

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Factor out pool report fetch and remove excess declaration

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Use macros instead of hardcoded min/max values for shorts

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Simplify pidff_rescale_signed

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Move all hid-pidff definitions to a dedicated header

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Factor out code for setting gain

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Rescale time values to match field units

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Define values used in pidff_find_special_fields

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Simplify pidff_upload_effect function

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Completely rework and fix pidff_reset function

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Stop all effects before enabling actuators

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Clamp PERIODIC effect period to device's logical range

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix s390_mmio_read/write syscall page fault handling

Jann Horn <jannh@google.com>
    ext4: don't treat fhandle lookup of ea_inode as FS corruption

Willem de Bruijn <willemb@google.com>
    bpf: support SKF_NET_OFF and SKF_LL_OFF on skb frags

Sheng Yong <shengyong1@xiaomi.com>
    erofs: set error to bio if file-backed IO fails

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: fsl-ftm: Handle clk_get_rate() returning 0

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: rcar: Improve register calculation

Josh Poimboeuf <jpoimboe@kernel.org>
    pwm: mediatek: Prevent divide-by-zero in pwm_mediatek_config()

Jonathan McDowell <noodles@meta.com>
    tpm: End any active auth session before shutdown

Jonathan McDowell <noodles@meta.com>
    tpm, tpm_tis: Workaround failed command reception on Infineon devices

Ayush Jain <Ayush.jain3@amd.com>
    ktest: Fix Test Failures Due to Missing LOG_FILE Directories

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: probe-events: Add comments about entry data storing code

Leonid Arapov <arapovl839@gmail.com>
    fbdev: omapfb: Add 'plane' value check

Christian König <christian.koenig@amd.com>
    drm/amdgpu: grab an additional reference on the gang fence v2

Ryo Takakura <ryotkkr98@gmail.com>
    PCI: vmd: Make vmd_dev::cfg_lock a raw_spinlock_t type

Philipp Stanner <phasta@kernel.org>
    PCI: Check BAR index for validity

Emily Deng <Emily.Deng@amd.com>
    drm/amdgpu: Fix the race condition for draining retry fault

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Enable Configuration RRS SV early

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu: handle amdgpu_cgs_create_device() errors in amd_powerplay_create()

Shawn Lin <shawn.lin@rock-chips.com>
    PCI: Add Rockchip Vendor ID

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_dpi: Explicitly manage TVD clock in power on/off

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_dpi: Move the input_2p_en bit to platform data

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/xe/xelp: Move Wa_16011163337 from tunings to workarounds

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: debugfs hang_hws skip GPU with MES

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Fix pqm_destroy_queue race with GPU reset

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Fix mode1 reset crash issue

David Yat Sin <David.YatSin@amd.com>
    drm/amdkfd: clamp queue size to minimum

Lucas De Marchi <lucas.demarchi@intel.com>
    drivers: base: devres: Allow to release group on device release

Mike Katsnelson <mike.katsnelson@amd.com>
    drm/amd/display: stop DML2 from removing pipes based on planes

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/bridge: panel: forbid initializing a panel with unknown connector type

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/debugfs: fix printk format for bridge index

Andrew Wyatt <fewtarius@steamfork.org>
    drm: panel-orientation-quirks: Add quirk for OneXPlayer Mini (Intel)

Andrew Wyatt <fewtarius@steamfork.org>
    drm: panel-orientation-quirks: Add new quirk for GPD Win 2

Andrew Wyatt <fewtarius@steamfork.org>
    drm: panel-orientation-quirks: Add quirk for AYA NEO Slide

Andrew Wyatt <fewtarius@steamfork.org>
    drm: panel-orientation-quirks: Add quirks for AYA NEO Flip DS and KB

Andrew Wyatt <fewtarius@steamfork.org>
    drm: panel-orientation-quirks: Add support for AYANEO 2S

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: Unlocked unmap only clear page table leaves

Zhikai Zhai <zhikai.zhai@amd.com>
    drm/amd/display: Update Cursor request mode to the beginning prefetch always

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/vf: Don't try to trigger a full GT reset if VF

Shekhar Chauhan <shekhar.chauhan@intel.com>
    drm/xe/bmg: Add new PCI IDs

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm: allow encoder mode_set even when connectors change for crtc

Pedro Nishiyama <nishiyama.pedro@gmail.com>
    Bluetooth: Add quirk for broken READ_PAGE_SCAN_TYPE

Pedro Nishiyama <nishiyama.pedro@gmail.com>
    Bluetooth: Add quirk for broken READ_VOICE_SETTING

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    Bluetooth: qca: simplify WCN399x NVM loading

Janaki Ramaiah Thota <quic_janathot@quicinc.com>
    Bluetooth: hci_qca: use the power sequencer for wcn6750

Jiande Lu <jiande.lu@mediatek.com>
    Bluetooth: btusb: Add 2 HWIDs for MT7922

Arseniy Krasnov <avkrasnov@salutedevices.com>
    Bluetooth: hci_uart: fix race during initialization

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Add device id of Whale Peak

Gabriele Paoloni <gpaoloni@redhat.com>
    tracing: fix return value in __ftrace_event_enable_disable for TRACE_REG_UNREGISTER

Stanislav Fomichev <sdf@fomichev.me>
    net: vlan: don't propagate flags on open

Icenowy Zheng <uwu@icenowy.me>
    wifi: mt76: mt76x2u: add TP-Link TL-WDN6200 ID to device table

Boris Burkov <boris@bur.io>
    btrfs: harden block_group::bg_list against list_del() races

Huacai Chen <chenhuacai@kernel.org>
    ahci: Marvell 88SE9215 controllers prefer DMA for ATAPI

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Fix array overflow in st_setup()

Philipp Hahn <phahn-oss@avm.de>
    cdc_ether|r8152: ThinkPad Hybrid USB-C/A Dock quirk

Bhupesh <bhupesh@igalia.com>
    ext4: ignore xattrs past end

Chao Yu <chao@kernel.org>
    Revert "f2fs: rebuild nat_bits during umount"

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: protect ext4_release_dquot against freezing

Daniel Kral <d.kral@proxmox.com>
    ahci: add PCI ID for Marvell 88SE9215 SATA Controller

Martin Schiller <ms@dev.tdt.de>
    net: sfp: add quirk for FS SFP-10GM-T copper SFP+ module

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid out-of-bounds access in f2fs_truncate_inode_blocks()

Manish Dharanenthiran <quic_mdharane@quicinc.com>
    wifi: ath12k: Fix invalid data access in ath12k_dp_rx_h_undecap_nwifi

Birger Koblitz <mail@birger-koblitz.de>
    net: sfp: add quirk for 2.5G OEM BX SFP

Niklas Cassel <cassel@kernel.org>
    ata: libata-eh: Do not use ATAPI DMA for a device limited to PIO mode

Edward Adam Davis <eadavis@qq.com>
    jfs: add sanity check for agwidth in dbMount

Edward Adam Davis <eadavis@qq.com>
    jfs: Prevent copying of nlink with value 0 from disk inode

Rand Deeb <rand.sec96@gmail.com>
    fs/jfs: Prevent integer overflow in AG size calculation

Rand Deeb <rand.sec96@gmail.com>
    fs/jfs: cast inactags to s64 to prevent potential overflow

Zhongqiu Han <quic_zhonhan@quicinc.com>
    jfs: Fix uninit-value access of imap allocated in the diMount() function

Ciprian Marian Costea <ciprianmarian.costea@oss.nxp.com>
    can: flexcan: add NXP S32G2/S32G3 SoC support

Ciprian Marian Costea <ciprianmarian.costea@oss.nxp.com>
    can: flexcan: Add quirk to handle separate interrupt lines for mailboxes

Jason Xing <kerneljasonxing@gmail.com>
    page_pool: avoid infinite loop to schedule delayed worker

Max Schulze <max.schulze@online.de>
    net: usb: asix_devices: add FiberGecko DeviceID

Chaohai Chen <wdhh66@163.com>
    scsi: target: spc: Fix RSOC parameter data header size

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: ensure sdata->work is canceled before initialized.

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: add strict mode disabling workarounds

Chao Yu <chao@kernel.org>
    f2fs: don't retry IO for corrupted data scenario

Pavel Begunkov <asml.silence@gmail.com>
    net: page_pool: don't cast mp param to devmem

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Synchronous access b/w reset and tm thread for reply queue

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Avoid reply queue full condition

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Add 'external' to the libata.force kernel parameter

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process

Miaoqing Pan <quic_miaoqing@quicinc.com>
    wifi: ath12k: fix memory leak in ath12k_pci_remove()

Miaoqing Pan <quic_miaoqing@quicinc.com>
    wifi: ath11k: fix memory leak in ath11k_xxx_remove()

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath11k: Fix DMA buffer allocation to resolve SWIOTLB issues

Hans de Goede <hdegoede@redhat.com>
    platform/x86: x86-android-tablets: Add select POWER_SUPPLY to Kconfig

Syed Saba kareem <syed.sabakareem@amd.com>
    ASoC: amd: yc: update quirk data for new Lenovo model

keenplify <keenplify@gmail.com>
    ASoC: amd: Add DMI quirk for ACP6X mic support

Ricard Wanderlof <ricard2013@butoba.net>
    ALSA: usb-audio: Fix CME quirk for UF series keyboards

Kaustabh Chakraborty <kauschluss@disroot.org>
    mmc: dw_mmc: add a quirk for accessing 64-bit FIFOs in two halves

Aakarsh Jain <aakarsh.jain@samsung.com>
    media: s5p-mfc: Corrected NV12M/NV21M plane-sizes

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Add quirk for Actions UVC05

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_audmix: register card device depends on 'dais' property

Maxim Mikityanskiy <maxtram95@gmail.com>
    ALSA: hda: intel: Add Lenovo IdeaPad Z570 to probe denylist

Maxim Mikityanskiy <maxtram95@gmail.com>
    ALSA: hda: intel: Fix Optimus when GPU has no sound

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: ps: use macro for ACP6.3 pci revision id

Tomasz Pakuła <forest10pl@gmail.com>
    HID: pidff: Fix null pointer dereference in pidff_find_fields

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Add PERIODIC_SINE_ONLY quirk

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: Add hid-universal-pidff driver and supported device ids

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Add FIX_WHEEL_DIRECTION quirk

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Add hid_pidff_init_with_quirks and export as GPL symbol

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Add PERMISSIVE_CONTROL quirk

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Add MISSING_PBO quirk and its detection

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Add MISSING_DELAY quirk and its detection

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Do not send effect envelope if it's empty

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Convert infinite length from Linux API to PID standard

Zhang Heng <zhangheng@kylinos.cn>
    ASoC: SOF: topology: Use krealloc_array() to replace krealloc()

Daniel Schaefer <dhs@frame.work>
    platform/chrome: cros_ec_lpc: Match on Framework ACPI device

Ingo Molnar <mingo@kernel.org>
    zstd: Increase DYNAMIC_BMI2 GCC version cutoff from 4.8 to 11.0 to work around compiler segfault

Kees Cook <kees@kernel.org>
    xen/mcelog: Add __nonstring annotations for unterminated strings

Douglas Anderson <dianders@chromium.org>
    arm64: cputype: Add QCOM_CPU_PART_KRYO_3XX_GOLD

Paul E. McKenney <paulmck@kernel.org>
    Flush console log from kernel_power_off()

Lizhi Xu <lizhi.xu@windriver.com>
    PM: hibernate: Avoid deadlock in hibernate_compressor_param_set()

Yunhui Cui <cuiyunhui@bytedance.com>
    perf/dwc_pcie: fix some unreleased resources

Mark Rutland <mark.rutland@arm.com>
    perf: arm_pmu: Don't disable counter in armpmu_add()

Max Grobecker <max@grobecker.info>
    x86/cpu: Don't clear X86_FEATURE_LAHF_LM flag in init_amd_k8() on AMD when running in a virtual machine

Xin Li (Intel) <xin@zytor.com>
    x86/ia32: Leave NULL selector values 0~3 unchanged

Uros Bizjak <ubizjak@gmail.com>
    x86/percpu: Disable named address spaces for UBSAN_BOOL with KASAN for GCC < 14.2

Matthew Wilcox (Oracle) <willy@infradead.org>
    x86/mm: Clear _PAGE_DIRTY for kernel mappings when we clear _PAGE_RW

Zhongqiu Han <quic_zhonhan@quicinc.com>
    pm: cpupower: bench: Prevent NULL dereference on malloc failure

Trond Myklebust <trond.myklebust@hammerspace.com>
    umount: Allow superblock owners to force umount

Mateusz Guzik <mjguzik@gmail.com>
    fs: consistently deref the files table with rcu_dereference_raw()

Frederic Weisbecker <frederic@kernel.org>
    perf: Fix hang while freeing sigtrap event

Peter Zijlstra <peterz@infradead.org>
    perf/core: Simplify the perf_event_alloc() error path

Adrian Hunter <adrian.hunter@intel.com>
    perf/core: Add aux_pause, aux_resume, aux_start_paused

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    iommu/mediatek: Fix NULL pointer deference in mtk_iommu_device_group

Marek Szyprowski <m.szyprowski@samsung.com>
    iommu/exynos: Fix suspend/resume with IDENTITY domain

Florian Westphal <fw@strlen.de>
    nft_set_pipapo: fix incorrect avx2 match of 5th field octet

Arnaud Lecomte <contact@arnaud-lcm.com>
    net: ppp: Add bound checking for skb data on ppp_sync_txmung

Ido Schimmel <idosch@nvidia.com>
    ipv6: Align behavior across nexthops during path selection

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phy: allow MDIO bus PM ops to start/stop state machine for phylink-controlled PHY

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phy: move phy_link_change() prior to mdio_bus_phy_may_suspend()

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix UAF in decryption with multichannel

Octavian Purdila <tavip@google.com>
    net_sched: sch_sfq: move the limit validation

Octavian Purdila <tavip@google.com>
    net_sched: sch_sfq: use a temporary work area for validating configuration

Daniel Wagner <wagi@kernel.org>
    nvmet-fcloop: swap list_add_tail arguments

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915/huc: Fix fence not released on early probe errors

Wentao Liang <vulab@iscas.ac.cn>
    ata: sata_sx4: Add error handling in pdc20621_i2c_read()

Chenyuan Yang <chenyuan0y@gmail.com>
    net: libwx: handle page_pool_dev_alloc_pages error

Maxime Ripard <mripard@kernel.org>
    drm/tests: probe-helper: Fix drm_display_mode memory leak

Maxime Ripard <mripard@kernel.org>
    drm/tests: modes: Fix drm_display_mode memory leak

Maxime Ripard <mripard@kernel.org>
    drm/tests: cmdline: Fix drm_display_mode memory leak

Maxime Ripard <mripard@kernel.org>
    drm/tests: helpers: Create kunit helper to destroy a drm_display_mode

Maxime Ripard <mripard@kernel.org>
    drm/tests: modeset: Fix drm_display_mode memory leak

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: ethtool: Don't call .cleanup_data when prepare_data fails

Toke Høiland-Jørgensen <toke@redhat.com>
    tc: Ensure we have enough buffer space when sending filter netlink notifications

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-pf: qos: fix VF root node parent queue index

Jakub Kicinski <kuba@kernel.org>
    net: tls: explicitly disallow disconnect

Cong Wang <xiyou.wangcong@gmail.com>
    codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: fix memory leak in tipc_link_xmit

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Fix INSN_CONTEXT_SWITCH handling in validate_unret()

Henry Martin <bsdhenrymartin@gmail.com>
    ata: pata_pxa: Fix potential NULL pointer dereference in pxa_ata_probe()

Tejas Upadhyay <tejas.upadhyay@intel.com>
    drm/xe/hw_engine: define sysfs_ops on all directories

Petr Vaněk <arkamar@atlas.cz>
    x86/acpi: Don't limit CPUs to 1 for Xen PV guests due to disabled ACPI

Badal Nilawar <badal.nilawar@intel.com>
    drm/i915: Disable RPG during live selftest

Ming Lei <ming.lei@redhat.com>
    ublk: fix handling recovery & reissue in ublk_abort_queue()

Uday Shankar <ushankar@purestorage.com>
    ublk: refactor recovery configuration flag helpers

Edward Liaw <edliaw@google.com>
    selftests/futex: futex_waitv wouldblock test should fail

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: of: Fix the choice for Ingenic NAND quirk

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix race between newly created partition and dying one

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Further optimize code if CONFIG_CPUSETS_V1 not set

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Enforce at most one rebuild_sched_domains_locked() call per operation

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Revert "Allow suppression of sched domain rebuild in update_cpumasks_hier()"

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix error handling in remote_partition_disable()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix incorrect isolated_cpus update in update_parent_effective_cpumask()

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: Intel: adl: add 2xrt1316 audio configuration


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   2 +
 .../bindings/arm/qcom,coresight-tpda.yaml          |   3 +-
 .../bindings/arm/qcom,coresight-tpdm.yaml          |   3 +-
 .../bindings/media/i2c/st,st-mipid02.yaml          |   2 +-
 Makefile                                           |   7 +-
 arch/arm64/boot/dts/exynos/google/gs101.dtsi       |   1 +
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   6 +-
 .../boot/dts/nvidia/tegra234-p3768-0000+p3767.dtsi |   7 -
 arch/arm64/include/asm/cputype.h                   |   4 +
 arch/arm64/include/asm/spectre.h                   |   1 -
 arch/arm64/include/asm/traps.h                     |   4 +-
 arch/arm64/kernel/proton-pack.c                    | 208 ++++----
 arch/arm64/kvm/arm.c                               |   6 +-
 arch/arm64/mm/mmu.c                                |   3 +-
 arch/powerpc/kvm/powerpc.c                         |   5 +-
 arch/s390/Makefile                                 |   2 +-
 arch/s390/kernel/perf_cpum_cf.c                    |   9 +-
 arch/s390/kernel/perf_cpum_sf.c                    |   3 -
 arch/s390/pci/pci_bus.c                            |   3 +
 arch/s390/pci/pci_mmio.c                           |  18 +-
 arch/sparc/include/asm/pgtable_64.h                |   2 -
 arch/sparc/mm/tlb.c                                |   5 +-
 arch/x86/Kconfig                                   |  20 +-
 arch/x86/include/asm/irqflags.h                    |  40 +-
 arch/x86/include/asm/paravirt.h                    |  20 +-
 arch/x86/include/asm/paravirt_types.h              |   3 +-
 arch/x86/kernel/acpi/boot.c                        |  11 +
 arch/x86/kernel/cpu/amd.c                          |   2 +-
 arch/x86/kernel/e820.c                             |  17 +-
 arch/x86/kernel/paravirt.c                         |  13 +-
 arch/x86/kernel/signal_32.c                        |  62 ++-
 arch/x86/kvm/cpuid.c                               |   8 +-
 arch/x86/kvm/x86.c                                 |   4 +
 arch/x86/mm/pat/set_memory.c                       |   6 +-
 arch/x86/xen/enlighten.c                           |  10 +
 arch/x86/xen/setup.c                               |   3 -
 drivers/accel/ivpu/ivpu_debugfs.c                  |   4 +-
 drivers/accel/ivpu/ivpu_ipc.c                      |   3 +-
 drivers/accel/ivpu/ivpu_ms.c                       |  24 +
 drivers/acpi/platform_profile.c                    |  20 +-
 drivers/ata/ahci.c                                 |  11 +
 drivers/ata/ahci.h                                 |   1 +
 drivers/ata/libahci.c                              |   4 +
 drivers/ata/libata-core.c                          |  38 ++
 drivers/ata/libata-eh.c                            |  11 +-
 drivers/ata/pata_pxa.c                             |   6 +
 drivers/ata/sata_sx4.c                             |  13 +-
 drivers/auxdisplay/hd44780.c                       |   4 +-
 drivers/base/devres.c                              |   7 +
 drivers/block/ublk_drv.c                           |  90 +++-
 drivers/bluetooth/btintel_pcie.c                   |   1 +
 drivers/bluetooth/btqca.c                          |  13 +-
 drivers/bluetooth/btusb.c                          |   4 +
 drivers/bluetooth/hci_ldisc.c                      |  19 +-
 drivers/bluetooth/hci_qca.c                        |   2 +-
 drivers/bluetooth/hci_uart.h                       |   1 +
 drivers/bus/mhi/host/main.c                        |  16 +-
 drivers/char/tpm/tpm-chip.c                        |   6 +
 drivers/char/tpm/tpm-interface.c                   |   7 -
 drivers/char/tpm/tpm_tis_core.c                    |  20 +-
 drivers/char/tpm/tpm_tis_core.h                    |   1 +
 drivers/clk/qcom/clk-branch.c                      |   4 +-
 drivers/clk/qcom/gdsc.c                            |  61 ++-
 drivers/clk/renesas/r9a07g043-cpg.c                |   7 +
 drivers/clocksource/timer-stm32-lp.c               |   4 +-
 drivers/crypto/ccp/sp-pci.c                        |  15 +-
 drivers/gpio/gpio-tegra186.c                       |  25 +-
 drivers/gpio/gpio-zynq.c                           |   1 +
 drivers/gpio/gpiolib-of.c                          |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   4 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h             |   4 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c          |  43 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  10 +
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   5 +
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  17 +
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |  31 +-
 .../amd/display/dc/dml2/dml2_dc_resource_mgmt.c    |  26 -
 .../gpu/drm/amd/display/dc/hubp/dcn31/dcn31_hubp.c |   2 +-
 .../drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c    |  22 +-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |   5 +
 drivers/gpu/drm/drm_atomic_helper.c                |   2 +-
 drivers/gpu/drm/drm_debugfs.c                      |   2 +-
 drivers/gpu/drm/drm_panel.c                        |   5 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  46 +-
 drivers/gpu/drm/i915/gt/intel_rc6.c                |  19 +-
 drivers/gpu/drm/i915/gt/uc/intel_huc.c             |  11 +-
 drivers/gpu/drm/i915/gt/uc/intel_huc.h             |   1 +
 drivers/gpu/drm/i915/gt/uc/intel_uc.c              |   1 +
 drivers/gpu/drm/i915/selftests/i915_selftest.c     |  18 +
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |  23 +-
 drivers/gpu/drm/tests/drm_client_modeset_test.c    |   3 +
 drivers/gpu/drm/tests/drm_cmdline_parser_test.c    |  10 +-
 drivers/gpu/drm/tests/drm_kunit_helpers.c          |  22 +
 drivers/gpu/drm/tests/drm_modes_test.c             |  22 +
 drivers/gpu/drm/tests/drm_probe_helper_test.c      |   8 +-
 drivers/gpu/drm/xe/xe_gt.c                         |   4 +
 drivers/gpu/drm/xe/xe_gt_sriov_vf.c                |  16 +
 drivers/gpu/drm/xe/xe_gt_sriov_vf.h                |   1 +
 drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c      | 108 ++--
 drivers/gpu/drm/xe/xe_tuning.c                     |   8 -
 drivers/gpu/drm/xe/xe_wa.c                         |   7 +
 drivers/hid/Kconfig                                |  14 +
 drivers/hid/Makefile                               |   1 +
 drivers/hid/hid-ids.h                              |  37 ++
 drivers/hid/hid-universal-pidff.c                  | 202 ++++++++
 drivers/hid/usbhid/hid-core.c                      |   1 +
 drivers/hid/usbhid/hid-pidff.c                     | 571 ++++++++++++++-------
 drivers/hid/usbhid/hid-pidff.h                     |  33 ++
 drivers/i3c/master.c                               |   3 +
 drivers/i3c/master/svc-i3c-master.c                |   2 +-
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c     |  32 +-
 drivers/iommu/exynos-iommu.c                       |   4 +-
 drivers/iommu/intel/iommu.c                        |   2 +
 drivers/iommu/intel/irq_remapping.c                |  71 +--
 drivers/iommu/iommufd/device.c                     | 123 ++++-
 drivers/iommu/iommufd/fault.c                      |   8 +-
 drivers/iommu/iommufd/iommufd_private.h            |  33 +-
 drivers/iommu/mtk_iommu.c                          |  26 +-
 drivers/leds/rgb/leds-qcom-lpg.c                   |   8 +-
 drivers/mailbox/tegra-hsp.c                        |  72 ++-
 drivers/md/dm-ebs-target.c                         |   7 +
 drivers/md/dm-integrity.c                          |  48 +-
 drivers/md/dm-verity-target.c                      |   8 +
 drivers/media/common/siano/smsdvb-main.c           |   2 +
 drivers/media/i2c/adv748x/adv748x.h                |   2 +-
 drivers/media/i2c/ccs/ccs-core.c                   |   6 +-
 drivers/media/i2c/hi556.c                          |   5 +-
 drivers/media/i2c/imx214.c                         |  25 +-
 drivers/media/i2c/imx219.c                         | 106 ++--
 drivers/media/i2c/imx319.c                         |   9 +-
 drivers/media/i2c/ov7251.c                         |   4 +-
 drivers/media/pci/intel/ipu6/ipu6-isys-video.c     |   1 +
 drivers/media/pci/mgb4/mgb4_cmt.c                  |   8 +-
 .../media/platform/chips-media/wave5/wave5-hw.c    |   2 +-
 .../platform/chips-media/wave5/wave5-vpu-dec.c     |  31 +-
 .../media/platform/chips-media/wave5/wave5-vpu.c   |   4 +-
 .../platform/chips-media/wave5/wave5-vpuapi.c      |  10 +
 .../mediatek/vcodec/common/mtk_vcodec_fw_scp.c     |   5 +-
 .../vcodec/decoder/vdec/vdec_vp9_req_lat_if.c      |   3 +-
 .../mediatek/vcodec/encoder/venc/venc_h264_if.c    |   6 +-
 drivers/media/platform/nuvoton/npcm-video.c        |   6 +-
 drivers/media/platform/qcom/venus/hfi_parser.c     | 100 +++-
 drivers/media/platform/qcom/venus/hfi_venus.c      |  18 +-
 drivers/media/platform/rockchip/rga/rga-hw.c       |   2 +-
 .../platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c      |   5 +-
 drivers/media/platform/st/stm32/dma2d/dma2d.c      |   3 +-
 drivers/media/rc/streamzap.c                       |  68 +--
 drivers/media/test-drivers/vim2m.c                 |   6 +-
 drivers/media/test-drivers/visl/visl-core.c        |  12 +
 drivers/media/usb/uvc/uvc_driver.c                 |   9 +
 drivers/media/v4l2-core/v4l2-dv-timings.c          |   4 +-
 drivers/mfd/ene-kb3930.c                           |   2 +-
 drivers/misc/pci_endpoint_test.c                   |   3 +-
 drivers/mmc/host/dw_mmc.c                          |  94 +++-
 drivers/mmc/host/dw_mmc.h                          |  27 +
 drivers/mtd/inftlcore.c                            |   9 +-
 drivers/mtd/mtdpstore.c                            |  12 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   2 +-
 drivers/mtd/nand/raw/r852.c                        |   3 +
 drivers/net/can/flexcan/flexcan-core.c             |  35 +-
 drivers/net/can/flexcan/flexcan.h                  |   5 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |  23 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c      |   4 +-
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c   |   5 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  46 +-
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |   3 +-
 drivers/net/phy/phy_device.c                       |  57 +-
 drivers/net/phy/sfp.c                              |  13 +-
 drivers/net/ppp/ppp_synctty.c                      |   5 +
 drivers/net/usb/asix_devices.c                     |  17 +
 drivers/net/usb/cdc_ether.c                        |   7 +
 drivers/net/usb/r8152.c                            |   6 +
 drivers/net/usb/r8153_ecm.c                        |   6 +
 drivers/net/wireless/ath/ath11k/ahb.c              |   4 +-
 drivers/net/wireless/ath/ath11k/core.c             |   3 +-
 drivers/net/wireless/ath/ath11k/dp.c               |  35 +-
 drivers/net/wireless/ath/ath11k/fw.c               |   3 +-
 drivers/net/wireless/ath/ath11k/pci.c              |   3 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c           |   2 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |  42 +-
 drivers/net/wireless/ath/ath12k/pci.c              |   1 +
 drivers/net/wireless/mediatek/mt76/eeprom.c        |   4 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |   1 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |  16 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.h    |   4 +-
 drivers/ntb/ntb_transport.c                        |   2 +-
 drivers/nvme/target/fcloop.c                       |   2 +-
 drivers/of/irq.c                                   |  78 +--
 drivers/pci/controller/cadence/pci-j721e.c         |   5 +-
 drivers/pci/controller/pcie-brcmstb.c              |  13 +-
 drivers/pci/controller/pcie-rockchip-host.c        |   2 +-
 drivers/pci/controller/pcie-rockchip.h             |   1 -
 drivers/pci/controller/vmd.c                       |  12 +-
 drivers/pci/devres.c                               |  18 +-
 drivers/pci/hotplug/pciehp_core.c                  |   5 +-
 drivers/pci/iomap.c                                |  29 +-
 drivers/pci/pci.c                                  |   6 +
 drivers/pci/pci.h                                  |  16 +
 drivers/pci/probe.c                                |  22 +-
 drivers/perf/arm_pmu.c                             |   8 +-
 drivers/perf/dwc_pcie_pmu.c                        |  33 +-
 drivers/phy/freescale/phy-fsl-imx8m-pcie.c         |  11 +
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  12 +-
 drivers/pinctrl/samsung/pinctrl-exynos-arm64.c     |  98 ++--
 drivers/pinctrl/samsung/pinctrl-exynos.h           |  22 +
 drivers/pinctrl/samsung/pinctrl-samsung.c          |   1 +
 drivers/pinctrl/samsung/pinctrl-samsung.h          |   4 +
 drivers/platform/chrome/cros_ec_lpc.c              |  22 +-
 drivers/platform/x86/x86-android-tablets/Kconfig   |   1 +
 drivers/pwm/pwm-fsl-ftm.c                          |   6 +
 drivers/pwm/pwm-mediatek.c                         |   8 +-
 drivers/pwm/pwm-rcar.c                             |  24 +-
 drivers/s390/virtio/virtio_ccw.c                   |  16 +-
 drivers/scsi/mpi3mr/mpi3mr.h                       |  14 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |  24 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  99 +++-
 drivers/scsi/st.c                                  |   2 +-
 drivers/soc/samsung/exynos-chipid.c                |   2 +
 drivers/spi/spi-cadence-quadspi.c                  |   6 +
 drivers/target/target_core_spc.c                   |   2 +-
 drivers/thermal/mediatek/lvts_thermal.c            |  52 +-
 drivers/thermal/rockchip_thermal.c                 |   1 +
 drivers/ufs/host/ufs-qcom.c                        |   2 +-
 drivers/vdpa/mlx5/core/mr.c                        |   7 +-
 drivers/video/backlight/led_bl.c                   |   5 +-
 drivers/video/fbdev/omap2/omapfb/dss/dispc.c       |   6 +-
 drivers/xen/balloon.c                              |  34 +-
 drivers/xen/xenfs/xensyms.c                        |   4 +-
 fs/btrfs/disk-io.c                                 |  12 +
 fs/btrfs/extent-tree.c                             |   8 +
 fs/btrfs/tests/extent-map-tests.c                  |   1 +
 fs/btrfs/transaction.c                             |  12 +
 fs/btrfs/zoned.c                                   |   6 +
 fs/dlm/lock.c                                      |   2 +
 fs/erofs/fileio.c                                  |   2 +
 fs/ext4/inode.c                                    |  68 ++-
 fs/ext4/namei.c                                    |   2 +-
 fs/ext4/super.c                                    |  17 +
 fs/ext4/xattr.c                                    |  11 +-
 fs/f2fs/checkpoint.c                               |  21 +-
 fs/f2fs/f2fs.h                                     |  32 +-
 fs/f2fs/inode.c                                    |   8 +-
 fs/f2fs/node.c                                     | 110 ++--
 fs/f2fs/super.c                                    |   4 +
 fs/file.c                                          |  26 +-
 fs/jbd2/journal.c                                  |   1 -
 fs/jfs/jfs_dmap.c                                  |  10 +-
 fs/jfs/jfs_imap.c                                  |   4 +-
 fs/namespace.c                                     |   3 +-
 fs/nfsd/nfs4callback.c                             |   2 +-
 fs/nfsd/nfsctl.c                                   |   9 +-
 fs/nfsd/stats.c                                    |   4 +-
 fs/nfsd/stats.h                                    |   2 +-
 fs/smb/client/cifsencrypt.c                        |  16 +-
 fs/smb/client/connect.c                            |   3 +
 fs/smb/client/fs_context.c                         |   5 +
 fs/smb/client/inode.c                              |  10 +
 fs/smb/client/reparse.c                            |   4 -
 fs/smb/client/sess.c                               |   7 +
 fs/smb/client/smb2misc.c                           |   9 +-
 fs/smb/client/smb2ops.c                            |   6 +-
 fs/smb/client/smb2pdu.c                            |  11 +-
 fs/udf/inode.c                                     |   1 +
 fs/userfaultfd.c                                   |  51 +-
 include/drm/drm_kunit_helpers.h                    |   3 +
 include/drm/intel/i915_pciids.h                    |   5 +-
 include/linux/cgroup-defs.h                        |   1 +
 include/linux/cgroup.h                             |   2 +-
 include/linux/hid.h                                |   6 -
 include/linux/io_uring_types.h                     |   3 +
 include/linux/kvm_host.h                           |   2 +-
 include/linux/page-flags.h                         |   6 +
 include/linux/pci_ids.h                            |   2 +
 include/linux/perf_event.h                         |  45 +-
 include/linux/pgtable.h                            |  14 +-
 include/linux/printk.h                             |   6 +
 include/linux/tpm.h                                |   1 +
 include/net/bluetooth/hci.h                        |  16 +
 include/net/bluetooth/hci_core.h                   |   4 +
 include/net/mac80211.h                             |   6 +
 include/net/sctp/structs.h                         |   3 +-
 include/net/sock.h                                 |  40 +-
 include/uapi/linux/kfd_ioctl.h                     |   2 +
 include/uapi/linux/landlock.h                      |   2 +
 include/uapi/linux/perf_event.h                    |  11 +-
 include/uapi/linux/psp-sev.h                       |  21 +-
 include/uapi/linux/rkisp1-config.h                 |   2 +-
 include/xen/interface/xen-mca.h                    |   2 +-
 io_uring/io_uring.c                                |   4 +-
 io_uring/kbuf.c                                    |   2 +
 io_uring/net.c                                     |   3 +
 kernel/cgroup/cgroup.c                             |   6 +
 kernel/cgroup/cpuset.c                             | 176 ++++---
 kernel/events/core.c                               | 255 +++++----
 kernel/events/internal.h                           |   1 +
 kernel/locking/lockdep.c                           |   3 +
 kernel/power/hibernate.c                           |   6 +-
 kernel/printk/printk.c                             |   4 +-
 kernel/reboot.c                                    |   1 +
 kernel/sched/ext.c                                 |   4 +-
 kernel/trace/ftrace.c                              |   9 +-
 kernel/trace/ring_buffer.c                         |   5 +-
 kernel/trace/trace_events.c                        |   4 +-
 kernel/trace/trace_events_synth.c                  |   1 -
 kernel/trace/trace_fprobe.c                        |  26 +-
 kernel/trace/trace_probe.c                         |  28 +
 lib/sg_split.c                                     |   2 -
 lib/zstd/common/portability_macros.h               |   2 +-
 mm/damon/ops-common.c                              |   2 +-
 mm/damon/paddr.c                                   |  24 +-
 mm/hugetlb.c                                       |   2 +-
 mm/memory-failure.c                                |  11 +-
 mm/memory_hotplug.c                                |   3 +-
 mm/mremap.c                                        |  10 +-
 mm/page_vma_mapped.c                               |  13 +-
 mm/rmap.c                                          |   2 +-
 mm/shmem.c                                         |   3 +-
 mm/vmscan.c                                        |   2 +-
 net/8021q/vlan_dev.c                               |  31 +-
 net/bluetooth/hci_sync.c                           |   6 +-
 net/core/filter.c                                  |  80 +--
 net/core/page_pool.c                               |   8 +-
 net/core/page_pool_user.c                          |   2 +-
 net/core/sock.c                                    |   5 +
 net/ethtool/netlink.c                              |   8 +-
 net/ipv6/route.c                                   |   8 +-
 net/mac80211/debugfs.c                             |  44 +-
 net/mac80211/iface.c                               |   5 +-
 net/mac80211/mesh_hwmp.c                           |  14 +-
 net/mac80211/mlme.c                                |  45 +-
 net/mptcp/sockopt.c                                |  28 +
 net/mptcp/subflow.c                                |  19 +-
 net/netfilter/nft_set_pipapo_avx2.c                |   3 +-
 net/sched/cls_api.c                                |  66 ++-
 net/sched/sch_codel.c                              |   5 +-
 net/sched/sch_fq_codel.c                           |   6 +-
 net/sched/sch_sfq.c                                |  66 ++-
 net/sctp/socket.c                                  |  22 +-
 net/sctp/transport.c                               |   2 +
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   3 +-
 net/tipc/link.c                                    |   1 +
 net/tls/tls_main.c                                 |   6 +
 scripts/generate_builtin_ranges.awk                |   5 +
 security/integrity/ima/ima.h                       |   3 +-
 security/integrity/ima/ima_main.c                  |  18 +-
 security/landlock/errata.h                         |  99 ++++
 security/landlock/errata/abi-4.h                   |  15 +
 security/landlock/errata/abi-6.h                   |  19 +
 security/landlock/fs.c                             |  39 +-
 security/landlock/setup.c                          |  38 +-
 security/landlock/setup.h                          |   3 +
 security/landlock/syscalls.c                       |  22 +-
 security/landlock/task.c                           |  12 +
 sound/pci/hda/hda_intel.c                          |  44 +-
 sound/pci/hda/patch_realtek.c                      |  22 +
 sound/soc/amd/ps/acp63.h                           |   1 +
 sound/soc/amd/ps/pci-ps.c                          |   2 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  14 +
 sound/soc/codecs/wcd937x.c                         |   2 +
 sound/soc/fsl/fsl_audmix.c                         |  16 +-
 sound/soc/intel/common/soc-acpi-intel-adl-match.c  |  29 ++
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |  60 ++-
 sound/soc/qcom/qdsp6/q6apm.c                       |  18 +-
 sound/soc/qcom/qdsp6/q6apm.h                       |   3 +
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |  19 +-
 sound/soc/sof/topology.c                           |   4 +-
 sound/usb/midi.c                                   |  80 ++-
 tools/lib/bpf/btf_dump.c                           |   4 +-
 tools/objtool/check.c                              |   5 +
 tools/power/cpupower/bench/parse.c                 |   4 +
 tools/testing/ktest/ktest.pl                       |   8 +
 .../futex/functional/futex_wait_wouldblock.c       |   2 +-
 tools/testing/selftests/landlock/base_test.c       |  46 +-
 tools/testing/selftests/landlock/common.h          |   1 +
 .../selftests/landlock/scoped_signal_test.c        | 108 +++-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |  11 +-
 virt/kvm/Kconfig                                   |   2 +-
 virt/kvm/eventfd.c                                 |  10 +-
 383 files changed, 5029 insertions(+), 2064 deletions(-)


