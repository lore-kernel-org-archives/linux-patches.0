Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43C07482;
	Mon, 23 Jun 2025 21:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713621; cv=none; b=VzVIdrRq6zS6pFZCpeZm/1ACbJ7AyAzNGQR2Y1G/oi0XqRVV9yXvI3r9Wh3I1Hxd7BQqD7m4SYOIrgSevFVp7HcMkcz6qV8f+UVZb7O938sxUFWrZbno2kqLuZo6208lzDvLJp+vsyi0SktQhafDO2aHpefgIypF3tUeF40MyiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713621; c=relaxed/simple;
	bh=+QK7+h1dalRXXN8sAsw8iT3Ane+yvqTyFMp7A0OgSl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzjSmEbXpZWIgC7+TxPX2cQ2tgErhu14+Wbutdwy3tkYM5Aai5gBGG5VqlHi3uQJP82rLyFqXzVtFCb/9BHrVQl2VhCbp+7fKnMiF/wLP2moG+kkuKHP2ks+vrCtqHoHlbYnZG9BimTkEEl2QZAdnsSebF8owlsfcX1nC27Gx+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t58kSrqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t58kSrqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39059C4CEED;
	Mon, 23 Jun 2025 21:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713621;
	bh=+QK7+h1dalRXXN8sAsw8iT3Ane+yvqTyFMp7A0OgSl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t58kSrqDrCKkZfcX8kubHQEi2bYsmiyBtdVynm2ps9J3TF7cvKdWH8WQ9FOFWvgbH
	 /8gVg/Xowjq8IQuFUbFCW/J1gORIwegTjfrCXxnb3U0OiMRn66Lt60hG/SJzJ7pVWF
	 MUNvfKCXCmwbLzMzttFaeLKaRvVjDTDVrtcurpOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/508] f2fs: fix to correct check conditions in f2fs_cross_rename
Date: Mon, 23 Jun 2025 15:02:30 +0200
Message-ID: <20250623130647.864050245@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 9883494c45a13dc88d27dde4f988c04823b42a2f ]

Should be "old_dir" here.

Fixes: 5c57132eaf52 ("f2fs: support project quota")
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 77fa3c639ba38..7bfa3249d9cc1 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1086,7 +1086,7 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if ((is_inode_flag_set(new_dir, FI_PROJ_INHERIT) &&
 			!projid_eq(F2FS_I(new_dir)->i_projid,
 			F2FS_I(old_inode)->i_projid)) ||
-	    (is_inode_flag_set(new_dir, FI_PROJ_INHERIT) &&
+	    (is_inode_flag_set(old_dir, FI_PROJ_INHERIT) &&
 			!projid_eq(F2FS_I(old_dir)->i_projid,
 			F2FS_I(new_inode)->i_projid)))
 		return -EXDEV;
-- 
2.39.5



uct no
 
 		stab = rtnl_dereference(q->root->stab);
 
-		oper = rtnl_dereference(q->oper_sched);
+		rcu_read_lock();
+		oper = rcu_dereference(q->oper_sched);
 		if (oper)
 			taprio_update_queue_max_sdu(q, oper, stab);
 
-		admin = rtnl_dereference(q->admin_sched);
+		admin = rcu_dereference(q->admin_sched);
 		if (admin)
 			taprio_update_queue_max_sdu(q, admin, stab);
+		rcu_read_unlock();
 
 		break;
 	}


