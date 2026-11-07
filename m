Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064926;
	b=17N/rOwrfUFx+X3newIPdmLY6sgOcTXNyFdPhH1ioPb60yolI19qKGbknrFAfdzoyXrc
	 ++pw4bbvp9TaNMZAsJMNQQFUZTdAxu25HXKXnR2XAgSu7EubUkZs/vvbFZB7Gl059DNH3
	 sOyvCflMVsDI5xGOxp0KTTTxz/lp2Tc/pbfsU+G1rGyzFdNo21ZBbUtseXSZB8hehS8Zx
	 KIQIKb8qmCo5SwJMpmaxQkV0ByhdlXt0yGa/tOZrcJdqFuJrb5m64EdJq/JU2uaqGdsx8
	 ZrvqBRy2ODFqdJ7iC+Ww8tKFlEPoDWdhf94BbzVEusrU4zLbpCjYPiLjXFQbDCDmaIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9lsK0T0v5lOEkhRxoOxi94XKoHkKaDRvSN9Jk1jCF6g=;
	b=dYNfslvCe5dntZvFasrSsjWGQG9KcgEyQka1U9uVRqH3DwxQ5rByN1a+z8ueqCDvVahB
	 8vjxH4Xb8mBV7h9vf2rr0LCISMzY5lsgJxy6say3Y/dC9+X900X2+2Arjbk/tCL3+1Sgi
	 nU56M4JAQP/CC7mFSa1shUhfEqw+fjuNTvQqFZ7EgKPVppP+k1tAkeFrqVq4FeguV9Mpj
	 kHl8Nhd4U5D4Wrh3kVcbi/Yhgp6DFLnmgN8NdSuujCG+S6d++3LL5Jj6nWAzup4gtq86v
	 tNDvmZ8Si8d5AaPAoW8sFKc7sF2t/Q/0yIJSyUsHN+rfxWBJp4bBf18xWRKKGC4tuvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SAvaTsnv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D59606A33E;
	Sat,  7 Nov 2026 15:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SAvaTsnv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23FA1F008A1;
	Sat,  7 Nov 2026 15:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064926;
	bh=9lsK0T0v5lOEkhRxoOxi94XKoHkKaDRvSN9Jk1jCF6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAvaTsnvI9yu/So0SnRGrgzaCIHwZR/PoCVQEaG4ZJmDqvpWwLm4gwZVKT/0j2Y1e
	 IORTgfDEvYRzGMRpRdf5ftvIB95qv0W2OW00mTskHGZkiJ9gU2JNZlcsuRmm3FOZT/
	 SLKeGN3cwA4VYDoWHoan8ejO4KDgtchYKnb4X57g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0821/1257] ublk: mark the io command cancelable before publishing it
Date: Sat,  7 Nov 2026 08:51:57 -0500
Message-ID: <20261107135002.017084989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

[ Upstream commit a261f0cacacc022e4fab5b8e38c59f74ce4942e8 ]

FETCH, COMMIT_AND_FETCH and NEED_GET_DATA publish the command in io->cmd
before marking it cancelable. A cancel from the control path (STOP_DEV,
QUIESCE_DEV) can complete it in between:

  issue path                       control-path cancel
  io->cmd = C
                                   take C, io_uring_cmd_done(C):
                                     C not marked, nothing to unlink
  ublk_prep_cancel(C)
    the completed C is linked on the cancelable list
  ring exit: the cancel walk hits it → GPF (KASAN, with a delay added)

Mark the command before ublk_fill_io_cmd() publishes it. The handlers
run with uring_lock held, as io_uring's cancel walk does, so marking
takes no lock and the walk can't see a marked command before it is
published. smp_wmb() orders the mark before the io->cmd store; the
cancel loads cmd with READ_ONCE(io->cmd) before reading cmd->flags.

A marked command has to be completed by io_uring_cmd_done(), so a failed
FETCH and the inline UBLK_IO_RES_OK of NEED_GET_DATA now do that. The CQE
is the same.

Fixes: 216c8f5ef0f2 ("ublk: replace monitor with cancelable uring_cmd")
Cc: stable@vger.kernel.org
Tested-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261011063555.1142277-3-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 38ed7d0e39793..6015fb2fb925f 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2800,7 +2800,8 @@ static void ublk_cancel_cmd(struct ublk_queue *ubq, u16 tag,
 	done = !!(io->flags & UBLK_IO_FLAG_CANCELED);
 	if (!done) {
 		io->flags |= UBLK_IO_FLAG_CANCELED;
-		cmd = io->cmd;
+		/* dependency ordered against smp_wmb() in ublk_prep_cancel() */
+		cmd = READ_ONCE(io->cmd);
 		io->cmd = NULL;
 	}
 	spin_unlock(&ubq->cancel_lock);
@@ -3163,6 +3164,12 @@ ublk_fill_io_cmd(struct ublk_io *io, struct io_uring_cmd *cmd)
 	return req;
 }
 
+/*
+ * Call before ublk_fill_io_cmd() publishes @cmd in io->cmd: a control-path
+ * cancel may complete any command found there, and io_uring_cmd_done() only
+ * takes it off the cancelable list if it is marked already. The handlers
+ * hold uring_lock, so marking takes no lock.
+ */
 static inline void ublk_prep_cancel(struct io_uring_cmd *cmd,
 				    unsigned int issue_flags,
 				    struct ublk_queue *ubq, u16 tag)
@@ -3176,6 +3183,8 @@ static inline void ublk_prep_cancel(struct io_uring_cmd *cmd,
 	pdu->ubq = ubq;
 	pdu->tag = tag;
 	io_uring_cmd_mark_cancelable(cmd, issue_flags);
+	/* pairs with the cancel loading cmd from io->cmd, then cmd->flags */
+	smp_wmb();
 }
 
 static void ublk_io_release(void *priv)
@@ -3423,11 +3432,11 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		ret = ublk_check_fetch_buf(ub, addr);
 		if (ret)
 			goto out;
+		/* before ublk_fetch() publishes io->cmd, see ublk_prep_cancel() */
+		ublk_prep_cancel(cmd, issue_flags, ubq, tag);
 		ret = ublk_fetch(cmd, ub, io, addr, q_id);
 		if (ret)
-			goto out;
-
-		ublk_prep_cancel(cmd, issue_flags, ubq, tag);
+			goto out_done;
 		return -EIOCBQUEUED;
 	}
 
@@ -3471,6 +3480,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		if (ret)
 			goto out;
 		io->res = result;
+		ublk_prep_cancel(cmd, issue_flags, ubq, tag);
 		req = ublk_fill_io_cmd(io, cmd);
 		ublk_apply_io_buf(ub, io, cmd, addr, &auto_buf, &buf_idx);
 		if (buf_idx != UBLK_INVALID_BUF_IDX)
@@ -3489,19 +3499,24 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		 * uring_cmd active first and prepare for handling new requeued
 		 * request
 		 */
+		ublk_prep_cancel(cmd, issue_flags, ubq, tag);
 		req = ublk_fill_io_cmd(io, cmd);
 		io->buf.addr = addr;
 		if (likely(ublk_get_data(ubq, io, req))) {
 			__ublk_prep_compl_io_cmd(io, req);
-			return UBLK_IO_RES_OK;
+			ret = UBLK_IO_RES_OK;
+			goto out_done;
 		}
 		break;
 	default:
 		goto out;
 	}
-	ublk_prep_cancel(cmd, issue_flags, ubq, tag);
 	return -EIOCBQUEUED;
 
+ out_done:
+	/* marked cancelable: complete through io_uring_cmd_done() */
+	io_uring_cmd_done(cmd, ret, issue_flags);
+	return -EIOCBQUEUED;
  out:
 	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
 			__func__, cmd_op, tag, ret, io ? io->flags : 0);
-- 
2.53.0



