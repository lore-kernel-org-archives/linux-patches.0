Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E449363C6F;
	Wed, 20 May 2026 17:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298852; cv=none; b=usH+fsxoco++s/x2J7z/R1r1X9L7RBEO8HuGSbyxi1gnfpOCLk7xL4PUuoRBBqc5ws/QKm0LC7MewwQfRJVk5a+hY1jIEnUJffD9vFkHyMmloW2dJHFKKYLhoBJsNVjLd3vjeXZY6s90b7FtBfhHCErDMK8vhC9KD1e9hBp7tvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298852; c=relaxed/simple;
	bh=XYFFeH4MsA5/Tw2zgk/8IZuDe6A/1fgRWbGbRzOKnFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3P4I19gr538feSWDCk2gAVTq9jO8oXImS8J1t7JQmK+jzpdfZY9OmLHOVfIznYw9i2/LzLVv82gsEh6T8XGAqPdoJn3qwAc37zGEwwCgH9RN8L9H7cZvgFgXo56IK3Jh3DheXQ7SPlP3N4t48j2v/kEquzplGztW+ssfwb1Pyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QB4R2YZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QB4R2YZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F771F000E9;
	Wed, 20 May 2026 17:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298851;
	bh=lv6q+K2dSt76xCCOzZH7ONG5d+MTXaiFxtA9n70169s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QB4R2YZDwH3JmFHL7U+Xm9uhZRdSIFha/cxttwK6KEWZSQkWCIi31cHVhZLz4TPjm
	 +VxwMCruIznM7P50GpWqeLpDePQJomfV1aZdDQV31rsyfoSkv4XCDmKxhvF+5wH6qA
	 2XNxsPYZ5+sjZSElPC1jcVipl7qNTObz8NlRkykk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 531/957] leds: lgm-sso: Remove duplicate assignments for priv->mmap
Date: Wed, 20 May 2026 18:16:54 +0200
Message-ID: <20260520162146.048402318@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8923d2df47049..3d9ef9a54805c 100644
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



