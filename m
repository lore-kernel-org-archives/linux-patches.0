Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AF04C10DF;
	Thu, 17 Sep 2026 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658432; cv=none; b=fDE85EfrS1QuQZz7ZTI7DNFdWAM5F8+dcEMQO0EUrWjYLmugZgu0pepeZK8vSTbTb/Qic6ukb8ZP27d1j3+0uDvtOziKFnGonB8sOBjaMz7Abe9uzpJQgsX7DieKDGIFOdUXl4jzZbIKg0HkwRZJBRCYen3+RZWHDaDGl9eoGNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658432; c=relaxed/simple;
	bh=n3G5SBRqu+nmjB3zOBiy/x+IGOJvTsjXqvoH5TxEq0E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ABCHjWBs/I4U1WCW9JJrmMAsWhnVuCSTRRc4QYprIucHPl4m4ypn5KULLC0kfRqMkJoUCIIi3UVf9WLgrzMtGTORmce4Z31fTQXFuApvuaPvgK1H9zAPTcqotb0BX54HviOMPru4lZU/qSXPDRxqWfhT9+Hdyur04ij1cGq2j8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWelLYDZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWelLYDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B295F1F00898;
	Thu, 17 Sep 2026 15:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658402;
	bh=ieCWIF6EDLHJUvEKsG5x6ydRwHS0YQDU7MY/WcoEPFw=;
	h=From:To:Cc:Subject:Date;
	b=wWelLYDZRSF000ikSCoW42mjeqpdLbDOnni3x6oAeiSq29wms4EBbXyM9n4tQ2Hha
	 AeYwEYtYlBoXMhaxaOJaOS2GCeBc8e7uT4PZvhvt3rJSR5QR3g/tnGiEGPfaQzvJ1F
	 ZmF9iIPxVIZK6bXeEkoChIFlLSiGOLQhdWJ36Y4k=
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
Subject: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
Date: Thu, 17 Sep 2026 15:59:03 +0100
Message-ID: <20260917151539.408551884@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.111-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.111-rc1
X-KernelTest-Deadline: 2026-09-19T15:16+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.111 release.
There are 1102 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 19 Sep 2026 15:13:49 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.111-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.111-rc1

Vincent Guittot <vincent.guittot@linaro.org>
    sched/eevdf: Fix augmented max_slice

Ameer Hamza <ameer.hamza@truenas.com>
    SUNRPC: Restore NUMA_NO_NODE for svc thread allocations in global mode

Mallesh Koujalagi <mallesh.koujalagi@intel.com>
    workqueue: Update documentation as per system_percpu_wq naming

Kevin Hao <haokexin@gmail.com>
    net: cpsw: Execute ndo_set_rx_mode callback in a work queue

Oscar Salvador <osalvador@suse.de>
    mm, hugetlb: increment the number of pages to be reset on HVO

Doruk Tan Ozturk <doruk@0sec.ai>
    ocfs2: validate directory-index entry counts when reading metadata

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: validate dx_root extent list fields during block read

Tejun Heo <tj@kernel.org>
    sched_ext: Fix inverted ops.core_sched_before() invocation

Chris Mason <clm@meta.com>
    svcrdma: Reject Write/Reply chunks with segcount 0

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Adjust the number of entries in svc_rdma_recv_ctxt::rc_pages

Chuck Lever <chuck.lever@oracle.com>
    sunrpc: Add a helper to derive maxpages from sv_max_mesg

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Reorder rpcrdma_rn_unregister before rdma_destroy_id

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Release transport resources synchronously

Chuck Lever <chuck.lever@oracle.com>
    rpcrdma: arm rn_done before publishing the notification

Luxiao Xu <rakukuip@gmail.com>
    sunrpc: fix use-after-free in __rpc_clnt_handle_event and __rpc_clnt_remove_pipedir

Al Viro <viro@zeniv.linux.org.uk>
    rpc_pipe: don't overdo directory locking

Al Viro <viro@zeniv.linux.org.uk>
    rpc_mkpipe_dentry(): saner calling conventions

Al Viro <viro@zeniv.linux.org.uk>
    rpc_populate(): lift cleanup into callers

Chris Mason <clm@meta.com>
    SUNRPC: fix gssx_dec_option_array error path bugs

Jeff Layton <jlayton@kernel.org>
    sunrpc: defer rq_argp and rq_resp free until after RCU grace period

Anna Schumaker <anna.schumaker@oracle.com>
    SUNRPC: Update svcxdr_init_decode() to call xdr_set_scratch_folio()

Anna Schumaker <anna.schumaker@oracle.com>
    SUNRPC: Introduce xdr_set_scratch_folio()

Zhiling Zou <zhilinz@nebusec.ai>
    ip: orphan prefetched skbs before multicast forwarding

Eric Dumazet <edumazet@google.com>
    ipv6: ip6_mc_input() and ip6_mr_input() cleanups

Eric Dumazet <edumazet@google.com>
    ipv6: adopt skb_dst_dev() and skb_dst_dev_net[_rcu]() helpers

Andrea Mayer <andrea.mayer@uniroma2.it>
    ipv6: rpl: fix NULL dereference of idev in ipv6_rpl_srh_rcv()

Yue Haibing <yuehaibing@huawei.com>
    ipv6: annotate data-races around devconf->rpl_seg_enabled

Terry Bowman <terry.bowman@amd.com>
    cxl/ras: Fix cxl_rch_get_aer_severity() wrong severity register

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: TAD: Add locking around AML evaluations

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: TAD: Split three functions to untangle runtime PM handling

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: TAD: Rearrange RT data validation checking

Jiri Olsa <jolsa@kernel.org>
    bpf: Disable preemption in bpf_get_stackid

Jiri Olsa <jolsa@kernel.org>
    bpf: Use stack id functions instead of __bpf_get_stackid

Jiri Olsa <jolsa@kernel.org>
    bpf: Factor stackid_new_bucket from __bpf_get_stackid

Jiri Olsa <jolsa@kernel.org>
    bpf: Factor stackid_fastpath function from __bpf_get_stackid

Jiri Olsa <jolsa@kernel.org>
    bpf: Factor stackid_init function from __bpf_get_stackid

Haoxiang Li <haoxiang_li2024@163.com>
    cpufreq: apple-soc: Fix OPP table cleanup

Terry Bowman <terry.bowman@amd.com>
    acpi/apei/ghes: Use raw_spinlock_t for CXL CPER work locks

Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
    efi/cper, cxl: Make definitions and structures global

Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
    efi/cper, cxl: Prefix protocol error struct and function names with cxl_

Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
    erofs: skip sufficiently large global buffers when resizing

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent client use-after-free during close_lru reaping

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent client use-after-free during blocked-lock reaping

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Consolidate the revocation-path client unpin

Jiangshan Yi <yijiangshan@kylinos.cn>
    HID: mcp2221: clear rxbuf after I2C/SMBus transfer completes

Florian Pradines <florian.pradines@gmail.com>
    HID: mcp2221: fix OOB write in mcp2221_raw_event()

Doruk Tan Ozturk <doruk@0sec.ai>
    HID: sony: clean up device list on probe failure

Rosalie Wanders <rosalie@mailbox.org>
    HID: sony: use guard() and scoped_guard()

Baul Lee <baul.lee@xbow.com>
    HID: universal-pidff: stop the device when force-feedback init fails

Doruk Tan Ozturk <doruk@0sec.ai>
    HID: sony: fix UAF of ghl_poke_timer / ghl_urb at driver unbind

Qu Wenruo <wqu@suse.com>
    btrfs: do not overwrite NODATASUM flag when removing NODATACOW flag

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    btrfs: fix extent map leak in NOCOW direct I/O write

Filipe Manana <fdmanana@suse.com>
    btrfs: rename extent map functions to get block start, end and check if in tree

Filipe Manana <fdmanana@suse.com>
    btrfs: add btrfs prefix to main lock, try lock and unlock extent functions

David Sterba <dsterba@suse.com>
    btrfs: use BTRFS_PATH_AUTO_FREE in can_nocow_extent()

Qu Wenruo <wqu@suse.com>
    btrfs: prepare btrfs_punch_hole_lock_range() for large data folios

David Sterba <dsterba@suse.com>
    btrfs: pass struct btrfs_inode to btrfs_sync_inode_flags_to_i_flags()

David Sterba <dsterba@suse.com>
    btrfs: parameter constification in ioctl.c

David Sterba <dsterba@suse.com>
    btrfs: update include and forward declarations in headers

Qu Wenruo <wqu@suse.com>
    btrfs: expose per-inode stable writes flag

Filipe Manana <fdmanana@suse.com>
    btrfs: move btrfs_alloc_write_mask() into fs.h

Filipe Manana <fdmanana@suse.com>
    btrfs: move BTRFS_BYTES_TO_BLKS() into fs.h

Filipe Manana <fdmanana@suse.com>
    btrfs: move btrfs_is_empty_uuid() from ioctl.c into fs.c

Andre Eikmeyer <dev@deq.rocks>
    HID: apple: preserve keyboard backlight across T2 resume

Sam Edwards <cfsworks@gmail.com>
    ceph: properly decrypt filenames in vmalloc() buffers

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Guard admin state-revocation walks with NFSD_NET_UP

Max Kellermann <max.kellermann@ionos.com>
    ceph: force a cap message when a deferred revoke can't be acked immediately

Dr. David Alan Gilbert <linux@treblig.org>
    ceph: Remove fs/ceph deadcode

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent client use-after-free during delegation revoke

Mike Snitzer <snitzer@kernel.org>
    nfsd: disallow file locking and delegations for NFSv4 reexport

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent client use-after-free during admin state revocation

Jeff Layton <jlayton@kernel.org>
    nfsd: close shrinker/GC/fsnotify vs per-net shutdown race in filecache

Jeff Layton <jlayton@kernel.org>
    nfsd: fix stale s2s_cp_stateids IDR entry for async COPY

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: update mtime/ctime on COPY in presence of delegated attributes

Jeff Layton <jlayton@kernel.org>
    nfsd: fix netlink dumpit error handling for rpc_status_get

Jeff Layton <jlayton@kernel.org>
    nfsd: fix clock domain mismatch in clients_still_reclaiming()

Jeff Layton <jlayton@kernel.org>
    nfsd: RCU-protect cl_cb_session to fix use-after-free on session teardown

Jeff Layton <jlayton@kernel.org>
    nfsd: dedup nfs4_client_to_reclaim inserts

Jeff Layton <jlayton@kernel.org>
    nfsd: widen nfsd_genl_rqstp address fields to sockaddr_storage

Chuck Lever <chuck.lever@oracle.com>
    Revert "NFSD: Remove the cap on number of operations per NFSv4 COMPOUND"

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Make nfsd_genl_rqstp::rq_ops array best-effort

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Rename a function parameter

Jeff Layton <jlayton@kernel.org>
    nfsd: check nfsd4_acl_to_attr() return value in nfsd4_create()

Jeff Layton <jlayton@kernel.org>
    nfsd: validate sockaddr length per family in listener_set

Carolina Jubran <cjubran@nvidia.com>
    netlink: introduce type-checking attribute iteration for nlmsg

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: set default primary compressor in zram_destroy_comps()

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: switch to guard() for init_lock

Longlong Xia <xialonglong@kylinos.cn>
    zram: fix out-of-bounds access in writeback_store()

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: use zram_read_from_zspool() in writeback

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: remove entry element member

Longlong Xia <xialonglong@kylinos.cn>
    zram: fix out-of-bounds access in read_block_state()

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: fixup read_block_state()

Neill Kapron <nkapron@google.com>
    usb: gadget: f_fs: Fix Use-After-Free in AIO error path

Gabriel Prostitis <prostitisgabriel@gmail.com>
    USB: gadget: ffs: fix mm lifetime handling

Terry Bowman <terry.bowman@amd.com>
    cxl/ras: Fix cxl_rch_get_aer_info() out-of-bounds AER register read

Dave Jiang <dave.jiang@intel.com>
    cxl/pci: Remove CXL VH handling in CONFIG_PCIEAER_CXL conditional blocks from core/pci.c

Terry Bowman <terry.bowman@amd.com>
    cxl/pci: Remove unnecessary CXL RCH handling helper functions

Terry Bowman <terry.bowman@amd.com>
    cxl/pci: Remove unnecessary CXL Endpoint handling helper functions

Roger Pau Monne <roger@xenproject.org>
    x86/xen: fix init of balloon stats again

Roger Pau Monne <roger.pau@citrix.com>
    xen/balloon: improve accuracy of initial balloon target for dom0

Yao Zi <me@ziyao.cc>
    x86/locking: Use sfence for wmb() if SSE is available

Uros Bizjak <ubizjak@gmail.com>
    x86/locking: Remove semicolon from "lock" prefix

Li Xiasong <lixiasong1@huawei.com>
    mm/slub: fix missing debugfs entries for caches created before sysfs init

Vlastimil Babka <vbabka@suse.cz>
    mm/slab: move and refactor __kmem_cache_alias()

Arvind Yadav <arvind.yadav@intel.com>
    mm/migrate_device: clear stale mapping after freeing swapcache

Kairui Song <kasong@tencent.com>
    mm/mglru: fix and remove redundant unevictable folio handling

Kairui Song <kasong@tencent.com>
    mm/mglru: use the common routine for dirty/writeback reactivation

Yu Zhao <yuzhao@google.com>
    mm/mglru: optimize deactivation

Wei Xu <weixugc@google.com>
    mm/mglru: reset page lru tier bits when activating

Muchun Song <muchun.song@linux.dev>
    mm/hugetlb: initialize gigantic bootmem hugepage struct pages earlier

Chen Linxuan <me@black-desk.cn>
    pidfd: hold exec_update_lock around namespace ioctl

Christian Brauner <brauner@kernel.org>
    nscommon: simplify initialization

David Hildenbrand (Arm) <david@kernel.org>
    mm/gup: fix always draining LRU caches in collect_longterm_unpinnable_folios()

David Hildenbrand <david@redhat.com>
    mm: move _pincount in folio to page[2] on 32bit

David Hildenbrand <david@redhat.com>
    mm: move hugetlb specific things in folio to page[3]

Chengfeng Ye <nicoyip.dev@gmail.com>
    KEYS: trusted: Fix TPM teardown ordering

Breno Leitao <leitao@debian.org>
    mm, swap: ratelimit bad swap entry reports

gao xu <gaoxu2@honor.com>
    mm: fix possible NULL pointer dereference in __swap_duplicate

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    crypto: iaa - unmap dst before software fallback on decompress

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - avoid stale fallback key after set_secret failure

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Track the GPA of the guest-controlled VMSA used for SNP guests

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Move SEV-ES VMSA allocation to a dedicated sev_vcpu_create() helper

Ashish Kalra <ashish.kalra@amd.com>
    KVM: SEV: Disable SEV-SNP support on initialization failure

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Invalidate "next" SNP VMSA GPA even on failure

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Use guard(mutex) to simplify SNP vCPU state updates

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Mark VMCB dirty before processing incoming snp_vmsa_gpa

Jiayuan Chen <jiayuan.chen@linux.dev>
    net: advertise TCP MSS from the configured MTU, not the learned PMTU

Bryam Vargas <hexlabsecurity@proton.me>
    crypto: virtio - bound the akcipher result length

Lukas Wunner <lukas@wunner.de>
    crypto: virtio - Drop superfluous [as]kcipher_req pointer

Lukas Wunner <lukas@wunner.de>
    crypto: virtio - Drop superfluous [as]kcipher_ctx pointer

Lukas Wunner <lukas@wunner.de>
    crypto: virtio - Drop sign/verify operations

Eric Dumazet <edumazet@google.com>
    vlan: fix skb_under_panic and races when toggling HW VLAN offload

Kyle Zeng <kylebot@openai.com>
    net/packet: defer vmalloc TX_RING free until skbs finish

Yong Wang <edragain@163.com>
    tcp: clamp route advmss to TCP_MIN_MSS

Eric Dumazet <edumazet@google.com>
    ipv4: use dst4_mtu() instead of dst_mtu()

Eric Dumazet <edumazet@google.com>
    ipv6: use dst6_mtu() instead of dst_mtu()

Eric Dumazet <edumazet@google.com>
    inet: add dst4_mtu() and dst6_mtu() helpers

Eric Dumazet <edumazet@google.com>
    ipv6: add some unlikely()/likely() clauses in ip6_output.c

Eric Dumazet <edumazet@google.com>
    ipv6: pass proto by value to ipv6_push_nfrag_opts() and ipv6_push_frag_opts()

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Add an anonymous "psc" struct to track current PSC metadata

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Make it more obvious when KVM is writing back the current PSC index

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Wire up kvm_x86_ops.gmem_xxx() if and only if CONFIG_KVM_AMD_SEV=y

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix race between interrupt and resend

Breno Leitao <leitao@debian.org>
    usb: xhci: bail out of setup if the controller is inaccessible

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: simplify handling of Structural Parameters 1 values

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: use cached HCSPARAMS1 value

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: add USB Port Register Set struct

Eric Biggers <ebiggers@kernel.org>
    netfilter: nft_set_pipapo_avx2: add missing vzeroupper

Anton Protopopov <a.s.protopopov@gmail.com>
    bpf: fix the return value of push_stack

Javier Tia <javier@peridio.com>
    xfs: initialise args->total for parent pointer updates

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    fou: Fix use-after-free in fou_create()

Weiming Shi <bestswngs@gmail.com>
    net: appletalk: fix NULL pointer dereference in aarp_send_ddp()

Weiming Shi <bestswngs@gmail.com>
    i2c: smbus: reject oversized block transfers in the common path

Kazuki Hanai <hnkz.64@gmail.com>
    ALSA: us122l: Prevent write upgrades for read mappings

Gary Guo <gary@garyguo.net>
    net: usb: pegasus: don't rely on id table pointer arithmetic

Gary Guo <gary@garyguo.net>
    media: as102: do not rely on id table address comparison

Gary Guo <gary@garyguo.net>
    usb: serial: spcp8x5: don't store usb_device_id

Gary Guo <gary@garyguo.net>
    usb: usbtmc: don't store usb_device_id

Gary Guo <gary@garyguo.net>
    wifi: ath9k_htc: don't store usb_device_id

Gary Guo <gary@garyguo.net>
    usb: xusbatm: don't rely on id table pointer arithmetic

Chuck Lever <chuck.lever@oracle.com>
    xdrgen: Fix union declarations

Ian Rogers <irogers@google.com>
    perf evsel: Add per-thread warning for EOPNOTSUPP open failues

Sasha Levin <sashal@kernel.org>
    Revert "perf tests: Fix flakiness in BPF counters test on hybrid systems"

Sasha Levin <sashal@kernel.org>
    Revert "slab: reset slab->obj_ext when freeing and it is OBJEXTS_ALLOC_FAIL"

Sasha Levin <sashal@kernel.org>
    Revert "selftests/mm: report unique test names for each cow test"

Sasha Levin <sashal@kernel.org>
    Revert "selftests/mm: skip COW tmpfile cases when fallocate() is unsupported"

Sasha Levin <sashal@kernel.org>
    Revert "selftests: harness: Mark test fixture objects __maybe_unused"

Sasha Levin <sashal@kernel.org>
    Revert "nvme: apple: Add Apple A11 support"

Sasha Levin <sashal@kernel.org>
    Revert "nvme-apple: Drop the PRP null check chicken bit"

Sasha Levin <sashal@kernel.org>
    Revert "nvme-apple: Prevent shared tags across queues on Apple A11"

Sasha Levin <sashal@kernel.org>
    Revert "nvme-apple: Reset q->sq_tail during queue init"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sc8180x: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sdm845: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8150: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8250: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8350: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8450: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8550: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8650: Fix the PCIe iommu-map entries"

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Publish an LVCMDQ only after it is fully initialized

Atish Patra <atishp@meta.com>
    crypto: ccp - Fix possible deadlock in SEV init failure path

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix UBSAN array-index-out-of-bounds in smb2_copychunk_range

Darrick J. Wong <djwong@kernel.org>
    xfs: actually recover intended file sizes in xfs_xmi_item_recover_intent

Darrick J. Wong <djwong@kernel.org>
    xfs: advance the findparent inode scan cursor while holding ILOCK

Darrick J. Wong <djwong@kernel.org>
    xfs: bail out on bitmap errors in xrep_agfl_fill

Darrick J. Wong <djwong@kernel.org>
    xfs: compute dquot checksum after resetting dd_lsn in repair

Darrick J. Wong <djwong@kernel.org>
    xfs: count escaped corruption errors in scrub stats

Darrick J. Wong <djwong@kernel.org>
    xfs: destroy seen inode bitmap when we fail to add a dirpath

Darrick J. Wong <djwong@kernel.org>
    xfs: don't leak dqacct if rhashtable insertion fails

Darrick J. Wong <djwong@kernel.org>
    xfs: don't leak new_bp if xfs_btree_bload_drop_buf fails

Darrick J. Wong <djwong@kernel.org>
    xfs: don't modify file attributes or poke fsnotify for dry runs

Darrick J. Wong <djwong@kernel.org>
    xfs: don't spin forever on zero-length dirents when salvaging them

Darrick J. Wong <djwong@kernel.org>
    xfs: fix backwards skipping logic in xrep_quota_block

Darrick J. Wong <djwong@kernel.org>
    xfs: fix bnobt repair space reservation disposal failure

Lin Jiapeng <ljp1205831794@gmail.com>
    xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN

Darrick J. Wong <djwong@kernel.org>
    xfs: fix name string recording in slowpath pptr tracepoints

Darrick J. Wong <djwong@kernel.org>
    xfs: fix replaying dirent removals into the temporary directory

Javier Tia <javier@peridio.com>
    xfs: initialise error in xfs_defer_finish_one()

Darrick J. Wong <djwong@kernel.org>
    xfs: log the tempip after we convert it to extents format

Darrick J. Wong <djwong@kernel.org>
    xfs: preserve owner on in-memory btree creation

Darrick J. Wong <djwong@kernel.org>
    xfs: report nonexistent parents as a filesystem corruption

Darrick J. Wong <djwong@kernel.org>
    xfs: reset parent pointer args before each dir tree unlink repair

Darrick J. Wong <djwong@kernel.org>
    xfs: signal inode btree xref error if get_rec returns an error

Darrick J. Wong <djwong@kernel.org>
    xfs: snapshot old AGFL before rewriting it

Darrick J. Wong <djwong@kernel.org>
    xfs: snapshot scrub stats when rendering them

Darrick J. Wong <djwong@kernel.org>
    xfs: truncate quota file correctly when repairing quota file

Bjoern Doebel <doebel@amazon.de>
    smb: client: fix heap overflow in DACL owner/group rewrite

Bjoern Doebel <doebel@amazon.de>
    smb: client: avoid leaking refcount when cifs_sb_tlink() fails

Bjoern Doebel <doebel@amazon.de>
    smb: client: avoid leaking refcount in cifs_queue_oplock_break()

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix file type corruption in wsl_to_fattr()

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix file type corruption in cifs_reparse_point_to_fattr()

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix one-byte OOB read in smb2_parse_native_symlink()

Karl Mehltretter <kmehltretter@gmail.com>
    smb: client: pin DFS superblock in iterator callback

Aohan Mei <henrymei@tencent.com>
    smb: client: reject userspace cifs.idmap descriptions

Gang Yan <yangang@kylinos.cn>
    selftests: mptcp: fix an UAF in mptcp_connect.c

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: syncookies: remember the request backup flag

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: subflow: no need to copy thmac during ulp_clone

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: options: handle MPC data + csum reqd + no csum

Joe Damato <joe@dama.to>
    bnxt_en: Propagate RX ring init failures in bnxt_init_nic()

Joe Damato <joe@dama.to>
    bnxt_en: Handle buffer allocation failure in bnxt_rx_ring_reset()

Joe Damato <joe@dama.to>
    bnxt_en: Only restore LRO if the device supports TPA

Michael Bommarito <michael.bommarito@gmail.com>
    media: v4l2-ctrls: validate AV1 tile counts

Michael Bommarito <michael.bommarito@gmail.com>
    media: v4l2-ctrls: validate HEVC tile counts

Michael Bommarito <michael.bommarito@gmail.com>
    media: verisilicon: rockchip: reject AV1 frames exceeding the tile capacity

Michael Bommarito <michael.bommarito@gmail.com>
    media: verisilicon: rockchip: guard VPU981 AV1 divisor and tile buffer

Haotian Zhang <vulab@iscas.ac.cn>
    media: v4l2-h264: Fix memcmp() size in B1 reference list comparison

Michael Bommarito <michael.bommarito@gmail.com>
    media: mediatek: vcodec: bound AV1 tile-start copy to the array capacity

Michael Bommarito <michael.bommarito@gmail.com>
    media: verisilicon: hantro: bound G2 HEVC tile loop to the buffer capacity

Michael Bommarito <michael.bommarito@gmail.com>
    media: hevc: add bounded tile-count helpers

Vishnu Razdan <vrazdan@openai.com>
    hwmon: (pmbus) Clear generic status alarms with CLEAR_FAULTS

Fan Wu <fanwu01@zju.edu.cn>
    hwmon: (gpio-fan) Fix use-after-free in alarm work

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: (chipcap2) fix channels in humidity alarm notifications

Cong Nguyen <congnt264@gmail.com>
    hwmon: (applesmc) fix key backlight workqueue leak on register failure

Chengfeng Ye <nicoyip.dev@gmail.com>
    afs: Clear stale peer app data after address list changes

David Howells <dhowells@redhat.com>
    afs: Fix incorrect free in candidate cleanup in afs_lookup_server()

Xixin Liu <liuxixin@kylinos.cn>
    perf: RISC-V: use BIT_ULL for u64 overflow masks

Xixin Liu <liuxixin@kylinos.cn>
    perf: RISC-V: store available counter mask as bitmap

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: Fix missing scrub of temp buffers with AES ctr and gcm algorithm

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: Fix use of mutex in atomic context

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: Fix skcipher_walk return code handling in aes_s390

Nagamani PV <nagamani@linux.ibm.com>
    s390/qeth: allow bridgeport queries despite OS_MISMATCH

leixiang <leixiang@kylinos.cn>
    KVM: PPC: Book3S HV: Set irqfd->producer only on success

Ibrahim Hashimov <security@auditcode.ai>
    mac802154: fix use-after-free of sdata via queued RX frames

Kyle Zeng <kylebot@openai.com>
    ipvs: reject invalid states in connection template sync records

Zihan Xi <zihanx@nebusec.ai>
    ipv4: fib: bound automatic table ID allocation

David Carlier <devnexen@gmail.com>
    ieee802154: hwsim: serialize pib updates to fix double-free

Fan Wu <fanwu01@zju.edu.cn>
    ieee802154: cc2520: fix FIFOP work use-after-free

Zhiling Zou <zhilinz@nebusec.ai>
    ieee802154: 6lowpan: fix NULL dereference in lowpan_newlink

Yilin Zhang <yilinzhang@moonshot.ai>
    inet: frags: invalidate queues before flushing them

Weiming Shi <bestswngs@gmail.com>
    fbdev: vfb: defer cleanup until the last reference

Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
    erofs: preserve LZMA decoders on resize failure

Jeffin Philip <jeffinphilip14@gmail.com>
    fs: autofs: fix memory leak in autofs_fill_super()

Nathan Chancellor <nathan@kernel.org>
    scripts/sorttable: Mark long_size as __maybe_unused

Xiong Weimin <xiongweimin@kylinos.cn>
    vdpa: solidrun: Free IRQs after request failure

Xiong Weimin <xiongweimin@kylinos.cn>
    vdpa: ifcvf: Put device on unsupported feature error

Ilya Maximets <i.maximets@ovn.org>
    netfilter: report NLM_F_DUMP_FILTERED when all is filtered out

Chengfeng Ye <nicoyip.dev@gmail.com>
    netfilter: nf_log: unregister loggers before per-net teardown

Norbert Szetei <norbert@doyensec.com>
    net: openvswitch: fix use-after-free of the flow table mask array

Fourie Zhang <littleddfu@gmail.com>
    net: mpls: clear inner_protocol when the last label is popped

Sahil Chandna <sahilchandna@linux.microsoft.com>
    net: mana: Reserve extra CQ slot for the fence completion CQE

Johan Hovold <johan@kernel.org>
    net: hso: fix TIOCMIWAIT race

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net/sched: act_api: release all action references on NEWACTION failure

David Carlier <devnexen@gmail.com>
    ring-buffer: Check resize_disabled before publishing the new subbuf order

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    ring-buffer: Acquire the lock with irqsave in rb_wake_up_waiters()

Gabriel Krisman Bertazi <krisman@suse.de>
    io_uring/net: let io_recv_buf_select return the length of the buffer region

Thorsten Blum <thorsten.blum@linux.dev>
    drm/i915: Fix memory leak in query_perf_config_list()

Sunil Khatri <sunil.khatri@amd.com>
    drm/drm_exec: fix up contended obj when num_objects is 0

Moritz Tanner <moritz.tanner@linbit.com>
    fs: don't return -EINVAL for successful nested thaw

Jann Horn <jannh@google.com>
    exec: do_close_on_exec() before taking exec_update_lock

Runyu Xiao <runyu.xiao@seu.edu.cn>
    cpufreq: initialize policy rwsem before sysfs publication

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    cpufreq: zero-initialize policy cpumask before sysfs publication

Rong Zhang <i@rong.moe>
    Bluetooth: btrtl: Don't leak return code when parsing firmware format v2

Xu Rao <raoxu@uniontech.com>
    Bluetooth: btqcomsmd: destroy RPMsg endpoints before freeing hci_dev

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ASoC: sti: initialize IRQ lock before requesting IRQ

Tianchu Chen <flynnnchen@tencent.com>
    ASoC: sprd: validate compress buffer sizes against fixed allocations

Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
    accel/ivpu: Limit firmware log name prints to field size

Magdalena Schulfer <magdalena.schulfer@intel.com>
    accel/ivpu: Validate firmware log buffer metadata

Magdalena Schulfer <magdalena.schulfer@intel.com>
    accel/ivpu: Validate full buffer range in ivpu_to_cpu_addr

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Keep the entry count when the histogram stats allocation fails

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Let histogram values keep the percent and graph modifiers

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Free histogram the field rejected for a bad modifier

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Free histogram var refs regardless of how often they are referenced

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Free histogram the var ref when its initialization fails

Henry Martin <bsdhenrymartin@gmail.com>
    tracing/user_events: Don't destroy fields when event removal fails

Thomas Gleixner <tglx@linutronix.de>
    tick/broadcast: Plug clockevents replacement race

Ido Schimmel <idosch@nvidia.com>
    tunnels: Drop stale dst when building an ICMP error for PMTUD

Ali Ahmet Memis <ali@iusegentoo.com>
    ufs: validate cylinder group metadata before caching it

Ali Ahmet Memis <ali@iusegentoo.com>
    ufs: create the root dentry after loading cylinder metadata

James Hilliard <james.hilliard1@gmail.com>
    watchdog: sunxi_wdt: preserve boot-enabled watchdog

Harry Wentland <harry.wentland@amd.com>
    dm/amdgpu: fix malformed link_settings debugfs output

Tristan Madani <tristan@talencesecurity.com>
    ALSA: usbusx2y: validate URB actual_length in interrupt callback

Tristan Madani <tristan@talencesecurity.com>
    ALSA: usbusx2y: fix in04_last array size mismatch with in04_buf

Roman Prucha <zorgan.roman@gmail.com>
    ALSA: ctxfi: Fix CA20K2 S/PDIF passthrough

Miguel Ojeda <ojeda@kernel.org>
    rust: allow `unknown_lints` in generated bindings for Rust < 1.88

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix memory corruption from the histogram stacktrace modifier

Zihan Xi <zihanx@nebusec.ai>
    ipv6: fix fib6 walker UAF on seq stop

Vernon Yang <yanglincheng@kylinos.cn>
    x86/mm: Fix user-space data loss with MADV_FREE and THP

Eric Biggers <ebiggers@kernel.org>
    crypto: x86/aria - add missing vzeroupper in AVX-512 code

Eric Biggers <ebiggers@kernel.org>
    crypto: x86/aria - add missing vzeroupper in AVX2 code

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    powerpc/eeh: Fix recursive locking on devices without EEH sensitive driver

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/ps3: Fix repository.c build failure

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent out-of-bounds reads in share config responses

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    scripts/mksysmap: fix escape of '$' in the __pi_ pattern

Stian Halseth <stian@itx.no>
    sunvdc: unmap LDC cookies when the descriptor send fails

Eelco Chaudron <echaudro@redhat.com>
    openvswitch: fix wrong flag value in get_ipv6_ext_hdrs()

MD Danish Anwar <danishanwar@ti.com>
    net: hsr: enable promiscuous mode on interlink port with fwd offload

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: fix TX descriptor availability check for TSO traffic

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: add TSO check for header length

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: add stmmac_tso_header_size()

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: fix TSO support when some channels have TBS available

Furong Xu <0x1207@gmail.com>
    net: stmmac: TSO: Simplify the code flow of DMA descriptor allocations

Greg Marsden <greg.marsden@oracle.com>
    net/rds: fix tcp stream corruption with large pages

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: fix PF/CGX debugfs PCI bus lookup

Vladislav Karmanov <vladislav.karmanov.dev@gmail.com>
    net: phy: mediatek-ge: disable EEE on the MT7530 PHY

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: add phy_disable_eee

SkyLake.Huang <skylake.huang@mediatek.com>
    net: phy: mediatek: Re-organize MediaTek ethernet phy drivers

Colin Ian King <colin.i.king@gmail.com>
    cxgb4: clip_tbl: Fix spelling mistake "wont" -> "won't"

Aamir Ahmed <elb12345@hotmail.co.uk>
    net: hinic: fix mailbox segment buffer overflow

Li Youhong <liyouhong@kylinos.cn>
    net: sun4i-emac: fix missing of_node_put() for phy_node

Kuniyuki Iwashima <kuniyu@google.com>
    net/sched: cls_api: Don't replay RTM_GETCHAIN in tc_ctl_chain().

Victor Nogueira <victor@mojatatu.com>
    net/sched: cls_route: Fix in-place replace

Victor Nogueira <victor@mojatatu.com>
    net/sched: cls_route: Reject handle aliasing

Victor Nogueira <victor@mojatatu.com>
    net/sched: cls_route: free emptied bucket on filter move

Vincent Guittot <vincent.guittot@linaro.org>
    sched/eevdf: Fix rb augmented with multi fields

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Fix lag clamp

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Fix EEVDF entity placement bug causing scheduling lag

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Correct pt_regs->flags update for PEBS path

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel/ds: Factor out PEBS group processing code to functions

Changbin Du <changbin.du@huawei.com>
    perf/x86/intel/ds: Remove redundant assignments to sample.period

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/ds: Clarify adaptive PEBS processing

Yabin Cui <yabinc@google.com>
    perf/core: Check sample_type in perf_sample_save_callchain

Thomas Richter <tmricht@linux.ibm.com>
    perf/core: Allow list_del during perf_event_overflow()

Kan Liang <kan.liang@linux.intel.com>
    perf: Supply task information to sched_task()

Thibault Ferrante <thibault.ferrante@canonical.com>
    selftests/powerpc/tm: Fix tcheck() reading uninitialised CR value

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: initialize ptp_lock at probe time

Qingfang Deng <qingfang.deng@linux.dev>
    ppp_synctty: ensure a writeable skb header

Eric Dumazet <edumazet@google.com>
    vxlan: initialize _md in vxlan_xmit_one()

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-pf: reset HTB scheduler topology before freeing queues

Linmao Li <lilinmao@kylinos.cn>
    hwmon: (corsair-cpro) Remove debugfs entries when probe fails

Pengpeng Hou <pengpeng@iscas.ac.cn>
    hwmon: (aspeed-pwm-tacho) Propagate reset deassert errors

Cong Nguyen <congnt264@gmail.com>
    hwmon: (gpio-fan) take fan_data->lock in gpio_fan_shutdown()

Linmao Li <lilinmao@kylinos.cn>
    hwmon: (corsair-cpro) Create debugfs entries after hwmon registration

Marek Vasut <marex@nabladev.com>
    net: ks8851: Fix receiver error in 100BASE-TX mode following software power-down

Yicong Hui <yiconghui@gmail.com>
    net/micrel: Fix typos in micrel driver code comments

Jan Havran (Advantech Czech) <havran.jan@email.cz>
    net: dsa: lantiq_gswip: fix GSWIP_MDIO_PHY_FCONTX_EN value

Daniel Golle <daniel@makrotopia.org>
    net: dsa: lantiq_gswip: move definitions to header

Daniel Golle <daniel@makrotopia.org>
    net: dsa: lantiq_gswip: prepare for more CPU port options

Daniel Golle <daniel@makrotopia.org>
    net: dsa: lantiq_gswip: deduplicate dsa_switch_ops

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Sync timeout value if WDT was running at boot

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix undefined behavior

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix spurious reset on suspend

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Enable clock before accessing hardware registers

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix clock leak and spurious timer in settimeout()

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Avoid division by zero

David Arcari <darcari@redhat.com>
    watchdog: fix hrtimer start when pretimeout is zero

Paolo Abeni <pabeni@redhat.com>
    mptcp: remove unneeded READ_ONCE() annotation

Nicolai Buchwitz <nb@tipi-net.de>
    net: macb: destroy the phylink instance on the probe error path

Jiajia Liu <liujiajia@kylinos.cn>
    Bluetooth: btusb: Fix leaked runtime PM reference in btusb_reset

Jiajia Liu <liujiajia@kylinos.cn>
    Bluetooth: btusb: mediatek: Fix leaked runtime PM reference in reset

Ivan Hu <ivan.hu@canonical.com>
    Bluetooth: btmtk: Declare MT7920 (MT7961 1a) Bluetooth firmware

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: fix tx_handle bounds off-by-one

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: validate packet_len before skb_put_data

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: btusb: Fix UAF of btusb_data by rx_work

Jakub Kicinski <kuba@kernel.org>
    eth: ice: don't dereference pointers from TP_printk()

Jacob Keller <jacob.e.keller@intel.com>
    ice: add missing xa_destroy for sched_node_ids

Joshua Hay <joshua.a.hay@intel.com>
    idpf: account for VLAN header when parsing RSC packet header

HyeongJun An <sammiee5311@gmail.com>
    ALSA: hda: Report a change when only the channel status bytes move

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/common: Use guard() for mutex locks

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/common: Use cleanup macros for PM controls

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Introduce auto cleanup macros for PM

Karl Mehltretter <kmehltretter@gmail.com>
    drm/logicvc: Drop the select of the nonexistent CONFIG_DRM_KMS_DMA_HELPER

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Count RX descriptors for freeq refill

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Count RX drops once per frame

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: No mapping is a dropped rx

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Count dropped frames as NAPI work

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Finish RX updates before NAPI completion

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Fix budget accounting

Alice Mikityanska <alice@isovalent.com>
    net: ipv6: Clamp to IP6_MAX_MTU in ip6_dst_mtu_maybe_forward

Alice Mikityanska <alice@isovalent.com>
    net: ipv6: Fix UDP length overflow with PMTU discover and big MTU

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Return immediately when manage_oob() returns NULL for 0-length buffer.

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Update last skb marker in manage_oob().

Karl Mehltretter <kmehltretter@gmail.com>
    virtio_input: stop callbacks before unregistering input device

Xiong Weimin <xiongweimin@kylinos.cn>
    virtio_input: reset device if input_register_device() fails

Andrew Stellman <astellman@stellman-greene.com>
    virtio-pci: return IRQ_HANDLED after non-zero ISR

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vdpa_sim_net: check TX pull result before RX copy

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vdpa_sim_blk: reject out-of-range sector starts

Yu Zhang <yuz08559@gmail.com>
    vhost-vdpa: protect config_ctx from being freed under the config callback

Yu Zhang <yuz08559@gmail.com>
    vhost-vdpa: don't install the eventfd_ctx_fdget() error in config_ctx

Jia Jia <physicalmtea@gmail.com>
    vhost/vdpa: reject VRING_NUM larger than device max

Jia Jia <physicalmtea@gmail.com>
    virtio_console: do not free control-out buffers on remove

Karl Mehltretter <kmehltretter@gmail.com>
    virtio: fix use-after-free in unregister_virtio_device()

hpp.iscas <hppiscas@163.com>
    ASoC: mt6351: Publish the OF module alias

Florian Westphal <fw@strlen.de>
    netfilter: ip6_tables: set F_PROTO when proto value is nonzero

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_log: cope with concurrent instance destruction

hpp.iscas <hppiscas@163.com>
    ASoC: Intel: SST: Publish the PCI module aliases

hpp.iscas <hppiscas@163.com>
    ASoC: bcm: bcm63xx: Publish the OF module aliases

Jared Kangas <jkangas@redhat.com>
    hwmon: (ina2xx) Parameterize ina2xx_data in ina226_alert_read()

Guenter Roeck <linux@roeck-us.net>
    hwmon: Introduce 64-bit energy attribute support

Zijun Hu <quic_zijuhu@quicinc.com>
    libnvdimm: Replace namespace_match() with device_find_child_by_name()

Geert Uytterhoeven <geert+renesas@glider.be>
    hwmon: (ltc4282) Make sure clk_init_data is fully initialized

Edward Adam Davis <eadavis@sina.com>
    ALSA: caiaq: Decoupling ep1_in_urb in caiaq dev

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Reject non-scalar bpf_loop iteration counts

Vineeth Karumanchi <vineeth.karumanchi@amd.com>
    net: macb: fix NULL pointer dereference on unbind with fixed-link

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: rename bp->sgmii_phy field to bp->phy

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: ets: clamp quantum in parse and fallback paths

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: drr: clamp quantum in change class

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: pie: clamp psched_mtu in pie_drop_early

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: hhf: clamp quantum in change and init paths

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sfq: clamp quantum in change path

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq_pie: clamp quantum in change path

Lama Kayal <lkayal@nvidia.com>
    net/mlx5: E-Switch, prevent mc_list repopulation during vport disable

Yael Chemla <ychemla@nvidia.com>
    net/mlx5: E-Switch: fix use-after-free in mlx5_eswitch_termtbl_put

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Fix use-after-free race in sample_restore_put()

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Fix ETS zero BW reporting when one TC holds 100%

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Fix setting RS FEC after remapping

Weiming Shi <bestswngs@gmail.com>
    net/sched: defer qdisc freeing after failed creation

XingWang Xiang <v3rdant.xiang@gmail.com>
    net: mctp: i3c: serialize probe with bus removal

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/kexec_file: Use inclusive range checks in add_usable_mem()

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: don't release PCI regions for VFs on reset

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: fix cmd_regs access racing BAR unmap on reset

Jamal Hadi Salim <jhs@mojatatu.com>
    net: reject oversized tx_queue_len at netlink parse time

Jamal Hadi Salim <jhs@mojatatu.com>
    net: cap tx_queue_len at S16_MAX to prevent oversized ring allocations

Seungwon Bae <qotmddnjs@ajou.ac.kr>
    vxlan: reject dynamic fdb entries that reference a nexthop id

Alexandra Winter <wintera@linux.ibm.com>
    s390/ism: folio_put() after error

Jason Winter <jjx@live.nl>
    net: usb: cx82310_eth: drop URB after 0xffff reboot sentinel to prevent partial_data heap overflow

Nikhil P. Rao <nikhil.rao@amd.com>
    ionic: use netif_txq_maybe_stop() in ionic_tx()

Viswajith Murali <viswajithm@marvell.com>
    octeontx2-af: mcs: Clear stale X2P calibration state before calibration

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: mcast: properly convert mglist to rcu

Jakub Kicinski <kuba@kernel.org>
    net: dsa: mv88e6xxx: bound the policy rule dump by the caller's buffer size

Jakub Kicinski <kuba@kernel.org>
    eth: nfp: drop the replaced rule from the list when reprogramming fails

Jakub Kicinski <kuba@kernel.org>
    eth: nfp: bound the ntuple rule dump by the caller's buffer size

Jakub Kicinski <kuba@kernel.org>
    eth: nfp: migrate to new RXFH callbacks

Jakub Kicinski <kuba@kernel.org>
    net: ethtool: add dedicated callbacks for getting and setting rxfh fields

Jakub Kicinski <kuba@kernel.org>
    net: ethtool: require drivers to opt into the per-RSS ctx RXFH

Jakub Kicinski <kuba@kernel.org>
    net: ethtool: remove the duplicated handling from rxfh and rxnfc

Jakub Kicinski <kuba@kernel.org>
    net: ethtool: copy the rxfh flow handling

Gal Pressman <gal@nvidia.com>
    ethtool: Block setting of symmetric RSS when non-symmetric rx-flow-hash is requested

Gal Pressman <gal@nvidia.com>
    ethtool: Symmetric OR-XOR RSS hash

Jakub Kicinski <kuba@kernel.org>
    net: dsa: bcm_sf2: bound the CFP rule dump by the caller's buffer size

Eric Dumazet <edumazet@google.com>
    bonding: use skb_cow_head() in bond_do_alb_xmit() and rlb_arp_xmit()

Ido Schimmel <idosch@nvidia.com>
    nexthop: Initialize extack in remove_nh_grp_entry()

Jiayuan Chen <jiayuan.chen@linux.dev>
    selftests/bpf: Fix flaky bpf_nf test when random NAT port is 0

Ning Ding <dingning04@gmail.com>
    bpf: Reject untrusted allocated-object pointers

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Require MEM_PERCPU for percpu kptr stores

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    thermal: sysfs: switch to use scnprintf() to suppress truncation warning

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Don't predict JMP32 pointer vs zero comparisons

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark faultable stack helpers as sleepable

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark bpf_btf_find_by_name_kind() as sleepable

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: fix tx_spb_ring_full() checking same slot cnt times

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: clear txcb->last before writing each descriptor

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix unbalanced module reference count

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Do not ignore -ENOENT when loading a topology

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Clean up streams if their initialization fails

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Clean up the bus when fetching ML caps fails

Xixin Liu <liuxixin@kylinos.cn>
    nvme-tcp: defer TLS inline send to io_work

Hannes Reinecke <hare@kernel.org>
    nvme-tcp: open-code nvme_tcp_queue_request() for R2T

Mohamed Khalfella <mkhalfella@purestorage.com>
    nvme: remove stale namespaces by NSID range during scan

Steven Rostedt <rostedt@goodmis.org>
    ring-buffer: Add checking nr_subbufs to persistent ring buffer validation

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark sched_process_wait argument as nullable

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix NULL-ptr-deref in btf_var_show()

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix NULL-ptr-deref when showing a void BTF type

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Fix potential double-free at error path

HyeongJun An <sammiee5311@gmail.com>
    selftests/alsa: Fix the step check for INTEGER controls

Breno Leitao <leitao@debian.org>
    arm64: trans_pgd: clone only the linear map that exists at runtime

HW He <hw.he@mediatek.com>
    net: gro: Fix nesting of TCP GSO SKBs in skb_gro_receive_list()

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: reconfigure RX packet parser table in stmmac_hw_setup() after reset

Allison Henderson <achender@kernel.org>
    net/rds: don't let rds_conn_shutdown() consume a concurrent drop

Håkon Bugge <haakon.bugge@oracle.com>
    net/rds: acquire the fastpath locks in rds_conn_shutdown()

Allison Henderson <achender@kernel.org>
    net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()

Gerd Rausch <gerd.rausch@oracle.com>
    net/rds: tcp: don't force RDS_CONN_RESETTING over a concurrent shutdown

Allison Henderson <achender@kernel.org>
    net/rds: clear cp_flags bits individually in rds_conn_path_reset()

Allison Henderson <achender@kernel.org>
    net/rds: use clear_bit_unlock() in release_refill()

Allison Henderson <achender@kernel.org>
    net/rds: use wq_has_sleeper() in release_in_xmit()

Eric Dumazet <edumazet@google.com>
    bonding: do not clear curr_active_slave prematurely when releasing all slaves

Eduard Zingerman <eddyz87@gmail.com>
    bpf: reject BPF_PSEUDO_FUNC reference to the main program

Henry Martin <bsdhenrymartin@gmail.com>
    tracing/probes: Fix use-after-free on field name/type of events with multiple probes

Joas Antonio dos Santos <joasantonio108@gmail.com>
    netfilter: nf_conntrack_sip: fix OOB read in sip_skip_whitespace()

Kyle Zeng <kylebot@openai.com>
    ipvs: fix reversed sequence option serialization

Qu Wenruo <wqu@suse.com>
    btrfs: do not force reloc root creation during qgroup_account_snapshot()

Avi Weiss <thnkslprpt@gmail.com>
    btrfs: send: fix lost error return value in will_overwrite_ref()

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: finish active block group cleanup if call_zone_finish() fails

Qu Wenruo <wqu@suse.com>
    btrfs: return proper negative error code for update_raid_extent_item()

Qu Wenruo <wqu@suse.com>
    btrfs: fix the possible bioc_list memory leak during error

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    btrfs: fix transaction use-after-free in raid stripe insertion

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Program the MSP FIFO watermarks

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Allow repeated MSP prepare calls

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Remove obsolete PRCMU QoS calls

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Request the MSP MMIO resource

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Deassert the MSP reset during probe

Linus Walleij <linusw@kernel.org>
    mfd: db8500-prcmu: Fold dbx500 header into db8500

Kees Cook <kees@kernel.org>
    arm: Handle KCOV __init vs inline mismatches

Zijun Hu <quic_zijuhu@quicinc.com>
    mfd: db8500-prcmu: Remove needless return in three void APIs

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Validate MSP DAI configuration

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Correct MSP frame and bit clock setup

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Propagate MSP setup errors

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Fix MSP stream lifecycle handling

John Ogness <john.ogness@linutronix.de>
    printk/nbcon: Change nbcon_irq_work to IRQ_WORK_LAZY

Qingyu Zhang <usupergate@gmail.com>
    ALSA: ump: do not touch legacy_rmidi before it exists

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Update rawmidi name per EP name update

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Copy safe string name to rawmidi

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Copy FB name string more safely

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Show substream activity in info ioctl

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Expose the tied device number in info ioctl

Sunil Goutham <sgoutham@marvell.com>
    octeontx2-af: Fix limiting SRIOV VF count logic

Eric Dumazet <edumazet@google.com>
    locking/lockdep: Invalidate stale class_cache entries for zapped classes

Leo Yan <leo.yan@arm.com>
    perf/core: Skip empty AUX records with only format flags

Ivy Lopez <skunkolee@gmail.com>
    scsi: mpt3sas: Avoid out-of-bounds cpumask_of_node() call in _base_assign_reply_queues()

Xixin Liu <liuxixin@kylinos.cn>
    perf: RISC-V: check cpu_hw_evt before dereference in overflow IRQ

Eric Dumazet <edumazet@google.com>
    bonding: alb: fix uninitialized transport header access in alb_determine_nd()

Guanghui Yang <3497809730@qq.com>
    btrfs: restore active device pointers after failed sprout

Guanghui Yang <3497809730@qq.com>
    btrfs: detach failed sprout device from transaction update list

Lu Yao <yaolu@kylinos.cn>
    drm/xe/oa: Remove sysfs entry on idr_alloc failure in xe_oa_add_config_ioctl()

wangdicheng <wangdicheng@kylinos.cn>
    ASoC: amd: yc: fix memory leak in acp6x_pdm_dma_close()

wangdicheng <wangdicheng@kylinos.cn>
    ASoC: amd: renoir: fix disable_pdm_interrupts() to clear mask bits

Vasily Gorbik <gor@linux.ibm.com>
    s390/boot: Avoid IPL parameter append past command line

Vasily Gorbik <gor@linux.ibm.com>
    s390/boot: Fix physical memory search range

Xu Rao <raoxu@uniontech.com>
    ALSA: hda: restore MFG widget enumeration after core split

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/core: Use guard() for mutex locks

Hui Su <sh_def@163.com>
    staging: fbtft: make dirty_lock IRQ-safe

Kuniyuki Iwashima <kuniyu@google.com>
    af_packet: Don't cast tpacket_hdr.tp_len to int in tpacket_parse_header().

Eric Dumazet <edumazet@google.com>
    ipv6: sr: restore network header before routing and forwarding

David Laight <david.laight.linux@gmail.com>
    tipc: Dont send random pad bytes in RESET/ACTIVATE messages

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: fix NULL deref in tipc_named_node_up() on empty publication list

Eric Dumazet <edumazet@google.com>
    ip6_gre: check tunnel info before xmit in ip6gre_tunnel_xmit

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: use copy-on-write RCU updates in ip6_mc_source()

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: mcast: Don't hold RTNL for MCAST_ socket options.

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: mcast: Don't hold RTNL for IPV6_DROP_MEMBERSHIP and MCAST_LEAVE_GROUP.

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: mcast: Don't hold RTNL for IPV6_ADD_MEMBERSHIP and MCAST_JOIN_GROUP.

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: fix RCU list diversion in ip6_mc_del1_src()

Qingfang Deng <qingfang.deng@linux.dev>
    ppp: ppp_synctty: simplify tty disc_data access

Qingfang Deng <qingfang.deng@linux.dev>
    ppp: ppp_async: simplify tty disc_data access

Eric Dumazet <edumazet@google.com>
    igmp: convert struct ip_sf_list to RCU

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_u32: fix duplicate handle when node ID pool is exhausted

Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
    net: ethernet: oa_tc6: Fix for the wrong data type

Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
    net: ethernet: oa_tc6: Disable tx queues on fatal error

Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
    net: ethernet: oa_tc6: Improve the error recovery

Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
    net: ethernet: oa_tc6: Protect skb pointer used by two different kernel instances

Ciprian Regus <ciprian.regus@analog.com>
    net: ethernet: oa_tc6: Add the OA_TC6_ prefix to standard registers

Ciprian Regus <ciprian.regus@analog.com>
    net: ethernet: oa_tc6: Export standard defined registers

Ciprian Regus <ciprian.regus@analog.com>
    net: ethernet: oa_tc6: Handle the OA TC6 SPI protected mode

Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
    net: ethernet: oa_tc6: Interrupt is active low, level triggered.

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Validate and program TDM slots correctly

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Correct digital interface format setup

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Repair the DAPM capture graph

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Reset the audio block before configuring it

Gongwei Li <ligongwei@kylinos.cn>
    Bluetooth: hci_mrvl: Fix wrong return value check of wait_on_bit_timeout()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: clear FLAG_DEFER_SETUP only for same PID/PSM

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: fix out-of-bounds write in l2cap_ecred_connect

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: fix chan mode for LE_CONN_REQ + EXT_FLOWCTL pchan

Aleksandr Nogikh <nogikh@google.com>
    Bluetooth: hci_core: Fix race condition during device registration

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    Bluetooth: btintel: bound firmware ID by TLV length

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    Bluetooth: btintel: validate version TLV value lengths

Jiacheng Xu <stitch@zju.edu.cn>
    workqueue: reject watchdog thresholds that overflow jiffies

Marco Crivellari <marco.crivellari@suse.com>
    workqueue: replace use of system_wq with system_percpu_wq

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Clear automask on spurious interrupts

Wanwu Li <liwanwu@kylinos.cn>
    sched_ext: Fix timer pinning and return value in scx_central

Vasily Gorbik <gor@linux.ibm.com>
    s390/ipl: Fix NULL deref in dump_reipl without re-IPL parm block

Vasily Gorbik <gor@linux.ibm.com>
    s390/ipl: Fix NULL deref in kdump without re-IPL parm block

Heiko Carstens <hca@linux.ibm.com>
    s390/time: Use jiffies instead of jiffies_64

Heiko Carstens <hca@linux.ibm.com>
    s390/vtime: Use __this_cpu_read() / get rid of READ_ONCE()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: rate limit unmapped SID errors

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: propagate DACL parsing errors

Yilin Zhang <yilinzhang@moonshot.ai>
    ALSA: pcm: Serialize PCM mmap with buffer reallocation to fix page UAF

Colin Ian King <colin.i.king@gmail.com>
    OPP: of: Fix potential multiplication overflow when calculating freq

Adrian Hunter <adrian.hunter@intel.com>
    perf symbol: Do not use debug file as the binary type

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix NULL pointer dereference in PM callbacks

Baul Lee <baul.lee@xbow.com>
    vxlan: mdb: Fix use-after-free in vxlan_mdb_remote_src_del()

James Nugraha <aslan.jnn@gmail.com>
    net: amd-xgbe: discard rx packets with bad FCS

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    raw: annotate disconnect-side IPv4 match writers

Henry Martin <bsdhenrymartin@gmail.com>
    sctp: fix soft lockup from unpadded ASCONF-ACK parameter iteration

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    smb: client: transport: Fix debug printing in __release_mid()

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: fix integer truncation in collapse range

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: fix data corruption in emulated insert range

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb: move copychunk definitions to common/smb2pdu.h

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: batch SRV_COPYCHUNK entries to cut round trips

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: mark file sparse before emulating insert range

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: validate new EOF for zero range

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: validate new EOF for insert range

Milan P. Gandhi <mgandhi@redhat.com>
    scsi: mpi3mr: Fix target device refcount leak in mpi3mr_sas_port_add()

Milan P. Gandhi <mgandhi@redhat.com>
    scsi: mpi3mr: Fix NULL pointer dereference in mpi3mr_sas_port_add()

Xin Long <lucien.xin@gmail.com>
    sctp: fix a TOCTOU race in SCTP_CMD_TIMER_START

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_api: fix skb sizing and action leak on reoffload delete

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_api: size the RTM_GETACTION reply from the actions

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_api: budget all shared attributes in notify skbs

Dong Chenchen <dongchenchen2@huawei.com>
    net: iptunnel: fix stale transport header during tunnel decapsulation

Eric Dumazet <edumazet@google.com>
    tcp: use GFP_ATOMIC in tcp_send_active_reset()

Eric Dumazet <edumazet@google.com>
    net: icmp: avoid invalid transport header access in icmp_send tracepoint

Slawomir Stepien <sst@poczta.fm>
    drm/cirrus-qemu: Validate BAR0 size during probe

Thomas Zimmermann <tzimmermann@suse.de>
    drm/cirrus: Use video aperture helpers

Ali Ahmet Memis <ali@iusegentoo.com>
    ufs: do not treat unreadable directory blocks as empty

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix REG INVARIANTS VIOLATION on speculative pointer arithmetic

Hongfu Li <lihongfu@kylinos.cn>
    selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter

Liang Luo <luoliang@kylinos.cn>
    sched_ext: Fix nonexistent field in sched-ext.rst example

Xixin Liu <liuxixin@kylinos.cn>
    nvmet-rdma: fix queue leak when connect backlog is exceeded

Xixin Liu <liuxixin@kylinos.cn>
    nvme-rdma: fix -EIO cleanup order in queue_rq

Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
    accel/qaic: Address potential out-of-bounds read in resp_worker()

Dan Carpenter <error27@gmail.com>
    drm/virtio: Fix a NULL vs ERR_PTR() bug in virtio_gpu_user_framebuffer_create()

Jad Keskes <inasj268@gmail.com>
    EDAC/device_sysfs: Use kstrtouint() for poll_msec to prevent truncation

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix channel address decode for non-hash mode

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix channel selection hash

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix interleave boundary condition

Yazen Ghannam <yazen.ghannam@amd.com>
    RAS/AMD/ATL, EDAC/amd64: Only load ATL when needed

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: ensure interrupts are enabled in __do_user_fault()

Xie Yuanbin <xieyuanbin1@huawei.com>
    ARM: 9484/1: enable interrupts when unhandled user faults are triggered

SJ Park <sj@kernel.org>
    mm/damon/core: avoid infinite kdamond_merge_regions() internal loop

Max Chou <max.chou@realtek.com>
    Bluetooth: btrtl: Add the support for RTL8761CUV

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Unlink scc_entry in unix_del_edge().

Eric Dumazet <edumazet@google.com>
    l2tp: fix tunnel and session refcount leak on seq_file release

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use memcmp() to compare ClientGUIDs

HyeongJun An <sammiee5311@gmail.com>
    ASoC: meson: aiu: Validate written enum values

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: topology: Check PCM and DAI name strings before use

Kuniyuki Iwashima <kuniyu@google.com>
    ipv4: fib: Don't dump dying fib_info in fib_leaf_notify().

Jiri Olsa <jolsa@kernel.org>
    bpf: Guard __get_user acesss with access_ok for uprobe_multi data

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Proper rollback if the ioremap fails

Jie Gan <jie.gan@oss.qualcomm.com>
    coresight: platform: defer connection counter increment until alloc succeeds

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid10: fix writes_pending and barrier reference leaks on discard failures

Xin Long <lucien.xin@gmail.com>
    sctp: fix err_chunk memory leaks in INIT handling

Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
    bpf: Mask pseudo pointer values in verifier logs

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix malformed ISO_END/CONT handling

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Reject redirect helpers without a bpf_net_context

Gregor Herburger <gregor.herburger@linutronix.de>
    drm/vc4: hvs/v3d: Fix null dereference in unbind

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    tipc: fix integer overflow in tipc_recvmsg() and tipc_recvstream()

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    net: drop_monitor: fix info leak in NET_DM_ATTR_PAYLOAD

Eric Dumazet <edumazet@google.com>
    drop_monitor: fix size calculations for 64-bit attributes

Eric Dumazet <edumazet@google.com>
    drop_monitor: perform u64_stats updates under IRQ-disabled section

Vlatko Kosturjak <kost@linux.hr>
    ppp_async: drop the errored frame instead of resetting its headroom

Saravana Kannan <saravanak@google.com>
    of: dynamic: Fix overlayed devices not probing because of fw_devlink

Ulf Hansson <ulf.hansson@linaro.org>
    driver core: Export get_dev_from_fwnode()

Brahmajit Das <listout@listout.xyz>
    drm/amd/display: clean-up dead code in dml2_mall_phantom

Zi Yan <ziy@nvidia.com>
    mm/huge_memory: use folio's memcg inside __folio_split()

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    wifi: mt76: mt7921: skip unknown CLC firmware records

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    wifi: mt76: mt7921: validate CLC firmware records

Sasha Levin <sashal@kernel.org>
    Revert "ARM: 9481/2: breakpoint: CFI breakpoints only on demand"

Sasha Levin <sashal@kernel.org>
    Revert "bpf, s390: Clear fetch destination on faulting arena atomic"

Gil Portnoy <dddhkts1@gmail.com>
    ksmbd: remove stale channels from all sessions on teardown

Andrii Nakryiko <andrii@kernel.org>
    bpftool: Strip all -Wformat* flags from bootstrap libbpf build

Genevieve Chan <genevieve.chan@altera.com>
    firmware: stratix10-svc: fix FCS SMC call kernel-doc

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPI: processor: Update cpuidle driver check in __acpi_processor_start()"

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_log: wait for rcu grace period before freeing pernet state

Lin Xianglin <1021538027@qq.com>
    ASoC: amd: yc: Add DMI quirk for HyperX OMEN Gaming Laptop 16-ap1xxx

Zizhi Wo <wozizhi@huawei.com>
    scsi: core: Do not block on tag allocation in scsi_eh_lock_door()

Rudi Heitbaum <rudi@heitbaum.com>
    ASoC: rt5645: Perform the initial jack detect at probe

Jisheng Zhang <jszhang@kernel.org>
    spi: dw: fix wrong RX_SAMPLE_DLY setting after resume

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Disable LPM on WDC WD141KFGX-68FH9N0

Guenter Roeck <linux@roeck-us.net>
    hwmon: (corsair-psu) Fix linear11 calculation

Jia Jia <physicalmtea@gmail.com>
    vhost-scsi: flush backend after device ioctls

Zhang Heng <zhangheng@kylinos.cn>
    ASoC: amd: yc: Add DMI quirk for HP Victus Laptop 16-e1xxx

Hardik Garg <hargar@linux.microsoft.com>
    Drivers: hv: vmbus: add VTL2 redirect connection ID

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Disable LPM on WD Green 2.5 480GB

André Pragosa <pragosa512@gmail.com>
    ALSA: hda/realtek: Add mute LED quirk for HP Victus 16-e0xxx (MB 88ED)

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Disable LPM on some WD drives

Robert Abrahamse <denobyte2@gmail.com>
    ALSA: usb-audio: Add quirk for Corsair Virtuoso (later revision)

Jiale Yao <yaojiale02@163.com>
    Bluetooth: RFCOMM: validate skb length in rfcomm_recv_frame

Deepanshu Kartikey <kartikey406@gmail.com>
    wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()

Li Qiang <liqiang01@kylinos.cn>
    cifs: validate idmap key payload length

Vaibhav Jain <vaibhav@linux.ibm.com>
    powerpc/pseries: Ensure vpa,slb_shadow & dtl are unregistered during crash

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: pass the return value of skb_checksum_help()

Madhavender Singh <madhav@disroot.org>
    ALSA: hda/realtek: Add mute LED quirk for HP Laptop 14s-dr1xxx

Markus Lindner <lindner.markus@outlook.at>
    ALSA: usb-audio: Add dB map quirk for Razer Barracuda X 2.4

Minhong He <heminhong@kylinos.cn>
    phonet: check register_netdevice_notifier() error in phonet_device_init()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    drm/gma500: return errors from Oaktrail HDMI I2C reads

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: preserve VFS inherited POSIX ACL mask

Ibrahim Hashimov <security@auditcode.ai>
    wifi: mac80211_hwsim: reject undersized HWSIM_ATTR_TX_INFO

Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>
    regulator: core: clamp voltage constraints before applying apply_uV

Jay Vadayath <jay@artiphishell.com>
    smb: client: bound dirent name against end of SMB response in cifs_filldir

Georgi Valkov <gvalkov@gmail.com>
    wifi: mwifiex: replace one-element arrays with flexible array members

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Add HDA_CODEC_QUIRK for Samsung 750XBE/730XBE

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: acpi: validate WGDS table revision index

Daniel C. Ribeiro <dcoutinho.96@gmail.com>
    ALSA: usb-audio: Add FIXED_RATE quirk for JBL Quantum650 Wireless

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: bound aligned TLV advance in FW parser

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add quirk for HP Pavilion x360

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/si: Don't schedule thermal work when queue isn't initialized

Pu Hu <hupu@transsion.com>
    arm64: kprobes: Allow reentering kprobes while single-stepping

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix out-of-bounds tid_data access in BA notif

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: add a check on the tid coming from the firmware

Yu Peng <pengyu@kylinos.cn>
    arm64: fixmap: Allow 256K early_ioremap() at any offset

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix a possible underflow

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: validate TX_CMD response layout

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: Intel: sof_sdw: Add quirks for new Dell laptops

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: flush dirty data before punching a hole

Tao Cui <cuitao@kylinos.cn>
    blk-cgroup: fix leaks and online flag on radix_tree_insert failure

Marcel Kłos <marcel@marmak.net.pl>
    ALSA: hda/realtek: Add quirk for HP EliteBook 830 G8 (8AB8) to enable mute LEDs

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: pcie: null RX pointers after free

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix sched scan IE sizing

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: parse beacon notif per layout

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix an off-by-1 boundary check

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: validate mac_link_id in session protect notif

Filipe Manana <fdmanana@suse.com>
    btrfs: fix reloc root cleanup in merge_reloc_roots()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: validate sta_id in BA window status notif

Wang YuWei <1973615295@qq.com>
    spi: dw-dma: Wait for controller idle before completing Tx

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free on reloc root after error in insert_dirty_subvol()

Dave Chen <davechen@synology.com>
    btrfs: only account delalloc bytes for regular file inodes in btrfs_getattr()

Pali Rohár <pali@kernel.org>
    cifs: Fix support for creating SFU fifo

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda: cs35l56: Fail if wmfw file is missing

Rohit Sinha <rohitsinha12043@gmail.com>
    ALSA: hda/realtek - Add quirk for HP Victus 15-fa0xxx (MB 8A50)

Chen Bowen <hicbowen@gmail.com>
    ALSA: hda/realtek: Fix speakers on MECHREVO WUJIE Series

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: zero-initialize stack-allocated cifs_open_info_data

Pali Rohár <pali@kernel.org>
    cifs: Fix support for creating SFU socket

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: reduce fallocate zero buffer allocation

Tianze Shao <shaotianze@outlook.com>
    ASoC: rt712-sdca: reset codec at io_init to fix silent headphone

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: rsi: validate beacon length before fixed buffer copy

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: mark the rcu locked areas properly

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: libipw: fix key index receive bound checks

Liang Hao <haohlliang@gmail.com>
    gpio: dwapb: Mask interrupts at hardware initialization

Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: mac80211: ibss: wait for in-flight TX on disconnect

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: validate rx/tx MLME callback frame lengths before access

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate SID namespace before mapping IDs

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: mark invalid session responses as signed

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: find bound sessions during reauthentication

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: validate assoc response length before status and IE access

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: libertas: reject short monitor TX frames

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: rsi: avoid reading TKIP MIC keys for non-TKIP ciphers

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: validate deauth frame length before reason access

Corentin Labbe <clabbe@baylibre.com>
    wifi: ralink: RT2X00: init EEPROM properly

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ALSA: usb-audio: caiaq: validate EP1 reply lengths

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix credit charge calculation for SMB2 QUERY_INFO

Perry Yuan <perry.yuan@amd.com>
    drm/amdgpu: flush pending RCU callbacks on module unload

Jetha Chan <jethachan@gmail.com>
    ASoC: amd: yc: Add Alienware m15 R7 AMD to DMIC quirk table

David Howells <dhowells@redhat.com>
    netfs: Fix decision whether to disallow write-streaming due to fscache use

David Howells <dhowells@redhat.com>
    cachefiles: Fix double fput

Yousef Alhouseen <alhouseenyousef@gmail.com>
    xen/gntalloc: validate grant count before allocation

Farhad Alemi <farhad.alemi@berkeley.edu>
    freevxfs: don't BUG() on unknown typed-extent type

Yousef Alhouseen <alhouseenyousef@gmail.com>
    xen/front-pgdir-shbuf: free grant reference head on errors

Qiang Liu <liuqiang@kylinos.cn>
    ksmbd: Fix acl.sd_buf memory leak and invalid sd_size error handling

Qiang Liu <liuqiang@kylinos.cn>
    ksmbd: fix n.data memory leak in ksmbd_vfs_set_dos_attrib_xattr

Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>
    drm/arm/komeda: fix error handling for clk_prepare_enable() and callers

Shubham Nayak <shubhamnayak392reborn@gmail.com>
    ALSA: hda/realtek: Add quirk for HP Victus 16-e0xxx (88EE) to enable mute LED

Qiang Liu <liuqiang@kylinos.cn>
    ksmbd: fix sd_ndr.data memory leak in ksmbd_vfs_set_sd_xattr

Florian Westphal <fw@strlen.de>
    netfilter: nf_conntrack_expect: zero at allocation time

Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>
    drm/arm/malidp: use clk_bulk API in runtime PM resume and suspend

Weiming Shi <bestswngs@gmail.com>
    btrfs: tree-checker: validate INODE_REF's namelen

Praveen Talari <praveen.talari@oss.qualcomm.com>
    spi: core: Abort active target transfer on controller suspend

Baojun Xu <baojun.xu@ti.com>
    ASoC: tas2781: Update default register address to TAS2563

Haoxiang Li <haoxiang_li2024@163.com>
    fbdev: pm2fb: unwind WC setup on probe failure

Kamlesh Chhetty <kamleshkc2002@gmail.com>
    ALSA: hda: Add Lenovo Legion 7i 16IAX7 17AA3874 quirk

Arnd Bergmann <arnd@arndb.de>
    eth: mlx5: fix macsec dependency

Adriana Stancu <adriana@arista.com>
    rtc: bq32000: add delay between RTC reads

Yu Kuai <yukuai@fygo.io>
    blk-cgroup: protect iterating blkgs with blkcg->lock in blkcg_print_stat()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    net: au1000: move free_irq out of the close-time spinlocked section

Pengpeng Hou <pengpeng@iscas.ac.cn>
    regulator: da9121: Use subvariant ids in the I2C table

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Use kstrtobool() to parse the ROM attribute input

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/proc: Fix race between pci_proc_init() and pci_bus_add_device()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: treat read-control opens as stat opens only for leases

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: break RH leases before delete-on-close

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: start file id allocation at 1

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: deny renaming directory with open children

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: apply create security descriptor first

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: treat unnamed DATA stream as base file

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use connection ClientGUID for lease lookup

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: align SMB2 oplock break ack handling

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate SMB2 lease create contexts

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix lease break and ack state handling

Alex Markuze <amarkuze@redhat.com>
    ceph: harden send_mds_reconnect and handle active-MDS peer reset

Tommy Huang <tommy_huang@aspeedtech.com>
    rtc: aspeed: add AST2700 compatible

Xue Lei <Xue.Lei@windriver.com>
    rtc: mv: add suspend/resume support for wakeup

Samuel Moelius <sam.moelius@trailofbits.com>
    f2fs: validate inline dentry name lengths before conversion

Chris Aherin <chrisaherin@gmail.com>
    ALSA: hda/realtek: Add quirk for Lenovo Yoga 7 16IAP7

Chen Cheng <chencheng@fnnas.com>
    md/raid5: let stripe batch bm_seq comparison wrap-safe

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    mailbox: imx: use devm_of_platform_populate()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    mailbox: imx: Add a channel shutdown field

Yu Kuai <yukuai@fygo.io>
    md/raid5: account discard IO

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    mailbox: imx: Use devm_pm_runtime_enable()

Peter Zijlstra <peterz@infradead.org>
    perf: Fix addr_filter_ranges lifetime

Hans Zhang <18255117159@163.com>
    PCI: plda: Protect root bus removal with rescan lock

Hans Zhang <18255117159@163.com>
    PCI: mediatek: Protect root bus removal with rescan lock

Hans Zhang <18255117159@163.com>
    PCI: rockchip: Protect root bus removal with rescan lock

Hans Zhang <18255117159@163.com>
    PCI: altera: Protect root bus removal with rescan lock

Hans Zhang <18255117159@163.com>
    PCI: iproc: Protect root bus removal with rescan lock

David Francis <David.Francis@amd.com>
    drm/amdkfd: Properly acquire queue buffers in CRIU restore

Jean-Louis Colaco <jean-louis.colaco@orange.fr>
    ALSA: usb-audio: Add quirk for YAMAHA CDS3000

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Use system unbound workqueue for soft IH ring

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: check find_first_zero_bit before __set_bit on kfd->doorbell_bitmap

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Let driver decide buffer size at AMDKFD_IOC_GET_DMABUF_INFO ioctl

Matthew Bystrin <dev.mbstr@gmail.com>
    mfd: rsmu: Add 8a34002 support

Piotr Kubik <piotr@kubik.pl>
    leds: trigger: gpio: Use GPIOD_FLAGS_BIT_NONEXCLUSIVE

Akashdeep Kaur <a-kaur@ti.com>
    mfd: tps65219: Make poweroff handler conditional on system-power-controller

Tobias Deiminger <tobias.deiminger@linutronix.de>
    leds: pca9532: Don't stop blinking for non-zero brightness

Yousef Alhouseen <alhouseenyousef@gmail.com>
    leds: uleds: Return -EFAULT on copy_to_user() failure

Galen Hassen <rwekyes@gmail.com>
    ALSA: hda/conexant: Add pin config quirk for Lenovo IdeaPad Slim 5 16AKP10

Jakub Kicinski <kuba@kernel.org>
    tls: reject the combination of TLS and sockmap

Ai Chao <aichao@kylinos.cn>
    ALSA: usb-audio: Add quirk flags for SC13A

guoqi0226 <guoqi0226@163.com>
    spi: Add NULL check for spi_get_device_id() in spi_get_device_match_data()

Rob Herring (Arm) <robh@kernel.org>
    gpio: pisosr: Read "ngpios" as u32

Arnd Bergmann <arnd@arndb.de>
    scsi: bfa: Reduce kernel stack usage in bfa_fcs_lport_fdmi_build_portattr_block()

Zhang Tianci <zhangtianci.1997@bytedance.com>
    fuse: set ff->flock only on success

Jiri Kosina <jikos@kernel.org>
    HID: hidpp: fix potential UAF in hidpp_connect_event()

Yung-Tse Cheng <mes900903@gmail.com>
    virtio-fs: avoid double-free on failed queue setup

Viktor Menshin <ripeeerr@gmail.com>
    ALSA: hda/realtek: Add quirk for Lenovo Xiaoxin 14 GT

David Timber <dxdt@dev.snart.me>
    exfat: fix handling of damaged volume in exfat_create_upcase_table()

Rosen Penev <rosenp@gmail.com>
    sparc: Disable compat support with LLD

Leo Yan <leo.yan@arm.com>
    bpftool: Pass host flags to bootstrap libbpf

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Tolerate i3c_master_add_i3c_dev_locked() failures in DAA

Fredric Cover <fredric.cover.lkernel@gmail.com>
    smb: client: fix races in cifsd thread creation

Alice Mikityanska <alice@isovalent.com>
    net/sched: act_csum: don't mangle UDP tunnel GSO packets

Maxime Bélair <maxime.belair@canonical.com>
    apparmor: propagate -ENOMEM correctly in unpack_table

Jijie Shao <shaojijie@huawei.com>
    net: hns3: improve the unused_tuple parameter setting

Agalakov Daniil <ade@amicon.ru>
    e1000e: limit endianness conversion to boundary words

Raf Dickson <rafdog35@gmail.com>
    vsock: use sk_acceptq_is_full() helper in all transports

Ido Schimmel <idosch@nvidia.com>
    ipv6: Honor oif when choosing nexthop for locally generated traffic

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    ptp: ocp: add shutdown callback

Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
    net: stmmac: xgmac2: disable RBUE in default RX interrupt mask

Rosen Penev <rosenp@gmail.com>
    sparc64: uprobes: add missing break

Chen Zhang <zhangchen01@kylinos.cn>
    Bluetooth: btusb: Add Realtek RTL8922AE VID/PID 0bda/d923

Nils Helmig <nils.helmig@web.de>
    Bluetooth: btusb: Add TP-Link UB600 for Realtek 8761BUV

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: rockchip: spdif: Restore regcache cache-only mode on sync failure

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: rockchip: rockchip_pdm: Reorder clock enable sequence

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: rockchip: rockchip_pdm: Handle runtime PM resume failures in set_fmt

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Add 50 ms delay before MAC init on BlazarIW

Samuel Moelius <sam.moelius@trailofbits.com>
    Bluetooth: L2CAP: validate connectionless PSM length

Cris <cxs1494089474@gmail.com>
    Bluetooth: btusb: Add support for TP-Link TL-UB250

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: MT7925: Add VID/PID 0e8d/8c38

Rong Zhang <i@rong.moe>
    Bluetooth: btmtk: Disable remote wakeup for MT7922/MT7925

Hrvoje Nuic <hrvoje.nuic@gmail.com>
    Bluetooth: btusb: Add Mercusys MA530 for Realtek RTL8761BUV

Chen Zhang <zhangchen01@kylinos.cn>
    Bluetooth: btusb: Add Realtek RTL8922AE VID/PID 0bda/d922

Ravindra <ravindra@intel.com>
    Bluetooth: btusb: Add support for Intel Lizard Peak 2 (0x8087:0x0040)

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: MT7922: Add VID/PID 0e8d/223c

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    spi: xilinx: let transfers timeout in case of no IRQ

Potin Lai <potin.lai.pt@gmail.com>
    hwmon: (pmbus/lm25066) Fix PMBus coefficients for LM5064/5066/5066i

Tze Yee Ng <tze.yee.ng@altera.com>
    dmaengine: dw-axi-dmac: fix PM for system sleep and channel alloc

Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>
    dmaengine: altera-msgdma: Use memcpy_toio for descriptor FIFO writes

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    PCI: Avoid SBR for Qualcomm WCN6855/WCN7850 WiFi, SDX62/SDX65 modems

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Add Dell Latitude 7530 to fan control whitelist

Dave Carey <carvsdriver@gmail.com>
    HID: multitouch: Honor ContactCount for Yoga Book 9 to suppress ghost contacts

Yuho Choi <dbgh9129@gmail.com>
    sctp: Unwind address notifier registration on failure

Mohamed Khalfella <mkhalfella@purestorage.com>
    nvme-fc: Do not cancel requests in io target before it is initialized

Nikolay Metchev <nikolaymetchev@gmail.com>
    platform/x86: intel-hid: Add HP ProBook x360 440 G1 to button_array_table

Xu Rao <raoxu@uniontech.com>
    ata: libata-pmp: add JMicron JMS562 quirk

Moritz Baron <moritz.baron@stud.uni-hannover.de>
    ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14IRH8

Furst Blumier <seal@furst.blue>
    ALSA: hda/realtek: Add quirk for HP 255 15.6 inch G9 Notebook PC

Vamsi Attunuru <vattunuru@marvell.com>
    vdpa/octeon_ep: Use 4 bytes for mailbox signature

Evgenii Burenchev <evg28bur@yandex.ru>
    vdpa/ifcvf: handle dev_set_name() failure in ifcvf_vdpa_dev_add()

Guangshuo Li <lgs201920130244@gmail.com>
    net: lan966x: restore RX state on reload failure

George Moussalem <george.moussalem@outlook.com>
    net: dsa: qca8k: Add support for force mode for fixed link topology

Ben Maurer <bmaurer@meta.com>
    btrfs: use lockless read in nr_cached_objects shrinker callback

Anand Jain <asj@kernel.org>
    btrfs: use on-disk uuid for s_uuid in temp_fsid mounts

Kory Maincent <kory.maincent@bootlin.com>
    hwmon: (adt7462) Add of_match_table to support devicetree

Shubham Chakraborty <chakrabortyshubham66@gmail.com>
    hwmon: (raspberrypi) Fix delayed-work teardown race

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    PCI: Avoid FLR for MediaTek MT7925 WiFi

Lu Yao <yaolu@kylinos.cn>
    fbcon: don't suspend/resume when vc is graphics mode

KangNing Liao <lkangn.kernel@gmail.com>
    btrfs: protect sb_write_pointer() with invalidate lock

Breno Leitao <leitao@debian.org>
    netconsole: take target_cleanup_list_lock in drop_netconsole_target()

Jiajia Liu <liujiajia@kylinos.cn>
    wifi: mt76: transform aspm_conf for pci_disable_link_state

Javier Tia <floss@jetm.me>
    wifi: mt76: mt7925: add 320MHz bandwidth to bss_rlm_tlv

Javier Tia <floss@jetm.me>
    wifi: mt76: mt7925: populate EHT 320MHz MCS map in sta_rec

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7925: add Netgear A8500 USB device ID

Luis de Carlos <reskoldo73@gmail.com>
    platform/x86: msi-ec: Add support for MSI Pulse GL66 12th Gen

Javier Tia <floss@jetm.me>
    wifi: mt76: mt7925: handle 320MHz bandwidth in RXV and TXS

Gleb Sonichev <sonichev555@gmail.com>
    platform/x86: dell-laptop: add Inspiron N5110 to touchpad LED quirk table

Chuck Lever <chuck.lever@oracle.com>
    tls: Flush backlog before waiting for a new record

Rosen Penev <rosenp@gmail.com>
    net: ibm: emac: mal: fix potential system hang in mal_remove()

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: quiesce DMA before freeing resources

Al Viro <viro@zeniv.linux.org.uk>
    configfs_depend_prep(): pass configfs_dirent instead of dentry

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Create ODP EQ for non-pinned dmabuf MRs

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Add request-pool slack for delayed recycling

Aurelien DESBRIERES <aurelien@hackers.camp>
    RDMA/rtrs-srv: Fix integer underflow in process_read and process_write

Tuo Li <islituo@gmail.com>
    ASoC: mediatek: mt8365-afe-pcm: fix possible NULL-pointer dereferences in mt8365_afe_suspend()

Dai Ngo <dai.ngo@oracle.com>
    NFS: fix eof updates after NFSv4.2 fallocate/zero-range

Zhang Cen <rollkingzzc@gmail.com>
    btrfs: tree-checker: validate names in ROOT_REF and ROOT_BACKREF

ZhengYuan Huang <gality369@gmail.com>
    btrfs: balance: fix potential bg lookup failure in btrfs_may_alloc_data_chunk()

Osama Abdelkader <osama.abdelkader@gmail.com>
    riscv: panic if IRQ handler stacks cannot be allocated

Rosen Penev <rosenp@gmail.com>
    netfilter: nf_conntrack: use get_unaligned_be32() in tcp_sack()

Ruoyu Wang <ruoyuw560@gmail.com>
    ALSA: es18xx: check control allocation before private data setup

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    net: microchip: sparx5: clean up PSFP resources on flower setup failure

Maoyi Xie <maoyixie.tju@gmail.com>
    hsr: broadcast netlink notifications in the device's net namespace

Guangshuo Li <lgs201920130244@gmail.com>
    net: cpsw_new: unregister devlink on port registration failure

Dawei Feng <dawei.feng@seu.edu.cn>
    bpf: NUL-terminate replaced sysctl value

Li RongQing <lirongqing@baidu.com>
    RDMA/mlx5: Fix state and counter desync on loopback enable failure

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/umem: Be careful about boundary conditions in ib_umem_find_best_pgsz()

Thiyagarajan Pandiyan <thiyagarajan@aerlync.com>
    wifi: nl80211: Increase ie_len size to prevent truncated IEs in new peer notifications

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ipv6: use READ_ONCE() for bindv6only default in inet6_create()

Yongqiang Sun <Yongqiang.Sun@amd.com>
    drm/amdkfd: Unwind debug trap enable on copy_to_user failure

Rosen Penev <rosenp@gmail.com>
    ipmi: si: Use platform_get_irq_optional() to retrieve interrupt

Andrei Faleichyk <andrei.faleichyk@noogadev.com>
    ALSA: hda/realtek: Add quirk for ASUS VivoBook X509DAP

Michael Walle <mwalle@kernel.org>
    clk: keystone: don't cache clock rate

Shay Drory <shayd@nvidia.com>
    net/mlx5: E-Switch, align disable sequence with switchdev-to-legacy transition

Cyrill Gorcunov <gorcunov@gmail.com>
    RDMA/irdma: Fix typo in SQ completions generation

Shay Drory <shayd@nvidia.com>
    net/mlx5e: Verify unique vhca_id count instead of range

Shiwu Zhang <shiwu.zhang@amd.com>
    drm/amdgpu: fix buffer overflow during vBIOS update

Asad Kamal <asad.kamal@amd.com>
    drm/amd/pm: bound pp_dpm_set_pp_table() memcpy

Stanley.Yang <Stanley.Yang@amd.com>
    drm/amdgpu: harden FRU PIA parsing with bounded helpers

Alysa Liu <Alysa.Liu@amd.com>
    drm/amdkfd: fix UAF race in destroy_queue_cpsch

Samson Tam <Samson.Tam@amd.com>
    drm/amd/display: Check for sharpening case when calculating max vtaps for scaler

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Prevent queuing new commands if xhci is inaccessible

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Improve Soft Retries after short transfers

Priyansh Jain <priyansh.jain@oss.qualcomm.com>
    thermal/drivers/qcom/tsens: Atomic temperature read with hardware-guided retries

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: fix handling of NAPI on the remove path

David Yang <mmyangfl@gmail.com>
    net: dsa: sja1105: flower: reject cross-chip redirect

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: fix the error path in dpaa2_switch_rx()

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: rework FDB management on the bridge leave path

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: seq: oss: Reject reads that cannot fit the next event

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: codecs: rk3328: Use managed GPIO and clock helpers

Alessandro Schino <7991aleschino@gmail.com>
    ntfs3: fix out-of-bounds read in ntfs_dir_emit() and hdr_find_e()

ZhengYuan Huang <gality369@gmail.com>
    fs/ntfs3: validate index entry key bounds

Yao Sang <sangyao@kylinos.cn>
    nvme: refresh multipath head zoned limits from path limits

ZhengYuan Huang <gality369@gmail.com>
    fs/ntfs3: preserve non-DOS attribute bits in system.dos_attrib

Adriano Vero <adri.vero.dev@gmail.com>
    powerpc/fadump: Add timeout to RTAS busy-wait loops

Simon Xue <xxm@rock-chips.com>
    iommu/rockchip: disable fetch dte time limit

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    net: wwan: t7xx: Add delay between MD and SAP suspend

Wentao Liang <vulab@iscas.ac.cn>
    net: qrtr: fix node refcount leak on ctrl packet alloc failure

Chen Pei <cp0613@linux.alibaba.com>
    ACPI: PCI: Clear _DEP dependencies after PCI root bridge attach

Chen Pei <cp0613@linux.alibaba.com>
    ACPI: scan: Honor _DEP for ACPI0016 PCI/CXL host bridge

liyouhong <liyouhong@kylinos.cn>
    ata: ahci: fail probe if BAR too small for claimed ports

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: pcm3168a: Drop CONFIG_PM-conditional preproc directive

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6apm: return error code to consumers on failures

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath11k: fix invalid data access in ath11k_dp_rx_h_undecap_nwifi

Rosen Penev <rosenp@gmail.com>
    net: ibm: emac: Reserve VLAN header in MJS limit

Daniel Borkmann <daniel@iogearbox.net>
    libbpf: Also reset {insn,data}_cur on realloc failure

Sanjay Chitroda <sanjayembeddedse@gmail.com>
    iio: accel: mma8452: switch to non-devm request_threaded_irq()

Rik van Riel <riel@surriel.com>
    perf/ftrace: Fix WARNING in __unregister_ftrace_function

Miao Li <limiao@kylinos.cn>
    iio: light: stk3310: Deal with the ps interrupt issue in PM

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    mmc: renesas_sdhi: Add OF entry for RZ/G2E SoC

Karl Mehltretter <kmehltretter@gmail.com>
    tracing: Disable KCOV instrumentation for trace_irqsoff.o

Ion Agorria <ion@agorria.com>
    ARM: tegra: p880: Lower CPU thermal limit

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    mmc: renesas_sdhi: Add OF entry for RZ/G2N SoC

Osama Abdelkader <osama.abdelkader@gmail.com>
    mmc: davinci: fix mmc_add_host order in probe

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: only handle alert events when the peripheral is attached

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: page poisoning fix

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: dmi-quirks: Disable ghost Realtek devices

Kartik Rajput <kkartik@nvidia.com>
    soc/tegra: fuse: Register nvmem lookups at probe

Tiezhu Yang <yangtiezhu@loongson.cn>
    libbpf: Add __NR_bpf definition for LoongArch

Timur Tabi <ttabi@nvidia.com>
    drm/nouveau/bios: skip the IFR header if present

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: catpt: Complete coredump handling

Alexandre Courbot <acourbot@nvidia.com>
    scripts: modpost: detect and report truncated buf_printf() output

shayderrr <darknessshayder@gmail.com>
    host1x: bus: Fix missing ops null check in error teardown

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    pinctrl: renesas: rzv2m: Use -ENOTSUPP instead of -EOPNOTSUPP

Wei Qisen <weixiansen574@163.com>
    net: sfp: add quirk for OEM 2.5G optical modules

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: rework hfsplus_readdir() logic

ikaros <void0red@gmail.com>
    ACPICA: add boundary checks in two places

ikaros <void0red@gmail.com>
    ACPICA: Enhance buffer validation in acpi_ut_walk_aml_resources()

Weiming Shi <bestswngs@gmail.com>
    ACPICA: Fix NULL pointer dereference in acpi_ns_custom_package()

ikaros <void0red@gmail.com>
    ACPICA: Enhance OEM ID and Table ID validation in acpi_ex_load_table_op()

ikaros <void0red@gmail.com>
    ACPICA: Add validation for node in acpi_ns_build_normalized_path()

ikaros <void0red@gmail.com>
    ACPICA: Add package limit checks in parser functions

ikaros <void0red@gmail.com>
    ACPICA: validate handler object type in two places

ikaros <void0red@gmail.com>
    ACPICA: Improve argument parsing in acpi_ps_get_next_simple_arg()

ikaros <void0red@gmail.com>
    ACPICA: Fix integer overflow in acpi_ex_opcode_3A_1T_1R() (mid_op)

ikaros <void0red@gmail.com>
    ACPICA: Prevent adding invalid references

ikaros <void0red@gmail.com>
    ACPICA: validate byte_count in acpi_ps_get_next_package_length()

ikaros <void0red@gmail.com>
    ACPICA: add boundary checks in acpi_ps_get_next_field()

ikaros <void0red@gmail.com>
    ACPICA: Fix use-after-free in acpi_ds_terminate_control_method()

ikaros <void0red@gmail.com>
    ACPICA: Fix condition check in acpi_ps_parse_loop()

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Initialize dsc_caps to 0

Jeremy Klarenbeek <jeremy.klarenbeek99@gmail.com>
    drm/amd/pm/si: Fix updating clock limits from power states

Imre Deak <imre.deak@intel.com>
    drm/dp: Add DSC virtual DPCD quirk for Realtek MST branch device

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    net: thunderx: fix PTP device ref leak in nicvf_probe()

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv6: addrconf: fix temp address generation after prefix deprecation

Luka Gejak <luka.gejak@linux.dev>
    net: hsr: require valid EOT supervision TLV

Uwe Küchler <uwe@kuechler.org>
    ALSA: usb-audio: Add quirk for Novation Mininova

Mostafa Saleh <smostafa@google.com>
    irqchip/gic-v4: Don't advertise VLPIs if no ITS is probed

Stepan Ionichev <sozdayvek@gmail.com>
    iio: adc: qcom-spmi-iadc: balance enable_irq_wake() on driver unbind

Rosen Penev <rosenp@gmail.com>
    mips: cps: Assemble jr.hb with an R2 ISA level

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    drm/panel: simple: Add AM-1280800W8TZQW-T00H

Sumeet Pawnikar <sumeet4linux@gmail.com>
    powercap: intel_rapl: Fix memory leak in rapl_add_package_cpuslocked()

Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>
    thermal/drivers/tegra/soctherma: Switch to devm cooling device registration

Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>
    clk: socfpga: agilex: implement l3_main_free_clk

Heiko Carstens <hca@linux.ibm.com>
    s390/zcore: Removed unused variables

Jiayuan Chen <jiayuan.chen@linux.dev>
    rds: annotate data-race around rs_seen_congestion

Maoyi Xie <maoyixie.tju@gmail.com>
    rds: filter RDS_INFO_* getsockopt by caller's netns

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: seq: Remove arbitrary prioq insertion limit

Chenguang Zhao <zhaochenguang@kylinos.cn>
    netlabel: fix IPv6 unlabeled address add error handling

Dian-Syuan Yang <dian_syuan0116@realtek.com>
    wifi: rtw89: pci: enable LTR based on pcie control register

Zqiang <qiang.zhang@linux.dev>
    rcu-tasks: Fix possible boot-time tests failed for the call_rcu_tasks()

Venkat Rao Bagalkote <venkat88@linux.ibm.com>
    char/nvram: Remove redundant nvram_mutex

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-sha204a - remove sysfs group before hwrng

Christian Marangi <ansuelsmth@gmail.com>
    usb: host: add ARCH_AIROHA in XHCI MTK dependency

Marco Felsch <m.felsch@pengutronix.de>
    serial: 8250: fix possible ISR soft lockup

Maoyi Xie <maoyixie.tju@gmail.com>
    usb: gadget: aspeed_udc: avoid past-the-end iterator in dequeue

Dave Carey <carvsdriver@gmail.com>
    USB: cdc-acm: start bulk-IN polling when ALWAYS_POLL_CTRL is set

Stepan Ionichev <sozdayvek@gmail.com>
    usb: gadget: goku_udc: avoid NULL deref of dev->driver in INT_USBRESET log

Oliver Neukum <oneukum@suse.com>
    usb: core: hcd: fix possible deadlock in rh control transfers

Adrian Wowk <dev@adrianwowk.com>
    usbip: vhci_hcd: fix NULL deref in status_show_vhci

Nikhil Chatterjee <nikhilc1527@gmail.com>
    HID: bpf: Add Huion Inspiroy Frego M button quirk

Christoph Hellwig <hch@lst.de>
    isofs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    omfs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    hpfs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    jfs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    qnx4: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    minix: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    bfs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    affs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    ntfs3: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    befs: handle set_blocksize failures

Thomas Lin <thomas_lin@lecomputing.com>
    spi: dw-mmio: Add ACPI ID LECA0002 for LECARC SoCs

Allison Henderson <achender@kernel.org>
    net/rds: Don't sleep inside rds_ib_conn_path_shutdown

Eric Dumazet <edumazet@google.com>
    net/sched: sch_drr: make cl->quantum lockless

Eric Dumazet <edumazet@google.com>
    net: bridge: remove stale rcu_barrier() in br_multicast_dev_del()

Jan Volckaert <janvolck@gmail.com>
    net: usb: qmi_wwan: add MeiG SRM813Q

Maurizio Lombardi <mlombard@redhat.com>
    nvme-core: align fabrics_q teardown with admin_q in nvme_free_ctrl

Yury Norov <ynorov@nvidia.com>
    bitfield: wire __bf_shf to __builtin_ctzll

Gil Fine <gil.fine@linux.intel.com>
    thunderbolt: Verify Router Ready bit is set after router enumeration

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: don't call ieee80211_handle_reconfig_failure when not needed

Gil Fine <gil.fine@linux.intel.com>
    thunderbolt: Increase timeout for Configuration Ready bit

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Validate BASE_ERROR_EVENT payload size

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Validate SENSOR_UPDATE payload size

Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
    thunderbolt: Improve multi-display DisplayPort tunnel allocation

Pooja Katiyar <pooja.katiyar@intel.com>
    thunderbolt: Don't access path config space on Lane 1 adapters in tb_switch_reset_host()

Ido Schimmel <idosch@nvidia.com>
    bridge: Add missing READ_ONCE() annotations around FDB destination port

Candice Li <candice.li@amd.com>
    drm/amdgpu: validate and share PSP fw_pri_buf copies via psp_copy_fw

Pierre Barre <pierre@barre.sh>
    9p: use kvzalloc for readdir buffer

Brajesh Gupta <brajesh.gupta@imgtec.com>
    drm/imagination: Populate FW common context ID before passing to the FW

Leonardo Bras <leo.bras@arm.com>
    arm64/daifflags: Make local_daif_*() helpers __always_inline

Pierre Barre <pierre@barre.sh>
    9p: invalidate readdir buffer on seek

Anna Maniscalco <anna.maniscalco2000@gmail.com>
    iommu: arm-smmu-qcom: Ensure smmu is powered up in set_ttbr0_cfg

Andrea Righi <arighi@nvidia.com>
    sched/fair: Reject misfit pulls onto busy SMT siblings on asym-capacity

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usx2y: Drain pending US-428 pipe-4 output commands

David Francis <David.Francis@amd.com>
    drm/amdkfd: Check bounds on allocate_doorbell

Sunday Clement <Sunday.Clement@amd.com>
    drm/amdkfd: Fix OOB memory exposure in get_wave_state()

David Francis <David.Francis@amd.com>
    drm/amdkfd: Check bounds for allocate_sdma_queue restore_sdma_id

Bjorn Helgaas <helgaas@kernel.org>
    PCI: Wait for device readiness after D3hot -> D0uninitialized transition

Joonwon Kang <joonwonkang@google.com>
    mailbox: Make mbox_send_message() return error code when tx fails

Christoph Hellwig <hch@lst.de>
    iomap: don't make REQ_POLLED imply REQ_NOWAIT

Luca Leonardo Scorcia <l.scorcia@gmail.com>
    drm/mediatek: dsi: Add compatible for mt8167-dsi

Chenguang Zhao <zhaochenguang@kylinos.cn>
    RDMA/mlx5: Use QP port when decoding responder CQEs

Alessandro Baldi <baldovic@virgilio.it>
    media: imon: Add iMON VFD HID OEM v1.2 key mappings

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - add support for atecc608b

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: Intel: sof_sdw: append dai type to dai link name unconditionally

Lukas Wunner <lukas@wunner.de>
    crypto: ecc - Unbreak the build on arm with CONFIG_KASAN_STACK=y

Kumar Meiyappan <kumar.meiyappan@microchip.com>
    scsi: pm8001: Reject non-fatal dump when controller is crashed

Kumar Meiyappan <kumar.meiyappan@microchip.com>
    scsi: pm8001: Reject firmware update in fatal error state

Alexey Klimov <alexey.klimov@linaro.org>
    clk: samsung: exynos850: mark APM I3C clocks as critical

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    soundwire: intel: Move suspend tracking from trigger to pm suspend

Pengpeng Hou <pengpeng@iscas.ac.cn>
    drivers/of: validate status properties in reconfig state changes

Stefan Berger <stefanb@linux.ibm.com>
    integrity: Check for NULL returned by asymmetric_key_public_key

Mieczyslaw Nalewaj <namiltd@yahoo.com>
    net: dsa: realtek: rtl8365mb: add support for RTL8367SB

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: phy: check length before parsing PHY status IE

Dave Carey <carvsdriver@gmail.com>
    HID: multitouch: Fix Yoga Book 9 14IAH10 touchscreen misclassification

Arash Golgol <arash.golgol@gmail.com>
    media: video-i2c: use vb2_video_unregister_device on driver removal

Ricardo Ribalda <ribalda@chromium.org>
    media: chips-media: wave5: Add range checks for dec_output_info

Sophie D <patches@scd31.com>
    drm/gud: Add RCade Display Adapter VID/PID pair

chunzhi.lin <linchunzhi0@gmail.com>
    net: phy: motorcomm: use device properties for firmware tuning

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: rework hfsplus_readdir() logic

Florian Eckert <fe@dev.tdt.de>
    PCI: intel-gw: Enable clock before PHY init

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Fix CRC open failure during active rendering

Brodie Abrew <brodie_abrew@selinc.com>
    platform/x86: sel3350-platform: Retain LED state on load and unload

Stepan Ionichev <sozdayvek@gmail.com>
    mmc: davinci: avoid NULL deref of host->data in IRQ handler

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: core: Add validation for host-provided max_segs

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: Resolve kb_wake_angle visibility race

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: HWS, Handle destroying table that has a miss table

Mark Pearson <mpearson-lenovo@squebb.ca>
    watchdog: lenovo_se10_wdt: Fix use-after-free and resource leak risk

Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>
    watchdog: imx7ulp_wdt: Keep WDOG running until A55 enters WFI on i.MX94

Mark Pearson <mpearson-lenovo@squebb.ca>
    watchdog: lenovo_se10_wdt: Add support for SE10 Gen 2 platform

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    ASoC: ti: omap3pandora: update board check to use DT compatible

Arnd Bergmann <arnd@arndb.de>
    media: qcom: camss: avoid format string warning

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Add CAP_SYS_ADMIN check to __resource_resize_store()

Ziyi Guo <n7l8m4@u.northwestern.edu>
    dlm: add usercopy whitelist to dlm_cb cache

Parth Pancholi <parth.pancholi@toradex.com>
    drm/bridge: tc358768: Set pre_enable_prev_first for reverse order

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: cpg-mssr: Add number of clock cells check

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: omap - add omap_des_unregister_algs helper

Ruoyu Wang <ruoyuw560@gmail.com>
    crypto: ixp4xx - fix buffer chain unwind on allocation failure

Justin Lai <justinlai0215@realtek.com>
    rtase: Fix flow control configuration

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: explicitly disable FTM responder on AP stop

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    media: em28xx-video: fix missing res_free() on init_usb_xfer failure

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable .rmu_disable() for 6320 family

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: define .pot_clear() for 6321

Ben Reed <Ben.Reed@microchip.com>
    PCI: switchtec: Add Gen6 Device IDs

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix number of g1 interrupts for 6320 family

Zhaoyang Yu <2426767509@qq.com>
    media: dm1105: fix missing error check for dma_alloc_coherent

David Heidelberg <david@ixit.cz>
    drm/panel: Enable GPIOLIB for panels which uses functions from it

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Prefer ROM BAR for default VGA device

Ovidiu Bunea <ovidiu.bunea@amd.com>
    drm/amd/display: Find link encoder for flexible DIG mapping cases

Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
    thunderbolt: Don't create multiple DMA tunnels on firmware connection manager

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Set tb->root_switch to NULL when domain is stopped

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Keep the domain reference while processing hotplug

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Keep XDomain reference during the lifetime of a service

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Release request if tb_cfg_request() fails in __tb_xdomain_response()

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Don't disable lane adapter if XDomain lane bonding isn't possible

Gil Fine <gil.fine@linux.intel.com>
    thunderbolt: Avoid reserved fields in path config space for USB4 routers

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Purge based on the cdev's online status

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    net: mana: hardening: Reject zero max_num_queues from MANA_QUERY_VPORT_CONFIG

Riccardo Boninsegna <rboninsegna2@gmail.com>
    media: rc: mceusb: Add support for 04eb:e033

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    spi: spi-qcom-qspi: Fix incomplete error handling in runtime PM

Brandon Brnich <b-brnich@ti.com>
    media: chips-media: wave5: Fix Reports from Kernel Lock Validator

Pengpeng Hou <pengpeng@iscas.ac.cn>
    soundwire: validate DT compatible before parsing it

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: intel_auxdevice: Add cs42l43b to wake_capable_list

Danielle Ratson <danieller@nvidia.com>
    bridge: Do not suppress ARP probes and DAD NS unconditionally

Siew Chin Lim <elly.siew.chin.lim@intel.com>
    firmware: stratix10-svc: change get provision data to async SMC call

Marco Elver <elver@google.com>
    kcsan: Silence -Wmaybe-uninitialized when calling __kcsan_check_access()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl-asoc-card: reduce WM8904 PLL ratio to meet frequency limit

Dian-Syuan Yang <dian_syuan0116@realtek.com>
    wifi: rtw89: disable CSI STBC for VHT 160MHz

Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
    wifi: rtw88: Add NULL check for chip->edcca_th in rtw_fw_adaptivity_result()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: always allow transmitting null-data on TXQs

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: reject beacons with bad HE operation

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix issue of direct writes beyond end-of-file

Yuqi Xu <xuyuqiabc@gmail.com>
    wifi: cfg80211: reject duplicate wiphy cipher suite entries

Lukas Wunner <lukas@wunner.de>
    PCI: Stop setting cached power state to 'unknown' on unbind

Thomas Weißschuh <linux@weissschuh.net>
    tools/nolibc: avoid call to wcslen() in _start_c() inserted by clang

Hirokazu Honda <hiroh@chromium.org>
    tee: optee: Allow MT_NORMAL_TAGGED shared memory

Xu Yang <xu.yang_2@nxp.com>
    usb: gadget: udc: skip pullup() if already connected

Goldwyn Rodrigues <rgoldwyn@suse.de>
    ima: return error early if file xattr cannot be changed

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Propagate write errors in generic mixer put callbacks

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Handle RZ/V2H(P) IOLH configuration in PM cache

Kevin Tung <kevin.tung.openbmc@gmail.com>
    iio: adc: rtq6056: add i2c_device_id support

Jie Wang <jie.wang@intel.com>
    gfs2: move quota_init qc iterator increment

Jie Wang <jie.wang@intel.com>
    gfs2: fix quota init duplicate scan

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Check SMUv13.0.6/12 metrics integrity

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/panel: jadard-jd9365da-h3: set prepare_prev_first

Dominik Kaszewski <dominik.kaszewski@amd.com>
    drm/amd/display: Fix DPMS using partially updated pipe context

Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
    drm: rz-du: Ensure correct suspend/resume ordering with VSP

Ioana Ciornei <ioana.ciornei@nxp.com>
    bus: fsl-mc: wait for the MC firmware to complete its boot

Boris Brezillon <boris.brezillon@collabora.com>
    drm/gem: Consider GEM object reclaimable if shrinking fails

Abdifatah Suruur <suruurism@gmail.com>
    ksmbd: fix use-after-free in oplock break notification


-------------

Diffstat:

 Documentation/filesystems/nfs/reexport.rst         |  10 +-
 Documentation/hwmon/hwmon-kernel-api.rst           |   3 +
 Documentation/netlink/specs/rt_link.yaml           |   2 +
 Documentation/networking/ethtool-netlink.rst       |   2 +-
 Documentation/networking/scaling.rst               |  15 +-
 Documentation/scheduler/sched-ext.rst              |   2 +-
 Documentation/sound/designs/midi-2.0.rst           |  11 +
 MAINTAINERS                                        |   4 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts       |  13 +
 arch/arm/kernel/hw_breakpoint.c                    |  11 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |   6 +-
 arch/arm/mm/cache-feroceon-l2.c                    |   2 +-
 arch/arm/mm/cache-tauros2.c                        |   2 +-
 arch/arm/mm/fault.c                                |  12 +-
 arch/arm64/boot/dts/qcom/sc8180x.dtsi              |  16 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |  64 +--
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |  12 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sm8650.dtsi               |   8 +-
 arch/arm64/include/asm/daifflags.h                 |  10 +-
 arch/arm64/include/asm/fixmap.h                    |   6 +-
 arch/arm64/include/asm/kprobes.h                   |   6 +
 arch/arm64/kernel/machine_kexec.c                  |   3 +-
 arch/arm64/kernel/probes/kprobes.c                 |  23 +-
 arch/mips/kernel/cps-vec.S                         |   6 +
 arch/powerpc/kernel/eeh_driver.c                   |   2 -
 arch/powerpc/kexec/file_load_64.c                  |   2 +-
 arch/powerpc/kvm/book3s_hv.c                       |   4 +-
 arch/powerpc/perf/core-book3s.c                    |   8 +-
 arch/powerpc/platforms/ps3/repository.c            |   5 +-
 arch/powerpc/platforms/pseries/kexec.c             |  13 +-
 arch/powerpc/platforms/pseries/rtas-fadump.c       |  80 +--
 arch/powerpc/platforms/pseries/rtas-fadump.h       |   6 +
 arch/riscv/kernel/irq.c                            |  22 +-
 arch/s390/boot/ipl_parm.c                          |  26 +-
 arch/s390/boot/physmem_info.c                      |   2 +-
 arch/s390/crypto/aes_s390.c                        |  87 ++--
 arch/s390/kernel/ipl.c                             |  12 +-
 arch/s390/kernel/perf_pai_crypto.c                 |   3 +-
 arch/s390/kernel/perf_pai_ext.c                    |   3 +-
 arch/s390/kernel/vtime.c                           |  25 +-
 arch/s390/net/bpf_jit_comp.c                       |  11 -
 arch/sparc/Kconfig                                 |   1 +
 arch/sparc/kernel/uprobes.c                        |   1 +
 arch/x86/crypto/aria-aesni-avx2-asm_64.S           |   6 +
 arch/x86/crypto/aria-gfni-avx512-asm_64.S          |   3 +
 arch/x86/events/amd/brs.c                          |   3 +-
 arch/x86/events/amd/ibs.c                          |   3 +-
 arch/x86/events/amd/lbr.c                          |   3 +-
 arch/x86/events/core.c                             |   5 +-
 arch/x86/events/intel/core.c                       |   4 +-
 arch/x86/events/intel/ds.c                         | 208 +++++---
 arch/x86/events/intel/lbr.c                        |   3 +-
 arch/x86/events/perf_event.h                       |  14 +-
 arch/x86/include/asm/alternative.h                 |   2 +-
 arch/x86/include/asm/barrier.h                     |  10 +-
 arch/x86/include/asm/cmpxchg.h                     |   4 +-
 arch/x86/include/asm/cmpxchg_32.h                  |   4 +-
 arch/x86/include/asm/edac.h                        |   2 +-
 arch/x86/include/asm/perf_event.h                  |  16 +-
 arch/x86/include/asm/pgtable.h                     |   2 +-
 arch/x86/include/asm/sync_bitops.h                 |  12 +-
 arch/x86/kvm/svm/sev.c                             | 243 +++++----
 arch/x86/kvm/svm/svm.c                             |  33 +-
 arch/x86/kvm/svm/svm.h                             |  23 +-
 block/blk-cgroup.c                                 |  13 +-
 crypto/Makefile                                    |   5 +
 drivers/accel/ivpu/ivpu_fw_log.c                   |  87 ++--
 drivers/accel/ivpu/ivpu_gem.h                      |  14 +-
 drivers/accel/ivpu/ivpu_ipc.c                      |   7 +-
 drivers/accel/qaic/qaic_control.c                  |  46 +-
 drivers/acpi/acpi_apd.c                            |   7 +
 drivers/acpi/acpi_tad.c                            | 188 ++++---
 drivers/acpi/acpica/dsmethod.c                     |  43 ++
 drivers/acpi/acpica/evhandler.c                    |  11 +
 drivers/acpi/acpica/exconfig.c                     |  26 +-
 drivers/acpi/acpica/exoparg3.c                     |   2 +-
 drivers/acpi/acpica/nsnames.c                      |   6 +
 drivers/acpi/acpica/nsprepkg.c                     |   7 +
 drivers/acpi/acpica/nsxfname.c                     |   4 +
 drivers/acpi/acpica/psargs.c                       | 134 ++++-
 drivers/acpi/acpica/psloop.c                       |  30 +-
 drivers/acpi/acpica/psparse.c                      |  14 +
 drivers/acpi/acpica/utcopy.c                       |  10 +-
 drivers/acpi/acpica/utresrc.c                      |  30 ++
 drivers/acpi/apei/ghes.c                           |  24 +-
 drivers/acpi/pci_root.c                            |   4 +
 drivers/acpi/processor_driver.c                    |   2 +-
 drivers/acpi/scan.c                                |   1 +
 drivers/ata/ahci.c                                 |  22 +
 drivers/ata/libata-core.c                          |  10 +
 drivers/ata/libata-pmp.c                           |   7 +-
 drivers/base/core.c                                |  91 +++-
 drivers/block/sunvdc.c                             |  17 +
 drivers/block/zram/zram_drv.c                      |  62 +--
 drivers/block/zram/zram_drv.h                      |   5 +-
 drivers/bluetooth/btintel.c                        |  39 +-
 drivers/bluetooth/btintel_pcie.c                   |  22 +-
 drivers/bluetooth/btmtk.c                          |  11 +
 drivers/bluetooth/btmtk.h                          |   1 +
 drivers/bluetooth/btqcomsmd.c                      |   6 +-
 drivers/bluetooth/btrtl.c                          |  21 +-
 drivers/bluetooth/btusb.c                          |  47 +-
 drivers/bluetooth/hci_mrvl.c                       |   3 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |  46 ++
 drivers/char/ipmi/ipmi_si_platform.c               |   5 +-
 drivers/char/nvram.c                               |  16 +-
 drivers/char/virtio_console.c                      |  21 +-
 drivers/clk/keystone/sci-clk.c                     |   8 +
 drivers/clk/renesas/renesas-cpg-mssr.c             |   3 +
 drivers/clk/samsung/clk-exynos850.c                |   5 +-
 drivers/clk/socfpga/clk-agilex.c                   |   2 +
 drivers/clk/ux500/clk-prcmu.c                      |  20 +-
 drivers/clk/ux500/u8500_of_clk.c                   |   2 +-
 drivers/clocksource/timer-orion.c                  |   2 +-
 drivers/cpufreq/apple-soc-cpufreq.c                |  36 +-
 drivers/cpufreq/cpufreq.c                          |   6 +-
 drivers/cpuidle/cpuidle-ux500.c                    |   6 +-
 drivers/crypto/atmel-ecc.c                         |  11 +-
 drivers/crypto/atmel-sha204a.c                     |   3 +-
 drivers/crypto/ccp/sev-dev.c                       |   2 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |  36 +-
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c        |  25 +-
 drivers/crypto/omap-des.c                          |  26 +-
 .../crypto/virtio/virtio_crypto_akcipher_algs.c    |  81 ++-
 .../crypto/virtio/virtio_crypto_skcipher_algs.c    |  13 +-
 drivers/cxl/core/Makefile                          |   2 +
 drivers/cxl/core/core.h                            |  12 +
 drivers/cxl/core/pci.c                             | 318 ------------
 drivers/cxl/core/ras.c                             | 186 +++++++
 drivers/cxl/core/ras_rch.c                         | 136 +++++
 drivers/cxl/pci.c                                  |   1 -
 drivers/dma/altera-msgdma.c                        |  24 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |  11 +-
 drivers/edac/amd64_edac.c                          |   2 +
 drivers/edac/edac_device_sysfs.c                   |  11 +-
 drivers/edac/igen6_edac.c                          |  27 +-
 drivers/firmware/arm_scmi/base.c                   |  15 +-
 drivers/firmware/arm_scmi/sensors.c                |  10 +-
 drivers/firmware/efi/cper.c                        |   5 +-
 drivers/firmware/efi/cper_cxl.c                    |  38 +-
 drivers/firmware/efi/cper_cxl.h                    |  54 +-
 drivers/firmware/stratix10-svc.c                   |   4 +-
 drivers/gpio/gpio-dwapb.c                          |  17 +
 drivers/gpio/gpio-pisosr.c                         |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |  23 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   8 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c     |  97 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |  34 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h            |   2 +-
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/psp_v12_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c             |  14 +-
 drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c           |  14 +-
 drivers/gpu/drm/amd/amdgpu/psp_v14_0.c             |  14 +-
 drivers/gpu/drm/amd/amdgpu/psp_v3_1.c              |   8 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_debug.c             |   6 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  17 +-
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c          |   8 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |  11 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |  12 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c  |   7 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |  20 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  21 +-
 .../drm/amd/display/dc/dml2/dml2_mall_phantom.c    |   6 +-
 .../gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c |   8 +-
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |  12 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |  31 +-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |   3 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c   |   4 +
 drivers/gpu/drm/arm/display/komeda/komeda_dev.c    |   6 +-
 drivers/gpu/drm/arm/display/komeda/komeda_drv.c    |  14 +-
 drivers/gpu/drm/arm/malidp_drv.c                   |  22 +-
 drivers/gpu/drm/bridge/tc358768.c                  |   2 +
 drivers/gpu/drm/display/drm_dp_helper.c            |   2 +
 drivers/gpu/drm/drm_exec.c                         |  13 +
 drivers/gpu/drm/drm_gem.c                          |  10 +
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c         |  21 +-
 drivers/gpu/drm/gud/gud_drv.c                      |   1 +
 drivers/gpu/drm/i915/i915_query.c                  |   4 +-
 drivers/gpu/drm/imagination/pvr_context.c          |  32 +-
 drivers/gpu/drm/logicvc/Kconfig                    |   1 -
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |   1 +
 .../gpu/drm/nouveau/nvkm/subdev/bios/shadowrom.c   | 110 +++-
 drivers/gpu/drm/panel/Kconfig                      |  11 +-
 drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c   |   2 +
 drivers/gpu/drm/panel/panel-simple.c               |  28 +
 drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.c       |  16 +
 drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.h       |   2 +
 drivers/gpu/drm/tiny/cirrus.c                      |   7 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |   2 +-
 drivers/gpu/drm/vc4/vc4_v3d.c                      |   2 +-
 drivers/gpu/drm/virtio/virtgpu_display.c           |   2 +-
 drivers/gpu/drm/xe/xe_oa.c                         |   6 +-
 drivers/gpu/host1x/bus.c                           |   4 +-
 .../hid/bpf/progs/Huion__Inspiroy-Frego-M.bpf.c    |  87 ++++
 drivers/hid/hid-apple.c                            |  18 +-
 drivers/hid/hid-logitech-hidpp.c                   |   1 +
 drivers/hid/hid-mcp2221.c                          |  15 +-
 drivers/hid/hid-multitouch.c                       | 147 +++++-
 drivers/hid/hid-sony.c                             |  82 ++-
 drivers/hid/hid-universal-pidff.c                  |   4 +-
 drivers/hv/connection.c                            |  47 +-
 drivers/hv/hyperv_vmbus.h                          |   2 +
 drivers/hwmon/adt7462.c                            |   8 +
 drivers/hwmon/applesmc.c                           |   7 +-
 drivers/hwmon/aspeed-pwm-tacho.c                   |   4 +-
 drivers/hwmon/chipcap2.c                           |   9 +-
 drivers/hwmon/corsair-cpro.c                       |  24 +-
 drivers/hwmon/corsair-psu.c                        |  23 +-
 drivers/hwmon/dell-smm-hwmon.c                     |   8 +
 drivers/hwmon/gpio-fan.c                           |  13 +-
 drivers/hwmon/hwmon.c                              |  16 +-
 drivers/hwmon/ina2xx.c                             |  14 +-
 drivers/hwmon/ltc4282.c                            |   2 +-
 drivers/hwmon/pmbus/lm25066.c                      |  60 +--
 drivers/hwmon/pmbus/pmbus_core.c                   |   4 +-
 drivers/hwmon/raspberrypi-hwmon.c                  |  12 +-
 drivers/hwtracing/coresight/coresight-platform.c   |  12 +-
 drivers/i2c/i2c-core-smbus.c                       |  12 +
 drivers/i3c/master/mipi-i3c-hci/cmd_v1.c           |   4 +-
 drivers/i3c/master/mipi-i3c-hci/cmd_v2.c           |   4 +-
 drivers/iio/accel/mma8452.c                        |  19 +-
 drivers/iio/adc/qcom-spmi-iadc.c                   |  18 +-
 drivers/iio/adc/rtq6056.c                          |  10 +-
 drivers/iio/light/stk3310.c                        |  76 ++-
 drivers/infiniband/core/umem.c                     |  18 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |  11 +
 drivers/infiniband/hw/irdma/utils.c                |   2 +-
 drivers/infiniband/hw/mlx5/cq.c                    |   3 +-
 drivers/infiniband/hw/mlx5/main.c                  |  11 +
 drivers/infiniband/hw/mlx5/mr.c                    |   4 +
 drivers/infiniband/hw/mlx5/odp.c                   |   3 +
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |  12 +-
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c     |  21 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |   9 +
 drivers/iommu/rockchip-iommu.c                     |   8 +
 drivers/irqchip/irq-gic-v3-its.c                   |   1 +
 drivers/leds/leds-pca9532.c                        |   8 +-
 drivers/leds/trigger/ledtrig-gpio.c                |   3 +-
 drivers/leds/uleds.c                               |  11 +-
 drivers/mailbox/imx-mailbox.c                      |  64 ++-
 drivers/mailbox/mailbox.c                          |   6 +-
 drivers/md/raid10.c                                |   5 +
 drivers/md/raid5.c                                 |  35 +-
 drivers/media/i2c/video-i2c.c                      |   2 +-
 drivers/media/pci/dm1105/dm1105.c                  |   7 +-
 .../platform/chips-media/wave5/wave5-vpu-dec.c     |  47 +-
 .../platform/chips-media/wave5/wave5-vpuapi.c      |  11 +-
 .../vcodec/decoder/vdec/vdec_av1_req_lat_if.c      |   5 +-
 drivers/media/platform/qcom/camss/camss-csiphy.c   |  10 +-
 .../platform/verisilicon/hantro_g2_hevc_dec.c      |   6 +-
 .../verisilicon/rockchip_vpu981_hw_av1_dec.c       |  57 +-
 drivers/media/rc/imon.c                            |   4 +
 drivers/media/rc/mceusb.c                          |   2 +
 drivers/media/usb/as102/as102_usb_drv.c            |  75 ++-
 drivers/media/usb/em28xx/em28xx-video.c            |   4 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |  32 ++
 drivers/media/v4l2-core/v4l2-h264.c                |   3 +-
 drivers/mfd/ab8500-core.c                          |   2 +-
 drivers/mfd/db8500-prcmu.c                         |   6 +-
 drivers/mfd/rsmu_i2c.c                             |   2 +
 drivers/mfd/rsmu_spi.c                             |   2 +
 drivers/mfd/tps65219.c                             |  14 +-
 drivers/mmc/core/queue.c                           |   8 +-
 drivers/mmc/host/davinci_mmc.c                     |  16 +-
 drivers/mmc/host/renesas_sdhi_internal_dmac.c      |   2 +
 drivers/net/bonding/bond_alb.c                     |  32 +-
 drivers/net/bonding/bond_main.c                    |   4 +-
 drivers/net/dsa/bcm_sf2_cfp.c                      |   2 +
 drivers/net/dsa/lantiq_gswip.c                     | 367 +++----------
 drivers/net/dsa/lantiq_gswip.h                     | 252 +++++++++
 drivers/net/dsa/mv88e6xxx/chip.c                   |  23 +-
 drivers/net/dsa/qca/qca8k-8xxx.c                   |  22 +-
 drivers/net/dsa/qca/qca8k.h                        |   1 +
 drivers/net/dsa/realtek/rtl8365mb.c                |  14 +
 drivers/net/dsa/sja1105/sja1105_flower.c           |   4 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   2 +
 drivers/net/ethernet/amd/au1000_eth.c              |   3 +-
 drivers/net/ethernet/amd/pds_core/core.c           |   4 +
 drivers/net/ethernet/amd/pds_core/fw.c             |  10 +-
 drivers/net/ethernet/amd/pds_core/main.c           |  10 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |   3 +-
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  19 +-
 drivers/net/ethernet/cadence/macb.h                |   2 +-
 drivers/net/ethernet/cadence/macb_main.c           |  39 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   8 +-
 drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c      |   4 +-
 drivers/net/ethernet/cortina/gemini.c              |  77 +--
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  69 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  12 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c  |   4 +-
 drivers/net/ethernet/ibm/emac/core.c               |   3 +-
 drivers/net/ethernet/ibm/emac/mal.c                |   6 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c        |  19 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   9 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   2 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |   4 +-
 drivers/net/ethernet/intel/ice/ice_trace.h         |  64 ++-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  20 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |   2 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |  10 +-
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |  10 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  33 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  10 +-
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c   |  60 ++-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c   |  27 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   8 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   3 +-
 .../mlx5/core/steering/hws/mlx5hws_table.c         |   3 +
 drivers/net/ethernet/micrel/ks8842.c               |   4 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |  10 +-
 drivers/net/ethernet/micrel/ks8851_spi.c           |   4 +-
 drivers/net/ethernet/micrel/ksz884x.c              |   4 +-
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |  20 +
 .../net/ethernet/microchip/sparx5/sparx5_psfp.c    |   5 +-
 .../ethernet/microchip/sparx5/sparx5_tc_flower.c   |  18 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  12 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  36 +-
 drivers/net/ethernet/oa_tc6.c                      | 514 +++++++++++-------
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |  13 +-
 drivers/net/ethernet/realtek/rtase/rtase.h         |   4 +
 drivers/net/ethernet/realtek/rtase/rtase_main.c    |   3 +
 drivers/net/ethernet/sfc/ethtool.c                 |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 169 ++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   1 -
 drivers/net/ethernet/ti/cpsw.c                     |  41 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   4 +-
 drivers/net/gtp.c                                  |   5 +
 drivers/net/ieee802154/cc2520.c                    |   5 +-
 drivers/net/ieee802154/mac802154_hwsim.c           |  10 +-
 drivers/net/mctp/mctp-i3c.c                        |   9 +-
 drivers/net/netconsole.c                           |   2 +
 drivers/net/phy/Kconfig                            |  17 +-
 drivers/net/phy/Makefile                           |   3 +-
 drivers/net/phy/mediatek/Kconfig                   |  22 +
 drivers/net/phy/mediatek/Makefile                  |   3 +
 .../{mediatek-ge-soc.c => mediatek/mtk-ge-soc.c}   |   0
 .../net/phy/{mediatek-ge.c => mediatek/mtk-ge.c}   |  29 ++
 drivers/net/phy/motorcomm.c                        |  41 +-
 drivers/net/phy/phy_device.c                       |  16 +
 drivers/net/phy/sfp.c                              |   2 +
 drivers/net/ppp/ppp_async.c                        |  89 +---
 drivers/net/ppp/ppp_synctty.c                      |  97 +---
 drivers/net/usb/cx82310_eth.c                      |   1 +
 drivers/net/usb/hso.c                              |   2 +-
 drivers/net/usb/pegasus.c                          |  54 +-
 drivers/net/usb/pegasus.h                          |   3 -
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/vxlan/vxlan_core.c                     |  13 +-
 drivers/net/vxlan/vxlan_mdb.c                      |   8 +
 drivers/net/vxlan/vxlan_vnifilter.c                |  13 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  50 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  12 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h           |   2 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |   5 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  19 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  25 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   3 -
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  45 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   9 +-
 drivers/net/wireless/marvell/libertas/tx.c         |   7 +
 drivers/net/wireless/marvell/mwifiex/fw.h          |  18 +-
 drivers/net/wireless/marvell/mwifiex/join.c        |   8 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  33 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   9 +
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |   5 +
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c    |   3 +
 drivers/net/wireless/mediatek/mt76/pci.c           |   8 +-
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |   2 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |   3 +
 drivers/net/wireless/realtek/rtw89/core.c          |   4 +-
 drivers/net/wireless/realtek/rtw89/mac_be.c        |   4 +
 drivers/net/wireless/realtek/rtw89/pci.c           |  16 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   8 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   6 +-
 drivers/net/wireless/virtual/mac80211_hwsim.c      |   6 +-
 drivers/net/wwan/t7xx/t7xx_pci.c                   |   3 +
 drivers/nvdimm/claim.c                             |   9 +-
 drivers/nvme/host/apple.c                          | 182 +++----
 drivers/nvme/host/core.c                           |  34 +-
 drivers/nvme/host/fc.c                             |   7 +-
 drivers/nvme/host/rdma.c                           |  18 +-
 drivers/nvme/host/tcp.c                            |  17 +-
 drivers/nvme/target/rdma.c                         |  15 +-
 drivers/of/dynamic.c                               |  20 +-
 drivers/of/overlay.c                               |  15 +
 drivers/opp/of.c                                   |   2 +-
 drivers/pci/controller/dwc/pcie-intel-gw.c         |  19 +-
 drivers/pci/controller/pcie-altera.c               |   2 +
 drivers/pci/controller/pcie-iproc.c                |   2 +
 drivers/pci/controller/pcie-mediatek.c             |   2 +
 drivers/pci/controller/pcie-rockchip-host.c        |   2 +
 drivers/pci/controller/plda/pcie-plda-host.c       |   2 +
 drivers/pci/pci-driver.c                           |  10 +-
 drivers/pci/pci-sysfs.c                            |  14 +-
 drivers/pci/pci.c                                  |  24 +-
 drivers/pci/proc.c                                 |  79 ++-
 drivers/pci/quirks.c                               |   5 +
 drivers/pci/switch/switchtec.c                     |  16 +
 drivers/perf/riscv_pmu_legacy.c                    |   5 +-
 drivers/perf/riscv_pmu_sbi.c                       |  98 ++--
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   3 +-
 drivers/pinctrl/renesas/pinctrl-rzv2m.c            |   4 +-
 drivers/platform/chrome/cros_ec_sensorhub.c        |   6 +-
 drivers/platform/chrome/cros_ec_sysfs.c            |   5 +-
 drivers/platform/x86/dell/dell-laptop.c            |   9 +
 drivers/platform/x86/intel/hid.c                   |   7 +
 drivers/platform/x86/msi-ec.c                      |   1 +
 drivers/platform/x86/sel3350-platform.c            | 136 +++--
 drivers/powercap/intel_rapl_common.c               |   3 +-
 drivers/ptp/ptp_ocp.c                              |   1 +
 drivers/ras/amd/atl/core.c                         |   1 -
 drivers/regulator/core.c                           | 163 +++---
 drivers/regulator/da9121-regulator.c               |  18 +-
 drivers/regulator/db8500-prcmu.c                   |  12 +-
 drivers/rtc/rtc-aspeed.c                           |   1 +
 drivers/rtc/rtc-bq32k.c                            |   9 +
 drivers/rtc/rtc-mv.c                               |  23 +
 drivers/s390/char/zcore.c                          |   8 +-
 drivers/s390/cio/device.c                          |   2 +-
 drivers/s390/net/ism_drv.c                         |   4 +-
 drivers/s390/net/qeth_l2.h                         |   3 +-
 drivers/s390/net/qeth_l2_main.c                    |  26 +-
 drivers/s390/net/qeth_l2_sys.c                     |   7 +-
 drivers/scsi/bfa/bfa_fcs_lport.c                   |   2 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c             |   8 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   5 +-
 drivers/scsi/pm8001/pm8001_ctl.c                   |   8 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |   7 +
 drivers/scsi/scsi_error.c                          |   2 +-
 drivers/soc/tegra/fuse/fuse-tegra.c                |  14 +-
 drivers/soc/ti/pm33xx.c                            |   2 +-
 drivers/soundwire/bus.c                            |   4 +
 drivers/soundwire/dmi-quirks.c                     |  35 ++
 drivers/soundwire/intel.c                          |  31 +-
 drivers/soundwire/intel_ace2x.c                    |  39 +-
 drivers/soundwire/intel_auxdevice.c                |   2 +
 drivers/soundwire/slave.c                          |   4 +-
 drivers/spi/spi-dw-dma.c                           |   3 +-
 drivers/spi/spi-dw-mmio.c                          |   7 +-
 drivers/spi/spi-dw.h                               |   1 +
 drivers/spi/spi-qcom-qspi.c                        |  44 +-
 drivers/spi/spi-xilinx.c                           |   6 +-
 drivers/spi/spi.c                                  |   9 +-
 drivers/staging/fbtft/fbtft-core.c                 |   9 +-
 drivers/target/iscsi/iscsi_target.c                |   4 +-
 drivers/tee/optee/call.c                           |   3 +-
 drivers/thermal/db8500_thermal.c                   |  10 +-
 drivers/thermal/qcom/tsens.c                       | 111 ++--
 drivers/thermal/qcom/tsens.h                       |   1 +
 drivers/thermal/tegra/soctherm.c                   |   6 +-
 drivers/thermal/thermal_sysfs.c                    |  12 +-
 drivers/thunderbolt/icm.c                          |  10 +
 drivers/thunderbolt/path.c                         |  31 +-
 drivers/thunderbolt/switch.c                       |   6 +
 drivers/thunderbolt/tb.c                           |   9 +-
 drivers/thunderbolt/tb_regs.h                      |   1 +
 drivers/thunderbolt/usb4.c                         |  11 +-
 drivers/thunderbolt/xdomain.c                      |  49 +-
 drivers/tty/serial/8250/8250_port.c                |   7 +
 drivers/usb/atm/xusbatm.c                          |   6 +-
 drivers/usb/class/cdc-acm.c                        |   6 +
 drivers/usb/class/usbtmc.c                         |   2 -
 drivers/usb/core/hcd.c                             |  14 +-
 drivers/usb/gadget/function/f_fs.c                 |  31 +-
 drivers/usb/gadget/udc/aspeed_udc.c                |   7 +-
 drivers/usb/gadget/udc/core.c                      |   7 +-
 drivers/usb/gadget/udc/goku_udc.c                  |   3 +-
 drivers/usb/host/Kconfig                           |   2 +-
 drivers/usb/host/xhci-debugfs.c                    |  10 +-
 drivers/usb/host/xhci-hub.c                        |   2 +-
 drivers/usb/host/xhci-mem.c                        |  34 +-
 drivers/usb/host/xhci-pci.c                        |   9 +-
 drivers/usb/host/xhci-ring.c                       |  13 +-
 drivers/usb/host/xhci.c                            |  31 +-
 drivers/usb/host/xhci.h                            |  39 +-
 drivers/usb/serial/spcp8x5.c                       |   6 +-
 drivers/usb/usbip/vhci_sysfs.c                     |  52 +-
 drivers/vdpa/ifcvf/ifcvf_main.c                    |  14 +-
 drivers/vdpa/octeon_ep/octep_vdpa_main.c           |   6 +-
 drivers/vdpa/solidrun/snet_main.c                  |   6 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c               |   3 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c               |   7 +-
 drivers/vhost/scsi.c                               |   3 +-
 drivers/vhost/vdpa.c                               |  88 +++-
 drivers/video/fbdev/core/fbcon.c                   |   9 +-
 drivers/video/fbdev/pm2fb.c                        |   1 +
 drivers/video/fbdev/vfb.c                          |  11 +-
 drivers/virtio/virtio.c                            |   2 +-
 drivers/virtio/virtio_input.c                      |   9 +-
 drivers/virtio/virtio_pci_common.c                 |   4 +-
 drivers/watchdog/db8500_wdt.c                      |  22 +-
 drivers/watchdog/imx7ulp_wdt.c                     |  10 +-
 drivers/watchdog/lenovo_se10_wdt.c                 |  82 ++-
 drivers/watchdog/msc313e_wdt.c                     |  74 ++-
 drivers/watchdog/sunxi_wdt.c                       |  45 +-
 drivers/watchdog/watchdog_hrtimer_pretimeout.c     |   1 +
 drivers/xen/balloon.c                              |  56 +-
 drivers/xen/gntalloc.c                             |  13 +-
 drivers/xen/xen-front-pgdir-shbuf.c                |  12 +-
 fs/9p/vfs_dir.c                                    |  14 +-
 fs/affs/affs.h                                     |   5 -
 fs/affs/super.c                                    |   6 +-
 fs/afs/addr_list.c                                 |   5 +-
 fs/afs/fs_probe.c                                  |   1 +
 fs/afs/server.c                                    |   1 -
 fs/autofs/inode.c                                  |   4 +-
 fs/befs/linuxvfs.c                                 |   3 +-
 fs/bfs/inode.c                                     |   3 +-
 fs/btrfs/accessors.h                               |   1 +
 fs/btrfs/acl.h                                     |   2 +
 fs/btrfs/compression.c                             |  16 +-
 fs/btrfs/ctree.h                                   |  11 +-
 fs/btrfs/defrag.c                                  |  32 +-
 fs/btrfs/delayed-ref.h                             |   2 +
 fs/btrfs/dir-item.h                                |   1 +
 fs/btrfs/direct-io.c                               |  41 +-
 fs/btrfs/direct-io.h                               |   2 +
 fs/btrfs/discard.h                                 |   1 +
 fs/btrfs/disk-io.c                                 |  11 +-
 fs/btrfs/extent-io-tree.h                          |   6 +-
 fs/btrfs/extent-tree.h                             |   1 -
 fs/btrfs/extent_io.c                               |  53 +-
 fs/btrfs/extent_map.c                              |  94 ++--
 fs/btrfs/extent_map.h                              |   8 +-
 fs/btrfs/fiemap.c                                  |   4 +-
 fs/btrfs/file-item.h                               |   2 +
 fs/btrfs/file.c                                    | 136 +++--
 fs/btrfs/file.h                                    |   2 +
 fs/btrfs/free-space-cache.c                        |  10 +-
 fs/btrfs/fs.c                                      |  10 +-
 fs/btrfs/fs.h                                      |  10 +
 fs/btrfs/inode.c                                   | 181 +++----
 fs/btrfs/ioctl.c                                   | 171 +++---
 fs/btrfs/ioctl.h                                   |   5 +-
 fs/btrfs/locking.c                                 |   1 -
 fs/btrfs/ordered-data.c                            |   8 +-
 fs/btrfs/ordered-data.h                            |   1 +
 fs/btrfs/print-tree.h                              |   2 +
 fs/btrfs/props.h                                   |   1 +
 fs/btrfs/qgroup.h                                  |   3 +
 fs/btrfs/raid-stripe-tree.c                        |  25 +-
 fs/btrfs/raid-stripe-tree.h                        |   2 +
 fs/btrfs/reflink.c                                 |   8 +-
 fs/btrfs/relocation.c                              |  71 ++-
 fs/btrfs/send.c                                    |   3 +-
 fs/btrfs/space-info.c                              |   2 +-
 fs/btrfs/subpage.c                                 |   1 -
 fs/btrfs/super.c                                   |   2 +-
 fs/btrfs/sysfs.h                                   |   1 +
 fs/btrfs/tests/extent-io-tests.c                   |   6 +-
 fs/btrfs/tests/extent-map-tests.c                  |  56 +-
 fs/btrfs/tests/inode-tests.c                       |  67 +--
 fs/btrfs/transaction.c                             |  13 +-
 fs/btrfs/tree-checker.c                            |  41 ++
 fs/btrfs/tree-log.c                                |  12 +-
 fs/btrfs/verity.c                                  |   4 +-
 fs/btrfs/volumes.c                                 |  10 +-
 fs/btrfs/volumes.h                                 |   4 +
 fs/btrfs/xattr.h                                   |   2 +
 fs/btrfs/zoned.c                                   |  15 +-
 fs/cachefiles/namei.c                              |   1 -
 fs/ceph/caps.c                                     |  69 ++-
 fs/ceph/crypto.c                                   |  46 +-
 fs/ceph/mds_client.c                               | 196 ++++++-
 fs/ceph/mds_client.h                               |   2 -
 fs/ceph/super.h                                    |   5 +-
 fs/configfs/dir.c                                  |  12 +-
 fs/dlm/memory.c                                    |   4 +-
 fs/erofs/decompressor_lzma.c                       |  18 +-
 fs/erofs/zutil.c                                   |   2 +
 fs/exec.c                                          |  22 +-
 fs/exfat/nls.c                                     |  19 +-
 fs/f2fs/inline.c                                   |   7 +
 fs/freevxfs/vxfs_bmap.c                            |   3 +-
 fs/fuse/dev.c                                      |  27 +-
 fs/fuse/file.c                                     |   3 +-
 fs/fuse/virtio_fs.c                                |   2 +
 fs/gfs2/bmap.c                                     |  19 +
 fs/gfs2/bmap.h                                     |   1 +
 fs/gfs2/file.c                                     |  10 +
 fs/gfs2/quota.c                                    |  36 +-
 fs/hfs/catalog.c                                   |   9 -
 fs/hfs/dir.c                                       |  28 +-
 fs/hfs/hfs.h                                       |   3 +-
 fs/hfs/hfs_fs.h                                    |   2 -
 fs/hfs/inode.c                                     |   4 -
 fs/hfsplus/catalog.c                               |  11 -
 fs/hfsplus/dir.c                                   |  28 +-
 fs/hfsplus/hfsplus_fs.h                            |   5 +-
 fs/hfsplus/inode.c                                 |  40 +-
 fs/hfsplus/super.c                                 |   2 -
 fs/hpfs/super.c                                    |   3 +-
 fs/iomap/direct-io.c                               |   2 +-
 fs/isofs/inode.c                                   |   3 +-
 fs/jfs/super.c                                     |   3 +-
 fs/minix/inode.c                                   |   3 +-
 fs/netfs/buffered_read.c                           |   2 +-
 fs/netfs/buffered_write.c                          |   2 +-
 fs/netfs/internal.h                                |  12 +
 fs/nfs/blocklayout/rpc_pipefs.c                    |  41 +-
 fs/nfs/export.c                                    |   3 +-
 fs/nfs/nfs42proc.c                                 |  15 +-
 fs/nfs/nfs4idmap.c                                 |   8 +-
 fs/nfsd/filecache.c                                |  34 +-
 fs/nfsd/netns.h                                    |  14 +-
 fs/nfsd/nfs4callback.c                             |  78 ++-
 fs/nfsd/nfs4proc.c                                 |  32 +-
 fs/nfsd/nfs4recover.c                              |  76 +--
 fs/nfsd/nfs4state.c                                | 257 +++++++--
 fs/nfsd/nfsctl.c                                   | 199 ++++---
 fs/nfsd/nfsd.h                                     |  15 -
 fs/nfsd/state.h                                    |   5 +-
 fs/nfsd/trace.h                                    |  14 +-
 fs/nfsd/xdr4.h                                     |   1 +
 fs/ntfs3/dir.c                                     |   4 +-
 fs/ntfs3/fslog.c                                   |  28 +-
 fs/ntfs3/index.c                                   |  41 +-
 fs/ntfs3/super.c                                   |   8 +-
 fs/ntfs3/xattr.c                                   |   4 +-
 fs/ocfs2/dir.c                                     |  71 ++-
 fs/omfs/inode.c                                    |   6 +-
 fs/pidfs.c                                         |  65 ++-
 fs/qnx4/inode.c                                    |   3 +-
 fs/smb/client/cifsacl.c                            |  30 +-
 fs/smb/client/cifspdu.h                            |   8 -
 fs/smb/client/connect.c                            |  27 +-
 fs/smb/client/file.c                               |   5 +-
 fs/smb/client/link.c                               |   2 +-
 fs/smb/client/misc.c                               |  24 +-
 fs/smb/client/readdir.c                            |   9 +-
 fs/smb/client/reparse.c                            |   5 +-
 fs/smb/client/smb1ops.c                            |   2 +-
 fs/smb/client/smb2ops.c                            | 487 +++++++++++------
 fs/smb/client/smb2pdu.h                            |  20 -
 fs/smb/client/trace.h                              |   2 +-
 fs/smb/client/transport.c                          |  11 +-
 fs/smb/common/smb2pdu.h                            |  29 ++
 fs/smb/server/mgmt/share_config.c                  |  36 +-
 fs/smb/server/mgmt/user_session.c                  |  25 +-
 fs/smb/server/misc.c                               |  14 +-
 fs/smb/server/oplock.c                             | 221 ++++++--
 fs/smb/server/oplock.h                             |   2 +-
 fs/smb/server/server.c                             |   6 +
 fs/smb/server/smb2misc.c                           |   9 +-
 fs/smb/server/smb2pdu.c                            | 281 +++++-----
 fs/smb/server/smb2pdu.h                            |  20 -
 fs/smb/server/smbacl.c                             |  88 ++--
 fs/smb/server/transport_ipc.c                      |  21 +-
 fs/smb/server/vfs.c                                |  46 +-
 fs/smb/server/vfs_cache.c                          |  28 +-
 fs/smb/server/vfs_cache.h                          |   8 +-
 fs/super.c                                         |   9 +-
 fs/ufs/cylinder.c                                  |  10 +
 fs/ufs/dir.c                                       |   2 +-
 fs/ufs/super.c                                     |  17 +-
 fs/xfs/libxfs/xfs_btree_mem.c                      |   2 +
 fs/xfs/libxfs/xfs_btree_staging.c                  |   4 +-
 fs/xfs/libxfs/xfs_defer.c                          |   2 +-
 fs/xfs/libxfs/xfs_exchmaps.c                       |  10 +
 fs/xfs/libxfs/xfs_parent.c                         |  13 +-
 fs/xfs/scrub/agheader_repair.c                     |  39 +-
 fs/xfs/scrub/alloc_repair.c                        |  18 +-
 fs/xfs/scrub/dir_repair.c                          |  10 +-
 fs/xfs/scrub/dirtree.c                             |  31 +-
 fs/xfs/scrub/dirtree_repair.c                      |   2 +
 fs/xfs/scrub/findparent.c                          |  56 +-
 fs/xfs/scrub/ialloc.c                              |   4 +
 fs/xfs/scrub/quota_repair.c                        |  14 +-
 fs/xfs/scrub/quotacheck.c                          |   4 +-
 fs/xfs/scrub/scrub.c                               |   3 +-
 fs/xfs/scrub/stats.c                               |  60 ++-
 fs/xfs/scrub/stats.h                               |   4 +-
 fs/xfs/scrub/symlink_repair.c                      |   2 +-
 fs/xfs/scrub/trace.h                               |  35 +-
 fs/xfs/xfs_exchmaps_item.c                         |  19 +-
 fs/xfs/xfs_exchrange.c                             |  12 +-
 include/cxl/event.h                                |  80 +++
 include/linux/bio.h                                |  14 -
 include/linux/bitfield.h                           |   2 +-
 include/linux/bpf.h                                |   1 +
 include/linux/bpf_verifier.h                       |   4 +-
 include/linux/cper.h                               |   4 +
 include/linux/device.h                             |   1 +
 include/linux/ethtool.h                            |  28 +-
 include/linux/exportfs.h                           |   1 +
 include/linux/firmware/intel/stratix10-smc.h       |  18 +-
 include/linux/fwnode.h                             |   1 +
 include/linux/hugetlb.h                            |   5 +
 include/linux/hwmon.h                              |   1 +
 include/linux/igmp.h                               |   7 +-
 include/linux/kcsan-checks.h                       |   6 +-
 include/linux/mailbox_controller.h                 |   2 +
 include/linux/mfd/db8500-prcmu.h                   | 252 ++++++++-
 include/linux/mfd/dbx500-prcmu.h                   | 575 ---------------------
 include/linux/mm.h                                 |   2 +
 include/linux/mm_inline.h                          |  15 +-
 include/linux/mm_types.h                           |  27 +-
 include/linux/mmzone.h                             |   2 +
 include/linux/oa_tc6.h                             |  50 ++
 include/linux/perf/riscv_pmu.h                     |   2 +-
 include/linux/perf_event.h                         |   7 +-
 include/linux/phy.h                                |   1 +
 include/linux/platform_data/cros_ec_proto.h        |   2 +
 include/linux/rbtree_augmented.h                   |  35 +-
 include/linux/sched.h                              |   1 +
 include/linux/skbuff.h                             |   5 +
 include/linux/sunrpc/rpc_pipe_fs.h                 |   4 +-
 include/linux/sunrpc/svc.h                         |  21 +-
 include/linux/sunrpc/svc_rdma.h                    |   3 +-
 include/linux/sunrpc/xdr.h                         |  13 +
 include/linux/switchtec.h                          |   1 +
 include/linux/thunderbolt.h                        |   2 +
 include/linux/workqueue.h                          |  38 +-
 include/media/v4l2-hevc.h                          |  41 ++
 include/net/cfg80211.h                             |   2 +-
 include/net/cfg802154.h                            |   1 +
 include/net/dst.h                                  |   6 +
 include/net/if_inet6.h                             |   2 -
 include/net/inet6_hashtables.h                     |   2 +-
 include/net/ip.h                                   |  28 +-
 include/net/ip6_route.h                            |  45 ++
 include/net/ip6_tunnel.h                           |   2 +-
 include/net/ip_fib.h                               |   5 +
 include/net/ipv6.h                                 |  10 +-
 include/net/netlink.h                              |  14 +
 include/net/sch_generic.h                          |   2 +-
 include/net/tcp.h                                  |   8 +-
 include/rdma/ib_umem.h                             |   4 +-
 include/sound/hda_codec.h                          |  30 ++
 include/sound/rawmidi.h                            |   2 +
 include/sound/tas2781.h                            |   4 +-
 include/trace/events/hwmon.h                       |  10 +-
 include/trace/events/icmp.h                        |  13 +-
 include/uapi/linux/ethtool.h                       | 128 ++---
 include/uapi/linux/virtio_crypto.h                 |   1 +
 include/uapi/sound/asound.h                        |   6 +-
 io_uring/net.c                                     |  10 +-
 kernel/bpf/bpf_iter.c                              |   2 +-
 kernel/bpf/btf.c                                   |  24 +-
 kernel/bpf/cgroup.c                                |   1 +
 kernel/bpf/disasm.c                                |   5 +-
 kernel/bpf/stackmap.c                              | 175 +++++--
 kernel/bpf/verifier.c                              | 123 +++--
 kernel/events/core.c                               |  27 +-
 kernel/events/ring_buffer.c                        |   9 +-
 kernel/locking/lockdep.c                           |  50 +-
 kernel/printk/nbcon.c                              |   2 +-
 kernel/rcu/tasks.h                                 |   3 +-
 kernel/sched/ext.c                                 |  10 +-
 kernel/sched/fair.c                                | 209 +++-----
 kernel/time/clockevents.c                          |  35 +-
 kernel/time/tick-broadcast.c                       |  36 +-
 kernel/time/tick-internal.h                        |   2 +
 kernel/trace/Makefile                              |   5 +-
 kernel/trace/bpf_trace.c                           |  11 +
 kernel/trace/ring_buffer.c                         |  26 +-
 kernel/trace/trace_event_perf.c                    |  12 +-
 kernel/trace/trace_events_hist.c                   |  42 +-
 kernel/trace/trace_events_user.c                   |  26 +-
 kernel/trace/trace_probe.c                         |  48 +-
 kernel/trace/trace_probe.h                         |   2 +
 kernel/workqueue.c                                 |   5 +-
 mm/damon/core.c                                    |  13 +-
 mm/gup.c                                           |  10 +-
 mm/huge_memory.c                                   |  10 +
 mm/hugetlb.c                                       |   6 +-
 mm/hugetlb_vmemmap.c                               |   6 +-
 mm/migrate_device.c                                |   6 +
 mm/mm_init.c                                       |   2 +
 mm/page_alloc.c                                    |   5 +
 mm/slab.h                                          |   8 +-
 mm/slab_common.c                                   |  41 +-
 mm/slub.c                                          | 116 ++---
 mm/swap.c                                          |  49 +-
 mm/swapfile.c                                      |   8 +-
 mm/vmscan.c                                        |  78 ++-
 net/8021q/vlan.c                                   |   7 +-
 net/8021q/vlan_dev.c                               |  32 +-
 net/9p/client.c                                    |   2 +-
 net/appletalk/aarp.c                               |   5 +
 net/bluetooth/hci_core.c                           |   4 +-
 net/bluetooth/iso.c                                |  31 +-
 net/bluetooth/l2cap_core.c                         |  38 +-
 net/bluetooth/msft.c                               |   2 +-
 net/bluetooth/rfcomm/core.c                        |   5 +
 net/bridge/br_arp_nd_proxy.c                       |  16 +-
 net/bridge/br_device.c                             |   2 +-
 net/bridge/br_fdb.c                                |   7 +-
 net/bridge/br_input.c                              |   2 +-
 net/bridge/br_multicast.c                          |  11 +-
 net/core/dev.c                                     |   2 +-
 net/core/drop_monitor.c                            |  18 +-
 net/core/filter.c                                  |  17 +-
 net/core/gro_cells.c                               |   2 +
 net/core/rtnetlink.c                               |   7 +-
 net/core/skbuff.c                                  |   7 +
 net/ethtool/ioctl.c                                | 212 +++++++-
 net/hsr/hsr_forward.c                              |   2 +-
 net/hsr/hsr_netlink.c                              |   9 +-
 net/hsr/hsr_slave.c                                |  11 +-
 net/ieee802154/6lowpan/core.c                      |   2 +-
 net/ipv4/fib_rules.c                               |   4 +-
 net/ipv4/fib_trie.c                                |   4 +
 net/ipv4/fou_core.c                                |   2 +-
 net/ipv4/icmp.c                                    |   2 +-
 net/ipv4/igmp.c                                    | 210 +++++---
 net/ipv4/inet_fragment.c                           |   6 +
 net/ipv4/ip_output.c                               |   4 +-
 net/ipv4/ip_sockglue.c                             |   2 +-
 net/ipv4/ip_tunnel_core.c                          |   6 +
 net/ipv4/ipmr.c                                    |   5 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   2 +-
 net/ipv4/nexthop.c                                 |   2 +-
 net/ipv4/route.c                                   |   4 +-
 net/ipv4/tcp.c                                     |  14 +-
 net/ipv4/tcp_ipv4.c                                |  15 +-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/tcp_offload.c                             |  22 +-
 net/ipv4/tcp_output.c                              |  10 +-
 net/ipv4/tcp_timer.c                               |   6 +-
 net/ipv4/udp.c                                     |   4 +-
 net/ipv6/addrconf.c                                |  10 +-
 net/ipv6/af_inet6.c                                |   2 +-
 net/ipv6/exthdrs.c                                 |  99 ++--
 net/ipv6/ioam6.c                                   |  17 +-
 net/ipv6/ip6_fib.c                                 |   4 +-
 net/ipv6/ip6_gre.c                                 |   8 +-
 net/ipv6/ip6_input.c                               |  34 +-
 net/ipv6/ip6_output.c                              |  54 +-
 net/ipv6/ip6_tunnel.c                              |   8 +-
 net/ipv6/ip6_vti.c                                 |   2 +-
 net/ipv6/ip6mr.c                                   |   9 +-
 net/ipv6/ipv6_sockglue.c                           |  13 +-
 net/ipv6/mcast.c                                   | 257 +++++----
 net/ipv6/netfilter.c                               |   4 +-
 net/ipv6/netfilter/ip6_tables.c                    |   5 +
 net/ipv6/netfilter/nf_reject_ipv6.c                |   2 +-
 net/ipv6/output_core.c                             |   2 +-
 net/ipv6/reassembly.c                              |  10 +-
 net/ipv6/route.c                                   |  19 +-
 net/ipv6/seg6_iptunnel.c                           |   6 +-
 net/ipv6/sit.c                                     |   2 +-
 net/ipv6/tcp_ipv6.c                                |  15 +-
 net/ipv6/tcpv6_offload.c                           |  15 +-
 net/ipv6/xfrm6_output.c                            |   2 +-
 net/l2tp/l2tp_debugfs.c                            |   4 +
 net/l2tp/l2tp_ppp.c                                |  56 +-
 net/mac80211/cfg.c                                 |   9 +-
 net/mac80211/ibss.c                                |   9 +-
 net/mac80211/mlme.c                                |   6 +-
 net/mac80211/tx.c                                  |   2 +-
 net/mac80211/util.c                                |   6 +-
 net/mac802154/ieee802154_i.h                       |   8 +
 net/mac802154/iface.c                              |   6 +
 net/mac802154/main.c                               |   1 +
 net/mac802154/rx.c                                 | 120 ++++-
 net/mac802154/scan.c                               |  10 +-
 net/mptcp/options.c                                |   7 +-
 net/mptcp/protocol.c                               |   5 +-
 net/mptcp/protocol.h                               |   2 +-
 net/mptcp/subflow.c                                |   1 -
 net/mptcp/syncookies.c                             |   5 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |  13 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |  20 +-
 net/netfilter/nf_conntrack_expect.c                |   3 +-
 net/netfilter/nf_conntrack_netlink.c               |  13 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  10 +-
 net/netfilter/nf_conntrack_sip.c                   |   2 +-
 net/netfilter/nf_log_syslog.c                      |   6 +-
 net/netfilter/nfnetlink_log.c                      |  28 +-
 net/netfilter/nft_set_pipapo_avx2.c                |   1 +
 net/netlabel/netlabel_unlabeled.c                  |   2 +-
 net/openvswitch/flow.c                             |   4 +-
 net/openvswitch/flow_table.c                       |   4 +-
 net/packet/af_packet.c                             | 101 +++-
 net/phonet/pn_dev.c                                |  30 +-
 net/qrtr/af_qrtr.c                                 |   4 +-
 net/rds/af_rds.c                                   |  63 ++-
 net/rds/connection.c                               | 102 +++-
 net/rds/ib_cm.c                                    |  25 +-
 net/rds/ib_recv.c                                  |   9 +-
 net/rds/message.c                                  |   4 +-
 net/rds/send.c                                     |  16 +-
 net/rds/tcp.c                                      | 164 ++++--
 net/rds/tcp_listen.c                               |   6 +-
 net/sched/act_api.c                                |  46 +-
 net/sched/act_csum.c                               |   8 +-
 net/sched/cls_api.c                                |   8 +-
 net/sched/cls_route.c                              |  76 +--
 net/sched/cls_u32.c                                |  32 +-
 net/sched/sch_api.c                                |   2 +-
 net/sched/sch_drr.c                                |  13 +-
 net/sched/sch_ets.c                                |  12 +-
 net/sched/sch_fq_pie.c                             |   3 +-
 net/sched/sch_generic.c                            |  24 +-
 net/sched/sch_hhf.c                                |   8 +-
 net/sched/sch_pie.c                                |   2 +-
 net/sched/sch_sfq.c                                |   7 +-
 net/sctp/ipv6.c                                    |  12 +-
 net/sctp/protocol.c                                |  10 +-
 net/sctp/sm_make_chunk.c                           |  14 +-
 net/sctp/sm_sideeffect.c                           |  11 +-
 net/sctp/sm_statefuns.c                            |   5 +
 net/sunrpc/auth_gss/auth_gss.c                     |   7 +-
 net/sunrpc/auth_gss/gss_rpc_xdr.c                  |   9 +-
 net/sunrpc/clnt.c                                  |  52 +-
 net/sunrpc/rpc_pipe.c                              |  80 +--
 net/sunrpc/svc.c                                   |  23 +-
 net/sunrpc/xprtrdma/ib_client.c                    |  26 +-
 net/sunrpc/xprtrdma/svc_rdma_pcl.c                 |   2 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |  15 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |  32 +-
 net/sunrpc/xprtrdma/verbs.c                        |  21 +-
 net/tipc/link.c                                    |   6 +-
 net/tipc/name_table.c                              |  32 +-
 net/tipc/socket.c                                  |   4 +-
 net/tls/tls_main.c                                 |  11 +
 net/tls/tls_sw.c                                   |  12 +
 net/unix/af_unix.c                                 |  12 +-
 net/unix/garbage.c                                 |   1 +
 net/vmw_vsock/hyperv_transport.c                   |   2 +-
 net/vmw_vsock/vmci_transport.c                     |   2 +-
 net/wireless/core.c                                |  21 +
 net/wireless/mlme.c                                | 105 ++--
 net/wireless/nl80211.c                             |   8 +-
 net/wireless/wext-sme.c                            |   9 +
 rust/bindings/lib.rs                               |   3 +-
 rust/uapi/lib.rs                                   |   3 +-
 scripts/mksysmap                                   |   2 +-
 scripts/mod/modpost.c                              |  11 +-
 scripts/sorttable.c                                |   2 +-
 security/apparmor/match.c                          |  22 +-
 security/integrity/digsig_asymmetric.c             |   4 +
 security/integrity/ima/ima_appraise.c              |   5 +
 security/keys/trusted-keys/trusted_tpm1.c          |   2 +-
 sound/core/pcm_native.c                            |  35 +-
 sound/core/rawmidi.c                               |   4 +
 sound/core/seq/oss/seq_oss_rw.c                    |   3 +-
 sound/core/seq/seq_prioq.c                         |  14 +-
 sound/core/ump.c                                   |  94 +++-
 sound/hda/ext/hdac_ext_controller.c                |   6 +-
 sound/hda/hdac_bus.c                               |   8 +-
 sound/hda/hdac_component.c                         |   6 +-
 sound/hda/hdac_device.c                            |  28 +-
 sound/hda/hdac_regmap.c                            |  35 +-
 sound/isa/es18xx.c                                 |   4 +
 sound/pci/ctxfi/cthw20k2.c                         |   1 +
 sound/pci/hda/cs35l41_hda_property.c               |   2 +
 sound/pci/hda/cs35l56_hda.c                        |  30 +-
 sound/pci/hda/hda_codec.c                          | 119 ++---
 sound/pci/hda/hda_controller.c                     |  24 +-
 sound/pci/hda/hda_proc.c                           |   4 +-
 sound/pci/hda/hda_sysfs.c                          |  77 ++-
 sound/pci/hda/patch_conexant.c                     |  12 +
 sound/pci/hda/patch_realtek.c                      |  40 ++
 sound/soc/amd/renoir/acp3x-pdm-dma.c               |   2 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  21 +
 sound/soc/amd/yc/acp6x-pdm-dma.c                   |   2 +
 sound/soc/bcm/bcm63xx-i2s-whistler.c               |   1 +
 sound/soc/codecs/ab8500-codec.c                    | 543 ++++++++++---------
 sound/soc/codecs/mt6351.c                          |   1 +
 sound/soc/codecs/pcm3168a.c                        |  20 +-
 sound/soc/codecs/rk3328_codec.c                    |  54 +-
 sound/soc/codecs/rt5645.c                          |   4 +
 sound/soc/codecs/rt712-sdca.c                      |  11 +
 sound/soc/fsl/fsl-asoc-card.c                      |   8 +-
 sound/soc/intel/atom/sst/sst_pci.c                 |   1 +
 sound/soc/intel/avs/core.c                         |  29 +-
 sound/soc/intel/avs/debugfs.c                      |  12 +-
 sound/soc/intel/avs/pcm.c                          |  34 +-
 sound/soc/intel/avs/topology.c                     |   2 +-
 sound/soc/intel/avs/topology.h                     |   1 +
 sound/soc/intel/boards/sof_sdw.c                   |  25 +-
 sound/soc/intel/catpt/ipc.c                        |   8 +
 sound/soc/intel/catpt/loader.c                     |   3 +
 sound/soc/intel/catpt/registers.h                  |  12 +
 sound/soc/mediatek/mt8365/mt8365-afe-pcm.c         |  13 +-
 sound/soc/meson/aiu-acodec-ctrl.c                  |   3 +
 sound/soc/meson/aiu-codec-ctrl.c                   |   3 +
 sound/soc/qcom/qdsp6/q6apm.c                       |  10 +-
 sound/soc/rockchip/rockchip_pdm.c                  |  16 +-
 sound/soc/rockchip/rockchip_spdif.c                |   1 +
 sound/soc/soc-topology.c                           |  37 +-
 sound/soc/sprd/sprd-pcm-compress.c                 |  15 +-
 sound/soc/sti/uniperif_reader.c                    |   4 +-
 sound/soc/ti/omap3pandora.c                        |   5 +-
 sound/soc/ux500/ux500_msp_dai.c                    | 189 +++----
 sound/soc/ux500/ux500_msp_dai.h                    |  14 +-
 sound/soc/ux500/ux500_msp_i2s.c                    | 260 +++++++---
 sound/soc/ux500/ux500_msp_i2s.h                    |  12 +-
 sound/usb/caiaq/audio.c                            |  10 +-
 sound/usb/caiaq/device.c                           |  53 +-
 sound/usb/caiaq/device.h                           |   4 +-
 sound/usb/caiaq/input.c                            |   6 +
 sound/usb/caiaq/midi.c                             |   6 +-
 sound/usb/mixer.c                                  |  17 +-
 sound/usb/mixer_maps.c                             |  25 +
 sound/usb/quirks-table.h                           |  22 +
 sound/usb/quirks.c                                 |   4 +
 sound/usb/usx2y/us122l.c                           |   9 +-
 sound/usb/usx2y/usbusx2y.c                         |  49 +-
 sound/usb/usx2y/usbusx2y.h                         |   4 +-
 tools/bpf/bpftool/Makefile                         |   6 +-
 tools/build/feature/test-bpf.c                     |   2 +
 tools/include/nolibc/crt.h                         |   2 +-
 tools/lib/bpf/bpf.c                                |   2 +
 tools/lib/bpf/gen_loader.c                         |   2 +
 .../xdrgen/templates/C/union/declaration/close.j2  |   4 +
 tools/perf/tests/shell/stat_bpf_counters.sh        |  28 +-
 tools/perf/util/evsel.c                            |   4 +
 tools/perf/util/symbol.c                           |  11 +-
 tools/sched_ext/scx_central.bpf.c                  |   6 +-
 tools/sched_ext/scx_qmap.bpf.c                     |   2 +-
 tools/testing/cxl/Kbuild                           |   2 +
 tools/testing/selftests/alsa/mixer-test.c          |   4 +-
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |   8 +-
 tools/testing/selftests/cgroup/test_kmem.c         |   2 +-
 tools/testing/selftests/kselftest_harness.h        |   2 +-
 tools/testing/selftests/mm/cow.c                   | 338 +++++-------
 tools/testing/selftests/net/fib_nexthops.sh        |  28 +
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   4 +-
 tools/testing/selftests/net/pmtu.sh                |   2 +-
 tools/testing/selftests/net/test_vxlan_mdb.sh      |   6 +
 tools/testing/selftests/powerpc/tm/tm.h            |   8 +-
 1054 files changed, 15506 insertions(+), 8702 deletions(-)


