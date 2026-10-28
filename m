Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207151;
	b=vc5cBYesE/VrBtdiCbAYRTVqgxZYRuPSIelO9Pi6o4eEz4yzFuHmvDVrPRSKBUjXwfOx
	 ge8eTTt3ArfDo+sTNMbgadwErmIq0fqxA0ZLYSP44TQKC8aaNkjP3LLfpxc+vwdXJFYTe
	 iiG4KkcJA+ri883LSsKnSsEb50Zz4txf8ePvj5MIDt1y897CaBcs6dkvfyEk59Ih8EynH
	 T3x2rGSm31byayMAsRr+KsbbLTCGq8QTrcugJ+YHb+CLZedQPU3B8zkZ25k9QIVmIh8sA
	 xstRiPrP4A2j/11h+MoV2CHrJfoi2gqJx4E5AX+BfKhD4UVA8HTPfjTjPR6sT6RIVLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Transfer-Encoding;
	bh=W9AhoeHo6WX4yj7YOq16vc7HSAofrdCUagI8vNchmjc=;
	b=sSUdZ/fsfdKHXI0UG/xR6FolFY9cEpsLJptMfJ5blmadgaHOHU7jI9XqXefSMMgVa3hH
	 qpYPXufKgCBgT5ZHGHfCG1f+FNqAgxPyvn/+7RCKs0LhHvCOLNejRIVZ7rNtnPz5JNSD4
	 cRHxD8fLUwKarx6CV9sJZTEXpoFo4m6j1Q6D09u3F9vw7HmbL2d0tC/So/pzPcKMWLRQY
	 v8rhxOO4tbPl7LrVWxjl9DsljdhOKfWmOZ6OszMT4yFjwSAxDGUr+aq8rMMwX7bYNRT0V
	 FEKCP99DUaBukPYDXYD2C8fwBCorD2Lyt6g4OKD4g0v6g8GJdspAjDDepKETmQ/HQog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQZroQ04;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9159C606A31A;
	Wed, 28 Oct 2026 17:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQZroQ04
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EE51F01828;
	Wed, 28 Oct 2026 17:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207150;
	bh=W9AhoeHo6WX4yj7YOq16vc7HSAofrdCUagI8vNchmjc=;
	h=From:To:Cc:Subject:Date;
	b=lQZroQ04r/mxVposNyg4qvDZzUDog3xBGYpMf4lNGRV9uahNUFinJiMUCKPe70OBv
	 XftF5MT2yj8+YlGYc8IUrKJybQ6x/Xja8cZNsRCAhcB8/edynm9bHyMphTeOR6fNVp
	 3pcZzMlFBtj9rSmwepqBEPTkvUvnF07+EFqLQ7jY=
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
Subject: [PATCH 7.3 00/38] 7.3.1-rc1 review
Date: Wed, 28 Oct 2026 17:59:47 +0100
Message-ID: <20261028165940.394092994@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.3.1-rc1
X-KernelTest-Deadline: 2026-10-30T16:59+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.3.1 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.3.1-rc1

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
    io-wq: order the exit bit against worker creation task work

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
    io_uring: end the drain when the drain request completes

Junyeong Lee <jylee5498@gmail.com>
    io_uring/waitid: prevent cancel reference wrap

Tamaki Yanagawa <ty@000ty.net>
    io_uring/net: keep recv buffer select length within MAX_RW_COUNT

Austin Schuh <austin.linux@gmail.com>
    io_uring/wait: wake real-time waiters from hard interrupt context

Juanlu Herrero <juanlu@fastmail.com>
    io_uring/poll: avoid retry wakeup loss when dropping ownership

Haoran Wang <haoranwangsec@gmail.com>
    tracing/syscalls: Use copy_from_user for the faultable syscall buffer

Lee Jones <lee@kernel.org>
    tracing/histograms: Verify event_call identity when updating synth_event refcount

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix 64-bit and signed histogram fields on 32-bit kernels

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Add the bucket size to expr_field_str()

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

SJ Park <sj@kernel.org>
    mm/damon/core: error damos_commit_quota_goal() for zero target_value

Haris Okanovic <harisokn@amazon.com>
    genirq/proc: Fix missing CPU header in /proc/interrupts


-------------

Diffstat:

 Makefile                                           |   4 +-
 crypto/asymmetric_keys/restrict.c                  |   8 +-
 fs/coredump.c                                      |  18 +--
 include/linux/io_uring_types.h                     |   2 +
 include/linux/key-type.h                           |   1 +
 include/linux/key.h                                |   5 +
 include/linux/sched.h                              |   2 +-
 include/linux/sched/signal.h                       |  27 +++-
 io_uring/io-wq.c                                   |   2 +
 io_uring/io_uring.c                                |  42 +++++-
 io_uring/net.c                                     |   2 +
 io_uring/poll.c                                    |   3 +-
 io_uring/wait.c                                    |  16 ++-
 io_uring/waitid.c                                  |   7 +-
 kernel/exit.c                                      |   5 +-
 kernel/fork.c                                      |   9 +-
 kernel/irq/proc.c                                  |  24 +++-
 kernel/pid_namespace.c                             |   3 +-
 kernel/ptrace.c                                    |   6 +
 kernel/signal.c                                    |   4 +
 kernel/trace/ftrace.c                              |   4 +-
 kernel/trace/trace.c                               |  21 ++-
 kernel/trace/trace_events_filter.c                 |   6 +
 kernel/trace/trace_events_hist.c                   |  36 +++--
 kernel/trace/trace_events_synth.c                  |  10 ++
 kernel/trace/trace_synth.h                         |   1 +
 kernel/trace/trace_syscalls.c                      |   2 +-
 mm/damon/core.c                                    |  22 ++-
 net/bluetooth/l2cap_core.c                         |   7 +-
 net/bluetooth/l2cap_sock.c                         |   2 +
 security/keys/key.c                                |  13 +-
 security/keys/keyctl.c                             |  15 ++-
 security/keys/keyring.c                            | 150 +++++++++++----------
 security/keys/process_keys.c                       |   5 +-
 security/keys/trusted-keys/trusted_tpm1.c          |   4 +-
 security/keys/trusted-keys/trusted_tpm2.c          |   2 +-
 tools/dma/Makefile                                 |   4 +-
 .../test.d/filter/event-filter-incomplete.tc       |  24 ++++
 38 files changed, 362 insertions(+), 156 deletions(-)


