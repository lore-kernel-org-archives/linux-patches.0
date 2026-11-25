Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619060;
	b=2ybE6XJWBBH5lSghfNhJlCIY3N8K7xcC+QZDDbUXzOpYGdDjbAT66+0Djmq3QM9+6Idc
	 +Dg+Q6F7KZKPUBTUJLapvbNe76LvOOdOwkUht9zgJbq9RhK/gED+q+ldvaChWlG32q7jp
	 Fb3zzk2v6DsacuPiUXO+MTNCwmxBIf+2bmET5xTPFzgX4hLpD+4gugHFnbxdCPviwXFB3
	 UCPDugH/QUtFatPW05f5G/djzsc/aPJ5WTH4BvwYHNHIhE9UFHlVLiDcpDXUQ563anqHh
	 JbVE720ze2+N1oLjfkigKC1SomjaaqzfT0WhGhsaBLGkRzySChJMgy6VMy4SbYYY/kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qGnIbBSbAH3aVZ5z1oTRspOCO5/ab/8DMjVxjiJhrfc=;
	b=18M4bS8F3ZyrncHJWPEJrcDu8TVVLVBb9rgwN7cn4IRrxXgHaWEKcVjfBSyMv0jvCQN7
	 LVGcnsofrPYzDwK1HfRT/CYZQ+rO9Xq4Hsd3nLUSrbDs7zFBJ2JSVl36mbuloP5HAil37
	 APQONTjpqvNvYpPYcmZW4EOesd74yuVUyFL5Tg/k0Kcy55fS+gfWTOZ2Nx6X2WFG5Y9l8
	 dar0zf8YrQop94WyjgiaqVX+KGNc6D1rUfA67PuO5NYBQ3SQXxuvywvztsKmde7PRB0aO
	 pw0mdujY7wBLLefsKB5Ww0xCRjIm9OTV0Er9eAQMeGw5t/KmbtUJCicyUq+4tffleTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UucEKct3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0569C606A31E;
	Wed, 25 Nov 2026 15:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UucEKct3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE741F000C0;
	Wed, 25 Nov 2026 15:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619059;
	bh=qGnIbBSbAH3aVZ5z1oTRspOCO5/ab/8DMjVxjiJhrfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UucEKct3FSQ1Hwf//ixW+bb93ZIrlrxh3i9diac6jfSulyWjwwUWg7QxtzuT9hVKU
	 IZya2QGb38cOvg0BI5Esu4gCXJEgj6wpRD574l5ZoAROh6IBsi8gWRrx1JVex1Rvr6
	 FEHO25+go0BT1aRN9ov+JslIQBkSKTwq6BIVMJ+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0476/1005] NFSv4: wake blocking lock waiters when a delegated lock is released
Date: Wed, 25 Nov 2026 15:30:14 +0100
Message-ID: <20261125143832.896400553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit e8433473eca284bc561373d0a0fff632f76aa594 ]

When the client holds a delegation, _nfs4_proc_setlk() caches POSIX
locks locally and never sends a LOCK to the server. It has to strip
FL_SLEEP to do so, since that branch runs holding
sp->so_delegreturn_mutex and nfsi->rwsem and F_SETLKW can block
indefinitely. A contending waiter is therefore never placed on the VFS
blocked-lock list, and locks_wake_up_blocks() does not reach it when the
holder releases.

The waiter blocks in nfs4_retry_setlk() on clp->cl_lock_waitq instead,
whose only waker is nfs4_callback_notify_lock(). The server never saw a
LOCK for a cached lock, so it does not know anyone is waiting and will
never send a CB_NOTIFY_LOCK; nfs4_proc_unlck() returns early without
sending LOCKU for the same reason. The waiter sleeps out the full
NFS4_LOCK_MAXTIMEOUT of 30s before retrying a lock that is long free.

Wake cl_lock_waitq when releasing a cached lock. The releasing thread
cannot tell which waiter wants the lock, so the wakeup names only the
inode; make the owner comparison in nfs4_wake_lock_waiter() conditional
on cbnl_valid so that a CB_NOTIFY_LOCK still wakes exactly the owner it
names. The inode restriction matters: without it every blocked locker
for the server is woken, and those on non-delegated state each retry
with a LOCK RPC.

Fixes: a1d617d8f134 ("nfs: allow blocking locks to be awoken by lock callbacks")
Assisted-by: Claude Opus 5
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 028459fb6edbf..ebc431906a453 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7287,8 +7287,15 @@ static int nfs4_proc_unlck(struct nfs4_state *state, int cmd, struct file_lock *
 	if (status != 0)
 		goto out;
 	/* Is this a delegated lock? */
-	if (test_bit(NFS_LOCK_INITIALIZED, &lsp->ls_flags) == 0)
+	if (test_bit(NFS_LOCK_INITIALIZED, &lsp->ls_flags) == 0) {
+		struct nfs_client *clp = NFS_SERVER(inode)->nfs_client;
+		struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
+
+		/* The server never saw it, so it will not notify waiters */
+		nfs_copy_fh(&cbnl.cbnl_fh, NFS_FH(inode));
+		__wake_up(&clp->cl_lock_waitq, TASK_NORMAL, 0, &cbnl);
 		goto out;
+	}
 	alloc_seqid = NFS_SERVER(inode)->nfs_client->cl_mvops->alloc_seqid;
 	seqid = alloc_seqid(&lsp->ls_seqid, GFP_KERNEL);
 	status = -ENOMEM;
@@ -7708,8 +7715,14 @@ nfs4_wake_lock_waiter(wait_queue_entry_t *wait, unsigned int mode, int flags, vo
 		struct nfs_lowner		*lowner = &cbnl->cbnl_owner,
 						*wowner = &waiter->owner;
 
-		/* Only wake if the callback was for the same owner. */
-		if (lowner->id != wowner->id || lowner->s_dev != wowner->s_dev)
+		/*
+		 * Only wake the owner a CB_NOTIFY_LOCK names. A lock cached
+		 * under a delegation is released locally, and the releasing
+		 * thread cannot tell which waiter wants it, so those wakeups
+		 * (cbnl_valid false) name only the inode and wake them all.
+		 */
+		if (cbnl->cbnl_valid &&
+		    (lowner->id != wowner->id || lowner->s_dev != wowner->s_dev))
 			return 0;
 
 		/* Make sure it's for the right inode */
-- 
2.53.0



