Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A6D42046;
	Mon,  8 Apr 2024 13:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584469; cv=none; b=kuvsUyCtgI98UkfxvHBhQLTYDpPGuCiiWBeqKYLLTI3Ydw6LMGbDrD6fi3xXh23ZLayx/ViJK8EYWELUvLZkVHLnxYtqPJ6TV9Ue/jkSq7lqWL6wqgR8rQ2Wdjm+XTwhvtK78G+i8dWUkdZ+Lf73DVm6kpTHdb7ML2+BRjk1qI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584469; c=relaxed/simple;
	bh=313xyx46Vy4DkI2B0fbGr/NDIjwY3Rz0fjs3IPO28lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFW/2llSHDah/GlChTD+dcMu0+NEn6FnczxB5W9mKF5bx+Na/XBPj2cV7/MQ6yhjs3Kwz5qnONK3i6GiRVNejUPRHdbwk2Cy0hV57UYFs+6rPoQtHF8zCzxeuw1ITaWQOZieSA78Z7Glv2WpEd8AhIBavTwbIsdH7tXTM9m2KDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOGYheDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOGYheDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E19EC433F1;
	Mon,  8 Apr 2024 13:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584468;
	bh=313xyx46Vy4DkI2B0fbGr/NDIjwY3Rz0fjs3IPO28lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOGYheDq+cWXWb6g4QHogR1LEdHtJRCDBmpW9EV94rOpQq8ZVCAJmvxunln0F5dd4
	 OpKAEd6n84mUGawl8LbM18Ntg60J8w3tN/GYUG4yT+GVeBa7D974vgxKYGCCOWdigs
	 Sbg9WlAdLbkTyyvZCG5Ewdpxb3Tj3j9vyiFItKnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong2@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 447/690] nfsd: use DEFINE_SHOW_ATTRIBUTE to define client_info_fops
Date: Mon,  8 Apr 2024 14:55:13 +0200
Message-ID: <20240408125415.839246844@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong2@huawei.com>

[ Upstream commit 1d7f6b302b75ff7acb9eb3cab0c631b10cfa7542 ]

Use DEFINE_SHOW_ATTRIBUTE helper macro to simplify the code.

inode is converted from seq_file->file instead of seq_file->private in
client_info_show().

Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 8cbb66b07d519..cc258f2988c73 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2503,7 +2503,7 @@ static const char *cb_state2str(int state)
 
 static int client_info_show(struct seq_file *m, void *v)
 {
-	struct inode *inode = m->private;
+	struct inode *inode = file_inode(m->file);
 	struct nfs4_client *clp;
 	u64 clid;
 
@@ -2543,17 +2543,7 @@ static int client_info_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int client_info_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, client_info_show, inode);
-}
-
-static const struct file_operations client_info_fops = {
-	.open		= client_info_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(client_info);
 
 static void *states_start(struct seq_file *s, loff_t *pos)
 	__acquires(&clp->cl_lock)
-- 
2.43.0



