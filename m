Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591619;
	b=bWrPsNfjp9Q+DjUjbSuVD0892+wqJHteq3kkMT3FpZWxGEZ/YELqtM/OEzYUr36a0Y8U
	 4aPDE6TroAKcUPQfAYmoIbz1+WdHNsQ7FPVEHONs1NoIPPKdxripybk78gnnaJsGlo//d
	 MGTGKQsuJpmZN4OsrJZ/hozuCWkGcJ5DndvyiuCYXBf1GP+Zm8ItScQWAhORrbOzlA4Jo
	 MDaK7m+tme8ALmH9VSDxoJxdY2c3j2evVhy79Qi2bNmkoX+w5qK1HOjxY0z+tGRhfWuuB
	 FSbvMCDm+vKQscQmXUxLc14/eBbSvcz8ONoy6+HYnqc2jcZXx4K+CsaZFpHL0e01JQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kKIiK8/WdIgK2Tj4UgbENII763D3xKguVs3Bt97VvI4=;
	b=qHKjImQymMclJE5WCrxmwc5rSTOmJr0C+OmQJ530eyD54ZVR7FxQuHS/oe27kLUVJi0w
	 xhQlvR2uDv9lfIPfd+V7ffuihi3GfqIYebqaWojAuK6TbJyxriAve4y4+5ceHY4OA1gEN
	 0iKsdHFS5uOId+GOTaSbJK8fmL22pYHPFpEKTnt4DXt6j/drYE1pQ/yjyikhQRklzJVCh
	 PZpMLhT8dZ9CjkGHlohnF8FepuVnaU3sAgBL2ptVASjcS2gnb3Et/Okoo7Hl0Et45eR+y
	 NCI4zNIBPL25nGUjGHrFDHUv6wkU5Ji977f/SjDy3Jsz5dsmFr+sp7wTUQoe+D79hxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G1ZbCmnr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3897E607E835;
	Fri, 13 Nov 2026 17:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G1ZbCmnr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82301F000C4;
	Fri, 13 Nov 2026 17:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591619;
	bh=kKIiK8/WdIgK2Tj4UgbENII763D3xKguVs3Bt97VvI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G1ZbCmnrWs0oq4pRZvg0idJWYFa/s2WZBUisUbBWksmYMT9nVYtHPTFIyV5GN9hD2
	 XdOYoNXYQkGKwuYFQFlO8OfAWIORZX4t9Yf7yqJBRsKVx6hgwV54gRPedTCcxqw0+b
	 b99PlQXMt0f7lSeYyZ01yEIZjH6KYNp3AK5aifNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 660/670] power: supply: core: get rid of of_node
Date: Fri, 13 Nov 2026 10:53:44 -0500
Message-ID: <20261113153834.269695466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 134254038739a6c6ecb7548a2f895d89a0dc9d2a ]

This removes .of_node from 'struct power_supply', since there
is already a copy in .dev.of_node and there is no need to have
two copies.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250225-psy-core-convert-to-fwnode-v1-1-d5e4369936bb@collabora.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 6bd80f22c764 ("power: supply: core: Honor supplied-from with CONFIG_OF=y")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 17 ++++++++---------
 include/linux/power_supply.h             |  1 -
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 515772e2ab51e..ae0e11146a1fb 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -197,11 +197,11 @@ static int __power_supply_populate_supplied_from(struct power_supply *epsy,
 	int i = 0;
 
 	do {
-		np = of_parse_phandle(psy->of_node, "power-supplies", i++);
+		np = of_parse_phandle(psy->dev.of_node, "power-supplies", i++);
 		if (!np)
 			break;
 
-		if (np == epsy->of_node) {
+		if (np == epsy->dev.of_node) {
 			dev_dbg(&psy->dev, "%s: Found supply : %s\n",
 				psy->desc->name, epsy->desc->name);
 			psy->supplied_from[i-1] = (char *)epsy->desc->name;
@@ -232,7 +232,7 @@ static int  __power_supply_find_supply_from_node(struct power_supply *epsy,
 	struct device_node *np = data;
 
 	/* returning non-zero breaks out of power_supply_for_each_psy loop */
-	if (epsy->of_node == np)
+	if (epsy->dev.of_node == np)
 		return 1;
 
 	return 0;
@@ -267,13 +267,13 @@ static int power_supply_check_supplies(struct power_supply *psy)
 		return 0;
 
 	/* No device node found, nothing to do */
-	if (!psy->of_node)
+	if (!psy->dev.of_node)
 		return 0;
 
 	do {
 		int ret;
 
-		np = of_parse_phandle(psy->of_node, "power-supplies", cnt++);
+		np = of_parse_phandle(psy->dev.of_node, "power-supplies", cnt++);
 		if (!np)
 			break;
 
@@ -598,8 +598,8 @@ int power_supply_get_battery_info(struct power_supply *psy,
 	const __be32 *list;
 	u32 min_max[2];
 
-	if (psy->of_node) {
-		battery_np = of_parse_phandle(psy->of_node, "monitored-battery", 0);
+	if (psy->dev.of_node) {
+		battery_np = of_parse_phandle(psy->dev.of_node, "monitored-battery", 0);
 		if (!battery_np)
 			return -ENODEV;
 
@@ -1384,9 +1384,8 @@ __power_supply_register(struct device *parent,
 	if (cfg) {
 		dev->groups = cfg->attr_grp;
 		psy->drv_data = cfg->drv_data;
-		psy->of_node =
+		dev->of_node =
 			cfg->fwnode ? to_of_node(cfg->fwnode) : cfg->of_node;
-		dev->of_node = psy->of_node;
 		psy->supplied_to = cfg->supplied_to;
 		psy->num_supplicants = cfg->num_supplicants;
 	}
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index ee6e89c9c301a..1e059ff7a9712 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -289,7 +289,6 @@ struct power_supply {
 
 	char **supplied_from;
 	size_t num_supplies;
-	struct device_node *of_node;
 
 	/* Driver private data */
 	void *drv_data;
-- 
2.53.0



