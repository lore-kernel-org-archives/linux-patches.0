Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212055;
	b=Tv4byX8qrxXu+pu3WOGDMxwnYd2fvUZaXIuufSyv9sjZYMc5TdI2faSP0UBDHutkdRVb
	 YVn2GlRtDBN+UJYC9OeRN/843857HTFspZlRHgeEntLRduwisRxBXp8HAhymfWeXRZgd4
	 cMBhtjLY2ye8SiDRyN6ArHTvGoAsWAdkCQK80w6cSbdJclRxBKs+jQ6u16fBjFHlPhrmb
	 dDtaaHFWWCU9hP3pTsZHqrq9aXZOPJD6WrLipfTaVJdwevJrvWgU1Pu7r8mMG3hY1EsX0
	 /HaQxuyHiVmRO+Ige7zKYFAncE8WCDojy0CU8hJc7jKa4ihNBxKtOQg8VNxlcnullsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=/v7bjxT9XhwoqaO6JnGUT/X0eM+n4jR444NsAYVs+i0=;
	b=VdNHkkbMzeAG1OexJhhDxV1yNmbddzdA259bNIfVEQqb/m5tTpT1pyUqszh8KCWZfpWr
	 MY3CmDy+KcUgLPo+yMdhH3w1JOF0GbYpqnNT6OZsrApWmf7Fp1v1JM3wIY0r8t+JcelGW
	 h57wp/hZ1LWgmX6NW5UV6ZlHQK0vmt4p+8ZRihVus//JQc8hy4GGEBtvZrSD4XfLYsXc3
	 TNqyqSA+A3+JJsLyusa2WB0bu1hGEMPu2savViL2X4OSk3SxzDI6ycn2HgBaaJOECfkoL
	 QM2rhABHHwkUOqidxXNnMUjVDiUlel4Oze2V07XaiJKA33vOyxbem/Fa13mHp+VIf3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="k8/jyh62";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD2B606A31A;
	Wed, 28 Oct 2026 18:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8/jyh62
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1D01F01825;
	Wed, 28 Oct 2026 18:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212053;
	bh=/v7bjxT9XhwoqaO6JnGUT/X0eM+n4jR444NsAYVs+i0=;
	h=From:To:Cc:Subject:Date;
	b=k8/jyh62EFRWjFA4UFKEasLjzRMExcmEo8yItanF6a4rhmYZhkjXsPScC5HgoiGH9
	 yPjBkYg7kwciHbvz0fzrPKFKLcqxY1EJ1HQnuz5StbfN24er0M5k3iOVXIikykkrqy
	 eMff2Mkrf8CM1markzWRMLmR0dDOov+rUJgtM7xg=
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
Subject: [PATCH 6.1 0000/1887] 6.1.191-rc1 review
Date: Wed, 28 Oct 2026 17:34:56 +0100
Message-ID: <20261028170459.200466217@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.191-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.191-rc1
X-KernelTest-Deadline: 2026-10-30T17:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.191 release.
There are 1887 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 30 Oct 2026 17:02:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.191-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.191-rc1

Alexey Dobriyan <adobriyan@gmail.com>
    uapi: stddef.h: Fix header guard location

Xiaolei Wang <xiaolei.wang@windriver.com>
    pinctrl: freescale: Fix a memory out of bounds when num_configs is 1

Shenwei Wang <shenwei.wang@nxp.com>
    gpio: mxc: map Both Edge pad wakeup to Rising Edge

Haojie Li <lihaojie@kylinos.cn>
    drm/amdkfd: fix dma_buf reference leak in get_dmabuf_info

Steffen Klassert <steffen.klassert@secunet.com>
    Revert "esp: do not unref managed frag pages in esp_ssg_unref()"

Eric Dumazet <edumazet@google.com>
    inet: control sockets should not use current thread task_frag

Damien Le Moal <dlemoal@kernel.org>
    scsi: block: Improve ioprio value validity checks

Damien Le Moal <dlemoal@kernel.org>
    scsi: block: Introduce ioprio hints

Zhaoyang Huang <zhaoyang.huang@unisoc.com>
    mm: use stack_depot_early_init for kmemleak

Xiaolei Wang <xiaolei.wang@windriver.com>
    mm/kmemleak: use object_cache instead of kmemleak_initialized to check in set_track_prepare()

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: Use /* */ comment in initializer macro

Eric Dumazet <edumazet@kernel.org>
    vlan: restore HW VLAN tag insertion with reorder_hdr off

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: ctnetlink: do not expose expectation DEAD flag

Nathan Lynch <nathanl@linux.ibm.com>
    seq_buf: Make DECLARE_SEQ_BUF() usable

HyeongJun An <sammiee5311@gmail.com>
    ALSA: seq: Don't leak the extension cell pointer in the bounce payload

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: use correct endian in ocfs2_dinode_has_extents

ThangNN99 <ngocthang2710.1999@gmail.com>
    Bluetooth: hci_core: Fix queuing tx_work after workqueue is drained

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Print number of packets in conn->data_q

Tejun Heo <tj@kernel.org>
    sched/psi: Create the psimon kthread outside of cgroup_mutex

Dan Carpenter <dan.carpenter@linaro.org>
    ext4: fix error pointer dereference in ext4_mb_load_buddy_gfp()

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-core: fix cancellation of a port deferred qc work

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Preserve RUN bit when aborting DMA ring

Ming Qian <ming.qian@oss.nxp.com>
    media: verisilicon: Fix kernel panic due to __initconst misuse

Magnus Lindholm <linmag7@gmail.com>
    alpha: do not clear remote MMU contexts in migrate_flush_tlb_page()

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: protect tc_count increment in smb2_find_smb_sess_tcon_unlocked()

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    drm/amdgpu: replace PASID IDR with XArray

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: fix the idr allocation flags

Pankaj Gupta <pankaj.gupta@amd.com>
    KVM: SEV: Drop FOLL_WRITE for encrypted region registration

Perry Yuan <perry.yuan@amd.com>
    drm/amdgpu: ensure no_hw_access is visible before MMIO

Dan Carpenter <dan.carpenter@linaro.org>
    xen/events: fix error code in xen_bind_pirq_msi_to_irq()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: MGMT: fix crash in set_mesh_sync and set_mesh_complete

Jianpeng Chang <jianpeng.chang.cn@windriver.com>
    Bluetooth: MGMT: Fix memory leak in set_ssp_complete

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix dangling pointer on mgmt_add_adv_patterns_monitor_complete

Su Hui <suhui@nfschina.com>
    highmem: fix a memory copy problem in memcpy_from_folio

Moon Hee Lee <moonhee.lee.ca@gmail.com>
    fs/ntfs3: reject index allocation if $BITMAP is empty but blocks exist

Karl Mehltretter <kmehltretter@gmail.com>
    virtio_ccw: always take irq_lock in the classic interrupt handler

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix r_count dec/increment mismatch

Qihang <q.h.hack.winter@gmail.com>
    ksmbd: pin conn during async oplock break notification

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Follow rb_key.ats when creating new mkeys

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Fix implicit ODP hang on parent deregistration

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    rds: tcp: unregister sysctl before tearing down listen socket

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Remove redundant checks for automatic debugfs dump

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Fix a deadlock issue related to automatic dump

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Check before using pointer variables

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Drop handle on protocol bind failures

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Fix requested device removal race

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Unrequest devices if driver registration fails

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Add multiple protocols registration support

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Unregister device notifier before IDR teardown

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Free transport channel on IDR failure

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Protect device request lookup with RCU

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Avoid IDR updates while cleaning channels

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Reject out of range DT protocol IDs

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Use channel ID for transport teardown

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Add internal platform/channel identifiers

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Move errors defs and code to common.h

Gleb Markov <markov.gi@npc-ksb.ru>
    drm/amd/display: Remove unused-but-set variable hubp from

Zicheng Qu <quzicheng@huawei.com>
    drm/amd/display: Fix null check for pipe_ctx->plane_state in dcn20_program_pipe

Hamza Mahfooz <hamza.mahfooz@amd.com>
    drm/amd/display: drop unused function set_abm_event()

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    pinmux: fix race causing mux_owner NULL with active mux_usecount

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix node_cnt race between extent node destroy and writeback

Cong Wang <cong.wang@bytedance.com>
    bpf: Fix a potential use-after-free in bpf_link_free()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between ordered extent completion and fiemap

Johannes Berg <johannes.berg@intel.com>
    net/sched: initialize noop_qdisc owner

Petr Machata <petrm@nvidia.com>
    Documentation: networking: Add a caveat to nexthop_compat_mode sysctl

Mike Tipton <quic_mdtipton@quicinc.com>
    interconnect: Don't access req_list while it's being manipulated

Song Shuai <songshuaishuai@tinylab.org>
    riscv: Remove SHADOW_OVERFLOW_STACK_SIZE macro

Radim Krčmář <rkrcmar@ventanamicro.com>
    riscv: use lw when reading int cpu in asm_per_cpu

Christian Brauner <brauner@kernel.org>
    signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL

Christian Brauner <brauner@kernel.org>
    pid_namespace: prevent TIF_NOTIFY_SIGNAL from interrupting the reaper

Christian Brauner <brauner@kernel.org>
    signal: don't retarget shared signals in a dying thread group

Christian Brauner <brauner@kernel.org>
    signal: only SIGKILL and the freezers interrupt a coredumping task

Christian Brauner <brauner@kernel.org>
    coredump: hold RCU while releasing parked threads

Aaron Ahmed <aarnahmd@amazon.com>
    ftrace: Initialize modname and offset in print_rec()

Weiming Shi <bestswngs@gmail.com>
    asymmetric_keys: reject trust keys without IDs

Srish Srinivasan <ssrish@linux.ibm.com>
    keys/trusted_keys: return immediately after TPM unseal failure

Stefano Garzarella <sgarzare@redhat.com>
    KEYS: trusted: Fix blob allocation size in tpm2_key_decode()

Adrian Martinez <adrimg3196@gmail.com>
    KEYS: Fix key_reject_and_link() race with keyring restriction

Cen Zhang <zzzccc427@gmail.com>
    keys: Protect the read method check against type removal

Kyle Zeng <kylebot@openai.com>
    keys: make keyring indexes independent of kernel addresses

Cen Zhang <zzzccc427@gmail.com>
    keys: Protect the type name while describing a key

Cen Zhang <zzzccc427@gmail.com>
    keys: Check the authorization payload in process keyring searches

Cen Zhang <zzzccc427@gmail.com>
    keys: Avoid the owner account dereference in named keyring lookup

Lee Jones <lee@kernel.org>
    tracing/histograms: Verify event_call identity when updating synth_event refcount

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix 64-bit and signed histogram fields on 32-bit kernels

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Unregister field variable histograms when the command fails

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Save the event file instead of the compatible histogram

Kyle Zeng <kylebot@openai.com>
    tracing: Reject incomplete event filter expressions

Kees Cook <keescook@chromium.org>
    Compiler Attributes: counted_by: Adjust name and identifier expansion

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: refuse __l2cap_chan_add if chan already has conn

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: access chan->conn safely in get/setsockopt

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm: split critical region in remap_file_pages() and invoke LSMs in between

Jonas Köppeler <j.koeppeler@tu-berlin.de>
    net_sched: codel: fix stale state for empty flows in fq_codel

Hangbin Liu <liuhangbin@gmail.com>
    bonding: do not set usable_slaves for broadcast mode

Yun Zhou <yun.zhou@windriver.com>
    xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf

Frank Sorenson <sorenson@redhat.com>
    cifs: add revalidation on FSCTL failure in smb2_duplicate_extents()

Ben Cressey <ben@cressey.dev>
    dm-integrity: fix infinite loop on discard with large tag size

Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>
    drm/i915/dmc: Harden DMC firmware payload parsing

Jann Horn <jannh@google.com>
    futex: Fix mm reuse handling for FUT_OFF_MMSHARED

Wentao Liang <vulab@iscas.ac.cn>
    i2c: viai2c-wmt: Fix clock leak in wmt_i2c_probe()

Ido Schimmel <idosch@nvidia.com>
    ipv4: udp: Create exceptions before socket matching

Daehyeon Ko <4ncienth@gmail.com>
    vsock/virtio: validate packet source for connected sockets

Chen Cheng <chencheng@fnnas.com>
    dm-integrity: require stable writes for internal hash modes

Usama Arif <usama.arif@linux.dev>
    mm/huge_memory: transfer the pmd dirty bit to the folio on zap

Aviv Vaknin <vaknins33@gmail.com>
    pid_namespace: make zap_pid_ns_processes() freezable

Jens Axboe <axboe@kernel.dk>
    exit: move core of do_wait() into helper

Christian Brauner <brauner@kernel.org>
    ext4: free the sbi after a grace period

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    watch_queue: Fix note pool publication race in watch_queue_set_size()

Daniil Stas <daniil.stas@posteo.net>
    hwmon: (drivetemp) Fix driver producing garbage data when SCSI errors occur

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    perf: Track the perf mlock gift separately

Laurence Oberman <loberman@redhat.com>
    scsi: st: Fix use-after-free race between st_remove() and st_open()

Lee Jones <lee@kernel.org>
    tracing/histograms: Reject non-stacktrace fields for synthetic stacktrace fields

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix multiuser mount with krb5

Aohan Mei <henrymei@tencent.com>
    net/sched: cls_flower: validate mask pointer after nla_next()

Aleksandr Khromov <haa@amicon.ru>
    ksmbd: zero the FS_OBJECT_ID_INFORMATION buffer before filling it in

Aleksandr Khromov <haa@amicon.ru>
    ksmbd: initialize FileSystemControlFlags in FS_CONTROL_INFORMATION

Aleksandr Khromov <haa@amicon.ru>
    ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION

Jun Yang <littleddfu@gmail.com>
    net: bridge: mcast: don't truncate the port group walk on teardown

Kairui Song <kasong@tencent.com>
    mm, madvise: fix potential workingset node list_lru leaks

Hyunwoo Kim <imv4bel@gmail.com>
    KVM: x86/mmu: Preserve nested TDP shadow page tables if they are used as roots

Matt Fleming <mfleming@cloudflare.com>
    mm/huge_memory: initialise workingset state before folio split

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Fix VCE 3 ring align_mask

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

Carlos Maiolino <cem@kernel.org>
    xfs: fix capability check in xfs

Bryam Vargas <hexlabsecurity@proton.me>
    net/iucv: fix the recvmsg window update

Genjian Zhang <zhanggenjian@kylinos.cn>
    dm-ebs: fix incorrect device offset check in ebs_ctr()

Ben Cressey <ben@cressey.dev>
    dm-crypt: fix a tiny race condition in crypt_dec_pending

Benjamin Marzinski <bmarzins@redhat.com>
    dm cache: fix issue with background work locking

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix demotion stats in passthrough mode

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

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix the shift out of bounds in the log2 histogram modifier

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: don't drop the runtime PM reference twice in amdgpu_gpr

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/sdma3: Work around POLL_REGMEM / FENCE hang

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    scsi: libiscsi: Validate the task named by a management response

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    scsi: libiscsi: Validate the ITT reflected in a Reject PDU

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    scsi: libiscsi: Reject a negative task index from parse_pdu_itt

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    scsi: xen/scsifront: Check for a NULL shadow entry on a backend response

Loic Poulain <loic.poulain@oss.qualcomm.com>
    i2c: qcom-cci: Fix HALT_ACK reset request being dropped

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

Kyle Zeng <kylebot@openai.com>
    fsnotify: prevent mark additions during connector teardown

Amirmohammad Eftekhar <amirmohammadeftekhar@gmail.com>
    KVM: nVMX: Reset MMU back to the root MMU if loading L2 state fails for !VM-Entry

Christian Brauner <brauner@kernel.org>
    unicode: free the map after a grace period

Sung Byeongchan <tjdqudcks0424@naver.com>
    autofs: ignore notification errors from a replaced pipe

Peng Fan <peng.fan@nxp.com>
    gpio: mxc: fix wakeup_pads bit operations

Alexander Stein <alexander.stein@ew.tq-group.com>
    gpio: mxc: use BIT() macro

Peng Fan <peng.fan@nxp.com>
    gpio: mxc: fix both_edges bit operations

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: mxc: use lock guards for the generic GPIO chip lock

Shenwei Wang <shenwei.wang@nxp.com>
    gpio: mxc: enable pad wakeup on i.MX8x platforms

Nicolai Buchwitz <nb@tipi-net.de>
    net: bcmgenet: unshare the skb before writing the control block

Kyle Zeng <kylebot@openai.com>
    netlink: avoid hashing the network namespace pointer

Xingui Yang <yangxingui@huawei.com>
    scsi: libsas: Fix SMP IO deadlock during HA resume

Kyle Zeng <kylebot@openai.com>
    pipe: preserve existing fasync readers on writer setup failure

Sasha Levin <sashal@kernel.org>
    samples: pidfd: fix userprogs typo

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/dlm: Protect the recovery list during debugfs reads

Linfeng Sun <linfeng.sun.dev@gmail.com>
    scsi: target: iscsi: Fix race in discovery auth updates

Laurence Oberman <loberman@redhat.com>
    scsi: st: Save the visited block for the partition the drive is in

Keith Busch <kbusch@kernel.org>
    nios2: fix __wsum type degradation in csum_fold()

Carlos Jones Jr <carlosjr.jones@analog.com>
    spi: tegra114: assert CS GPIO for every transfer in a message

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

Michael Kelley <mhkelley58@gmail.com>
    Drivers: hv: Don't reset VMBus connection state on error/exit paths

Waiman Long <longman@redhat.com>
    Drivers: hv: Avoid infinite retry loop in init_vp_index()

Xueqin Luo <luoxueqin@kylinos.cn>
    power: supply: ds2780: Fix ds2780_get_capacity() returning raw value

Karl Mehltretter <kmehltretter@gmail.com>
    power: supply: Fix maintenance charge table kernel-doc

Abdul Wasey <w453y.me@gmail.com>
    mptcp: move the OoO check back into __mptcp_try_fallback()

Jinu Kim <kimjw04271234@gmail.com>
    KVM: x86: Use active memslots for the per-vCPU MMIO cache

Ilan Dudnik <ilan.dudnik@safebreach.com>
    ksmbd: fix heap out-of-bounds write in krb5_authenticate()

Matthew Wilcox (Oracle) <willy@infradead.org>
    powerpc: Remove initialisation of readpos

Chengfeng Ye <nicoyip.dev@gmail.com>
    netfilter: cttimeout: prevent UAF during module unload

David Carlier <devnexen@gmail.com>
    ieee802154: hwsim: serialize pib updates to fix double-free

Zhiling Zou <zhilinz@nebusec.ai>
    ipv6: flowlabel: cap duplicate leases per socket

Xixin Liu <liuxixin@kylinos.cn>
    perf: RISC-V: store available counter mask as bitmap

Kalpan Jani <kalpan.jani@mpiricsoftware.com>
    mptcp: pm: kernel: drop pending ADD_ADDR when removing ID0

Paulo Alcantara <pc@manguebit.org>
    smb: client: honor forceuid/forcegid when mapping SIDs to uid/gid

Bjoern Doebel <doebel@amazon.de>
    smb: client: fail DACL rewrite when the new DACL exceeds 64K

Paulo Alcantara <pc@manguebit.org>
    smb: client: avoid using uninitialized SIDs in cifs_posix_to_fattr()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size

Daeho Jeong <daehojeong@google.com>
    f2fs: accurately adjust free_sections during free_segment_range

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Skip vport under deletion in report ID acquisition

Yuqi Xu <xuyuqiabc@gmail.com>
    wifi: cfg80211: reject duplicate wiphy cipher suite entries

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    spi: spi-qcom-qspi: Fix incomplete error handling in runtime PM

Douglas Anderson <dianders@chromium.org>
    spi: spi-qcom-qspi: Support pinctrl sleep states

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Add CAP_SYS_ADMIN check to __resource_resize_store()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI/sysfs: Demacrofy pci_dev_resource_resize_attr(n) functions

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: paris: bypass pinctrl GPIO layer in set GPIO direction

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: phy: check length before parsing PHY status IE

Candice Li <candice.li@amd.com>
    drm/amdgpu: validate and share PSP fw_pri_buf copies via psp_copy_fw

Candice Li <candice.li@amd.com>
    drm/amdgpu: Bound GPIO I2C table entry count from VBIOS

Stepan Ionichev <sozdayvek@gmail.com>
    tty: serial: 8250: protect against NULL uart->port.dev in register

Herve Codina <herve.codina@bootlin.com>
    driver core: Avoid warning when removing a device while its supplier is unbinding

Sicong Huang <congei42@163.com>
    virt: acrn: Fix irqfd use-after-free during eventfd shutdown

Tao Cui <cuitao@kylinos.cn>
    RDMA/counter: Fix num_counters leak on bind_qp failure in alloc_and_bind()

Shiwu Zhang <shiwu.zhang@amd.com>
    drm/amdgpu: fix buffer overflow during vBIOS update

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Use attribute groups for PSP flashing attributes

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Add vbios attribute only if supported

Yongqiang Sun <Yongqiang.Sun@amd.com>
    drm/amdkfd: fix SMI event cross-process information leak

Mohamed Khalfella <mkhalfella@purestorage.com>
    nvme-fc: Do not cancel requests in io target before it is initialized

Fredric Cover <fredric.cover.lkernel@gmail.com>
    smb: client: fix races in cifsd thread creation

Paulo Alcantara <pc@manguebit.com>
    cifs: get rid of dns resolve worker

David Timber <dxdt@dev.snart.me>
    exfat: fix handling of damaged volume in exfat_create_upcase_table()

Daniel Yang <danielyangkang@gmail.com>
    exfat: resolve memory leak from exfat_create_upcase_table()

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Let driver decide buffer size at AMDKFD_IOC_GET_DMABUF_INFO ioctl

Peter Zijlstra <peterz@infradead.org>
    perf: Fix addr_filter_ranges lifetime

Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: mac80211: ibss: wait for in-flight TX on disconnect

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: pcie: null RX pointers after free

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: flush dirty data before punching a hole

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: validate TX_CMD response layout

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix a possible underflow

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: add a check on the tid coming from the firmware

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix out-of-bounds tid_data access in BA notif

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: preserve VFS inherited POSIX ACL mask

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix maximum allowed access checks

Val Packett <val@packett.cool>
    remoteproc: qcom_wcnss: Fix handling the lack of PD regulators in v3

Yun Zhou <yun.zhou@windriver.com>
    ext4: fix circular lock dependency in ext4_ext_migrate

Gou Hao <gouhao@uniontech.com>
    powerpc/xive: propagate IPI init errors to prevent use-after-free

Gou Hao <gouhao@uniontech.com>
    powerpc/xive: add error return value to xive_smp_probe()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: bus: Introduce acpi_bus_get_primary_device()

Chris Mason <clm@meta.com>
    svcrdma: Reject Write/Reply chunks with segcount 0

Shameer Kolothum <skolothumtho@nvidia.com>
    iommu/arm-smmu-v3: Manage teardown with devm

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix recursive locking during device registration

Li Chen <me@linux.beauty>
    nvdimm: virtio_pmem: refcount requests for token lifetime

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Clear queue->active_job when v3d_fence_create() fails

Richard Cheng <icheng@nvidia.com>
    cxl/mbox: Clamp mailbox output allocation to the payload size

Evgenii Burenchev <evg28bur@yandex.ru>
    drm/amd/display: Fix dangling pointer in plane reset function

Evgenii Burenchev <evg28bur@yandex.ru>
    drm/amd/display: Fix dangling pointer in CRTC reset function

Leon Hwang <leon.hwang@linux.dev>
    bpf: Copy per-CPU map value padding in copy_map_value_long()

Gregory Price <gourry@gourry.net>
    mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug

Alex Bereza <alex@bereza.email>
    dmaengine: xilinx_dma: Fix CPU stall in xilinx_dma_poll_timeout

Manos Pitsidianakis <manos@pitsidianak.is>
    hwrng: core - fix rng list on registration error

Myeonghun Pak <mhun512@gmail.com>
    crypto: keembay - Fix AEAD unregister count in error path

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Make nr_deadline_tasks an atomic_t

Chen Ridong <chenridong@huawei.com>
    cgroup/cpuset: move common code to cpuset-internal.h

Chen Ridong <chenridong@huawei.com>
    cgroup/cpuset: introduce cpuset-v1.c

Malaya Kumar Rout <malayarout91@gmail.com>
    time/namespace: Validate nanosecond field in proc_timens_set_offset()

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-wmi-base: Fix handling of ultra performance key

Armin Wolf <W_Armin@gmx.de>
    platform/x86: lg-laptop: Fix LED resource handling

Nicholas Dudar <main.kalliope@gmail.com>
    bpf: Reject rdonly/rdwr_buf_size kfunc arguments that exceed u32 max

Qing Ming <a0yami@mailbox.org>
    usb: gadget: uac: validate rate list length before storing

Marco Scardovi <scardracs@disroot.org>
    platform/x86: asus-wmi: fix resource leaks on probe failure

Maher Azzouzi <maherazz04@gmail.com>
    esp: do not unref managed frag pages in esp_ssg_unref()

Leon Romanovsky <leon@kernel.org>
    RDMA/rvt: Return NULL after port allocation failure

Reinette Chatre <reinette.chatre@intel.com>
    fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Publish channel state before callbacks

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Fix SCMI device destroy lifetimes

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: guard against division by zero in iwl_dbg_tlv_alloc_fragments

Ruoyu Wang <ruoyuw560@gmail.com>
    drm/msm: Only fini scheduler after successful init

Philipp Stanner <phasta@kernel.org>
    drm/sched: Use struct for drm_sched_init() params

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Terminate all descriptors without callbacks

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Zero queue and stack outputs on lock failure

Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
    ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()

Leon Romanovsky <leon@kernel.org>
    RDMA/erdma: complete object teardown when the destroy command fails

Leon Hwang <leon.hwang@linux.dev>
    bpf: Fix WARNING in bpf_tracing_link_release

Justin Yeh <justin.yeh@mediatek.com>
    pinctrl: mediatek: use devm_gpiochip_add_data() for GPIO chip

Li Qiang <liqiang01@kylinos.cn>
    scsi: ufs: core: Validate string descriptors

Fan Wu <fanwu01@zju.edu.cn>
    spi: oc-tiny: switch to managed controller allocation

Gary Guo <gary@garyguo.net>
    PCI: Fix UAF when probe runs concurrent to dyn ID removal

Gary Guo <gary@garyguo.net>
    PCI: Fix dyn_id add TOCTOU

Gary Guo <gary@garyguo.net>
    PCI: Make pci_match_one_device() match on ID instead of device

Samiullah Khawaja <skhawaja@google.com>
    PCI: Initialize temporary device in new_id_store()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismatch

Leon Romanovsky <leon@kernel.org>
    RDMA/cxgb4: Fix dereg_skb leak and double free in write_tpt_entry()

Fan Wu <fanwu01@zju.edu.cn>
    spi: davinci: switch to managed controller allocation

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: fix overreads in ath11k_wmi_process_csa_switch_count_event()

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: fix stride mismatch in mac_phy_caps_parse()

Pu Lehui <pulehui@huawei.com>
    bpf: Fix potential UAF when reading bpf link info

Kui-Feng Lee <kuifeng@meta.com>
    bpf: Retire the struct_ops map kvalue->refcnt.

Peter Zijlstra <peterz@infradead.org>
    x86/ftrace: Remove SYSTEM_BOOTING exceptions

Martin Wilck <mwilck@suse.com>
    md/raid1: create serial pool adding rdev to array with serialize_policy=1

Muhammad Usama Anjum <usama.anjum@arm.com>
    misc: sgi-gru: remove interrupt-context page-table walks

Michael-CY Lee <michael-cy.lee@mediatek.com>
    wifi: mt76: fix non-AQL packet accounting for MLO stations

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: unwind state on add_interface failure

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    wifi: mt76: mt7915: Fix an error handling path in mt7915_add_interface()

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: allocate vif wcid in the same range as stations

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: cancel reset and rc work on device unregister

Yonghong Song <yonghong.song@linux.dev>
    bpf, x86: Fix trampoline stack size for 128-bit arguments

Will Deacon <will@kernel.org>
    arm64: ptrace: Keep 'orig_x0' in-sync with x0 on syscall entry

Zhao Li <enderaoelyther@gmail.com>
    wifi: nl80211: clean up color-change beacon data on errors

Jason Huang <jason.huang2@infineon.com>
    wifi: brcmfmac: fix P2P action frame handling without device vif

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: stop PMSR before P2P and NAN teardown

Karl Mehltretter <kmehltretter@gmail.com>
    serial: core: do fallible allocations before the console can be registered

Karl Mehltretter <kmehltretter@gmail.com>
    serial: core: clear freed pointers on uart_register_driver() failure

Karl Mehltretter <kmehltretter@gmail.com>
    tty: skip cdev_del() when no cdev is registered

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    tty: make tty_class a static const structure

Haoxiang Li <haoxiang_li2024@163.com>
    HID: logitech-hidpp: Fix FF device cleanup on init failure

Vicki Pfau <vi@endrift.com>
    HID: steam: Reject short reads

Pu Lehui <pulehui@huawei.com>
    bpf, cgroup: Fix invalid storage access after __cgroup_bpf_attach failed

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: hwmon: Remove hwmon class device along with its parent

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/erdma: Hold QP references for AE and CM processing

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: o2hb: quiesce negotiate handlers and timeout work

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/cluster: keep heartbeat local node stable

Yufan Chen <ericterminal@gmail.com>
    ocfs2/heartbeat: fix slot mapping rollback leaks on error paths

Jiri Olsa <jolsa@kernel.org>
    bpf: Clear buf on error in __bpf_get_task_stack

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Resize MST HDCP per-connector arrays to 32

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm4x: missing cscfg_csdev_disable_active_config() in perf enable

Yang Xiuwei <yangxiuwei@kylinos.cn>
    scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails

Filipe Manana <fdmanana@suse.com>
    btrfs: defrag: fix deadlock between defrag and delalloc space reservation

Qu Wenruo <wqu@suse.com>
    btrfs: always wait for ordered extents to avoid OE races

Sun YangKai <sunyangkai@fnnas.com>
    btrfs: check if root is readonly when setting posix acl

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: fix a wrong length calculation in qgroup_free_reserved_data()

Pu Lehui <pulehui@huawei.com>
    bpf, cgroup: Fix storage null-ptr-deref after replacing prog

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    bpf: Fix mmap_lock leak in irq_work path

Runyu Xiao <runyu.xiao@seu.edu.cn>
    sunrpc: xprtsock: annotate shared socket callbacks with READ_ONCE/WRITE_ONCE

Benjamin Coddington <bcodding@redhat.com>
    Treewide: Stop corrupting socket's task_frag

Guillaume Nault <gnault@redhat.com>
    net: Introduce sk_use_task_frag in struct sock.

Alexander Aring <aahringo@redhat.com>
    fs: dlm: cleanup listen sock handling

Alexander Aring <aahringo@redhat.com>
    fs: dlm: remove socket shutdown handling

Alexander Aring <aahringo@redhat.com>
    fs: dlm: use listen sock as dlm running indicator

Chuck Lever <cel@kernel.org>
    NFS: Return a delegation the client fails to record

Kuniyuki Iwashima <kuniyu@google.com>
    amt: Don't support cross-netns setup.

Sven Peter <sven@kernel.org>
    nvme-apple: Destroy the admin queue on removal

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: fix memory leak in error path of build_tree()

Marek Szyprowski <m.szyprowski@samsung.com>
    clocksource/drivers/samsung_pwm: Switch to raw_spinlock_t type

Maurizio Lombardi <mlombard@redhat.com>
    nvmet: fix max_qid race between configfs and controller allocation

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: validate orphan slot during inode read

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: validate DIO orphan slot during inode read

Zhan Xusheng <zhanxusheng1024@gmail.com>
    fs/ntfs3: fix integer overflow in MFT cluster validation

Zizhi Wo <wozizhi@huawei.com>
    null_blk: free zones array on device power-off

Usama Arif <usama.arif@linux.dev>
    blk-iolatency: clear delay state when freeing policy data

Usama Arif <usama.arif@linux.dev>
    blk-iocost: clear delay state when freeing policy data

Yu Kuai <yukuai@fygo.io>
    blk-cgroup: delay freeing policy data after rcu grace period

John Johansen <john.johansen@canonical.com>
    apparmor: fix deadlock in complain-mode change_hat

Yunseong Kim <yunseong.kim@est.tech>
    ksmbd: fix slab-out-of-bounds read in ksmbd_alloc_user()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: free preauth sessions on connection teardown

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: serialize oplock close with pending break ownership

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix null-ptr-deref in ksmbd_ipc_tree_connect_request()

Ilan Dudnik <ilan.dudnik@safebreach.com>
    ksmbd: defer publishing granted locks to prevent UAF/double-free race

Gao Xiang <xiang@kernel.org>
    erofs: fix interlaced ztailpacking pclusters

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: safely discard unregistered deferred locks

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: detach blocked lock requests before freeing

Hang Nan <2122295973@qq.com>
    ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size

Ze Tan <tanze@kylinos.cn>
    smb/server: fix session leak in ksmbd_session_register()

ZhangGuoDong <zhangguodong@kylinos.cn>
    pnfs/blocklayout: Fix device leaks on parse failure

Jeuk Kim <jeuk20.kim@gmail.com>
    NFSv4/flexfiles: fix NULL dereference for NFSv4.0 data servers

Zhansong Gao <zhsgao@hotmail.com>
    NFSv4: Fix incorrect argument passed to nfs4_delete_lease() in nfs4_add_lease()

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, xdp: move offload check into dev_xdp_install()

Baokun Li <libaokun@linux.alibaba.com>
    fuse: check for NULL root inode in fuse_fill_super_submount

Nguyen Dinh Phi <phind.uet@gmail.com>
    vsock: don't check the listener's sk_err in vsock_accept()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net: add missing ref_tracker_dir_exit() to alloc_netdev_mqs()

Christopher Lusk <clusk@northecho.dev>
    smb: client: fix request buffer leak in smb2_new_read_req()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: mtpav: shut down output timer before card teardown

Pengpeng Hou <pengpeng@iscas.ac.cn>
    net: qlcnic: validate unified ROM sections before loading

Eric Dumazet <edumazet@google.com>
    ip6mr: do not clone dst in ip6mr_cache_report()

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: fix 32-bit backlog wrap in gred, bfifo and plug enqueue

Eric Dumazet <edumazet@google.com>
    net_sched: sch_fifo: implement lockless __fifo_dump()

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: arp/nd proxy: fix reading neigh ha

Nikolay Aleksandrov <razor@blackwall.org>
    vxlan: fix reading neigh ha

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    NFSv4.1: zero referring call lists before decoding

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: account classifier filter allocations to memcg

Michael Kelley <mhkelley58@gmail.com>
    Drivers: hv: vmbus: Skip VMBus module cleanup for non-nested root partition

Radek Podgorny <radek@podgorny.cz>
    Bluetooth: do not leak an hci_conn when a second LE connect is rejected

Anshumali Gaur <agaur@marvell.com>
    octeontx2-vf: fix workqueue and netdev race in probe/remove

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_ife: Only operate on Ethernet frames

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq: add overflow bounds to quantum and initial quantum

Haotian Zhang <vulab@iscas.ac.cn>
    samples/ftrace: Fix kthread_stop() on ERR_PTR in ftrace-direct-multi-modify

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: skip double clone set expressions on element insert

Doruk Tan Ozturk <doruk@0sec.ai>
    HID: sony: clean up device list on probe failure

Chuck Lever <cel@kernel.org>
    NFSD: Prevent client use-after-free during close_lru reaping

Jeffin Philip <jeffinphilip14@gmail.com>
    usb: gadget: f_midi: initialize work in f_midi_alloc()

Kees Cook <keescook@chromium.org>
    usb: gadget: f_midi: Annotate struct f_midi with __counted_by

Kees Cook <keescook@chromium.org>
    Compiler Attributes: Add __counted_by macro

Steven Rostedt <rostedt@goodmis.org>
    tracing: Take trace_array reference when opening options file

Baineng Shou <shoubaineng@gmail.com>
    dma-buf: dma-heap: don't publish fd before copy_to_user() succeeds

Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
    dma-direct: return struct page from dma_direct_alloc_from_pool()

Christoph Hellwig <hch@lst.de>
    dma-direct: simplify the use atomic pool logic in dma_direct_alloc

Petr Tesarik <petrtesarik@huaweicloud.com>
    dma-direct: cleanup parameters to dma_direct_optimal_gfp_mask

Jinjie Ruan <ruanjinjie@huawei.com>
    powerpc/kexec_file: Prevent kexec range truncation

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: fix stale pqap_hook pointer on error in vfio_ap_mdev_set_kvm()

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix dereference matrix_mdev->kvm without checking for NULL

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix missing lock required to access list of ap_matrix_mdev objects

Haoxiang Li <haoxiang_li2024@163.com>
    ASoC: hdac_hda: Fix hlink refcount leak on component registration failure

Vidhu Sarwal <vidhu.linux@gmail.com>
    iio: light: ltrf216a: fix runtime PM reference leak in error path

Shreeya Patel <shreeya.patel@collabora.com>
    iio: light: ltrf216a: Return floating point values

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix memory corruption by not reinjecting CK machine checks

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: vgic-its: Don't dereference a NULL collection on ITT save

Wenjie Qi <qwjhust@gmail.com>
    f2fs: validate MOVE_RANGE destination size

Wenjie Qi <qwjhust@gmail.com>
    f2fs: avoid NULL checkpoint thread access in sysfs

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: use new ioprio Macro to get ckpt thread ioprio level

Damien Le Moal <dlemoal@kernel.org>
    scsi: block: ioprio: Clean up interface definition

Yangtao Li <frank.li@vivo.com>
    f2fs: convert to use sysfs_emit

Daeho Jeong <daehojeong@google.com>
    f2fs: fix to migrate all curseg types during free_segment_range

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential deadloop in f2fs_fsync_node_pages()

Chao Yu <chao@kernel.org>
    f2fs: fix to clear dirty flag on folio in error path

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: force complete the KIQ ring fences on reset

Priya Hosur <Priya.Hosur@amd.com>
    drm/amdkfd: Add TLB flush after MES queue eviction/suspension

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Fix error path at svm_migrate_copy_to_ram

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Fix the case that vm range is hole at svm_migrate_copy_to_vram

Marek Czernohous <marek@czernohous.de>
    drm/nouveau: unsubscribe the channel-kill event before the fence context

Jiri Olsa <jolsa@kernel.org>
    bpf: Disable preemption in bpf_get_stackid

Farhan Ali <alifm@linux.ibm.com>
    PCI: Allow per function PCI slots to fix slot reset on s390

Farhan Ali <alifm@linux.ibm.com>
    PCI: Introduce PCI_SLOT_PLACEHOLDER constant for slot_nr placeholder value

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: zero pipe read compound padding

Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>
    ksmbd: fix tree connection use-after-free in smb2_tree_connect()

Jann Horn <jannh@google.com>
    apparmor: fix cred UAF caused by begin_current_label_crit_section()

Quanfa Fu <quanfafu@gmail.com>
    apparmor: make aa_set_current_onexec return void

Breno Leitao <leitao@debian.org>
    mm/kmemleak: avoid soft lockup when scanning task stacks

Jim Cromie <jim.cromie@gmail.com>
    kmemleak: drop (age <increasing>) from leak record

Zhaoyang Huang <zhaoyang.huang@unisoc.com>
    mm: use stack_depot for recording kmemleak's backtrace

Kairui Song <kasong@tencent.com>
    mm/mglru: fix and remove redundant unevictable folio handling

Daniel Borkmann <borkmann@iogearbox.net>
    bpf: Disable preemption in __bpf_get_stack

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Reject Read lists that exceed the page budget

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Validate Read chunk positions before reconstruction

Jiangshan Yi <yijiangshan@kylinos.cn>
    HID: nintendo: register input device after capabilities are set

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Ensure first IDAW remains constant

David Windsor <dwindsor@gmail.com>
    bpf: Reject sleepable BPF_LSM_CGROUP programs at load time

Jordan Walters <jaggyaur@gmail.com>
    Bluetooth: hci_core: Fix UAF in hci_unregister_dev()

Eric Dumazet <edumazet@google.com>
    net: watchdog: fix refcount tracking races

Jamie Nguyen <jamien@nvidia.com>
    fs/ntfs3: resize log->one_page_buf when adopting on-disk page size

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: 6lowpan: hold L2CAP conn across debugfs control

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic: Handle race between interrupt affinity change and LPI disabling

Kanglong Wang <wangkanglong@loongson.cn>
    LoongArch: Move jump_label_init() before parse_early_param()

Qing Ming <a0yami@mailbox.org>
    cgroup/rstat: validate cpu before css_rstat_cpu() access

Florian Westphal <fw@strlen.de>
    netfilter: revalidate bridge ports

Damien Riégel <damien.riegel@silabs.com>
    greybus: raw: fix use-after-free if write is called after disconnect

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix fsck inconsistency caused by FGGC of node block

Gao Xiang <xiang@kernel.org>
    erofs: fix inline data read failure for ztailpacking pclusters

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_queue: do shared-unconfirmed check before segmentation

Xingui Yang <yangxingui@huawei.com>
    scsi: hisi_sas: Fix NULL pointer exception during user_scan()

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv4: nexthop: allocate skb dynamically in rtm_get_nexthop()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: clone set on flush only

Peilin Ye <yepeilin@google.com>
    bpf: Tell memcg to use allow_spinning=false path in bpf_timer_init()

Qu Wenruo <wqu@suse.com>
    btrfs: avoid NULL pointer dereference if no valid csum tree

Qu Wenruo <wqu@suse.com>
    btrfs: avoid NULL pointer dereference if no valid extent tree

Zqiang <qiang.zhang1211@gmail.com>
    rcu-tasks: Fix access non-existent percpu rtpcp variable in rcu_tasks_need_gpcb()

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check link_index before accessing dc->links[]

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix TX fifo corruption

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix soft lockup under heavy CEQE load

Gavin Shan <gshan@redhat.com>
    mm/shmem: disable PMD-sized page cache if needed

Jacob Keller <jacob.e.keller@intel.com>
    ice: Don't process extts if PTP is disabled

Gavin Shan <gshan@redhat.com>
    mm/filemap: skip to create PMD-sized page cache if needed

Longlong Xia <xialonglong@kylinos.cn>
    zram: fix out-of-bounds access in writeback_store()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: check truncate permission under inode lock

Jeff Layton <jlayton@kernel.org>
    lockd, nfsd: RCU-protect nlmsvc_ops dispatch

Jeff Layton <jlayton@kernel.org>
    nfsd: fix BUG_ON in nfsd4_alloc_layout_stateid on racing delegation revoke

Jeff Layton <jlayton@kernel.org>
    nfsd: fix fcache_disposal UAF by inlining dispose state into nfsd_net

Jeff Layton <jlayton@kernel.org>
    nfsd: fix stale s2s_cp_stateids IDR entry for async COPY

Chris Mason <clm@meta.com>
    nfsd: gate nfs3 setacl by argp->mask

Robbie Ko <robbieko@synology.com>
    nfsd: reject out-of-range nseconds in NFSv3 SETATTR and create ops

Chuck Lever <cel@kernel.org>
    NFSD: Prevent client use-after-free during delegation revoke

Xiubo Li <xiubo.li@clyso.com>
    ceph: fix UAF in check_new_map() on session freed during unlock

Michael Bommarito <michael.bommarito@gmail.com>
    ceph: cap delegated inode count in ceph_parse_deleg_inos()

Max Kellermann <max.kellermann@ionos.com>
    ceph: do not repeat ceph_trim_dentries() if no progress possible

Guanghui Yang <3497809730@qq.com>
    btrfs: drop recovered reloc root refs on recovery failure

Anand Jain <anand.jain@oracle.com>
    btrfs: rename err to ret in btrfs_recover_relocation()

Anand Jain <anand.jain@oracle.com>
    btrfs: rename ret to ret2 in btrfs_recover_relocation()

Anand Jain <anand.jain@oracle.com>
    btrfs: rename ret to err in btrfs_recover_relocation()

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    btrfs: fix extent map leak in NOCOW direct I/O write

Frank Sorenson <sorenson@redhat.com>
    cifs: call pagecache_isize_extended() in cifs_setsize() when extending

Bryam Vargas <hexlabsecurity@proton.me>
    smb: client: reject a tree connect response whose byte count is too small

Jiangshan Yi <yijiangshan@kylinos.cn>
    HID: mcp2221: clear rxbuf after I2C/SMBus transfer completes

Florian Pradines <florian.pradines@gmail.com>
    HID: mcp2221: fix OOB write in mcp2221_raw_event()

Jan Kara <jack@suse.cz>
    ext2: Fix lost inode updates for IS_SYNC inodes

Hui Su <sh_def@163.com>
    fbdev: ssd1307fb: defer I2C transfers from damage callbacks

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev/ssd1307fb: Generate deferred I/O ops

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: Add initializer macros for struct fb_ops

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: Validate info->screen_{base, buffer} in fb_ops implementations

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: Don't re-validate info->state in fb_ops implementations

Bryam Vargas <hexlabsecurity@proton.me>
    dm array: validate array block headers on read

Heinz Mauelshagen <heinzm@redhat.com>
    dm: correct block comments format.

Zhiling Zou <zhilinz@nebusec.ai>
    ip: orphan prefetched skbs before multicast forwarding

Andrea Mayer <andrea.mayer@uniroma2.it>
    ipv6: rpl: fix NULL dereference of idev in ipv6_rpl_srh_rcv()

Chris Mason <clm@meta.com>
    SUNRPC: svcauth_gss: enforce krb5 token minimum length

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Convert unwrap_priv_data() to use xdr_stream

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Rename automatic variables in unwrap_priv_data()

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix crasher in unwrap_integ_data()

Jeff Layton <jlayton@kernel.org>
    sunrpc: defer rq_argp and rq_resp free until after RCU grace period

Luxiao Xu <rakukuip@gmail.com>
    sunrpc: fix use-after-free in __rpc_clnt_handle_event and __rpc_clnt_remove_pipedir

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Reject short RFC 4121 MIC tokens in gss_krb5_verify_mic_v2

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Reject connection when transport allocation fails

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Handle ADDR_CHANGE CM event properly

Chuck Lever <cel@kernel.org>
    svcrdma: Reject inline replies that overflow the pull-up buffer

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Use svc_xprt_put to free listener on create failure

Yan Zhen <yanzhen@vivo.com>
    sunrpc: xprtrdma: Use ERR_CAST() to return

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Refactor the creation of listener CMA ID

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Allocate new transports on device's NUMA node

Tejun Heo <tj@kernel.org>
    sched/core: Make core-sched flips wait for in-flight selections

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    lockd: fix NULL dereference on lockowner allocation failure

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: charger-manager: register regulators before exposing sysfs

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    power: supply: charger-manager: Convert to platform remove callback returning void

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: lp8788-charger: fix use-after-free on remove

Andrew Davis <afd@ti.com>
    power: supply: lp8788: Use devm_power_supply_register() helper

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    power: supply: lp8788-charger: Convert to platform remove callback returning void

Jianing Li <m13940358460@163.com>
    power: supply: max17040: propagate register read errors

Weimin Xiong <xiongwm2026@163.com>
    iommu/msm: Unwind probe state on registration failure

Kevin Tian <kevin.tian@intel.com>
    iommu/vt-d: Force requesting ACS when tboot is enabled

Lu Baolu <baolu.lu@linux.intel.com>
    iommu: Add max_pasids field in struct iommu_device

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    platform/x86: int1092: Fix potential memory leak in sar_probe()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: intel_sar: Check ACPI_HANDLE() against NULL

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd/pmc: Propagate SMU errors and validate S2D address

Zihan Xi <zihanx@nebusec.ai>
    net: l2tp: do not propagate multicast notification errors

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net: ravb: serialize PTP clock teardown

Fan Ye <fy15309206903@gmail.com>
    net: thunderbolt: Mark the connection down when bringing it up fails

Fan Ye <fy15309206903@gmail.com>
    net: thunderbolt: Release the Rx HopID that was handed out on mismatch

Hidayath Khan <hidayath@linux.ibm.com>
    net/smc: stop killed, freed and out_of_sync sharing a byte

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    mfd: sm501: Fix potential memory leaks during remove

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mfd: sm501: Convert to platform remove callback returning void

Paul Cercueil <paul@crapouillou.net>
    mfd: sm501: Remove #ifdef guards for PM related functions

Dawei Feng <dawei.feng@seu.edu.cn>
    wifi: iwlwifi: dvm: fix memory leak in iwl_op_mode_dvm_start()

Bryam Vargas <hexlabsecurity@proton.me>
    wifi: mt76: mt7915: bound the device EEPROM address before the EFUSE copy

StanleyYP Wang <StanleyYP.Wang@mediatek.com>
    wifi: mt76: mt7915: set correct background radar capability

Eric Dumazet <edumazet@google.com>
    vlan: fix skb_under_panic and races when toggling HW VLAN offload

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Fix UVD dpb min size calculation for H264

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/amdgpu: Fix errors & warnings in amdgpu _uvd, _vce.c

Wei Fang <wei.fang@nxp.com>
    net: tap: fix wrong transport_header when sending VLAN-tagged frame

Akihiko Odaki <akihiko.odaki@daynix.com>
    tap: Keep hdr_len in tap_get_user()

Leon Romanovsky <leon@kernel.org>
    ntb: Store original DMA address for future release

Koichiro Den <den@valinux.co.jp>
    NTB: ntb_transport: Use ntb_get_dma_dev() for DMA buffers

Koichiro Den <den@valinux.co.jp>
    NTB: core: Add .get_dma_dev() callback to ntb_dev_ops

Eric Dumazet <edumazet@google.com>
    tipc: avoid busy looping in tipc_exit_net()

Ibrahim Hashimov <security@auditcode.ai>
    RDMA/rxe: Fix responder UAF on IB_QP_MAX_DEST_RD_ATOMIC modify_qp

Yong Wang <edragain@163.com>
    tcp: clamp route advmss to TCP_MIN_MSS

Kyle Zeng <kylebot@openai.com>
    net/packet: defer vmalloc TX_RING free until skbs finish

Fourie Zhang <littleddfu@gmail.com>
    netfilter: nf_tables: don't queue packet path object notifications

Bryam Vargas <hexlabsecurity@proton.me>
    crypto: virtio - bound the akcipher result length

Lukas Wunner <lukas@wunner.de>
    crypto: virtio - Drop superfluous [as]kcipher_req pointer

Lukas Wunner <lukas@wunner.de>
    crypto: virtio - Drop superfluous [as]kcipher_ctx pointer

Lukas Wunner <lukas@wunner.de>
    crypto: virtio - Drop sign/verify operations

Markus Elfring <elfring@users.sourceforge.net>
    crypto: virtio - Less function calls in __virtio_crypto_akcipher_do_req() after error detection

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: Wrap user-invoked calls to fb_set_var() in helper

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: ISO: zero the sockaddr before returning it in getname

Bryam Vargas <hexlabsecurity@proton.me>
    selinux: reject a permission value exceeding the class permission count

William Palacek <William.Palacek@amd.com>
    drm/amdkfd: Add bounds check for CRAT subtype length

Yongqiang Sun <Yongqiang.Sun@amd.com>
    drm/amdkfd: Fix infinite loop parsing CRAT with zero subtype length

Shay Drory <shayd@nvidia.com>
    net/mlx5e: TC, Check if flow is PEER before acquiring devcom lock

Luxiao Xu <rakukuip@gmail.com>
    bpf: Check sk_state before sk_protocol in bpf_tcp_*_syncookie

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Fix undersized format-check buffer

Heiko Carstens <hca@linux.ibm.com>
    s390: include linux/io.h instead of asm/io.h

Baoquan He <bhe@redhat.com>
    s390/mm: do not include <asm-generic/io.h> directly

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: move functions from header file to source file

Heiko Carstens <hca@linux.ibm.com>
    s390/appldata: remove power management callbacks

Yuho Choi <dbgh9129@gmail.com>
    dmaengine: idxd: fix double free of wq, engine, and group structs

Guenter Roeck <linux@roeck-us.net>
    hwmon: (sht3x) Fix unaligned accesses

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net: ethernet: mtk_eth_soc: pass eth to mtk_handle_irq_rx in poll_controller

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: use conntrack GC to reap expectations

Prasanna Kumar T S M <ptsm@linux.microsoft.com>
    soc: xilinx: Shutdown and free rx mailbox channel

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    soc/xilinx: zynqmp_power: Convert to platform remove callback returning void

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Add slave_destroy interface for v3 hw

Yuho Choi <dbgh9129@gmail.com>
    media: atomisp: gc2235: fix UAF and memory leak

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix call trace due to missing release()

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: synproxy: fix unaligned memory access in timestamp adjustment

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: synproxy: adjust duplicate timestamp options

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: synproxy: drop packets if timestamp adjustment fails

Florian Westphal <fw@strlen.de>
    netfilter: make nftables drops visible in net dropmonitor

David Carlier <devnexen@gmail.com>
    netfilter: flowtable: avoid num_encaps underflow on bridge VLAN untag

Weiming Shi <bestswngs@gmail.com>
    btrfs: lzo: reject compressed segment that overflows the compressed input

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: npc: Fix size of entry2cntr_map

Cen Zhang <zzzccc427@gmail.com>
    ALSA: seq: oss: Serialize readq reset state with q->lock

James Clark <james.clark@linaro.org>
    coresight: ete: Always save state on power down

Ivan Abramov <i.abramov@mt-integration.ru>
    ieee802154: Avoid calling WARN_ON() on -ENOMEM in cfg802154_switch_netns()

Li RongQing <lirongqing@baidu.com>
    ACPI: processor_idle: Mark LPI enter functions as __cpuidle

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: avoid combining some incoming suboptions

Candice Li <candice.li@amd.com>
    drm/amdgpu: reject oversized IBs with per-ring packet limits

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Limit the number of channel program segments

Mark Brown <broonie@kernel.org>
    ASoC: tas2562: Validate values for volume writes

Hongjie Fang <hongjiefang@asrmicro.com>
    scsi: core: pair EH runtime PM get and put

Julian Anastasov <ja@ssi.bg>
    ipvs: revalidate ihl to prevent out-of-bounds access

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_api: fix TOCTOU NULL deref on a->goto_chain

Victor Nogueira <victor@mojatatu.com>
    net: sched: Add initial TC error skb drop reasons

Victor Nogueira <victor@mojatatu.com>
    net: sched: Move drop_reason to struct tc_skb_cb

Jamal Hadi Salim <jhs@mojatatu.com>
    net, sched: Fix SKB_NOT_DROPPED_YET splat under debug config

Daniel Borkmann <daniel@iogearbox.net>
    net, sched: Make tc-related drop reason more flexible

Eric Dumazet <edumazet@google.com>
    l2tp: fix tunnel and session refcount leak on seq_file release

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    gpio: pca953x: fix pca953x_irq_bus_sync_unlock regmap lock

Karthikeyan KS <karthiproffesional@gmail.com>
    soc: aspeed: lpc-snoop: Fix usercopy overflow in snoop_file_read

David Lee <david.lee@trailofbits.com>
    btrfs: lzo: reject inline extents without valid headers

Chengfeng Ye <nicoyip.dev@gmail.com>
    bpf: Fix netns reference imbalance in conntrack kfuncs

Linfeng Sun  <linfeng.sun.dev@gamil.com>
    vhost_iotlb: bound map allocation in add_range

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_api: Always acquire rtnl_lock when destroying locked classifiers

Xin Long <lucien.xin@gmail.com>
    net: sched: refine software bypass handling in tc_run

Jianbo Liu <jianbol@nvidia.com>
    net: sched: cls_api: fix slab-use-after-free in fl_dump_key

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: sched: cls_api: add filter counter

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: sched: cls_api: add skip_sw counter

Eric Dumazet <edumazet@google.com>
    netfilter: nf_flow_table: drop existing skb dst before skb_dst_set_noref()

Alexandra Winter <wintera@linux.ibm.com>
    s390/ism: Fix UAF of sba and ieq during ism_dev_exit()

Hongyan Xu <getshell@seu.edu.cn>
    watchdog: at91sam9_wdt: prevent timer rearm during teardown

Dongli Zhang <dongli.zhang@oracle.com>
    net: tap: set skb->dev before parsing virtio net header in tap_get_user_xdp()

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    tls: rx: restore msg_iter before TLS 1.3 optimistic retry

Sabrina Dubroca <sd@queasysnail.net>
    selftests: tls: add rekey tests

Sabrina Dubroca <sd@queasysnail.net>
    selftests: tls: add test with a partially invalid iov

Sabrina Dubroca <sd@queasysnail.net>
    selftests: tls: add getsockopt test

Zhiling Zou <zhilinz@nebusec.ai>
    mm/page_table_check: skip special zero mappings

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/ptdump: always stabilise against page table freeing using init_mm

Dongjiang Zhu <zhudongjiang@fnnas.com>
    btrfs: skip global block reserve accounting for rescue mounts

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    net/sched: cls_u32: validate offshift to prevent shift-out-of-bounds

Eric Dumazet <edumazet@google.com>
    net: udp_tunnel: fix memory leak in udp_tunnel_nic_unregister()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: hold sk properly in iso_conn_ready

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: Block VFs from clobbering special CGX PKIND state

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Close speculative mem read possibility

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: reject DX_BIND_QUERY without a DX context

Werner Kasselman <werner@verivus.ai>
    drm/radeon: fix integer overflow in radeon_align_pitch()

Wei Zhang <wei.zhang@oss.qualcomm.com>
    wifi: ath11k: cancel SSR work items during PCI shutdown

Di Shen <di.shen@unisoc.com>
    OPP: Fix race between OPP addition and lookup

Alexander Aring <aahringo@redhat.com>
    dlm: fix add msg handle in send_queue ordered

Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
    IB/mlx5: Fix transport-domain rollback and initialize lb mutex earlier

Pengpeng Hou <pengpeng@iscas.ac.cn>
    tracing: Bound synthetic-field strings with seq_buf

Kees Cook <keescook@chromium.org>
    seq_buf: Introduce DECLARE_SEQ_BUF and seq_buf_str()

Matthew Wilcox (Oracle) <willy@infradead.org>
    tracing: Move readpos from seq_buf to trace_seq

Sergey Senozhatsky <senozhatsky@chromium.org>
    seq_buf: Add seq_buf_do_printk() helper

Lianfa Weng <wenglianfa@huawei.com>
    RDMA/hns: Fix log flood after cmd_mbox failure

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix UAF at handling events with embedded SysEx data

Geliang Tang <tanggeliang@kylinos.cn>
    nvmet-tcp: fix page fragment cache leak in error path

Michael S. Tsirkin <mst@redhat.com>
    vhost: fix vhost_get_avail_idx for a non empty ring

Michael S. Tsirkin <mst@redhat.com>
    vhost: move smp_rmb() into vhost_get_avail_idx()

Xianting Tian <xianting.tian@linux.alibaba.com>
    vhost: correct misleading printing information

Zhang Cen <rollkingzzc@gmail.com>
    ocfs2: validate fast symlink target during inode read

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: cttimeout: detach dataplane timeout policy and repurpose refcount

Bernard Metzler <bernard.metzler@linux.dev>
    RDMA/siw: Fix endpoint/socket association handling

Guoqing Jiang <guoqing.jiang@linux.dev>
    RDMA/siw: Introduce siw_destroy_cep_sock

Filipe Manana <fdmanana@suse.com>
    btrfs: fix deadlock cloning inline extent when using flushoncommit

Larysa Zaremba <larysa.zaremba@intel.com>
    ixgbe: do not configure xps for XDP queues

Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
    ext4: fix kernel BUG in ext4_write_inline_data_end

Yun Zhou <yun.zhou@windriver.com>
    ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: topology: Check PCM and DAI name strings before use

HanQuan <eilaimemedsnaimel@gmail.com>
    ALSA: seq: Fix kernel heap address leak in bounce_error_event()

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Drop superfluous filter argument of get_event_dest_client()

Joe Damato <joe@dama.to>
    bnxt: fix head underflow on XDP head-grow

Cen Zhang <zzzccc427@gmail.com>
    ALSA: seq: avoid stale FIFO cells during resize

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Clean up fifo locking with guard

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: fifo: Use guard() for locking

Kuniyuki Iwashima <kuniyu@google.com>
    sockmap: Fix use-after-free in udp_bpf_recvmsg()

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Replace waitqueue and flag with completion

Baoli.Zhang <baoli.zhang@linux.intel.com>
    soundwire: fix bug in sdw_add_element_group_count found by syzkaller

Yang Erkun <yangerkun@huawei.com>
    nfs: use nfsi->rwsem to protect traversal of the file lock list

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1: fix writes_pending and barrier reference leaks on write failures

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid10: fix writes_pending leak on write request failures

John Garry <john.g.garry@oracle.com>
    md/raid10: Handle bio_split() errors

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid10: fix writes_pending and barrier reference leaks on discard failures

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    bpf: Guard conntrack opts error writes

Chen Cheng <chencheng@fnnas.com>
    md/raid5: avoid R5_Overlap races while breaking stripe batches

Florian Westphal <fw@strlen.de>
    netfilter: nft_compat: ebtables emulation must reject non-bridge targets

Eric Dumazet <edumazet@google.com>
    net: udp_tunnel: prevent double queueing in udp_tunnel_nic_device_sync

Eric Dumazet <edumazet@google.com>
    tipc: fix UAF in cleanup_bearer() due to premature dst_cache_destroy()

Xin Long <lucien.xin@gmail.com>
    sctp: add INIT verification after cookie unpacking

Xin Long <lucien.xin@gmail.com>
    sctp: fix addr_wq_timer race in sctp_free_addr_wq()

Haofeng Li <lihaofeng@kylinos.cn>
    ksmbd: reject undersized DACLs before parsing ACEs

Michael Bommarito <michael.bommarito@gmail.com>
    xen/pvcalls: bound backend response req_id before indexing rsp[]

Christian Brauner <brauner@kernel.org>
    fs: refuse O_TMPFILE creation with an unmapped fsuid or fsgid

David Howells <dhowells@redhat.com>
    afs: Fix reinitialisation of the inode, in particular ->lock_work

Feng Liu <feliu@nvidia.com>
    net/mlx5e: Fix publication race for priv->channel_stats[]

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_pedit: fix TOCTOU heap OOB write in tc offload

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: 6lowpan: avoid untracked enable work

Yuho Choi <dbgh9129@gmail.com>
    net/liquidio: drop cached VF pci_dev LUT

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/core: Avoid enabling BRS from the SVM reload path

Eric Dumazet <edumazet@google.com>
    ipv4: igmp: Fix potential memory leaks in igmp_mod_timer() and igmp_stop_timer()

Tamaki Yanagawa <ty@000ty.net>
    netfilter: nft_lookup: fix catchall element handling with inverted lookups

Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>
    netfilter: nft_fib: reject fib expression on the netdev egress hook

Deepanshu Kartikey <kartikey406@gmail.com>
    mm/hugetlb: fix hugetlb cgroup rsvd charge/uncharge mismatch

Matthew Wilcox (Oracle) <willy@infradead.org>
    fs: Remove NTFS classic

Florian Fuchs <fuchsfl@gmail.com>
    mtd: maps: vmu-flash: fix fault in unaligned fixup

Ian Bridges <icb@fastmail.org>
    ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec

Deepanshu Kartikey <kartikey406@gmail.com>
    ocfs2: validate i_refcount_loc when refcount flag is set

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: add extra consistency checks for chain allocator dinodes

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: add suballoc slot check in ocfs2_validate_inode_block()

Julian Sun <sunjunchao2870@gmail.com>
    ocfs2: correct l_next_free_rec in online check

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma-pcie: Reject devices without driver data

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    platform/x86: dell-laptop: fix missing cleanups in init error path

Lyndon Sanche <lsanche@lyndeno.ca>
    platform/x86: dell-smbios: Move request functions for reuse

Armin Wolf <W_Armin@gmx.de>
    ACPI: battery: Pass battery hook pointer to hook callbacks

Michael Bommarito <michael.bommarito@gmail.com>
    nvmet-auth: reject short AUTH_RECEIVE buffers

Damien Le Moal <dlemoal@kernel.org>
    nvmet: Introduce nvmet_req_transfer_len()

Mikulas Patocka <mpatocka@redhat.com>
    dm-ioctl: fix a possible overflow in list_version_get_info

Heinz Mauelshagen <heinzm@redhat.com>
    dm: avoid spaces before function arguments or in favour of tabs

Mikulas Patocka <mpatocka@redhat.com>
    dm ioctl: a small code cleanup in list_version_get_info

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: fix buffer overflow in FEC calculation

Martin Kaiser <martin@kaiser.cx>
    riscv: probes: save original sp in rethook trampoline

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    pmdomain: imx93-blk-ctrl: Extract PHY as shared domain for DSI/CSI

Peng Fan <peng.fan@nxp.com>
    pmdomain: imx: Fix i.MX8MP VC8000E power up sequence

Zhao Li <enderaoelyther@gmail.com>
    wifi: ieee80211: validate MLE common info length

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix buffer over-read in cca_cipher2protkey

Rosen Penev <rosenp@gmail.com>
    ata: sata_dwc_460ex: fix infinite loop in NCQ tag completion bit-scanning

Amir Goldstein <amir73il@gmail.com>
    ovl: check access to copy_file_range source with src mounter creds

Linmao Li <lilinmao@kylinos.cn>
    drm/vc4: Prevent shader BO mappings from becoming writable

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: Handle TC_ACT_REDIRECT from qdisc filter chains

George Guo <guodongtai@kylinos.cn>
    LoongArch: Fix address space mismatch in kexec command line lookup

Petr Wozniak <petr.wozniak@gmail.com>
    xfrm: fix stale skb->prev after async crypto steals a GSO segment

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Prevent user-triggered null deref on QP create

Maoyi Xie <maoyixie.tju@gmail.com>
    wifi: mac80211: defer link RX stats percpu free to RCU

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: cfg80211: add link_station_info structure to support MLO statistics

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: mac80211: refactor populating mesh related fields in sinfo

Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>
    wifi: cfg80211: convert pmsr_free_wk to wiphy_work to fix deadlock

Cen Zhang <zzzccc427@gmail.com>
    wifi: cfg80211: use wiphy work for socket owner autodisconnect

Mostafa Saleh <smostafa@google.com>
    firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()

Matt Bobrowski <mattbobrowski@google.com>
    bpf: Fix UAF in sock clone early bailouts

David Jeffery <djeffery@redhat.com>
    scsi: core: wake eh reliably when using scsi_schedule_eh

Guanghui Feng <guanghuifeng@linux.alibaba.com>
    iommu/amd: Wait for completion instead of returning early in iommu_completion_wait()

Weiming Shi <bestswngs@gmail.com>
    tipc: serialize udp bearer replicast list updates

Frank Sorenson <sorenson@redhat.com>
    cifs: fix cifsFileInfo leak on kmalloc failure in deferred close drain paths

Frank Sorenson <sorenson@redhat.com>
    cifs: prevent readdir from changing file size due to stale directory metadata

Gregor Herburger <gregor.herburger@linutronix.de>
    drm/vc4: hvs/v3d: Fix null dereference in unbind

Gal Pressman <gal@nvidia.com>
    net/mlx5: Fix MCIA register buffer overflow on 32 dword reads

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/amdgpu: Fix context pstate override handling

James Zhu <James.Zhu@amd.com>
    drm/amdgpu: keep amdgpu_ctx_mgr in ctx structure

David Francis <David.Francis@amd.com>
    drm/amdkfd: Check bounds on CRIU restore queue type and mqd size

Jani Nikula <jani.nikula@intel.com>
    drm/i915/bios: range check LFP Data Block panel_type2

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915/gt: Fix NULL deref on sched_engine alloc failure

Jani Nikula <jani.nikula@intel.com>
    drm/i915/mst: limit DP MST ESI service loop

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: Release VFCT ACPI table reference

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Add wrapper for freeing vbios memory

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Use dbg level for VBIOS check messages

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/amdgpu: Fix errors & warnings in amdgpu _bios, _cs, _dma_buf, _fence.c

Linmao Li <lilinmao@kylinos.cn>
    drm/vc4: Shut down BO cache timer before teardown

Guangshuo Li <lgs201920130244@gmail.com>
    media: vivid: fix cleanup bugs in vivid_init()

Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
    tcp: challenge ACK for non-exact RST in SYN-RECEIVED

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu: fix aperture mapping leak

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: bound DACL dedup walk to copied ACEs

Davide Ornaghi <d.ornaghi97@gmail.com>
    ksmbd: fix path resolution in ksmbd_vfs_kern_path_create

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Put vmcs12 pages if nested VM-Enter fails due to invalid guest state

Taeyang Lee <0wn@theori.io>
    perf/core: Detach event groups during remove_on_exec

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: hda/cs35l41: Fix firmware load work teardown

Myeonghun Pak <mhun512@gmail.com>
    usb: typec: tcpci_rt1711h: unregister TCPCI port with devres

Breno Leitao <leitao@debian.org>
    netpoll: fix a use-after-free on shutdown path

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent path traversal bypass by restricting caseless retry

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use opener credentials for delete-on-close

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use opener credentials for ADS I/O

Haofeng Li <lihaofeng@kylinos.cn>
    ksmbd: validate NTLMv2 response before updating session key

Ralph Boehme <slow@samba.org>
    smb/client: fix chown/chgrp with SMB3 POSIX Extensions

Dawei Feng <dawei.feng@seu.edu.cn>
    usb: free iso schedules on failed submit

Xu Rao <raoxu@uniontech.com>
    usb: gadget: f_printer: take kref only for successful open

Andrzej Pietrasiewicz <andrzej.p@collabora.com>
    usb: gadget: function: Simplify diagnostic messaging in printer

Johan Hovold <johan@kernel.org>
    USB: iowarrior: fix use-after-free on disconnect race

Bryam Vargas <hexlabsecurity@proton.me>
    nvmet: fix pre-auth out-of-bounds heap read in Discovery Get Log Page

Tianchu Chen <flynnnchen@tencent.com>
    nvmet-auth: validate reply message payload bounds against transfer length

Hannes Reinecke <hare@kernel.org>
    nvmet: return DHCHAP status codes from nvmet_setup_auth()

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - protect service table iterations with service_lock

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Add lock protection to lm90_alert

Martin Kaiser <martin@kaiser.cx>
    test_kprobes: clear kprobes between test runs

Jia Zhu <zhujia.zj@bytedance.com>
    erofs: fix metabuf leak in inode xattr initialization

Jiajia Liu <liujiajia@kylinos.cn>
    Bluetooth: btmtk: fix urb->setup_packet leak in error paths

Junyi Liu <moss80199@gmail.com>
    ksmbd: validate SID in parent security descriptor during ACL inheritance

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: move to two-stage removal scheme

Florian Westphal <fw@strlen.de>
    netfilter: bridge: eb_tables: close module init race

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Stop work before releasing hwmon device

Xingwang Xiang <v3rdant.xiang@gmail.com>
    bpf, skmsg: fix verdict sk_data_ready racing with ktls rx

Keith Busch <kbusch@kernel.org>
    blk-mq: pop cached request if it is usable

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_tables: fix dst corruption in same register operation

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Extend nft_expr_ops::dump callback parameters

Heitor Alves de Siqueira <halves@igalia.com>
    Bluetooth: hci_sync: Set HCI_CMD_DRAIN_WORKQUEUE during device close

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: tcpm: validate VDO count in Discover Identity ACK handlers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: tcpm: bound altmode_desc[] per iteration in svdm_consume_modes()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: tcpm/tcpci_maxim: validate header NDO against RX_BYTE_CNT

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Ignore Port I/O requests of length '0'

SeungJu Cheon <suunj1331@gmail.com>
    Bluetooth: ISO: Fix data-race on iso_pi fields in hci_get_route calls

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v2.0 enc/dec rings

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v2.5 enc/dec rings

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v3.0 enc/dec rings

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v4.0 enc ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v2.0 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v2.5 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v3.0 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0 ring

Ian Bridges <icb@fastmail.org>
    fbdev: fix use-after-free in store_modes()

Konstantin Khorenko <khorenko@virtuozzo.com>
    gcov: use atomic counter updates to fix concurrent access crashes

Hongling Zeng <zenghongling@kylinos.cn>
    fbdev: omap2: fix use-after-free in omapfb_mmap

Hongling Zeng <zenghongling@kylinos.cn>
    fbdev: omap2: fix inconsistent lock returns in omapfb_mmap

Anna Maniscalco <anna.maniscalco2000@gmail.com>
    drm/msm: always recover the gpu

Alysa Liu <Alysa.Liu@amd.com>
    drm/amdkfd: Add upper bound check for num_of_nodes

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix fsck inconsistency caused by incorrect nat_entry flag usage

Sean Christopherson <seanjc@google.com>
    KVM: Don't WARN if memory is dirtied without a vCPU when the VM is dying

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Fix out-of-bounds read in dp_get_eq_aux_rd_interval()

Rory Little <rory@candelatech.com>
    wifi: mt76: mt7921: Place upper limit on station AID

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Avoid NULL dereference in dc_dmub_srv error paths

Stylon Wang <stylon.wang@amd.com>
    drm/amd/display: Add interface to enable DPIA trace

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    net: mana: Guard mana_remove against double invocation

Morduan Zang <zhangdandan@uniontech.com>
    net: phonet: do not BUG_ON() in pn_socket_autobind() on failed bind

Qu Wenruo <wqu@suse.com>
    btrfs: only release the dirty pages io tree after successful writes

Gao Xiang <xiang@kernel.org>
    erofs: fix use-after-free on sbi->sync_decompress

Jiayuan Chen <jiayuan.chen@linux.dev>
    netfilter: nft_ct: bail out on template ct in get eval

Lee Jones <lee@kernel.org>
    l2tp: pppol2tp: hold reference to session in pppol2tp_ioctl()

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: fix leak if split 6 GHz scanning fails

Yun Zhou <yun.zhou@windriver.com>
    gpio: mvebu: fix NULL pointer dereference in suspend/resume

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    gpio: mvebu: Use IS_REACHABLE instead of IS_ENABLED for CONFIG_PWM

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: phy: clean the sfp upstream if phy probing fails

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5: Fix slab-out-of-bounds in mlx5_query_nic_vport_mac_list

Shay Drory <shayd@nvidia.com>
    net/mlx5: Add generic getters for other functions caps

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: xsk: Fix DMA and xdp_frame leak on XDP_TX xmit failure

Xin Long <lucien.xin@gmail.com>
    sctp: validate embedded INIT chunk and address list lengths in cookie

HyungJung Joo <jhj140711@gmail.com>
    fs/mbcache: cancel shrink work before destroying the cache

Filipe Manana <fdmanana@suse.com>
    btrfs: fix deadlock between reflink and transaction commit when using flushoncommit

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/64s: Fix unmap race with PMD migration entries

Zilin Guan <zilin@seu.edu.cn>
    wifi: mt76: Fix memory leak after mt76_connac_mcu_alloc_sta_req()

Sechang Lim <rhkrqnwk98@gmail.com>
    bpf: Fix RCU stall in bpf_fd_array_map_clear()

Lang Xu <xulang@uniontech.com>
    bpf: Fix OOB in pcpu_init_value

Xin Long <lucien.xin@gmail.com>
    sctp: disable BH before calling udp_tunnel_xmit_skb()

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Fix clone_alias() to use the original device's devid

Deepanshu Kartikey <kartikey406@gmail.com>
    fs/ntfs3: fix missing run load for vcn0 in attr_data_get_block_locked()

Damien Riégel <damien.riegel@silabs.com>
    greybus: raw: fix use-after-free on cdev close

Jianan Huang <huangjianan@xiaomi.com>
    f2fs: avoid reading already updated pages during GC

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix data loss caused by incorrect use of nat_entry flag

Gao Xiang <xiang@kernel.org>
    erofs: unify lcn as u64 for 32-bit platforms

Michal Schmidt <mschmidt@redhat.com>
    ice: fix double-free of tx_buf skb

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nat: use kfree_rcu to release ops

Edward Adam Davis <eadavis@qq.com>
    sched/psi: fix race between file release and pressure write

Amir Goldstein <amir73il@gmail.com>
    fsnotify: fix inode reference leak in fsnotify_recalc_mask()

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: fix BUG_ON in __ceph_build_xattrs_blob() due to stale blob size

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix potential out-of-bounds access in __ceph_x_decrypt()

Weiming Shi <bestswngs@gmail.com>
    tap: fix stack info leak in tap_ioctl() SIOCGIFHWADDR

Haixin Xu <jerryxucs@gmail.com>
    crypto: jitterentropy - replace long-held spinlock with mutex

Stephan Müller <smueller@chronox.de>
    crypto: jitter - replace LFSR with SHA3-256

D. Wythe <alibuda@linux.alibaba.com>
    Revert "net/smc: Introduce TCP ULP support"

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: use list_del_rcu for netlink hooks

Janne Grunau <j@jannau.net>
    media: videobuf2: Set vma_flags in vb2_dma_sg_mmap

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: allow multiple opens of /sys/fs/selinux/policy

Helge Deller <deller@kernel.org>
    AppArmor: Allow apparmor to handle unaligned dfa tables

Johan Hovold <johan@kernel.org>
    spi: mpc52xx: fix use-after-free on registration failure

Amir Shetaia <Amir.Shetaia@amd.com>
    drm/amdkfd: Clear VRAM on allocation to prevent stale data exposure

Johan Hovold <johan@kernel.org>
    spi: fsl: fix controller deregistration

Yang Yingliang <yangyingliang@huawei.com>
    spi: fsl-spi: switch to use modern name

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: fsl-spi: Convert to platform remove callback returning void

Johan Hovold <johan@kernel.org>
    spi: rspi: fix controller deregistration

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: rspi: Convert to platform remove callback returning void

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu/vcn4: Prevent OOB reads when parsing IB

David Rosca <david.rosca@amd.com>
    drm/amdgpu/vcn4: Fix IB parsing with multiple engine info packages

David (Ming Qiang) Wu <David.Wu3@amd.com>
    drm/amdgpu: limit AV1 to the first instance on VCN4 encode

Johan Hovold <johan@kernel.org>
    spi: mpc52xx: fix controller deregistration

Yang Yingliang <yangyingliang@huawei.com>
    spi: mpc52xx: switch to use modern name

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: mpc52xx: Convert to platform remove callback returning void

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx4: Fix mis-use of RCU in mlx4_srq_event()

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix data race at accessing runtime.oss.trigger

Conor Dooley <conor.dooley@microchip.com>
    spi: microchip-core-qspi: control built-in cs manually

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Avoid clearing VMCB_LBR in vmcb12

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Always use NextRIP as vmcb02's NextRIP after first L2 VMRUN

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Triple fault if restore host CR3 fails on nested #VMEXIT

David Howells <dhowells@redhat.com>
    rxrpc: Fix memory leaks in rxkad_verify_response()

David Howells <dhowells@redhat.com>
    rxrpc: Fix conn-level packet handling to unshare RESPONSE packets

Zhang Yi <yi.zhang@huawei.com>
    ext4: don't set EXT4_GET_BLOCKS_CONVERT when splitting before submitting I/O

Deepanshu Kartikey <kartikey406@gmail.com>
    gfs2: fix memory leaks in gfs2_fill_super error path

Yao Kai <yaokai34@huawei.com>
    rcu: Fix rcu_read_unlock() deadloop due to softirq

Lianjie Wang <karin0.zst@gmail.com>
    hwrng: core - use RCU and work_struct to fix race condition

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Clear Present bit before tearing down context entry

Yongjian Sun <sunyongjian1@huawei.com>
    ext4: fix e4b bitmap inconsistency reports

Matthew Wilcox (Oracle) <willy@infradead.org>
    ext4: convert bd_buddy_page to bd_buddy_folio

Matthew Wilcox (Oracle) <willy@infradead.org>
    ext4: convert bd_bitmap_page to bd_bitmap_folio

Gou Hao <gouhao@uniontech.com>
    ext4: delete redundant calculations in ext4_mb_get_buddy_page_lock()

Theodore Ts'o <tytso@mit.edu>
    ext4: convert some BUG_ON's in mballoc to use WARN_RATELIMITED instead

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: remove unnecessary e4b->bd_buddy_page check in ext4_mb_load_buddy_gfp

Jie Zhang <jzhang918@gmail.com>
    net: stmmac: fix oops when split header is enabled

Boris Burkov <boris@bur.io>
    btrfs: fix EEXIST abort due to non-consecutive gaps in chunk allocation

Julian Anastasov <ja@ssi.bg>
    ipvs: do not keep dest_dst if dev is going down

Zhang Yi <yi.zhang@huawei.com>
    ext4: drop extent cache when splitting extent fails

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Clear Present bit before tearing down PASID entry

Helge Deller <deller@kernel.org>
    apparmor: Fix & Optimize table creation from possibly unaligned memory

Ryan Lin <ryan.lin@intel.com>
    HID: intel-ish-hid: fix NULL-ptr-deref in ishtp_bus_remove_all_clients

Even Xu <even.xu@intel.com>
    HID: Intel-ish-hid: Ishtp: Fix sensor reads after ACPI S3 suspend

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: avoid Non-NCQ command starvation

Shota Zaizen <s@zaizen.me>
    ksmbd: validate inherited ACE SID length

Jiayuan Chen <jiayuan.chen@shopee.com>
    bonding: fix type confusion in bond_setup_by_slave()

Chen Ni <nichen@iscas.ac.cn>
    ASoC: amd: acp-mach-common: Add missing error check for clock acquisition

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: amd: acp: Refactor i2s clocks programming sequence

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: amd: acp: Refactor dai format implementation

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: amd: acp: Add setbias level for rt5682s codec in machine driver

Max Kellermann <max.kellermann@ionos.com>
    ceph: fix memory leaks in ceph_mdsc_build_path()

Vladimir Riabchun <ferr.lambarginio@gmail.com>
    scsi: qla2xxx: Completely fix fcport double free

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Fix race in DMA ring dequeue

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Correct RING_CTRL_ABORT handling in DMA dequeue

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Fix die ID init and look up bugs

Filipe Manana <fdmanana@suse.com>
    btrfs: reserve enough transaction items for qgroup ioctls

Ming Qian <ming.qian@oss.nxp.com>
    media: verisilicon: Avoid G2 bus error while decoding H.264 and HEVC

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: v4l2-mem2mem: Add a kref to the v4l2_m2m_dev structure

Sebastian Reichel <sebastian.reichel@collabora.com>
    media: hantro: Disable multicore support

Filipe Manana <fdmanana@suse.com>
    btrfs: don't BUG() on unexpected delayed ref type in run_one_delayed_ref()

Qu Wenruo <wqu@suse.com>
    btrfs: do not ASSERT() when the fs flips RO inside btrfs_repair_io_failure()

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    md-cluster: fix NULL pointer dereference in process_metadata_update

Magnus Lindholm <linmag7@gmail.com>
    alpha: fix user-space corruption during memory compaction

Arnd Bergmann <arnd@arndb.de>
    arch: turn off -Werror for architectures with known warnings

Ankit Soni <Ankit.Soni@amd.com>
    iommu/amd: move wait_on_sem() out of spinlock

Mario Peter <mario.peter@leica-geosystems.com>
    usb: chipidea: udc: fix DMA and SG cleanup in _ep_nuke()

Stefano Stabellini <stefano.stabellini@amd.com>
    9p/xen: protect xen_9pfs_front_free against concurrent calls

Eugenio Pérez <eperezma@redhat.com>
    vhost: move vdpa group bound check to vhost_vdpa

Jiayuan Chen <jiayuan.chen@shopee.com>
    kcm: fix zero-frag skb in frag_list on partial sendmsg error

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: prevent races in ->query_interfaces()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    team: avoid NETDEV_CHANGEMTU event when unregistering slave

Shyam Prasad N <sprasad@microsoft.com>
    cifs: Fix locking usage for tcon fields

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: validate sequence number of TX release report

Cédric Bellegarde <cedric.bellegarde@adishatz.org>
    ASoC: qcom: q6asm: drop DSP responses for closed data streams

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6asm: handle the responses after closing

Nicholas Carlini <nicholas@carlini.com>
    ksmbd: fix signededness bug in smb_direct_prepare_negotiation()

Prashanth K <prashanth.k@oss.qualcomm.com>
    usb: dwc3: gadget: Move vbus draw to workqueue context

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    xfrm: always flush state and policy upon NETDEV_UNREGISTER event

Christoph Hellwig <hch@lst.de>
    xfs: remove xfs_attr_leaf_hasname

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    ima: verify the previous kernel's IMA buffer lies in addressable RAM

Takashi Iwai <tiwai@suse.de>
    ALSA: mixer: oss: Add card disconnect checkpoints

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: hci_sync: annotate data-races around hdev->req_status

Filipe Manana <fdmanana@suse.com>
    btrfs: fix zero size inode with non-zero size after log replay

Keenan Dong <keenanat2000@gmail.com>
    xfrm: account XFRMA_IF_ID in aevent size calculation

Eric Dumazet <edumazet@google.com>
    ipv6: ioam: fix potential NULL dereferences in __ioam6_fill_trace_data()

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Wait for RCU readers during policy netns exit

Justin Iurman <justin.iurman@gmail.com>
    net: ioam6: fix OOB and missing lock

Lee Jones <lee@kernel.org>
    HID: logitech-hidpp: Prevent use-after-free on force feedback initialisation failure

Lee Jones <lee@kernel.org>
    HID: core: Mitigate potential OOB by removing bogus memset()

Li Chen <chenl311@chinatelecom.cn>
    HID: rate-limit hid_warn to prevent log flooding

Tatsuya S <tatsuya.s2862@gmail.com>
    HID: core: Add reserved item tag for main items

Sabrina Dubroca <sd@queasysnail.net>
    mpls: add seqcount to protect the platform_label{,s} pair

Guoyu Su <yss2813483011xxl@gmail.com>
    net: use skb_header_pointer() for TCPv4 GSO frag_off check

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: hci_cmd_sync_queue_once() return -EEXIST if exists

Kuniyuki Iwashima <kuniyu@google.com>
    bpf: sockmap: Fix use-after-free of sk->sk_socket in sk_psock_verdict_data_ready().

Varun R Mallya <varunrmallya@gmail.com>
    bpf: Reject sleepable kprobe_multi programs at attach time

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix incorrect pruning due to atomic fetch precision tracking

Oleh Konko <security@1seal.org>
    Bluetooth: hci_event: move wake reason storage into validated event handlers

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/dsi: Don't do DSC horizontal timing adjustments in command mode

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_ecm: Fix net_device lifecycle with device_move

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_eem: Fix net_device lifecycle with device_move

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_subset: Fix net_device lifecycle with device_move

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_rndis: Fix net_device lifecycle with device_move

Michael Bommarito <michael.bommarito@gmail.com>
    ksmbd: validate response sizes in ipc_validate_msg()

Michael Bommarito <michael.bommarito@gmail.com>
    ksmbd: validate num_aces and harden ACE walk in smb_inherit_dacl()

Douya Le <ldy3087146292@gmail.com>
    crypto: af_alg - limit RX SG extraction by receive buffer budget

Yucheng Lu <kanolyc@gmail.com>
    net/sched: sch_netem: fix out-of-bounds access in packet corruption

Qi Tang <tpluszz77@gmail.com>
    xfrm: hold dev ref until after transport_finish NF_HOOK

Jacky Bai <ping.bai@nxp.com>
    pmdomain: imx8mp-blk-ctrl: Keep the NOC_HDCP clock enabled

Michael Zimmermann <sigmaepsilon92@gmail.com>
    usb: gadget: f_hid: don't call cdev_init while cdev in use

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Protect *all* of sev_mem_enc_register_region() with kvm->lock

Ge Yang <yangge1116@126.com>
    KVM: SEV: Use long-term pin when registering encrypted memory regions

Janosch Frank <frankja@linux.ibm.com>
    s390/mm: Add missing secure storage access fixups for donated memory

Vladimir Yakovlev <vovchkir@gmail.com>
    spi: spi-dw-dma: fix print error log when wait finish transaction

Chaitanya Kulkarni <kch@nvidia.com>
    nvmet: move async event work off nvmet-wq

Kohei Enju <kohei@enjuk.jp>
    iavf: fix out-of-bounds writes in iavf_get_ethtool_stats()

Jiayuan Chen <jiayuan.chen@shopee.com>
    team: fix header_ops type confusion with non-Ethernet ports

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/core) Protect regulator operations with mutex

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdgpu: prevent immediate PASID reuse case

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/amdgpu: Remove usage of the deprecated ida_simple_xx() API

Asim Viladi Oglu Manizada <manizada@pm.me>
    ksmbd: fix OOB write in QUERY_INFO for compound requests

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use volume UUID in FS_OBJECT_ID_INFORMATION

Jiayuan Chen <jiayuan.chen@shopee.com>
    serial: core: fix infinite loop in handle_tx() for PORT_UNKNOWN

Filipe Manana <fdmanana@suse.com>
    btrfs: log new dentries when logging parent dir of a conflicting inode

Allison Henderson <achender@kernel.org>
    net/rds: Fix circular locking dependency in rds_tcp_tune

Fuad Tabba <tabba@google.com>
    bpf, arm64: Force 8-byte alignment for JIT buffer to prevent atomic tearing

Chaitanya Kulkarni <kch@nvidia.com>
    blktrace: fix __this_cpu_read/write in preemptible context

Juri Lelli <juri.lelli@redhat.com>
    sched/deadline: Fix missing ENQUEUE_REPLENISH during PI de-boosting

Niklas Cassel <cassel@kernel.org>
    PCI: dwc: ep: Flush MSI-X write before unmapping its ATU entry

Jakub Kicinski <kuba@kernel.org>
    nfc: nci: complete pending data exchange on device close

Davidlohr Bueso <dave@stgolabs.net>
    cxl/mbox: validate payload size before accessing contents in cxl_payload_from_user_allowed()

Eric Dumazet <edumazet@google.com>
    tcp: secure_seq: add back ports to TS offset

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add chann_lock to protect ksmbd_chann_list xarray

Qu Wenruo <wqu@suse.com>
    btrfs: reject new transactions if the fs is fully read-only

Perry Yuan <perry.yuan@amd.com>
    drm/amd/pm: Disable MMIO access during SMU Mode 1 reset

Edward Adam Davis <eadavis@qq.com>
    ALSA: usb-audio: Prevent excessive number of frames

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Protect curr_xfer check in IRQ handler

Nikolay Aleksandrov <razor@blackwall.org>
    bonding: fix use-after-free due to enslave fail after slave array update

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add recursion protection in kernel stack trace recording

Zilin Guan <zilin@seu.edu.cn>
    of: unittest: Fix memory leak in unittest_data_add()

David Howells <dhowells@redhat.com>
    rxrpc: Fix data-race warning and potential load/store tearing

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS: Fix a deadlock when returning a delegation during open()

Eric Dumazet <edumazet@google.com>
    dst: fix races in rt6_uncached_list_del() and rt_del_uncached_list()

Jie Zhang <jie.zhang@oss.qualcomm.com>
    drm/msm: Recover HW before retire hung submit

Cong Nguyen <congnt264@gmail.com>
    staging: rtl8723bs: fix xmit_frame/xmit_buf leaks on mgnt-frame error paths

Haotian Zhang <vulab@iscas.ac.cn>
    PCI: endpoint: Add missing NULL check for alloc_workqueue()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: handle attr_set_size() errors when truncating files

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: Drop the MHI auto_queue feature for IPCR DL channels

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Use devm_kmemdup() in rtw_set_supported_band()

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw88: debugfs: support multiple adapters debugging

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't WARN for connections on invalid channels

Francesco Lavra <flavra@baylibre.com>
    iio: imu: st_lsm6dsx: fix iio_chan_spec for sensors without event detection

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: imu: st_lsm6dsx: fix LSM6DSV sensor description

Loic Poulain <loic.poulain@oss.qualcomm.com>
    phy: qcom-qusb2: Fix NULL pointer dereference on early suspend

Miquel Sabaté Solà <mssola@mssola.com>
    btrfs: fix NULL dereference on root when tracing inode eviction

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: properly keep track of conduit reference

Nikolay Kuratov <kniv@yandex-team.ru>
    drm/msm/dpu: Add missing NULL pointer check for pingpong interface

Gregory CLEMENT <gregory.clement@bootlin.com>
    MIPS: ftrace: Fix memory corruption when kernel is located beyond 32 bits

Al Viro <viro@zeniv.linux.org.uk>
    functionfs: fix the open/removal races

Al Viro <viro@zeniv.linux.org.uk>
    functionfs, gadgetfs: use simple_recursive_removal()

Paul Cercueil <paul@crapouillou.net>
    usb: gadget: functionfs: Factorize wait-for-endpoint code

Paul Cercueil <paul@crapouillou.net>
    usb: gadget: Support already-mapped DMA SGs

Linyu Yuan <quic_linyyuan@quicinc.com>
    usb: gadget: ffs: remove ENTER() macro

Minseong Kim <ii4gsp@gmail.com>
    Input: lkkbd - disable pending work before freeing device

Joshua Rogers <linux@joshua.hu>
    svcrdma: bound check rq_pages index in inline path

Duoming Zhou <duoming@zju.edu.cn>
    Input: alps - fix use-after-free bugs caused by dev3_register_work

Qianchang Zhao <pioooooooooip@gmail.com>
    ksmbd: vfs: fix race on m_flags in vfs_cache

Johan Hovold <johan@kernel.org>
    staging: most: remove broken i2c driver

Tony Battersby <tonyb@cybernetics.com>
    scsi: qla2xxx: Clear cmds after chip reset

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix null deref on srq->rq.queue after resize failure

Arnaud Lecomte <contact@arnaud-lcm.com>
    bpf: Fix stackmap overflow check in __bpf_get_stackid()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_receive_bulk_callback(): check actual_length before accessing data

Duoming Zhou <duoming@zju.edu.cn>
    scsi: imm: Fix use-after-free bug caused by unfinished delayed work

Horatiu Vultur <horatiu.vultur@microchip.com>
    lan966x: Fix sleeping in atomic context

Nitin Rawat <nitin.rawat@oss.qualcomm.com>
    scsi: ufs: ufs-qcom: Fix UFS OCP issue during UFS power down (PC=3)

Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
    cifs: fix memory leak in smb3_fs_context_parse_param error path

Akiva Goldberger <agoldberger@nvidia.com>
    mlx5: Fix default values in create CQ

Eric Dumazet <edumazet@google.com>
    tcp: use dst_dev_rcu() in tcp_fastopen_active_disable_ofo_check()

Coiby Xu <coxu@redhat.com>
    ima: don't clear IMA_DIGSIG flag when setting or removing non-IMA xattr

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Do not share the name pointer between components

Oleksij Rempel <linux@rempel-privat.de>
    net: stmmac: Correctly handle Rx checksum offload errors

Romain Gantois <romain.gantois@bootlin.com>
    net: stmmac: Prevent DSA tags from breaking COE

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix potential UAF in smb2_close_cached_fid()

Xiao Ni <xni@redhat.com>
    md/raid10: wait barrier before returning discard request with REQ_NOWAIT

Moti Haimovski <moti.haimovski@intel.com>
    accel/habanalabs: support mapping cb with vmalloc-backed coherent memory

Christian König <christian.koenig@amd.com>
    drm/amdgpu: hide VRAM sysfs attributes on GPUs without VRAM

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Show vram vendor only if available

Edward Adam Davis <eadavis@qq.com>
    cifs: client: fix memory leak in smb3_fs_context_parse_param

Harini T <harini.t@amd.com>
    mailbox: zynqmp-ipi: Fix out-of-bounds access in mailbox cleanup loop

Ben Levinsky <ben.levinsky@amd.com>
    mailbox: zynqmp: Move buffered IPI setup to of_match selected routine

Ben Levinsky <ben.levinsky@amd.com>
    mailbox: zynqmp: Move of_match structure closer to usage

Randy Dunlap <rdunlap@infradead.org>
    mailbox: zynqmp-ipi: fix an Excess struct member kernel-doc warning

Rob Herring <robh@kernel.org>
    mailbox: Explicitly include correct DT includes

Rob Herring <robh@kernel.org>
    of: Move of_device_get_match_data() declaration

Rob Herring <robh@kernel.org>
    of: Move of_device_(add|register|unregister) to of_platform.h

Eric Dumazet <edumazet@google.com>
    net: use dst_dev_rcu() in sk_setup_caps()

Jason Andryuk <jason.andryuk@amd.com>
    xen/events: Return -EEXIST for bound VIRQs

Juergen Gross <jgross@suse.com>
    xen/events: modify internal [un]bind interfaces

Juergen Gross <jgross@suse.com>
    xen/events: drop xen_allocate_irqs_dynamic()

Juergen Gross <jgross@suse.com>
    xen/events: remove some simple helpers from events_base.c

Juergen Gross <jgross@suse.com>
    xen/events: reduce externally visible helper functions

Juergen Gross <jgross@suse.com>
    xen/events: avoid using info_for_irq() in xen_send_IPI_one()

Eric Dumazet <edumazet@google.com>
    ipv6: use RCU in ip6_output()

Chao Yu <chao@kernel.org>
    f2fs: fix to truncate first page in error path of f2fs_truncate()

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - request reserved interrupt for virtual function

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid overflow while left shift operation

Matthew Wilcox (Oracle) <willy@infradead.org>
    f2fs: Use a folio in f2fs_truncate_partial_cluster()

Eric Dumazet <edumazet@google.com>
    tcp_metrics: use dst_dev_net_rcu()

Seppo Takalo <seppo.takalo@nordicsemi.no>
    tty: n_gsm: Don't block input queue by waiting MSC

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: add parameters used with parameter negotiation

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: introduce macro for minimal unit size

Fangyu Yu <fangyu.yu@linux.alibaba.com>
    RISC-V: KVM: Write hgatp register with valid mode bits

I Viswanath <viswanathiyyappan@gmail.com>
    ptp: Add a upper bound on max_vclocks

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i915: Move list_count() to list.h as list_count_nodes() for broader use

Duoming Zhou <duoming@zju.edu.cn>
    net: mscc: ocelot: Fix use-after-free caused by cyclic delayed work

Shuai Xue <xueshuai@linux.alibaba.com>
    x86/mce: use is_copy_from_user() to determine copy-from-user context

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix possible UAFs

Ajay.Kathat@microchip.com <Ajay.Kathat@microchip.com>
    wifi: wilc1000: avoid buffer overflow in WID string configuration

Stefan Metzmacher <metze@samba.org>
    smb: client: let recv_done verify data_offset, data_length and remaining_data_length

Stefan Metzmacher <metze@samba.org>
    smb: client: let smbd_destroy() call disable_work_sync(&info->post_send_credits_work)

Uladzislau Rezki (Sony) <urezki@gmail.com>
    mm/vmalloc, mm/kasan: respect gfp mask in kasan_populate_vmalloc()

Duoming Zhou <duoming@zju.edu.cn>
    ptp: ocp: fix use-after-free bugs causing by ptp_ocp_watchdog

Ido Schimmel <idosch@nvidia.com>
    vxlan: Fix NPD when refreshing an FDB entry with a nexthop object

Ido Schimmel <idosch@nvidia.com>
    vxlan: Fix NPD in {arp,neigh}_reduce() when using nexthop objects

Ye Weihua <yeweihua4@huawei.com>
    trace/fgraph: Fix the warning caused by missing unregister notifier

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    bnxt_en: Fix memory corruption when FW resources change during ifdown

Aakash Kumar S <saakashkumar@marvell.com>
    xfrm: Duplicate SPI Handling

Kanglong Wang <wangkanglong@loongson.cn>
    LoongArch: Optimize module load time by optimizing PLT/GOT counting

Jinjiang Tu <tujinjiang@huawei.com>
    mm/smaps: fix race between smaps_hugetlb_range and migration

Joel Fernandes <joelagnelf@nvidia.com>
    rcu: Fix rcu_read_unlock() deadloop due to IRQ work

Halil Pasic <pasic@linux.ibm.com>
    s390/ism: fix concurrency management in ism_cmd()

Stefan Raspl <raspl@linux.ibm.com>
    s390/ism: Introduce struct ism_dmb

Ziyan Xu <ziyan@securitygossip.com>
    ksmbd: fix refcount leak causing resource not released

Siyang Liu <Security@tencent.com>
    drm/amd/display: fix a Null pointer dereference vulnerability

William Liu <will@willsroot.io>
    net/sched: Fix backlog accounting in qdisc_dequeue_internal

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix UAF on smcsk after smc_listen_out()

Al Viro <viro@zeniv.linux.org.uk>
    habanalabs: fix UAF in export_dmabuf()

Tomer Tayar <ttayar@habana.ai>
    habanalabs: fix dma-buf release handling if dma_buf_fd() fails

Ohad Sharabi <osharabi@habana.ai>
    habanalabs: helper function to validate export params

Ohad Sharabi <osharabi@habana.ai>
    habanalabs: remove support to export dmabuf from handle

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: fix general protection fault in hfs_find_init()

Matthew Wilcox (Oracle) <willy@infradead.org>
    highmem: add memcpy_to_folio() and memcpy_from_folio()

Vishal Moola (Oracle) <vishal.moola@gmail.com>
    pagemap: add filemap_grab_folio()

Jan Kara <jack@suse.cz>
    loop: Avoid updating block size under exclusive owner

Umio Yasuno <coelacanth_dream@protonmail.com>
    drm/amd/pm: fix null pointer access

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: add cluster chain loop check for dir

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: remove unnecessary arguments from exfat_find_dir_entry()

Gabriele Monaco <gmonaco@redhat.com>
    rv: Use strings in da monitors tracepoints

Edward Adam Davis <eadavis@qq.com>
    fs/ntfs3: cancle set bad inode after removing name fails

Heiko Stuebner <heiko@sntech.de>
    drm/rockchip: vop2: fail cleanly if missing a primary plane for a video-port

Al Viro <viro@zeniv.linux.org.uk>
    xen: fix UAF in dmabuf_exp_from_pages()

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Remove skb secpath if xfrm state is not found

Leon Romanovsky <leon@kernel.org>
    net/mlx5e: Provide intermediate pointer to access IPsec struct

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix double destruction of rsv_qp

David Howells <dhowells@redhat.com>
    rxrpc: Fix bug due to prealloc collision

Maud Spierings <maudspierings@gocontroll.com>
    iio: common: st_sensors: Fix use of uninitialize device structs

Kaustabh Chakraborty <kauschluss@disroot.org>
    iio: st_sensors: relax WhoAmI check in st_sensors_verify_id()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: st_sensors: core and lsm9ds0 switch to devm_regulator_bulk_get_enable()

David Howells <dhowells@redhat.com>
    rxrpc: Fix recv-recv race of completed call

Daniel J. Ogorchock <djogorchock@gmail.com>
    HID: nintendo: avoid bluetooth suspend/resume stalls

Sumit Kumar <quic_sumk@quicinc.com>
    bus: mhi: ep: Update read pointer only after buffer is written

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Fix in_atomic() handling in do_secure_storage_access()

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: bugfix live migration function without VF device driver

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: do not enable EEE on bcm63xx

Ben Dooks <ben.dooks@codethink.co.uk>
    riscv: save the SR_SUM status over switches

Ido Schimmel <idosch@nvidia.com>
    bridge: mcast: Fix use-after-free during router port configuration

Yan Zhai <yan@cloudflare.com>
    bnxt: properly flush XDP redirect lists

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix potential deadlock when reconnecting channels

Harshit Agarwal <harshit@nutanix.com>
    sched/rt: Fix race in push_rt_task

Tianyang Zhang <zhangtianyang@loongson.cn>
    LoongArch: Fix panic caused by NULL-PMD in huge_pte_offset()

Ronnie Sahlberg <rsahlberg@whamcloud.com>
    ublk: santizize the arguments from userspace when adding a device

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: holding cscfg_csdev_lock while removing cscfg from csdev

Michal Kubiak <michal.kubiak@intel.com>
    ice: fix Tx scheduler error handling in XDP callback

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: don't warn when if there is a FW error

Luis de Arquer <luis.dearquer@inertim.com>
    spi-rockchip: Fix register out of bounds access

Christian Bruel <christian.bruel@foss.st.com>
    PCI: endpoint: pci-epf-test: Fix double free that causes kernel to oops

Michael S. Tsirkin <mst@redhat.com>
    virtio: break and reset virtio devices on device_shutdown()

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: fix debug actions order

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: dbg-tlv: fix DRAM data init

Roger Quadros <rogerq@kernel.org>
    dmaengine: ti: k3-udma-glue: Drop skip_fdq argument from k3_udma_glue_reset_rx_chn

Philippe Simons <simons.philippe@gmail.com>
    clk: sunxi-ng: h616: Reparent GPU clock during frequency changes

Andre Przywara <andre.przywara@arm.com>
    clk: sunxi-ng: h616: Reparent CPU clock during frequency changes

Alexander Gordeev <agordeev@linux.ibm.com>
    kasan: avoid sleepable page allocation from atomic context

Andrey Konovalov <andreyknvl@gmail.com>
    kasan: use unchecked __memset internally

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp: Don't access ifa_index when missing

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: Disable iocc if dma-coherent property isn't set

Mikhail Lobanov <m.lobanov@rosa.ru>
    KVM: SVM: Forcibly leave SMM mode on SHUTDOWN interception

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent rename with empty string

Sean Heelan <seanheelan@gmail.com>
    ksmbd: Fix UAF in __close_file_table_ids

Johannes Berg <johannes.berg@intel.com>
    um: fix time-travel syscall scheduling hack

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Synchronous access b/w reset and tm thread for reply queue

Edward Cree <ecree.xilinx@gmail.com>
    sfc: fix NULL dereferences in ef100_process_design_param()

Boris Burkov <boris@bur.io>
    btrfs: harden block_group::bg_list against list_del() races

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: debugfs hang_hws skip GPU with MES

Han Xu <han.xu@nxp.com>
    spi: fsl-qspi: use devm function instead of driver remove

Yonghong Song <yonghong.song@linux.dev>
    bpf: Fix kmemleak warning for percpu hashmap

Lizhi Xu <lizhi.xu@windriver.com>
    fs/ntfs3: Keep write operations atomic

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix UAF in decryption with multichannel

Frederic Weisbecker <frederic@kernel.org>
    perf: Fix hang while freeing sigtrap event

Chao Yu <chao@kernel.org>
    f2fs: fix potential deadloop in prepare_compress_overwrite()

Chao Yu <chao@kernel.org>
    f2fs: convert f2fs_handle_page_eio() to use folio

Boris Burkov <boris@bur.io>
    btrfs: fix block group refcount race in btrfs_create_pending_block_groups()

Murad Masimov <m.masimov@mt-integration.ru>
    ax25: Remove broken autobind

Christian Schoenebeck <linux_oss@crudebyte.com>
    fs/9p: fix NULL pointer dereference on mkdir

Antoine Tenart <atenart@kernel.org>
    net: decrease cached dst counters in dst_release

Dave Marquardt <davemarq@linux.ibm.com>
    net: ibmveth: make veth_pool_store stop hanging

Nick Child <nnac123@linux.ibm.com>
    ibmveth: Always stop tx queues during close

Hengqi Chen <hengqi.chen@gmail.com>
    LoongArch: BPF: Don't override subprog's return value

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix null pointer dereference in alloc_preauth_hash()

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp: unshare packets when reassembling

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix slab-use-after-free Read in l2cap_send_cmd

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in ksmbd_free_work_struct

Taehee Yoo <ap420073@gmail.com>
    eth: bnxt: fix truesize for mb-xdp-pass case

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent connection release during oplock break notification

Maurizio Lombardi <mlombard@redhat.com>
    nvme-tcp: fix potential memory corruption in nvme_tcp_recv_pdu()

Wei Fang <wei.fang@nxp.com>
    net: enetc: VFs do not support HWTSTAMP_TX_ONESTEP_SYNC

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Fix the recovery flow of the UMR QP

Shay Drory <shayd@nvidia.com>
    RDMA/mlx5: Implement mkeys management via LIFO queue

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/mlx5: Introduce mlx5r_cache_rb_key

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/mlx5: Change the cache structure to an RB-tree

Aharon Landau <aharonl@nvidia.com>
    RDMA/mlx5: Remove implicit ODP cache entry

Aharon Landau <aharonl@nvidia.com>
    RDMA/mlx5: Don't keep umrable 'page_shift' in cache entries

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Fix a WARN during dereg_mr for DM type

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Fix the page details for the srq created by kernel consumers

Peter Jones <pjones@redhat.com>
    efi: Don't map the entire mokvar table to determine its size

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Harden loops for looking up ALH copiers

Werner Sembach <wse@tuxedocomputers.com>
    PCI: Avoid putting some root ports into D3 on TUXEDO Sirius Gen1

Mario Limonciello <mario.limonciello@amd.com>
    x86/PCI: Avoid PME from D3hot/D3cold for AMD Rembrandt and Phoenix USB4

Kory Maincent <kory.maincent@bootlin.com>
    net: ravb: Fix missing rtnl lock in suspend/resume path

Jakub Kicinski <kuba@kernel.org>
    net: ipv6: fix dst ref loops in rpl, seg6 and ioam6 lwtunnels

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Fix a race for an ODP MR which leads to CQE with error

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: fix race between cancel_hw_scan and hw_scan completion

Guixin Liu <kanie@linux.alibaba.com>
    scsi: mpi3mr: Fix possible crash when setting up bsg fails

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix implicit ODP use after free

Ryan Roberts <ryan.roberts@arm.com>
    mm: clear uffd-wp PTE/PMD state on mremap()

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix double free of TCP_Server_Info::hostname

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    rds: sysctl: rds_tcp_{rcv,snd}buf: avoid using current->nsproxy

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: SOF: Intel: hda-dai: Ensure DAI widget is valid during params

Niklas Cassel <cassel@kernel.org>
    PCI: dwc: ep: Prevent changing BAR size/flags in pci_epc_set_bar()

Gaurav Batra <gbatra@linux.ibm.com>
    powerpc/pseries/iommu: IOMMU incorrectly marks MMIO range in DDW

Florian Westphal <fw@strlen.de>
    xfrm: state: fix out-of-bounds read during lookup

Qu Wenruo <wqu@suse.com>
    btrfs: do proper folio cleanup when cow_file_range() failed

Stefano Brivio <sbrivio@redhat.com>
    udp: Deal with race between UDP socket address change and rehash

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    workqueue: Do not warn when cancelling WQ_MEM_RECLAIM work from !WQ_MEM_RECLAIM worker

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Fix corrupt config pages PHY state is switched in sysfs

Yishai Hadas <yishaih@nvidia.com>
    vfio/mlx5: Fix an unwind issue in mlx5vf_add_migration_pages()

Paul Aurich <paul@darkrain42.org>
    smb: Initialize cfid->tcon before performing network ops

Jann Horn <jannh@google.com>
    udmabuf: fix memory leak on last export_udmabuf() error path

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on node blkaddr in truncate_node()

Wen Gu <guwen@linux.alibaba.com>
    net/smc: initialize close_work early to avoid warning

David Hildenbrand <david@redhat.com>
    mm/mempolicy: fix migrate_to_node() assuming there is at least one VMA in a MM

Hou Tao <houtao1@huawei.com>
    bpf: Call free_htab_elem() after htab_unlock_bucket()

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Create all dump files during debugfs initialization

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Allocate DFX memory during dump trigger

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Directly call register snapshot instead of using workqueue

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: hisi_sas: Add function complete_v3_hw()

Xingui Yang <yangxingui@huawei.com>
    scsi: hisi_sas: Add SATA_DISK_ERR bit handling for v3 hw

Xingui Yang <yangxingui@huawei.com>
    scsi: hisi_sas: Move slot variable definition in hisi_sas_abort_task()

Wander Lairson Costa <wander@redhat.com>
    sched/deadline: Fix warning in migrate_enable for boosted tasks

yuan.gao <yuan.gao@ucloud.cn>
    mm/slub: Avoid list corruption when removing a slab from the full list

Chao Yu <chao@kernel.org>
    f2fs: fix to drop all discards after creating snapshot on lvm device

Sean Anderson <sean.anderson@linux.dev>
    drm: zynqmp_kms: Unplug DRM device before removal

Phil Sutter <phil@nwl.cc>
    netfilter: IDLETIMER: Fix for possible ABBA deadlock

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Move events notifier registration to be after device registration

Yang Erkun <yangerkun@huawei.com>
    nfsd: release svc_expkey/svc_export with rcu_work

Raghavendra Rao Ananta <rananta@google.com>
    KVM: arm64: Get rid of userspace_irqchip_in_use

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: check for overflows in io_pin_pages

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix use-after-free of signing key

Paulo Alcantara <pc@manguebit.com>
    smb: client: stop flooding dmesg in smb2_calc_signature()

Paul Aurich <paul@darkrain42.org>
    smb: Don't leak cfid when reconnect races with open_cached_dir

Liu Jian <liujian56@huawei.com>
    sunrpc: fix one UAF issue caused by sunrpc kernel tcp socket

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix out-of-bounds access of directory entries

Peng Fan <peng.fan@nxp.com>
    pmdomain: imx93-blk-ctrl: correct remove path

Kuniyuki Iwashima <kuniyu@amazon.com>
    smb: client: Fix use-after-free of network namespace.

Showrya M N <showrya@chelsio.com>
    RDMA/siw: Add sendpage_ok() check to disable MSG_SPLICE_PAGES

Zijian Zhang <zijianzhang@bytedance.com>
    bpf: Add sk_is_inet and IS_ICSK check in tls_sw_has_ctx_tx/rx

David Howells <dhowells@redhat.com>
    afs: Fix lock recursion

Xinqi Zhang <quic_xinqzhan@quicinc.com>
    firmware: arm_scmi: Fix slab-use-after-free in scmi_bus_notifier()

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Refactor device create/destroy helpers

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Move handle get/set helpers

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Refactor protocol device creation

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Add common notifier helpers

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Move protocol registration helpers

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Use dedicated devices to initialize channels

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Simplify chan_available transport operation

Dan Carpenter <dan.carpenter@linaro.org>
    drm/msm/gem: prevent integer overflow in msm_ioctl_gem_submit()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: check outstanding simultaneous SMB operations

Dan Williams <dan.j.williams@intel.com>
    cxl/port: Fix use-after-free, permit out-of-order decoder shutdown

Maurizio Lombardi <mlombard@redhat.com>
    nvme-pci: fix race condition between reset and nvme_dev_disable()

Anastasia Belova <abelova@astralinux.ru>
    cpufreq: amd-pstate: add check for cpufreq_cpu_get's return value

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Implement bounds check for stream encoder creation in DCN401

Eddie James <eajames@linux.ibm.com>
    net/ncsi: Disable the ncsi work before freeing the associated structure

James Chapman <jchapman@katalix.com>
    l2tp: prevent possible tunnel refcount underflow

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Pass non-null to dcn20_validate_apply_pipe_split_flags

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check null pointers before using them

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check null pointers before used

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check null pointers before multiple uses

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add null check for head_pipe in dcn201_acquire_free_pipe_for_layer

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add null check for head_pipe in dcn32_acquire_idle_pipe_for_head_pipe_in_layer

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add null check for pipe_ctx->plane_state in dcn20_program_pipe

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Check null pointer before try to access it

Chunguang.xu <chunguang.xu@shopee.com>
    nvme-rdma: unquiesce admin_q before destroy it

Leon Hwang <leon.hwang@linux.dev>
    bpf: Prevent tailcall infinite loop caused by freplace

Yunfei Dong <yunfei.dong@mediatek.com>
    media: mediatek: vcodec: Fix H264 stateless decoder smatch warning

Devyn Liu <liudingyuan@huawei.com>
    spi: hisi-kunpeng: Add verification for the max_frequency provided by the firmware

Yang Yingliang <yangyingliang@huawei.com>
    spi: hisi-kunpeng: switch to use modern name

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: hisi-kunpeng: Convert to platform remove callback returning void

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Avoid overflow from uint32_t to uint8_t

Leon Huang <Leon.Huang1@amd.com>
    drm/amd/display: Refactor ABM feature

Maxime Méré <maxime.mere@foss.st.com>
    crypto: stm32/cryp - call finalize with bh disabled

Mukesh Ojha <quic_mojha@quicinc.com>
    pinmux: Use sequential access to access desc->pinmux data

Bert Karwatzki <spasswolf@web.de>
    wifi: mt76: mt7921: fix NULL pointer access in mt7921_ipv6_addr_change

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Fix index may exceed array range within fpu_update_bw_bounding_box

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Add missing NULL pointer check within dpcd_extend_address_range

Lenko Donchev <lenko.donchev@gmail.com>
    drm/amd/display: Use kcalloc() instead of kzalloc()

Jann Horn <jannh@google.com>
    userfaultfd: fix checks for huge PMDs

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: protect XDP configuration with a mutex

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Ensure array index tg_inst won't be -1

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check index for aux_rd_interval before using

Eric Dumazet <edumazet@google.com>
    pktgen: use cpus_read_lock() in pg_net_init()

Filipe Manana <fdmanana@suse.com>
    btrfs: do not BUG_ON() when freeing tree block after error

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on F2FS_INLINE_DATA flag in inode during GC

Chao Yu <chao@kernel.org>
    f2fs: fix to cover read extent cache access with lock

Keith Busch <kbusch@kernel.org>
    nvme: apple: fix device reference counting

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: Fix null pointer deref in dcn20_resource.c

Sibi Sankar <quic_sibis@quicinc.com>
    soc: qcom: icc-bwmon: Fix refcount imbalance seen during bwmon_remove

Manivannan Sadhasivam <mani@kernel.org>
    PCI: endpoint: pci-epf-test: Make use of cached 'epc_features' in pci_epf_test_core_init()

Steve Wilkins <steve.wilkins@raymarine.com>
    spi: microchip-core: ensure TX and RX FIFOs are empty at start of a transfer

Gavin Shan <gshan@redhat.com>
    mm/filemap: make MAX_PAGECACHE_ORDER acceptable to xarray

Xu Yang <xu.yang_2@nxp.com>
    filemap: add helper mapping_max_folio_size()

Jules Irenge <jbi.octave@gmail.com>
    s390/pkey: Use kfree_sensitive() to fix Coccinelle warnings

Holger Dengler <dengler@linux.ibm.com>
    s390/pkey: Wipe copies of clear-key structures on failure

Holger Dengler <dengler@linux.ibm.com>
    s390/pkey: Wipe copies of protected- and secure-keys

Milena Olech <milena.olech@intel.com>
    ice: Fix improper extts handling

George Stark <gnstark@salutedevices.com>
    leds: an30259a: Use devm_mutex_init() for mutex initialization

Bob Zhou <bob.zhou@amd.com>
    drm/amdgpu: fix double free err_addr pointer warnings

Chao Yu <chao@kernel.org>
    f2fs: fix to shrink read extent node in batches

Wander Lairson Costa <wander@redhat.com>
    sched/deadline: Fix task_struct reference leak

Miaohe Lin <linmiaohe@huawei.com>
    fork: defer linking file vma until vma is fully initialized

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Update cpu_sibling_map when disabling nonboot CPUs

Shashank Sharma <shashank.sharma@amd.com>
    drm/amdgpu: change vm->task_info handling

Baokun Li <libaokun1@huawei.com>
    ext4: fix uninitialized ratelimit_state->lock access in __ext4_fill_super()

Baokun Li <libaokun1@huawei.com>
    ext4: refactoring to use the unified helper ext4_quotas_off()

Hans de Goede <hdegoede@redhat.com>
    platform/x86: x86-android-tablets: Unregister devices in reverse order

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Check 'folio' pointer for NULL

Aleksandr Mishin <amishin@t-argos.ru>
    drm/msm/dpu: Add callback function pointer check before its call

Xiaolei Wang <xiaolei.wang@windriver.com>
    net: stmmac: move the EST lock to struct stmmac_priv

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix potential glock use-after-free on unmount

Stanislav Fomichev <sdf@google.com>
    bpf: Add BPF_PROG_TYPE_CGROUP_SKB attach type enforcement in BPF_LINK_CREATE

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Reload only IB representors upon lag disable/enable

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: L2CAP: Fix div-by-zero in l2cap_le_flowctl_init()

Rick Edgecombe <rick.p.edgecombe@intel.com>
    hv_netvsc: Don't free decrypted memory

Peter Xu <peterx@redhat.com>
    mm/userfaultfd: reset ptes when close() for wr-protected ones

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Fix the error path in panfrost_mmu_map_fault_addr()

Po-Hao Huang <phhuang@realtek.com>
    wifi: rtw89: fix null pointer access when abort scan

Andre Werner <andre.werner@systec-electronic.com>
    net: phy: phy_device: Prevent nullptr exceptions on ISR

Adam Ford <aford173@gmail.com>
    pmdomain: imx8mp-blk-ctrl: imx8mp_blk: Add fdcc clock to hdmimix domain

Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
    usb: typec: ucsi: Limit read size on v1.2

Christian Göttsche <cgzones@googlemail.com>
    selinux: avoid dereference of garbage after mount failure

Andrii Nakryiko <andrii@kernel.org>
    bpf: support deferring bpf_link dealloc to after RCU grace period

Chris Park <chris.park@amd.com>
    drm/amd/display: Prevent crash when disable stream

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix deadlock with fiemap and extent locking

Kory Maincent <kory.maincent@bootlin.com>
    dmaengine: dw-edma: eDMA: Add sync read before starting the DMA transfer in remote setup

Dave Airlie <airlied@redhat.com>
    nouveau: lock the client object tree.

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-pcm: Workaround for crashed firmware on system suspend

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/amd/display: fix NULL checks for adev->dm.dc in amdgpu_dm_fini()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fix memleak in map from abort path

Eric Dumazet <edumazet@google.com>
    net/sched: Fix mirred deadlock on device recursion

Dragos Tatulea <dtatulea@nvidia.com>
    net: esp: fix bad handling of pages from page_pool

Allen Pan <allen.pan@amd.com>
    drm/amd/display: Add a dc_state NULL check in dc_state_release

Yongqiang Liu <liuyongqiang13@huawei.com>
    ARM: 9359/1: flush: check if the folio is reserved for no-mapping addresses

Fei Wu <fei2.wu@intel.com>
    perf: RISCV: Fix panic on pmu overflow handler

Atish Patra <atishp@rivosinc.com>
    perf: RISC-V: Define helper functions expose hpm counter width and count

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix possible buffer overflow

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: af_bluetooth: Fix deadlock

Mads Bligaard Nielsen <bli@bang-olufsen.dk>
    drm/bridge: adv7511: fix crash on irq during probe

Chao Yu <chao@kernel.org>
    f2fs: fix to truncate meta inode pages forcely

Chao Yu <chao@kernel.org>
    f2fs: introduce f2fs_invalidate_internal_cache() for cleanup

Yangtao Li <frank.li@vivo.com>
    f2fs: introduce f2fs_is_readonly() for readability

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    spi: lpspi: Avoid potential use-after-free in probe()

Colin Ian King <colin.i.king@gmail.com>
    ASoC: qcom: Fix uninitialized pointer dmactl

Jakub Kicinski <kuba@kernel.org>
    net/sched: act_mirred: use the backlog for mirred ingress

Petr Tesarik <petr@tesarici.cz>
    net: stmmac: protect updates of 64-bit statistics counters

David Howells <dhowells@redhat.com>
    rxrpc: Fix delayed ACKs to not set the reference serial number

Mark Rutland <mark.rutland@arm.com>
    arm64: entry: fix ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD

Ido Schimmel <idosch@nvidia.com>
    net/sched: flower: Fix chain template offload

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix 'panel_cntl' could be null in 'dcn21_set_backlight_level()'

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add NULL test for 'timing generator' in 'dcn21_set_pipe()'

Petr Machata <petrm@nvidia.com>
    net: nexthop: Increase weight to u16

Petr Machata <petrm@nvidia.com>
    net: nexthop: Have all NH notifiers carry NH ID

Benjamin Poirier <bpoirier@nvidia.com>
    nexthop: Do not return invalid nexthop object during multipath selection

Benjamin Poirier <bpoirier@nvidia.com>
    nexthop: Factor out neighbor validity check

Benjamin Poirier <bpoirier@nvidia.com>
    nexthop: Factor out hash threshold fdb nexthop selection

Yu Kuai <yukuai3@huawei.com>
    blk-cgroup: dropping parent refcount after pd_free_fn() is done

Rob Clark <robdclark@chromium.org>
    interconnect: Fix locking for runpm vs reclaim

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on direct node in truncate_dnode()

Yu Kuai <yukuai3@huawei.com>
    block/rq_qos: protect rq_qos apis with a new lock

Kuniyuki Iwashima <kuniyu@amazon.com>
    smc: Fix use-after-free in tcp_write_timer_handler().

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: fix time stamp counter initialization

Chao Yu <chao@kernel.org>
    f2fs: don't reset unchangable mount option in f2fs_remount()

Yangtao Li <frank.li@vivo.com>
    f2fs: fix to set flush_merge opt and show noflush_merge

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: xsk: Fix crash on regular rq reactivation

Junhao He <hejunhao3@huawei.com>
    coresight: Fix memory leak in acpi_buffer->pointer

Jan Kara <jack@suse.cz>
    ext4: avoid deadlock in fs reclaim with page writeback

Fei Shao <fshao@chromium.org>
    media: mediatek: vcodec: Only free buffer VA that is not NULL

Dan Williams <dan.j.williams@intel.com>
    cxl/port: Fix delete_endpoint() vs parent unregistration race

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: split initial and dynamic conditions for extent_cache

Deepak Gupta <debug@rivosinc.com>
    riscv: VMAP_STACK overflow detection thread-safe

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix use-after-free in smb2_query_info_compound()

Ilya Bakoulin <ilya.bakoulin@amd.com>
    drm/amd/display: Fix hang/underflow when transitioning to ODM4:1

Zhipeng Lu <alexious@zju.edu.cn>
    SUNRPC: fix a memleak in gss_import_v2_context

Jan Kara <jack@suse.cz>
    reiserfs: Avoid touching renamed directory if parent does not change

Jeff Layton <jlayton@kernel.org>
    reiserfs: convert to simple_rename_timestamp

Jeff Layton <jlayton@kernel.org>
    fs: new helper: simple_rename_timestamp

Paloma Arellano <quic_parellan@quicinc.com>
    drm/msm/dpu: Add mutex lock in control vblank irq

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: migrate: fix getting incorrect page mapping during page migration

Dave Chinner <dchinner@redhat.com>
    xfs: fix unmount hang with unflushable inodes stuck in the AIL

Dave Chinner <dchinner@redhat.com>
    xfs: factor out stale buffer item completion

Dave Chinner <dchinner@redhat.com>
    xfs: rearrange code in xfs_buf_item.c

Dave Chinner <dchinner@redhat.com>
    xfs: catch stale AGF/AGF metadata

Dave Chinner <dchinner@redhat.com>
    xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock

Johan Hovold <johan@kernel.org>
    tty: add break_wait kernel-doc

Christian Brauner <brauner@kernel.org>
    namespace: handle mount locking for automounts correctly

Christian Brauner <brauner@kernel.org>
    fcntl: refuse F_SET_RW_HINT on an immutable inode

Christian Brauner <brauner@kernel.org>
    namespace: check the target before walking it in do_mount_setattr()

Christian Brauner <brauner@kernel.org>
    namespace: don't copy an unmounted mount tree

Christian Brauner <brauner@kernel.org>
    namespace: unhash a dentry before detaching the mounts on it

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    drm/fb-helper: defer setup when fbdev_probe() fails, not just on -EAGAIN

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    drm/amdgpu: copy debugfs register data outside the GRBM/SRBM locks

Wentao Liang <vulab@iscas.ac.cn>
    drm/vc4: Fix firmware reference leak in vc4_drm_bind()

Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>
    scsi: ch: Do not keep references to data transfer element devices

Shao-Fu Chen <shf.chen@mediatek.com>
    optee: register TEE devices only once fully initialized

Shawn Lin <shawn.lin@rock-chips.com>
    pmdomain: rockchip: propagate subdomain add errors

Shawn Lin <shawn.lin@rock-chips.com>
    pmdomain: rockchip: don't ignore clock lookup errors on attach

Ming Qian <ming.qian@oss.nxp.com>
    pmdomain: imx8m-blk-ctrl: Serialize power on/off across sibling domains

Shawn Lin <shawn.lin@rock-chips.com>
    pmdomain: rockchip: fix clock leak on domain probe failure

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix reading free memory in do_resume

Christian Brauner <brauner@kernel.org>
    namespace: check the mounts before reading their parents in pivot_root()

Christian Brauner <brauner@kernel.org>
    namespace: don't inherit MNT_UMOUNT in clone_mnt()

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: ISO: Serialize concurrent connect calls

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: validate pitch coming from userspace

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    Bluetooth: RFCOMM: connect the session socket without rfcomm_mutex

Weiming Shi <bestswngs@gmail.com>
    net: team: stop reusing skb after queue override

Weiming Shi <bestswngs@gmail.com>
    net: team: fix NULL pointer dereference in team_xmit during mode change

Marc Harvey <marcharvey@google.com>
    net: team: Rename port_disabled team mode op to port_tx_disabled

Marc Harvey <marcharvey@google.com>
    net: team: Remove unused team_mode_op, port_enabled

Felix Fietkau <nbd@nbd.name>
    netfilter: nf_tables: fix bidirectional offload regression

Tahera Fahimi <taherafahimi@linux.microsoft.com>
    xfrm: prevent policy_hthresh.work from racing with netns teardown

Ramses de Norre <ramses@well-founded.dev>
    wireguard: queueing: preserve tstamp_type when encapsulating packet

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP

Vishal Badole <Vishal.Badole@amd.com>
    EDAC/amd64: Mask UMC chip select to the four implemented selects

Christian Göttsche <cgzones@googlemail.com>
    selinux: fix data race on AVC latest_notif

Tristan Madani <tristan@talencesecurity.com>
    ice: fix metadata_dst refcount handling on representor teardown

Daehyeon Ko <4ncienth@gmail.com>
    ip6_gre: remove obsolete ERSPAN PMTU update

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Set the trace clock before registering the histogram trigger

Vicki Pfau <vi@endrift.com>
    HID: steam: Clean up locking

Vicki Pfau <vi@endrift.com>
    HID: steam: Refactor registration

Vicki Pfau <vi@endrift.com>
    HID: steam: Rearrange teardown sequence

Vicki Pfau <vi@endrift.com>
    HID: steam: Fully unregister controller when hidraw is opened

Vicki Pfau <vi@endrift.com>
    HID: hid-steam: Make client_opened a counter

Dan Carpenter <dan.carpenter@linaro.org>
    HID: hid-steam: Fix cleanup in probe()

Adrian Betschart <adrian.betschart@cinemaone.ch>
    drm/amd/display: Don't replace a sink mode that shares the native totals

Oliver Hartkopp <socketcan@hartkopp.net>
    can: fix unique skb identifier regression under RPS

Ezrak1e <ezrakiez@gmail.com>
    dlm: validate length in dlm_search_rsb_tree

Xue Lei <Xue.Lei@windriver.com>
    mtd: fix double free and WARN_ON in add_mtd_device() error paths

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: maps: vmu-flash: Fix the (mtd core) switch to ref counters

Alexander Usyskin <alexander.usyskin@intel.com>
    mtd: fix use-after-free in mtd release

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: Clean refcounting with MTD_PARTITIONED_MASTER

Fernando Fernandez Mancera <fmancera@suse.de>
    net: openvswitch: validate transport header presence in set_ipv6_addr

Li RongQing <lirongqing@baidu.com>
    net/mlx5e: Order ICOSQ cc update after CQ doorbell

Eric Dumazet <edumazet@kernel.org>
    flow_dissector: avoid u16 truncation of hlen in bpf_flow_dissect()

Eric Dumazet <edumazet@kernel.org>
    flow_dissector: avoid u16 truncation of skb->len when computing thoff

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: samsung: i2s: enable op_clk in probe to balance runtime PM

Alvin Šipraga <alvin.sipraga@analog.com>
    ASoC: adau1372: fix invalid default state of output ASRC and DAC muxes

Alvin Šipraga <alvin.sipraga@analog.com>
    ASoC: adau1372: allow sleepy powerdown GPIOs

Sang-Hoon Choi <csh0052@gmail.com>
    nvmet: use the local P2P device on metadata allocation failure

Sang-Hoon Choi <csh0052@gmail.com>
    cxgb4/ch_ktls: disable softirqs around tid_list erases

Omar Ramadan <omar@blockcast.net>
    amt: send the relay's General Query directly from the receive path

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: em_text: reject unterminated algo before autoload

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Free the BO cache size list on teardown

Myeonghun Pak <mhun512@gmail.com>
    drm/aspeed: Balance the display clock enable on teardown

Sang-Hoon Choi <csh0052@gmail.com>
    gpio: exar: initialize the ID before registering its cleanup

Oleg Keri <okerixx@gmail.com>
    drm/dp: don't mark the AUX backlight enabled when enabling failed

Christian Brauner <brauner@kernel.org>
    namespace: refuse an automount below a mount that is in no namespace

Christian Brauner <brauner@kernel.org>
    dcache: don't put a mountpoint on a dentry that's being removed

Christian Brauner <brauner@kernel.org>
    namespace: check a submount for references right before unmounting it

Christian Brauner <brauner@kernel.org>
    fs: refuse fspick() on internal superblocks

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: make Mac FB workaround generic

Fan Wu <fanwu01@zju.edu.cn>
    drm/vc4: drain the hangcheck timer and works on V3D unbind

Krzysztof Karas <krzysztof.karas@intel.com>
    drm/i915/gt: Unmask interrupts only when ACTIVE is true

Krzysztof Karas <krzysztof.karas@intel.com>
    drm/i915/gem: Prevent overstepping exec array boundary

Sajal Gupta <sajal2005gupta@gmail.com>
    drm/gud: don't keep a connector without a CRTC as connector_state

Palla Raghunath <raghunathpalla.0209@gmail.com>
    Bluetooth: RFCOMM: Fix NULL tty_dev dereference in rfcomm_dev_shutdown

Maxim Skokov <skokovmaksimevg@gmail.com>
    Bluetooth: RFCOMM: free the skb when the DLC has no owner

Iaroslav Voitovych <yaroslav.voytovych@gmail.com>
    Bluetooth: MGMT: Fix status of pending commands flushed on power off

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sock: Serialize dead-device detachment

Runyu Xiao <runyu.xiao@seu.edu.cn>
    scsi: qedi: Initialize callback state before registration

Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>
    regulator: ltc3676: don't read the write-only HRST and CLIRQ registers

Denis V. Lunev <den@openvz.org>
    openvswitch: fix soft lockup in the netlink flow dump

Karl Bonde Torp <k.torp@samsung.com>
    nvme: fix swapped ZRASF zone state values for full and read only

Fredrik Nyberg <fredrik.nyberg@volvocars.com>
    net: usb: ax88179_178a: fix rx frame length for non-last packets

Sebastien Royen <sebastien.royen@armadeus.com>
    net: dsa: microchip: fix KSZ8765 fiber detection

Zixuan Chai <petalzu987@gmail.com>
    net: bridge: avoid recursive multicast port cleanup

Chengfeng Ye <nicoyip.dev@gmail.com>
    net/smc: protect clcsock lifetime in smc_getname

Quchaosheng <quchaosheng000406@163.com>
    net/packet: guard the ll header push in packet_rcv_spkt()

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: sdhci-sprd: disable runtime PM on remove

Yibo Tan <lhfff@tju.edu.cn>
    mmc: mtk-sd: Cancel request timeout work on remove

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: cavium-thunderx: destroy slot platform devices on remove

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: cavium-octeon: destroy slot platform devices on remove

Ma Xinmeng <1564938642@qq.com>
    dm-snap: reject the transient exception store for snapshot-merge

Ben Cressey <ben@cressey.dev>
    dm-crypt: reject the lmk IV mode with AEAD ciphers

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    memstick: rtsx_usb_ms: complete requests after eject instead of dropping them

Raj Ojha <rajojha047@gmail.com>
    memstick: core: wait for request completion before freeing card

성병찬 <tjdqudcks0424@naver.com>
    KEYS: Fix add_key() race with keyring restriction

Karl Mehltretter <kmehltretter@gmail.com>
    keys: finalize persistent keyring timeout after link attempt

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: fix TX LTB and filter unwind on open-fail

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: h_free logical LAN on open-fail after register

Ridham Khurana <khurana.ridham222@gmail.com>
    gpio: xilinx: fix runtime PM leak on request error path

Hui Peng <benquike@gmail.com>
    sctp: copy zeroed stats to user in sctp_getsockopt_pr_streamstatus() when !streamoute

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: preserve NATIVE_LABELS on already-initialized sb in set_mnt_opts

Johannes Berg <johannes.berg@intel.com>
    Revert "wifi: libertas: reject short monitor TX frames"

Chengfeng Ye <nicoyip.dev@gmail.com>
    tipc: hold a reference to nodes found by link name

Yuqi Xu <xuyuqiabc@gmail.com>
    tipc: destroy topsrv workqueues before closing connections

Sabrina Dubroca <sd@queasysnail.net>
    strparser: make sure __strp_recv isn't running before tearing down the parser

Josef Bacik <josef@toxicpanda.com>
    xen/netfront: don't leak the skb when xennet_fill_frags() fails

Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>
    workqueue: Fix NULL current_pwq deref in chained work check

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: noise: reject response consumption after intermediate initiation

Michele Dionisio <michele.dionisio@gmail.com>
    wifi: brcmfmac: fix P2P device removal race in brcmf_detach()

Palla Raghunath <raghunathpalla.0209@gmail.com>
    dm ioctl: don't let data_start run past the buffer

Wentao Liang <vulab@iscas.ac.cn>
    btrfs: scrub: fix local_root reference leak in scrub_print_warning_inode()

Michael Garland <minimelkav@gmail.com>
    ASoC: amd: yc: Add DMI quirk for Acer Aspire Go 15 (AG15-21P)

Karl Mehltretter <kmehltretter@gmail.com>
    arm64: irq: exclude the softirq stack switch from KCOV

Daehyeon Ko <4ncienth@gmail.com>
    ipv6: do not warn on route notification size race

Daehyeon Ko <4ncienth@gmail.com>
    ipv4: do not warn on route notification size race

Daehyeon Ko <4ncienth@gmail.com>
    ipv4: stop route notification sizing when nexthop group shrinks

Daehyeon Ko <4ncienth@gmail.com>
    ipv4: stop PMTU walk when nexthop group shrinks

Eric Biggers <ebiggers@kernel.org>
    crypto: drbg - Fix ineffective sanity check

Karl Mehltretter <kmehltretter@gmail.com>
    netfilter: nft_set_pipapo: restore cloned mapping table memcg accounting

Jiajia Liu <liujiajia@kylinos.cn>
    Bluetooth: hci_event: fix simultaneous discovery stuck in FINDING

Liew Rui Yan <aethernet65535@gmail.com>
    mm/damon/core: fix unconditionally skip last region

SeongJae Park <sj@kernel.org>
    mm/damon/core: do non-safe region walk on kdamond_apply_schemes()

Carlos Llamas <cmllamas@google.com>
    HID: uhid: convert to hid_safe_input_report()

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: introduce hid_safe_input_report()

Andrey Misiurov <andrey.misyrov@gmail.com>
    scsi: lpfc: Fix use-after-free of mboxq in lpfc_sli4_driver_resource_setup()

HE WEI（ギカク） <skyexpoc@gmail.com>
    fs/ntfs3: fix slab-out-of-bounds write in ni_create_attr_list()

Nirbhay Sharma <nirbhay.lkd@gmail.com>
    fs/ntfs3: fix KMSAN uninit-value in ni_create_attr_list

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Mark inode as bad as soon as error detected in mi_enum_attr()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Add more checks in mi_enum_attr (part 2)

Pengpeng Hou <hppiscas@163.com>
    iio: cdc: ad7150: fix OF matching and publish module aliases

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    iio: adc: stm32-adc: fix possible division by zero in processed channel

Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>
    iio: adc: axp288: Add TS bias override for Haier HV103H

Cong Nguyen <congnt264@gmail.com>
    iio: adc: max1363: sign-extend bipolar differential channel reads

Pengpeng Hou <pengpeng@iscas.ac.cn>
    iio: adc: aspeed: propagate reset deassert errors

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    iio: adc: aspeed: Simplify with dev_err_probe

Fan Wu <fanwu01@zju.edu.cn>
    iio: adc: ad_sigma_delta: fix use-after-free on unbind

Paulo Alcantara <pc@manguebit.org>
    smb: client: discard post-EOF pagecache when extending a file via zero range

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: set info->band for 802.3 encap offload frames

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Use the active VMCB's MSR bitmap when checking if MSR is intercepted

Peter Xu <peterx@redhat.com>
    mm/hugetlb: fix avoid_reserve to allow taking folio from subpool

Matthew Wilcox (Oracle) <willy@infradead.org>
    fs: Free any excess xarray nodes in clear_inode()

Zhiling Zou <zhilinz@nebusec.ai>
    wifi: mac80211: count only matching reservations in reserved switch

Zhiling Zou <zhilinz@nebusec.ai>
    wifi: mac80211: keep paired old chanctx alive

Johan Hovold <johan@kernel.org>
    tty: port: fix tty_port_tty_vhangup() race

Eric Dumazet <edumazet@kernel.org>
    bnxt_en: fix DMA mapping length for padded small packets

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: account proxy paths against the mesh path limit

Han Xu <han.xu@nxp.com>
    mtd: spinand: Enable QE on all dies

Pei Xiao <xiaopei01@kylinos.cn>
    mtd: block2mtd: Fix divide error when erase_size is zero

Johan Hovold <johan@kernel.org>
    USB: serial: fix ioctl hangup race

Johan Hovold <johan@kernel.org>
    USB: serial: report unsupported break signalling

Johan Hovold <johan@kernel.org>
    USB: serial: return errors from break handling

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: keep fallback association elements alive

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: shut down RX BA session timer on teardown

Nuno Sá <nuno.sa@analog.com>
    mtd: spinand: fix NULL pointer dereference with no ECC engine

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Mark DCE 6.4 as not APU

Johan Hovold <johan@kernel.org>
    serial: fix TIOCMIWAIT race

Fan Wu <fanwu01@zju.edu.cn>
    tty: serial: max3100: shut down timer before freeing port

Johan Hovold <johan@kernel.org>
    tty: tty_port: restore TTY_IO_ERROR on activation failure

Pannarat Wiriyaarritham <pannarat.wiriyaarritham@danielcorp.dev>
    usb: typec: ucsi: acpi: Assume UCSI 1.2 on Acer Nitro ANV15-41

Runyu Xiao <runyu.xiao@seu.edu.cn>
    USB: dwc2: shut down wakeup timer before freeing HCD state

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-spear: disable controller wakeup on removal

Chen Ni <nichen@iscas.ac.cn>
    usb: ohci-spear: Remove unnecessary NULL check before clk_disable_unprepare()

Francisco Beltrán Millalén <fbeltranmillalen@gmail.com>
    drm/amdgpu: reset VI ASIC on MacBookPro14,3

Andre Eikmeyer <dev@deq.rocks>
    drm/amdgpu: reset VI ASIC on MacBookPro15,1

Jiangshan Yi <yijiangshan@kylinos.cn>
    drm/amd/display: check dc_state_create_copy() for NULL in dm_suspend

Eric Biggers <ebiggers@kernel.org>
    fsverity: add dependency on 64K or smaller pages

Mostafa Saleh <smostafa@google.com>
    KVM: arm64: Don't use the VMA to size stage-2 block mappings for VM_PFNMAP

Jinseob Kim <kimjinseob88@gmail.com>
    iio: buffer: serialize buffer teardown with mode claims

Beata Michalska <beata.michalska@arm.com>
    arm64: errata: Add Cortex-A725 erratum 3821522 workaround

Beata Michalska <beata.michalska@arm.com>
    arm64: errata: Factor out broken AMU const counter cap

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: signal: Forbid non-streaming SVE payload on SME-only systems

Zhengchuan Liang <zcliangcn@gmail.com>
    perf: Require kernel access for text poke events

Johan Hovold <johan@kernel.org>
    tty: fix saved termios reset race

Jiazi Liu <jiazi.liu1984@gmail.com>
    usb: dwc3: gadget: fix IRQ storm on invalid event buffer count

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    soc: qcom: geni-se: Correct QUP Core ICC vote constants

Andrei Matei <andreimatei1@gmail.com>
    bpf: Fix accesses to uninit stack slots

Jiangshan Yi <yijiangshan@kylinos.cn>
    smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions

Josef Bacik <josef@toxicpanda.com>
    xen/netfront: drop RX packets with a short Ethernet header

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: constrain TCPM_SOURCING_VBUS event handling

Xu Yang <xu.yang_2@nxp.com>
    usb: typec: tcpm: fix debug accessory mode detection for sink ports

Neill Kapron <nkapron@google.com>
    usb: gadget: f_fs: Fix Use-After-Free in AIO error path

Gabriel Prostitis <prostitisgabriel@gmail.com>
    USB: gadget: ffs: fix mm lifetime handling

Fan Wu <fanwu01@zju.edu.cn>
    usb: gadget: at91_udc: drain polled-VBUS timer/work before udc is freed

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: gadget: at91_udc: Convert to platform remove callback returning void

Karl Mehltretter <kmehltretter@gmail.com>
    serial: imx: serialize imx_uart_ports[] lifetime

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial: imx: Convert to platform remove callback returning void

Gilberto Conde <gilbertorconde@gmail.com>
    net: usb: qmi_wwan: add Quectel EG120K-EA

Wentao Liang <vulab@iscas.ac.cn>
    wifi: wlcore: Fix runtime PM leak in wlcore_remove()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    wifi: wlcore: Convert to platform remove callback returning void

Frank Sorenson <sorenson@redhat.com>
    smb: client: split cifsFileInfo bitfields to avoid shared-byte RMW races

Paolo Abeni <pabeni@redhat.com>
    mptcp: prevent race between disconnect() and rtx

Eric Dumazet <edumazet@google.com>
    tcp: introduce icsk->icsk_keepalive_timer

Mehmet Fide <mehmet.fide@screeningeagle.com>
    mtd: rawnand: vf610_nfc: fix false bitflips on reads of erased pages

Yi Yang <yiyang13@huawei.com>
    vc_screen: reload vc pointer before if (ret) in vcs_write() to avoid UAF

Chris Mason <clm@meta.com>
    SUNRPC: reject duplicate CREDS_VALUE options

Chris Mason <clm@meta.com>
    SUNRPC: fix gssx_dec_option_array error path bugs

Asad Kamal <asad.kamal@amd.com>
    drm/amd/powerplay: fix VoltageObjectInfo zero-stride loop and OOB read

Aditya Dutt <duttaditya18@gmail.com>
    jfs: fix array-index-out-of-bounds read in add_missing_indices

Fan Wu <fanwu01@zju.edu.cn>
    iio: trigger: cancel reenable_work before freeing trigger

Salah Triki <salah.triki@gmail.com>
    iio: proximity: vcnl3020: fix ISR bitmask check in IRQ handler

Zhang Jie <zhangjie14@huaqin.corp-partner.google.com>
    iio: proximity: sx9324: Correct proximity channel resolution

Cong Nguyen <congnt264@gmail.com>
    iio: proximity: pulsedlight: fix iio_device left registered on PM setup failure

Salah Triki <salah.triki@gmail.com>
    iio: proximity: isl29501: Fix return type of isl29501_register_write

Hui Su <sh_def@163.com>
    iio: pressure: bmp280: fix out-of-bounds access in sampling frequency lookup

Fan Wu <fanwu01@zju.edu.cn>
    iio: light: gp2ap020a00f: drain irq_work after free_irq

Arka Mondal <arkamondalofficial@gmail.com>
    iio: imu: adis16480: fix unprotected debugfs reads

Arka Mondal <arkamondalofficial@gmail.com>
    iio: imu: adis16400: fix unprotected debugfs reads

Arka Mondal <arkamondalofficial@gmail.com>
    iio: gyro: adis16136: fix unprotected debugfs reads

Salah Triki <salah.triki@gmail.com>
    iio: frequency: admv1013: fix wrong channel field used in admv1013_read_raw()

Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
    iio: buffer: Ensure bounce buffer used for unaligned case is zeroed.

Fan Wu <fanwu01@zju.edu.cn>
    iio: adc: xilinx-xadc: free IRQ before cancelling the unmask worker on unbind

Felix Gu <ustc.gu@gmail.com>
    iio: adc: sun4i-gpadc-iio: drop underflowing pm_runtime_put() calls

Felix Gu <ustc.gu@gmail.com>
    iio: adc: sun4i-gpadc-iio: clean up on thermal zone registration failure

Salah Triki <salah.triki@gmail.com>
    iio: accel: sca3000: fix frequency divider condition check

Jiale Yao <yaojiale02@163.com>
    iio: accel: kxcjk-1013: reject duplicate event disable

Daehyeon Ko <4ncienth@gmail.com>
    thunderbolt: Reject oversized XDomain properties responses

Kurt Lieber <kurt@lieber.org>
    thunderbolt: Disable CL states for the Anker Prime TB5 dock

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Fix KASAN reported use-after-free when request is canceled

Ian Lin <ian.lin@jetone.com.tw>
    USB: serial: option: add Compal EXC-T1 support

Sebastian Sjoholm <sebastian.sjoholm@gmail.com>
    USB: serial: option: add Quectel RG660QB

Ian Lin <jisayme@gmail.com>
    USB: serial: option: add Compal EXM-G1x support

Carlo Szelinsky <github@szelinsky.de>
    USB: serial: option: add Quectel EG060W

Zhao Dongdong <zhaodongdong@kylinos.cn>
    USB: serial: option: add support for SIMCom SIM8260C

Johan Hovold <johan@kernel.org>
    USB: serial: fix driver deregistration order

Johan Hovold <johan@kernel.org>
    USB: serial: fix dynamic id driver deregistration race

Johan Hovold <johan@kernel.org>
    USB: serial: ssu100: fix baud rate overflow

Johan Hovold <johan@kernel.org>
    USB: serial: quatech2: fix baud rate overflow

Jérémy Carrat <jeremy.carrat@icloud.com>
    USB: serial: cp210x: add Corsair AX1500i Power Supply

Yuqi Xu <xuyuqiabc@gmail.com>
    wifi: mac80211: handle empty FILS association request payload

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: release mesh path quota on failed additions

Yuqi Xu <xuyuqiabc@gmail.com>
    wifi: mac80211: minstrel_ht: validate fixed rate index

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: drain PS delivery work during station teardown

Guangshuo Li <lgs201920130244@gmail.com>
    wifi: iwlegacy: 3945: free EEPROM data on remove

Tianchu Chen <flynnnchen@tencent.com>
    wifi: cw1200: fix TX padding OOB read leaking heap data to device

Nuno Sá <nuno.sa@analog.com>
    mtd: spinand: fix zero oobavail when no ECC engine is used

Mehmet Fide <mehmet.fide@screeningeagle.com>
    mtd: rawnand: vf610_nfc: fix reads on chips with more than 64 bytes of OOB

Runyu Xiao <runyu.xiao@seu.edu.cn>
    mtd: rawnand: cadence: Initialize IRQ state before requesting IRQ

Weiming Shi <bestswngs@gmail.com>
    nvmet-auth: fix out-of-bounds write in nvmet_auth_challenge()

Daehyeon Ko <4ncienth@gmail.com>
    nvme-multipath: fix underflow in ANA log bounds checks

Zhiling Zou <zhilinz@nebusec.ai>
    ipvs: bound LBLCR and LBLC cache growth

Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
    Bluetooth: btintel: fix buffer over-read in btintel_hw_error()

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_core: Serialize fragmented ISO packet queueing

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_core: Serialize ACL scheduling with channel deletion

Linmao Li <lilinmao@kylinos.cn>
    Bluetooth: hci_core: Fix inquiry cache timestamps on 64-bit systems

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_conn: Lock parent access during enhanced SCO setup

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: RFCOMM: Fix initial port reference race

Xiang Mei <xmei5@asu.edu>
    ALSA: ua101: reject mismatched capture/playback packet sizes

Kyle Zeng <kylebot@openai.com>
    ALSA: seq: Serialize compat port-info ioctls

Zimeng Li <me@lizi.moe>
    ASoC: qcom: lpass-cpu: use DAI table index for playback constraints

Wentao Liang <vulab@iscas.ac.cn>
    serial: vt8500: Fix clock reference leak in vt8500_serial_probe()

Simon Gassner <simon.gassner@noxsystems.com>
    serial: tegra: don't clear the Tx FIFO on an Rx-only reset

Fan Wu <fanwu01@zju.edu.cn>
    serial: 8250_bcm7271: fix use-after-free in brcmuart_remove()

Johan Hovold <johan@kernel.org>
    tty: abort break signalling on hangup

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    tty: serial: qcom_geni_serial: Keep console RX functional after deep idle

Joshua Rogers <linux@joshua.hu>
    tty: vcc: hold port lock when clearing tty pointer in vcc_cleanup

Joshua Rogers <linux@joshua.hu>
    tty: vcc: zero-initialize control packet in vcc_send_ctl()

Johan Hovold <johan@kernel.org>
    tty: amiserial: fix broken TIOCMIWAIT

Mingyu Wang <25181214217@stu.xidian.edu.cn>
    tty: vt: fix memory leak in vc_allocate()

Jie Deng <dengjie03@kylinos.cn>
    usb: cdns3: Fix NULL pointer dereference in cdns3_pci_probe

Fan Wu <fanwu01@zju.edu.cn>
    usb: cdns3: fix use-after-free in cdns3_gadget_exit()

Jameson Thies <jthies@google.com>
    usb: typec: ucsi: displayport: Current CAM OOB index fixup

Prashanth K <prashanth.k@oss.qualcomm.com>
    usb: typec: ucsi: Get the connector fwnode based on reg value

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    usb: typec: tipd: fix uninitialized typec_partner_desc in tps6598x_connect()

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: recover after failure to start the frs ams

Hui Peng <benquike@gmail.com>
    usb: core: clear both ep_in and ep_out for non-ep0 control endpoints

Myeonghun Pak <mhun512@gmail.com>
    usb: chipidea: tegra: disable runtime PM on resume failure

Yuchao Zhang <ndaugoing@gmail.com>
    usb: gadget: f_fs: Fix NULL pointer dereference in FUNCTIONFS_ENDPOINT_DESC

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: dummy-hcd: Fix wait for outstanding request completions

Fan Wu <fanwu01@zju.edu.cn>
    usb: gadget: aspeed-vhub: cancel wake work on device removal

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    usb: dwc3: am62: Fix runtime PM usage count leak on probe error path

Linkai Gong <gonglinkai@kylinos.cn>
    usb: typec: anx7411 - stop the IRQ before destroying the workqueue

Liu Chao <liuc63@xiaopeng.com>
    usb: gadget: f_uac1_legacy: validate bRequest index in generic_{set,get}_cmd

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-st: disable controller wakeup on removal

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-s3c2410: disable controller wakeup on removal

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-da8xx: disable controller wakeup on cleanup

Orgad Shaneh <orgads@gmail.com>
    usb: octeon-hcd: fix the FIFO-flush timeout computation

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    usb: hub: use shorter 120ms post resume hold for SS root hubs

Syed Labeeq Sajid Bukhari <syedlabeeq@gmail.com>
    usb: storage: sierra_ms: reject short SWoC info transfers

Johan Hovold <johan@kernel.org>
    USB: serial: fix port tear down use-after-free

Yuchao Zhang <ndaugoing@gmail.com>
    USB: cdc-acm: skip URB restart in port_shutdown if disconnected

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix racy TIOCMIWAIT implementation

Yuxiao Wang <yuxiao.wang@certik.com>
    nitro_enclaves: fix use-after-free on SLOT_ALLOC failure

Raphaël Larocque <rlarocque@disroot.org>
    Input: synaptics - limit T440p InterTouch quirk to LEN0036

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    Input: synaptics - add LEN205b entry to smbus_pnp_ids for ThinkPad T490

David Heidelberg <david@ixit.cz>
    Input: s6sy761 - fix resume ordering and restore sensing

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    Input: i8042 - add nomux quirk for Fujitsu LIFEBOOK U7410

Martino Papero <martino.papero@lcb.to.it>
    Input: atkbd - skip deactivate for Lenovo IdeaPad Slim 3 15IWC11

Wentao Liang <vulab@iscas.ac.cn>
    kgdboc: Fix tty driver reference leak in configure_kgdboc()

Tomer Pomeranc <tomerpo@gmail.com>
    binder: fix leaked fd fixups on TF_UPDATE_TXN supersede

Tomer Pomeranc <tomerpo@gmail.com>
    binder: fix is_failure flag for superseded transaction cleanup

Guangshuo Li <lgs201920130244@gmail.com>
    drm/amdgpu: fix ACP MFD device leak on init failure

Guangshuo Li <lgs201920130244@gmail.com>
    drm/amdgpu: fix IP instance memory leak on kobject add failure

Imre Kaloz <kaloz@kernel.org>
    drm/radeon: Read the VRAM VBIOS signature with readb()

Willian Oliveira <williandossantosdeoliveira287@gmail.com>
    drm/amdgpu/gfx6: fix firmware leak on teardown

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/si: Fix updating clock limits on AC/DC

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/si: Check AMD_IS_MOBILITY flag for PPSMC_SYSTEMFLAG_GPIO_DC

Nikola Prica <nikola.prica@amd.com>
    PCI: Accept AtomicOps already enabled by the hypervisor

Luo Gengkun <luogengkun2@huawei.com>
    perf: Fix race between perf_event_exit_task() and perf_pending_task()

Hongjian Dai <daihongjian@kylinsec.com.cn>
    i2c: at91: release DMA channels when probe defers

Eric Dumazet <edumazet@kernel.org>
    ipv6: sr: use skb_get_hash_net() in seg6_make_flowlabel()

Florian Westphal <fw@strlen.de>
    net: add and use skb_get_hash_net

Quentin Freimanis <quentin@q-lab.dev>
    net: sparx5: make ports inherit the switch base mac address type

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: bpf: reject invalid NAT manipulation types

Julian Anastasov <ja@ssi.bg>
    ipvs: filter some flags received in the backup server

Julian Anastasov <ja@ssi.bg>
    ipvs: do not create invisible templates

Julian Anastasov <ja@ssi.bg>
    ipvs: fix missing counter decrement in lblc

Jeff Jo <jeffjo@openai.com>
    tcp: refresh TS.Recent for accepted old ACKs

Nicolai Buchwitz <nb@tipi-net.de>
    net: bcmgenet: fix NULL dereference in set_coalesce before first open

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_codel: match the no-drop threshold to the packet size

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq_codel: match the no-drop threshold to the packet size

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    tipc: prevent GCM nonce reuse on peer key changes

Baha Mesleh <baha.mesleh@nokia.com>
    octeontx2-af: mcs: Fix SC resource cleanup loop

Florian Fainelli <florian.fainelli@broadcom.com>
    net: systemport: Fix RUNT MIB counter register offset calculation

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    Bluetooth: hci_sync: don't drain cmd_sync backlog on unregister

Florian Westphal <fw@strlen.de>
    netfilter: ipset: do not update comments from kernel-side adds

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_api: reclaim an empty proto on the error path

Binbin Deng <18983559317@163.com>
    net/mctp: publish the mctp_dev only after it is initialised

Sai Teja Aluvala <aluvala.sai.teja@intel.com>
    Bluetooth: btintel: validate DDC record lengths

Sang-Hoon Choi <csh0052@gmail.com>
    Bluetooth: hci_core: free the HCI ID if naming fails

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: rt274: Fix format setting for 44100 rate

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: rt286: Revert delay value for jack setup

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: preserve hidden-group beacon IE ownership

Manush Prajwal <manushprajwal555@gmail.com>
    rtc: mpfs: fix unchecked devm_clk_get() error pointer in probe()

Liu Dalin <liudalin@kylinsec.com.cn>
    rtc: dev: zero-initialize struct rtc_wkalrm to prevent information leak

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath11k: reset ar->num_stations on hardware start

Sheetal <sheetal@nvidia.com>
    ASoC: tegra: Fix ASRC Stream6 input threshold control

Aamir Ahmed <elb12345@hotmail.co.uk>
    wifi: wfx: validate MIB read length before copying to caller

HyeongJun An <sammiee5311@gmail.com>
    ASoC: wm8903: Move the DRC QR threshold to the register that holds it

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of/overlay: don't create "//" paths for fragments targeting the root

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of/overlay: don't leak fragment references when changeset init fails

Julian Sun <sunjunchao@bytedance.com>
    nvmet: preserve device path on allocation failure

Karl Mehltretter <kmehltretter@gmail.com>
    mtd: core: call _get_device() with the master MTD

Alexander Usyskin <alexander.usyskin@intel.com>
    mtd: call external _get and _put in right order

Tomas Winkler <tomas.winkler@intel.com>
    mtd: use refcount to prevent corruption

SJ Park <sj@kernel.org>
    mm/damon/core: don't skip damos_adjust_quota() while esz is not zero

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Initialize NVMe abort_work once at submission

Svyatoslav Ryhel <clamor95@gmail.com>
    drm/tegra: gr2d/gr3d: Initialize address register map before HOST1X client is registered

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/lbr: Fix kernel address leakage

Kuniyuki Iwashima <kuniyu@google.com>
    hsr: Remove WARN_ONCE() in hsr_addr_is_self().

Kang Yang <quic_kangyang@quicinc.com>
    wifi: ath11k: add srng->lock for ath11k_hal_srng_* in monitor mode

Duoming Zhou <duoming@zju.edu.cn>
    watchdog: cpu5wdt.c: Fix use-after-free bug caused by cpu5wdt_trigger

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    perf/core: Fix WARN in perf_sigtrap()

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/secretmem: properly account locked pages

Xiang Mei <xmei5@asu.edu>
    ALSA: line6: reject oversized playback packets

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    ALSA: caiaq: unregister the input device when probe fails

Zizhi Wo <wozizhi@huawei.com>
    vt: skip screen update for DEC alignment test on backgroup consoles

Clément Léger <clement.leger@bootlin.com>
    of/irq: add missing of_node_put() for interrupt parent node

Chunguang Xu <chunguang.xu@shopee.com>
    nvme-fabrics: use reserved tag for reg read/write command

Jakub Kicinski <kuba@kernel.org>
    ethtool: fail closed if we can't get max channel used in indirection tables

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: av7110: fix a spectre vulnerability

Christoph Schlameuss <schlameuss@linux.ibm.com>
    kvm: s390: Reject memory region operations for ucontrol VMs

Dan Carpenter <dan.carpenter@linaro.org>
    drm/mediatek: Fix potential NULL dereference in mtk_crtc_destroy()

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/hdcp: Add encoder check in hdcp2_get_capability

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/hdcp: Add encoder check in intel_hdcp_get_capability

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Validate function returns

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    vxlan: use one headroom snapshot for neighbour replies

Maoyi Xie <maoyixie.tju@gmail.com>
    rds_tcp: close NULL deref window in rds_tcp_set_callbacks

Konrad Dybcio <konrad.dybcio@linaro.org>
    drm/msm/adreno: Assign msm_gpu->pdev earlier to avoid nullptrs

Benjamin Berg <benjamin.berg@intel.com>
    wifi: cfg80211: avoid double free if updating BSS fails

Mario Limonciello <mario.limonciello@amd.com>
    x86/CPU/AMD: Clear virtualized VMLOAD/VMSAVE on Zen4 client

David Arinzon <darinzon@amazon.com>
    net: ena: Add validation for completion descriptors consistency

Shay Drory <shayd@nvidia.com>
    net/mlx5e: Fix netif state handling

Jan Kara <jack@suse.cz>
    ocfs2: Avoid touching renamed directory if parent does not change

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Defer work in bpf_timer_cancel_and_free

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Fail bpf_timer_cancel when callback is being cancelled

Jun Yang <junvyyang@tencent.com>
    sctp: check RCV_SHUTDOWN after the sendmsg connect wait

Runyu Xiao <runyu.xiao@seu.edu.cn>
    rtc: spear: initialize IRQ state before requesting alarm IRQ

Ilkka Lappeteläinen <ilkka.lappetelainen@gmail.com>
    net/packet: prevent TX_RING byte count overflow

Aohan Mei <henrymei@tencent.com>
    netfilter: nft_flow_offload: drop flowtable reference on init error path

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of/overlay: only treat a positive changeset id as registered

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of/overlay: put property on deadprops only after changeset add succeeds

Wentao Liang <vulab@iscas.ac.cn>
    of/irq: Fix remaining refcount leaks in of_irq_init()

Leon Hwang <leon.hwang@linux.dev>
    kprobes: Skip disarmed probes when checking optkprobe overlap

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    audit: fix exe mark UAF in kill_rules()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Apply IGNORE_CTL_ERROR quirk to all Audient devices

Darrick J. Wong <djwong@kernel.org>
    xfs: fix cursor and pointer handling when recovering iunlink buckets

Zihan Xi <zihanx@nebusec.ai>
    smb: client: close completed creates on compound wait errors

Zihan Xi <zihanx@nebusec.ai>
    smb: client: close handle after create-context parsing failure

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: pass cifs_open_info_data to SMB2_open()

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: use stack-allocated smb2_file_all_info in smb3_query_mf_symlink()

Chen Changcheng <chenchangcheng@kylinos.cn>
    HID: alps: unregister DualPoint Stick input device on remove

Bastien Nocera <hadess@hadess.net>
    HID: hid-alps: Use pm_ptr instead of #ifdef CONFIG_PM

Marcus Folkesson <marcus.folkesson@gmail.com>
    HID: hid-alps: use default remove for hid device

Thomas Weißschuh <linux@weissschuh.net>
    HID: core: remove #ifdef CONFIG_PM from hid_driver

Tibor Harcsa <silurust@gmail.com>
    Bluetooth: btusb: Add IMC Networks QCA9377 to quirks table

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: mgmt: fix race in read_unconf_index_list()

Namjae Jeon <linkinjeon@kernel.org>
    smb: client: use finish_no_open() for non-regular inodes

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Fix GRT PEBS load/store direction for latency events, to fix sample classification

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Update event constraints and cache_extra_regsfor ADL

Aohan Mei <henrymei@tencent.com>
    netfilter: nf_tables: skip expired catchall elements on insert and delete

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: set->ops->insert returns opaque set element in case of EEXIST

Guangshuo Li <lgs201920130244@gmail.com>
    net: ena: fix MMIO read buffer leak on probe failure

Dr. David Alan Gilbert <linux@treblig.org>
    net: ena: Remove autopolling mode

Yuqi Xu <xuyuqiabc@gmail.com>
    net: ipconfig: bound DHCP option construction

Thorsten Blum <thorsten.blum@linux.dev>
    net: ipconfig: Remove outdated comment and indent code block

Liz Fong-Jones <lizf@honeycomb.io>
    PCI: Fix BAR resize for devices on a root bus

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Fix Resizable BAR restore order

Zihan Xi <zihanx@nebusec.ai>
    smb: client: fix create context out-of-bounds reads

Steve French <stfrench@microsoft.com>
    smb3: make query_on_disk_id open context consistent and move to common code

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: conntrack: fix helper UAF due to extensions realloc

Florian Westphal <fw@strlen.de>
    openvswitch: prepare for stolen verdict coming from conntrack and nat engine

Jaewook You <jaewook376@gmail.com>
    mm/hugetlb: preserve mremap address delta when skipping page tables

Jinjiang Tu <tujinjiang@huawei.com>
    mm/rmap: fix missing barrier between anon_vma init and vma->anon_vma publish

Waiman Long <longman@redhat.com>
    mm/kmemleak: fix UAF bug in kmemleak_scan()

Waiman Long <longman@redhat.com>
    mm/kmemleak: simplify kmemleak_cond_resched() usage

Henry Martin <bsdhenrymartin@gmail.com>
    tracing/user_events: Don't destroy fields when event removal fails

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Remove anythread_deprecated bit from perf_capabilities

Willem de Bruijn <willemb@google.com>
    tcp: prevent collapsing skbs across boundary in rtx queue

Myeonghun Pak <mhun512@gmail.com>
    bna: prevent IOC timer rearm during teardown

April Cardenas <april.cardenas@canonical.com>
    smb/client: send lease break ACKs thru correct session for multiuser mounts

Fan Wu <fanwu01@zju.edu.cn>
    wifi: wcn36xx: Fix potential use-after-free in TX ack timer teardown

Yibo Tan <lhfff@tju.edu.cn>
    hwmon: (pwm-fan) Stop RPM timer before freeing tach data

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: rtd119x: Avoid division by zero

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    watchdog: rtd119x: Use devm_clk_get_enabled() helper

Shakeel Butt <shakeel.butt@linux.dev>
    mm/mlock: use the IRQ-safe accessor for NR_MLOCK in __munlock_folio()

Hongling Zeng <zenghongling@kylinos.cn>
    btrfs: take commit root semaphore when iterating in mark_block_group_to_copy()

Fan Wu <fanwu01@zju.edu.cn>
    smb: client: fix cifsFileInfo reference leak in deferred close

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix file type corruption in cifs_reparse_point_to_fattr()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: reset retrans_time when ADD_ADDR entry is reused

Qing Luo <luoqing@kylinos.cn>
    mptcp: pm: userspace: fix address ID overflow

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: use sock_kmemdup for address entry

Geliang Tang <tanggeliang@kylinos.cn>
    sock: add sock_kmemdup helper

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: pm: drop match in userspace_pm_append_new_local_addr

Matthieu Baerts <matthieu.baerts@tessares.net>
    mptcp: userspace pm: use a single point of exit

Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
    erofs: preserve LZMA decoders on resize failure

Sahil Chandna <sahilchandna@linux.microsoft.com>
    net: mana: Reserve extra CQ slot for the fence completion CQE

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net/sched: act_api: release all action references on NEWACTION failure

Xiong Weimin <xiongweimin@kylinos.cn>
    virtio_mmio: disable IRQ wake before free_irq

Viresh Kumar <viresh.kumar@linaro.org>
    virtio-mmio: Remove virtqueue list from mmio device

Zihan Xi <zihanx@nebusec.ai>
    ipmr: account multicast table and route memory

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: simpledrm: Improve stride validation

Guanghui Yang <3497809730@qq.com>
    f2fs: fix dentry folio leak in find_in_level

Wenjie Qi <qwjhust@gmail.com>
    f2fs: limit recovery filename logging to stored length

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix soft lockup polling continuation IOCB signature

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Use memset_io() to clear QLAFX00 request ring slot

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Quiesce response IRQ before freeing request queue

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error path

Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
    media: rkvdec: Propagate platform_get_irq() errors

Johan Hovold <johan@kernel.org>
    media: platform: mtk-mdp3: fix NULL deref on failed SCP lookup

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP

Rupesh Majhi <zoone.rupert@gmail.com>
    iio: pressure: dps310: fix NULL pointer dereference on ACPI probe

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix NULL deref in status_show() during queue probe

Xu Rao <raoxu@uniontech.com>
    nvme-fabrics: fix DHCHAP secret leak on parse failure

Karl Mehltretter <kmehltretter@gmail.com>
    arm64: mm: Fix the lockless page-table walk in show_pte()

Hugh Dickins <hughd@google.com>
    arm64: allow pte_offset_map() to fail

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    rtc: rzn1: Handle unset alarm weekday in rzn1_rtc_read_alarm

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Synchronize the initialization of ftrace_ops

Muhammad Bilal <meatuni001@gmail.com>
    staging: sm750fb: fix mono image source stride mismatch in lynxfb_ops_imageblit()

Can Peng <pengcan@kylinos.cn>
    spi: bcm63xx: disable clock on resume failure

Yang Yingliang <yangyingliang@huawei.com>
    spi: bcm63xx: switch to use modern name

Jeffin Philip <jeffinphilip14@gmail.com>
    usb: gadget: f_mass_storage: fix null pointer dereference in fsg_common_set_num_buffers()

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix use-after-free of master->this

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Do not treat master device as a duplicate target

Can Peng <pengcan@kylinos.cn>
    hwrng: stm32 - Fix runtime PM cleanup on registration failure

Fan Wu <fanwu01@zju.edu.cn>
    mmc: via-sdmmc: cancel card-detect work on remove

Jianing Li <m13940358460@163.com>
    power: supply: max17040: drop incorrect I2C functionality check

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    power: supply: max17040: Convert to i2c's .probe_new()

Angel Iglesias <ang.iglesiasg@gmail.com>
    i2c: core: Introduce i2c_client_get_device_id helper function

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: rt9455: quiesce delayed work before teardown

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    power: supply: rt9455: Convert to i2c's .probe_new()

Oscar Ou <oscarou@synology.com>
    lockd: fix swapped arguments in nlmsvc_match_ip()

Ruoyu Wang <ruoyuw560@gmail.com>
    i2c: mxs: fix DMA channel leak on probe error

Bence Csókás <csokas.bence@prolan.hu>
    dmaengine: Add devm_dma_request_chan()

Jiacheng Yu <yujiacheng3@huawei.com>
    params: fix charp corruption on allocation failure

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    params: Fix multi-line comment style

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    params: Sort headers

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    params: Use size_add() for kmalloc()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    params: Do not go over the limit when getting the string length

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    kernel/params.c: Use kstrtobool() instead of strtobool()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: TAD: Add locking around AML evaluations

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: TAD: Split three functions to untangle runtime PM handling

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: TAD: Rearrange RT data validation checking

Hui Su <sh_def@163.com>
    kasan: fix cache shrink race with CPU hotplug

Zqiang <qiang1.zhang@intel.com>
    kasan: fix lockdep report invalid wait context

Kuan-Wei Chiu <visitorckw@gmail.com>
    coresight: etm3x: Fix cntr_val_show() to match cntr_val_store() behavior

Chuck Lever <chuck.lever@oracle.com>
    nfsd: gate nfs2 setacl by argp->mask

Jeff Layton <jlayton@kernel.org>
    nfsd: fix clock domain mismatch in clients_still_reclaiming()

Jeff Layton <jlayton@kernel.org>
    nfsd: check nfsd4_acl_to_attr() return value in nfsd4_create()

Chris Mason <clm@meta.com>
    nfsd: size fh_verify server sockaddr slot by xpt_locallen

Chris Mason <clm@meta.com>
    nfsd: release path refs on follow_down() error

Longlong Xia <xialonglong@kylinos.cn>
    zram: fix out-of-bounds access in read_block_state()

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: fixup read_block_state()

Chengfeng Ye <nicoyip.dev@gmail.com>
    KEYS: trusted: Fix TPM teardown ordering

Qing Ming <a0yami@mailbox.org>
    gtp: serialize PDP context updates

Breno Leitao <leitao@debian.org>
    usb: xhci: bail out of setup if the controller is inaccessible

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf test bpf: Address error about non-null argument for epoll_pwait 2nd arg

Namhyung Kim <namhyung@kernel.org>
    perf tools: Fix a asan issue in parse_events_multi_pmu_add()

Ilya Titov <ilya.titov@wirenboard.com>
    pinctrl: sunxi: keep a shadow copy of the data register output latches

Xiang Mei <xmei5@asu.edu>
    vlan: require the MAC header to be present in __vlan_insert_inner_tag()

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()

Joseph Qi <joseph.qi@linux.alibaba.com>
    smb: client: fix use-after-free of iface in cifs_try_adding_channels()

Daehyeon Ko <4ncienth@gmail.com>
    wifi: libipw: reject TKIP frames without a full MIC

Hyunwoo Kim <imv4bel@gmail.com>
    exec: Cleanup POSIX timers right after de_thread()

Xiang Mei <xmei5@asu.edu>
    ALSA: usb-audio: Clamp implicit feedback packet count to URB capacity

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Optimize the copy of packet sizes for implicit fb handling

Bjoern Doebel <doebel@amazon.de>
    smb: client: fix heap overflow in DACL owner/group rewrite

Norbert Szetei <norbert@doyensec.com>
    landlock: Fix use-after-free of the source's parent directory

Zhiling Zou <zhilinz@nebusec.ai>
    net: bridge: use option bits for CFM/MRP frame handlers

XingWang Xiang <v3rdant.xiang@gmail.com>
    genetlink: pin family module during policy dump

Xu Rao <raoxu@uniontech.com>
    Bluetooth: btqcomsmd: destroy RPMsg endpoints before freeing hci_dev

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Bluetooth: btqcomsmd: Convert to platform remove callback returning void

Chao Yu <chao@kernel.org>
    f2fs: embed f2fs_gc_kthread in f2fs_sb_info

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix use-after-free of qpair work on queue teardown

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Zero initialize data structures for inject_pfault_token

Tristan Madani <tristan@talencesecurity.com>
    nvme: add missing SRCU grace period in error path

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Take trace_array reference before accessing its ftrace_ops

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in rtw_restruct_wmm_ie()

Vivek BalachandharTN <vivek.balachandhar@gmail.com>
    staging: rtl8723bs: fix spacing around operators

Myeonghun Pak <mhun512@gmail.com>
    usb: storage: realtek_cr: fix use-after-free on disconnect

Fan Wu <fanwu01@zju.edu.cn>
    wifi: rtl8xxxu: fix use-after-free from rx_urb_wq on stop

Doruk Tan Ozturk <doruk@0sec.ai>
    ocfs2: validate directory-index entry counts when reading metadata

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: validate dx_root extent list fields during block read

Dave Airlie <airlied@redhat.com>
    nouveau/gem: reserve the bo in the info ioctl around the vma lookup

Doruk Tan Ozturk <doruk@0sec.ai>
    HID: sony: fix UAF of ghl_poke_timer / ghl_urb at driver unbind

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix OOB read/write from unvalidated DataOffset in coalesce_t2()

Michael Bommarito <michael.bommarito@gmail.com>
    ceph: bound copied dentry name length in NFS export get_name

Jeff Layton <jlayton@kernel.org>
    nfsd: fix nfsd_file leak on inter-server COPY setup failure

Hyunwoo Kim <imv4bel@gmail.com>
    apparmor: fix out-of-bounds write when null terminating a label vec

Arnd Bergmann <arnd@arndb.de>
    mips: unhide uasm_in_compat_space_p() declaration

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: don't loop on HUP with multiple references

Jens Axboe <axboe@kernel.dk>
    io_uring/timeout: don't lose a cancel as io-wq arms a timeout

Jens Axboe <axboe@kernel.dk>
    io_uring/timeout: don't flush with the sequence behind the last flush

Jens Axboe <axboe@kernel.dk>
    io_uring/timeout: don't put a sequence target behind the last flush

Juanlu Herrero <juanlu@fastmail.com>
    io_uring/poll: avoid retry wakeup loss when dropping ownership

Josef Bacik <josef@toxicpanda.com>
    io_uring: look up the file before queueing to io-wq

Josef Bacik <josef@toxicpanda.com>
    io_uring: don't pass restart error codes to userspace

Josef Bacik <josef@toxicpanda.com>
    io_uring/sqpoll: let the thread sleep on disabled rings

Josef Bacik <josef@toxicpanda.com>
    io_uring/timeout: don't skip over reached sequences

Josef Bacik <josef@toxicpanda.com>
    io_uring/poll: drop stale double poll entry on rearm

Josef Bacik <josef@toxicpanda.com>
    io_uring/wait: look at all CQ waiters on wake up

Josef Bacik <josef@toxicpanda.com>
    io_uring/cancel: let CANCEL_ALL find parked requests

Josef Bacik <josef@toxicpanda.com>
    io_uring/cancel: recognize "no timeout" on 32-bit

Josef Bacik <josef@toxicpanda.com>
    io_uring/cancel: don't forget that the work was running

Josef Bacik <josef@toxicpanda.com>
    io_uring/poll: don't lose a cancel as io-wq arms poll

Josef Bacik <josef@toxicpanda.com>
    io_uring/io-wq: let cancel find picked up hashed work

Josef Bacik <josef@toxicpanda.com>
    io_uring/io-wq: don't exit with a creation pending

Josef Bacik <josef@toxicpanda.com>
    io_uring/io-wq: don't strand work when a worker exits

Josef Bacik <josef@toxicpanda.com>
    io_uring: don't flood a cancelling task with task_work

Josef Bacik <josef@toxicpanda.com>
    io_uring/io-wq: don't hide a link from cancellations

Josef Bacik <josef@toxicpanda.com>
    io_uring/io-wq: don't lose the signal that ends work

Christian Brauner <brauner@kernel.org>
    io-wq: order the exit bit against worker creation task work


-------------

Diffstat:

 CREDITS                                            |    5 +
 Documentation/arm64/silicon-errata.rst             |    2 +
 Documentation/filesystems/index.rst                |    1 -
 Documentation/filesystems/ntfs.rst                 |  466 ---
 Documentation/networking/ip-sysctl.rst             |    6 +
 Documentation/networking/strparser.rst             |    2 +-
 Documentation/virt/kvm/api.rst                     |    6 +
 MAINTAINERS                                        |   11 +-
 Makefile                                           |   31 +-
 arch/alpha/include/asm/pgtable.h                   |   33 +-
 arch/alpha/include/asm/tlbflush.h                  |    4 +-
 arch/alpha/lib/Makefile                            |    1 -
 arch/alpha/mm/Makefile                             |    4 +-
 arch/alpha/mm/tlbflush.c                           |   96 +
 arch/arm/mm/flush.c                                |    2 +
 arch/arm64/Kconfig                                 |   30 +
 arch/arm64/include/asm/kvm_host.h                  |    2 -
 arch/arm64/kernel/Makefile                         |    3 +
 arch/arm64/kernel/cpu_errata.c                     |   24 +-
 arch/arm64/kernel/cpufeature.c                     |    2 +-
 arch/arm64/kernel/entry.S                          |   22 +-
 arch/arm64/kernel/ptrace.c                         |   50 +
 arch/arm64/kernel/signal.c                         |   25 +-
 arch/arm64/kernel/topology.c                       |   11 +-
 arch/arm64/kvm/arch_timer.c                        |    3 +-
 arch/arm64/kvm/arm.c                               |   18 +-
 arch/arm64/kvm/mmu.c                               |   25 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |    8 +
 arch/arm64/kvm/vgic/vgic.c                         |    9 +-
 arch/arm64/mm/fault.c                              |   15 +-
 arch/arm64/net/bpf_jit_comp.c                      |    2 +-
 arch/arm64/tools/cpucaps                           |    2 +-
 arch/loongarch/kernel/machine_kexec.c              |    5 +-
 arch/loongarch/kernel/module-sections.c            |   38 +-
 arch/loongarch/kernel/setup.c                      |    1 +
 arch/loongarch/kernel/smp.c                        |  129 +-
 arch/loongarch/mm/hugetlbpage.c                    |    3 +-
 arch/loongarch/net/bpf_jit.c                       |    5 +-
 arch/mips/Kbuild                                   |    6 -
 arch/mips/include/asm/uasm.h                       |    2 -
 arch/mips/kernel/ftrace.c                          |   25 +-
 arch/nios2/include/asm/checksum.h                  |    2 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h       |   16 +
 arch/powerpc/include/asm/xive.h                    |    4 +-
 arch/powerpc/kernel/iommu.c                        |    2 +-
 arch/powerpc/kernel/setup-common.c                 |    1 -
 arch/powerpc/kexec/ranges.c                        |   12 +-
 arch/powerpc/mm/book3s64/pgtable.c                 |   13 +-
 arch/powerpc/platforms/powernv/smp.c               |    8 +-
 arch/powerpc/platforms/pseries/iommu.c             |    3 +-
 arch/powerpc/platforms/pseries/smp.c               |    8 +-
 arch/powerpc/sysdev/xive/common.c                  |   10 +-
 arch/riscv/include/asm/asm-prototypes.h            |    1 -
 arch/riscv/include/asm/asm.h                       |   23 +
 arch/riscv/include/asm/processor.h                 |    1 +
 arch/riscv/include/asm/thread_info.h               |    4 -
 arch/riscv/kernel/asm-offsets.c                    |    6 +
 arch/riscv/kernel/entry.S                          |   79 +-
 arch/riscv/kernel/probes/kprobes_trampoline.S      |    3 +
 arch/riscv/kernel/traps.c                          |   30 +-
 arch/riscv/kvm/vmid.c                              |    2 +-
 arch/s390/appldata/appldata_base.c                 |  117 +-
 arch/s390/appldata/appldata_mem.c                  |    2 +-
 arch/s390/include/asm/appldata.h                   |    2 +-
 arch/s390/include/asm/cpu_mf.h                     |   53 -
 arch/s390/include/asm/dma.h                        |    2 +-
 arch/s390/include/asm/nmi.h                        |    3 +
 arch/s390/kernel/cpcmd.c                           |    2 +-
 arch/s390/kernel/dis.c                             |    2 +-
 arch/s390/kernel/nmi.c                             |    5 +-
 arch/s390/kernel/perf_cpum_sf.c                    |   52 +
 arch/s390/kernel/process.c                         |    2 +-
 arch/s390/kvm/interrupt.c                          |   24 +-
 arch/s390/kvm/kvm-s390.c                           |    7 +-
 arch/s390/kvm/priv.c                               |    3 +-
 arch/s390/lib/spinlock.c                           |    2 +-
 arch/s390/mm/fault.c                               |   15 +-
 arch/s390/mm/maccess.c                             |    2 +-
 arch/s390/pci/pci_sysfs.c                          |    3 +
 arch/sparc/kernel/Makefile                         |    1 -
 arch/sparc/lib/Makefile                            |    1 -
 arch/sparc/mm/Makefile                             |    1 -
 arch/sparc/prom/Makefile                           |    1 -
 arch/um/kernel/skas/syscall.c                      |   34 +-
 arch/x86/events/amd/core.c                         |   12 +-
 arch/x86/events/amd/lbr.c                          |    3 +-
 arch/x86/events/intel/core.c                       |   14 +-
 arch/x86/events/intel/ds.c                         |   48 +-
 arch/x86/events/intel/uncore_snbep.c               |    5 -
 arch/x86/events/perf_event.h                       |   12 +-
 arch/x86/kernel/alternative.c                      |   10 -
 arch/x86/kernel/cpu/amd.c                          |   11 +
 arch/x86/kernel/cpu/mce/severity.c                 |   12 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |   13 +-
 arch/x86/kernel/ftrace.c                           |    3 +-
 arch/x86/kvm/mmu/mmu.c                             |    4 +-
 arch/x86/kvm/svm/nested.c                          |   34 +-
 arch/x86/kvm/svm/sev.c                             |   33 +-
 arch/x86/kvm/svm/svm.c                             |   24 +-
 arch/x86/kvm/vmx/nested.c                          |    9 +-
 arch/x86/kvm/x86.c                                 |    5 +-
 arch/x86/kvm/x86.h                                 |    5 +-
 arch/x86/net/bpf_jit_comp.c                        |    4 +-
 arch/x86/pci/fixup.c                               |   89 +
 block/bfq-cgroup.c                                 |   15 +-
 block/bfq-iosched.c                                |    8 +-
 block/bfq-iosched.h                                |    2 +-
 block/blk-cgroup.c                                 |   18 +-
 block/blk-cgroup.h                                 |    2 +
 block/blk-core.c                                   |    1 +
 block/blk-iocost.c                                 |   25 +-
 block/blk-iolatency.c                              |   19 +-
 block/blk-mq.c                                     |   28 +-
 block/blk-rq-qos.c                                 |    2 +
 block/blk-rq-qos.h                                 |   18 +-
 block/blk-throttle.c                               |   15 +-
 block/blk-wbt.c                                    |    2 +
 block/ioprio.c                                     |    7 +-
 crypto/Kconfig                                     |    1 +
 crypto/af_alg.c                                    |    2 +
 crypto/algif_skcipher.c                            |    8 +-
 crypto/asymmetric_keys/restrict.c                  |    8 +-
 crypto/drbg.c                                      |   11 +-
 crypto/jitterentropy-kcapi.c                       |  195 +-
 crypto/jitterentropy.c                             |  143 +-
 crypto/jitterentropy.h                             |   10 +-
 drivers/acpi/acpi_tad.c                            |  188 +-
 drivers/acpi/battery.c                             |    8 +-
 drivers/acpi/bus.c                                 |   54 +-
 drivers/acpi/processor_idle.c                      |    4 +-
 drivers/android/binder.c                           |    3 +-
 drivers/ata/libata-core.c                          |    5 +-
 drivers/ata/libata-eh.c                            |    6 +
 drivers/ata/libata-scsi.c                          |   93 +
 drivers/ata/libata.h                               |    2 +
 drivers/ata/sata_dwc_460ex.c                       |    9 +-
 drivers/base/core.c                                |   38 +-
 drivers/block/drbd/drbd_receiver.c                 |    3 +
 drivers/block/loop.c                               |   40 +-
 drivers/block/nbd.c                                |    1 +
 drivers/block/null_blk/main.c                      |   16 +-
 drivers/block/ublk_drv.c                           |    4 +
 drivers/block/zram/zram_drv.c                      |   21 +-
 drivers/bluetooth/btintel.c                        |   15 +-
 drivers/bluetooth/btqcomsmd.c                      |   10 +-
 drivers/bluetooth/btusb.c                          |    4 +
 drivers/bus/mhi/ep/ring.c                          |   12 +-
 drivers/bus/mhi/host/pci_generic.c                 |   20 +-
 drivers/char/hw_random/core.c                      |  153 +-
 drivers/char/hw_random/stm32-rng.c                 |   12 +-
 drivers/clk/sunxi-ng/ccu-sun50i-h616.c             |   64 +-
 drivers/clocksource/samsung_pwm_timer.c            |   22 +-
 drivers/cpufreq/amd-pstate.c                       |    7 +-
 drivers/crypto/hisilicon/qm.c                      |   38 +-
 drivers/crypto/keembay/keembay-ocs-aes-core.c      |    4 +-
 drivers/crypto/qat/qat_common/adf_init.c           |   14 +
 drivers/crypto/stm32/stm32-cryp.c                  |    8 +-
 .../crypto/virtio/virtio_crypto_akcipher_algs.c    |   91 +-
 .../crypto/virtio/virtio_crypto_skcipher_algs.c    |   13 +-
 drivers/cxl/core/hdm.c                             |   48 +-
 drivers/cxl/core/mbox.c                            |   15 +-
 drivers/cxl/core/port.c                            |   23 +-
 drivers/cxl/core/region.c                          |   29 +-
 drivers/cxl/cxl.h                                  |    3 +-
 drivers/dma-buf/dma-buf.c                          |   15 +
 drivers/dma-buf/dma-heap.c                         |   80 +-
 drivers/dma-buf/udmabuf.c                          |   11 +-
 drivers/dma/dmaengine.c                            |   30 +
 drivers/dma/dw-edma/dw-edma-core.c                 |   90 +-
 drivers/dma/dw-edma/dw-edma-pcie.c                 |    3 +
 drivers/dma/dw-edma/dw-edma-v0-core.c              |   17 +
 drivers/dma/idxd/init.c                            |   36 +-
 drivers/dma/ti/k3-udma-glue.c                      |   15 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   14 +-
 drivers/edac/amd64_edac.c                          |    2 +-
 drivers/edac/igen6_edac.c                          |    6 +
 drivers/firewire/core-topology.c                   |   40 +-
 drivers/firmware/arm_ffa/driver.c                  |    4 +-
 drivers/firmware/arm_scmi/bus.c                    |  428 ++-
 drivers/firmware/arm_scmi/common.h                 |   66 +-
 drivers/firmware/arm_scmi/driver.c                 |  699 ++---
 drivers/firmware/arm_scmi/mailbox.c                |   32 +-
 drivers/firmware/arm_scmi/optee.c                  |    6 +-
 drivers/firmware/arm_scmi/smc.c                    |   18 +-
 drivers/firmware/arm_scmi/virtio.c                 |    4 +-
 drivers/firmware/efi/mokvar-table.c                |   42 +-
 drivers/gpio/gpio-exar.c                           |    2 +-
 drivers/gpio/gpio-mvebu.c                          |    6 +-
 drivers/gpio/gpio-mxc.c                            |  161 +-
 drivers/gpio/gpio-pca953x.c                        |   18 +-
 drivers/gpio/gpio-xilinx.c                         |    9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c            |   13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   27 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |    3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c       |   30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.h       |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |   79 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   42 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |   75 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.h            |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |  108 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   55 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |    2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |    2 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |   14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |   17 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c            |   54 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h            |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |   18 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   46 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h            |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   33 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c            |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |  137 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |   39 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  150 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h             |   21 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c          |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |   20 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c              |    9 +
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c             |   25 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c             |   24 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c              |   20 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |   24 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c             |    1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c             |    2 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c             |    1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c             |    1 +
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c             |    8 +-
 drivers/gpu/drm/amd/amdgpu/psp_v12_0.c             |    8 +-
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c             |   14 +-
 drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c           |   14 +-
 drivers/gpu/drm/amd/amdgpu/psp_v3_1.c              |    8 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c             |   25 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   23 +-
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c              |    2 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |    2 +
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |    4 +
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |    3 +
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |   58 +-
 drivers/gpu/drm/amd/amdgpu/vi.c                    |   21 +
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   13 +-
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              |   17 +
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |    5 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   14 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.h  |    2 +
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |   56 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |    4 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   24 +-
 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c        |   19 +-
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |   11 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   43 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |    2 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |    8 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |   10 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h |    8 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |   15 +-
 .../amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c |    2 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   19 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   14 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dpcd.c |    3 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |    2 +-
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c       |   40 +-
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h       |    3 +
 drivers/gpu/drm/amd/display/dc/dc_link.h           |    3 +
 drivers/gpu/drm/amd/display/dc/dc_types.h          |    2 +-
 drivers/gpu/drm/amd/display/dc/dce/Makefile        |    2 +-
 drivers/gpu/drm/amd/display/dc/dce/dmub_abm.c      |  282 +-
 drivers/gpu/drm/amd/display/dc/dce/dmub_abm_lcd.c  |  286 ++
 drivers/gpu/drm/amd/display/dc/dce/dmub_abm_lcd.h  |   46 +
 .../amd/display/dc/dce110/dce110_hw_sequencer.c    |    5 +-
 .../drm/amd/display/dc/dce112/dce112_resource.c    |    5 +-
 .../gpu/drm/amd/display/dc/dce60/dce60_resource.c  |    1 -
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |    4 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_hubbub.c    |    3 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c  |    3 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   17 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   12 +-
 .../drm/amd/display/dc/dcn201/dcn201_resource.c    |    4 +-
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c |   24 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |    3 +-
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c |    4 +-
 .../gpu/drm/amd/display/dc/dcn314/dcn314_optc.c    |    7 +
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c  |    7 +
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource.c  |    7 +-
 .../drm/amd/display/dc/dcn321/dcn321_resource.c    |    2 +-
 .../gpu/drm/amd/display/dc/dml/dcn302/dcn302_fpu.c |   10 +
 .../gpu/drm/amd/display/dc/dml/dcn303/dcn303_fpu.c |   10 +
 .../gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c   |   10 +
 .../gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c |   10 +
 drivers/gpu/drm/amd/display/dc/inc/hw/abm.h        |    4 +
 .../gpu/drm/amd/display/dc/link/link_hwss_dio.c    |    5 +-
 .../gpu/drm/amd/display/dc/link/link_hwss_hpo_dp.c |    3 +-
 drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h    |   18 +
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |    2 +
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |   39 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |   10 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomfwctrl.c  |   11 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |    7 +-
 drivers/gpu/drm/aspeed/aspeed_gfx_drv.c            |    5 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |   22 +-
 drivers/gpu/drm/display/drm_dp_helper.c            |    4 +-
 drivers/gpu/drm/drm_fb_helper.c                    |    8 +-
 drivers/gpu/drm/etnaviv/etnaviv_sched.c            |   13 +-
 drivers/gpu/drm/gud/gud_pipe.c                     |    1 +
 drivers/gpu/drm/i915/display/icl_dsi.c             |    4 +-
 drivers/gpu/drm/i915/display/intel_bios.c          |   36 +-
 drivers/gpu/drm/i915/display/intel_dmc.c           |   21 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |    8 +-
 drivers/gpu/drm/i915/display/intel_hdcp.c          |   14 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |    2 +-
 .../gpu/drm/i915/gt/intel_execlists_submission.c   |   34 +-
 drivers/gpu/drm/i915/gt/intel_rps.c                |    3 +-
 drivers/gpu/drm/lima/lima_sched.c                  |   13 +-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |    3 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |    2 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h   |    4 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c   |   33 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   |   35 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c    |   11 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c  |    4 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |    3 +-
 drivers/gpu/drm/msm/msm_gpu.c                      |   31 +-
 drivers/gpu/drm/msm/msm_ringbuffer.c               |   22 +-
 drivers/gpu/drm/msm/msm_ringbuffer.h               |    1 +
 drivers/gpu/drm/nouveau/include/nvkm/core/client.h |    1 +
 drivers/gpu/drm/nouveau/nouveau_chan.c             |    9 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   11 +-
 drivers/gpu/drm/nouveau/nvkm/core/client.c         |    1 +
 drivers/gpu/drm/nouveau/nvkm/core/object.c         |   26 +-
 drivers/gpu/drm/panfrost/panfrost_job.c            |   16 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |   13 +-
 drivers/gpu/drm/radeon/radeon_bios.c               |    6 +-
 drivers/gpu/drm/radeon/radeon_fb.c                 |    9 +-
 drivers/gpu/drm/radeon/radeon_gem.c                |    4 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |    4 +
 drivers/gpu/drm/scheduler/sched_main.c             |   33 +-
 drivers/gpu/drm/tegra/gr2d.c                       |    8 +-
 drivers/gpu/drm/tegra/gr3d.c                       |    8 +-
 drivers/gpu/drm/tiny/simpledrm.c                   |   10 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |  106 +-
 drivers/gpu/drm/vc4/vc4_bo.c                       |   13 +-
 drivers/gpu/drm/vc4/vc4_drv.c                      |    5 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |    2 +-
 drivers/gpu/drm/vc4/vc4_v3d.c                      |   10 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |    6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   22 +-
 drivers/gpu/drm/xlnx/zynqmp_dpsub.c                |    2 +-
 drivers/hid/hid-alps.c                             |   21 +-
 drivers/hid/hid-core.c                             |   38 +-
 drivers/hid/hid-logitech-hidpp.c                   |   27 +-
 drivers/hid/hid-mcp2221.c                          |   17 +-
 drivers/hid/hid-nintendo.c                         |   46 +-
 drivers/hid/hid-sony.c                             |   36 +-
 drivers/hid/hid-steam.c                            |  243 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |    7 +-
 drivers/hid/intel-ish-hid/ishtp/bus.c              |    2 +
 drivers/hid/intel-ish-hid/ishtp/client.c           |    4 +-
 drivers/hid/uhid.c                                 |    8 +-
 drivers/hid/usbhid/hid-core.c                      |   11 +-
 drivers/hv/channel_mgmt.c                          |   12 +-
 drivers/hv/connection.c                            |    1 -
 drivers/hv/vmbus_drv.c                             |   16 +-
 drivers/hwmon/drivetemp.c                          |   10 +-
 drivers/hwmon/lm90.c                               |   26 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |   60 +-
 drivers/hwmon/pwm-fan.c                            |   13 +-
 drivers/hwmon/sht3x.c                              |    9 +-
 .../hwtracing/coresight/coresight-etm3x-sysfs.c    |   15 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |   83 +-
 drivers/hwtracing/coresight/coresight-platform.c   |   48 +-
 drivers/hwtracing/coresight/coresight-syscfg.c     |    2 +
 drivers/i2c/busses/i2c-at91-master.c               |    8 +-
 drivers/i2c/busses/i2c-mxs.c                       |    5 +-
 drivers/i2c/busses/i2c-qcom-cci.c                  |    4 +-
 drivers/i2c/busses/i2c-wmt.c                       |    2 +-
 drivers/i2c/i2c-core-base.c                        |   14 +
 drivers/i3c/master.c                               |   58 +-
 drivers/i3c/master/mipi-i3c-hci/core.c             |    2 +
 drivers/i3c/master/mipi-i3c-hci/dma.c              |   27 +-
 drivers/i3c/master/mipi-i3c-hci/hci.h              |    1 +
 drivers/iio/accel/kxcjk-1013.c                     |    2 +-
 drivers/iio/accel/sca3000.c                        |    2 +-
 drivers/iio/accel/st_accel_core.c                  |   10 +-
 drivers/iio/adc/ad_sigma_delta.c                   |   26 +-
 drivers/iio/adc/aspeed_adc.c                       |   13 +-
 drivers/iio/adc/axp288_adc.c                       |    8 +
 drivers/iio/adc/max1363.c                          |    8 +
 drivers/iio/adc/stm32-adc.c                        |   13 +-
 drivers/iio/adc/sun4i-gpadc-iio.c                  |   10 +-
 drivers/iio/adc/xilinx-xadc-core.c                 |    9 +-
 drivers/iio/cdc/ad7150.c                           |    8 +-
 drivers/iio/common/st_sensors/st_sensors_core.c    |   72 +-
 drivers/iio/common/st_sensors/st_sensors_trigger.c |   20 +-
 drivers/iio/frequency/admv1013.c                   |    2 +-
 drivers/iio/gyro/adis16136.c                       |    2 +-
 drivers/iio/imu/adis16400.c                        |    2 +-
 drivers/iio/imu/adis16480.c                        |    4 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |   18 +-
 drivers/iio/imu/st_lsm9ds0/st_lsm9ds0_core.c       |   65 +-
 drivers/iio/industrialio-buffer.c                  |    5 +-
 drivers/iio/industrialio-trigger.c                 |    2 +
 drivers/iio/light/gp2ap020a00f.c                   |    2 +
 drivers/iio/light/ltrf216a.c                       |   13 +-
 drivers/iio/pressure/bmp280-core.c                 |    2 +-
 drivers/iio/pressure/dps310.c                      |    2 +-
 drivers/iio/proximity/isl29501.c                   |    2 +-
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c  |    4 +-
 drivers/iio/proximity/sx9324.c                     |    2 +-
 drivers/iio/proximity/vcnl3020.c                   |   24 +-
 drivers/infiniband/core/counters.c                 |    9 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |    2 +
 drivers/infiniband/hw/cxgb4/mem.c                  |   46 +-
 drivers/infiniband/hw/erdma/erdma_cm.c             |    6 +-
 drivers/infiniband/hw/erdma/erdma_eq.c             |    3 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c          |   23 +-
 drivers/infiniband/hw/erdma/erdma_verbs.h          |   15 +
 drivers/infiniband/hw/hns/hns_roce_cq.c            |    6 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |    1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  130 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |    5 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |    6 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |    2 +-
 drivers/infiniband/hw/irdma/hw.c                   |    7 +-
 drivers/infiniband/hw/irdma/main.h                 |    3 +-
 drivers/infiniband/hw/irdma/utils.c                |   12 +-
 drivers/infiniband/hw/irdma/verbs.c                |   21 +-
 drivers/infiniband/hw/mlx5/cq.c                    |   11 +-
 drivers/infiniband/hw/mlx5/main.c                  |   55 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   35 +-
 drivers/infiniband/hw/mlx5/mr.c                    |  385 ++-
 drivers/infiniband/hw/mlx5/odp.c                   |   59 +-
 drivers/infiniband/hw/mlx5/umr.c                   |   87 +-
 drivers/infiniband/sw/rdmavt/vt.c                  |    4 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |    9 +
 drivers/infiniband/sw/rxe/rxe_srq.c                |    7 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |   48 +-
 drivers/infiniband/sw/siw/siw_qp_tx.c              |    2 +
 drivers/input/keyboard/atkbd.c                     |    8 +
 drivers/input/keyboard/lkkbd.c                     |    2 +
 drivers/input/mouse/alps.c                         |    2 +
 drivers/input/mouse/synaptics.c                    |    7 +-
 drivers/input/serio/i8042-acpipnpio.h              |    9 +
 drivers/input/touchscreen/s6sy761.c                |   14 +-
 drivers/interconnect/core.c                        |   16 +-
 drivers/iommu/amd/iommu.c                          |   43 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   46 +-
 drivers/iommu/intel/dmar.c                         |   22 +-
 drivers/iommu/intel/iommu.c                        |   28 +-
 drivers/iommu/intel/iommu.h                        |    6 +-
 drivers/iommu/intel/pasid.c                        |   22 +-
 drivers/iommu/msm_iommu.c                          |    9 +-
 drivers/leds/leds-an30259a.c                       |   14 +-
 drivers/mailbox/arm_mhu.c                          |    1 +
 drivers/mailbox/arm_mhu_db.c                       |    1 -
 drivers/mailbox/hi3660-mailbox.c                   |    1 +
 drivers/mailbox/hi6220-mailbox.c                   |    1 +
 drivers/mailbox/imx-mailbox.c                      |    3 +-
 drivers/mailbox/mailbox-mpfs.c                     |    1 +
 drivers/mailbox/mailbox.c                          |    1 +
 drivers/mailbox/mtk-adsp-mailbox.c                 |    3 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |    2 +-
 drivers/mailbox/omap-mailbox.c                     |    2 +-
 drivers/mailbox/platform_mhu.c                     |    1 +
 drivers/mailbox/rockchip-mailbox.c                 |    2 +-
 drivers/mailbox/sprd-mailbox.c                     |    2 +-
 drivers/mailbox/stm32-ipcc.c                       |    1 +
 drivers/mailbox/tegra-hsp.c                        |    1 -
 drivers/mailbox/zynqmp-ipi-mailbox.c               |  137 +-
 drivers/md/dm-bio-prison-v1.c                      |    6 +-
 drivers/md/dm-bufio.c                              |   30 +-
 drivers/md/dm-cache-metadata.c                     |    7 +-
 drivers/md/dm-cache-target.c                       |  129 +-
 drivers/md/dm-crypt.c                              |   17 +-
 drivers/md/dm-ebs-target.c                         |    5 +-
 drivers/md/dm-era-target.c                         |   58 +-
 drivers/md/dm-exception-store.h                    |   44 +-
 drivers/md/dm-integrity.c                          |    5 +-
 drivers/md/dm-io.c                                 |   24 +-
 drivers/md/dm-ioctl.c                              |   99 +-
 drivers/md/dm-kcopyd.c                             |   20 +-
 drivers/md/dm-log.c                                |   24 +-
 drivers/md/dm-mpath.c                              |   33 +-
 drivers/md/dm-path-selector.h                      |   27 +-
 drivers/md/dm-ps-queue-length.c                    |    4 +-
 drivers/md/dm-ps-round-robin.c                     |   13 +-
 drivers/md/dm-ps-service-time.c                    |    8 +-
 drivers/md/dm-raid.c                               |   12 +-
 drivers/md/dm-raid1.c                              |   46 +-
 drivers/md/dm-region-hash.c                        |    6 +-
 drivers/md/dm-snap-persistent.c                    |    8 +-
 drivers/md/dm-snap-transient.c                     |    8 +-
 drivers/md/dm-snap.c                               |   27 +-
 drivers/md/dm-table.c                              |    2 +-
 drivers/md/dm-thin-metadata.c                      |   20 +-
 drivers/md/dm-thin.c                               |   24 +-
 drivers/md/dm-uevent.c                             |    2 +-
 drivers/md/dm-verity-fec.c                         |    4 +-
 drivers/md/dm.c                                    |   12 +-
 drivers/md/dm.h                                    |   12 +-
 drivers/md/md-cluster.c                            |   11 +-
 drivers/md/md.c                                    |    3 +-
 drivers/md/persistent-data/dm-array.c              |   37 +-
 drivers/md/persistent-data/dm-block-manager.c      |    6 +-
 drivers/md/persistent-data/dm-btree.c              |    6 +-
 drivers/md/raid1.c                                 |   12 +-
 drivers/md/raid10.c                                |   72 +-
 drivers/md/raid5.c                                 |   12 +-
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |    1 +
 drivers/media/pci/ivtv/ivtvfb.c                    |    4 +-
 .../media/platform/mediatek/mdp3/mtk-mdp3-core.c   |    5 +
 .../mediatek/vcodec/vdec/vdec_h264_req_if.c        |    9 +-
 .../platform/mediatek/vcodec/venc/venc_h264_if.c   |    5 +-
 drivers/media/platform/verisilicon/hantro.h        |    2 +
 drivers/media/platform/verisilicon/hantro_drv.c    |   89 +-
 drivers/media/platform/verisilicon/imx8m_vpu_hw.c  |    8 +
 drivers/media/test-drivers/vivid/vivid-core.c      |    4 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   23 +
 drivers/memstick/core/memstick.c                   |    8 +-
 drivers/memstick/host/rtsx_usb_ms.c                |   31 +-
 drivers/mfd/sm501.c                                |   18 +-
 drivers/misc/habanalabs/common/habanalabs.h        |    5 -
 drivers/misc/habanalabs/common/memory.c            |  236 +-
 drivers/misc/habanalabs/gaudi/gaudi.c              |   19 +
 drivers/misc/habanalabs/gaudi2/gaudi2.c            |    7 +
 drivers/misc/sgi-gru/grufault.c                    |  101 +-
 drivers/misc/sgi-gru/gruprocfs.c                   |    1 -
 drivers/misc/sgi-gru/grutables.h                   |    1 -
 drivers/mmc/host/cavium-octeon.c                   |    5 +-
 drivers/mmc/host/cavium-thunderx.c                 |    5 +-
 drivers/mmc/host/mtk-sd.c                          |    1 +
 drivers/mmc/host/sdhci-sprd.c                      |    4 +
 drivers/mmc/host/via-sdmmc.c                       |    4 +
 drivers/mtd/devices/block2mtd.c                    |    2 +-
 drivers/mtd/maps/vmu-flash.c                       |   12 +-
 drivers/mtd/mtdcore.c                              |  124 +-
 drivers/mtd/mtdcore.h                              |    1 +
 drivers/mtd/mtdpart.c                              |   14 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |    6 +-
 drivers/mtd/nand/raw/vf610_nfc.c                   |   85 +-
 drivers/mtd/nand/spi/core.c                        |   37 +-
 drivers/net/amt.c                                  |   51 +-
 drivers/net/bonding/bond_main.c                    |   70 +-
 drivers/net/can/dev/skb.c                          |    2 +
 drivers/net/can/usb/gs_usb.c                       |  159 +-
 drivers/net/dsa/b53/b53_common.c                   |    8 +-
 drivers/net/dsa/microchip/ksz_common.h             |    2 +-
 drivers/net/ethernet/amazon/ena/ena_com.c          |   25 +-
 drivers/net/ethernet/amazon/ena/ena_com.h          |   14 -
 drivers/net/ethernet/amazon/ena/ena_eth_com.c      |   37 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |    3 +
 drivers/net/ethernet/amazon/ena/ena_regs_defs.h    |    1 +
 drivers/net/ethernet/broadcom/bcmsysport.c         |    4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   70 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |    1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |    2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   15 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |   16 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |   27 -
 .../net/ethernet/cavium/liquidio/octeon_device.h   |    3 -
 .../net/ethernet/cavium/liquidio/octeon_mailbox.c  |   33 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |    4 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |    3 +
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   10 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |   79 +-
 drivers/net/ethernet/ibm/ibmveth.h                 |    1 -
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |   31 +-
 drivers/net/ethernet/intel/ice/ice.h               |    2 +
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |    2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   18 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   66 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   70 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h           |    8 +
 drivers/net/ethernet/intel/ice/ice_txrx.c          |    6 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |    3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    3 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   12 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |    1 +
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |    4 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |    2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   79 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   22 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   69 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   20 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |    2 +-
 drivers/net/ethernet/mellanox/mlx4/srq.c           |   14 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |   23 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   12 +
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c |   10 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |    6 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |   16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   38 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |    9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   13 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |    4 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   30 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |   17 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   12 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |    4 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   28 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   78 +-
 .../ethernet/microchip/lan966x/lan966x_ethtool.c   |   18 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |    2 -
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |    4 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |    1 +
 .../net/ethernet/microchip/sparx5/sparx5_main.h    |    1 +
 .../net/ethernet/microchip/sparx5/sparx5_netdev.c  |    1 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   13 +-
 drivers/net/ethernet/mscc/ocelot_stats.c           |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c   |  467 +--
 drivers/net/ethernet/renesas/ravb_main.c           |    8 +-
 drivers/net/ethernet/renesas/ravb_ptp.c            |   37 +-
 drivers/net/ethernet/sfc/ef100_netdev.c            |    6 +-
 drivers/net/ethernet/sfc/ef100_nic.c               |   47 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   56 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   15 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c   |   15 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c    |   15 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   15 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |    2 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  125 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  191 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |    8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   18 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |    4 +-
 drivers/net/gtp.c                                  |   18 +-
 drivers/net/hyperv/netvsc.c                        |   20 +-
 drivers/net/ieee802154/mac802154_hwsim.c           |    9 +-
 drivers/net/phy/phy_device.c                       |   19 +-
 drivers/net/tap.c                                  |   55 +-
 drivers/net/team/team.c                            |  161 +-
 drivers/net/team/team_mode_loadbalance.c           |    4 +-
 drivers/net/thunderbolt.c                          |   12 +
 drivers/net/usb/ax88179_178a.c                     |    6 +-
 drivers/net/usb/qmi_wwan.c                         |    1 +
 drivers/net/vxlan/vxlan_core.c                     |   44 +-
 drivers/net/vxlan/vxlan_private.h                  |    4 +-
 drivers/net/wireguard/noise.c                      |    7 +-
 drivers/net/wireguard/queueing.h                   |    2 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   10 +-
 drivers/net/wireless/ath/ath11k/mac.c              |    1 +
 drivers/net/wireless/ath/ath11k/mhi.c              |    6 +-
 drivers/net/wireless/ath/ath11k/pci.c              |    7 +
 drivers/net/wireless/ath/ath11k/wmi.c              |   29 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   27 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |    4 +
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |    1 +
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   28 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    3 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   47 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |    9 +-
 drivers/net/wireless/intersil/p54/fwio.c           |   42 +-
 drivers/net/wireless/marvell/libertas/tx.c         |    7 -
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |    4 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |    5 +
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   33 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |    1 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   17 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   15 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |    8 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    2 +
 drivers/net/wireless/mediatek/mt76/tx.c            |    1 -
 drivers/net/wireless/microchip/wilc1000/wlan_cfg.c |   37 +-
 drivers/net/wireless/microchip/wilc1000/wlan_cfg.h |    5 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   19 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |  303 +-
 drivers/net/wireless/realtek/rtw88/debug.h         |    2 +
 drivers/net/wireless/realtek/rtw88/main.c          |   20 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    3 +-
 drivers/net/wireless/realtek/rtw89/core.c          |    8 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   11 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |    7 +-
 drivers/net/wireless/silabs/wfx/hif_tx.c           |    4 +-
 drivers/net/wireless/st/cw1200/bh.c                |    8 +-
 drivers/net/wireless/st/cw1200/txrx.c              |   14 +
 drivers/net/wireless/ti/wl12xx/main.c              |    6 +-
 drivers/net/wireless/ti/wl18xx/main.c              |    2 +-
 drivers/net/wireless/ti/wlcore/main.c              |   10 +-
 drivers/net/wireless/ti/wlcore/wlcore.h            |    2 +-
 drivers/net/xen-netfront.c                         |   16 +-
 drivers/ntb/ntb_transport.c                        |   18 +-
 drivers/nvdimm/nd_virtio.c                         |   32 +-
 drivers/nvdimm/virtio_pmem.h                       |    2 +
 drivers/nvme/host/apple.c                          |   38 +-
 drivers/nvme/host/core.c                           |    3 +
 drivers/nvme/host/fabrics.c                        |    8 +-
 drivers/nvme/host/fc.c                             |    7 +-
 drivers/nvme/host/multipath.c                      |    5 +-
 drivers/nvme/host/pci.c                            |   18 +-
 drivers/nvme/host/rdma.c                           |    8 +-
 drivers/nvme/host/tcp.c                            |   33 +-
 drivers/nvme/target/admin-cmd.c                    |   31 +-
 drivers/nvme/target/auth.c                         |   20 +-
 drivers/nvme/target/configfs.c                     |    9 +-
 drivers/nvme/target/core.c                         |   94 +-
 drivers/nvme/target/discovery.c                    |   37 +-
 drivers/nvme/target/fabrics-cmd-auth.c             |  100 +-
 drivers/nvme/target/fabrics-cmd.c                  |   56 +-
 drivers/nvme/target/nvmet.h                        |   23 +-
 drivers/nvme/target/rdma.c                         |    1 +
 drivers/nvme/target/tcp.c                          |    8 +
 drivers/of/irq.c                                   |   14 +-
 drivers/of/overlay.c                               |   17 +-
 drivers/of/unittest.c                              |    7 +-
 drivers/opp/core.c                                 |    6 +-
 drivers/pci/controller/dwc/pcie-designware-ep.c    |   20 +
 drivers/pci/endpoint/functions/pci-epf-ntb.c       |    5 +
 drivers/pci/endpoint/functions/pci-epf-test.c      |   16 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |    5 +
 drivers/pci/hotplug/pnv_php.c                      |    2 +-
 drivers/pci/hotplug/rpaphp_slot.c                  |    2 +-
 drivers/pci/pci-driver.c                           |  187 +-
 drivers/pci/pci-sysfs.c                            |  125 +-
 drivers/pci/pci.c                                  |   20 +-
 drivers/pci/pci.h                                  |   41 +-
 drivers/pci/rebar.c                                |   19 +-
 drivers/pci/search.c                               |    4 +-
 drivers/pci/setup-bus.c                            |   56 +-
 drivers/pci/slot.c                                 |   46 +-
 drivers/perf/riscv_pmu_legacy.c                    |    5 +-
 drivers/perf/riscv_pmu_sbi.c                       |  103 +-
 drivers/phy/qualcomm/phy-qcom-qusb2.c              |   16 +-
 drivers/pinctrl/core.c                             |    3 +
 drivers/pinctrl/core.h                             |    1 +
 drivers/pinctrl/freescale/pinctrl-scu.c            |    3 +-
 drivers/pinctrl/mediatek/pinctrl-moore.c           |    6 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |   14 +-
 drivers/pinctrl/mediatek/pinctrl-paris.c           |    7 +-
 drivers/pinctrl/pinctrl-amd.c                      |    9 +
 drivers/pinctrl/pinmux.c                           |  175 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   88 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.h              |    7 +
 drivers/platform/x86/amd/pmc.c                     |   26 +-
 drivers/platform/x86/asus-wmi.c                    |    6 +-
 drivers/platform/x86/dell/dell-laptop.c            |   28 +-
 drivers/platform/x86/dell/dell-smbios-base.c       |   25 +
 drivers/platform/x86/dell/dell-smbios.h            |    5 +
 drivers/platform/x86/dell/dell-wmi-base.c          |    2 +-
 drivers/platform/x86/huawei-wmi.c                  |    4 +-
 drivers/platform/x86/intel/int1092/intel_sar.c     |   39 +-
 drivers/platform/x86/lg-laptop.c                   |   26 +-
 drivers/platform/x86/system76_acpi.c               |    4 +-
 drivers/platform/x86/thinkpad_acpi.c               |    4 +-
 drivers/platform/x86/toshiba_acpi.c                |    4 +-
 drivers/platform/x86/x86-android-tablets.c         |    6 +-
 drivers/power/supply/charger-manager.c             |   60 +-
 drivers/power/supply/ds2780_battery.c              |    2 +-
 drivers/power/supply/lp8788-charger.c              |   29 +-
 drivers/power/supply/max17040_battery.c            |   37 +-
 drivers/power/supply/rt9455_charger.c              |   26 +-
 drivers/ptp/ptp_ocp.c                              |    3 +-
 drivers/ptp/ptp_private.h                          |    1 +
 drivers/ptp/ptp_sysfs.c                            |    2 +-
 drivers/pwm/pwm-samsung.c                          |   22 +-
 drivers/regulator/ltc3676.c                        |   15 +-
 drivers/remoteproc/qcom_wcnss.c                    |   23 +-
 drivers/rtc/dev.c                                  |    2 +-
 drivers/rtc/rtc-mpfs.c                             |    6 +-
 drivers/rtc/rtc-rzn1.c                             |   16 +-
 drivers/rtc/rtc-spear.c                            |   11 +-
 drivers/s390/block/dasd_diag.c                     |    2 +-
 drivers/s390/block/dasd_eckd.c                     |   15 +-
 drivers/s390/block/dasd_fba.c                      |    2 +-
 drivers/s390/block/dcssblk.c                       |    2 +-
 drivers/s390/char/con3215.c                        |    2 +-
 drivers/s390/char/monwriter.c                      |    2 +-
 drivers/s390/cio/vfio_ccw_cp.c                     |   13 +
 drivers/s390/cio/vfio_ccw_cp.h                     |    8 +
 drivers/s390/crypto/pkey_api.c                     |  120 +-
 drivers/s390/crypto/vfio_ap_ops.c                  |  142 +-
 drivers/s390/crypto/zcrypt_api.c                   |    3 +
 drivers/s390/crypto/zcrypt_ccamisc.c               |   64 +-
 drivers/s390/crypto/zcrypt_ccamisc.h               |    6 +-
 drivers/s390/net/ctcm_mpc.c                        |   13 +-
 drivers/s390/net/ism.h                             |    2 +
 drivers/s390/net/ism_drv.c                         |   45 +-
 drivers/s390/net/netiucv.c                         |    2 +-
 drivers/s390/virtio/virtio_ccw.c                   |    4 -
 drivers/scsi/ch.c                                  |   30 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |    4 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   48 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  279 +-
 drivers/scsi/hosts.c                               |    2 +
 drivers/scsi/imm.c                                 |    1 +
 drivers/scsi/iscsi_tcp.c                           |    1 +
 drivers/scsi/libiscsi.c                            |   14 +-
 drivers/scsi/libsas/sas_expander.c                 |   14 +-
 drivers/scsi/lpfc/lpfc_init.c                      |    2 +-
 drivers/scsi/mpi3mr/mpi3mr.h                       |   11 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |   11 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  148 +-
 drivers/scsi/qedi/qedi_main.c                      |    3 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |   47 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   17 +
 drivers/scsi/qla2xxx/qla_iocb.c                    |   12 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |   25 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |    6 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |   41 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   10 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   33 +-
 drivers/scsi/qla2xxx/qla_target.c                  |    5 +-
 drivers/scsi/qla2xxx/qla_target.h                  |    1 +
 drivers/scsi/scsi_error.c                          |   28 +-
 drivers/scsi/scsi_priv.h                           |    1 +
 drivers/scsi/sd.c                                  |   25 +-
 drivers/scsi/st.c                                  |   18 +-
 drivers/scsi/xen-scsifront.c                       |    1 +
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |   33 +-
 drivers/soc/imx/imx8m-blk-ctrl.c                   |   34 +-
 drivers/soc/imx/imx8mp-blk-ctrl.c                  |   18 +-
 drivers/soc/imx/imx93-blk-ctrl.c                   |   54 +-
 drivers/soc/qcom/icc-bwmon.c                       |    2 +
 drivers/soc/rockchip/pm_domains.c                  |   20 +-
 drivers/soc/xilinx/zynqmp_power.c                  |   10 +-
 drivers/soundwire/generic_bandwidth_allocation.c   |   35 +-
 drivers/spi/spi-bcm63xx.c                          |   72 +-
 drivers/spi/spi-davinci.c                          |    5 +-
 drivers/spi/spi-dw-dma.c                           |    2 +-
 drivers/spi/spi-fsl-lpspi.c                        |    9 +-
 drivers/spi/spi-fsl-qspi.c                         |   42 +-
 drivers/spi/spi-fsl-spi.c                          |   97 +-
 drivers/spi/spi-hisi-kunpeng.c                     |   95 +-
 drivers/spi/spi-microchip-core-qspi.c              |   79 +-
 drivers/spi/spi-microchip-core.c                   |    4 +
 drivers/spi/spi-mpc52xx.c                          |   66 +-
 drivers/spi/spi-oc-tiny.c                          |   24 +-
 drivers/spi/spi-qcom-qspi.c                        |   45 +-
 drivers/spi/spi-rockchip.c                         |    2 +-
 drivers/spi/spi-rspi.c                             |   14 +-
 drivers/spi/spi-tegra114.c                         |    7 +
 drivers/spi/spi-tegra210-quad.c                    |   20 +
 drivers/staging/greybus/raw.c                      |   90 +-
 drivers/staging/greybus/uart.c                     |    3 +-
 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c |   29 +-
 .../media/deprecated/saa7146/av7110/av7110.h       |    4 +-
 .../media/deprecated/saa7146/av7110/av7110_ca.c    |   26 +-
 drivers/staging/media/rkvdec/rkvdec.c              |    4 +-
 drivers/staging/most/Kconfig                       |    2 -
 drivers/staging/most/Makefile                      |    1 -
 drivers/staging/most/i2c/Kconfig                   |   13 -
 drivers/staging/most/i2c/Makefile                  |    4 -
 drivers/staging/most/i2c/i2c.c                     |  371 ---
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |    5 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |   22 +-
 drivers/staging/sm750fb/sm750.c                    |    2 +-
 drivers/staging/sm750fb/sm750.h                    |    2 +-
 drivers/staging/sm750fb/sm750_accel.c              |    6 +-
 drivers/staging/sm750fb/sm750_accel.h              |    4 +-
 drivers/target/iscsi/iscsi_target_configfs.c       |   26 +-
 drivers/tee/optee/ffa_abi.c                        |   16 +-
 drivers/tee/optee/smc_abi.c                        |   17 +-
 drivers/thermal/thermal_hwmon.c                    |   89 +-
 drivers/thunderbolt/ctl.c                          |   63 +-
 drivers/thunderbolt/quirks.c                       |    3 +
 drivers/thunderbolt/xdomain.c                      |    4 +
 drivers/tty/amiserial.c                            |    9 +-
 drivers/tty/n_gsm.c                                |   90 +-
 drivers/tty/pty.c                                  |    2 +-
 drivers/tty/serial/8250/8250_bcm7271.c             |    2 +-
 drivers/tty/serial/8250/8250_core.c                |    2 +-
 drivers/tty/serial/imx.c                           |   26 +-
 drivers/tty/serial/kgdboc.c                        |    9 +
 drivers/tty/serial/max3100.c                       |   13 +-
 drivers/tty/serial/qcom_geni_serial.c              |    5 +-
 drivers/tty/serial/sc16is7xx.c                     |   22 +-
 drivers/tty/serial/serial-tegra.c                  |   18 +-
 drivers/tty/serial/serial_core.c                   |   48 +-
 drivers/tty/serial/vt8500_serial.c                 |    1 +
 drivers/tty/tty_io.c                               |   80 +-
 drivers/tty/tty_port.c                             |   75 +-
 drivers/tty/vcc.c                                  |    5 +-
 drivers/tty/vt/vc_screen.c                         |   25 +-
 drivers/tty/vt/vt.c                                |    7 +-
 drivers/ufs/core/ufshcd.c                          |   28 +-
 drivers/ufs/host/ufs-exynos.c                      |   17 +-
 drivers/ufs/host/ufs-exynos.h                      |    3 +-
 drivers/ufs/host/ufs-qcom.c                        |   13 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |    4 +
 drivers/usb/cdns3/cdns3-pci-wrap.c                 |    5 +
 drivers/usb/chipidea/ci_hdrc_tegra.c               |    4 +-
 drivers/usb/chipidea/udc.c                         |    4 +
 drivers/usb/class/cdc-acm.c                        |   41 +-
 drivers/usb/class/cdc-acm.h                        |    1 -
 drivers/usb/core/hub.c                             |    7 +-
 drivers/usb/core/message.c                         |    8 +-
 drivers/usb/dwc2/hcd.c                             |    3 +-
 drivers/usb/dwc3/core.c                            |   19 +-
 drivers/usb/dwc3/core.h                            |   23 +
 drivers/usb/dwc3/dwc3-am62.c                       |    1 +
 drivers/usb/dwc3/ep0.c                             |    9 +
 drivers/usb/dwc3/gadget.c                          |  112 +-
 drivers/usb/gadget/function/f_ecm.c                |   41 +-
 drivers/usb/gadget/function/f_eem.c                |   59 +-
 drivers/usb/gadget/function/f_fs.c                 |  241 +-
 drivers/usb/gadget/function/f_hid.c                |   17 +-
 drivers/usb/gadget/function/f_mass_storage.c       |    3 +
 drivers/usb/gadget/function/f_midi.c               |    6 +-
 drivers/usb/gadget/function/f_printer.c            |   10 +-
 drivers/usb/gadget/function/f_rndis.c              |   42 +-
 drivers/usb/gadget/function/f_subset.c             |   57 +-
 drivers/usb/gadget/function/f_uac1.c               |   13 +-
 drivers/usb/gadget/function/f_uac1_legacy.c        |    6 +
 drivers/usb/gadget/function/f_uac2.c               |   13 +-
 drivers/usb/gadget/function/u_ecm.h                |   21 +-
 drivers/usb/gadget/function/u_eem.h                |   21 +-
 drivers/usb/gadget/function/u_fs.h                 |    2 -
 drivers/usb/gadget/function/u_gether.h             |   22 +-
 drivers/usb/gadget/function/u_rndis.h              |   31 +-
 drivers/usb/gadget/legacy/g_ffs.c                  |    9 -
 drivers/usb/gadget/legacy/inode.c                  |    7 +-
 drivers/usb/gadget/udc/aspeed-vhub/core.c          |    4 +
 drivers/usb/gadget/udc/aspeed-vhub/dev.c           |    2 +-
 drivers/usb/gadget/udc/aspeed-vhub/hub.c           |    5 +-
 drivers/usb/gadget/udc/aspeed-vhub/vhub.h          |    1 +
 drivers/usb/gadget/udc/at91_udc.c                  |   33 +-
 drivers/usb/gadget/udc/core.c                      |    7 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |    4 +
 drivers/usb/host/ehci-sched.c                      |   11 +-
 drivers/usb/host/fotg210-hcd.c                     |    6 +-
 drivers/usb/host/octeon-hcd.c                      |    2 +-
 drivers/usb/host/ohci-da8xx.c                      |    2 +
 drivers/usb/host/ohci-s3c2410.c                    |    1 +
 drivers/usb/host/ohci-spear.c                      |    4 +-
 drivers/usb/host/ohci-st.c                         |    1 +
 drivers/usb/host/xhci.c                            |   11 +-
 drivers/usb/misc/iowarrior.c                       |   57 +-
 drivers/usb/serial/ark3116.c                       |    7 +-
 drivers/usb/serial/belkin_sa.c                     |   12 +-
 drivers/usb/serial/bus.c                           |    6 +-
 drivers/usb/serial/ch341.c                         |   37 +-
 drivers/usb/serial/cp210x.c                        |    9 +-
 drivers/usb/serial/digi_acceleport.c               |    7 +-
 drivers/usb/serial/f81232.c                        |    4 +-
 drivers/usb/serial/f81534.c                        |    4 +-
 drivers/usb/serial/ftdi_sio.c                      |   10 +-
 drivers/usb/serial/generic.c                       |   10 +-
 drivers/usb/serial/io_edgeport.c                   |    6 +-
 drivers/usb/serial/io_ti.c                         |    9 +-
 drivers/usb/serial/keyspan.c                       |    5 +-
 drivers/usb/serial/keyspan_pda.c                   |    8 +-
 drivers/usb/serial/mct_u232.c                      |    6 +-
 drivers/usb/serial/mos7720.c                       |    9 +-
 drivers/usb/serial/mos7840.c                       |    7 +-
 drivers/usb/serial/mxuport.c                       |    6 +-
 drivers/usb/serial/option.c                        |   14 +
 drivers/usb/serial/pl2303.c                        |   14 +-
 drivers/usb/serial/quatech2.c                      |   27 +-
 drivers/usb/serial/ssu100.c                        |   18 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |   10 +-
 drivers/usb/serial/upd78f0730.c                    |    7 +-
 drivers/usb/serial/usb-serial.c                    |  127 +-
 drivers/usb/serial/usb_debug.c                     |   13 +-
 drivers/usb/serial/whiteheat.c                     |    7 +-
 drivers/usb/serial/xr_serial.c                     |    4 +-
 drivers/usb/storage/realtek_cr.c                   |    9 +-
 drivers/usb/storage/sierra_ms.c                    |    7 +
 drivers/usb/typec/anx7411.c                        |    5 +-
 drivers/usb/typec/tcpm/tcpci_maxim.c               |    9 +
 drivers/usb/typec/tcpm/tcpci_rt1711h.c             |   13 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   53 +-
 drivers/usb/typec/tipd/core.c                      |    3 +-
 drivers/usb/typec/ucsi/displayport.c               |    9 +-
 drivers/usb/typec/ucsi/ucsi.c                      |   43 +-
 drivers/usb/typec/ucsi/ucsi.h                      |   11 +
 drivers/usb/typec/ucsi/ucsi_acpi.c                 |   32 +
 drivers/usb/usbip/usbip_common.c                   |    1 +
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |    2 +
 drivers/vdpa/mlx5/core/mr.c                        |    3 +
 drivers/vdpa/mlx5/core/resources.c                 |   11 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |    9 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   11 +-
 drivers/vdpa/vdpa_user/iova_domain.c               |   11 +-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |   22 +-
 drivers/vfio/pci/mlx5/main.c                       |    6 +-
 drivers/vhost/iotlb.c                              |   47 +-
 drivers/vhost/vdpa.c                               |   11 +-
 drivers/vhost/vhost.c                              |  116 +-
 drivers/video/fbdev/arcfb.c                        |    3 +
 drivers/video/fbdev/broadsheetfb.c                 |    4 +-
 drivers/video/fbdev/cobalt_lcdfb.c                 |    6 +
 drivers/video/fbdev/core/fb_sys_fops.c             |    8 +-
 drivers/video/fbdev/core/fbcon.c                   |    2 -
 drivers/video/fbdev/core/fbmem.c                   |   29 +-
 drivers/video/fbdev/core/fbsysfs.c                 |   13 +-
 drivers/video/fbdev/hecubafb.c                     |    4 +-
 drivers/video/fbdev/metronomefb.c                  |    4 +-
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c     |   11 +-
 drivers/video/fbdev/ps3fb.c                        |    5 +-
 drivers/video/fbdev/pvr2fb.c                       |    3 +
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |    5 +-
 drivers/video/fbdev/sm712fb.c                      |   10 +-
 drivers/video/fbdev/ssd1307fb.c                    |  126 +-
 drivers/virt/acrn/irqfd.c                          |   75 +-
 drivers/virt/nitro_enclaves/ne_misc_dev.c          |    1 +
 drivers/virtio/virtio.c                            |   29 +
 drivers/virtio/virtio_mmio.c                       |   66 +-
 drivers/watchdog/at91sam9_wdt.c                    |    4 +-
 drivers/watchdog/cpu5wdt.c                         |    2 +-
 drivers/watchdog/rtd119x_wdt.c                     |   21 +-
 drivers/xen/events/events_2l.c                     |    8 +-
 drivers/xen/events/events_base.c                   |  449 +--
 drivers/xen/events/events_internal.h               |    1 -
 drivers/xen/gntdev-dmabuf.c                        |   31 +-
 drivers/xen/pvcalls-front.c                        |   88 +-
 fs/9p/vfs_inode_dotl.c                             |    2 +-
 fs/Kconfig                                         |    1 -
 fs/Makefile                                        |    1 -
 fs/afs/inode.c                                     |    1 +
 fs/afs/internal.h                                  |    2 +
 fs/afs/rxrpc.c                                     |   79 +-
 fs/afs/super.c                                     |    2 +-
 fs/autofs/waitq.c                                  |   25 +-
 fs/btrfs/acl.c                                     |    3 +
 fs/btrfs/block-group.c                             |    3 +
 fs/btrfs/block-rsv.c                               |   19 +-
 fs/btrfs/ctree.c                                   |   65 +-
 fs/btrfs/ctree.h                                   |   23 +-
 fs/btrfs/dev-replace.c                             |    1 +
 fs/btrfs/disk-io.c                                 |    5 +
 fs/btrfs/extent-tree.c                             |   46 +-
 fs/btrfs/extent_io.c                               |  173 +-
 fs/btrfs/file.c                                    |  105 +-
 fs/btrfs/free-space-tree.c                         |   10 +-
 fs/btrfs/inode.c                                   |   82 +-
 fs/btrfs/ioctl.c                                   |   68 +-
 fs/btrfs/lzo.c                                     |   14 +-
 fs/btrfs/qgroup.c                                  |   24 +-
 fs/btrfs/reflink.c                                 |   58 +
 fs/btrfs/relocation.c                              |   87 +-
 fs/btrfs/scrub.c                                   |    9 +-
 fs/btrfs/transaction.c                             |   21 +-
 fs/btrfs/tree-log.c                                |  105 +-
 fs/btrfs/volumes.c                                 |  243 +-
 fs/ceph/dir.c                                      |   10 +-
 fs/ceph/export.c                                   |   23 +-
 fs/ceph/mds_client.c                               |   63 +-
 fs/ceph/mds_client.h                               |    1 +
 fs/ceph/super.h                                    |    9 +
 fs/ceph/xattr.c                                    |   16 +
 fs/coredump.c                                      |   16 +-
 fs/dcache.c                                        |    4 +-
 fs/dlm/config.c                                    |    4 +-
 fs/dlm/lock.c                                      |    2 +
 fs/dlm/lowcomms.c                                  |  197 +-
 fs/dlm/lowcomms.h                                  |    5 +-
 fs/dlm/midcomms.c                                  |   10 +-
 fs/erofs/decompressor_lzma.c                       |   18 +-
 fs/erofs/xattr.c                                   |    5 +-
 fs/erofs/zdata.c                                   |   46 +-
 fs/erofs/zmap.c                                    |   21 +-
 fs/exec.c                                          |   23 +-
 fs/exfat/dir.c                                     |   24 +-
 fs/exfat/exfat_fs.h                                |    3 +-
 fs/exfat/fatent.c                                  |   10 +
 fs/exfat/namei.c                                   |   28 +-
 fs/exfat/nls.c                                     |   24 +-
 fs/exfat/super.c                                   |   32 +-
 fs/ext2/inode.c                                    |    3 +-
 fs/ext2/xattr.c                                    |    4 +-
 fs/ext4/ext4.h                                     |   29 +-
 fs/ext4/extents.c                                  |   20 +-
 fs/ext4/extents_status.c                           |    7 +-
 fs/ext4/extents_status.h                           |    1 +
 fs/ext4/inode.c                                    |   57 +-
 fs/ext4/ioctl.c                                    |    5 +
 fs/ext4/mballoc.c                                  |  217 +-
 fs/ext4/mballoc.h                                  |    4 +-
 fs/ext4/migrate.c                                  |   14 +-
 fs/ext4/super.c                                    |   61 +-
 fs/ext4/xattr.c                                    |    2 +-
 fs/f2fs/checkpoint.c                               |    7 +-
 fs/f2fs/compress.c                                 |   10 +-
 fs/f2fs/data.c                                     |   14 +-
 fs/f2fs/debug.c                                    |    4 -
 fs/f2fs/dir.c                                      |    1 +
 fs/f2fs/extent_cache.c                             |  153 +-
 fs/f2fs/f2fs.h                                     |   69 +-
 fs/f2fs/file.c                                     |   32 +-
 fs/f2fs/gc.c                                       |   70 +-
 fs/f2fs/gc.h                                       |   20 -
 fs/f2fs/inode.c                                    |    8 +-
 fs/f2fs/node.c                                     |   78 +-
 fs/f2fs/recovery.c                                 |   33 +-
 fs/f2fs/segment.c                                  |   37 +-
 fs/f2fs/super.c                                    |   58 +-
 fs/f2fs/sysfs.c                                    |   42 +-
 fs/fcntl.c                                         |    3 +
 fs/fsopen.c                                        |    3 +
 fs/fuse/inode.c                                    |    2 +
 fs/gfs2/glock.c                                    |   35 +-
 fs/gfs2/glock.h                                    |    1 +
 fs/gfs2/incore.h                                   |    1 +
 fs/gfs2/lock_dlm.c                                 |   12 +-
 fs/gfs2/ops_fstype.c                               |   13 +-
 fs/gfs2/super.c                                    |    7 +-
 fs/hfs/bfind.c                                     |    3 +
 fs/hfs/btree.c                                     |   57 +-
 fs/hfs/extent.c                                    |    2 +-
 fs/hfs/hfs_fs.h                                    |    1 +
 fs/inode.c                                         |   24 +-
 fs/jfs/jfs_dtree.c                                 |   18 +-
 fs/libfs.c                                         |   36 +-
 fs/lockd/clntproc.c                                |    3 +
 fs/lockd/svc.c                                     |    6 +-
 fs/lockd/svc4proc.c                                |    4 +-
 fs/lockd/svcproc.c                                 |    4 +-
 fs/lockd/svcsubs.c                                 |   47 +-
 fs/mbcache.c                                       |    1 +
 fs/namei.c                                         |    4 +
 fs/namespace.c                                     |  123 +-
 fs/nfs/blocklayout/dev.c                           |   19 +-
 fs/nfs/callback_xdr.c                              |    6 +-
 fs/nfs/delegation.c                                |   27 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |    3 +-
 fs/nfs/nfs4proc.c                                  |   32 +-
 fs/nfs/nfs4session.c                               |   16 +-
 fs/nfs/pnfs.c                                      |   58 +-
 fs/nfs/pnfs.h                                      |   17 +-
 fs/nfsd/export.c                                   |   31 +-
 fs/nfsd/export.h                                   |    4 +-
 fs/nfsd/filecache.c                                |   67 +-
 fs/nfsd/lockd.c                                    |    6 +-
 fs/nfsd/netns.h                                    |    5 +-
 fs/nfsd/nfs2acl.c                                  |   21 +-
 fs/nfsd/nfs3acl.c                                  |   17 +-
 fs/nfsd/nfs3proc.c                                 |   38 +
 fs/nfsd/nfs4layouts.c                              |   21 +-
 fs/nfsd/nfs4proc.c                                 |   36 +-
 fs/nfsd/nfs4state.c                                |   33 +-
 fs/nfsd/trace.h                                    |    4 +-
 fs/nfsd/vfs.c                                      |   36 +-
 fs/nilfs2/page.c                                   |   17 +-
 fs/notify/mark.c                                   |   50 +-
 fs/ntfs/Kconfig                                    |   80 -
 fs/ntfs/Makefile                                   |   15 -
 fs/ntfs/aops.c                                     | 1761 -----------
 fs/ntfs/aops.h                                     |   88 -
 fs/ntfs/attrib.c                                   | 2624 ----------------
 fs/ntfs/attrib.h                                   |  102 -
 fs/ntfs/bitmap.c                                   |  179 --
 fs/ntfs/bitmap.h                                   |  104 -
 fs/ntfs/collate.c                                  |  110 -
 fs/ntfs/collate.h                                  |   36 -
 fs/ntfs/compress.c                                 |  950 ------
 fs/ntfs/debug.c                                    |  159 -
 fs/ntfs/debug.h                                    |   57 -
 fs/ntfs/dir.c                                      | 1538 ----------
 fs/ntfs/dir.h                                      |   34 -
 fs/ntfs/endian.h                                   |   79 -
 fs/ntfs/file.c                                     | 2006 ------------
 fs/ntfs/index.c                                    |  440 ---
 fs/ntfs/index.h                                    |  134 -
 fs/ntfs/inode.c                                    | 3100 -------------------
 fs/ntfs/inode.h                                    |  310 --
 fs/ntfs/layout.h                                   | 2421 ---------------
 fs/ntfs/lcnalloc.c                                 | 1000 ------
 fs/ntfs/lcnalloc.h                                 |  131 -
 fs/ntfs/logfile.c                                  |  849 ------
 fs/ntfs/logfile.h                                  |  295 --
 fs/ntfs/malloc.h                                   |   77 -
 fs/ntfs/mft.c                                      | 2906 ------------------
 fs/ntfs/mft.h                                      |  110 -
 fs/ntfs/mst.c                                      |  189 --
 fs/ntfs/namei.c                                    |  391 ---
 fs/ntfs/ntfs.h                                     |  150 -
 fs/ntfs/quota.c                                    |  103 -
 fs/ntfs/quota.h                                    |   21 -
 fs/ntfs/runlist.c                                  | 1893 ------------
 fs/ntfs/runlist.h                                  |   88 -
 fs/ntfs/super.c                                    | 3194 --------------------
 fs/ntfs/sysctl.c                                   |   69 -
 fs/ntfs/sysctl.h                                   |   27 -
 fs/ntfs/time.h                                     |   89 -
 fs/ntfs/types.h                                    |   55 -
 fs/ntfs/unistr.c                                   |  384 ---
 fs/ntfs/upcase.c                                   |   73 -
 fs/ntfs/usnjrnl.c                                  |   70 -
 fs/ntfs/usnjrnl.h                                  |  191 --
 fs/ntfs/volume.h                                   |  164 -
 fs/ntfs3/attrib.c                                  |   27 +-
 fs/ntfs3/file.c                                    |   43 +-
 fs/ntfs3/frecord.c                                 |   86 +-
 fs/ntfs3/fslog.c                                   |   16 +
 fs/ntfs3/index.c                                   |   10 +
 fs/ntfs3/inode.c                                   |   17 +-
 fs/ntfs3/namei.c                                   |   10 +-
 fs/ntfs3/ntfs_fs.h                                 |   24 +-
 fs/ntfs3/record.c                                  |   91 +-
 fs/ntfs3/super.c                                   |   16 +-
 fs/ocfs2/cluster/heartbeat.c                       |  168 +-
 fs/ocfs2/cluster/nodemanager.c                     |   19 +-
 fs/ocfs2/cluster/nodemanager.h                     |    2 +
 fs/ocfs2/cluster/tcp.c                             |  104 +-
 fs/ocfs2/cluster/tcp.h                             |    1 +
 fs/ocfs2/dir.c                                     |   71 +-
 fs/ocfs2/dlm/dlmcommon.h                           |    2 +
 fs/ocfs2/dlm/dlmdebug.c                            |    5 +-
 fs/ocfs2/dlm/dlmrecovery.c                         |    2 +-
 fs/ocfs2/inode.c                                   |  129 +
 fs/ocfs2/namei.c                                   |    8 +-
 fs/overlayfs/file.c                                |   19 +-
 fs/pipe.c                                          |    6 +-
 fs/proc/task_mmu.c                                 |    3 +
 fs/reiserfs/namei.c                                |   61 +-
 fs/smb/client/cached_dir.c                         |  122 +-
 fs/smb/client/cifsacl.c                            |   71 +-
 fs/smb/client/cifsfs.c                             |    1 +
 fs/smb/client/cifsglob.h                           |   15 +-
 fs/smb/client/connect.c                            |  172 +-
 fs/smb/client/dir.c                                |   39 +-
 fs/smb/client/file.c                               |   41 +-
 fs/smb/client/fs_context.c                         |    6 +
 fs/smb/client/inode.c                              |   40 +-
 fs/smb/client/link.c                               |   15 +-
 fs/smb/client/misc.c                               |   72 +-
 fs/smb/client/readdir.c                            |   17 +-
 fs/smb/client/sess.c                               |  104 +-
 fs/smb/client/smb1ops.c                            |   21 +-
 fs/smb/client/smb2file.c                           |   19 +-
 fs/smb/client/smb2misc.c                           |   15 +-
 fs/smb/client/smb2ops.c                            |  107 +-
 fs/smb/client/smb2pdu.c                            |   96 +-
 fs/smb/client/smb2pdu.h                            |    9 -
 fs/smb/client/smb2proto.h                          |    4 +-
 fs/smb/client/smb2transport.c                      |   58 +-
 fs/smb/client/smbdirect.c                          |   22 +-
 fs/smb/client/transport.c                          |   69 +-
 fs/smb/common/smb2pdu.h                            |   11 +
 fs/smb/server/auth.c                               |   22 +-
 fs/smb/server/connection.c                         |   23 +
 fs/smb/server/connection.h                         |   14 +
 fs/smb/server/ksmbd_work.c                         |    3 -
 fs/smb/server/ksmbd_work.h                         |    1 -
 fs/smb/server/mgmt/share_config.c                  |    7 +-
 fs/smb/server/mgmt/tree_connect.c                  |   28 +-
 fs/smb/server/mgmt/user_config.c                   |   11 +
 fs/smb/server/mgmt/user_session.c                  |   29 +-
 fs/smb/server/mgmt/user_session.h                  |    2 +
 fs/smb/server/misc.c                               |   33 -
 fs/smb/server/misc.h                               |    1 -
 fs/smb/server/oplock.c                             |  133 +-
 fs/smb/server/oplock.h                             |    2 +-
 fs/smb/server/server.c                             |   26 +-
 fs/smb/server/smb2ops.c                            |    1 -
 fs/smb/server/smb2pdu.c                            |  292 +-
 fs/smb/server/smb2pdu.h                            |    8 -
 fs/smb/server/smb_common.c                         |   10 +-
 fs/smb/server/smb_common.h                         |    2 +-
 fs/smb/server/smbacl.c                             |  317 +-
 fs/smb/server/smbacl.h                             |    4 +-
 fs/smb/server/transport_ipc.c                      |    5 +-
 fs/smb/server/transport_rdma.c                     |    4 +-
 fs/smb/server/vfs.c                                |   94 +-
 fs/smb/server/vfs_cache.c                          |  135 +-
 fs/unicode/utf8-core.c                             |   21 +-
 fs/userfaultfd.c                                   |   11 +
 fs/verity/Kconfig                                  |    3 +
 fs/xfs/libxfs/xfs_alloc.c                          |   46 +-
 fs/xfs/libxfs/xfs_attr.c                           |   74 +-
 fs/xfs/libxfs/xfs_ialloc.c                         |   32 +-
 fs/xfs/libxfs/xfs_sb.c                             |   17 +-
 fs/xfs/xfs_buf_item.c                              |  299 +-
 fs/xfs/xfs_buf_item.h                              |    3 +-
 fs/xfs/xfs_fsmap.c                                 |    2 +-
 fs/xfs/xfs_icache.c                                |    8 +
 fs/xfs/xfs_inode.c                                 |    2 +-
 fs/xfs/xfs_ioctl.c                                 |    2 +-
 fs/xfs/xfs_iops.c                                  |    2 +-
 fs/xfs/xfs_log_recover.c                           |   13 +-
 include/acpi/acpi_bus.h                            |    6 +
 include/acpi/battery.h                             |    4 +-
 include/clocksource/samsung_pwm.h                  |    2 +-
 include/drm/gpu_scheduler.h                        |   29 +-
 include/linux/blkdev.h                             |    1 +
 include/linux/bpf.h                                |   42 +-
 include/linux/can/skb.h                            |    2 +
 include/linux/cgroup-defs.h                        |    5 +-
 include/linux/cgroup.h                             |    1 +
 include/linux/compiler_attributes.h                |   13 +
 include/linux/device-mapper.h                      |   23 +-
 include/linux/device.h                             |    3 +
 include/linux/dm-dirty-log.h                       |    2 +-
 include/linux/dm-region-hash.h                     |    6 +-
 include/linux/dma-buf.h                            |    1 +
 include/linux/dma/k3-udma-glue.h                   |    3 +-
 include/linux/dmaengine.h                          |    7 +
 include/linux/f2fs_fs.h                            |    1 +
 include/linux/fb.h                                 |  115 +
 include/linux/fs.h                                 |    2 +
 include/linux/fsnotify_backend.h                   |    1 +
 include/linux/ftrace.h                             |    5 +-
 include/linux/futex.h                              |   14 +-
 include/linux/hid.h                                |   10 +-
 include/linux/highmem.h                            |   44 +
 include/linux/hw_random.h                          |    2 +
 include/linux/i2c.h                                |    1 +
 include/linux/i3c/master.h                         |    3 +
 include/linux/ieee80211.h                          |   12 +-
 include/linux/if_team.h                            |    3 +-
 include/linux/if_vlan.h                            |    3 +
 include/linux/iio/common/st_sensors.h              |    4 -
 include/linux/ima.h                                |    1 +
 include/linux/io_uring.h                           |    2 +
 include/linux/iommu.h                              |    2 +
 include/linux/ism.h                                |   23 +
 include/linux/kasan.h                              |    6 +-
 include/linux/key-type.h                           |    1 +
 include/linux/key.h                                |    5 +
 include/linux/libata.h                             |    3 +
 include/linux/list.h                               |   15 +
 include/linux/lockd/bind.h                         |   12 +-
 include/linux/lockd/lockd.h                        |    2 +-
 include/linux/memory_hotplug.h                     |    2 +-
 include/linux/mlx5/cq.h                            |    1 +
 include/linux/mlx5/driver.h                        |    1 -
 include/linux/mlx5/mlx5_ifc.h                      |   13 +-
 include/linux/mlx5/vport.h                         |    6 +-
 include/linux/mm.h                                 |    2 +-
 include/linux/mm_types.h                           |    3 +
 include/linux/mount.h                              |    2 +-
 include/linux/mtd/mtd.h                            |    2 +-
 include/linux/netdevice.h                          |    4 +
 include/linux/netfilter.h                          |   12 +
 include/linux/nfs_xdr.h                            |    1 -
 include/linux/ntb.h                                |   24 +
 include/linux/nvme.h                               |    4 +-
 include/linux/of.h                                 |    6 +
 include/linux/of_device.h                          |   11 -
 include/linux/of_platform.h                        |    5 +
 include/linux/pagemap.h                            |   48 +
 include/linux/pci.h                                |    7 +-
 include/linux/perf/riscv_pmu.h                     |    5 +-
 include/linux/perf_event.h                         |    1 -
 include/linux/power_supply.h                       |    6 +-
 include/linux/psi.h                                |    4 +-
 include/linux/qcom-geni-se.h                       |   15 +-
 include/linux/sched.h                              |    2 +-
 include/linux/sched/signal.h                       |   27 +-
 include/linux/sched/user.h                         |   11 +-
 include/linux/scmi_protocol.h                      |    5 -
 include/linux/seq_buf.h                            |   27 +-
 include/linux/skbuff.h                             |   22 +-
 include/linux/stmmac.h                             |    1 -
 include/linux/sunrpc/svc_rdma.h                    |    1 +
 include/linux/sunrpc/xdr.h                         |    1 -
 include/linux/trace_recursion.h                    |    9 +
 include/linux/trace_seq.h                          |    2 +
 include/linux/tty.h                                |    4 +-
 include/linux/tty_driver.h                         |    6 +
 include/linux/tty_port.h                           |   22 +-
 include/linux/unicode.h                            |    1 +
 include/linux/usb/gadget.h                         |    2 +
 include/linux/usb/serial.h                         |    3 +-
 include/linux/userfaultfd_k.h                      |    7 +
 include/linux/virtio.h                             |    2 +-
 include/media/v4l2-mem2mem.h                       |   21 +
 include/net/af_vsock.h                             |    3 +
 include/net/amt.h                                  |    4 -
 include/net/ax25.h                                 |    1 -
 include/net/bluetooth/hci.h                        |    9 +
 include/net/bluetooth/hci_core.h                   |    5 +-
 include/net/bluetooth/l2cap.h                      |    1 +
 include/net/bluetooth/mgmt.h                       |    2 +-
 include/net/bluetooth/rfcomm.h                     |    1 +
 include/net/cfg80211.h                             |  105 +-
 include/net/codel_impl.h                           |    1 +
 include/net/dropreason.h                           |    3 +
 include/net/dsa.h                                  |    1 +
 include/net/inet_connection_sock.h                 |   11 +-
 include/net/ip.h                                   |   17 +-
 include/net/ip6_route.h                            |    2 +-
 include/net/ip_vs.h                                |    2 +-
 include/net/netfilter/nf_conntrack_expect.h        |   16 +-
 include/net/netfilter/nf_conntrack_timeout.h       |   27 +-
 include/net/netfilter/nf_queue.h                   |    1 +
 include/net/netfilter/nf_tables.h                  |   16 +-
 include/net/netfilter/nft_fib.h                    |    2 +-
 include/net/netfilter/nft_meta.h                   |    4 +-
 include/net/netfilter/nft_reject.h                 |    3 +-
 include/net/netns/mpls.h                           |    1 +
 include/net/netns/xfrm.h                           |    1 +
 include/net/nexthop.h                              |    6 +-
 include/net/pkt_cls.h                              |   45 +-
 include/net/pkt_sched.h                            |    3 +-
 include/net/route.h                                |    2 +-
 include/net/sch_generic.h                          |   21 +-
 include/net/secure_seq.h                           |   47 +-
 include/net/sock.h                                 |   19 +-
 include/net/strparser.h                            |   10 +-
 include/net/tc_act/tc_pedit.h                      |   18 +-
 include/net/tcp.h                                  |   14 +-
 include/net/tls.h                                  |   12 +-
 include/scsi/scsi_host.h                           |    9 +-
 include/trace/events/btrfs.h                       |    4 +-
 include/trace/events/rv.h                          |   76 +-
 include/uapi/linux/ioprio.h                        |  100 +-
 include/uapi/linux/netfilter/nf_conntrack_common.h |    1 +
 include/uapi/linux/nexthop.h                       |    7 +-
 include/uapi/linux/stddef.h                        |    5 +
 include/uapi/linux/virtio_crypto.h                 |    1 +
 include/xen/events.h                               |    4 +-
 io_uring/cancel.c                                  |   33 +-
 io_uring/cancel.h                                  |    2 +
 io_uring/io-wq.c                                   |   96 +-
 io_uring/io-wq.h                                   |    4 +-
 io_uring/io_uring.c                                |  108 +-
 io_uring/io_uring.h                                |   44 +-
 io_uring/poll.c                                    |   42 +-
 io_uring/rsrc.c                                    |    7 +-
 io_uring/rw.c                                      |   18 -
 io_uring/sqpoll.c                                  |    7 +
 io_uring/tctx.c                                    |    1 +
 io_uring/timeout.c                                 |   46 +-
 kernel/audit_tree.c                                |   36 +-
 kernel/bpf/arraymap.c                              |   30 +-
 kernel/bpf/bpf_struct_ops.c                        |   75 +-
 kernel/bpf/btf.c                                   |    5 +
 kernel/bpf/cgroup.c                                |   23 +
 kernel/bpf/core.c                                  |    1 +
 kernel/bpf/hashtab.c                               |   63 +-
 kernel/bpf/helpers.c                               |  102 +-
 kernel/bpf/mmap_unlock_work.h                      |   51 +-
 kernel/bpf/queue_stack_maps.c                      |    8 +-
 kernel/bpf/stackmap.c                              |   85 +-
 kernel/bpf/syscall.c                               |   93 +-
 kernel/bpf/task_iter.c                             |   14 +-
 kernel/bpf/trampoline.c                            |   54 +-
 kernel/bpf/verifier.c                              |  104 +-
 kernel/cgroup/Makefile                             |    2 +-
 kernel/cgroup/cgroup.c                             |   53 +-
 kernel/cgroup/cpuset-internal.h                    |  222 ++
 kernel/cgroup/cpuset-v1.c                          |    3 +
 kernel/cgroup/cpuset.c                             |  222 +-
 kernel/cgroup/rstat.c                              |   19 +-
 kernel/dma/direct.c                                |   56 +-
 kernel/events/core.c                               |  111 +-
 kernel/exit.c                                      |   51 +-
 kernel/fork.c                                      |   38 +-
 kernel/futex/core.c                                |   49 +-
 kernel/kprobes.c                                   |    8 +-
 kernel/params.c                                    |   61 +-
 kernel/pid_namespace.c                             |    5 +-
 kernel/rcu/tasks.h                                 |   82 +-
 kernel/rcu/tree.h                                  |   13 +-
 kernel/rcu/tree_plugin.h                           |   42 +-
 kernel/sched/core.c                                |   50 +
 kernel/sched/deadline.c                            |    7 +-
 kernel/sched/psi.c                                 |   69 +-
 kernel/sched/rt.c                                  |   52 +-
 kernel/sched/sched.h                               |    1 +
 kernel/signal.c                                    |    4 +
 kernel/time/namespace.c                            |    5 +
 kernel/trace/blktrace.c                            |    3 +-
 kernel/trace/bpf_trace.c                           |    6 +-
 kernel/trace/fgraph.c                              |    1 +
 kernel/trace/ftrace.c                              |   76 +-
 kernel/trace/trace.c                               |  103 +-
 kernel/trace/trace.h                               |    4 +-
 kernel/trace/trace_events_filter.c                 |    6 +
 kernel/trace/trace_events_hist.c                   |  102 +-
 kernel/trace/trace_events_synth.c                  |   10 +
 kernel/trace/trace_events_user.c                   |   26 +-
 kernel/trace/trace_functions.c                     |    2 +-
 kernel/trace/trace_seq.c                           |    6 +-
 kernel/trace/trace_stack.c                         |    2 +-
 kernel/trace/trace_synth.h                         |    1 +
 kernel/watch_queue.c                               |   11 +-
 kernel/workqueue.c                                 |   24 +-
 lib/Kconfig.debug                                  |    2 +
 lib/seq_buf.c                                      |   52 +-
 lib/test_kprobes.c                                 |   28 +-
 mm/damon/core.c                                    |   32 +-
 mm/filemap.c                                       |    2 +-
 mm/huge_memory.c                                   |   17 +
 mm/hugetlb.c                                       |   56 +-
 mm/kasan/quarantine.c                              |   39 +-
 mm/kasan/report.c                                  |    4 +-
 mm/kasan/shadow.c                                  |  111 +-
 mm/khugepaged.c                                    |    3 +
 mm/kmemleak.c                                      |  190 +-
 mm/memcontrol.c                                    |    2 +-
 mm/memory_hotplug.c                                |    3 +-
 mm/mempolicy.c                                     |    2 +
 mm/migrate.c                                       |   27 +-
 mm/mlock.c                                         |    2 +-
 mm/mmap.c                                          |  100 +-
 mm/mremap.c                                        |   70 +-
 mm/page_alloc.c                                    |   14 +-
 mm/page_table_check.c                              |   20 +-
 mm/pagewalk.c                                      |    8 +
 mm/ptdump.c                                        |    7 +
 mm/readahead.c                                     |   13 -
 mm/rmap.c                                          |    6 +-
 mm/secretmem.c                                     |  119 +-
 mm/shmem.c                                         |   13 +-
 mm/slab.h                                          |    5 +
 mm/slub.c                                          |    9 +-
 mm/userfaultfd.c                                   |   22 +-
 mm/vmalloc.c                                       |    4 +-
 mm/vmscan.c                                        |   18 +-
 net/8021q/vlan.c                                   |    7 +-
 net/8021q/vlan_dev.c                               |   65 +-
 net/9p/trans_fd.c                                  |    1 +
 net/9p/trans_xen.c                                 |   79 +-
 net/ax25/af_ax25.c                                 |   30 +-
 net/ax25/ax25_route.c                              |   74 -
 net/bluetooth/6lowpan.c                            |   49 +-
 net/bluetooth/af_bluetooth.c                       |   10 +-
 net/bluetooth/hci_conn.c                           |   98 +-
 net/bluetooth/hci_core.c                           |   45 +-
 net/bluetooth/hci_debugfs.c                        |    2 +-
 net/bluetooth/hci_event.c                          |  129 +-
 net/bluetooth/hci_request.c                        |    2 +-
 net/bluetooth/hci_sock.c                           |    2 +
 net/bluetooth/hci_sync.c                           |   43 +-
 net/bluetooth/iso.c                                |  129 +-
 net/bluetooth/l2cap_core.c                         |   64 +-
 net/bluetooth/l2cap_sock.c                         |   59 +-
 net/bluetooth/mgmt.c                               |  273 +-
 net/bluetooth/mgmt_util.c                          |   46 +
 net/bluetooth/mgmt_util.h                          |    3 +
 net/bluetooth/rfcomm/core.c                        |  134 +-
 net/bluetooth/rfcomm/sock.c                        |    5 +-
 net/bluetooth/rfcomm/tty.c                         |    9 +-
 net/bluetooth/sco.c                                |    6 +-
 net/bridge/br_arp_nd_proxy.c                       |   24 +-
 net/bridge/br_cfm.c                                |   11 +-
 net/bridge/br_device.c                             |    1 -
 net/bridge/br_input.c                              |   35 +-
 net/bridge/br_mrp.c                                |   13 +-
 net/bridge/br_multicast.c                          |   45 +-
 net/bridge/br_private.h                            |   26 +-
 net/bridge/netfilter/ebt_dnat.c                    |    4 +-
 net/bridge/netfilter/ebt_redirect.c                |   16 +-
 net/bridge/netfilter/ebtable_broute.c              |    2 +-
 net/bridge/netfilter/ebtable_filter.c              |    2 +-
 net/bridge/netfilter/ebtable_nat.c                 |    2 +-
 net/bridge/netfilter/ebtables.c                    |   71 +-
 net/can/af_can.c                                   |    6 +-
 net/can/bcm.c                                      |    2 +
 net/can/isotp.c                                    |   11 +-
 net/can/j1939/socket.c                             |    1 +
 net/can/j1939/transport.c                          |    2 +
 net/can/raw.c                                      |    7 +-
 net/ceph/auth_x.c                                  |    5 +
 net/ceph/messenger.c                               |    1 +
 net/core/bpf_sk_storage.c                          |    2 -
 net/core/dev.c                                     |   75 +-
 net/core/dst.c                                     |    8 +
 net/core/filter.c                                  |    4 +-
 net/core/flow_dissector.c                          |   26 +-
 net/core/netpoll.c                                 |   10 +-
 net/core/page_pool.c                               |    3 +-
 net/core/pktgen.c                                  |    5 +-
 net/core/secure_seq.c                              |   80 +-
 net/core/skmsg.c                                   |   22 +-
 net/core/sock.c                                    |   30 +-
 net/dccp/timer.c                                   |    4 +-
 net/dsa/dsa2.c                                     |   35 +-
 net/ethtool/channels.c                             |    9 +-
 net/ethtool/ioctl.c                                |   11 +-
 net/hsr/hsr_framereg.c                             |    4 +-
 net/ieee802154/core.c                              |    8 +-
 net/ife/ife.c                                      |   14 +-
 net/ipv4/af_inet.c                                 |    1 +
 net/ipv4/esp4.c                                    |    8 +-
 net/ipv4/fib_semantics.c                           |    5 +-
 net/ipv4/fib_trie.c                                |    2 -
 net/ipv4/igmp.c                                    |   14 +-
 net/ipv4/inet_connection_sock.c                    |   10 +-
 net/ipv4/inet_diag.c                               |    4 +-
 net/ipv4/ipconfig.c                                |   90 +-
 net/ipv4/ipmr.c                                    |    6 +-
 net/ipv4/ipmr_base.c                               |    2 +-
 net/ipv4/netfilter/iptable_nat.c                   |    4 +-
 net/ipv4/netfilter/nft_dup_ipv4.c                  |    3 +-
 net/ipv4/nexthop.c                                 |  115 +-
 net/ipv4/route.c                                   |    9 +-
 net/ipv4/syncookies.c                              |   10 +-
 net/ipv4/tcp.c                                     |   18 +-
 net/ipv4/tcp_cong.c                                |    4 +-
 net/ipv4/tcp_dctcp.c                               |    4 +-
 net/ipv4/tcp_fastopen.c                            |    7 +-
 net/ipv4/tcp_input.c                               |   70 +-
 net/ipv4/tcp_ipv4.c                                |   43 +-
 net/ipv4/tcp_metrics.c                             |    6 +-
 net/ipv4/tcp_minisocks.c                           |   16 +-
 net/ipv4/tcp_output.c                              |    8 +-
 net/ipv4/tcp_timer.c                               |    5 +-
 net/ipv4/udp.c                                     |   65 +
 net/ipv4/udp_bpf.c                                 |    9 +
 net/ipv4/udp_tunnel_nic.c                          |   32 +-
 net/ipv4/xfrm4_input.c                             |    5 +-
 net/ipv6/esp6.c                                    |    8 +-
 net/ipv6/exthdrs.c                                 |   26 +-
 net/ipv6/ioam6.c                                   |   32 +-
 net/ipv6/ioam6_iptunnel.c                          |    9 +-
 net/ipv6/ip6_flowlabel.c                           |   20 +
 net/ipv6/ip6_gre.c                                 |    5 -
 net/ipv6/ip6_input.c                               |    1 +
 net/ipv6/ip6_output.c                              |   30 +-
 net/ipv6/ip6mr.c                                   |    5 +-
 net/ipv6/netfilter/ip6table_nat.c                  |    4 +-
 net/ipv6/netfilter/nft_dup_ipv6.c                  |    3 +-
 net/ipv6/route.c                                   |    6 +-
 net/ipv6/rpl_iptunnel.c                            |    9 +-
 net/ipv6/seg6_iptunnel.c                           |    2 +-
 net/ipv6/syncookies.c                              |   11 +-
 net/ipv6/tcp_ipv6.c                                |   43 +-
 net/ipv6/udp.c                                     |   50 +
 net/ipv6/xfrm6_input.c                             |    5 +-
 net/iucv/af_iucv.c                                 |   42 +-
 net/kcm/kcmsock.c                                  |   21 +-
 net/l2tp/l2tp_core.c                               |   16 +-
 net/l2tp/l2tp_core.h                               |    3 +-
 net/l2tp/l2tp_debugfs.c                            |    4 +
 net/l2tp/l2tp_netlink.c                            |   20 +-
 net/l2tp/l2tp_ppp.c                                |  151 +-
 net/mac80211/agg-rx.c                              |    2 +-
 net/mac80211/chan.c                                |   37 +-
 net/mac80211/fils_aead.c                           |    8 +
 net/mac80211/ibss.c                                |    9 +-
 net/mac80211/mesh_pathtbl.c                        |   16 +-
 net/mac80211/mlme.c                                |   10 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   30 +-
 net/mac80211/sta_info.c                            |   85 +-
 net/mac80211/tx.c                                  |   11 +
 net/mctp/device.c                                  |   21 +-
 net/mctp/route.c                                   |   43 +-
 net/mpls/af_mpls.c                                 |   40 +-
 net/mptcp/options.c                                |   70 +-
 net/mptcp/pm_netlink.c                             |   10 +-
 net/mptcp/pm_userspace.c                           |   37 +-
 net/mptcp/protocol.c                               |   45 +-
 net/mptcp/protocol.h                               |   11 +-
 net/ncsi/ncsi-manage.c                             |    2 +
 net/netfilter/core.c                               |    6 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h            |    2 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |    3 +
 net/netfilter/ipvs/ip_vs_core.c                    |   11 +-
 net/netfilter/ipvs/ip_vs_lblc.c                    |    4 +
 net/netfilter/ipvs/ip_vs_lblcr.c                   |    3 +
 net/netfilter/ipvs/ip_vs_sync.c                    |   33 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   49 +-
 net/netfilter/nf_conntrack_bpf.c                   |   85 +-
 net/netfilter/nf_conntrack_core.c                  |   39 +-
 net/netfilter/nf_conntrack_expect.c                |  148 +-
 net/netfilter/nf_conntrack_h323_main.c             |    4 +-
 net/netfilter/nf_conntrack_helper.c                |   10 +-
 net/netfilter/nf_conntrack_netlink.c               |   24 +-
 net/netfilter/nf_conntrack_sip.c                   |   13 +-
 net/netfilter/nf_conntrack_timeout.c               |   27 +-
 net/netfilter/nf_flow_table_ip.c                   |    3 +
 net/netfilter/nf_nat_bpf.c                         |    3 +
 net/netfilter/nf_nat_core.c                        |   15 +-
 net/netfilter/nf_synproxy_core.c                   |   40 +-
 net/netfilter/nf_tables_api.c                      |  149 +-
 net/netfilter/nf_tables_core.c                     |    6 +-
 net/netfilter/nf_tables_trace.c                    |    2 +-
 net/netfilter/nfnetlink_cttimeout.c                |  114 +-
 net/netfilter/nfnetlink_log.c                      |   23 +-
 net/netfilter/nfnetlink_queue.c                    |  186 +-
 net/netfilter/nft_bitwise.c                        |   21 +-
 net/netfilter/nft_byteorder.c                      |   16 +-
 net/netfilter/nft_cmp.c                            |    9 +-
 net/netfilter/nft_compat.c                         |   33 +-
 net/netfilter/nft_connlimit.c                      |    3 +-
 net/netfilter/nft_counter.c                        |    3 +-
 net/netfilter/nft_ct.c                             |   24 +-
 net/netfilter/nft_dup_netdev.c                     |    3 +-
 net/netfilter/nft_dynset.c                         |   28 +-
 net/netfilter/nft_exthdr.c                         |    9 +-
 net/netfilter/nft_fib.c                            |   11 +-
 net/netfilter/nft_fib_netdev.c                     |   29 +-
 net/netfilter/nft_flow_offload.c                   |   14 +-
 net/netfilter/nft_fwd_netdev.c                     |    6 +-
 net/netfilter/nft_hash.c                           |    4 +-
 net/netfilter/nft_immediate.c                      |    3 +-
 net/netfilter/nft_last.c                           |    3 +-
 net/netfilter/nft_limit.c                          |    5 +-
 net/netfilter/nft_log.c                            |    3 +-
 net/netfilter/nft_lookup.c                         |   17 +-
 net/netfilter/nft_masq.c                           |    3 +-
 net/netfilter/nft_meta.c                           |    5 +-
 net/netfilter/nft_nat.c                            |    3 +-
 net/netfilter/nft_numgen.c                         |    6 +-
 net/netfilter/nft_objref.c                         |    6 +-
 net/netfilter/nft_osf.c                            |    3 +-
 net/netfilter/nft_payload.c                        |    6 +-
 net/netfilter/nft_queue.c                          |    6 +-
 net/netfilter/nft_quota.c                          |    3 +-
 net/netfilter/nft_range.c                          |    3 +-
 net/netfilter/nft_redir.c                          |    3 +-
 net/netfilter/nft_reject.c                         |    3 +-
 net/netfilter/nft_rt.c                             |    2 +-
 net/netfilter/nft_set_bitmap.c                     |    4 +-
 net/netfilter/nft_set_hash.c                       |    8 +-
 net/netfilter/nft_set_pipapo.c                     |   26 +-
 net/netfilter/nft_set_rbtree.c                     |   10 +-
 net/netfilter/nft_socket.c                         |    2 +-
 net/netfilter/nft_synproxy.c                       |    3 +-
 net/netfilter/nft_tproxy.c                         |    2 +-
 net/netfilter/nft_tunnel.c                         |    2 +-
 net/netfilter/nft_xfrm.c                           |    2 +-
 net/netfilter/xt_CT.c                              |    2 +-
 net/netfilter/xt_IDLETIMER.c                       |   52 +-
 net/netlink/af_netlink.c                           |    6 +-
 net/netlink/genetlink.c                            |   28 +-
 net/nfc/nci/core.c                                 |    9 +
 net/openvswitch/actions.c                          |    7 +-
 net/openvswitch/conntrack.c                        |   71 +-
 net/openvswitch/datapath.c                         |    8 +
 net/packet/af_packet.c                             |  103 +-
 net/phonet/socket.c                                |   10 +-
 net/qrtr/mhi.c                                     |   61 +-
 net/rds/rdma_transport.c                           |   38 +-
 net/rds/tcp.c                                      |   66 +-
 net/rxrpc/ar-internal.h                            |    9 +-
 net/rxrpc/call_accept.c                            |    5 +
 net/rxrpc/conn_event.c                             |   34 +-
 net/rxrpc/output.c                                 |   12 +-
 net/rxrpc/peer_event.c                             |   17 +-
 net/rxrpc/proc.c                                   |    4 +-
 net/rxrpc/recvmsg.c                                |   16 +-
 net/rxrpc/rxkad.c                                  |    5 +-
 net/sched/act_api.c                                |   46 +-
 net/sched/act_ife.c                                |   32 +-
 net/sched/act_mirred.c                             |   14 +-
 net/sched/act_pedit.c                              |   11 +-
 net/sched/cls_api.c                                |   93 +-
 net/sched/cls_basic.c                              |    6 +-
 net/sched/cls_bpf.c                                |    8 +-
 net/sched/cls_cgroup.c                             |    2 +-
 net/sched/cls_flow.c                               |    2 +-
 net/sched/cls_flower.c                             |   34 +-
 net/sched/cls_fw.c                                 |    4 +-
 net/sched/cls_matchall.c                           |    6 +-
 net/sched/cls_route.c                              |    4 +-
 net/sched/cls_u32.c                                |   23 +-
 net/sched/em_text.c                                |    3 +
 net/sched/sch_cake.c                               |    2 +-
 net/sched/sch_codel.c                              |   14 +-
 net/sched/sch_drr.c                                |    2 +-
 net/sched/sch_ets.c                                |    2 +-
 net/sched/sch_fifo.c                               |   13 +-
 net/sched/sch_fq.c                                 |   18 +-
 net/sched/sch_fq_codel.c                           |   18 +-
 net/sched/sch_fq_pie.c                             |   14 +-
 net/sched/sch_generic.c                            |   47 +-
 net/sched/sch_gred.c                               |    4 +-
 net/sched/sch_hfsc.c                               |    2 +-
 net/sched/sch_hhf.c                                |   12 +-
 net/sched/sch_htb.c                                |    2 +-
 net/sched/sch_multiq.c                             |    2 +-
 net/sched/sch_netem.c                              |    5 +-
 net/sched/sch_pie.c                                |   12 +-
 net/sched/sch_plug.c                               |    2 +-
 net/sched/sch_prio.c                               |    2 +-
 net/sched/sch_qfq.c                                |    2 +-
 net/sched/sch_sfb.c                                |    2 +-
 net/sched/sch_sfq.c                                |    2 +-
 net/sctp/bind_addr.c                               |   11 +-
 net/sctp/inqueue.c                                 |    6 +-
 net/sctp/ipv6.c                                    |   10 +-
 net/sctp/protocol.c                                |    5 +-
 net/sctp/sm_make_chunk.c                           |   17 +-
 net/sctp/sm_statefuns.c                            |   36 +-
 net/sctp/socket.c                                  |   39 +-
 net/smc/af_smc.c                                   |  117 +-
 net/smc/smc.h                                      |    6 +-
 net/strparser/strparser.c                          |    6 +-
 net/sunrpc/auth_gss/gss_krb5_mech.c                |   17 +-
 net/sunrpc/auth_gss/gss_krb5_unseal.c              |    3 +
 net/sunrpc/auth_gss/gss_rpc_xdr.c                  |   15 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |  193 +-
 net/sunrpc/clnt.c                                  |   22 +-
 net/sunrpc/svc.c                                   |   13 +-
 net/sunrpc/svcsock.c                               |    3 +
 net/sunrpc/xdr.c                                   |    7 -
 net/sunrpc/xprtrdma/svc_rdma_pcl.c                 |    2 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |   22 +-
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  |   36 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |   47 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |  125 +-
 net/sunrpc/xprtsock.c                              |   29 +-
 net/tipc/core.c                                    |    4 +-
 net/tipc/crypto.c                                  |   20 +-
 net/tipc/node.c                                    |   12 +-
 net/tipc/topsrv.c                                  |   80 +-
 net/tipc/udp_media.c                               |   75 +-
 net/tls/tls_device.c                               |    4 +-
 net/tls/tls_sw.c                                   |    2 +
 net/vmw_vsock/af_vsock.c                           |   55 +-
 net/vmw_vsock/virtio_transport_common.c            |    3 +-
 net/wireless/core.c                                |   39 +-
 net/wireless/core.h                                |    4 +-
 net/wireless/lib80211_crypt_tkip.c                 |   13 +-
 net/wireless/nl80211.c                             |   13 +-
 net/wireless/pmsr.c                                |    6 +-
 net/wireless/scan.c                                |   38 +-
 net/wireless/sme.c                                 |    6 +-
 net/xfrm/espintcp.c                                |    1 +
 net/xfrm/xfrm_device.c                             |   19 +-
 net/xfrm/xfrm_input.c                              |   15 +-
 net/xfrm/xfrm_policy.c                             |   21 +-
 net/xfrm/xfrm_state.c                              |  144 +-
 net/xfrm/xfrm_user.c                               |   10 +-
 samples/ftrace/ftrace-direct-multi-modify.c        |   13 +-
 samples/pidfd/Makefile                             |    2 +-
 security/apparmor/domain.c                         |   27 +-
 security/apparmor/include/cred.h                   |    6 +-
 security/apparmor/include/label.h                  |    6 +-
 security/apparmor/include/match.h                  |   12 +-
 security/apparmor/include/policy.h                 |    2 +
 security/apparmor/include/task.h                   |   17 +-
 security/apparmor/match.c                          |   22 +-
 security/apparmor/policy.c                         |   21 +-
 security/apparmor/task.c                           |   32 +-
 security/integrity/ima/ima_appraise.c              |   21 +-
 security/integrity/ima/ima_kexec.c                 |   35 +
 security/keys/key.c                                |   19 +-
 security/keys/keyctl.c                             |   15 +-
 security/keys/keyring.c                            |  150 +-
 security/keys/persistent.c                         |   55 +-
 security/keys/process_keys.c                       |    5 +-
 security/keys/trusted-keys/trusted_tpm1.c          |    6 +-
 security/keys/trusted-keys/trusted_tpm2.c          |    2 +-
 security/landlock/fs.c                             |   10 +-
 security/selinux/avc.c                             |    5 +-
 security/selinux/hooks.c                           |    9 +-
 security/selinux/selinuxfs.c                       |   40 +-
 security/selinux/ss/policydb.c                     |    4 +
 sound/core/oss/mixer_oss.c                         |   32 +
 sound/core/oss/pcm_oss.c                           |   29 +-
 sound/core/seq/oss/seq_oss_event.c                 |    6 +-
 sound/core/seq/oss/seq_oss_event.h                 |    3 +-
 sound/core/seq/oss/seq_oss_ioctl.c                 |    5 +-
 sound/core/seq/oss/seq_oss_midi.c                  |    6 +-
 sound/core/seq/oss/seq_oss_midi.h                  |    2 +-
 sound/core/seq/oss/seq_oss_readq.c                 |   85 +-
 sound/core/seq/oss/seq_oss_rw.c                    |    5 +-
 sound/core/seq/seq_clientmgr.c                     |   60 +-
 sound/core/seq/seq_compat.c                        |    4 +-
 sound/core/seq/seq_fifo.c                          |   98 +-
 sound/core/seq/seq_fifo.h                          |    1 +
 sound/drivers/mtpav.c                              |    6 +-
 sound/pci/hda/cs35l41_hda.c                        |   74 +-
 sound/pci/hda/cs35l41_hda.h                        |    4 +
 sound/soc/amd/acp/acp-mach-common.c                |  371 ++-
 sound/soc/amd/yc/acp6x-mach.c                      |    7 +
 sound/soc/codecs/adau1372.c                        |   18 +-
 sound/soc/codecs/cs42l52.c                         |    2 +-
 sound/soc/codecs/cs42l56.c                         |    2 +-
 sound/soc/codecs/hdac_hda.c                        |    4 +-
 sound/soc/codecs/max98371.c                        |    2 +-
 sound/soc/codecs/nau8822.c                         |    4 +-
 sound/soc/codecs/pcm3168a.c                        |    2 +-
 sound/soc/codecs/rt274.c                           |    4 +-
 sound/soc/codecs/rt286.c                           |    2 +-
 sound/soc/codecs/tas2562.c                         |    8 +-
 sound/soc/codecs/wm8903.c                          |    2 +-
 sound/soc/codecs/wm8978.c                          |    4 +-
 sound/soc/intel/avs/pcm.c                          |    6 +-
 sound/soc/qcom/lpass-cdc-dma.c                     |    2 +-
 sound/soc/qcom/lpass-cpu.c                         |    4 +-
 sound/soc/qcom/qdsp6/q6asm.c                       |    5 +
 sound/soc/samsung/i2s.c                            |    8 +
 sound/soc/soc-topology.c                           |   37 +-
 sound/soc/sof/intel/hda.c                          |    5 +
 sound/soc/sof/ipc4-pcm.c                           |   17 +-
 sound/soc/sof/ipc4-topology.c                      |    7 +-
 sound/soc/stm/stm32_spdifrx.c                      |    2 +-
 sound/soc/tegra/tegra186_asrc.c                    |    2 +-
 sound/usb/caiaq/device.c                           |    3 +
 sound/usb/card.h                                   |    3 +-
 sound/usb/endpoint.c                               |   16 +-
 sound/usb/line6/playback.c                         |    7 +
 sound/usb/misc/ua101.c                             |    9 +
 sound/usb/pcm.c                                    |    3 +-
 sound/usb/quirks.c                                 |    4 +-
 tools/gpio/Makefile                                |    6 +
 tools/perf/tests/bpf.c                             |    3 +-
 tools/perf/util/parse-events.c                     |    2 +-
 tools/testing/cxl/test/cxl.c                       |   14 +-
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c  |    4 +-
 tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c  |    4 +-
 .../selftests/bpf/progs/test_global_func16.c       |    2 +-
 .../selftests/bpf/verifier/atomic_cmpxchg.c        |   11 -
 tools/testing/selftests/bpf/verifier/basic_stack.c |   12 +-
 tools/testing/selftests/bpf/verifier/calls.c       |    4 +-
 tools/testing/selftests/bpf/verifier/raw_stack.c   |    8 +-
 tools/testing/selftests/bpf/verifier/var_off.c     |   57 +-
 .../test.d/filter/event-filter-incomplete.tc       |   24 +
 .../testing/selftests/net/forwarding/tc_actions.sh |    3 -
 tools/testing/selftests/net/tls.c                  |  584 ++++
 tools/testing/selftests/vm/memfd_secret.c          |   30 +-
 virt/kvm/kvm_main.c                                |    3 +-
 1911 files changed, 31056 insertions(+), 45393 deletions(-)


