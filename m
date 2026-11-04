Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831654;
	b=naT42ePDstx6Rv01VcWjC3o7cS2KKoyApAv3bdT93TBBASVVrOM8uYlUbPcE+tfuugvv
	 bgVrIKxcOMdW98cjtsFmgpf4LlOPQbRcNKw+i6CS0y30aE6jbHUVQpSo5P+CLdciGAgf2
	 2LwPyVZ5VE3ijAbD6wd0Vmp/fgK+/GVCcBSCnMgO3OOth17Lo3EvbjJcqqmX0qeao7DOK
	 R6RQPah3IMbLxMM1SaHghozxvro4Ikm/Tyxc7LXEywFTPcgPGyhsQjk6n8q4ieHp75usI
	 QQvefGahTQsvzL2TLK+Sq9maMF1W4O3OLaEgckZqQ2XdQnwa26B2RLksym7NFj9yWfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DeQYiNrukXYGjYxPZYIkUxuaX6UAAtMWH9myw5e/K2E=;
	b=OjRSIR7nGTODjakaJb59BBkMBwqOTjHVN5xdGwYhaw7L9kcAVjV7H6usicp49ayIT3+c
	 E5VYTybbYK31B4Mpyz9Sz0vERiYaVhCkXLeZ6xO8QibUI/uv7bJxWXyNlVwjK6bBYJJ14
	 356jHWl+MmvcGyg9CVoSVUURvH0v65wdJiPvQzOZoy/SDdrQFQNDCpmjbA6RvsL80JRbR
	 cicrkx3uFPl3+fXYjVnDENSFtz8GRVwgEYb3txJxnqJtHORPu0kqsgiLHC7tL9OoHuMSI
	 AZZ3Fdqy1mQdMMKUdx7oAbU2OvPQuT4pFKiGQJY4vG1T+PPEZVzYpY/zx4Xk1+xolXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qtKmFB1F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C1E606B2F4;
	Wed,  4 Nov 2026 22:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qtKmFB1F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05181F000C1;
	Wed,  4 Nov 2026 22:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831654;
	bh=DeQYiNrukXYGjYxPZYIkUxuaX6UAAtMWH9myw5e/K2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qtKmFB1F+lmDgmLlvuUGOmaOl0a7aRGbuUGLgDMD1/JA3E9HmyWbHecdJa4cUJ/9K
	 mPqlL07Jprf3ETAx7u7mdReDIm7MHZVZ9xAYfmOy3o8lL+nHpfTxlzaJ7sud8eN9Sy
	 cJYHIMcs+pcBOwUbS3Vsm6qSAXEvueMmOrKObxP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0835/1005] xfs: always forget cached ACLs if the attr fork swap succeeds
Date: Wed,  4 Nov 2026 16:09:28 -0500
Message-ID: <20261104211106.714600248@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 41ee987f53785b9443388a756912b1a0fe3c9592 upstream.

LOLLM complains that xrep_xattr_rebuild_tree omits the xfs_forget_acl
call if the attr fork swap succeeds (and hence the acls might have
changed) but reaping the old attr fork fails.  Fix it so that we always
purge the cached acls if the swap succeeds, even if subsequent steps do
not.  This avoids some cache coherency problems with access controls.

Cc: stable@vger.kernel.org # v6.10
Fixes: e47dcf113ae348 ("xfs: repair extended attributes")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1491,7 +1491,7 @@ xrep_xattr_rebuild_tree(
 
 	error = xrep_xattr_reset_tempfile_fork(sc);
 	if (error)
-		return error;
+		goto forget_acls;
 
 	/*
 	 * Roll to get a transaction without any inodes joined to it.  Then we
@@ -1500,7 +1500,7 @@ xrep_xattr_rebuild_tree(
 	 */
 	error = xfs_trans_roll(&sc->tp);
 	if (error)
-		return error;
+		goto forget_acls;
 
 	xrep_tempfile_iunlock(sc);
 	xrep_tempfile_iounlock(sc);
@@ -1509,7 +1509,7 @@ forget_acls:
 	/* Invalidate cached ACLs now that we've reloaded all the xattrs. */
 	xfs_forget_acl(VFS_I(sc->ip), SGI_ACL_FILE);
 	xfs_forget_acl(VFS_I(sc->ip), SGI_ACL_DEFAULT);
-	return 0;
+	return error;
 }
 
 /* Tear down all the incore scan stuff we created. */


