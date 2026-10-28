Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212041;
	b=Y95kaZjvpJudcocti7PhIblTIj1by0RE7fVRFKgFVAKfxkVgh8LmiAJJr+ark/lchMBw
	 52Qkw1M/9JCzgBWLiNOPHFS9I5WFdKPhc4MMBbF8vLWBV+SbfT7pQz9oD6gfz4SXWEaZd
	 SY8dLdpgP0ByreVH9tlbBHykreSJiL04Zw1PLJYuFUtP5PDOVw8YIMmZlCUXoZvxSGln1
	 KNO2Df9wOBOQEPzNkhuejKzjKMK44CZ3TkHR2XoXtq+rQhyYpBEurZoodjSmy2kZ0CqL1
	 u52a6YaLhnwz0X1I01Fb/jHkHxC2PpJ99Rlq1ZITWfm9AD1n5u3CQs+CwmgdTSlMU/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hunYmxkKLgy3EtPkYKRJSOu1v6U509rUHo9fkbWmA3I=;
	b=RI8Yb+5BjzyAsJpFCUfv7o882Q2GcHpHDdyWzz0rgPhJ2jV6Jo6l0zW2U2BDOUC9gYmx
	 N77AxuB0QuxqIYqBRI23fR4LnlgDRLF0kQ5bmRqMGKKtzZ1dbLPBbZDtRwk/xqdOzi85X
	 03VCnHuycRlhlUBRUZwnL4N+x/5tv/onr+rspn0IVa7IYBfsFk5IQMN6UtiX/uImocWrG
	 Ooj74daXwPDbd85eiHq1dMbTjiKht1AgG0e4hiszeZTmFRXR0Hv2FSGE21LnvAq6DPU/1
	 KNyDEZQ9+czMKoavEmT8nxPJU5D0zmGPddE6FQzy9T+Oqnz71phIJ552/SaN+44s4GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HrYb3/GA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300F4606A31C;
	Wed, 28 Oct 2026 18:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HrYb3/GA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812CE1F01825;
	Wed, 28 Oct 2026 18:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212041;
	bh=hunYmxkKLgy3EtPkYKRJSOu1v6U509rUHo9fkbWmA3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HrYb3/GA6dkfHt6ZlxGrNbWrqJIsEuw6ZoohKGpj0v9x9kkLgZrZkdh+hj7vdjLGv
	 99zYUgYDI9FH0lraBcRPOQoXEHJDsZo0aKbG8nr1ZvOGeVEIwLlhWw3eYLgTcwSR5e
	 svwbmar0duZMJVBQI4dO9mIovE8MFNhpcYN0ukg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.1 0006/1887] io_uring/io-wq: dont exit with a creation pending
Date: Wed, 28 Oct 2026 17:35:02 +0100
Message-ID: <20261028170459.364694683@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit e231d2e8f80d3649ecd3851b7f2abdfbe606c04b upstream.

A worker that is the last one to go to sleep while work is pending asks
for another worker. io_wq_dec_running() bumps ->nr_running on behalf of
the new worker and queues create_worker_cb() as task_work for the owner
of the io-wq. Until that has run, everybody else takes it that a worker
is running which is going to look after the work list: io_wq_enqueue()
doesn't create one, and other workers that go to sleep don't find
themselves to be the last.

If the worker that made the request exits, io_worker_exit() cancels the
task_work, and io_worker_cancel_cb() drops ->nr_running without a look at
the work list:

worker A                   worker B                 io_wq_enqueue()
blocks, work is pending
  nr_running++
  queues create_worker_cb()
wakes, handles the work
idle timeout, decides to exit
                           picks up work 1
                                                    queues work 2
                                                    B is on the free list
                                                    still: wakes B
                           work 1 blocks
                             nr_running 2 -> 1
io_worker_exit()
  io_worker_cancel_cb()
    nr_running 1 -> 0

Work 2 has to wait for work 1, although there is room for more workers.
It takes an owner that doesn't get around to run its task_work for the
time of the idle timeout, less if the worker exits because its affinity
was changed or the io-wq is marked exit-on-idle.

Let the worker stay around until its request has been dealt with. Only
the worker itself sets ->create_state, so it can't be set behind its
back once it has decided to leave.

[ 6.1: no exit-on-idle state ]
Fixes: 1d5f5ea7cb7d ("io-wq: remove worker to owner tw dependency")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-12-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -697,8 +697,12 @@ static int io_wqe_worker(void *data)
 		/*
 		 * Last sleep timed out. Exit if we're not the last worker,
 		 * or if someone modified our affinity.
+		 * Not as long as a request of ours for another worker is
+		 * pending, though. It is accounted as a running worker, which
+		 * others rely on, and io_worker_exit() would cancel it.
 		 */
-		if (last_timeout && (exit_mask || acct->nr_workers > 1)) {
+		if (last_timeout && (exit_mask || acct->nr_workers > 1) &&
+		    !test_bit(0, &worker->create_state)) {
 			acct->nr_workers--;
 			if (worker->flags & IO_WORKER_F_FREE) {
 				worker->flags &= ~IO_WORKER_F_FREE;


