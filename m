Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5A31E7C27;
	Thu, 30 Jan 2025 14:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247037; cv=none; b=I6tVfqv0ARKyfEh8rgA+NAaWqauzFu5/nFM3Tka8cEUsZo1cUWMLfVyW1yfsqM/Ulw/QDRJ+bDox3+U9KR/Lce3igJIDHwCVKijKJ/qmVJ9tMI3Uj5d9Zq3YEGStbfAD+9+KFgvMUKuLKDGfWGrwnBuRuZzxaBJ/QBPqzoEbxBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247037; c=relaxed/simple;
	bh=ZVYUgCxVMaa5h6thNDeb6xCZKPXFuZw7Z5e5LSdgqo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7oA8P6jrxXpo40DKdj5nK6Xm4pr0/2ILPzGkolhRzgfwgZT1MZzZcphgtuyi0xAeehIoZ9rxdYc9ltnrRJpHVEFWgnYlxCe2VdCFvT8Aad1zRijho+AC5EPmwj6HkXnZUY3MBMNzIeBYN4OfS24dboyPzJha9ebl9eJrvu10kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwPIA4mI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwPIA4mI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289B3C4CED2;
	Thu, 30 Jan 2025 14:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247037;
	bh=ZVYUgCxVMaa5h6thNDeb6xCZKPXFuZw7Z5e5LSdgqo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwPIA4mIRKvEUnVQwvV/TlWDFjwASyMQLwRsc8BNcyISVUuN5f7eg4flRNxNnxfOP
	 uBm70qNRf3pKx/IXFqklZtOeg7cUg+jwROvPsY+HOF4x/95S5oJLAGt3bIGY5TiA1F
	 FBfm++Z/WAA+PRdy97QUxXQ2Dq+vmkHREl/wjTcM=
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
Subject: [PATCH 5.10 059/133] ocfs2: correct return value of ocfs2_local_free_info()
Date: Thu, 30 Jan 2025 15:00:48 +0100
Message-ID: <20250130140144.895420299@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7a1c8da9e44b..fbab536741e2 100644
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



