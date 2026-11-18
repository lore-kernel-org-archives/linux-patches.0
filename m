Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038737;
	b=4EhPrCC8z1mrfmUfzw3rWM8iGx09PaFsc+tshweRMRYpgKjTlZivuhZsm2nkXt9K2qT3
	 2Pdiy4Ke99pUuKc7rPG83RixMV0t4sogITxcPbYK2SzdNHQCqXTus8L2h7EkIv2aKlCph
	 h0lasbhfNbFNnbZ40ebgYIkANFgYql6yCXfZLK5y1OJxH0ZrTNnKoM25gq8P8yBPKu8AQ
	 JzN8QvmGZYyNTbiV8IYlUbqBb0St5pvQuHLjtPcCcHl7n3kc4Ya7vQOQE2g8RLt62uvww
	 lDvDOEq+yuI5dDSN6yca97qPx6kxVK1VZoH7MdhryEkwRDbZc/VPOrKLx9LOAVblWig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Io7IV4xNjN42ztqWU8RbL1LO3OAkqcPqFrKx1tGwl9Y=;
	b=bbn38YXGsuvl72kNtLXhY6ZHIvJSvJFzJdVCz0EmLCAuzY3A+r78L5KHY0da+oZWmwMX
	 YvrG3Q+0bl46kbTJTk4Xp9cOQgHOG5HekyEbCAeoWmc3WuZK7OIlZaQHR6iuT4Xmb3kax
	 wr51+MC/aUMV40jwdTDExTbJ8iWVxOgL2GENx0h/v4a9dIgOG7In7vuxuK8jrsLGy1rh+
	 gpfjSzIMGW+ekxRdfAYE6w5BwuP7XopBj/u2B23Eopij2iyPXHX+GaB3sVZNyGxnY93J/
	 PbII0ZCnWqSuxXFL/p4f+uC6OMjknoaRJrXpG0l7eCkFqyfKOk7cateUvC6Ur9GROqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5qoLo3h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F261606A325;
	Wed, 18 Nov 2026 21:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5qoLo3h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE19D1F000C4;
	Wed, 18 Nov 2026 21:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038737;
	bh=Io7IV4xNjN42ztqWU8RbL1LO3OAkqcPqFrKx1tGwl9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5qoLo3hRpluiX6Up7+EKmUzJa9EFFkI/NNdgoRagVfLZB9GWmNvhlDNKjrUmyzUG
	 tAjP3+2RZY/ydPM2Kl4d5Paxvj1oOhBBccSg4Ot4h1eK4hvuxTdlKp43HyhV/1oP1P
	 V6yA8JtAHYaP8WsM0zETru47Tqib1vIYSGhidhXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1849/3318] f2fs: Fix not used variable index
Date: Wed, 18 Nov 2026 15:41:11 +0100
Message-ID: <20261118150417.336517480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit 0c3a38a4b442893f8baca72e44a2a27d52d6cc75 ]

Fix the following compilation warning:
fs/f2fs/data.c:2391:10: warning: variable ‘index’ set but not used
[-Wunused-but-set-variable]
 2391 |  pgoff_t index;

Only define and set the variable index when the CONFIG_F2FS_FS_COMPRESSION
is enabled.

Fixes: db92e6c729d8 ("f2fs: convert f2fs_mpage_readpages() to use folio")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 29c371a04b300..8c8d7980f1952 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2392,10 +2392,10 @@ static int f2fs_mpage_readpages(struct inode *inode,
 		.nr_cpages = 0,
 	};
 	pgoff_t nc_cluster_idx = NULL_CLUSTER;
+	pgoff_t index;
 #endif
 	unsigned nr_pages = rac ? readahead_count(rac) : 1;
 	unsigned max_nr_pages = nr_pages;
-	pgoff_t index;
 	int ret = 0;
 
 	map.m_pblk = 0;
@@ -2413,9 +2413,9 @@ static int f2fs_mpage_readpages(struct inode *inode,
 			prefetchw(&folio->flags);
 		}
 
+#ifdef CONFIG_F2FS_FS_COMPRESSION
 		index = folio_index(folio);
 
-#ifdef CONFIG_F2FS_FS_COMPRESSION
 		if (!f2fs_compressed_file(inode))
 			goto read_single_page;
 
-- 
2.53.0



