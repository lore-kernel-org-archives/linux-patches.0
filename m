Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034242;
	b=p8C1DaV7/UIAfbABpMCZ8JCTsT+Gt4+otu1LdFICMzozOog5tQwHNiMG67uB5xrfbjvn
	 6hBRassV2xMsbgnXp6udzCkT87+2qttPBtoLbksRw2FLrhOxKKUmUOq7TvZUG+grtcKIn
	 Q1QKW6ibKMxXln+JgUWvheFxY3KuVBaVwbEYG2D2dg9wRwggb3BcFkguFFi6Ko9jkIWjG
	 9OA/nWfwNQrXdQcdi1jSVTpmTQ6cbpRmBhI10hMGz+vexigpStCsFQOGKe4oV5slCwAfM
	 oAt11ekY1Kp+T+LMZlA2oo1yUS1izParq59DRPyDhW+12yf3BeTeh5BPsbhcTCuNJvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=33uqiytvqrkETRNNv1rSexIVTH8A5dwNgPbrYt5zP94=;
	b=jY8givzdVDCxJ9FNAowGpyZhNSSLGdshMSHFpFcEQt2GSkVvezIjpCGqseVcKsOVWxfp
	 WuSvClCopmG6zo/oY3a2S5nz7vmWk2yJCGWP7se8RtM7PbXRKyXjzZ0tny4GzaZtKsqtJ
	 ZG5le+KU9xNiqgOSbypsizByPh2Dhw8vu3avNEMvuy2ZHezIiYC41ZWPM/hQ459kwzsII
	 GZnjKxo33n3lEaWOy3jDQ2Uemgv5JS4pUZoAjzY9nnI7sjJL2GaQKR6uh+YGdkMqkfo1z
	 hytjJV2qLCurT/gIM1kpA6p/AaKfTJipVQE2IDsvh9roT1QyPL343VHiQ3/490Ed3Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CApOAQ3/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BD0606A33B;
	Wed, 18 Nov 2026 20:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CApOAQ3/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713A61F000C4;
	Wed, 18 Nov 2026 20:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034242;
	bh=33uqiytvqrkETRNNv1rSexIVTH8A5dwNgPbrYt5zP94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CApOAQ3/7OU0XkqFuKzL6krwAST4rwYCu05qmvoVM+G3K5orl0FmhRRNn3B2OnEjW
	 h60MWYg85/11+JWhzGQvViy7ZYdnO5I2PY3sjC/Y3dqRB5105wl1Fj2J8uPLu0ot/H
	 Q0lthGnpXp1Bv4KapRxL25W2T/IQMYdS3sr0o2no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0301/3318] ksmbd: notify parent directory leases on child create
Date: Wed, 18 Nov 2026 15:15:23 +0100
Message-ID: <20261118150324.744923405@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7d85b9e338ec2..779d0f01f20fd 100644
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
index 6cfc253f902bd..5715696ecdcfc 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3538,6 +3538,9 @@ int smb2_open(struct ksmbd_work *work)
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



