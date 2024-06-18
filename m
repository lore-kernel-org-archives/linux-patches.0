Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651BB1AAE1A;
	Tue, 18 Jun 2024 13:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716476; cv=none; b=QI3bxDtKeFljkH5OS+uNGidZbz71uwo8HEmbt6nCDUa4lp857qbxGksmHmWR3P63mUdg24GYEYVsyVgS2vwco43Mnc1+ET/+SSnHC8QCwgkibsAcL/w+gtsZvz5RKvJDBvbXirKLA8dpPr1y7oEw6blvFCMEMUNOBlEOA4F+y/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716476; c=relaxed/simple;
	bh=U5PFlgmS+JwYYFRR1S+AzYDuITI19NraJ4te307mh0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnvJXW8lgD6sXH9R/Bah1Ncc2lHkEAvmnuewb2ah/Eedy5wBReN5jsWqXfXRFkoFXmRuvjAja4028iklLsB4Chw6ci+UPHjaZde2EijXlHkUTzpf9q/ViTy/9E/xmzS5IOtpfQucRUppioJX7FNcSBw+6mvNkRkcbsyvxjE14jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcmlR8qz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcmlR8qz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E067CC3277B;
	Tue, 18 Jun 2024 13:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716476;
	bh=U5PFlgmS+JwYYFRR1S+AzYDuITI19NraJ4te307mh0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcmlR8qzpzRMxkBhzlAOLT5gH9mp4eWO401K8Lr/javVB96DKuv5iLWRL5SOClg2I
	 ziy7l/6CWXqs1pKYP4iBlf6U5r0vlZkBqUtoRctfsdZPTE76B1TCZjQ4lMKL/mpzbp
	 yxDm5G/7/vE6wavQLUAqiRzkmJ6LwrXhIDy6LpjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong2@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 660/770] nfsd: use DEFINE_SHOW_ATTRIBUTE to define client_info_fops
Date: Tue, 18 Jun 2024 14:38:33 +0200
Message-ID: <20240618123432.762060634@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong2@huawei.com>

[ Upstream commit 1d7f6b302b75ff7acb9eb3cab0c631b10cfa7542 ]

Use DEFINE_SHOW_ATTRIBUTE helper macro to simplify the code.

inode is converted from seq_file->file instead of seq_file->private in
client_info_show().

Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index d2468a408328d..fce62a4388a26 100644
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



