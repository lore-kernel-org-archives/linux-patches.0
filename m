Received: from sender4-pp-o95.zoho.com (sender4-pp-o95.zoho.com [136.143.188.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6573054E5
	for <patches@lists.linux.dev>; Mon, 25 Aug 2025 18:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756145609; cv=pass; b=ilkwqg4TL037gjRUJkk5DrN4LT5495nnAvT45STkjwQiazk4FlJXX/6EUnGrzZBxtR60+fT2+Vq18mrfW0IZHvv7V04z5I5Uf4J3Dv2o4asV/Spptzz9QE0JlmmFZqRa6Wgci+o4BTI1oOOcavV4V3lv84XNsmC7yW91uYxrSCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756145609; c=relaxed/simple;
	bh=5uaPBf07hCj63yaAFoCxEND7MCLmzvxkZW7/dK6tHJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDiS5KEQWpNM3Eb8Tc8wpNg5v+q6rmI5RRwNYrfmlfqBXO7mdiXsUE+iAIgxitne+u0o79vqQFpE+mbZ6dlz+6WTo2wXV73vU0zpWsCI5SVmbzbZ2L3dJfRsGHUt0iMsOv9FWrWHSn1b6ai9dK/J/TkZGyOavcAu+nZmF0H/s/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b=KLxuvRgW; arc=pass smtp.client-ip=136.143.188.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b="KLxuvRgW"
ARC-Seal: i=1; a=rsa-sha256; t=1756145572; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=jzQnkIaCG30B/q3COYw/nDGYZNsob7u9T6WY4rskhUMe5YJy9LrBas95GaOr4MRLNvEepCQUZftcc+nIWPA4AuPy0DtK9Xa4ah7oEyfswRiqfw106t6SXOLxMmewCr9vLTbr9BNB0J4SDVGm/l7oBbFFntXkrqRWtXKqTsi/L+I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1756145572; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=cwTeDTN8vZEoJJgRMRcOqX3jO84JMqfepC8EV4dqZg0=; 
	b=G6FVqdwK7C1WRQKHqpznO8/BSY4n3Df0tAp7YKD7Y57WT+rN2PvIfq2ZNmTulDuCNUQuGskdAJzJEa4ru+UXzHtqhOAyaw8qZgNZNpfNufLRPd6JBvt39ybbHA/9Nah/99z8JZPQQ9htVhh2X2WlsC+ejxPHgsFPKitbZVDxG14=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=safinaskar@zohomail.com;
	dmarc=pass header.from=<safinaskar@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1756145572;
	s=zm2022; d=zohomail.com; i=safinaskar@zohomail.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Feedback-ID:Message-Id:Reply-To;
	bh=cwTeDTN8vZEoJJgRMRcOqX3jO84JMqfepC8EV4dqZg0=;
	b=KLxuvRgW30bx73AcHrakVro95/y2zznJOVjPMgut2bH84MJqgC1nVlPIIOQQWCvJ
	RtEJjy95UGrnHfldyy4mkcvgLI2GfkzjDXL0m6JwcfxyBSF1y63voMwV9Qa242SMJez
	t9fwBfLjeO275E5OadiqmFOQglNyf9ZxsqzLGuuQ=
Received: by mx.zohomail.com with SMTPS id 175614556960387.54761423051127;
	Mon, 25 Aug 2025 11:12:49 -0700 (PDT)
From: Askar Safin <safinaskar@zohomail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	cyphar@cyphar.com,
	Ian Kent <raven@themaw.net>,
	autofs mailing list <autofs@vger.kernel.org>,
	patches@lists.linux.dev
Subject: [PATCH v2 1/4] namei: move cross-device check to traverse_mounts
Date: Mon, 25 Aug 2025 18:12:30 +0000
Message-ID: <20250825181233.2464822-2-safinaskar@zohomail.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250825181233.2464822-1-safinaskar@zohomail.com>
References: <20250825181233.2464822-1-safinaskar@zohomail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: rr08011227d54e95a90a56b31b5d00c8590000c77bf43990679d842f4acd79ed5fd0851e9194228b4c27f106:zu08011227e6784f6c0ac40d9bdf44f80d00007bb01dde73f3eb727b49faa2586029e502d0c6ebe4001942b3:rf0801122c15be9a1f2b725284181daf5e0000e48a76ed74563d961abb37da3855f37fc3d81f4e0ae80e19beea910f57ae:ZohoMail
X-ZohoMailClient: External

This is preparation to RESOLVE_NO_XDEV fix in following commits.
No functional change intended

Signed-off-by: Askar Safin <safinaskar@zohomail.com>
---
 fs/namei.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index cd43ff89fbaa..1e13d8e119a4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1518,6 +1518,7 @@ static inline int traverse_mounts(struct path *path, bool *jumped,
 				  int *count, unsigned lookup_flags)
 {
 	unsigned flags = smp_load_acquire(&path->dentry->d_flags);
+	int ret;
 
 	/* fastpath */
 	if (likely(!(flags & DCACHE_MANAGED_DENTRY))) {
@@ -1526,7 +1527,11 @@ static inline int traverse_mounts(struct path *path, bool *jumped,
 			return -ENOENT;
 		return 0;
 	}
-	return __traverse_mounts(path, flags, jumped, count, lookup_flags);
+
+	ret = __traverse_mounts(path, flags, jumped, count, lookup_flags);
+	if (*jumped && unlikely(lookup_flags & LOOKUP_NO_XDEV))
+		return -EXDEV;
+	return ret;
 }
 
 int follow_down_one(struct path *path)
@@ -1631,9 +1636,7 @@ static inline int handle_mounts(struct nameidata *nd, struct dentry *dentry,
 	}
 	ret = traverse_mounts(path, &jumped, &nd->total_link_count, nd->flags);
 	if (jumped) {
-		if (unlikely(nd->flags & LOOKUP_NO_XDEV))
-			ret = -EXDEV;
-		else
+		if (!unlikely(nd->flags & LOOKUP_NO_XDEV))
 			nd->state |= ND_JUMPED;
 	}
 	if (unlikely(ret)) {
-- 
2.47.2

