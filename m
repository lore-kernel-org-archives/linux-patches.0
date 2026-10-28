Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215950;
	b=giiCoWLN0H9TJopCN/I1Z5GukTh+TOw6fP6FNmDgjO8cAjeSb9ybWmUbUT7nFuqN3ngH
	 8pMXkEhJpX9hwBEMlIXEkTsVwCx2VrR6mcvH5ktkYcBdUWDBvsDJqjMgh8YSvBWLK/mR+
	 8H21qv/Kng61MoOImOdDpGBoyGJ4QVmdio6Ju5PhmDLcsc31Jwl/gJn0+kTn2CtOzz2oB
	 NQxohuyfeTBCBWGjmPiP8knG4ufx/ob4286zT7IaOw3J5QYdY3HhPsMoodC8YWGp9lTIL
	 45ypK6U+gJraJ2jHRyleaqmyoUIRMf7KVFJ/ojWKhlUXjw+KC0bBCIhQcLO67o7wOwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pT8o8j6qXc/afwRV2tWpHYNC4NLO4zHXHaH14hJ5KoI=;
	b=tmtcHjY6QPAssPTNVCCo7xYz3r1HtmOWoQm+vIOViS6IOSxJCPvf/w6dC9/vZQAN/qj5
	 zjCXrnJolormw3C+a6mM/7QxoeXCfF321KCB7peoTWtSAPl3R8GxPlBzvDsOjHi0llFC6
	 ApkB4jJ/8wsPJWGWSWxhdNqDAAaMtAw3o4zVZXbfYAyMo5pJSnsL3dSoEy85gAI3xNK4P
	 F7xL3yykqDql6zQSZo4CRk+PecaG8vnfKH5vkR7/RygP2hEUNyzweYsnXV1xrR9nlLTeO
	 XxxAUq2CMZNjIivgS4i5rSxnaZQ27jjpBqlTxrtK+Cm6h0rLVUiosb4qtKyW/kIJGfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdpisgZA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8FF606A31E;
	Wed, 28 Oct 2026 19:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdpisgZA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE18E1F01825;
	Wed, 28 Oct 2026 19:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215950;
	bh=pT8o8j6qXc/afwRV2tWpHYNC4NLO4zHXHaH14hJ5KoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pdpisgZA8ZF+3PNj1sCi7JsETp4ozXwo6F37h62ATHYV80AQPlJSGRGMHRRj3/eTD
	 bL8Z6o8IEEFKBck1q8qj8EkRwi4KiEuh9WqnQBC8PZRytacdqlp3iVliFl3ykYWqcu
	 BNOnI1LnfS7dvWchhz4eRUPitgtM7PoTezJGnyBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1389/1887] power: supply: charger-manager: register regulators before exposing sysfs
Date: Wed, 28 Oct 2026 17:58:05 +0100
Message-ID: <20261028170531.060357464@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit c57cb36f76eb7ced45f57af1a890d8f3a6d76342 ]

charger_manager_remove() and the err_reg_extcon probe error path free each
charger regulator with regulator_put() before tearing down the power_supply
sysfs entries (power_supply_unregister()). charger_manager_remove() also
calls try_charger_enable(cm, false) after the regulator_put() loop. A
concurrent write to a charger's externally_control sysfs attribute that
lands between regulator_put() and power_supply_unregister() can run
charger_externally_control_store() and call try_charger_enable(), which,
when charging is enabled, dereferences the already-freed consumer handle.
When charging is enabled, try_charger_enable(cm, false) in .remove() also
dereferences the freed handles directly. Both leave use-after-free windows.
Symmetrically, probe registers the sysfs entries (power_supply_register)
before acquiring the regulators (regulator_get, inside
charger_manager_register_extcon), so userspace can reach externally_control
before the regulators are available.

Split charger_manager_register_extcon() on the sync/async boundary:
charger_manager_get_regulators() (regulator_get only, no async producer)
now runs before power_supply_register() so sysfs is not live before
regulators are available, and charger_manager_register_extcon() keeps only
the extcon notifier/work setup, still after power_supply_register() so a
power_supply_register() failure cannot reach extcon setup. This keeps the
sysfs setup/teardown ordering symmetric without introducing an asynchronous
producer on the earlier probe-error path.

Move power_supply_unregister() and try_charger_enable(cm, false) ahead of
the regulator_put() loop on both teardown paths, and adjust err_reg_extcon
(power_supply_unregister() then fall through err_regulator for
regulator_put(); get_regulators self-rolls back on its own failure).

This does not address the separate extcon-notifier-driven deref of the same
handles, which needs its own synchronization design.

Found by an in-house static analysis tool.

Fixes: 3950c7865cd7 ("charger-manager: Add support sysfs entry for charger")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260728030123.230202-1-fanwu01@zju.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/charger-manager.c | 54 +++++++++++++++++++-------
 1 file changed, 39 insertions(+), 15 deletions(-)

diff --git a/drivers/power/supply/charger-manager.c b/drivers/power/supply/charger-manager.c
index a20e7aaffbaa8..7f7ddecf2250b 100644
--- a/drivers/power/supply/charger-manager.c
+++ b/drivers/power/supply/charger-manager.c
@@ -1017,6 +1017,29 @@ static int charger_extcon_init(struct charger_manager *cm,
 	return 0;
 }
 
+static int charger_manager_get_regulators(struct charger_manager *cm)
+{
+	struct charger_desc *desc = cm->desc;
+	struct charger_regulator *charger;
+	int i, ret;
+
+	for (i = 0; i < desc->num_charger_regulators; i++) {
+		charger = &desc->charger_regulators[i];
+		charger->consumer = regulator_get(cm->dev,
+						  charger->regulator_name);
+		if (IS_ERR(charger->consumer)) {
+			dev_err(cm->dev, "Cannot find charger(%s)\n",
+				charger->regulator_name);
+			ret = PTR_ERR(charger->consumer);
+			while (i-- > 0)
+				regulator_put(desc->charger_regulators[i].consumer);
+			return ret;
+		}
+		charger->cm = cm;
+	}
+	return 0;
+}
+
 /**
  * charger_manager_register_extcon - Register extcon device to receive state
  *				     of charger cable.
@@ -1039,15 +1062,6 @@ static int charger_manager_register_extcon(struct charger_manager *cm)
 	for (i = 0; i < desc->num_charger_regulators; i++) {
 		charger = &desc->charger_regulators[i];
 
-		charger->consumer = regulator_get(cm->dev,
-					charger->regulator_name);
-		if (IS_ERR(charger->consumer)) {
-			dev_err(cm->dev, "Cannot find charger(%s)\n",
-				charger->regulator_name);
-			return PTR_ERR(charger->consumer);
-		}
-		charger->cm = cm;
-
 		for (j = 0; j < charger->num_cables; j++) {
 			struct charger_cable *cable = &charger->cables[j];
 
@@ -1582,13 +1596,23 @@ static int charger_manager_probe(struct platform_device *pdev)
 	}
 	psy_cfg.attr_grp = desc->sysfs_groups;
 
+	/*
+	 * Acquire charger regulators before exposing the sysfs entries, so
+	 * userspace cannot reach externally_control before the regulators
+	 * (and charger->cm) are available.  Mirrors the order in remove().
+	 */
+	ret = charger_manager_get_regulators(cm);
+	if (ret < 0)
+		return ret;
+
 	cm->charger_psy = power_supply_register(&pdev->dev,
 						&cm->charger_psy_desc,
 						&psy_cfg);
 	if (IS_ERR(cm->charger_psy)) {
 		dev_err(&pdev->dev, "Cannot register charger-manager with name \"%s\"\n",
 			cm->charger_psy_desc.name);
-		return PTR_ERR(cm->charger_psy);
+		ret = PTR_ERR(cm->charger_psy);
+		goto err_regulator;
 	}
 
 	/* Register extcon device for charger cable */
@@ -1622,11 +1646,11 @@ static int charger_manager_probe(struct platform_device *pdev)
 	return 0;
 
 err_reg_extcon:
+	power_supply_unregister(cm->charger_psy);
+err_regulator:
 	for (i = 0; i < desc->num_charger_regulators; i++)
 		regulator_put(desc->charger_regulators[i].consumer);
 
-	power_supply_unregister(cm->charger_psy);
-
 	return ret;
 }
 
@@ -1644,12 +1668,12 @@ static void charger_manager_remove(struct platform_device *pdev)
 	cancel_work_sync(&setup_polling);
 	cancel_delayed_work_sync(&cm_monitor_work);
 
-	for (i = 0 ; i < desc->num_charger_regulators ; i++)
-		regulator_put(desc->charger_regulators[i].consumer);
+	try_charger_enable(cm, false);
 
 	power_supply_unregister(cm->charger_psy);
 
-	try_charger_enable(cm, false);
+	for (i = 0 ; i < desc->num_charger_regulators ; i++)
+		regulator_put(desc->charger_regulators[i].consumer);
 }
 
 static const struct platform_device_id charger_manager_id[] = {
-- 
2.53.0



