Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578D01E98FF;
	Thu, 30 Jan 2025 14:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247043; cv=none; b=kKn148YymEm20oxUFi5bpdKN4CVp4TgrTM6o7yxcnTWNOz183dmwimVSFFfZN9nTbrQtjnnMOo/nxIr1ng/HaOi4us1pwrt4rF91wutsqVZUt9h6OHxSDXwn1oN/dXCfa5/Xbgxl+QzcY376wQMgeeOtl1V2tuqQ1W82PvT2pgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247043; c=relaxed/simple;
	bh=60aT/Na+lbMr898H3I+ZxwZaJZTnenLqzmIyZn0IpM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Prnp9XR8WnNPmCCyBn0j2+Q3EheMWMOQX2lwELqSOmE1rfsnbQI1E2/hMjUTXd72QLrmsRFPFTj16Ty2y2QnrXZ38Y3cmDB4P9PiH4FR5jfIDrhLJZ5VDL9wZQ9bbmaSwzTqq6ldoLpwqmPKkKm2BNvi/wDdkjSlBbOASNudNO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1gvZhsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1gvZhsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D900CC4CED2;
	Thu, 30 Jan 2025 14:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247043;
	bh=60aT/Na+lbMr898H3I+ZxwZaJZTnenLqzmIyZn0IpM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1gvZhsGpkIxQ3HdgXFp+WLIKby704LrUep3/HaTewk56B2CdUymAYD3WQwdQB0Vr
	 38d9v9r6YAkQYjNk2YcEzoGaDTh5lME/k2dKlt1ZPiDsm5dO7D3IehxMXyz3Ws49wX
	 OMIwhXAOZBGn60D5y4QctgWaStXap9bAFRryL1JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Wang <vulab@iscas.ac.cn>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/133] drm: bridge: adv7511: Remove redundant null check before clk_disable_unprepare
Date: Thu, 30 Jan 2025 15:00:50 +0100
Message-ID: <20250130140144.977448945@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Wang <vulab@iscas.ac.cn>

[ Upstream commit 3fc5a284213d5fca1c0807ea8725355d39808930 ]

Because clk_disable_unprepare() already checked NULL clock parameter,
so the additional check is unnecessary, just remove them.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Stable-dep-of: 81adbd3ff21c ("drm: adv7511: Fix use-after-free in adv7533_attach_dsi()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index e50c741cbfe7..60400efe1dd3 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -1324,8 +1324,7 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 err_unregister_cec:
 	cec_unregister_adapter(adv7511->cec_adap);
 	i2c_unregister_device(adv7511->i2c_cec);
-	if (adv7511->cec_clk)
-		clk_disable_unprepare(adv7511->cec_clk);
+	clk_disable_unprepare(adv7511->cec_clk);
 err_i2c_unregister_packet:
 	i2c_unregister_device(adv7511->i2c_packet);
 err_i2c_unregister_edid:
@@ -1343,8 +1342,7 @@ static int adv7511_remove(struct i2c_client *i2c)
 	if (adv7511->type == ADV7533 || adv7511->type == ADV7535)
 		adv7533_detach_dsi(adv7511);
 	i2c_unregister_device(adv7511->i2c_cec);
-	if (adv7511->cec_clk)
-		clk_disable_unprepare(adv7511->cec_clk);
+	clk_disable_unprepare(adv7511->cec_clk);
 
 	adv7511_uninit_regulators(adv7511);
 
-- 
2.39.5



