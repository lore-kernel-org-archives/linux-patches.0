Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AE23242D7;
	Sat, 30 May 2026 17:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161598; cv=none; b=oTNU7fO1JsHBlV2/h4KM4ehiTL7n6Z4yOepisld93GqVmzEBKTJ1b7EkrZ5Ht60+RVQ0fDgnnahDH5y+B7+1Q/vuw506/3M1IliOx4IJDnaXETgxtOKk7cu3OvJhlT1R58psr5AKh7kvvlDaieMgKdhlfk49qMZXWuLhRR+aY0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161598; c=relaxed/simple;
	bh=GwggiXMEWXZu/Mdvt3ustn7HUda9aDhM0R1w8E+YL5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=haIH5vmopZHcafNqg+nEJhPq46rStqHfmDOt47Ff4y5isFCk2pkc3UFzXfS6Gl/zziRgdJ4rKQpQK+G1eu7Q9t2CtonKXO1jsmG73+1a5mMKYZur9jDe+EYuemk0fH5acyG3qHMDU6veNhSULLgv49q28V/e9iVQz99clN6w5Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9rvkg+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9rvkg+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A82D1F00898;
	Sat, 30 May 2026 17:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161597;
	bh=p80xcMtUH5++Qlib5N42rs1W7eqehJ+bA8sGdLDIIJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N9rvkg+wMOOkxXoDIN7Av7G9O4l6wntdwqLb91G4u1k3joZtbZ6LWaBYA1/6FBPdM
	 DPE3aHY5e16//rWkt/1gyiNv98dmLNg+hqVE9oFDMYTT0VL6c7+VdKeLpdZOgfFZrN
	 5sdiBGXaoO519bJF4XQ5lv9X5JgZ2Wt235Edfysg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 640/969] leds: lgm-sso: Remove duplicate assignments for priv->mmap
Date: Sat, 30 May 2026 18:02:44 +0200
Message-ID: <20260530160318.127909818@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6f270c0272fb1..a33a97c2abb65 100644
--- a/drivers/leds/blink/leds-lgm-sso.c
+++ b/drivers/leds/blink/leds-lgm-sso.c
@@ -807,8 +807,6 @@ static int intel_sso_led_probe(struct platform_device *pdev)
 
 	priv->fpid_clkrate = clk_get_rate(priv->clocks[1].clk);
 
-	priv->mmap = syscon_node_to_regmap(dev->of_node);
-
 	priv->mmap = syscon_node_to_regmap(dev->of_node);
 	if (IS_ERR(priv->mmap)) {
 		dev_err(dev, "Failed to map iomem!\n");
-- 
2.53.0



