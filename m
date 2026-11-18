Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024601;
	b=d6et87urrQWMolDY/BoVwdkQ8Gj01CIdvcyPuTxn+ptkYRkbNeNjeZF/OzIXXvRj4mL5
	 o8+H6xqHEwqYa7xtKLxebQ1KuSGrdQOYMBkehgw0L4PgBD3LEZrkn+NE1108tzS/glb33
	 Fao7h7ryXsVrzW8KUayFsokYGTckO9eijft7LvTFBB3JbK2dh7p2+2xYHLSS268YOM0sA
	 goSjNjjWeiGz1iMJlNLPu0du+9ykSjrAAXFB946RzjgDVH32+S5aDLn+1ImdR9MXywgv+
	 ardHE38M3fXGl2lTMyso3TZraVCRHwCTCteZ5fsNU2FLWX6A3pUKpCkRarWaXos2hYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WhRiICYgvh2nA8GdW2eeYQHOT05qWK3QBJtxnpe3RZM=;
	b=h6dq37yr+8zgCResK/ToldWn5XWTy9aKreK8/87Lb1mtp4ZkOL+6fP0R22Usw7bU3tDr
	 cGTZNOscOQfUr7u0t4ctlldgopde47jXad4sUhIBb+gi127qiSM3t1WSabvokwYETOxr/
	 8FTqBR7/DZFbQPvt9P7ex5ue6ehL1soypnHWlk1HOjLjSdTBDKq31QedS2oDPUmS4nvwx
	 26Ubt7W3VtritvX3IPlbb6LUi+3Le1UD9+vPCw2oP3ypz25AgHaYvSO/qvX/xhmMu2zqT
	 /urKjw1pbH1kwQq8FmiNmFFhoj7VXGQ3a7mNkwHmNB7H/fjNVt9hjSzKAxIesZWHlEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dYGf6EJq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0088B606A320;
	Wed, 18 Nov 2026 17:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dYGf6EJq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE241F000C4;
	Wed, 18 Nov 2026 17:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024600;
	bh=WhRiICYgvh2nA8GdW2eeYQHOT05qWK3QBJtxnpe3RZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dYGf6EJqKMytzIaT+fIc06LZw2cc5vSOhQD0EPMc1klPakLMZr+Lh0ZNZZ4VezOc4
	 RQyeb11LyL5JVd8qOZAWZCbk0rvLveYfExsP0MWUkdqkLdn4imC5P0KXwl1CQgiwvc
	 Fq7s2mr8zKvqsnl085RiFTyjJTtlbhi9SZfUqCR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Tejun Heo <tj@kernel.org>,
	Xin Yin <yinxin.x@bytedance.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0742/2151] writeback: size foreign flushes by target wb dirty pages
Date: Wed, 18 Nov 2026 15:41:17 +0100
Message-ID: <20261118150149.068169257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Xin Yin <yinxin.x@bytedance.com>

[ Upstream commit 168a8c13159c6e3f0f08da6f8fa2f633a91ba9fd ]

Foreign dirty tracking records the bdi and wb memcg IDs of recently
dirtied foreign inodes. When the source memcg needs foreign writeback,
mem_cgroup_flush_foreign() queues WB_REASON_FOREIGN_FLUSH to the
recorded target bdi_writeback.

cgroup_writeback_by_id() currently sizes this best-effort work from the
target memcg's NR_FILE_DIRTY counter. The work is scoped to one target
wb, so a memcg-wide dirty count can over-size a single-bdi flush when
the target memcg has dirty pages on other devices. It can also under-size
the flush when the target wb has dirty pages charged to other memcgs.

Over-sizing keeps the target wb busy longer and can delay later
writeback work. Under-sizing can finish before enough pages are written
back for the source memcg.

Use the target wb's WB_RECLAIMABLE counter and keep the existing 25%
headroom. This keeps the budget aligned with the writeback object being
queued.

Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Link: https://patch.msgid.link/20260924065443.1650126-1-yinxin.x@bytedance.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e479e310f92c6..a390cb6b14c6f 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1166,7 +1166,7 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 	struct cgroup_subsys_state *memcg_css;
 	struct bdi_writeback *wb;
 	struct wb_writeback_work *work;
-	unsigned long dirty;
+	long dirty;
 	int ret;
 
 	/* lookup bdi and memcg */
@@ -1195,16 +1195,13 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 	}
 
 	/*
-	 * The caller is attempting to write out most of
-	 * the currently dirty pages.  Let's take the current dirty page
-	 * count and inflate it by 25% which should be large enough to
-	 * flush out most dirty pages while avoiding getting livelocked by
-	 * concurrent dirtiers.
-	 *
-	 * BTW the memcg stats are flushed periodically and this is best-effort
-	 * estimation, so some potential error is ok.
+	 * The caller is attempting to write out most of the target wb's
+	 * currently dirty pages.  Size the work from the wb's reclaimable pages
+	 * and inflate the count by 25%, which should be large enough to flush
+	 * out most dirty pages while avoiding getting livelocked by concurrent
+	 * dirtiers.
 	 */
-	dirty = memcg_page_state(mem_cgroup_from_css(memcg_css), NR_FILE_DIRTY);
+	dirty = wb_stat_sum(wb, WB_RECLAIMABLE);
 	dirty = dirty * 10 / 8;
 
 	/* issue the writeback work */
-- 
2.53.0



