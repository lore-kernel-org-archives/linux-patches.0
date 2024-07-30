Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58EA14831F;
	Tue, 30 Jul 2024 16:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358158; cv=none; b=EhbYCsdbmdpxk9JwAWHOS4KJBt8f6nRHLgBNAFFJu+mku90B+/kL2lSGpHx9j5JLr2oCowXqAYoL3hgfprebXtkYUT93H4RaZC+q6uGnuT+5fPjH9fbUREKn0TvqYhkFlU52wLlbR+lRV9EjGnZolMU9oRx6D2zBKNT41D0tqeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358158; c=relaxed/simple;
	bh=XJanFXhNs3fm4m05ECeonMW5fBbG5L077jU3OZO4A+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mD3fivMZdxxymqNIW13dNBKvfqLLu0GQu0FBr8AN904d9PCK4pmSkTy7fzUX8axcTX+UitU+qS142tSh+5Q1DtLU/G7z65Ws5wFoFGAS5Kt48b/oH8TZSZgnCRrc1jxtZ/ZewB+DRFIuyzyAjmajOlWP6C+aG40IInjFuUTu3es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6hk7l3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6hk7l3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4193AC4AF0E;
	Tue, 30 Jul 2024 16:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358158;
	bh=XJanFXhNs3fm4m05ECeonMW5fBbG5L077jU3OZO4A+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6hk7l3aRrG7WcxGyLhyS+LbRUuL4QyFMH/Df1rp+k6MiH9FwAH2CMDBHqScOqeIE
	 G/j7P6+Q+j7zHKADwi7Iemz2W0+195/GKpsj/trUrR4QJ4WECLk8b3egS0H7q1Tudc
	 IeSiBus6nFJGV/8uH/cf3y/kJOYIgNkQ/+NeI+kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 330/809] drm/mediatek: Add OVL compatible name for MT8195
Date: Tue, 30 Jul 2024 17:43:26 +0200
Message-ID: <20240730151737.650015362@linuxfoundation.org>
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
index de811e2265da7..8c403bf566856 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -743,6 +743,8 @@ static const struct of_device_id mtk_ddp_comp_dt_ids[] = {
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



