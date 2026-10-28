Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209102;
	b=IVoYSg1kS5Qg5YYzNeK4VrMDj4hBt7AfctD9B3NWNmaWDlI3rO6ydPB6o3mxdDA93kUm
	 OdwXRTZ8qyrvsjO3baewcsY8i6SYy1UrXE1OCmG0IEHEk7e3tVuL9Is3F6yCAVaN3UjpS
	 qyjkKdF5R2tllimaZbAjjWk9nyzksRdInRs7rDUZk2VHaf9RZhqd/nMsEGuwXaLN0QhaD
	 kbwN4DrikdAnIjSJXfYWNeH9Ybb+I4fGa9pzVR3gWUThfIj5yIwI0aMpV5OK9+MLgGABx
	 K7gYU+rA8KLLFsq1FVJU17dCD9woR7D7BGViHPKu204XpMidVdQCLGKtW91IIXuoO3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/gOWQKD+NAEoEjC1l21zwav78xysKMsDoxdb5vkTYik=;
	b=xk6rxVHHbVDNFN/KvjeuN2dxg7f51QlYZAcE334P4md0HgwZCj1ntADEfPy8jrz++gUw
	 taCfD/e72ejU1QG5QLLZ/wbhfszhhQM+tXsLEJpSUrHG6u94UeztUQW3/VVhmO3fTzAeF
	 tALScB6J101sKSnFmKdeE1tfljFh1ZRwPGLzjNgHwLNQ1dYld4xmBfaYcUHz3DrNTIXIi
	 MudIQMfpm+20SRDl2NnUdk1xyLgGRdB/44FT0+RZt+iKNKB4kdkNAV+rUKlNMwYzjWGd6
	 8f4wTt2FUxhcfIiByJsWpKWjowD2/SHuwYIV5961774fzFGZ2JdWO+pXtVpkujxYP9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GEBuP+fA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6530660A2612;
	Wed, 28 Oct 2026 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GEBuP+fA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0431F01825;
	Wed, 28 Oct 2026 17:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209102;
	bh=/gOWQKD+NAEoEjC1l21zwav78xysKMsDoxdb5vkTYik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEBuP+fAq/0BhaF1U5uu5VN4tyjQFksxh6oRYsgAJOEI5Hzf60FrKnMBOOWaUbv3o
	 bWeOsAWqdpLcr8UMRXp+xe3X/hsf5QlLB6Ot8tMMLaG72RGV0u4aEdFM1ZQ+ZslySj
	 ICNgfAGH8Z3KAbxqCzzK7AJKNs2a/6Cpz8hbOzac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 353/516] drm/aspeed: Balance the display clock enable on teardown
Date: Wed, 28 Oct 2026 17:58:25 +0100
Message-ID: <20261028170011.851985856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2b424b2b85cc8..a8d05186b6817 100644
--- a/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c
+++ b/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c
@@ -138,13 +138,12 @@ static int aspeed_gfx_load(struct drm_device *drm)
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



