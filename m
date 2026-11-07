Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061112;
	b=JySulSy+RKV874fLOp8XC3Mlc9Ibz2pkysAKsfhJtrNxWjREecRPFB97pbYdEYIhgo3N
	 PzQrawQfBdQrSwRtAnmLByNPjDoyu9VwHvV5aCkJPPjLdaF8sAqXXXVI2LDbilcZNoZBE
	 k3eWjYL554gJHwstGGOgyZmVYZC/9b/IeQ42Zqxgs4IX6L4uB7weokTwW6oGdvCf4Qtp3
	 FM8nFeojR8gIqRPUptRUyer1Lw2nZtUtuU1s5Wajj0s1/tH9JPXnwUU8Hmd+MPO9JVw5X
	 dVQxR9qA2UxrWm+RB8cs/fX0KM+O9JrLjkOi2wEAVKVjnIMSKfIt8CC213gi2gnjtBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TsqKFYs0Xu+t81frMj9tXFen6GXdUGwWC9p+iSxRUTw=;
	b=O2aoeFW+T1Thaje7YwTWVUHthcEbksymIWt8a0YuHH5Mun9BhoOhbQ3oHp/ZBxKOR1GP
	 imZKaNAf28qSBKea/sgB2eIkyRUq1ZAJwEiHg9/2plJydHHcDqN9X5IAq+tbjHfweS0gW
	 FwY9g8cLHMFWP8XikXSbbYgiRDF/bZiWRRdjE1P81QKfCIgNlJxp2vNTarJxsVzyHmHfC
	 BDhydJC+NXPlIYdVExdXDDsvRI7ek190JRw3Tb9Oa7a7wF2LLgQiTjmWTeeukgrNYqzCC
	 hnNIIVUycpIkv1z68GiYd4vb5Fr3k8u5iLn0LTNu+1xqhOwxKYcZcKqwOUFDiqQjQOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zomayDUL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A7D606A332;
	Sat,  7 Nov 2026 14:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zomayDUL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52321F0089F;
	Sat,  7 Nov 2026 14:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061112;
	bh=TsqKFYs0Xu+t81frMj9tXFen6GXdUGwWC9p+iSxRUTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zomayDULMjduA3+r0mEoEPGS0xyoEUIeNzYCBYIsZJoM664Bn9yr2O3DDjfV0V4PO
	 OEI0IUIvB1h+kb3BSQBujRkIa66m9UnnqMQzm99Wut3SQb/Tnw60pBGa/4K6yYlJPA
	 Bn7lfwfjc7bLXieR8tJWonQDhXjMdIkOZzA/JNMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0429/1536] Revert "namei: dont reveal overmounted entries in refwalk"
Date: Sat,  7 Nov 2026 08:40:45 -0500
Message-ID: <20261107135009.612556045@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 214897acc8c2e5d6b63189d23ccaed6fa2af45a9 ]

This reverts commit 8189ab688f5a2c745dc90b63374da02f213d6994.

This bug class is bigger than can be fixed with this simple patch.
Back out of it and give us some time to fix this properly.

Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namei.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a73b055dcd399..767a83566bdbe 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1888,33 +1888,6 @@ static const char *pick_link(struct nameidata *nd, struct path *link,
 	return NULL;
 }
 
-/*
- * Be careful in case the dentry is unlinked or renamed. Any mounts
- * stacked on top of it are going away. We need to make sure that we
- * don't reveal the underyling dentry during refwalk. In rcuwalk we
- * catch this via d_seq and another lookup for the name. Give the same
- * guarantee in refwalk.
- */
-static bool unlink_may_reveal(struct nameidata *nd, int flags,
-			      struct path *path, struct dentry *dentry)
-{
-	/* ".." and LOOKUP_DOWN may land on an unhashed directory */
-	if (flags & WALK_NOFOLLOW)
-		return false;
-	if (nd->flags & LOOKUP_REVAL)
-		return false;
-	/* We crossed onto a mount and the name led us here while it still existed */
-	if (path->mnt != nd->path.mnt)
-		return false;
-	/* only a name on its way out is flagged */
-	if (likely(!cant_mount(dentry)))
-		return false;
-	if (!d_unlinked(dentry))
-		return false;
-	dput(no_free_ptr(path->dentry));
-	return true;
-}
-
 /*
  * Do we need to follow links? We _really_ want to be able
  * to do this check without having to look at inode->i_op,
@@ -1943,8 +1916,6 @@ static const char *step_into(struct nameidata *nd, int flags,
 			if (unlikely(!inode))
 				return ERR_PTR(-ENOENT);
 		} else {
-			if (unlikely(unlink_may_reveal(nd, flags, &path, dentry)))
-				return ERR_PTR(-ESTALE);
 			dput(nd->path.dentry);
 			if (nd->path.mnt != path.mnt)
 				mntput(nd->path.mnt);
-- 
2.53.0



