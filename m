Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773793;
	b=rGlwAdgPOr/G/1AkE1fGv4NrWzUhUrgKzJZYMradZyzR/BKtKvyMQeC1+bTKWvP4g9WA
	 BvHCktmJDwlq7btRcgrsaIzsRuA7d87htLr4LO2hh4+3AfpbHkdy7WvhSk49tGderKQQV
	 FNHqErtpN833waOpYo2xLqC3eSEGoQ1w1zI/PyOSapkNi4cC8zXVxK1iHXBZjRW3XGTQH
	 3qbHbuA9O9WMR/oJHqQRcejKp0BNPGSn55CtDeIm0IcIYFN6bXfNA8A/zXVwDxMHjXAdU
	 XBNiPFb4/8AQFsIxqUo9J7jnCrmS428Oj/n+B7JHCA194i9kUNJN70fF47oG1QBxRrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=N7JBgKwwwrWLppfNYXioQ7hgZoPyybULWaSMvuRxNF0=;
	b=rc9VipsNc7yRicPt0LtFHoNWf9IaAOH/d8fG7MpKOd2VIMJ/JOdcVinroKy2APyRE5p0
	 XyCSQorxMpqrZFz7hiw5yyiLos7Ch/tCrbFkT2kA5tAwTj0JVKNq0GlfXRen301giHJvd
	 SUeNaaSZlXsx+b95rURyDnIFUTQZdPDSeXxqohPIpsk5Nh6ssjUoNjAtLvuMH2R/Sb15I
	 J9kwovDfNuK4BKParycZNL1HldGVs0WMWBDfRVsEEStI+khDF2dGQno4oi65IE8nxsU9f
	 v/JexjPkMQnVuDj8c9I0YAIgzNNbPa2mkCy0SA4dENGGgmKzYp5bLekgk86mqaAzgsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bJ1xpCEL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1012E606A31B;
	Fri, 23 Oct 2026 16:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bJ1xpCEL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1461F01825;
	Fri, 23 Oct 2026 16:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773792;
	bh=N7JBgKwwwrWLppfNYXioQ7hgZoPyybULWaSMvuRxNF0=;
	h=From:To:Cc:Subject:Date;
	b=bJ1xpCEL65kbvXCKdlg+clD036cWLTJ4UV+uGXYJ07zMrKZ7goIpE86Pol60mhe1j
	 9psQtAD8SlRvztOOtuCOAbY8AsYT8xk71GomON+ikEdT2MU1YonJVGyOsSLGEPof06
	 gxi9egs+8szDsiOQtia3K1RSHazKBgIVXSTip4Mc=
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
Subject: [PATCH 6.18 000/193] 6.18.59-rc1 review
Date: Fri, 23 Oct 2026 18:34:37 +0200
Message-ID: <20261023163714.201276352@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.59-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.59-rc1
X-KernelTest-Deadline: 2026-10-25T16:37+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.59 release.
There are 193 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 25 Oct 2026 16:36:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.59-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.59-rc1

Paulo Alcantara <pc@manguebit.org>
    smb: client: drain outstanding I/O before truncating on O_TRUNC open

Michal Schmidt <mschmidt@redhat.com>
    ice: fix crash in ethtool offline loopback test

Alexander Lobakin <aleksander.lobakin@intel.com>
    ice: fix broken Rx on VFs

Michal Kubiak <michal.kubiak@intel.com>
    ice: switch to Page Pool

Michal Kubiak <michal.kubiak@intel.com>
    ice: drop page splitting and recycling

Michal Kubiak <michal.kubiak@intel.com>
    ice: remove legacy Rx and construct SKB

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix data corruption with concurrent writes and O_TRUNC

Daehyeon Ko <4ncienth@gmail.com>
    vsock/vmci: validate packet source for connected sockets

Ido Schimmel <idosch@nvidia.com>
    ipv4: udp: Create exceptions before socket matching

Daehyeon Ko <4ncienth@gmail.com>
    vsock/virtio: validate packet source for connected sockets

Bobby Eshleman <bobbyeshleman@meta.com>
    virtio: set skb owner of virtio_transport_reset_no_sock() reply

Yao Kai <yaokai34@huawei.com>
    workqueue: Fix unbound pool lifetime for pending pwqs

Breno Leitao <leitao@debian.org>
    workqueue: release pwq pools by pool type

Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>
    io_uring/cancel: don't spin on local work the task can't run

Jens Axboe <axboe@kernel.dk>
    io_uring/cancel: move cancelation code from io_uring.c to cancel.c

Jens Axboe <axboe@kernel.dk>
    io_uring/cancel: move __io_uring_cancel() into cancel.c

Jens Axboe <axboe@kernel.dk>
    io_uring/cancel: move request/task cancelation logic into cancel.c

Frank Sorenson <sorenson@redhat.com>
    cifs: add revalidation on FSCTL failure in smb2_duplicate_extents()

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: refresh allocation size after duplicate extents

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix NULL dereference when copying keys for a field variable

Pengpeng Hou <pengpeng@iscas.ac.cn>
    tracing: Bound histogram expression strings with seq_buf

Pengpeng Hou <pengpeng@iscas.ac.cn>
    tracing: Use __free() for expr_str() buffer

Tom Zanussi <zanussi@kernel.org>
    tracing: Fix fully-qualified variable reference printing in histograms

Tejun Heo <tj@kernel.org>
    sched_ext: Fix stall when a task enqueued with SCX_ENQ_LAST lands back on its CPU's local DSQ

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: free the userptr ranges when a CS fails after parser_bos

Taeyang Lee <0wn@theori.io>
    tracing: Keep the predicate limit separate from program capacity

Dmitry Kandybka <d.kandybka@gmail.com>
    tracing: Fix ignored return value of resize_buffer_duplicate_size()

Hui Su <sh_def@163.com>
    sched_ext: idle: Respect task affinity in restricted CPU selection

Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>
    drm/i915/dmc: Harden DMC firmware payload parsing

Christian Brauner <brauner@kernel.org>
    ntfs3: free the sbi after a grace period

Baokun Li <libaokun1@huawei.com>
    fs/ntfs3: fix ntfs_mount_options leak in ntfs_fill_super()

YangWen <anmuxixixi@gmail.com>
    ntfs3: fix double free of sbi->options->nls and clarify ownership of fc->fs_private

YangWen <anmuxixixi@gmail.com>
    ntfs3: fix use-after-free of sbi->options in cmp_fnames

Laurence Oberman <loberman@redhat.com>
    scsi: st: Fix use-after-free race between st_remove() and st_open()

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix multiuser mount with krb5

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix heap overflow in cifs_do_set_acl()

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

Jun Yang <littleddfu@gmail.com>
    net: bridge: mcast: don't truncate the port group walk on teardown

Christian Brauner <brauner@kernel.org>
    ext4: free the sbi after a grace period

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Fix shift-out-of-bounds for aggregated ALH capture

Jann Horn <jannh@google.com>
    futex: Fix mm reuse handling for FUT_OFF_MMSHARED

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: keep the eviction fence until the last handle is closed

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/mmu: Cope with the SS bit being set in #NPF exit codes

Hyunwoo Kim <imv4bel@gmail.com>
    KVM: x86/mmu: Preserve nested TDP shadow page tables if they are used as roots

Florian Westphal <fw@strlen.de>
    netfilter: nft_byteorder: remove multi-register support

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: tiny-power-button: Convert the driver to a platform one

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Fix VCE 3 ring align_mask

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: SVM: Stop toggling virtual VMSAVE/VMLOAD on intercept recalc

Zihan Xi <zihanx@nebusec.ai>
    ipv4: avoid divide by zero in fib_rebalance

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix leak of uninitialized kernel data in SCLP report

Aswin Karuvally <aswin@linux.ibm.com>
    s390/ctcm: Prevent XID null dereference

Florian Schauer <florian@schauer.to>
    page_pool: keep frag_offset aligned for odd-sized requests

Charles Vosburgh <theminershive@gmail.com>
    sctp: validate chunk length in the inqueue parser

Chengfeng Ye <nicoyip.dev@gmail.com>
    tipc: protect node reset trace dump with node lock

Tejun Heo <tj@kernel.org>
    workqueue: Annotate cb_lock nesting when draining a dead BH pool

Zqiang <qiang.zhang@linux.dev>
    workqueue: Use raise_softirq() to trigger softirq in irq_work handler

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

Etienne Perot <eperot@google.com>
    cgroup: fix spurious SIGKILL of CLONE_INTO_CGROUP children

Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
    tcp: fix use-after-free in do_tcp_getsockopt(TCP_CC_INFO)

Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
    tcp: fix use-after-free in do_tcp_getsockopt(TCP_CONGESTION)

Heyang Tan <thy15333007817@163.com>
    wifi: p54: validate firmware record lengths

Tengda Wu <wutengda@huaweicloud.com>
    tracing: Fix hist trigger timestamps for buffered events

Amit Machhiwal <amachhiw@linux.ibm.com>
    tracing: Do not initialize tracefs work if tracing is disabled

Taeyang Lee <0wn@theori.io>
    tracing: Check operator stack capacity before pushing

David Carlier <devnexen@gmail.com>
    tracing: Take trace_types_lock when dropping the buffer_meta reference

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix the shift out of bounds in the log2 histogram modifier

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
    drm/amdgpu: don't drop the runtime PM reference twice in amdgpu_gpr

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/sdma3: Work around POLL_REGMEM / FENCE hang

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/pm: add zero fan stop temperature support on smu 14.0.2

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    scsi: libiscsi: Validate the task named by a management response

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    scsi: libiscsi: Validate the ITT reflected in a Reject PDU

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    scsi: libiscsi: Reject a negative task index from parse_pdu_itt

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    scsi: xen/scsifront: Check for a NULL shadow entry on a backend response

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

Wentao Liang <vulab@iscas.ac.cn>
    i2c: viai2c-wmt: Fix clock leak in wmt_i2c_probe()

Loic Poulain <loic.poulain@oss.qualcomm.com>
    i2c: qcom-cci: Fix HALT_ACK reset request being dropped

Lee Jones <lee@kernel.org>
    tracing/histograms: Reject non-stacktrace fields for synthetic stacktrace fields

Sasha Levin <sashal@kernel.org>
    tools: gpio: fix building from the top level with O=

Daehyeon Ko <4ncienth@gmail.com>
    sctp: revalidate output stream after association connect wait

Mario Limonciello <mario.limonciello@amd.com>
    pinctrl: amd: Clear S4 wake bits when firmware has _AEI

Aohan Mei <henrymei@tencent.com>
    net: rds: fix uninitialized trans dereference in CM event handler

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    net/sched: fix use-after-free in __tcf_action_put()

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: poly1305: Use memzero_explicit() in poly1305_final()

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state

Christian Brauner <brauner@kernel.org>
    namei: test for a negative dentry the way traverse_mounts() does

Christian Brauner <brauner@kernel.org>
    eventfs: Free the eventfs_inode after an rcu grace period too

Aviv Vaknin <vaknins33@gmail.com>
    pid_namespace: make zap_pid_ns_processes() freezable

Kyle Zeng <kylebot@openai.com>
    fsnotify: prevent mark additions during connector teardown

Amirmohammad Eftekhar <amirmohammadeftekhar@gmail.com>
    KVM: nVMX: Reset MMU back to the root MMU if loading L2 state fails for !VM-Entry

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

Christian Brauner <brauner@kernel.org>
    afs: free the super info after a grace period

Igor Paunovic <royalnet026@gmail.com>
    accel/rocket: search every core slot when a core is removed

Alexander Gruhlke <gruhlke@mailbox.org>
    PCI: Don't treat ~0 as ready in pci_dev_wait() with RRS SV

John Ogness <john.ogness@linutronix.de>
    printk: Postpone kthread startup

Haris Okanovic <harisokn@amazon.com>
    perf: Fix perf_pmu_migrate_context() leaving events behind

Peng Fan <peng.fan@nxp.com>
    gpio: mxc: fix race between gpiochip registration and IRQ domain setup

Peng Fan <peng.fan@nxp.com>
    gpio: mxc: fix wakeup_pads bit operations

Alexander Stein <alexander.stein@ew.tq-group.com>
    gpio: mxc: use BIT() macro

Peng Fan <peng.fan@nxp.com>
    gpio: mxc: fix both_edges bit operations

Peng Fan <peng.fan@nxp.com>
    gpio: mxc: fix race between chained IRQ handler install and probe completion

Kent Gibson <warthog618@gmail.com>
    gpiolib: fix memory leak in gpiod_set_array_value_complex() on error paths

Joas Antonio dos Santos <joasantonio108@gmail.com>
    calipso: keep BIG TCP payload_len in calipso_skbuff_setattr()

Alice Mikityanska <alice@isovalent.com>
    net/ipv6: Introduce payload_len helpers

Nicolai Buchwitz <nb@tipi-net.de>
    net: bcmgenet: unshare the skb before writing the control block

Kyle Zeng <kylebot@openai.com>
    netlink: avoid hashing the network namespace pointer

Xingui Yang <yangxingui@huawei.com>
    scsi: libsas: Fix SMP IO deadlock during HA resume

Martin Kaiser <martin@kaiser.cx>
    tracing: probes: error if BTF is required but unavailable

Kyle Zeng <kylebot@openai.com>
    pipe: preserve existing fasync readers on writer setup failure

Sasha Levin <sashal@kernel.org>
    samples: pidfd: fix userprogs typo

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/dlm: Protect the recovery list during debugfs reads

Erik Faye-Lund <erik.faye-lund@arm.com>
    drm/panthor: fix immortalis condition

Linfeng Sun <linfeng.sun.dev@gmail.com>
    scsi: target: iscsi: Fix race in discovery auth updates

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

Francesco Lavra <flavra@baylibre.com>
    regcache: Do not overwrite error code when finalizing cache after error

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    regcache: Add ->populate() callback to separate from ->init()

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

Gilberto Conde <gilbertorconde@gmail.com>
    pinctrl: qcom: ipq5018: add missing pwm3 function on gpio13

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    pinctrl: qcom: qcs8300: Fix intr_target_width

Michael Kelley <mhkelley58@gmail.com>
    Drivers: hv: Don't reset VMBus connection state on error/exit paths

Michael Kelley <mhkelley58@gmail.com>
    x86/hyperv: Avoid using per-cpu output page in hv_apicid_to_vp_index()

Waiman Long <longman@redhat.com>
    Drivers: hv: Avoid infinite retry loop in init_vp_index()

Xueqin Luo <luoxueqin@kylinos.cn>
    power: supply: ds2780: Fix ds2780_get_capacity() returning raw value

Karl Mehltretter <kmehltretter@gmail.com>
    power: supply: Fix maintenance charge table kernel-doc

David Oberhollenzer <david.oberhollenzer@sigma-star.at>
    ARM: dts: ti/omap: dra7: fix PCIe PHY clock divider definition

Jinhui Guo <guojinhui.liam@bytedance.com>
    soc/tegra: fuse: Add missing newline to APBMISC error message

Federico Parola <fparola@amazon.de>
    kho: free phys_bits bitmaps using free_page() in __kho_abort()

Abel Vesa <abel.vesa@oss.qualcomm.com>
    i2c: qcom-geni: Restore the source-clock selection policy

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: purge rose_neigh->queue on final teardown

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: bound REJ-driven fast retransmits with the existing N2 counter

Harin Lee <me@harin.net>
    ALSA: ctxfi: Use correct DAIO type for da_desc

Harin Lee <me@harin.net>
    ALSA: ctxfi: Rename SPDIFI1 to SPDIFI_BAY

Takashi Iwai <tiwai@suse.de>
    ALSA: ctxfi: Don't enumerate SPDIF1 at DAIO initialization

Vadim Nikitushkin <bub4z0r@gmail.com>
    drm/ttm: fix swapped-out resources never leaving their bulk_move range


-------------

Diffstat:

 Documentation/netlink/specs/conntrack.yaml         |  21 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/ti/omap/dra7xx-clocks.dtsi       |   2 +-
 arch/nios2/include/asm/checksum.h                  |   2 +-
 arch/s390/pci/pci_sysfs.c                          |   3 +
 arch/x86/hyperv/hv_init.c                          |   3 +-
 arch/x86/kernel/kvm.c                              |  32 +-
 arch/x86/kvm/mmu.h                                 |  16 +-
 arch/x86/kvm/mmu/mmu.c                             |   1 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |   2 +-
 arch/x86/kvm/svm/svm.c                             |  10 +-
 arch/x86/kvm/vmx/nested.c                          |   4 +-
 block/bsg-lib.c                                    |  13 +-
 drivers/accel/rocket/rocket_device.c               |   2 +
 drivers/accel/rocket/rocket_device.h               |   1 +
 drivers/accel/rocket/rocket_drv.c                  |   7 +-
 drivers/acpi/tiny-power-button.c                   |  27 +-
 drivers/base/regmap/internal.h                     |   1 +
 drivers/base/regmap/regcache-maple.c               |   9 +-
 drivers/base/regmap/regcache.c                     |  18 +-
 drivers/gpio/gpio-mxc.c                            |  36 +-
 drivers/gpio/gpio-nct6694.c                        |   2 +-
 drivers/gpio/gpiolib.c                             |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |  23 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  11 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c             |  25 +-
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c              |   2 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |  55 +-
 drivers/gpu/drm/drm_exec.c                         |  77 ++-
 drivers/gpu/drm/i915/display/intel_cx0_phy.c       |  12 +-
 drivers/gpu/drm/i915/display/intel_dmc.c           |  76 ++-
 drivers/gpu/drm/i915/display/intel_dmc_regs.h      |  12 +
 drivers/gpu/drm/panthor/panthor_hw.c               |   2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   2 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  20 +-
 drivers/gpu/drm/xe/xe_bo.c                         |   6 +
 drivers/gpu/drm/xe/xe_exec.c                       |   7 +-
 drivers/gpu/drm/xe/xe_oa.c                         |   7 +
 drivers/gpu/drm/xe/xe_vm.c                         |  31 +-
 drivers/gpu/drm/xe/xe_vm.h                         |   2 +
 drivers/hv/channel_mgmt.c                          |  12 +-
 drivers/hv/connection.c                            |   1 -
 drivers/hv/vmbus_drv.c                             |   1 -
 drivers/i2c/busses/i2c-qcom-cci.c                  |   4 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |  37 +-
 drivers/i2c/busses/i2c-viai2c-wmt.c                |   2 +-
 drivers/md/dm-cache-target.c                       |  59 +-
 drivers/md/dm-crypt.c                              |   3 +-
 drivers/md/dm-ebs-target.c                         |   3 +-
 drivers/md/dm-integrity.c                          |   6 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  10 +
 drivers/net/ethernet/intel/Kconfig                 |   1 +
 drivers/net/ethernet/intel/ice/ice.h               |   3 +-
 drivers/net/ethernet/intel/ice/ice_base.c          | 128 ++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  26 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |  16 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  21 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          | 647 +++------------------
 drivers/net/ethernet/intel/ice/ice_txrx.h          | 125 +---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      |  69 ++-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h      |   9 -
 drivers/net/ethernet/intel/ice/ice_xsk.c           | 146 +----
 drivers/net/ethernet/intel/ice/ice_xsk.h           |   6 +-
 drivers/net/ethernet/intel/ice/virt/queues.c       |   6 +-
 .../mellanox/mlx5/core/steering/hws/fs_hws.c       |   5 +-
 drivers/net/wireless/intersil/p54/fwio.c           |  42 +-
 drivers/pci/pci.c                                  |  15 +-
 drivers/pinctrl/pinctrl-amd.c                      |   9 +
 drivers/pinctrl/qcom/pinctrl-ipq5018.c             |  10 +-
 drivers/pinctrl/qcom/pinctrl-qcs8300.c             |   1 +
 drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c           |   1 +
 drivers/power/supply/ds2780_battery.c              |   2 +-
 drivers/power/supply/generic-adc-battery.c         |   9 +-
 drivers/power/supply/power_supply_core.c           |  26 +-
 drivers/s390/net/ctcm_mpc.c                        |   3 +-
 drivers/scsi/libiscsi.c                            |  14 +-
 drivers/scsi/libsas/sas_expander.c                 |  14 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |   2 +-
 drivers/scsi/scsi_transport_fc.c                   |   6 +-
 drivers/scsi/scsi_transport_iscsi.c                |   2 +-
 drivers/scsi/scsi_transport_sas.c                  |   6 +-
 drivers/scsi/st.c                                  |  18 +-
 drivers/scsi/xen-scsifront.c                       |   1 +
 drivers/soc/tegra/fuse/tegra-apbmisc.c             |   2 +-
 drivers/spi/spi-tegra114.c                         |   7 +
 drivers/target/iscsi/iscsi_target_configfs.c       |  26 +-
 drivers/ufs/core/ufs_bsg.c                         |   2 +-
 fs/afs/internal.h                                  |   2 +
 fs/afs/super.c                                     |   2 +-
 fs/autofs/waitq.c                                  |  25 +-
 fs/ext4/ext4.h                                     |   2 +
 fs/ext4/extents_status.c                           |   7 +-
 fs/ext4/extents_status.h                           |   1 +
 fs/ext4/super.c                                    |  13 +-
 fs/namei.c                                         |   3 +-
 fs/notify/mark.c                                   |  11 +
 fs/ntfs3/ntfs_fs.h                                 |   1 +
 fs/ntfs3/super.c                                   |  66 ++-
 fs/ocfs2/dlm/dlmcommon.h                           |   2 +
 fs/ocfs2/dlm/dlmdebug.c                            |   5 +-
 fs/ocfs2/dlm/dlmrecovery.c                         |   2 +-
 fs/pipe.c                                          |   6 +-
 fs/smb/client/cifsfs.c                             |  10 +-
 fs/smb/client/cifssmb.c                            |  13 +-
 fs/smb/client/connect.c                            |  21 +-
 fs/smb/client/file.c                               |  38 +-
 fs/smb/client/smb2ops.c                            |  35 +-
 fs/smb/server/smb2pdu.c                            |   5 +
 fs/tracefs/event_inode.c                           |  10 +-
 fs/unicode/utf8-core.c                             |  21 +-
 fs/xfs/libxfs/xfs_rtgroup.h                        |   6 +-
 fs/xfs/libxfs/xfs_sb.c                             |  37 +-
 fs/xfs/xfs_aops.c                                  |   3 +-
 fs/xfs/xfs_fsmap.c                                 |   2 +-
 fs/xfs/xfs_ioctl.c                                 |   2 +-
 fs/xfs/xfs_iomap.c                                 |   3 +-
 fs/xfs/xfs_iops.c                                  |   2 +-
 include/drm/drm_exec.h                             |  15 +-
 include/linux/bsg-lib.h                            |   3 +-
 include/linux/cgroup-defs.h                        |   5 +-
 include/linux/fsnotify_backend.h                   |   1 +
 include/linux/futex.h                              |  18 +-
 include/linux/ipv6.h                               |  22 +
 include/linux/maple_tree.h                         |   4 +
 include/linux/mm_types.h                           |   3 +
 include/linux/power_supply.h                       |  16 +-
 include/linux/sched/user.h                         |   8 +-
 include/linux/unicode.h                            |   1 +
 include/net/af_vsock.h                             |   3 +
 include/net/ipv6.h                                 |   2 -
 include/net/netfilter/nf_tables_ipv6.h             |   4 +-
 include/net/rose.h                                 |  12 +
 io_uring/cancel.c                                  | 269 +++++++++
 io_uring/cancel.h                                  |   8 +-
 io_uring/io_uring.c                                | 288 +--------
 io_uring/io_uring.h                                |  13 +-
 io_uring/sqpoll.c                                  |   1 +
 kernel/cgroup/cgroup.c                             |   6 +-
 kernel/events/core.c                               |  33 +-
 kernel/exit.c                                      |   2 +-
 kernel/futex/core.c                                |  79 +--
 kernel/kexec_handover.c                            |   2 +-
 kernel/pid_namespace.c                             |   2 +-
 kernel/printk/printk.c                             |   2 +-
 kernel/sched/ext.c                                 |  13 +-
 kernel/sched/ext_idle.c                            |  50 +-
 kernel/sched/ext_internal.h                        |   5 +-
 kernel/trace/ring_buffer.c                         |  13 +-
 kernel/trace/trace.c                               |  13 +-
 kernel/trace/trace_events_filter.c                 |   9 +-
 kernel/trace/trace_events_hist.c                   | 101 ++--
 kernel/trace/trace_probe.c                         |   3 +-
 kernel/watch_queue.c                               |  11 +-
 kernel/workqueue.c                                 |  36 +-
 lib/crypto/arm64/poly1305-armv8.pl                 |   2 +-
 lib/crypto/poly1305.c                              |   2 +-
 net/ax25/ax25_std_in.c                             |  36 ++
 net/bridge/br_multicast.c                          |  13 +-
 net/bridge/br_netfilter_ipv6.c                     |   2 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |   4 +-
 net/core/page_pool.c                               |   3 +-
 net/core/sock.c                                    |   3 +
 net/ipv4/fib_semantics.c                           |   2 +-
 net/ipv4/tcp.c                                     |  18 +-
 net/ipv4/tcp_cong.c                                |   4 +-
 net/ipv4/tcp_dctcp.c                               |   4 +-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv4/udp.c                                     |  11 +-
 net/ipv6/calipso.c                                 |   6 +-
 net/ipv6/ip6_input.c                               |   2 +-
 net/ipv6/ip6_offload.c                             |   7 +-
 net/ipv6/output_core.c                             |   7 +-
 net/iucv/af_iucv.c                                 |  42 +-
 net/mac802154/ieee802154_i.h                       |   7 +-
 net/mac802154/main.c                               |   1 +
 net/mac802154/scan.c                               |  51 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   2 +-
 net/netfilter/nf_conntrack_ovs.c                   |   2 +-
 net/netfilter/nf_log_syslog.c                      |   2 +-
 net/netfilter/nft_byteorder.c                      |  51 +-
 net/netlink/af_netlink.c                           |  10 +-
 net/rds/rdma_transport.c                           |  38 +-
 net/sched/act_api.c                                |  11 +-
 net/sched/cls_flower.c                             |   5 +
 net/sched/sch_cake.c                               |   2 +-
 net/sctp/inqueue.c                                 |   6 +-
 net/sctp/socket.c                                  |  33 +-
 net/tipc/node.c                                    |   2 +
 net/vmw_vsock/af_vsock.c                           |  49 +-
 net/vmw_vsock/virtio_transport_common.c            |   9 +-
 net/vmw_vsock/vmci_transport.c                     |  40 +-
 samples/pidfd/Makefile                             |   2 +-
 sound/pci/ctxfi/ctatc.c                            |  16 +-
 sound/pci/ctxfi/ctdaio.c                           |   5 +-
 sound/pci/ctxfi/ctdaio.h                           |   2 +-
 sound/soc/amd/yc/pci-acp6x.c                       |  38 +-
 sound/soc/codecs/cs42l52.c                         |   2 +-
 sound/soc/codecs/cs42l56.c                         |   2 +-
 sound/soc/codecs/max98371.c                        |   2 +-
 sound/soc/codecs/nau8822.c                         |   4 +-
 sound/soc/codecs/pcm3168a.c                        |   2 +-
 sound/soc/codecs/wm8978.c                          |   4 +-
 sound/soc/intel/avs/pcm.c                          |   2 +-
 sound/soc/sof/ipc4-topology.c                      |  16 +-
 sound/soc/stm/stm32_spdifrx.c                      |   2 +-
 tools/bootconfig/main.c                            |   3 +-
 tools/gpio/Makefile                                |   6 +
 tools/power/x86/turbostat/turbostat.c              |  24 +-
 210 files changed, 2271 insertions(+), 1951 deletions(-)


