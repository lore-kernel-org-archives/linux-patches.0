Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038812;
	b=Evqpmt77KMh4IYYCXizP26IUPot4X8vpC9FLLwN83cNIMmGeZjOsx853HgyJb92kFwuI
	 iN6wgtPGlqUSohHLwJRyk1oP9igVU0pH85VBI26aO0GXfoRc2EV0YZmf0lQcboDinjiI4
	 KR+0QfZMouX/TvYveWCREnbSZXpDslN4W5tDB9mL0ShZKgkBw/LIA1ZTJQQyNizXdAHB4
	 bVxVIFIeCvBkxUNw8qhqLzfmTG96T7xgulwZGIIKbNSoAvc8idbcxWrPr6fFLGtrH0Z+q
	 QKGJ3BUO8G3aSI8i2Xdg5vPznRobj/5kl9PPZJiP9n6VlExccOjvFjfWaAZ3RMmEMkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TxxlDOwA2A7cnIMOL6VzsXAyXZJpzasI7eGDNoPgGMc=;
	b=Y/0Uaotb7jV/5SfwbfzWojIbql0DMYSoodFG2f4RNcSSPj8eetUrBX/hIbC/kiOt9X5X
	 CPNUc3M3/7oeaf9TlD086uoppMt7pIwx4L7O/9JR7YjmL9QlmyQDK36nK3XnRsnUt3DSw
	 KAITuE7WjfU86VuM/oh16ETb7wfXDKoArLC63do/YcPben/crFvdIMZs4EbRZFdSsrALu
	 4k2JbM8U9RK7kXjuDwGS0xE7HJBoVGeLEZGEYR0hVfAxL8Yr6GbwNsc6ijjtYYlox4Z43
	 K4kqhs1NrVeEgTD2bZKoNL3pnATLy4c2eieq0cVlmHpBL5mIFtjg9SHHWyVb8LsexLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rLtgBDvr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B46606A32C;
	Wed, 18 Nov 2026 21:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rLtgBDvr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2297E1F000C5;
	Wed, 18 Nov 2026 21:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038812;
	bh=TxxlDOwA2A7cnIMOL6VzsXAyXZJpzasI7eGDNoPgGMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rLtgBDvrZ7DLbUxDg4Fc0gXK+WMTu79pywBtmGM6vgoXrxWW9BRXXQM7royo6KmMH
	 HFYxmmMyI/usPOf3gHJTWKg8mCCW5XfmA1Rh3cg6zPXhFkq/SQIAqhJ+XUXfu9yAtp
	 KuqMkSpNzFmHklZOM+NdvfFx5J1sn3wcCvJDXDWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ricardo B. Marliere" <ricardo@marliere.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1834/3318] power: supply: core: make power_supply_class constant
Date: Wed, 18 Nov 2026 15:40:56 +0100
Message-ID: <20261118150416.880899476@linuxfoundation.org>
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

From: Ricardo B. Marliere <ricardo@marliere.net>

[ Upstream commit 71c2cc5cbf686c2397f43cbcb51a31589bdcee7b ]

Since commit 43a7206b0963 ("driver core: class: make class_register() take
a const *"), the driver core allows for struct class to be in read-only
memory, so move the power_supply_class structure to be declared at build
time placing it into read-only memory, instead of having to be dynamically
allocated at boot time.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20240301-class_cleanup-power-v1-1-97e0b7bf9c94@marliere.net
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 6bd80f22c764 ("power: supply: core: Honor supplied-from with CONFIG_OF=y")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_btemp.c      |  2 +-
 drivers/power/supply/ab8500_chargalg.c   |  2 +-
 drivers/power/supply/ab8500_charger.c    |  2 +-
 drivers/power/supply/ab8500_fg.c         |  2 +-
 drivers/power/supply/apm_power.c         |  2 +-
 drivers/power/supply/power_supply_core.c | 39 +++++++++++++-----------
 include/linux/power_supply.h             |  2 +-
 7 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/power/supply/ab8500_btemp.c b/drivers/power/supply/ab8500_btemp.c
index ce36d6ca34226..3ea01301da9ff 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -617,7 +617,7 @@ static int ab8500_btemp_get_ext_psy_data(struct device *dev, void *data)
  */
 static void ab8500_btemp_external_power_changed(struct power_supply *psy)
 {
-	class_for_each_device(power_supply_class, NULL, psy,
+	class_for_each_device(&power_supply_class, NULL, psy,
 			      ab8500_btemp_get_ext_psy_data);
 }
 
diff --git a/drivers/power/supply/ab8500_chargalg.c b/drivers/power/supply/ab8500_chargalg.c
index 2205ea0834a61..faff6f7f38054 100644
--- a/drivers/power/supply/ab8500_chargalg.c
+++ b/drivers/power/supply/ab8500_chargalg.c
@@ -1231,7 +1231,7 @@ static void ab8500_chargalg_algorithm(struct ab8500_chargalg *di)
 	int ret;
 
 	/* Collect data from all power_supply class devices */
-	class_for_each_device(power_supply_class, NULL,
+	class_for_each_device(&power_supply_class, NULL,
 		di->chargalg_psy, ab8500_chargalg_get_ext_psy_data);
 
 	ab8500_chargalg_end_of_charge(di);
diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index c6d513953b042..39eeeb10b5b04 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -1949,7 +1949,7 @@ static void ab8500_charger_check_vbat_work(struct work_struct *work)
 	struct ab8500_charger *di = container_of(work,
 		struct ab8500_charger, check_vbat_work.work);
 
-	class_for_each_device(power_supply_class, NULL,
+	class_for_each_device(&power_supply_class, NULL,
 			      &di->usb_chg, ab8500_charger_get_ext_psy_data);
 
 	/* First run old_vbat is 0. */
diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index b8b96e3225b27..178394a7b289a 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -2408,7 +2408,7 @@ static int ab8500_fg_init_hw_registers(struct ab8500_fg *di)
  */
 static void ab8500_fg_external_power_changed(struct power_supply *psy)
 {
-	class_for_each_device(power_supply_class, NULL, psy,
+	class_for_each_device(&power_supply_class, NULL, psy,
 			      ab8500_fg_get_ext_psy_data);
 }
 
diff --git a/drivers/power/supply/apm_power.c b/drivers/power/supply/apm_power.c
index 50b9636945599..0bde81dd22e6c 100644
--- a/drivers/power/supply/apm_power.c
+++ b/drivers/power/supply/apm_power.c
@@ -79,7 +79,7 @@ static void find_main_battery(void)
 	main_battery = NULL;
 	bp.main = main_battery;
 
-	error = class_for_each_device(power_supply_class, NULL, &bp,
+	error = class_for_each_device(&power_supply_class, NULL, &bp,
 				      __find_main_battery);
 	if (error) {
 		main_battery = bp.main;
diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 4f350db05efa0..43f72ca0cbe4f 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -26,7 +26,10 @@
 #include "samsung-sdi-battery.h"
 
 /* exported for the APM Power driver, APM emulation */
-struct class *power_supply_class;
+const struct class power_supply_class = {
+	.name = "power_supply",
+	.dev_uevent = power_supply_uevent,
+};
 EXPORT_SYMBOL_GPL(power_supply_class);
 
 BLOCKING_NOTIFIER_HEAD(power_supply_notifier);
@@ -94,7 +97,7 @@ static void power_supply_changed_work(struct work_struct *work)
 	if (likely(psy->changed)) {
 		psy->changed = false;
 		spin_unlock_irqrestore(&psy->changed_lock, flags);
-		class_for_each_device(power_supply_class, NULL, psy,
+		class_for_each_device(&power_supply_class, NULL, psy,
 				      __power_supply_changed_work);
 		power_supply_update_leds(psy);
 		blocking_notifier_call_chain(&power_supply_notifier,
@@ -188,7 +191,7 @@ static int power_supply_populate_supplied_from(struct power_supply *psy)
 {
 	int error;
 
-	error = class_for_each_device(power_supply_class, NULL, psy,
+	error = class_for_each_device(&power_supply_class, NULL, psy,
 				      __power_supply_populate_supplied_from);
 
 	dev_dbg(&psy->dev, "%s %d\n", __func__, error);
@@ -223,8 +226,8 @@ static int power_supply_find_supply_from_node(struct device_node *supply_node)
 	 * We return 0 if class_for_each_device() returned 1, -EPROBE_DEFER if
 	 * it returned 0, or error as returned by it.
 	 */
-	error = class_for_each_device(power_supply_class, NULL, supply_node,
-				       __power_supply_find_supply_from_node);
+	error = class_for_each_device(&power_supply_class, NULL, supply_node,
+				      __power_supply_find_supply_from_node);
 
 	return error ? (error == 1 ? 0 : error) : -EPROBE_DEFER;
 }
@@ -325,7 +328,7 @@ int power_supply_am_i_supplied(struct power_supply *psy)
 	struct psy_am_i_supplied_data data = { psy, 0 };
 	int error;
 
-	error = class_for_each_device(power_supply_class, NULL, &data,
+	error = class_for_each_device(&power_supply_class, NULL, &data,
 				      __power_supply_am_i_supplied);
 
 	dev_dbg(&psy->dev, "%s count %u err %d\n", __func__, data.count, error);
@@ -361,7 +364,7 @@ int power_supply_is_system_supplied(void)
 	int error;
 	unsigned int count = 0;
 
-	error = class_for_each_device(power_supply_class, NULL, &count,
+	error = class_for_each_device(&power_supply_class, NULL, &count,
 				      __power_supply_is_system_supplied);
 
 	/*
@@ -408,7 +411,7 @@ int power_supply_get_property_from_supplier(struct power_supply *psy,
 	 * This function is not intended for use with a supply with multiple
 	 * suppliers, we simply pick the first supply to report the psp.
 	 */
-	ret = class_for_each_device(power_supply_class, NULL, &data,
+	ret = class_for_each_device(&power_supply_class, NULL, &data,
 				    __power_supply_get_supplier_property);
 	if (ret < 0)
 		return ret;
@@ -454,8 +457,8 @@ static int power_supply_match_device_by_name(struct device *dev, const void *dat
 struct power_supply *power_supply_get_by_name(const char *name)
 {
 	struct power_supply *psy = NULL;
-	struct device *dev = class_find_device(power_supply_class, NULL, name,
-					power_supply_match_device_by_name);
+	struct device *dev = class_find_device(&power_supply_class, NULL, name,
+					       power_supply_match_device_by_name);
 
 	if (dev) {
 		psy = dev_get_drvdata(dev);
@@ -509,8 +512,8 @@ struct power_supply *power_supply_get_by_phandle(struct device_node *np,
 	if (!power_supply_np)
 		return ERR_PTR(-ENODEV);
 
-	dev = class_find_device(power_supply_class, NULL, power_supply_np,
-						power_supply_match_device_node);
+	dev = class_find_device(&power_supply_class, NULL, power_supply_np,
+				power_supply_match_device_node);
 
 	of_node_put(power_supply_np);
 
@@ -1362,7 +1365,7 @@ __power_supply_register(struct device *parent,
 
 	device_initialize(dev);
 
-	dev->class = power_supply_class;
+	dev->class = &power_supply_class;
 	dev->type = &power_supply_dev_type;
 	dev->parent = parent;
 	dev->release = power_supply_dev_release;
@@ -1609,12 +1612,12 @@ EXPORT_SYMBOL_GPL(power_supply_get_drvdata);
 
 static int __init power_supply_class_init(void)
 {
-	power_supply_class = class_create("power_supply");
+	int err;
 
-	if (IS_ERR(power_supply_class))
-		return PTR_ERR(power_supply_class);
+	err = class_register(&power_supply_class);
+	if (err)
+		return err;
 
-	power_supply_class->dev_uevent = power_supply_uevent;
 	power_supply_init_attrs(&power_supply_dev_type);
 
 	return 0;
@@ -1622,7 +1625,7 @@ static int __init power_supply_class_init(void)
 
 static void __exit power_supply_class_exit(void)
 {
-	class_destroy(power_supply_class);
+	class_unregister(&power_supply_class);
 }
 
 subsys_initcall(power_supply_class_init);
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index aa20bf8c3366d..87cd0fefc1dc2 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -896,7 +896,7 @@ extern int power_supply_powers(struct power_supply *psy, struct device *dev);
 
 extern void *power_supply_get_drvdata(struct power_supply *psy);
 /* For APM emulation, think legacy userspace. */
-extern struct class *power_supply_class;
+extern const struct class power_supply_class;
 
 static inline bool power_supply_is_amp_property(enum power_supply_property psp)
 {
-- 
2.53.0



