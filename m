Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021138;
	b=goEdtVkMisiB/Sla1cHE5TpvXUL4w91ci6bvh+VJ+uylkMXsUjzKqWUjk6SvL5rF3qzk
	 dfuvtqHZd8g8Mxh3EWMwCfk+vcGAeViygvn2PFhAotr3of9fitEVMXwifX1u+Sp0D+76e
	 P3T896tylXwvlOYlP9JbdIUH8mR4L60DdwiaB43DJn9aVvAZX2ETTDiEFPxibbAv7yQ2K
	 NSYBxgsyKf1wKLHhy4OXbR9CaK6bccqpkQBW0nMbL40Sdd4XGtAoW4mjtCu5+ptyTHaBe
	 gjIXd8o90qERpTlLhVH/6Q2ppOMauFl2afjT1ONycfoLLqUrmHCjWGAuLOgLcfMtCFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TryxOI0Jawcwj9lT0EbY/tA1goCbCUI/M+QjTGEXVy4=;
	b=oqDBQ0YWVKOUNPZ8DKGqQm97igonxY+rCQlYoQ1aRKkRXD5T1J4NqeocQQljAKemme8g
	 wBu0PkqVTOd6lNrcllEAocz5Pil3jqyzWNH0GY3gGDyZreheLBvbty2PtoxihMPiXelbC
	 QTPkE5AP5S3YAf60ejzuxYMeVjE+aNZd33vuyMdjcncnYLmE3+7mKJUdfSzDhSSNWoTNE
	 JaH0uafZZLqRzgo3yo4mbXfDf7MByyaCjESenjadOr/Jd/tCPYM3gOxiBtsJ/HcC46xGV
	 w3zlJmVBJkQ2WS1SihGMO59LHnmCdweIEH6oxEi92OTJ2nUGKbR1ZL1s8EzZsq0Y/8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nwy1eXnM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A0F606A325;
	Wed, 18 Nov 2026 16:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nwy1eXnM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662701F000C4;
	Wed, 18 Nov 2026 16:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021137;
	bh=TryxOI0Jawcwj9lT0EbY/tA1goCbCUI/M+QjTGEXVy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nwy1eXnMBb3UEXSTl/lR9gd7QmWhhSWaCbV8qbNymYA8hsCL4hJHhaeCLQf4Rcn9R
	 GpiPMbbj11hvHVM8ykXIlElS8pkfvNFl0TntSn6YLEsI9Ory/mumpv1x5Lvd5HAu2x
	 dN96yNjLqxHedonRGSRCr8RMXy8LeHDmSBiKjbSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	=?UTF-8?q?Marek=20Weso=C5=82owski?= <marek@wesolowski.eu.org>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2201/2651] ntfs: fix FITRIM bitmap indexing for large pages
Date: Wed, 18 Nov 2026 15:57:21 +0100
Message-ID: <20261118150404.936717981@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 055a8d19788f16d27f07e6ac40155460e3d227b3 ]

The LCN bitmap has one bit per cluster, so a bitmap page represents
PAGE_SIZE * 8 clusters. ntfs_trim_fs() still used a 15-bit shift when
selecting the page. On arm64 with 16 KiB pages this selects the wrong
bitmap page and can test or discard the wrong clusters.

Compute bitmap indices from buf_clusters, use the page cluster base as
the bit-search origin, and keep the requested range as the clipping
boundary.

Fixes: 11ccc9107dc4 ("ntfs: update runlist handling and cluster allocator")
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Marek Wesołowski <marek@wesolowski.eu.org>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/bitmap.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/ntfs/bitmap.c b/fs/ntfs/bitmap.c
index 5a4457551306d..912fdcca8e011 100644
--- a/fs/ntfs/bitmap.c
+++ b/fs/ntfs/bitmap.c
@@ -20,7 +20,7 @@ int ntfs_trim_fs(struct ntfs_volume *vol, struct fstrim_range *range)
 	struct folio *folio;
 	unsigned long *bitmap;
 	char *kaddr;
-	u64 end, trimmed = 0, start_buf, end_buf, end_cluster;
+	u64 end, trimmed = 0, start_buf, end_buf, end_cluster, page_cluster;
 	u64 start_cluster = ntfs_bytes_to_cluster(vol, range->start);
 	u32 dq = bdev_discard_granularity(vol->sb->s_bdev);
 	int ret = 0;
@@ -45,8 +45,8 @@ int ntfs_trim_fs(struct ntfs_volume *vol, struct fstrim_range *range)
 		return -ENOMEM;
 
 	buf_clusters = PAGE_SIZE * 8;
-	start_index = start_cluster >> 15;
-	end_index = (end_cluster + buf_clusters - 1) >> 15;
+	start_index = start_cluster / buf_clusters;
+	end_index = DIV_ROUND_UP_ULL(end_cluster, buf_clusters);
 
 	for (index = start_index; index < end_index; index++) {
 		folio = ntfs_get_locked_folio(vol->lcnbmp_ino->i_mapping,
@@ -59,19 +59,20 @@ int ntfs_trim_fs(struct ntfs_volume *vol, struct fstrim_range *range)
 		kaddr = kmap_local_folio(folio, 0);
 		bitmap = (unsigned long *)kaddr;
 
-		start_buf = max_t(u64, index * buf_clusters, start_cluster);
-		end_buf = min_t(u64, (index + 1) * buf_clusters, end_cluster);
+		page_cluster = (u64)index * buf_clusters;
+		start_buf = max_t(u64, page_cluster, start_cluster);
+		end_buf = min_t(u64, page_cluster + buf_clusters, end_cluster);
 
 		end = start_buf;
 		while (end < end_buf) {
 			u64 aligned_start, aligned_end, aligned_count;
-			u64 start = find_next_zero_bit(bitmap, end_buf - start_buf,
-					end - start_buf) + start_buf;
+			u64 start = find_next_zero_bit(bitmap, end_buf - page_cluster,
+					end - page_cluster) + page_cluster;
 			if (start >= end_buf)
 				break;
 
-			end = find_next_bit(bitmap, end_buf - start_buf,
-					start - start_buf) + start_buf;
+			end = find_next_bit(bitmap, end_buf - page_cluster,
+					start - page_cluster) + page_cluster;
 
 			aligned_start = ALIGN(ntfs_cluster_to_bytes(vol, start), dq);
 			aligned_end = ALIGN_DOWN(ntfs_cluster_to_bytes(vol, end), dq);
-- 
2.53.0



