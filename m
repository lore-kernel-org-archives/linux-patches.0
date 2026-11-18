Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051460;
	b=NWiUTXM7AZjgCsV4WQNwNgJFBmU0BnsR6AlmcCJGis1DnE5gRc9of4OiIgolCLFb4+tm
	 3TDGNJ+uE1RuFMHNtr6u1287dPMEhOCee8FUOXG0bk9n9NsOv3eODKpm5T8Wkg1QLDiqO
	 UCgLAz/5tbyYP/eINk6OFJRg7+XsVoBrKS/tiXZgGRzXGWPXv4SBntEckXRP7qurIctM9
	 IDCrjATadt1raXiPle369euILkbsSQohsxPgdP6G80hUplzRH7VmpMTY1Dd2wGQf2nTuI
	 fyK+D4cXOEnxBFvQO87VEeWfJ+kCMdJPmDlmo1/FF3AwvThEpLfvWTWydttrBMDISEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yaBANbFDHMEMt4myeTSSloyxYZ8EOzbUUMUcmRLUwUk=;
	b=NqKn0qi98rJaqAjH4lz90qBvQ0/x1ttn2L5i5ORaIGRwmzapN6xYFxCX3hfF2TeFnkoU
	 /T8LeKgBx5UVhSzKmssXf5KCAy4eSXjqv+nXojyvwh3cZT9vuEaXV5VOT3Elwo5Bu37jJ
	 frUF6U1OJqVzNKuLEiqlTQv4yHa8QCg+DNl6FDWV82xs8EU/Y8HOyozoMkkTjE31e8bEX
	 nY4u/VjTu/0wyqJZmx6hsXNhSjng//hyWp5y+3khtuWLLzO+BrSqeehTUJl9Pzq36WDzx
	 r+U8oQLWa4dTsJT7U6lDSqIdE/9Z0j26wNmv09kWDU1WnMku40EwPhoU+HJIFBmRxUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="X3/3kzk2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A75606A31C;
	Thu, 19 Nov 2026 01:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X3/3kzk2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F351F000C5;
	Thu, 19 Nov 2026 01:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051460;
	bh=yaBANbFDHMEMt4myeTSSloyxYZ8EOzbUUMUcmRLUwUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X3/3kzk2oz5JKThyCSJ3KNCV/fasbd592kDV/bH/zY5Rj682vEfBEczgg4m8m57IK
	 tQKrGxgzadxcelgpoxstacypMEdrdu8CoxukWg0BjbLaWygKJ71V71QqWd0vqU0yby
	 Qf4dpTl4Cvbqc2ARCDIJVmFH87rUZMpCzD/rfZ8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0217/2214] ksmbd: notify parent directory leases on child create
Date: Wed, 18 Nov 2026 15:31:33 +0100
Message-ID: <20261118150018.851903794@linuxfoundation.org>
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
 fs/ksmbd/oplock.c  | 9 +++++----
 fs/ksmbd/smb2pdu.c | 3 +++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index e938921d20085..be8f8c94cfc2d 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1105,7 +1105,7 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 	struct oplock_info *opinfo;
 	struct ksmbd_inode *p_ci = NULL;
 
-	if (lctx->version != 2)
+	if (lctx && lctx->version != 2)
 		return;
 
 	p_ci = ksmbd_inode_lookup_lock(fp->filp->f_path.dentry->d_parent);
@@ -1118,9 +1118,10 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
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
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index e54a18b6d4eb5..4c42205fe5261 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3284,6 +3284,9 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 		}
 	} else {
+		if (created && !lc)
+			smb_send_parent_lease_break_noti(fp, NULL);
+
 		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE && lc) {
 			/*
 			 * Compare parent lease using parent key. If there is no
-- 
2.53.0



