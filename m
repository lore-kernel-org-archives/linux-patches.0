Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215942;
	b=3ZRMZOrtJYC2QkBGTrxZMnOxvuW+8FasMCgkrr2PYGNXCwqn1cgzBn2HDZIDPD5rZ0HU
	 Iiz3LaJhte8VltaIgnUoe8V1Nj2x/JIskN+6t/jeXPbfstFOcjCuADvmDBX/qZ2hfG4ND
	 ShZocEJiKs0mgUkL+jH8eJ9C9pxxF8B2jzNd/runVg9wnASql1gg8NQr8NW7vVui6jYRJ
	 SDpfs0lTJ1iB68+Dqx3Wad0gwI0BpcFIYHShSfnVbsDUjcTHnW87U7ZZHATCfpJu5u9x0
	 BnPpU6/9e47hvsXD2LLxDI38o4Tam/sLP/QGlGJ3izJ1bzEVAws/w8xGG6Myv7L7d9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=939SBXjivPmLPcAWZgYvKQPr6AKu67o54Gc33+gM9w0=;
	b=ggetZmlOSKKOQjojJapWXp/oHGWlNxHBWorMhpsp9GUQwjj/L09D8flIWlQGWdF4IH1k
	 KYEa3M8TSA3OzYlOwqKUeBVWEvYxysDxG0wm1x+6hxzlL8JFSFtHtdCO0z/Z0UXaLUpU1
	 aZHQH38Y2nt1P6OMleQbUcC6yK6gykzouuxKTfClENI6uc2Fo8+dhp9jtY2woE8iSVlF0
	 bOo/J4mU3tW9vDtL0zth/sNLSacknyWuJVj37BO1Gq4R9A5+/w1mH5hKsgUUE7FbtyN8H
	 xkhZjJ2FpGutKbgne103SQ2IJNo8vPD4pmTW7r3QIq2MXsKV9Z2l76dzGAiEq+7TGXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I80lqo11;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC8B606A31A;
	Wed, 28 Oct 2026 19:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I80lqo11
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9A61F01825;
	Wed, 28 Oct 2026 19:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215942;
	bh=939SBXjivPmLPcAWZgYvKQPr6AKu67o54Gc33+gM9w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I80lqo11QxS+IyW/UG/HCIhx8+se7rLFt/sODtotjJYEYBUsH+2u5N/uHidR9ont3
	 aeSEyiES2j1aTe9paQlAfqaXcLTUBogxT2NqW5UT5wA9h6PAcfIK2h9CSWzfYIAlFI
	 /yYcdMoagT4MjGVCSVZHmfgMA1waADkxupwWvS4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1386/1887] power: supply: lp8788: Use devm_power_supply_register() helper
Date: Wed, 28 Oct 2026 17:58:02 +0100
Message-ID: <20261028170530.986492176@linuxfoundation.org>
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

From: Andrew Davis <afd@ti.com>

[ Upstream commit 2abb571143c39f581df9951d263948726db42d86 ]

Use the device lifecycle managed register function. This helps prevent
mistakes like unregistering out of order in cleanup functions and
forgetting to unregister on error paths.

Signed-off-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20240123163653.384385-7-afd@ti.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 831c29a12d56 ("power: supply: lp8788-charger: fix use-after-free on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/lp8788-charger.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/power/supply/lp8788-charger.c b/drivers/power/supply/lp8788-charger.c
index 3cf8cec8cca6b..98c15b7abfb88 100644
--- a/drivers/power/supply/lp8788-charger.c
+++ b/drivers/power/supply/lp8788-charger.c
@@ -406,12 +406,6 @@ static const struct power_supply_desc lp8788_psy_battery_desc = {
 	.get_property	= lp8788_battery_get_property,
 };
 
-static void lp8788_psy_unregister(struct lp8788_charger *pchg)
-{
-	power_supply_unregister(pchg->battery);
-	power_supply_unregister(pchg->charger);
-}
-
 static void lp8788_charger_event(struct work_struct *work)
 {
 	struct lp8788_charger *pchg =
@@ -667,18 +661,16 @@ static int lp8788_psy_register(struct platform_device *pdev,
 	charger_cfg.supplied_to = battery_supplied_to;
 	charger_cfg.num_supplicants = ARRAY_SIZE(battery_supplied_to);
 
-	pchg->charger = power_supply_register(&pdev->dev,
-					      &lp8788_psy_charger_desc,
-					      &charger_cfg);
+	pchg->charger = devm_power_supply_register(&pdev->dev,
+						   &lp8788_psy_charger_desc,
+						   &charger_cfg);
 	if (IS_ERR(pchg->charger))
 		return -EPERM;
 
-	pchg->battery = power_supply_register(&pdev->dev,
-					      &lp8788_psy_battery_desc, NULL);
-	if (IS_ERR(pchg->battery)) {
-		power_supply_unregister(pchg->charger);
+	pchg->battery = devm_power_supply_register(&pdev->dev,
+						   &lp8788_psy_battery_desc, NULL);
+	if (IS_ERR(pchg->battery))
 		return -EPERM;
-	}
 
 	return 0;
 }
@@ -721,7 +713,6 @@ static void lp8788_charger_remove(struct platform_device *pdev)
 
 	flush_work(&pchg->charger_work);
 	lp8788_irq_unregister(pdev, pchg);
-	lp8788_psy_unregister(pchg);
 }
 
 static struct platform_driver lp8788_charger_driver = {
-- 
2.53.0



