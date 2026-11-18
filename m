Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038704;
	b=OT3ufGRnih7h38a6VWdHDmy0+ZSlNy1MU/RYqKSITXkUoEY29PF0i/4b3bkuBHXuAzec
	 3cY9VnORcYdvoXdmZe0mS64B/g2VPVORg7IQpNDAmRvxzhffrmZWmvf8Z8K10PF4/LkJ7
	 2j7aBY4fpO3G/11ZOhPzCkKCJl5DdKqnWd4E78wJ6QmJOBxVXQgTahBe9V70rlqMeuD9y
	 YUWziPPqdQWxK+tvMFzYt475sKRYcaiTUrUFGyqH1OKipYrsI5KO2zMeHIvCLSYpMCoxE
	 HfmQ7EINsVM4jy6oW/phJBQaFfNB9f+cj2N1mnlijOIoYfilwqL37NFYXZl+FTq0wuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B03STq3pJqhwgEi4sAgjJMjrdf3MXUF9+sa6NDqP4Y8=;
	b=PFfsK+ki5ftJAvMKSk8zJbPimLupjSNpVyJZ4wVZw33kW1ljl2IO6qTiEywdmf+CD8K8
	 JzLTa+42gYEtFSixhEgCL26/bZc86CcnuHpHJEK1ibMhh6zVc859/dINiBUlHEIHTrIi/
	 ZDYuIB9fV/+3YTbFs4FXqEALOopIEzKNMI5tav/3V8eRe+E4ZXmvuPW67w/MiNANyoLvl
	 QDxZYtC8QoYL328Abyd3rMCGEuRbMFOhAYMEJfebyRmhKrbYJm/YdTQm8RodbqgPicyQE
	 K0WOAoaz9zfPJ/hIh/vj1lCf8+k/bFa5XzTQW1ZfdwH/LeUWjXfWnJs4ircb77PWB2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vc9HbA3N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C85B606A31C;
	Wed, 18 Nov 2026 21:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vc9HbA3N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B3D1F000C4;
	Wed, 18 Nov 2026 21:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038704;
	bh=B03STq3pJqhwgEi4sAgjJMjrdf3MXUF9+sa6NDqP4Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vc9HbA3NWi1jTUKW+h469CtFB17nlyMJJyKgfeSJr3Ga63U741QSv6BTWWe/V1eA4
	 3NEEhaOIXGLJU5X2R+03Q77bVFjXPCWMgsSZ/VxhpACGNbAS4Il5M+B1Wi8eEX3+oF
	 DsOhZNYv5RsLmL9N/leds9M1mWwOrgDi98Tl0u4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Casciano <mauriziocasciano7@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1839/3318] power: supply: core: Honor supplied-from with CONFIG_OF=y
Date: Wed, 18 Nov 2026 15:41:01 +0100
Message-ID: <20261118150417.028246547@linuxfoundation.org>
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
[ sashal: adapted fwnode reference parsing to of_parse_phandle_with_fixed_args() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 90 ++++++++++++------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index a55b85ffe3337..c09fd5fbd941a 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -185,7 +185,35 @@ static void power_supply_deferred_register_work(struct work_struct *work)
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
@@ -256,73 +284,45 @@ static int power_supply_find_supply_from_node(struct device_node *supply_node)
 
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



