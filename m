Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030118;
	b=sfysDp9v9ufg9NZHCwVYJqYq0zfftTa6DKx/Xa06rB5u4nqOIgupLKGL+ChRywm4vWWG
	 K2oJgOqx+SaMKId6DG5GM6a2PYFWW0+wAinMdeaudySttjvvZpXijG8N23bxsFrt1LMvc
	 WD5/CcAjteBhfzls0+ekFY7X+6EjH9i/VROutbHUcp5fvECZP6c40V92t6C8JergkC6c+
	 KuQ8w0lyczM5IV0/Xd8Jn8p0+4N3VQd0LdN8kBTA80jNYsvJ2HzAB0cxPNEfkyEnq4PVG
	 SD3rIBizVyOKlqPf/Cgvs/+0wyukvr5foKt6CfzM8crwjD6qXJmZgVaewuNo2E+vCNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZaohOgf8iCSzB3NiAZCu89vGNtYQ3J2iPm6UYFR2eYo=;
	b=XmqHldg2PXYzh+cd3oIiStPP3H3yaT6VzIbrZ0VBlhF+WX1a5KxCE6Cog1GFryV/X/Sw
	 uwrM94a4gFbO4DyERNrAUp9BOoGfTX5kgVEUu7fGTEilULY9kvIXe6ZD5k6FrSt+TGhyz
	 v6QT27HV6CWdx1fE1OJp8aiGdSzFxESCOxN+jZQOY09JqdvaHl5Fe2N623PH2H6Fs9z1O
	 4HAyd8TEz5xnEVNwKRKkYPI3J6VxR6qtl/S4s8Bti8ctlKrOlOJm26RKdXep4kwSo6/Xv
	 /SC+UCF6PbYEPHvQRHbtis1c5o8jCFNROCVlH/GAA1s+LBnAIxEj0BzjZym26GL/CyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0igLx+/k";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498D460712AB;
	Wed, 18 Nov 2026 19:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0igLx+/k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7C31F000CE;
	Wed, 18 Nov 2026 19:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030118;
	bh=ZaohOgf8iCSzB3NiAZCu89vGNtYQ3J2iPm6UYFR2eYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0igLx+/krEE7QB4jyaWjFEDGA7R2yv2vAKsKqMqLeA19DJsV0eu3Deu/VUUFIC2G0
	 +ziXg662S/hA6g1v1wGB6PHqTsTJCpszcn1u+ujBAMD1aMLINlWnv/czACEt6/j5Og
	 ndJXUSxX7ffBL0i+s4/B8hIXCinBvOUj3oi5vb08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Tejun Heo <tj@kernel.org>,
	Xin Yin <yinxin.x@bytedance.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0590/1756] writeback: size foreign flushes by target wb dirty pages
Date: Wed, 18 Nov 2026 15:45:17 +0100
Message-ID: <20261118150032.496742065@linuxfoundation.org>
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
index 3b67018191df1..c195c97717396 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1146,7 +1146,7 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 	struct cgroup_subsys_state *memcg_css;
 	struct bdi_writeback *wb;
 	struct wb_writeback_work *work;
-	unsigned long dirty;
+	long dirty;
 	int ret;
 
 	/* lookup bdi and memcg */
@@ -1175,16 +1175,13 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
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



