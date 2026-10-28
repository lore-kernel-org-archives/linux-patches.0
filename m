Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209697;
	b=QMVdnOZDiRy35xeIHTBKC/0KH1N57wEls/DCmTrcwhG2myMnCyBgGDtcMzfLqRa1Nsr6
	 VceWvv/FKeoUf7UVfBObpB7GvBCMPRrulrrAB0bJAsaUrhuC8rIOm/svLMV83wS4IPTHT
	 shvduCxL+VLgfR0756E7ZerBIDD6uMcejSsgwIvLQYCMcFXvWLji5Xp1y2A02dshJbKVk
	 dSlSh1CR1+aIiqPPhRalvPg7dnJZ4tagPlNcPEoseECFqtHVjmfwsUlyY45Vl9rfCypZk
	 1C0hYsgJ5Q0dnN5rT5JuUK5kXzlJSm9V1SnaMz8t3RGWUxlkAGb2lwoNRCi8w3sUXbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=a2Yz2B2zEDhVdlLWMtPCQoyUy4ZjwPyY+6DplsMbzCk=;
	b=DgnB0co+tuNdKtU6nWMNp7Iu4STc+KMBfvAnB++1t8JbDT59SofG/VYjndekkd5mNfFH
	 pSh8I3RWjrrjcEa2+vPzg4ZKy13vp2ASaxiGWMoUHlPylK9hKqNSqGLIo1dn/Yc5eAOdu
	 /QA76ihQqIJouQhzMv8rW2ZtZP2lc9FeybNQIUpXO/WDobxou72mIJg1PRuySqm6hk1Fq
	 XUGr1HrmiAicqDgWgFzNq5uPef98goOGx7k87VBsGStxPdbzbiAVrXS6wdExDlu5TcNSq
	 R80334oqLOrCx49QjWC0fv/XmwQkV5j6D0JHLiK9HOHyl8lKfA+K/Vxqo+WQX5A9eLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x6Ega2Ra;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25532606A31C;
	Wed, 28 Oct 2026 17:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x6Ega2Ra
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7531F01828;
	Wed, 28 Oct 2026 17:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209696;
	bh=a2Yz2B2zEDhVdlLWMtPCQoyUy4ZjwPyY+6DplsMbzCk=;
	h=From:To:Cc:Subject:Date;
	b=x6Ega2RawE4T8O67eFlR/AmDu2J22YujavPhn/pqfefOctheqDVebt6r77TnSykFS
	 1Ai71QYx+5kXIAiFeBA+4WXAZrjNoumrqPtEQPyGIiHm96F5aedG19iz5zQBNITNEy
	 lnRKncWojV5y3Jmh5mhaLssBXyEZRRfAWnfoA33s=
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
Subject: [PATCH 6.18 000/109] 6.18.60-rc1 review
Date: Wed, 28 Oct 2026 17:59:44 +0100
Message-ID: <20261028165942.357251485@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.60-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.60-rc1
X-KernelTest-Deadline: 2026-10-30T16:59+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.60 release.
There are 109 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.60-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.60-rc1

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: scan: Avoid registering platform devices with resource overlaps

Christian Brauner <brauner@kernel.org>
    signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL

Christian Brauner <brauner@kernel.org>
    pid_namespace: prevent TIF_NOTIFY_SIGNAL from interrupting the reaper

Christian Brauner <brauner@kernel.org>
    exit: hang up the tty before closing the files

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

Jens Axboe <axboe@kernel.dk>
    io_uring: keep the drain active when a deferred drain request is started

Jens Axboe <axboe@kernel.dk>
    io_uring: end the drain when the drain request completes

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
    io_uring/openclose: keep the lock in io_pipe_fixed()

Josef Bacik <josef@toxicpanda.com>
    io_uring/sqpoll: let the thread sleep on disabled rings

Josef Bacik <josef@toxicpanda.com>
    io_uring/kbuf: handle index wrap in last buffer check

Josef Bacik <josef@toxicpanda.com>
    io_uring/zcrx: fix buffer offsets in areas above 4GB

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
    io_uring/fdinfo: fix CQE dump of CQE32 rings

Josef Bacik <josef@toxicpanda.com>
    io_uring/register: handle index wrap when resizing

Josef Bacik <josef@toxicpanda.com>
    io_uring/register: don't wrap 32b CQEs when resizing

Josef Bacik <josef@toxicpanda.com>
    io_uring: drop the CQE cache if a refill fails

Josef Bacik <josef@toxicpanda.com>
    io_uring/futex: allocate private hash before waiting

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
    io_uring/io-wq: don't go to sleep on pending work

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

Zihan Xi <zihanx@nebusec.ai>
    net: gso: limit recursive IP-in-IP segmentation

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

David Carlier <devnexen@gmail.com>
    tracing: Hold trace_types_lock when resetting last boot data from readers

David Carlier <devnexen@gmail.com>
    tracing: Hold trace_types_lock when updating modules in persistent instances

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: refuse __l2cap_chan_add if chan already has conn

Jonas Köppeler <j.koeppeler@tu-berlin.de>
    net_sched: codel: fix stale state for empty flows in fq_codel

SJ Park <sj@kernel.org>
    mm/damon/core: error damos_commit_quota_goal() for zero target_value

Damien Le Moal <dlemoal@kernel.org>
    block: avoid potential deadlock on zone revalidation failure

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

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: change XDP RxQ frag_size from DMA write length to xdp.frame_sz

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: fix rxq info registering in mbuf packets

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: scan: Register platform devices for fixed event buttons

Joseph Qi <joseph.qi@linux.alibaba.com>
    eventfs: fix SRCU read lock leak in eventfs_iterate()


-------------

Diffstat:

 Makefile                                           |   4 +-
 block/blk-zoned.c                                  |  37 +-
 block/blk.h                                        |   4 +-
 block/genhd.c                                      |   2 +-
 crypto/asymmetric_keys/restrict.c                  |   8 +-
 drivers/acpi/acpi_platform.c                       |  75 +++-
 drivers/acpi/scan.c                                |   4 +
 drivers/net/ethernet/intel/ice/ice_base.c          |  33 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   1 +
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   4 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   3 +
 fs/coredump.c                                      |  16 +-
 fs/tracefs/event_inode.c                           |   6 +-
 include/linux/io_uring_types.h                     |   5 +
 include/linux/key-type.h                           |   1 +
 include/linux/key.h                                |   5 +
 include/linux/sched.h                              |   2 +-
 include/linux/sched/signal.h                       |  27 +-
 include/net/ax25.h                                 |   6 +
 include/net/codel_impl.h                           |   1 +
 include/net/gso.h                                  |   8 +
 include/net/netrom.h                               |  18 +-
 include/net/rose.h                                 |   5 +
 io_uring/cancel.c                                  |  29 +-
 io_uring/cancel.h                                  |   2 +
 io_uring/fdinfo.c                                  |  14 +-
 io_uring/futex.c                                   |  32 +-
 io_uring/io-wq.c                                   | 126 ++++++-
 io_uring/io_uring.c                                | 231 ++++++++++---
 io_uring/io_uring.h                                |  44 ++-
 io_uring/kbuf.c                                    |   2 +-
 io_uring/napi.c                                    |   4 +-
 io_uring/net.c                                     |  26 +-
 io_uring/openclose.c                               |  11 +-
 io_uring/poll.c                                    |  38 +-
 io_uring/register.c                                |  20 +-
 io_uring/rw.c                                      |  18 -
 io_uring/sqpoll.c                                  |   7 +
 io_uring/timeout.c                                 |  91 +++--
 io_uring/uring_cmd.c                               |   2 +-
 io_uring/waitid.c                                  |  19 +-
 io_uring/zcrx.c                                    |   2 +-
 kernel/exit.c                                      |   5 +-
 kernel/fork.c                                      |   9 +-
 kernel/pid_namespace.c                             |   3 +-
 kernel/ptrace.c                                    |   6 +
 kernel/signal.c                                    |   4 +
 kernel/trace/ftrace.c                              |   4 +-
 kernel/trace/trace.c                               |  21 +-
 kernel/trace/trace_events_filter.c                 |   6 +
 kernel/trace/trace_events_hist.c                   |  33 +-
 kernel/trace/trace_events_synth.c                  |  10 +
 kernel/trace/trace_synth.h                         |   1 +
 mm/damon/core.c                                    |  22 +-
 mm/damon/sysfs.c                                   |  19 +
 net/ax25/af_ax25.c                                 |  81 ++++-
 net/ax25/ax25_ds_in.c                              |   2 +
 net/ax25/ax25_in.c                                 |  55 ++-
 net/ax25/ax25_out.c                                | 121 +++++--
 net/ax25/ax25_std_in.c                             |   8 +
 net/ax25/ax25_subr.c                               |  44 ++-
 net/bluetooth/l2cap_core.c                         |   7 +-
 net/bluetooth/l2cap_sock.c                         |   2 +
 net/core/gso.c                                     |   1 +
 net/ipv4/af_inet.c                                 |   3 +
 net/ipv6/ip6_offload.c                             |   4 +
 net/netrom/af_netrom.c                             |  33 +-
 net/netrom/nr_in.c                                 |  26 ++
 net/netrom/nr_route.c                              | 383 +++++++++++----------
 net/rose/af_rose.c                                 |   5 +
 net/rose/rose_in.c                                 |  31 ++
 net/rose/rose_link.c                               |  42 +++
 net/rose/rose_loopback.c                           |   2 +-
 net/rose/rose_out.c                                |   1 +
 net/rose/rose_route.c                              | 119 ++++++-
 security/keys/key.c                                |  13 +-
 security/keys/keyctl.c                             |  15 +-
 security/keys/keyring.c                            | 150 ++++----
 security/keys/process_keys.c                       |   5 +-
 security/keys/trusted-keys/trusted_tpm1.c          |   4 +-
 security/keys/trusted-keys/trusted_tpm2.c          |   2 +-
 .../test.d/filter/event-filter-incomplete.tc       |  24 ++
 82 files changed, 1722 insertions(+), 597 deletions(-)


