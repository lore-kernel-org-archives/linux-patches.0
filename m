Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021475;
	b=afuTMqJCyVzFtN1XlG7DD2JDSNlS6ebOgI3FvhIe/EeDfdV/W8DVxX8M1BcKAPsAuTXD
	 Oqe4LcdvUOjGRdh+nwvqXC6S0dAFZ0fRNPbP3ScUzEoyVU/dOUVcZfrSp5ky58yXx29hF
	 fImrfbqGyVY/wT1z9sMRJ92hmz3sY8IFWgU4cd7bgxV2YAmk3F0CXuZvTTO27S1dDNOAH
	 gE5+nm9KSQADr93ZxWj5qXOFDoe69YRxAnkRziAFQ143igYKdohdR25rFTtBgAbqdAbzl
	 VN2Vt0NeyU1NVj8iSNEmwJACYcJKGKn2zrVXTg9MaLripUP2JA0o2CAlIvw2YfRJ0dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y0an7wUHy3oYoP6jW1lM4E4FjwfXYDF3sIlUzp2cRCo=;
	b=WU2mE/vAYLal6v2eyrY0YLOffqf2LouWrkSInSlFkpsY6mh9WFMwgHFMp9ONpVP2XZwH
	 an7CixFkrSb3MQbf+u+6OBbDQTgEj0uNz+FKf5bblZ8SIGm0ikIEGyiNw7quA8jxN5fCa
	 Aq4YjKZOk16j1W1FPnf8o9l5OZj1M4ufXglMsiPzqrrYncEoWChfxwpTAOn9SeLxwFG+P
	 ohAM5R2hY2fkRZSLzSSssn6Fqs5cHFyAmiRxh7coA0vmm9B4T2kUJZGpXrXORRFazzKzH
	 9Nkmbg0LrOG+dUl1V2SbrYeIx2Uk4oge7mf+Y5/onyB8cyXXQ5Iv0b/a8uZoxi7+hgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vwVt24Ht;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F66D60A260A;
	Wed, 18 Nov 2026 17:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vwVt24Ht
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFE41F000C4;
	Wed, 18 Nov 2026 17:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021474;
	bh=y0an7wUHy3oYoP6jW1lM4E4FjwfXYDF3sIlUzp2cRCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vwVt24Hto5i+tHm64q79EsQaB425SsnJTbJ+DeSJEqQdAYlKMTcFBYb4dd7k2mS3d
	 Y55gaYJ5V50UkX5E+w1NUZY7sChAJMko9kF3u4aRb4VUpqJGSYXqcOhGiw4ldNbTn9
	 ZX/yJl9kMSiRyG25OZHBRrmF40uEayeuePDWz3Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2279/2651] exfat: take bitmap_lock at the start of exfat_alloc_cluster()
Date: Wed, 18 Nov 2026 15:58:39 +0100
Message-ID: <20261118150407.362728406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chi Zhiling <chizhiling@kylinos.cn>

[ Upstream commit 48acff2eedef7fecdfbd39be1b6f4463a9e43e3e ]

exfat_alloc_cluster() checks sbi->used_clusters against the total
number of data clusters before acquiring sbi->bitmap_lock. A concurrent
allocation can update sbi->used_clusters after the check but before
the lock is acquired, making the check stale. This can allow the
allocation to proceed even though there are not enough free clusters,
causing it to fail partway through.

Acquire sbi->bitmap_lock before checking sbi->used_clusters so that
the free-space check and subsequent cluster allocation are serialized
with concurrent allocations.

Fixes: f55c096f62f1 ("exfat: do not zero the extended part")
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/fatent.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index a6728c3612899..3c8bdc131f6f3 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -427,19 +427,22 @@ int exfat_alloc_cluster(struct inode *inode, unsigned int num_alloc,
 	struct super_block *sb = inode->i_sb;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
+	mutex_lock(&sbi->bitmap_lock);
+
 	total_cnt = EXFAT_DATA_CLUSTER_COUNT(sbi);
 
 	if (unlikely(total_cnt < sbi->used_clusters)) {
 		exfat_fs_error_ratelimit(sb,
 			"%s: invalid used clusters(t:%u,u:%u)\n",
 			__func__, total_cnt, sbi->used_clusters);
-		return -EIO;
+		ret = -EIO;
+		goto unlock;
 	}
 
-	if (num_alloc > total_cnt - sbi->used_clusters)
-		return -ENOSPC;
-
-	mutex_lock(&sbi->bitmap_lock);
+	if (num_alloc > total_cnt - sbi->used_clusters) {
+		ret = -ENOSPC;
+		goto unlock;
+	}
 
 	hint_clu = p_chain->dir;
 	/* find new cluster */
@@ -516,8 +519,8 @@ int exfat_alloc_cluster(struct inode *inode, unsigned int num_alloc,
 		if (p_chain->size == num_alloc) {
 done:
 			sbi->clu_srch_ptr = hint_clu;
-			mutex_unlock(&sbi->bitmap_lock);
-			return 0;
+			ret = 0;
+			goto unlock;
 		}
 
 		hint_clu = new_clu + 1;
-- 
2.53.0



