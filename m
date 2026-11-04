Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829676;
	b=STC7Y12D/R/WVG7waNli3MCZh5AJ8FiG4/t1iDrjd5hFgHD9/kC4PS+bJMJ0qWIrrcLk
	 gBbTK/zjwjyuLoTwjQ9hrix3iwrE7+yYowPCAQteGu2FNNeyvlfxzapD3lZ/oRyD45TVe
	 td9SpdIFsbGRHVnApnvcro01T9Kfr9Mcla1/AgmkAbUMKGgCjevZ3YBqO/k9e9hvxFj9X
	 oBUV7c1QSdNz6XXSfT/Umkil/vI6pZTtKSWe6f3oweuxI+SiPmiHkndJMqdomSwIdrGM0
	 vw3A8WZhIQDobrRIr2n+I+Tu2a4MKPCK5b3o8d0pwfx1OGhMPpkgrjeIngJHVhoPTDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sgizFHzBoFEiZeW6m5KRCDQAg/hGo3rM051wPVzAtZQ=;
	b=d4M/AEkBMbzKeQlLmB2XrAyRDB7mKDyxB5cl/mJxXm6SioEfIT0fxUvSCim4fvxZHiMO
	 5hUErllbE5QKPOCzSs4kqPv9147el7w2fYV2/QJ6h8ESp1PFakmHrv+rtOsd7bOPp2fMh
	 70BIYEMLpS5HQuwISqCOuRMQNa0dQHi7A4MG/B+x5HRYyb8sdM8isONjnJE34HIzV25DL
	 NHXtGXjAI0v2O6uph75FMwphbr3yxMNpsjwidhLLLg9R5z1HlkAiNSb9GOX+CMmx3Ty0Y
	 i4eCdDHL4C/jhHC5VVVrwN01dRjIXKhBHxIETT3ANZAV85FsYSxiGp/X04wlO31lYmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIkhjK6u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F07B60C29B3;
	Wed,  4 Nov 2026 22:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIkhjK6u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E176D1F000C1;
	Wed,  4 Nov 2026 22:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829676;
	bh=sgizFHzBoFEiZeW6m5KRCDQAg/hGo3rM051wPVzAtZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIkhjK6uVDoX5UeFXujWISRxoGbBJ+TGcrMXU6kDwS+qZiKXTDggaURhmAEioq/WW
	 AJAOfyqbEQWFXWjglC8n6WfNjwj8DxQwuii5J8Nu5oeC/1CErfgFwxdmvOg9U4SdAK
	 M3iCT/YWPNY9pkGCum8RyliPCoT6lrJCg9bxfwHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0274/1005] exfat: clean up new entry on add entry failure
Date: Wed,  4 Nov 2026 16:00:07 -0500
Message-ID: <20261104211051.558237978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 06bed867b46ad..9fe6635c60a42 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -476,6 +476,7 @@ static int exfat_add_entry(struct inode *inode, const char *path,
 	struct exfat_entry_set_cache es;
 	int clu_size = 0;
 	unsigned int start_clu = EXFAT_FREE_CLUSTER;
+	bool dir_allocated = false;
 
 	ret = exfat_resolve_path(inode, path, &uniname);
 	if (ret)
@@ -502,6 +503,7 @@ static int exfat_add_entry(struct inode *inode, const char *path,
 		}
 		start_clu = clu.dir;
 		clu_size = sbi->cluster_size;
+		dir_allocated = true;
 	}
 
 	/* update the directory entry */
@@ -512,8 +514,21 @@ static int exfat_add_entry(struct inode *inode, const char *path,
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
 
 	info->entry = dentry;
 	info->flags = ALLOC_NO_FAT_CHAIN;
-- 
2.53.0



