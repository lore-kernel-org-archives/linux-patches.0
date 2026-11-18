Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028533;
	b=Wr8Q9APqizBsZISSK577zAsv8/Vs4tosz2IVd4NNZuSK0WdmAhVHi21YuDrp/dcJXj1D
	 pxqe7uKKP+VcKm3taFZfRyGKm+YByDguE0xFYNdxmHh6VV17iGlfshE70lZgivO3w5sX5
	 G/IDkzqal04igneonosCMkhi9NsyxG8hLuY2Fr4Qk6O/Paga+NzvQVu0IgfLuDtr4la7w
	 IAciCCheOf+zAeVvQAj5H1ZIkjtGE5zQNBBwWO5miHwm2saRRnhbRz1yQJFNlmSojxHdO
	 iATIF2CsR80hOZh8rx99TopgdZm9NaWcDD6/v/Yy8yXPcx7z9O1I2c3BpYM9FCHgUKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4hM8oYGTDylNRUCI+TYSEneRGXMyScGemGXlrmEWVFQ=;
	b=IuL1re+7aqAa55+OCZua/Nai06M187r98r6ru+MQJS1vlRJB5SAO8eLdIqop6PF3aUMQ
	 2nrwX/UHFI/1nyWVzG5sKt/6dwOWyCjJIJt9dRukR8lp2UX6OwY8iLv4HiyMUgEaFH5Dm
	 XxAjqdox7aiaJNfj9sIvmu4bfJkJ41sV/xdCBtCXNAo7oRw9QV4dHThX4aa1VST+Ts8Kh
	 NQkBbfIpGsA5NWGP6bRWn1I8Jqd/lJkIMf7vfMAyzwHzq0yDsfyJGZxSBkhoWn0p9jgq4
	 y06eFX/IPilIiCPfKBO66HjTLkYGLL6IZWC+5ne2fq5a5gZVgekQxnv8b9DQ4UdgLlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ac3FsMOz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFB9606A31C;
	Wed, 18 Nov 2026 19:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ac3FsMOz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534311F000C4;
	Wed, 18 Nov 2026 19:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028532;
	bh=4hM8oYGTDylNRUCI+TYSEneRGXMyScGemGXlrmEWVFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ac3FsMOzCTJYkKLuSg/tB8cRVc5kc9BGdSPVxqteaJDQS/hiAIlLiVsV1cV4eYUlv
	 0lTYNVf97Ev2h0pzcFOmM/7kcFOQ4Wzk7uatJurF8DvaMauKEGjMumHvbUBiE+C0Ib
	 OEp9P2XlhSmtmT09wMxVRtkHXj9GqQz0jd27nZeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0030/1756] f2fs: fix to fetch ino via ino_of_node() under cache lock
Date: Wed, 18 Nov 2026 15:35:57 +0100
Message-ID: <20261118150009.071769021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit cd6d8b1891395b681f2060916a4b83880b765698 ]

In f2fs_writeback_node_caches(), it's better to fetch ino via ino_of_node()
under cache lock, otherwise, node cache content may become stale after cache
is unlocked due to racing w/ truncation.

Commit 493b9dc8b52c ("f2fs: cache: use node cache") fixes similar issue in
f2fs_flush_inline_data() introduced in commit 34c061ad85a2 ("f2fs: Avoid double
lock for cp_rwsem during checkpoint").

Cc: stable@kernel.org
Fixes: 2049d4fcb057 ("f2fs: avoid multiple node page writes due to inline_data")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: adapted node cache access in f2fs_writeback_node_caches() to page access in f2fs_sync_node_pages() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 231a9281968e4..c5ea13cdb2e8e 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2100,9 +2100,11 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
 
 			/* flush inline_data */
 			if (page_private_inline(page)) {
+				nid_t ino = ino_of_node(page);
+
 				clear_page_private_inline(page);
 				unlock_page(page);
-				flush_inline_data(sbi, ino_of_node(page));
+				flush_inline_data(sbi, ino);
 				goto lock_node;
 			}
 
-- 
2.53.0



