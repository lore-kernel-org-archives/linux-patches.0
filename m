Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036791;
	b=H52RRLgAli5ovskHJM6tyCJk2ajEc+nvXovR6//teC9IM2p4BYBhM5lR0uSYQi6VLxxR
	 i2dOpn6vljg3bQrNGQ6o7AiSh99S+ssSV5V17m7QSTQ1T+U1cVg68jCVH+J8wWf5UKd4Z
	 O7Dg+mXAbl5sXqdSImVJVZJVM1U8eQRu79RPtucrO01dhPmxA46VggwUlFrodvVbo08YA
	 FWBXd7jxeBoRZAVAvT+NhUjQQi96o7AfdmJzLX5nQodhgv9boHfFQ8iFrw6v6N5wseGK8
	 7ntYkfJwlJ2VwKtTWZNvaovWl9cCTfmtW7lShCC31jYv0GnWdKJBttPulD8/1w+Ofiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CpcuquQ2RZg+KpW2+ES++EQWGcMzExWKSMawBdkzWJs=;
	b=gat0GalHKD/pMTqW1ZajaLBX/rsfUOv+APIldPiabpgB6GhGBNju6SXuaO8fvRYdjqFy
	 fAAIFGLesPQ/ypkvr0fmtcx8uFv6F/l4/2mXL5vhGJx2k/w96BMyl00qz5m6BedNJb3pc
	 OTxOW43svZUSd2s1sJH6P+rEFYLnZXWLLaCQO1ZPObQ9oWm9uaTnK+glGM5CN6Cr5pY9N
	 u5wg5FUogCEEmJb3klMBZTzxBFHht5mSD9k7dynJtVtBqAdDQIOpKtsUYOKru1+XddcAF
	 OvWC4/nLo96dZSENPRlP3gsq1uK8LeDgkPSEeFTZVQEINvWu+UmE/ewC26XZlc2iScg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZiaWoSF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34E6606A32C;
	Wed, 18 Nov 2026 21:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZiaWoSF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBBC1F000C4;
	Wed, 18 Nov 2026 21:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036791;
	bh=CpcuquQ2RZg+KpW2+ES++EQWGcMzExWKSMawBdkzWJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZiaWoSFZIjSaLUT+r1/FxgstWfGQfJZvTyVnc6UaIEXAWwpYRF42btB6/2WfAzuK
	 h8rvSf4/oTbQeRdd3NwWEc//uPQ/RRjHPtecjhmODFGwu3L+kU7W2TB4dfLLl9l2s0
	 NIEEmySGLr9xpw0lDs52eO54MhUlJYc7CTjo3qBM=
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
Subject: [PATCH 6.6 1184/3318] ocfs2: reserve metadata for a new xattr block and its value tree
Date: Wed, 18 Nov 2026 15:30:06 +0100
Message-ID: <20261118150355.669489608@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 8ad5fa0c11246d260d7b12c9672e604b1f431b2e ]

Patch series "ocfs2: fix metadata reservation for xattr value trees".

ocfs2_calc_xattr_set_need() reserves too little metadata for a new xattr
value's extent tree on three paths.  The reservation cannot be topped up
once the transaction has started, so ocfs2_add_clusters_in_btree() gives
up with RESTART_META when the value root fills and nothing is left.
ocfs2_xattr_extend_allocation() turns that into -ENOSPC, after
ocfs2_xa_cleanup_value_truncate() has dropped the entry and leaked the
clusters already handed out; before commit 0cdc7dde00ec ("ocfs2: fix
missing metadata reservation for large xattrs") it was a BUG_ON() instead.
It takes a fragmented cluster allocator to get there, since the first
extent always fits in the root.

Patch 1 fixes the create side of meta_guess: commit 3ed2be719eb9 ("ocfs2:
allow for more than one data extent when creating xattr") replaced the
block reserved for the new xattr block with the two the value tree needs
instead of adding them together.

Patch 2 fixes the arm that moves an xattr back into the inode, which
charges credits for a value tree but no metadata for one.

Patch 3 drops a second copy of the same reservation on the path that falls
through to meta_guess.  That one is cleanup rather than a fix and is not
for stable, and it must not be backported without patch 1: the duplicate
it removes is what currently covers the shortfall patch 1 fixes.

This patch (of 3):

The create side of meta_guess in ocfs2_calc_xattr_set_need() reserves
metadata for the new value's extent tree and nothing for the xattr block
that will hold it:

        } else {
                credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
                if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
                        struct ocfs2_extent_list *el = &def_xv.xv.xr_list;
                        meta_add += ocfs2_extend_meta_needed(el);
                        ...

Commit 3ed2be719eb9 ("ocfs2: allow for more than one data extent when
creating xattr") meant to add that tree on top of the meta_add += 1 the
branch already had, but it moved the 1 into the else arm instead, so the
external-value case lost it.  The 1 is not optional: it is what
ocfs2_create_xattr_block() takes from meta_ac through
ocfs2_claim_metadata(), and it is spent before the value tree exists.

ocfs2_extend_meta_needed() on the empty def_xv list returns 2, so the
branch reserves 2 where 3 are needed.  The xattr block consumes one, and
when the cluster allocator is fragmented enough that the value needs more
than one extent, ocfs2_add_clusters_in_btree() comes back around with a
full value root and ocfs2_alloc_context_bits_left() of 1 against a
threshold of 2.  It answers RESTART_META, which
ocfs2_xattr_extend_allocation() turns into a BUG_ON().  Commit
0cdc7dde00ec ("ocfs2: fix missing metadata reservation for large xattrs")
downgraded that to -ENOSPC, at the cost of leaking the clusters already
handed out: ocfs2_xa_cleanup_value_truncate() takes its !orig_clusters
arm, drops the entry and leaves the clusters for fsck.ocfs2 to reclaim.

Reserve for the block and the tree separately.

Link: https://lore.kernel.org/20261010113454.1420939-1-joseph.qi@linux.alibaba.com
Link: https://lore.kernel.org/20261010113454.1420939-2-joseph.qi@linux.alibaba.com
Fixes: 3ed2be719eb9 ("ocfs2: allow for more than one data extent when creating xattr")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 72b6b73d8372d..5cd52de9bb32a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3458,7 +3458,13 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
 		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
 			struct ocfs2_extent_list *el = &def_xv.xv.xr_list;
-			meta_add += ocfs2_extend_meta_needed(el);
+			/*
+			 * One block for the xattr block we may have to
+			 * allocate, the rest for growing the value tree it
+			 * would hold.  If ocfs2_xattr_ibody_set() succeeds
+			 * instead, that first block goes unused.
+			 */
+			meta_add += 1 + ocfs2_extend_meta_needed(el);
 			credits += ocfs2_calc_extend_credits(inode->i_sb,
 							     el);
 		} else {
-- 
2.53.0



