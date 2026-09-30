Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CD351AED4;
	Wed, 30 Sep 2026 18:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792813; cv=none; b=pLF1FN26WBSn8wwAHp+cNJ0litzmd4v/eqnK3jbXr7aRxkXIQaFng9qOIbuksaFjBU/TaDCVQUtpVOYU4nfQNzUkKr3IB681Fv6xlbJryhPwoVavZvd74SMHAoO5scZ1hyJG/7uYlSR0HW5JC001bQN/AopWdSsdoicMQJuyYLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792813; c=relaxed/simple;
	bh=S7WtWBeOeCEomEoIHakDYN8aD7inqWEOZqGJHJ1I4iM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WdQVZBWkgN91UBGzw5xsBrYqSAtrnxtDbcOBIEi3gvh2yGlJ+XYc/pBubAR1sd1iZOv7oi5yinO+Opqzosgfr+9CqnuMgFAYKSYW9FV+thqkcVgeNEzhsF8EFfp8qHrRXX3m77fYps+mFhjthl+Z/u8L8AKqSEHyOlgEnVSReww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAYiRQr7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAYiRQr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E6D1F000FF;
	Wed, 30 Sep 2026 18:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792809;
	bh=eUVqN5OZzdXyvk1MQtxNIvngNBSwtZVrSgOHkH1xl+k=;
	h=From:To:Cc:Subject:Date;
	b=wAYiRQr7EXm0kxHffn9Sa3RCiSiCgd0LZopt75ebekP70+7YTYmkurNv+y99UhMer
	 vWEuFa4u8ozk+MEbDFjiP5Pm33scAFyoo5V/R3ywotv9UQBGgngP2MkvM+eSZTgvlE
	 CDepyij2BaI7unVnVq/9XlbTB5joVMPTwHzlWSwc=
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
Subject: [PATCH 6.18 000/395] 6.18.55-rc1 review
Date: Wed, 30 Sep 2026 17:24:22 +0200
Message-ID: <20260930152340.591469096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.55-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.55-rc1
X-KernelTest-Deadline: 2026-10-02T15:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.55 release.
There are 395 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.55-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.55-rc1

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Reject key-less BTF for hash maps

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: don't warn on stray CALL_ACCEPTED/CLEAR_CONFIRMATION in state 3

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: use timer_shutdown_sync() for t0timer teardown

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: guard rose_transmit_link() against a NULL neighbour

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: keep the route needed for routing loop detection

Tejun Heo <tj@kernel.org>
    sched_ext: Derive SCX_RQ_IN_WAKEUP from the core enqueue flags

Shardul Bankar <shardulsb08@gmail.com>
    hfsplus: avoid double unload_nls() on mount failure

Liew Rui Yan <aethernet65535@gmail.com>
    mm/damon/core: fix unconditionally skip last region

Chunfeng Song <springbreeze@stu.pku.edu.cn>
    rust: net: phy: fix off-by-one bit positions in device status accessors

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "rust: net: phy: fix off-by-one bit positions in device status accessors"

Xie Bo <xb@ultrarisc.com>
    RISC-V: KVM: Serialize IMSIC attributes with vCPU migration

Jiakai Xu <jiakaipeanut@gmail.com>
    RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_rw_attr()

Ilya Maximets <i.maximets@ovn.org>
    net/sched: act_ct: avoid modifying shared unconfirmed ct entry

Ilya Maximets <i.maximets@ovn.org>
    net/sched: act_ct: fix helper UAF due to extensions realloc

Melody Wang <huibo.wang@amd.com>
    x86/sev: Make vTPM SVSM calls preemption-safe

Nikunj A Dadhania <nikunj@amd.com>
    x86/sev: Remove redundant ghcbs_initialized checks around __sev_{get,put}_ghcb()

Borislav Petkov (AMD) <bp@alien8.de>
    x86/sev: Carve out the SVSM code into a separate compilation unit

Borislav Petkov (AMD) <bp@alien8.de>
    x86/sev: Add internal header guards

Borislav Petkov (AMD) <bp@alien8.de>
    x86/sev: Move the internal header

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Remove incorrect LionCove PEBS data-source constraints

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Update event constraints and cache_extra_regsfor LNL

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Fix GRT PEBS load/store direction for latency events, to fix sample classification

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Update event constraints and cache_extra_regsfor ADL

Yuqi Xu <xuyuqiabc@gmail.com>
    net: ipconfig: bound DHCP option construction

Thorsten Blum <thorsten.blum@linux.dev>
    net: ipconfig: Remove outdated comment and indent code block

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: fix dma_alloc_coherent() leak on macb_alloc() error paths

Chen Changcheng <chenchangcheng@kylinos.cn>
    HID: alps: unregister DualPoint Stick input device on remove

Bastien Nocera <hadess@hadess.net>
    HID: hid-alps: Use pm_ptr instead of #ifdef CONFIG_PM

Liz Fong-Jones <lizf@honeycomb.io>
    PCI: Fix BAR resize for devices on a root bus

Christian Brauner <brauner@kernel.org>
    super: make iterate_supers_type() deletion-safe

Longlong Xia <xialonglong@kylinos.cn>
    mm/hugetlb: do not dissolve gigantic pages without runtime support

Usama Arif <usamaarif642@gmail.com>
    mm/hugetlb: create hstate_is_gigantic_no_runtime helper

Jinjiang Tu <tujinjiang@huawei.com>
    mm/rmap: fix missing barrier between anon_vma init and vma->anon_vma publish

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm/rmap: allocate anon_vma_chain objects unlocked when possible

shechenglong <shechenglong@xfusion.com>
    drm/client: fix restore of partially initialized client

Thomas Zimmermann <tzimmermann@suse.de>
    drm/client: Pass force parameter to client restore

Thomas Zimmermann <tzimmermann@suse.de>
    drm/client: Remove holds_console_lock parameter from suspend/resume

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu: Fix acpi device leak in amdgpu_acpi_enumerate_xcc()

Ankit Nautiyal <ankit.k.nautiyal@intel.com>
    drm/i915/quirks: Limit eDP rate to HBR2 on HP Pavilion Plus 14-ew1

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Disable PSR2 on Xiaomi Book Pro 14 2026 as a quirk

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Fixes for Dell XPS DA14260 quirk

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Disable Panel Replay on Dell XPS 14 DA14260 as a quirk

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    i2c: qcom-geni: Fix hardcoded clock index in SE_GENI_CLK_SEL

Xiang Mei <xmei5@asu.edu>
    vlan: require the MAC header to be present in __vlan_insert_inner_tag()

Hui Peng <benquike@gmail.com>
    cgroup/cpuset: Return PERR_NOCPUS in remote_partition_enable() on subpartitions_cpus conflict

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Ensure domain isolated CPUs stay in root or isolated partition

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Move up prstate_housekeeping_conflict() helper

Jakub Kicinski <kuba@kernel.org>
    net: tls: fix silent data drop under pipe back-pressure

Darrick J. Wong <djwong@kernel.org>
    xfs: fix cursor and pointer handling when recovering iunlink buckets

Darrick J. Wong <djwong@kernel.org>
    xfs: fix blockgc group quota scanning when usrquota isn't enforced

Darrick J. Wong <djwong@kernel.org>
    xfs: drop dquot flush lock when we can't find a buffer to flush

Darrick J. Wong <djwong@kernel.org>
    xfs: don't let hidden_space go negative in xfs_metafile_resv_init

Darrick J. Wong <djwong@kernel.org>
    xfs: call xfs_dquot_set_prealloc_limits if we installed default rtb limits

Darrick J. Wong <djwong@kernel.org>
    xfs: fix wild memcpy access when formatting ondisk rtrefcount btree roots

Darrick J. Wong <djwong@kernel.org>
    xfs: fix rtgroup repair estimations

Darrick J. Wong <djwong@kernel.org>
    xfs: check di_forkoff correctly in scrub

Darrick J. Wong <djwong@kernel.org>
    xfs: use the correct reservations for rtrmap/refcount recovery

Darrick J. Wong <djwong@kernel.org>
    xfs: don't call xfs_exchange_range_finish for a dry run

Darrick J. Wong <djwong@kernel.org>
    xfs: check padding field in xfs_ioc_commit_range

Darrick J. Wong <djwong@kernel.org>
    xfs: use correct jiffies comparison function in xchk_maybe_relax

Darrick J. Wong <djwong@kernel.org>
    xfs: release orphanage dir inode if chown fails

Darrick J. Wong <djwong@kernel.org>
    xfs: fix attr fork block count checks in xrep_inode_blockcounts

Darrick J. Wong <djwong@kernel.org>
    xfs: don't assert when XFS_SCRUB_TYPE_HEALTHY scans return corruption

Zihan Xi <zihanx@nebusec.ai>
    smb: client: validate POSIX create context length

Zihan Xi <zihanx@nebusec.ai>
    smb: client: preserve create-context parsing errors

Zihan Xi <zihanx@nebusec.ai>
    smb: client: clean up failed cached directory opens

Zihan Xi <zihanx@nebusec.ai>
    smb: client: fix create context out-of-bounds reads

Hui Peng <benquike@gmail.com>
    Bluetooth: RFCOMM: fix NULL dereference of dlc->session in RFCOMM_CONNINFO

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: mgmt: fix race in read_unconf_index_list()

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: L2CAP: validate frame length before control and FCS access

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: ISO: release unused CIS holds after channel attach

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: ISO: balance the parent hold in hci_bind_bis()

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: hci_sock: reject out-of-range OCF values

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: hci_sock: validate event length before filtering

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: hci_conn: fix CIS hold ownership on reuse

Tan Chi <tanchi25@mails.ucas.ac.cn>
    RISC-V: KVM: Fix HSM hart status error propagation

Xie Bo <xb@ultrarisc.com>
    RISC-V: KVM: Propagate interrupted G-stage faults

Myeonghun Pak <mhun512@gmail.com>
    RISC-V: KVM: Synchronize hrtimer callback during teardown

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: Transfer the hyp stack pages out of the host stage-2

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    KVM: arm64: nv: Fix null ptr deref on nested wp/unmap, teardown race

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    KVM: arm64: Fix spurious warning for benign stage 2 teardown race

Karl Mehltretter <kmehltretter@gmail.com>
    KVM: arm64: Fix AArch32 DBGBXVR<n> handling

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Do cache maintenance on the source VM during intra-host migration

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Free have_run_cpus during VM destruction even if VM is no longer SEV

Zeng Chi <zengchi@kylinos.cn>
    KVM: Don't treat reserved xarray entries as having memory attributes

David Ballesteros <davimaba.v@proton.me>
    KVM: Ensure memory attributes xarray nodes are accounted to the caller's memcg

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: fix KVM GISC and page leak when queue removed from host config

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Don't report recovery success on skipped recovery

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Report SCLP status on error events when no pdev is associated

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix missing device lock in zpci_report_status()

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix leak of struct pci_dev reference in zpci_report_status()

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/cmf: Fix virtual vs physical address confusion

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Fix NULL pointer dereference in ccw_device_get_util_str()

Ilya Titov <ilya.titov@wirenboard.com>
    pinctrl: sunxi: keep a shadow copy of the data register output latches

Myeonghun Pak <mhun512@gmail.com>
    pinctrl: single: free the IRQ on domain creation failure

Puranjay Mohan <puranjay@kernel.org>
    perf/core: Run sched_task() for PMUs with only CPU-wide events

Puranjay Mohan <puranjay@kernel.org>
    perf/core: Fix NULL pmu_ctx passed to pmu->sched_task()

Helge Deller <deller@gmx.de>
    parisc: Increase kernel stack size to 32kb

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    scsi: libiscsi_tcp: Check the data direction of a Data-In PDU

Myeonghun Pak <mhun512@gmail.com>
    nfc: trf7970a: power down on startup RX gain failure

Doruk Tan Ozturk <doruk@0sec.ai>
    nfc: port100: reject frames whose declared length exceeds the received data

Aamir Ahmed <elb12345@hotmail.co.uk>
    nfc: llcp: drop truncated I/RR/RNR PDUs in nfc_llcp_recv_hdlc()

Luxiao Xu <rakukuip@gmail.com>
    nfc: fix use-after-free in nfc_get_local_general_bytes

Aohan Mei <henrymei@tencent.com>
    netfilter: nf_tables: skip expired catchall elements on insert and delete

Luxiao Xu <rakukuip@gmail.com>
    netfilter: ip6t_rt: fix zero-address non-strict match out-of-bounds read

Weiming Shi <bestswngs@gmail.com>
    netfilter: ip6t_rpfilter: reject routes without inet6_dev

Wentao Liang <vulab@iscas.ac.cn>
    net: usb: lan78xx: Fix URB reference leak in lan78xx_submit_deferred_urbs()

Ming Wang <wangming01@loongson.cn>
    net: usb: cdc_mbim: add MeiG Smart SRM821 to ZLP whitelist

Zhang Yunfei <zhangyunfei1@kylinos.cn>
    net: txgbe: fix FDIR filter restore for VF rules

Abhishek Ojha <abhishek.ojha@savoirfairelinux.com>
    net: phy: micrel: Advance register data pointer in write loop

Guangshuo Li <lgs201920130244@gmail.com>
    net: ena: fix MMIO read buffer leak on probe failure

Guangshuo Li <lgs201920130244@gmail.com>
    net: ena: fix PHC cleanup on probe failure

Fourie Zhang <littleddfu@gmail.com>
    net: bridge: mdb: restart port group walk after deletion

Gajdos Tamás <tamas@rimpianto.com>
    net: atl1e: fix soft lockup on out-of-range hw_next_to_clean read

Gajdos Tamás <tamas@rimpianto.com>
    net: atl1c: fix soft lockup on out-of-range tpd_cons read

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: conntrack: fix helper UAF due to extensions realloc

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: conntrack: remove 'add_helper' dead code

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: conntrack: avoid modifying shared unconfirmed ct entry

Wentao Liang <vulab@iscas.ac.cn>
    net: hisilicon: hns_dsaf_mac: fix mdio device leak in hns_mac_register_phy()

Gajdos Tamás <tamas@rimpianto.com>
    net: atl1: fix soft lockup on out-of-range cmb_tpd_next_to_clean read

Zijie Huang <milkory@outlook.com>
    net: arp: terminate device name before lookup

Myeonghun Pak <mhun512@gmail.com>
    net: airoha: npu: cancel wdt_work after releasing the WDT IRQ

Weiming Shi <bestswngs@gmail.com>
    net/sched: reject IDR error pointers when deleting actions

Andrea Parri <parri.andrea@gmail.com>
    net/mlx5e: fix swapped IPv6 IPsec policy masks

Ralf Lici <ralf@mandelbit.com>
    net/mlx5e: advertise MACsec offload only when supported

Wentao Liang <vulab@iscas.ac.cn>
    net/mlx5: Fix rev_entry reference leak in mlx5_tc_ct_shared_counter_get()

Wei Jie LAW <98lawweijie@gmail.com>
    HID: wacom: fix OOB read in wacom_wac_pen_serial_enforce()

Junjie Cao <junjie.cao@intel.com>
    HID: quirks: add ALWAYS_POLL quirk for SDINNOVATION gaming keyboard

Chen Changcheng <chenchangcheng@kylinos.cn>
    HID: alps: fix use-after-free on input2 registration failure

Willem de Bruijn <willemb@google.com>
    packet: use ubuf_info completion for TX_RING packets

Angel J <iamanaws@httpd.dev>
    PCI: of_property: Omit bus properties without a subordinate bus

SJ Park <sj@kernel.org>
    mm/damon/vaddr: avoid hw-driven pte updates during damon_hugetlb_mkold()

Jaewook You <jaewook376@gmail.com>
    mm/hugetlb: preserve mremap address delta when skipping page tables

Karl Mehltretter <kmehltretter@gmail.com>
    gpio: tps65219: Fix TPS65214 GPIO direction programming

Karl Mehltretter <kmehltretter@gmail.com>
    gpio: tps65219: Use the variant-specific direction callback

Karl Mehltretter <kmehltretter@gmail.com>
    gpio: tps65219: Fix GPIO input value reads

Peiyang He <peiyang_he@smail.nju.edu.cn>
    drm/virtio: fix NULL pointer dereference on fence allocation failure

Peiyang He <peiyang_he@smail.nju.edu.cn>
    drm/virtio: fix memory leak of fence event on execbuffer failure

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Keep walking on SVM eviction failure

Szymon Acedański <accek@invisiblethingslab.com>
    drm/xe: Limit sg segment size to PAGE_SIZE on Xen PV

Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>
    drm/xe: harden adjust_idledly() against divide-by-zero and overflow

Matthew Auld <matthew.auld@intel.com>
    drm/xe/vm: nuke PTs only after unlinking contested VMAs

Peiyang He <peiyang_he@smail.nju.edu.cn>
    drm/nouveau: don't bump pin count on failed re-pin in nouveau_bo_pin_locked()

Jonghyuk Kim(MalHyuk) <malhyuk97@gmail.com>
    drm/nouveau: RCU-free the scheduler-containing nouveau_sched

Wentao Liang <vulab@iscas.ac.cn>
    drm/nouveau: Fix runtime PM leak in nouveau_connector_detect()

Wentao Liang <vulab@iscas.ac.cn>
    drm/nouveau: Fix gem reference leak in validate_init()

Peiyang He <peiyang_he@smail.nju.edu.cn>
    drm/nouveau: fix double-free in nvif_vmm_dtor

Wentao Liang <vulab@iscas.ac.cn>
    drm/nouveau: Fix bridge reference leak in nv1a_ram_new()

Guangshuo Li <lgs201920130244@gmail.com>
    drm/nouveau: fix autosuspend cleanup during teardown

Peiyang He <peiyang_he@smail.nju.edu.cn>
    drm/nouveau/uvmm: fix UAF in nouveau_uvmm_sm when BO is in TTM_PL_SYSTEM

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu: Fix vmid_wait fence leak in amdgpu_ring_init()

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu: Fix runtime PM leak in amdgpu_debugfs_test_ib_show()

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu: Fix last_update fence leak in amdgpu_vm_init()

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Bump frame warning limit for clang builds of dml

Wentao Liang <vulab@iscas.ac.cn>
    drm/amd/display: Fix dc stream excess put in dm_update_crtc_state()

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_mst: Fix configuring TUs for a disconnected stream

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_mst: Fix configuring FEC for a disconnected stream

Christian König <ckoenig.leichtzumerken@gmail.com>
    drm/i915: fix incorrect RCU teardown order

Brajesh Gupta <brajesh.gupta@imgtec.com>
    drm/imagination: Fix page count for page table for map() interface

Brajesh Gupta <brajesh.gupta@imgtec.com>
    drm/imagination: Propagate map failures correctly from pvr_mmu_map_sgl()

Dongliang Qin <cccccccccccc777777@gmail.com>
    rds: ib: Clear the sg list when mapping an MR fails

Hui Peng <benquike@gmail.com>
    mctp: route: iterate socket tag list in mctp_lookup_prealloc_tag()

Zixuan Chai <petalzu987@gmail.com>
    llc: reserve device headroom for allocated frames

Ridham Khurana <khurana.ridham222@gmail.com>
    gpio: zynq: fix runtime PM leak on request error path

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: cdev: fix kernel stack leak to user-space in error path

Wentao Liang <vulab@iscas.ac.cn>
    gpio: arizona: Fix runtime PM leak in arizona_gpio_direction_out()

Hui Peng <benquike@gmail.com>
    ipv6: sr: enforce exact attribute length for SEG6_ATTR_DST

Norbert Szetei <norbert@doyensec.com>
    ipv6: do not let ipv6_find_hdr() return an offset past the packet end

Fan Wu <wufan@kernel.org>
    ipe: protect the dm-verity root hash with RCU

Fan Wu <wufan@kernel.org>
    ipe: fix use-after-free when auditing a newly loaded policy

Wentao Liang <vulab@iscas.ac.cn>
    fsl/fman: Fix clk reference leak in read_dts_node()

Josef Bacik <josef@toxicpanda.com>
    writeback: report a Tasks-RCU quiescent state per cgwb drain pass

Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>
    workqueue: Fix NULL current_pwq deref in flush dependency check

Patrick Lu (Anthropic) <perf.patrick.lu@gmail.com>
    writeback: bound cleanup_offline_cgwb() rescans by rotating scanned inodes

Christian Brauner <brauner@kernel.org>
    fs/ntfs3: use d_instantiate_new() in ntfs_create_inode() and murder syzbot's "WARNING in do_new_mount" saga

Hui Peng <benquike@gmail.com>
    fou: reject omitted FOU_ATTR_IPPROTO on FOU_ENCAP_DIRECT

Guopeng Zhang <zhangguopeng@kylinos.cn>
    cgroup/pids: Restore pids.events notifications in local mode

Holger Dengler <dengler@linux.ibm.com>
    crypto: s390/hmac - Generate intermediate CV for API partial block handling

Andrea Parri <parri.andrea@gmail.com>
    bpf: fs/xattr: don't assume the inode is locked in path_unlink/path_rmdir

Myeonghun Pak <mhun512@gmail.com>
    bna: prevent IOC timer rearm during teardown

Matthias Goergens <matthias.goergens@gmail.com>
    ata: libata-scsi: bound the ATA passthru sense descriptor writes

David Carlier <devnexen@gmail.com>
    arm64: errata: match the target implementation CPU's own MIDR

Fuad Tabba <fuad.tabba@linux.dev>
    arm64/boot: Disable trapping of PMZR_EL0 writes to EL2

Dairui Zhang <zhangdairui@gmail.com>
    af_packet: fix integer overflow in prb_calc_retire_blk_tmo()

Aohan Mei <henrymei@tencent.com>
    sctp: discard the rest of the packet on a stale-cookie error

Willem de Bruijn <willemb@google.com>
    tcp: prevent collapsing skbs across boundary in rtx queue

Eric Dumazet <edumazet@google.com>
    tipc: reject invalid and unexpected GRP_ACK_MSG to prevent bc_ackers underflow

Willem de Bruijn <willemb@google.com>
    virtio_net: copy zerocopy frags in start_xmit without NAPI

Mario Limonciello <mario.limonciello@amd.com>
    x86/PCI: Disable enhanced atomics on AMD NBIO 7.7 and 7.11

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    x86/mce: Fix hardware debug register corruption on task migration

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase

Pablo Neira Ayuso <pablo@netfilter.org>
    rculist: add list_splice_rcu() for private lists

Mark Amirkan <markdamirkan@gmail.com>
    mptcp: return sk_wait_data() errors from recvmsg()

Zhan Xusheng <zhanxusheng1024@gmail.com>
    sched/core: Account PSI IRQ time to the execution context, not the scheduling context

Namhyung Kim <namhyung@kernel.org>
    perf/core: Fix a refcount leak in attach_perf_ctx_data()

Sean Christopherson <seanjc@google.com>
    perf/x86/intel: Make @data a mandatory param for intel_guest_get_msrs()

Sean Christopherson <seanjc@google.com>
    perf/x86/intel: Don't pointlessly context switch DS_AREA (and PEBS config) if PEBS is unused

Sean Christopherson <seanjc@google.com>
    perf/x86/intel: Don't write PEBS_ENABLED on host<=>guest xfers if CPU has PEBS isolation, to fix stuck PEBS_ENABLED

Sean Christopherson <seanjc@google.com>
    perf/x86/intel: Ensure KVM guest PEBS path doesn't set unwanted PERF_GLOBAL_CTRL bits

Hui Peng <benquike@gmail.com>
    autofs: fix sbi->pipe file reference leak in autofs_kill_sb()

Eric Dumazet <edumazet@google.com>
    vlan: ensure sufficient headroom in vlan_dev_hard_header()

Eric Dumazet <edumazet@google.com>
    net/sched: sch_teql: fix shadowed err in __teql_resolve()

Eric Dumazet <edumazet@google.com>
    bridge: check llc_mac_hdr_init() return value in br_send_bpdu()

Eric Dumazet <edumazet@google.com>
    llc: fix skb UAF and leaks on llc_mac_hdr_init() failure

Eric Dumazet <edumazet@google.com>
    gve: DQO: reject TSO packets with an out of range MSS

Eddie Phillips <eddiephillips@google.com>
    gve: fix TX drop when GSO MSS is too small for hw

Eric Dumazet <edumazet@google.com>
    gve: DQO: fix header length used by gve_can_send_tso() for UDP GSO

Ankit Garg <nktgrg@google.com>
    gve: add support for UDP GSO for DQO format

Ankit Garg <nktgrg@google.com>
    gve: Enable hw-gro by default if device supported

Ankit Garg <nktgrg@google.com>
    gve: Advertise NETIF_F_GRO_HW instead of NETIF_F_LRO

Ankit Garg <nktgrg@google.com>
    gve: Allow ethtool to configure rx_buf_len

Ankit Garg <nktgrg@google.com>
    gve: Use extack to log xdp config verification errors

Ankit Garg <nktgrg@google.com>
    gve: Consolidate and persist ethtool ring changes

Coia Prant <coiaprant@gmail.com>
    net: ethernet: stmmac: dwmac-rk: fix bulk clock leak when the PHY clock fails

Ginger Li <ginger.jzllee@gmail.com>
    tipc: Fix a data race on mon->peer_cnt in mon_timeout()

Sidraya Jayagond <sidraya@linux.ibm.com>
    net/smc: fix UAF on lgr list traversal in smcr_port_err()

Sang-Hoon Choi <csh0052@gmail.com>
    nfp: hold IPsec RX state under the XArray lock

Aleksei Sviridkin <f@lex.la>
    net: phylink: record the PHY only once bringup cannot fail

Yilin Zhang <yilinzhang@moonshot.ai>
    tcp: fix use-after-free of retransmit_skb_hint in tcp_send_synack()

Aleksei Sviridkin <f@lex.la>
    net: dsa: mt7530: leave the MDIO IRQ mappings to regmap-irq

Aleksei Sviridkin <f@lex.la>
    net: dsa: mt7530: fix NULL dereference on unbind of MT7531 and MT7621

Haseeb Malik <haseebulhaq55@gmail.com>
    macsec: initialize SecY before registering the netdevice

David Dai <zdai@linux.ibm.com>
    bonding: crypto offload enabled, non-offload slave failover, rekey failed

Pengpeng Hou <hppiscas@163.com>
    drm/imagination: clamp freelist reconstruction requests

Norbert Szetei <norbert@doyensec.com>
    net: xps: reject an out of range traffic class

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    vxlan: use one headroom snapshot for neighbour replies

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    ip_gre: Reject enabling collect metadata through changelink

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: mask DMA_TIMEOUT_MASK when reading DMA_RING0_TIMEOUT

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: validate Ethernet address in bcmgenet_set_mac_addr

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: do not skip WoL power up on GENET V1

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: initialize u64 stats seq counter for all queues

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: fix 64-bit RTNL stats reading in ethtool on 32-bit systems

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: clear stale buf->page after recycling on skb build failure

Ivan Delalande <colona@arista.com>
    tg3: use random MAC address when tg3_get_device_address fails

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf: Fix BSWAP 32 and 16 on MIPS64

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf: Fix immediate JMP JEQ/JNE on MIPS32

Ido Schimmel <idosch@nvidia.com>
    vrf: Stop corrupting skb->csum when capturing CHECKSUM_COMPLETE packets

Shihuang Liu <shlomojune6@gmail.com>
    net: skbuff: fix pull-bound underflow in skb_checksum_setup_ipv6()

Jakub Kicinski <kuba@kernel.org>
    veth: manage XDP program pointers during channel resize

Nicolai Buchwitz <nb@tipi-net.de>
    net: bcmgenet: stop Tx NAPI before disabling the queues

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_gate: budget the per-entry list in get_fill_size

Deepanshu Kartikey <kartikey406@gmail.com>
    nfc: pn533: fix OOB read in pn533_acr122_is_rx_frame_valid()

Ömer Mete Kaya <omermetekaya0@gmail.com>
    nfc: llcp: fix slab-out-of-bounds reads when logging service names

Ömer Mete Kaya <omermetekaya0@gmail.com>
    nfc: llcp: fix WKS SAP hijacking via prefix match in nfc_llcp_wks_sap()

Ömer Mete Kaya <omermetekaya0@gmail.com>
    nfc: llcp: fix -ENOMEM on connect with zero-length service name

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: st21nfca: validate ISO15693 inventory length

Cong Nguyen <congnt264@gmail.com>
    nfc: llcp: fix sdreq TLV list leak on parse/alloc/send failure

Chris Gellermann <christian.gellermann@codasip.com>
    nfc: virtual_ncidev: Add missing ioctl compat handler

Chris Gellermann <christian.gellermann@codasip.com>
    selftests/nci: Fix out-of-bounds store on thread join

Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
    selftests: nci: Fix uninitialized family ID on missing attribute

Lee Jones <lee@kernel.org>
    nfc: llcp: Fix race condition in accept_queue lifecycle

Lei Zhu <zhulei@kylinos.cn>
    selftests: nci: Correct pthread_create return value check

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nfc: llcp: Fix list corruption / refcount desync in nfc_llcp_recv_dm()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: st21nfca: validate received frame size

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: nfcmrvl: validate helper command length before pull

Weiming Shi <bestswngs@gmail.com>
    bpf: Reject dev-bound-only programs on other devices

Bernard Ladenthin <bernard.ladenthin@gmail.com>
    net/sched: fix potential stack infoleak in em_text_dump()

Björn Töpel <bjorn@kernel.org>
    eth: fbnic: Avoid rounding zero ring sizes

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Account for alignment shift on dwmac1000 for Jumbo test

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwmac4: Use the correct bufzise when the len is exactly 8K

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Capture all packets for vlan checks

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Check the dev->features for S-TAG offload testing

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Support running selftests on DSA conduits

Xin Long <lucien.xin@gmail.com>
    sctp: hold asoc or transport before mod_timer() in timer handlers

Bernardo Soares <bsoares.it@gmail.com>
    net/mlx5: Bridge, don't fail unlink of untracked/unsupported peer ports

Bernardo Soares <bsoares.it@gmail.com>
    net/mlx5: Bridge, don't fail switchdev events of sibling eswitch ports

Zhao Gongyi <zhaogongyi@BYTEDANCE.COM>
    bpf, sockmap: Reject max_entries > INT_MAX in sock_map_alloc

Emil Tsalapatis <emil@etsalapatis.com>
    bpf: Fix bpf_sock context code generation

Emil Tsalapatis <emil@etsalapatis.com>
    bpf: Fix bounds check for skb-backed dynptrs

Manaf Meethalavalappu Pallikunhi <manaf.pallikunhi@oss.qualcomm.com>
    thermal: gov_step_wise: Fix stale mitigation vote with non-zero lower bounds

Coia Prant <coiaprant@gmail.com>
    net: pcs: xpcs: fix clock reference leak on xpcs_init_clks failure

Jakub Kicinski <kuba@kernel.org>
    genetlink: report the real command id for dump-only ops in policy dumps

bui duc phuc <phucduc.bui@gmail.com>
    net: ethernet: ti: netcp: fix pm_runtime usage counter leak on error

Muhammad Bilal <meatuni001@gmail.com>
    net: spacemit: clear TX descriptor on fragment mapping failure

Mikhail Zaslonko <zaslonko@linux.ibm.com>
    s390/debug: Fix NULL pointer dereference in debug_info_copy()

Mikhail Zaslonko <zaslonko@linux.ibm.com>
    s390/debug: Do not register views for failed static debug areas

Nemesa Garg <nemesa.garg@intel.com>
    drm/i915/psr: Clear stale sel fetch enable bits on sel fetch disable

Myeonghun Pak <mhun512@gmail.com>
    tg3: clean up PHYLIB resources on probe failure

Shardul Bankar <shardul.b@mpiricsoftware.com>
    udp: remove a disconnected socket from the 4-tuple hash table

Shardul Bankar <shardul.b@mpiricsoftware.com>
    udp: relocate a connected socket in the 4-tuple hash table on re-connect

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Fix dst leak for uncached routes.

Pengpeng Hou <hppiscas@163.com>
    net: usb: sr9700: include receive overhead in the length check

Ivan Vecera <ivecera@redhat.com>
    dpll: use exact lookup for reference sync pin id

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Prevent rt6_insert_exception() for dying fib6_info.

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: Fix memory scaling limitation in SR-IOV mode

Hui Peng <benquike@gmail.com>
    Bluetooth: RFCOMM: Reject short EA=0 frames in rfcomm_recv_frame()

Ravindra <ravindra@intel.com>
    Bluetooth: btintel_pcie: validate device-supplied DMA indices

Hui Peng <benquike@gmail.com>
    Bluetooth: bnep: fix out-of-bounds reads on short RX/TX frames and control fallthrough

Ralf Lici <ralf@mandelbit.com>
    ovpn: reject invalid peer VPN addresses

Ralf Lici <ralf@mandelbit.com>
    ovpn: reject multipeer peers without VPN addresses

Ralf Lici <ralf@mandelbit.com>
    ovpn: reject duplicate peer VPN addresses

Ralf Lici <ralf@mandelbit.com>
    ovpn: always unhash old VPN addresses before rehashing

Ralf Lici <ralf@mandelbit.com>
    ovpn: replace bind when clearing stale local source

Ralf Lici <ralf@mandelbit.com>
    ovpn: replace bind when learning local endpoint

Ralf Lici <ralf@mandelbit.com>
    ovpn: validate peer state before caching UDP dst

Ralf Lici <ralf@mandelbit.com>
    ovpn: track UDP socket route key for peer dst cache

Ralf Lici <ralf@mandelbit.com>
    ovpn: skip UDP source validation for unspecified addresses

Ralf Lici <ralf@mandelbit.com>
    ovpn: preserve IPv6 scope id for netlink peer endpoints

Li Youhong <liyouhong@kylinos.cn>
    drm/bridge: samsung-dsim: fix TE GPIO lifetime for host attach

Benjamin Leggett <benjamin@edera.io>
    drm/virtio: sync shmem backing on guest-bound transfers

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    Revert "drm/virtio: Allow importing prime buffers when 3D is enabled"

Junrui Luo <moonafterrain@outlook.com>
    drm/virtio: release the GEM object on virtio_gpu_vram_create() errors

Junrui Luo <moonafterrain@outlook.com>
    drm/virtio: fix object leaks in virtio_gpu_resource_create_blob_ioctl()

Junrui Luo <moonafterrain@outlook.com>
    drm/virtio: fix object leak in virtio_gpu_resource_create_ioctl()

Junrui Luo <moonafterrain@outlook.com>
    drm/virtio: fix object leak when drm_gem_handle_create() fails

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_hfsc: bound the classify inner-filter walk with a drift budget

Yuqi Xu <xuyuqiabc@gmail.com>
    bpf: Check params size before reading reserved fields

Aamir Ahmed <elb12345@hotmail.co.uk>
    net: usb: catc: bound the RX packet length in catc_rx_done()

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Bound ownership depth through local kptrs and graph roots

Yiqi Sun <sunyiqixm@gmail.com>
    sctp: avoid livelock while updating retransmit path

Alexander Duyck <alexanderduyck@fb.com>
    eth: fbnic: Handle FW mailbox completions flagged with an error

Mike Marciniszyn (Meta) <mike.marciniszyn@gmail.com>
    eth fbnic: Add debugfs hooks for firmware mailbox

Mohsin Bashir <mohsin.bashr@gmail.com>
    eth: fbnic: Reuse RX mailbox pages

Alexander Duyck <alexanderduyck@fb.com>
    eth: fbnic: Set AW_FLUSH_MODE alongside AW_FLUSH when flushing the mailbox

Alexander Duyck <alexanderduyck@fb.com>
    eth: fbnic: reset num_napi when the napi vectors are freed

Björn Töpel <bjorn@kernel.org>
    eth: fbnic: Handle maximum standalone channels

Kuniyuki Iwashima <kuniyu@google.com>
    ip6_gre: Call ip6erspan_tunnel_unlink_md() in ip6erspan_changelink().

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: ethernet: mtk_eth_soc: unregister net_devices in case of probe failure

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    net: gue: reject invalid REMCSUM offsets

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    net/sched: act_ct: don't WARN on benign flow_offload_alloc() failure

Giuseppe Ranieri <giuseppe@ranieri.dev>
    drm/nouveau/disp: don't reject HDMI config on cards without SCDC

Francesco Magazzu <postadelmaga@gmail.com>
    drm/nouveau/clk: don't clobber reclock status when restoring volt/fan

Dan Carpenter <error27@gmail.com>
    drm/nouveau/clk: fix list cursor use after loop in nvkm_clk_ustate_update

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: make ocfs2_calc_xattr_init() return void

Zeng Heng <zengheng4@huawei.com>
    arm64: io: Reject non-user protection in ioremap_prot()

Naman Gulati <namangulati@google.com>
    netfilter: ctnetlink: fix suspicious RCU usage in expect_iter_name

Julian Anastasov <ja@ssi.bg>
    ipvs: revalidate ihl before icmp_send

Karl Mehltretter <kmehltretter@gmail.com>
    netfilter: nft_synproxy: use the family-aware checksum helper

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_queue: hold nfnl mutex in event notifier

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    netfilter: flowtable: publish HW_DEAD after worker is done

Linkui Xiao <xiaolinkui@kylinos.cn>
    ipv4: fib: fix data-race and stale genid check around nh->nh_saddr

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    libbpf: Reject truncated ldimm64 CO-RE relocations

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Restrict CO-RE poisoning to relocatable instructions

Shay Drory <shayd@nvidia.com>
    net/mlx5: devcom, Base component size on linked devices

Heyang Tan <thy15333007817@163.com>
    octeontx2-af: use seq_file for rsrc_alloc debugfs

Kyle Hendry <khendry@reliablecontrols.com>
    net: pcs: rzn1-miic: Fix config array initialization

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_u32: fix manual hash table handle IDR aliasing

Björn Töpel <bjorn@kernel.org>
    eth: fbnic: Fix payload page pool error cleanup

Weiming Shi <bestswngs@gmail.com>
    bpf: Skip unsettled links in link iterator

Zhiling Zou <zhilinz@nebusec.ai>
    xsk: Use a 32-bit compare in xsk_map_gen_lookup

Julian Sun <sunjunchao@bytedance.com>
    fs: avoid repeated scans in evict_inodes()

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Guard PMCW field accesses with dnv check

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Check pmcw.dnv before pmcw.ena in I/O entry points

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Fix cio_update_schib() to not cache invalid schib

Karl Mehltretter <kmehltretter@gmail.com>
    s390/pci/docs: Fix sriov_numvfs attribute name

Niklas Schnelle <schnelle@linux.ibm.com>
    docs: s390/pci: Improve and update PCI documentation

Bart Van Assche <bvanassche@acm.org>
    scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume()

Eva Kurchatova <eva.kurchatova@virtuozzo.com>
    selftests: cgroup: give the O_TMPFILE open in get_temp_fd() a mode

Lee Jones <lee@kernel.org>
    Bluetooth: mgmt: Dequeue pending mesh_send_sync entries on cancel

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btnxpuart: Fix skb leak in nxp_process_fw_dump()

Christiano Amora <christiano.amora@gmail.com>
    Bluetooth: SMP: reject Security Request over BR/EDR

Andre Przywara <andre.przywara@arm.com>
    pinctrl: sunxi: A523: fix voltage withstand encoding

ZHOU Jiaxiang <me@fxti.xyz>
    scsi: sd_zbc: Reject disks with too many zones

Ran Hongyun <ranhongyun1@huawei.com>
    squashfs: Add dictionary size range check to prevent shift-out-of-bounds

Mark Brown <broonie@kernel.org>
    KVM: arm64: Fix FGT mapping for HFGITR_EL2.nGCSEPP

Karl Mehltretter <kmehltretter@gmail.com>
    KVM: arm64: Return -EINVAL for an empty SMCCC filter range at base 0

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: Derive GUEST_HAS_SVE from the SVE feature bit at EL2

Fuad Tabba <tabba@google.com>
    KVM: arm64: Include VM type when checking VM capabilities in pKVM

Fuad Tabba <tabba@google.com>
    KVM: arm64: Fix MTE flag initialization for protected VMs

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic-v3: Fix GICv3 trapping in protected mode

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: Do not clear VM-wide SVE feature on vCPU init failure

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: Validate the SVE vector length in pkvm_vcpu_init_sve()

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: vgic-its: Skip unreachable devices instead of failing the save

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: vgic-its: Free the caches when GITS_BASER changes

SeungJu Cheon <suunj1331@gmail.com>
    RISC-V: KVM: Fix perf-backed counter accounting across stop and read

SeungJu Cheon <suunj1331@gmail.com>
    RISC-V: KVM: Report snapshot write failure to the guest

SeungJu Cheon <suunj1331@gmail.com>
    RISC-V: KVM: Preserve firmware counter value across stop/start

Zongmin Zhou <zhouzongmin@kylinos.cn>
    KVM: riscv: Fix NACL hfence entry update order

Benjamin Tissoires <bentiss@kernel.org>
    HID: bpf: fix __hid_bpf_hw_check_params report length

Slawomir Stepien <sst@poczta.fm>
    HID: amd_sfh: Validate PCI BAR size before mapping

Sean Anderson <sanderson@brivo.com>
    pinctrl: meson: Fix typo in s4 group name

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    bpf, arm64: set up the frame pointer for the exception callback

Geliang Tang <geliang@kernel.org>
    bpf, sockmap: Fix self-redirect copied_seq double-counting

Pu Lehui <pulehui@huawei.com>
    bpf: Fix UAF due to concurrent consumption of ttrace lists in alloc_bulk

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Register dtor for freeing special fields

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix out-of-bounds read of rtt_min in sock_ops

Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
    bpf: Avoid soft lockup in __htab_map_lookup_and_delete_batch()

Jim Mattson <jmattson@google.com>
    KVM: x86/pmu: Move Intel PMU global MSRs to intel_is_valid_msr()

Oscar Priego Verdugo <oscar.priegov@gmail.com>
    HID: elecom: fix bus type for M-XGL20DLBK

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    HID: multitouch: Add report ID mismatch quirk for ASUS ROG Z13 Folio

Jiayuan Chen <jiayuan.chen@linux.dev>
    tcp: Skip cond_resched() in inet_csk_listen_stop() under BPF context

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix out-of-bounds read of sk_protocol in bpf_sock_destroy()

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix divide-by-zero in btf_struct_walk()

Sven Schnelle <svens@linux.ibm.com>
    selftests/ftrace: Fix unique symbol check in kprobe_non_uniq_symbol.tc

Weiming Shi <bestswngs@gmail.com>
    bpf: Disallow bpf_skb_pull_data() for LWT_SEG6LOCAL

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix bpf_skb_change_tail wrt csum partial skbs

Steffen Eiden <seiden@linux.ibm.com>
    s390/uv: Prevent potential out-of-bounds read

Steffen Eiden <seiden@linux.ibm.com>
    s390/uv: Fix loop condition in uv_find_secrets

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: Fix IRQ injection with SIGP Stop and Store Status

Mostafa Saleh <smostafa@google.com>
    remoteproc: qcom_q6v5_adsp: Fix iommu_unmap() usage

Sean Rhodes <sean@starlabs.systems>
    ALSA: hda/realtek: Add StarFighter HDA SSID

Sean Rhodes <sean@starlabs.systems>
    ALSA: hda/realtek: Limit Star Labs internal mic boost

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Atomize IRQ register read/modify/write ops

Wenwu Hou <hwenwur@gmail.com>
    erofs: fix large folio race in erofs_fscache_req_complete

Darrick J. Wong <djwong@kernel.org>
    xfs: don't stash removename operations with unknown ftype


-------------

Diffstat:

 Documentation/arch/arm64/booting.rst               |   1 +
 Documentation/arch/s390/pci.rst                    | 144 +++++---
 Makefile                                           |   4 +-
 arch/arm64/include/asm/el2_setup.h                 |   9 +-
 arch/arm64/include/asm/io.h                        |   3 +-
 arch/arm64/include/asm/kvm_pkvm.h                  |  10 +-
 arch/arm64/kernel/cpu_errata.c                     |  15 +-
 arch/arm64/kvm/arm.c                               |   4 +-
 arch/arm64/kvm/emulate-nested.c                    |   2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  38 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |  10 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   5 +
 arch/arm64/kvm/hypercalls.c                        |   3 +-
 arch/arm64/kvm/mmu.c                               |  15 +-
 arch/arm64/kvm/nested.c                            |  15 +-
 arch/arm64/kvm/sys_regs.c                          |   1 +
 arch/arm64/kvm/vgic/vgic-its.c                     |  43 ++-
 arch/arm64/net/bpf_jit_comp.c                      |   2 +
 arch/mips/net/bpf_jit_comp32.c                     |   2 +-
 arch/mips/net/bpf_jit_comp64.c                     |   3 +-
 arch/parisc/include/asm/thread_info.h              |   2 +-
 arch/riscv/kvm/aia_imsic.c                         |  11 +-
 arch/riscv/kvm/mmu.c                               |   2 +
 arch/riscv/kvm/nacl.c                              |  20 +-
 arch/riscv/kvm/vcpu_exit.c                         |   2 +-
 arch/riscv/kvm/vcpu_pmu.c                          |  33 +-
 arch/riscv/kvm/vcpu_sbi_hsm.c                      |   4 +-
 arch/riscv/kvm/vcpu_timer.c                        |   5 +-
 arch/s390/crypto/hmac_s390.c                       |   5 +-
 arch/s390/include/asm/debug.h                      |   8 +-
 arch/s390/kernel/debug.c                           |  15 +-
 arch/s390/kernel/uv.c                              |   8 +-
 arch/s390/kvm/interrupt.c                          |  72 ++--
 arch/s390/pci/pci_event.c                          |   7 +-
 arch/s390/pci/pci_report.c                         |  32 +-
 arch/s390/pci/pci_report.h                         |   4 +-
 arch/x86/boot/startup/sev-startup.c                |   3 +-
 arch/x86/coco/sev/Makefile                         |   2 +-
 arch/x86/coco/sev/core.c                           | 388 +--------------------
 .../asm/sev-internal.h => coco/sev/internal.h}     |  32 ++
 arch/x86/coco/sev/noinstr.c                        |   7 +-
 arch/x86/coco/sev/svsm.c                           | 362 +++++++++++++++++++
 arch/x86/coco/sev/vc-handle.c                      |   3 +-
 arch/x86/events/intel/core.c                       |  79 +++--
 arch/x86/events/intel/ds.c                         |  36 +-
 arch/x86/kernel/cpu/mce/core.c                     |  27 +-
 arch/x86/kvm/pmu.c                                 |   8 -
 arch/x86/kvm/svm/sev.c                             |  18 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   3 +
 arch/x86/pci/fixup.c                               |  99 ++++++
 drivers/ata/libata-scsi.c                          |  10 +-
 drivers/bluetooth/btintel_pcie.c                   |  16 +
 drivers/bluetooth/btnxpuart.c                      |   8 +-
 drivers/dpll/dpll_netlink.c                        |   3 +-
 drivers/gpio/gpio-arizona.c                        |   8 +-
 drivers/gpio/gpio-tps65219.c                       |  12 +-
 drivers/gpio/gpio-zynq.c                           |  10 +-
 drivers/gpio/gpiolib-cdev.c                        |  32 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   8 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |  12 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   3 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |   3 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c  |  62 ++--
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.h  |  28 ++
 drivers/gpu/drm/amd/display/dc/dml/Makefile        |   6 +-
 drivers/gpu/drm/bridge/samsung-dsim.c              |   2 +-
 drivers/gpu/drm/clients/drm_fbdev_client.c         |  28 +-
 drivers/gpu/drm/clients/drm_log.c                  |   4 +-
 drivers/gpu/drm/drm_client_event.c                 |  20 +-
 drivers/gpu/drm/drm_fb_helper.c                    |  24 +-
 drivers/gpu/drm/drm_file.c                         |   2 +-
 drivers/gpu/drm/drm_modeset_helper.c               |   6 +-
 drivers/gpu/drm/i915/display/intel_cursor.c        |   7 +-
 drivers/gpu/drm/i915/display/intel_display_types.h |   2 +
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |  24 +-
 drivers/gpu/drm/i915/display/intel_dp_mst.h        |   2 +
 drivers/gpu/drm/i915/display/intel_link_bw.c       |   3 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |  26 ++
 drivers/gpu/drm/i915/display/intel_quirks.c        |  37 +-
 drivers/gpu/drm/i915/display/intel_quirks.h        |   2 +
 drivers/gpu/drm/i915/display/skl_universal_plane.c |   9 +-
 drivers/gpu/drm/i915/gem/i915_gem_object.c         |   2 +-
 drivers/gpu/drm/i915/i915_driver.c                 |   6 +-
 drivers/gpu/drm/imagination/pvr_free_list.c        |  15 +-
 drivers/gpu/drm/imagination/pvr_mmu.c              |  19 +-
 drivers/gpu/drm/imagination/pvr_mmu.h              |   2 +-
 drivers/gpu/drm/imagination/pvr_vm.c               |   4 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   3 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   5 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |   4 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   5 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   2 +
 drivers/gpu/drm/nouveau/nouveau_sched.c            |   2 +-
 drivers/gpu/drm/nouveau/nouveau_sched.h            |   1 +
 drivers/gpu/drm/nouveau/nouveau_uvmm.c             |  13 +-
 drivers/gpu/drm/nouveau/nvif/vmm.c                 |   1 +
 drivers/gpu/drm/nouveau/nvkm/engine/disp/uoutp.c   |   3 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c     |  23 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramnv1a.c   |   2 +
 drivers/gpu/drm/radeon/radeon_device.c             |   4 +-
 drivers/gpu/drm/virtio/virtgpu_drv.h               |   5 +
 drivers/gpu/drm/virtio/virtgpu_gem.c               |   2 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |  49 ++-
 drivers/gpu/drm/virtio/virtgpu_prime.c             |   2 +-
 drivers/gpu/drm/virtio/virtgpu_submit.c            |  11 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |  46 +++
 drivers/gpu/drm/virtio/virtgpu_vram.c              |  17 +-
 drivers/gpu/drm/xe/display/xe_display.c            |   6 +-
 drivers/gpu/drm/xe/xe_bo.c                         |   7 +
 drivers/gpu/drm/xe/xe_bo.h                         |  19 +
 drivers/gpu/drm/xe/xe_hw_engine.c                  |  27 +-
 drivers/gpu/drm/xe/xe_vm.c                         |  21 +-
 drivers/hid/amd-sfh-hid/amd_sfh_common.h           |   4 +
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c             |  10 +
 drivers/hid/bpf/hid_bpf_dispatch.c                 |  12 +-
 drivers/hid/hid-alps.c                             |  31 +-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-multitouch.c                       |  29 +-
 drivers/hid/hid-quirks.c                           |   3 +-
 drivers/hid/wacom_sys.c                            |   5 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |  38 +-
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/dsa/mt7530-mdio.c                      |  18 +-
 drivers/net/dsa/mt7530.c                           |   3 -
 drivers/net/ethernet/airoha/airoha_npu.c           |  18 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   2 +
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   3 +
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   3 +
 drivers/net/ethernet/atheros/atlx/atl1.c           |   3 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  34 +-
 drivers/net/ethernet/broadcom/tg3.c                |  15 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |  24 +-
 drivers/net/ethernet/cadence/macb_main.c           |  14 +-
 drivers/net/ethernet/freescale/fman/fman.c         |   1 +
 drivers/net/ethernet/google/gve/gve.h              |  12 +-
 drivers/net/ethernet/google/gve/gve_adminq.c       |  12 +-
 drivers/net/ethernet/google/gve/gve_desc_dqo.h     |   5 +
 drivers/net/ethernet/google/gve/gve_ethtool.c      | 105 +++---
 drivers/net/ethernet/google/gve/gve_main.c         |  93 +++--
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |  71 +++-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |   3 +
 drivers/net/ethernet/marvell/octeontx2/af/common.h |  45 ++-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 104 ++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   6 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |  45 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   3 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   1 -
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  15 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.c   |   5 +-
 drivers/net/ethernet/meta/fbnic/fbnic_csr.h        |   5 +
 drivers/net/ethernet/meta/fbnic/fbnic_debugfs.c    |  48 +++
 drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c    |  13 +-
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c         |  74 +++-
 drivers/net/ethernet/meta/fbnic/fbnic_fw.h         |   2 +
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c        |  18 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c       |   4 +-
 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c  |   3 +-
 drivers/net/ethernet/spacemit/k1_emac.c            |   3 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   5 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |   4 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   1 +
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 109 ++++--
 drivers/net/ethernet/ti/netcp_core.c               |   2 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_fdir.c    |  13 +-
 drivers/net/macsec.c                               |  84 ++---
 drivers/net/ovpn/netlink.c                         | 108 +++++-
 drivers/net/ovpn/peer.c                            | 121 +++++--
 drivers/net/ovpn/peer.h                            |  25 +-
 drivers/net/ovpn/udp.c                             | 193 ++++++++--
 drivers/net/pcs/pcs-rzn1-miic.c                    |   3 +-
 drivers/net/pcs/pcs-xpcs.c                         |   4 +-
 drivers/net/phy/micrel.c                           |   1 +
 drivers/net/phy/phylink.c                          |  20 +-
 drivers/net/usb/catc.c                             |  15 +-
 drivers/net/usb/cdc_mbim.c                         |   5 +
 drivers/net/usb/lan78xx.c                          |   2 +
 drivers/net/usb/sr9700.c                           |   3 +-
 drivers/net/veth.c                                 |   2 +
 drivers/net/virtio_net.c                           |   9 +
 drivers/net/vrf.c                                  |   2 -
 drivers/net/vxlan/vxlan_core.c                     |   6 +-
 drivers/nfc/microread/microread.c                  |   6 +-
 drivers/nfc/nfcmrvl/fw_dnld.c                      |  11 +-
 drivers/nfc/pn533/pn533.c                          |  14 +-
 drivers/nfc/pn533/pn533.h                          |   4 +-
 drivers/nfc/pn533/usb.c                            |   4 +-
 drivers/nfc/pn544/pn544.c                          |   7 +-
 drivers/nfc/port100.c                              |   7 +
 drivers/nfc/st21nfca/core.c                        |  12 +-
 drivers/nfc/st21nfca/i2c.c                         |  29 +-
 drivers/nfc/trf7970a.c                             |   4 +-
 drivers/nfc/virtual_ncidev.c                       |   3 +-
 drivers/pci/of_property.c                          |  11 +-
 drivers/pci/setup-bus.c                            |  23 +-
 drivers/pinctrl/meson/pinctrl-meson-s4.c           |   2 +-
 drivers/pinctrl/pinctrl-single.c                   |   3 +-
 drivers/pinctrl/sunxi/pinctrl-sun55i-a523-r.c      |   2 +-
 drivers/pinctrl/sunxi/pinctrl-sun55i-a523.c        |   2 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |  82 ++++-
 drivers/pinctrl/sunxi/pinctrl-sunxi.h              |   9 +
 drivers/remoteproc/qcom_q6v5_adsp.c                |   8 +-
 drivers/s390/cio/chp.c                             |   3 +
 drivers/s390/cio/cio.c                             |  11 +-
 drivers/s390/cio/cio.h                             |   5 +-
 drivers/s390/cio/cmf.c                             |   2 +-
 drivers/s390/cio/device.c                          |   9 +-
 drivers/s390/cio/device_fsm.c                      |   3 +
 drivers/s390/cio/device_ops.c                      |  23 ++
 drivers/s390/cio/vfio_ccw_fsm.c                    |   2 +-
 drivers/s390/crypto/vfio_ap_ops.c                  |  18 +-
 drivers/scsi/libiscsi_tcp.c                        |   3 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |   4 +-
 drivers/scsi/sd_zbc.c                              |   8 +-
 drivers/thermal/gov_step_wise.c                    |  10 +-
 fs/autofs/inode.c                                  |   4 +
 fs/bpf_fs_kfuncs.c                                 |   4 -
 fs/erofs/fscache.c                                 |   2 +
 fs/fs-writeback.c                                  |  25 +-
 fs/hfsplus/super.c                                 |   1 -
 fs/inode.c                                         |  11 +-
 fs/kernfs/mount.c                                  |   4 +-
 fs/ntfs3/inode.c                                   |   7 +-
 fs/ocfs2/namei.c                                   |   9 +-
 fs/ocfs2/xattr.c                                   |  13 +-
 fs/ocfs2/xattr.h                                   |   8 +-
 fs/smb/client/cached_dir.c                         |  32 +-
 fs/smb/client/smb2inode.c                          |   4 +-
 fs/smb/client/smb2ops.c                            |  28 +-
 fs/smb/client/smb2pdu.c                            |  51 ++-
 fs/squashfs/xz_wrapper.c                           |   6 +-
 fs/super.c                                         |  43 +--
 fs/xfs/libxfs/xfs_metafile.c                       |   8 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c               |   4 +-
 fs/xfs/scrub/dir_repair.c                          |  19 +-
 fs/xfs/scrub/health.c                              |   6 +-
 fs/xfs/scrub/inode.c                               |   2 +-
 fs/xfs/scrub/inode_repair.c                        |   2 +-
 fs/xfs/scrub/orphanage.c                           |   6 +-
 fs/xfs/scrub/repair.c                              |  21 +-
 fs/xfs/scrub/scrub.h                               |   2 +-
 fs/xfs/scrub/trace.h                               |  12 +-
 fs/xfs/xfs_dquot.c                                 |   8 +-
 fs/xfs/xfs_exchrange.c                             |  13 +-
 fs/xfs/xfs_icache.c                                |   2 +-
 fs/xfs/xfs_log_recover.c                           |  13 +-
 fs/xfs/xfs_qm.c                                    |  10 +-
 fs/xfs/xfs_refcount_item.c                         |   8 +-
 fs/xfs/xfs_rmap_item.c                             |   8 +-
 include/drm/drm_client.h                           |  22 +-
 include/drm/drm_client_event.h                     |  12 +-
 include/drm/drm_fb_helper.h                        |   8 +-
 include/linux/bpf_mem_alloc.h                      |   6 +
 include/linux/if_vlan.h                            |   3 +
 include/linux/rculist.h                            |  29 ++
 include/linux/skbuff.h                             |  24 +-
 include/net/gue.h                                  |  19 +-
 include/net/ip6_route.h                            |   4 +-
 include/net/netfilter/nf_conntrack.h               |   5 +
 include/net/nfc/hci.h                              |   2 +-
 include/net/nfc/nfc.h                              |   3 +-
 include/net/rose.h                                 |  28 +-
 include/net/tcp.h                                  |   4 +-
 kernel/bpf/btf.c                                   | 140 +++++---
 kernel/bpf/crypto.c                                |   5 +-
 kernel/bpf/hashtab.c                               | 114 +++++-
 kernel/bpf/memalloc.c                              | 106 ++++--
 kernel/bpf/offload.c                               |   2 +
 kernel/bpf/syscall.c                               |   5 +-
 kernel/cgroup/cpuset.c                             |  53 +--
 kernel/cgroup/pids.c                               |   5 +
 kernel/events/core.c                               |  17 +-
 kernel/sched/core.c                                |   2 +-
 kernel/sched/ext.c                                 |   7 +-
 kernel/workqueue.c                                 |   2 +-
 mm/backing-dev.c                                   |   5 +-
 mm/damon/core.c                                    |  24 +-
 mm/damon/vaddr.c                                   |  21 +-
 mm/hugetlb.c                                       |  41 ++-
 mm/rmap.c                                          |  23 +-
 mm/vma.c                                           |   8 +
 net/8021q/vlan_dev.c                               |   5 +
 net/bluetooth/bnep/core.c                          |  17 +-
 net/bluetooth/bnep/netdev.c                        |   8 +-
 net/bluetooth/hci_conn.c                           |  14 +-
 net/bluetooth/hci_sock.c                           |  20 +-
 net/bluetooth/iso.c                                |   7 +
 net/bluetooth/l2cap_core.c                         |  10 +-
 net/bluetooth/mgmt.c                               |  27 +-
 net/bluetooth/rfcomm/core.c                        |   3 +-
 net/bluetooth/rfcomm/sock.c                        |   6 +-
 net/bluetooth/smp.c                                |  17 +
 net/bridge/br_mdb.c                                |   2 +
 net/bridge/br_stp_bpdu.c                           |   5 +-
 net/core/dev.c                                     |   2 +-
 net/core/filter.c                                  |  46 ++-
 net/core/skbuff.c                                  |   9 +-
 net/core/skmsg.c                                   |   4 +
 net/core/sock_map.c                                |   1 +
 net/ipv4/arp.c                                     |   1 +
 net/ipv4/fib_semantics.c                           |  13 +-
 net/ipv4/fou_core.c                                |   4 +
 net/ipv4/inet_connection_sock.c                    |   3 +-
 net/ipv4/ip_gre.c                                  |  12 +
 net/ipv4/ipconfig.c                                |  90 ++---
 net/ipv4/tcp_output.c                              |   3 +
 net/ipv4/udp.c                                     |  44 ++-
 net/ipv6/exthdrs_core.c                            |   3 +
 net/ipv6/ip6_fib.c                                 |   2 +-
 net/ipv6/ip6_gre.c                                 |   2 +-
 net/ipv6/netfilter/ip6t_rpfilter.c                 |   2 +-
 net/ipv6/netfilter/ip6t_rt.c                       |  11 +-
 net/ipv6/route.c                                   |  12 +-
 net/ipv6/seg6.c                                    |   4 +-
 net/llc/llc_c_ac.c                                 |   2 +-
 net/llc/llc_s_ac.c                                 |   4 +
 net/llc/llc_sap.c                                  |   8 +-
 net/mctp/route.c                                   |   2 +-
 net/mptcp/protocol.c                               |   2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   6 +
 net/netfilter/nf_conntrack_netlink.c               |   3 +-
 net/netfilter/nf_flow_table_offload.c              |   7 +-
 net/netfilter/nf_tables_api.c                      |  18 +-
 net/netfilter/nfnetlink_queue.c                    |   8 +-
 net/netfilter/nft_synproxy.c                       |   3 +-
 net/netlink/genetlink.c                            |   8 +-
 net/nfc/core.c                                     |  15 +-
 net/nfc/digital_dep.c                              |   8 +-
 net/nfc/llcp.h                                     |   1 +
 net/nfc/llcp_commands.c                            |   2 +-
 net/nfc/llcp_core.c                                | 173 ++++++---
 net/nfc/llcp_sock.c                                |  67 +++-
 net/nfc/nci/core.c                                 |  10 +-
 net/nfc/netlink.c                                  |   7 +-
 net/nfc/nfc.h                                      |   3 +-
 net/openvswitch/conntrack.c                        |  37 +-
 net/packet/af_packet.c                             | 104 +++---
 net/rds/ib_frmr.c                                  |  11 +-
 net/rose/rose_in.c                                 |  13 +-
 net/rose/rose_link.c                               |   5 +
 net/rose/rose_route.c                              |  81 ++++-
 net/sched/act_api.c                                |   2 +-
 net/sched/act_ct.c                                 |  41 ++-
 net/sched/act_gate.c                               |  30 +-
 net/sched/cls_u32.c                                |  12 +-
 net/sched/em_text.c                                |   2 +-
 net/sched/sch_hfsc.c                               |  22 ++
 net/sched/sch_teql.c                               |   7 +-
 net/sctp/associola.c                               |  15 +-
 net/sctp/input.c                                   |   7 +-
 net/sctp/sm_sideeffect.c                           |  37 +-
 net/sctp/sm_statefuns.c                            |   2 +
 net/smc/smc_core.c                                 |   2 +
 net/smc/smc_ib.c                                   |  10 +-
 net/tipc/group.c                                   |   4 +-
 net/tipc/monitor.c                                 |   3 +-
 net/tls/tls_sw.c                                   |   6 +-
 net/xdp/xskmap.c                                   |   2 +-
 rust/kernel/net/phy.rs                             |  38 +-
 security/ipe/eval.c                                |  12 +-
 security/ipe/eval.h                                |   2 +-
 security/ipe/fs.c                                  |   8 +-
 security/ipe/hooks.c                               |  22 +-
 security/ipe/policy_fs.c                           |   3 +
 sound/hda/codecs/realtek/alc269.c                  |   9 +
 tools/lib/bpf/libbpf.c                             |   7 +
 tools/lib/bpf/relo_core.c                          |  58 +--
 .../testing/selftests/bpf/prog_tests/linked_list.c |   4 +-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh  |   2 +
 tools/testing/selftests/cgroup/test_memcontrol.c   |   2 +-
 .../ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc |   2 +-
 tools/testing/selftests/nci/nci_dev.c              |  45 ++-
 virt/kvm/kvm_main.c                                |  30 +-
 382 files changed, 4875 insertions(+), 2189 deletions(-)


