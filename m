Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590713;
	b=Ri8Rq+xCLtAL9yiFzzOEVHkk57Pvd2zVxjPAA0gb9pK6NuaLKVohPXsT+D4x4vuVB7dT
	 TUp6+URzfOEHWLGOx73WzAUTp9ZjLc6l56jbKun9BIOrTvGnc9pd9c/6SeQbaOCz5h5yw
	 2Zv/h11ZyC6j2F7TH4YBJcZXxwkaC/AA1geOvYHjm3oUG4pXR13LjjynTaTtayA7isTUQ
	 dTjCNY3O86mFxQ5dPRbchdgk7iwKjDNjNn7p2HXbsbj4she9uRoPIgBjNMCNIJyVTybKk
	 zphqLprsU/YvMeCL22DAOssbwqBYyzKSKHk0tw8Q+1fj7tnLykI/uUZAmUj0u/8gjEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Xn/4NpSv2rhBdB6cknsCbxshC3ldJ0WwshdUM+LmdIU=;
	b=uHRcVzdbTE0psU/KL8g5oUtbsi2IgC6Wn21hBXwyqDChjjyCKRkOfruWz0Atd1X2s13X
	 M3z2cmoYbTRjlCos9gXt5pM2Sv8Lghr0zIvocstQFYG/Xy93rSDLXbZc//+cnAFnGtLOt
	 djMZXxrzush0VCFqLpo8SxeJlSNKW0Kk6RI7O8uxalFC4eCbwHCSO1Y0pOyi6k9vxiWDd
	 93W+hg+WfXvgFNMd/DyIk3onnY9Tup0D5NUb4XPhvq/YIXEMZX1+bB3aP0QzQjj9UaLUe
	 xYR6qiAg9JXY9/rW4keXn6tQI0NlgRv3H3Ily7IV2ELiCO0XHFmB4NYI8tg2kI3eMAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="z/3PhclF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8580B607A5C9;
	Fri, 13 Nov 2026 17:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z/3PhclF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302791F000C4;
	Fri, 13 Nov 2026 17:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590713;
	bh=Xn/4NpSv2rhBdB6cknsCbxshC3ldJ0WwshdUM+LmdIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z/3PhclFmgvAcqkBN99dxeckM577v1v/VDXV0O5YiER1L/xgDAVF62WWEkClq/rf4
	 ru0d+lYG0c/2TTrqoU7jbOmfWNc6G/4NtyRiHeICJfMDSzuyJ19aqDbzawFjEjU7Ji
	 6aB2/jScw36n01BB0c7X2xSzwx1wuGJAqtq2rsns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 621/686] ublk: mark the io command cancelable before publishing it
Date: Fri, 13 Nov 2026 10:52:34 -0500
Message-ID: <20261113153842.906716231@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: passed READ_ONCE(io->cmd) directly to io_uring_cmd_done() instead of storing it in a local variable ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index c0e4f94cc43b0..197825f44b1d0 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2003,8 +2003,10 @@ static void ublk_cancel_cmd(struct ublk_queue *ubq, unsigned tag,
 		io->flags |= UBLK_IO_FLAG_CANCELED;
 	spin_unlock(&ubq->cancel_lock);
 
+	/* dependency ordered against smp_wmb() in ublk_prep_cancel() */
 	if (!done)
-		io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, issue_flags);
+		io_uring_cmd_done(READ_ONCE(io->cmd), UBLK_IO_RES_ABORT,
+				  issue_flags);
 }
 
 /*
@@ -2274,6 +2276,12 @@ ublk_fill_io_cmd(struct ublk_io *io, struct io_uring_cmd *cmd)
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
 				    struct ublk_queue *ubq, unsigned int tag)
@@ -2287,6 +2295,8 @@ static inline void ublk_prep_cancel(struct io_uring_cmd *cmd,
 	pdu->ubq = ubq;
 	pdu->tag = tag;
 	io_uring_cmd_mark_cancelable(cmd, issue_flags);
+	/* pairs with the cancel loading cmd from io->cmd, then cmd->flags */
+	smp_wmb();
 }
 
 static void ublk_io_release(void *priv)
@@ -2527,11 +2537,11 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		ret = ublk_check_fetch_buf(ub, addr);
 		if (ret)
 			goto out;
+		/* before ublk_fetch() publishes io->cmd, see ublk_prep_cancel() */
+		ublk_prep_cancel(cmd, issue_flags, ubq, tag);
 		ret = ublk_fetch(cmd, ub, ubq, io, addr);
 		if (ret)
-			goto out;
-
-		ublk_prep_cancel(cmd, issue_flags, ubq, tag);
+			goto out_done;
 		return -EIOCBQUEUED;
 	}
 
@@ -2575,6 +2585,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		if (ret)
 			goto out;
 		io->res = result;
+		ublk_prep_cancel(cmd, issue_flags, ubq, tag);
 		req = ublk_fill_io_cmd(io, cmd);
 		ublk_apply_io_buf(ub, io, cmd, addr, &auto_buf, &buf_idx);
 		if (buf_idx != UBLK_INVALID_BUF_IDX)
@@ -2594,19 +2605,24 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
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



