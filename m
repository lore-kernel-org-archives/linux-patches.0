Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038701;
	b=WFE9JA1IBSDpNRNZO4XCMv0W7xZcn6kI22FxlISIn5QoDTIuAMwVE/365yo2931O0cyT
	 RbLfL9CbdGfVgiOWJHy7zfN+p/m7jpuhfK97EC0szV72Vy+LQPCMG8px7glrtwJdBHTjq
	 l5H8L2mh75yQSs0VLYvxEn14RV7DDPbrdQc9QivY5HHBi6YTBfR+9qCaceXxv/3/FCvOd
	 gyZa9aCPPGbO/1F8GBWmhqib1OyPPLjK+lISR8vnSe4d9emX7cvtrXq1yGdgockfiXlk9
	 EScM96Ef0OOZcfzn5jXA7mnfNeqcamKXINW1/Zuq+bMcj/9y2Kqz56+EcMrDsU+d9Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YF4UqG9h/HnvVeMuwVFOEb4QVozj2hj0RQIEkwOeEwE=;
	b=EiIXtv1cPVBos3ZoF+Op0Wu6TZbBjNutr/kP3Zf+JdUtz7yF3CuWYMAnnIxzJJpRki5s
	 wttaoGG/WaTzvhdifiQM6AqsDDxa9qdatczm9jYFqBWbM1NuL9BjvO/2TxQKqpZ0pgezm
	 x5DWdGIIByXBoLTAhJvRfUp9bOM0SrqLINvLnk/C/2k9a7rkPqkmZACfZ8uEgN8aYOsGc
	 XjLt81LlQbAHPQYL3r6JWpUr21ZS0VdYEq9OdQl053S6WqhLghZQ8X03WEQ9I2kkJkc3N
	 nMPNpPgkJXXpRhLiv0XUNPr6/j6af6IgSqCnMvdrP8tSx3IC9a9u8HyY6GDLTZQ0M+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SLIUqQGK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39D0606A31C;
	Wed, 18 Nov 2026 21:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SLIUqQGK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A591F000C4;
	Wed, 18 Nov 2026 21:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038701;
	bh=YF4UqG9h/HnvVeMuwVFOEb4QVozj2hj0RQIEkwOeEwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SLIUqQGKRqydA6AsCzEfcYvy09WoHS+KpCP/4aqzOGXllfkN5yktrvr2ukFz5m5it
	 pWsuExgXySDt29luj84Dii7UWsGbVnAgf2LSIyXAVVGGB7+SC/bYAwtoYW/RvePxJT
	 b2R67kZAFoSHqjKkUXE0HziodXGxj4hC9eLbkY6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1838/3318] power: supply: core: get rid of of_node
Date: Wed, 18 Nov 2026 15:41:00 +0100
Message-ID: <20261118150417.000161641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/power/supply/power_supply_core.c | 16 ++++++++--------
 include/linux/power_supply.h             |  1 -
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 2929e21b82032..a55b85ffe3337 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -194,11 +194,11 @@ static int __power_supply_populate_supplied_from(struct power_supply *epsy,
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
@@ -229,7 +229,7 @@ static int  __power_supply_find_supply_from_node(struct power_supply *epsy,
 	struct device_node *np = data;
 
 	/* returning non-zero breaks out of power_supply_for_each_psy loop */
-	if (epsy->of_node == np)
+	if (epsy->dev.of_node == np)
 		return 1;
 
 	return 0;
@@ -264,13 +264,13 @@ static int power_supply_check_supplies(struct power_supply *psy)
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
 
@@ -595,8 +595,8 @@ int power_supply_get_battery_info(struct power_supply *psy,
 	const __be32 *list;
 	u32 min_max[2];
 
-	if (psy->of_node) {
-		battery_np = of_parse_phandle(psy->of_node, "monitored-battery", 0);
+	if (psy->dev.of_node) {
+		battery_np = of_parse_phandle(psy->dev.of_node, "monitored-battery", 0);
 		if (!battery_np)
 			return -ENODEV;
 
@@ -1390,7 +1390,7 @@ __power_supply_register(struct device *parent,
 	if (cfg) {
 		dev->groups = cfg->attr_grp;
 		psy->drv_data = cfg->drv_data;
-		psy->of_node =
+		dev->of_node =
 			cfg->fwnode ? to_of_node(cfg->fwnode) : cfg->of_node;
 		psy->supplied_to = cfg->supplied_to;
 		psy->num_supplicants = cfg->num_supplicants;
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 4b231468c3f1d..84cff00720d03 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -287,7 +287,6 @@ struct power_supply {
 
 	char **supplied_from;
 	size_t num_supplies;
-	struct device_node *of_node;
 
 	/* Driver private data */
 	void *drv_data;
-- 
2.53.0



