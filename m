Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD15577E4F;
	Wed,  9 Sep 2026 14:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963330; cv=none; b=DBIPpmEU/JWNBe6MKP8qbTtgxv9GHs1xWt6cdfKVbZ4D566oBTu9nF0KthEecbtERT/cXLnPr5vv6PZw5Shh07+kK5KEoNzu93jC8H5Yvq3SpOeXK3L14tUaFMhH9Snmzcz09xQ7qpxkoYQ8+giDZxc/YXaeY7tPzJBYghJW8jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963330; c=relaxed/simple;
	bh=DbC3DVv7SImkQStWuKftfGZuj0ALc4L4uG3QX24T5sg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ejL29FFmTh1IwjboD8Hoopa52qwcqeweDpkkS1vkhyTpr28pgjT+Igu0A3JVFB1gJ7iYg7cnbrj11889h/2eRpPwLoR4euCX7TlDiqOZSF5mR7oRtgzuVlDHzczaqBRkBL0zcqMuxnSBVZIBv0BYdEj6dXAOMYhZhV8z9aGkruQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npBUw5Jw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npBUw5Jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E161F00A3A;
	Wed,  9 Sep 2026 14:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963325;
	bh=2C1Cb2Hy54cqdxFKD44kKPRboqJijJUy2zz3q6mqaCQ=;
	h=From:To:Cc:Subject:Date;
	b=npBUw5JwQ+pyQsmzZcUhCYkCRgw1zezB+02lHPFjyd//WsR0iw5U7OJR2UpKtW7Mg
	 Cu5WH0hw+PYaq7nTpPmUDD3fbA82D7WF2NUOtw31pWxWgX3FOYv3VqRtDlSwsxmZLp
	 142LDVWpsQkv04whA+JQGF0HCLVHZbxFkhohJ51g=
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
Subject: [PATCH 6.18 000/583] 6.18.51-rc1 review
Date: Wed,  9 Sep 2026 15:34:45 +0200
Message-ID: <20260909134237.773280130@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.51-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.51-rc1
X-KernelTest-Deadline: 2026-09-11T13:42+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.51 release.
There are 583 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 11 Sep 2026 13:40:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.51-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.51-rc1

Frank Sorenson <sorenson@redhat.com>
    cifs: add fscache_resize_cookie() to cifs_setsize()

Muchun Song <muchun.song@linux.dev>
    mm/hugetlb_vmemmap: fix incorrect vmemmap restore in rollback

Christian Brauner <brauner@kernel.org>
    pidfs: protect PIDFD_GET_* ioctls() via ifdef

Zi Yan <ziy@nvidia.com>
    mm/huge_memory: use folio's memcg inside __folio_split()

Matthew Wilcox (Oracle) <willy@infradead.org>
    migrate: replace RMP_ flags with TTU_ flags

Zi Yan <ziy@nvidia.com>
    mm/huge_memory: replace can_split_folio() with direct refcount calculation

Zi Yan <ziy@nvidia.com>
    mm/huge_memory: change folio_split_supported() to folio_check_splittable()

Muchun Song <muchun.song@linux.dev>
    mm: thp: use folio_batch to handle THP splitting in deferred_split_scan()

Muchun Song <muchun.song@linux.dev>
    mm: thp: introduce folio_split_queue_lock and its variants

SJ Park <sj@kernel.org>
    mm/damon/core: initialize damos->last_applied

SJ Park <sj@kernel.org>
    mm/damon/core-kunit: handle region split failure in filter_out()

SJ Park <sj@kernel.org>
    mm/damon/sysfs: read addr_unit only once in damon_sysfs_apply_inputs()

SJ Park <sj@kernel.org>
    mm/damon/core: skip aging from repeated aggressive merging

SJ Park <sj@kernel.org>
    mm/damon/ops-common: use nr_accesses moving sum for quota score

SJ Park <sj@kernel.org>
    mm/damon/paddr: drop last same folio access check reuse optimization

SJ Park <sj@kernel.org>
    mm/damon/vaddr: drop last same folio access check optimization

SJ Park <sj@kernel.org>
    mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()

Robin Murphy <robin.murphy@arm.com>
    iommu/arm-smmu-v3: Add HAFT support for SVA

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: ab8500_fg: fix use-after-free on remove

Pan Chuang <panchuang@vivo.com>
    power: supply: ab8500_fg: Remove redundant dev_err()/dev_err_probe()

Song Hu <husong@kylinos.cn>
    Docs/ABI/damon: fix typo in intervals_goal sysfs path

Muchun Song <muchun.song@linux.dev>
    mm/hugetlb_vmemmap: fix __hugetlb_vmemmap_optimize_folios()

Kiryl Shutsemau <kas@kernel.org>
    hugetlb: remove VMEMMAP_SYNCHRONIZE_RCU

Kiryl Shutsemau <kas@kernel.org>
    mm: rework compound_head() for power-of-2 sizeof(struct page)

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: set default primary compressor in zram_destroy_comps()

Yuwen Chen <ywen.chen@foxmail.com>
    zram: fix the issue that the write - back limits might overflow

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: read slot block idx under slot lock

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: drop wb_limit_lock

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: take write lock in wb limit store handlers

Longlong Xia <xialonglong@kylinos.cn>
    zram: fix out-of-bounds access in read_block_state()

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: fixup read_block_state()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent client use-after-free during close_lru reaping

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent client use-after-free during blocked-lock reaping

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Consolidate the revocation-path client unpin

Bryam Vargas <hexlabsecurity@proton.me>
    smb: client: reject a tree connect response whose byte count is too small

David Howells <dhowells@redhat.com>
    cifs: Do some preparation prior to organising the function declarations

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix OOB read/write from unvalidated DataOffset in coalesce_t2()

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix UAF and buffer leak in cifs_check_trans2() for malformed secondary T2

David Howells <dhowells@redhat.com>
    cifs: SMB1 split: Separate out SMB1 decls into smb1proto.h

David Howells <dhowells@redhat.com>
    cifs: SMB1 split: Create smb1proto.h for SMB1 declarations

David Howells <dhowells@redhat.com>
    cifs: Remove dead function prototypes

Jiangshan Yi <yijiangshan@kylinos.cn>
    smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions

David Howells <dhowells@redhat.com>
    cifs: Scripted clean up fs/smb/client/smb2proto.h

David Howells <dhowells@redhat.com>
    cifs: Scripted clean up fs/smb/client/fs_context.h

David Howells <dhowells@redhat.com>
    cifs: Scripted clean up fs/smb/client/fscache.h

David Howells <dhowells@redhat.com>
    cifs: Scripted clean up fs/smb/client/cifs_unicode.h

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent client use-after-free during admin state revocation

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent client use-after-free during delegation revoke

Jeff Layton <jlayton@kernel.org>
    nfsd: convert global state_lock to per-net deleg_lock

Jeff Layton <jlayton@kernel.org>
    nfsd: close shrinker/GC/fsnotify vs per-net shutdown race in filecache

Jeff Layton <jlayton@kernel.org>
    nfsd: fix UAF in async copy cancel and shutdown

Jeff Layton <jlayton@kernel.org>
    nfsd: fix fcache_disposal UAF by inlining dispose state into nfsd_net

Jeff Layton <jlayton@kernel.org>
    nfsd: fix clock domain mismatch in clients_still_reclaiming()

Jeff Layton <jlayton@kernel.org>
    nfsd: widen nfsd_genl_rqstp address fields to sockaddr_storage

Jeff Layton <jlayton@kernel.org>
    nfsd: move struct nfsd_genl_rqstp to nfsctl.c

Jeff Layton <jlayton@kernel.org>
    nfsd: check nfsd4_acl_to_attr() return value in nfsd4_create()

Jiayuan Chen <jiayuan.chen@linux.dev>
    net: advertise TCP MSS from the configured MTU, not the learned PMTU

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

Xiang Mei <xmei5@asu.edu>
    fuse: copy request headers via a stack buffer for io-uring

Joanne Koong <joannelkoong@gmail.com>
    fuse-uring: use named constants for io-uring iovec indices

Joanne Koong <joannelkoong@gmail.com>
    fuse-uring: refactor setting up copy state for payload copying

Joanne Koong <joannelkoong@gmail.com>
    fuse-uring: use enum types for header copying

Joanne Koong <joannelkoong@gmail.com>
    fuse-uring: refactor io-uring header copying from ring

Joanne Koong <joannelkoong@gmail.com>
    fuse-uring: refactor io-uring header copying to ring

Joanne Koong <joannelkoong@gmail.com>
    fuse: fix missing barrier when checking io-uring readiness

Ali Tariq <alitariq45892@gmail.com>
    PCI: starfive: Fix resource leaks on error paths in host_init()

Hal Feng <hal.feng@starfivetech.com>
    PCI: starfive: Use regulator APIs to control the 3v3 power supply of PCIe slots

Oscar Ou <oscarou@synology.com>
    lockd: fix swapped arguments in nlmsvc_match_ip()

Doruk Tan Ozturk <doruk@0sec.ai>
    ocfs2: validate directory-index entry counts when reading metadata

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: validate dx_root extent list fields during block read

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Make cpu_buffer::free_page a buffer_data_read_page

Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>
    ASoC: codecs: aw88261: only check PLL and clock state at power-up

Val Packett <val@packett.cool>
    ASoC: codecs: aw88261: reduce log spam

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    remoteproc: qcom: pas: Guard dtb metadata release with dtb_pas_id check

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware: qcom_scm: Rename peripheral as pas_id

Tejun Heo <tj@kernel.org>
    sched/core: Make core-sched flips wait for in-flight selections

John Stultz <jstultz@google.com>
    sched: Rework prev_balance() to avoid stale prev references

John Stultz <jstultz@google.com>
    sched: Add assert_balance_callbacks_empty helper

Tejun Heo <tj@kernel.org>
    sched_ext: Fix inverted ops.core_sched_before() invocation

Linkai Gong <gonglinkai@kylinos.cn>
    scsi: fnic: Use GFP_ATOMIC for VLAN alloc under spinlock

Abhijit Gangurde <abhijit.gangurde@amd.com>
    RDMA/ionic: Embed counter driver data in rdma_counter allocation

fangqiurong <fangqiurong@kylinos.cn>
    sched_ext: Fix exit_task leak on fork failure during enable

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Reject Read lists that exceed the page budget

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Reject oversized Read segments at decode time

Chuck Lever <chuck.lever@oracle.com>
    rpcrdma: arm rn_done before publishing the notification

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Reorder rpcrdma_rn_unregister before rdma_destroy_id

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Release transport resources synchronously

Chris Mason <clm@meta.com>
    SUNRPC: fix gssx_dec_option_array error path bugs

Dave Jiang <dave.jiang@intel.com>
    cxl/mce: Make the MCE notifier per-region

Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
    cxl/region: Add helper to check Soft Reserved containment by CXL regions

Dan Williams <dan.j.williams@intel.com>
    dax/cxl, hmem: Initialize hmem early and defer dax_cxl binding

Terry Bowman <terry.bowman@amd.com>
    cxl/ras: Fix cxl_rch_get_aer_severity() wrong severity register

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

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: TAD: Add locking around AML evaluations

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: TAD: Rearrange RT data validation checking

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: x86/rtc-cmos: Use platform device for driver binding

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: x86: cmos_rtc: Create a CMOS RTC platform device

Christian Loehle <christian.loehle@arm.com>
    ACPI: CPPC: Reject desired_perf reads on _CPC revision 4+

Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
    erofs: skip sufficiently large global buffers when resizing

Jiangshan Yi <yijiangshan@kylinos.cn>
    HID: mcp2221: clear rxbuf after I2C/SMBus transfer completes

Florian Pradines <florian.pradines@gmail.com>
    HID: mcp2221: fix OOB write in mcp2221_raw_event()

Doruk Tan Ozturk <doruk@0sec.ai>
    HID: sony: clean up device list on probe failure

Rosalie Wanders <rosalie@mailbox.org>
    HID: sony: use guard() and scoped_guard()

Frank Sorenson <sorenson@redhat.com>
    cifs: add cifs_resize_file_locked() to guard fscache_resize_cookie() under i_rwsem

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: emulate small EOF-extending mode 0 fallocate ranges

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: reduce fallocate zero buffer allocation

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb: move some definitions from common/smb2pdu.h into common/fscc.h

Sam Edwards <cfsworks@gmail.com>
    ceph: properly decrypt filenames in vmalloc() buffers

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Guard admin state-revocation walks with NFSD_NET_UP

Max Kellermann <max.kellermann@ionos.com>
    ceph: force a cap message when a deferred revoke can't be acked immediately

Michael Bommarito <michael.bommarito@gmail.com>
    ceph: cap delegated inode count in ceph_parse_deleg_inos()

Terry Bowman <terry.bowman@amd.com>
    cxl/ras: Fix cxl_rch_get_aer_info() out-of-bounds AER register read

Terry Bowman <terry.bowman@amd.com>
    cxl/pci: Move CXL driver's RCH error handling into core/ras_rch.c

Neill Kapron <nkapron@google.com>
    usb: gadget: f_fs: Fix Use-After-Free in AIO error path

Gabriel Prostitis <prostitisgabriel@gmail.com>
    USB: gadget: ffs: fix mm lifetime handling

Brendan Jackman <jackmanb@google.com>
    mm/page_alloc: don't spin_trylock() in NMI on UP

Roger Pau Monne <roger@xenproject.org>
    x86/xen: fix init of balloon stats again

Roger Pau Monne <roger.pau@citrix.com>
    xen/balloon: improve accuracy of initial balloon target for dom0

Li Xiasong <lixiasong1@huawei.com>
    mm/slub: fix missing debugfs entries for caches created before sysfs init

Vlastimil Babka <vbabka@suse.cz>
    mm/slab: move and refactor __kmem_cache_alias()

Dev Jain <dev.jain@arm.com>
    mm/rmap: use huge_ptep_get() in try_to_migrate_one()

Kairui Song <kasong@tencent.com>
    mm/mglru: fix and remove redundant unevictable folio handling

Kairui Song <kasong@tencent.com>
    mm/mglru: use the common routine for dirty/writeback reactivation

Muchun Song <muchun.song@linux.dev>
    mm/hugetlb: initialize gigantic bootmem hugepage struct pages earlier

Kiryl Shutsemau <kas@kernel.org>
    mm/hugetlb: refactor code around vmemmap_walk

Kiryl Shutsemau (Meta) <kas@kernel.org>
    mm/hugetlb: defer vmemmap population for bootmem hugepages

FUJITA Tomonori <fujita.tomonori@gmail.com>
    rust: bug: prevent dead_code warning from warn_on!'s flags constant

Danilo Krummrich <dakr@kernel.org>
    rust: devres: fix race between concurrent revokers

Danilo Krummrich <dakr@kernel.org>
    rust: devres: fix race condition due to nesting

Chen Linxuan <me@black-desk.cn>
    pidfd: hold exec_update_lock around namespace ioctl

Christian Brauner <brauner@kernel.org>
    pidfs: simplify PIDFD_GET_<type>_NAMESPACE ioctls

Vivek Parikh <vivek.parikh@breachx.ai>
    ovl: fix double end_creating() on the casefold-mismatch path

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - avoid stale fallback key after set_secret failure

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - clean up and improve ECDH comments

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - replace min_t with min

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    crypto: iaa - unmap dst before software fallback on decompress

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: iaa - fall back to software for multi-entry scatterlists

Eric Dumazet <edumazet@google.com>
    vlan: fix skb_under_panic and races when toggling HW VLAN offload

Kyle Zeng <kylebot@openai.com>
    net/packet: defer vmalloc TX_RING free until skbs finish

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix race between interrupt and resend

Miklos Szeredi <mszeredi@redhat.com>
    fuse: remove fm arg of args->end callback

Miklos Szeredi <mszeredi@redhat.com>
    fuse: split off fuse_args and related definitions into a separate header

Joanne Koong <joannelkoong@gmail.com>
    fuse: publish io-uring queues with release semantics

Breno Leitao <leitao@debian.org>
    usb: xhci: bail out of setup if the controller is inaccessible

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: simplify handling of Structural Parameters 1 values

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: use cached HCSPARAMS1 value

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: implement USB Port Register Set struct

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: add USB Port Register Set struct

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: add helper to read PORTSC register

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: add tracing for PORTSC register writes

David Howells <dhowells@redhat.com>
    afs: Fix leak of ungot volume

Abdifatah Suruur <suruurism@gmail.com>
    ksmbd: fix use-after-free in oplock break notification

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/gsp: fix vblank interrupts on GB20x

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/disp: fix head state readback on GB20x

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/disp: fix HDMI GCP AVMute register offsets on GB20x

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/disp: fix HDMI vendor infoframes on GB20x

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/disp: route GSP-RM display MMIO through nvkm_disp_func hooks

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/disp: move the GSP HDMI GCP AVMute write to engine/disp

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/disp: move GSP head-timing ISR and vblank helpers to tu102.c

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau/uvmm: clear the dirty flag when unwinding an OP_UNMAP_SPARSE

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau/uvmm: fix premature region free on failed OP_UNMAP_SPARSE

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau/uvmm: fix NULL deref unwinding an OP_MAP_SPARSE op

Faith Ekstrand <faith.ekstrand@collabora.com>
    drm/nouveau: Use write-combined maps for coherent

Marek Czernohous <marek@czernohous.de>
    drm/nouveau: unsubscribe the channel-kill event before the fence context

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/gsp: use per-version DP_CONFIG_STREAM params on r570 firmware

Shixiong Ou <oushixiong@kylinos.cn>
    drm/sysfb: ofdrm: Fix is_avivo() constant comparison bug

Shixiong Ou <oushixiong@kylinos.cn>
    drm/sysfb: ofdrm: Fix integer overflow in fb_size calculation

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: simpledrm: Improve stride validation

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: simpledrm: Improve panel-size validation

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: simpledrm: Improve framebuffer-size validation

Sunday Clement <Sunday.Clement@amd.com>
    drm/amdkfd: Reject zero-sized AQL queue allocations after size halving

Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>
    drm/amdkfd: guard against NULL restore_mqd in CRIU queue restore

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Fix the case that vm range is hole at svm_migrate_copy_to_vram

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Fix error path at svm_migrate_copy_to_ram

Priya Hosur <Priya.Hosur@amd.com>
    drm/amdkfd: Add TLB flush after MES queue eviction/suspension

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: use AMDGPU_GPU_PAGE_SHIFT instead of PAGE_SHIFT

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: update the fw version for gfx12 userqueues

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: update the fw version for gfx11 userqueues

Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>
    drm/amdgpu: Skip accessing psp rum time db for APUs

Guangshuo Li <lgs201920130244@gmail.com>
    drm/amdgpu: fix autosuspend cleanup during removal

Yang Wang <kevinyang.wang@amd.com>
    drm/amdgpu: Disable runtime PM for externally attached dGPUs

Xiang Liu <xiang.liu@amd.com>
    drm/amdgpu: clamp the isolation index for rings outside a partition

Yang Wang <kevinyang.wang@amd.com>
    drm/amdgpu: check thunderbolt before switcheroo registration

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    drm: Fix drm_crtc_commit leak if signaled when PAGE_FLIP_EVENT is used

Kavan Smith <kavansmith82@gmail.com>
    drm/msm/dsi: round 6G byte clock rate to the PLL-achievable value

Tao Yu <tao1.yu@intel.com>
    drm/gud: validate TV mode names before creating enum property

Deepanshu Kartikey <kartikey406@gmail.com>
    drm/gud: NUL-terminate TV mode names read from the device

David (Ming Qiang) Wu <David.Wu3@amd.com>
    drm/amdgpu/vcn: fix integer overflow in dec_msg buffer count check

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: validate plane degamma LUT size for private color prop

Linkai Gong <gonglinkai@kylinos.cn>
    drm/amd/display: fix dc_lock leak on GPU reset error paths

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: avoid divide-by-zero in __is_lut_linear()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/hibmc: Use drm_atomic_helper_check_plane_state()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/hibmc: Fix list of formats on the primary plane

Lyude Paul <lyude@redhat.com>
    drm/nouveau/disp/r535: Add scanline position support + head state support

Amit Barzilai <amit.barzilai22@gmail.com>
    drm/ssd130x: fix column and row end address in partial updates in ssd133x

Wentao Liang <vulab@iscas.ac.cn>
    drm/sun4i: fix refcount leak in sun4i_backend_init_sat()

Amit Barzilai <amit.barzilai22@gmail.com>
    drm/ssd130x: fix column and row end address in partial updates for ssd132x

Deepanshu Kartikey <kartikey406@gmail.com>
    drm/i915: Guard against NULL driver_data in i915_pci_probe()

Danilo Krummrich <dakr@kernel.org>
    drm: fix race between partial drm_dev_register() failure and ioctl

Johan Hovold <johan@kernel.org>
    drm/panel-edp: fix i2c adapter leak on probe failure

Johan Hovold <johan@kernel.org>
    drm/bridge: dw-hdmi: fix i2c adapter leak on probe failure

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: fix firmware control interface bounds checks

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: harden firmware build-info bounds checks

Matthew Auld <matthew.auld@intel.com>
    drm/xe/vram: report FLAT_CCS base misalignment

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/amdgpu: Fix init ordering in amdgpu_vram_mgr_init()

Chao Yu <chao@kernel.org>
    f2fs: fix to zero post-EOF data when extending file size

Chao Yu <chao@kernel.org>
    f2fs: fix to pass folio->index to f2fs_sanity_check_node_footer()

Chen Changcheng <chenchangcheng@kylinos.cn>
    f2fs: fix valid block count leak on data block allocation failure

Chao Yu <chao@kernel.org>
    f2fs: fix to clear dirty flag on folio in error path

Chao Yu <chao@kernel.org>
    f2fs: fix to off-by-one issue in f2fs_zero_post_eof_page()

Zhan Xusheng <zhanxusheng1024@gmail.com>
    f2fs: fix i_size when pinned fallocate partially fails

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential deadloop in f2fs_fsync_node_pages()

Daeho Jeong <daehojeong@google.com>
    f2fs: fix to migrate all curseg types during free_segment_range

Wenjie Qi <qwjhust@gmail.com>
    f2fs: avoid NULL checkpoint thread access in sysfs

Guanghui Yang <3497809730@qq.com>
    f2fs: fix dentry folio leak in find_in_level

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential section-unaligned pinfile

Wenjie Qi <qwjhust@gmail.com>
    f2fs: return writeback error from collapse range

Zhan Xusheng <zhanxusheng1024@gmail.com>
    f2fs: use the mount idmap for the owner check in f2fs_xattr_advise_set()

Joanne Chang <joannechien@google.com>
    f2fs: dirty directory inodes on mtime/ctime update

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid move_range and defragment on device_alias file

Wenjie Qi <qwjhust@gmail.com>
    f2fs: only redirty pinned folios in redirty_blocks

Hao-Qun Huang <alvinhuang0603@gmail.com>
    f2fs: reject overlapping move range after len expansion

Wenjie Qi <qwjhust@gmail.com>
    f2fs: return symlink writeback errors

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Skip NVMe LS reject IOCB when FW not started

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero-init bsg stack buffers to avoid info leak

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Use coherent DMA buffer for D_Port diagnostics

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Hold vport_slock for host map update in report ID acquisition

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Drop vport reference under lock in report ID acquisition

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Avoid req_q_map double-read in qla2x00_error_entry()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound rsp_info_len to avoid OOB sense-data read

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Avoid double completion in async IOCB timeout

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Quiesce response IRQ before freeing request queue

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix response queue over-consumption in __qla_consume_iocb()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Reject non-SCSI SRB on status IOCB fast path

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Don't query firmware state while chip is down

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix FCE trace enable parsing in debugfs

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero mailbox struct in qla2x00_get_firmware_state()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix FCE trace use-after-free during firmware dump

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix cs84xx use-after-free on host teardown

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Serialize flash version read in reset handler

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Clamp MSI-X derived queue counts to avoid truncation

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Hold qpair lock when sending NVMe LS reject

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Initialize NVMe abort_work once at submission

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix Name Server logout detection on FWI2 adapters

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound i2c->length in I2C bsg handlers

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero SFP DMA buffer in FRU/I2C bsg handlers

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Set inst->std during default format initialization

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Guard bit depth check with initial_info_obtained

Hungyu Lin <dennylin0707@gmail.com>
    media: qcom: iris: use disable_irq() during power-off

Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
    media: qcom: iris: fix state-change debug log printing stale value

Ruoyu Wang <ruoyuw560@gmail.com>
    media: zoran: Avoid freeing a registered video_device twice

Arash Golgol <arash.golgol@gmail.com>
    media: vimc: fix pixel format lookup in enum_framesizes

Uday Khare <udaykhare77@gmail.com>
    media: video-i2c: fix kthread error pointer left in kthread_vid_cap on failure

Mohammed EL Kadiri <med08elkadiri@gmail.com>
    media: venus: fix payload size calculation in parse_raw_formats()

Mohammed EL Kadiri <med08elkadiri@gmail.com>
    media: venus: fix payload size returned by parse_caps() and parse_alloc_mode()

Biren Pandya <birenpandya@gmail.com>
    media: v4l2-fwnode: Fix fwnode leak in v4l2_fwnode_parse_link

Ming Qian <ming.qian@oss.nxp.com>
    media: v4l2-ctrls: Allow unknown HDR10 white point and luminance

Xu Rao <raoxu@uniontech.com>
    media: v4l2-async: avoid deleting unlinked ASC entry on link error

Ilya Krutskih <devsec@tpz.ru>
    media: tda18250: fix possible integer overflow

Guangshuo Li <lgs201920130244@gmail.com>
    media: saa7164: fix cleanup on resource allocation failure

Lei Huang <huanglei@kylinos.cn>
    media: s2255: check firmware size before reading trailing marker

HyeongJun An <sammiee5311@gmail.com>
    media: s2255: bound JPEG frame size before copying into the buffer

Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
    media: rzg2l-cru: Align bytesperline to hardware DMA stride requirement

Valery Borovsky <vebohr@gmail.com>
    media: rtl2832_sdr: release URBs and stream buffers on start_streaming() failure

Valery Borovsky <vebohr@gmail.com>
    media: rtl2832_sdr: use vb2_video_unregister_device() on remove to fix DMA leak

Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
    media: rkvdec: Propagate platform_get_irq() errors

Myeonghun Pak <mhun512@gmail.com>
    media: rc: sunxi-cir: Unregister rc device on probe failure

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    media: nxp: imx8-isi: Use BIT_ULL() for 64-bit stream masks

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    media: nxp: imx8-isi: Correct color map between V4L2 and ISI

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    media: nxp: imx8-isi: Fix stream ID validation bypass in crossbar routing

Johan Hovold <johan@kernel.org>
    media: platform: mtk-mdp3: fix NULL deref on failed SCP lookup

Guangshuo Li <lgs201920130244@gmail.com>
    media: platform: mtk-mdp3: Fix SCP device refcounting

Christian Hewitt <christianshewitt@gmail.com>
    media: meson: vdec: fix NULL pointer deref in vdec_try_fmt_common

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: iris: Enumerate cap->bus_info to differentiate between encoder and decoder

Cong Nguyen <congnt264@gmail.com>
    media: intel/ipu6: fix async notifier cleanup leak on parse error

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: imx355: Avoid calling imx355_power_off twice in error path

Biren Pandya <birenpandya@gmail.com>
    media: i2c: ov7740: fix use-after-destroy in remove

Biren Pandya <birenpandya@gmail.com>
    media: i2c: ov02a10: fix endpoint parsing use-after-free

Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
    media: i2c: imx415: Return test pattern write errors

Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
    media: i2c: imx415: Release runtime PM reference on VBLANK error

Martin Hecht <mhecht73@gmail.com>
    media: i2c: alvium: Fix: Correct name of register in alvium_set_ctrl_auto_exposure

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    media: go7007: defer the ALSA v4l2 put until card release

Jiangong.Han <jiangong.han@windriver.com>
    media: em28xx: fix use-after-free of dev_next->devlist on disconnect

Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
    media: em28xx: defer audio-only extension registration

Fan Wu <fanwu01@zju.edu.cn>
    media: cx23885: cancel NetUP CI work before teardown

Bryam Vargas <hexlabsecurity@proton.me>
    media: cx231xx: reject geometry changes while the VBI queue is busy

Ruoyu Wang <ruoyuw560@gmail.com>
    media: cobalt: Avoid freeing ALSA private data twice

Dawei Feng <dawei.feng@seu.edu.cn>
    media: cedrus: fix memory leak in cedrus_init_ctrls()

Ruoyu Wang <ruoyuw560@gmail.com>
    media: cec: Serialize exclusive follower delivery

Yi Ding <yi.s.ding@gmail.com>
    media: cec: meson: ao-cec-g12a: name the CEC core regmap to avoid debugfs clash

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: cec: extron-da-hd-4k-plus: add sanity check

Biren Pandya <birenpandya@gmail.com>
    media: cec: disable delayed work before freeing an interrupted transmit

Jonas Karlman <jonas@kwiboo.se>
    media: cec: core: Fix kmemleak due to missed rc_free_device() call

Ming Qian <ming.qian@oss.nxp.com>
    media: amphion: Remove obsolete frame_count check in venc_start_session

Valery Borovsky <vebohr@gmail.com>
    media: airspy: use vb2_video_unregister_device() on disconnect to fix NULL deref

Danilo Krummrich <dakr@kernel.org>
    rust: drm: ioctl: fix unbounded lifetimes in ioctl handler arguments

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    LoongArch: Avoid preempt count underflow without probe

Wentao Guan <guanwentao@uniontech.com>
    LoongArch: Do not save/restore percpu base register in rethook trampoline

Nathan Chancellor <nathan@kernel.org>
    LoongArch: Do not select HAVE_RUST when KASAN is enabled

Bibo Mao <maobibo@loongson.cn>
    LoongArch: Fix acpi_package_ids[] array overflow

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Refactor jump offset calculation in tail call

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Optimize redundant TCC loads in epilogue

Han Gao <gaohan@iscas.ac.cn>
    LoongArch: Add DIRECT_MAP_PHYSMEM_END definition

Zeng Chi <zengchi@kylinos.cn>
    LoongArch: KVM: Preserve memslot arch flags on KVM_MR_FLAGS_ONLY

Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
    LoongArch: KVM: Free init resources if kvm_init() fails

Tao Cui <cuitao@kylinos.cn>
    LoongArch: KVM: Fix TOCTOU race on pv_features

Zeng Chi <zengchi@kylinos.cn>
    LoongArch: KVM: Fix PC double advance in kernel MMIO read fast path

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Correctly cap TLBI Range to the architural limit

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: vgic-its: Don't dereference a NULL collection on ITT save

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: vgic: Reset in_kernel on private IRQ allocation failure

Kajetan Puchalski <kajetan.puchalski@arm.com>
    KVM: arm64: vgic: Fix detection of MI on no pending LR

Qihang <q.h.hack.winter@gmail.com>
    KVM: arm64: vgic-v3: take an LPI reference in vgic_v3_save_pending_tables

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Sign-extend VA for range-based TLBI invalidation

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Make VNCR invalidation participate in MMU invalidation retry

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Correctly handle end of VA space TLBI invalidation

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Handle negative S1 walk levels in VNCR TLB size evaluation

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Consider SCTLR_EL2.M when mapping the L1 VNCR page

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Restore sigset on error path

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: pv: Fix rc/rrc offset for PVM_DUMP

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix memory corruption by not reinjecting CK machine checks

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Zero initialize irq in reinject_machine_check

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Take srcu when importing watchpoint data

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Free guest debug data on vcpu destroy

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix old_data leak in guest debug error path

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix memory leak in guest debug handling

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix length check __import_wp_info()

Sean Christopherson <seanjc@google.com>
    KVM: x86: Ensure runtime reads of disabled_quirks are resolved once

Sean Christopherson <seanjc@google.com>
    KVM: x86: Serialize writes to disabled_quirks using kvm->lock

Carlos López <clopez@suse.de>
    KVM: x86: hyper-v: Clamp stimer deadline to avoid livelock

Phil Rosenthal <phil@phil.gs>
    KVM: x86/mmu: Consume the locked rmap value in the lockless rmap walk

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Use split "zap all fast" helpers when invalidating memslot

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Use CMPXCHG when clearing Accessed bit in TDP MMU

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Split kvm_mmu_zap_all_fast() into "front" and "back" halves

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Fold kvm_mmu_zap_memslot() into kvm_arch_flush_shadow_memslot()

Yosry Ahmed <yosry@kernel.org>
    KVM: nVM: Ensure INVVPID is emulated on the correct physical CPU

Yosry Ahmed <yosry@kernel.org>
    KVM: nVMX: Service local TLB flushes on failed nested VM-Enter

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Ensure KVM_REQ_GET_NESTED_STATE_PAGES is cleared on VM-Exit

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Decouple INVVPID operand checks from flushing of vpid02

Yosry Ahmed <yosry@kernel.org>
    KVM: nVMX: Always flush vpid02 on first use

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: Validate arch_compat against host compatibility mode

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: opt4001: Fix reversed GENMASK() arguments in fault count mask

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: opt4001: Reject integration times with a non-zero seconds part

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: opt4001: Fix incompatible pointer type passed to div_u64_rem()

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: opt4001: Fix power down clearing bits of the wrong register

Vidhu Sarwal <vidhu.linux@gmail.com>
    iio: light: opt4060: Fix incorrect register name in threshold read error message

Vidhu Sarwal <vidhu.linux@gmail.com>
    iio: light: opt4060: Reject integration times with a non-zero seconds part

Paul Geurts <paul.geurts@prodrive-technologies.com>
    iio: ti-ads7138: Disable STATS_EN bit while reading conversion results

Sanjay Chitroda <sanjayembeddedse@gmail.com>
    iio: temperature: hid-sensor-temperature: switch to non-devm iio_device_register()

Cong Nguyen <congnt264@gmail.com>
    iio: srf04: fix pm_runtime handling on probe error path

Can Peng <pengcan@kylinos.cn>
    iio: pressure: mpl115: Fix runtime PM cleanup

Rupesh Majhi <zoone.rupert@gmail.com>
    iio: pressure: dps310: fix NULL pointer dereference on ACPI probe

Vidhu Sarwal <vidhu.linux@gmail.com>
    iio: light: ltrf216a: fix runtime PM reference leak in error path

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    iio: light: gp2ap002: Disable regulators on resume failure

Giorgi Tchankvetadze <giorgi@tchankvetadze.com>
    iio: light: cm32181: return zero after writing calibscale

Cong Nguyen <congnt264@gmail.com>
    iio: gyro: mpu3050: fix sign of raw angular velocity readings

Erick Henrique <erick.henrique.rodrigues@usp.br>
    iio: dac: m62332: Fix regulator reference count imbalance

Babanpreet Singh <bbnpreetsingh@gmail.com>
    iio: dac: ad3552r-hs: fix scnprintf() buffer bound in data source show

Linmao Li <lilinmao@kylinos.cn>
    iio: chemical: sgp30: Handle IAQ thread creation failure

Fan Wu <fanwu01@zju.edu.cn>
    iio: chemical: atlas-sensor: use iio_trigger_poll_nested() to fix remove UAF

Moksh Panicker <mokshpanicker.7@gmail.com>
    iio: chemical: atlas-sensor: fix PM reference leak in buffer postenable

Lars-Peter Clausen <lars@metafoo.de>
    iio: buffer: Tie IIO dma fence lock lifetime to the fence

Lars-Peter Clausen <lars@metafoo.de>
    iio: buffer: Make IIO DMA fence release RCU-safe

Lars-Peter Clausen <lars@metafoo.de>
    iio: buffer: Fix potential use-after-free in anonymous buffer release

Cong Nguyen <congnt264@gmail.com>
    iio: adc: pac1921: fix wrong channel used in trigger handler read

Joshua Crofts <joshua.crofts1@gmail.com>
    iio: adc: max34408: add missing 'select REGMAP_I2C' to Kconfig

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: adc: adi-axi-adc: add data size support for AD408X backend

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tegra210_i2s: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tegra210_i2s: sort the Tegra264 register default table

Jon Hunter <jonathanh@nvidia.com>
    ASoC: tegra: Fix the MIXER enable default value

Jon Hunter <jonathanh@nvidia.com>
    ASoC: tegra: Sort ADMAIF register defaults

Jon Hunter <jonathanh@nvidia.com>
    ASoC: tegra: Sort MBDRC register defaults

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tegra210_mixer: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tas2783-sdw: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tas2783-sdw: drop duplicate reg_default entry

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tas2780: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tas2764: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tas2552: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: sti-sas: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: sgtl5000: sort the register default table

WenTao Liang <vulab@iscas.ac.cn>
    ASoC: samsung: aries_audio_probe: double of_node_put due to direct assignment without of_node_get

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt721-sdca-sdw: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt715: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt715-sdca: sort the register default tables

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt715-sdca: drop duplicate reg_default entries

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt712-sdca-sdw: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt712-sdca-dmic: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt711: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt711-sdca: sort the register default tables

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt700: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt700: drop duplicate reg_default entry

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt298: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt286: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt274: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt1318: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt1318-sdw: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt1316-sdw: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt1017-sdca-sdw: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: pm4125-sdw: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: pcm512x: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: ml26124: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: max9860: sort the register default table

Binbin Zhou <zhoubinbin@loongson.cn>
    ASoC: loongson: Fix error handling in ACPI property parsing

Haoxiang Li <haoxiang_li2024@163.com>
    AsoC: intel: sst: fix PCI device reference leak on probe failure

Haoxiang Li <haoxiang_li2024@163.com>
    ASoC: hdac_hda: Fix hlink refcount leak on component registration failure

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: fsl_easrc: sort the register default table

wangdicheng <wangdicheng@kylinos.cn>
    ASoC: fsl_easrc: Use div64_u64 for 64-by-64 division

Haoxiang Li <haoxiang_li2024@163.com>
    ASoC: fsl: mpc5200-i2s: Free DMA resources on probe failure

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: cx2072x: sort the register default table

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ASoC: cs35l34: drain threaded IRQ before runtime suspend

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ASoC: cs35l33: drain threaded IRQ before runtime suspend

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: adau1761: sort the register default table

Linkai Gong <gonglinkai@kylinos.cn>
    i2c: mux: demux-pinctrl: fix OF node leak on kstrdup failure

Stephan Gerhold <stephan.gerhold@linaro.org>
    clk: qcom: gcc-mdm9607: Drop incorrect BIMC PLL and related clocks

Stephan Gerhold <stephan.gerhold@linaro.org>
    clk: qcom: gcc-mdm9607: Fix halt_reg for gcc_apss_axi_clk

Stephan Gerhold <stephan@gerhold.net>
    clk: qcom: gcc-mdm9607: Fix enable_reg for gcc_blsp1_sleep_clk

Stephan Gerhold <stephan@gerhold.net>
    clk: qcom: gcc-mdm9607: Drop incorrect system_noc_bfdcd_clk_src

Stephan Gerhold <stephan@gerhold.net>
    clk: qcom: gcc-mdm9607: Drop incorrect apss_tcu_clk_src

Heiko Stuebner <heiko.stuebner@cherry.de>
    clk: rockchip: rk3588: Don't change PLL rates when setting dclk_vop2_src

Stephan Gerhold <stephan.gerhold@linaro.org>
    clk: qcom: gcc-msm8939: Fix enable_reg for gcc_blsp1_sleep_clk

Stephan Gerhold <stephan.gerhold@linaro.org>
    clk: qcom: gcc-msm8916: Fix enable_reg for gcc_blsp1_sleep_clk

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: align gxbb_32k_clk_sel number of parents with actual count

Akari Tsuyukusa <akkun11.open@gmail.com>
    clk: mediatek: mt8196: Select REGMAP_MMIO for vlpckgen

Pavel Löbl <pavel@loebl.cz>
    clk: clocking-wizard: fix integer overflow in rate calculation

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: prevent CRC corruptions after claim flush

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: fix freeing of claims on meshif deletion

Sven Eckelmann <sven@narfation.org>
    batman-adv: dat: avoid unaligned fault in IP extraction

Sven Eckelmann <sven@narfation.org>
    batman-adv: mcast: linearize skbuff for packet generation

Sven Eckelmann <sven@narfation.org>
    batman-adv: mcast: ensure unshared skb for multicast packets

Zhiling Zou <zhilinz@nebusec.ai>
    batman-adv: fix stale receive device on merged fragments

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: rawnand: validate ONFI extended parameter page sections

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: nand: realtek-ecc: add missing MODULE_DEVICE_TABLE()

Xu Rao <raoxu@uniontech.com>
    mtd: mtdoops: free page bitmap when the backing MTD is removed

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: afs: validate v2 image info bounds

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix required lock not held during update of ap_matrix_mdev object

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: fix potential use of uninitialized apm_filtered bitmap

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix NULL deref in status_show() during queue probe

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix missing lock required to access list of ap_matrix_mdev objects

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix hot-unplug skipped when last AP adapter or domain removed

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix dereference matrix_mdev->kvm without checking for NULL

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix control domain removal in vfio_ap_mdev_cfg_remove

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix stale do_remove flag across iterations in vfio_ap_mdev_cfg_remove

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: fix stale pqap_hook pointer on error in vfio_ap_mdev_set_kvm()

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/crash: stop watchdogs before booting kdump kernel

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/pseries: Move H_WATCHDOG definitions to a common header

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/pseries: Handle and log pseries-wdt registration failures

Muchun Song <muchun.song@linux.dev>
    powerpc/mm: fix wrong addr_pfn tracking in compound vmemmap population

Jinjie Ruan <ruanjinjie@huawei.com>
    powerpc/kexec_file: Prevent kexec range truncation

Jinjie Ruan <ruanjinjie@huawei.com>
    powerpc/kexec_file: Fix null-ptr-def in extra size calculation

Helge Deller <deller@gmx.de>
    parisc: Fix alignment of asm statements in head.S

Pei Xiao <xiaopei01@kylinos.cn>
    parisc: eisa: Fix infinite loop when parsing invalid IRQ value

Bryam Vargas <hexlabsecurity@proton.me>
    nvdimm/btt: reject an arena whose nfree is below the lane count

Narek Jilavyan <njilav@gmail.com>
    mm/hugetlb_cgroup: call page_counter_set_max() outside VM_BUG_ON()

Longlong Xia <xialonglong@kylinos.cn>
    mm/hugetlb: keep max_huge_pages when dissolving surplus folios

Wupeng Ma <mawupeng1@huawei.com>
    mm/hugetlb: fix missing migratable flag on same-node hugetlb migration

caina <caina@uniontech.com>
    Revert "irqchip/mbigen: Fix mbigen node address layout"

Christian Marangi <ansuelsmth@gmail.com>
    pmdomain: airoha: fix unselectable AIROHA_CPU_PM_DOMAIN kconfig

Shivam Kumar <kumar.shivam43666@gmail.com>
    nvmet-tcp: reject unsolicited H2CData PDUs

Shivam Kumar <kumar.shivam43666@gmail.com>
    nvmet-tcp: fix out-of-bounds write when receiving an over-long PDU

Kazuki Hanai <hnkz.64@gmail.com>
    nvmet-auth: Synchronize timeout work during SQ teardown

Tristan Madani <tristan@talencesecurity.com>
    nvme: add missing SRCU grace period in error path

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvme-tcp: check the data direction of a C2HData PDU

Niklas Cassel <cassel@kernel.org>
    nvme-fc: fix double free of fabrics options when nvme_add_ctrl() fails

Xu Rao <raoxu@uniontech.com>
    nvme-fabrics: fix DHCHAP secret leak on parse failure

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix race between non-atomic ops and trigger-start

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: harmony: initialize locks before requesting IRQ

HyeongJun An <sammiee5311@gmail.com>
    ALSA: rawmidi: Return the error from snd_rawmidi_input_params()

Khushit Shah <khushit.shah@nutanix.com>
    arm64: errata: pass REVIDR when matching target implementation CPUs

Karl Mehltretter <kmehltretter@gmail.com>
    arm64: mm: Fix the lockless page-table walk in show_pte()

Ahmad Byagowi <ahmadexp@gmail.com>
    i2c: mux: Fix channel node leak on adapter add failure

Vasileios Almpanis <vasilisalmpanis@gmail.com>
    i2c: core: fix debugfs UAF on adapter removal

Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
    i2c: qcom-geni: update frequency table to fix timing parameters

Hongbo Yao <andy.xu@hj-micro.com>
    i2c: designware: Enable interrupt mask workaround for HJMC3001

Sizhe Liu <liusizhe5@huawei.com>
    perf hisi-ptt: Fix PTT trace TLP header parsing

Viktor Malik <vmalik@redhat.com>
    perf trace: Refactor augmented_raw_syscalls using bpf_for

Viktor Malik <vmalik@redhat.com>
    perf trace: Factor out BPF loop body

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Fix kernel address leakages in LBR stack

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    rtc: rzn1: Disable alarm interrupt before reprogramming alarm registers

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    rtc: rzn1: Handle unset alarm weekday in rzn1_rtc_read_alarm

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    rtc: rzn1: Fix weekday underflow when alarm crosses month boundary

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    rtc: rzn1: Handle EPROBE_DEFER for optional pps interrupt

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: make the v1 soft limit knob inert

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: bypass the reclaim and oom killer for dying tasks once oom_reaper is done

Pengpeng Hou <pengpeng@iscas.ac.cn>
    Input: aiptek - validate raw macro indices before updating state

HE WEI（ギカク） <skyexpoc@gmail.com>
    fs/ntfs3: fix slab-out-of-bounds write in ni_create_attr_list()

Nirbhay Sharma <nirbhay.lkd@gmail.com>
    fs/ntfs3: fix KMSAN uninit-value in ni_create_attr_list

Eric Dumazet <edumazet@google.com>
    mm/mempolicy: fix sleeping allocation in alloc_pages_bulk_weighted_interleave()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: Protect kprobe_blacklist with RCU

Ju Nan <junan76@163.com>
    irqchip/stm32mp-exti: Fix the unit of the hwspinlock timeout

Bradley Morgan <brads@mainlining.org>
    ima: Check for ERR_PTR from dentry_path() in validate_hash_algo()

Hajo Noerenberg <hajo-linux-ide@noerenberg.de>
    ata: ahci: work around lost interrupts on Marvell 88SE61xx

Max Kellermann <max.kellermann@ionos.com>
    ceph: lock mutex in ceph_mds_check_access()

Hui Su <sh_def@163.com>
    bpf: Fix infinite loop in pcpu_freelist push with one possible CPU

Damien Le Moal <dlemoal@kernel.org>
    block: flag zoned disks with GENHD_FL_NO_PART

Ulf Hansson <ulf.hansson@oss.qualcomm.com>
    cpuidle: psci: Fix support for probe deferral by dropping the faux device

Linkai Gong <gonglinkai@kylinos.cn>
    cpuidle: dt_idle_genpd: kfree() the original name allocation

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Initialize IRQ data before requesting IRQs

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Complete descriptors before pausing

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Fix HDMA channel status register access

Martin Kaiser <martin@kaiser.cx>
    dmaengine: fsl-edma: tracing: no ptr dereference during log output

Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
    dma-direct: return struct page from dma_direct_alloc_from_pool()

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix resume-vs-remove race

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix race when loading and unloading a table

Ibrahim Hashimov <security@auditcode.ai>
    HID: wacom: validate report length in wacom_intuos_pro2_bt_irq

Wei Jie Law <98lawweijie@gmail.com>
    HID: rmi: fix OOB access with undersized RMI reports

Shen Yongchao <grayhat@foxmail.com>
    HID: bpf: serialize device reference release in struct_ops destroy path

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Synchronize the initialization of ftrace_ops

Yao Kai <yaokai34@huawei.com>
    futex: Prevent rcuwait use-after-free during requeue PI

SJ Park <sj@kernel.org>
    mm/damon/core-kunit: check region count before testing in split_at()

SJ Park <sj@kernel.org>
    mm/damon/sysfs: kobject_del() target (normal), context and kdamond dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs: kobject_del() region and target (error) dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: kobject_del() scheme region dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: kobject_del() scheme quota goal dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: kobject_del() scheme filter dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: kobject_del() scheme dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: kobject_del() scheme action destination dirs

SJ Park <sj@kernel.org>
    samples/damon/wsse: stop and free damon ctx when damon_call() fails

SJ Park <sj@kernel.org>
    samples/damon/wsse: handle damon_start() failure

SJ Park <sj@kernel.org>
    samples/damon/prcl: stop and free damon ctx when damon_call() fails

SJ Park <sj@kernel.org>
    samples/damon/prcl: handle damon_start() failure

SJ Park <sj@kernel.org>
    samples/damon/mtier: handle damon_stop() failure

SJ Park <sj@kernel.org>
    samples/damon/mtier: handle damon_start() failure

SJ Park <sj@kernel.org>
    mm/damon/vaddr-kunit: check region count in three_regions test

Runyu Xiao <runyu.xiao@seu.edu.cn>
    scsi: pm8001: Use rollback index when freeing MSI-X vectors

Thomas Lamprecht <t.lamprecht@proxmox.com>
    scsi: megaraid_sas: Limit NVMe request size to the PRP chain frame

Sujal Tuladhar <sujaltuladhar1231@gmail.com>
    scsi: target: iscsi: Reserve a terminator byte for the login payload

Honghui Jiang <jiang_hh2019@163.com>
    spi: Fix DMA mapping ownership on partial map failure

Can Peng <pengcan@kylinos.cn>
    spi: bcmbca-hsspi: disable clocks on resume failure

Can Peng <pengcan@kylinos.cn>
    spi: bcm63xx: disable clock on resume failure

Can Peng <pengcan@kylinos.cn>
    spi: bcm63xx-hsspi: disable clocks on resume failure

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    soc: qcom: geni-se: Use HW PROG_RAM_DEPTH to validate firmware size

Kanishka De Silva <kpskanna1915@gmail.com>
    ublk: clear VM_MAYWRITE on read-only ublk char device mmap

Bryan Lim <foxieflakey@gmail.com>
    userfaultfd: reset err to be 0 when move_pages_ptes succeeded

Can Peng <pengcan@kylinos.cn>
    thermal/drivers/qoriq: Disable clock on resume failure

Can Peng <pengcan@kylinos.cn>
    thermal/drivers/imx: Disable clock on runtime resume failure

Arthur Gautier <baloo@superbaloo.net>
    xhci: fix lost bounce buffers on TDs spanning several ring segments

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in rtw_action_frame_parse()

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read / stack overflow in rtw_get_wps_attr()

Jeffin Philip <jeffinphilip14@gmail.com>
    usb: gadget: fix null pointer dereference in usb_put_function_instance()

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    USB: gadget: fix NULL pointer dereference in gadget_dev_ioctl()

Jeffin Philip <jeffinphilip14@gmail.com>
    usb: gadget: f_midi: initialize work in f_midi_alloc()

Ivy Lopez <skunkolee@gmail.com>
    usb: gadget: f_midi2: fix use-after-free in string attribute show path

Aleksandr Nogikh <nogikh@google.com>
    usb: gadget: midi2: Fix null-pointer dereference in f_midi2_free_ep_reqs

Jameson Thies <jthies@google.com>
    usb: typec: ucsi: displayport: Fix OOB altmode array index

Sven Peter <sven@kernel.org>
    usb: typec: tipd: Fix Thunderbolt altmode VDOs for cd321x

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: constrain TCPM_SOURCING_VBUS event handling

Fan Wu <fanwu01@zju.edu.cn>
    usb: typec: qcom-pmic: cancel reset_work on stop

Fan Wu <fanwu01@zju.edu.cn>
    usb: typec: qcom-pmic-typec: drain cc_debounce_dwork if port_start() fails

Fan Wu <fanwu01@zju.edu.cn>
    usb: typec: qcom-pmic-typec: disable cc_debounce_dwork on stop

Myeonghun Pak <mhun512@gmail.com>
    usb: storage: realtek_cr: fix use-after-free on disconnect

Elson Serrao <elson.serrao@oss.qualcomm.com>
    usb: dwc3: clear forceRM when issuing EndTransfer

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: f_mass_storage: Bump local buffer size in fsg_common_create_luns()

Liu Qi <liuqi@longcheer.com>
    usb-storage: ene_ub6250: fix race between scan work and probe

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    media: usbtv: keep device alive while ALSA card exists

Stephan Gerhold <stephan@gerhold.net>
    clk: qcom: gcc-mdm9607: Increase delay for USB PHY reset

HyeongJun An <sammiee5311@gmail.com>
    ALSA: usb-audio: fix OOB write in snd_usbmidi_us122l_output()

Griffin Kroah-Hartman <griffin@kroah.com>
    usb: image: mdc800: change kmalloc() to kzalloc()

Hari Mishal <harimishal1@gmail.com>
    drm/amd/display: fix division by zero in get_estimated_bw()

Anton Protopopov <a.s.protopopov@gmail.com>
    bpf: fix the return value of push_stack

Linus Torvalds <torvalds@linux-foundation.org>
    drm/xe: Don't hand out the flat CCS storage as usable VRAM

Sun Jian <sun.jian.kdev@gmail.com>
    fsnotify: inotify: pass mark connector to fsnotify_recalc_mask()

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Drop calls to restore power limit and clock from smu_resume()

Ali Ahmet Memis <ali@iusegentoo.com>
    mfd: qnap-mcu: keep the reply buffer alive past a command timeout

FUJITA Tomonori <fujita.tomonori@gmail.com>
    objtool/rust: add one more `noreturn` Rust function

Youngjae Kwon <yjkwon0026@snu.ac.kr>
    fsnotify: Fix stale object mask after concurrent mark updates

Jinjie Ruan <ruanjinjie@huawei.com>
    entry: Fix seccomp bypass after ptrace with TSYNC

Dev Jain <dev.jain@arm.com>
    mm/page_vma_mapped: use huge_ptep_get() for hugetlb

Yuqi Xu <xuyuqiabc@gmail.com>
    openvswitch: Fix CT limit teardown use-after-free

Norbert Szetei <norbert@doyensec.com>
    net: skbuff: don't skb_tx_error() the source skb in skb_zerocopy()


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-kernel-mm-damon    |   8 +-
 Documentation/admin-guide/cgroup-v1/memory.rst     |  49 +--
 Documentation/trace/hisi-ptt.rst                   |  28 +-
 .../media/v4l/ext-ctrls-colorimetry.rst            |  12 +-
 Makefile                                           |   4 +-
 arch/arm64/include/asm/kvm_nested.h                |  20 ++
 arch/arm64/kernel/cpu_errata.c                     |   2 +-
 arch/arm64/kvm/at.c                                |   2 -
 arch/arm64/kvm/nested.c                            |  94 ++++--
 arch/arm64/kvm/sys_regs.c                          |  11 +
 arch/arm64/kvm/vgic/vgic-init.c                    |   1 +
 arch/arm64/kvm/vgic/vgic-its.c                     |   8 +
 arch/arm64/kvm/vgic/vgic-v3-nested.c               |   2 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |  12 +-
 arch/arm64/mm/fault.c                              |  12 +-
 arch/loongarch/Kconfig                             |   2 +-
 arch/loongarch/include/asm/kvm_host.h              |   1 +
 arch/loongarch/include/asm/pgtable.h               |   7 +
 arch/loongarch/kernel/acpi.c                       |   3 +-
 arch/loongarch/kernel/kprobes.c                    |   3 +
 arch/loongarch/kernel/rethook_trampoline.S         |   2 -
 arch/loongarch/kvm/exit.c                          |   1 -
 arch/loongarch/kvm/main.c                          |   6 +-
 arch/loongarch/kvm/mmu.c                           |  10 +
 arch/loongarch/kvm/vcpu.c                          |   6 +-
 arch/loongarch/kvm/vm.c                            |   1 +
 arch/loongarch/net/bpf_jit.c                       |  22 +-
 arch/parisc/kernel/head.S                          |   1 +
 arch/powerpc/include/asm/papr-watchdog.h           |  64 ++++
 arch/powerpc/include/asm/reg.h                     |  12 +
 arch/powerpc/kexec/file_load_64.c                  |   2 +-
 arch/powerpc/kexec/ranges.c                        |  12 +-
 arch/powerpc/kvm/book3s_hv.c                       |  15 +-
 arch/powerpc/kvm/powerpc.c                         |   6 +
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   7 +-
 arch/powerpc/platforms/pseries/setup.c             |  28 +-
 arch/s390/include/asm/nmi.h                        |   3 +
 arch/s390/kernel/nmi.c                             |   5 +-
 arch/s390/kvm/guestdbg.c                           |   9 +-
 arch/s390/kvm/interrupt.c                          |  26 +-
 arch/s390/kvm/kvm-s390.c                           |  15 +-
 arch/x86/events/intel/lbr.c                        |  12 +-
 arch/x86/kernel/rtc.c                              |   4 +
 arch/x86/kvm/hyperv.c                              |  25 +-
 arch/x86/kvm/mmu/mmu.c                             | 102 +++---
 arch/x86/kvm/mmu/tdp_iter.h                        |   7 +
 arch/x86/kvm/mmu/tdp_mmu.c                         |  20 +-
 arch/x86/kvm/vmx/nested.c                          |  75 +++--
 arch/x86/kvm/x86.c                                 |   5 +-
 arch/x86/kvm/x86.h                                 |   2 +-
 block/genhd.c                                      |   7 +
 drivers/acpi/acpi_pnp.c                            |   2 +-
 drivers/acpi/acpi_tad.c                            | 186 +++++++----
 drivers/acpi/cppc_acpi.c                           |  13 +-
 drivers/acpi/x86/cmos_rtc.c                        |  13 +-
 drivers/ata/ahci.c                                 |  49 +++
 drivers/block/ublk_drv.c                           |   6 +
 drivers/block/zram/zram_drv.c                      |  65 ++--
 drivers/block/zram/zram_drv.h                      |   1 -
 drivers/clk/mediatek/Kconfig                       |   1 +
 drivers/clk/meson/gxbb.c                           |   2 +-
 drivers/clk/qcom/gcc-mdm9607.c                     | 182 +----------
 drivers/clk/qcom/gcc-msm8916.c                     |   5 +-
 drivers/clk/qcom/gcc-msm8939.c                     |   5 +-
 drivers/clk/rockchip/clk-rk3588.c                  |   2 +-
 drivers/clk/xilinx/clk-xlnx-clock-wizard.c         |   4 +-
 drivers/cpufreq/apple-soc-cpufreq.c                |  36 +--
 drivers/cpufreq/cppc_cpufreq.c                     |   2 +-
 drivers/cpuidle/cpuidle-psci.c                     |  42 +--
 drivers/cpuidle/dt_idle_genpd.c                    |   3 +-
 drivers/crypto/atmel-ecc.c                         |  50 ++-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         | 138 ++++----
 drivers/crypto/intel/iaa/iaa_crypto_stats.c        |   9 +
 drivers/crypto/intel/iaa/iaa_crypto_stats.h        |   2 +
 drivers/cxl/core/Makefile                          |   1 +
 drivers/cxl/core/core.h                            |  11 +-
 drivers/cxl/core/mbox.c                            |   8 -
 drivers/cxl/core/mce.c                             |  27 +-
 drivers/cxl/core/pci.c                             | 115 -------
 drivers/cxl/core/ras_rch.c                         | 136 ++++++++
 drivers/cxl/core/region.c                          | 122 ++++---
 drivers/cxl/cxl.h                                  |   9 +-
 drivers/cxl/cxlmem.h                               |   2 -
 drivers/dax/Makefile                               |   3 +-
 drivers/dax/cxl.c                                  |  27 +-
 drivers/dma/dw-edma/dw-edma-core.c                 |  23 +-
 drivers/dma/dw-edma/dw-hdma-v0-core.c              |   2 +-
 drivers/dma/fsl-edma-trace.h                       |   4 +-
 drivers/firmware/qcom/qcom_scm.c                   |  30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  26 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |   7 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   3 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  23 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |  56 ++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   6 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_color.c    |  13 +
 .../display/dc/link/protocols/link_dp_dpia_bw.c    |   5 +
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  13 -
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |   3 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |   2 +
 drivers/gpu/drm/drm_drv.c                          |  34 +-
 drivers/gpu/drm/gud/gud_connector.c                |  12 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c     |  54 +---
 drivers/gpu/drm/i915/i915_pci.c                    |   3 +
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  12 +
 drivers/gpu/drm/nouveau/include/nvkm/engine/disp.h |   1 +
 drivers/gpu/drm/nouveau/nouveau_chan.c             |   9 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c            |   4 +-
 drivers/gpu/drm/nouveau/nouveau_uvmm.c             |   6 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c  |  10 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/Kbuild    |   1 +
 drivers/gpu/drm/nouveau/nvkm/engine/disp/ga102.c   |  13 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c   | 191 +++++++++++
 drivers/gpu/drm/nouveau/nvkm/engine/disp/gv100.c   |   4 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/head.h    |   4 +
 drivers/gpu/drm/nouveau/nvkm/engine/disp/ior.h     |   1 +
 drivers/gpu/drm/nouveau/nvkm/engine/disp/priv.h    |  17 +
 drivers/gpu/drm/nouveau/nvkm/engine/disp/tu102.c   |  86 ++++-
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/disp.c | 129 +++-----
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/disp.c |  64 ++++
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/gsp.c  |   9 +
 .../nouveau/nvkm/subdev/gsp/rm/r570/nvrm/disp.h    |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/rm.h    |   5 +
 drivers/gpu/drm/panel/panel-edp.c                  |  19 +-
 drivers/gpu/drm/panthor/panthor_fw.c               |  22 +-
 drivers/gpu/drm/solomon/ssd130x.c                  |   9 +-
 drivers/gpu/drm/sun4i/sun4i_backend.c              |   2 +-
 drivers/gpu/drm/sysfb/ofdrm.c                      |   8 +-
 drivers/gpu/drm/sysfb/simpledrm.c                  |  74 ++++-
 drivers/gpu/drm/xe/xe_vram.c                       |  26 +-
 drivers/hid/bpf/hid_bpf_struct_ops.c               |  17 +-
 drivers/hid/hid-mcp2221.c                          |  15 +-
 drivers/hid/hid-rmi.c                              |  46 ++-
 drivers/hid/hid-sony.c                             |  78 ++---
 drivers/hid/wacom_wac.c                            |  13 +
 drivers/i2c/busses/i2c-designware-platdrv.c        |   2 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |   4 +-
 drivers/i2c/i2c-core-base.c                        |   6 +
 drivers/i2c/i2c-mux.c                              |   1 +
 drivers/i2c/muxes/i2c-demux-pinctrl.c              |   1 +
 drivers/iio/adc/Kconfig                            |   1 +
 drivers/iio/adc/adi-axi-adc.c                      |  30 ++
 drivers/iio/adc/pac1921.c                          |   2 +-
 drivers/iio/adc/ti-ads7138.c                       |  42 ++-
 drivers/iio/chemical/atlas-sensor.c                |  19 +-
 drivers/iio/chemical/sgp30.c                       |   3 +
 drivers/iio/dac/ad3552r-hs.c                       |   2 +-
 drivers/iio/dac/m62332.c                           |  17 +-
 drivers/iio/gyro/mpu3050-core.c                    |   2 +-
 drivers/iio/industrialio-buffer.c                  |  38 ++-
 drivers/iio/light/cm32181.c                        |   2 +-
 drivers/iio/light/gp2ap002.c                       |  10 +-
 drivers/iio/light/ltrf216a.c                       |   3 +-
 drivers/iio/light/opt4001.c                        |  37 +--
 drivers/iio/light/opt4060.c                        |   5 +-
 drivers/iio/pressure/dps310.c                      |   3 +-
 drivers/iio/pressure/mpl115.c                      |  11 +-
 drivers/iio/proximity/srf04.c                      |   1 +
 drivers/iio/temperature/hid-sensor-temperature.c   |   3 +-
 drivers/infiniband/hw/ionic/ionic_hw_stats.c       |  95 +++---
 drivers/infiniband/hw/ionic/ionic_ibdev.h          |  11 +-
 drivers/input/tablet/aiptek.c                      |  13 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c    |  14 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   9 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h        |   3 +
 drivers/irqchip/irq-mbigen.c                       |  20 +-
 drivers/irqchip/irq-stm32mp-exti.c                 |   4 +-
 drivers/md/dm.c                                    |  14 +-
 drivers/media/cec/core/cec-adap.c                  |  10 +-
 drivers/media/cec/core/cec-core.c                  |   2 -
 drivers/media/cec/platform/meson/ao-cec-g12a.c     |   1 +
 .../extron-da-hd-4k-plus/extron-da-hd-4k-plus.c    |   3 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  23 +-
 drivers/media/i2c/alvium-csi2.c                    |   2 +-
 drivers/media/i2c/imx355.c                         |   3 +-
 drivers/media/i2c/imx415.c                         |   4 +-
 drivers/media/i2c/ov02a10.c                        |  12 +-
 drivers/media/i2c/ov7740.c                         |   4 +-
 drivers/media/i2c/video-i2c.c                      |   8 +-
 drivers/media/pci/cobalt/cobalt-alsa-main.c        |   1 -
 drivers/media/pci/cx23885/cimax2.c                 |   1 +
 drivers/media/pci/intel/ipu6/ipu6-isys.c           |   1 +
 drivers/media/pci/saa7164/saa7164-core.c           |   8 +-
 drivers/media/pci/zoran/zoran_card.c               |   2 +-
 drivers/media/platform/amphion/venc.c              |   2 -
 .../platform/chips-media/wave5/wave5-vpu-dec.c     |   3 +-
 .../platform/chips-media/wave5/wave5-vpu-enc.c     |   6 +-
 .../media/platform/mediatek/mdp3/mtk-mdp3-core.c   |   6 +-
 .../platform/nxp/imx8-isi/imx8-isi-crossbar.c      |   6 +-
 .../media/platform/nxp/imx8-isi/imx8-isi-video.c   |   2 +-
 drivers/media/platform/qcom/iris/iris_state.c      |   2 +-
 drivers/media/platform/qcom/iris/iris_vidc.c       |  11 +-
 drivers/media/platform/qcom/iris/iris_vpu_common.c |   2 +-
 drivers/media/platform/qcom/venus/hfi_parser.c     |   9 +-
 .../media/platform/renesas/rzg2l-cru/rzg2l-video.c |   5 +
 drivers/media/platform/rockchip/rkvdec/rkvdec.c    |   4 +-
 drivers/media/rc/sunxi-cir.c                       |   9 +-
 drivers/media/test-drivers/vimc/vimc-capture.c     |   4 +-
 drivers/media/tuners/tda18250.c                    |   4 +-
 drivers/media/usb/airspy/airspy.c                  |  19 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   4 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   3 +-
 drivers/media/usb/em28xx/em28xx-core.c             |   2 +
 drivers/media/usb/go7007/snd-go7007.c              |  10 +-
 drivers/media/usb/s2255/s2255drv.c                 |  11 +
 drivers/media/usb/usbtv/usbtv-audio.c              |  11 +
 drivers/media/v4l2-core/v4l2-async.c               |   1 -
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |  49 ++-
 drivers/media/v4l2-core/v4l2-fwnode.c              |   2 +
 drivers/mfd/qnap-mcu.c                             |  13 +-
 drivers/mtd/mtdoops.c                              |   3 +
 drivers/mtd/nand/ecc-realtek.c                     |   1 +
 drivers/mtd/nand/raw/nand_onfi.c                   |  27 +-
 drivers/mtd/parsers/afs.c                          |   7 +
 drivers/nvdimm/btt.c                               |   8 +
 drivers/nvme/host/core.c                           |   3 +
 drivers/nvme/host/fabrics.c                        |   2 +
 drivers/nvme/host/fc.c                             |  26 +-
 drivers/nvme/host/tcp.c                            |   7 +
 drivers/nvme/target/auth.c                         |   6 +
 drivers/nvme/target/core.c                         |   2 +-
 drivers/nvme/target/nvmet.h                        |   2 +
 drivers/nvme/target/tcp.c                          |  10 +
 drivers/parisc/eisa.c                              |   5 +
 drivers/pci/controller/plda/pcie-starfive.c        |  36 ++-
 drivers/pmdomain/mediatek/Kconfig                  |   5 +-
 drivers/power/supply/ab8500_fg.c                   |  32 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |   9 +-
 drivers/rtc/rtc-cmos.c                             |  10 +
 drivers/rtc/rtc-rzn1.c                             |  30 +-
 drivers/s390/crypto/vfio_ap_ops.c                  | 203 ++++++++----
 drivers/scsi/fnic/fip.c                            |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |  13 +-
 drivers/scsi/pm8001/pm8001_init.c                  |   4 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |   6 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  39 ++-
 drivers/scsi/qla2xxx/qla_dbg.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_dfs.c                     |   4 +-
 drivers/scsi/qla2xxx/qla_edif.c                    |   3 +
 drivers/scsi/qla2xxx/qla_gs.c                      |   4 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  61 +++-
 drivers/scsi/qla2xxx/qla_inline.h                  |  13 +
 drivers/scsi/qla2xxx/qla_isr.c                     |  39 ++-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  28 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  31 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  14 +-
 drivers/soc/qcom/qcom-geni-se.c                    |  24 +-
 drivers/spi/spi-bcm63xx-hsspi.c                    |   8 +-
 drivers/spi/spi-bcm63xx.c                          |   6 +-
 drivers/spi/spi-bcmbca-hsspi.c                     |   8 +-
 drivers/spi/spi.c                                  |  34 +-
 drivers/staging/media/meson/vdec/vdec.c            |   4 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   4 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |   7 +
 drivers/target/iscsi/iscsi_target_login.c          |   2 +-
 drivers/thermal/imx_thermal.c                      |   9 +-
 drivers/thermal/qoriq_thermal.c                    |  13 +-
 drivers/usb/dwc3/ep0.c                             |   2 +-
 drivers/usb/dwc3/gadget.c                          |  21 +-
 drivers/usb/gadget/function/f_fs.c                 |  31 +-
 drivers/usb/gadget/function/f_mass_storage.c       |   2 +-
 drivers/usb/gadget/function/f_midi.c               |   2 +-
 drivers/usb/gadget/function/f_midi2.c              |  17 +-
 drivers/usb/gadget/functions.c                     |   2 +-
 drivers/usb/gadget/legacy/inode.c                  |   3 +-
 drivers/usb/host/xhci-debugfs.c                    |  21 +-
 drivers/usb/host/xhci-hub.c                        | 117 ++++---
 drivers/usb/host/xhci-mem.c                        |  34 +-
 drivers/usb/host/xhci-pci.c                        |   6 +-
 drivers/usb/host/xhci-ring.c                       |  40 ++-
 drivers/usb/host/xhci-tegra.c                      |  12 +-
 drivers/usb/host/xhci-trace.h                      |   5 +
 drivers/usb/host/xhci.c                            |  81 +++--
 drivers/usb/host/xhci.h                            |  46 ++-
 drivers/usb/image/mdc800.c                         |   4 +-
 drivers/usb/storage/ene_ub6250.c                   |   2 +
 drivers/usb/storage/realtek_cr.c                   |   9 +-
 .../usb/typec/tcpm/qcom/qcom_pmic_typec_pdphy.c    |   2 +
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c |   5 +
 drivers/usb/typec/tcpm/tcpm.c                      |  28 +-
 drivers/usb/typec/tipd/core.c                      |  17 +-
 drivers/usb/typec/tipd/tps6598x.h                  |   4 +-
 drivers/usb/typec/ucsi/displayport.c               |   2 +-
 drivers/watchdog/pseries-wdt.c                     |  53 +--
 drivers/xen/balloon.c                              |  56 ++--
 fs/afs/callback.c                                  |   1 +
 fs/ceph/caps.c                                     |  63 +++-
 fs/ceph/crypto.c                                   |  46 ++-
 fs/ceph/mds_client.c                               |  71 +++-
 fs/ceph/mds_client.h                               |   2 +
 fs/ceph/super.h                                    |  13 +
 fs/erofs/zutil.c                                   |   2 +
 fs/f2fs/data.c                                     |   5 +-
 fs/f2fs/dir.c                                      |   7 +-
 fs/f2fs/file.c                                     | 154 ++++++---
 fs/f2fs/gc.c                                       |   2 +-
 fs/f2fs/inline.c                                   |   2 +-
 fs/f2fs/namei.c                                    |  17 +-
 fs/f2fs/node.c                                     |   9 +-
 fs/f2fs/sysfs.c                                    |   7 +-
 fs/f2fs/xattr.c                                    |   2 +-
 fs/fuse/args.h                                     |  65 ++++
 fs/fuse/cuse.c                                     |   7 +-
 fs/fuse/dev.c                                      |  44 +--
 fs/fuse/dev_uring.c                                | 189 +++++++----
 fs/fuse/file.c                                     |  22 +-
 fs/fuse/fuse_i.h                                   |  53 +--
 fs/fuse/inode.c                                    |  10 +-
 fs/lockd/svcsubs.c                                 |   2 +-
 fs/nfsd/filecache.c                                | 115 +++----
 fs/nfsd/netns.h                                    |  11 +-
 fs/nfsd/nfs4proc.c                                 | 139 ++++++--
 fs/nfsd/nfs4state.c                                | 170 +++++++---
 fs/nfsd/nfsctl.c                                   |  25 +-
 fs/nfsd/nfsd.h                                     |  15 -
 fs/nfsd/state.h                                    |   2 +-
 fs/notify/fanotify/fanotify_user.c                 |  12 +-
 fs/notify/inotify/inotify_user.c                   |  15 +-
 fs/ntfs3/frecord.c                                 |  20 +-
 fs/ocfs2/dir.c                                     |  71 +++-
 fs/overlayfs/dir.c                                 |   1 -
 fs/pidfs.c                                         | 136 +++++---
 fs/smb/client/cifs_debug.c                         |   4 +-
 fs/smb/client/cifs_spnego.h                        |   2 -
 fs/smb/client/cifs_unicode.h                       |   3 -
 fs/smb/client/cifsfs.c                             |   5 +-
 fs/smb/client/cifsfs.h                             |   6 +-
 fs/smb/client/cifsglob.h                           |  10 +-
 fs/smb/client/cifsproto.h                          |  29 +-
 fs/smb/client/cifssmb.c                            | 146 +++++++++
 fs/smb/client/compress.c                           |  21 +-
 fs/smb/client/compress.h                           |  19 +-
 fs/smb/client/connect.c                            | 142 --------
 fs/smb/client/dir.c                                |   2 +-
 fs/smb/client/dns_resolve.h                        |   4 -
 fs/smb/client/fs_context.c                         |   2 +-
 fs/smb/client/fs_context.h                         |  16 +-
 fs/smb/client/fscache.h                            |  10 +-
 fs/smb/client/inode.c                              |  61 +++-
 fs/smb/client/misc.c                               |   1 +
 fs/smb/client/netmisc.c                            |   2 +-
 fs/smb/client/smb1ops.c                            | 171 ----------
 fs/smb/client/smb1proto.h                          |  40 +++
 fs/smb/client/smb1transport.c                      | 198 ++++++++++++
 fs/smb/client/smb2file.c                           |   3 +-
 fs/smb/client/smb2inode.c                          |   1 -
 fs/smb/client/smb2maperror.c                       |   3 +-
 fs/smb/client/smb2ops.c                            |  99 ++++--
 fs/smb/client/smb2pdu.c                            |   5 +-
 fs/smb/client/smb2proto.h                          |  14 +-
 fs/smb/client/trace.h                              | 151 +++++++++
 fs/smb/server/oplock.c                             |  61 +++-
 include/linux/acpi.h                               |  14 +
 include/linux/firmware/qcom/qcom_scm.h             |  10 +-
 include/linux/huge_mm.h                            |   7 +-
 include/linux/hugetlb.h                            |   5 +
 include/linux/kprobes.h                            |   1 +
 include/linux/lockd/lockd.h                        |   2 +-
 include/linux/memcontrol.h                         |  10 +
 include/linux/mm.h                                 |   2 -
 include/linux/rmap.h                               |   9 +-
 include/linux/soc/qcom/geni-se.h                   |   4 +
 include/net/dst.h                                  |   6 +
 include/net/ip.h                                   |  25 ++
 include/net/ip6_route.h                            |  43 +++
 include/net/ipv6.h                                 |  10 +-
 include/net/tcp.h                                  |   5 +
 kernel/bpf/percpu_freelist.c                       |  35 +-
 kernel/bpf/percpu_freelist.h                       |   1 +
 kernel/bpf/stackmap.c                              | 173 ++++++----
 kernel/bpf/verifier.c                              |  81 ++---
 kernel/dma/direct.c                                |  18 +-
 kernel/entry/syscall-common.c                      |   3 +
 kernel/futex/requeue.c                             |  12 +-
 kernel/kprobes.c                                   |  14 +-
 kernel/sched/core.c                                |  60 ++--
 kernel/sched/deadline.c                            |   8 +-
 kernel/sched/ext.c                                 |  17 +-
 kernel/sched/fair.c                                |   4 +-
 kernel/sched/idle.c                                |   2 +-
 kernel/sched/rt.c                                  |   8 +-
 kernel/sched/sched.h                               |  12 +-
 kernel/sched/stop_task.c                           |   2 +-
 kernel/trace/ftrace.c                              |  13 +-
 kernel/trace/ring_buffer.c                         |  20 +-
 mm/damon/core.c                                    |  22 +-
 mm/damon/ops-common.c                              |   5 +-
 mm/damon/paddr.c                                   |  20 +-
 mm/damon/sysfs-schemes.c                           |  18 +-
 mm/damon/sysfs.c                                   |  23 +-
 mm/damon/tests/core-kunit.h                        |  15 +-
 mm/damon/tests/vaddr-kunit.h                       |   5 +
 mm/damon/vaddr.c                                   |  34 +-
 mm/huge_memory.c                                   | 358 ++++++++++++---------
 mm/hugetlb.c                                       |  25 +-
 mm/hugetlb_cgroup.c                                |   7 +-
 mm/hugetlb_vmemmap.c                               | 298 +++++++----------
 mm/memcontrol-v1.c                                 |  43 ++-
 mm/memcontrol.c                                    |  13 +
 mm/mempolicy.c                                     |   2 +-
 mm/migrate.c                                       |  12 +-
 mm/mm_init.c                                       |   1 +
 mm/page_alloc.c                                    |   6 +-
 mm/page_vma_mapped.c                               |   8 +-
 mm/rmap.c                                          |  15 +-
 mm/slab.h                                          |   8 +-
 mm/slab_common.c                                   |  44 ++-
 mm/slub.c                                          | 108 +++----
 mm/sparse-vmemmap.c                                |  53 ---
 mm/userfaultfd.c                                   |   4 +-
 mm/vmscan.c                                        |  41 +--
 net/8021q/vlan.c                                   |   7 +-
 net/8021q/vlan_dev.c                               |  32 +-
 net/batman-adv/bridge_loop_avoidance.c             |  15 +-
 net/batman-adv/distributed-arp-table.c             |   8 +-
 net/batman-adv/main.c                              |   4 +
 net/batman-adv/multicast_forw.c                    |   7 +-
 net/core/skbuff.c                                  |   5 +-
 net/ipv4/icmp.c                                    |   2 +-
 net/ipv4/ip_output.c                               |   4 +-
 net/ipv4/ip_sockglue.c                             |   2 +-
 net/ipv4/ipmr.c                                    |   2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   2 +-
 net/ipv4/route.c                                   |   4 +-
 net/ipv4/tcp_ipv4.c                                |  15 +-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/tcp_output.c                              |   6 +-
 net/ipv6/exthdrs.c                                 |  55 ++--
 net/ipv6/ip6_gre.c                                 |   2 +-
 net/ipv6/ip6_output.c                              |  47 +--
 net/ipv6/ip6_tunnel.c                              |   6 +-
 net/ipv6/ipv6_sockglue.c                           |   4 +-
 net/ipv6/route.c                                   |  10 +-
 net/ipv6/sit.c                                     |   2 +-
 net/ipv6/tcp_ipv6.c                                |  11 +-
 net/openvswitch/conntrack.c                        | 121 ++++---
 net/openvswitch/conntrack.h                        |   6 +-
 net/openvswitch/datapath.c                         |  10 +-
 net/openvswitch/datapath.h                         |   8 +-
 net/packet/af_packet.c                             |  96 +++++-
 net/sunrpc/auth_gss/gss_rpc_xdr.c                  |   9 +-
 net/sunrpc/xprtrdma/ib_client.c                    |  26 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |  12 +-
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  |   5 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |  32 +-
 rust/kernel/bug.rs                                 |  10 +-
 rust/kernel/devres.rs                              | 163 ++++------
 rust/kernel/drm/ioctl.rs                           |   6 +
 samples/damon/mtier.c                              |  14 +-
 samples/damon/prcl.c                               |  11 +-
 samples/damon/wsse.c                               |  11 +-
 security/integrity/ima/ima_appraise.c              |   2 +
 sound/core/pcm_native.c                            |   2 +
 sound/core/rawmidi.c                               |   2 +-
 sound/parisc/harmony.c                             |   6 +-
 sound/soc/codecs/adau1761.c                        |  34 +-
 sound/soc/codecs/aw88261.c                         |  30 +-
 sound/soc/codecs/aw88261.h                         |   6 -
 sound/soc/codecs/cs35l33.c                         |  14 +-
 sound/soc/codecs/cs35l34.c                         |  14 +-
 sound/soc/codecs/cx2072x.c                         | 134 ++++----
 sound/soc/codecs/hdac_hda.c                        |   4 +-
 sound/soc/codecs/max9860.c                         |   2 +-
 sound/soc/codecs/ml26124.c                         |   4 +-
 sound/soc/codecs/pcm512x.c                         |  40 +--
 sound/soc/codecs/pm4125-sdw.c                      |   2 +-
 sound/soc/codecs/rt1017-sdca-sdw.h                 |  10 +-
 sound/soc/codecs/rt1316-sdw.c                      |   2 +-
 sound/soc/codecs/rt1318-sdw.c                      |   2 +-
 sound/soc/codecs/rt1318.c                          |   4 +-
 sound/soc/codecs/rt274.c                           |   8 +-
 sound/soc/codecs/rt286.c                           |  14 +-
 sound/soc/codecs/rt298.c                           |  14 +-
 sound/soc/codecs/rt700-sdw.h                       |  11 +-
 sound/soc/codecs/rt711-sdca-sdw.h                  |   6 +-
 sound/soc/codecs/rt711-sdw.h                       |  10 +-
 sound/soc/codecs/rt712-sdca-dmic.h                 |   6 +-
 sound/soc/codecs/rt712-sdca-sdw.h                  |  11 +-
 sound/soc/codecs/rt715-sdca-sdw.h                  |  48 ++-
 sound/soc/codecs/rt715-sdw.h                       |  32 +-
 sound/soc/codecs/rt721-sdca-sdw.h                  |  44 +--
 sound/soc/codecs/sgtl5000.c                        |   2 +-
 sound/soc/codecs/sti-sas.c                         |   2 +-
 sound/soc/codecs/tas2552.c                         |  14 +-
 sound/soc/codecs/tas2764.c                         |   2 +-
 sound/soc/codecs/tas2780.c                         |   2 +-
 sound/soc/codecs/tas2783-sdw.c                     | 177 +++++-----
 sound/soc/fsl/fsl_easrc.c                          |   8 +-
 sound/soc/fsl/mpc5200_psc_i2s.c                    |   1 +
 sound/soc/intel/atom/sst/sst_pci.c                 |   4 +-
 sound/soc/loongson/loongson_card.c                 |   6 +-
 sound/soc/samsung/aries_wm8994.c                   |   1 +
 sound/soc/tegra/tegra210_admaif.c                  | 210 ++++++++----
 sound/soc/tegra/tegra210_i2s.c                     |   8 +-
 sound/soc/tegra/tegra210_mbdrc.c                   |  42 +--
 sound/soc/tegra/tegra210_mixer.c                   |  10 +-
 sound/usb/midi.c                                   |   2 +
 tools/objtool/check.c                              |   3 +-
 .../util/bpf_skel/augmented_raw_syscalls.bpf.c     | 155 +++++----
 .../util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.c   |  47 +--
 .../util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.h   |  12 +
 tools/sched_ext/scx_qmap.bpf.c                     |   2 +-
 tools/testing/cxl/Kbuild                           |   1 +
 511 files changed, 7548 insertions(+), 4554 deletions(-)


