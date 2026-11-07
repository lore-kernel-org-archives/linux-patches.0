Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061018;
	b=b6bFgs9A7fPEU1+Rbe+bTO7td3Bl7qfzsSq9mi9bGne1+R6s5TouOFyVEE9T+ky0CGtG
	 5MzYcsu0H/gtz5iq5uNUHa8J9TmyYv+1u34UQWyB7WRPaV7tmqn+SHfRd+HkpxrCCWOBa
	 Inc6MbhgaheXT79OzOe+LTKRdmYcRgd2qRV4p6B2/cuyiZSDI/VzSMFdJK2VQu6OF46O/
	 FGpr2lco7BYp9n3E3ThmioFjLNsuLb2/zN9WTJ2JTriRoK5apo5kRxi2a48AqdX9nibej
	 v39n6xohHxh+zrDSbslvf2V5TssvRlx4pWHrs5F1HqZT1Zegs0jhbOMwNtHW34kUzhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NIsCPGhjwmM6CvMMZQI3rooMdn64C5taUV03JFSqvO4=;
	b=YJxx5GFa536g8xR2O5h9gEvBwXj4QzcJyKtWEruUcvjr3d39A0G73czvQ8AUYP9Ia812
	 6QTm6Fs5+5GAImeSZNKaQMiWRUYf2hDiyAPDigUToQsLV0MWY5iwp6p3E9Z8GjrzQfq7M
	 2FBXnL5FZNXBZbqBVlopOazbBjP1qroz/TUO8aGXa9WSRSrAN0eS3qMiQKJH7QU5yrSjq
	 zB37I7M++9ac4rrMqZqUhtSS4NJzeRScI8EjxD2eziSGjfkXahI6jLTW2R36vlfdxhJ6l
	 ewIaye8LQPPvUkC4yw0m516gdQq3TFlKCeyg286JZnDyMWnm6jOovZa+gJBPDOn9FDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sLyWTrD1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC719606D802;
	Sat,  7 Nov 2026 14:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sLyWTrD1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4769C1F0089F;
	Sat,  7 Nov 2026 14:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061017;
	bh=NIsCPGhjwmM6CvMMZQI3rooMdn64C5taUV03JFSqvO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLyWTrD12W65rdTdYfbfGc/ft4UxU5QbnljJtF3jt+zdQI5vHF2cjUpzlUEBz034s
	 KFIDd23Du3bAnq66Wz7AIenkfCdIMRs6q0f4dEwbWcMvfh11RYyA+67TZU+LWieUu1
	 ZJKLrhRHXmHIPkklplfrMs9FliElg7MPRRttL8a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0357/1536] ksmbd: notify parent directory leases on child create
Date: Sat,  7 Nov 2026 08:39:33 -0500
Message-ID: <20261107135007.687051019@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 06f1c82ba42d2..51436cc50c790 100644
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



