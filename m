Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058844;
	b=MJtDmLHFEtldgCwdZ9dU7bkXYwa31eJkEAolE81ZTlNIRfFFWoMTlVh1rePm6n8/5jFg
	 dn3C09NMcif7avDgjxNBNg/o+NOfb7yg8AegM3epMvoq1ywoKWTBXkcEPmgiNjw6SosTt
	 uk1G8SPuvCWEc3Zf+DPYLrfChBKy+lxV88ittfkKGpxdBA4aIQT5qYcn4j/F8D5E27SJg
	 OwmUeiSjFCs6fduWp4vRaj+aLxHPVD1OaBR3AmHoM7M80vbH7D7nPwkF0+yKjRNe88efK
	 XILKP92SLhoYf6G4kwuGulyLrc6QkDT1NvkUAwBjpRGCcxIgM8a6cNt8n6lQSTt9R1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EoV4APbT56M2ago8OGXwEWQjs8vrH8oSk2FlZ7Ps4o8=;
	b=VisdeMbVkffGaIkKUlvkFi6Iss60xitzscg//MKFJMIa6u8yxiDfKxH0uAOvNDvZOWlL
	 tLJZutZ1INgsQaJIL2NwJ95J9jA9MNdUtPpWCcx4+UeTxnHgd0suyNCIcArRHWc20yGw5
	 lDSVsc/LmHHUz5f7PWfUPXNeLrmc01fMSrP40Lj9CTXiG3Kdl44kKd2JDLMMC+UCgPMyV
	 4qD4xevht/1nEejbz3QmjYgTkbXRNfUKAXJyTT5OmTg7wHDDrdNXvMXHcm9qQrajIQGZt
	 Ge5aVcTRJonq7hRotdpgZHwA33Kb5y+npc9AFO3c3a5lTOlmSuoLH/TWedtHVQw3Veg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sh4O/EUa";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9951606A338;
	Thu, 19 Nov 2026 03:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sh4O/EUa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DCF1F000C5;
	Thu, 19 Nov 2026 03:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058844;
	bh=EoV4APbT56M2ago8OGXwEWQjs8vrH8oSk2FlZ7Ps4o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sh4O/EUahCFl3PSz8dWwY7F9VWhFOVqOQ8vNDwY2Pxp60YRlpabpty9ePEtfdR6f7
	 kUHx+Hvbls8l2DhrwyFFU6kT7VpEwMP+G09WKw68JIOUknQd4PAvRagCjdQHXAkkcY
	 gORsUDkuVqDwugo9rk5zEDacMIRDA4Y9CeLAksas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+edbebd898142ee5e24ce@syzkaller.appspotmail.com,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0632/1848] NFSD: Complete a cld upcall when the daemon closes the pipe
Date: Wed, 18 Nov 2026 15:44:30 +0100
Message-ID: <20261118145942.115201523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 2a83fcb50f3c25c493cc4389619340fefe9d6ac4 ]

Once nfsdcld has read a whole upcall, rpc_pipe_read() unlinks the
message from every pipe list, so the purges in rpc_pipe_release()
and rpc_close_pipes() no longer reach it. cld_upcall_ops supplies no
.release_pipe callback, and cld_pipe_destroy_msg() returns without
completing the upcall because a downcall is expected to follow. A
daemon that exits between the read and the write therefore strands
its waiter: the nfsd thread sleeps in TASK_UNINTERRUPTIBLE in
__cld_pipe_upcall() and never returns, hung task warnings follow,
and the server cannot be shut down.

Add a .release_pipe that completes every upcall the daemon has
consumed. cu_inflight distinguishes those from upcalls still queued
on the pipe, which the framework purges before it calls this
callback; cld_pipe_downcall() removes an upcall it accepts from
cn_list under the same lock. Neither can be completed twice.

Fail the stranded upcall with -EPIPE rather than the -EAGAIN that
makes cld_pipe_upcall() retry. The daemon consumed the request, so
whether it acted on it before exiting is unknown.

Fixes: f3f8014862d8 ("nfsd: add the infrastructure to handle the cld upcall")
Reported-by: syzbot+edbebd898142ee5e24ce@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-nfs/6a99f6f0.2e567484.299ffc.000c.GAE@google.com/
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901-alemi-v2-7-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 5cedbea8911ec..bdffe807d0404 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -937,10 +937,34 @@ cld_pipe_destroy_msg(struct rpc_pipe_msg *msg)
 	complete(&cup->cu_done);
 }
 
+/*
+ * An upcall the daemon has consumed is off every pipe list, so the
+ * purge in rpc_pipe_release() and rpc_close_pipes() cannot reach it.
+ * Release its waiter here instead; no downcall can arrive now.
+ */
+static void
+cld_release_pipe(struct inode *inode)
+{
+	struct nfsd_net *nn = net_generic(inode->i_sb->s_fs_info, nfsd_net_id);
+	struct cld_net *cn = nn->cld_net;
+	struct cld_upcall *cup;
+
+	spin_lock(&cn->cn_lock);
+	list_for_each_entry(cup, &cn->cn_list, cu_list) {
+		if (!cup->cu_inflight)
+			continue;
+		cup->cu_inflight = false;
+		cup->cu_pipe_msg.errno = -EPIPE;
+		complete(&cup->cu_done);
+	}
+	spin_unlock(&cn->cn_lock);
+}
+
 static const struct rpc_pipe_ops cld_upcall_ops = {
 	.upcall		= rpc_pipe_generic_upcall,
 	.downcall	= cld_pipe_downcall,
 	.destroy_msg	= cld_pipe_destroy_msg,
+	.release_pipe	= cld_release_pipe,
 };
 
 static struct dentry *
-- 
2.53.0



