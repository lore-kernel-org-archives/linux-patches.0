Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDCF332EAE;
	Sat, 12 Sep 2026 14:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224834; cv=none; b=PA75iGRD0Ch5akj5OwA8LTGfDCXBRqRt1ZHWXW4Zdk3rlSiw3WvdAdE+J1Kr53XruBr2OB69HuNbiqa95rxPvXK3PrZh7ARXvIxBpd9pY3lhGzZRKzRmjUNcdSYjhznTJnWoDIl9FaKNw+4JAipChzrxmFU5pf1wI+AyQFLOAvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224834; c=relaxed/simple;
	bh=pQZWw1QEgD79lRfl7s94hyVeiOnj+v+JTDgBJMxsxuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnWmgArCrV7yflWPn2KZLNNPKbYPi5NT49HL1fZDBFXgqHJT4AhZGZgX37Ca30qDPpvPLzXVTlgVueTeA+n/7JHU39uQliDXd/lwXxMu6+pFLTUOAnm5YErAPiotLlCv4DjoySVhb6HxeCTwHbJZJv0rQ0IOnbxRRsemVgdarZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dY0fMrjV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dY0fMrjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84081F000FF;
	Sat, 12 Sep 2026 14:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224833;
	bh=qFWesyN1cIPBtjBooY4jFXRKiu2VKDPS8lj6Vxe9w5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dY0fMrjV2aIda84KV3IDTbtlrM8iDeCaTvIiMxHPBHVU3jvbK8qUjlOloUKC8F+TD
	 aRgcrHY+zQ6I9snwC26oQrWIXNsgKmg/YEaSLlpvWdZzlCyMg21aRiAkH6RdzkGos6
	 b41rIihkWYfjSPKz6aSbue1ruvvaX7u+Z4QuPdfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1073/1424] drm/sun4i: tcon: Drop TCON TOP device reference
Date: Sat, 12 Sep 2026 08:58:25 +0200
Message-ID: <20260912065631.332349767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1b710013b9cb3..901e84de5aef9 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -1409,7 +1409,7 @@ static int sun8i_r40_tcon_tv_set_mux(struct sun4i_tcon *tcon,
 {
 	struct device_node *port, *remote;
 	struct platform_device *pdev;
-	int id, ret;
+	int id, ret = 0;
 
 	/* find TCON TOP platform device and TCON id */
 
@@ -1432,21 +1432,20 @@ static int sun8i_r40_tcon_tv_set_mux(struct sun4i_tcon *tcon,
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



