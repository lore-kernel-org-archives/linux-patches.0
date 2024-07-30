Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4B11A6199;
	Tue, 30 Jul 2024 16:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357117; cv=none; b=mJ8b7enJ6rTpll8TTLGfGrxfwqRAMKfsxYggSjxR9IbEEa8X2PkqUyp4LbWkOQ7FeIZWbJhh2WrVNLMzUJ/1av0D2awm/ziPEosZ5mwx74MarsiTsCNCjYeWQ4wwDiKObTi0pXahIIyoeKrSln01PZqXMT+vuPhfHqKqrmlPtrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357117; c=relaxed/simple;
	bh=kmW5esy0vqcDUsRkFhTmFh8m/MlYmLf3tErrkRWjwCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYAgmVnSaKpGx6PVJwKb8M9PmIMn1PHAa4Ogt1yA1SMoTz3NZI+FH5s/jT6hWS63gW+Kep1jbi8bUEQ5wE9PcM75sXkJK0sfteLm955psKCclp5oF1gqo+Sdi3hTUl/NFphiNiEXsSE20yKDH9zLOnSwgpitD+9YAP6vXFNCIiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0poXODIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0poXODIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9405CC32782;
	Tue, 30 Jul 2024 16:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357117;
	bh=kmW5esy0vqcDUsRkFhTmFh8m/MlYmLf3tErrkRWjwCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0poXODIzwekfCHOd+Qzk+ejsvp8as/IOc7ok6EH30onmFsatNn9SeJseTCWCpvmJg
	 yW8Yu1EZDa8s7xFHUdSMlIQkoEwET9fWxCPbEMW2/Uo2TnQbKiTPJ5WDCXbOJ0Gc3z
	 X0e5K1XIyU2AFj4jRNj9YgEa9ftQ40a9iNUoT2cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 219/568] drm/mediatek: Add OVL compatible name for MT8195
Date: Tue, 30 Jul 2024 17:45:26 +0200
Message-ID: <20240730151648.439653139@linuxfoundation.org>
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

[ Upstream commit 6fb7a0985fd16868b5d72eb3e3de7524a6000e6e ]

Add OVL compatible name for MT8195.
Without this commit, DRM won't work after modifying the device tree.

Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Hsiao Chien Sung <shawn.sung@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240620-igt-v3-7-a9d62d2e2c7e@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index 37d8113ba92f0..ffe016d6cbcfe 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -719,6 +719,8 @@ static const struct of_device_id mtk_ddp_comp_dt_ids[] = {
 	  .data = (void *)MTK_DISP_OVL },
 	{ .compatible = "mediatek,mt8192-disp-ovl",
 	  .data = (void *)MTK_DISP_OVL },
+	{ .compatible = "mediatek,mt8195-disp-ovl",
+	  .data = (void *)MTK_DISP_OVL },
 	{ .compatible = "mediatek,mt8183-disp-ovl-2l",
 	  .data = (void *)MTK_DISP_OVL_2L },
 	{ .compatible = "mediatek,mt8192-disp-ovl-2l",
-- 
2.43.0



