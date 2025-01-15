Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB523594E;
	Wed, 15 Jan 2025 10:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938636; cv=none; b=aHTQ+AzaubNdu2gT6K7f0Ws9Z+ZLuVX4hRmQ38J1gPTUiAEG3sGXsvxk5JTei3zLS2J0Qc+j8hYO1xWpurRlZeiyAolzCb5e8odtgrc99ABsQexfhI+Kc5l9FsUv4v2wDJ3fPMqOisJhfoTYEk4BgqW1/xBk7Xrmd6NTk2OKdiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938636; c=relaxed/simple;
	bh=yWWno3ZL6xf8VLUM8xPF3mAWtWA/o6Ia1gVKYB8j7vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJuW6bMw2eotKorKmN9GlYVwT9oPE8qpn60bt2RTwcYDFzisVB/ZFL0g/xpKPm8kHxqmgjfbArP0pqPtfSbNxkF/iJAlf+u+eogQHxGQWLBGS30dsMedcgJux7dPcch4VI7CqjCLgbBaflKlpsFpmToJIrQRDFt/Wj9UDxJKWIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBjnwuBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBjnwuBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83E6C4CEDF;
	Wed, 15 Jan 2025 10:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938636;
	bh=yWWno3ZL6xf8VLUM8xPF3mAWtWA/o6Ia1gVKYB8j7vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBjnwuBK2fp3+fBbslcb0oqbpgvB9T/+BlrM6p98cSgZ+bMmBm5QV5hNctvtTepU/
	 H8TlqHFRHdjwElkthW1ZkXw1BpAta5gT3Gn/GxXbLDUO0bEPh7GhZoofM+vo0wN5wm
	 PWjDm9ysxyrdp2MKD4sK8PB8F6EdtfuDWRwdUg/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liankun Yang <liankun.yang@mediatek.com>,
	Guillaume Ranquet <granquet@baylibre.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/129] drm/mediatek: Add return value check when reading DPCD
Date: Wed, 15 Jan 2025 11:37:06 +0100
Message-ID: <20250115103556.402353083@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liankun Yang <liankun.yang@mediatek.com>

[ Upstream commit 522908140645865dc3e2fac70fd3b28834dfa7be ]

Check the return value of drm_dp_dpcd_readb() to confirm that
AUX communication is successful. To simplify the code, replace
drm_dp_dpcd_readb() and DP_GET_SINK_COUNT() with drm_dp_read_sink_count().

Fixes: f70ac097a2cf ("drm/mediatek: Add MT8195 Embedded DisplayPort driver")
Signed-off-by: Liankun Yang <liankun.yang@mediatek.com>
Reviewed-by: Guillaume Ranquet <granquet@baylibre.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20241218113448.2992-1-liankun.yang@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dp.c b/drivers/gpu/drm/mediatek/mtk_dp.c
index 3e1b400febde..be4de26c77f9 100644
--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -2005,7 +2005,6 @@ static enum drm_connector_status mtk_dp_bdg_detect(struct drm_bridge *bridge)
 	struct mtk_dp *mtk_dp = mtk_dp_from_bridge(bridge);
 	enum drm_connector_status ret = connector_status_disconnected;
 	bool enabled = mtk_dp->enabled;
-	u8 sink_count = 0;
 
 	if (!mtk_dp->train_info.cable_plugged_in)
 		return ret;
@@ -2020,8 +2019,8 @@ static enum drm_connector_status mtk_dp_bdg_detect(struct drm_bridge *bridge)
 	 * function, we just need to check the HPD connection to check
 	 * whether we connect to a sink device.
 	 */
-	drm_dp_dpcd_readb(&mtk_dp->aux, DP_SINK_COUNT, &sink_count);
-	if (DP_GET_SINK_COUNT(sink_count))
+
+	if (drm_dp_read_sink_count(&mtk_dp->aux) > 0)
 		ret = connector_status_connected;
 
 	if (!enabled)
-- 
2.39.5



