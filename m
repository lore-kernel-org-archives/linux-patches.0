Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061672;
	b=nEpgg070F2qmUF8tUot67zHGlK3pNYYtQ4uOwr+cKm7bGBgPwy0chWEpjwPhLYrIhldN
	 y+jXEz0Dfr7e9FJe1Sapxe1H1FX9YxCNA6CVnRgt7umV3HPTeo3ow7qx8z+nusLTdM5PL
	 UlnAt74vMPYJVB88NOcYSvH8Z13uDlWnjndvJ9gP1z9JeauwnfgGkvE62anQRwR7/YGop
	 PBaShUeOsWkW590F+6L5V9vr2S1vw8J4BVk13a+Y8Q1NpNIYBvI7MCwxa7J4wJEE3jkix
	 /34eyBBS8Ybge5fDbTsTBk1nx30gY2F7UetsoTxORJyXkFyFoGhP+K3dOQFwX7v7LJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dxhcmj1AbKBV9CfJWAbgcKoTZI8HbgVRLL0nCZZRsFA=;
	b=2zceSyiHHbelHUGvfDXoo8LFntbpLEWlJcwhZiNuc0wuTx78JdVV9j3sj9z5s7jvVMss
	 NBXUXKsU9bkGe8kOym321FlLHCz7kfXJiWdxHbHfFJ0BsOKoqK2/IGLScQlms8sdiaeog
	 KM/N+xCfSzIguT2U3PImc8jaAvsEBQP9ZnVff6HSbFhWUfma3pvldQhGcX5K145tmYY6K
	 rUnpmbyIq93o7jXy9LbF+TY4omgWzcSLA73s5PVQJSrKZInUsu2heDM2+uyoCna7djRzh
	 TZIJB8mXExRnyetPI9vJjOse2xSqVPGJKAqjeCUq8jn+ilg7hKcjwbxgjaziSR81TrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZT8bAx62;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C314B606A331;
	Sat,  7 Nov 2026 14:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZT8bAx62
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7208C1F0089F;
	Sat,  7 Nov 2026 14:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061671;
	bh=dxhcmj1AbKBV9CfJWAbgcKoTZI8HbgVRLL0nCZZRsFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZT8bAx62TcRNQLY967Idv5uEt3EOuKuF8mJADYUNCqm5UGGScDdkVFW8Wgh1iXxah
	 XC70sdEMEOdGldzvFnob8zzaCqFaOLhGWisEYRsbzVKPUls+quSYzYt+hlLfHV5Jk7
	 5Ca9fkFpJDAtZ18bW5z2BjklDiTmGFQlruceeoW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0726/1536] xfs: always forget cached ACLs if the attr fork swap succeeds
Date: Sat,  7 Nov 2026 08:45:42 -0500
Message-ID: <20261107135017.890085273@linuxfoundation.org>
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


