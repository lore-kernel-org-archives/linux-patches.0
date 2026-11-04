Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831119;
	b=l6KY3wM1MLkGsZ/nMHA55LeuvgXtEGQYqpUTBYvM59rilR12BSkRoBYs8bvYO/hjcnjF
	 cb4RWWBD5e2meip73E2FBiIN0aiuk7FwJe0r7Ch8NwGgbp2CFPDEto+MaYgN65iuLtVN/
	 dsgDzKMGVCvTYXrUbBHLVaIkOXvsGr7EUnw0F9vXZslvZkqHP8/GyBQbg7D0JY0TW+rLY
	 AB3/ttw0iEqGfa0RbJ5E07wd4f02B3hdtu3ZM30TpYrvBbWOUhNXHvns3EfjuzcuiNWDo
	 IqhJ7CLsHVDjrpZjt2BPt1Lplyk8wcxOE+XkNKomEjdh3iKwd6rXiih8bFE78/9j+MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cXxlA9v9ObDzH9zmcZ4UfNkvANwshfeBkvJx+1nY77s=;
	b=onRcGhIgImptgw2PF8y0MuZCYgm3Y7swHwqtazLMIl9pACtzB5wx4yVBJOtbtsaQ9n/u
	 o8F4haGx8Mtt8BeRe5vzsLTCUnwwRWBHs5vPHOw6reForgJXS0nNQaXjWKl0loWTQCMB1
	 LqBwH5C+AAk/BuKJqXQS+7PTUT1IKKrOCZone0ppW3NTWhLa9OMtOtB4cvK4u7yh2fuR6
	 KpBtXDf2b/q1w9U+U2D39MbqeseKCJsCuYU+5py9C584nGnacDvBzX70BGAX9d87mmCXb
	 nN9HyDxteKixjLe5lUzwFF+Ybv9FgNnSmWCQuhkb6YuwaOqCHDoTsx4j3VoNrMx2Ycw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vodEkJFF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BA5606B3AF;
	Wed,  4 Nov 2026 22:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vodEkJFF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626881F000C1;
	Wed,  4 Nov 2026 22:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831118;
	bh=cXxlA9v9ObDzH9zmcZ4UfNkvANwshfeBkvJx+1nY77s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vodEkJFFbKG2Ga7jdFn4OI0MZSjRx1MfNdMNYRBOeN2wmbRDRiyjEHhHRihMF5MjW
	 R2c5AdLPlCtLw59B8p8oGKssN81lsEMC3F7pvjcW02o6IXGDqNDI2HXSahmjYyjGID
	 a0OJt5rwh1NuvNCPlRY+obu0rwz/9DYKenk5cbK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0514/1005] Revert "namei: dont reveal overmounted entries in refwalk"
Date: Wed,  4 Nov 2026 16:04:07 -0500
Message-ID: <20261104211058.329516419@linuxfoundation.org>
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
index fc2f463c6ea4d..39169df7bcaea 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1973,33 +1973,6 @@ static const char *pick_link(struct nameidata *nd, struct path *link,
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
@@ -2028,8 +2001,6 @@ static const char *step_into(struct nameidata *nd, int flags,
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



