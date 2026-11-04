Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830987;
	b=K7+07f+sXCPgtzJWZwkX7YQBy5UMXr3t3lApQF3l9s/WO9CPj0M26phVxJpzUyvk+uOZ
	 3BMN3pFue36t4EqN7xxWTLVQzLY4BnEZGz8Ve9NjduvElFgYRfCJDCmRUnAxlxyxZHM+4
	 wFKSPw7lGf3nS7Cqr+4mWsZ4Y8/bG8ysMEO6RU5l8Yw03rr/G6vPMgtcQkDZ3zXWIfRLl
	 7f4uwkS/vkYLTutQ8jr3+D2OQtaelMC4OoSo5f0EQpDU+ALHYoseCShlDvH5TRmA0ci2+
	 fWt1cqFTlsxdG+KvDl4ke0SAe0LUO8MG5KfK2pePBpmwaajBJugWW1YT6JXPNqEwQrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ak5M14p8xTGfRVNzy1O5MC1PfMAbR4RTXJQMTeytH8U=;
	b=o4Wi6/Ah4tNpqpoMp0YoJ9gdr4d9OvvPQCV6bS1mtCqjobjhim5j248GWnjQfClmYP0x
	 0dEnFAapVZngEyMxiMykbLvJsJXAu5DoU9chin2EjqwpcchxYTpH59KpvA3VJcZ6TdF9G
	 1YiWCnrrfQlJrjT0W9CnGmcCkt8K1YpTsuZR8wiV/3V4tbd7NCMCq+J/GHyPnm6PADMnz
	 NGItSol/q6qMRayjS6x0fL6oyOlH0TK4wfZKchzPZkS5EJMu4vrtg2GZjaXzr7fFTZzoE
	 yl853nVmsrH1NB58WYnbOfWBXAGTpFwEZuzUW0lqmW8msY/mCqwwa2JgHqEnwcoTq6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nojsuf2s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE9E606AB19;
	Wed,  4 Nov 2026 22:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nojsuf2s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430B81F000C1;
	Wed,  4 Nov 2026 22:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830986;
	bh=Ak5M14p8xTGfRVNzy1O5MC1PfMAbR4RTXJQMTeytH8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nojsuf2s9fgU+xbrx/SkszXTgYOkFMfP6uCGcMArQ3FruHhlgyMBVZDIq0UgFGCVt
	 nuAmBLVPovGg+VzoiItISZyyaHV4NHq0NeYIwQpZAGfj6HHYoivrDXMFreGZeqYR6C
	 hvNPkHz7VsIYzfQGf/mtgbYuRB/GobOE5MsR9xRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0423/1005] ksmbd: notify parent directory leases on child create
Date: Wed,  4 Nov 2026 16:02:36 -0500
Message-ID: <20261104211055.948574351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit abe5acb34282206c2a6303d0e09b3165b1addf0e ]

BVT_DirectoryLeasing_ReadWriteHandleCaching requires a parent directory
lease break notification when another client creates a child in the
leased directory. A child CREATE without a lease context did not notify
the parent lease holders because the notification path expected a
non-NULL lease context.

Allow the parent lease notification helper to handle a NULL child lease
context and notify matching parent leases. Invoke it after a child is
created without a lease context while preserving the existing lease-key
filtering for requests that provide one.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c  | 9 +++++----
 fs/smb/server/smb2pdu.c | 3 +++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 08e3e4504b03f..7d78d4ae43acb 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1271,7 +1271,7 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 	struct ksmbd_inode *p_ci = NULL;
 	LIST_HEAD(brk_list);
 
-	if (lctx->version != 2)
+	if (lctx && lctx->version != 2)
 		return;
 
 	p_ci = ksmbd_inode_lookup_lock(fp->filp->f_path.dentry->d_parent);
@@ -1284,9 +1284,10 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 			continue;
 
 		if (opinfo->o_lease->state != SMB2_OPLOCK_LEVEL_NONE &&
-		    (!(lctx->flags & SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE) ||
-		     !compare_guid_key(opinfo, fp->conn->ClientGUID,
-				      lctx->parent_lease_key))) {
+		    (!lctx ||
+		     (!(lctx->flags & SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE) ||
+		      !compare_guid_key(opinfo, fp->conn->ClientGUID,
+			       lctx->parent_lease_key)))) {
 			if (!atomic_inc_not_zero(&opinfo->refcount))
 				continue;
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 61f16f54a810b..7a9eac676cbb9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3565,6 +3565,9 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 		}
 	} else {
+		if (created && !lc)
+			smb_send_parent_lease_break_noti(fp, NULL);
+
 		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE && lc) {
 			if (S_ISDIR(file_inode(filp)->i_mode)) {
 				lc->req_state &= ~SMB2_LEASE_WRITE_CACHING_LE;
-- 
2.53.0



