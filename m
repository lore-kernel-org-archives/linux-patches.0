Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC513D75AA;
	Thu, 17 Sep 2026 17:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667544; cv=none; b=i3hZHX0PY2/EsivuVk+CfG1zHn86kAX2ZYdP3nmUzebz5OCt8gqS2xcvt5wRY8yTui2MRbSOoI2wh8g9wJSmKpUGKGwFhfQKuQ9Sl6zWicylVYuoC6HvXS/MxAE5whqh5mgvYY5YbJut43HxiLgR86ufd0KtCKhPfF0bNlv0Mck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667544; c=relaxed/simple;
	bh=zMA5q8Jnk+pIB5DvTwchSmOtJqymoqlbJPBI6mZFtlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMg+wIRO8C2DK8cD0A21Xi1Ft9M46ujjpIGyNHW+8XgtRikSJbj9TWXEKNcsAoNz9LURLS8p+9jK0bZ2Nl68ul+KDx2kMiGgdEqaWP2Jr9olBNM0flh49ouX6NzzfC1W4mLNyXm/4VpvXPkupcUNExC5063AzYsr+vNXFAx8cag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtngCUxc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtngCUxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D06C1F00893;
	Thu, 17 Sep 2026 17:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667542;
	bh=CtvFH4Say14HUEQ3/x/j+ajcashHZoYKXv0HSRdMYwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vtngCUxcCtahzEyffaa4qv0wRSq+MANnaV77aVTAjDNZnrmSA3M8qgHE4D/MrlaGt
	 ghDzxx7O6dolXPpvjgdlTCifuJTcpMFXFO/7bBOZL9sIoqm8k13yOR7UPowGWk/5qy
	 h2HvQ5sHISDXmHoOJ3YB9d7dVXpDkrPXfyDnAiog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0090/1102] drm/mediatek: dsi: Add compatible for mt8167-dsi
Date: Thu, 17 Sep 2026 16:00:33 +0100
Message-ID: <20260917151541.743716992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Luca Leonardo Scorcia <l.scorcia@gmail.com>

[ Upstream commit 6428eaf0c1f39815b08d57054895c1934d5782f3 ]

The mt8167 DSI controller is fully compatible with the one found in
mt2701. Unfortunately the device tree has a dedicated compatible for
mt8167 since 2022 and it cannot be changed with a fallback nor removed at
this point. The only way to get the device to work is to add the
compatible to the driver.

Signed-off-by: Luca Leonardo Scorcia <l.scorcia@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20260505214541.333657-3-l.scorcia@gmail.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index 88f3dfeb4731d..96dcfbf6ba5a9 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -1294,6 +1294,7 @@ static const struct mtk_dsi_driver_data mt8188_dsi_driver_data = {
 
 static const struct of_device_id mtk_dsi_of_match[] = {
 	{ .compatible = "mediatek,mt2701-dsi", .data = &mt2701_dsi_driver_data },
+	{ .compatible = "mediatek,mt8167-dsi", .data = &mt2701_dsi_driver_data },
 	{ .compatible = "mediatek,mt8173-dsi", .data = &mt8173_dsi_driver_data },
 	{ .compatible = "mediatek,mt8183-dsi", .data = &mt8183_dsi_driver_data },
 	{ .compatible = "mediatek,mt8186-dsi", .data = &mt8186_dsi_driver_data },
-- 
2.53.0



