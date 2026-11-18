Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022606;
	b=D7R7XR0S+AqxDDy+cdrzJVMAzqdpwBfnnecrbP2j7IyDFUeA7B+XIgksI0IdIKfZjEbB
	 c4X6CAUTQCX6T16pf0H4tcoH+N7AV6ut1XWCaIul6lJJFjC2EUfLN4LxoWD+4WGnAWmr9
	 JLpCil/kv0KarxfAonyhSoTPtWjU65HDtfPrCitpz6bqwiXZMXTYlGiFk3yyqzPs+AyD0
	 +4pz1CL0aHvhCneJpgfAoc+Mxm3QS/fopJHikrfE7x1wyEfnPhKqY7Zk6YKwv8QbBALz0
	 CyC6oly1KVBVKHHWtCA4MMoh0K6wpD9P0dZix/2sFZD+EICXSgrDIadQK0sJ18fmTRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OhSoWHKxQS8WiBhQKcSBV6LMR9cuqM+Y5reaIK4YgBA=;
	b=dZTRMwxLnHRJRS9eWm1w8RYAbK+tzqxvkwZArjeuxzzZlT5EnwTBi357mBt01ngVzI5B
	 y4LYMKsCXkavXd0HqCiTxh4Fx7g4AnUMH4q2qwISI56jd7cUuW/syMRDIaWS1qXWK2roR
	 w6BvPf0Oi1kBPY6U4pVe2Zn4FBQcKQpw14Y9WapE/vWXMbOBK/IaWMbhrqmqf3gpL+/0Z
	 ewd43wUdpFdtTO/f4JYz2FGXDJ4ljMJeujzgiiwevGJpD56Wnfi95ZXd6JOYPFbLdOMNr
	 /TjkrEdKXyqC+ZKTDDKrUGS5vz5ythcHA/edisSdP4rB/H2waYDf9HfIYqJzaVVryoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yQtH0ATI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CC1606A325;
	Wed, 18 Nov 2026 17:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yQtH0ATI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D25F1F000C4;
	Wed, 18 Nov 2026 17:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022606;
	bh=OhSoWHKxQS8WiBhQKcSBV6LMR9cuqM+Y5reaIK4YgBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQtH0ATIzZSw4rMTRn+TC3c2ziYYBxkSbCsG1078BBCWEkNI/ps+vdD+/NsiK/RWD
	 k7EoIurIfhacOFSz2OwreaYS3/r5xXqrOmSkQPyOCpnE+Bu4W0SxznlIEalfJZ+vVz
	 QyBYhJ2WANsCJAuNl4BPEB6JzyFl7hN49VDpKNmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0073/2151] ocfs2: validate move extents against a stable EOF
Date: Wed, 18 Nov 2026 15:30:08 +0100
Message-ID: <20261118150124.419987236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 84db6619cb702c37cf848b450c21b9c9706b0775 ]

The move-extents range must be bounded by the inode size used for extent
movement.  ocfs2_ioctl_move_extents() checks and clamps the request before
taking the local inode and cluster locks in ocfs2_move_extents().  It also
uses separate i_size_read() calls for the range check and subtraction.

A concurrent truncate can invalidate the first check and make the later
unsigned subtraction underflow:

  Move-extents ioctl                  Truncate
  ------------------                  --------
  check me_start <= i_size
                                      take inode and cluster locks
                                      shrink EOF below me_start
                                      release locks
  compare me_start + me_len with EOF
  set me_len = EOF - me_start
    [unsigned underflow]
  acquire inode and cluster locks
  select extents using the bad range

A truncate after clamping can also leave the range extending beyond EOF.
Conversely, the cached size may be smaller than the size refreshed when
the cluster inode lock is acquired.  Early validation can then reject a
valid start or permanently shorten the requested length and threshold.
The me_start + me_len comparison can also wrap for a large input length.

Validate and adjust the original request once, after inode_lock(), the
exclusive rw lock and ocfs2_inode_lock() have stabilized and refreshed the
size.  Read EOF once, reject a start beyond it, and bound the length by
EOF minus start.  Normalize the threshold using the same EOF snapshot.
This keeps zero as the default-threshold sentinel until validation uses
the size that will govern extent movement.

Move goal validation after range adjustment as well.  Its allocation-group
capacity check uses me_len and must see the EOF-clamped length.  Both
validation failures use the existing inode-lock unwind path before any
extent movement or transaction starts.

Range errors now reach the ioctl's normal copyout path, as goal errors
already did.  Unlike the old early rejection, a failed copyout can
therefore override -EINVAL with -EFAULT.

Link: https://lore.kernel.org/pm-ocfs2-move-extents-isize-rrw-v6-395bdee84ea81149068e@gmail.com
Fixes: 53069d4e7695 ("Ocfs2/move_extents: move/defrag extents within a certain range.")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/move_extents.c | 70 +++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 31 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index f599978cbb9b1..5952c7f4e7f04 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -902,6 +902,30 @@ static int __ocfs2_move_extents_range(struct buffer_head *di_bh,
 	return ret;
 }
 
+static int ocfs2_validate_and_adjust_move_range(struct inode *inode,
+						struct ocfs2_move_extents *range)
+{
+	u64 i_size = i_size_read(inode);
+
+	if (range->me_start > i_size)
+		return -EINVAL;
+
+	if (range->me_len > i_size - range->me_start)
+		range->me_len = i_size - range->me_start;
+
+	/*
+	 * The default threshold for defragmentation is 1 MiB, which
+	 * matches the maximum OCFS2 cluster size.
+	 */
+	if (!range->me_threshold)
+		range->me_threshold = 1024 * 1024;
+
+	if (range->me_threshold > i_size)
+		range->me_threshold = i_size;
+
+	return 0;
+}
+
 static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 {
 	int status;
@@ -931,6 +955,21 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 		goto out_rw_unlock;
 	}
 
+	status = ocfs2_validate_and_adjust_move_range(inode, context->range);
+	if (status) {
+		mlog_errno(status);
+		goto out_inode_unlock;
+	}
+
+	/* The goal check depends on the adjusted range length. */
+	if (!context->auto_defrag) {
+		status = ocfs2_validate_and_adjust_move_goal(inode, context->range);
+		if (status) {
+			mlog_errno(status);
+			goto out_inode_unlock;
+		}
+	}
+
 	/*
 	 * remember ip_xattr_sem also needs to be held if necessary
 	 */
@@ -1023,27 +1062,8 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 		goto out_free;
 	}
 
-	if (range.me_start > i_size_read(inode)) {
-		status = -EINVAL;
-		goto out_free;
-	}
-
-	if (range.me_start + range.me_len > i_size_read(inode))
-			range.me_len = i_size_read(inode) - range.me_start;
-
 	context->range = &range;
 
-	/*
-	 * ok, the default threshold for the defragmentation
-	 * is 1M, since our maximum clustersize was 1M also.
-	 * any thought?
-	 */
-	if (!range.me_threshold)
-		range.me_threshold = 1024 * 1024;
-
-	if (range.me_threshold > i_size_read(inode))
-		range.me_threshold = i_size_read(inode);
-
 	if (range.me_flags & ~(OCFS2_MOVE_EXT_FL_AUTO_DEFRAG |
 			       OCFS2_MOVE_EXT_FL_PART_DEFRAG)) {
 		status = -EINVAL;
@@ -1055,23 +1075,11 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 
 		if (range.me_flags & OCFS2_MOVE_EXT_FL_PART_DEFRAG)
 			context->partial = 1;
-	} else {
-		/*
-		 * first best-effort attempt to validate and adjust the goal
-		 * (physical address in block), while it can't guarantee later
-		 * operation can succeed all the time since global_bitmap may
-		 * change a bit over time.
-		 */
-
-		status = ocfs2_validate_and_adjust_move_goal(inode, &range);
-		if (status)
-			goto out_copy;
 	}
 
 	status = ocfs2_move_extents(context);
 	if (status)
 		mlog_errno(status);
-out_copy:
 	/*
 	 * movement/defragmentation may end up being partially completed,
 	 * that's the reason why we need to return userspace the finished
-- 
2.53.0



