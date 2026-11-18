Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053065;
	b=vR025vz2M1ZkLoRjC98Yl1h7VkcXyz/aVhidOIgtx03meS7n/xT9izEWWCAxiXnMZsoT
	 W2PjSP0ES4nFITeHBZeL7ZUkGH6glPN0cECLOtbYUeBNxf+ToqWK74wnsaYYzXlDRM9zV
	 /Hm08U9vGeCrVIXNW6Oy2ph3n9z1df+OkzYCiFlJhh+QalY7hg6z4wKpcUNqQCwLqOs6u
	 6pPMfX7S39Y9+29BV0igxYpSUMktwVdCA0ruaItnKu8A7d5UcyIaxnCPPOG5Q8/ySwsxG
	 6SOEtiObagWQfXUuZsLNZU22nBsBJmSGqSUvcO+mJmsh4xTGW9BVQMplEAl/LmCpgnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RTdxHAixahd9cKT+8xXOmMAx5F4ZcSZOv4uzZ4yZ0SA=;
	b=F1bxIxBIN4QlVHu2ZFNUep0NyckapVAuI+VXJ1bCbXKbOR+uv7pfNrLR+8ggwCbx91ry
	 dScqVnMqwI/JB7poWWEvJDVRhrdwHRkzAkUznEvwYtPxjV/mlsp5azkKAqQ3hbwbWiupF
	 vtf1WAlXJNtvSc9dcW3/Ll3lVVfqPS5d+5f7bk00INea+dFU2+SfW+f5YK89u44FlY8xK
	 CbEX2NzKFEO1kyyZKYQ3koFvv1ypvus+EAeRZ9XfYqZmbP6uJ4lFYlf46eMwVKyxK4IV7
	 Y/I7FFuTfIBma1jXIkCY24vfg3ahxuWfxPw95miapP+pTA2L1ql2Ts/H7lhodg88BwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ezAkouOj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939E2606A320;
	Thu, 19 Nov 2026 01:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ezAkouOj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9ACB1F000C4;
	Thu, 19 Nov 2026 01:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053065;
	bh=RTdxHAixahd9cKT+8xXOmMAx5F4ZcSZOv4uzZ4yZ0SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezAkouOjzATsYei+a5+81tCZgNYWweZaxW35dFd1vNmze+DWWoJ/L+3UBLxwEjpv9
	 nEgWgvYU5jVo0XBxgnKQSa3Yb32+py6QMiZG2tDd5veC/GB2y7DVdsKdJRJf4TGM6R
	 uZw81cpJEPPRy/na21XxywODjwJTukwvowQQrzyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+edbebd898142ee5e24ce@syzkaller.appspotmail.com,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0784/2214] NFSD: Complete a cld upcall when the daemon closes the pipe
Date: Wed, 18 Nov 2026 15:41:00 +0100
Message-ID: <20261118150042.968788776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index abbde09d25f35..0b3b23ae7820e 100644
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



