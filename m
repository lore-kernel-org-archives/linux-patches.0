Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D6E29B78D;
	Wed, 20 May 2026 18:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301071; cv=none; b=dOUW52vJanCka327m/sPan669QiqqaxzCvoPcKQD0SMpGJ3giJTigePWbANblyw9Cep+b4RhRDbIaOGKRYCPDa5SuWVjgCnz/6Hkafy2FHu42jefehzAEfwXu8+fORZjYdm1CLDCkMXZkWm9Z3oOiSAsEc4g+Uj4vaFhkPx2fSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301071; c=relaxed/simple;
	bh=SZ9bRH1SQB1bHj50+06CFESm0G6Vjok0beSIVcsnOs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQtbJ+l/AJ+8k3T44BRLP6t61+K+d9DN3c3GSfLf7WOh49XCSjt0MuqfZ9dg32XQE7ZMkM0BpQEo2PDxZus837USV/XZPXpHDZUUpWWlokZRMKq8CWGVMBrzhgDhqwfm+5Ppm4PC676UooiEAhKsj198IIUliG7/BSTu0DcLU1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06WJMmSN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06WJMmSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8904C1F000E9;
	Wed, 20 May 2026 18:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301070;
	bh=ArCpwfTxiRUSMgr3YoSRzRjPYPMe8jT48x/LAKxXF+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06WJMmSNuTwRO/LhZuxLuK2YVOCEqK8mwzLiRam6379zFNDtzAUIxizG7+Mpp7P+h
	 BXlZe8XhYSiFWy+igRH9R7l3KSeOhsuJObfWnGp5wcqnxASMVt/AuRWBL4JetrNQOq
	 9ezw/HSV26grX4oXTltewScDkOtbOj5QFAuERfWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 388/666] leds: lgm-sso: Remove duplicate assignments for priv->mmap
Date: Wed, 20 May 2026 18:19:59 +0200
Message-ID: <20260520162119.665203559@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7b04ea1462605..330cd46194659 100644
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



