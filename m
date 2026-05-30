Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046EE340A6F;
	Sat, 30 May 2026 18:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164397; cv=none; b=kgn0aVguthzx1qOGkg504bU+DtGyLpyHgDyy9cFAF1LS3TL+e6Uzo2rSTve7uau+7cGAABF1H/+VHSA2imwQRTgd/xPXUDXGb0kTG0RTOnSPat0xZe+lL/a13JMk+Z68ouTDhESUGGEpWaVCwq6GSki1dl0KsVhmlZYPJNBOX2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164397; c=relaxed/simple;
	bh=tx9NIDoJyVQTEEUZh/lZwchHAJqjSTMMSNNWC73RGiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yiy4oR5pPq9xWWsEBowtDxtavLBQ5oc0dZRpL5pPfSL2ct2enRSjjHxUUjT2hikVJi5aCk+0i0ZYKXtK97ukDi+DZvFpriSpYfgX1Dd7LtyShqv3h6muxj8u2O2ocOLqcCbeZ3g6XbWDflelGkX628Oqzcuj3d3eFOEeETynJJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0PtRaW4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0PtRaW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156FB1F00893;
	Sat, 30 May 2026 18:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164396;
	bh=ccg/QF3/5m1rKYwL65f72sgtuZBoobF8hIhY9Zb2kb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0PtRaW48Swurn47RTPjQPn0N2MBwVwqdvrAEBbM4pElfev81ASL3JSks+C7zHaaK
	 e3T/mwIqvu7NVV10AC9Ta0cCffFleiULZKuEK4z0MAw4NZdSeID1Heul5D8GCgtbMt
	 dxoRwV7jFomI4nwYx9CZ7JuBDqqrsMNKe4rP+JPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 525/776] leds: lgm-sso: Remove duplicate assignments for priv->mmap
Date: Sat, 30 May 2026 18:03:59 +0200
Message-ID: <20260530160253.790418265@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 7186d0330c3f3e86de577687a82f4ebd96dcb5ac ]

Remove duplicate assignment of priv->mmap in intel_sso_led_probe().

Fixes: fba8a6f2263b ("leds: lgm-sso: Fix clock handling")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://patch.msgid.link/20260226033048.3715915-1-nichen@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/blink/leds-lgm-sso.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/leds/blink/leds-lgm-sso.c b/drivers/leds/blink/leds-lgm-sso.c
index fd8b7573285ad..45045c2a26574 100644
--- a/drivers/leds/blink/leds-lgm-sso.c
+++ b/drivers/leds/blink/leds-lgm-sso.c
@@ -808,8 +808,6 @@ static int intel_sso_led_probe(struct platform_device *pdev)
 
 	priv->fpid_clkrate = clk_get_rate(priv->clocks[1].clk);
 
-	priv->mmap = syscon_node_to_regmap(dev->of_node);
-
 	priv->mmap = syscon_node_to_regmap(dev->of_node);
 	if (IS_ERR(priv->mmap)) {
 		dev_err(dev, "Failed to map iomem!\n");
-- 
2.53.0



