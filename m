Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6531A619B;
	Tue, 30 Jul 2024 16:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357053; cv=none; b=iFZ6v7AZiErsDYQ3LEPWvKsLzQGi4kyDK9qS/1lkH2Mx705PP4TdkUe05xYPtntrClL2+45ji84/FrZNbkh2m2BmOGpKcz59cjFstdkM5smcSYZMCBO8/G2JYGmwxSqA4sMIaaxMjvS5Uc2RfqCHctCbXmpvogE4u/sSgEP9XU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357053; c=relaxed/simple;
	bh=/lsUdpE1I3TfOGjBL1t/BDQfHKyKJTsdiApDYp0PYjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmI4lVaoXRR+HvNV0J2m8+J2Ey2vPjK6je+dJnXIpCT88Cw7J9cgTR0y18wDEpnqzx+zg3stwF4xScYo4ZShV2we0XkbnbFqr/yhF8gGUwW2PFe84gtWhsVAvLWdEsIpRIqL2MbfkE0rUA3A0YKr2gudtfLoxvBOuPyg2V4H8Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gYb6jFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gYb6jFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8254FC4AF0A;
	Tue, 30 Jul 2024 16:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357053;
	bh=/lsUdpE1I3TfOGjBL1t/BDQfHKyKJTsdiApDYp0PYjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gYb6jFzk90wAn1u8VcshPN28xKTKofqxEiu2Qb9P6sWMHRwfM318Vj5RAojRG9/a
	 aUqrPRHMOdPQ0OcQ4SZ8mhWOMfFAQTOu54u8A9LvcbM2N2Hvh66/pJpLSHU7saAupB
	 HzHNfIfRgkPfH9o6BnMHWF2RLIorX2NEs2k4r1K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/568] drm/mediatek: Add missing plane settings when async update
Date: Tue, 30 Jul 2024 17:45:20 +0200
Message-ID: <20240730151648.198357395@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ddc9355b06d51..f10d4cc6c2234 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_plane.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_plane.c
@@ -227,6 +227,8 @@ static void mtk_plane_atomic_async_update(struct drm_plane *plane,
 	plane->state->src_y = new_state->src_y;
 	plane->state->src_h = new_state->src_h;
 	plane->state->src_w = new_state->src_w;
+	plane->state->dst.x1 = new_state->dst.x1;
+	plane->state->dst.y1 = new_state->dst.y1;
 
 	mtk_plane_update_new_state(new_state, new_plane_state);
 	swap(plane->state->fb, new_state->fb);
-- 
2.43.0



