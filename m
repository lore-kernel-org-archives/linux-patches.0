Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2641E98FF;
	Thu, 30 Jan 2025 14:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246741; cv=none; b=KR/IodaIKOfdoo497GLmPMKcGxKZeQ5BBceSbSjWhK8wxgOYqPryfkwdFalPq1YnqY1i1+8hQMCdDww9LGs9xWf63aEZAIw9/EhOYFSxT2nM/Hi21+qSTTK5W8L46oSLSel2GzrhLu8YPzwrG+5KNVFDsjA4kxPYbNydmfZYf5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246741; c=relaxed/simple;
	bh=J9UMIHx/E/GQX/QMDO0CmvQCjmCeNQcHCzRrJCrqmms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPjxCU3/1Few0TrX6EXyoI0kbCvh/LsMRauWaXHjV//EQ2IRnuTKB69DEJENzbC1++P8ysDgOXVnr6+HoPKiYTGl8KVyWpWgFf30twjfz+4gldb5d+SZtVwI1utsL2dI7nV2RPj1hiq3mXfkRkf3CuVCUIxq6ZKM4a43b5FEwQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QY+cIlV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QY+cIlV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9E0C4CEE0;
	Thu, 30 Jan 2025 14:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246741;
	bh=J9UMIHx/E/GQX/QMDO0CmvQCjmCeNQcHCzRrJCrqmms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QY+cIlV2tp3T4U/LCP552Y69dzymKL32rd0sMGnjmMBYUXB1RKzUfKw5sIFZmSR1M
	 ExLKtzEOBajhQ7aIRp1lLw2/CiIlzoClTNjRsObvN02lsXrk0NHOvqhKmtdVyJB5+y
	 ZSUJ+qRuhuIhr8Z7hUJjCy0BM5jIIUdipXAEnRVM=
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
Subject: [PATCH 5.4 44/91] ocfs2: correct return value of ocfs2_local_free_info()
Date: Thu, 30 Jan 2025 15:01:03 +0100
Message-ID: <20250130140135.430606960@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



