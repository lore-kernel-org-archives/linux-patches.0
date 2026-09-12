Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5517678C9C;
	Sat, 12 Sep 2026 19:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243053; cv=none; b=sHSzxVDrPAyDYXv2WZkHiae1fXccrXyJTqGrnEw+H43qv+s9+ryotRCFjxRdasqevzcV3C4JHmUP8+ApdUVqg1lKdpaoT2nqIDwxhl7a0U8/PAxBeP/Tsh5HeapPdrleCvVjsAV03F4DegKr0Z+gQeqPq0iP409PcQGi3KHZUis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243053; c=relaxed/simple;
	bh=feO7qP1UGVoU8DxjJ2bckB5Llmpre4WmdMsFkaJoph8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6ImNtK0FhkrR8RwOOU7aZWmh7YFyflrum57HM5GIR3ZKrU2f8s+8I/QNSyqghoUDxI/a8YGGlx/5OQZG0DBSBsKkGeww1L3GAwLBVwx7lkIhMEsYfao0Fv/JGdU8QUKt8pOJHrXBT6jmKuVXZk7ANfICCpexscpuV93XLv9iZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qheyAIj1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qheyAIj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9F61F000FF;
	Sat, 12 Sep 2026 19:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243052;
	bh=XBORh9JNyfJGId0P9fl2BPma78HWPdHWYtq0yeS4Qs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qheyAIj1iQIVM88ayyeO9IXLkx1cpV15gPLWb9X7KhdpJGToKaiOiNeGglM8FTzSx
	 tRFvu8CGqTl6GGE7UJpb73DsyVIjlKaEEA14rS8iA/TVoSfsWVNNFnDld/VhJgJBVt
	 YM5lABlX4oM5faJJwkFH0Pe8lqblUMtHTx5K4uGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 621/798] drm/sun4i: tcon: Drop TCON TOP device reference
Date: Sat, 12 Sep 2026 09:04:09 +0200
Message-ID: <20260912065531.354684353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 8208832a38ff3d2560eb8a77a9d7a2f17d8ebcdc ]

of_find_device_by_node() takes a device reference. Drop it after mux
configuration succeeds.

Fixes: 0305189afb32 ("drm/sun4i: tcon: Add support for R40 TCON")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/871a3108086c15a483eef23301984c8d2254dfa7.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_tcon.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index bb43196d5d83e..846085b3ee2dd 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -1404,7 +1404,7 @@ static int sun8i_r40_tcon_tv_set_mux(struct sun4i_tcon *tcon,
 {
 	struct device_node *port, *remote;
 	struct platform_device *pdev;
-	int id, ret;
+	int id, ret = 0;
 
 	/* find TCON TOP platform device and TCON id */
 
@@ -1427,21 +1427,20 @@ static int sun8i_r40_tcon_tv_set_mux(struct sun4i_tcon *tcon,
 	if (IS_ENABLED(CONFIG_DRM_SUN8I_TCON_TOP) &&
 	    encoder->encoder_type == DRM_MODE_ENCODER_TMDS) {
 		ret = sun8i_tcon_top_set_hdmi_src(&pdev->dev, id);
-		if (ret) {
-			put_device(&pdev->dev);
-			return ret;
-		}
+		if (ret)
+			goto out_put_device;
 	}
 
 	if (IS_ENABLED(CONFIG_DRM_SUN8I_TCON_TOP)) {
 		ret = sun8i_tcon_top_de_config(&pdev->dev, tcon->id, id);
-		if (ret) {
-			put_device(&pdev->dev);
-			return ret;
-		}
+		if (ret)
+			goto out_put_device;
 	}
 
-	return 0;
+out_put_device:
+	put_device(&pdev->dev);
+
+	return ret;
 }
 
 static const struct sun4i_tcon_quirks sun4i_a10_quirks = {
-- 
2.53.0



