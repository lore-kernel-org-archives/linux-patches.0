Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208128;
	b=Io/gxprC2UTQ7gu4ujJ61qkAsUUi5q6XH+vNUOvcZCnKgHb1XjlNpyZ/XykjvpdsTl3x
	 WUxqV/2uco99QJ7v5RnRv52H8i3mrw01TihGsLTFGtb4xb+AG6Uy6bx5El2QQgjFOed3B
	 G0IcMdKvkn33z15UxgYSOu0G6f5dtU8X+gKMHpPAv0mJ1p4k0LG/n6M4Rehf9imXCauMA
	 wC3y2eANSVi4mjH4EHgYfs+RC7V8SYvIbBKNr655u1bc+Xg49x7PEYBvzVcFaQSGIg0mg
	 hOjEDIIH1dLCVpxtUuFR/XgU1JQwaPxkBiMHzXACX9Mqp0URoqGnRkTzieuzY/1fdcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=BXiLZOgtkecC1mLq0Iw6mQGv6kseUlahx4q9VYhXnCs=;
	b=45tzMXSMe9QmPtBqrYC1MGmk0RnqupM2DxLYLrMB1Da8dJ2yQpNkxyBjSdhpzxBTkkG7
	 8/+l9ZkJz/hNzLXmaC2yn2Q0VJo8oXhCdtk2VNqETxJSmRA72mGl63PdMevmve21oyfvd
	 IS7Xqt7JPOSH+BgwJjszU3cq8mCHvJzw1HmZzwgRqhUoNeZCKpsdvjmQQG0W0ql3SucGJ
	 iKhiU6GyGxBOpdzG8HzxB4ac5+l+IJodcmdAFySNRSY3NRVta+s1PV4Gp7OP8jTPA58J3
	 65ZRY3Rm6e7KRT9pbfKzwJ7dnDxoSQcqSdi/B837QZ1uw6zv+vInyr8409KfeVUTVIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZAuHcRai;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B4B606A31E;
	Wed, 28 Oct 2026 17:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZAuHcRai
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894EE1F01825;
	Wed, 28 Oct 2026 17:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208126;
	bh=BXiLZOgtkecC1mLq0Iw6mQGv6kseUlahx4q9VYhXnCs=;
	h=From:To:Cc:Subject:Date;
	b=ZAuHcRaiW8FXXXHdT7nUftUPE1/knUtrfYyha1l3/HKvndUGOK0wC5QB7rlhOUEdB
	 qfpwEsULovE3RJnUpQAwsGLZM3urw/NyORwR7S8ob3bKJ1yygPfWd29DEG23oAD4V3
	 xzHkHhjY11V2XmwePIsGEvHayCEjrC6cu/Ux2DEk=
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
Subject: [PATCH 5.10 000/516] 5.10.273-rc1 review
Date: Wed, 28 Oct 2026 17:52:32 +0100
Message-ID: <20261028170003.522232767@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.273-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.273-rc1
X-KernelTest-Deadline: 2026-10-30T17:00+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.273 release.
There are 516 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.273-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.273-rc1

Christian Brauner <brauner@kernel.org>
    signal: don't retarget shared signals in a dying thread group

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

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix 64-bit and signed histogram fields on 32-bit kernels

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Unregister field variable histograms when the command fails

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Save the event file instead of the compatible histogram

Kyle Zeng <kylebot@openai.com>
    tracing: Reject incomplete event filter expressions

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: refuse __l2cap_chan_add if chan already has conn

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: access chan->conn safely in get/setsockopt

Jonas Köppeler <j.koeppeler@tu-berlin.de>
    net_sched: codel: fix stale state for empty flows in fq_codel

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: unconditionally bump set->nelems before insertion

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: always increment set element count

Xiang Mei <xmei5@asu.edu>
    net: bonding: fix use-after-free in bond_xmit_broadcast()

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

Jun Yang <littleddfu@gmail.com>
    net: bridge: mcast: don't truncate the port group walk on teardown

Ido Schimmel <idosch@nvidia.com>
    ipv4: udp: Create exceptions before socket matching

Chen Cheng <chencheng@fnnas.com>
    dm-integrity: require stable writes for internal hash modes

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: release flowtable after rcu grace period on error

Usama Arif <usama.arif@linux.dev>
    mm/huge_memory: transfer the pmd dirty bit to the folio on zap

Linmao Li <lilinmao@kylinos.cn>
    Input: byd - synchronize timer deletion before freeing private data

Christian Brauner <brauner@kernel.org>
    unicode: free the map after a grace period

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    watch_queue: Fix note pool publication race in watch_queue_set_size()

Daniil Stas <daniil.stas@posteo.net>
    hwmon: (drivetemp) Fix driver producing garbage data when SCSI errors occur

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: vgic-its: Don't dereference a NULL collection on ITT save

Laurence Oberman <loberman@redhat.com>
    scsi: st: Fix use-after-free race between st_remove() and st_open()

Lee Jones <lee@kernel.org>
    tracing/histograms: Reject non-stacktrace fields for synthetic stacktrace fields

Aohan Mei <henrymei@tencent.com>
    net/sched: cls_flower: validate mask pointer after nla_next()

Hyunwoo Kim <imv4bel@gmail.com>
    KVM: x86/mmu: Preserve nested TDP shadow page tables if they are used as roots

Di Shen <di.shen@unisoc.com>
    OPP: Fix race between OPP addition and lookup

Zhang Changzhong <zhangchangzhong@huawei.com>
    net/sched: cls_u32: skip hash tables in u32_bind_class()

Linus Torvalds <torvalds@linux-foundation.org>
    security/keys: fix missed RCU read section on lookup

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Fix VCE 3 ring align_mask

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/vmalloc: acquire init_mm lock on huge vmap to avoid ptdump UAF

Hao Sun <sunhao.th@gmail.com>
    bpf: Reject variable offset alu on PTR_TO_FLOW_KEYS

Zihan Xi <zihanx@nebusec.ai>
    ipv4: avoid divide by zero in fib_rebalance

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix leak of uninitialized kernel data in SCLP report

Aswin Karuvally <aswin@linux.ibm.com>
    s390/ctcm: Prevent XID null dereference

Charles Vosburgh <theminershive@gmail.com>
    sctp: validate chunk length in the inqueue parser

Chengfeng Ye <nicoyip.dev@gmail.com>
    tipc: protect node reset trace dump with node lock

Genjian Zhang <zhanggenjian@kylinos.cn>
    dm-ebs: fix incorrect device offset check in ebs_ctr()

Ben Cressey <ben@cressey.dev>
    dm-crypt: fix a tiny race condition in crypt_dec_pending

Benjamin Marzinski <bmarzins@redhat.com>
    dm cache: fix issue with background work locking

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix demotion stats in passthrough mode

Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
    tcp: fix use-after-free in do_tcp_getsockopt(TCP_CC_INFO)

Heyang Tan <thy15333007817@163.com>
    wifi: p54: validate firmware record lengths

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

Loic Poulain <loic.poulain@oss.qualcomm.com>
    i2c: qcom-cci: Fix HALT_ACK reset request being dropped

Sasha Levin <sashal@kernel.org>
    tools: gpio: fix building from the top level with O=

Daehyeon Ko <4ncienth@gmail.com>
    sctp: revalidate output stream after association connect wait

Aohan Mei <henrymei@tencent.com>
    net: rds: fix uninitialized trans dereference in CM event handler

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    net/sched: fix use-after-free in __tcf_action_put()

Kyle Zeng <kylebot@openai.com>
    fsnotify: prevent mark additions during connector teardown

Amirmohammad Eftekhar <amirmohammadeftekhar@gmail.com>
    KVM: nVMX: Reset MMU back to the root MMU if loading L2 state fails for !VM-Entry

Sung Byeongchan <tjdqudcks0424@naver.com>
    autofs: ignore notification errors from a replaced pipe

Kyle Zeng <kylebot@openai.com>
    netlink: avoid hashing the network namespace pointer

Eric Dumazet <edumazet@google.com>
    net: initialize net->net_cookie at netns setup

Kyle Zeng <kylebot@openai.com>
    pipe: preserve existing fasync readers on writer setup failure

Nickolai Zeldovich <nickolai@csail.mit.edu>
    exit: fix lost-update race on the child_subreaper bitfields

Christian Brauner <brauner@kernel.org>
    clone: add CLONE_AUTOREAP

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

Kyle Zeng <kylebot@openai.com>
    netlink: reset skb headers before unicast and multicast filtering

Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
    netlink: Reverse the patch which removed filtering

Florian Westphal <fw@strlen.de>
    netlink: remove netlink_broadcast_filtered

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

Michal Luczaj <mhal@rbox.co>
    vsock: treat TCP_CLOSING as once-established

Michael Kelley <mhkelley58@gmail.com>
    Drivers: hv: Don't reset VMBus connection state on error/exit paths

Xueqin Luo <luoxueqin@kylinos.cn>
    power: supply: ds2780: Fix ds2780_get_capacity() returning raw value

Andrii Nakryiko <andrii@kernel.org>
    bpf: fix potential 32-bit overflow when accessing ARRAY map element

Geliang Tang <tanggeliang@kylinos.cn>
    skmsg: Skip zero length skb in sk_msg_recvmsg

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Do mark_chain_precision for ARG_CONST_ALLOC_SIZE_OR_ZERO

Jinu Kim <kimjw04271234@gmail.com>
    KVM: x86: Use active memslots for the per-vCPU MMIO cache

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

Dave Chinner <dchinner@redhat.com>
    xfs: buffer pins need to hold a buffer reference

Darrick J. Wong <djwong@kernel.org>
    xfs: fix intermittent hang during quotacheck

Guo Xuenan <guoxuenan@huawei.com>
    xfs: fix super block buf log item UAF during force shutdown

Dave Chinner <dchinner@redhat.com>
    xfs: remove xfs_buf_t typedef

Dave Chinner <dchinner@redhat.com>
    xfs: aborting inodes on shutdown may need buffer lock

Dave Chinner <dchinner@redhat.com>
    xfs: log items should have a xlog pointer, not a mount

Dave Chinner <dchinner@redhat.com>
    xfs: convert XLOG_FORCED_SHUTDOWN() to xlog_is_shutdown()

Dave Chinner <dchinner@redhat.com>
    xfs: don't nest icloglock inside ic_callback_lock

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: improve the code that checks recovered refcount intent items

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: hoist recovered refcount intent checks out of xfs_cui_item_recover

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: improve the code that checks recovered rmap intent items

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: hoist recovered rmap intent checks out of xfs_rui_item_recover

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: improve the code that checks recovered bmap intent items

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: hoist recovered bmap intent checks out of xfs_bui_item_recover

Tahera Fahimi <taherafahimi@linux.microsoft.com>
    xfrm: prevent policy_hthresh.work from racing with netns teardown

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix crash when nf_trace is enabled

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    devm-helpers: Fix devm_delayed_work_autocancel() kerneldoc

Christian Brauner <brauner@kernel.org>
    namespace: handle mount locking for automounts correctly

Christian Brauner <brauner@kernel.org>
    fcntl: refuse F_SET_RW_HINT on an immutable inode

Christian Brauner <brauner@kernel.org>
    namespace: don't copy an unmounted mount tree

Christian Brauner <brauner@kernel.org>
    namespace: unhash a dentry before detaching the mounts on it

Krzysztof Karas <krzysztof.karas@intel.com>
    drm/i915/gt: Unmask interrupts only when ACTIVE is true

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    drm/fb-helper: defer setup when fbdev_probe() fails, not just on -EAGAIN

Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>
    scsi: ch: Do not keep references to data transfer element devices

Shao-Fu Chen <shf.chen@mediatek.com>
    optee: register TEE devices only once fully initialized

Shawn Lin <shawn.lin@rock-chips.com>
    pmdomain: rockchip: propagate subdomain add errors

Shawn Lin <shawn.lin@rock-chips.com>
    pmdomain: rockchip: don't ignore clock lookup errors on attach

Shawn Lin <shawn.lin@rock-chips.com>
    pmdomain: rockchip: fix clock leak on domain probe failure

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix reading free memory in do_resume

Matthew Wilcox (Oracle) <willy@infradead.org>
    highmem: round down the address passed to kunmap_flush_on_unmap()

Christian Brauner <brauner@kernel.org>
    namespace: check the mounts before reading their parents in pivot_root()

Christian Brauner <brauner@kernel.org>
    namespace: don't inherit MNT_UMOUNT in clone_mnt()

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

Zixuan Chai <petalzu987@gmail.com>
    net: bridge: avoid recursive multicast port cleanup

Felix Fietkau <nbd@nbd.name>
    netfilter: nf_tables: fix bidirectional offload regression

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP

Vishal Badole <Vishal.Badole@amd.com>
    EDAC/amd64: Mask UMC chip select to the four implemented selects

Christian Göttsche <cgzones@googlemail.com>
    selinux: fix data race on AVC latest_notif

Michele Dionisio <michele.dionisio@gmail.com>
    wifi: brcmfmac: fix P2P device removal race in brcmf_detach()

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

Sang-Hoon Choi <csh0052@gmail.com>
    nvmet: use the local P2P device on metadata allocation failure

Sang-Hoon Choi <csh0052@gmail.com>
    cxgb4/ch_ktls: disable softirqs around tid_list erases

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: em_text: reject unterminated algo before autoload

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Free the BO cache size list on teardown

Myeonghun Pak <mhun512@gmail.com>
    drm/aspeed: Balance the display clock enable on teardown

Alexandru Hossu <hossu.alexandru@gmail.com>
    staging: rtl8723bs: fix OOB read in OnAssocRsp() IE loop

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

Krzysztof Karas <krzysztof.karas@intel.com>
    drm/i915/gem: Prevent overstepping exec array boundary

Palla Raghunath <raghunathpalla.0209@gmail.com>
    Bluetooth: RFCOMM: Fix NULL tty_dev dereference in rfcomm_dev_shutdown

Maxim Skokov <skokovmaksimevg@gmail.com>
    Bluetooth: RFCOMM: free the skb when the DLC has no owner

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sock: Serialize dead-device detachment

Runyu Xiao <runyu.xiao@seu.edu.cn>
    scsi: qedi: Initialize callback state before registration

Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>
    regulator: ltc3676: don't read the write-only HRST and CLIRQ registers

Denis V. Lunev <den@openvz.org>
    openvswitch: fix soft lockup in the netlink flow dump

Fredrik Nyberg <fredrik.nyberg@volvocars.com>
    net: usb: ax88179_178a: fix rx frame length for non-last packets

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
    ibmveth: h_free logical LAN on open-fail after register

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

Palla Raghunath <raghunathpalla.0209@gmail.com>
    dm ioctl: don't let data_start run past the buffer

Wentao Liang <vulab@iscas.ac.cn>
    btrfs: scrub: fix local_root reference leak in scrub_print_warning_inode()

Eric Biggers <ebiggers@kernel.org>
    crypto: drbg - Fix ineffective sanity check

Carlos Llamas <cmllamas@google.com>
    HID: uhid: convert to hid_safe_input_report()

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: introduce hid_safe_input_report()

Cong Nguyen <congnt264@gmail.com>
    iio: adc: max1363: sign-extend bipolar differential channel reads

Pengpeng Hou <pengpeng@iscas.ac.cn>
    iio: adc: aspeed: propagate reset deassert errors

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

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: introduce and use tty_port_tty_vhangup() helper

Eric Dumazet <edumazet@kernel.org>
    bnxt_en: fix DMA mapping length for padded small packets

Johan Hovold <johan@kernel.org>
    USB: serial: fix driver deregistration order

Johan Hovold <johan@kernel.org>
    USB: serial: clean up core error labels

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: account proxy paths against the mesh path limit

Han Xu <han.xu@nxp.com>
    mtd: spinand: Enable QE on all dies

Pei Xiao <xiaopei01@kylinos.cn>
    mtd: block2mtd: Fix divide error when erase_size is zero

Johan Hovold <johan@kernel.org>
    USB: serial: fix ioctl hangup race

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Fix KASAN reported use-after-free when request is canceled

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: keep fallback association elements alive

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Mark DCE 6.4 as not APU

Johan Hovold <johan@kernel.org>
    serial: fix TIOCMIWAIT race

Mingyu Wang <25181214217@stu.xidian.edu.cn>
    tty: vt: fix memory leak in vc_allocate()

David Heidelberg <david@ixit.cz>
    Input: s6sy761 - fix resume ordering and restore sensing

Fan Wu <fanwu01@zju.edu.cn>
    tty: serial: max3100: shut down timer before freeing port

Johan Hovold <johan@kernel.org>
    tty: abort break signalling on hangup

Johan Hovold <johan@kernel.org>
    tty: tty_port: restore TTY_IO_ERROR on activation failure

Pannarat Wiriyaarritham <pannarat.wiriyaarritham@danielcorp.dev>
    usb: typec: ucsi: acpi: Assume UCSI 1.2 on Acer Nitro ANV15-41

Fan Wu <fanwu01@zju.edu.cn>
    usb: cdns3: fix use-after-free in cdns3_gadget_exit()

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-spear: disable controller wakeup on removal

Chen Ni <nichen@iscas.ac.cn>
    usb: ohci-spear: Remove unnecessary NULL check before clk_disable_unprepare()

Orgad Shaneh <orgads@gmail.com>
    usb: octeon-hcd: fix the FIFO-flush timeout computation

Willian Oliveira <williandossantosdeoliveira287@gmail.com>
    drm/amdgpu/gfx6: fix firmware leak on teardown

Guangshuo Li <lgs201920130244@gmail.com>
    drm/amdgpu: fix ACP MFD device leak on init failure

Francisco Beltrán Millalén <fbeltranmillalen@gmail.com>
    drm/amdgpu: reset VI ASIC on MacBookPro14,3

Andre Eikmeyer <dev@deq.rocks>
    drm/amdgpu: reset VI ASIC on MacBookPro15,1

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/si: Fix updating clock limits on AC/DC

Eric Biggers <ebiggers@kernel.org>
    fsverity: add dependency on 64K or smaller pages

Beata Michalska <beata.michalska@arm.com>
    arm64: errata: Add Cortex-A725 erratum 3821522 workaround

Beata Michalska <beata.michalska@arm.com>
    arm64: errata: Factor out broken AMU const counter cap

Kyle Zeng <kylebot@openai.com>
    ALSA: seq: Serialize compat port-info ioctls

Zhengchuan Liang <zcliangcn@gmail.com>
    perf: Require kernel access for text poke events

Johan Hovold <johan@kernel.org>
    tty: fix saved termios reset race

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    soc: qcom: geni-se: Correct QUP Core ICC vote constants

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/si: Check AMD_IS_MOBILITY flag for PPSMC_SYSTEMFLAG_GPIO_DC

Jiangshan Yi <yijiangshan@kylinos.cn>
    smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions

Josef Bacik <josef@toxicpanda.com>
    xen/netfront: drop RX packets with a short Ethernet header

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: constrain TCPM_SOURCING_VBUS event handling

Xu Yang <xu.yang_2@nxp.com>
    usb: typec: tcpm: fix debug accessory mode detection for sink ports

Gilberto Conde <gilbertorconde@gmail.com>
    net: usb: qmi_wwan: add Quectel EG120K-EA

Tristan Madani <tristan@talencesecurity.com>
    wifi: wcn36xx: fix heap overflow from oversized firmware HAL response

Kyle Zeng <kylebot@openai.com>
    ALSA: seq: Clear variable event pointer on read

Lu Baolu <baolu.lu@linux.intel.com>
    iommu: disable SVA when CONFIG_X86 is set

Kuniyuki Iwashima <kuniyu@google.com>
    vxlan: Fix potential null-ptr-deref in vxlan_gro_prepare_receive().

Stefan Wahren <stefan.wahren@i2se.com>
    staging: vchiq_arm: Avoid NULL ptr deref in vchiq_dump_platform_instances

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix WQ_MEM_RECLAIM warning

Wentao Liang <vulab@iscas.ac.cn>
    wifi: wlcore: Fix runtime PM leak in wlcore_remove()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    wifi: wlcore: Convert to platform remove callback returning void

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    wifi: wl12xx: Drop if with an always false condition

Frank Sorenson <sorenson@redhat.com>
    smb: client: split cifsFileInfo bitfields to avoid shared-byte RMW races

Mehmet Fide <mehmet.fide@screeningeagle.com>
    mtd: rawnand: vf610_nfc: fix false bitflips on reads of erased pages

Jakub Kicinski <kuba@kernel.org>
    page_pool: always add GFP_NOWARN for ATOMIC allocations

Yi Yang <yiyang13@huawei.com>
    vc_screen: reload vc pointer before if (ret) in vcs_write() to avoid UAF

Chris Mason <clm@meta.com>
    SUNRPC: reject duplicate CREDS_VALUE options

Chris Mason <clm@meta.com>
    SUNRPC: fix gssx_dec_option_array error path bugs

Asad Kamal <asad.kamal@amd.com>
    drm/amd/powerplay: fix VoltageObjectInfo zero-stride loop and OOB read

Amit Pundir <amit.pundir@linaro.org>
    arm64: dts: qcom: sdm845-db845c: Mark cont splash memory region as reserved

Sasha Levin <sashal@kernel.org>
    Revert "scsi: sd: sd_zbc: Use logical blocks as unit when querying zones"

Victor Nogueira <victor@mojatatu.com>
    net: sched: cls_u32: Undo tcf_bind_filter if u32_replace_hw_knode

Bart Van Assche <bvanassche@acm.org>
    loop: Fix use-after-free issues

Cong Nguyen <congnt264@gmail.com>
    iio: proximity: pulsedlight: fix iio_device left registered on PM setup failure

Salah Triki <salah.triki@gmail.com>
    iio: proximity: isl29501: Fix return type of isl29501_register_write

Fan Wu <fanwu01@zju.edu.cn>
    iio: light: gp2ap020a00f: drain irq_work after free_irq

Arka Mondal <arkamondalofficial@gmail.com>
    iio: imu: adis16480: fix unprotected debugfs reads

Arka Mondal <arkamondalofficial@gmail.com>
    iio: imu: adis16400: fix unprotected debugfs reads

Arka Mondal <arkamondalofficial@gmail.com>
    iio: gyro: adis16136: fix unprotected debugfs reads

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

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: drain PS delivery work during station teardown

Guangshuo Li <lgs201920130244@gmail.com>
    wifi: iwlegacy: 3945: free EEPROM data on remove

Tianchu Chen <flynnnchen@tencent.com>
    wifi: cw1200: fix TX padding OOB read leaking heap data to device

Mehmet Fide <mehmet.fide@screeningeagle.com>
    mtd: rawnand: vf610_nfc: fix reads on chips with more than 64 bytes of OOB

Runyu Xiao <runyu.xiao@seu.edu.cn>
    mtd: rawnand: cadence: Initialize IRQ state before requesting IRQ

Daehyeon Ko <4ncienth@gmail.com>
    nvme-multipath: fix underflow in ANA log bounds checks

Leon Hwang <leon.hwang@linux.dev>
    kprobes: Skip disarmed probes when checking optkprobe overlap

Zhiling Zou <zhilinz@nebusec.ai>
    ipvs: bound LBLCR and LBLC cache growth

Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
    Bluetooth: btintel: fix buffer over-read in btintel_hw_error()

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_core: Serialize ACL scheduling with channel deletion

Linmao Li <lilinmao@kylinos.cn>
    Bluetooth: hci_core: Fix inquiry cache timestamps on 64-bit systems

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: RFCOMM: Fix initial port reference race

Xiang Mei <xmei5@asu.edu>
    ALSA: ua101: reject mismatched capture/playback packet sizes

Wentao Liang <vulab@iscas.ac.cn>
    serial: vt8500: Fix clock reference leak in vt8500_serial_probe()

Simon Gassner <simon.gassner@noxsystems.com>
    serial: tegra: don't clear the Tx FIFO on an Rx-only reset

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    tty: serial: qcom_geni_serial: Keep console RX functional after deep idle

Joshua Rogers <linux@joshua.hu>
    tty: vcc: hold port lock when clearing tty pointer in vcc_cleanup

Joshua Rogers <linux@joshua.hu>
    tty: vcc: zero-initialize control packet in vcc_send_ctl()

Johan Hovold <johan@kernel.org>
    tty: amiserial: fix broken TIOCMIWAIT

Jie Deng <dengjie03@kylinos.cn>
    usb: cdns3: Fix NULL pointer dereference in cdns3_pci_probe

Jameson Thies <jthies@google.com>
    usb: typec: ucsi: displayport: Current CAM OOB index fixup

Prashanth K <prashanth.k@oss.qualcomm.com>
    usb: typec: ucsi: Get the connector fwnode based on reg value

Hui Peng <benquike@gmail.com>
    usb: core: clear both ep_in and ep_out for non-ep0 control endpoints

Yuchao Zhang <ndaugoing@gmail.com>
    usb: gadget: f_fs: Fix NULL pointer dereference in FUNCTIONFS_ENDPOINT_DESC

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: dummy-hcd: Fix wait for outstanding request completions

Fan Wu <fanwu01@zju.edu.cn>
    usb: gadget: aspeed-vhub: cancel wake work on device removal

Liu Chao <liuc63@xiaopeng.com>
    usb: gadget: f_uac1_legacy: validate bRequest index in generic_{set,get}_cmd

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-st: disable controller wakeup on removal

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-s3c2410: disable controller wakeup on removal

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-da8xx: disable controller wakeup on cleanup

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    usb: hub: use shorter 120ms post resume hold for SS root hubs

Syed Labeeq Sajid Bukhari <syedlabeeq@gmail.com>
    usb: storage: sierra_ms: reject short SWoC info transfers

Johan Hovold <johan@kernel.org>
    USB: serial: fix port tear down use-after-free

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix racy TIOCMIWAIT implementation

Yuxiao Wang <yuxiao.wang@certik.com>
    nitro_enclaves: fix use-after-free on SLOT_ALLOC failure

Raphaël Larocque <rlarocque@disroot.org>
    Input: synaptics - limit T440p InterTouch quirk to LEN0036

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    Input: synaptics - add LEN205b entry to smbus_pnp_ids for ThinkPad T490

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    Input: i8042 - add nomux quirk for Fujitsu LIFEBOOK U7410

Martino Papero <martino.papero@lcb.to.it>
    Input: atkbd - skip deactivate for Lenovo IdeaPad Slim 3 15IWC11

Wentao Liang <vulab@iscas.ac.cn>
    kgdboc: Fix tty driver reference leak in configure_kgdboc()

Imre Kaloz <kaloz@kernel.org>
    drm/radeon: Read the VRAM VBIOS signature with readb()

Nikola Prica <nikola.prica@amd.com>
    PCI: Accept AtomicOps already enabled by the hypervisor

Hongjian Dai <daihongjian@kylinsec.com.cn>
    i2c: at91: release DMA channels when probe defers

Eric Dumazet <edumazet@kernel.org>
    ipv6: sr: use skb_get_hash_net() in seg6_make_flowlabel()

Florian Westphal <fw@strlen.de>
    net: add and use skb_get_hash_net

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: avoid skb access on nf_stolen

Julian Anastasov <ja@ssi.bg>
    ipvs: filter some flags received in the backup server

Julian Anastasov <ja@ssi.bg>
    ipvs: do not create invisible templates

Julian Anastasov <ja@ssi.bg>
    ipvs: fix missing counter decrement in lblc

Jeff Jo <jeffjo@openai.com>
    tcp: refresh TS.Recent for accepted old ACKs

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_codel: match the no-drop threshold to the packet size

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq_codel: match the no-drop threshold to the packet size

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    tipc: prevent GCM nonce reuse on peer key changes

Florian Fainelli <florian.fainelli@broadcom.com>
    net: systemport: Fix RUNT MIB counter register offset calculation

Florian Westphal <fw@strlen.de>
    netfilter: ipset: do not update comments from kernel-side adds

Sai Teja Aluvala <aluvala.sai.teja@intel.com>
    Bluetooth: btintel: validate DDC record lengths

Sang-Hoon Choi <csh0052@gmail.com>
    Bluetooth: hci_core: free the HCI ID if naming fails

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: rt274: Fix format setting for 44100 rate

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: preserve hidden-group beacon IE ownership

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath11k: reset ar->num_stations on hardware start

HyeongJun An <sammiee5311@gmail.com>
    ASoC: wm8903: Move the DRC QR threshold to the register that holds it

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of/overlay: don't create "//" paths for fragments targeting the root

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of/overlay: don't leak fragment references when changeset init fails

Julian Sun <sunjunchao@bytedance.com>
    nvmet: preserve device path on allocation failure

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Initialize NVMe abort_work once at submission

Kuniyuki Iwashima <kuniyu@google.com>
    hsr: Remove WARN_ONCE() in hsr_addr_is_self().

Xiang Mei <xmei5@asu.edu>
    ALSA: line6: reject oversized playback packets

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    ALSA: caiaq: unregister the input device when probe fails

Zizhi Wo <wozizhi@huawei.com>
    vt: skip screen update for DEC alignment test on backgroup consoles

Clément Léger <clement.leger@bootlin.com>
    of/irq: add missing of_node_put() for interrupt parent node

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    vxlan: use one headroom snapshot for neighbour replies

Maoyi Xie <maoyixie.tju@gmail.com>
    rds_tcp: close NULL deref window in rds_tcp_set_callbacks

Xin Long <lucien.xin@gmail.com>
    openvswitch: add nf_ct_is_confirmed check before assigning the helper

Konrad Dybcio <konrad.dybcio@linaro.org>
    drm/msm/adreno: Assign msm_gpu->pdev earlier to avoid nullptrs

Benjamin Berg <benjamin.berg@intel.com>
    wifi: cfg80211: avoid double free if updating BSS fails

Jun Yang <junvyyang@tencent.com>
    sctp: check RCV_SHUTDOWN after the sendmsg connect wait

Runyu Xiao <runyu.xiao@seu.edu.cn>
    rtc: spear: initialize IRQ state before requesting alarm IRQ

Ilkka Lappeteläinen <ilkka.lappetelainen@gmail.com>
    net/packet: prevent TX_RING byte count overflow

Aohan Mei <henrymei@tencent.com>
    netfilter: nft_flow_offload: drop flowtable reference on init error path

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of/overlay: put property on deadprops only after changeset add succeeds

Wentao Liang <vulab@iscas.ac.cn>
    of/irq: Fix remaining refcount leaks in of_irq_init()

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    audit: fix exe mark UAF in kill_rules()

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

Zihan Xi <zihanx@nebusec.ai>
    smb: client: validate POSIX create context length

Florian Eckert <fe@dev.tdt.de>
    tools/thermal/tmon: Fix compilation warning for wrong format

Namjae Jeon <linkinjeon@kernel.org>
    smb: client: use finish_no_open() for non-regular inodes

Guangshuo Li <lgs201920130244@gmail.com>
    net: ena: fix MMIO read buffer leak on probe failure

Ilya Titov <ilya.titov@wirenboard.com>
    pinctrl: sunxi: keep a shadow copy of the data register output latches

Wang Jianzheng <wangjianzheng@vivo.com>
    pinctrl: sunxi: Use devm_clk_get_enabled() helpers

Samuel Holland <samuel@sholland.org>
    pinctrl: sunxi: Refactor register/offset calculation

Yuqi Xu <xuyuqiabc@gmail.com>
    net: ipconfig: bound DHCP option construction

Thorsten Blum <thorsten.blum@linux.dev>
    net: ipconfig: Remove outdated comment and indent code block

Peiyang He <peiyang_he@smail.nju.edu.cn>
    drm/nouveau: don't bump pin count on failed re-pin in nouveau_bo_pin_locked()

Christian König <christian.koenig@amd.com>
    drm/nouveau: switch over to the new pin interface

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf test bpf: Address error about non-null argument for epoll_pwait 2nd arg

Namhyung Kim <namhyung@kernel.org>
    perf tools: Fix a asan issue in parse_events_multi_pmu_add()

Zihan Xi <zihanx@nebusec.ai>
    smb: client: fix create context out-of-bounds reads

Steve French <stfrench@microsoft.com>
    smb3: make query_on_disk_id open context consistent and move to common code

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: conntrack: fix helper UAF due to extensions realloc

Jinjiang Tu <tujinjiang@huawei.com>
    mm/rmap: fix missing barrier between anon_vma init and vma->anon_vma publish

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Remove anythread_deprecated bit from perf_capabilities

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu: Fix runtime PM leak in amdgpu_debugfs_test_ib_show()

Willem de Bruijn <willemb@google.com>
    tcp: prevent collapsing skbs across boundary in rtx queue

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix smbd_connection leak on cifs_get_tcp_session() error

Fan Wu <fanwu01@zju.edu.cn>
    wifi: wcn36xx: Fix potential use-after-free in TX ack timer teardown

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: rtd119x: Avoid division by zero

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    watchdog: rtd119x: Use devm_clk_get_enabled() helper

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix file type corruption in cifs_reparse_point_to_fattr()

Fan Wu <fanwu01@zju.edu.cn>
    hwmon: (gpio-fan) Fix use-after-free in alarm work

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    devm-helpers: Add resource managed version of work init

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    ring-buffer: Acquire the lock with irqsave in rb_wake_up_waiters()

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net/sched: act_api: release all action references on NEWACTION failure

Zihan Xi <zihanx@nebusec.ai>
    ipmr: account multicast table and route memory

Kavan Smith <kavansmith82@gmail.com>
    drm/msm/dsi: round 6G byte clock rate to the PLL-achievable value

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dsi: rename dual DSI to bonded DSI

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dsi: do not enable PHYs when called for the slave DSI interface

Wenjie Qi <qwjhust@gmail.com>
    f2fs: limit recovery filename logging to stored length

Wenjie Qi <qwjhust@gmail.com>
    f2fs: return writeback error from collapse range

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Use memset_io() to clear QLAFX00 request ring slot

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Quiesce response IRQ before freeing request queue

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error path

Ruoyu Wang <ruoyuw560@gmail.com>
    media: zoran: Avoid freeing a registered video_device twice

Guangshuo Li <lgs201920130244@gmail.com>
    media: saa7164: fix cleanup on resource allocation failure

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix length check __import_wp_info()

Yosry Ahmed <yosry@kernel.org>
    KVM: nVMX: Service local TLB flushes on failed nested VM-Enter

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: harmony: initialize locks before requesting IRQ

Takashi Iwai <tiwai@suse.de>
    ALSA: parisc: Fix assignment in if condition

Karl Mehltretter <kmehltretter@gmail.com>
    arm64: mm: Fix the lockless page-table walk in show_pte()

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Synchronize the initialization of ftrace_ops

Muhammad Bilal <meatuni001@gmail.com>
    staging: sm750fb: fix mono image source stride mismatch in lynxfb_ops_imageblit()

Lee Jones <lee.jones@linaro.org>
    staging: sm750fb: sm750_accel: Provide description for 'accel' and fix function naming

Can Peng <pengcan@kylinos.cn>
    spi: bcm63xx: disable clock on resume failure

Jeffin Philip <jeffinphilip14@gmail.com>
    usb: gadget: f_mass_storage: fix null pointer dereference in fsg_common_set_num_buffers()

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix use-after-free of master->this

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Do not treat master device as a duplicate target

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: pcxhr: initialize mutexes before requesting threaded IRQ

Jason Wang <wangborong@cdjrlc.com>
    ALSA: pcxhr: use __func__ to get funcion's name in an output message

Can Peng <pengcan@kylinos.cn>
    hwrng: stm32 - Fix runtime PM cleanup on registration failure

Hidayath Khan <hidayath@linux.ibm.com>
    net/smc: fix socket refcount leak in smc_switch_conns()

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: ucs1002: fix use-after-free on remove

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: bq24257: fix use-after-free on remove

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    workqueue: Add resource managed version of delayed work init

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

Kuan-Wei Chiu <visitorckw@gmail.com>
    coresight: etm3x: Fix cntr_val_show() to match cntr_val_store() behavior

Frank Sorenson <sorenson@redhat.com>
    cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0

Chuck Lever <chuck.lever@oracle.com>
    nfsd: gate nfs2 setacl by argp->mask

Jeff Layton <jlayton@kernel.org>
    nfsd: fix clock domain mismatch in clients_still_reclaiming()

Jeff Layton <jlayton@kernel.org>
    nfsd: check nfsd4_acl_to_attr() return value in nfsd4_create()

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

Baokun Li <libaokun@linux.alibaba.com>
    fuse: fix invalidate lock leak on setattr writeback failure

Baokun Li <libaokun@linux.alibaba.com>
    fuse: fix invalidate lock leak on open O_TRUNC DAX failure

Xiang Mei <xmei5@asu.edu>
    vlan: require the MAC header to be present in __vlan_insert_inner_tag()

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix next_buffer UAF and NextCommand bounds in compound PDUs

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix potential OOB read in smb3_enum_snapshots()

Daehyeon Ko <4ncienth@gmail.com>
    wifi: libipw: reject TKIP frames without a full MIC

Bjoern Doebel <doebel@amazon.de>
    smb: client: avoid leaking refcount in cifs_queue_oplock_break()

Aohan Mei <henrymei@tencent.com>
    smb: client: reject userspace cifs.idmap descriptions

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: end write accounting from ->ki_complete

XingWang Xiang <v3rdant.xiang@gmail.com>
    genetlink: pin family module during policy dump

Xu Rao <raoxu@uniontech.com>
    Bluetooth: btqcomsmd: destroy RPMsg endpoints before freeing hci_dev

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Bluetooth: btqcomsmd: Convert to platform remove callback returning void

Thomas Gleixner <tglx@linutronix.de>
    tick/broadcast: Plug clockevents replacement race

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

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: Protect kprobe_blacklist with RCU

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Take trace_array reference before accessing its ftrace_ops

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in rtw_restruct_wmm_ie()

Vivek BalachandharTN <vivek.balachandhar@gmail.com>
    staging: rtl8723bs: fix spacing around operators

Fan Wu <fanwu01@zju.edu.cn>
    wifi: rtl8xxxu: fix use-after-free from rx_urb_wq on stop

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvme-tcp: reject a read that transferred too few bytes

Daniel Wagner <dwagner@suse.de>
    nvme-tcp: Do not reset transport on data digest errors

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvme-tcp: fix host memory disclosure on R2T for a read command

Varun Prakash <varun@chelsio.com>
    nvme-tcp: validate R2T PDU in nvme_tcp_handle_r2t()

Doruk Tan Ozturk <doruk@0sec.ai>
    ocfs2: validate directory-index entry counts when reading metadata

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: validate dx_root extent list fields during block read

Dave Airlie <airlied@redhat.com>
    nouveau/gem: reserve the bo in the info ioctl around the vma lookup

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix OOB read/write from unvalidated DataOffset in coalesce_t2()

Michael Bommarito <michael.bommarito@gmail.com>
    ceph: bound num_export_targets array for mds info v2/v3

Michael Bommarito <michael.bommarito@gmail.com>
    ceph: bound copied dentry name length in NFS export get_name

Jeff Layton <jlayton@kernel.org>
    nfsd: fix nfsd_file leak on inter-server COPY setup failure

Xu Yang <xu.yang_2@nxp.com>
    device property: fix infinite loop in fwnode_for_each_child_node()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    device property: Add cleanup.h based fwnode_handle_put() scope based cleanup.

Hyunwoo Kim <imv4bel@gmail.com>
    apparmor: fix out-of-bounds write when null terminating a label vec

Jiayuan Chen <jiayuan.chen@linux.dev>
    tls: device: fix out-of-bounds write in tls_append_frag()


-------------

Diffstat:

 Documentation/arm64/silicon-errata.rst             |   2 +
 Documentation/networking/strparser.rst             |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/Kconfig                                 |  30 ++
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |   9 +
 arch/arm64/include/asm/cpucaps.h                   |   2 +-
 arch/arm64/kernel/cpu_errata.c                     |  23 +-
 arch/arm64/kernel/cpufeature.c                     |   2 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |   8 +
 arch/arm64/mm/fault.c                              |  14 +-
 arch/nios2/include/asm/checksum.h                  |   2 +-
 arch/s390/kvm/guestdbg.c                           |   2 +-
 arch/s390/kvm/kvm-s390.c                           |   4 +-
 arch/s390/pci/pci_sysfs.c                          |   3 +
 arch/x86/events/intel/core.c                       |  10 +-
 arch/x86/events/perf_event.h                       |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |   4 +-
 arch/x86/kvm/svm/svm.c                             |   3 +-
 arch/x86/kvm/vmx/nested.c                          |  18 +-
 arch/x86/kvm/x86.h                                 |   4 +-
 crypto/drbg.c                                      |  11 +-
 drivers/base/property.c                            |  19 +-
 drivers/block/loop.c                               |  10 +-
 drivers/block/zram/zram_drv.c                      |   6 +-
 drivers/bluetooth/btintel.c                        |  15 +-
 drivers/bluetooth/btqcomsmd.c                      |  10 +-
 drivers/bluetooth/btusb.c                          |   2 +
 drivers/char/hw_random/stm32-rng.c                 |  12 +-
 drivers/dma/dmaengine.c                            |  30 ++
 drivers/edac/amd64_edac.c                          |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c            |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |  27 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |  17 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c              |   9 +
 drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c             |  25 +-
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c              |   2 +-
 drivers/gpu/drm/amd/amdgpu/vi.c                    |  21 ++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   7 +-
 .../gpu/drm/amd/display/dc/dce60/dce60_resource.c  |   1 -
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |  10 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomfwctrl.c  |  11 +-
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c          |  39 ++-
 drivers/gpu/drm/aspeed/aspeed_gfx_drv.c            |   5 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   8 +-
 drivers/gpu/drm/i915/display/intel_csr.c           |  19 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   2 +-
 drivers/gpu/drm/i915/gt/intel_rps.c                |   3 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   2 +
 drivers/gpu/drm/msm/disp/mdp5/mdp5_ctl.c           |   2 +-
 drivers/gpu/drm/msm/dsi/dsi.h                      |   8 +-
 drivers/gpu/drm/msm/dsi/dsi_cfg.h                  |   2 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  46 ++-
 drivers/gpu/drm/msm/dsi/dsi_manager.c              | 107 +++---
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c         |   2 +-
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_14nm.c         |   6 +-
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_7nm.c          |   2 +-
 drivers/gpu/drm/msm/msm_gpu.c                      |   1 -
 drivers/gpu/drm/nouveau/nouveau_bo.c               |  49 +--
 drivers/gpu/drm/nouveau/nouveau_bo.h               |   3 -
 drivers/gpu/drm/nouveau/nouveau_chan.c             |   2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |  11 +-
 drivers/gpu/drm/radeon/radeon_bios.c               |   6 +-
 drivers/gpu/drm/vc4/vc4_bo.c                       |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |  22 +-
 drivers/hid/hid-alps.c                             |  21 +-
 drivers/hid/hid-core.c                             |  26 +-
 drivers/hid/hid-steam.c                            | 211 ++++++-----
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   5 +-
 drivers/hid/uhid.c                                 |   8 +-
 drivers/hid/usbhid/hid-core.c                      |  11 +-
 drivers/hv/connection.c                            |   1 -
 drivers/hv/vmbus_drv.c                             |   1 -
 drivers/hwmon/drivetemp.c                          |  10 +-
 drivers/hwmon/gpio-fan.c                           |   8 +-
 .../hwtracing/coresight/coresight-etm3x-sysfs.c    |  15 +-
 drivers/i2c/busses/i2c-at91-master.c               |   8 +-
 drivers/i2c/busses/i2c-mxs.c                       |   5 +-
 drivers/i2c/busses/i2c-qcom-cci.c                  |   4 +-
 drivers/i2c/busses/i2c-wmt.c                       |   2 +-
 drivers/i2c/i2c-core-base.c                        |  14 +
 drivers/i3c/master.c                               |  20 +-
 drivers/iio/accel/kxcjk-1013.c                     |   2 +-
 drivers/iio/accel/sca3000.c                        |   2 +-
 drivers/iio/adc/aspeed_adc.c                       |   4 +-
 drivers/iio/adc/max1363.c                          |   8 +
 drivers/iio/adc/sun4i-gpadc-iio.c                  |  10 +-
 drivers/iio/gyro/adis16136.c                       |   2 +-
 drivers/iio/imu/adis16400.c                        |   2 +-
 drivers/iio/imu/adis16480.c                        |   4 +-
 drivers/iio/light/gp2ap020a00f.c                   |   2 +
 drivers/iio/proximity/isl29501.c                   |   2 +-
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c  |   4 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   3 +-
 drivers/input/keyboard/atkbd.c                     |   8 +
 drivers/input/mouse/byd.c                          |   2 +-
 drivers/input/mouse/synaptics.c                    |   7 +-
 drivers/input/serio/i8042-acpipnpio.h              |   9 +
 drivers/input/touchscreen/s6sy761.c                |  14 +-
 drivers/iommu/iommu.c                              |   3 +
 drivers/isdn/capi/capi.c                           |   8 +-
 drivers/md/dm-cache-target.c                       |  59 ++--
 drivers/md/dm-crypt.c                              |  10 +-
 drivers/md/dm-ebs-target.c                         |   3 +-
 drivers/md/dm-integrity.c                          |   5 +-
 drivers/md/dm-ioctl.c                              |  15 +-
 drivers/md/dm-snap.c                               |  14 +
 drivers/md/dm-table.c                              |   2 +-
 drivers/media/pci/saa7164/saa7164-core.c           |   6 +
 drivers/memstick/core/memstick.c                   |   8 +-
 drivers/memstick/host/rtsx_usb_ms.c                |  31 +-
 drivers/mmc/host/cavium-octeon.c                   |   5 +-
 drivers/mmc/host/cavium-thunderx.c                 |   5 +-
 drivers/mmc/host/mtk-sd.c                          |   1 +
 drivers/mmc/host/sdhci-sprd.c                      |   4 +
 drivers/mmc/host/via-sdmmc.c                       |   4 +
 drivers/mtd/devices/block2mtd.c                    |   2 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |   6 +-
 drivers/mtd/nand/raw/vf610_nfc.c                   |  85 ++++-
 drivers/mtd/nand/spi/core.c                        |  21 +-
 drivers/net/bonding/bond_main.c                    |  27 +-
 drivers/net/can/dev/dev.c                          |   2 +
 drivers/net/can/slcan.c                            |   1 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   1 +
 drivers/net/ethernet/broadcom/bcmsysport.c         |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  23 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |   4 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   6 +-
 drivers/net/gtp.c                                  |  18 +-
 drivers/net/team/team.c                            |  67 ++--
 drivers/net/team/team_mode_loadbalance.c           |   4 +-
 drivers/net/usb/ax88179_178a.c                     |   6 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/vxlan/vxlan_core.c                     |  12 +-
 drivers/net/wireguard/noise.c                      |   7 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   1 +
 drivers/net/wireless/ath/wcn36xx/dxe.c             |   2 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |   4 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  25 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |   1 +
 drivers/net/wireless/intersil/p54/fwio.c           |  42 ++-
 drivers/net/wireless/marvell/libertas/tx.c         |   7 -
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  19 +-
 drivers/net/wireless/st/cw1200/bh.c                |   8 +-
 drivers/net/wireless/st/cw1200/txrx.c              |  14 +
 drivers/net/wireless/ti/wl12xx/main.c              |   9 +-
 drivers/net/wireless/ti/wl18xx/main.c              |   2 +-
 drivers/net/wireless/ti/wlcore/main.c              |  10 +-
 drivers/net/wireless/ti/wlcore/wlcore.h            |   2 +-
 drivers/net/xen-netfront.c                         |  16 +-
 drivers/nvme/host/core.c                           |   3 +
 drivers/nvme/host/multipath.c                      |   5 +-
 drivers/nvme/host/tcp.c                            | 118 +++++--
 drivers/nvme/target/configfs.c                     |   9 +-
 drivers/nvme/target/core.c                         |   2 +-
 drivers/of/irq.c                                   |  14 +-
 drivers/of/overlay.c                               |  14 +-
 drivers/opp/core.c                                 |   6 +-
 drivers/pci/pci.c                                  |  15 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              | 197 ++++++++---
 drivers/pinctrl/sunxi/pinctrl-sunxi.h              | 100 +-----
 drivers/power/supply/bq24257_charger.c             |  16 +-
 drivers/power/supply/ds2780_battery.c              |   2 +-
 drivers/power/supply/max17040_battery.c            |  10 +-
 drivers/power/supply/rt9455_charger.c              |  26 +-
 drivers/power/supply/ucs1002_power.c               |   6 +-
 drivers/regulator/ltc3676.c                        |  15 +-
 drivers/rtc/rtc-spear.c                            |  11 +-
 drivers/s390/net/ctcm_mpc.c                        |   3 +-
 drivers/scsi/ch.c                                  |  30 +-
 drivers/scsi/libiscsi.c                            |  14 +-
 drivers/scsi/qedi/qedi_main.c                      |   3 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  41 ++-
 drivers/scsi/qla2xxx/qla_init.c                    |  17 +
 drivers/scsi/qla2xxx/qla_iocb.c                    |   4 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   4 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |  33 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  10 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  10 +
 drivers/scsi/sd_zbc.c                              |  11 +-
 drivers/scsi/st.c                                  |  18 +-
 drivers/soc/rockchip/pm_domains.c                  |  20 +-
 drivers/spi/spi-bcm63xx.c                          |   6 +-
 drivers/staging/greybus/uart.c                     |  10 +-
 drivers/staging/media/zoran/zoran_card.c           |   2 +-
 drivers/staging/octeon-usb/octeon-hcd.c            |   2 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |   5 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |   4 +
 drivers/staging/sm750fb/sm750.c                    |   2 +-
 drivers/staging/sm750fb/sm750.h                    |   2 +-
 drivers/staging/sm750fb/sm750_accel.c              |  10 +-
 drivers/staging/sm750fb/sm750_accel.h              |   4 +-
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |   3 +
 drivers/target/iscsi/iscsi_target_configfs.c       |  26 +-
 drivers/tee/optee/core.c                           |  26 +-
 drivers/thunderbolt/ctl.c                          |  47 ++-
 drivers/thunderbolt/xdomain.c                      |   4 +
 drivers/tty/amiserial.c                            |   9 +-
 drivers/tty/serial/kgdboc.c                        |   9 +
 drivers/tty/serial/max3100.c                       |  15 +-
 drivers/tty/serial/qcom_geni_serial.c              |   5 +-
 drivers/tty/serial/serial-tegra.c                  |  18 +-
 drivers/tty/serial/serial_core.c                   |  11 +-
 drivers/tty/serial/vt8500_serial.c                 |   1 +
 drivers/tty/tty_io.c                               |  54 ++-
 drivers/tty/tty_port.c                             |  43 ++-
 drivers/tty/vcc.c                                  |   5 +-
 drivers/tty/vt/vc_screen.c                         |  25 +-
 drivers/tty/vt/vt.c                                |   5 +-
 drivers/usb/cdns3/cdns3-pci-wrap.c                 |   5 +
 drivers/usb/cdns3/gadget.c                         |   4 +
 drivers/usb/class/cdc-acm.c                        |  46 ++-
 drivers/usb/class/cdc-acm.h                        |   1 -
 drivers/usb/core/hub.c                             |   7 +-
 drivers/usb/core/message.c                         |   8 +-
 drivers/usb/gadget/function/f_fs.c                 |  15 +-
 drivers/usb/gadget/function/f_mass_storage.c       |   3 +
 drivers/usb/gadget/function/f_uac1_legacy.c        |   6 +
 drivers/usb/gadget/udc/aspeed-vhub/core.c          |   4 +
 drivers/usb/gadget/udc/aspeed-vhub/dev.c           |   2 +-
 drivers/usb/gadget/udc/aspeed-vhub/hub.c           |   5 +-
 drivers/usb/gadget/udc/aspeed-vhub/vhub.h          |   1 +
 drivers/usb/gadget/udc/dummy_hcd.c                 |   4 +
 drivers/usb/host/ohci-da8xx.c                      |   2 +
 drivers/usb/host/ohci-s3c2410.c                    |   1 +
 drivers/usb/host/ohci-spear.c                      |   4 +-
 drivers/usb/host/ohci-st.c                         |   1 +
 drivers/usb/host/xhci.c                            |  12 +-
 drivers/usb/serial/bus.c                           |   6 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/generic.c                       |  10 +-
 drivers/usb/serial/option.c                        |  14 +
 drivers/usb/serial/quatech2.c                      |  19 +-
 drivers/usb/serial/ssu100.c                        |  18 +-
 drivers/usb/serial/usb-serial.c                    | 187 +++++++---
 drivers/usb/serial/usb_wwan.c                      |   6 +-
 drivers/usb/storage/sierra_ms.c                    |   7 +
 drivers/usb/typec/tcpm/tcpm.c                      |  37 +-
 drivers/usb/typec/ucsi/displayport.c               |   9 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  17 +-
 drivers/usb/typec/ucsi/ucsi_acpi.c                 |  18 +
 drivers/virt/nitro_enclaves/ne_misc_dev.c          |   1 +
 drivers/watchdog/rtd119x_wdt.c                     |  21 +-
 fs/autofs/waitq.c                                  |  25 +-
 fs/btrfs/scrub.c                                   |   4 +-
 fs/ceph/export.c                                   |  23 +-
 fs/ceph/mdsmap.c                                   |   7 +-
 fs/cifs/cifsacl.c                                  |  15 +
 fs/cifs/cifsfs.c                                   |  16 +-
 fs/cifs/cifsglob.h                                 |   6 +-
 fs/cifs/connect.c                                  |   1 +
 fs/cifs/dir.c                                      |  37 +-
 fs/cifs/inode.c                                    |  29 +-
 fs/cifs/link.c                                     |  15 +-
 fs/cifs/misc.c                                     |   7 +-
 fs/cifs/smb1ops.c                                  |  21 +-
 fs/cifs/smb2misc.c                                 |   9 +-
 fs/cifs/smb2ops.c                                  |  81 ++++-
 fs/cifs/smb2pdu.c                                  |  79 +++--
 fs/cifs/smb2pdu.h                                  |   6 +-
 fs/cifs/transport.c                                |  68 +++-
 fs/dcache.c                                        |   4 +-
 fs/f2fs/debug.c                                    |   4 -
 fs/f2fs/f2fs.h                                     |  16 +-
 fs/f2fs/file.c                                     |   5 +-
 fs/f2fs/gc.c                                       |  30 +-
 fs/f2fs/gc.h                                       |  14 -
 fs/f2fs/recovery.c                                 |  33 +-
 fs/f2fs/super.c                                    |   4 +-
 fs/f2fs/sysfs.c                                    |   8 +-
 fs/fcntl.c                                         |   3 +
 fs/fsopen.c                                        |   3 +
 fs/fuse/dir.c                                      |   9 +-
 fs/fuse/file.c                                     |   5 +-
 fs/inode.c                                         |  15 +-
 fs/lockd/svcsubs.c                                 |   2 +-
 fs/namespace.c                                     | 115 ++++--
 fs/nfsd/netns.h                                    |   1 +
 fs/nfsd/nfs2acl.c                                  |  17 +-
 fs/nfsd/nfs4proc.c                                 |  25 +-
 fs/nfsd/nfs4state.c                                |   3 +-
 fs/nfsd/vfs.c                                      |   4 +-
 fs/notify/mark.c                                   |  11 +
 fs/ocfs2/dir.c                                     |  71 +++-
 fs/ocfs2/dlm/dlmcommon.h                           |   2 +
 fs/ocfs2/dlm/dlmdebug.c                            |   5 +-
 fs/ocfs2/dlm/dlmrecovery.c                         |   2 +-
 fs/pipe.c                                          |   6 +-
 fs/unicode/utf8-core.c                             |   9 +-
 fs/verity/Kconfig                                  |   3 +
 fs/xfs/libxfs/xfs_alloc.c                          |  61 +++-
 fs/xfs/libxfs/xfs_bmap.c                           |   6 +-
 fs/xfs/libxfs/xfs_btree.c                          |  10 +-
 fs/xfs/libxfs/xfs_ialloc.c                         |  38 +-
 fs/xfs/libxfs/xfs_rtbitmap.c                       |  22 +-
 fs/xfs/libxfs/xfs_sb.c                             |  17 +-
 fs/xfs/xfs_bmap_item.c                             |  76 ++--
 fs/xfs/xfs_buf.c                                   |  24 +-
 fs/xfs/xfs_buf.h                                   |  14 +-
 fs/xfs/xfs_buf_item.c                              | 384 +++++++++++++--------
 fs/xfs/xfs_buf_item.h                              |   3 +-
 fs/xfs/xfs_dquot_item.c                            |   5 +-
 fs/xfs/xfs_extfree_item.c                          |   2 +-
 fs/xfs/xfs_fsops.c                                 |   2 +-
 fs/xfs/xfs_icache.c                                |  10 +-
 fs/xfs/xfs_inode.c                                 |   9 +-
 fs/xfs/xfs_inode_item.c                            | 164 +++++++--
 fs/xfs/xfs_inode_item.h                            |   1 +
 fs/xfs/xfs_log.c                                   |  50 ++-
 fs/xfs/xfs_log_cil.c                               |  12 +-
 fs/xfs/xfs_log_priv.h                              |   7 +-
 fs/xfs/xfs_log_recover.c                           |  17 +-
 fs/xfs/xfs_qm.c                                    |   7 +
 fs/xfs/xfs_refcount_item.c                         |  60 ++--
 fs/xfs/xfs_rmap_item.c                             |  75 ++--
 fs/xfs/xfs_rtalloc.c                               |  20 +-
 fs/xfs/xfs_rtalloc.h                               |   4 +-
 fs/xfs/xfs_symlink.c                               |   4 +-
 fs/xfs/xfs_trace.h                                 |   4 +-
 fs/xfs/xfs_trans.c                                 |   6 +-
 fs/xfs/xfs_trans.h                                 |   3 +-
 fs/xfs/xfs_trans_buf.c                             |  16 +-
 include/linux/can/dev.h                            |   1 +
 include/linux/can/skb.h                            |   2 +
 include/linux/device-mapper.h                      |   5 +
 include/linux/devm-helpers.h                       |  79 +++++
 include/linux/dmaengine.h                          |   7 +
 include/linux/fsnotify_backend.h                   |   1 +
 include/linux/ftrace.h                             |   5 +-
 include/linux/futex.h                              |  14 +-
 include/linux/hid.h                                |   6 +-
 include/linux/highmem.h                            |   2 +-
 include/linux/i2c.h                                |   1 +
 include/linux/if_team.h                            |   3 +-
 include/linux/if_vlan.h                            |   3 +
 include/linux/key-type.h                           |   1 +
 include/linux/key.h                                |   5 +
 include/linux/kprobes.h                            |   1 +
 include/linux/lockd/lockd.h                        |   2 +-
 include/linux/mm.h                                 |   2 +-
 include/linux/mm_types.h                           |   4 +
 include/linux/mount.h                              |   2 +-
 include/linux/netlink.h                            |   3 +-
 include/linux/property.h                           |   3 +
 include/linux/qcom-geni-se.h                       |  15 +-
 include/linux/sched/signal.h                       |   5 +-
 include/linux/skbuff.h                             |  12 +-
 include/linux/tty.h                                |   2 +
 include/linux/tty_driver.h                         |   5 +
 include/linux/unicode.h                            |   1 +
 include/linux/usb/serial.h                         |   1 +
 include/net/bluetooth/hci_core.h                   |   4 +-
 include/net/bluetooth/rfcomm.h                     |   1 +
 include/net/codel_impl.h                           |   1 +
 include/net/net_namespace.h                        |   4 +-
 include/net/netfilter/nf_tables.h                  |  16 +-
 include/net/netns/xfrm.h                           |   1 +
 include/net/strparser.h                            |  10 +-
 include/net/tcp.h                                  |   4 +
 include/uapi/linux/sched.h                         |   5 +-
 io_uring/io_uring.c                                |   9 +-
 kernel/audit_tree.c                                |  36 +-
 kernel/bpf/arraymap.c                              |  13 +-
 kernel/bpf/verifier.c                              |   7 +
 kernel/events/core.c                               |   2 +-
 kernel/fork.c                                      |  20 +-
 kernel/futex/core.c                                |  49 +--
 kernel/kprobes.c                                   |  27 +-
 kernel/params.c                                    |  61 ++--
 kernel/ptrace.c                                    |   3 +-
 kernel/signal.c                                    |   8 +
 kernel/time/clockevents.c                          |  37 +-
 kernel/time/tick-broadcast.c                       |  34 +-
 kernel/time/tick-internal.h                        |   2 +
 kernel/trace/ftrace.c                              |  72 ++--
 kernel/trace/ring_buffer.c                         |   6 +-
 kernel/trace/trace.h                               |   4 +-
 kernel/trace/trace_events_filter.c                 |   6 +
 kernel/trace/trace_events_hist.c                   |  48 +--
 kernel/trace/trace_functions.c                     |   2 +-
 kernel/trace/trace_stack.c                         |   2 +-
 kernel/watch_queue.c                               |  11 +-
 kernel/workqueue.c                                 |   2 +-
 mm/huge_memory.c                                   |   3 +
 mm/hugetlb.c                                       |  22 +-
 mm/ioremap.c                                       |  51 ++-
 mm/mmap.c                                          |  31 +-
 mm/mremap.c                                        |  29 +-
 mm/rmap.c                                          |   6 +-
 net/bluetooth/hci_core.c                           |  12 +-
 net/bluetooth/hci_debugfs.c                        |   2 +-
 net/bluetooth/hci_sock.c                           |   2 +
 net/bluetooth/l2cap_core.c                         |   7 +-
 net/bluetooth/l2cap_sock.c                         |  59 +++-
 net/bluetooth/mgmt.c                               |   9 +-
 net/bluetooth/rfcomm/core.c                        | 134 ++++---
 net/bluetooth/rfcomm/sock.c                        |   5 +-
 net/bluetooth/rfcomm/tty.c                         |  16 +-
 net/bridge/br_multicast.c                          |  36 +-
 net/can/af_can.c                                   |   6 +-
 net/can/bcm.c                                      |   2 +
 net/can/isotp.c                                    |  11 +-
 net/can/j1939/socket.c                             |   1 +
 net/can/j1939/transport.c                          |   2 +
 net/can/raw.c                                      |   7 +-
 net/core/filter.c                                  |   8 +-
 net/core/flow_dissector.c                          |  26 +-
 net/core/net_namespace.c                           |  19 +-
 net/core/page_pool.c                               |   6 +
 net/hsr/hsr_framereg.c                             |   4 +-
 net/ipv4/fib_semantics.c                           |   2 +-
 net/ipv4/ipconfig.c                                |  90 ++---
 net/ipv4/ipmr.c                                    |   3 +-
 net/ipv4/ipmr_base.c                               |   2 +-
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/tcp_bpf.c                                 |   3 +-
 net/ipv4/tcp_dctcp.c                               |   2 +-
 net/ipv4/tcp_input.c                               |   6 +
 net/ipv4/udp.c                                     |   9 +
 net/ipv6/ip6mr.c                                   |   2 +-
 net/ipv6/seg6_iptunnel.c                           |   2 +-
 net/mac80211/chan.c                                |  36 +-
 net/mac80211/fils_aead.c                           |   8 +
 net/mac80211/mesh_pathtbl.c                        |  16 +-
 net/mac80211/mlme.c                                |   4 +-
 net/mac80211/sta_info.c                            |   6 +-
 net/mac80211/tx.c                                  |   6 +
 net/netfilter/ipset/ip_set_bitmap_gen.h            |   2 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   3 +
 net/netfilter/ipvs/ip_vs_lblc.c                    |   4 +
 net/netfilter/ipvs/ip_vs_lblcr.c                   |   3 +
 net/netfilter/ipvs/ip_vs_sync.c                    |  33 +-
 net/netfilter/nf_tables_api.c                      |  23 +-
 net/netfilter/nf_tables_core.c                     |  29 +-
 net/netfilter/nf_tables_trace.c                    |  44 +--
 net/netfilter/nft_flow_offload.c                   |   8 +-
 net/netlink/af_netlink.c                           |  24 +-
 net/netlink/genetlink.c                            |  28 +-
 net/openvswitch/actions.c                          |   7 +-
 net/openvswitch/conntrack.c                        |  23 +-
 net/openvswitch/datapath.c                         |   8 +
 net/packet/af_packet.c                             |   6 +-
 net/rds/rdma_transport.c                           |  26 +-
 net/rds/tcp.c                                      |   9 +-
 net/sched/act_api.c                                |  20 +-
 net/sched/cls_flower.c                             |   5 +
 net/sched/cls_u32.c                                |  43 ++-
 net/sched/em_text.c                                |   3 +
 net/sched/sch_codel.c                              |   2 +-
 net/sched/sch_fq_codel.c                           |   4 +-
 net/sctp/inqueue.c                                 |   6 +-
 net/sctp/socket.c                                  |  39 ++-
 net/smc/af_smc.c                                   |   7 +-
 net/smc/smc_core.c                                 |  14 +-
 net/strparser/strparser.c                          |   6 +-
 net/sunrpc/auth_gss/gss_rpc_xdr.c                  |  15 +-
 net/tipc/crypto.c                                  |  20 +-
 net/tipc/node.c                                    |  12 +-
 net/tipc/topsrv.c                                  |  80 ++++-
 net/tls/tls_device.c                               |   7 +-
 net/vmw_vsock/af_vsock.c                           |  17 +-
 net/wireless/lib80211_crypt_tkip.c                 |  13 +-
 net/wireless/scan.c                                |  29 +-
 net/xfrm/xfrm_policy.c                             |  19 +-
 samples/pidfd/Makefile                             |   2 +-
 security/apparmor/include/label.h                  |   6 +-
 security/keys/key.c                                |  19 +-
 security/keys/keyctl.c                             |  15 +-
 security/keys/keyring.c                            | 151 ++++----
 security/keys/persistent.c                         |  55 +--
 security/keys/process_keys.c                       |   5 +-
 security/keys/trusted-keys/trusted_tpm1.c          |   2 +-
 security/selinux/avc.c                             |   5 +-
 security/selinux/hooks.c                           |   9 +-
 sound/core/seq/seq_clientmgr.c                     |   1 +
 sound/core/seq/seq_compat.c                        |   2 +
 sound/parisc/harmony.c                             |  13 +-
 sound/pci/pcxhr/pcxhr.c                            |  61 ++--
 sound/soc/codecs/cs42l52.c                         |   2 +-
 sound/soc/codecs/cs42l56.c                         |   2 +-
 sound/soc/codecs/max98371.c                        |   2 +-
 sound/soc/codecs/nau8822.c                         |   4 +-
 sound/soc/codecs/pcm3168a.c                        |   2 +-
 sound/soc/codecs/rt274.c                           |   4 +-
 sound/soc/codecs/wm8903.c                          |   2 +-
 sound/soc/codecs/wm8978.c                          |   4 +-
 sound/soc/samsung/i2s.c                            |   8 +
 sound/soc/stm/stm32_spdifrx.c                      |   2 +-
 sound/usb/caiaq/device.c                           |   3 +
 sound/usb/line6/playback.c                         |   7 +
 sound/usb/misc/ua101.c                             |   9 +
 tools/gpio/Makefile                                |   6 +
 tools/perf/tests/bpf.c                             |   3 +-
 tools/perf/util/parse-events.c                     |   2 +-
 .../test.d/filter/event-filter-incomplete.tc       |  24 ++
 tools/thermal/tmon/tui.c                           |   2 +-
 496 files changed, 5384 insertions(+), 2619 deletions(-)


