Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3416453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9C3C340EE;
	Tue, 22 Mar 2022 21:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985123;
	bh=8A4cVOx+2H2wsICtI9ey9kBvYxU0IYDOVM2mO9NY4R8=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=Yc8nhr06gsha69GzyQx3JRfiKCgbsvmyYTTDq0tOm0ewqIojf0lZsyHr7b/t0VH4T
	 p5mqYUVU/svqOakmwt3tL0Oh8HthDioTmkKcSKu9jnDk5Sq1UhdqWbZjVxj5I3sHpN
	 CYPPz/dduOwW923ObLBwjqOeaitPoF1r7tnoXwWM=
Date: Tue, 22 Mar 2022 14:38:42 -0700
To: zealci@zte.com.cn,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,chi.minghao@zte.com.cn,cgel.zte@gmail.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 004/227] ocfs2: cleanup some return variables
Message-Id: <20220322213843.2F9C3C340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: cleanup some return variables

Simply return directly instead of assign the return value to another
variable.

Link: https://lkml.kernel.org/r/20220114021641.13927-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Minghao Chi <chi.minghao@zte.com.cn>
Cc: CGEL ZTE <cgel.zte@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c       |    9 +++------
 fs/ocfs2/stack_user.c |   18 ++++++------------
 2 files changed, 9 insertions(+), 18 deletions(-)

--- a/fs/ocfs2/file.c~ocfs2-cleanup-some-return-variables
+++ a/fs/ocfs2/file.c
@@ -540,15 +540,12 @@ int ocfs2_add_inode_data(struct ocfs2_su
 			 struct ocfs2_alloc_context *meta_ac,
 			 enum ocfs2_alloc_restarted *reason_ret)
 {
-	int ret;
 	struct ocfs2_extent_tree et;
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), fe_bh);
-	ret = ocfs2_add_clusters_in_btree(handle, &et, logical_offset,
-					  clusters_to_add, mark_unwritten,
-					  data_ac, meta_ac, reason_ret);
-
-	return ret;
+	return ocfs2_add_clusters_in_btree(handle, &et, logical_offset,
+					   clusters_to_add, mark_unwritten,
+					   data_ac, meta_ac, reason_ret);
 }
 
 static int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
--- a/fs/ocfs2/stack_user.c~ocfs2-cleanup-some-return-variables
+++ a/fs/ocfs2/stack_user.c
@@ -683,28 +683,22 @@ static int user_dlm_lock(struct ocfs2_cl
 			 void *name,
 			 unsigned int namelen)
 {
-	int ret;
-
 	if (!lksb->lksb_fsdlm.sb_lvbptr)
 		lksb->lksb_fsdlm.sb_lvbptr = (char *)lksb +
 					     sizeof(struct dlm_lksb);
 
-	ret = dlm_lock(conn->cc_lockspace, mode, &lksb->lksb_fsdlm,
-		       flags|DLM_LKF_NODLCKWT, name, namelen, 0,
-		       fsdlm_lock_ast_wrapper, lksb,
-		       fsdlm_blocking_ast_wrapper);
-	return ret;
+	return dlm_lock(conn->cc_lockspace, mode, &lksb->lksb_fsdlm,
+			flags|DLM_LKF_NODLCKWT, name, namelen, 0,
+			fsdlm_lock_ast_wrapper, lksb,
+			fsdlm_blocking_ast_wrapper);
 }
 
 static int user_dlm_unlock(struct ocfs2_cluster_connection *conn,
 			   struct ocfs2_dlm_lksb *lksb,
 			   u32 flags)
 {
-	int ret;
-
-	ret = dlm_unlock(conn->cc_lockspace, lksb->lksb_fsdlm.sb_lkid,
-			 flags, &lksb->lksb_fsdlm, lksb);
-	return ret;
+	return dlm_unlock(conn->cc_lockspace, lksb->lksb_fsdlm.sb_lkid,
+			  flags, &lksb->lksb_fsdlm, lksb);
 }
 
 static int user_dlm_lock_status(struct ocfs2_dlm_lksb *lksb)
_
