Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060839;
	b=cvdh7r9by55AyTTzkDlums1ebxsIHm1pJzLeLxjX1PRGM/W+WS5TMG/IgzEH09zgnE+0
	 /dvnde/6wgg7Tc9pmyYnl3smJd/+1ZhuKRJSsIIRMeu7+uecaXUxzWUYBTiuXPZhkwLKc
	 Gr8FvUQMgC3dhKNGjFpGENRUoVvfJutRDrzKdveMR07YlEweTwb3/A0lCeMKJUR5th8Up
	 Wf1KAWQSe6CCPQJ7oyivYaNDIP0mQn7mfezuCqiB2LzQCs95CIjg//Xk+OjnaVpQm3Ie0
	 Z8qVcL3Kd9bKcUbE/vzgoJMWt6EqUv/FQY8jjRgXI87ELRcm+AkGx8zLzElXH/1silA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2/IBqaQSieYLxnzc8yYp4v5RUWWzbVGaqiIuEbQ9ZTg=;
	b=WklG4d13bvf5I0hqLUaHHJbrkxj0mjQ4jI+c1wzcAo/sBPam76xEBt5w4Ms87YCdeUwG
	 q8X7EJiq80wzYqVwmc35fwD9hEK68/CME2RlXsDd19e4HjXj/bN9BM9Ly/MfvRYmt1nLJ
	 o+85jrVHEnGAnE0Dz4bSEgY/C8RHZy5RyNvp+GKMzlWOgg4pnAXSNNWzy8AhXqJuO3m/U
	 MR/pkkrwTfg/FQS5bvDQfjfwgl0uqlldHq0zeW6+aruin/GECmFzOaycX5tTWjVyTkD94
	 qpyNPRcRm+gO8bNc8YOON2ytWRWmJgUPyd5iD8t6fYVxDv/s3G36zptJVt3rECDP4xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPnphAqK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCD2606A33E;
	Sat,  7 Nov 2026 14:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPnphAqK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773C41F0089F;
	Sat,  7 Nov 2026 14:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060837;
	bh=2/IBqaQSieYLxnzc8yYp4v5RUWWzbVGaqiIuEbQ9ZTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPnphAqKxJODK6d1XYlvC+AoRQkDItq7PoUMjLWhV/xgZ8NFF8m9DG28+Ef9N4PVm
	 VZyrvXqQXRc/B9OJ5C+OgSIcODGdAaAuLuSu2OM3Npp0agw7fbyva0ZCPZm0avdwxJ
	 QzRq+X9uQFckeNOvtB/1i/jYZ5J6VaqCQPNWv5QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0228/1536] exfat: clean up new entry on add entry failure
Date: Sat,  7 Nov 2026 08:37:24 -0500
Message-ID: <20261107135004.074263696@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 0901a71e8cff5c60dd464529cba2ed30a2ab0a3f ]

exfat_add_entry() initializes a new directory entry set before writing it
with exfat_put_dentry_set().  If the write fails, mkdir/create returns an
error but a partially written entry may be left behind.

For non-zero-size directories, the failure also happens after a cluster
has been allocated for the new directory.  Clean up the new entry
best-effort, and free the newly allocated directory cluster only when the
cleanup writeback succeeds.  This avoids freeing a cluster that may still
be referenced by an on-disk entry if the cleanup fails.

Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/namei.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 80acb54531126..d6e910ed7f41d 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -465,6 +465,7 @@ static int exfat_add_entry(struct inode *inode, const char *path,
 	struct exfat_entry_set_cache es;
 	int clu_size = 0;
 	unsigned int start_clu = EXFAT_FREE_CLUSTER;
+	bool dir_allocated = false;
 
 	ret = exfat_resolve_path(inode, path, &uniname);
 	if (ret)
@@ -491,6 +492,7 @@ static int exfat_add_entry(struct inode *inode, const char *path,
 		}
 		start_clu = clu.dir;
 		clu_size = sbi->cluster_size;
+		dir_allocated = true;
 	}
 
 	/* update the directory entry */
@@ -501,8 +503,21 @@ static int exfat_add_entry(struct inode *inode, const char *path,
 	exfat_init_ext_entry(&es, num_entries, &uniname, NULL, 0);
 
 	ret = exfat_put_dentry_set(&es, IS_DIRSYNC(inode));
-	if (ret)
+	if (ret) {
+		int cleanup_ret;
+
+		cleanup_ret = exfat_get_dentry_set(&es, sb, &info->dir,
+						   dentry, ES_ALL_ENTRIES);
+		if (!cleanup_ret) {
+			exfat_remove_entries(inode, &es, ES_IDX_FILE, false);
+			cleanup_ret = exfat_put_dentry_set(&es,
+							   IS_DIRSYNC(inode));
+		}
+
+		if (!cleanup_ret && dir_allocated)
+			exfat_free_cluster(inode, &clu);
 		goto out;
+	}
 
 	info->dir = *p_dir;
 	info->entry = dentry;
-- 
2.53.0



