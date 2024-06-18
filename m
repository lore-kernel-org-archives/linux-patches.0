Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E625D1AAE2F;
	Tue, 18 Jun 2024 13:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716480; cv=none; b=AZmMSiFhydQn1w6iWD6eKYkT9iFTGR5JOvkpVq60+WOl3FALu1J5yHFrW3NahK70iIA4zLcknrMaLbY315kEThyLpWP0NoCMqy6rBWMBD2rt6eGtn3dXtomu/4WJ3VKMYd+Ox3oA0PeczPdJ0XUKynkagV9G9Jx5q+Eo7Z2lMhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716480; c=relaxed/simple;
	bh=a1Vw4ErXoAJ1T/m+wHMyPjRkt4zgz68fH6pUPaYP5mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRwSbGlzficaTUsHA3ZEreZs9W+M1cCQSrkw52UD/TypI6uAAmBy/ooc1mwQO4svyuCehOD6UQgGwBRhNm21oxCyx4ny7aH905/YnCfVe3MaTXwJ533l7lfX9azbz2XDtcJOK6YohUvauST2sW8Xl4NeO/BHRwtNfTH9PUvG77w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziKBFqXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziKBFqXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3509C3277B;
	Tue, 18 Jun 2024 13:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716479;
	bh=a1Vw4ErXoAJ1T/m+wHMyPjRkt4zgz68fH6pUPaYP5mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziKBFqXrAj1rtkziwms5tMEJsAS3VxCghiX00Ls9+ypxzOgAY7CVmGBQsp7e6KoWU
	 vyoawksLHxmzyYxlO8m/igm43fjmNriw5Giu0axXn2rfKmp0vVv+rMI3gw/o1up13M
	 /NeplTUHcLIA2q9SC5r177CWJjJ1UphXYmDmd0Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong2@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 661/770] nfsd: use DEFINE_SHOW_ATTRIBUTE to define nfsd_reply_cache_stats_fops
Date: Tue, 18 Jun 2024 14:38:34 +0200
Message-ID: <20240618123432.800359337@linuxfoundation.org>
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

[ Upstream commit 64776611a06322b99386f8dfe3b3ba1aa0347a38 ]

Use DEFINE_SHOW_ATTRIBUTE helper macro to simplify the code.

nfsd_net is converted from seq_file->file instead of seq_file->private in
nfsd_reply_cache_stats_show().

Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
[ cel: reduce line length ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/cache.h    |  2 +-
 fs/nfsd/nfscache.c | 13 +++----------
 fs/nfsd/nfsctl.c   | 10 +++-------
 3 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/fs/nfsd/cache.h b/fs/nfsd/cache.h
index 65c331f75e9c7..f21259ead64bb 100644
--- a/fs/nfsd/cache.h
+++ b/fs/nfsd/cache.h
@@ -84,6 +84,6 @@ int	nfsd_reply_cache_init(struct nfsd_net *);
 void	nfsd_reply_cache_shutdown(struct nfsd_net *);
 int	nfsd_cache_lookup(struct svc_rqst *);
 void	nfsd_cache_update(struct svc_rqst *, int, __be32 *);
-int	nfsd_reply_cache_stats_open(struct inode *, struct file *);
+int	nfsd_reply_cache_stats_show(struct seq_file *m, void *v);
 
 #endif /* NFSCACHE_H */
diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 7da88bdc0d6c3..2b5417e06d80d 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -603,9 +603,10 @@ nfsd_cache_append(struct svc_rqst *rqstp, struct kvec *data)
  * scraping this file for info should test the labels to ensure they're
  * getting the correct field.
  */
-static int nfsd_reply_cache_stats_show(struct seq_file *m, void *v)
+int nfsd_reply_cache_stats_show(struct seq_file *m, void *v)
 {
-	struct nfsd_net *nn = m->private;
+	struct nfsd_net *nn = net_generic(file_inode(m->file)->i_sb->s_fs_info,
+					  nfsd_net_id);
 
 	seq_printf(m, "max entries:           %u\n", nn->max_drc_entries);
 	seq_printf(m, "num entries:           %u\n",
@@ -625,11 +626,3 @@ static int nfsd_reply_cache_stats_show(struct seq_file *m, void *v)
 	seq_printf(m, "cachesize at longest:  %u\n", nn->longest_chain_cachesize);
 	return 0;
 }
-
-int nfsd_reply_cache_stats_open(struct inode *inode, struct file *file)
-{
-	struct nfsd_net *nn = net_generic(file_inode(file)->i_sb->s_fs_info,
-								nfsd_net_id);
-
-	return single_open(file, nfsd_reply_cache_stats_show, nn);
-}
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 3ed0cfdb0c0b5..1983f4f2908d9 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -204,12 +204,7 @@ static const struct file_operations pool_stats_operations = {
 	.release	= nfsd_pool_stats_release,
 };
 
-static const struct file_operations reply_cache_stats_operations = {
-	.open		= nfsd_reply_cache_stats_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(nfsd_reply_cache_stats);
 
 static const struct file_operations filecache_ops = {
 	.open		= nfsd_file_cache_stats_open,
@@ -1354,7 +1349,8 @@ static int nfsd_fill_super(struct super_block *sb, struct fs_context *fc)
 		[NFSD_Threads] = {"threads", &transaction_ops, S_IWUSR|S_IRUSR},
 		[NFSD_Pool_Threads] = {"pool_threads", &transaction_ops, S_IWUSR|S_IRUSR},
 		[NFSD_Pool_Stats] = {"pool_stats", &pool_stats_operations, S_IRUGO},
-		[NFSD_Reply_Cache_Stats] = {"reply_cache_stats", &reply_cache_stats_operations, S_IRUGO},
+		[NFSD_Reply_Cache_Stats] = {"reply_cache_stats",
+					&nfsd_reply_cache_stats_fops, S_IRUGO},
 		[NFSD_Versions] = {"versions", &transaction_ops, S_IWUSR|S_IRUSR},
 		[NFSD_Ports] = {"portlist", &transaction_ops, S_IWUSR|S_IRUGO},
 		[NFSD_MaxBlkSize] = {"max_block_size", &transaction_ops, S_IWUSR|S_IRUGO},
-- 
2.43.0



