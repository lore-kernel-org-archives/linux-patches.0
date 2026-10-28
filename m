Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212321;
	b=prClwiYmj6mu+Sf4fCa4DUDqJZy8lZ8+70m2iEog3JYY+wxnyZBXrN4OOJflXBSj213m
	 PeasVkfeugecUXozbN83MviiM339hjK5HAxnyuT9Xu+79iBeCi/kAnJj/N5c69IZWi04z
	 OKf0IYSR4AQavihCn14gFPD9DNaBYlutpV5SsIO1z5THFmLaWFJvBSyGyA+5B0Mls6Xda
	 onxBlEwO9r+UmjQuIcZQUITTq6Wq0rHaIyOhd7j4+vty5PUXvdNrjro6FAQXibhH+keEn
	 Sp43nvSbbU+6w7o5czENn9yytBX1P70oXRE97zXJWZHNOO0Dcrb3pZl1V3mjjIW6+iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hhjBKpRSs1C1g5b1Z+/+DIjbVvNcWWEJez/KmMesiH8=;
	b=hRF5bR1xwNVI+KUJZTNvqFOfIOcU0HiCCft/DF4LDpBG0aKbx1mparfASe8ox4YFnwys
	 ncaDfuUckXdybiEt84auc4O3ZnqRaWsKMq3QMy5eiUTP5RVpxL1IBcy/8/g1j9IlC75hg
	 YzB76CDPZsDGhpLXbxbMFp8Fhb/04vBr65OUZG4OfFrFKWOaRQPowjFUg/VNbpLI0YqX4
	 0g0cOqzMIIYbk7QbQSFc+5P37Lh8wxDq4wGAkDjZQ+JXRgsFSCSHxNKHZYrnHuvPrY/8y
	 tGfdwP2F+BTaWntQrnt856aSslsFMqUAQbByywZbBw13y9VVe4OGFmwWYBnX5nHPLAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tx5Nqcv9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F360F606A32A;
	Wed, 28 Oct 2026 18:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tx5Nqcv9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBA11F01828;
	Wed, 28 Oct 2026 18:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212320;
	bh=hhjBKpRSs1C1g5b1Z+/+DIjbVvNcWWEJez/KmMesiH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tx5Nqcv96JGkR9at/dQnJJqo4iHXgzcKumP5poWlvQgqg4bppgS4j0xOPQzy+GpM9
	 E2UWwlJQObUfFOytNiKomnVpxdl2GTh2/2aR5LS3Dokusle+2bEBOZrV4/IeBSKhd0
	 7BJEYb6KwAehDulVdQGBDQc/BT+114GAfulHfGFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0069/1887] nfsd: gate nfs2 setacl by argp->mask
Date: Wed, 28 Oct 2026 17:36:05 +0100
Message-ID: <20261028170500.803225065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit a3a7e20ed66d3f04d37883c398da8a113b430769 ]

The NFSACL v2 SETACL path shares the decoder convention used by its
v3 sibling: nfsaclsvc_decode_setaclargs() fills in argp->acl_access
only when NFS_ACL is set in the request mask and argp->acl_default
only when NFS_DFACL is set, leaving the other pointer NULL because
the argument buffer is zeroed up to pc_argzero before decode.

nfsacld_proc_setacl() then hands both pointers to set_posix_acl()
unconditionally. set_posix_acl(idmap, dentry, type, NULL) is the VFS
"remove this ACL type" operation, so an omitted arm is
indistinguishable from an explicit request to delete that ACL. A
SETACL carrying only NFS_ACL silently strips the directory's default
ACL; mask=0 strips both.

This is the same defect just fixed in nfsd3_proc_setacl(); apply the
same remedy. Gate each set_posix_acl() call on its mask bit and
initialize error to 0 so that a request with neither bit set leaves
the on-disk ACLs untouched and returns success. The out_drop_lock
path and the unconditional posix_acl_release() in
nfsaclsvc_release_setacl() already tolerate the skipped arms.

Fixes: a257cdd0e217 ("[PATCH] NFSD: Add server support for NFSv3 ACLs.")
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ retained the older user-namespace and inode set_posix_acl() API in place of the newer mount-idmap and dentry API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index f8b91aacd8174..cd6de7aca989f 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -115,14 +115,19 @@ static __be32 nfsacld_proc_setacl(struct svc_rqst *rqstp)
 
 	inode_lock(inode);
 
-	error = set_posix_acl(&init_user_ns, inode, ACL_TYPE_ACCESS,
-			      argp->acl_access);
-	if (error)
-		goto out_drop_lock;
-	error = set_posix_acl(&init_user_ns, inode, ACL_TYPE_DEFAULT,
-			      argp->acl_default);
-	if (error)
-		goto out_drop_lock;
+	error = 0;
+	if (argp->mask & NFS_ACL) {
+		error = set_posix_acl(&init_user_ns, inode, ACL_TYPE_ACCESS,
+				      argp->acl_access);
+		if (error)
+			goto out_drop_lock;
+	}
+	if (argp->mask & NFS_DFACL) {
+		error = set_posix_acl(&init_user_ns, inode, ACL_TYPE_DEFAULT,
+				      argp->acl_default);
+		if (error)
+			goto out_drop_lock;
+	}
 
 	inode_unlock(inode);
 
-- 
2.53.0



