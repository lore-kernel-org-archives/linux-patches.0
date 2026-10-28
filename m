Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212087;
	b=AM9OnGAf2l76xW0lF5G7BqvT+TSFtvPaznGeERswdOINoenYG8WQnsfFL52hCDmlvsa3
	 N9It0pPDlDU6L5T+MHElySdY696MzUwDNvkI1a36GZvhXkIWsaSpmUnXk3agjFrW7123I
	 QyxTxIH5KdszvyemswQKPiEa0KW7hBYN+7XxlrCxv9KHSv/j2oS/9lGURNZ7IEes8Gn4L
	 MhLaiQKh4sODi+x88wSVVRxXjNfNmL5AW12WBJgG8ayio3cFpk0e5Y0NIX0g7CvQCvD49
	 9soCbTiY1u8LgCwqFIXEN12X+6kWl8KKqkQXbxuidzOnLE1VvMooHx9AAThlpJvmcTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cMWxF8kwC+g+Yzu9QhpXzouG/BUbZYoxddct7cHpTx0=;
	b=D7uOt1ZGF6p4aABC1owmkuxBw4yxhb8V8Avod9OhXABoJRNRFLXsJDrM5U1kyFne6TU8
	 lg92SDn/woZewVFPD+UzKVI+22iDtPm/HQ1EUT6wNnM7gln8GnEViP8x/Hnf2g81YJD7Z
	 2XMMr7qFU09MtIPdFgtl7brOTQ4/KmONwKxueOTCBFiE/7ZJMRx/DuKnStAIBq6eR3CFF
	 /7zkv2PQXOEVkA9HhJxxlkY7TTVubJIYj30L2K4Vy28bCvSVtyKtwpcKquCMZEIw3l7e9
	 sv8ngwIv1dDbdphoKaHEcXcWO2Lae90iBACz1WQzcPQNZ1ev2dlncG1TQg5PXdai+VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xStjVa7/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23256606A31D;
	Wed, 28 Oct 2026 18:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xStjVa7/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CDD1F01825;
	Wed, 28 Oct 2026 18:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212087;
	bh=cMWxF8kwC+g+Yzu9QhpXzouG/BUbZYoxddct7cHpTx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xStjVa7/nMwZO/0MBD6AT+fpqZg8QPIfIl1NFN5+v+A3Uy0oOvBkBVdbSF//9BmWd
	 z6REFTwQA/MsObs5SlUQYLbnsEEAiVeTDO4ZGF8l85z5GoMYWK1DXHTcOXVq2LQz92
	 pr+Br3bEG62zZ/tAYS1jYoDpTqzVXhiGdDtu64eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.1 0016/1887] io_uring: dont pass restart error codes to userspace
Date: Wed, 28 Oct 2026 17:35:12 +0100
Message-ID: <20261028170459.591973860@linuxfoundation.org>
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

Commit e1a64bc64897f4c2fe460922c345f2ed8f889b5f upstream.

-ERESTARTSYS and friends are instructions for the system call exit code,
which either restarts the call or turns them into -EINTR. They are not
supposed to be seen by applications. A request isn't a system call,
nobody looks at what it returns before that is put into a CQE.

The read/write and the networking opcodes convert these codes to -EINTR
by hand. The others don't. An io-wq worker that is blocked in the open of
a FIFO, a tty or some other device, or in a splice from an empty pipe,
and that gets interrupted because the request is cancelled, completes it
with -512:

  IORING_OP_OPENAT, IOSQE_ASYNC       // FIFO without a writer
  IORING_OP_ASYNC_CANCEL              // -EALREADY, worker is signalled
  CQE of the open: res == -512

There are more candidates, like whatever a file system or driver returns
from ->flush(), ->fsync(), ->fallocate() or ->uring_cmd(), or breaking a
lease or delegation.

Take care of it in io_issue_sqe(), which all of them go through. The
helper is moved from rw.c as is. The cost is a compare and a branch that
is not taken per request.

[ 6.1: io_issue_sqe() returns IOU_OK and an error straight away ]
Fixes: 15b71abe7b52 ("io_uring: add support for IORING_OP_OPENAT")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-39-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    8 +++++++-
 io_uring/io_uring.h |   18 ++++++++++++++++++
 io_uring/rw.c       |   18 ------------------
 3 files changed, 25 insertions(+), 19 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1741,12 +1741,18 @@ static int io_issue_sqe(struct io_kiocb
 	}
 
 	if (ret == IOU_OK) {
+		/* not all handlers take care of the internal restart codes */
+		if (unlikely(req->cqe.res <= -ERESTARTSYS))
+			req->cqe.res = io_fixup_restart_res(req->cqe.res);
 		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 			io_req_complete_defer(req);
 		else
 			io_req_complete_post(req);
-	} else if (ret != IOU_ISSUE_SKIP_COMPLETE)
+	} else if (ret != IOU_ISSUE_SKIP_COMPLETE) {
+		if (unlikely(ret <= -ERESTARTSYS))
+			ret = io_fixup_restart_res(ret);
 		return ret;
+	}
 
 	/* If the op doesn't have a file, we're not polling for it */
 	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -155,6 +155,24 @@ static inline bool __io_fill_cqe_req(str
 	return true;
 }
 
+static inline ssize_t io_fixup_restart_res(ssize_t ret)
+{
+	switch (ret) {
+	case -ERESTARTSYS:
+	case -ERESTARTNOINTR:
+	case -ERESTARTNOHAND:
+	case -ERESTART_RESTARTBLOCK:
+		/*
+		 * We can't just restart the syscall, since previously
+		 * submitted sqes may already be in progress. Just fail
+		 * this IO with EINTR.
+		 */
+		return -EINTR;
+	default:
+		return ret;
+	}
+}
+
 static inline void req_set_fail(struct io_kiocb *req)
 {
 	req->flags |= REQ_F_FAIL;
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -129,24 +129,6 @@ void io_readv_writev_cleanup(struct io_k
 	kfree(io->free_iovec);
 }
 
-static inline ssize_t io_fixup_restart_res(ssize_t ret)
-{
-	switch (ret) {
-	case -ERESTARTSYS:
-	case -ERESTARTNOINTR:
-	case -ERESTARTNOHAND:
-	case -ERESTART_RESTARTBLOCK:
-		/*
-		 * We can't just restart the syscall, since previously
-		 * submitted sqes may already be in progress. Just fail
-		 * this IO with EINTR.
-		 */
-		return -EINTR;
-	default:
-		return ret;
-	}
-}
-
 static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 {
 	/* IO was queued async, completion will happen later */


