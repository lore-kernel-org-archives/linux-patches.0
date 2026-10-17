Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24973B9927;
	Sat, 17 Oct 2026 17:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259143; cv=none; b=Cn1PABxs6A4z2dhMSq5GXw4SVLDbrAumH3CGhpQ1zFFtGtISsTHqKnSP34CyRrPSp6ZpML86f48HFXRFDPlyE3hesv1vIUWf4tXaGbIPWs0WYbTWaV7NIb/dQF+k84gUN0OxQhCBHlSDWRtJGf/AsDJP8/j88RL3Z+S1lMI/jPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259143; c=relaxed/simple;
	bh=ugLmKX27L73a36FKiUIlEfGSqjGdqSzV3MhXfN2qhMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJhHlQ5LImilZr1n3p4tV/qfiBKKs+oJTQK+kWTyH2n4rw6hO2LoW4k5pANfaetVrwNf7pThWEtByG34KGNx8HfOAOvQi47slXCheNSAYY8T/yMj/gR+WHkbuow5iBVOoQYCyGH9/OZugCjRyt9HDfWrlrkFXbH5C6HfCYTN6YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Al8u8R7U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Al8u8R7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EC11F000C4;
	Sat, 17 Oct 2026 17:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259142;
	bh=axgwOCwv+xyDFkY+DKQ0YBCE8WF5P+J3a6BHVtgH8qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Al8u8R7UBBis6cdh29Xd1ElMg8GLjAB74ozCy21RnRnipFG5FqwwXz9qm3op00I72
	 ImwW13cFelXtviAV5oVLOwCvd1saf/neLNuT5YXRVjl13oyXxgiWv/wUWKrFIqNGz2
	 SDUkMYfHdSkBUzhBL3ywhu6BFltduhjFE2+cMC6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao2870@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1117/1674] ocfs2: correct l_next_free_rec in online check
Date: Sat, 17 Oct 2026 17:56:29 +0200
Message-ID: <20261017160459.803388596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao2870@gmail.com>

[ Upstream commit fdbb6cd96ed51da002bd9a5a142586a74a436784 ]

Correct the value of l_next_free_rec to l_count during the online check,
as done in the check_el() function in ocfs2_tools.

Link: https://lkml.kernel.org/r/20250106023432.1320904-2-sunjunchao2870@gmail.com
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 452a8467be81 ("ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/inode.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index bbf8dfeeac745..1de709515f031 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -233,6 +233,20 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	return inode;
 }
 
+static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
+{
+	/* inodes flagged with other stuff in id2 */
+	if (di->i_flags & (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL |
+			   OCFS2_CHAIN_FL | OCFS2_DEALLOC_FL))
+		return 0;
+	/* i_flags doesn't indicate when id2 is a fast symlink */
+	if (S_ISLNK(di->i_mode) && di->i_size && di->i_clusters == 0)
+		return 0;
+	if (di->i_dyn_features & OCFS2_INLINE_DATA_FL)
+		return 0;
+
+	return 1;
+}
 
 /*
  * here's how inodes get read from disk:
@@ -1728,6 +1742,16 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		     le32_to_cpu(di->i_fs_generation));
 	}
 
+	if (ocfs2_dinode_has_extents(di) &&
+	    le16_to_cpu(di->id2.i_list.l_next_free_rec) > le16_to_cpu(di->id2.i_list.l_count)) {
+		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
+		changed = 1;
+		mlog(ML_ERROR,
+		     "Filecheck: reset dinode #%llu: l_next_free_rec to %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->id2.i_list.l_next_free_rec));
+	}
+
 	if (changed || ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check)) {
 		ocfs2_compute_meta_ecc(sb, bh->b_data, &di->i_check);
 		mark_buffer_dirty(bh);
-- 
2.53.0



