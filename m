Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD6618801C;
	Tue, 30 Jul 2024 16:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358319; cv=none; b=H+haY4jJb6Uh/aQkq95P3B+l6lnPML9+AtGZlYmHZMCZRxQSFX2aMluSDJP2JFt0UgCx3kDNJdnVRkJNFNiq4V3VdLqzZv33bfKCE1cZMaG8bJdpAp2ZeZl1FeVOG1N7cU52UjfFyyHYMo1ssH570SivyNHSA+Lp5htX1vAGw60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358319; c=relaxed/simple;
	bh=r0pcj4sOrjLIp7XW4OTEQCYt0chtG3YmPErpmuc/RRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdAvLOJ0ou9Cf6HgTOKDFJSr08d4jNRF8syh9yf0WC+zL+OPjar67OpEaT87DoiGjoOYv5Tde/djyGwVMMU39uuh5wCgTu8OHDTrhfxQESOQlkMR3N/HI7Xz4+SgDdFo9UR46/eybJJiJN9f4u9KvLHGnfv/JcNvdxXXb/ntwic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CeSOpmQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CeSOpmQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B4FC32782;
	Tue, 30 Jul 2024 16:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358319;
	bh=r0pcj4sOrjLIp7XW4OTEQCYt0chtG3YmPErpmuc/RRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeSOpmQkc6a2bs61Lc5HJXagxqykWWL1IZeSJ0BxBP/Yj0LjZ/RWiDYmOrvEnN/HM
	 XCsibEPD9QChoddyXBf/f/LyS/EgSOVpvdTQx7Hz/8Kxw9+fuhoszyWBRsOrtYxhod
	 rI0wYuci9qxMu1xaRgCvl9/Fh1pCF8N6Bq7o2s4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 327/809] drm/mediatek: Fix XRGB setting error in Mixer
Date: Tue, 30 Jul 2024 17:43:23 +0200
Message-ID: <20240730151737.535931974@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsiao Chien Sung <shawn.sung@mediatek.com>

[ Upstream commit 8e418bee401b7cfd0bc40d187afea2c6b08b44ec ]

Although the alpha channel in XRGB formats can be ignored, ALPHA_CON
must be configured accordingly when using XRGB formats or it will still
affects CRC generation.

Fixes: d886c0009bd0 ("drm/mediatek: Add ETHDR support for MT8195")
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hsiao Chien Sung <shawn.sung@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240620-igt-v3-4-a9d62d2e2c7e@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_ethdr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_ethdr.c b/drivers/gpu/drm/mediatek/mtk_ethdr.c
index d7d16482c9473..5c52e514ae301 100644
--- a/drivers/gpu/drm/mediatek/mtk_ethdr.c
+++ b/drivers/gpu/drm/mediatek/mtk_ethdr.c
@@ -153,6 +153,7 @@ void mtk_ethdr_layer_config(struct device *dev, unsigned int idx,
 	unsigned int offset = (pending->x & 1) << 31 | pending->y << 16 | pending->x;
 	unsigned int align_width = ALIGN_DOWN(pending->width, 2);
 	unsigned int alpha_con = 0;
+	bool replace_src_a = false;
 
 	dev_dbg(dev, "%s+ idx:%d", __func__, idx);
 
@@ -167,7 +168,15 @@ void mtk_ethdr_layer_config(struct device *dev, unsigned int idx,
 	if (state->base.fb && state->base.fb->format->has_alpha)
 		alpha_con = MIXER_ALPHA_AEN | MIXER_ALPHA;
 
-	mtk_mmsys_mixer_in_config(priv->mmsys_dev, idx + 1, alpha_con ? false : true,
+	if (state->base.fb && !state->base.fb->format->has_alpha) {
+		/*
+		 * Mixer doesn't support CONST_BLD mode,
+		 * use a trick to make the output equivalent
+		 */
+		replace_src_a = true;
+	}
+
+	mtk_mmsys_mixer_in_config(priv->mmsys_dev, idx + 1, replace_src_a,
 				  MIXER_ALPHA,
 				  pending->x & 1 ? MIXER_INX_MODE_EVEN_EXTEND :
 				  MIXER_INX_MODE_BYPASS, align_width / 2 - 1, cmdq_pkt);
-- 
2.43.0



