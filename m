Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061699;
	b=5oqbV96MkW4s7WeSKc+zlErqHu0s1iWgSy+9ltBr2hKRShQEq/YtFsSWDwynF7t9ZDZ9
	 8OoqXjvWU9epLTHdZZvz7/D09CWZFRRrIdCXEl9yAE0WW++LIYu3BtYVcsmjXJpDG+DLV
	 EnyX79w9Ym9DK34OuN/TRDDtmcNq3opWG9FibvYbCqnjrGzz0r4oZXwWbbja2UzS+oad6
	 0ymUCEkSZ9yy66rRwswzcjhems2vM2dTl525pvnQIOKErWuAIjuUpM7AVW+clalBkDtVx
	 ykXzYuqHKoCRg6wDu3I84vYvvjhTcpjXkvpVVM2hxAjcdEXyfTcO51bKs2Ng5B4EsbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FgCtNNI6TypLNW+LOy5JB+gCg3WctqE5EUqbm9ShYco=;
	b=tmI1RC+AtraFMiXLMHKsgRCrS+3rdNVaq0YwVPUpO53RkWcjbU51C7KHM2qa5DzBhw1I
	 1XjthOovoefv7sbl/PpjYmtkCT1iPdKAVrhVZc4FhadSXsa1eS7SOTB6gsilz8sBR13a4
	 c2kztqOiLo/Jokac9PyMC4ftA4meEickgERv4XG2lKGeZj0qp+rukCQVcOJtvKyL0YEM8
	 sbYaebm+tj9u5CNjbdNhWwSqQO5PAfGsxEhvF8pdKNlw3odHw/+RaKq+BtKmboK3ijb4s
	 GzISx5qs0RpOGZtHdybwAVPu5cx+w34e/p7efyp9/5rkBwERy/11hZMFmOqvlnBnB1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vaOOqjxa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C58606A326;
	Sat,  7 Nov 2026 14:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vaOOqjxa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13C71F0089F;
	Sat,  7 Nov 2026 14:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061698;
	bh=FgCtNNI6TypLNW+LOy5JB+gCg3WctqE5EUqbm9ShYco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vaOOqjxaXb4KQ1HcmjeJr3UmD90jWrLFrf+15btTqb4d+NSVkdJGvYcqDF6UBuruQ
	 AUO6cyXd0OHsIsbJXeGbEG+ptf2Zi18vqbfZP5tangNKUhtgWOms+FKeOPrNl1xB0M
	 eAT6UbP301y85v6EhyKezCRsxFSrMMZ0RYiDir4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0710/1536] xfs: check fork type against dabtree block magic number
Date: Sat,  7 Nov 2026 08:45:26 -0500
Message-ID: <20261107135017.440963202@linuxfoundation.org>
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

commit 43030b72a11a532e7e3c21ac84a8625425b4201b upstream.

LOLLM complains that we fail to flag dabtree blocks that should never be
associated with the file fork -- data forks can't point to xattr leaves,
and attr forks can't point to dirent blocks.  Add the missing checks.

Cc: stable@vger.kernel.org # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dabtree.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -410,6 +410,10 @@ xchk_da_btree_block(
 				XFS_BLFT_ATTR_LEAF_BUF);
 		blk->magic = XFS_ATTR_LEAF_MAGIC;
 		blk->hashval = xfs_attr_leaf_lasthash(blk->bp, pmaxrecs);
+		if (dargs->whichfork != XFS_ATTR_FORK) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		if (ds->tree_level != 0)
 			xchk_da_set_corrupt(ds, level);
 		break;
@@ -419,6 +423,10 @@ xchk_da_btree_block(
 				XFS_BLFT_DIR_LEAFN_BUF);
 		blk->magic = XFS_DIR2_LEAFN_MAGIC;
 		blk->hashval = xfs_dir2_leaf_lasthash(ip, blk->bp, pmaxrecs);
+		if (dargs->whichfork != XFS_DATA_FORK) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		if (ds->tree_level != 0)
 			xchk_da_set_corrupt(ds, level);
 		break;
@@ -428,6 +436,10 @@ xchk_da_btree_block(
 				XFS_BLFT_DIR_LEAF1_BUF);
 		blk->magic = XFS_DIR2_LEAF1_MAGIC;
 		blk->hashval = xfs_dir2_leaf_lasthash(ip, blk->bp, pmaxrecs);
+		if (dargs->whichfork != XFS_DATA_FORK) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		if (ds->tree_level != 0)
 			xchk_da_set_corrupt(ds, level);
 		break;


