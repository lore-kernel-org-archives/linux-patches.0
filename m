Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE04403E9A;
	Wed, 20 May 2026 18:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302539; cv=none; b=sAiFgm6jsi0rb6HSz41tcSX/47U2Fam0yLJeFMRDGWzSLOjKVjjvS7dthLYPftt0z7ymA0Lc5h5Y0FATwUn729zKlF9+BQyM8MG9shf21twwZvve6iFkra6DUISGMr3R3HBAVaxAg18TCsWq/33dRQj8EdrW3iiBkiVMrlpbz80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302539; c=relaxed/simple;
	bh=Y5jjhHQBVyU3ln0jY7ZMxgBwePHLibxVxjRTpumW0sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaKt+Gf77RX4aObD4Rxh8c/dAeMJsrvfZeFTl2gprESR7/ZOLQqWm2mxPW5MBNdox6pL5IRfvgwKerbx5H53mGlLa8+qYBTOGMBXYDG4r7Un4tgA1FozlpxALY2Ty/ELb/X9iLVaaKnaEgS0jUDqkGZZP5Qm0X5x34yF9IOxGC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSn5XAvj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSn5XAvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55E61F000E9;
	Wed, 20 May 2026 18:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302538;
	bh=3QOVZ4NyW5PiIKEAhrSbxi6xk7DAhaNm0UzzGt8MWAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fSn5XAvjKvwHPdKNWuP907MZWXnyJdYKVSUXh1j/st44bwug2BCvv2huVE3Jn60Wz
	 mFv1t29T1Ccv+i5XafnLhqI1NKWslg8B0xI0FJWGerwR3GLt+7AUAr0UP2weIctszt
	 a4e3nzW8uwMD0+BisS5q49T0DdoFxFYn7AlbS36g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 263/508] leds: lgm-sso: Remove duplicate assignments for priv->mmap
Date: Wed, 20 May 2026 18:21:26 +0200
Message-ID: <20260520162104.343872900@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 35c61311e7fd8..e104010345b18 100644
--- a/drivers/leds/blink/leds-lgm-sso.c
+++ b/drivers/leds/blink/leds-lgm-sso.c
@@ -806,8 +806,6 @@ static int intel_sso_led_probe(struct platform_device *pdev)
 
 	priv->fpid_clkrate = clk_get_rate(priv->clocks[1].clk);
 
-	priv->mmap = syscon_node_to_regmap(dev->of_node);
-
 	priv->mmap = syscon_node_to_regmap(dev->of_node);
 	if (IS_ERR(priv->mmap)) {
 		dev_err(dev, "Failed to map iomem!\n");
-- 
2.53.0



