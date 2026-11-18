Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054197;
	b=zSRpcupf6R9n3yJNoXc5fRh94Iv3ZyyAm3zvfE4QWByQaEfpJ0aUZuzggA/ARBZW/CSW
	 Bep+fqfunxjio4y0hXxuQhh+tp8JAjAEJ01LzYM4XiOMVYT47l6BwgIhR1xZWLO+fUBmC
	 kPSBDdItfUQPoavLuCkeVIli5QZwKoIKAzxF8D7cXK/mJqjc9bDcxjRsd7weZnTtUactN
	 0Cf5ybK8aJ+nqDi5D8AMG4fvVCCIg1INkXg/w6n9pagT0UO7mM99onGxXhXWnxgCQ3iH4
	 NorU3rMqBFrxY+pFywpun5awlKP8+tDJ4d3RKvgryWy+BJmLUZuNexWbJLavBsmPO/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OPiVy7QymOIzh/sjhm5eUz514D9yaEjVHw4nJaadjAk=;
	b=4s1NOzuC4YseFL+6GPyAAR7zhzqllSKm6j/+v2j8NZFH+HDI7amg1U7Eqesgv4wZaF3Z
	 j86nw7X6n/NsAuB0CGGo9IJc5h1j48/aKR5atCm2xc43YaHkIsjDO8lbG78YTHLz0LcA4
	 2pPYtvKek5spwZw6kE5Ga+1dWDsm1iEr1E1EGMf5UjOSJMofSSYD1aAvYzyDxlq2YUf+k
	 NjvQ/fek1vjdo1fEKB4PyDThZmD3oE29sAei8nOK6zhn+zP9XjXOv8GYIlSFRtrHwpjiP
	 YquiLeXM3IYS5tt95E1MQioQEz+q53gGNHLPDdncpSX5L+vkAwUnzb3eFv9RtOav6Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zAKHY7EB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C400A606A325;
	Thu, 19 Nov 2026 02:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zAKHY7EB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211541F000C4;
	Thu, 19 Nov 2026 02:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054197;
	bh=OPiVy7QymOIzh/sjhm5eUz514D9yaEjVHw4nJaadjAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zAKHY7EBIscrvD98QJFlXwYeZB5lC4OpxknLdrvhKx3kEkCW/0Lze58nCQFyHbXxR
	 mrGbEkp3p6OuvA6G6G1ZwWxfoKvfjsWuYemZ168/e4Sj18ByldlnORrQ5V4F3nX/sR
	 e17JhrP5iqbaCoOcNRx81Eu31Sr0YbO+KW0vfeaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Casciano <mauriziocasciano7@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1188/2214] power: supply: core: Honor supplied-from with CONFIG_OF=y
Date: Wed, 18 Nov 2026 15:47:44 +0100
Message-ID: <20261118150059.434325287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Maurizio Casciano <mauriziocasciano7@gmail.com>

[ Upstream commit 6bd80f22c764fe8c56c62c118387f86a3ca98cff ]

The supplied-from device property is the name-based counterpart to
firmware-node power-supplies references. It was added for non-DT platforms,
but its parser is compiled only when CONFIG_OF is disabled. CONFIG_OF is
a global kernel option, so x86 systems commonly enable it even when
individual power supplies are described by software nodes.

Consequently, these consumers never populate supplied_from and supplier
notifications do not reach their external_power_changed() callbacks. On a
Lenovo Yoga Book YB1-X91L, ftrace showed the Whiskey Cove supplier
notification running without invoking the BQ25892 callback, leaving the
input current limit at its boot-time value.

Use a single power_supply_check_supplies() implementation for all
configurations. Preserve firmware-node power-supplies references as the
preferred firmware description and use the name-based supplied-from
property only when no references are specified. Continue to honor an
explicitly provided supplied_from list first and propagate errors from
specified firmware references.

With the fix, ftrace shows the BQ25892 callback on hotplug. A boot-offline
test changes its input current limit from 500 mA to 2 A.

Fixes: 58a36bb06891 ("power: supply: core: Add support for supplied-from device-property")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Maurizio Casciano <mauriziocasciano7@gmail.com>
Link: https://patch.msgid.link/20260924225152.985489-1-mauriziocasciano7@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
[ sashal: Replaced generic firmware-node reference parsing with of_parse_phandle_with_fixed_args() to fit the existing device-tree model. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 81 +++++++++++-------------
 1 file changed, 38 insertions(+), 43 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 2ebf838fbf9d3..0701bf34e850e 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -154,7 +154,6 @@ static void power_supply_deferred_register_work(struct work_struct *work)
 		mutex_unlock(&psy->dev.parent->mutex);
 }
 
-#ifdef CONFIG_OF
 static int __power_supply_populate_supplied_from(struct device *dev,
 						 void *data)
 {
@@ -229,71 +228,68 @@ static int power_supply_find_supply_from_node(struct device_node *supply_node)
 
 static int power_supply_check_supplies(struct power_supply *psy)
 {
-	struct device_node *np;
-	int cnt = 0;
+	struct device *parent = psy->dev.parent;
+	struct of_phandle_args args;
+	int cnt, nval, ret;
 
 	/* If there is already a list honor it */
 	if (psy->supplied_from && psy->num_supplies > 0)
 		return 0;
 
-	/* No device node found, nothing to do */
-	if (!psy->of_node)
-		return 0;
-
-	do {
-		int ret;
+	for (cnt = 0; psy->of_node; cnt++) {
+		ret = of_parse_phandle_with_fixed_args(psy->of_node,
+						       "power-supplies", 0, cnt,
+						       &args);
+		if (ret) {
+			if (ret != -ENOENT)
+				return ret;
 
-		np = of_parse_phandle(psy->of_node, "power-supplies", cnt++);
-		if (!np)
 			break;
+		}
 
-		ret = power_supply_find_supply_from_node(np);
-		of_node_put(np);
+		ret = power_supply_find_supply_from_node(args.np);
+		of_node_put(args.np);
 
 		if (ret) {
 			dev_dbg(&psy->dev, "Failed to find supply!\n");
 			return ret;
 		}
-	} while (np);
-
-	/* Missing valid "power-supplies" entries */
-	if (cnt == 1)
-		return 0;
-
-	/* All supplies found, allocate char ** array for filling */
-	psy->supplied_from = devm_kzalloc(&psy->dev, sizeof(psy->supplied_from),
-					  GFP_KERNEL);
-	if (!psy->supplied_from)
-		return -ENOMEM;
-
-	*psy->supplied_from = devm_kcalloc(&psy->dev,
-					   cnt - 1, sizeof(char *),
-					   GFP_KERNEL);
-	if (!*psy->supplied_from)
-		return -ENOMEM;
+	}
 
-	return power_supply_populate_supplied_from(psy);
-}
-#else
-static int power_supply_check_supplies(struct power_supply *psy)
-{
-	int nval, ret;
+	if (cnt) {
+		/* All supplies found, allocate char ** array for filling */
+		psy->supplied_from = devm_kzalloc(&psy->dev,
+						  sizeof(psy->supplied_from),
+						  GFP_KERNEL);
+		if (!psy->supplied_from)
+			return -ENOMEM;
+
+		*psy->supplied_from = devm_kcalloc(&psy->dev,
+						   cnt, sizeof(char *),
+						   GFP_KERNEL);
+		if (!*psy->supplied_from)
+			return -ENOMEM;
+
+		return power_supply_populate_supplied_from(psy);
+	}
 
-	if (!psy->dev.parent)
+	/* Fall back to the name-based property if no references were specified. */
+	if (!parent)
 		return 0;
 
-	nval = device_property_read_string_array(psy->dev.parent,
-						 "supplied-from", NULL, 0);
+	nval = device_property_string_array_count(parent, "supplied-from");
 	if (nval <= 0)
 		return 0;
 
 	psy->supplied_from = devm_kmalloc_array(&psy->dev, nval,
-						sizeof(char *), GFP_KERNEL);
+						sizeof(*psy->supplied_from),
+						GFP_KERNEL);
 	if (!psy->supplied_from)
 		return -ENOMEM;
 
-	ret = device_property_read_string_array(psy->dev.parent,
-		"supplied-from", (const char **)psy->supplied_from, nval);
+	ret = device_property_read_string_array(parent, "supplied-from",
+						(const char **)psy->supplied_from,
+						nval);
 	if (ret < 0)
 		return ret;
 
@@ -301,7 +297,6 @@ static int power_supply_check_supplies(struct power_supply *psy)
 
 	return 0;
 }
-#endif
 
 struct psy_am_i_supplied_data {
 	struct power_supply *psy;
-- 
2.53.0



