Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216231;
	b=b3wu309JTcUWJoBajfXTTlQRMTc/x/x5wyjc/M1ZgSIMwwO8betk/A5suakYoRZXLQ6+
	 8Khq1BIZ/nUEykx7maLEI1PFykBAUK00fmghe/g0etM+SePFbLWTLSy+i1VDHVrtooLd7
	 QR+4IjwxiZL2ajvXafEgmlaoV03E30hCN4MasQoXPQzXNwL3VvC6ZbN9ABZBMLmENAAuQ
	 LpHkERVQ8O8Mq9RCtv/rsib4Axg/Tey/1eY6+bF375zZU5fX5x9uQnL2YEGnI1n7gNqsp
	 9g9FC0GGd4FHs6IFU4MoHD7k/toS7ih1v9ODpzJ3LCQx+4/OfXCLBLMbSm+OQdwjs8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SxtzKafWG5gxv5BrF0YwQJ+Iv0HI2T+xQF+gAjLTEis=;
	b=FVIXTsSowySGUG5VzN32/x1RSbqdHhj572ePQ5mD3NBrzfwZoq5mnCR3GK18iqqtig1i
	 jLzD4fDJp/fd+F8hQgxApxO+Zsg9bLBBikEZWJ4mski4OOQhQb4sT2Nn0iqnNPHUVFiqO
	 nx8r/ZLxzQegRETV+0YCiq9OpSPPsYeCpprvFGjE7G0QMVReHaZs8wbd2Tm8GTZKa7CXO
	 0ikvbDo6SVwkZnpAZyDn1XAEBgmCZJ6WyY2OW1hLlkZJTokuUaaAK0LKtC+PjcHd6BDWX
	 vJc9GGwbvCaJaCLsDumQlRrfBsC9iY0u6L7UMwDO0GFe6EtIgERN+rLlJgpQ+FC7MqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNYwYmcS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E9B60A2610;
	Wed, 28 Oct 2026 19:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNYwYmcS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4283A1F031E0;
	Wed, 28 Oct 2026 19:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216230;
	bh=SxtzKafWG5gxv5BrF0YwQJ+Iv0HI2T+xQF+gAjLTEis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNYwYmcS+wVl+M6IozGO3Fx8YD7oFC4ZujGvJ7AHkCSQnK2nYOYRM59HFaNFYqDAz
	 qxZmsO3fl6iRB/pnvc1h0H1Y8j3Vc5R6bAXV4aVKqQeUg9agUswJrSaYcScZ+biZu/
	 otOU+7YBbxCYopK4duk4apbVuPgTMsUshX22A9+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1486/1887] f2fs: fix to migrate all curseg types during free_segment_range
Date: Wed, 28 Oct 2026 17:59:42 +0100
Message-ID: <20261028170533.266703778@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 8ec06f50ddd8d201bd7e55b896ae28ed9d4cb7d1 ]

In free_segment_range(), the curseg evacuation loop only iterates up to
NR_CURSEG_PERSIST_TYPE (0..5), missing non-persistent in-memory curseg
types such as CURSEG_COLD_DATA_PINNED and CURSEG_ALL_DATA_ATGC.

Even though these in-memory curseg types are not saved in the on-disk
checkpoint header, they still occupy active physical segments at runtime.
If an active in-memory curseg happens to be allocated within the segment
range being truncated during filesystem shrink, failing to evacuate it
will cause subsequent writes to the curseg attempting out-of-bounds I/O
on the truncated storage range.

Fix this by expanding the curseg evacuation loop upper bound to
NR_CURSEG_TYPE to ensure all active curseg types are safely migrated
out of the target range.

Fixes: d0b9e42ab615 ("f2fs: introduce inmem curseg")
Cc: stable@vger.kernel.org
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Sunmin Jeong <s_min.jeong@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 771e38aaeba32..2df6a5b503508 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2017,7 +2017,7 @@ static int free_segment_range(struct f2fs_sb_info *sbi,
 	mutex_unlock(&DIRTY_I(sbi)->seglist_lock);
 
 	/* Move out cursegs from the target range */
-	for (type = CURSEG_HOT_DATA; type < NR_CURSEG_PERSIST_TYPE; type++)
+	for (type = CURSEG_HOT_DATA; type < NR_CURSEG_TYPE; type++)
 		f2fs_allocate_segment_for_resize(sbi, type, start, end);
 
 	/* do GC to move out valid blocks in the range */
-- 
2.53.0



