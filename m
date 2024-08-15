Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BF019EED4;
	Thu, 15 Aug 2024 13:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729541; cv=none; b=a1wqreVtR5BZ/Fbx6JYRKZfUOy0wh551hlZiC0yGfqT+EjiNeIndA67Mlt6GnZmeUfGSMw+93ddl4Aq8gVGRQYoHsT90jgTBiwqG5e6gurxFs/7QzTFJNBaJzBiU4y5PwMM+1rj+BS4u6SN0HydLAwY7haosm7LTzC8LX9MhMUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729541; c=relaxed/simple;
	bh=ZM0PIkfew87m+GB2/tVf1+Y9xhHXJkmwqnMfqjaTOwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npxhKw6PvKzDLQ6jwgAxB4Ntg1i6Ctm/k4vR1UGlj/0TV5xhD6o696fWsn5MSScUISHfbOcfWFEAzSTzsE+u2KDPI3KQTOXQl8ay0by1YvI3VFa8xRtF4ACBlVgV8u9LX+y/SXX9aC36rSVy9CrrYr+uVV5fnUsyEpjXQzQPBIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWVJTuOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWVJTuOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D74AC32786;
	Thu, 15 Aug 2024 13:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729541;
	bh=ZM0PIkfew87m+GB2/tVf1+Y9xhHXJkmwqnMfqjaTOwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWVJTuOCU39f/EnM1SQg46a6szsowKhk078TC9AEDRBP8BXgbkETQatixYc6gxiiH
	 r7OJhYydKTc7FTHzPpEtI+4i+S5O/R6gRCw+zg+oj2+mFiDWqMdBN662mixjTs6EI5
	 qaMuK0NhMFm7zNK7igi5Tk+Ztkg7IrC9VbzXSfyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/484] drm/mediatek: Add missing plane settings when async update
Date: Thu, 15 Aug 2024 15:19:17 +0200
Message-ID: <20240815131945.115425132@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsiao Chien Sung <shawn.sung@mediatek.com>

[ Upstream commit 86b89dc669c400576dc23aa923bcf302f99e8e3a ]

Fix an issue that plane coordinate was not saved when
calling async update.

Fixes: 920fffcc8912 ("drm/mediatek: update cursors by using async atomic update")

Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Hsiao Chien Sung <shawn.sung@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240620-igt-v3-1-a9d62d2e2c7e@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_plane.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_plane.c b/drivers/gpu/drm/mediatek/mtk_drm_plane.c
index eda072a3bf9ae..a9fa510d9a684 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_plane.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_plane.c
@@ -154,6 +154,8 @@ static void mtk_plane_atomic_async_update(struct drm_plane *plane,
 	plane->state->src_y = new_state->src_y;
 	plane->state->src_h = new_state->src_h;
 	plane->state->src_w = new_state->src_w;
+	plane->state->dst.x1 = new_state->dst.x1;
+	plane->state->dst.y1 = new_state->dst.y1;
 
 	mtk_plane_update_new_state(new_state, new_plane_state);
 	swap(plane->state->fb, new_state->fb);
-- 
2.43.0



