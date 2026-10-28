Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211479;
	b=k2wZl+QIWLL1mGFmIcEQjgcYwiwh4nS52hmQGjbKzyOpUOV1brtkQ2X83j2RbAG34GL/
	 9VEDaA3INp4bxO0pB3zfc1+EFCcFHvpLXqEZJ6JkiU1H9xlRypEsRWqMIqFWnB1lKv9pa
	 1gMzbZ2g5N1u0cSv7867KDyR9F85J2AfjQK1abFoTrfBmf1OPOJYrpbYVvtQ30MdnHq7p
	 waU+JAQynFqWVp6yNTVu+qACTjLIQ0CdySD1R2dHfm0cEEQfFix1kJULxB3RmUt1MF0r4
	 P98RANDBlQyIud3kaIEKwJRWf6ZI1KtBMeha7JGbH9lfZ8tUToGh9FMrPmEA3OpaUsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8OeFholzY5PmOqps6VJ0AMkg85Y1gHOvWqzMWlZWUVY=;
	b=yd6BZlgta/bQbCOOnW6ULkllc/vREIdKNc8odR0eV4kLq4SzTX4eAcC5UEhIU3liEXSb
	 /F109eAC2iulcY0v1qbWnMG6vu0iVCq2ssuj9DWG5Qkl2k7j7umeo7dIUmtzoR8p+DKsC
	 ZFwvo+QhTs4BbCyTYmlFatog20xHR37+/PabTOT9+AAueeNbMJRnLbcPnEEZCpdkqzl2n
	 TjWDWewEM2cu5PACq6ovQFsg6OU3/QVwc8hzP9TKLBXz9AePOZHR9OgAvdIg05JQ4uu/H
	 hq4Tu7FyOhUCJyB9KYRtfDWmXi8mB44rrnbxmwvjP9ypvd+vPHGxuXXmKglhSM7t9uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=10DedyQx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE722606A31E;
	Wed, 28 Oct 2026 18:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=10DedyQx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F451F01828;
	Wed, 28 Oct 2026 18:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211478;
	bh=8OeFholzY5PmOqps6VJ0AMkg85Y1gHOvWqzMWlZWUVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=10DedyQxIQF4FRYzFG+lYLBBWe23nDBqYFYvHdcxELXFo5lVgKa4DLLZQ1sITTY34
	 F1/Or+tIHuAa/LbP8UaSUQwTZqBm+MBEKasU6hOIO7CeBOZpKoJdzXn9MLRQNQYDlG
	 2P7zTnQZyY437HbIqJVMo5wSReOo+yf80KogphBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 392/571] drm/aspeed: Balance the display clock enable on teardown
Date: Wed, 28 Oct 2026 17:58:59 +0100
Message-ID: <20261028170017.314822364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 65f172807a0d5..fb225912bb303 100644
--- a/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c
+++ b/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c
@@ -181,13 +181,12 @@ static int aspeed_gfx_load(struct drm_device *drm)
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



