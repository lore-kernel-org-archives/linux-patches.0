Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059864;
	b=URm392SIEBat2/xIxf4ogruf0wa9wssYiyCrLLnkQVhBgY3Ve5fDF89CDXrqvyhqaDTE
	 DYP1VEgN5RRyewXxjo7tuyo/x6fmk2Pyg480CYdNUbMgO6E+ajoJNHbvr9nLgchrBxZMr
	 S7jba5liT4rnqJOt+EQ0+zcjknEWV0g1qDKaLiF7dGRpKI+f9M9EFqefpp5ndJzKeeD6I
	 06nlGJHbopRsFQc+9ve1rAFvhjzJ+SNTVB+C7nehTcMxz3mDf2XRdtvQ0Oqu4DIX0iYBU
	 GKd1ENZuxrizIPD+MLWyHxmEoacjzkFkU1OGqGtmqxLPVMhEqv430XetXCH+Hw+iz4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sUJndAH84dLJS9kh622gytvIP1Wt91DVLm6ffYrC5QI=;
	b=0M5yudLY24qkz8NBNmF6NWzzpZ6LePffaZ4BnRHcoEvf1NAZAz0IWdTNGwTLUJIYDi8s
	 LYuD+4JCzRsM9HpdKWqGgay4QxP1vBzrem04PSNn9p6joFgdOAuA8kvi++vWk0DZw8FVq
	 DS7hVhbgm+ySlcKDEnT2S7AiixygBmPMO9WnB+rw86LOyXKx/fM8VUo0GL7OOXXN/1d46
	 4mglC8qiNwrEMAmMzx/pEzJFFYMbNL3jjzzNs+TR0AaYupMh/ivSahpIshbhpgpfZPymy
	 vZmEWjOVxxjAlRm+PoSfEoSt8l2V3jqMSH9gr0IVEOf4gnDdTQdfil/G/xVXbE61IUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BJTH/8rx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D740606A320;
	Thu, 19 Nov 2026 03:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BJTH/8rx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9727D1F000C4;
	Thu, 19 Nov 2026 03:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059864;
	bh=sUJndAH84dLJS9kh622gytvIP1Wt91DVLm6ffYrC5QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BJTH/8rxzjynigp8re2T5l+nUFBm76VlTjDB8COjyLk14fx/wmFyJuAsyfNCwNpKt
	 n+lP6pi4RU1PPuXHJ02FYno82ylNn4Q92rK0kgR1u0XzjQkS0b/MLIsTR0r2SK5tac
	 JuIITTnxcm8PIdk2K9EbX2nM2xeB2sPp1A9Rkcjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Casciano <mauriziocasciano7@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0994/1848] power: supply: core: Honor supplied-from with CONFIG_OF=y
Date: Wed, 18 Nov 2026 15:50:32 +0100
Message-ID: <20261118145958.474516049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced fwnode_find_reference() with of_parse_phandle_with_fixed_args() to use existing OF nodes ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 81 +++++++++++-------------
 1 file changed, 38 insertions(+), 43 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 61ba2b343b938..2a382617900ef 100644
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



