Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A965248BB2;
	Wed, 15 Jan 2025 10:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938123; cv=none; b=F2vF12wkpQEuJogQ1dKXnY3BfKBQAKjUyqYInXPvvUlefWPnhqwJlxkv+DR8MuSZPnDQhd6mfu1XOr5FKXEZNhAi5B1okHbgYm5FJrCOwdhh4pCnVHjGapPmfxMpbRRzz8ZTfHcTcBgyy3/vSkIX5VMrF6FLL5vIEqZ/A3xaeRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938123; c=relaxed/simple;
	bh=96JDjjfffRb8VsjAn7f1DO86IGf0bfjk95OxvSUDZFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJ+4AsDgohP/gN/pHuvXIunoJuhbKDEXFmSVsnh/deQlcHqjO8sPa08Pi0boGYsz6Ea8Z3h9p6Nv/fHkM4AZ1ciO0qLzVrpWDHeCCFZKrw504sRQdeGk/9IzovEJ9IWbKOwT5WeRIp5HR0VpDmpO9FSju24jP8xyNQRhxi9O7M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2Lygcb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2Lygcb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F21C4CEDF;
	Wed, 15 Jan 2025 10:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938122;
	bh=96JDjjfffRb8VsjAn7f1DO86IGf0bfjk95OxvSUDZFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2Lygcb+rMYqPm1lcBxLCl2Gg8h8xXGZbAs+gOsJFhKeqYQHhhZGyc/UuJsR7tXPJ
	 Lu/TC8TLTJlzOoY4rdqguooIklQErUFtjHnHBO2X09o7JePo4XcxomwTGaSxFO5BCl
	 qj8oJcVlpKhvyaRRkuQiD+TFnOr1jaj5qwWww1uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/189] drm/mediatek: Add support for 180-degree rotation in the display driver
Date: Wed, 15 Jan 2025 11:35:58 +0100
Message-ID: <20250115103608.831352520@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason-JH.Lin <jason-jh.lin@mediatek.com>

[ Upstream commit 5c9d7e79ba154e8e1f0bfdeb7b495f454c1a3eba ]

mediatek-drm driver reported the capability of 180-degree rotation by
adding `DRM_MODE_ROTATE_180` to the plane property, as flip-x combined
with flip-y equals a 180-degree rotation. However, we did not handle
the rotation property in the driver and lead to rotation issues.

Fixes: 74608d8feefd ("drm/mediatek: Add DRM_MODE_ROTATE_0 to rotation property")
Signed-off-by: Jason-JH.Lin <jason-jh.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20241118025126.30808-1-jason-jh.lin@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
index e0c0bb01f65a..a3091bfcbd43 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
@@ -471,6 +471,7 @@ void mtk_ovl_layer_config(struct device *dev, unsigned int idx,
 	unsigned int pitch = pending->pitch;
 	unsigned int hdr_pitch = pending->hdr_pitch;
 	unsigned int fmt = pending->format;
+	unsigned int rotation = pending->rotation;
 	unsigned int offset = (pending->y << 16) | pending->x;
 	unsigned int src_size = (pending->height << 16) | pending->width;
 	unsigned int blend_mode = state->base.pixel_blend_mode;
@@ -513,12 +514,19 @@ void mtk_ovl_layer_config(struct device *dev, unsigned int idx,
 			ignore_pixel_alpha = OVL_CONST_BLEND;
 	}
 
-	if (pending->rotation & DRM_MODE_REFLECT_Y) {
+	/*
+	 * Treat rotate 180 as flip x + flip y, and XOR the original rotation value
+	 * to flip x + flip y to support both in the same time.
+	 */
+	if (rotation & DRM_MODE_ROTATE_180)
+		rotation ^= DRM_MODE_REFLECT_X | DRM_MODE_REFLECT_Y;
+
+	if (rotation & DRM_MODE_REFLECT_Y) {
 		con |= OVL_CON_VIRT_FLIP;
 		addr += (pending->height - 1) * pending->pitch;
 	}
 
-	if (pending->rotation & DRM_MODE_REFLECT_X) {
+	if (rotation & DRM_MODE_REFLECT_X) {
 		con |= OVL_CON_HORZ_FLIP;
 		addr += pending->pitch - 1;
 	}
-- 
2.39.5



