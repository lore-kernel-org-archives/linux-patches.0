Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213456;
	b=1meS3KVcZ0Ulf5486KaNUUnuEJSiE9HBzqb0wsbBOPKcIBDqu8wyivLco6MmODY0CUT3
	 d5JtlJDUMOgEF5Eghn3egBg9P3Q75yRdqAnxAzYJBPVFVBWGjlpmpey1VSldnKVHcCUAO
	 7VTqjLyb9nSG2nq4gP34GESRgYFuoNhdY51WU67wroLvA+zeYU6Hf+sAne/0I830TIx90
	 OQv44uSwN1UggNIV1czdlINr+1QI+6dknSNJN7rZlr3se+VEGLGmFnFuqAvDzi681khZ2
	 yc+mJO80oB4xzTNiiwYrdf+PKfiqpgomUgI2Cw1q+kPsmr0YOV0f1JSqYHiG/FD/f2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EdDk07mGoHX3D53saG+4/oR+BcjATLHJyOyuBcrcH1Q=;
	b=0CzN1AmAfN1cT6U9ca+ShNbgH0McRpF11mbWbHcjW7Cmh+FU1yuhWPqwOEilQB4NAet1
	 DiKw7txxMa0Dr5AG/zrdLYocYUCJ47ske3TWPudSV/aLS3deyXiS0msxeKv0c/HdP/DrN
	 Gp1gqSgNlKgamh+30G00ULD0oDO/XF17SM0SCn+i63B+pnuoZYxr+3WpyGl/0fkM0lEBD
	 1jDIVrdqLHo6XN6GQu5omIBdCgyT0sX5xdC3bX3gbO7dWmdbhpnFY1fSNN/7CnzG0wSkS
	 a9d/0p1z+kpyLBf1EeoScA0UL0tiNk+TcgKLiHLVmhDC46SylgwgOrpP5wPvhpGvajQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mfgPSR0z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61536606A31E;
	Wed, 28 Oct 2026 18:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mfgPSR0z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26121F01828;
	Wed, 28 Oct 2026 18:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213456;
	bh=EdDk07mGoHX3D53saG+4/oR+BcjATLHJyOyuBcrcH1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mfgPSR0zdiPbK2WzyU2TkP4/J4iKeUYgAOfV/cM7plBmiPHEkZx9BeGxRc/V5QA8Y
	 9RoFk6oD2t0/MaWdJTC6bbkqavTYvzF/dW4NsbaovlNpdPuVwbX1XnFcbEgkZzaB6u
	 ruOq5jhkmKfwV/DWAqFk/rgKDlCAMGZEwbHU3FMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0485/1887] drm/aspeed: Balance the display clock enable on teardown
Date: Wed, 28 Oct 2026 17:43:01 +0100
Message-ID: <20261028170510.301062526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit ecce445c6489895463b7ddec2af66338287fee4c ]

aspeed_gfx_load() enables the display clock without checking the return
value and never disables it on probe failure or removal. devm_clk_get()
only releases the clock reference, leaving the enable unbalanced.

Use devm_clk_get_enabled() to handle enable failures and automatically
disable and unprepare the clock on probe failure or removal.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 4f2a8f5898ec ("drm: Add ASPEED GFX driver")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Assisted-by: OpenAI:GPT-5.6
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260913223019.89651-1-mhun512@gmail.com
Link: https://patch.msgid.link/20260905080426.34224-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/aspeed/aspeed_gfx_drv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c b/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c
index a94f1a9e8f409..79f67413c1175 100644
--- a/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c
+++ b/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c
@@ -194,13 +194,12 @@ static int aspeed_gfx_load(struct drm_device *drm)
 	}
 	reset_control_deassert(priv->rst);
 
-	priv->clk = devm_clk_get(drm->dev, NULL);
+	priv->clk = devm_clk_get_enabled(drm->dev, NULL);
 	if (IS_ERR(priv->clk)) {
 		dev_err(&pdev->dev,
-			"missing or invalid clk device tree entry");
+			"failed to get and enable clock\n");
 		return PTR_ERR(priv->clk);
 	}
-	clk_prepare_enable(priv->clk);
 
 	/* Sanitize control registers */
 	writel(0, priv->base + CRT_CTRL1);
-- 
2.53.0



