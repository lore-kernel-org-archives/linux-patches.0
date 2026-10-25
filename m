Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792933130;
	b=U3fpIhmcSspn6HPjFMBB4dFoKZYCn2PFMKnijkufFeOUZ1WcQhr/9Vmqks9KWFxZSHux
	 FgIGZuLxcVBVmxejsxzsLeaJsIqulb7WLzOvKm67mmyKKtPXuhsYqy2LNYhjwRcdF5HeJ
	 XSd4xvPdgiSgoqQD+CZM7W7NSUH/WhjPDgTTjMcDym/Bnig7Hp7iTBuCDIVOwMJmlKqEq
	 9aR0LJzVr1tFE7vdpOAbNz9WqwO6z992Qf0ROCWiF9fC23vAlawWZ+gjDCi8UOJV2jKSq
	 S6sW0NoFDLC/bAxos1bimwc1vGtpMGiQ8rZTlRv5kZX2WEJedfkq5GEC2fA2Xq1Brow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792933130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=MwqDMfnoE7qW7Bd5sD4la2u5gTx0oY+kGAC4VNksnnw=;
	b=lUFfgZWWXipQKbBY2KoDUYPaoK3Ls4Xkma8X/3kWBmqebSZwR/BNQIs71A6yYUh3/q76
	 InUT19YjFSdO59F+spXkVR9rHhIJ7CJ8jhqdAy5rMKo/S7kRE91nLPENbO5xwTp8XDlhG
	 8ARER9reuSMODI6CCuS5ruyYZRwLqfwhLJCJnHkrWXqye7s0htTWDXnJVd6qw2g772QPa
	 Ye57Y2DIJyeJMFmTvMKdZVGFe2CSTr4iJqwZaamE/T89ISd58zcZvIIs1g2bvvsEqLljM
	 7dwCVQ2IaRSJHBzfQgp02ALz4AVytG0l+udkFxDiBZqadN1BHDTjdcqEB78W4DyxwfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u9ct+0s6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D388606A31A;
	Sun, 25 Oct 2026 12:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u9ct+0s6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93471F01825;
	Sun, 25 Oct 2026 12:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792933128;
	bh=MwqDMfnoE7qW7Bd5sD4la2u5gTx0oY+kGAC4VNksnnw=;
	h=From:To:Cc:Subject:Date;
	b=u9ct+0s6tj6bM1VBVNl9K0QulgMMoEyYGRo4oxURP1X5tNZxSov2SRsGVUYU3KQhU
	 /gDUVzCtilcAWRtPnupf7Wul4RsozW84emY2Ye+VGOBbc55FskhZCBeJXpWp9s9yyc
	 uNf0sp6yY7mW69aMFaeyYyi1WpNLAllY1kwadfUk=
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
Subject: [PATCH 7.2 000/231] 7.2.13-rc3 review
Date: Sun, 25 Oct 2026 13:58:45 +0100
Message-ID: <20261025125805.309934791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.13-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.2.13-rc3
X-KernelTest-Deadline: 2026-10-27T12:58+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.2.13 release.
There are 231 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 27 Oct 2026 12:57:40 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.13-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.2.13-rc3

Paulo Alcantara <pc@manguebit.org>
    smb: client: drain outstanding I/O before truncating on O_TRUNC open

Hongling Zeng <zenghongling@kylinos.cn>
    ntfs: fix memmove overlap in ntfs_new_attr_flags

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: move attribute payload before shrinking its record

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: fix resident conversion in ntfs_new_attr_flags

Hongling Zeng <zenghongling@kylinos.cn>
    ntfs: take invalidate_lock in ntfs_setattr_size()

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: use pagecache_isize_extended() on size extension

Yao Kai <yaokai34@huawei.com>
    workqueue: Fix unbound pool lifetime for pending pwqs

Tejun Heo <tj@kernel.org>
    sched_ext: Fix the bypass dispatch claim for schedulers bypassed by an ancestor

Tejun Heo <tj@kernel.org>
    sched_ext: Fix stall when a task enqueued with SCX_ENQ_LAST lands back on its CPU's local DSQ

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: free the userptr ranges when a CS fails after parser_bos

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/amdgpu: Remove the bo list mutex

Haris Okanovic <harisokn@amazon.com>
    genirq/proc: Fix missing CPU header in /proc/interrupts

Hongling Zeng <zenghongling@kylinos.cn>
    ntfs: fix undefined behavior in mft/index record size calculation

Hongling Zeng <zenghongling@kylinos.cn>
    ntfs: fix incorrect MFT record pointer passed to ntfs_attr_record_resize

Jacopo Labardi <jacopolabardi@gmail.com>
    ntfs: fix FITRIM range alignment

Hongling Zeng <zenghongling@kylinos.cn>
    ntfs: handle signal interruption in fallocate

Yunpeng Tian <shionthanatos@gmail.com>
    smb: client: reject SetEA requests that do not fit the request buffer

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix multiuser mount with krb5

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix heap overflow in cifs_do_set_acl()

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix data corruption with concurrent writes and O_TRUNC

Aohan Mei <henrymei@tencent.com>
    net/sched: cls_flower: validate mask pointer after nla_next()

Aleksandr Khromov <haa@amicon.ru>
    ksmbd: zero the FS_OBJECT_ID_INFORMATION buffer before filling it in

Aleksandr Khromov <haa@amicon.ru>
    ksmbd: initialize FileSystemControlFlags in FS_CONTROL_INFORMATION

Aleksandr Khromov <haa@amicon.ru>
    ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION

Norbert Szetei <norbert@doyensec.com>
    net: psp: do not inherit the Rx association on clone

Koichiro Den <den@valinux.co.jp>
    net: ntb_netdev: Fix statistics races

Jun Yang <littleddfu@gmail.com>
    net: bridge: mcast: don't truncate the port group walk on teardown

Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>
    drm/i915/dmc: Harden DMC firmware payload parsing

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu/userq: actually validate userq BOs

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: correct reservation fence slots for userq per-vm BOs eviction

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/mmu: Cope with the SS bit being set in #NPF exit codes

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Fix VCE 3 ring align_mask

Zihan Xi <zihanx@nebusec.ai>
    ipv4: avoid divide by zero in fib_rebalance

Daehyeon Ko <4ncienth@gmail.com>
    vsock/vmci: validate packet source for connected sockets

Daehyeon Ko <4ncienth@gmail.com>
    vsock/virtio: validate packet source for connected sockets

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix leak of uninitialized kernel data in SCLP report

Thomas Richter <tmricht@linux.ibm.com>
    s390/pai: Handle multiple PMU stop callback invocations

Aswin Karuvally <aswin@linux.ibm.com>
    s390/ctcm: Prevent XID null dereference

Florian Schauer <florian@schauer.to>
    page_pool: keep frag_offset aligned for odd-sized requests

Charles Vosburgh <theminershive@gmail.com>
    sctp: validate chunk length in the inqueue parser

Paul Moore <paul@paul-moore.com>
    selinux: fix BPF token permission checks

Chengfeng Ye <nicoyip.dev@gmail.com>
    tipc: protect node reset trace dump with node lock

Tejun Heo <tj@kernel.org>
    workqueue: Annotate cb_lock nesting when draining a dead BH pool

Zqiang <qiang.zhang@linux.dev>
    workqueue: Use raise_softirq() to trigger softirq in irq_work handler

Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>
    io_uring/cancel: don't spin on local work the task can't run

Ilya Maximets <i.maximets@ovn.org>
    netlink: specs: add missing mask attributes for conntrack dump

Ilya Maximets <i.maximets@ovn.org>
    netlink: specs: fix the conntrack filter type

Christoph Hellwig <hch@lst.de>
    xfs: fix zoned write iomap flags assignments

Carlos Maiolino <cem@kernel.org>
    xfs: fix capability check in xfs

Yun Zhou <yun.zhou@windriver.com>
    xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf

Bryam Vargas <hexlabsecurity@proton.me>
    net/iucv: fix the recvmsg window update

Kaiwen Shi <skwkevin@mail.ustc.edu.cn>
    mac802154: fix data race and NULL deref on local->assoc_dev

Chen Cheng <chencheng@fnnas.com>
    dm-integrity: require stable writes for internal hash modes

Ben Cressey <ben@cressey.dev>
    dm-integrity: fix infinite loop on discard with large tag size

Genjian Zhang <zhanggenjian@kylinos.cn>
    dm-ebs: fix incorrect device offset check in ebs_ctr()

Ben Cressey <ben@cressey.dev>
    dm-crypt: fix a tiny race condition in crypt_dec_pending

Benjamin Marzinski <bmarzins@redhat.com>
    dm cache: fix issue with background work locking

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix demotion stats in passthrough mode

Frank Sorenson <sorenson@redhat.com>
    cifs: don't update i_size in cifs_do_truncate without a cached handle

Frank Sorenson <sorenson@redhat.com>
    cifs: add revalidation on FSCTL failure in smb2_duplicate_extents()

Etienne Perot <eperot@google.com>
    cgroup: fix spurious SIGKILL of CLONE_INTO_CGROUP children

Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
    tcp: fix use-after-free in do_tcp_getsockopt(TCP_CC_INFO)

Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
    tcp: fix use-after-free in do_tcp_getsockopt(TCP_CONGESTION)

Heyang Tan <thy15333007817@163.com>
    wifi: p54: validate firmware record lengths

Dmitry Kandybka <d.kandybka@gmail.com>
    tracing: Fix ignored return value of resize_buffer_duplicate_size()

Tengda Wu <wutengda@huaweicloud.com>
    tracing: Fix hist trigger timestamps for buffered events

Hao Ge <hao.ge@linux.dev>
    tracing: Fix crash in print_graph_function_event()

Amit Machhiwal <amachhiw@linux.ibm.com>
    tracing: Do not initialize tracefs work if tracing is disabled

Taeyang Lee <0wn@theori.io>
    tracing: Check operator stack capacity before pushing

David Carlier <devnexen@gmail.com>
    tracing: Take trace_types_lock when dropping the buffer_meta reference

Taeyang Lee <0wn@theori.io>
    tracing: Keep the predicate limit separate from program capacity

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix the shift out of bounds in the log2 histogram modifier

Tejun Heo <tj@kernel.org>
    sched_ext: Propagate every bypass depth change to the descendants

Hui Su <sh_def@163.com>
    sched_ext: idle: Respect task affinity in restricted CPU selection

Tejun Heo <tj@kernel.org>
    sched_ext: Fix use-after-free of a destroyed user DSQ by a deferred reenqueue

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Don't transfer shrinker pages for pinned bos on purgeable state change

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Bump LRU for external objects on exec and rebind

Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>
    drm/i915/dmc: Add sanity check for DMC load address

Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
    drm/i915/cx0_phy: Fix ARL-S host bridge detection

Christian König <ckoenig.leichtzumerken@gmail.com>
    drm/exec: don't immediately add prelocked obj to array of locked objs

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: report the BO alignment in bytes in GEM_LIST_HANDLES

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: keep the eviction fence until the last handle is closed

Perry Yuan <perry.yuan@amd.com>
    drm/amdgpu: fix sched entity leak in ttm buffer entity init

Perry Yuan <perry.yuan@amd.com>
    drm/amdgpu: fix GEM object leak on ENOMEM in userptr ioctl

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: don't drop the runtime PM reference twice in amdgpu_gpr

Perry Yuan <perry.yuan@amd.com>
    drm/amdgpu: destroy mutex when tearing down ttm buffer entity

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/uvd3.1: Fix checking whether UVD firmware keyselect was already set

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/sdma3: Work around POLL_REGMEM / FENCE hang

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/pm: add zero fan stop temperature support on smu 14.0.2

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix NULL sink dereference in USB4 bandwidth functions

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    scsi: libiscsi: Validate the task named by a management response

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    scsi: libiscsi: Validate the ITT reflected in a Reject PDU

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    scsi: libiscsi: Reject a negative task index from parse_pdu_itt

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    scsi: xen/scsifront: Check for a NULL shadow entry on a backend response

Laurence Oberman <loberman@redhat.com>
    scsi: st: Fix use-after-free race between st_remove() and st_open()

Stanley Jhu <stanleyjhu@google.com>
    scsi: bsg: Pass reply_len to bsg_setup_queue() to fit UFS ARPMB replies

Krystian Kaniewski <krystianmkaniewski@gmail.com>
    ring-buffer: Fix false warning in ring_buffer_map_get_reader()

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    ring-buffer: Fix the sub-buffer array base in rb_meta_subbuf_idx()

David Carlier <devnexen@gmail.com>
    ring-buffer: Do not show buffer_meta for CPUs without a buffer

Antoine Huret <antoine.huret@bull.com>
    perf: Update cgroup time when rotating multiplexed events

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    perf: Track the perf mlock gift separately

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    i2c: xiic: restore non-managed runtime PM to fix clk WARN flood

Wentao Liang <vulab@iscas.ac.cn>
    i2c: viai2c-wmt: Fix clock leak in wmt_i2c_probe()

Loic Poulain <loic.poulain@oss.qualcomm.com>
    i2c: qcom-cci: Fix HALT_ACK reset request being dropped

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: shared: gracefully handle no-device lookup of shared GPIOs

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: shared: fix use-after-free bug when adding shared proxies

Lee Jones <lee@kernel.org>
    tracing/histograms: Reject non-stacktrace fields for synthetic stacktrace fields

Sasha Levin <sashal@kernel.org>
    tools: gpio: fix building from the top level with O=

Ali Ahmet Memis <ali@iusegentoo.com>
    tools/power turbostat: Read complete CPU lists

Richard Leitner <richard.leitner@linux.dev>
    spi: imx: fix slab corruption from undersized DMA bounce buffers

Daehyeon Ko <4ncienth@gmail.com>
    sctp: revalidate output stream after association connect wait

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: microchip: beaglev-fire: remove double definition of gpio interrupts

François Roux <franzelfranzel@gmail.com>
    power: sequencing: qcom-wcn: power off WLAN at probe

Mario Limonciello <mario.limonciello@amd.com>
    pinctrl: amd: Clear S4 wake bits when firmware has _AEI

Aohan Mei <henrymei@tencent.com>
    net: rds: fix uninitialized trans dereference in CM event handler

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    net/sched: fix use-after-free in __tcf_action_put()

Hardik Garg <hargar@linux.microsoft.com>
    mshv_vtl: Check per-CPU register page before mmap

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: poly1305: Use memzero_explicit() in poly1305_final()

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state

Jann Horn <jannh@google.com>
    futex: Fix mm reuse handling for FUT_OFF_MMSHARED

Christian Brauner <brauner@kernel.org>
    namei: test for a negative dentry the way traverse_mounts() does

Christian Brauner <brauner@kernel.org>
    namespace: a mount that copy_tree() leaves out can't take over a lock

Christian Brauner <brauner@kernel.org>
    ntfs3: free the sbi after a grace period

Christian Brauner <brauner@kernel.org>
    ipc: drop the mqueue mount with kern_unmount() on setup failure

Christian Brauner <brauner@kernel.org>
    eventfs: Free the eventfs_inode after an rcu grace period too

Christian Brauner <brauner@kernel.org>
    ext4: free the sbi after a grace period

Aviv Vaknin <vaknins33@gmail.com>
    pid_namespace: make zap_pid_ns_processes() freezable

Kyle Zeng <kylebot@openai.com>
    fsnotify: prevent mark additions during connector teardown

Amirmohammad Eftekhar <amirmohammadeftekhar@gmail.com>
    KVM: nVMX: Reset MMU back to the root MMU if loading L2 state fails for !VM-Entry

Jann Horn <jannh@google.com>
    KVM: SEV: Fix page dirtying in sev_gmem_post_populate()

EJ Campbell <ejc3@meta.com>
    x86/kvm: Don't consume async #PF flags on a kernel #PF in NMI context

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    watch_queue: Fix note pool publication race in watch_queue_set_size()

Christian Brauner <brauner@kernel.org>
    unicode: free the map after a grace period

Sasha Levin <sashal@kernel.org>
    bootconfig: give the footer size static_assert a message

Sung Byeongchan <tjdqudcks0424@naver.com>
    autofs: ignore notification errors from a replaced pipe

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: sof-client: Use event-handler mutex consistently

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Fix shift-out-of-bounds for aggregated ALH capture

Christian Brauner <brauner@kernel.org>
    afs: free the super info after a grace period

Igor Paunovic <royalnet026@gmail.com>
    accel/rocket: search every core slot when looking up a scheduler

Igor Paunovic <royalnet026@gmail.com>
    accel/rocket: search every core slot when a core is removed

Christian Brauner <brauner@kernel.org>
    9p: free the session after a grace period

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: fix race condition in split transaction handling

Lukas Zobernig <lukas.zobernig@gmail.com>
    x86/insn-eval: Fix shadowed segment index in get_seg_reg_override_idx()

Alexander Gruhlke <gruhlke@mailbox.org>
    PCI: Don't treat ~0 as ready in pci_dev_wait() with RRS SV

Alexander Gruhlke <gruhlke@mailbox.org>
    PCI: Ignore Immediate Readiness on Samsung 990 PRO and 990 EVO Plus NVMe

John Ogness <john.ogness@linutronix.de>
    printk: Postpone kthread startup

Haris Okanovic <harisokn@amazon.com>
    perf: Fix perf_pmu_migrate_context() leaving events behind

Guixiong Wei <weiguixiong@bytedance.com>
    perf/x86/intel/uncore: Fix DMR CXL CM invert filter

Igor Velkov <iav@iav.lv>
    net: stmmac: dwmac1000: clear the RGMII status interrupt

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Use subbuf_order in available memory estimation

Peng Fan <peng.fan@nxp.com>
    gpio: mxc: fix race between gpiochip registration and IRQ domain setup

Peng Fan <peng.fan@nxp.com>
    gpio: mxc: fix wakeup_pads bit operations

Peng Fan <peng.fan@nxp.com>
    gpio: mxc: fix both_edges bit operations

Peng Fan <peng.fan@nxp.com>
    gpio: mxc: fix race between chained IRQ handler install and probe completion

Kent Gibson <warthog618@gmail.com>
    gpiolib: fix memory leak in gpiod_set_array_value_complex() on error paths

Joas Antonio dos Santos <joasantonio108@gmail.com>
    calipso: keep BIG TCP payload_len in calipso_skbuff_setattr()

Nicolai Buchwitz <nb@tipi-net.de>
    net: bcmgenet: unshare the skb before writing the control block

David Yang <mmyangfl@gmail.com>
    net: ti: icssm-prueth: Move setting of netops to fix crash

David Yang <mmyangfl@gmail.com>
    net: ethernet: aeroflex: move setting of netops to fix crash

David Yang <mmyangfl@gmail.com>
    net: ethoc: move setting of netops to fix crash

David Yang <mmyangfl@gmail.com>
    net: au1000: move setting of netops to fix crash

David Yang <mmyangfl@gmail.com>
    net: mv643xx: move setting of netops to fix crash

David Yang <mmyangfl@gmail.com>
    net: ethernet: actions: Move setting of netops to fix crash

David Yang <mmyangfl@gmail.com>
    net: hisilicon: hip04_eth: Move setting of netops to fix crash

David Yang <mmyangfl@gmail.com>
    net: hisilicon: hisi_femac: Move setting of netops to fix crash

Kyle Zeng <kylebot@openai.com>
    netlink: avoid hashing the network namespace pointer

Xingui Yang <yangxingui@huawei.com>
    scsi: libsas: Fix SMP IO deadlock during HA resume

Martin Kaiser <martin@kaiser.cx>
    tracing: probes: error if BTF is required but unavailable

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Skip si_mem_available() for persistent and remote buffers

Vincent Donnefort <vdonnefort@google.com>
    tracing: Fix simple_ring_buffer undef check on sparc64

Vincent Donnefort <vdonnefort@google.com>
    tracing: Fix simple_ring_buffer undef check on parisc

Vincent Donnefort <vdonnefort@google.com>
    tracing: Fix empty symbol names in simple_ring_buffer undef check

Kyle Zeng <kylebot@openai.com>
    pipe: preserve existing fasync readers on writer setup failure

Nickolai Zeldovich <nickolai@csail.mit.edu>
    exit: fix lost-update race on the child_subreaper bitfields

Sasha Levin <sashal@kernel.org>
    samples: pidfd: fix userprogs typo

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/dlm: Protect the recovery list during debugfs reads

Erik Faye-Lund <erik.faye-lund@arm.com>
    drm/panthor: fix immortalis condition

Jason Gunthorpe <jgg@ziepe.ca>
    iommupt/kunit: Use if_changed_rule for the kunit

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    entry: Account the deferred hrtimer rearm as hardirq context for lockdep

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/core: Call wakeup_preempt() for queued tasks during class change

Linfeng Sun <linfeng.sun.dev@gmail.com>
    scsi: target: iscsi: Fix race in discovery auth updates

Yu Zhang <yuz08559@gmail.com>
    scsi: target: Disable interrupts while holding delayed_cmd_lock

Laurence Oberman <loberman@redhat.com>
    scsi: st: Save the visited block for the partition the drive is in

Keith Busch <kbusch@kernel.org>
    nios2: fix __wsum type degradation in csum_fold()

Carlos Jones Jr <carlosjr.jones@analog.com>
    spi: tegra114: assert CS GPIO for every transfer in a message

Bommu Krishnaiah <krishnaiah.bommu@intel.com>
    drm/xe/oa: Zero OA buffer at allocation

Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
    drm/xe: skip eviction of a BO with no resource

Mario Limonciello <mario.limonciello@amd.com>
    ASoC: amd: yc: disable MSI on resume

Alexandre Cassen <acassen@corp.free.fr>
    net/mlx5: HWS, fix flow meter offset within its bulk

Alexandre Cassen <acassen@corp.free.fr>
    net/mlx5: HWS, release L2 to L3 tunnel reformats to their own pool

Guangshuo Li <lgs201920130244@gmail.com>
    accel/rocket: clear rdev on device init failure

Kyle Zeng <kylebot@openai.com>
    netlink: reset skb headers before unicast and multicast filtering

Michael Reeves <michael.reeves077@gmail.com>
    regmap: Drop map lock during cache init and exit

HyeongJun An <sammiee5311@gmail.com>
    ASoC: nau8822: Fix the 128x oversampling switch bits

HyeongJun An <sammiee5311@gmail.com>
    ASoC: wm8978: Fix the 128x oversampling switch bits

HyeongJun An <sammiee5311@gmail.com>
    ASoC: max98371: Fix the Speaker DHT Min Volume bits

HyeongJun An <sammiee5311@gmail.com>
    ASoC: pcm3168a: Fix the DAC zero flag polarity bit

HyeongJun An <sammiee5311@gmail.com>
    ASoC: cs42l52: Fix the NG Type Switch bit

HyeongJun An <sammiee5311@gmail.com>
    ASoC: cs42l56: Put the Limiter Cushion control on the limiter register

Avi Weiss <thnkslprpt@gmail.com>
    ASoC: stm32: spdifrx: fix synchronization state check

Sergey Tiraspolsky <stiraspo@gmail.com>
    ASoC: Intel: avs: Reset the stream unless it is already prepared

Liam R. Howlett <liam@infradead.org>
    accel/amdxdna: Fix Kconfig invalid configuration

Allison Henderson <achender@kernel.org>
    net/rds: don't let the rdma_cm destroy an id RDS still owns on route failure

Michal Luczaj <mhal@rbox.co>
    vsock: treat TCP_CLOSING as once-established

Ming Yu <a0282524688@gmail.com>
    gpio: nct6694: Mark the GPIO controller as sleeping

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hdmi: Move packet RAM enable to PM runtime

Pablo Mazzini <pmazzini@gmail.com>
    pinctrl: sunxi: dt: do not accumulate npins across probe attempts

Adriel Santos <adriel@adriel.eu>
    pinctrl: qcom: ipq5018: replace gcc_plltest with pwm2 on gpio12

Alexey Charkov <alchark@flipper.net>
    power: supply: core: prevent unregistering a power supply while a callback runs

Svyatoslav Ryhel <clamor95@gmail.com>
    power: supply: generic-adc-battery: Fix temperature IIO channel conversion

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix add_counter issue if > 24 counters.

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix PMT error path fd handling

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix CWF PMT off-by-one

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix fd_perf leak on reset

Len Brown <len.brown@intel.com>
    tools/power turbostat: Warn, but don't Err on out-dated perf systems

Shawn Guo <shengchao.guo@oss.qualcomm.com>
    pinctrl: qcom: spmi-gpio: make direction changes exclusive

Gilberto Conde <gilbertorconde@gmail.com>
    pinctrl: qcom: ipq5018: add missing pwm3 function on gpio13

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ARM: configs: sama5: enable current Microchip KSZ DSA symbols

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    pinctrl: qcom: qcs8300: Fix intr_target_width

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    pinctrl: qcom: hawi: Fix intr_target_width

Zhangfei Gao <zhangfei.gao@oss.qualcomm.com>
    pinctrl: qcom: nord: fix GPIO interrupt target width

Michael Kelley <mhkelley58@gmail.com>
    Drivers: hv: Don't reset VMBus connection state on error/exit paths

Michael Kelley <mhkelley58@gmail.com>
    x86/hyperv: Avoid using per-cpu output page in hv_apicid_to_vp_index()

Waiman Long <longman@redhat.com>
    Drivers: hv: Avoid infinite retry loop in init_vp_index()

Jon Hunter <jonathanh@nvidia.com>
    soc/tegra: pmc: Fix uninitialised clock rate

Xueqin Luo <luoxueqin@kylinos.cn>
    power: supply: ds2780: Fix ds2780_get_capacity() returning raw value

Karl Mehltretter <kmehltretter@gmail.com>
    power: supply: Fix maintenance charge table kernel-doc

David Oberhollenzer <david.oberhollenzer@sigma-star.at>
    ARM: dts: ti/omap: dra7: fix PCIe PHY clock divider definition

Jinhui Guo <guojinhui.liam@bytedance.com>
    soc/tegra: fuse: Add missing newline to APBMISC error message

Abel Vesa <abel.vesa@oss.qualcomm.com>
    i2c: qcom-geni: Restore the source-clock selection policy

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: exempt FSCTL_PIPE_TRANSCEIVE from the generic file-id lookup


-------------

Diffstat:

 Documentation/netlink/specs/conntrack.yaml         |  21 +++-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/ti/omap/dra7xx-clocks.dtsi       |   2 +-
 arch/arm/configs/sama5_defconfig                   |   4 +-
 arch/nios2/include/asm/checksum.h                  |   2 +-
 .../riscv/boot/dts/microchip/mpfs-beaglev-fire.dts |  18 ---
 arch/s390/kernel/perf_pai.c                        |  25 +++-
 arch/s390/pci/pci_sysfs.c                          |   3 +
 arch/x86/events/intel/uncore_snbep.c               |   5 +-
 arch/x86/hyperv/hv_init.c                          |   3 +-
 arch/x86/include/asm/insn.h                        |   2 +-
 arch/x86/kernel/kvm.c                              |  32 +++++-
 arch/x86/kvm/mmu.h                                 |  16 ++-
 arch/x86/kvm/mmu/paging_tmpl.h                     |   3 +-
 arch/x86/kvm/svm/sev.c                             |   2 +-
 arch/x86/kvm/vmx/nested.c                          |   4 +-
 block/bsg-lib.c                                    |  13 ++-
 drivers/accel/amdxdna/Kconfig                      |   1 +
 drivers/accel/rocket/rocket_device.c               |   2 +
 drivers/accel/rocket/rocket_device.h               |   1 +
 drivers/accel/rocket/rocket_drv.c                  |   7 +-
 drivers/accel/rocket/rocket_job.c                  |   2 +-
 drivers/base/regmap/regcache-maple.c               |   9 +-
 drivers/base/regmap/regcache.c                     |   6 -
 drivers/firewire/core-transaction.c                |   8 +-
 drivers/gpio/gpio-mxc.c                            |  36 +++---
 drivers/gpio/gpio-nct6694.c                        |   2 +-
 drivers/gpio/gpiolib-shared.c                      |  19 +++-
 drivers/gpio/gpiolib.c                             |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c        |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h        |   4 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  22 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |  23 +---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  17 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c          |  13 ++-
 drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c             |  25 +++-
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c              |   2 +-
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c              |   2 +-
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c    |  18 ++-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |  55 ++++++++-
 drivers/gpu/drm/drm_exec.c                         |  77 +++++++------
 drivers/gpu/drm/i915/display/intel_cx0_phy.c       |  12 +-
 drivers/gpu/drm/i915/display/intel_dmc.c           |  76 ++++++++++++-
 drivers/gpu/drm/i915/display/intel_dmc_regs.h      |  12 ++
 drivers/gpu/drm/panthor/panthor_hw.c               |   2 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  20 ++--
 drivers/gpu/drm/xe/xe_bo.c                         |  11 +-
 drivers/gpu/drm/xe/xe_exec.c                       |   7 +-
 drivers/gpu/drm/xe/xe_oa.c                         |   7 ++
 drivers/gpu/drm/xe/xe_vm.c                         |  31 ++++-
 drivers/gpu/drm/xe/xe_vm.h                         |   2 +
 drivers/hv/channel_mgmt.c                          |  12 +-
 drivers/hv/connection.c                            |   1 -
 drivers/hv/mshv_vtl_main.c                         |   3 +
 drivers/hv/vmbus_drv.c                             |   1 -
 drivers/i2c/busses/i2c-qcom-cci.c                  |   4 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |  37 +++---
 drivers/i2c/busses/i2c-viai2c-wmt.c                |   2 +-
 drivers/i2c/busses/i2c-xiic.c                      |  49 ++++++--
 drivers/iommu/generic_pt/fmt/Makefile              |   2 +-
 drivers/md/dm-cache-target.c                       |  59 +++++-----
 drivers/md/dm-crypt.c                              |   3 +-
 drivers/md/dm-ebs-target.c                         |   3 +-
 drivers/md/dm-integrity.c                          |   6 +-
 drivers/net/ethernet/actions/owl-emac.c            |   3 +-
 drivers/net/ethernet/aeroflex/greth.c              |   3 +-
 drivers/net/ethernet/amd/au1000_eth.c              |   3 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  10 ++
 drivers/net/ethernet/ethoc.c                       |   3 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |   3 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c        |   3 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |   4 +-
 .../mellanox/mlx5/core/steering/hws/fs_hws.c       |   5 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   6 +
 drivers/net/ethernet/ti/icssm/icssm_prueth.c       |   3 +-
 drivers/net/ntb_netdev.c                           |  47 +++++---
 drivers/net/wireless/intersil/p54/fwio.c           |  42 ++++++-
 drivers/pci/pci.c                                  |  15 ++-
 drivers/pci/quirks.c                               |  12 ++
 drivers/pinctrl/pinctrl-amd.c                      |   9 ++
 drivers/pinctrl/qcom/pinctrl-hawi.c                |   1 +
 drivers/pinctrl/qcom/pinctrl-ipq5018.c             |  10 +-
 drivers/pinctrl/qcom/pinctrl-nord.c                |   1 +
 drivers/pinctrl/qcom/pinctrl-qcs8300.c             |   1 +
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |  37 ++++--
 drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c           |   1 +
 drivers/power/sequencing/pwrseq-qcom-wcn.c         |  16 +--
 drivers/power/supply/ds2780_battery.c              |   2 +-
 drivers/power/supply/generic-adc-battery.c         |   9 +-
 drivers/power/supply/power_supply_core.c           |  26 ++++-
 drivers/s390/net/ctcm_mpc.c                        |   3 +-
 drivers/scsi/libiscsi.c                            |  14 ++-
 drivers/scsi/libsas/sas_expander.c                 |  14 ++-
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |   2 +-
 drivers/scsi/scsi_transport_fc.c                   |   6 +-
 drivers/scsi/scsi_transport_iscsi.c                |   2 +-
 drivers/scsi/scsi_transport_sas.c                  |   6 +-
 drivers/scsi/st.c                                  |  18 ++-
 drivers/scsi/xen-scsifront.c                       |   1 +
 drivers/soc/tegra/fuse/tegra-apbmisc.c             |   2 +-
 drivers/soc/tegra/pmc.c                            |   1 +
 drivers/spi/spi-imx.c                              |   9 +-
 drivers/spi/spi-tegra114.c                         |   7 ++
 drivers/target/iscsi/iscsi_target_configfs.c       |  26 +++--
 drivers/target/target_core_transport.c             |   8 +-
 drivers/ufs/core/ufs_bsg.c                         |   2 +-
 fs/9p/v9fs.h                                       |   1 +
 fs/9p/vfs_super.c                                  |   4 +-
 fs/afs/internal.h                                  |   2 +
 fs/afs/super.c                                     |   2 +-
 fs/autofs/waitq.c                                  |  25 +++-
 fs/ext4/ext4.h                                     |   2 +
 fs/ext4/extents-test.c                             |   2 +
 fs/ext4/extents.c                                  |   1 +
 fs/ext4/extents_status.c                           |   7 +-
 fs/ext4/extents_status.h                           |   1 +
 fs/ext4/super.c                                    |  13 ++-
 fs/namei.c                                         |   3 +-
 fs/namespace.c                                     |  19 +++-
 fs/notify/mark.c                                   |  11 ++
 fs/ntfs/attrib.c                                   |   8 +-
 fs/ntfs/bitmap.c                                   |   8 +-
 fs/ntfs/ea.c                                       | 126 +++++++++++++++++----
 fs/ntfs/file.c                                     |  41 ++++---
 fs/ntfs/super.c                                    |   4 +-
 fs/ntfs3/ntfs_fs.h                                 |   1 +
 fs/ntfs3/super.c                                   |  33 ++++--
 fs/ocfs2/dlm/dlmcommon.h                           |   2 +
 fs/ocfs2/dlm/dlmdebug.c                            |   5 +-
 fs/ocfs2/dlm/dlmrecovery.c                         |   2 +-
 fs/pipe.c                                          |   6 +-
 fs/smb/client/cifssmb.c                            |  24 +++-
 fs/smb/client/connect.c                            |  21 +++-
 fs/smb/client/file.c                               |  38 ++++++-
 fs/smb/client/smb2ops.c                            |   7 +-
 fs/smb/server/smb2pdu.c                            |   6 +
 fs/tracefs/event_inode.c                           |  10 +-
 fs/unicode/utf8-core.c                             |  21 +++-
 fs/xfs/libxfs/xfs_rtgroup.h                        |   6 +-
 fs/xfs/libxfs/xfs_sb.c                             |  37 +++---
 fs/xfs/xfs_aops.c                                  |   3 +-
 fs/xfs/xfs_fsmap.c                                 |   2 +-
 fs/xfs/xfs_ioctl.c                                 |   2 +-
 fs/xfs/xfs_iomap.c                                 |   3 +-
 fs/xfs/xfs_iops.c                                  |   2 +-
 include/drm/drm_exec.h                             |  15 ++-
 include/linux/bsg-lib.h                            |   3 +-
 include/linux/cgroup-defs.h                        |   5 +-
 include/linux/fsnotify_backend.h                   |   1 +
 include/linux/futex.h                              |  19 ++--
 include/linux/futex_types.h                        |   2 +
 include/linux/irq-entry-common.h                   |  23 +++-
 include/linux/maple_tree.h                         |   4 +
 include/linux/power_supply.h                       |  16 ++-
 include/linux/sched/signal.h                       |   4 +-
 include/linux/sched/user.h                         |   8 +-
 include/linux/unicode.h                            |   1 +
 include/net/af_vsock.h                             |   3 +
 io_uring/cancel.c                                  |   7 +-
 ipc/namespace.c                                    |   2 +-
 kernel/cgroup/cgroup.c                             |   6 +-
 kernel/events/core.c                               |  33 +++---
 kernel/exit.c                                      |   2 +-
 kernel/futex/core.c                                |  55 +++++----
 kernel/irq/proc.c                                  |  24 ++--
 kernel/pid_namespace.c                             |   2 +-
 kernel/printk/printk.c                             |   2 +-
 kernel/sched/core.c                                |  19 ++--
 kernel/sched/ext/ext.c                             |  95 +++++++++++-----
 kernel/sched/ext/idle.c                            |  50 ++++++--
 kernel/sched/ext/internal.h                        |   5 +-
 kernel/trace/Makefile                              |   5 +-
 kernel/trace/ring_buffer.c                         |  60 +++++-----
 kernel/trace/trace.c                               |  28 ++++-
 kernel/trace/trace_events_filter.c                 |   9 +-
 kernel/trace/trace_events_hist.c                   |  19 +++-
 kernel/trace/trace_probe.c                         |   3 +-
 kernel/trace/trace_snapshot.c                      |   5 +-
 kernel/trace/undefsyms_base.c                      |   5 +-
 kernel/watch_queue.c                               |  11 +-
 kernel/workqueue.c                                 |  27 +++--
 lib/crypto/arm64/poly1305-armv8.pl                 |   2 +-
 lib/crypto/poly1305.c                              |   2 +-
 net/bridge/br_multicast.c                          |  13 ++-
 net/core/page_pool.c                               |   3 +-
 net/core/sock.c                                    |   3 +
 net/ipv4/fib_semantics.c                           |   2 +-
 net/ipv4/tcp.c                                     |  18 ++-
 net/ipv4/tcp_cong.c                                |   4 +-
 net/ipv4/tcp_dctcp.c                               |   4 +-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv6/calipso.c                                 |   6 +-
 net/iucv/af_iucv.c                                 |  42 ++++---
 net/mac802154/ieee802154_i.h                       |   7 +-
 net/mac802154/main.c                               |   1 +
 net/mac802154/scan.c                               |  51 ++++++---
 net/netlink/af_netlink.c                           |  10 +-
 net/rds/rdma_transport.c                           |  38 ++++++-
 net/sched/act_api.c                                |  11 +-
 net/sched/cls_flower.c                             |   5 +
 net/sctp/inqueue.c                                 |   6 +-
 net/sctp/socket.c                                  |  33 ++++--
 net/tipc/node.c                                    |   2 +
 net/vmw_vsock/af_vsock.c                           |  49 ++++++--
 net/vmw_vsock/virtio_transport_common.c            |   3 +-
 net/vmw_vsock/vmci_transport.c                     |  34 +++++-
 samples/pidfd/Makefile                             |   2 +-
 security/selinux/hooks.c                           |  36 ++----
 sound/soc/amd/yc/pci-acp6x.c                       |  38 ++++++-
 sound/soc/codecs/cs42l52.c                         |   2 +-
 sound/soc/codecs/cs42l56.c                         |   2 +-
 sound/soc/codecs/max98371.c                        |   2 +-
 sound/soc/codecs/nau8822.c                         |   4 +-
 sound/soc/codecs/pcm3168a.c                        |   2 +-
 sound/soc/codecs/wm8978.c                          |   4 +-
 sound/soc/intel/avs/pcm.c                          |   2 +-
 sound/soc/sof/ipc4-topology.c                      |   9 +-
 sound/soc/sof/sof-client.c                         |   6 +-
 sound/soc/stm/stm32_spdifrx.c                      |   2 +-
 tools/arch/x86/include/asm/insn.h                  |   2 +-
 tools/bootconfig/main.c                            |   3 +-
 tools/gpio/Makefile                                |   6 +
 tools/power/x86/turbostat/turbostat.c              |  74 +++++++-----
 225 files changed, 2046 insertions(+), 879 deletions(-)


