Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065195;
	b=HItLLlTdCabfoE1x2paXsC19NfqhZxHXWWBEkIyYwiS5fO0PTqBpQqOiZgJrD8gJrrag
	 6dfxZqLtvzP3g8IFHevnJvDGNXo5je9cIaT8vmSu+Ncs/NXRb49huJRpUifQAv+QCfeAa
	 b43cr/wfTB9GxWehv+3Wdt3hX8sMo5/3HuNq3h9pnnYTAJx6UPnmCOApXlQGkhF7/e4sG
	 E4wSxPQ9abtIaz46RsCRYscj6veuuCntK3pSxIstFSZwzjBeI7KvBJxh3Ef5gCsy9LUBu
	 kaAH5qRwXVp4b83ZnyA/46RLLSF7iaxVc2PFg8V4ddZmnRnz1YSWLgOZhHmnKHsiBMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IHSH5aJ2E1gbRawY6DMpV+rklciR/P65cvbMwzszETs=;
	b=TdYjI8hSkSUKe9BrilTWoqNnga73GmHbhtQdyiWm979jQZXoZJLsjNvBH+4kEUZoYK5u
	 /EB/9+WJpa8PcN9mgznqshdzux8mJtW+6BjjVz2+UciuyW3eiKXBIZKlkYr5ECTXU+6bY
	 lEYVnAIGk2ZczJDBabPRSPMcP1T0stOZrVTLLXDyCeB7y0vredM/L2jWj1mcFsMEtJx4v
	 42CFWLJAHN6lKdXlzJbNxIEOJ5dB6lWJx08ij5Fad9C07NhMqn4ofqYBPWsZkA/Bv7/SZ
	 DBFbwqYcDLuG0v0foxTWitlpcVhXDVheNNzlPRTVPcdlhKzxtNwLIu09xUCfUTJhrmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dYxhMzdo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4F3606A339;
	Sat,  7 Nov 2026 15:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dYxhMzdo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45EA1F0089F;
	Sat,  7 Nov 2026 15:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065195;
	bh=IHSH5aJ2E1gbRawY6DMpV+rklciR/P65cvbMwzszETs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dYxhMzdobG5fS1ldFJmqWAapeWd6FZuSWL7xvjFe7tUJXB8LhjZLql6OSy9A4UFcj
	 CmcOkAiuiM+KoYH/eOqsEU+DydZIz6lOoxH+2Po/a5Jf4H/6zh0glvYnkbJWwB12qU
	 EpPQUCd7d3PWSyXifYIzb74CKJYntv5dkgUuySxk=
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
Subject: [PATCH 7.3 0995/1257] ocfs2: reserve metadata for a new xattr block and its value tree
Date: Sat,  7 Nov 2026 08:54:51 -0500
Message-ID: <20261107135006.843994821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 8933d0f301199..b133489282a4d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3481,7 +3481,13 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
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



