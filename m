Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591620;
	b=SywXTfl0Hy7InK7egmuDbyqhlU7pOeVkiv7iV/Fz2G258xTVrWpCvREOfF2xBLzjnhCm
	 VbwNT1BZnQMKw71JJ1QLTBJaNoDicW/rH06LLXhFWi2HLX85e5dV4SnzYru+3vSpz7QO6
	 NcLDChBJuF6HeEseDzLX45VqM84fLFwBoG4KeM4Q5+q0vODUIm5/oAEvtWFS/vy7bsQda
	 h6vu45daq+GVK2WfJ031ZNSKfiUbHyM/grvFZQJRJEtg6FvNVfy8kUWau9AwH6FRd828G
	 a6CcfY6v02vxFftnPc6Tgmt9T7rHqHhXRhZIxJ95Vp/JzmFPhVYNi3wX3FAaQ6tpI/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AaIicqzSEIiAbYE/T7H5vohYXf+hAPlAj8UkJEUp8b4=;
	b=S79X0efLh5tWJiuwg/SIOaN6wezbWVbGO18g7D9mRVgh6SZOynPVItPNFARbmMY4AOrW
	 L7oaa2pWLOglmTOa5H0b5xKsAtypOWHddkW60Rk9UJQZlIJEYlta2sukGN6wMgbu20gAw
	 hMQulJkic5ZFe+w1U7XnM3FUnQVNwoYm0H1Dt174ZCkiSD1F+LdzYusntkzMGMJt05DsV
	 NfPrT31wniHpCH8XXq6mq30Xv1ZUCQLg+nJxKnR+ptHHZgVGTm6p4F/JT3p40KS5fXxU3
	 TNd9yrkRw3ca/pvV1jazRakH1SsbSHhP8m67MAKK7S6Moa6zE3defPnX2wYTQejHcUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h5Qu/7F+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD16607E83F;
	Fri, 13 Nov 2026 17:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5Qu/7F+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5EA1F000C4;
	Fri, 13 Nov 2026 17:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591620;
	bh=AaIicqzSEIiAbYE/T7H5vohYXf+hAPlAj8UkJEUp8b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5Qu/7F+VdvfaI+q7yjrPfpbSBQpiY0XuUCYdTOcFNKe6Sq95ghS2BhAU5QsQNMEi
	 61rDmKAUy0txp63Kla1cWW1yX1AK/glPrHxiu1tcpvyq7YK8y0F95RAevHPhOXxenr
	 YJoEWM1qbOY4cwVyAGqzVTaGhO4kXr5Ig01IreHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Casciano <mauriziocasciano7@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 661/670] power: supply: core: Honor supplied-from with CONFIG_OF=y
Date: Fri, 13 Nov 2026 10:53:45 -0500
Message-ID: <20261113153834.300502905@linuxfoundation.org>
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
[ sashal: adapted firmware-node supplier lookup to existing device-tree APIs using of_parse_phandle_with_fixed_args() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 90 ++++++++++++------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index ae0e11146a1fb..9610ea1c341d9 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -188,7 +188,35 @@ static void power_supply_deferred_register_work(struct work_struct *work)
 		mutex_unlock(&psy->dev.parent->mutex);
 }
 
-#ifdef CONFIG_OF
+static int power_supply_check_supplies_by_name(struct power_supply *psy)
+{
+	struct device *parent = psy->dev.parent;
+	int nval, ret;
+
+	if (!parent)
+		return 0;
+
+	nval = device_property_string_array_count(parent, "supplied-from");
+	if (nval <= 0)
+		return 0;
+
+	psy->supplied_from = devm_kmalloc_array(&psy->dev, nval,
+						sizeof(*psy->supplied_from),
+						GFP_KERNEL);
+	if (!psy->supplied_from)
+		return -ENOMEM;
+
+	ret = device_property_read_string_array(parent, "supplied-from",
+						(const char **)psy->supplied_from,
+						nval);
+	if (ret < 0)
+		return ret;
+
+	psy->num_supplies = nval;
+
+	return 0;
+}
+
 static int __power_supply_populate_supplied_from(struct power_supply *epsy,
 						 void *data)
 {
@@ -259,73 +287,45 @@ static int power_supply_find_supply_from_node(struct device_node *supply_node)
 
 static int power_supply_check_supplies(struct power_supply *psy)
 {
-	struct device_node *np;
-	int cnt = 0;
+	struct of_phandle_args args;
+	int cnt, ret;
 
 	/* If there is already a list honor it */
 	if (psy->supplied_from && psy->num_supplies > 0)
 		return 0;
 
-	/* No device node found, nothing to do */
-	if (!psy->dev.of_node)
-		return 0;
-
-	do {
-		int ret;
+	for (cnt = 0; psy->dev.of_node; cnt++) {
+		ret = of_parse_phandle_with_fixed_args(psy->dev.of_node,
+						       "power-supplies", 0, cnt, &args);
+		if (ret) {
+			if (ret != -ENOENT)
+				return ret;
 
-		np = of_parse_phandle(psy->dev.of_node, "power-supplies", cnt++);
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
+	}
 
-	/* Missing valid "power-supplies" entries */
-	if (cnt == 1)
-		return 0;
+	/* Fall back to the name-based property if no references were specified. */
+	if (!cnt)
+		return power_supply_check_supplies_by_name(psy);
 
 	/* All supplies found, allocate char * array for filling */
 	psy->supplied_from = devm_kcalloc(&psy->dev,
-					  cnt - 1, sizeof(*psy->supplied_from),
+					  cnt, sizeof(*psy->supplied_from),
 					  GFP_KERNEL);
 	if (!psy->supplied_from)
 		return -ENOMEM;
 
 	return power_supply_populate_supplied_from(psy);
 }
-#else
-static int power_supply_check_supplies(struct power_supply *psy)
-{
-	int nval, ret;
-
-	if (!psy->dev.parent)
-		return 0;
-
-	nval = device_property_string_array_count(psy->dev.parent, "supplied-from");
-	if (nval <= 0)
-		return 0;
-
-	psy->supplied_from = devm_kmalloc_array(&psy->dev, nval,
-						sizeof(char *), GFP_KERNEL);
-	if (!psy->supplied_from)
-		return -ENOMEM;
-
-	ret = device_property_read_string_array(psy->dev.parent,
-		"supplied-from", (const char **)psy->supplied_from, nval);
-	if (ret < 0)
-		return ret;
-
-	psy->num_supplies = nval;
-
-	return 0;
-}
-#endif
 
 struct psy_am_i_supplied_data {
 	struct power_supply *psy;
-- 
2.53.0



