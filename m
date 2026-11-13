Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591145;
	b=cGtWV8KvRfuyjZtV6uP2TiGDaNfvVgMpUBA7JGO3/AeZlGOLQYN5eLzAQTTFygoXHLFt
	 F8QX1vRj2mzYOlB6qaM3/AZlGMwoMNNJzeftcvGPx8Obb6KgORAZpKlW1Ip7wtTzlSSd0
	 A5yJKETd0u56oATYfyuze8VH4X1wPMEWuRFNleRqy22PiEqCvOAj7K8l20At7hXF1hwN9
	 mTRu0DNgxZT0v/QTxi766Nyc79CfvbFtJd1REjcGyMzWn4B3BGZR18VSyYDeQKnKOEWKe
	 vUf7/mqTKqR+UAWgYDdxMQifs4XH2FXSqeCbw5dYUkalpM5WV7mGuQ2rsxTbCpio8tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wuZGmPCwdLtu/ai0xDkZA1K5OROTtFn5+qy+5EpKFpc=;
	b=nHj/9HjkVcLdQNRB2uxKeKpjU4j2NXxkkAtwxs5LWKsOInSHoJfPyQV/t8neLuYIjZKR
	 BvtQjOx5biE5pxqaIdFqQ2jOn4p6pa1KxbGDX+osFgvGGQ6OpYWyI+nBBzMbRNj7/PkT8
	 8Es6RjKrcCfLVKaBMMVXULy5HUOzsA+IW3QJNDDa9zu7g5wmiedtJ/FBHYf+hpj9WOryM
	 0OSUiORg1YoMSCaFyEqU/3B9qfI+/+jpRJUqyUAlZJsNIT/bb0nVNXCoUZ9Rn/8oj5thR
	 UXcOI3inTEtjkw//gsj0zRmvEMcUH88367wGsOWeoly6+zzXQNS03vY2plNR0XT+kpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SjDnGiEO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2239F606BD32;
	Fri, 13 Nov 2026 17:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SjDnGiEO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98561F000C6;
	Fri, 13 Nov 2026 17:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591145;
	bh=wuZGmPCwdLtu/ai0xDkZA1K5OROTtFn5+qy+5EpKFpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjDnGiEOz5oHG9/EHWdOfe7IsZsA/k0Ft/jxcYAOQINHR6TB/n9RVtpMFoZdExyQW
	 aRJfyr3MIR5CszpcNz5pHtMFVfWqFKEjt/GQh9ICKOhcrnLR8IdiEc5cUJtpDy/m/8
	 nwIq20d+Coef2TIs/OfeVHnX+y9el9IT8Gqs0KFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 288/670] ocfs2: do not index before the entry array when dividing an empty bucket
Date: Fri, 13 Nov 2026 10:47:32 -0500
Message-ID: <20261113153821.633772175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 7133a0d0954c109f1764ebf8ab32d7e757a6c587 ]

ocfs2_divide_xattr_bucket() appends an empty bucket carrying a sentinel
hash when the source bucket has no divide position, taking that hash
from xh_entries[start - 1].  ocfs2_xattr_find_divide_pos() returns count
when every entry shares one hash, and its loop does not run at all for
count < 2, so an empty bucket comes back with start == count == 0 and
the read is xh_entries[-1].

That is outside the __counted_by_le(xh_count) bounds of xh_entries[] and
lands on the header, so the value picked up is
xh_count | xh_free_start << 16.  One above it is written into the new
bucket's xh_entries[0] and committed, which leaves a bucket whose first
hash does not follow the bucket before it.  ocfs2_xattr_bucket_find()
binary searches on xh_entries[0], so the broken key hides the range the
sentinel was meant to cover: getxattr() answers -ENODATA for an
attribute that is stored, and an insert can go to the wrong bucket and
leave two copies of a name.  The cross cluster divide hands the same
value back as a tree record's e_cpos, which then claims a hash range it
does not cover.

Read xh_entries[0] instead.  The branch is only reached when every entry
shares one hash, so for a non-empty bucket it holds the same value, and
for an empty one it is the slot that carries the bucket key.

An empty bucket reaches the divide from
ocfs2_check_xattr_bucket_collision(), which reports no collision for
one, through ocfs2_add_new_xattr_bucket() and
ocfs2_extend_xattr_bucket().  It does not take a failed set to get
there: a divide that finds no position is itself what leaves an empty
sentinel bucket behind, and a later extend can pick it as the target.

Link: https://lore.kernel.org/20261024151012.1059683-6-joseph.qi@linux.alibaba.com
Fixes: 80bcaf3469b8 ("ocfs2/xattr: Proper hash collision handle in bucket division")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index f30cefdff16f7..4704d96bce053 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5029,7 +5029,15 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
 	start = ocfs2_xattr_find_divide_pos(xh);
 
 	if (start == count) {
-		xe = &xh->xh_entries[start-1];
+		/*
+		 * start == count means every entry shares one hash, so the
+		 * first of them carries it too.  An empty bucket has no
+		 * entries[start - 1], but its entries[0] still carries the
+		 * bucket key: either the hash ocfs2_xa_remove_entry()
+		 * deliberately leaves behind, or the sentinel a previous
+		 * divide wrote.
+		 */
+		xe = &xh->xh_entries[0];
 
 		/*
 		 * initialized a new empty bucket here.
-- 
2.53.0



