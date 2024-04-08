Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95B474438;
	Mon,  8 Apr 2024 13:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584465; cv=none; b=pb+A01A0ezoARWaOWUmI/RBDVf4bBUSI31/ev+yF11XAVOxCk0pU0ZdMUYyWESmEVKgjzZSNPZnaQjEXqQ0Au2j71o9p1qADNy7yY/ROx+TJCIW87hSTnwtECanfds0FFuUThdOUmrDknghv/S3C+SBQXJYvfO31HgDEgOPlPZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584465; c=relaxed/simple;
	bh=6qUVCdzn6nfwJTG/qVv4BUYceqGFbJpDW2TTAriusZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KflQTJ8tYkjJCn4aqF01p4MDSgagtJ46PX75kX2rWWy4/F2iV6BC6xK5b2wQ2E56rWWSsVbX2koH2H3pA4KGtjamnsV7o/LDTEivl+kaKkHeX9T+sZGekaMD9CvHJttTYSp0vi+vuWhja7P5SUD1a/VbhVZGcJqdfOyEhOKTyCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LlsIVYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LlsIVYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58788C433C7;
	Mon,  8 Apr 2024 13:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584465;
	bh=6qUVCdzn6nfwJTG/qVv4BUYceqGFbJpDW2TTAriusZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LlsIVYDk+RNex6dMyf+ySb7iSiPATFMK9RLpf+pPT08TtxjQk1+iI3q1giyJ3qfu
	 FpGZNU83Lk7tER7CrWUBHbmvmpFY9Qke/XpkJN0aZnYl6WzIX7J4R1+zvwstqPpRxw
	 VTHzvyIwlUmON3mPnJtYuHrpWIx8Vgy761ZzAl1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong2@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 446/690] nfsd: use DEFINE_SHOW_ATTRIBUTE to define export_features_fops and supported_enctypes_fops
Date: Mon,  8 Apr 2024 14:55:12 +0200
Message-ID: <20240408125415.808899572@linuxfoundation.org>
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

[ Upstream commit 9beeaab8e05d353d709103cafa1941714b4d5d94 ]

Use DEFINE_SHOW_ATTRIBUTE helper macro to simplify the code.

Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
[ cel: reduce line length ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsctl.c | 29 +++++------------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 597a26ad4183f..3ed0cfdb0c0b5 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -185,17 +185,7 @@ static int export_features_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int export_features_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, export_features_show, NULL);
-}
-
-static const struct file_operations export_features_operations = {
-	.open		= export_features_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(export_features);
 
 #if defined(CONFIG_SUNRPC_GSS) || defined(CONFIG_SUNRPC_GSS_MODULE)
 static int supported_enctypes_show(struct seq_file *m, void *v)
@@ -204,17 +194,7 @@ static int supported_enctypes_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int supported_enctypes_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, supported_enctypes_show, NULL);
-}
-
-static const struct file_operations supported_enctypes_ops = {
-	.open		= supported_enctypes_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(supported_enctypes);
 #endif /* CONFIG_SUNRPC_GSS or CONFIG_SUNRPC_GSS_MODULE */
 
 static const struct file_operations pool_stats_operations = {
@@ -1365,7 +1345,7 @@ static int nfsd_fill_super(struct super_block *sb, struct fs_context *fc)
 		/* Per-export io stats use same ops as exports file */
 		[NFSD_Export_Stats] = {"export_stats", &exports_nfsd_operations, S_IRUGO},
 		[NFSD_Export_features] = {"export_features",
-					&export_features_operations, S_IRUGO},
+					&export_features_fops, S_IRUGO},
 		[NFSD_FO_UnlockIP] = {"unlock_ip",
 					&transaction_ops, S_IWUSR|S_IRUSR},
 		[NFSD_FO_UnlockFS] = {"unlock_filesystem",
@@ -1381,7 +1361,8 @@ static int nfsd_fill_super(struct super_block *sb, struct fs_context *fc)
 		[NFSD_MaxConnections] = {"max_connections", &transaction_ops, S_IWUSR|S_IRUGO},
 		[NFSD_Filecache] = {"filecache", &filecache_ops, S_IRUGO},
 #if defined(CONFIG_SUNRPC_GSS) || defined(CONFIG_SUNRPC_GSS_MODULE)
-		[NFSD_SupportedEnctypes] = {"supported_krb5_enctypes", &supported_enctypes_ops, S_IRUGO},
+		[NFSD_SupportedEnctypes] = {"supported_krb5_enctypes",
+					&supported_enctypes_fops, S_IRUGO},
 #endif /* CONFIG_SUNRPC_GSS or CONFIG_SUNRPC_GSS_MODULE */
 #ifdef CONFIG_NFSD_V4
 		[NFSD_Leasetime] = {"nfsv4leasetime", &transaction_ops, S_IWUSR|S_IRUSR},
-- 
2.43.0



