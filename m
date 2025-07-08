Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886AB5464F;
	Tue,  8 Jul 2025 16:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992938; cv=none; b=JYBRP32YG2uyNDgcQ70CFqv1eaK6dHO1B+jB4Wc+pcgYkyzSZe1c32VH+JsgiuFcCxQRZaVKq12Eg8DDtauONMftPQVBKRO2ktDodjqbp71TTDnJA8ALbkjQ1wwLB23INsm+r/l7mQafgaQjaow6q+C6t+jpoWKKXPLcziVfJeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992938; c=relaxed/simple;
	bh=i5pZlP8Ab4Du84pV1PT5qjw+4HZ3morFSzu8GnpudgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkGgqB5IWiWPHLc1nJVOPUSUm6Gg6OU09hsK3kCtLQgiiWtaAVm0QfYSs9hY2FCQCptXkowKS1dlBWOV9AQWYyH/iMsYwooj42im2XO7sc7eSOhfyACPJuoEvKJalS6Pq4gr5N81nc5rbMcTAodv57KZes1b4ielbt+p2UnK9QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3oYII4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3oYII4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1027FC4CEF0;
	Tue,  8 Jul 2025 16:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992938;
	bh=i5pZlP8Ab4Du84pV1PT5qjw+4HZ3morFSzu8GnpudgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3oYII4HNqhRLG7x4GDj1DV8PbGBpNaf0pkEHPmuWjxgvl6eCDJO4ZxuHNESt4EqS
	 mzmiAR+ozWwyvSesg816yynwaAN/FRrsXXSQzaF1SdF2BrgpCtzFaSpY+Nf+l5opUf
	 SAQ320vKQktNjPR2MKYY5n3RNJLnSu9Lx2lA90+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/232] gfs2: Rename GIF_{DEFERRED -> DEFER}_DELETE
Date: Tue,  8 Jul 2025 18:21:38 +0200
Message-ID: <20250708162244.112200301@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 9fb794aac6ddd08a9c4982372250f06137696e90 ]

The GIF_DEFERRED_DELETE flag indicates an action that gfs2_evict_inode()
should take, so rename the flag to GIF_DEFER_DELETE to clarify.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 2c63986dd35f ("gfs2: deallocate inodes in gfs2_create_inode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c  | 4 ++--
 fs/gfs2/incore.h | 2 +-
 fs/gfs2/super.c  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index ed699f2872f55..9d72c5b8b7762 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -985,7 +985,7 @@ static bool gfs2_try_evict(struct gfs2_glock *gl)
 		ip = NULL;
 	spin_unlock(&gl->gl_lockref.lock);
 	if (ip) {
-		set_bit(GIF_DEFERRED_DELETE, &ip->i_flags);
+		set_bit(GIF_DEFER_DELETE, &ip->i_flags);
 		d_prune_aliases(&ip->i_inode);
 		iput(&ip->i_inode);
 
@@ -993,7 +993,7 @@ static bool gfs2_try_evict(struct gfs2_glock *gl)
 		spin_lock(&gl->gl_lockref.lock);
 		ip = gl->gl_object;
 		if (ip) {
-			clear_bit(GIF_DEFERRED_DELETE, &ip->i_flags);
+			clear_bit(GIF_DEFER_DELETE, &ip->i_flags);
 			if (!igrab(&ip->i_inode))
 				ip = NULL;
 		}
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index e5535d7b46592..98a41c631ce10 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -376,7 +376,7 @@ enum {
 	GIF_SW_PAGED		= 3,
 	GIF_FREE_VFS_INODE      = 5,
 	GIF_GLOP_PENDING	= 6,
-	GIF_DEFERRED_DELETE	= 7,
+	GIF_DEFER_DELETE	= 7,
 };
 
 struct gfs2_inode {
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 5ecb857cf74e3..6584fd5e0a5b7 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1326,7 +1326,7 @@ static enum dinode_demise evict_should_delete(struct inode *inode,
 	if (unlikely(test_bit(GIF_ALLOC_FAILED, &ip->i_flags)))
 		goto should_delete;
 
-	if (test_bit(GIF_DEFERRED_DELETE, &ip->i_flags))
+	if (test_bit(GIF_DEFER_DELETE, &ip->i_flags))
 		return SHOULD_DEFER_EVICTION;
 
 	/* Deletes should never happen under memory pressure anymore.  */
-- 
2.39.5



