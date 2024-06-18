Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC391A8C3A;
	Tue, 18 Jun 2024 13:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716474; cv=none; b=HuKIf1wpg0nkW/VPwhlEbvBx+FFvKuGq+o2delTsKqE0/X1TGR6uBnDr89uE5G6topIDyZoo8GInBfu3sghWA1ED55jHp6oJxpkqMjTpq8BIaJ10nzcNwzbe5dFSZD53OTJZdOog/WJ63KIUUvzftOAKATfCQ0csaROeEyOFOI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716474; c=relaxed/simple;
	bh=24tTfgf8lDLLSD3OsN4nWXqGaNODO7AtrKSDOfyxMQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K11AlizA8ekwiShijx/LjMP2o9wQUeQPpfz2yyxEhsNpiUU/fZ3swMjz3L4VyhrhIj6rS/l+dAxZu4xFovE9196vHhCNva/t2UsJlUO9be/djO25PMI8blBk0ZWby/8rMMX7oLKNLtGobyMxcGY5TYCv0xK3Ot4QfoU1ETPNcE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FALwAY/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FALwAY/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5883C3277B;
	Tue, 18 Jun 2024 13:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716473;
	bh=24tTfgf8lDLLSD3OsN4nWXqGaNODO7AtrKSDOfyxMQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FALwAY/VmAUdhSk5414t3nvJrDsdmdeH+dOmCRSeb7m+Ai2ZHXhDGcydkky2pF0bv
	 R/8RyjoPZH/S2Kke+NJr3He/dnfd5JiquCsl+E+LqEV9Y8nJ6NdKh8SxVVCgIEWSZA
	 0JNoAxQQlku/jkPHAuUC8ctSBPDJrAoWOCGdWNq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong2@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 659/770] nfsd: use DEFINE_SHOW_ATTRIBUTE to define export_features_fops and supported_enctypes_fops
Date: Tue, 18 Jun 2024 14:38:32 +0200
Message-ID: <20240618123432.723506672@linuxfoundation.org>
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

[ Upstream commit 9beeaab8e05d353d709103cafa1941714b4d5d94 ]

Use DEFINE_SHOW_ATTRIBUTE helper macro to simplify the code.

Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
[ cel: reduce line length ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



