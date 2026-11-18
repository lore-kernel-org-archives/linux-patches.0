Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038699;
	b=l8ZUyPNLffwMIv4SPsA07Lu7ZN3dvcsrX72v2ye7WJUcpHR5LTJgEYQrqCzJMDNKhPZj
	 Ca3mARYWqEVHhSBV1YV4vPc2nkrm5t6QlS8Db9eXMwyaVJbnfI/kJ89fYGqlmzQCVXNNv
	 xZ7PuLm70nOz65wbRLrxFbOLs0QsOQi//cFRl9NbD/v42aFsOjcAKGBf+Cx3YKYsarlgS
	 eC7PTL7xi0IuYG8H+sdbYVRBDz7Z37zuSEYWblVDD8PywDE02bbi8FhVQSKIcQ2Sg03+J
	 xILO62c7AOkyBll5PWe5Z4bsuTxTmnFwN9xtGOr9cjSVknly341VGoOkJY+KNITRyeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GPeG3f1on33P/ATq2eWuJoo3GwRUFRgj9XDrZmPA6Ys=;
	b=PJGFNg0QIS+ZnM4F5ow0LTIF/+LSDcEZsLKl9r5udbLrCq/64OtyOLtsbjc7NBXJaRk1
	 mRL9tdvQgKbV2nb2nntSzkVZNO7dXtEPNwex614KdlqBLV/+B5lboRtIAfbhpl00virOM
	 7ZAoMYEw7KKC1EKOGMgjagt0/z63UoJ+8/g1ZIKUlFN2onheOZsk0snTgpI7lHbT2K1VR
	 88/fGdUwDZQ0ZzErc7gNCSmRdnUwhzDN8r4oOjrNR5Psrwu5XPCzKrarvCj1PYSjdb7U2
	 FRWO0g4wEARFSr1v32kGCfWAXXRa0tPW2ug7ElKxb/dDXvmxKFefd+8w1WS1sgeCOtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eIce32k7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236F0606A320;
	Wed, 18 Nov 2026 21:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eIce32k7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737B31F000C5;
	Wed, 18 Nov 2026 21:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038699;
	bh=GPeG3f1on33P/ATq2eWuJoo3GwRUFRgj9XDrZmPA6Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eIce32k7Vh3rlC6h46j6tatI2M/3qK+fkTKLUoB51cZE4GCfNJ+gBEyRolXhGzd/O
	 IEBejwROBtQnoSFYaUNmH5O8t2bXwd/kUdYg3/yLiuNKsdbgs+Te8Srkn0ePPBD1Ee
	 sU6IZhdMHyJg05iDLLcZbtx6/7AWVzDEo+vyvqtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1837/3318] power: supply: core: use power_supply_for_each_psy()
Date: Wed, 18 Nov 2026 15:40:59 +0100
Message-ID: <20261118150416.970699364@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 68abaf7323ae857db7ec56a174b7bbf5fc687d47 ]

Simplify the callbacks by removing the need to convert a 'struct device'
into a 'struct power_supply'.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20241210-power-supply-dev_to_psy-v2-3-9d8c9d24cfe4@weissschuh.net
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 6bd80f22c764 ("power: supply: core: Honor supplied-from with CONFIG_OF=y")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 36 ++++++++++--------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 260de00996bc1..2929e21b82032 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -63,10 +63,9 @@ static bool __power_supply_is_supplied_by(struct power_supply *supplier,
 	return false;
 }
 
-static int __power_supply_changed_work(struct device *dev, void *data)
+static int __power_supply_changed_work(struct power_supply *pst, void *data)
 {
 	struct power_supply *psy = data;
-	struct power_supply *pst = dev_get_drvdata(dev);
 
 	if (__power_supply_is_supplied_by(psy, pst)) {
 		if (pst->desc->external_power_changed)
@@ -95,7 +94,7 @@ static void power_supply_changed_work(struct work_struct *work)
 	if (likely(psy->changed)) {
 		psy->changed = false;
 		spin_unlock_irqrestore(&psy->changed_lock, flags);
-		power_supply_for_each_device(psy, __power_supply_changed_work);
+		power_supply_for_each_psy(psy, __power_supply_changed_work);
 		power_supply_update_leds(psy);
 		blocking_notifier_call_chain(&power_supply_notifier,
 				PSY_EVENT_PROP_CHANGED, psy);
@@ -187,11 +186,10 @@ static void power_supply_deferred_register_work(struct work_struct *work)
 }
 
 #ifdef CONFIG_OF
-static int __power_supply_populate_supplied_from(struct device *dev,
+static int __power_supply_populate_supplied_from(struct power_supply *epsy,
 						 void *data)
 {
 	struct power_supply *psy = data;
-	struct power_supply *epsy = dev_get_drvdata(dev);
 	struct device_node *np;
 	int i = 0;
 
@@ -218,20 +216,19 @@ static int power_supply_populate_supplied_from(struct power_supply *psy)
 {
 	int error;
 
-	error = power_supply_for_each_device(psy, __power_supply_populate_supplied_from);
+	error = power_supply_for_each_psy(psy, __power_supply_populate_supplied_from);
 
 	dev_dbg(&psy->dev, "%s %d\n", __func__, error);
 
 	return error;
 }
 
-static int  __power_supply_find_supply_from_node(struct device *dev,
+static int  __power_supply_find_supply_from_node(struct power_supply *epsy,
 						 void *data)
 {
 	struct device_node *np = data;
-	struct power_supply *epsy = dev_get_drvdata(dev);
 
-	/* returning non-zero breaks out of power_supply_for_each_device loop */
+	/* returning non-zero breaks out of power_supply_for_each_psy loop */
 	if (epsy->of_node == np)
 		return 1;
 
@@ -243,16 +240,16 @@ static int power_supply_find_supply_from_node(struct device_node *supply_node)
 	int error;
 
 	/*
-	 * power_supply_for_each_device() either returns its own errors or values
+	 * power_supply_for_each_psy() either returns its own errors or values
 	 * returned by __power_supply_find_supply_from_node().
 	 *
 	 * __power_supply_find_supply_from_node() will return 0 (no match)
 	 * or 1 (match).
 	 *
-	 * We return 0 if power_supply_for_each_device() returned 1, -EPROBE_DEFER if
+	 * We return 0 if power_supply_for_each_psy() returned 1, -EPROBE_DEFER if
 	 * it returned 0, or error as returned by it.
 	 */
-	error = power_supply_for_each_device(supply_node, __power_supply_find_supply_from_node);
+	error = power_supply_for_each_psy(supply_node, __power_supply_find_supply_from_node);
 
 	return error ? (error == 1 ? 0 : error) : -EPROBE_DEFER;
 }
@@ -332,10 +329,9 @@ struct psy_am_i_supplied_data {
 	unsigned int count;
 };
 
-static int __power_supply_am_i_supplied(struct device *dev, void *_data)
+static int __power_supply_am_i_supplied(struct power_supply *epsy, void *_data)
 {
 	union power_supply_propval ret = {0,};
-	struct power_supply *epsy = dev_get_drvdata(dev);
 	struct psy_am_i_supplied_data *data = _data;
 
 	if (__power_supply_is_supplied_by(epsy, data->psy)) {
@@ -353,7 +349,7 @@ int power_supply_am_i_supplied(struct power_supply *psy)
 	struct psy_am_i_supplied_data data = { psy, 0 };
 	int error;
 
-	error = power_supply_for_each_device(&data, __power_supply_am_i_supplied);
+	error = power_supply_for_each_psy(&data, __power_supply_am_i_supplied);
 
 	dev_dbg(&psy->dev, "%s count %u err %d\n", __func__, data.count, error);
 
@@ -364,10 +360,9 @@ int power_supply_am_i_supplied(struct power_supply *psy)
 }
 EXPORT_SYMBOL_GPL(power_supply_am_i_supplied);
 
-static int __power_supply_is_system_supplied(struct device *dev, void *data)
+static int __power_supply_is_system_supplied(struct power_supply *psy, void *data)
 {
 	union power_supply_propval ret = {0,};
-	struct power_supply *psy = dev_get_drvdata(dev);
 	unsigned int *count = data;
 
 	if (!psy->desc->get_property(psy, POWER_SUPPLY_PROP_SCOPE, &ret))
@@ -388,7 +383,7 @@ int power_supply_is_system_supplied(void)
 	int error;
 	unsigned int count = 0;
 
-	error = power_supply_for_each_device(&count, __power_supply_is_system_supplied);
+	error = power_supply_for_each_psy(&count, __power_supply_is_system_supplied);
 
 	/*
 	 * If no system scope power class device was found at all, most probably we
@@ -407,9 +402,8 @@ struct psy_get_supplier_prop_data {
 	union power_supply_propval *val;
 };
 
-static int __power_supply_get_supplier_property(struct device *dev, void *_data)
+static int __power_supply_get_supplier_property(struct power_supply *epsy, void *_data)
 {
-	struct power_supply *epsy = dev_get_drvdata(dev);
 	struct psy_get_supplier_prop_data *data = _data;
 
 	if (__power_supply_is_supplied_by(epsy, data->psy))
@@ -434,7 +428,7 @@ int power_supply_get_property_from_supplier(struct power_supply *psy,
 	 * This function is not intended for use with a supply with multiple
 	 * suppliers, we simply pick the first supply to report the psp.
 	 */
-	ret = power_supply_for_each_device(&data, __power_supply_get_supplier_property);
+	ret = power_supply_for_each_psy(&data, __power_supply_get_supplier_property);
 	if (ret < 0)
 		return ret;
 	if (ret == 0)
-- 
2.53.0



