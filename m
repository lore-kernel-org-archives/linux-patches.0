Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207509;
	b=Y97ZNYgrbiWqcQo63N6BmCd9rEkM9cmWP4UdiDv77HXmyMygP1t/cteccdZSoDw1Q5Jf
	 isxE5JOXUj/E0PrdxVGB3Zu2T6rNrJu78Z5AiwNPnzmW4KCuCYG7Jr0wuJNAYIJD8CDvc
	 tvDCn9B6MNx7uUmE6APHLAR4iNs7Jb/NhWsC5wHG8jf9uQggYTpHhzMIxUeEqG1JNiHQV
	 qQQhOteYI+vHKd4iuIz4caK+GaOtylnZN54qidt+u/NUVrbxvmBzOzDefI1uRKPrMxhJu
	 vLozxscbPYTtGCRXf4U2NkKJ9k+f8tHbi2846rmSg7NSfuKGzG97FlUz0zM+mhpR3gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=kVrT0VJu3iu1s3RdsmiikLtYChmTYGMZdrSvr8ikSkc=;
	b=3R5oiyM2qpIavbRuV0+RQWIiPw4dCjWeU16l5ho3Kenlbh5UplJFYL5pbPDtyHiZTTdL
	 dDRmI4UNP9p3b48SO8036TtfY9vKtsfntbBp7AtVvSDKSjwyDNVvSnbLKGZmV+JkdmWaL
	 qiVedIwXMGWrTv0icBwyvRmTkll/CF0jPphE2K3Nbr014XQ3fZ/V28WIwdroL+lDebsOe
	 jpb44BVCThZrB4rl4GrwPHAuHr5LAXpmEiio+WafRJ97Dezqcx7wECXbnEPFSeIjUUcxw
	 tuGLV/TKAeqdVuCUiG8QcD3hMgWsCT0k5h80GcBiHVmGzQhRf9YgoMxXsgNgrOeFWPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBswgaLr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515C1606A31A;
	Wed, 28 Oct 2026 17:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBswgaLr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AD11F01825;
	Wed, 28 Oct 2026 17:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207508;
	bh=kVrT0VJu3iu1s3RdsmiikLtYChmTYGMZdrSvr8ikSkc=;
	h=From:To:Cc:Subject:Date;
	b=RBswgaLrrb09BAvHF7eWp5GlCe7wlAqRH6goL5KeMIb37PNMm+KYVrDhSiWulwlNz
	 S74NW83c94EJMaWMVfWN/UcVF3aoIk9TlQf3372rMGOOumctaNiXcwZUy5Awkxc4ax
	 3oYVACPMtkMKt6wGjby8qXGNm/g3rCShXxuRgFBk=
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
Subject: [PATCH 6.12 000/247] 6.12.115-rc1 review
Date: Wed, 28 Oct 2026 17:56:43 +0100
Message-ID: <20261028165947.349197979@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.115-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.115-rc1
X-KernelTest-Deadline: 2026-10-30T16:59+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.115 release.
There are 247 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.115-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.115-rc1

Jan Kara <jack@suse.cz>
    fanotify: Fix crash in fanotify_init(2)

Christian Brauner <brauner@kernel.org>
    signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL

Christian Brauner <brauner@kernel.org>
    pid_namespace: prevent TIF_NOTIFY_SIGNAL from interrupting the reaper

Christian Brauner <brauner@kernel.org>
    fork: release the files of a failed fork after sched_cancel_fork()

Christian Brauner <brauner@kernel.org>
    ptrace: refuse to change the signal mask of a user worker

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

Junyeong Lee <jylee5498@gmail.com>
    io_uring/waitid: prevent cancel reference wrap

Austin Schuh <austin.linux@gmail.com>
    io_uring/wait: wake real-time waiters from hard interrupt context

Tamaki Yanagawa <ty@000ty.net>
    io_uring/net: keep recv buffer select length within MAX_RW_COUNT

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
    io_uring/timeout: don't end a linked timeout with 1

Josef Bacik <josef@toxicpanda.com>
    io_uring/timeout: no ABS update of multishot timeouts

Josef Bacik <josef@toxicpanda.com>
    io_uring/net: don't retry recv on uncommitted buffers

Josef Bacik <josef@toxicpanda.com>
    io_uring: don't pass restart error codes to userspace

Josef Bacik <josef@toxicpanda.com>
    io_uring/sqpoll: let the thread sleep on disabled rings

Josef Bacik <josef@toxicpanda.com>
    io_uring/kbuf: handle index wrap in last buffer check

Josef Bacik <josef@toxicpanda.com>
    io_uring/napi: don't busy poll past an expired timeout

Josef Bacik <josef@toxicpanda.com>
    io_uring/napi: make stale entries time out after 60s

Josef Bacik <josef@toxicpanda.com>
    io_uring/wait: no early -ETIME if min_wait finds work

Josef Bacik <josef@toxicpanda.com>
    io_uring/timeout: keep repeat count on multishot update

Josef Bacik <josef@toxicpanda.com>
    io_uring/timeout: don't skip over reached sequences

Josef Bacik <josef@toxicpanda.com>
    io_uring/poll: drop stale double poll entry on rearm

Josef Bacik <josef@toxicpanda.com>
    io_uring/wait: look at all CQ waiters on wake up

Josef Bacik <josef@toxicpanda.com>
    io_uring: wake ring pollers for local task_work

Josef Bacik <josef@toxicpanda.com>
    io_uring/cancel: let CANCEL_ALL find parked requests

Josef Bacik <josef@toxicpanda.com>
    io_uring/cancel: recognize "no timeout" on 32-bit

Josef Bacik <josef@toxicpanda.com>
    io_uring/cancel: don't forget that the work was running

Josef Bacik <josef@toxicpanda.com>
    io_uring: don't lose a cancel as io-wq parks a request

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

Josef Bacik <josef@toxicpanda.com>
    io_uring/wait: don't spin on a stuck overflow list

Josef Bacik <josef@toxicpanda.com>
    io_uring/cmd: don't leave list poison in ->hash_node

Josef Bacik <josef@toxicpanda.com>
    io_uring/waitid: own the request before clearing ->head

Christian Brauner <brauner@kernel.org>
    io-wq: order the exit bit against worker creation task work

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

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: refuse __l2cap_chan_add if chan already has conn

Jonas Köppeler <j.koeppeler@tu-berlin.de>
    net_sched: codel: fix stale state for empty flows in fq_codel

Sasha Levin <sashal@kernel.org>
    Revert "srcu: Use irq_work to start GP in tiny SRCU"

Damien Le Moal <dlemoal@kernel.org>
    block: avoid potential deadlock on zone revalidation failure

Hyunwoo Kim <imv4bel@gmail.com>
    mm/pagewalk: fix stale walk->action escaping walk_pmd_range()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: don't free an incoming SABM skb left on the listener's queue

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: bring up the link of the preferred route passed over by a connect request

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: send unacknowledged I frames again when a link is re-established

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: clear the circuits of a neighbour that restarts the link

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: send a private copy of each I frame

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: don't accept frames on a device that is going down

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: wait for ax25_send_frame() before detaching the connections of a device

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: read the connection's ax25_dev only once when walking ax25_list

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: don't create two connections for the same link in ax25_send_frame()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: process received frames and send with the socket locked

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: serialise the transmission of I frames on a connection

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: restart the link of a neighbour created over a live AX.25 connection

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: clear through routes when a neighbour is removed from the tables

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: fix nr_node leak when nr_del_node() removes the last route

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: clear nr_neigh->ax25 under the routing lock in nr_link_failed()

Junjie Cao <junjie.cao@intel.com>
    netrom: fix reference count leak in nr_rt_device_down

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: look up and update routes in one critical section

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: use a single lock for the node and neighbour lists

Mashiro Chen <mashiro.chen@mailbox.org>
    net: ax25: fix integer overflow in ax25_rx_fragment()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: check frame length in ax25_decode() and ax25_rx_iframe()

Ashutosh Desai <ashutoshdesai993@gmail.com>
    ax25: fix OOB read after address header strip in ax25_rcv()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: bound fragment reassembly in nr_queue_rx_frame()

Mashiro Chen <mashiro.chen@mailbox.org>
    net: netrom: validate source address in nr_find_socket()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    netrom: require full NET/ROM headers in nr_route_frame()

Stanislav Fort <disclosure@aisle.com>
    netrom: linearize and validate lengths in nr_rx_frame()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: clear stale N(R)/N(S) before (re)transmitting a data frame

Yun Zhou <yun.zhou@windriver.com>
    xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf

Frank Sorenson <sorenson@redhat.com>
    cifs: add revalidation on FSCTL failure in smb2_duplicate_extents()

Tejun Heo <tj@kernel.org>
    sched_ext: Fix stall when a task enqueued with SCX_ENQ_LAST lands back on its CPU's local DSQ

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: free the userptr ranges when a CS fails after parser_bos

Dmitry Kandybka <d.kandybka@gmail.com>
    tracing: Fix ignored return value of resize_buffer_duplicate_size()

Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>
    drm/i915/dmc: Harden DMC firmware payload parsing

Jann Horn <jannh@google.com>
    futex: Fix mm reuse handling for FUT_OFF_MMSHARED

Wentao Liang <vulab@iscas.ac.cn>
    i2c: viai2c-wmt: Fix clock leak in wmt_i2c_probe()

Enrico Zanda <e.zanda1@gmail.com>
    i2c: viai2c-wmt: Replace dev_err() with dev_err_probe() in probe function

Yao Kai <yaokai34@huawei.com>
    workqueue: Fix unbound pool lifetime for pending pwqs

Breno Leitao <leitao@debian.org>
    workqueue: release pwq pools by pool type

Ido Schimmel <idosch@nvidia.com>
    ipv4: udp: Create exceptions before socket matching

Daehyeon Ko <4ncienth@gmail.com>
    vsock/virtio: validate packet source for connected sockets

Bobby Eshleman <bobbyeshleman@meta.com>
    virtio: set skb owner of virtio_transport_reset_no_sock() reply

Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>
    io_uring/cancel: don't spin on local work the task can't run

Taeyang Lee <0wn@theori.io>
    tracing: Keep the predicate limit separate from program capacity

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Bump LRU for external objects on exec and rebind

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Fix shift-out-of-bounds for aggregated ALH capture

Christian Brauner <brauner@kernel.org>
    ext4: free the sbi after a grace period

Christian Brauner <brauner@kernel.org>
    ntfs3: free the sbi after a grace period

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    watch_queue: Fix note pool publication race in watch_queue_set_size()

K Prateek Nayak <kprateek.nayak@amd.com>
    kernel/watch_queue: Use pipe_buf() to retrieve the pipe buffer

Breno Leitao <leitao@debian.org>
    net: call getsockopt_iter if available

Joseph Qi <joseph.qi@linux.alibaba.com>
    eventfs: fix SRCU read lock leak in eventfs_iterate()

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    perf: Track the perf mlock gift separately

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

Jun Yang <littleddfu@gmail.com>
    net: bridge: mcast: don't truncate the port group walk on teardown

Al Viro <viro@zeniv.linux.org.uk>
    fs: get rid of __FMODE_NONOTIFY kludge

Hyunwoo Kim <imv4bel@gmail.com>
    KVM: x86/mmu: Preserve nested TDP shadow page tables if they are used as roots

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/huge_memory: bypass THP tuneables for huge pfnmap mappings

Florian Westphal <fw@strlen.de>
    netfilter: nft_byteorder: remove multi-register support

Sasha Levin <sashal@kernel.org>
    Revert "s390/mm: Add missing secure storage access fixups for donated memory"

Matt Fleming <mfleming@cloudflare.com>
    mm/huge_memory: initialise workingset state before folio split

Kairui Song <kasong@tencent.com>
    mm, madvise: fix potential workingset node list_lru leaks

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

Zqiang <qiang.zhang@linux.dev>
    workqueue: Use raise_softirq() to trigger softirq in irq_work handler

Carlos Maiolino <cem@kernel.org>
    xfs: fix capability check in xfs

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

Christian König <ckoenig.leichtzumerken@gmail.com>
    drm/exec: don't immediately add prelocked obj to array of locked objs

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

Christian Brauner <brauner@kernel.org>
    unicode: free the map after a grace period

Sung Byeongchan <tjdqudcks0424@naver.com>
    autofs: ignore notification errors from a replaced pipe

Christian Brauner <brauner@kernel.org>
    afs: free the super info after a grace period

Alexander Gruhlke <gruhlke@mailbox.org>
    PCI: Don't treat ~0 as ready in pci_dev_wait() with RRS SV

John Ogness <john.ogness@linutronix.de>
    printk: Postpone kthread startup

Haris Okanovic <harisokn@amazon.com>
    perf: Fix perf_pmu_migrate_context() leaving events behind

Peng Fan <peng.fan@nxp.com>
    gpio: mxc: fix wakeup_pads bit operations

Alexander Stein <alexander.stein@ew.tq-group.com>
    gpio: mxc: use BIT() macro

Peng Fan <peng.fan@nxp.com>
    gpio: mxc: fix both_edges bit operations

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: mxc: use lock guards for the generic GPIO chip lock

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

Linfeng Sun <linfeng.sun.dev@gmail.com>
    scsi: target: iscsi: Fix race in discovery auth updates

Laurence Oberman <loberman@redhat.com>
    scsi: st: Save the visited block for the partition the drive is in

Keith Busch <kbusch@kernel.org>
    nios2: fix __wsum type degradation in csum_fold()

Carlos Jones Jr <carlosjr.jones@analog.com>
    spi: tegra114: assert CS GPIO for every transfer in a message

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

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hdmi: Move packet RAM enable to PM runtime

Adriel Santos <adriel@adriel.eu>
    pinctrl: qcom: ipq5018: replace gcc_plltest with pwm2 on gpio12

Svyatoslav Ryhel <clamor95@gmail.com>
    power: supply: generic-adc-battery: Fix temperature IIO channel conversion

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix add_counter issue if > 24 counters.

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix fd_perf leak on reset

Gilberto Conde <gilbertorconde@gmail.com>
    pinctrl: qcom: ipq5018: add missing pwm3 function on gpio13

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

Jinhui Guo <guojinhui.liam@bytedance.com>
    soc/tegra: fuse: Add missing newline to APBMISC error message

Matteo Croce <technoboy85@gmail.com>
    fat: stop reading directory entries past the end-of-directory marker

Abdul Wasey <w453y.me@gmail.com>
    mptcp: move the OoO check back into __mptcp_try_fallback()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: purge rose_neigh->queue on final teardown

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: bound REJ-driven fast retransmits with the existing N2 counter

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: hold a reference on incoming sockets queued for accept()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: don't warn on stray CALL_ACCEPTED/CLEAR_CONFIRMATION in state 3

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: use timer_shutdown_sync() for t0timer teardown

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: guard rose_transmit_link() against a NULL neighbour

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: keep the route needed for routing loop detection

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: don't free fd-owned sockets when reaping in the heartbeat

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: clear neighbour pointer in rose_kill_by_device()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: release netdev ref and destroy orphaned incoming sockets

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: disconnect orphaned STATE_2 sockets when device is gone

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: set SOCK_DESTROY in rose_kill_by_device() for prompt cleanup


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/nios2/include/asm/checksum.h                  |   2 +-
 arch/s390/mm/fault.c                               |  11 +-
 arch/s390/pci/pci_sysfs.c                          |   3 +
 arch/x86/hyperv/hv_init.c                          |   3 +-
 arch/x86/kernel/kvm.c                              |  32 +-
 arch/x86/kvm/mmu/mmu.c                             |   4 +-
 arch/x86/kvm/vmx/nested.c                          |   4 +-
 block/blk-zoned.c                                  |  37 +-
 block/blk.h                                        |   4 +-
 block/bsg-lib.c                                    |  13 +-
 block/genhd.c                                      |   2 +-
 crypto/asymmetric_keys/restrict.c                  |   8 +-
 drivers/base/regmap/internal.h                     |   1 +
 drivers/base/regmap/regcache-maple.c               |   9 +-
 drivers/base/regmap/regcache.c                     |  18 +-
 drivers/gpio/gpio-mxc.c                            |  69 ++--
 drivers/gpio/gpiolib.c                             |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |  23 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c             |  25 +-
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c              |   2 +-
 drivers/gpu/drm/drm_exec.c                         |  77 +++--
 drivers/gpu/drm/i915/display/intel_dmc.c           |  21 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  20 +-
 drivers/gpu/drm/xe/xe_exec.c                       |   7 +-
 drivers/gpu/drm/xe/xe_vm.c                         |  31 +-
 drivers/gpu/drm/xe/xe_vm.h                         |   2 +
 drivers/hv/channel_mgmt.c                          |  12 +-
 drivers/hv/connection.c                            |   1 -
 drivers/hv/vmbus_drv.c                             |   1 -
 drivers/i2c/busses/i2c-qcom-cci.c                  |   4 +-
 drivers/i2c/busses/i2c-viai2c-wmt.c                |  22 +-
 drivers/md/dm-cache-target.c                       |  59 ++--
 drivers/md/dm-crypt.c                              |   3 +-
 drivers/md/dm-ebs-target.c                         |   3 +-
 drivers/md/dm-integrity.c                          |   6 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  10 +
 drivers/net/wireless/intersil/p54/fwio.c           |  42 ++-
 drivers/pci/pci.c                                  |  15 +-
 drivers/pinctrl/pinctrl-amd.c                      |   9 +
 drivers/pinctrl/qcom/pinctrl-ipq5018.c             |  10 +-
 drivers/power/supply/ds2780_battery.c              |   2 +-
 drivers/power/supply/generic-adc-battery.c         |   9 +-
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
 fs/coredump.c                                      |  16 +-
 fs/ext4/ext4.h                                     |   2 +
 fs/ext4/extents_status.c                           |   7 +-
 fs/ext4/extents_status.h                           |   1 +
 fs/ext4/super.c                                    |  13 +-
 fs/fat/dir.c                                       |  44 ++-
 fs/fcntl.c                                         |   4 +-
 fs/namei.c                                         |   3 +-
 fs/notify/fanotify/fanotify_user.c                 |  25 +-
 fs/notify/mark.c                                   |  11 +
 fs/ntfs3/ntfs_fs.h                                 |   1 +
 fs/ntfs3/super.c                                   |  29 +-
 fs/ocfs2/dlm/dlmcommon.h                           |   2 +
 fs/ocfs2/dlm/dlmdebug.c                            |   5 +-
 fs/ocfs2/dlm/dlmrecovery.c                         |   2 +-
 fs/open.c                                          |  23 +-
 fs/pipe.c                                          |   6 +-
 fs/smb/client/cifssmb.c                            |  13 +-
 fs/smb/client/connect.c                            |  21 +-
 fs/smb/client/smb2ops.c                            |   7 +-
 fs/smb/server/smb2pdu.c                            |   5 +
 fs/tracefs/event_inode.c                           |  16 +-
 fs/unicode/utf8-core.c                             |  21 +-
 fs/xfs/libxfs/xfs_sb.c                             |  17 +-
 fs/xfs/xfs_fsmap.c                                 |   2 +-
 fs/xfs/xfs_ioctl.c                                 |   2 +-
 fs/xfs/xfs_iops.c                                  |   2 +-
 include/drm/drm_exec.h                             |  15 +-
 include/linux/bsg-lib.h                            |   3 +-
 include/linux/cgroup-defs.h                        |   5 +-
 include/linux/fs.h                                 |   6 +-
 include/linux/fsnotify_backend.h                   |   1 +
 include/linux/futex.h                              |  14 +-
 include/linux/huge_mm.h                            |   2 +-
 include/linux/io_uring_types.h                     |   3 +
 include/linux/ipv6.h                               |  22 ++
 include/linux/key-type.h                           |   1 +
 include/linux/key.h                                |   5 +
 include/linux/maple_tree.h                         |   4 +
 include/linux/mm_types.h                           |   3 +
 include/linux/power_supply.h                       |   6 +-
 include/linux/sched.h                              |   2 +-
 include/linux/sched/signal.h                       |  27 +-
 include/linux/sched/user.h                         |   8 +-
 include/linux/srcutiny.h                           |   4 -
 include/linux/unicode.h                            |   1 +
 include/net/af_vsock.h                             |   3 +
 include/net/ax25.h                                 |   6 +
 include/net/codel_impl.h                           |   1 +
 include/net/ipv6.h                                 |   2 -
 include/net/netfilter/nf_tables_ipv6.h             |   4 +-
 include/net/netrom.h                               |  18 +-
 include/net/rose.h                                 |  45 ++-
 include/uapi/asm-generic/fcntl.h                   |   1 -
 io_uring/cancel.c                                  |  29 +-
 io_uring/cancel.h                                  |   2 +
 io_uring/futex.c                                   |   7 +-
 io_uring/io-wq.c                                   | 110 +++++-
 io_uring/io-wq.h                                   |   4 +-
 io_uring/io_uring.c                                | 167 +++++++--
 io_uring/io_uring.h                                |  44 ++-
 io_uring/kbuf.c                                    |   2 +-
 io_uring/napi.c                                    |   4 +-
 io_uring/net.c                                     |  26 +-
 io_uring/poll.c                                    |  41 ++-
 io_uring/rw.c                                      |  18 -
 io_uring/sqpoll.c                                  |   7 +
 io_uring/tctx.c                                    |   1 +
 io_uring/timeout.c                                 |  91 +++--
 io_uring/uring_cmd.c                               |   2 +-
 io_uring/waitid.c                                  |  19 +-
 kernel/cgroup/cgroup.c                             |   6 +-
 kernel/events/core.c                               |  33 +-
 kernel/exit.c                                      |   2 +-
 kernel/fork.c                                      |  12 +-
 kernel/futex/core.c                                |  47 +--
 kernel/pid_namespace.c                             |   5 +-
 kernel/printk/printk.c                             |   2 +-
 kernel/ptrace.c                                    |   6 +
 kernel/rcu/srcutiny.c                              |  19 +-
 kernel/sched/ext.c                                 |  18 +-
 kernel/signal.c                                    |   4 +
 kernel/trace/ftrace.c                              |   4 +-
 kernel/trace/ring_buffer.c                         |  13 +-
 kernel/trace/trace.c                               |  13 +-
 kernel/trace/trace_events_filter.c                 |  15 +-
 kernel/trace/trace_events_hist.c                   |  52 +--
 kernel/trace/trace_events_synth.c                  |  10 +
 kernel/trace/trace_probe.c                         |   3 +-
 kernel/trace/trace_synth.h                         |   1 +
 kernel/watch_queue.c                               |  16 +-
 kernel/workqueue.c                                 |  24 +-
 mm/filemap.c                                       |   9 -
 mm/huge_memory.c                                   |  81 +++--
 mm/internal.h                                      |   6 +
 mm/khugepaged.c                                    |   3 +
 mm/pagewalk.c                                      |   6 +-
 net/ax25/af_ax25.c                                 |  81 ++++-
 net/ax25/ax25_ds_in.c                              |   2 +
 net/ax25/ax25_in.c                                 |  55 ++-
 net/ax25/ax25_out.c                                | 121 +++++--
 net/ax25/ax25_std_in.c                             |  44 +++
 net/ax25/ax25_subr.c                               |  44 ++-
 net/bluetooth/l2cap_core.c                         |   7 +-
 net/bluetooth/l2cap_sock.c                         |   2 +
 net/bridge/br_multicast.c                          |  13 +-
 net/bridge/br_netfilter_ipv6.c                     |   2 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |   4 +-
 net/core/page_pool.c                               |   3 +-
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
 net/iucv/af_iucv.c                                 |  42 ++-
 net/mac802154/ieee802154_i.h                       |   7 +-
 net/mac802154/main.c                               |   1 +
 net/mac802154/scan.c                               |  51 ++-
 net/mptcp/protocol.c                               |  14 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   2 +-
 net/netfilter/nf_conntrack_ovs.c                   |   2 +-
 net/netfilter/nf_log_syslog.c                      |   2 +-
 net/netfilter/nft_byteorder.c                      |  51 ++-
 net/netlink/af_netlink.c                           |  10 +-
 net/netrom/af_netrom.c                             |  33 +-
 net/netrom/nr_in.c                                 |  26 ++
 net/netrom/nr_route.c                              | 383 +++++++++++----------
 net/rds/rdma_transport.c                           |  38 +-
 net/rose/af_rose.c                                 |  73 +++-
 net/rose/rose_in.c                                 |  44 ++-
 net/rose/rose_link.c                               |  47 +++
 net/rose/rose_loopback.c                           |   2 +-
 net/rose/rose_out.c                                |   1 +
 net/rose/rose_route.c                              | 200 +++++++++--
 net/rose/rose_timer.c                              |  87 ++++-
 net/sched/act_api.c                                |  11 +-
 net/sched/cls_flower.c                             |   5 +
 net/sched/sch_cake.c                               |   2 +-
 net/sctp/inqueue.c                                 |   6 +-
 net/sctp/socket.c                                  |  33 +-
 net/socket.c                                       |  54 ++-
 net/tipc/node.c                                    |   2 +
 net/vmw_vsock/af_vsock.c                           |  49 ++-
 net/vmw_vsock/virtio_transport_common.c            |   9 +-
 samples/pidfd/Makefile                             |   2 +-
 security/keys/key.c                                |  13 +-
 security/keys/keyctl.c                             |  15 +-
 security/keys/keyring.c                            | 150 ++++----
 security/keys/process_keys.c                       |   5 +-
 security/keys/trusted-keys/trusted_tpm1.c          |   4 +-
 security/keys/trusted-keys/trusted_tpm2.c          |   2 +-
 sound/soc/codecs/cs42l52.c                         |   2 +-
 sound/soc/codecs/cs42l56.c                         |   2 +-
 sound/soc/codecs/max98371.c                        |   2 +-
 sound/soc/codecs/nau8822.c                         |   4 +-
 sound/soc/codecs/pcm3168a.c                        |   2 +-
 sound/soc/codecs/wm8978.c                          |   4 +-
 sound/soc/intel/avs/pcm.c                          |   2 +-
 sound/soc/sof/ipc4-topology.c                      |  16 +-
 sound/soc/stm/stm32_spdifrx.c                      |   2 +-
 tools/gpio/Makefile                                |   6 +
 tools/power/x86/turbostat/turbostat.c              |  11 +-
 .../test.d/filter/event-filter-incomplete.tc       |  24 ++
 229 files changed, 3065 insertions(+), 1216 deletions(-)


