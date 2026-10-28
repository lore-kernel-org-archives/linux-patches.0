Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207210;
	b=m48BMVAiVZNCrdI8AsYvkVnt6aRwS4p0lni/fLqaohBwVjSbxV5iOq56MxvcP4HO05CW
	 VE4ODGwBc95dfpp5OFgL2oYKrJL/IEyjEHCn3PMOtfBuN9VCASN7OFF02ljipBStiDiaY
	 u2mhH2FLpV0Na12eLrvdKHrPQhQFC2BsxAVtqnctVqY3R+5HHIiwKlAwNXMiF7nXuljs0
	 6J05VbA+JJbXGaW/Zl0/bPOUJHFMIoOtTDiS/mO6Xvkm1khqDx/kwdodOhfAW7zXqFOK5
	 vHVESNdZbNI/uX1EgvXVeiYHTSUT50GkQ9tW99BarwFd6Oi5AH2XrdaKszCjlxtHy+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Transfer-Encoding;
	bh=W2gmWX+TDoNPKkm6huo6mn3i68VwdlCFZWhkWWglJzM=;
	b=sXlpNNXdy2B4valaw7gfZCLjBSJ8PV3JUcWwSVkpW9TxYjMtuZJ4FHm+juDjrkm8MUdq
	 YOEWMzOOcZp30JpdWz2dHnTyoxO+1HaTW2Z+y7iPC3+UPZw9EmRq34oXaVQhpeC9KCvUe
	 iCOXC2MeQIAQJkNowse9HQOVhZ0X/+Gv/81jV1rIh7CG2Ul8TH/qpt7+Z/FkArzLYw2Hb
	 +2e3LBJPb0kBRhLK5cBSfMH8nW8yWyVaz/C8tRrBJ6S/9fzqJa9zlZ0SLiB9pKSTyMtqJ
	 g+49an4cW42PKWedZA10loqGQTcFNpZEp78KU1G137ombFxBK7o1eSP0j6IkUT/sWbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iC3KoLUt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1487606A31C;
	Wed, 28 Oct 2026 17:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iC3KoLUt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC001F01828;
	Wed, 28 Oct 2026 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207209;
	bh=W2gmWX+TDoNPKkm6huo6mn3i68VwdlCFZWhkWWglJzM=;
	h=From:To:Cc:Subject:Date;
	b=iC3KoLUtG9wI27mxp87e3LGHqfFurG03kxvfDBfhgyb6SeShjIet+Dv7ssaOlhPrB
	 6OljlsgjHr+lR/ARURwpd/qiPgUz57O77uKmWUBDGTpcG0BxCyPHFC1sAplXNgQqJK
	 Iw35cN5BaohiR1zSIMVyuB1o3mh1Na3Awc4HROSE=
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
Subject: [PATCH 7.2 00/88] 7.2.14-rc1 review
Date: Wed, 28 Oct 2026 17:59:08 +0100
Message-ID: <20261028165942.107695352@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.2.14-rc1
X-KernelTest-Deadline: 2026-10-30T16:59+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.2.14 release.
There are 88 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.2.14-rc1

Christian Brauner <brauner@kernel.org>
    signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL

Christian Brauner <brauner@kernel.org>
    pid_namespace: prevent TIF_NOTIFY_SIGNAL from interrupting the reaper

Christian Brauner <brauner@kernel.org>
    coredump: prevent TIF_NOTIFY_SIGNAL from interrupting coredumps

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
    io_uring/timeout: use the right clock for ABS updates

Josef Bacik <josef@toxicpanda.com>
    io_uring/timeout: keep repeat count on multishot update

Josef Bacik <josef@toxicpanda.com>
    io_uring/timeout: don't skip over reached sequences

Josef Bacik <josef@toxicpanda.com>
    io_uring/fdinfo: fix CQE dump of CQE32 rings

Josef Bacik <josef@toxicpanda.com>
    io_uring/register: keep 128b SQEs intact on resize

Josef Bacik <josef@toxicpanda.com>
    io_uring/register: handle index wrap when resizing

Josef Bacik <josef@toxicpanda.com>
    io_uring/register: don't wrap 32b CQEs when resizing

Josef Bacik <josef@toxicpanda.com>
    io_uring: don't split 128b SQEs at the SQPOLL cap

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
    io_uring/mpscq: disable preemption while pushing

Josef Bacik <josef@toxicpanda.com>
    io_uring/cancel: rearm local work wake up before sleep

Josef Bacik <josef@toxicpanda.com>
    io_uring: don't lose the DEFER_TASKRUN wake up

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

Haoran Wang <haoranwangsec@gmail.com>
    tracing/syscalls: Use copy_from_user for the faultable syscall buffer

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

Sasha Levin <sashal@kernel.org>
    tools/dma: fix building with O=

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: refuse __l2cap_chan_add if chan already has conn

Hui Su <sh_def@163.com>
    sched/fair: Avoid overflow in place_entity()

SJ Park <sj@kernel.org>
    mm/damon/core: error damos_commit_quota_goal() for zero target_value

Hongling Zeng <zenghongling@kylinos.cn>
    ntfs: take invalidate_lock in ntfs_filemap_page_mkwrite()

Hongling Zeng <zenghongling@kylinos.cn>
    ntfs: fix race between fallocate and mmap reads

Kuba Piecuch <jpiecuch@google.com>
    sched_ext: Wait for SCX_OPSS_DISPATCHING before moving tasks off DSQs


-------------

Diffstat:

 Makefile                                           |   4 +-
 crypto/asymmetric_keys/restrict.c                  |   8 +-
 fs/coredump.c                                      |  18 ++-
 fs/ntfs/file.c                                     |  32 ++--
 include/linux/io_uring_types.h                     |   5 +
 include/linux/key-type.h                           |   1 +
 include/linux/key.h                                |   5 +
 include/linux/sched.h                              |   2 +-
 include/linux/sched/signal.h                       |  27 +++-
 io_uring/cancel.c                                  |  43 ++++-
 io_uring/cancel.h                                  |   2 +
 io_uring/fdinfo.c                                  |  14 +-
 io_uring/futex.c                                   |  32 +++-
 io_uring/io-wq.c                                   | 126 +++++++++++++--
 io_uring/io_uring.c                                | 180 ++++++++++++++++-----
 io_uring/io_uring.h                                |  44 ++++-
 io_uring/kbuf.c                                    |   2 +-
 io_uring/loop.c                                    |   8 +-
 io_uring/mpscq.h                                   |  14 +-
 io_uring/napi.c                                    |   4 +-
 io_uring/net.c                                     |  26 ++-
 io_uring/openclose.c                               |  11 +-
 io_uring/poll.c                                    |  38 ++++-
 io_uring/register.c                                |  54 ++++++-
 io_uring/rw.c                                      |  18 ---
 io_uring/sqpoll.c                                  |   7 +
 io_uring/timeout.c                                 | 102 +++++++++---
 io_uring/tw.c                                      |  36 ++++-
 io_uring/uring_cmd.c                               |   2 +-
 io_uring/wait.c                                    |  48 ++++--
 io_uring/wait.h                                    |  15 ++
 io_uring/waitid.c                                  |  19 ++-
 io_uring/zcrx.c                                    |   2 +-
 kernel/exit.c                                      |   5 +-
 kernel/fork.c                                      |   9 +-
 kernel/pid_namespace.c                             |   3 +-
 kernel/ptrace.c                                    |   6 +
 kernel/sched/ext/ext.c                             |  14 +-
 kernel/sched/fair.c                                |  16 +-
 kernel/signal.c                                    |   4 +
 kernel/trace/ftrace.c                              |   4 +-
 kernel/trace/trace.c                               |  21 ++-
 kernel/trace/trace_events_filter.c                 |   6 +
 kernel/trace/trace_events_hist.c                   |  33 ++--
 kernel/trace/trace_events_synth.c                  |  10 ++
 kernel/trace/trace_synth.h                         |   1 +
 kernel/trace/trace_syscalls.c                      |   2 +-
 mm/damon/core.c                                    |  22 ++-
 mm/damon/sysfs.c                                   |  19 +++
 net/bluetooth/l2cap_core.c                         |   7 +-
 net/bluetooth/l2cap_sock.c                         |   2 +
 security/keys/key.c                                |  13 +-
 security/keys/keyctl.c                             |  15 +-
 security/keys/keyring.c                            | 150 +++++++++--------
 security/keys/process_keys.c                       |   5 +-
 security/keys/trusted-keys/trusted_tpm1.c          |   4 +-
 security/keys/trusted-keys/trusted_tpm2.c          |   2 +-
 tools/dma/Makefile                                 |   4 +-
 .../test.d/filter/event-filter-incomplete.tc       |  24 +++
 59 files changed, 1036 insertions(+), 314 deletions(-)


