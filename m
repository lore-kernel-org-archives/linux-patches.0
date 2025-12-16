Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9042B346FB6;
	Tue, 16 Dec 2025 12:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887553; cv=none; b=cIhVGlqf4AZvi2/JD+ATiObzWCH5kYLl3w4Zreep0D4NUoWchrZP24TYZQPGMkRMkOpiaYy+OCmppL4ABLJDkNdrmNer84erD4hEXV0duaw4er39zuG4h2NcmlhRIziROcFLDYIgcQ4THNOOAgQAo3PYeZlaXzQYPRjgs4PkQfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887553; c=relaxed/simple;
	bh=AySm7zN8pGrXLcbOqrfyqmCVacQfYDIxZrok8CP9BUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3j7GrdXCwc7690l7utKiWYQI7iIQS9L5PY2sj4WUDGrb/8w+fMiJWwew+L1AiJdPQoh02PK9l+oRNp9nSnG2Mm03+u9762VEAN/8b9+1G89536NUKXqzKA9QbQN/aftn6WB0Gx2oI1L13/cYrV3Rd4GE48Dv2mEZ4cu8+pNsj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ho6DZ7vn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ho6DZ7vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18357C4CEF1;
	Tue, 16 Dec 2025 12:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887553;
	bh=AySm7zN8pGrXLcbOqrfyqmCVacQfYDIxZrok8CP9BUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ho6DZ7vnK7mvMMOZxwcCLBkUEkx0tJCqADExc9/g87dM0wuz/tnWKPn1pHPozTUfR
	 g6abZ6Q/xmNSAIj4PKpAwb+crWWVJsz6AFlCTDkCo6Ms2/Hzp0q56wRiHqzKusSHFY
	 cZZcm9DiFtZkh4Ihry8pAmKMQxOHi1wvnlFntLcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 265/614] ocfs2: use correct endian in ocfs2_dinode_has_extents
Date: Tue, 16 Dec 2025 12:10:32 +0100
Message-ID: <20251216111410.974470210@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit c9dff86eb78a4b6b02b1e407993c946ccaf9bfb4 ]

Fields in ocfs2_dinode is little endian, covert to host endian when
checking those contents.

Link: https://lkml.kernel.org/r/20251025123218.3997866-1-joseph.qi@linux.alibaba.com
Fixes: fdbb6cd96ed5 ("ocfs2: correct l_next_free_rec in online check")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/inode.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fcc89856ab95b..0a0a96054bfec 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -201,13 +201,15 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
 {
 	/* inodes flagged with other stuff in id2 */
-	if (di->i_flags & (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL |
-			   OCFS2_CHAIN_FL | OCFS2_DEALLOC_FL))
+	if (le32_to_cpu(di->i_flags) &
+	    (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL | OCFS2_CHAIN_FL |
+	     OCFS2_DEALLOC_FL))
 		return 0;
 	/* i_flags doesn't indicate when id2 is a fast symlink */
-	if (S_ISLNK(di->i_mode) && di->i_size && di->i_clusters == 0)
+	if (S_ISLNK(le16_to_cpu(di->i_mode)) && le64_to_cpu(di->i_size) &&
+	    !le32_to_cpu(di->i_clusters))
 		return 0;
-	if (di->i_dyn_features & OCFS2_INLINE_DATA_FL)
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL)
 		return 0;
 
 	return 1;
-- 
2.51.0



