Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E0F1898FC;
	Tue, 30 Jul 2024 16:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356048; cv=none; b=XsCYU4zWORWb4N+YMKFcmWidX9CpsXlk2QvvnAq09kLi9coOhXX0UQlOg7+MyNakTryt0FhxGFoqnSngVqBwsbmmHz4xiN4NvO56vHXXXItzz0Vid4nXS79CIL77oxI4QrTrhzV9YvgfoDT1/mk3CAR1vgI7Yk4pT0UFanZJ6Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356048; c=relaxed/simple;
	bh=p2xmmSjKtik08TrzsBdGo/l3B3sz3rfnM0axNA8Lgfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqZGSKFfxxARgCbXjQ7lF5VMM8X8+KhnNYQMhSwbwf3q6EEbLD0OBtmTsLIiinr9O4K/h19uEgGVVSHvEtzTa1qg4aHFLeT/udD9KFuHkIl3OuTc2FQO1nZFJf5t+SYawleeyVLuF1aUrS18/ib30/dFF8BuRixrt1+4ja8qUx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KD/q8TJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KD/q8TJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB647C32782;
	Tue, 30 Jul 2024 16:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356048;
	bh=p2xmmSjKtik08TrzsBdGo/l3B3sz3rfnM0axNA8Lgfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KD/q8TJnvDdeWrIfKdOJ5iYZ6WAgmeBET/exdRjBgTU3InF04BPGFEW0CZRifPXmU
	 Br3xdcXk+SLQS2hI6clcKPQtKurL8763f1qyM9zOdY4sNkcmu53iZDRaQqJEAjAOJ/
	 zYc/k5fjDiI0NPZZ6yIY/WQflpHy5reECLIn06Rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/440] drm/mediatek: Add missing plane settings when async update
Date: Tue, 30 Jul 2024 17:46:24 +0200
Message-ID: <20240730151621.778393037@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c4a0203d17e38..30d361671aa9c 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_plane.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_plane.c
@@ -157,6 +157,8 @@ static void mtk_plane_atomic_async_update(struct drm_plane *plane,
 	plane->state->src_y = new_state->src_y;
 	plane->state->src_h = new_state->src_h;
 	plane->state->src_w = new_state->src_w;
+	plane->state->dst.x1 = new_state->dst.x1;
+	plane->state->dst.y1 = new_state->dst.y1;
 
 	mtk_plane_update_new_state(new_state, new_plane_state);
 	swap(plane->state->fb, new_state->fb);
-- 
2.43.0



