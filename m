Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828949;
	b=YcGrwpaOeXayqfmkbeU7V644/jZJKFTdJ8lqvJEVD5Jzm6CGa0gvJ6fqYOkMEzJtVtW2
	 W3EGdLjd5IdI2+y6M2OhZUr4gFlLRcxSCXg/DKgZC5XmodPfnkbiQR1Ubj+hIyvcF1X4T
	 fucFLBsxj8p79klmc4KKCP6k5yOErL1G1JTlrQalT9V/xO5SwD3Lvvgug3P2Eazu+wA9d
	 9CwDig1QRPXD5QKvnqnLTdwAMFRhvP9vc3atMj17VRgdV9KmBwhONBp8xTzzcoIyqWv+Y
	 zAU3QvYdQDQ4JzOE2r/hj3byK1KJX8nRXCqQ1TRHKpBxknl9VZwMWSNsgpZjYoYmhOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qJsaYhCjQJzpPoX94szUEmoFfQQp8FxzbKvSHdCIBs8=;
	b=XAmdxzPxtxPbFWuNDgGHrVlGxIUlG0zpzUogjMYy3y+sbnSb1BdTXq14JZ1ZPVpuP29O
	 kw+d1cOgdTEBN87juJscFH9hrnSULXVCR8RgNG+0tbsPLyK6XPaTBjYz33wa16uglp5Oi
	 cpZxC1v2ntHYqS3ecVbg6vGK77QoUm6ZxzRQQiNM9nOBI14vIxBWFmtFA4ZhbcetEv7VD
	 vf5eaeGkZvadNIIQ6AfdfU1cPC3zzqYDdPhECxzjE9tr9ZEev6V3/x2XPhHE3CZFaIU0v
	 jAVKmjXgL7CD9VcpbYIg47yrSbldqR8loUHfgufXud9BhneP3RxWc+D5eUhDCxtBZNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RSM0sDWn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456A06072659;
	Wed,  4 Nov 2026 21:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RSM0sDWn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F481F00919;
	Wed,  4 Nov 2026 21:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828949;
	bh=qJsaYhCjQJzpPoX94szUEmoFfQQp8FxzbKvSHdCIBs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RSM0sDWnHlkiWqPlXqeqkz832l0IXkKLNuIN8FP0nYLaD2r9743/S6h53SxACKFgj
	 iIWtT4rdvaEdOB2J6k/7KyItna6AEb6MjQp0stGsicD4zhDtNcP3Nn1mTtJ2+4jRTF
	 2ldxb8/UL47kNpQ+0jsz8/tfDRGn1Kyd0AiMH4cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 344/547] xfs: always forget cached ACLs if the attr fork swap succeeds
Date: Wed,  4 Nov 2026 16:08:48 -0500
Message-ID: <20261104211048.041609036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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


