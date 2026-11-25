Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619062;
	b=5FhNBz0XgbywCJJmME0YYPXh7o/tq8NZvwoeRN83Ohy08dZRmFwudwu/6itXA3QmXrfi
	 Ks79flSSmek3mlxyYt+PCmgpwb8TSNSgHwPmrq31B69a9rTThcQcCnkLSzGE0AMgNXYav
	 rGqI9bdFHmeiS42kOQBCFW3n++7GEfmURDSDq2zm8eW2RGJ5D4VCDsjEdVyaj3vxB93Rj
	 8eFcwtWBVZPzHmTg91ZDB7abxZWN0Jz4bSE/PKHbn/v6UAiLSyWcLQk3kBppdARqd/sVd
	 cOQTt0t0qFKPtJ/bPNrmf8mcts1CCUJGxf9bOl6y8cRq1Hlqha6eNDgAR9/ZHBqvyWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nQQLRak6nNFliN+eTFka5Yh8bB47bdU4FRhqMF67ttw=;
	b=znHQekUgPPCTAoxsdIbCmdVjYfyJ/q8tMMzGtlpnsGMB67MkoY+/ubkDQgZ51h+vQ2IR
	 UUnXrYHV62BBXszyqvb+OqcjaLOGn/btyou6Y1OvN7h0Fyo7Z9sRhJXNrXR4npoGM5nqd
	 WmNfWKa0Joj5Qx/hsEfglasogdyhTc6eMMsI9srSLbxc91/FPCO7XjqFUAfNLxzWqhbV0
	 KsgWaMcVVDf9gjpUDp143oSk+KNZ7/S4w2WDLNSQMlguzg4mxo3wD/IvMVd8HZJ/JGhZf
	 ujHhQzAjPx0SAOx5f5T6Vnx5V33WrRLNQ62kq8C/wCE0TbMeylSd1uEjYGM6c/W2tqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1vs2LYbp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0771606A31E;
	Wed, 25 Nov 2026 15:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1vs2LYbp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16ED1F000C0;
	Wed, 25 Nov 2026 15:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619062;
	bh=nQQLRak6nNFliN+eTFka5Yh8bB47bdU4FRhqMF67ttw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1vs2LYbpJlHN9t1SCRwet8xzrNh36Fhp2W4ZA9bcph83CMG3BNl2r6tcDiNzcVgX1
	 JnDxLGsxwFuuevJus3xGB91Y/UBEVT+uH+7CQ8NNAnZb/0OVi2orDvOeTFCeZf/5sE
	 eiXXgapKK7P1NOeZQJaQJQB4FeHscmd/wbvOlDzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0477/1005] NFSv4: remember that the server may send CB_NOTIFY_LOCK
Date: Wed, 25 Nov 2026 15:30:15 +0100
Message-ID: <20261125143832.919815665@linuxfoundation.org>
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

[ Upstream commit 4fdc29eb6730207b4a6f63f81575c7aa5c2a4ff1 ]

Two processes contending for a POSIX lock on one file see occasional
acquisitions of almost exactly 1, 3 or 7 seconds when the client holds a
delegation, although the holder releases within microseconds.

nfs4_retry_setlk() only parks a waiter on clp->cl_lock_waitq when
NFS_STATE_MAY_NOTIFY_LOCK is set. Otherwise it uses
nfs4_retry_setlk_simple(), which has no waitqueue at all and sleeps on a
bare timeout starting at NFS4_LOCK_MINTIMEOUT and doubling, so a waiter
that loses one poll waits a second, then two, then four.

NFS_STATE_MAY_NOTIFY_LOCK is set in _nfs4_open_and_get_state() from the
OPEN reply rflags. It describes the server, but is recorded per
nfs4_state and can only be learned from a reply. Once a delegation is
held, further opens are satisfied from it with no OPEN on the wire, so
o_res.rflags is zero and the new state starts out believing no callback
can arrive, even though the open that obtained the delegation was told
otherwise.

Record the capability on the nfs_client the first time an OPEN reply
carries it, and apply it to every state built for that client.
nfs_client is the right scope: the flag describes one server,
CB_NOTIFY_LOCK arrives on that client's backchannel, and cl_lock_waitq
is per nfs_client.

This also covers a case the per-state flag misses. After the delegation
is recalled the state has neither NFS_DELEGATED_STATE nor
NFS_STATE_MAY_NOTIFY_LOCK, so locks go to the server and the server does
send CB_NOTIFY_LOCK, but the client is in the backoff loop and ignores
it.

Fixes: a8ce377a5db8 ("nfs: track whether server sets MAY_NOTIFY_LOCK flag")
Assisted-by: Claude Opus 5
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c         | 2 ++
 include/linux/nfs_fs_sb.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index ebc431906a453..78cae03d33289 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3093,6 +3093,8 @@ static int _nfs4_open_and_get_state(struct nfs4_opendata *opendata,
 	if (server->caps & NFS_CAP_POSIX_LOCK)
 		set_bit(NFS_STATE_POSIX_LOCKS, &state->flags);
 	if (opendata->o_res.rflags & NFS4_OPEN_RESULT_MAY_NOTIFY_LOCK)
+		server->nfs_client->cl_may_notify_lock = true;
+	if (server->nfs_client->cl_may_notify_lock)
 		set_bit(NFS_STATE_MAY_NOTIFY_LOCK, &state->flags);
 	if (opendata->o_res.rflags & NFS4_OPEN_RESULT_PRESERVE_UNLINKED)
 		set_bit(NFS_INO_PRESERVE_UNLINKED, &NFS_I(state->inode)->flags);
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 34d294774f8ce..5f9415d7059e3 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -116,6 +116,7 @@ struct nfs_client {
 #define NFS_SP4_MACH_CRED_COMMIT   6	/* COMMIT */
 #define NFS_SP4_MACH_CRED_PNFS_CLEANUP  7 /* LAYOUTRETURN */
 	wait_queue_head_t	cl_lock_waitq;
+	bool			cl_may_notify_lock;
 #endif /* CONFIG_NFS_V4 */
 
 	/* Our own IP address, as a null-terminated string.
-- 
2.53.0



