Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215437;
	b=cCGnVM0wDqeRza5+m+dtSIhEt7HUKg910mkO2a/omVO+Jtipgs2yIJ9tm77fY74b5qb3
	 8BQAG+b3AA0IXdX3PruVrocIf9zeF91vJKki0wp6tPe8ZQQv2I6zopfreK/Ur3YCvf4GZ
	 AQoHTx7AK1KIdZwjI1SrhPrzkgQsry+dPQDVJWtM5RuV/eMfHjpIIFKZkGiu956htIVpG
	 upxvv6DcVh9qODJXuCwYxxTwueepjq6SOs/t2zQdP4UgTjEgXZZjp5VD1wmFhVikvLKF3
	 HYy3CcDLMirgQPmqk7OFCIVxd/yybtaGLrKRpYX3YQZ2L6fF7VQgqvbgFv2SkFkvqXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YNi0zZhETiMo0CX4dXaoGcln2sXk1Uk5Ln2z1lruIuU=;
	b=zAln1xNQarooggeqDPa3RAtqqAU1JZ0frackVRDTTzePhCWVufvxVx8l59AJWlK0vfJ4
	 3rBk0jRYQ13qYvxHgPWSyKCbLUjF4XWwslir35Df/1kRduv/3E6DtHkakor82mNPL2VGO
	 S90AhoLBJCyCq8TuLIgLU7a3aRxMDJY1KH+mvtBYrdBe2Zg4KWBvkWK1pDsEGD9ZWeMVw
	 HY1ID/lENinABgKrMO/5HTBmjucEQbFMsn2gDJ8PCqxMrkvvtaiisQKeM/xw52LSnTfPz
	 GsIHYqO2nFGnwjKgs5jpy4UAFstKfCKOJSEcR+IflUfzN1YPSqtdivvKoBqB4w6BfyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GO9Y8TG7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E942E606A31A;
	Wed, 28 Oct 2026 19:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GO9Y8TG7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A001F01825;
	Wed, 28 Oct 2026 19:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215436;
	bh=YNi0zZhETiMo0CX4dXaoGcln2sXk1Uk5Ln2z1lruIuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GO9Y8TG7KKdDLm+eeByELope7u/fut/UKZpjF02tYjsvexCVtk+jaQYyZ9t2wYVgS
	 cNgH7Ch/AalCbCZpmR4iFE+US7Tr+Sb7B4mX8AwlfESDlplLURqdQc7L5B2w2Nxazn
	 AgPqjv3x3nGoFwDgadYhT0S4D15pZUubKCk7gAaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1209/1887] ACPI: battery: Pass battery hook pointer to hook callbacks
Date: Wed, 28 Oct 2026 17:55:05 +0100
Message-ID: <20261028170526.920131525@linuxfoundation.org>
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 878a82c23469d6626b27b44ade4d8f9438de51ab ]

Right now, is impossible for battery hook callbacks
to access instance-specific data, forcing most drivers
to provide some sort of global state. This however is
difficult for drivers which can be instantiated multiple
times and/or are hotplug-capable.

Pass a pointer to the battery hook to those callbacks
for usage with container_of().

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20220927204521.601887-2-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 6e9cab2247e5 ("platform/x86: dell-laptop: fix missing cleanups in init error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/battery.c               | 8 ++++----
 drivers/platform/x86/asus-wmi.c      | 4 ++--
 drivers/platform/x86/huawei-wmi.c    | 4 ++--
 drivers/platform/x86/lg-laptop.c     | 4 ++--
 drivers/platform/x86/system76_acpi.c | 4 ++--
 drivers/platform/x86/thinkpad_acpi.c | 4 ++--
 drivers/platform/x86/toshiba_acpi.c  | 4 ++--
 include/acpi/battery.h               | 4 ++--
 8 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 5a4e022662417..9db4189ac2675 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -701,7 +701,7 @@ static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
 	 * de-register all the batteries that are registered.
 	 */
 	list_for_each_entry(battery, &acpi_battery_list, list) {
-		hook->remove_battery(battery->bat);
+		hook->remove_battery(battery->bat, hook);
 	}
 	list_del_init(&hook->list);
 
@@ -736,7 +736,7 @@ void battery_hook_register(struct acpi_battery_hook *hook)
 	 * its attributes.
 	 */
 	list_for_each_entry(battery, &acpi_battery_list, list) {
-		if (hook->add_battery(battery->bat)) {
+		if (hook->add_battery(battery->bat, hook)) {
 			/*
 			 * If a add-battery returns non-zero,
 			 * the registration of the extension has failed,
@@ -774,7 +774,7 @@ static void battery_hook_add_battery(struct acpi_battery *battery)
 	 * during the battery module initialization.
 	 */
 	list_for_each_entry_safe(hook_node, tmp, &battery_hook_list, list) {
-		if (hook_node->add_battery(battery->bat)) {
+		if (hook_node->add_battery(battery->bat, hook_node)) {
 			/*
 			 * The notification of the extensions has failed, to
 			 * prevent further errors we will unload the extension.
@@ -797,7 +797,7 @@ static void battery_hook_remove_battery(struct acpi_battery *battery)
 	 * custom attributes from the battery.
 	 */
 	list_for_each_entry(hook, &battery_hook_list, list) {
-		hook->remove_battery(battery->bat);
+		hook->remove_battery(battery->bat, hook);
 	}
 	/* Then, just remove the battery from the list */
 	list_del(&battery->list);
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index ed6ea8782558c..73bcebab27694 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -900,7 +900,7 @@ static ssize_t charge_control_end_threshold_show(struct device *device,
 
 static DEVICE_ATTR_RW(charge_control_end_threshold);
 
-static int asus_wmi_battery_add(struct power_supply *battery)
+static int asus_wmi_battery_add(struct power_supply *battery, struct acpi_battery_hook *hook)
 {
 	/* The WMI method does not provide a way to specific a battery, so we
 	 * just assume it is the first battery.
@@ -927,7 +927,7 @@ static int asus_wmi_battery_add(struct power_supply *battery)
 	return 0;
 }
 
-static int asus_wmi_battery_remove(struct power_supply *battery)
+static int asus_wmi_battery_remove(struct power_supply *battery, struct acpi_battery_hook *hook)
 {
 	device_remove_file(&battery->dev,
 			   &dev_attr_charge_control_end_threshold);
diff --git a/drivers/platform/x86/huawei-wmi.c b/drivers/platform/x86/huawei-wmi.c
index 201e1f2e2c2f0..3721879bb8472 100644
--- a/drivers/platform/x86/huawei-wmi.c
+++ b/drivers/platform/x86/huawei-wmi.c
@@ -474,7 +474,7 @@ static DEVICE_ATTR_RW(charge_control_start_threshold);
 static DEVICE_ATTR_RW(charge_control_end_threshold);
 static DEVICE_ATTR_RW(charge_control_thresholds);
 
-static int huawei_wmi_battery_add(struct power_supply *battery)
+static int huawei_wmi_battery_add(struct power_supply *battery, struct acpi_battery_hook *hook)
 {
 	int err = 0;
 
@@ -489,7 +489,7 @@ static int huawei_wmi_battery_add(struct power_supply *battery)
 	return err;
 }
 
-static int huawei_wmi_battery_remove(struct power_supply *battery)
+static int huawei_wmi_battery_remove(struct power_supply *battery, struct acpi_battery_hook *hook)
 {
 	device_remove_file(&battery->dev, &dev_attr_charge_control_start_threshold);
 	device_remove_file(&battery->dev, &dev_attr_charge_control_end_threshold);
diff --git a/drivers/platform/x86/lg-laptop.c b/drivers/platform/x86/lg-laptop.c
index 5704981d18487..f6028bc1866c5 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -522,7 +522,7 @@ static DEVICE_ATTR_RW(fn_lock);
 static DEVICE_ATTR_RW(charge_control_end_threshold);
 static DEVICE_ATTR_RW(battery_care_limit);
 
-static int lg_battery_add(struct power_supply *battery)
+static int lg_battery_add(struct power_supply *battery, struct acpi_battery_hook *hook)
 {
 	if (device_create_file(&battery->dev,
 			       &dev_attr_charge_control_end_threshold))
@@ -531,7 +531,7 @@ static int lg_battery_add(struct power_supply *battery)
 	return 0;
 }
 
-static int lg_battery_remove(struct power_supply *battery)
+static int lg_battery_remove(struct power_supply *battery, struct acpi_battery_hook *hook)
 {
 	device_remove_file(&battery->dev,
 			   &dev_attr_charge_control_end_threshold);
diff --git a/drivers/platform/x86/system76_acpi.c b/drivers/platform/x86/system76_acpi.c
index 958df41ad5098..9031bd53253fb 100644
--- a/drivers/platform/x86/system76_acpi.c
+++ b/drivers/platform/x86/system76_acpi.c
@@ -254,7 +254,7 @@ static struct attribute *system76_battery_attrs[] = {
 
 ATTRIBUTE_GROUPS(system76_battery);
 
-static int system76_battery_add(struct power_supply *battery)
+static int system76_battery_add(struct power_supply *battery, struct acpi_battery_hook *hook)
 {
 	// System76 EC only supports 1 battery
 	if (strcmp(battery->desc->name, "BAT0") != 0)
@@ -266,7 +266,7 @@ static int system76_battery_add(struct power_supply *battery)
 	return 0;
 }
 
-static int system76_battery_remove(struct power_supply *battery)
+static int system76_battery_remove(struct power_supply *battery, struct acpi_battery_hook *hook)
 {
 	device_remove_groups(&battery->dev, system76_battery_groups);
 	return 0;
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 3f2098e686f73..d2124f69948ea 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -10102,7 +10102,7 @@ ATTRIBUTE_GROUPS(tpacpi_battery);
 
 /* ACPI battery hooking */
 
-static int tpacpi_battery_add(struct power_supply *battery)
+static int tpacpi_battery_add(struct power_supply *battery, struct acpi_battery_hook *hook)
 {
 	int batteryid = tpacpi_battery_get_id(battery->desc->name);
 
@@ -10113,7 +10113,7 @@ static int tpacpi_battery_add(struct power_supply *battery)
 	return 0;
 }
 
-static int tpacpi_battery_remove(struct power_supply *battery)
+static int tpacpi_battery_remove(struct power_supply *battery, struct acpi_battery_hook *hook)
 {
 	device_remove_groups(&battery->dev, tpacpi_battery_groups);
 	return 0;
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 033e28aaeea63..3541c2048905b 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -3124,7 +3124,7 @@ static struct attribute *toshiba_acpi_battery_attrs[] = {
 
 ATTRIBUTE_GROUPS(toshiba_acpi_battery);
 
-static int toshiba_acpi_battery_add(struct power_supply *battery)
+static int toshiba_acpi_battery_add(struct power_supply *battery, struct acpi_battery_hook *hook)
 {
 	if (toshiba_acpi == NULL) {
 		pr_err("Init order issue\n");
@@ -3137,7 +3137,7 @@ static int toshiba_acpi_battery_add(struct power_supply *battery)
 	return 0;
 }
 
-static int toshiba_acpi_battery_remove(struct power_supply *battery)
+static int toshiba_acpi_battery_remove(struct power_supply *battery, struct acpi_battery_hook *hook)
 {
 	device_remove_groups(&battery->dev, toshiba_acpi_battery_groups);
 	return 0;
diff --git a/include/acpi/battery.h b/include/acpi/battery.h
index b8d56b702c7a8..611a2561a014f 100644
--- a/include/acpi/battery.h
+++ b/include/acpi/battery.h
@@ -12,8 +12,8 @@
 
 struct acpi_battery_hook {
 	const char *name;
-	int (*add_battery)(struct power_supply *battery);
-	int (*remove_battery)(struct power_supply *battery);
+	int (*add_battery)(struct power_supply *battery, struct acpi_battery_hook *hook);
+	int (*remove_battery)(struct power_supply *battery, struct acpi_battery_hook *hook);
 	struct list_head list;
 };
 
-- 
2.53.0



