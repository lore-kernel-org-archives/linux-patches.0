Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A4F248BA7;
	Wed, 15 Jan 2025 10:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937833; cv=none; b=jdpLXAi/m+rSVUhZwdSE2mJzMKl/020NNuoJNKH68hmAZEfaQV0eiq2uck1KkHb0omzbJ60zzVqsakP8ureAgq9WOCmsVbWckq3ukMQN/va4Hg00kbe9biyX3kC10TNnDTcG54DgYVD5emsksqE1NnIsHB4Lk8JnHzjF8nU3elc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937833; c=relaxed/simple;
	bh=pDw5F8wIw/MgbADSg5EbXuMCcY5tJ4jhywH242pOfqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BApMp+Qa6aqlPAI7FLtJENXpW3gM6MH6HPw6pjuUGlW7xWhbEfideNo2JUTPLtPnqbpuDHNnbIRzdViFU+tfsNOa8ds4A7kGftOsRWBvsU7W8f+1orsruuGk09tGLS+p0UJ8lY+crAiDfqsG5k8PahGOhVu/QQUE04VhB9T1JBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FB3V0Di4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FB3V0Di4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1647BC4CEE2;
	Wed, 15 Jan 2025 10:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937832;
	bh=pDw5F8wIw/MgbADSg5EbXuMCcY5tJ4jhywH242pOfqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FB3V0Di4820glyzO1FFWFqbD+xwOsVDDf0f7owo4lvwfQDZFnxnWAo5EK7+0qW0r2
	 tyg6utw05KxxAooHKhZM7iH7DbF0JMh+QJDd7EBBDqEA81IO7Y7eUFlXjeClDnecjs
	 8BYWlYmncXoDlCcDSVVd/mmXekTsonfxhIbT/HMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Joseph Qi <jiangqi903@gmail.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 89/92] ocfs2: correct return value of ocfs2_local_free_info()
Date: Wed, 15 Jan 2025 11:37:47 +0100
Message-ID: <20250115103551.121319830@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit d32840ad4a111c6abd651fbf6b5996e6123913da ]

Now in ocfs2_local_free_info(), it returns 0 even if it actually fails.
Though it doesn't cause any real problem since the only caller
dquot_disable() ignores the return value, we'd better return correct as it
is.

Link: https://lkml.kernel.org/r/20230528132033.217664-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 5f3fd772d152 ("ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/quota_local.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 404ca3a62508..257f13cdd14c 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -815,7 +815,7 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
 	struct ocfs2_quota_chunk *chunk;
 	struct ocfs2_local_disk_chunk *dchunk;
 	int mark_clean = 1, len;
-	int status;
+	int status = 0;
 
 	iput(oinfo->dqi_gqinode);
 	ocfs2_simple_drop_lockres(OCFS2_SB(sb), &oinfo->dqi_gqlock);
@@ -857,17 +857,14 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
 				 oinfo->dqi_libh,
 				 olq_update_info,
 				 info);
-	if (status < 0) {
+	if (status < 0)
 		mlog_errno(status);
-		goto out;
-	}
-
 out:
 	ocfs2_inode_unlock(sb_dqopt(sb)->files[type], 1);
 	brelse(oinfo->dqi_libh);
 	brelse(oinfo->dqi_lqi_bh);
 	kfree(oinfo);
-	return 0;
+	return status;
 }
 
 static void olq_set_dquot(struct buffer_head *bh, void *private)
-- 
2.39.5



