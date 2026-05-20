Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B850372ECB;
	Wed, 20 May 2026 16:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294453; cv=none; b=fKlzva7a2aDMN1ck0n/Uacc/dbmob0GR/dgH268EeK/zIVm+nVsAUhPaO0QaSftT7PBpnlALpk0qEOmaLtTgRXbjSUteXl+5C44YxX4Y5t5NtWZ1DtUWC+mTM0sNgAs1ZzZGGLYzM2WKO+3OlfgmgnXxu3irbv/k8T4y71/LguE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294453; c=relaxed/simple;
	bh=6wK8hqix05t2mE2S24yGPm0HhbY7YYlaSRA3Wpj8kM8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=X8M/kBp2w3tG2sngHck34TBKktKvCwZyGo591chAIjAOB2sh7cStnKZfLjwTJydYKzkms23VxWnO+NZTujR94bouSSf+3/fL6vRjfTzzBqUoVdkFrNHnn9XHCt4M6rQUKecfnjddgzx4YOXJgi/kxfmNZRauTXgK66SaLx0UM14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilW37zz4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilW37zz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F4D1F000E9;
	Wed, 20 May 2026 16:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294445;
	bh=iZeIcSXKm2k3omnBvbrpUceNcbEpODucX2+9p7ZwWSo=;
	h=From:To:Cc:Subject:Date;
	b=ilW37zz4LHsXExlT+fWy6h7oLcdFQPchRVlqmrooSoUGA4k/mGleC8QPFAtIN6aCj
	 CTrysHUl8GmDxTL0rDnRj4C/4xUPjHtwliqlyCQ0wEkw484TluAf+fVRTLOj5B21Zt
	 HPxFGsGgVvSLjrOj+VAIw65YfztBh1tjW76I9GRg=
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
Subject: [PATCH 7.0 0000/1146] 7.0.10-rc1 review
Date: Wed, 20 May 2026 18:04:10 +0200
Message-ID: <20260520162148.390695140@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.0.10-rc1
X-KernelTest-Deadline: 2026-05-22T16:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.0.10 release.
There are 1146 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 22 May 2026 16:20:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.0.10-rc1

Johan Hovold <johan@kernel.org>
    spi: sifive: fix controller deregistration

Pei Xiao <xiaopei01@kylinos.cn>
    spi: sifive: Simplify clock handling with devm_clk_get_enabled()

Piyush Sachdeva <s.piyush1024@gmail.com>
    smb: client: Use FullSessionKey for AES-256 encryption key derivation

David Carlier <devnexen@gmail.com>
    eventfs: Use list_add_tail_rcu() for SRCU-protected children list

Steven Rostedt <rostedt@goodmis.org>
    eventfs: Simplify code using guard()s

James Morse <james.morse@arm.com>
    arm_mpam: Check whether the config array is allocated before destroying it

James Morse <james.morse@arm.com>
    arm_mpam: Fix false positive assert failure during mpam_disable()

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: Improve check for whether or not NRDY is hardware managed

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: Pretend that NRDY is always hardware managed

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: Fix monitor instance selection when checking for hardware NRDY

Johan Hovold <johan@kernel.org>
    drm/gma500/oaktrail_lvds: fix i2c adapter leaks on init

Johan Hovold <johan@kernel.org>
    drm/gma500/oaktrail_lvds: fix hang on init failure

Johan Hovold <johan@kernel.org>
    drm/gma500/oaktrail_hdmi: fix i2c adapter leak on setup

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/ttm: Convert -EAGAIN from dmem_cgroup_try_charge to -ENOSPC

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/ttm: Fix ttm_bo_shrink() infinite LRU walk on backup failure

Matthew Auld <matthew.auld@intel.com>
    drm/xe/dma-buf: fix UAF with retry loop

Matthew Auld <matthew.auld@intel.com>
    drm/xe/dma-buf: handle empty bo and UAF races

Gyeyoung Baek <gye976@gmail.com>
    drm/panfrost: Fix wait_bo ioctl leaking positive return from dma_resv_wait_timeout()

Sebastian Brzezinka <sebastian.brzezinka@intel.com>
    drm/i915: skip __i915_request_skip() for already signaled requests

Nicolin Chen <nicolinc@nvidia.com>
    iommu: Fix ATS invalidation timeouts during __iommu_remove_group_pasid()

Nicolin Chen <nicolinc@nvidia.com>
    iommu: Fix nested pci_dev_reset_iommu_prepare/done()

Nicolin Chen <nicolinc@nvidia.com>
    iommu: Fix pasid attach in pci_dev_reset_iommu_prepare/done()

Nicolin Chen <nicolinc@nvidia.com>
    iommu: Fix WARN_ON in __iommu_group_set_domain_nofail() due to reset

Nicolin Chen <nicolinc@nvidia.com>
    iommu: Replace per-group resetting_domain with per-gdev blocked flag

Nicolin Chen <nicolinc@nvidia.com>
    iommu: Fix NULL group->domain dereference in pci_dev_reset_iommu_done()

Zhenzhong Duan <zhenzhong.duan@intel.com>
    iommu/vt-d: Avoid NULL pointer dereference or refcount corruption

Zhenzhong Duan <zhenzhong.duan@intel.com>
    iommu/vt-d: Fix oops due to out of scope access

Naval Alcalá <ari@naval.cat>
    iommu/vt-d: Disable DMAR for Intel Q35 IGFX

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: handle rbtree insertion error in decode_choose_args()

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix potential out-of-bounds access in crush_decode()

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix potential out-of-bounds access in __ceph_x_decrypt()

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix potential null-ptr-deref in decode_choose_args()

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix potential out-of-bounds access in osdmap_decode()

Sascha Bischoff <Sascha.Bischoff@arm.com>
    irqchip/gic-v5: Allocate ITS parent LPIs as a range

Sascha Bischoff <Sascha.Bischoff@arm.com>
    irqchip/gic-v5: Support range allocation for LPIs

Sascha Bischoff <Sascha.Bischoff@arm.com>
    irqchip/gic-v5: Move LPI allocation into the LPI domain

Xianwei Zhao <xianwei.zhao@amlogic.com>
    irqchip/meson-gpio: Use the correct register in meson_s4_gpio_irq_set_type()

Yong-Xuan Wang <yongxuan.wang@sifive.com>
    irqchip/riscv-imsic: Clear interrupt move state during CPU offlining

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: update mtime/ctime on COPY in presence of delegated attributes

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: update mtime/ctime on CLONE in presense of delegated attributes

Scott Mayhew <smayhew@redhat.com>
    nfsd: fix file change detection in CB_GETATTR

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: fix GET_DIR_DELEGATION when VFS leases are disabled

Paulo Alcantara <pc@manguebit.org>
    netfs: fix error handling in netfs_extract_user_iter()

Ma Ke <make24@iscas.ac.cn>
    powerpc/warp: Fix error handling in pika_dtm_thread

Vivian Wang <wangruikang@iscas.ac.cn>
    riscv: misaligned: Make enabling delegation depend on NONPORTABLE

Carlos López <clopez@suse.de>
    virt: sev-guest: Do not use host-controlled page order in cleanup path

Wilfred Mallawa <wilfred.mallawa@wdc.com>
    xfs: fix memory leak on error in xfs_alloc_zone_info()

David Woodhouse <dwmw@amazon.co.uk>
    x86/kexec: Push kjump return address even for non-kjump kexec

Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
    iommu/amd: Bounds-check devid in __rlookup_amd_iommu()

Nicholas Carlini <nicholas@carlini.com>
    io-wq: check that the predecessor is hashed in io_wq_remove_pending()

Hristo Venev <hristo@venev.name>
    ceph: put folios not suitable for writeback

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: fix BUG_ON in __ceph_build_xattrs_blob() due to stale blob size

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: fix a buffer leak in __ceph_setxattr()

Qu Wenruo <wqu@suse.com>
    btrfs: only release the dirty pages io tree after successful writes

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: qcom: Check offload mapping failures

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Bound MIDI endpoint descriptor scans

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Bound MIDI 2.0 endpoint descriptor scans

Markus Kramer <linux@markus-kramer.de>
    ALSA: hda/realtek: Add quirk for Samsung Galaxy Book5 360 headphone

Adrien Burnett <an.arctic.pigeon@gmail.com>
    ALSA: hda/realtek: Add mute LED quirk for HP Pavilion Laptop 16-ag0xxx

Gyeyoung Baek <gye976@gmail.com>
    accel/rocket: Fix prep_bo ioctl leaking positive return from dma_resv_wait_timeout()

Derek J. Clark <derekjohn.clark@gmail.com>
    platform/x86: lenovo-wmi-other: Limit adding attributes to supported devices

Derek J. Clark <derekjohn.clark@gmail.com>
    platform/x86: lenovo-wmi-other: Add Attribute ID helper functions

Derek J. Clark <derekjohn.clark@gmail.com>
    platform/x86: lenovo-wmi-other: Fix tunable_attr_01 struct members

Derek J. Clark <derekjohn.clark@gmail.com>
    platform/x86: lenovo-wmi-other: Zero initialize WMI arguments

Rong Zhang <i@rong.moe>
    platform/x86: lenovo-wmi-other: Balance component bind and unbind

Rong Zhang <i@rong.moe>
    platform/x86: lenovo-wmi-other: Balance IDA id allocation and free

Rong Zhang <i@rong.moe>
    platform/x86: lenovo-wmi-helpers: Fix memory leak in lwmi_dev_evaluate_int()

Derek J. Clark <derekjohn.clark@gmail.com>
    platform/x86: lenovo-wmi-helpers: Move gamezone enums to wmi-helpers

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: intel: Move debugfs register before creating devices

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/ttm: Fix ttm_bo_swapout() infinite LRU walk on swapout failure

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    drm/amd/display: Wrap DCN32 phantom-plane allocation in DC_RUN_WITH_PREEMPTION_ENABLED

Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
    drm/i915/dp: Fix VSC dynamic range signaling for RGB formats

Guangshuo Li <lgs201920130244@gmail.com>
    drm/bridge: imx8qxp-pxl2dpi: avoid ERR_PTR with device_node cleanup

Edward Adam Davis <eadavis@qq.com>
    drm: Replace old pointer to new idr

Myeonghun Pak <mhun512@gmail.com>
    drm/loongson: Use managed KMS polling

Ye Bin <yebin10@huawei.com>
    smb/client: fix possible infinite loop and oob read in symlink_data()

Nick Chan <towinchenmi@gmail.com>
    nvme-apple: Reset q->sq_tail during queue init

Pauli Virtanen <pav@iki.fi>
    Bluetooth: btmtk: accept too short WMT FUNC_CTRL events

Michael Tretter <m.tretter@pengutronix.de>
    media: staging: imx: configure src_mux in csi_start

Igor Pylypiv <ipylypiv@google.com>
    ata: libata-scsi: fix requeue of deferred ATA PASS-THROUGH commands

Nathan Chancellor <nathan@kernel.org>
    HID: core: Fix size_t specifier in hid_report_raw_event()

Thomas Gleixner <tglx@kernel.org>
    rseq: Reenable performance optimizations conditionally

Thomas Gleixner <tglx@kernel.org>
    rseq: Implement read only ABI enforcement for optimized RSEQ V2 mode

Thomas Gleixner <tglx@kernel.org>
    rseq: Revert to historical performance killing behaviour

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: introduce hid_safe_input_report()

Benjamin Tissoires <bentiss@kernel.org>
    HID: pass the buffer size to hid_report_raw_event

Qiang Ma <maqianga@uniontech.com>
    KVM: x86: Fix Xen hypercall tracepoint argument assignment

Junrui Luo <moonafterrain@outlook.com>
    KVM: s390: pci: fix GAIT table indexing due to double-scaling pointer arithmetic

Aaron Sacks <contact@xchglabs.com>
    KVM: Reject wrapped offset in kvm_reset_dirty_gfn()

Sean Christopherson <seanjc@google.com>
    KVM: x86: Swap the dst and src operand for MOVNTDQA

sunshaojie <sunshaojie@kylinos.cn>
    cgroup/cpuset: Return only actually allocated CPUs during partition invalidation

Sergio Correia <scorreia@redhat.com>
    audit: enforce AUDIT_LOCKED for AUDIT_TRIM and AUDIT_MAKE_EQUIV

Zoran Ilievski <goodboy@rexbytes.com>
    net: atlantic: preserve PCI wake-from-D3 on shutdown when WOL enabled

Li Xiasong <lixiasong1@huawei.com>
    netfilter: nft_ct: fix missing expect put in obj eval

Mario Limonciello <mario.limonciello@amd.com>
    Revert "ACPI: CPPC: Adjust debug messages in amd_set_max_freq_ratio() to warn"

Guopeng Zhang <zhangguopeng@kylinos.cn>
    cgroup/cpuset: Reserve DL bandwidth only for root-domain moves

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    idpf: fix double free and use-after-free in aux device error paths

Guopeng Zhang <zhangguopeng@kylinos.cn>
    cgroup/dmem: Return -ENOMEM on failed pool preallocation

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: PHC: Check return code before setting timestamp output

Sergio Correia <scorreia@redhat.com>
    audit: fix incorrect inheritable capability in CAPSET records

Li Xiasong <lixiasong1@huawei.com>
    netfilter: nf_conntrack_sip: get helper before allocating expectation

Guopeng Zhang <zhangguopeng@kylinos.cn>
    cgroup/cpuset: Reset DL migration state on can_attach() failure

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: PHC: Fix potential use-after-free in get_timestamp

Breno Leitao <leitao@debian.org>
    workqueue: Fix wq->cpu_pwq leak in alloc_and_link_pwqs() WQ_UNBOUND path

Matt Vollrath <tactii@gmail.com>
    i40e: Cleanup PTP pins on probe failure

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Cap AEAD AD length to 0x80000000

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix wakeup_preempt_fair() for not waking up task

Eric Dumazet <edumazet@google.com>
    net/sched: sch_pie: annotate more data-races in pie_dump_stats()

Breno Leitao <leitao@debian.org>
    workqueue: fix devm_alloc_workqueue() va_list misuse

Samiullah Khawaja <skhawaja@google.com>
    PCI: Initialize temporary device in new_id_store()

Davidlohr Bueso <dave@stgolabs.net>
    futex: Drop CLONE_THREAD requirement for private default hash alloc

Zhaoyang Huang <zhaoyang.huang@unisoc.com>
    arm64: Reserve an extra page for early kernel mapping

Leo Yan <leo.yan@arm.com>
    kselftest/arm64: Include <asm/ptrace.h> for user_gcs definition

Paolo Abeni <pabeni@redhat.com>
    net/sched: cls_flower: revert unintended changes

Dan Carpenter <error27@gmail.com>
    sfc: fix error code in efx_devlink_info_running_versions()

Jakub Kicinski <kuba@kernel.org>
    net: tls: fix strparser anchor skb leak on offload RX setup failure

Petr Oros <poros@redhat.com>
    ice: add dpll peer notification for paired SMA and U.FL pins

Ivan Vecera <ivecera@redhat.com>
    dpll: export __dpll_pin_change_ntf() for use under dpll_lock

Petr Oros <poros@redhat.com>
    ice: fix missing dpll notifications for SW pins

Petr Oros <poros@redhat.com>
    ice: fix SMA and U.FL pin state changes affecting paired pin

Petr Oros <poros@redhat.com>
    ice: fix missing SMA pin initialization in DPLL subsystem

Petr Oros <poros@redhat.com>
    ice: fix infinite recursion in ice_cfg_tx_topo via ice_init_dev_hw

Petr Oros <poros@redhat.com>
    ice: fix NULL pointer dereference in ice_reset_all_vfs()

Petr Oros <poros@redhat.com>
    iavf: add VIRTCHNL_OP_ADD_VLAN to success completion handler

Petr Oros <poros@redhat.com>
    iavf: wait for PF confirmation before removing VLAN filters

Petr Oros <poros@redhat.com>
    iavf: stop removing VLAN filters from PF on interface down

Petr Oros <poros@redhat.com>
    iavf: rename IAVF_VLAN_IS_NEW to IAVF_VLAN_ADDING

Hasan Basbunar <basbunarhasan@gmail.com>
    page_pool: fix memory-provider leak in page_pool_create_percpu() error path

Eric Dumazet <edumazet@google.com>
    bonding: 3ad: implement proper RCU rules for port->aggregator

Hangbin Liu <liuhangbin@gmail.com>
    bonding: print churn state via netlink

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Do not return err in ndo_stop() callback

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/xe/xelp: Fix Wa_18022495364

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/gsc: Fix BO leak on error in query_compatibility_version()

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/eustall: Fix drm_dev_put called before stream disable in close

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe: Fix error cleanup in xe_exec_queue_create_ioctl()

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe: Fix potential NULL deref in xe_exec_queue_tlb_inval_last_fence_put_unlocked

Matt Roper <matthew.d.roper@intel.com>
    drm/xe/debugfs: Correct printing of register whitelist ranges

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Drop registration of guc_submit_wedged_fini from xe_guc_submit_wedge()

Zhanjun Dong <zhanjun.dong@intel.com>
    drm/xe: Use XE_WEDGED_MODE_UPON_ANY_HANG_NO_RESET enum instead of magic number

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Use EDID from VBIOS embedded panel info

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Read EDID from VBIOS embedded panel info

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Allow constructing DCE8 link encoder without DDC

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Allow constructing DCE6 link encoder without DDC

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Allow DCE link encoder without AUX registers

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Allow embedded connectors without DDC

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    futex: Prevent lockup in requeue-PI during signal/ timeout wakeup

Shenghao Ding <shenghao-ding@ti.com>
    ALSA: hda/tas2781: Fix incorrect bit update for non-book-zero or book 0 pages >1

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda: cs35l56: Fix uninitialized value in cs35l56_hda_read_acpi()

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: hda/conexant: Fix missing error check for jack detection

Breno Leitao <leitao@debian.org>
    netconsole: restore userdatum value on update_userdata() failure

Breno Leitao <leitao@debian.org>
    netconsole: propagate device name truncation in dev_name_store()

Breno Leitao <leitao@debian.org>
    netconsole: avoid clobbering userdatum value on truncated write

Breno Leitao <leitao@debian.org>
    netconsole: return count instead of strnlen(buf, count) from store callbacks

Eric Dumazet <edumazet@google.com>
    net/sched: sch_cake: annotate data-races in cake_dump_stats() (V)

Eric Dumazet <edumazet@google.com>
    net/sched: sch_cake: annotate data-races in cake_dump_stats() (IV)

Eric Dumazet <edumazet@google.com>
    net/sched: sch_cake: annotate data-races in cake_dump_stats() (III)

Eric Dumazet <edumazet@google.com>
    net/sched: sch_cake: annotate data-races in cake_dump_stats() (II)

Eric Dumazet <edumazet@google.com>
    net/sched: sch_cake: annotate data-races in cake_dump_stats() (I)

Weiming Shi <bestswngs@gmail.com>
    bareudp: fix NULL pointer dereference in bareudp_fill_metadata_dst()

Xin Long <lucien.xin@gmail.com>
    sctp: discard stale INIT after handshake completion

Xin Long <lucien.xin@gmail.com>
    netfilter: skip recording stale or retransmitted INIT

Christian A. Ehrhardt <christian.ehrhardt@codasip.com>
    ASoC: codecs: ab8500: Fix casting of private data

Jakub Kicinski <kuba@kernel.org>
    net: psp: require admin permission for dev-set and key-rotate

Jakub Kicinski <kuba@kernel.org>
    net: psp: check for device unregister when creating assoc

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Fix illegal writes to OTP_MEM registers

Jens Axboe <axboe@kernel.dk>
    io_uring/napi: cap busy_poll_to 10 msec

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Add fine grained flag to SMU v13.0.6

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v5.3.0 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v5.0.1 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v5.0.0 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0.5 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0.3 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v3.0 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v2.5 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v2.0 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v5.0.1 enc ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v5.0.0 enc ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v4.0.5 enc ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v4.0.3 enc ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v4.0 enc ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v3.0 enc/dec rings

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v2.5 enc/dec rings

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v2.0 enc/dec rings

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: properly handle family setting for early GC 11.5.4

Heiko Schocher <hs@nabladev.com>
    net: phy: dp83869: fix setting CLK_O_SEL field.

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Fix phys_to_folio() usage in do_secure_storage_access()

Yu Kuai <yukuai@fnnas.com>
    md/md-bitmap: add a none backend for bitmap grow

Yu Kuai <yukuai@fnnas.com>
    md/md-bitmap: split bitmap sysfs groups

Yu Kuai <yukuai@fnnas.com>
    md: factor bitmap creation away from sysfs handling

Yu Kuai <yukuai@fnnas.com>
    md: add fallback to correct bitmap_ops on version mismatch

Keith Busch <kbusch@kernel.org>
    md/raid1,raid10: don't fail devices for invalid IO errors

William A. Kennington III <william@wkennington.com>
    net: mctp i2c: check length before marking flow active

Zicheng Qu <quzicheng@huawei.com>
    sched/fair: Clear rel_deadline when initializing forked entities

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix wakeup_preempt_fair() vs delayed dequeue

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix potential leak of pd at parsing UAC3 streams

Breno Leitao <leitao@debian.org>
    netpoll: fix IPv6 local-address corruption

Altan Hacigumus <ahacigu.linux@gmail.com>
    tcp: make probe0 timer handle expired user timeout

Florian Westphal <fw@strlen.de>
    neigh: let neigh_xmit take skb ownership

Morduan Zang <zhangdandan@uniontech.com>
    net: phonet: do not BUG_ON() in pn_socket_autobind() on failed bind

Weiming Shi <bestswngs@gmail.com>
    net/sched: taprio: fix NULL pointer dereference in class dump

Paul Geurts <paul.geurts@prodrive-technologies.com>
    NFC: trf7970a: Ignore antenna noise when checking for RF field

Felix Gu <ustc.gu@gmail.com>
    spi: amlogic-spisg: initialize completion before requesting IRQ

Morduan Zang <zhangdandan@uniontech.com>
    net: usb: rtl8150: free skb on usb_submit_urb() failure in xmit

Zhan Jun <zhanjun@uniontech.com>
    net: usb: rtl8150: fix use-after-free in rtl8150_start_xmit()

Ido Schimmel <idosch@nvidia.com>
    vrf: Fix a potential NPD when removing a port from a VRF

Eric Dumazet <edumazet@google.com>
    net/sched: sch_fq_pie: annotate data-races in fq_pie_dump_stats()

Eric Dumazet <edumazet@google.com>
    net/sched: sch_choke: annotate data-races in choke_dump_stats()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Do not read uninitialized fragment address in airoha_dev_xmit()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Do not wake all netdev TX queues in airoha_qdma_wake_netdev_txqs()

Zhengping Zhang <aquapinn@qq.com>
    net: airoha: fix typo in function name

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: stop net_device TX queue before updating CPU index

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: fix BQL imbalance in TX path

Stephen Hemminger <stephen@networkplumber.org>
    net/sched: netem: check for negative latency and jitter

Stephen Hemminger <stephen@networkplumber.org>
    net/sched: netem: fix slot delay calculation overflow

Stephen Hemminger <stephen@networkplumber.org>
    net/sched: netem: validate slot configuration

Stephen Hemminger <stephen@networkplumber.org>
    net/sched: netem: only reseed PRNG when seed is explicitly provided

Stephen Hemminger <stephen@networkplumber.org>
    net/sched: netem: fix queue limit check to include reordered packets

Stephen Hemminger <stephen@networkplumber.org>
    net/sched: netem: fix probability gaps in 4-state loss model

Nikola Z. Ivanov <zlatistiv@gmail.com>
    netdevsim: zero initialize struct iphdr in dummy sk_buff

Felix Gu <ustc.gu@gmail.com>
    spi: axiado: replace usleep_range() with udelay() in IRQ path

Daan De Meyer <daan@amutable.com>
    cdrom, scsi: sr: propagate read-only status to block layer via set_disk_ro()

Tony Luck <tony.luck@intel.com>
    ACPI: APEI: EINJ: Fix EINJV2 memory error injection

Tony Luck <tony.luck@intel.com>
    ACPICA: Provide #defines for EINJV2 error types

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spinand: winbond: Fix ODTR write VCR on W35NxxJW

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spinand: winbond: Set the packed page read flag to W35N02/04JW

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spinand: Add support for packed read data ODTR commands

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: spi-mem: Add a packed command operation

Wentao Guan <guanwentao@uniontech.com>
    arm64/scs: Fix potential sign extension issue of advance_loc4

Geert Uytterhoeven <geert+renesas@glider.be>
    drm/color-mgmt: Typo s/R332/RGB332/

Yuho Choi <dbgh9129@gmail.com>
    drm/sysfb: ofdrm: fix PCI device reference leaks

James Calligeros <jcalligeros99@gmail.com>
    ASoC: tas2770: Fix order of operations for temperature calculation

James Calligeros <jcalligeros99@gmail.com>
    ASoC: tas2764: Mark die temp register as volatile

John Madieu <john.madieu@gmail.com>
    spi: rockchip: Read ISR, not IMR, to detect cs-inactive IRQ

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: SOF: Intel: add an empty adr_link

Guilherme G. Piccoli <gpiccoli@igalia.com>
    ASoC: amd: acp: Add DMI quirk for Valve Steam Deck OLED

John Madieu <john.madieu.xa@bp.renesas.com>
    spi: rzv2h-rspi: Fix silent failure in clock setup error path

Florian Westphal <fw@strlen.de>
    netfilter: nf_conntrack_sip: don't use simple_strtoul

Jiexun Wang <wangjiexun2025@gmail.com>
    netfilter: xt_policy: fix strict mode inbound policy matching

Kent Russell <kent.russell@amd.com>
    drm/amdgpu: Only send RMA CPER when threshold is exceeded

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/gfx6: Support harvested SI chips with disabled TCCs (v2)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/uvd3.1: Don't validate the firmware when already validated

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix AMDGPU_INFO_READ_MMR_REG

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix missing fine-grained dpm table flag on aldebaran

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/gmc: Fix AMDGPU_GART_PLACEMENT_LOW to not overlap with VRAM

Hongyan Xu <getshell@seu.edu.cn>
    drm/amdgpu: avoid double drm_exec_fini() in userq validate

Keith Busch <kbusch@kernel.org>
    nvme-pci: fix missed admin queue sq doorbell write

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: add hook transactions for device deletions

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase

Pablo Neira Ayuso <pablo@netfilter.org>
    rculist: add list_splice_rcu() for private lists

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: use list_del_rcu for netlink hooks

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: arp_tables: fix IEEE1394 ARP payload parsing

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-tcp: propagate nvmet_tcp_build_pdu_iovec() errors to its callers

Breno Leitao <leitao@debian.org>
    tracing: branch: Fix inverted check on stat tracer registration

Mark Harmstone <mark@harmstone.com>
    btrfs: fix double-decrement of bytes_may_use in submit_one_async_extent()

Mark Harmstone <maharmstone@fb.com>
    btrfs: don't clobber errors in add_remap_tree_entries()

Mark Harmstone <mark@harmstone.com>
    btrfs: fix bytes_may_use leak in do_remap_reloc_trans()

Mark Harmstone <mark@harmstone.com>
    btrfs: fix bytes_may_use leak in move_existing_remap()

Amir Goldstein <amir73il@gmail.com>
    fsnotify: fix inode reference leak in fsnotify_recalc_mask()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mailbox: mailbox-test: make data_ready a per-instance variable

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mailbox: mailbox-test: initialize struct earlier

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mailbox: mailbox-test: don't free the reused channel

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mailbox: mailbox-test: handle channel errors consistently

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mailbox: add sanity check for channel array

Guopeng Zhang <zhangguopeng@kylinos.cn>
    cgroup/cpuset: record DL BW alloc CPU for attach rollback

cuitao <cuitao@kylinos.cn>
    cgroup/rdma: fix integer overflow in rdmacg_try_charge()

Edward Adam Davis <eadavis@qq.com>
    sched/psi: fix race between file release and pressure write

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mailbox: mailbox-test: free channels on probe error

Jason-JH Lin <jason-jh.lin@mediatek.com>
    mailbox: mtk-cmdq: Fix CURR and END addr for task insert case

Felix Gu <ustc.gu@gmail.com>
    mailbox: mtk-vcp-mailbox: Fix the return value in mtk_vcp_mbox_xlate()

Thomas Weißschuh <linux@weissschuh.net>
    kbuild: Never respect CONFIG_WERROR / W=e to fixdep

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix --cpu-set 1 regression on HT systems

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix --cpu-set 0 regression on HT systems

David Arcari <darcari@redhat.com>
    tools/power turbostat: Fix unrecognized option '-P'

Yuho Choi <dbgh9129@gmail.com>
    fbdev: offb: fix PCI device reference leak on probe failure

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix AMD RAPL regression on big systems

Mathias Krause <minipli@grsecurity.net>
    kbuild: builddeb - avoid recompiles for non-cross-compiles

Anthony Pighin (Nokia) <anthony.pighin@nokia.com>
    rtc: abx80x: Disable alarm feature if no interrupt attached

Bae Yeonju <iwasbaeyz@gmail.com>
    fs/adfs: validate nzones in adfs_validate_bblk()

Christian Brauner <brauner@kernel.org>
    eventpoll: fix ep_remove struct eventpoll / struct file UAF

Christian Brauner <brauner@kernel.org>
    eventpoll: move epi_fget() up

Christian Brauner <brauner@kernel.org>
    eventpoll: drop vestigial __ prefix from ep_remove_{file,epi}()

Christian Brauner <brauner@kernel.org>
    eventpoll: kill __ep_remove()

Christian Brauner <brauner@kernel.org>
    eventpoll: split __ep_remove()

Christian Brauner <brauner@kernel.org>
    eventpoll: use hlist_is_singular_node() in __ep_remove()

Randy Dunlap <rdunlap@infradead.org>
    nstree: fix func. parameter kernel-doc warnings

Kohei Enju <kohei@enjuk.jp>
    vhost_net: fix sleeping with preempt-disabled in vhost_net_busy_poll()

Lee Jones <lee@kernel.org>
    tipc: fix double-free in tipc_buf_append()

Jiayuan Chen <jiayuan.chen@linux.dev>
    tcp: send a challenge ACK on SEG.ACK > SND.NXT

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    nfp: fix swapped arguments in nfp_encode_basic_qdr() calls

Brett Creeley <brett.creeley@amd.com>
    virtio_net: sync rss_trailer.max_tx_vq on queue_pairs change via VQ_PAIRS_SET

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: fix MSG_ZEROCOPY pinned-pages accounting

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    net: mana: Fix EQ leak in mana_remove on NULL port

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    net: mana: Don't overwrite port probe error with add_adev result

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    net: mana: Guard mana_remove against double invocation

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    net: mana: Init gf_stats_work before potential error paths in probe

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    net: mana: Init link_change_work before potential error paths in probe

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Add size check for TX NAPIs in airoha_qdma_cleanup()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Rework the code flow in airoha_remove() and in airoha_probe() error path

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Move ndesc initialization at end of airoha_qdma_init_rx_queue()

Mieczyslaw Nalewaj <namiltd@yahoo.com>
    net: dsa: realtek: rtl8365mb: fix mode mask calculation

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Add missing bits in airoha_qdma_cleanup_tx_queue()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Move ndesc initialization at end of airoha_qdma_init_tx()

Eric Dumazet <edumazet@google.com>
    net/sched: sch_sfb: annotate data-races in sfb_dump_stats()

Eric Dumazet <edumazet@google.com>
    net/sched: sch_red: annotate data-races in red_dump_stats()

Eric Dumazet <edumazet@google.com>
    net/sched: sch_fq_codel: remove data-races from fq_codel_dump_stats()

Eric Dumazet <edumazet@google.com>
    net/sched: sch_pie: annotate data-races in pie_dump_stats()

Eric Dumazet <edumazet@google.com>
    net_sched: sch_hhf: annotate data-races in hhf_dump_stats()

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix ice_ptp_read_tx_hwtstamp_status_eth56g

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix ready bitmap check for non-E822 devices

Grzegorz Nitka <grzegorz.nitka@intel.com>
    ice: perform PHY soft reset for E825C ports at initialization

Grzegorz Nitka <grzegorz.nitka@intel.com>
    ice: fix timestamp interrupt configuration for E825C

Michael Bommarito <michael.bommarito@gmail.com>
    net/rds: zero per-item info buffer before handing it to visitors

Xin Long <lucien.xin@gmail.com>
    sctp: fix sockets_allocated imbalance after sk_clone()

Vikas Gupta <vikas.gupta@broadcom.com>
    bnge: remove unsupported backing store type

Vikas Gupta <vikas.gupta@broadcom.com>
    bnge: fix initial HWRM sequence

Kohei Enju <kohei@enjuk.jp>
    net: validate skb->napi_id in RX tracepoints

Hyunwoo Kim <imv4bel@gmail.com>
    ksmbd: scope conn->binding slowpath to bound sessions only

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: fix durable fd leak on ClientGUID mismatch in durable v2 open

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: destroy async_ida in ksmbd_conn_free()

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: destroy tree_conn_ida in ksmbd_session_destroy()

Sangyun Kim <sangyun.kim@snu.ac.kr>
    pwm: atmel-tcb: Cache clock rates and mark chip as atomic

Matt Evans <mattev@meta.com>
    vfio/pci: Clean up DMABUFs before disabling function

Jun Yan <jerrysteve1101@gmail.com>
    arm64: dts: meson-gxl-p230: fix ethernet PHY interrupt number

Anand Moon <linux.amoon@gmail.com>
    arm64: dts: amlogic: meson-axg: Add missing cache information to cpu0

Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
    net/sched: sch_dualpi2: drain both C-queue and L-queue in dualpi2_change()

Weiming Shi <bestswngs@gmail.com>
    slip: bound decode() reads against the compressed packet length

Weiming Shi <bestswngs@gmail.com>
    slip: reject VJ receive packets on instances with no rstate array

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nfnetlink_osf: fix potential NULL dereference in ttl check

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nfnetlink_osf: fix out-of-bounds read on option matching

Yingnan Zhang <342144303@qq.com>
    ipvs: fix MTU check for GSO packets in tunnel mode

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nat: use kfree_rcu to release ops

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xtables: restrict several matches to inet family

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: remove sprintf usage

Xiang Mei <xmei5@asu.edu>
    netfilter: nfnetlink_osf: fix divide-by-zero in OSF_WSS_MODULO

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_osf: restrict it to ipv4

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Fix possible TX queue stall in airoha_qdma_tx_napi_poll()

Weiming Shi <bestswngs@gmail.com>
    openvswitch: cap upcall PID array size and pre-size vport replies

Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
    net/mlx5: Fix HCA caps leak on notifier init failure

Qingfang Deng <qingfang.deng@linux.dev>
    pppoe: drop PFC frames

Michael Bommarito <michael.bommarito@gmail.com>
    sctp: fix OOB write to userspace in sctp_getsockopt_peer_auth_chunks

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Drop all SCM attributes for SOCKMAP.

Eric Dumazet <edumazet@google.com>
    ipv6: fix possible UAF in icmpv6_rcv()

Matt Vollrath <tactii@gmail.com>
    e1000e: Unroll PTP in probe error handling

Petr Oros <poros@redhat.com>
    iavf: fix wrong VLAN mask for legacy Rx descriptors L2TAG2

Kohei Enju <kohei@enjuk.jp>
    i40e: don't advertise IFF_SUPP_NOFCS

Kohei Enju <kohei@enjuk.jp>
    ice: fix potential NULL pointer deref in error path of ice_set_ringparam()

Keita Morisaki <kmta1236@gmail.com>
    ice: fix race condition in TX timestamp ring cleanup

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: fix ICE_AQ_LINK_SPEED_M for 200G

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: fix PHY config on media change with link-down-on-close

Michal Schmidt <mschmidt@redhat.com>
    ice: fix double-free of tx_buf skb

Grzegorz Nitka <grzegorz.nitka@intel.com>
    ice: update PCS latency settings for E825 10G/25Gb modes

Grzegorz Nitka <grzegorz.nitka@intel.com>
    ice: fix 'adjust' timer programming for E830 devices

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around tp->plb_rehash

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around (tp->write_seq - tp->snd_nxt)

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around tp->timeout_rehash

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around tp->srtt_us

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around tp->reord_seen

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around tp->dsack_dups

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around tp->bytes_retrans

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around tp->bytes_sent

Eric Dumazet <edumazet@google.com>
    tcp: add data-race annotations for TCP_NLA_SNDQ_SIZE

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around tp->delivered and tp->delivered_ce

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around tp->snd_ssthresh

Eric Dumazet <edumazet@google.com>
    tcp: add data-races annotations around tp->reordering, tp->snd_cwnd

Eric Dumazet <edumazet@google.com>
    tcp: add data-race annotations around tp->data_segs_out and tp->total_retrans

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races in tcp_get_info_chrono_stats()

Eric Dumazet <edumazet@google.com>
    tcp: inline tcp_chrono_start()

Eric Dumazet <edumazet@google.com>
    tcp: move tp->chrono_type next tp->chrono_stat[]

Akif <akif.sait111@gmail.com>
    ksmbd: fix use-after-free in smb2_open during durable reconnect

Wei Fang <wei.fang@nxp.com>
    net: enetc: fix NTMP DMA use-after-free issue

Wei Fang <wei.fang@nxp.com>
    net: enetc: correct the command BD ring consumer index

Stanislav Fomichev <sdf.kernel@gmail.com>
    net: dsa: remove redundant netdev_lock_ops() from conduit ethtool ops

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    net/sched: taprio: fix use-after-free in advance_sched() on schedule switch

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Wait for NPU PPE configuration to complete in airoha_ppe_offload_setup()

Jiayuan Chen <jiayuan.chen@linux.dev>
    nexthop: fix IPv6 route referencing IPv4 nexthop

Dudu Lu <phx0fer@gmail.com>
    net/sched: sch_cake: fix NAT destination port not being updated in cake_update_flowkeys

Dudu Lu <phx0fer@gmail.com>
    macvlan: fix macvlan_get_size() not reserving space for IFLA_MACVLAN_BC_CUTOFF

Dudu Lu <phx0fer@gmail.com>
    net/sched: act_mirred: fix wrong device for mac_header_xmit check in tcf_blockcast_redir

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: stm32: Fix rounding issue for requests with inverted polarity

Gabor Juhos <j4g8y7@gmail.com>
    arm64: dts: marvell: armada-37xx: use 'usb2-phy' in USB3 controller's phy-names

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mm-tqma8mqml: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mn-tqma8mqnl: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mm-emtop-som: Correct PAD settings for PMIC_nINT

Ronald Claveau <linux-kernel-dev@aliel.fr>
    reset: amlogic: t7: Fix null reset ops

René Rebe <rene@exactco.de>
    PCMCIA: Fix garbled log messages for KERN_CONT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-data-modul-edm-sbc: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-dhcom-som: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-ultra-mach-sbc: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-sr-som: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-nitrogen-som: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-aristainetos3a-som-v1: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-edm-g: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-icore-mx8mp: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-navqp: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-debix-som-a: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-debix-model-a: Correct PAD settings for PMIC_nINT

Jork Loeser <jloeser@linux.microsoft.com>
    Drivers: hv: vmbus: fix hyperv_cpuhp_online variable shadowing

Aditya Garg <gargaditya@linux.microsoft.com>
    tools: hv: Fix cross-compilation

Gao Xiang <xiang@kernel.org>
    erofs: unify lcn as u64 for 32-bit platforms

Gao Xiang <xiang@kernel.org>
    erofs: fix offset truncation when shifting pgoff on 32-bit platforms

Thomas Zimmermann <tzimmermann@suse.de>
    sh: Include <linux/io.h> in dac.h

Paul Moses <p@1g4.org>
    crypto: ccp - copy IV using skcipher ivsize

T Pratham <t-pratham@ti.com>
    crypto: sa2ul - Fix AEAD fallback algorithm names

Aleksander Jan Bajkowski <olek2@wp.pl>
    crypto: eip93 - fix hmac setkey algo selection

Sami Mujawar <sami.mujawar@arm.com>
    virt: arm-cca-guest: fix error check for RSI_INCOMPLETE

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/wm: Verify the correct plane DDB entry

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: protect extension_list reading with sb_lock in f2fs_sbi_show()

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: allow empty mount string for Opt_usr|grp|projjquota

Brian Masney <bmasney@redhat.com>
    clk: visconti: pll: initialize clk_init_data to zero

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    clk: qcom: gcc-x1e80100: Keep GCC USB QTB clock always ON

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix parameter mismatch in panel self-refresh helper

Pengpeng Hou <pengpeng@iscas.ac.cn>
    scsi: hpsa: Enlarge controller and IRQ name buffers

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to preserve previous reserve_{blocks,node} value when remount

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix data loss caused by incorrect use of nat_entry flag

Geert Uytterhoeven <geert+renesas@glider.be>
    lib/hexdump: print_hex_dump_bytes() calls print_hex_dump_debug()

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    clk: qcom: gdsc: Fix error path on registration of multiple pm subdomains

John Ogness <john.ogness@linutronix.de>
    printk_ringbuffer: Fix get_data() size sanity check

Jianan Huang <huangjianan@xiaomi.com>
    f2fs: avoid reading already updated pages during GC

Shuwei Wu <shuwei.wu@mailbox.org>
    clk: spacemit: ccu_mix: fix inverted condition in ccu_mix_trigger_fc()

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: xgene: Fix mapping leak in xgene_pllclk_init()

Arnd Bergmann <arnd@arndb.de>
    clk: qoriq: avoid format string warning

Thomas Weißschuh <linux@weissschuh.net>
    x86/um: fix vDSO installation

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix potential race condition in TLB sync

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    clk: imx8mq: Correct the CSI PHY sels

Felix Gu <ustc.gu@gmail.com>
    clk: imx: imx6q: Fix device node reference leak in of_assigned_ldb_sels()

Felix Gu <ustc.gu@gmail.com>
    clk: imx: imx6q: Fix device node reference leak in pll6_bypassed()

Val Packett <val@packett.cool>
    clk: qcom: dispcc-sm8250: Enable parents for pixel clocks

Val Packett <val@packett.cool>
    clk: qcom: dispcc-sm8250: Use shared ops on the mdss vsync clk

Val Packett <val@packett.cool>
    clk: qcom: gcc-sc8180x: Use retention for PCIe power domains

Val Packett <val@packett.cool>
    clk: qcom: gcc-sc8180x: Use retention for USB power domains

Val Packett <val@packett.cool>
    clk: qcom: gcc-sc8180x: Add missing GDSCs

Val Packett <val@packett.cool>
    dt-bindings: clock: qcom,gcc-sc8180x: Add missing GDSCs

Shawn Lin <shawn.lin@rock-chips.com>
    scsi: ufs: rockchip,rk3576-ufshc: dt-bindings: Add new mphy reset item

Junrui Luo <moonafterrain@outlook.com>
    scsi: target: core: Fix integer overflow in UNMAP bounds check

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Add support to report MPI FW state

Fabrizio Castro <fabrizio.castro.jz@renesas.com>
    clk: renesas: r9a09g057: Remove entries for WDT{0,2,3}

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: dispcc[01]-sa8775p: Fix DSI byte clock rate setting

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: dispcc-sm4450: Fix DSI byte clock rate setting

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: dispcc-milos: Fix DSI byte clock rate setting

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: dispcc-kaanapali: Fix DSI byte clock rate setting

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: dispcc-glymur: Fix DSI byte clock rate setting

White Lewis <liu224806@gmail.com>
    clk: qcom: dispcc-sc8280xp: remove CLK_SET_RATE_PARENT from byte_div_clk_src dividers

Yang Erkun <yangerkun@huawei.com>
    scsi: sg: Resolve soft lockup issue when opening /dev/sgX

Yang Erkun <yangerkun@huawei.com>
    scsi: sg: Fix sysctl sg-big-buff register during sg_init()

Chen-Yu Tsai <wens@kernel.org>
    clk: sunxi-ng: sun55i-a523-r: Add missing r-spi module clock

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    clk: renesas: r9a09g056: Fix ordering of module clocks array

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    clk: renesas: r9a09g057: Fix ordering of module clocks array

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    clk: qcom: dispcc-sm8450: use RCG2 ops for DPTX1 AUX clock source

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    clk: qcom: dispcc-glymur: use RCG2 ops for DPTX1 AUX clock source

Taniya Das <taniya.das@oss.qualcomm.com>
    clk: qcom: gcc-glymur: Add video axi clock resets for glymur

Taniya Das <taniya.das@oss.qualcomm.com>
    dt-bindings: clock: qcom: Add GCC video axi reset clock for Glymur

Krishna Chomal <krishna.chomal108@gmail.com>
    platform/x86: hp-wmi: fix fan table parsing

Florian Westphal <fw@strlen.de>
    RDMA/core: Prefer NLA_NUL_STRING

Pengpeng Hou <pengpeng@iscas.ac.cn>
    platform/x86: dell-wmi-sysman: bound enumeration string aggregation

Fedor Pchelkin <pchelkin@ispras.ru>
    platform/x86: dell_rbu: avoid uninit value usage in packet_size_write()

Emre Cecanpunar <emreleno@gmail.com>
    platform/x86: hp-wmi: add locking for concurrent hwmon access

Emre Cecanpunar <emreleno@gmail.com>
    platform/x86: hp-wmi: fix u8 underflow in gpu_delta calculation

Emre Cecanpunar <emreleno@gmail.com>
    platform/x86: hp-wmi: use mod_delayed_work to reset keep-alive timer

Emre Cecanpunar <emreleno@gmail.com>
    platform/x86: hp-wmi: avoid cancel_delayed_work_sync from work handler

Emre Cecanpunar <emreleno@gmail.com>
    platform/x86: hp-wmi: fix ignored return values in fan settings

Pengpeng Hou <pengpeng@iscas.ac.cn>
    fs/ntfs3: terminate the cached volume label after UTF-8 conversion

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    tty: serial: ip22zilog: Fix section mispatch warning

Denis Benato <denis.benato@linux.dev>
    platform/x86: asus-wmi: fix screenpad brightness range

Denis Benato <denis.benato@linux.dev>
    platform/x86: asus-wmi: adjust screenpad power/brightness handling

Damien Riégel <damien.riegel@silabs.com>
    greybus: raw: fix use-after-free if write is called after disconnect

Damien Riégel <damien.riegel@silabs.com>
    greybus: raw: fix use-after-free on cdev close

Leon Romanovsky <leon@kernel.org>
    RDMA/umem: Use consistent DMA attributes when unmapping entries

Chuck Lever <chuck.lever@oracle.com>
    nfsd: use dynamic allocation for oversized NFSv4.0 replay cache

Dai Ngo <dai.ngo@oracle.com>
    NFSD: fix nfs4_file access extra count in nfsd4_add_rdaccess_to_wrdeleg

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    sunrpc: Fix compilation error (`make W=1`) when dprintk() is no-op

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    sunrpc: Kill RPC_IFDEBUG()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    nfs/blocklayout: Fix compilation error (`make W=1`) in bl_write_pagelist()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    mfd: mc13xxx-core: Fix memory leak in mc13xxx_add_subdevice_pdata()

Deepanshu Kartikey <kartikey406@gmail.com>
    fs/ntfs3: fix missing run load for vcn0 in attr_data_get_block_locked()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    platform/x86: barco-p50-gpio: normalize return value of gpio_get

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: panasonic-laptop: Fix OPTD notifier registration and cleanup

Mostafa Saleh <smostafa@google.com>
    usb: typec: ps883x: Fix Oops at unbind

Randy Dunlap <rdunlap@infradead.org>
    tty: hvc_iucv: fix off-by-one in number of supported devices

Ethan Tidmore <ethantidmore06@gmail.com>
    usb: typec: Fix error pointer dereference

Chen Ni <nichen@iscas.ac.cn>
    leds: lgm-sso: Remove duplicate assignments for priv->mmap

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/surface: surfacepro3_button: Drop wakeup source on remove

Chen Ni <nichen@iscas.ac.cn>
    backlight: sky81452-backlight: Check return value of devm_gpiod_get_optional() in sky81452_bl_parse_dt()

Edward Adam Davis <eadavis@qq.com>
    fs/ntfs3: prevent uninitialized lcn caused by zero len

Billy Tsai <billy_tsai@aspeedtech.com>
    i3c: mipi-i3c-hci: fix IBI payload length calculation for final status

Jorge Marques <jorge.marques@analog.com>
    i3c: master: adi: Fix error propagation for CCCs

Jorge Marques <jorge.marques@analog.com>
    i3c: master: Fix error codes at send_ccc_cmd

Felix Gu <ustc.gu@gmail.com>
    i3c: dw: Fix memory leak in dw_i3c_master_i3c_xfers()

Felix Gu <ustc.gu@gmail.com>
    i3c: master: renesas: Fix memory leak in renesas_i3c_i3c_xfers()

Felix Gu <ustc.gu@gmail.com>
    i3c: master: dw-i3c: Balance PM runtime usage count on probe failure

Felix Gu <ustc.gu@gmail.com>
    i3c: master: dw-i3c: Fix missing reset assertion in remove() callback

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf util: Kill die() prototype, dead for a long time

Ian Rogers <irogers@google.com>
    perf maps: Fix copy_from that can break sorted by name order

Ian Rogers <irogers@google.com>
    perf maps: Fix fixup_overlap_and_insert that can break sorted by name order

Inochi Amaoto <inochiama@gmail.com>
    pinctrl: sophgo: pinctrl-sg2044: Fix wrong module description

Inochi Amaoto <inochiama@gmail.com>
    pinctrl: sophgo: pinctrl-sg2042: Fix wrong module description

Ian Rogers <irogers@google.com>
    perf cgroup: Update metric leader in evlist__expand_cgroup

Jian Zhang <zhangjian.3032@bytedance.com>
    ipmi: ssif_bmc: change log level to dbg in irq callback

Jian Zhang <zhangjian.3032@bytedance.com>
    ipmi: ssif_bmc: fix message desynchronization after truncated response

Jian Zhang <zhangjian.3032@bytedance.com>
    ipmi: ssif_bmc: fix missing check for copy_to_user() partial failure

Ian Rogers <irogers@google.com>
    perf metrics: Make common stalled metrics conditional on having the event

Leo Yan <leo.yan@arm.com>
    perf expr: Return -EINVAL for syntax error in expr__find_ids()

Thomas Richter <tmricht@linux.ibm.com>
    perf test: Skip perf data type profiling tests for s390

Thomas Falcon <thomas.falcon@intel.com>
    perf test: Fix ratio_to_prev event parsing test

Chuck Lever <chuck.lever@oracle.com>
    perf tools: Fix module symbol resolution for non-zero .text sh_addr

Breno Leitao <leitao@debian.org>
    perf stat: Fix crash on arm64

Mike Rapoport (Microsoft) <rppt@kernel.org>
    memblock: reserve_mem: fix end caclulation in reserve_mem_release_by_name()

Ian Rogers <irogers@google.com>
    perf stat: Fix opt->value type for parse_cache_level

Ian Rogers <irogers@google.com>
    perf lock: Fix option value type in parse_max_stack

Leo Yan <leo.yan@arm.com>
    tools build: Correct link flags for libopenssl

Biju Das <biju.das.jz@bp.renesas.com>
    pinctrl: renesas: rzg2l: Fix save/restore of {IOLH,IEN,PUPD,SMT} registers

Yu-Chun Lin <eleanor.lin@realtek.com>
    pinctrl: abx500: Fix type of 'argument' variable

Yu-Chun Lin <eleanor.lin@realtek.com>
    pinctrl: realtek: Fix function signature for config argument

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: pinconf-generic: Fully validate 'pinmux' property

Mike Leach <mike.leach@arm.com>
    perf: tools: cs-etm: Fix print issue for Coresight debug in ETE/TRBE trace

Ian Rogers <irogers@google.com>
    perf branch: Avoid incrementing NULL

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: cy8c95x0: Avoid returning positive values to user space

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: cy8c95x0: Unify messages with help of dev_err_probe()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: cy8c95x0: remove duplicate error message

Ian Rogers <irogers@google.com>
    perf test type profiling: Remote typedef on struct

Felix Gu <ustc.gu@gmail.com>
    pinctrl: microchip-mssio: Fix missing return in probe

Ian Rogers <irogers@google.com>
    perf trace: Avoid an ERR_PTR in syscall_stats

Ethan Tidmore <ethantidmore06@gmail.com>
    pinctrl: pinctrl-pic32: Fix resource leak

Gabor Juhos <j4g8y7@gmail.com>
    dt-bindings: pinctrl: marvell,armada3710-xb-pinctrl: add missing items keyword

wangguangju <wangguangju@hygon.cn>
    perf trace: Fix IS_ERR() vs NULL check bug

Puranjay Mohan <puranjay@kernel.org>
    bpf, arm32: Reject BPF-to-BPF calls and callbacks in the JIT

Puranjay Mohan <puranjay@kernel.org>
    bpf: Validate node_id in arena_alloc_pages()

Jiri Olsa <jolsa@kernel.org>
    libbpf: Prevent double close and leak of btf objects

Yihan Ding <dingyihan@uniontech.com>
    bpf: allow UTF-8 literals in bpf_bprintf_prepare()

Mykyta Yatsenko <yatsenko@meta.com>
    bpf: Fix NULL deref in map_kptr_match_type for scalar regs

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix precedence bug in convert_bpf_ld_abs alignment check

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Take state lock for af_unix iter

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Fix af_unix null-ptr-deref in proto update

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Fix af_unix iter deadlock

Puranjay Mohan <puranjay@kernel.org>
    bpf, riscv: Remove redundant bpf_flush_icache() after pack allocator finalize

Puranjay Mohan <puranjay@kernel.org>
    bpf, arm64: Remove redundant bpf_flush_icache() after pack allocator finalize

Daniel Borkmann <daniel@iogearbox.net>
    bpf, arm64: Fix off-by-one in check_imm signed range check

Daniel Borkmann <daniel@iogearbox.net>
    bpf, arm64: Reject out-of-range B.cond targets

Ye Bin <yebin10@huawei.com>
    ext4: fix possible null-ptr-deref in mbt_kunit_exit()

Ye Bin <yebin10@huawei.com>
    ext4: fix possible null-ptr-deref in extents_kunit_exit()

Ye Bin <yebin10@huawei.com>
    ext4: fix the error handling process in extents_kunit_init).

Ye Bin <yebin10@huawei.com>
    ext4: call deactivate_super() in extents_kunit_exit()

Ye Bin <yebin10@huawei.com>
    ext4: fix miss unlock 'sb->s_umount' in extents_kunit_init()

Oliver Neukum <oneukum@suse.com>
    HID: usbhid: fix deadlock in hid_post_reset()

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spinand: winbond: Clarify when to enable the HS bit

Richard Genoud <richard.genoud@bootlin.com>
    mtd: rawnand: sunxi: fix sunxi_nfc_hw_ecc_read_extra_oob

Li Ming <ming.li@zohomail.com>
    cxl/pci: Check memdev driver binding status in cxl_reset_done()

Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
    mtd: parsers: ofpart: call of_node_get() for dedicated subpartitions

Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
    mtd: parsers: ofpart: call of_node_put() only in ofpart_fail path

Shiji Yang <yangshiji66@outlook.com>
    mtd: spi-nor: swp: check SR_TB flag when getting tb_mask

Haibo Chen <haibo.chen@nxp.com>
    mtd: spi-nor: micron-st: add SNOR_CMD_PP_8_8_8_DTR sfdp fixup for mt35xu512aba

Jonas Gorski <jonas.gorski@gmail.com>
    mtd: spi-nor: update spi_nor_fixups::post_sfdp() documentation

Haibo Chen <haibo.chen@nxp.com>
    mtd: spi-nor: core: correct the op.dummy.nbytes when check read operations

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: interrupt-controller: arm,gic-v3: Fix EPPI range

Dmitry Safonov <0x7f454c46@gmail.com>
    ima_fs: Correctly create securityfs files for unsupported hash algos

Chen Ni <nichen@iscas.ac.cn>
    mtd: physmap_of_gemini: Fix disabled pinctrl state check

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    power: supply: max77705: Free allocated workqueue and fix removal order

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    power: supply: max77705: Drop duplicated IRQ error message

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    workqueue: devres: Add device-managed allocate workqueue

Denis Benato <denis.benato@linux.dev>
    HID: asus: do not abort probe when not necessary

Denis Benato <denis.benato@linux.dev>
    HID: asus: make asus_resume adhere to linux kernel coding standards

Daniel Hodges <hodgesd@meta.com>
    ima: check return value of crypto_shash_final() in boot aggregate

Chen Ni <nichen@iscas.ac.cn>
    remoteproc: imx_rproc: Check return value of regmap_attach_dev() in imx_rproc_mmio_detect_mode()

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    stop_machine: Fix the documentation for a NULL cpus argument

Tim Michals <tcmichals@yahoo.com>
    remoteproc: xlnx: Fix sram property parsing

Francesco Lavra <flavra@baylibre.com>
    hte: tegra194: remove Kconfig dependency on Tegra194 SoC

Pengpeng Hou <pengpeng@iscas.ac.cn>
    tracing: Rebuild full_name on each hist_field_name() call

Arnd Bergmann <arnd@arndb.de>
    tracing: move __printf() attribute on __ftrace_vbprintk()

Richard Fitzgerald <rf@opensource.cirrus.com>
    soundwire: cadence: Clear message complete before signaling waiting thread

Frank Li <Frank.Li@nxp.com>
    dmaengine: mxs-dma: Fix missing return value from of_dma_controller_register()

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: Intel: test bus.bpt_stream before assigning it

Cole Leavitt <cole@unwrap.rs>
    soundwire: bus: demote UNATTACHED state warnings to dev_dbg()

Janne Grunau <j@jannau.net>
    phy: apple: apple: Use local variable for ioremap return value

Khairul Anuar Romli <karom.9560@gmail.com>
    dmaengine: dw-axi-dmac: Remove unnecessary return statement from void function

Khairul Anuar Romli <karom.9560@gmail.com>
    dmaengine: dw-axi-dmac: fix Alignment should match open parenthesis

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: validate group add input before caching

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: validate bg_bits during freefrag scan

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: fix listxattr handling when the buffer is full

Richard Cheng <icheng@nvidia.com>
    fwctl: Fix class init ordering to avoid NULL pointer dereference on device removal

Sebastian Ene <sebastianene@google.com>
    firmware: arm_ffa: Use the correct buffer size during RXTX_MAP

Frank Li <Frank.Li@nxp.com>
    ARM: dts: imx27-eukrea: replace interrupts with interrupts-extended

Christian A. Ehrhardt <lk@c--e.de>
    lib: kunit_iov_iter: fix memory leaks

Christoph Hellwig <hch@lst.de>
    arm64/xor: fix conflicting attributes for xor_block_template

Aaro Koskinen <aaro.koskinen@iki.fi>
    ARM: OMAP1: Fix DEBUG_LL and earlyprintk on OMAP16XX

Alexander Koskovich <AKoskovich@pm.me>
    arm64: dts: qcom: sm8250: Add missing CPU7 3.09GHz OPP

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: milos: Add missing CX power domain to GCC

Alok Tiwari <alok.a.tiwari@oracle.com>
    soc: qcom: aoss: compare against normalized cooling state

Alok Tiwari <alok.a.tiwari@oracle.com>
    soc: qcom: llcc: fix v1 SB syndrome register offset

Junrui Luo <moonafterrain@outlook.com>
    ocfs2/dlm: fix off-by-one in dlm_match_regions() region comparison

Junrui Luo <moonafterrain@outlook.com>
    ocfs2/dlm: validate qr_numregions in dlm_match_regions()

Michal Grzedzicki <mge@meta.com>
    unshare: fix nsproxy leak in ksys_unshare() on set_cred_ucounts() failure

Jon Hunter <jonathanh@nvidia.com>
    soc/tegra: pmc: Add kerneldoc for wake-up variables

Jon Hunter <jonathanh@nvidia.com>
    soc/tegra: pmc: Correct function names in kerneldoc

Jon Hunter <jonathanh@nvidia.com>
    soc/tegra: pmc: Add kerneldoc for reboot notifier

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Fix RTC aliases

Sumit Gupta <sumitg@nvidia.com>
    soc/tegra: cbb: Fix cross-fabric target timeout lookup

Sumit Gupta <sumitg@nvidia.com>
    soc/tegra: cbb: Fix incorrect ARRAY_SIZE in fabric lookup tables

Sumit Gupta <sumitg@nvidia.com>
    soc/tegra: cbb: Set ERD on resume for err interrupt

Xu Yang <xu.yang_2@nxp.com>
    arm64: dts: imx8qxp-mek: switch Type-C connector power-role to dual

Xu Yang <xu.yang_2@nxp.com>
    arm64: dts: imx8qm-mek: switch Type-C connector power-role to dual

Josua Mayer <josua@solid-run.com>
    arm64: dts: lx2160a: complete pinmux for rcwsr12 configuration word

Josua Mayer <josua@solid-run.com>
    arm64: dts: lx2160a: change zeros to hexadecimal in pinmux nodes

Josua Mayer <josua@solid-run.com>
    arm64: dts: lx2160a: add sda gpio references for i2c bus recovery

Josua Mayer <josua@solid-run.com>
    arm64: dts: lx2160a: rename pinmux nodes for readability

Josua Mayer <josua@solid-run.com>
    arm64: dts: lx2160a: remove duplicate pinmux nodes

Josua Mayer <josua@solid-run.com>
    arm64: dts: lx2160a: change i2c0 (iic1) pinmux mask to one bit

Liu Ying <victor.liu@nxp.com>
    arm64: dts: imx8mp-evk: Specify ADV7535 register addresses

Shengjiu Wang <shengjiu.wang@nxp.com>
    arm64: dts: imx8dxl-evk: Use audio-graph-card2 for wm8960-2 and wm8960-3

Annette Kobou <annette.kobou@kontron.de>
    arm64: dts: imx8mp-kontron: Fix boot order for PMIC and RTC

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: imx91: Remove TMU's superfluous sensor ID

Nora Schiffer <nora.schiffer@ew.tq-group.com>
    arm64: dts: freescale: imx8mp-tqma8mpql-mba8mp-ras314: fix UART1 RTS/CTS muxing

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: ti: k3-am62-verdin: Fix SPI_1 GPIO CS pinctrl label

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62-lp-sk: Enable internal pulls for MMC0 data pins

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62l3-evm: Disable MMC1 internal pulls on data pins

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62p5-sk: Disable MMC1 internal pulls on data pins

Barnabás Czémán <barnabas.czeman@mainlining.org>
    arm64: dts: qcom: msm8917-xiaomi-riva: Fix board-id for all bootloader

David Heidelberg <david@ixit.cz>
    arm64: dts: qcom: sdm845-xiaomi-beryllium: Mark l1a regulator as powered during boot

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm7225-fairphone-fp4: Fix conflicting bias pinctrl

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sm8650: Enable UHS-I SDR50 and SDR104 SD card modes

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sm8550: Enable UHS-I SDR50 and SDR104 SD card modes

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sm8450: Enable UHS-I SDR50 and SDR104 SD card modes

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: hamoa: Fix xo clock supply of platform SD host controller

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sm8650: Fix xo clock supply of SD host controller

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sm8550: Fix xo clock supply of platform SD host controller

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sm8750: Fix GIC_ITS range length

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sm8650: Fix GIC_ITS range length

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sm8550: Fix GIC_ITS range length

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sm8450: Fix GIC_ITS range length

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: milos: Fix GIC_ITS range length

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: kaanapali: Fix GIC_ITS range length

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: sm8750: correct Iris corners for the MXC rail

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: sm8650: correct Iris corners for the MXC rail

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: sm8550: correct Iris corners for the MXC rail

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: monaco: correct Iris corners for the MXC rail

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: lemans: correct Iris corners for the MXC rail

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: hamoa: correct Iris corners for the MXC rail

Tobias Heider <tobias.heider@canonical.com>
    arm64: dts: qcom: add missing denali-oled.dtb to Makefile

Riccardo Mereu <r.mereu@arduino.cc>
    arm64: dts: qcom: arduino-imola: fix faulty spidev node

Gatien Chevallier <gatien.chevallier@foss.st.com>
    bus: rifsc: fix RIF configuration check for peripherals

Shawn Lin <shawn.lin@rock-chips.com>
    arm64: dts: rockchip: Add mphy reset to ufshc node

谢致邦 (XIE Zhibang) <Yeking@Red54.com>
    arm64: dts: rockchip: Fix RK3562 EVB2 model name

Aurelien Jarno <aurelien@aurel32.net>
    riscv: dts: spacemit: drop incorrect pinctrl for combo PHY

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    soc: qcom: ocmem: return -EPROBE_DEFER is ocmem is not available

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    soc: qcom: ocmem: register reasons for probe deferrals

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    soc: qcom: ocmem: make the core clock optional

Chris Morgan <macromorgan@hotmail.com>
    arm64: dts: rockchip: Correct Joystick Axes on Gameforce Ace

Chris Morgan <macromorgan@hotmail.com>
    arm64: dts: rockchip: Correct Fan Supply for Gameforce Ace

Robin Murphy <robin.murphy@arm.com>
    Revert "arm64: dts: rockchip: add SPDIF audio to Beelink A1"

Ming Wang <wangming5719@gmail.com>
    arm64: dts: rockchip: Fix Bluetooth stability on LCKFB TaiShan Pi

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    soc: qcom: ubwc: disable bank swizzling for Glymur platform

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware: qcom_scm: don't opencode kmemdup

Barnabás Czémán <barnabas.czeman@mainlining.org>
    arm64: dts: qcom: msm8953-xiaomi-daisy: fix backlight

Barnabás Czémán <barnabas.czeman@mainlining.org>
    arm64: dts: qcom: msm8937-xiaomi-land: correct wled ovp value

Barnabás Czémán <barnabas.czeman@mainlining.org>
    arm64: dts: qcom: msm8953-xiaomi-vince: correct wled ovp value

Miquel Raynal <miquel.raynal@bootlin.com>
    ARM: dts: BCM5301X: Drop extra NAND controller compatible

Josua Mayer <josua@solid-run.com>
    arm64: dts: imx8mp-hummingboard-pulse: fix mini-hdmi dsi port reference

Josua Mayer <josua@solid-run.com>
    arm64: dts: imx8mp-hummingboard-pulse/cubox-m: fix vmmc gpio polarity

Frieder Schrempf <frieder.schrempf@kontron.de>
    arm64: dts: imx8mp-kontron: Drop vmmc-supply to fix SD card on SMARC eval carrier

Frieder Schrempf <frieder.schrempf@kontron.de>
    arm64: dts: imx8mp-kontron: Fix touch reset configuration on DL devices

Thorsten Blum <thorsten.blum@linux.dev>
    iommufd/selftest: Fix page leaks in mock_viommu_{init,destroy}

Akari Tsuyukusa <akkun11.open@gmail.com>
    arm64: dts: mediatek: mt7986a: Fix gpio-ranges pin count

Akari Tsuyukusa <akkun11.open@gmail.com>
    arm64: dts: mediatek: mt7981b: Fix gpio-ranges pin count

Akari Tsuyukusa <akkun11.open@gmail.com>
    arm64: dts: mediatek: mt6795: Fix gpio-ranges pin count

Kendall Willis <k-willis@ti.com>
    arm64: dts: ti: k3-am62l: include WKUP_UART0 in wakeup peripheral window

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: talos: Add missing clock-names to GCC

Hongyang Zhao <hongyang.zhao@thundersoft.com>
    arm64: dts: qcom: qcs6490-rubikpi3: Use lt9611 DSI Port B

Barnabás Czémán <barnabas.czeman@mainlining.org>
    arm64: dts: qcom: sm6125-xiaomi-ginkgo: Fix reserved gpio ranges

Barnabás Czémán <barnabas.czeman@mainlining.org>
    arm64: dts: qcom: sm6125-xiaomi-ginkgo: Remove extcon

Barnabás Czémán <barnabas.czeman@mainlining.org>
    arm64: dts: qcom: sm6125-xiaomi-ginkgo: Correct reserved memory ranges

Barnabás Czémán <barnabas.czeman@mainlining.org>
    arm64: dts: qcom: sm6125-xiaomi-ginkgo: Remove board-id

Jacob Pan <jacob.pan@linux.microsoft.com>
    iommufd: vfio compatibility extension check for noiommu mode

Sherry Sun <sherry.sun@nxp.com>
    arm64: dts: imx8mp-evk: Enable pull select bit for PCIe regulator GPIO (M.2 W_DISABLE1)

Heiko Stuebner <heiko.stuebner@cherry.de>
    arm64: dts: rockchip: Make Jaguar PCIe-refclk pin use pull-up config

Frank Wunderlich <frank-w@public-files.de>
    arm64: dts: mediatek: mt7988a-bpi-r4pro: fix model string

Yixun Lan <dlan@kernel.org>
    riscv: dts: spacemit: pcie: fix missing power regulator

Luke Wang <ziniu.wang_1@nxp.com>
    arm64: dts: imx91-11x11-evk: change usdhc tuning step for eMMC and SD

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: imx8-apalis: Fix LEDs name collision

Mikko Perttunen <mperttunen@nvidia.com>
    memory: tegra30-emc: Fix dll_change check

Mikko Perttunen <mperttunen@nvidia.com>
    memory: tegra124-emc: Fix dll_change check

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: mediatek: mt7623: fix efuse fallback compatible

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    arm64: dts: mediatek: mt8365: Describe infracfg-nao as a pure syscon

Joshua Klinesmith <joshuaklinesmith@gmail.com>
    ksmbd: fix use-after-free from async crypto on Qualcomm crypto engine

Thomas Huth <thuth@redhat.com>
    efi/capsule-loader: fix incorrect sizeof in phys array reallocation

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: prevent NULL pointer dereference during unmount

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: add some missing log locking

Arnd Bergmann <arnd@arndb.de>
    vfio: unhide vdev->debug_root

Jan Kara <jack@suse.cz>
    quota: Fix race of dquot_scan_active() with quota deactivation

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: less aggressive low-memory log flushing

Ted Logan <tedlogan@fb.com>
    vfio: selftests: Build tests on aarch64

Tomas Glozar <tglozar@redhat.com>
    rtla: Fix segfault on multiple SIGINTs

Costa Shulyupin <costa.shul@redhat.com>
    tools/rtla: Generate optstring from long options

Wander Lairson Costa <wander@redhat.com>
    rtla/utils: Fix resource leak in set_comm_sched_attr()

Wander Lairson Costa <wander@redhat.com>
    rtla/trace: Fix write loop in trace_event_save_hist()

Wander Lairson Costa <wander@redhat.com>
    rtla: Use str_has_prefix() for prefix checks

Wander Lairson Costa <wander@redhat.com>
    rtla: Simplify code by caching string lengths

Alex Mastro <amastro@fb.com>
    vfio: selftests: fix crash in vfio_dma_mapping_mmio_test

Ricardo B. Marlière <rbm@suse.com>
    ktest: Run POST_KTEST hooks on failure and cancellation

Ricardo B. Marlière <rbm@suse.com>
    ktest: Honor empty per-test option overrides

Ricardo B. Marlière <rbm@suse.com>
    ktest: Avoid undef warning when WARNINGS_FILE is unset

Luis Henriques <luis@igalia.com>
    fuse: fix uninit-value in fuse_dentry_revalidate()

Jingbo Xu <jefflexu@linux.alibaba.com>
    fuse: fix premature writetrhough request for large folio

Ondrej Mosnacek <omosnace@redhat.com>
    fanotify: call fanotify_events_supported() before path_permission() and security_path_notify()

Ondrej Mosnacek <omosnace@redhat.com>
    fanotify: avoid/silence premature LSM capability checks

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Call unlock_new_inode before d_instantiate

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - fixed speaker no sound update

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Exclude Scarlett 18i20 1st Gen from SKIP_IFACE_SETUP

Haixin Xu <jerryxucs@gmail.com>
    crypto: jitterentropy - replace long-held spinlock with mutex

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: cadence-qspi: Revert the filtering of certain opcodes in ODTR

Tejun Heo <tj@kernel.org>
    sched_ext: Fix ops.cgroup_move() invocation kf_mask and rq tracking

Tejun Heo <tj@kernel.org>
    sched_ext: Track @p's rq lock across set_cpus_allowed_scx -> ops.set_cpumask

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix missing return in invalidate_committed's error path

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: sc6000: Keep the programmed board state in card-private data

Pei Xiao <xiaopei01@kylinos.cn>
    spi: mtk-snfi: unregister ECC engine on probe failure and remove() callback

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    spi: rzv2h-rspi: Fix invalid SPR=0/BRDV=0 clock configuration

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: SDCA: Fix cleanup inversion in class driver

Yao Zi <me@ziyao.cc>
    PCI: sg2042: Avoid L0s and L1 on Sophgo 2042 PCIe Root Ports

Yao Zi <me@ziyao.cc>
    PCI: cadence: Add flags for disabling ASPM capability for broken Root Ports

Bart Van Assche <bvanassche@acm.org>
    drm/fb-helper: Fix a locking bug in an error path

Manikanta Maddireddy <mmaddireddy@nvidia.com>
    PCI: tegra194: Fix CBB timeout caused by DBI access before core power-on

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Disable L1.2 capability of Tegra234 EP

Manikanta Maddireddy <mmaddireddy@nvidia.com>
    PCI: dwc: Apply ECRC workaround to DesignWare 5.00a as well

Manikanta Maddireddy <mmaddireddy@nvidia.com>
    PCI: tegra194: Use DWC IP core version

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Free up Endpoint resources during remove()

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Allow system suspend when the Endpoint link is not up

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Set LTR message request before PCIe link up in Endpoint mode

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Disable direct speed change for Endpoint mode

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Use devm_gpiod_get_optional() to parse "nvidia,refclk-select"

Manikanta Maddireddy <mmaddireddy@nvidia.com>
    PCI: tegra194: Disable PERST# IRQ only in Endpoint mode

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Don't force the device into the D0 state before L2

Manikanta Maddireddy <mmaddireddy@nvidia.com>
    PCI: tegra194: Disable LTSSM after transition to Detect on surprise link down

Manikanta Maddireddy <mmaddireddy@nvidia.com>
    PCI: tegra194: Increase LTSSM poll time on surprise link down

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Fix polling delay for L2 state

songxiebing <songxiebing@kylinos.cn>
    ALSA: usb-audio: qcom: Fix incorrect type in enable_audio_stream

Syed Saba Kareem <syed.sabakareem@amd.com>
    ASoC: amd: ps: fix the pcm device numbering for acp pdm dmic

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: amd: name back to pcm_new()/pcm_free()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-component: re-add pcm_new()/pcm_free()

Cheng-Yang Chou <yphbchou0911@gmail.com>
    tools/sched_ext: Fix off-by-one in scx_sdt payload zeroing

Richard Cheng <icheng@nvidia.com>
    PCI/NPEM: Set LED_HW_PLUGGABLE for hotplug-capable ports

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: SOF: compress: return the configured codec from get_params

Ravi Hothi <ravi.hothi@oss.qualcomm.com>
    ASoC: qcom: audioreach: explicitly enable speaker protection modules

Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
    ALSA: scarlett2: Add missing sentinel initializer field

David Carlier <devnexen@gmail.com>
    gpu: nova-core: fix missing colon in SEC2 boot debug message

Gary Guo <gary@garyguo.net>
    gpu: nova-core: remove redundant `.as_ref()` for `dev_*` print

Waiman Long <longman@redhat.com>
    selftest: memcg: skip memcg_sock test if address family not supported

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: do not permit params change after init

SeongJae Park <sj@kernel.org>
    Docs/mm/damon/index: fix typo: autoamted -> automated

SeongJae Park <sj@kernel.org>
    Docs/admin-guide/mm/damn/lru_sort: fix intervals autotune parameter name

Jane Chu <jane.chu@oracle.com>
    Documentation: fix a hugetlbfs reservation statement

AnishMulay <anishm7030@gmail.com>
    selftests/mm: skip migration tests if NUMA is unavailable

Eliot Courtney <ecourtney@nvidia.com>
    gpu: nova-core: bitfield: fix broken Default implementation

Chen-Yu Tsai <wenst@chromium.org>
    PCI: mediatek-gen3: Prevent leaking IRQ domains when IRQ not found

Richard Zhu <hongxing.zhu@nxp.com>
    dt-bindings: PCI: imx6q-pcie: Fix maxItems of clocks and clock-names

Felix Gu <ustc.gu@gmail.com>
    PCI: aspeed: Fix IRQ domain leak on platform_get_irq() failure

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Keep Root Port MSI capability with iMSI-RX to work around hardware bug

Gerd Bayer <gbayer@linux.ibm.com>
    PCI: Enable AtomicOps only if Root Port supports them

Denis Rastyogin <gerben@altlinux.org>
    ASoC: rsnd: Fix potential out-of-bounds access of component_dais[]

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: hda: Notify IEC958 Default PCM switch state changes

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - use swab32 macro

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: iaa - fix per-node CPU counter reset in rebalance_wq_table()

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix type mismatch in RAS sysfs show functions

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix compression instance leak

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - disable 420xx AE cluster when lead engine is fused off

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - disable 4xxx AE cluster when lead engine is fused off

Hans Zhang <18255117159@163.com>
    PCI: dwc: Fix type mismatch for kstrtou32_from_user() return value

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: qdsp6: topology: check widget type before accessing data

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/riscv: Remove overflows on the invalidation path

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Fix clone_alias() to use the original device's devid

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_easrc: Change the type for iec958 channel status controls

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_easrc: Fix value type in fsl_easrc_iec958_get_bits()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_easrc: Check the variable range in fsl_easrc_iec958_put_bits()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_xcvr: Fix event generation in fsl_xcvr_mode_put()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_xcvr: Fix event generation in fsl_xcvr_arc_mode_put()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: Fix event generation in micfil_quality_set()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: Fix event generation in micfil_put_dc_remover_state()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: Fix event generation in micfil_range_set()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: Fix event generation in hwvad_put_init_mode()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: Fix event generation in hwvad_put_enable()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: Add access property for "VAD Detected"

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/dpu: drop INTF_0 on MSM8953

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    PM: domains: De-constify fields in struct dev_pm_domain_attach_data

Felix Gu <ustc.gu@gmail.com>
    pmdomain: imx: scu-pd: Fix device_node reference leak during ->probe()

Felix Gu <gu_0233@qq.com>
    pmdomain: ti: omap_prm: Fix a reference leak on device node

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: hda/cmedia: Remove duplicate pin configuration parsing

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix gpu init from secure world

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/adreno: Implement gx_is_on() for A8x

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Correct OOB usage

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Switch to preemption safe AO counter

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a8xx: Fix the ticks used in submit traces

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Use barriers while updating HFI Q headers

Connor Abbott <cwabbott0@gmail.com>
    drm/msm/a6xx: Fix dumping A650+ debugbus blocks

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm/shrinker: Fix can_block() logic

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm/a6xx: Fix HLSQ register dumping

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm: Fix VM_BIND UNMAP locking

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm: Reject fb creation from _NO_SHARE objs

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm/a6xx: Add missing aperture_lock init

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm/vma: Avoid lock in VM_BIND fence signaling path

Ethan Tidmore <ethantidmore06@gmail.com>
    ASoC: SOF: Intel: hda: Place check before dereference

Lei Huang <huanglei@kylinos.cn>
    ALSA: hda/realtek: fix code style (ERROR: else should follow close brace '}')

Lei Huang <huanglei@kylinos.cn>
    ALSA: hda/realtek: fix bad indentation for alc269

Billy Tsai <billy_tsai@aspeedtech.com>
    hwmon: (aspeed-g6-pwm-tach): remove redundant driver remove callback

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    PCI/DPC: Log AER error info for DPC/EDR uncorrectable errors

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/uvd4.2: Don't initialize UVD 4.2 when DPM is disabled

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/smu7: Add SCLK cap for quirky Hawaii board

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/ci: Fill DW8 fields from SMC

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/ci: Clear EnabledForActivity field for memory levels

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/ci: Fix powertune defaults for Hawaii 0x67B0

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/smu7: Fix SMU7 voltage dependency on display clock

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/ci: Disable MCLK DPM on problematic CI ASICs

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/ci: Use highest MCLK on CI when MCLK DPM is disabled

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: acp: update dmic_num logic for acp pdm dmic

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Avoid NULL dereference in dc_dmub_srv error paths

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: core: Validate compress device numbers without dynamic minors

Ethan Tidmore <ethantidmore06@gmail.com>
    iommu/riscv: Fix signedness bug

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Fix alignment calculation for resource size larger than align

Wenkai Lin <linwenkai6@hisilicon.com>
    crypto: hisilicon/sec2 - prevent req used-after-free for sec

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Fix premature removal from realloc_head list during resource assignment

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Prevent shrinking bridge window from its required size

Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
    PCI: qcom: Advertise Hotplug Slot Capability with no Command Completion support

Sebastian Reichel <sebastian.reichel@collabora.com>
    drm/panel: simple: Correct G190EAN01 prepare timing

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/panel: sharp-ls043t1le01: make use of prepare_prev_first

Zhao Mengmeng <zhaomengmeng@kylinos.cn>
    tools/sched_ext: scx_pair: fix pair_ctx indexing for CPU pairs

Alexey Charkov <alchark@flipper.net>
    ASoC: rockchip: rockchip_sai: Set slot width for non-TDM mode

Alexander Koskovich <akoskovich@pm.me>
    drm/msm/dsi: rename MSM8998 DSI version from V2_2_0 to V2_0_0

Pengyu Luo <mitltlatltl@gmail.com>
    drm/msm/dsi: fix hdisplay calculation for CMD mode panel

Pengyu Luo <mitltlatltl@gmail.com>
    drm/msm/dsi: fix bits_per_pclk

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/dpu: don't try using 2 LMs if only one DSC is available

Pengyu Luo <mitltlatltl@gmail.com>
    drm/msm/dsi: add the missing parameter description

Yuanjie Yang <yuanjie.yang@oss.qualcomm.com>
    drm/msm/dpu: fix mismatch between power and frequency

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm: add missing MODULE_DEVICE_ID definitions

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Update uAPI to clarify HYP_OWN requirement

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Set supports_cmd op in tegra241_vcmdq_hw_init()

Alexandru Dadu <alexandru.dadu@imgtec.com>
    drm/imagination: Switch reset_reason fields from enum to u32

Felix Gu <ustc.gu@gmail.com>
    PCI: sky1: Fix missing cleanup of ECAM config on probe failure

Pei Xiao <xiaopei01@kylinos.cn>
    spi: hisi-kunpeng: prevent infinite while() loop in hisi_spi_flush_fifo

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx11: look at the right prop for gfx queue priority

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx10: look at the right prop for gfx queue priority

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/ras: Remove redundant NULL check in pending bad-bank list iteration

haoyu.lu <hechushiguitu666@gmail.com>
    accel/amdxdna: fix missing newline in pr_err message

Koichiro Den <den@valinux.co.jp>
    PCI: dwc: rcar-gen4: Change EPC BAR alignment to 4K as per the documentation

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: Put CPU offline callback in ONLINE section to allow failure

Chuyi Zhou <zhouchuyi@bytedance.com>
    padata: Remove cpu online check from cpu add and removal

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-aes - guard unregister on error in atmel_aes_register_algs

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: tegra - Disable softirqs before finalizing request

Wesley Atwell <atwellwea@gmail.com>
    crypto: simd - reject compat registrations without __ prefixes

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    fbdev: matroxfb: Mark variable with __maybe_unused to avoid W=1 build break

Guillaume Gonnet <ggonnet.linux@gmail.com>
    dm init: ensure device probing has finished in dm-mod.waitfor=

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Remove dead negative offset check in amdgpu_virt_init_critical_region()

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Drop redundant queue NULL check in hang detect worker

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/ras: Fix NULL deref in ras_core_get_utc_second_timestamp()

Robby Cai <robby.cai@nxp.com>
    regulator: fp9931: Fix handling of mandatory "vin" supply

Robby Cai <robby.cai@nxp.com>
    regulator: dt-bindings: fp9931: Make vin-supply property as required

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Add default case in DVI mode validation

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/ras: Fix NULL deref in ras_core_ras_interrupt_detected()

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Update queue properties for metadata ring

Fangyu Yu <fangyu.yu@linux.alibaba.com>
    iommu/riscv: Stop polling when CQCSR reports an error

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/riscv: Add missing GENERIC_MSI_IRQ

Yaxing Guo <guoyaxing@bosc.ac.cn>
    iommu/riscv: Skip IRQ count check when using MSI interrupts

Fangyu Yu <fangyu.yu@linux.alibaba.com>
    iommu/riscv: Add IOTINVAL after updating DDT/PDT entries

John Madieu <john.madieu.xa@bp.renesas.com>
    dt-bindings: PCI: renesas,r9a08g045s33-pcie: Fix naming properties

John Madieu <john.madieu.xa@bp.renesas.com>
    PCI: rzg3s-host: Reorder reset assertion during suspend

John Madieu <john.madieu.xa@bp.renesas.com>
    PCI: rzg3s-host: Fix reset handling in probe error path

Aleksander Jan Bajkowski <olek2@wp.pl>
    crypto: inside-secure/eip93 - register hash before authenc algorithms

Ethan Tidmore <ethantidmore06@gmail.com>
    drm/sun4i: Fix resource leaks

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Handle error from drm_sched_entity_init()

David Carlier <devnexen@gmail.com>
    selftests/sched_ext: Add missing error check for exit__load()

Pei Xiao <xiaopei01@kylinos.cn>
    spi: atcspi200: fix mutex initialization order

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Fix xgmi max speed reporting

Geert Uytterhoeven <geert+renesas@glider.be>
    media: synopsys: VIDEO_DW_MIPI_CSI2RX should depend on ARCH_ROCKCHIP

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: i2c: og01a1b: Fix V4L2 subdevice data initialization on probe

Felix Gu <ustc.gu@gmail.com>
    spi: axiado: Remove redundant pm_runtime_mark_last_busy() call

Felix Gu <ustc.gu@gmail.com>
    spi: fsl-qspi: Use reinit_completion() for repeated operations

Felix Gu <ustc.gu@gmail.com>
    spi: nxp-fspi: Use reinit_completion() for repeated operations

Felix Gu <ustc.gu@gmail.com>
    spi: nxp-xspi: Use reinit_completion() for repeated operations

Harikrishna Shenoy <h-shenoy@ti.com>
    drm/bridge: cadence: cdns-mhdp8546-core: Handle HDCP state in bridge atomic check

Jayesh Choudhary <j-choudhary@ti.com>
    drm/bridge: cadence: cdns-mhdp8546-core: Add mode_valid hook to drm_bridge_funcs

Jayesh Choudhary <j-choudhary@ti.com>
    drm/bridge: cadence: cdns-mhdp8546-core: Set the mhdp connector earlier in atomic_enable()

Randy Dunlap <rdunlap@infradead.org>
    iopoll: fix function parameter names in read_poll_timeout_atomic()

Junrui Luo <moonafterrain@outlook.com>
    dm log: fix out-of-bounds write due to region_count overflow

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache metadata: fix memory leak on metadata abort retry

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    PCI: dwc: Perform cleanup in the error path of dw_pcie_resume_noirq()

Aksh Garg <a-garg7@ti.com>
    PCI: dwc: ep: Mirror the max link width and speed fields to all functions

Aksh Garg <a-garg7@ti.com>
    PCI: dwc: ep: Fix MSI-X Table Size configuration in dw_pcie_ep_set_msix()

Alexandre Courbot <acourbot@nvidia.com>
    gpu: nova-core: firmware: fix and explain v2 header offsets computations

Alexandre Courbot <acourbot@nvidia.com>
    gpu: nova-core: falcon: rename load parameters to reflect DMA dependency

Alexandre Courbot <acourbot@nvidia.com>
    gpu: nova-core: create falcon firmware DMA objects lazily

Joel Fernandes <joelagnelf@nvidia.com>
    gpu: nova-core: use checked arithmetic in FWSEC firmware parsing

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/chrome: chromeos_tbmc: Drop wakeup source on remove

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: GFX12.1 scratch memory limit up to 57-bit

Huan He <hehuan1@eswincomputing.com>
    dt-bindings: mmc: dwcmshc-sdhci: Fix resets array validation

Kees Cook <kees@kernel.org>
    drm/amd/ras: Fix type size of remainder argument

Benjamin Marzinski <bmarzins@redhat.com>
    dm-mpath: don't stop probing paths at presuspend

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix dirty mapping checking in passthrough mode switching

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix concurrent write failure in passthrough mode

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache policy smq: fix missing locks in invalidating cache blocks

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix write hang in passthrough mode

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix write path cache coherency in passthrough mode

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix null-deref with concurrent writes in passthrough mode

Sander Vanheule <sander@svanheule.net>
    ASoC: sti: use managed regmap_field allocations

Sander Vanheule <sander@svanheule.net>
    ASoC: sti: Return errors from regmap_field_alloc()

Aleksander Jan Bajkowski <olek2@wp.pl>
    crypto: inside-secure/eip93 - fix register definition

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Update counting of SU/GE DAPM routes

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Add default value for mipi-sdca-function-reset-max-delay

Felix Gu <ustc.gu@gmail.com>
    PCI: imx6: Fix device node reference leak in imx_pcie_probe()

Andrew Martin <andrew.martin@amd.com>
    drm/amdkfd: Removed commented line for MQD queue priority

Eliot Courtney <ecourtney@nvidia.com>
    gpu: nova-core: gsp: fix improper handling of empty slot in cmdq

Eliot Courtney <ecourtney@nvidia.com>
    gpu: nova-core: gsp: use empty slices instead of [0..0] ranges

Matt Roper <matthew.d.roper@intel.com>
    drm/xe/xe2_hpg: Drop invalid workaround Wa_15010599737

Matt Roper <matthew.d.roper@intel.com>
    drm/xe: Consolidate workaround entries for Wa_14019386621

Matt Roper <matthew.d.roper@intel.com>
    drm/xe: Consolidate workaround entries for Wa_14019877138

Ethan Tidmore <ethantidmore06@gmail.com>
    drm/sun4i: backend: fix error pointer dereference

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: mixer: Fix layer init code

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-ep-msi: Fix error unwind and prevent double alloc

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-test: Don't free doorbell IRQ unless requested

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Fix MSI doorbell IRQ unwind

George Abraham P <george.abraham.p@intel.com>
    PCI/TPH: Allow TPH enable for RCiEPs

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-compress: use function to clear symmetric params

Val Packett <val@invisiblethingslab.com>
    drm/virtio: Allow importing prime buffers when 3D is enabled

Maciej Patelczyk <maciej.patelczyk@intel.com>
    drm/gpusvm: Fix unbalanced unlock in drm_gpusvm_scan_mm()

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    dma-fence: Fix sparse warnings due __rcu annotations

Alexander Konyukhov <Alexander.Konyukhov@kaspersky.com>
    drm/komeda: fix integer overflow in AFBC framebuffer size check

Yuwen Chen <ywen.chen@foxmail.com>
    selftests/futex: Fix incorrect result reporting of futex_requeue test item

Maíra Canal <mcanal@igalia.com>
    drm/panel: ilitek-ili9882t: Select DRM_DISPLAY_DSC_HELPER

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Add missing PPE configurations in airoha_ppe_hw_init()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Fix VIP configuration for AN7583 SoC

Jiayuan Chen <jiayuan.chen@linux.dev>
    net, bpf: fix null-ptr-deref in xdp_master_redirect() for down master

Christian Brauner <brauner@kernel.org>
    selftests/namespaces: remove unused utils.h include from listns_efault_test

Xin Long <lucien.xin@gmail.com>
    sctp: disable BH before calling udp_tunnel_xmit_skb()

Xin Long <lucien.xin@gmail.com>
    sctp: fix missing encap_port propagation for GSO fragments

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Don't set treq->req_usec_ts in cookie_tcp_reqsk_init().

Gabriel Krisman Bertazi <krisman@suse.de>
    udp: Force compute_score to always inline

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: phy: qcom: at803x: Use the correct bit to disable extended next page

Stefan Metzmacher <metze@samba.org>
    Bluetooth: SCO: check for codecs->num_codecs == 1 before assigning to sco_pi(sk)->codec

Dudu Lu <phx0fer@gmail.com>
    Bluetooth: l2cap: Add missing chan lock in l2cap_ecred_reconf_rsp

Pauli Virtanen <pav@iki.fi>
    Bluetooth: fix locking in hci_conn_request_evt() with HCI_PROTO_DEFER

Jonathan Rissanen <jonathan.rissanen@axis.com>
    Bluetooth: hci_ldisc: Clear HCI_UART_PROTO_INIT on error

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix printing wrong information if SDU length exceeds MTU

Sun Jian <sun.jian.kdev@gmail.com>
    bpf: reject short IPv4/IPv6 inputs in bpf_prog_test_run_skb

Konstantin Khorenko <khorenko@virtuozzo.com>
    net: fix skb_ext_total_length() BUILD_BUG_ON with CONFIG_GCOV_PROFILE_ALL

Daniel Golle <daniel@makrotopia.org>
    net: ethernet: mtk_eth_soc: initialize PPE per-tag-layer MTU registers

Gal Pressman <gal@nvidia.com>
    net/mlx5e: IPsec, fix ASO poll timeout with read_poll_timeout_atomic()

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix features not applied during netdev registration

Charles Perry <charles.perry@microchip.com>
    net: phy: fix a return path in get_phy_c45_ids()

Josua Mayer <josua@solid-run.com>
    dt-bindings: net: dsa: nxp,sja1105: make spi-cpol optional for sja1110

Luca Weiss <luca.weiss@fairphone.com>
    net: ipa: Fix decoding EV_PER_EE for IPA v5.0+

Luca Weiss <luca.weiss@fairphone.com>
    net: ipa: Fix programming of QTIME_TIMESTAMP_CFG

Taegu Ha <hataegu0826@gmail.com>
    ppp: require CAP_NET_ADMIN in target netns for unattached ioctls

Lang Xu <xulang@uniontech.com>
    bpf: Fix OOB in pcpu_init_value

Greg Jumper <greg.jumper@oracle.com>
    net/rds: Restrict use of RDS/IB to the initial network namespace

Håkon Bugge <haakon.bugge@oracle.com>
    net/rds: Optimize rds_ib_laddr_check

Paul Chaignon <paul.chaignon@gmail.com>
    selftests/bpf: Fix reg_bounds to match new tnum-based refinement

Emil Tsalapatis <emil@etsalapatis.com>
    bpf: Allow instructions with arena source and non-arena dest registers

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix same-register dst/src OOB read and pointer leak in sock_ops

Fernando Fernandez Mancera <fmancera@suse.de>
    net_sched: fix skb memory leak in deferred qdisc drops

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Add missing RX_CPU_IDX() configuration in airoha_qdma_cleanup_rx_queue()

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    net: mana: Move current_speed debugfs file to mana_init_port()

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    net: mana: Use pci_name() for debugfs directory naming

Florian Westphal <fw@strlen.de>
    selftests: netfilter: nft_tproxy.sh: adjust to socat changes

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_ct: Only release RCU read lock after ct_ft

Davide Caratti <dcaratti@redhat.com>
    net/sched: cls_fw: fix NULL dereference of "old" filters before change()

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: fix __jited_unpriv tag name

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Enforce regsafe base id consistency for BPF_ADD_CONST scalars

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Fix FE_PSE_BUF_SET configuration if PPE2 is available

Mashiro Chen <mashiro.chen@mailbox.org>
    net: hamradio: 6pack: fix uninit-value in sixpack_receive_buf

Sechang Lim <rhkrqnwk98@gmail.com>
    bpf: Fix RCU stall in bpf_fd_array_map_clear()

Puranjay Mohan <puranjay@kernel.org>
    bpf: return VMA snapshot from task_vma iterator

Puranjay Mohan <puranjay@kernel.org>
    bpf: switch task_vma iterator from mmap_lock to per-VMA locks

Puranjay Mohan <puranjay@kernel.org>
    bpf: fix mm lifecycle in open-coded task_vma iterator

Florian Westphal <fw@strlen.de>
    netfilter: nft_fwd_netdev: check ttl/hl before forwarding

Florian Westphal <fw@strlen.de>
    netfilter: xt_socket: enable defrag after all other checks

Mohsin Bashir <hmohsin@meta.com>
    eth: fbnic: Use wake instead of start

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Add dma_rmb() and READ_ONCE() in airoha_qdma_rx_process()

Justin Chen <justin.chen@broadcom.com>
    net: bcmgenet: fix racing timeout handler

Justin Chen <justin.chen@broadcom.com>
    net: bcmgenet: fix leaking free_bds

Justin Chen <justin.chen@broadcom.com>
    net: bcmgenet: fix off-by-one in bcmgenet_put_txcb

Cosmin Ratiu <cratiu@nvidia.com>
    macsec: Support VLAN-filtering lower devices

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix use-after-free in offloaded map/prog info fill

Paolo Abeni <pabeni@redhat.com>
    mptcp: better mptcp-level RTT estimator

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Remove static qualifier from local subprog pointer

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix ld_{abs,ind} failure path analysis in subprogs

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Propagate error from visit_tailcall_insn

Wang Wensheng <wsw9603@163.com>
    arm64: kexec: Remove duplicate allocation for trans_pgd

Haoyu Lu <hechushiguitu666@gmail.com>
    ACPI: AGDI: fix missing newline in error message

Mark Rutland <mark.rutland@arm.com>
    arm64: entry: Don't preempt with SError or Debug masked

Eric Dumazet <edumazet@google.com>
    net: pull headers in qdisc_pkt_len_segs_init()

Eric Dumazet <edumazet@google.com>
    net: qdisc_pkt_len_segs_init() cleanup

Eric Dumazet <edumazet@google.com>
    net: plumb drop reasons to __dev_queue_xmit()

Eric Dumazet <edumazet@google.com>
    net: dropreason: add SKB_DROP_REASON_RECURSION_LIMIT

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix linked reg delta tracking when src_reg == dst_reg

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath10k: fix station lookup failure during disconnect

Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
    bpf: Prefer vmlinux symbols over module symbols for unqualified kprobes

Weiming Shi <bestswngs@gmail.com>
    bpf: reject negative CO-RE accessor indices in bpf_core_parse_spec()

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Drop task_to_inode and inet_conn_established from lsm sleepable hooks

Nicolas Escande <nico.escande@gmail.com>
    wifi: mac80211: handle VHT EXT NSS in ieee80211_determine_our_sta_mode()

Ethan Tidmore <ethantidmore06@gmail.com>
    wifi: brcmfmac: Fix error pointer dereference

Arnd Bergmann <arnd@arndb.de>
    net: ethernet: ti-cpsw: fix linking built-in code to modules

Arnd Bergmann <arnd@arndb.de>
    net: ethernet: ti-cpsw:: rename soft_reset() function

MingTao Huang <mintaohuang@tencent.com>
    bpf: Fix stale offload->prog pointer after constant blinding

Weiming Shi <bestswngs@gmail.com>
    bpf: fix end-of-list detection in cgroup_storage_get_next_key()

Mykyta Yatsenko <yatsenko@meta.com>
    bpf: Use copy_map_value_locked() in alloc_htab_elem() for BPF_F_LOCK

Eric Dumazet <edumazet@google.com>
    macvlan: annotate data-races around port->bc_queue_len_used

Leon Hwang <leon.hwang@linux.dev>
    bpf: Fix abuse of kprobe_write_ctx via freplace

Amit Machhiwal <amachhiw@linux.ibm.com>
    selftests/powerpc: Suppress -Wmaybe-uninitialized with GCC 15

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/crash: Update backup region offset in elfcorehdr on memory hotplug

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/crash: fix backup region offset update to elfcorehdr

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests/tracing: Fix to check awk supports non POSIX strtonum()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests/tracing: Fix to make --logdir option work again

Chih Kai Hsu <hsu.chih.kai@realtek.com>
    r8152: fix incorrect register write to USB_UPHY_XTAL

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    drivers/vfio_pci_core: Change PXD_ORDER check from switch case to if/else block

Alexey Velichayshiy <a.velichayshiy@ispras.ru>
    wifi: rtw89: phy: fix uninitialized variable access in rtw89_phy_cfo_set_crystal_cap()

haoyu.lu <hechushiguitu666@gmail.com>
    bpf,arc_jit: Fix missing newline in pr_err messages

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: Reset when feature configuration bit unset

Zeng Heng <zengheng4@huawei.com>
    arm_mpam: Ensure in_reset_state is false after applying configuration

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix variable length stack write over spilled pointers

David Carlier <devnexen@gmail.com>
    bpf: Use RCU-safe iteration in dev_map_redirect_multi() SKB path

Jiayuan Chen <jiayuan.chen@shopee.com>
    selftests/bpf: Fix sockmap_multi_channels reliability

Keisuke Nishimura <keisuke.nishimura@inria.fr>
    bpf: Fix refcount check in check_struct_ops_btf_id()

Peter Chiu <chui-hao.chiu@mediatek.com>
    wifi: mt76: mt7996: fix RRO EMU configuration

Chad Monroe <chad@monroe.io>
    wifi: mt76: support upgrading passive scans to active

Chad Monroe <chad@monroe.io>
    wifi: mt76: fix multi-radio on-channel scanning

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Decrement sta counter removing the link in mt7996_mac_reset_sta_iter()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Remove link pointer dependency in mt7996_mac_sta_remove_links()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Add missing CHANCTX_STA_CSA property

Michael Lo <michael.lo@mediatek.com>
    wifi: mt76: mt7921: fix 6GHz regulatory update on connection

Duoming Zhou <duoming@zju.edu.cn>
    wifi: mt76: mt7996: fix use-after-free bugs in mt7996_mac_dump_work()

Duoming Zhou <duoming@zju.edu.cn>
    wifi: mt76: mt7915: fix use-after-free bugs in mt7915_mac_dump_work()

StanleyYP Wang <StanleyYP.Wang@mediatek.com>
    wifi: mt76: mt7996: fix struct mt7996_mcu_uni_event

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: mt7996: fix wrong DMAD length when using MAC TXP

Carlos Llamas <cmllamas@google.com>
    bpf: Switch CONFIG_CFI_CLANG to CONFIG_CFI

James Clark <james.clark@linaro.org>
    arm64: cpufeature: Make PMUVer and PerfMon unsigned

Allen Ye <allen.ye@mediatek.com>
    wifi: mt76: fix backoff fields and max_power calculation

Chad Monroe <chad@monroe.io>
    wifi: mt76: fix deadlock in remain-on-channel

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7921: fix potential deadlock in mt7921_roc_abort_sync

Leon Yen <leon.yen@mediatek.com>
    wifi: mt76: mt7925: fix tx power setting failure after chip reset

Zilin Guan <zilin@seu.edu.cn>
    wifi: mt76: Fix memory leak after mt76_connac_mcu_alloc_sta_req()

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7925: fix potential deadlock in mt7925_roc_abort_sync

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7925: drop puncturing handling from BSS change path

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: npu: Add missing rx_token_size initialization

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Fix NPU stop procedure

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: Fix memory leak destroying device

Rory Little <rory@candelatech.com>
    wifi: mt76: mt7921: Place upper limit on station AID

Alok Tiwari <alok.a.tiwari@oracle.com>
    wifi: mt76: mt7996: fix FCS error flag check in RX descriptor

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925: prevent NULL vif dereference in mt7925_mac_write_txwi

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925: prevent NULL pointer dereference in mt7925_tx_check_aggr()

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7915: fix use_cts_prot support

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7615: fix use_cts_prot support

Leon Yen <leon.yen@mediatek.com>
    wifi: mt76: mt7925: Fix incorrect MLO mode in firmware control

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7921: Reset ampdu_state state in case of failure in mt76_connac2_tx_check_aggr()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Reset ampdu_state state in case of failure in mt7996_tx_check_aggr()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Clear wcid pointer in mt7996_mac_sta_deinit_link()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Switch to the secondary link if the default one is removed

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Reset mtxq->idx if primary link is removed in mt7996_vif_link_remove()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Set mtxq->wcid just for primary link

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: mt7996: fix iface combination for different chipsets

StanleyYP Wang <StanleyYP.Wang@mediatek.com>
    wifi: mt76: mt7996: fix the behavior of radar detection

Thomas Weißschuh <linux@weissschuh.net>
    tools/nolibc: avoid -Wundef warning for __STDC_VERSION__

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    tools/nolibc: MIPS: fix clobbers of 'lo' and 'hi' registers on different ISAs

David Laight <david.laight.linux@gmail.com>
    tools/nolibc/printf: Move snprintf length check to callback

David Laight <david.laight.linux@gmail.com>
    tools/nolibc/printf: Change variables 'c' to 'ch' and 'tmpbuf[]' to 'outbuf[]'

David Laight <david.laight.linux@gmail.com>
    selftests/nolibc: Fix build with host headers and libc

Thomas Weißschuh <linux@weissschuh.net>
    selftests/nolibc: fix test_file_stream() on musl libc

Amery Hung <ameryhung@gmail.com>
    bpf: Do not allow deleting local storage in NMI

Heitor Alves de Siqueira <halves@igalia.com>
    wifi: libertas: don't kill URBs in interrupt context

Heitor Alves de Siqueira <halves@igalia.com>
    wifi: libertas: use USB anchors for tracking in-flight URBs

Petr Pavlu <petr.pavlu@suse.com>
    module: Fix freeing of charp module parameters when CONFIG_SYSFS=n

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/64s: Fix unmap race with PMD migration entries

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/pgtable-frag: Fix bad page state in pte_frag_destroy

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Zero-extend bpf prog return values and kfunc arguments

Cai Xinchen <caixinchen1@huawei.com>
    dpaa2: compile dpaa2 even CONFIG_FSL_DPAA2_ETH=n

Cai Xinchen <caixinchen1@huawei.com>
    dpaa2: add independent dependencies for FSL_DPAA2_SWITCH

Shayne Chen <shayne.chen@mediatek.com>
    wifi: ieee80211: fix definition of EHT-MCS 15 in MRU

Alan Maguire <alan.maguire@oracle.com>
    selftests/bpf: Handle !CONFIG_SMC in bpf_smc.c

P Praneesh <praneesh.p@oss.qualcomm.com>
    wifi: ath12k: Fix legacy rate mapping for monitor mode capture

Sarika Sharma <sarika.sharma@oss.qualcomm.com>
    wifi: ath12k: account TX stats only when ACK/BA status is present

Feng Yang <yangfeng@kylinos.cn>
    bpf: test_run: Fix the null pointer dereference issue in bpf_lwt_xmit_push_encap

Duoming Zhou <duoming@zju.edu.cn>
    wifi: rtlwifi: pci: fix possible use-after-free caused by unfinished irq_prepare_bcn_tasklet

Zilin Guan <zilin@seu.edu.cn>
    wifi: mwifiex: Fix memory leak in mwifiex_11n_aggregate_pkt()

Zilin Guan <zilin@seu.edu.cn>
    wifi: ath11k: fix memory leaks in beacon template setup

Michal Koutný <mkoutny@suse.com>
    sched/rt: Skip group schedulable check with rt_group_sched=0

John Stultz <jstultz@google.com>
    sched: Make class_schedulers avoid pushing current, and get rid of proxy_tag_curr()

Aaron Tomlin <atomlin@atomlin.com>
    fs/resctrl: Report invalid domain ID when parsing io_alloc_cbm

Mario Limonciello (AMD) <superm1@kernel.org>
    firmware: dmi: Correct an indexing error in dmi.h

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    x86/vdso: Clean up remnants of VDSO32_NOTE_MASK

Ahmed S. Darwish <darwi@linutronix.de>
    ASoC: Intel: avs: Include CPUID header at file scope

Ahmed S. Darwish <darwi@linutronix.de>
    ASoC: Intel: avs: Check maximum valid CPUID leaf

Biju Das <biju.das.jz@bp.renesas.com>
    irqchip/renesas-rzg2l: Fix error path in rzg2l_irqc_common_probe()

Peter Zijlstra <peterz@infradead.org>
    sched/topology: Fix sched_domain_span()

Juergen Gross <jgross@suse.com>
    x86/irqflags: Preemptively move include paravirt.h directive where it belongs

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/topology: Compute sd_weight considering cpuset partitions

Bart Van Assche <bvanassche@acm.org>
    locking: Fix rwlock support in <linux/spinlock_up.h>

Thomas Weißschuh (Schneider Electric) <thomas.weissschuh@linutronix.de>
    scripts/gdb: timerlist: Adapt to move of tk_core

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    sparc64: vdso: Link with -z noexecstack

Boqun Feng <boqun@kernel.org>
    rust: sync: atomic: Remove bound `T: Sync` for `Atomic::from_ptr()`

Xiaoyao Li <xiaoyao.li@intel.com>
    x86/tdx: Fix the typo in TDX_ATTR_MIGRTABLE

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Avoid calling perf_allow_kernel() from the IBS NMI handler

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Preserve PhyAddrVal bit when clearing PhyAddr MSR

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Account interrupt for discarded samples

Bart Van Assche <bvanassche@acm.org>
    ww-mutex: Fix the ww_acquire_ctx function annotations

Bart Van Assche <bvanassche@acm.org>
    signal: Fix the lock_task_sighand() annotation

Bart Van Assche <bvanassche@acm.org>
    locking: Fix rwlock and spinlock lock context annotations

Thomas Gleixner <tglx@kernel.org>
    hrtimer: Reduce trace noise in hrtimer_start()

Peter Zijlstra <peterz@infradead.org>
    hrtimer: Avoid pointless reprogramming in __hrtimer_start_range_ns()

Brian Masney <bmasney@redhat.com>
    irqchip/irq-pic32-evic: Address warning related to wrong printf() formatter

Davidlohr Bueso <dave@stgolabs.net>
    locking/mutex: Fix wrong comment for CONFIG_DEBUG_LOCK_ALLOC

Davidlohr Bueso <dave@stgolabs.net>
    locking/mutex: Rename mutex_init_lockep()

Danilo Krummrich <dakr@kernel.org>
    bus: fsl-mc: use generic driver_override infrastructure

Danilo Krummrich <dakr@kernel.org>
    s390/ap: use generic driver_override infrastructure

Danilo Krummrich <dakr@kernel.org>
    s390/cio: use generic driver_override infrastructure

Danilo Krummrich <dakr@kernel.org>
    vdpa: use generic driver_override infrastructure

Danilo Krummrich <dakr@kernel.org>
    platform/wmi: use generic driver_override infrastructure

Danilo Krummrich <dakr@kernel.org>
    PCI: use generic driver_override infrastructure

K Prateek Nayak <kprateek.nayak@amd.com>
    cpufreq: Pass the policy to cpufreq_driver->adjust_perf()

Gautham R. Shenoy <gautham.shenoy@amd.com>
    amd-pstate: Update cppc_req_cached in fast_switch case

Gautham R. Shenoy <gautham.shenoy@amd.com>
    amd-pstate: Fix memory leak in amd_pstate_epp_cpu_init()

Gui-Dong Han <hanguidong02@gmail.com>
    soundwire: debugfs: initialize firmware_file to empty string

Gui-Dong Han <hanguidong02@gmail.com>
    debugfs: fix placement of EXPORT_SYMBOL_GPL for debugfs_create_str()

Gui-Dong Han <hanguidong02@gmail.com>
    debugfs: check for NULL pointer in debugfs_create_str()

Gopi Krishna Menon <krishnagopi487@gmail.com>
    thermal/drivers/spear: Fix error condition for reading st,thermal-flags

Danilo Krummrich <dakr@kernel.org>
    devres: fix missing node debug info in devm_krealloc()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: x86: cmos_rtc: Improve coordination with ACPI TAD driver

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: x86: cmos_rtc: Clean up address space handler driver

Viresh Kumar <viresh.kumar@linaro.org>
    OPP: Move break out of scoped_guard in dev_pm_opp_xlate_required_opp()

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    OPP: debugfs: Use performance level if available to distinguish between rates

Qu Wenruo <wqu@suse.com>
    btrfs: do not reject a valid running dev-replace

Filipe Manana <fdmanana@suse.com>
    btrfs: fix deadlock between reflink and transaction commit when using flushoncommit

Qu Wenruo <wqu@suse.com>
    btrfs: fix the inline compressed extent check in inode_need_compress()

Aleksa Sarai <aleksa@amutable.com>
    dcache: permit dynamic_dname()s up to NAME_MAX

Yu Kuai <yukuai@fnnas.com>
    md: wake raid456 reshape waiters before suspend

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md: remove unused static md_wq workqueue

Zhan Xusheng <zhanxusheng1024@gmail.com>
    erofs: handle 48-bit blocks/uniaddr for extra devices

Yuto Ohnuki <ytohnuki@amazon.com>
    blk-wbt: remove WARN_ON_ONCE from wbt_init_enable_default()

Uday Shankar <ushankar@purestorage.com>
    ublk: reset per-IO canceled flag on each fetch

Yu Kuai <yukuai3@huawei.com>
    md: fix array_state=clear sysfs deadlock

Zhan Xusheng <zhanxusheng1024@gmail.com>
    erofs: include the trailing NUL in FS_IOC_GETFSLABEL

Gao Xiang <xiang@kernel.org>
    erofs: verify metadata accesses for file-backed mounts

Cole Leavitt <cole@unwrap.rs>
    pstore/ram: fix resource leak when ioremap() fails

Jackie Liu <liuyun01@kylinos.cn>
    blk-cgroup: fix disk reference leak in blkcg_maybe_throttle_current()

Deepanshu Kartikey <kartikey406@gmail.com>
    nilfs2: reject zero bd_oblocknr in nilfs_ioctl_mark_blocks_dirty()

Jackie Liu <liuyun01@kylinos.cn>
    block: fix zones_cond memory leak on zone revalidation error paths

Daan De Meyer <daan.j.demeyer@gmail.com>
    loop: fix partition scan race between udev and loop_reread_partitions()

Bart Van Assche <bvanassche@acm.org>
    drbd: Balance RCU calls in drbd_adm_dump_devices()

Christoph Hellwig <hch@lst.de>
    fs: fix archiecture-specific compat_ftruncate64

Xiao Ni <xni@redhat.com>
    md/raid1: fix the comparing region of interval tree

HyungJung Joo <jhj140711@gmail.com>
    fs/mbcache: cancel shrink work before destroying the cache

HyungJung Joo <jhj140711@gmail.com>
    fs/omfs: reject s_sys_blocksize smaller than OMFS_DIR_START

Chen Cheng <chencheng@fnnas.com>
    md: suppress spurious superblock update error message for dm-raid

Ming Lei <ming.lei@redhat.com>
    blk-cgroup: wait for blkcg cleanup before initializing new disk


-------------

Diffstat:

 Documentation/admin-guide/mm/damon/lru_sort.rst    |   4 +-
 .../bindings/interrupt-controller/arm,gic-v3.yaml  |   2 +-
 .../bindings/mmc/snps,dwcmshc-sdhci.yaml           |   3 +
 .../devicetree/bindings/net/dsa/nxp,sja1105.yaml   |   2 -
 .../bindings/pci/fsl,imx6q-pcie-common.yaml        |   4 +-
 .../devicetree/bindings/pci/fsl,imx6q-pcie.yaml    |   3 +-
 .../bindings/pci/renesas,r9a08g045-pcie.yaml       |  50 ++--
 .../pinctrl/marvell,armada3710-xb-pinctrl.yaml     |  11 +-
 .../bindings/regulator/fitipower,fp9931.yaml       |   1 +
 .../bindings/ufs/rockchip,rk3576-ufshc.yaml        |   7 +-
 Documentation/driver-api/driver-model/devres.rst   |   4 +
 Documentation/mm/damon/index.rst                   |   2 +-
 Documentation/mm/hugetlbfs_reserv.rst              |   2 +-
 Documentation/netlink/specs/psp.yaml               |   2 +
 Documentation/userspace-api/rseq.rst               |  94 +++++-
 Makefile                                           |   6 +-
 arch/arc/net/bpf_jit_arcv2.c                       |   8 +-
 arch/arm/boot/dts/broadcom/bcm-ns.dtsi             |   2 +-
 arch/arm/boot/dts/mediatek/mt7623.dtsi             |   2 +-
 .../boot/dts/nxp/imx/imx27-eukrea-cpuimx27.dtsi    |   8 +-
 .../nxp/imx/imx27-eukrea-mbimxsd27-baseboard.dts   |   2 +-
 arch/arm/mach-omap1/clock_data.c                   |   4 +-
 arch/arm/net/bpf_jit_32.c                          |   6 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |   6 +
 .../boot/dts/amlogic/meson-gxl-s905d-p230.dts      |   3 +-
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     | 161 ++++++++---
 .../boot/dts/freescale/imx8-apalis-ixora-v1.1.dtsi |   4 +
 .../boot/dts/freescale/imx8-apalis-ixora-v1.2.dtsi |   4 +
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts      | 114 ++++++--
 .../arm64/boot/dts/freescale/imx8mm-emtop-som.dtsi |   4 +-
 .../arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi |   2 +-
 .../arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi |   2 +-
 .../freescale/imx8mp-aristainetos3a-som-v1.dtsi    |   2 +-
 arch/arm64/boot/dts/freescale/imx8mp-cubox-m.dts   |   2 +-
 .../dts/freescale/imx8mp-data-modul-edm-sbc.dts    |   2 +-
 .../boot/dts/freescale/imx8mp-debix-model-a.dts    |   2 +-
 .../dts/freescale/imx8mp-debix-som-a-bmb-08.dts    |   2 +-
 .../boot/dts/freescale/imx8mp-debix-som-a.dtsi     |   2 +-
 .../arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi |   2 +-
 arch/arm64/boot/dts/freescale/imx8mp-edm-g.dtsi    |   2 +-
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts       |   5 +-
 .../imx8mp-hummingboard-pulse-common.dtsi          |   2 +-
 .../imx8mp-hummingboard-pulse-mini-hdmi.dtsi       |  11 +-
 .../boot/dts/freescale/imx8mp-icore-mx8mp.dtsi     |   2 +-
 .../boot/dts/freescale/imx8mp-kontron-dl.dtso      |  19 ++
 .../boot/dts/freescale/imx8mp-kontron-osm-s.dtsi   |   6 +
 .../imx8mp-kontron-smarc-eval-carrier.dts          |   1 -
 arch/arm64/boot/dts/freescale/imx8mp-navqp.dts     |   2 +-
 .../boot/dts/freescale/imx8mp-nitrogen-som.dtsi    |   2 +-
 arch/arm64/boot/dts/freescale/imx8mp-sr-som.dtsi   |   4 +-
 .../freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts   |   4 +-
 .../boot/dts/freescale/imx8mp-ultra-mach-sbc.dts   |   4 +-
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts       |  10 +-
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts      |  10 +-
 arch/arm64/boot/dts/freescale/imx91-11x11-evk.dts  |   2 +
 arch/arm64/boot/dts/freescale/imx91.dtsi           |   2 +-
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi  |   2 +-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |   2 +-
 arch/arm64/boot/dts/mediatek/mt6795.dtsi           |   2 +-
 arch/arm64/boot/dts/mediatek/mt7981b.dtsi          |   2 +-
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi          |   2 +-
 .../mediatek/mt7988a-bananapi-bpi-r4-pro-4e.dts    |   2 +-
 .../mediatek/mt7988a-bananapi-bpi-r4-pro-8x.dts    |   2 +-
 arch/arm64/boot/dts/mediatek/mt8365.dtsi           |   5 +-
 arch/arm64/boot/dts/nvidia/tegra234-p3701.dtsi     |   1 +
 arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi     |   1 +
 arch/arm64/boot/dts/qcom/Makefile                  |   2 +
 arch/arm64/boot/dts/qcom/hamoa.dtsi                |  10 +-
 arch/arm64/boot/dts/qcom/kaanapali.dtsi            |   2 +-
 arch/arm64/boot/dts/qcom/lemans.dtsi               |   6 +-
 arch/arm64/boot/dts/qcom/milos.dtsi                |   4 +-
 arch/arm64/boot/dts/qcom/monaco.dtsi               |   6 +-
 arch/arm64/boot/dts/qcom/msm8917-xiaomi-riva.dts   |   2 +-
 arch/arm64/boot/dts/qcom/msm8937-xiaomi-land.dts   |   2 +-
 arch/arm64/boot/dts/qcom/msm8953-xiaomi-daisy.dts  |   2 +-
 arch/arm64/boot/dts/qcom/msm8953-xiaomi-vince.dts  |   2 +-
 .../boot/dts/qcom/qcs6490-thundercomm-rubikpi3.dts |   8 +-
 arch/arm64/boot/dts/qcom/qrb2210-arduino-imola.dts |  12 +-
 .../dts/qcom/sdm845-xiaomi-beryllium-common.dtsi   |   1 +
 arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts  |  58 ++--
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts  |   4 +
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   5 +
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   5 +-
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |  13 +-
 arch/arm64/boot/dts/qcom/sm8650.dtsi               |  15 +-
 arch/arm64/boot/dts/qcom/sm8750.dtsi               |  14 +-
 arch/arm64/boot/dts/qcom/talos.dtsi                |   3 +
 arch/arm64/boot/dts/rockchip/rk3328-a1.dts         |  23 --
 arch/arm64/boot/dts/rockchip/rk3562-evb2-v10.dts   |   2 +-
 arch/arm64/boot/dts/rockchip/rk3566-lckfb-tspi.dts |   4 +-
 arch/arm64/boot/dts/rockchip/rk3576.dtsi           |   5 +-
 arch/arm64/boot/dts/rockchip/rk3588-jaguar.dts     |   2 +-
 .../boot/dts/rockchip/rk3588s-gameforce-ace.dts    |  12 +-
 arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts           |  14 +-
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |   2 +-
 arch/arm64/boot/dts/ti/k3-am62l.dtsi               |   4 +-
 arch/arm64/boot/dts/ti/k3-am62l3-evm.dts           |   6 +-
 arch/arm64/boot/dts/ti/k3-am62p5-sk.dts            |   6 +-
 arch/arm64/include/asm/entry-common.h              |  21 +-
 arch/arm64/include/asm/kernel-pgtable.h            |   7 +-
 arch/arm64/include/asm/xor.h                       |   2 +-
 arch/arm64/kernel/cpufeature.c                     |   4 +-
 arch/arm64/kernel/machine_kexec.c                  |   3 -
 arch/arm64/kernel/pi/patch-scs.c                   |   4 +-
 arch/arm64/kernel/sys32.c                          |   2 +-
 arch/arm64/lib/insn.c                              |   2 +
 arch/arm64/net/bpf_jit_comp.c                      |  16 +-
 arch/mips/kernel/linux32.c                         |   2 +-
 arch/parisc/kernel/sys_parisc.c                    |   4 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h       |  15 +
 arch/powerpc/include/asm/kexec.h                   |  14 +-
 arch/powerpc/kernel/sys_ppc32.c                    |   2 +-
 arch/powerpc/kexec/crash.c                         |  64 +++++
 arch/powerpc/kexec/file_load_64.c                  |  29 +-
 arch/powerpc/mm/book3s64/pgtable.c                 |  13 +-
 arch/powerpc/mm/pgtable-frag.c                     |   1 +
 arch/powerpc/platforms/44x/warp.c                  |   2 +
 arch/riscv/Kconfig                                 |  22 ++
 arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts    |   4 +-
 arch/riscv/kernel/traps_misaligned.c               |   2 +-
 arch/riscv/net/bpf_jit.h                           |   6 -
 arch/riscv/net/bpf_jit_core.c                      |   7 -
 arch/s390/kvm/interrupt.c                          |   3 +-
 arch/s390/kvm/pci.c                                |   6 +-
 arch/s390/mm/fault.c                               |   2 +-
 arch/s390/net/bpf_jit_comp.c                       |  39 ++-
 arch/sh/include/cpu-sh3/cpu/dac.h                  |   2 +
 arch/sparc/kernel/sys_sparc32.c                    |   2 +-
 arch/sparc/vdso/Makefile                           |   2 +-
 arch/um/kernel/tlb.c                               |   1 +
 arch/x86/Makefile.um                               |   2 +
 arch/x86/coco/tdx/debug.c                          |   2 +-
 arch/x86/events/amd/ibs.c                          |  15 +-
 arch/x86/events/perf_event_flags.h                 |   1 +
 arch/x86/include/asm/irqflags.h                    |   6 +-
 arch/x86/include/asm/shared/tdx.h                  |   4 +-
 arch/x86/include/asm/vdso.h                        |   1 -
 arch/x86/kernel/acpi/cppc.c                        |   6 +-
 arch/x86/kernel/relocate_kernel_64.S               |   8 +
 arch/x86/kernel/sys_ia32.c                         |   3 +-
 arch/x86/kvm/emulate.c                             |   2 +-
 arch/x86/kvm/trace.h                               |   2 +-
 arch/x86/tools/vdso2c.c                            |   1 -
 arch/x86/um/vdso/Makefile                          |   2 -
 block/blk-cgroup.c                                 |  16 ++
 block/blk-wbt.c                                    |   5 +-
 block/blk-zoned.c                                  |  26 +-
 block/disk-events.c                                |   3 +-
 crypto/af_alg.c                                    |   2 +
 crypto/jitterentropy-kcapi.c                       |  14 +-
 crypto/simd.c                                      |  16 +-
 drivers/accel/amdxdna/amdxdna_mailbox.c            |   2 +-
 drivers/accel/rocket/rocket_gem.c                  |   2 +
 drivers/acpi/apei/einj-core.c                      |  55 ++--
 drivers/acpi/arm64/agdi.c                          |   2 +-
 drivers/acpi/x86/cmos_rtc.c                        |  79 ++++--
 drivers/ata/libata-scsi.c                          |   4 +-
 drivers/base/devres.c                              |   2 +
 drivers/block/drbd/drbd_nl.c                       |   8 +-
 drivers/block/ublk_drv.c                           |  21 +-
 drivers/block/zram/zram_drv.c                      |   4 +
 drivers/bluetooth/btmtk.c                          |   4 +-
 drivers/bluetooth/hci_ldisc.c                      |   3 +
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |  43 +--
 drivers/bus/stm32_rifsc.c                          |  52 ++--
 drivers/cdrom/cdrom.c                              |  73 +++--
 drivers/char/ipmi/ssif_bmc.c                       |  34 ++-
 drivers/clk/clk-qoriq.c                            |  17 +-
 drivers/clk/clk-xgene.c                            |   2 +
 drivers/clk/imx/clk-imx6q.c                        |  12 +-
 drivers/clk/imx/clk-imx8mq.c                       |   4 +-
 drivers/clk/qcom/dispcc-glymur.c                   |   4 +-
 drivers/clk/qcom/dispcc-kaanapali.c                |   2 -
 drivers/clk/qcom/dispcc-milos.c                    |   1 -
 drivers/clk/qcom/dispcc-sc8280xp.c                 |   4 -
 drivers/clk/qcom/dispcc-sm4450.c                   |   1 -
 drivers/clk/qcom/dispcc-sm8250.c                   |   6 +-
 drivers/clk/qcom/dispcc-sm8450.c                   |   2 +-
 drivers/clk/qcom/dispcc0-sa8775p.c                 |   2 -
 drivers/clk/qcom/dispcc1-sa8775p.c                 |   2 -
 drivers/clk/qcom/gcc-glymur.c                      |   1 +
 drivers/clk/qcom/gcc-sc8180x.c                     |  64 ++++-
 drivers/clk/qcom/gcc-x1e80100.c                    |   1 +
 drivers/clk/qcom/gdsc.c                            |  12 +-
 drivers/clk/renesas/r9a09g056-cpg.c                |  36 +--
 drivers/clk/renesas/r9a09g057-cpg.c                |  55 ++--
 drivers/clk/spacemit/ccu_mix.c                     |   2 +-
 drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c           |  17 +-
 drivers/clk/visconti/pll.c                         |   2 +-
 drivers/cpufreq/amd-pstate.c                       |   6 +-
 drivers/cpufreq/cpufreq.c                          |   6 +-
 drivers/cpufreq/intel_pstate.c                     |   4 +-
 drivers/crypto/atmel-aes.c                         |   6 +-
 drivers/crypto/ccp/ccp-crypto-aes.c                |   7 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |   2 +-
 drivers/crypto/inside-secure/eip93/eip93-common.c  |   2 +-
 drivers/crypto/inside-secure/eip93/eip93-main.c    |  16 +-
 drivers/crypto/inside-secure/eip93/eip93-regs.h    |   2 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |   2 +-
 .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c |  20 +-
 .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   |  14 +-
 .../intel/qat/qat_common/adf_sysfs_ras_counters.c  |  12 +-
 .../intel/qat/qat_common/icp_qat_hw_20_comp.h      |  10 +-
 .../crypto/intel/qat/qat_common/qat_comp_algs.c    |  10 +-
 drivers/crypto/sa2ul.c                             |   4 +-
 drivers/crypto/tegra/tegra-se-aes.c                |   9 +
 drivers/crypto/tegra/tegra-se-hash.c               |   3 +
 drivers/cxl/pci.c                                  |   3 +
 drivers/dma-buf/dma-fence.c                        |   8 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |  16 +-
 drivers/dma/mxs-dma.c                              |   1 +
 drivers/dpll/dpll_netlink.c                        |  10 +
 drivers/dpll/dpll_netlink.h                        |   2 -
 drivers/firmware/arm_ffa/driver.c                  |   2 +-
 drivers/firmware/efi/capsule-loader.c              |   2 +-
 drivers/firmware/qcom/qcom_scm.c                   |   3 +-
 drivers/fwctl/main.c                               |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |  57 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c     |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c          |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |   5 -
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c              |  66 +++++
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c             |  10 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c             |   1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c             |   2 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c             |   1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c             |   1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |   1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c           |   1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c           |   1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c           |   1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_3_0.c           |   1 +
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c              |  10 +
 drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c              |   5 +
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |   2 +
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |   2 +
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |   3 +
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c            |   1 +
 drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c       |  35 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_cik.c   |   1 -
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c   |   1 -
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c   |   1 -
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c   |   1 -
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c |   1 -
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |   1 -
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c    |   1 -
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   3 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   6 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |  21 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |  44 +++
 drivers/gpu/drm/amd/display/dc/bios/bios_parser.c  |  62 ++++
 drivers/gpu/drm/amd/display/dc/dc.h                |   2 +-
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c       |  10 +-
 .../gpu/drm/amd/display/dc/dce/dce_link_encoder.c  |   4 +-
 drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c |   3 +
 drivers/gpu/drm/amd/display/dc/link/link_factory.c |   4 +-
 .../amd/display/dc/resource/dce60/dce60_resource.c |   3 +-
 .../amd/display/dc/resource/dce80/dce80_resource.c |   3 +-
 .../amd/display/dc/resource/dcn32/dcn32_resource.c |   8 +-
 .../amd/display/include/grph_object_ctrl_defs.h    |   4 +
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c     |  15 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    | 118 +++++++-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.h    |   1 +
 drivers/gpu/drm/amd/pm/powerplay/inc/hwmgr.h       |   1 +
 .../gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c    |  15 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |   1 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_12_ppt.c  |   5 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c   |   1 +
 drivers/gpu/drm/amd/ras/rascore/ras_core.c         |  17 +-
 drivers/gpu/drm/amd/ras/rascore/ras_umc.c          |   2 +-
 .../drm/arm/display/komeda/komeda_framebuffer.c    |   6 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |  72 ++++-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.h    |   1 +
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c    |  18 +-
 drivers/gpu/drm/bridge/imx/imx8qxp-pxl2dpi.c       |  40 +--
 drivers/gpu/drm/drm_color_mgmt.c                   |   2 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   4 +-
 drivers/gpu/drm/drm_gem.c                          |   7 +-
 drivers/gpu/drm/drm_gpusvm.c                       |   4 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c             |   1 +
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |   9 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   9 +-
 drivers/gpu/drm/i915/display/skl_watermark.c       |   4 +-
 drivers/gpu/drm/i915/gt/intel_reset.c              |   3 +-
 drivers/gpu/drm/imagination/pvr_rogue_fwif.h       |   8 +-
 .../gpu/drm/imagination/pvr_rogue_fwif_shared.h    |   6 +-
 drivers/gpu/drm/loongson/lsdc_drv.c                |   2 +-
 drivers/gpu/drm/msm/adreno/a4xx_gpu.c              |   6 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |   6 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              | 140 +++++++--
 drivers/gpu/drm/msm/adreno/a6xx_gmu.h              |   7 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              | 109 ++-----
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h              |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c        |  18 +-
 drivers/gpu/drm/msm/adreno/a6xx_hfi.c              |  14 +-
 drivers/gpu/drm/msm/adreno/a8xx_gpu.c              |  26 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   6 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.h            |   3 +-
 .../drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h   |   7 -
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |   3 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |   2 -
 drivers/gpu/drm/msm/dp/dp_display.c                |   1 +
 drivers/gpu/drm/msm/dsi/dsi.c                      |   1 +
 drivers/gpu/drm/msm/dsi/dsi_cfg.c                  |   4 +-
 drivers/gpu/drm/msm/dsi/dsi_cfg.h                  |   2 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  16 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c              |   1 +
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   1 +
 drivers/gpu/drm/msm/hdmi/hdmi_phy.c                |   1 +
 drivers/gpu/drm/msm/msm_fb.c                       |   7 +-
 drivers/gpu/drm/msm/msm_gem.c                      |   3 +
 drivers/gpu/drm/msm/msm_gem_shrinker.c             |   5 +-
 drivers/gpu/drm/msm/msm_gem_vma.c                  |  11 +-
 drivers/gpu/drm/msm/registers/adreno/a6xx_gmu.xml  |   6 +-
 drivers/gpu/drm/panel/Kconfig                      |   1 +
 drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c    |   1 +
 drivers/gpu/drm/panel/panel-simple.c               |   2 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |   2 +
 drivers/gpu/drm/sun4i/sun4i_backend.c              |   6 +-
 drivers/gpu/drm/sun4i/sun8i_mixer.c                |   2 +-
 drivers/gpu/drm/sysfb/ofdrm.c                      |   2 +
 drivers/gpu/drm/ttm/ttm_bo.c                       |  18 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |  11 +-
 drivers/gpu/drm/ttm/ttm_resource.c                 |  18 +-
 drivers/gpu/drm/v3d/v3d_drv.c                      |  16 +-
 drivers/gpu/drm/virtio/virtgpu_prime.c             |   2 +-
 drivers/gpu/drm/xe/xe_dma_buf.c                    |  52 +---
 drivers/gpu/drm/xe/xe_eu_stall.c                   |   4 +-
 drivers/gpu/drm/xe/xe_exec_queue.c                 |   9 +-
 drivers/gpu/drm/xe/xe_gsc.c                        |   2 +-
 drivers/gpu/drm/xe/xe_guc_submit.c                 |  34 +--
 drivers/gpu/drm/xe/xe_lrc.c                        |   2 +-
 drivers/gpu/drm/xe/xe_reg_whitelist.c              |   2 +-
 drivers/gpu/drm/xe/xe_wa.c                         |  37 +--
 drivers/gpu/nova-core/bitfield.rs                  |   5 +-
 drivers/gpu/nova-core/driver.rs                    |   2 +-
 drivers/gpu/nova-core/falcon.rs                    |  74 +++--
 drivers/gpu/nova-core/firmware.rs                  |  88 +++---
 drivers/gpu/nova-core/firmware/booter.rs           |  59 ++--
 drivers/gpu/nova-core/firmware/fwsec.rs            | 167 +++++------
 drivers/gpu/nova-core/gpu.rs                       |   4 +-
 drivers/gpu/nova-core/gsp/boot.rs                  |  34 +--
 drivers/gpu/nova-core/gsp/cmdq.rs                  |  38 +--
 drivers/hid/bpf/hid_bpf_dispatch.c                 |   6 +-
 drivers/hid/hid-asus.c                             |  28 +-
 drivers/hid/hid-core.c                             |  67 ++++-
 drivers/hid/hid-gfrm.c                             |   4 +-
 drivers/hid/hid-logitech-hidpp.c                   |   2 +-
 drivers/hid/hid-multitouch.c                       |   2 +-
 drivers/hid/hid-primax.c                           |   2 +-
 drivers/hid/hid-vivaldi-common.c                   |   2 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   7 +-
 drivers/hid/usbhid/hid-core.c                      |  13 +-
 drivers/hid/wacom_sys.c                            |   6 +-
 drivers/hte/Kconfig                                |   6 +-
 drivers/hv/vmbus_drv.c                             |   1 -
 drivers/hwmon/aspeed-g6-pwm-tach.c                 |   8 -
 drivers/i3c/master.c                               |  32 +--
 drivers/i3c/master/adi-i3c-master.c                |   2 +-
 drivers/i3c/master/dw-i3c-master.c                 |  18 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |   5 +-
 drivers/i3c/master/renesas-i3c.c                   |   4 +-
 drivers/infiniband/core/iwpm_msg.c                 |   6 +-
 drivers/infiniband/core/umem.c                     |  13 +-
 drivers/iommu/amd/iommu.c                          |  15 +-
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c     |   7 +-
 drivers/iommu/intel/iommu.c                        |  16 +-
 drivers/iommu/iommu.c                              | 168 ++++++++---
 drivers/iommu/iommufd/selftest.c                   |   4 +-
 drivers/iommu/iommufd/vfio_compat.c                |   2 +-
 drivers/iommu/riscv/Kconfig                        |   1 +
 drivers/iommu/riscv/iommu-platform.c               |  17 +-
 drivers/iommu/riscv/iommu.c                        |  84 +++++-
 drivers/irqchip/irq-gic-v5-its.c                   |  34 +--
 drivers/irqchip/irq-gic-v5.c                       |  98 ++++---
 drivers/irqchip/irq-meson-gpio.c                   |   3 +-
 drivers/irqchip/irq-pic32-evic.c                   |   2 +-
 drivers/irqchip/irq-renesas-rzg2l.c                |   2 +-
 drivers/irqchip/irq-riscv-imsic-early.c            |   2 +
 drivers/leds/blink/leds-lgm-sso.c                  |   2 -
 drivers/mailbox/mailbox-test.c                     |  43 +--
 drivers/mailbox/mailbox.c                          |   3 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |   8 +-
 drivers/mailbox/mtk-vcp-mailbox.c                  |   2 +-
 drivers/md/dm-cache-metadata.c                     |  24 +-
 drivers/md/dm-cache-metadata.h                     |   5 -
 drivers/md/dm-cache-policy-smq.c                   |   4 +
 drivers/md/dm-cache-target.c                       |  73 +++--
 drivers/md/dm-init.c                               |   4 +-
 drivers/md/dm-log.c                                |   6 +-
 drivers/md/dm-mpath.c                              |   9 +-
 drivers/md/md-bitmap.c                             | 133 ++++++++-
 drivers/md/md-bitmap.h                             |   2 +-
 drivers/md/md-llbitmap.c                           |   7 +-
 drivers/md/md.c                                    | 259 ++++++++++++++---
 drivers/md/md.h                                    |   3 +
 drivers/md/raid1-10.c                              |   7 +-
 drivers/md/raid1.c                                 |   4 +-
 drivers/media/i2c/og01a1b.c                        |  13 +-
 drivers/media/platform/synopsys/Kconfig            |   1 +
 drivers/memory/tegra/tegra124-emc.c                |   2 +-
 drivers/memory/tegra/tegra30-emc.c                 |   6 +-
 drivers/mfd/mc13xxx-core.c                         |   2 +-
 drivers/mtd/maps/physmap-gemini.c                  |   2 +-
 drivers/mtd/nand/raw/sunxi_nand.c                  |   6 +-
 drivers/mtd/nand/spi/core.c                        |  24 +-
 drivers/mtd/nand/spi/winbond.c                     |  19 +-
 drivers/mtd/parsers/ofpart_core.c                  |   4 +-
 drivers/mtd/spi-nor/core.c                         |   2 +-
 drivers/mtd/spi-nor/core.h                         |   2 +-
 drivers/mtd/spi-nor/micron-st.c                    |  10 +
 drivers/mtd/spi-nor/swp.c                          |   4 +-
 drivers/net/bareudp.c                              |   3 +
 drivers/net/bonding/bond_3ad.c                     | 109 +++----
 drivers/net/bonding/bond_main.c                    |   8 +-
 drivers/net/bonding/bond_netlink.c                 |  21 +-
 drivers/net/bonding/bond_procfs.c                  |   3 +-
 drivers/net/bonding/bond_sysfs_slave.c             |  17 +-
 drivers/net/dsa/realtek/rtl8365mb.c                |   2 +-
 drivers/net/ethernet/airoha/airoha_eth.c           | 312 ++++++++++++++------
 drivers/net/ethernet/airoha/airoha_eth.h           |  10 +-
 drivers/net/ethernet/airoha/airoha_ppe.c           |  44 ++-
 drivers/net/ethernet/amazon/ena/ena_com.c          |   7 +-
 drivers/net/ethernet/amazon/ena/ena_phc.c          |   5 +-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   2 +-
 drivers/net/ethernet/broadcom/bnge/bnge_core.c     |  30 +-
 drivers/net/ethernet/broadcom/bnge/bnge_rmem.c     |  16 --
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  30 +-
 drivers/net/ethernet/freescale/Makefile            |   3 +-
 drivers/net/ethernet/freescale/dpaa2/Kconfig       |   4 +
 drivers/net/ethernet/freescale/enetc/ntmp.c        | 231 +++++++++------
 .../net/ethernet/freescale/enetc/ntmp_private.h    |  10 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   1 +
 drivers/net/ethernet/intel/i40e/i40e.h             |   1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c         |   3 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   9 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  52 +---
 drivers/net/ethernet/intel/iavf/iavf_type.h        |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  76 +++--
 drivers/net/ethernet/intel/ice/devlink/devlink.c   |   2 +
 drivers/net/ethernet/intel/ice/ice.h               |   4 +-
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |   2 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   2 -
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c       |   2 +-
 drivers/net/ethernet/intel/ice/ice_dpll.c          | 146 +++++++++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   1 +
 drivers/net/ethernet/intel/ice/ice_lib.c           |   4 +-
 drivers/net/ethernet/intel/ice/ice_main.c          | 123 ++------
 drivers/net/ethernet/intel/ice/ice_ptp.c           |  44 ++-
 drivers/net/ethernet/intel/ice/ice_ptp_consts.h    |  12 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c        | 259 ++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h        |   5 +
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  29 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |  16 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |   7 +-
 drivers/net/ethernet/intel/idpf/idpf_idc.c         |   6 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  22 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |  30 ++
 drivers/net/ethernet/mediatek/mtk_ppe.h            |   1 +
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   4 +-
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c        |   2 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   7 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  39 +--
 .../ethernet/netronome/nfp/nfpcore/nfp_target.c    |  17 +-
 drivers/net/ethernet/sfc/efx_devlink.c             |   2 +-
 drivers/net/ethernet/ti/Makefile                   |  30 +-
 drivers/net/ethernet/ti/cpsw.c                     |   2 +-
 drivers/net/ethernet/ti/cpsw_ale.c                 |  25 ++
 drivers/net/ethernet/ti/cpsw_ethtool.c             |  24 ++
 drivers/net/ethernet/ti/cpsw_new.c                 |   2 +-
 drivers/net/ethernet/ti/cpsw_priv.c                |  39 ++-
 drivers/net/ethernet/ti/cpsw_priv.h                |   2 +-
 drivers/net/ethernet/ti/cpsw_sl.c                  |  11 +
 drivers/net/ethernet/ti/davinci_cpdma.c            |  27 ++
 drivers/net/hamradio/6pack.c                       |   9 +-
 drivers/net/ipa/gsi.c                              |   1 +
 drivers/net/ipa/ipa_main.c                         |   6 +-
 drivers/net/macsec.c                               |  71 ++++-
 drivers/net/macvlan.c                              |   9 +-
 drivers/net/mctp/mctp-i2c.c                        |   4 +-
 drivers/net/netconsole.c                           |  49 ++--
 drivers/net/netdevsim/dev.c                        |   2 +-
 drivers/net/phy/dp83869.c                          |  13 +-
 drivers/net/phy/phy_device.c                       |   4 +-
 drivers/net/phy/qcom/at803x.c                      |   2 +-
 drivers/net/ppp/ppp_generic.c                      |   5 +-
 drivers/net/ppp/pppoe.c                            |   8 +-
 drivers/net/slip/slhc.c                            |  49 ++--
 drivers/net/usb/r8152.c                            |   2 +-
 drivers/net/usb/rtl8150.c                          |  12 +-
 drivers/net/virtio_net.c                           |   6 +
 drivers/net/vrf.c                                  |  15 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |  26 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  28 +-
 drivers/net/wireless/ath/ath12k/dp_htt.c           |  24 +-
 drivers/net/wireless/ath/ath12k/hal.h              |  31 +-
 drivers/net/wireless/ath/ath12k/mac.c              |  51 ++--
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c     |  76 +++--
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  15 +
 drivers/net/wireless/marvell/libertas/if_usb.c     |  32 ++-
 drivers/net/wireless/marvell/libertas/if_usb.h     |   3 +
 drivers/net/wireless/marvell/mwifiex/11n_aggr.c    |   1 +
 drivers/net/wireless/mediatek/mt76/channel.c       |  13 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  11 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        | 154 +++++++---
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   1 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  15 -
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  47 +++
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |   2 -
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |   6 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  16 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   1 +
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  13 -
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  66 ++++-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |  11 +
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   4 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  22 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   2 +
 drivers/net/wireless/mediatek/mt76/mt7925/init.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |  22 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7925/regd.c   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |  22 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |  44 +--
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   | 121 +++++---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  51 +++-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |   2 +
 drivers/net/wireless/mediatek/mt76/mt7996/npu.c    |  23 +-
 drivers/net/wireless/mediatek/mt76/npu.c           |   1 +
 drivers/net/wireless/mediatek/mt76/scan.c          |  66 ++++-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   1 +
 drivers/net/wireless/realtek/rtw89/phy.c           |   2 +-
 drivers/nfc/trf7970a.c                             |   3 +-
 drivers/nvme/host/apple.c                          |   1 +
 drivers/nvme/host/pci.c                            |   1 +
 drivers/nvme/target/tcp.c                          |  51 ++--
 drivers/opp/core.c                                 |   2 +-
 drivers/opp/debugfs.c                              |  20 +-
 drivers/pci/controller/cadence/pci-sky1.c          |   4 +-
 drivers/pci/controller/cadence/pcie-cadence-host.c |   7 +
 drivers/pci/controller/cadence/pcie-cadence.h      |  19 ++
 drivers/pci/controller/cadence/pcie-sg2042.c       |   2 +
 drivers/pci/controller/dwc/pci-imx6.c              |  11 +-
 .../pci/controller/dwc/pcie-designware-debugfs.c   |  21 +-
 drivers/pci/controller/dwc/pcie-designware-ep.c    |  31 +-
 drivers/pci/controller/dwc/pcie-designware-host.c  |  17 +-
 drivers/pci/controller/dwc/pcie-designware.c       |  16 +-
 drivers/pci/controller/dwc/pcie-designware.h       |   3 +
 drivers/pci/controller/dwc/pcie-qcom.c             |  17 +-
 drivers/pci/controller/dwc/pcie-rcar-gen4.c        |   2 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         | 202 ++++++-------
 drivers/pci/controller/pcie-aspeed.c               |   8 +-
 drivers/pci/controller/pcie-mediatek-gen3.c        |   8 +-
 drivers/pci/controller/pcie-rzg3s-host.c           |  23 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |   8 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |  12 +-
 drivers/pci/endpoint/pci-ep-msi.c                  |   5 +
 drivers/pci/npem.c                                 |   2 +-
 drivers/pci/pci-driver.c                           |  20 +-
 drivers/pci/pci-sysfs.c                            |  28 --
 drivers/pci/pci.c                                  |  41 ++-
 drivers/pci/pcie/dpc.c                             |   1 +
 drivers/pci/probe.c                                |   1 -
 drivers/pci/setup-bus.c                            |  59 +++-
 drivers/pci/tph.c                                  |   9 +-
 drivers/pcmcia/rsrc_nonstatic.c                    |   6 +-
 drivers/phy/apple/atc.c                            |   8 +-
 drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c     |   2 +-
 drivers/pinctrl/nomadik/pinctrl-abx500.c           |   2 +-
 drivers/pinctrl/pinconf-generic.c                  |   7 +-
 drivers/pinctrl/pinctrl-cy8c95x0.c                 |  27 +-
 drivers/pinctrl/pinctrl-pic32.c                    |  20 +-
 drivers/pinctrl/realtek/pinctrl-rtd.c              |   2 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   7 +
 drivers/pinctrl/sophgo/pinctrl-sg2042.c            |   2 +-
 drivers/pinctrl/sophgo/pinctrl-sg2044.c            |   2 +-
 drivers/platform/chrome/chromeos_tbmc.c            |   6 +
 drivers/platform/surface/surfacepro3_button.c      |   1 +
 drivers/platform/wmi/core.c                        |  36 +--
 drivers/platform/x86/asus-wmi.c                    |  50 ++--
 drivers/platform/x86/barco-p50-gpio.c              |   5 +-
 .../x86/dell/dell-wmi-sysman/enum-attributes.c     |  34 ++-
 drivers/platform/x86/dell/dell_rbu.c               |   6 +-
 drivers/platform/x86/hp/hp-wmi.c                   |  93 ++++--
 drivers/platform/x86/intel/vsec_tpmi.c             |  10 +-
 drivers/platform/x86/lenovo/wmi-capdata.c          |   8 +-
 drivers/platform/x86/lenovo/wmi-capdata.h          |  20 ++
 drivers/platform/x86/lenovo/wmi-events.c           |   2 +-
 drivers/platform/x86/lenovo/wmi-gamezone.c         |   3 +-
 drivers/platform/x86/lenovo/wmi-gamezone.h         |  20 --
 drivers/platform/x86/lenovo/wmi-helpers.c          |   4 +-
 drivers/platform/x86/lenovo/wmi-helpers.h          |  13 +
 drivers/platform/x86/lenovo/wmi-other.c            | 190 +++++++++----
 drivers/platform/x86/panasonic-laptop.c            |   5 +-
 drivers/pmdomain/imx/scu-pd.c                      |   1 +
 drivers/pmdomain/ti/omap_prm.c                     |   1 +
 drivers/power/supply/max77705_charger.c            |  36 +--
 drivers/pwm/pwm-atmel-tcb.c                        |  38 ++-
 drivers/pwm/pwm-stm32.c                            |  22 +-
 drivers/regulator/fp9931.c                         |   2 +-
 drivers/remoteproc/imx_rproc.c                     |   6 +-
 drivers/remoteproc/xlnx_r5_remoteproc.c            |   2 +-
 drivers/resctrl/mpam_devices.c                     | 122 ++++----
 drivers/resctrl/mpam_internal.h                    |   6 -
 drivers/reset/amlogic/reset-meson.c                |   1 +
 drivers/rtc/rtc-abx80x.c                           |   2 +
 drivers/s390/cio/cio.h                             |   5 -
 drivers/s390/cio/css.c                             |  34 +--
 drivers/s390/crypto/ap_bus.c                       |  34 +--
 drivers/s390/crypto/ap_bus.h                       |   1 -
 drivers/s390/crypto/ap_queue.c                     |  24 +-
 drivers/scsi/hpsa.h                                |   4 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |  62 +++-
 drivers/scsi/qla2xxx/qla_init.c                    |   2 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   9 +
 drivers/scsi/sg.c                                  |  31 +-
 drivers/scsi/sr.c                                  |  11 +-
 drivers/scsi/sr.h                                  |   1 -
 drivers/soc/qcom/llcc-qcom.c                       |   2 +-
 drivers/soc/qcom/ocmem.c                           |  17 +-
 drivers/soc/qcom/qcom_aoss.c                       |   2 +-
 drivers/soc/qcom/ubwc_config.c                     |   3 +-
 drivers/soc/tegra/cbb/tegra234-cbb.c               |  35 ++-
 drivers/soc/tegra/pmc.c                            |   7 +-
 drivers/soundwire/bus.c                            |   8 +-
 drivers/soundwire/cadence_master.c                 |   8 +
 drivers/soundwire/debugfs.c                        |   9 +-
 drivers/soundwire/intel_ace2x.c                    |   5 +
 drivers/spi/spi-amlogic-spisg.c                    |   3 +-
 drivers/spi/spi-atcspi200.c                        |   4 +-
 drivers/spi/spi-axiado.c                           |   3 +-
 drivers/spi/spi-cadence-quadspi.c                  |   4 -
 drivers/spi/spi-fsl-qspi.c                         |   3 +-
 drivers/spi/spi-hisi-kunpeng.c                     |  12 +-
 drivers/spi/spi-mtk-snfi.c                         |  14 +
 drivers/spi/spi-nxp-fspi.c                         |   3 +-
 drivers/spi/spi-nxp-xspi.c                         |   3 +-
 drivers/spi/spi-rockchip.c                         |   3 +-
 drivers/spi/spi-rzv2h-rspi.c                       |  20 +-
 drivers/spi/spi-sifive.c                           |  29 +-
 drivers/staging/greybus/hid.c                      |   2 +-
 drivers/staging/greybus/raw.c                      |  92 +++---
 drivers/staging/media/imx/imx-media-csi.c          |  44 +--
 drivers/target/target_core_sbc.c                   |   3 +-
 drivers/thermal/spear_thermal.c                    |   2 +-
 drivers/tty/hvc/hvc_iucv.c                         |   2 +-
 drivers/tty/serial/ip22zilog.c                     |   2 +-
 drivers/usb/typec/mux/ps883x.c                     |   1 +
 drivers/usb/typec/tipd/core.c                      |   6 +-
 drivers/vdpa/vdpa.c                                |  48 +---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                  |   4 +-
 drivers/vfio/pci/vfio_pci_core.c                   |  28 +-
 drivers/vhost/net.c                                |   4 +-
 drivers/video/backlight/sky81452-backlight.c       |   3 +
 drivers/video/fbdev/matrox/g450_pll.c              |   2 +-
 drivers/video/fbdev/offb.c                         |   7 +-
 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c    |   3 +-
 drivers/virt/coco/sev-guest/sev-guest.c            |  12 +-
 drivers/xen/xen-pciback/pci_stub.c                 |   6 +-
 fs/adfs/super.c                                    |   3 +
 fs/btrfs/disk-io.c                                 |   1 +
 fs/btrfs/inode.c                                   |   5 +-
 fs/btrfs/reflink.c                                 |  45 +++
 fs/btrfs/relocation.c                              |  14 +-
 fs/btrfs/transaction.c                             |   9 +-
 fs/btrfs/volumes.c                                 |   7 +-
 fs/ceph/addr.c                                     |   2 +
 fs/ceph/xattr.c                                    |  17 ++
 fs/d_path.c                                        |  11 +-
 fs/debugfs/file.c                                  |   7 +-
 fs/erofs/data.c                                    |  14 +
 fs/erofs/erofs_fs.h                                |   4 +-
 fs/erofs/inode.c                                   |   2 +-
 fs/erofs/super.c                                   |   8 +-
 fs/erofs/zdata.c                                   |   2 +-
 fs/erofs/zmap.c                                    |  19 +-
 fs/eventpoll.c                                     | 126 +++++----
 fs/ext4/extents-test.c                             |  64 +++--
 fs/ext4/mballoc-test.c                             |   6 +-
 fs/f2fs/gc.c                                       |   5 +-
 fs/f2fs/node.c                                     |   3 +
 fs/f2fs/super.c                                    |  29 +-
 fs/f2fs/sysfs.c                                    |   7 +-
 fs/fuse/dir.c                                      |   5 +
 fs/fuse/file.c                                     |  10 +-
 fs/gfs2/aops.c                                     |   5 +-
 fs/gfs2/inode.c                                    |   3 +-
 fs/gfs2/log.c                                      |  33 ++-
 fs/internal.h                                      |   1 -
 fs/lockd/svclock.c                                 |   5 +
 fs/mbcache.c                                       |   1 +
 fs/netfs/iterator.c                                |  13 +-
 fs/nfs/blocklayout/blocklayout.c                   |   4 +-
 fs/nfsd/nfs4proc.c                                 |  18 +-
 fs/nfsd/nfs4state.c                                |  77 +++--
 fs/nfsd/nfs4xdr.c                                  |  23 +-
 fs/nfsd/nfsfh.c                                    |   9 +-
 fs/nfsd/state.h                                    |  13 +-
 fs/nfsd/xdr4.h                                     |   1 +
 fs/nilfs2/ioctl.c                                  |   6 +
 fs/notify/fanotify/fanotify_user.c                 |  50 ++--
 fs/notify/mark.c                                   |  39 ++-
 fs/ntfs3/attrib.c                                  |  15 +
 fs/ntfs3/inode.c                                   |  10 +-
 fs/ntfs3/super.c                                   |   7 +-
 fs/ocfs2/dlm/dlmdomain.c                           |  10 +-
 fs/ocfs2/ioctl.c                                   |  18 +-
 fs/ocfs2/resize.c                                  |  12 +-
 fs/ocfs2/xattr.c                                   |   4 +-
 fs/omfs/inode.c                                    |   6 +
 fs/open.c                                          |  12 +-
 fs/pstore/ram_core.c                               |   4 +
 fs/quota/dquot.c                                   |  38 ++-
 fs/resctrl/ctrlmondata.c                           |   1 +
 fs/smb/client/ioctl.c                              |   2 +-
 fs/smb/client/smb2file.c                           |   3 +
 fs/smb/client/smb2transport.c                      |  32 ++-
 fs/smb/server/auth.c                               |  11 +-
 fs/smb/server/connection.c                         |   9 +
 fs/smb/server/mgmt/user_session.c                  |  12 +-
 fs/smb/server/smb2pdu.c                            |  15 +-
 fs/tracefs/event_inode.c                           |  96 +++----
 fs/xfs/xfs_zone_alloc.c                            |   2 +-
 include/acpi/actbl1.h                              |   6 +
 include/drm/ttm/ttm_resource.h                     |   2 +
 include/dt-bindings/clock/qcom,gcc-sc8180x.h       |   5 +
 include/dt-bindings/clock/qcom,glymur-gcc.h        |   1 +
 include/linux/cdrom.h                              |   1 +
 include/linux/cpufreq.h                            |   4 +-
 include/linux/cpuhotplug.h                         |   1 -
 include/linux/dmi.h                                |   5 +
 include/linux/dpll.h                               |   1 +
 include/linux/fsl/mc.h                             |   4 -
 include/linux/fsl/ntmp.h                           |   9 +-
 include/linux/hid.h                                |   6 +-
 include/linux/hid_bpf.h                            |  14 +-
 include/linux/ieee80211-eht.h                      |   4 +-
 include/linux/iopoll.h                             |   8 +-
 include/linux/irqchip/arm-gic-v5.h                 |   3 -
 include/linux/moduleparam.h                        |  11 +-
 include/linux/mtd/spinand.h                        |   7 +
 include/linux/mutex.h                              |   6 +-
 include/linux/nstree.h                             |   6 +-
 include/linux/padata.h                             |   8 +-
 include/linux/pci.h                                |   6 -
 include/linux/pm_domain.h                          |   4 +-
 include/linux/ppp_defs.h                           |  16 ++
 include/linux/printk.h                             |   5 +-
 include/linux/quotaops.h                           |   9 +-
 include/linux/rculist.h                            |  29 ++
 include/linux/rseq.h                               |  35 ++-
 include/linux/rseq_entry.h                         | 122 ++++----
 include/linux/rseq_types.h                         |  13 +-
 include/linux/rwlock.h                             |   4 +-
 include/linux/rwlock_api_smp.h                     |   6 +-
 include/linux/sched/deadline.h                     |   9 +
 include/linux/sched/signal.h                       |   2 +-
 include/linux/sched/topology.h                     |  24 +-
 include/linux/spi/spi-mem.h                        |   8 +
 include/linux/spinlock.h                           |   3 +-
 include/linux/spinlock_up.h                        |  20 +-
 include/linux/stop_machine.h                       |   4 +-
 include/linux/sunrpc/debug.h                       |  10 +-
 include/linux/sunrpc/sched.h                       |   3 -
 include/linux/syscalls.h                           |   8 +-
 include/linux/tcp.h                                |   4 +-
 include/linux/trace_printk.h                       |   1 -
 include/linux/vdpa.h                               |   4 -
 include/linux/vfio.h                               |   2 -
 include/linux/wmi.h                                |   4 -
 include/linux/workqueue.h                          |  24 ++
 include/linux/ww_mutex.h                           |   4 +-
 include/net/bond_3ad.h                             |   2 +-
 include/net/dropreason-core.h                      |   6 +
 include/net/ip6_tunnel.h                           |   2 +-
 include/net/netfilter/nf_tables.h                  |  13 +
 include/net/pie.h                                  |   2 +-
 include/net/sch_generic.h                          |  16 +-
 include/net/tcp.h                                  |  31 +-
 include/net/tcp_ecn.h                              |   2 +-
 include/rdma/ib_umem.h                             |   1 +
 include/sound/soc-component.h                      |   4 +
 include/sound/soc.h                                |   3 +
 include/trace/events/dma_fence.h                   |  35 +--
 include/trace/events/mptcp.h                       |   2 +-
 include/trace/events/net.h                         |   4 +-
 include/trace/events/timer.h                       |  11 +-
 include/uapi/linux/if_link.h                       |   2 +
 include/uapi/linux/iommufd.h                       |   5 +
 include/uapi/linux/mii.h                           |   3 +-
 io_uring/io-wq.c                                   |   3 +-
 io_uring/napi.c                                    |   2 +
 kernel/audit.c                                     |   4 +
 kernel/auditsc.c                                   |   2 +-
 kernel/bpf/arena.c                                 |   4 +
 kernel/bpf/arraymap.c                              |   4 +-
 kernel/bpf/bpf_local_storage.c                     |   3 +
 kernel/bpf/bpf_lsm.c                               |   3 -
 kernel/bpf/btf.c                                   |   2 +-
 kernel/bpf/core.c                                  |   2 +
 kernel/bpf/devmap.c                                |   5 +-
 kernel/bpf/hashtab.c                               |   6 +-
 kernel/bpf/helpers.c                               |  17 +-
 kernel/bpf/local_storage.c                         |   2 +-
 kernel/bpf/offload.c                               |  10 +-
 kernel/bpf/syscall.c                               |  17 ++
 kernel/bpf/task_iter.c                             | 151 +++++++++-
 kernel/bpf/verifier.c                              | 111 ++++++--
 kernel/cgroup/cgroup.c                             |  24 +-
 kernel/cgroup/cpuset-internal.h                    |   6 +
 kernel/cgroup/cpuset.c                             |  53 ++--
 kernel/cgroup/dmem.c                               |   1 +
 kernel/cgroup/rdma.c                               |   2 +-
 kernel/fork.c                                      |  23 +-
 kernel/futex/requeue.c                             |  13 +-
 kernel/locking/mutex.c                             |   4 +-
 kernel/module/main.c                               |   4 +-
 kernel/padata.c                                    | 130 ++++-----
 kernel/params.c                                    |  27 +-
 kernel/printk/printk_ringbuffer.c                  |   8 +-
 kernel/rseq.c                                      | 185 +++++++-----
 kernel/sched/core.c                                |  25 +-
 kernel/sched/cpufreq_schedutil.c                   |   5 +-
 kernel/sched/deadline.c                            |  31 +-
 kernel/sched/ext.c                                 |   4 +-
 kernel/sched/fair.c                                |  30 +-
 kernel/sched/membarrier.c                          |  11 +-
 kernel/sched/rt.c                                  |  20 +-
 kernel/sched/topology.c                            |  14 +-
 kernel/time/hrtimer.c                              |  51 ++--
 kernel/trace/trace_branch.c                        |   8 +-
 kernel/trace/trace_events_hist.c                   |  12 +-
 kernel/trace/trace_kprobe.c                        |   8 +
 kernel/trace/trace_printk.c                        |   1 +
 kernel/workqueue.c                                 |  52 +++-
 lib/tests/kunit_iov_iter.c                         |  14 +-
 mm/Kconfig                                         |   1 +
 mm/memblock.c                                      |   2 +-
 net/bluetooth/hci_event.c                          |   3 -
 net/bluetooth/l2cap_core.c                         |   8 +-
 net/bluetooth/sco.c                                |   3 +-
 net/bpf/test_run.c                                 |  35 ++-
 net/ceph/auth_x.c                                  |   5 +
 net/ceph/crush/crush.c                             |   6 +-
 net/ceph/osdmap.c                                  |  14 +-
 net/core/dev.c                                     | 192 +++++++------
 net/core/filter.c                                  |  12 +-
 net/core/neighbour.c                               |  10 +-
 net/core/netpoll.c                                 |  19 +-
 net/core/page_pool.c                               |  10 +-
 net/core/skbuff.c                                  |   4 +-
 net/dsa/conduit.c                                  |  16 +-
 net/ipv4/ip_tunnel_core.c                          |   2 +-
 net/ipv4/netfilter/arp_tables.c                    |  18 +-
 net/ipv4/netfilter/arpt_mangle.c                   |   8 +
 net/ipv4/netfilter/iptable_nat.c                   |   4 +-
 net/ipv4/nexthop.c                                 |   4 +-
 net/ipv4/syncookies.c                              |   2 +-
 net/ipv4/tcp.c                                     |  62 ++--
 net/ipv4/tcp_bbr.c                                 |   6 +-
 net/ipv4/tcp_bic.c                                 |   2 +-
 net/ipv4/tcp_cdg.c                                 |   4 +-
 net/ipv4/tcp_cubic.c                               |   6 +-
 net/ipv4/tcp_dctcp.c                               |   2 +-
 net/ipv4/tcp_input.c                               |  52 ++--
 net/ipv4/tcp_metrics.c                             |   6 +-
 net/ipv4/tcp_nv.c                                  |   4 +-
 net/ipv4/tcp_output.c                              |  43 +--
 net/ipv4/tcp_plb.c                                 |   2 +-
 net/ipv4/tcp_timer.c                               |   7 +-
 net/ipv4/tcp_vegas.c                               |   9 +-
 net/ipv4/tcp_westwood.c                            |   4 +-
 net/ipv4/tcp_yeah.c                                |   3 +-
 net/ipv4/udp.c                                     |  12 +-
 net/ipv6/icmp.c                                    |  10 +-
 net/ipv6/netfilter/ip6table_nat.c                  |   4 +-
 net/ipv6/udp.c                                     |  13 +-
 net/mac80211/mlme.c                                |   3 +-
 net/mptcp/protocol.c                               |  63 +++--
 net/mptcp/protocol.h                               |  37 ++-
 net/netfilter/ipvs/ip_vs_xmit.c                    |  19 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |  10 +-
 net/netfilter/nf_conntrack_sip.c                   | 160 ++++++++---
 net/netfilter/nf_nat_amanda.c                      |   2 +-
 net/netfilter/nf_nat_core.c                        |  10 +-
 net/netfilter/nf_nat_sip.c                         |  34 ++-
 net/netfilter/nf_tables_api.c                      | 314 +++++++++++++++------
 net/netfilter/nfnetlink_osf.c                      |  45 ++-
 net/netfilter/nft_ct.c                             |   2 +
 net/netfilter/nft_fwd_netdev.c                     |  10 +
 net/netfilter/nft_osf.c                            |   6 +-
 net/netfilter/xt_mac.c                             |  34 ++-
 net/netfilter/xt_owner.c                           |  37 ++-
 net/netfilter/xt_physdev.c                         |  29 +-
 net/netfilter/xt_policy.c                          |   2 +-
 net/netfilter/xt_realm.c                           |   2 +-
 net/netfilter/xt_socket.c                          |  23 +-
 net/openvswitch/datapath.c                         |  35 ++-
 net/openvswitch/vport.c                            |   3 +
 net/phonet/socket.c                                |  10 +-
 net/psp/psp-nl-gen.c                               |   4 +-
 net/psp/psp_nl.c                                   |  10 +-
 net/rds/af_rds.c                                   |  10 +-
 net/rds/connection.c                               |  14 +
 net/rds/ib.c                                       |  24 +-
 net/rds/ib.h                                       |   1 +
 net/rds/ib_rdma.c                                  |   2 +-
 net/sched/act_ct.c                                 |   8 +-
 net/sched/act_mirred.c                             |   2 +-
 net/sched/cls_fw.c                                 |   6 +-
 net/sched/sch_cake.c                               | 219 +++++++-------
 net/sched/sch_choke.c                              |  26 +-
 net/sched/sch_dualpi2.c                            |  32 ++-
 net/sched/sch_fq_codel.c                           |   3 +-
 net/sched/sch_fq_pie.c                             |  19 +-
 net/sched/sch_hhf.c                                |  19 +-
 net/sched/sch_netem.c                              |  76 ++++-
 net/sched/sch_pie.c                                |  52 ++--
 net/sched/sch_red.c                                |  31 +-
 net/sched/sch_sfb.c                                |  54 ++--
 net/sched/sch_taprio.c                             |  22 +-
 net/sctp/inqueue.c                                 |   1 +
 net/sctp/ipv6.c                                    |   2 +
 net/sctp/protocol.c                                |   2 +
 net/sctp/sm_statefuns.c                            |   6 +
 net/sctp/socket.c                                  |   5 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |  27 +-
 net/tipc/msg.c                                     |  14 +-
 net/tls/tls.h                                      |   1 +
 net/tls/tls_strp.c                                 |   6 +
 net/tls/tls_sw.c                                   |   4 +
 net/unix/af_unix.c                                 |  44 ++-
 net/unix/unix_bpf.c                                |   3 +
 net/vmw_vsock/virtio_transport_common.c            |  11 +-
 rust/kernel/cpufreq.rs                             |  13 +-
 rust/kernel/sync/atomic.rs                         |   5 +-
 scripts/gdb/linux/timerlist.py                     |   2 +-
 scripts/package/builddeb                           |   8 +-
 security/integrity/ima/ima_crypto.c                |   2 +-
 security/integrity/ima/ima_fs.c                    |  16 +-
 sound/core/compress_offload.c                      |   7 -
 sound/core/sound.c                                 |   7 +
 sound/hda/codecs/cmedia.c                          |   7 -
 sound/hda/codecs/conexant.c                        |   8 +-
 sound/hda/codecs/realtek/alc269.c                  |  30 +-
 sound/hda/codecs/side-codecs/cs35l56_hda.c         |  12 +-
 sound/hda/codecs/side-codecs/cs35l56_hda.h         |   1 +
 sound/hda/codecs/side-codecs/tas2781_hda_spi.c     |  14 +-
 sound/hda/common/codec.c                           |  46 ++-
 sound/hda/common/hda_local.h                       |   1 +
 sound/isa/sc6000.c                                 | 152 ++++++----
 sound/soc/amd/acp-pcm-dma.c                        |   2 +-
 sound/soc/amd/acp/acp-legacy-mach.c                |   2 +-
 sound/soc/amd/acp/acp-mach-common.c                |  22 +-
 sound/soc/amd/acp/acp-mach.h                       |   4 +
 sound/soc/amd/acp/acp-platform.c                   |   2 +-
 sound/soc/amd/acp/acp-sdw-legacy-mach.c            |   4 +-
 sound/soc/amd/acp/acp-sof-mach.c                   |   2 +-
 sound/soc/amd/ps/ps-pdm-dma.c                      |   3 +-
 sound/soc/amd/ps/ps-sdw-dma.c                      |   2 +-
 sound/soc/amd/raven/acp3x-pcm-dma.c                |   2 +-
 sound/soc/amd/renoir/acp3x-pdm-dma.c               |   2 +-
 sound/soc/amd/vangogh/acp5x-pcm-dma.c              |   2 +-
 sound/soc/amd/yc/acp6x-pdm-dma.c                   |   2 +-
 sound/soc/codecs/ab8500-codec.c                    |   6 +-
 sound/soc/codecs/cs35l56-shared.c                  |   7 +-
 sound/soc/codecs/tas2764.c                         |   1 +
 sound/soc/codecs/tas2770.c                         |   4 +-
 sound/soc/fsl/fsl_easrc.c                          | 123 +++++---
 sound/soc/fsl/fsl_micfil.c                         |  72 ++++-
 sound/soc/fsl/fsl_xcvr.c                           |  22 +-
 sound/soc/generic/audio-graph-card.c               |   1 +
 sound/soc/intel/Kconfig                            |   2 +-
 sound/soc/intel/avs/tgl.c                          |  38 ++-
 sound/soc/qcom/qdsp6/audioreach.c                  |   5 +
 sound/soc/qcom/qdsp6/topology.c                    |   8 +-
 sound/soc/renesas/rcar/core.c                      |   2 +-
 sound/soc/rockchip/rockchip_sai.c                  |   4 +
 sound/soc/sdca/sdca_asoc.c                         |  41 ++-
 sound/soc/sdca/sdca_class.c                        |  34 ++-
 sound/soc/sdca/sdca_fdl.c                          |   5 -
 sound/soc/sdca/sdca_functions.c                    |   6 +-
 sound/soc/soc-component.c                          |  10 +-
 sound/soc/soc-compress.c                           |   4 +-
 sound/soc/soc-pcm.c                                |   4 +-
 sound/soc/sof/compress.c                           |   8 +-
 sound/soc/sof/intel/hda-stream.c                   |  10 +-
 sound/soc/sof/intel/hda.c                          |   3 +-
 sound/soc/sof/sof-priv.h                           |   2 +
 sound/soc/sti/uniperif_player.c                    |   9 +-
 sound/usb/midi.c                                   |  12 +-
 sound/usb/midi2.c                                  |  12 +-
 sound/usb/mixer_scarlett2.c                        |   2 +-
 sound/usb/qcom/qc_audio_offload.c                  |  33 ++-
 sound/usb/quirks.c                                 |   3 +-
 sound/usb/stream.c                                 |  58 ++--
 sound/usb/stream.h                                 |   3 +-
 tools/build/feature/Makefile                       |  10 +-
 tools/hv/Makefile                                  |   4 +-
 tools/include/nolibc/arch-mips.h                   |  15 +-
 tools/include/nolibc/compiler.h                    |   8 +-
 tools/include/nolibc/stdio.h                       | 132 ++++++---
 tools/lib/bpf/libbpf.c                             |  23 +-
 tools/lib/bpf/relo_core.c                          |   2 +
 tools/perf/builtin-lock.c                          |   2 +-
 tools/perf/builtin-stat.c                          |  71 +++--
 tools/perf/builtin-trace.c                         |  12 +-
 .../pmu-events/arch/common/common/metrics.json     |   6 +-
 tools/perf/pmu-events/empty-pmu-events.c           | 108 +++----
 tools/perf/tests/parse-events.c                    |  49 ++--
 tools/perf/tests/shell/data_type_profiling.sh      |   6 +-
 tools/perf/tests/workloads/datasym.c               |   6 +-
 tools/perf/util/branch.h                           |   3 +
 tools/perf/util/cgroup.c                           |  30 +-
 tools/perf/util/cs-etm-decoder/cs-etm-decoder.c    |  51 +---
 tools/perf/util/expr.c                             |   3 +-
 tools/perf/util/maps.c                             |  15 +-
 tools/perf/util/symbol-elf.c                       |   8 +-
 tools/perf/util/util.h                             |   1 -
 tools/power/x86/turbostat/turbostat.c              |  96 +++++--
 tools/sched_ext/scx_pair.c                         |  14 +-
 tools/sched_ext/scx_sdt.bpf.c                      |   3 +-
 tools/testing/ktest/ktest.pl                       |  35 ++-
 tools/testing/selftests/arm64/gcs/gcs-util.h       |   6 -
 tools/testing/selftests/arm64/gcs/libc-gcs.c       |   1 +
 .../testing/selftests/bpf/prog_tests/reg_bounds.c  |  35 +++
 tools/testing/selftests/bpf/prog_tests/snprintf.c  |   3 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       |  17 +-
 .../selftests/bpf/prog_tests/test_bpf_smc.c        |   6 +-
 tools/testing/selftests/bpf/progs/bpf_misc.h       |   2 +-
 tools/testing/selftests/bpf/progs/bpf_smc.c        |  28 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   |  11 +-
 tools/testing/selftests/ftrace/ftracetest          |  18 +-
 .../ftrace/test.d/00basic/trace_marker_raw.tc      |   2 +
 tools/testing/selftests/ftrace/test.d/functions    |   4 +
 .../selftests/futex/functional/futex_requeue.c     |  49 +---
 tools/testing/selftests/mm/migration.c             |   3 +-
 .../selftests/namespaces/listns_efault_test.c      |   1 -
 .../selftests/net/netfilter/nft_tproxy_udp.sh      |  14 +-
 .../net/packetdrill/tcp_ts_recent_invalid_ack.pkt  |   4 +-
 tools/testing/selftests/nolibc/nolibc-test.c       |  26 +-
 tools/testing/selftests/powerpc/vphn/Makefile      |   2 +-
 tools/testing/selftests/sched_ext/exit.c           |   2 +-
 tools/testing/selftests/vfio/Makefile              |   2 +-
 .../selftests/vfio/vfio_dma_mapping_mmio_test.c    |   1 -
 tools/tracing/rtla/src/common.c                    |  48 +++-
 tools/tracing/rtla/src/common.h                    |   2 +
 tools/tracing/rtla/src/osnoise_hist.c              |   3 +-
 tools/tracing/rtla/src/osnoise_top.c               |   3 +-
 tools/tracing/rtla/src/timerlat_hist.c             |   3 +-
 tools/tracing/rtla/src/timerlat_top.c              |   3 +-
 tools/tracing/rtla/src/trace.c                     |  19 +-
 tools/tracing/rtla/src/utils.c                     |  25 +-
 virt/kvm/dirty_ring.c                              |   3 +-
 1074 files changed, 11781 insertions(+), 6245 deletions(-)


