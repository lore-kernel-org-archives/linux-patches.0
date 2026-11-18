Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017372;
	b=blyQtzgn2lCrjstbid0HwNZGsTYmxrCW01i0aOdhzyigDbEaoWTFZa/rHVHCabsVvUb4
	 lIH4TI9IA/yVWaBSD4stO18rPpRH7XXh1J29Cg/PCvSqjGhyRn4ZEjnp9aaM97yt3bydT
	 gCPBEEcrsi8ckmycfFsvGf5LRLcp1YbUv+VtPWtOzTtTaVjdQWK7sB+4XLPsuG/2cfZxw
	 VfSe8RtfNdec+JXEPTMa/0YmZiYf9rQTbGhLamD6m597BOSV9f3ROKgcXYqkl5AAxjfcp
	 WKSGenZ9EDRU6k74SC/sAzOaYP0ht2ajOvRy+HsdM2DWRha2gYU4PGvlyu/wDxuLVGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=isTNeOet1S1ryW1vQ6ZomYiXjzeJl37zdVWAXJaRuwA=;
	b=jS+nYHnoMXyzdE87x/9dyutUgvKc5F1GwhTFunySWED2/ji2Bh98Qteliapxz4ETxWs0
	 HJM08ZuaCF3u9Tzm0GVkxQ+p0GV41CcwlpicQl/AgvEnOedscgpHJo1YEns2698fVxnMX
	 h4HikCqhx0jZ5x1UrrgcCUStFxUOamdO9RLiiguX0VZ0rUAXSEy4HTntpALSxHSzBia+Y
	 SolkCM4kZaKop3W9517B3KcWaJYDa4zICinP/R0gNfwglwYxSR3s+h7+V5El1BblxBZaC
	 JISC3LpgIlY3UoY/42i9A219yRMIM1nQxJNH965xIozStDsuQs/J9COtqQtUdACASqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P1CZ0Zl5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0CD606A320;
	Wed, 18 Nov 2026 15:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P1CZ0Zl5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2E51F000C4;
	Wed, 18 Nov 2026 15:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017372;
	bh=isTNeOet1S1ryW1vQ6ZomYiXjzeJl37zdVWAXJaRuwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P1CZ0Zl5sBq0VsjLoRXaLn3FPrvHL/QaBnHWsllbXACf2ERKWYsf4lG8vOSc0waCI
	 nlmK7Ex/j3HGfTCErlH1dj2QBwQ5qWgKo6XsHAlJGOWT4fJqxR2I7pbj9xeeXHGvyu
	 n4Iwy43DLQVlaiIt4v8BSA/H/v7YoIQ3mj2uV2/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Tejun Heo <tj@kernel.org>,
	Xin Yin <yinxin.x@bytedance.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0860/2651] writeback: size foreign flushes by target wb dirty pages
Date: Wed, 18 Nov 2026 15:35:00 +0100
Message-ID: <20261118150318.822377461@linuxfoundation.org>
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
index e2ee11119518c..0a8839a8863ec 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1190,7 +1190,7 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 	struct cgroup_subsys_state *memcg_css;
 	struct bdi_writeback *wb;
 	struct wb_writeback_work *work;
-	unsigned long dirty;
+	long dirty;
 	int ret;
 
 	/* lookup bdi and memcg */
@@ -1219,16 +1219,13 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
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



