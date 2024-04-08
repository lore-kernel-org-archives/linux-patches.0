Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5150D6EB72;
	Mon,  8 Apr 2024 13:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584492; cv=none; b=ddcNnjoMEkXIJbMYioFOt8GqN8nrBt+4Sm0ppESUpERYqapyInQRShxacr8K98xs5Q1b/FqlwJ2SRpvWRihHtzFqSgJn6ZZ0mTGIzZ9wZ6kxahJAjGjqJ6v5BZZLxdZ84n2TynQQB8Gk+qcK9xGMRTvtDAytPJTlilx2yn2y00k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584492; c=relaxed/simple;
	bh=mnaHmAmavgIIfnM5v6jo5p+4e0vBnibZexgcVXsIk4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQwrSySSTiawLU6vDfnFBuyNaOeYoIjyoytBX4gKkJdvmp9WeQafFVudNgLpyyMUdKX2/WNSkFWij/h8PRR45iTiBTh2o+VKLXqgr5Ibe6E3ZmpZVOvCz98GCMI9ohUngkcts/n3WqrzP6D5Ba/J3juKlAusGzQadh/AO1jrpkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWCeeWi0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWCeeWi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F28C433F1;
	Mon,  8 Apr 2024 13:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584492;
	bh=mnaHmAmavgIIfnM5v6jo5p+4e0vBnibZexgcVXsIk4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWCeeWi02r4PlHOGqyGmEdW2kFqFAvWRkFJqCXrXtjORRVe1/cey2r5w+U8OIVdG5
	 R4nRedvZDLyk6faDy3Rf9eUEONbMR1Nh4LXl/7LOyJb1pzles4UrGi6kDVBwi6r0Yg
	 g5Jw+Zx+GwQ7dlmxGGTIY1IVWloOb47NkSw+9sos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong2@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 449/690] nfsd: use DEFINE_SHOW_ATTRIBUTE to define nfsd_file_cache_stats_fops
Date: Mon,  8 Apr 2024 14:55:15 +0200
Message-ID: <20240408125415.914143299@linuxfoundation.org>
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

[ Upstream commit 1342f9dd3fc219089deeb2620f6790f19b4129b1 ]

Use DEFINE_SHOW_ATTRIBUTE helper macro to simplify the code.

Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 7 +------
 fs/nfsd/filecache.h | 2 +-
 fs/nfsd/nfsctl.c    | 9 ++-------
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 55478d411e5a0..fa8e1546e0206 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1211,7 +1211,7 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
  * scraping this file for info should test the labels to ensure they're
  * getting the correct field.
  */
-static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
+int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
 	unsigned long releases = 0, pages_flushed = 0, evictions = 0;
 	unsigned long hits = 0, acquisitions = 0;
@@ -1258,8 +1258,3 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	seq_printf(m, "pages flushed: %lu\n", pages_flushed);
 	return 0;
 }
-
-int nfsd_file_cache_stats_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, nfsd_file_cache_stats_show, NULL);
-}
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 8e8c0c47d67df..357832bac736b 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -60,5 +60,5 @@ __be32 nfsd_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		  unsigned int may_flags, struct nfsd_file **nfp);
 __be32 nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		  unsigned int may_flags, struct nfsd_file **nfp);
-int	nfsd_file_cache_stats_open(struct inode *, struct file *);
+int nfsd_file_cache_stats_show(struct seq_file *m, void *v);
 #endif /* _FS_NFSD_FILECACHE_H */
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 1983f4f2908d9..6a29bcfc93909 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -206,12 +206,7 @@ static const struct file_operations pool_stats_operations = {
 
 DEFINE_SHOW_ATTRIBUTE(nfsd_reply_cache_stats);
 
-static const struct file_operations filecache_ops = {
-	.open		= nfsd_file_cache_stats_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(nfsd_file_cache_stats);
 
 /*----------------------------------------------------------------------------*/
 /*
@@ -1355,7 +1350,7 @@ static int nfsd_fill_super(struct super_block *sb, struct fs_context *fc)
 		[NFSD_Ports] = {"portlist", &transaction_ops, S_IWUSR|S_IRUGO},
 		[NFSD_MaxBlkSize] = {"max_block_size", &transaction_ops, S_IWUSR|S_IRUGO},
 		[NFSD_MaxConnections] = {"max_connections", &transaction_ops, S_IWUSR|S_IRUGO},
-		[NFSD_Filecache] = {"filecache", &filecache_ops, S_IRUGO},
+		[NFSD_Filecache] = {"filecache", &nfsd_file_cache_stats_fops, S_IRUGO},
 #if defined(CONFIG_SUNRPC_GSS) || defined(CONFIG_SUNRPC_GSS_MODULE)
 		[NFSD_SupportedEnctypes] = {"supported_krb5_enctypes",
 					&supported_enctypes_fops, S_IRUGO},
-- 
2.43.0



