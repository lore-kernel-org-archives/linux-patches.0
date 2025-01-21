Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66F11F7552;
	Tue, 21 Jan 2025 18:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482818; cv=none; b=fCVxZs9EKJQB167artr1r1ksgo0fRe92FZqXE2KpEePV7CVVCmeyyxuBhq7m70xFac/1AK/Nx/mZ2wFjFcApBvEdbtdmUNoDqLN/9Sby9mjvqKiS+tPiarzdxFeuzegtc3gVIjqPTlrtQNCASn3VSwhANNuSAb+QS7BAg54VpZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482818; c=relaxed/simple;
	bh=ZEK6D5mMPArTG9DI9GKcWcwVi0tH8TvzRGgHlxgAMNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEirCoxlmw6WQsRRAsP2NYJ3wfms6W5CPCwiEWl8RHrrBtErvgHfd5jmiipTGS7liE3Isg6UJX13Kb+ZWAC7DSe9LPDJ9zGB226haP55z0683b6ZaOFbre0VvKz0yb3G8yfsCCNewwby3R4fU1ekXPoCa56rATxHovI2w7HqMcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qM0D54oO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qM0D54oO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD11C4CEE3;
	Tue, 21 Jan 2025 18:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482817;
	bh=ZEK6D5mMPArTG9DI9GKcWcwVi0tH8TvzRGgHlxgAMNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qM0D54oOObTykmFbVMX4Yw5AE1mqgjyQfYnfQ+nVqOIDmNZ7jokz5wjSRj0dfJlnQ
	 6m7iTH2xXIa8rxMnbC0Ka1H/a4UX6a0hIpgQ6ceUxdrQ9uW/44Fp5Vq1EaKoykXU7b
	 wjoC54cKIdl/dyeCrM4da06cqirQP2RcRsUang5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/127] drm/mediatek: Add support for 180-degree rotation in the display driver
Date: Tue, 21 Jan 2025 18:51:31 +0100
Message-ID: <20250121174530.414242005@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c54d56fb7b4c..77397bf0b5b4 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
@@ -302,6 +302,7 @@ void mtk_ovl_layer_config(struct device *dev, unsigned int idx,
 	unsigned int addr = pending->addr;
 	unsigned int pitch = pending->pitch & 0xffff;
 	unsigned int fmt = pending->format;
+	unsigned int rotation = pending->rotation;
 	unsigned int offset = (pending->y << 16) | pending->x;
 	unsigned int src_size = (pending->height << 16) | pending->width;
 	unsigned int con;
@@ -315,12 +316,19 @@ void mtk_ovl_layer_config(struct device *dev, unsigned int idx,
 	if (state->base.fb && state->base.fb->format->has_alpha)
 		con |= OVL_CON_AEN | OVL_CON_ALPHA;
 
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



